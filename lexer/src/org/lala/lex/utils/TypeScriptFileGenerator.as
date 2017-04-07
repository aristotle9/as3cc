package org.lala.lex.utils
{
	import com.maccherone.json.JSON;

	public class TypeScriptFileGenerator extends LexerFile
	{
		private var asTransTable:Object;
		private var asFinalTable:Object;
		private var asInputTable:Object;
		private var asInitialTable:Object;
		private var config: Object;
		
		public function TypeScriptFileGenerator(config: Object, transTable:Object, finalTable: Object, inputTable: Object, initialTable: Object)
		{
			super(config.lexer);
			this.config = config;
			this.asTransTable = transTable;
			this.asFinalTable = finalTable;
			this.asInputTable = inputTable;
			this.asInitialTable = initialTable;
		}
		
		private function getActionsString():String
		{
			var result:Array = [];
			function p(str:String):void
			{
				result.push(str);
			};
			p("switch(_findex)\r\n{");
			(this.config.lexer.rules as Array).forEach(function(rule:Object, i:uint, parent:Array):void
			{
				if(String(rule.a).length > 0)
				{
					/** 跳过 epsilon 和 end **/
					p("case 0x" + i.toString(16).toUpperCase() + ":");
					var code: String = String(rule.a).replace(/\$\$/g, "yytext")
					.replace(/(?:(?:this|self)\.)?begin\((['"][^'"]*['"])\)/g, function(...args): String {
						return "this.begin(" + args[1] + ")"
					});
					p("    " + code + ';');
					p("    break;");
				}
			});
			p("}");
			return result.join("\r\n");
		}
		
		private function getTablesString(): String
		{
			var ret:Array = [];
			ret.push('this._transTable = ');
			ret.push(com.maccherone.json.JSON.encode(this.asTransTable));
			ret.push(';this._finalTable = ');
			ret.push(com.maccherone.json.JSON.encode(this.asFinalTable).replace(/"(\d+)"(?=\s*:)/g,'$1'));
			ret.push(';this._inputTable = ');
			ret.push(com.maccherone.json.JSON.encode(this.asInputTable));
			ret.push(';this._initialTable = ');
			ret.push(com.maccherone.json.JSON.encode(this.asInitialTable));
			ret.push(';');
			return ret.join('\r\n');
		}
		
		override public function getRenderObject():Object
		{
			var res: Object = super.getRenderObject();
			res.tables = this.getTablesString();
			res.actions = this.getActionsString();
			return res;
		}
		
		public function get fileName(): String
		{
			return this.className + ".ts";
		}
		
		public function render(): String
		{
			return (new TypeScriptTplRender()).render(this.getRenderObject());
		}
	}
}