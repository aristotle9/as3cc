package org.lala.compilercompile.utils
{
	import org.lala.compilercompile.interfaces.IConfig;
	
	public class RustFileGenerator extends ParserFile
	{
		private var config: IConfig;
		private var _actionTable:String;
		private var _gotoTable:String;
		private var _prodList:String;
		private var _inputTable:String;
		
		private var input_length: uint;
		private var state_length: uint;
		
		private var asActionTable:Object;
		private var asGotoTable:Object;
		private var asProdList:Object;
		private var asInputTable:Object;
		
		public function RustFileGenerator(config: IConfig, actionTable:Object, gotoTable: Object, prodList: Object, inputTable: Object)
		{
			super(config.data.parser);
			
			this.config = config;
			this.asActionTable = actionTable;
			this.asGotoTable = gotoTable;
			this.asProdList = prodList;
			this.asInputTable = inputTable;
		}
		
		public function get prodList():String
		{
			if (this._prodList)
				return this._prodList;
			
			this._prodList = productionItemsString(this.asProdList as Array);
			return this._prodList;
		}
		
		public function get actionTable():String
		{
			if (this._actionTable)
				return this._actionTable;
			
			// 将表格还原
			var state_length: uint = 0;
			var symbol_length: uint = 0;
			var table: Array = [];
			
			for(var k: String in this.asActionTable)
			{
				var input: int = Number(k);
				
				if (table[input] == null)
					table[input] = [];
				
				for(var l: String in this.asActionTable[k])
				{
					var cur_state: int = Number(l);
					var cell_value: int = Number(this.asActionTable[k][l]);
					var state: int = 0;
					
					if (cur_state > state_length)
					{
						state_length = cur_state;
					}
					
					if(cell_value == 1)
					{
						table[input][cur_state] = "Action::Accept";
						continue;
					}
					
					if((cell_value & 1) == 0)
					{
						state = cell_value >>> 1;
						table[input][cur_state] = "Action::Reduce(" + state + ")";
						if (state > state_length)
						{
							state_length = state;
						}
					}
					else
					{
						state = (cell_value >>> 1) - 1;
						table[input][cur_state] = "Action::Shift(" + state + ")";
						if (state > state_length)
						{
							state_length = state;
						}
					}
				}
			}
			
			for(var k: String in this.asGotoTable)
			{
				var input: int = Number(k);
				
				if (table[input] == null)
					table[input] = [];
				
				for(var l: String in this.asGotoTable[k])
				{
					var cur_state: int = Number(l);
					var cell_value: int = Number(this.asGotoTable[k][l]);
					var state: int = (cell_value >>> 1) - 1;
					
					if (cur_state > state_length)
					{
						state_length = cur_state;
					}
	
					if(input > symbol_length)
					{
						symbol_length = input;
					}
					
					if(state > state_length)
					{
						state_length = state;
					}
					
					table[input][cur_state] = "Action::Goto(" + state + ")";
				}
			}
			
			symbol_length += 1;
			state_length += 1;
			
			this.input_length = symbol_length;
			this.state_length = state_length;
			
			for(var i:uint = 0; i < symbol_length; i ++)
			{
				if (table[i] == null)
					table[i] = [];
				
				for(var j:uint = 0; j < state_length; j ++)
				{
					if (table[i][j] == null)
						table[i][j] = "Action::Error";
				}
			}
			
			table = remapInput(table);
			var result: String = table.map(function(row: Array, i: int, parent: Array): String
			{
				return row.join(", ");
			}).join(", \r\n");
			this._actionTable = result;
			return this._actionTable;
		}
		
		private function productionItemsString(a: Array): String
		{
			return a.map(function(nums:Array, ...args):String
			{
				return "ProductionItem{header_id: " + nums[0] + ", body_length: " + nums[1] + "}";
			}).join(", ");
		}
		
		private function remapInput(table: Array): Array
		{
			var _inputMap: Object = {};
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
			
			var tokens: Array = [];
			var tokens_oldIds: Array = [];
			for(var name: String in this.asInputTable)
			{
				if(name != "<$>")
					tokens.push(name);
			}
			tokens.sort();
			tokens.unshift("<$>");
			
			trace(input_names);
			trace(tokens);
			var self: * = this;
			tokens.forEach(function(name: String, i:int, parent:Array):void
			{
				if (input_names[i] != name)
				{
					throw new Error("Tokens sets of lexer is not equal to tokens sets of parser: " + input_names[i] + " <=> " + name);
				}
				tokens_oldIds[i] = Number(self.asInputTable[name]);
			});
			tokens_oldIds.push(0);//epsilon
			trace(tokens_oldIds);
			return tokens_oldIds.map(function(index: int, i: int, parent: Array): Array
			{
				return table[index];
			}).concat(table.slice(tokens_oldIds.length));
		}
		
		private function getActions():String
		{
			var config: Object = this.config.data;
			var result:Array = [];
			function p(str:String):void
			{
				result.push(str);
			};
			var i:uint = 1;//第一个扩展跳过
			for each(var rule:Object in config.parser.rules)
			{
				for each(var rhs:Object in rule.rhs)
				{
					if(rhs.action != null)
					{
						p("0x" + i.toString(16).toUpperCase() + " => {");
						p(String(rhs.action).replace(/\$(\$|\d+)|@(\d+)/g, function(...args):String
						{
							if(args[1] == "$")
							{
								return "_result";
							}
							else if(args[1].length)
							{
								var off:int = 1 + rhs.pattern.length - parseInt(args[1]);
								if(off < 1 || off > rhs.pattern.length)
								{
									throw new Error("动作代码中$n越界:" + rule.head + " -> " + rhs.pattern.join(" ") + ",with $"+args[1]);
								}
								return "(output_stack[output_stack.len() - " + off + "].clone())";
							}
							else
							{
								return "(output_stack[output_stack.len() - " + (parseInt(args[2]) + 1) + "].clone())";
							}
						}));
						p("},");
					}
					i ++;
				}
			}
			p("_ => {},");
			return result.join("\r\n");
		}
		
		override public function getRenderObject():Object
		{
			var res: Object = super.getRenderObject();
			res.tables = this.prodList;
			res.actions = this.getActions();
			res.lookup_table = this.actionTable;
			res.input_length = this.input_length;
			res.state_length = this.state_length;
			return res;
		}
		
		public function render(): String
		{
			return (new RustTplRender()).render(this.getRenderObject());
		}
		
		public function get fileName(): String
		{
			return this.className + '.rs';
		}
	}
}