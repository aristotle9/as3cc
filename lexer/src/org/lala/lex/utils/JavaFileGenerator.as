package org.lala.lex.utils
{
	import com.maccherone.json.JSON;

	public class JavaFileGenerator implements IFileGenerator
	{
		private var _transTable:String;
		private var _finalTable:String;
		private var _inputTable:String;
		private var _initialTable:String;
		
		private var asTransTable:Object;
		private var asFinalTable:Object;
		private var asInputTable:Object;
		private var asInitialTable:Object;
		
		public function JavaFileGenerator(transTable:Object, finalTable: Object, inputTable: Object, initialTable: Object)
		{
			this.asTransTable = transTable;
			this.asFinalTable = finalTable;
			this.asInputTable = inputTable;
			this.asInitialTable = initialTable;
		}
		
		public function get finalTable():String
		{
			if (this._finalTable)
				return this._finalTable;
			
			this._finalTable = mapString(this.asFinalTable, "_finalTable");
			return this._finalTable;
		}
		
		public function get initialTable():String
		{
			if (this._initialTable)
				return this._initialTable;
			
			this._initialTable = mapString(this.asInitialTable, "_initialTable");
			return this._initialTable;
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

			var segs: Array = (this.asTransTable as Array).map(function(item:Array, ...args): String {
				if (item[0]) {
					return "new StateTransItem(true, null, null)";
				} else {
					return "new StateTransItem(false, " + longArrayString(item[1]) + ", " + rangeItemsString(item[2]) + " )"
				}
			});
			
			this._transTable = "new StateTransItem[] {" +
				segs.join(", ") + "}";
			return this._transTable;
		}
		
		private function longArrayString(a: Array): String
		{
			return "new long[] {" + a.map(function(a:Number, ...args): String { return valueString(a);}).join(", ") + "}";
		}
		
		private function rangeItemsString(a: Array): String
		{
			return "new RangeItem[] {" + a.map(function(nums:Array, ...args):String
			{
				return "new RangeItem(" + nums.join("L, ") + "L)";
			}).join(", ") + "}";
		}
		
		private function mapString(obj: Object, name: String): String
		{
			var arr: Array = [];
			for(var k: String in obj) {
				arr.push(name + ".put(" + valueString(k) + ", " + valueString(obj[k]) + ")");
			}
			return "new HashMap<>(" + arr.length + ");" + arr.join("; ");
		}
		
		private function valueString(a: Object): String
		{
			if(a is Number)
			{
				return "0x" + a.toString(16).toUpperCase() + "L";
			}
			else if(a is String)
			{
				if(/^\d+$/.test(a as String))
				{
					return "0x" + Number(a).toString(16).toUpperCase() + "L";
				}
			}
			
			return com.maccherone.json.JSON.encode(a);
		}
		
		public static function getActions(config:Object):String
		{
			var result:Array = [];
			function p(str:String):void
			{
				result.push(str);
			};
			p("switch ((int)_fIndex) {");
			(config.lexer.rules as Array).forEach(function(rule:Object, i:uint, parent:Array):void
			{
				if(String(rule.a).length > 0)
				{
					/** 跳过 epsilon 和 end **/
					p("case 0x" + i.toString(16).toUpperCase() + ":");
					p("    " + String(rule.a).replace(/\$\$/g,"_yytext") + ';');
					if(String(rule.a).indexOf("return") == -1)/** 有 return 就不break了 **/
					{
						p("    break;");
					}
				}
			});
			p("}");
			return result.join("\r\n");
		}
	}
}