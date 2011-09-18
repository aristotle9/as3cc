package org.lala.lex.utils.parser
{
    ;

    public class RegexLexer
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
        
            public function set token(value:String):void
            {
                _tokenName = value;
            }
;

        public function RegexLexer()
        {
            _transTable = 
[[false,[4294967295,3,2,1],[[0,29,0],[30,30,1],[31,31,2],[32,32,3]]],[false,[14,13,12,11,10,9,8,7,6,5,4,4294967295],[[0,0,0],[1,1,1],[2,2,2],[3,3,3],[4,4,4],[5,5,5],[6,25,6],[26,26,7],[27,27,8],[28,28,9],[29,29,10],[30,32,11]]],[false,[14,13,8,15,17,16,4294967295],[[0,0,0],[1,1,1],[2,5,2],[6,6,3],[7,7,4],[8,8,5],[9,29,2],[30,32,6]]],[false,[4294967295,21,20,19,18],[[0,19,0],[20,22,1],[23,23,2],[24,24,3],[25,25,4],[26,32,0]]],[true],[true],[true],[true],[true],[true],[true],[true],[true],[false,[22,30,14,29,28,27,26,25,24,23,4294967295],[[0,8,0],[9,9,1],[10,11,2],[12,12,3],[13,13,4],[14,14,5],[15,15,6],[16,16,7],[17,17,8],[18,19,0],[20,20,9],[21,29,0],[30,32,10]]],[true],[true],[true],[true],[true],[false,[4294967295,19],[[0,23,0],[24,24,1],[25,32,0]]],[true],[false,[4294967295,21],[[0,19,0],[20,22,1],[23,32,0]]],[true],[false,[4294967295,31],[[0,19,0],[20,20,1],[21,21,0],[22,22,1],[23,32,0]]],[false,[4294967295,32],[[0,10,0],[11,11,1],[12,13,0],[14,15,1],[16,18,0],[19,22,1],[23,32,0]]],[false,[4294967295,33],[[0,10,0],[11,11,1],[12,13,0],[14,15,1],[16,18,0],[19,22,1],[23,32,0]]],[true],[true],[true],[true],[true],[false,[4294967295,34],[[0,19,0],[20,20,1],[21,21,0],[22,22,1],[23,32,0]]],[false,[4294967295,35],[[0,10,0],[11,11,1],[12,13,0],[14,15,1],[16,18,0],[19,22,1],[23,32,0]]],[false,[4294967295,36],[[0,10,0],[11,11,1],[12,13,0],[14,15,1],[16,18,0],[19,22,1],[23,32,0]]],[true],[true],[false,[4294967295,37],[[0,10,0],[11,11,1],[12,13,0],[14,15,1],[16,18,0],[19,22,1],[23,32,0]]],[false,[4294967295,38],[[0,10,0],[11,11,1],[12,13,0],[14,15,1],[16,18,0],[19,22,1],[23,32,0]]],[true]]
;_finalTable = 
{4:0,5:4,6:1,7:2,8:25,9:3,10:6,11:5,12:10,13:25,14:18,15:8,16:7,17:9,18:14,19:13,20:11,21:12,22:24,23:24,24:24,25:24,26:22,27:23,28:19,29:21,30:20,34:15,35:16,38:17}
;_inputTable = 
[[0,8,18],[9,9,24],[10,31,18],[32,32,24],[33,39,18],[40,40,28],[41,41,3],[42,42,29],[43,43,27],[44,44,23],[45,45,6],[46,46,0],[47,47,18],[48,48,20],[49,55,22],[56,57,21],[58,62,18],[63,63,26],[64,64,18],[65,70,19],[71,90,18],[91,91,4],[92,92,1],[93,93,7],[94,94,8],[95,96,18],[97,97,19],[98,98,15],[99,99,19],[100,100,11],[101,101,19],[102,102,14],[103,109,18],[110,110,9],[111,113,18],[114,114,13],[115,115,10],[116,116,12],[117,117,16],[118,118,18],[119,119,10],[120,120,17],[121,122,18],[123,123,2],[124,124,5],[125,125,25],[126,65535,18]]
;_initialTable = 
{"INITIAL":3,"BRACKET":2,"REPEAT":1}
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
case 0x0:
    return '*';
    break;
case 0x1:
    return '+';
    break;
case 0x2:
    return '?';
    break;
case 0x3:
    return '|';
    break;
case 0x4:
    return '(';
    break;
case 0x5:
    return ')';
    break;
case 0x6:
    this.begin('BRACKET'); return '[';
    break;
case 0x7:
    return '^';
    break;
case 0x8:
    return '-';
    break;
case 0x9:
    this.begin('INITIAL'); return ']';
    break;
case 0xA:
    this.begin('REPEAT'); return '{';
    break;
case 0xB:
    return ',';
    break;
case 0xC:
    yytext = parseInt(yytext); return 'd';
    break;
case 0xE:
    this.begin('INITIAL'); return '}';
    break;
case 0xF:
    yytext = String.fromCharCode(parseInt(yytext.substr(2, 2), 8)); return 'c';
    break;
case 0x10:
    yytext = String.fromCharCode(parseInt(yytext.substr(2, 2), 16)); return 'c';
    break;
case 0x11:
    yytext = String.fromCharCode(parseInt(yytext.substr(2, 4), 16)); return 'c';
    break;
case 0x12:
    return 'escc';
    break;
case 0x13:
    yytext = '\r'; return 'c';
    break;
case 0x14:
    yytext = '\n'; return 'c';
    break;
case 0x15:
    yytext = '\t'; return 'c';
    break;
case 0x16:
    yytext = '\b'; return 'c';
    break;
case 0x17:
    yytext = '\f'; return 'c';
    break;
case 0x18:
    yytext = yytext.substr(1, 1); return 'c';
    break;
case 0x19:
    return 'c';
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
    }
}