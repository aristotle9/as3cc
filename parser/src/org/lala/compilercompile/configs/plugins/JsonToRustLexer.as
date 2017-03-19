package org.lala.compilercompile.configs.plugins
{
    
    public class JsonToRustLexer
    {
        protected var _transTable:Array;
        protected var _finalTable:Object;
        protected var _inputTable:Array;
        protected var _initialTable:Object;
        protected const DEADSTATE:uint = uint.MAX_VALUE;
        
        protected var _start:uint;
        protected var _oldStart:uint;
        protected var _tokenName:String;
        protected var _yytext:*;
        protected var _yy:Object;
        protected var _ended:Boolean;
        protected var _initialInput:Number;
        protected var _initialState:String;
        
        protected var _line:uint;
        protected var _col:uint;
        protected var _advanced:Boolean;
        
        protected var _source:String;
        
        public function JsonToRustLexer()
        {
            _transTable = 
[[false,[4294967295,1],[[0,16,0],[17,17,1]]],[false,[4294967295,15,14,13,12,11,10,9,8,7,6,5,4,3,2],[[0,1,0],[2,2,1],[3,3,2],[4,4,3],[5,5,4],[6,6,5],[7,7,6],[8,8,7],[9,9,8],[10,10,9],[11,11,10],[12,12,11],[13,13,12],[14,14,13],[15,16,14],[17,17,0]]],[false,[4294967295,2],[[0,14,0],[15,16,1],[17,17,0]]],[false,[4294967295,3],[[0,0,0],[1,1,1],[2,13,0],[14,14,1],[15,17,0]]],[true],[true],[false,[6,16,4294967295],[[0,10,0],[11,11,1],[12,14,0],[15,15,2],[16,16,0],[17,17,2]]],[true],[true],[true],[true],[true],[true],[true],[true],[true],[true]]
;_finalTable = 
{2:0,3:1,4:2,5:4,7:6,8:8,9:3,10:5,11:7,12:10,13:9,14:12,15:11,16:13}
;_inputTable = 
[[0,8,0],[9,9,16],[10,10,15],[11,11,0],[12,12,16],[13,13,15],[14,31,0],[32,32,16],[33,33,0],[34,34,11],[35,35,0],[36,36,14],[37,39,0],[40,40,10],[41,41,6],[42,43,0],[44,44,5],[45,45,0],[46,46,2],[47,47,0],[48,57,1],[58,58,9],[59,59,3],[60,60,0],[61,61,4],[62,64,0],[65,90,14],[91,91,12],[92,92,0],[93,93,7],[94,94,0],[95,95,14],[96,96,0],[97,122,14],[123,123,13],[124,124,0],[125,125,8],[126,65535,0]]
;_initialTable = 
{"INITIAL":1}
;
        }
        
        public function yyrestart(src:String=null):void
        {
            if(src != null)
            {
                _source = src;
            }
            _ended = false;
            _start = 0;
            _oldStart = 0;
            _line = 1;
            _col = 0;
            _advanced = true;
            _tokenName = null;
            _yy = {};
            initialState = "INITIAL";
            ;

        }
        
        public function set source(src:String):void
        {
            _source = src;
            yyrestart();
        }
        
        public function get token():String
        {
            if(_advanced)
            {
                _tokenName = next();
                _advanced = false;
            }
            return _tokenName;
        }
        
        public function advance():void
        {
            _advanced = true;
        }
        
        public function get startIdx():uint
        {
            return _oldStart;
        }
        
        public function get endIdx():uint
        {
            return _start;
        }
        
        public function get position():Array
        {
            return [_line,_col];
        }
        
        public function get positionInfo():String
        {
            return token + '@row:' + position.join('col:');   
        }
        
        public function get yytext():*
        {
            return _yytext;
        }
        
        public function get yyleng():uint
        {
            return endIdx - startIdx;
        }
        
        public function set yytext(value:*):void
        {
            _yytext = value;
        }
        
        public function get yy():Object
        {
            return _yy;
        }

        public function get tokenName():String
        {
            return _tokenName;
        }
        
        protected function next():String
        {
            var _findex:*;
            var _nextState:*;
            var _char:Number;
            var _begin:uint;
            var _next:uint;
            var _ochar:uint;
            var _curState:uint;
            var _lastFinalState:uint;
            var _lastFinalPosition:uint;
            
            while(true)
            {
                _findex = null;
                _nextState = null;
                _char = 0;
                _begin = _start;
                _next = _start;
                _ochar = uint.MAX_VALUE;
                _lastFinalState = DEADSTATE;
                _lastFinalPosition = _start;
                _curState = _transTable[0][1][_initialInput];
                while(true)
                {
                    _char = _source.charCodeAt(_next);
                    /** 计算行,列位置 **/
                    if(_ochar != uint.MAX_VALUE)
                    {
                        if(_char == 0x0d)//\r
                        {
                            _col = 0;
                            _line ++;
                        }
                        else if(_char == 0x0a)//\n
                        {
                            if(_ochar != 0x0d)// != \r
                            {
                                _col = 0;
                                _line ++;
                            }
                        }
                        else
                        {
                            _col ++;
                        }
                    }
                    _ochar = _char;
                    /** 计算行,列位置--结束 **/
                    _nextState = trans(_curState, _char);
                    if(_nextState == DEADSTATE)
                    {
                        if(_begin == _lastFinalPosition)
                        {
                            if(_start == _source.length)
                            {
                                if(_ended == false)
                                {
                                    _ended = true;
                                    return "<$>";
                                }
                                else
                                {
                                    throw new Error("已经到达末尾.");
                                }                    
                            }
                            throw new Error("意外的字符,line:" + position.join(",col:") + 'of ' + _source.substr(_begin,20));
                        }
                        else
                        {
                            _findex = _finalTable[_lastFinalState];
                            _start = _lastFinalPosition;
                            _oldStart = _begin;
                            _yytext = _source.substring(startIdx, endIdx);
                            switch(_findex)
{
case 0x1:
    return "id";
    break;
case 0x2:
    return "{";
    break;
case 0x3:
    return "}";
    break;
case 0x4:
    return "[";
    break;
case 0x5:
    return "]";
    break;
case 0x6:
    return "(";
    break;
case 0x7:
    return ")";
    break;
case 0x8:
    return ":";
    break;
case 0x9:
    return "=";
    break;
case 0xA:
    return ",";
    break;
case 0xB:
    return ".";
    break;
case 0xC:
    return ";";
    break;
case 0xD:
    return "string";
    break;
}
                            break;
                        }
                    }
                    else
                    {
                        _findex = _finalTable[_nextState];
                        if(_findex != null)
                        {
                            _lastFinalState = _nextState;
                            _lastFinalPosition = _next + 1;
                        }
                        _next += 1;
                        _curState = _nextState;
                    }
                }
            }
            return "";//这里的值会影响返回值!!
        }
        protected function trans(curState:uint,char:Number):uint
        {
            if(isNaN(char))
                return DEADSTATE;
            if(char < _inputTable[0][0] || char > _inputTable[_inputTable.length - 1][1])
                throw new Error("输入超出有效范围,line:" + position.join(",col:"));
            if(_transTable[curState][0] == true)
                return DEADSTATE;

            var ipt:int = find(char,_inputTable);
            var ipt2:int = find(ipt, _transTable[curState][2]);
            return _transTable[curState][1][ipt2];
        }
        
        protected function find(code:uint,seg:Array):uint
        {
            var min:uint;
            var max:uint;
            var mid:uint;
            min = 0;
            max = seg.length - 1;
            while(true)
            {
                mid = (min + max) >>> 1;
                if(seg[mid][0] <= code && seg[mid][1] >= code)
                {
                    return seg[mid][2];
                }
                else if(seg[mid][0] > code)
                {
                    max = mid - 1;
                }
                else
                {
                    min = mid + 1;
                }
            }
            return 0;
        }
        
        protected function begin(state:String=null):void
        {
            if(state == null)
            {
                initialState = "INITIAL";
                return;
            }
            initialState = state;
        }
        
        protected function get initialState():String
        {
            return _initialState;
        }

        protected function set initialState(value:String):void
        {
            if(_initialTable[value] === undefined)
            {
                throw new Error("未定义的起始状态:" + value);
            }
            _initialState = value;
            _initialInput = _initialTable[value];
        }

		public static function lex_seq(source:String):Array
		{
			var lexer:JsonToRustLexer = new JsonToRustLexer();
			lexer.source = source;
			var tokens:Array = [];
			var token:String = lexer.token;
			while(token != '<$>')
			{
				tokens.push({token: token, text: lexer.yytext, start: lexer.startIdx, end: lexer.endIdx});
				lexer.advance();
				token = lexer.token;
			}
			return tokens;
		}
    }
}
