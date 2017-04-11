package org.lala.compilercompile.utils
{
	import com.maccherone.json.JSON;
	
	import org.lala.compilercompile.interfaces.IConfig;
	
	public class TypeScriptFileGenerator extends ParserFile
	{
		private var config: IConfig;
		
		private var asActionTable:Object;
		private var asGotoTable:Object;
		private var asProdList:Object;
		private var asInputTable:Object;
		
		public function TypeScriptFileGenerator(config: IConfig, actionTable:Object, gotoTable: Object, prodList: Object, inputTable: Object)
		{
			super(config.data.parser);
			
			this.config = config;
			this.asActionTable = actionTable;
			this.asGotoTable = gotoTable;
			this.asProdList = prodList;
			this.asInputTable = inputTable;
			
		}
		
		private function getTables():String
		{
			var ret:Array = [];
			ret.push('this._actionTable = ');
			ret.push(JSON.encode(asActionTable).replace(/"(\d+)"(?=\s*:)/g,'$1'));
			ret.push(';this._gotoTable = ');
			ret.push(JSON.encode(asGotoTable).replace(/"(\d+)"(?=\s*:)/g,'$1'));
			ret.push(';this._prodList = ');
			ret.push(JSON.encode(asProdList));
			ret.push(';this._inputTable = ');
			//使table的值从0开始
			var symbolTable:Array = [];
			var str:String = JSON.encode(asInputTable);
			str.replace(/("(?:[^"\\]|\\.)*")\s*:\s*(\d+)/g, function(...args):String
			{
				symbolTable[parseInt(args[2])] = args[0];
				return '';
			});
			symbolTable = symbolTable.filter(function(it:*, ...args):Boolean
			{
				if(it == null)
					return false;
				return true;
			});
			ret.push('{' + symbolTable.join(',') + '}');
			ret.push(';');
			return ret.join('\r\n');
		}
				
		private function getActions():String
		{
			var result:Array = [];
			function p(str:String):void
			{
				result.push(str);
			};
			p("switch(_pi)\r\n{");
			var i:uint = 1;//第一个扩展跳过
			for each(var rule:Object in config.data.parser.rules)
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
								return "_outputStack[_outputStack.length - " + off + "]";
							}
							else
							{
								return "_outputStack[_outputStack.length - " + (parseInt(args[2]) + 1) + ']';
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
		
		override public function getRenderObject():Object
		{
			var res: Object = super.getRenderObject();
			res.tables = this.getTables();
			res.actions = this.getActions();
			return res;
		}
		
		public function render(): String
		{
			return (new TypeScriptTplRender()).render(this.getRenderObject());
		}
		
		public function get fileName(): String
		{
			return this.className + '.ts';
		}
	}
}