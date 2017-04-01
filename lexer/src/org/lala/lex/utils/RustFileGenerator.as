package org.lala.lex.utils
{
	import com.maccherone.json.JSON;

	public class RustFileGenerator extends LexerFile
	{
		private var _transTable:String;
		private var _inputTable:String;
		private var _initialLookup: String;
		private var _inputLookup: String;
		private var _inputMap: Object;
		private var _endTokenIndex: uint;
		
		private var asTransTable:Object;
		private var asFinalTable:Object;
		private var asInputTable:Object;
		private var asInitialTable:Object;
		private var config: Object;
		
		public function RustFileGenerator(config: Object, transTable:Object, finalTable: Object, inputTable: Object, initialTable: Object)
		{
			super(config.lexer);
			this.config = config;
			this.asTransTable = transTable;
			this.asFinalTable = finalTable;
			this.asInputTable = inputTable;
			this.asInitialTable = initialTable;
			
			this.createInitialLookup();
			this.createTableString();
			this.actions = this.getActions();
		}
		
		public function createInitialLookup():void
		{
			this._initialLookup = lookupObjectString(this.asInitialTable, "initial_input", "undefined initial input");
		}
		
		public function get inputTable():String
		{
			if (this._inputTable)
				return this._inputTable;
			
			this._inputTable = rangeItemsString(this.asInputTable as Array);
			return this._inputTable;
		}
		
		public function get transTable():String
		{
			if (this._transTable)
				return this._transTable;

			var segs: Array = (this.asTransTable as Array).map(function(item:Array, state_id: uint, parent: Array): String {
				var final_index: uint = asFinalTable.hasOwnProperty(String(state_id)) ? asFinalTable[String(state_id)] : 0xffffffff;				
				if (item[0]) {
					return "StateTransItem{is_dead:true, final_index:" + final_index + ", to_states:vec![], trans_edge:vec![]}";
				} else {
					return "StateTransItem{is_dead:false, final_index:" + final_index + ", to_states:" + longArrayString(item[1]) + ", trans_edge:" + rangeItemsString(item[2]) + "}"
				}
			});
			
			this._transTable = "vec![" +
				segs.join(", ") + "]";
			return this._transTable;
		}
		
		private function longArrayString(a: Array): String
		{
			return "vec![" + a.join(", ") + "]";
		}
		
		private function rangeItemsString(a: Array): String
		{
			return "vec![" + a.map(function(nums:Array, ...args):String
			{
				return "RangeItem{from:" + nums[0] + ", to:" + nums[1] + ", value:" + nums[2] + "}";
			}).join(", ") + "]";
		}
		
		private function lookupObjectString(obj: Object, name: String, default_return: Object): String
		{
			var arr: Array = [];
			var result: Array = [];
			function put(x:Object):void
			{
				result.push(x);
			}
			for(var k: String in obj) {
				
				arr.push([k, obj[k]]);
			}
			arr.sort(function(a: Array, b: Array): int
			{
				return a[1] - b[1];
			});
			result = arr.map(function(a: Array, ...args):String
			{
				return a[1] + " => " + com.maccherone.json.JSON.encode(a[0]) + ",";
			});
			result.push("_ => " + com.maccherone.json.JSON.encode(default_return) + ",");
			return "return match " + name + " {\r\n" + result.join("\r\n") + "\r\n};";
		}

		public function getActions():String
		{
			var result:Array = [];
			function p(str:String):void
			{
				result.push(str);
			};
			
			this._inputMap = {};
			var input_names: Array = [];
			(config.lexer.rules as Array).forEach(function(rule:Object, i:uint, parent:Array):void
			{
				var rule_str: String = String(rule.a);
				if(rule_str.length > 0)
				{
					var re: RegExp = new RegExp("return\\s+\"([^\"]+)\"", "g");
					var a: Array = re.exec(rule_str);
					while(a != null)
					{
						if(!_inputMap.hasOwnProperty(a[1]))
						{
							_inputMap[a[1]] = true;
							input_names.push(a[1]);
						}
						a = re.exec(rule_str);
					}
				}
			});
			input_names.sort();
			input_names.unshift("<$>");
			input_names.forEach(function(k: String, i: uint, ...args):void
			{
				_inputMap[k] = i;
				if("<$>" == k)
					_endTokenIndex = i;
			});
			this._inputLookup = lookupObjectString(_inputMap, "token_index", "<undefined_token>");
			
			p("match _findex {");
			(config.lexer.rules as Array).forEach(function(rule:Object, i:uint, parent:Array):void
			{
				if(String(rule.a).length > 0)
				{
					/** 跳过 epsilon 和 end **/
					p("0x" + i.toString(16).toUpperCase() + " => {");
					var code: String = String(rule.a);
					code = code.replace(/\$\$/g, function(...args):String
					{
						return "self._yytext"
					}).replace(new RegExp("return\\s+\"([^\"]+)\"", "g"), function(...args):String
					{
						return "return Ok(" + _inputMap[args[1]] + ") /* " + args[1] + " */ ";
					}).replace(new RegExp("(?:self\.)?begin\\s*\\(\\s*\"([^\"]+)\"\\s*\\)", "g"), function(...args):String
					{
						return "self.begin(" + asInitialTable[args[1]] + ") /* " + args[1] + " */ ";
					});

					p("    " + code + ';');
					p("},");
				}
			});
			p("_ => {},");
			p("}");
			return result.join("\r\n");
		}
		
		public function createTableString(): void
		{
			var ret:Array = [];
			ret.push(';let _trans_table = ');
			ret.push(this.transTable);
			ret.push(';let _input_table = ');
			ret.push(this.inputTable);
			ret.push(';');
			this.tables = ret.join('\r\n');
		}
		
		override public function getRenderObject():Object
		{
			var res: Object = super.getRenderObject();
			res.initial_name_lookup = _initialLookup;
			res.token_name_lookup = _inputLookup;
			res.end_token_index = _endTokenIndex;
			res.initial_input_index = asInitialTable["INITIAL"];
			return res;
		}
		
		public function get fileName(): String
		{
			return CamelCaseTo_snake_case(this.className) + ".rs";
		}
		
		public function render(): String
		{
			return (new RustTplRender()).render(this.getRenderObject());
		}
		
		private static function CamelCaseTo_snake_case(name: String): String
		{
			return name.replace(/[A-Z]/g, function(char: String, index: int, str: String): String {
				if(index != 0)
				{
					return '_' + char.toLowerCase();
				}
				else 
				{
					return char.toLowerCase();
				}
			});
		}
	}
}