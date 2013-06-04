package org.lala.lex.utils
{
    public class TplRender
    {
        public function TplRender()
        {
        }
        
        public function render(data:Object):String
        {
            var str:String = String(Src);
            return str.replace(/<{\s*(\w+)\s*\}>/g,function(...args):String
            {
                if(data[args[1]] != null)
                {
                    return String(data[args[1]]);
                }
                return '';
            });
        }
		
		private static const Src:String = String(<r><![CDATA[package <{ package }>
{
    <{ imports }>
    public class <{ class }>
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
        <{ usercode }>
        public function <{ class }>()
        {
            <{ tables }>
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
            <{ initial }>
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
                            <{ actions }>
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
]]></r>);
    }
}