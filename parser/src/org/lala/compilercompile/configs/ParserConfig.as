package org.lala.compilercompile.configs
{
    import org.lala.compilercompile.configs.parser.ParserLexer;
    import org.lala.compilercompile.configs.parser.ParserParser;
    import org.lala.compilercompile.interfaces.IConfig;
    
    public class ParserConfig implements IConfig
    {
        private var _data:Object;
        public function ParserConfig(source:String)
        {
            var lex:ParserLexer = new ParserLexer;
            var parser:ParserParser = new ParserParser;
            lex.source = source;
            var res:Object = parser.parse(lex);
            this._data = {parser:res.decs};
            this._data.parser.rules = res.rules;
        }
        
        public function get data():Object
        {
            return _data;
        }
    }
}