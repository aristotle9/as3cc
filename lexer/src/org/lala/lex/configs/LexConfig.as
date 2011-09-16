package org.lala.lex.configs
{
    import org.lala.lex.configs.parser.LexLexer;
    import org.lala.lex.configs.parser.LexParser;
    import org.lala.lex.interfaces.IConfig;
    
    public class LexConfig implements IConfig
    {
        private var _data:Object;
        public function LexConfig(source:String)
        {
            var lex:LexLexer = new LexLexer;
            var parser:LexParser = new LexParser;
            lex.source = source;
            this._data = {lexer: parser.parse(lex).decs.lex[0]}; 
        }
        
        public function get data():Object
        {
            return _data;
        }
    }
}