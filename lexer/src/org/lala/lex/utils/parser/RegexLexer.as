package org.lala.lex.utils.parser
{
    import flash.utils.ByteArray;
    
    public class RegexLexer
    {
        [Embed(source="lexerData.dat", mimeType="application/octet-stream")]
        protected var DataArrays:Class;
        public var finalIndices:Array;
        public var stateTrans:Array;
        public var inputTrans:Array;
        public var statesInputTable:Object;
        
        protected var __start:uint;
        protected var __oldStart:uint;
        protected var __tokenName:String;
        protected var __yytext:*;
        protected var __yy:Object;
        protected var __ended:Boolean;
        protected var __initialInput:Number;
        protected var __initialState:String;
        
        protected var __line:uint;
        protected var __col:uint;
        protected var __advanced:Boolean;
        
        protected var __source:String;
        
        public function RegexLexer()
        {
            var __ba:ByteArray = new DataArrays() as ByteArray;
            __ba.inflate();
            stateTrans = __ba.readObject() as Array;
            finalIndices = __ba.readObject() as Array;
            inputTrans = __ba.readObject() as Array;
            statesInputTable = __ba.readObject() as Object;
        }
        
        public function yyrestart(src:String=null):void
        {
            if(src != null)
            {
                __source = src;
            }
            __ended = false;
            __start = 0;
            __oldStart = 0;
            __line = 1;
            __col = 0;
            __advanced = true;
            __tokenName = null;
            __yy = {};
            initialState = "INITIAL";
        }
        
        public function set source(src:String):void
        {
            __source = src;
            yyrestart();
        }
        
        public function get token():String
        {
            if(__advanced)
            {
                __tokenName = next();
                __advanced = false;
            }
            return __tokenName;
        }
        
        public function set token(value:String):void
        {
            __tokenName = value;
        }
        
        public function advance():void
        {
            __advanced = true;
        }
        
        public function get startIdx():uint
        {
            return __oldStart;
        }
        
        public function get endIdx():uint
        {
            return __start;
        }
        
        public function get position():Array
        {
            return [__line,__col];
        }
        
        public function get positionInfo():String
        {
            return token + '@row:' + position.join('col:');   
        }
        
        public function get yytext():*
        {
            return __yytext;
        }
        
        public function get yyleng():uint
        {
            return endIdx - startIdx;
        }
        
        public function set yytext(value:*):void
        {
            __yytext = value;
        }
        
        public function get yy():Object
        {
            return __yy;
        }

        public function get tokenName():String
        {
            return __tokenName;
        }
        
        protected function next():String
        {
            var __findex:*;
            var __nextState:*;
            var __char:Number;
            var __begin:uint;
            var __next:uint;
            var __ochar:uint;
            var __curState:uint;
            
            while(true)
            {
                __findex = null;
                __nextState = null;
                __char = 0;
                __begin = __start;
                __next = __start;
                __ochar = uint.MAX_VALUE;
                __curState = stateTrans[0][__initialInput];
                while(true)
                {
                    __char = __source.charCodeAt(__next);
                    /** 计算行,列位置 **/
                    if(__ochar != uint.MAX_VALUE)
                    {
                        if(__char == 0x0d)//\r
                        {
                            __col = 0;
                            __line ++;
                        }
                        else if(__char == 0x0a)//\n
                        {
                            if(__ochar != 0x0d)// != \r
                            {
                                __col = 0;
                                __line ++;
                            }
                        }
                        else
                        {
                            __col ++;
                        }
                    }
                    __ochar = __char;
                    /** 计算行,列位置--结束 **/
                    __nextState = trans(__curState, __char);
                    if(__nextState == null)
                    {
                        if(__begin == __next)
                        {
                            if(__start == __source.length)
                            {
                                if(__ended == false)
                                {
                                    __ended = true;
                                    return "<$>";
                                }
                                else
                                {
                                    throw new Error("已经到达末尾.");
                                }                    
                            }
                            throw new Error("意外的字符,line:" + position.join(",col:"));
                        }
                        else
                        {
                            __findex = finalIndices[__curState];
                            if(__findex == null)
                            {
                                throw new Error("出错,line:" + position.join(",col:"));
                            }
                            __start = __next;
                            __oldStart = __begin;
                            __yytext = __source.substring(startIdx, endIdx);
                            include "lexerActions.txt";
                            break;
                        }
                    }
                    else
                    {
                        __next += 1;
                        __curState = __nextState;
                    }
                }
            }
            return "";//这里的值会影响返回值!!
        }
        protected function trans(curState:uint,char:Number):*
        {
            if(isNaN(char))
                return null;
            return stateTrans[curState][find(char)];
        }
        protected function find(code:uint):uint
        {
            if(code < inputTrans[0][0] || code > inputTrans[inputTrans.length - 1][1])
            {
                throw new Error("输入超出有效范围,line:" + position.join(",col:"));
            }
            var min:uint;
            var max:uint;
            var mid:uint;
            min = 0;
            max = inputTrans.length - 1;
            while(true)
            {
                mid = (min + max) >>> 1;
                if(inputTrans[mid][0] <= code && inputTrans[mid][1] >= code)
                {
                    return inputTrans[mid][2];
                }
                else if(inputTrans[mid][0] > code)
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
            return __initialState;
        }

        protected function set initialState(value:String):void
        {
            if(statesInputTable[value] === undefined)
            {
                throw new Error("未定义的起始状态:" + value);
            }
            __initialState = value;
            __initialInput = statesInputTable[value];
        }


    }
}