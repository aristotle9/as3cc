package org.lala.compilercompile.utils
{
	import com.maccherone.json.JSON;
	
	public class JavaFileGenerator implements IFileGenerator
	{
		private var _actionTable:String;
		private var _gotoTable:String;
		private var _prodList:String;
		private var _inputTable:String;
		
		private var asActionTable:Object;
		private var asGotoTable:Object;
		private var asProdList:Object;
		private var asInputTable:Object;
		
		public function JavaFileGenerator(actionTable:Object, gotoTable: Object, prodList: Object, inputTable: Object)
		{
			this.asActionTable = actionTable;
			this.asGotoTable = gotoTable;
			this.asProdList = prodList;
			this.asInputTable = inputTable;
		}
		
		public function get gotoTable():String
		{
			if (this._gotoTable)
				return this._gotoTable;
			
			var result: Array = [];
			function p(line: String): void
			{
				result.push(line);
			}
			var i:uint = 0;
			for(var k:String in this.asGotoTable)
			{
				p("_tmp = " + mapString(this.asGotoTable[k], "_tmp") + ";");
				p("_gotoTable.put(" + valueString(k) + ", _tmp);");
				i ++;
			}
			result.unshift("new HashMap<>(" + valueString(i) + ");");
			this._gotoTable = result.join("");
			return this._gotoTable;
		}
		
		public function get inputTable():String
		{
			if (this._inputTable)
				return this._inputTable;
			
			this._inputTable = mapString(this.asInputTable, "_inputTable");
			return this._inputTable;
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
			
			var result: Array = [];
			function p(line: String): void
			{
				result.push(line);
			}
			p("new ArrayList<Map<Integer, Integer>>(" + (this.asActionTable as Array).length + ");");
			(this.asActionTable as Array).forEach(function(table: Object, index: int, parent: Array): void {
				if (table == null) {
					p("_actionTable.add(null);");
				} else {
					p("_tmp = " + mapString(table, "_tmp") + ";");
					p("_actionTable.add(_tmp);");
				}
			});
			this._actionTable = result.join("");
			return this._actionTable;
		}
		
		private function productionItemsString(a: Array): String
		{
			return "new ProductionItem[] {" + a.map(function(nums:Array, ...args):String
			{
				return "new ProductionItem(" + valueString(nums[0]) + ", " + valueString(nums[1]) + ")";
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
				return "0x" + a.toString(16).toUpperCase();
			}
			else if(a is String)
			{
				if(/^\d+$/.test(a as String))
				{
					return "0x" + Number(a).toString(16).toUpperCase();
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
			p("switch(_pi)\r\n{");
			var i:uint = 1;//第一个扩展跳过
			for each(var rule:Object in config.parser.rules)
			{
				for each(var rhs:Object in rule.rhs)
				{
					if(rhs.action != null)
					{
						p("case 0x" + i.toString(16).toUpperCase() + ":");
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
								return "(_outputStack.get(_outputStack.size() - " + off + "))";
							}
							else
							{
								return "(_outputStack.get(_outputStack.size() - " + (parseInt(args[2]) + 1) + '))';
							}
						}));
						p("break;");
					}
					i ++;
				}
			}
			p("}");
			return result.join("\r\n");
		}
		
		public static function getTables(actionTable:Object, gotoTable: Object, prodList: Object, inputTable: Object): String
		{
			var fileGen: JavaFileGenerator = new JavaFileGenerator(actionTable, gotoTable, prodList, inputTable);
			var ret:Array = [];
			ret.push('Map<Integer, Integer> _tmp;');
			ret.push('_actionTable = ');
			ret.push(fileGen.actionTable);
			ret.push(';_gotoTable = ');
			ret.push(fileGen.gotoTable);
			ret.push(';_prodList = ');
			ret.push(fileGen.prodList);
			ret.push(';_inputTable = ');
			ret.push(fileGen.inputTable);
			ret.push(';');
			return ret.join('\r\n');
		}
	}
}