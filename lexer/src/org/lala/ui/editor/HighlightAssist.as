package org.lala.ui.editor
{
    internal final class HighlightAssist
    {
        private static var _instance:HighlightAssist;
        
        private var _lexer:Lexer;
        public function HighlightAssist()
        {
            _lexer = new Lexer;
        }
        public function lexInfo(src:String):Array
        {
            var res:Array = new Array;
            _lexer.source = src;
            try{
                var tk:* = _lexer.token;
                while(tk != '<$>')
                {
                    res.push([tk, _lexer.startIdx, _lexer.endIdx]);
                    _lexer.advance();
                    tk = _lexer.token;
                }
            }
            catch(e:Error){}
            return res;
        }
        public static function getInstance():HighlightAssist
        {
            if(_instance == null)
            {
                _instance = new HighlightAssist;
            }
            return _instance;
        }
    }
}