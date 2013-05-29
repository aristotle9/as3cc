package org.lala.lex.utils.parser
{
    public class RegexParser
    {
        protected var _actionTable:Array;
        protected var _gotoTable:Object;
        protected var _prodList:Array;
        protected var _inputTable:Object;
        
        private var lexer:RegexLexer;
        
        public function RegexParser()
        {
            include "parserData.txt";
            lexer = new RegexLexer;
        }
        
        public function parse(src:String):*
        {
            var _stateStack:Array = [0];
            var _outputStack:Array = [];
            var _state:uint;
            var _token:*;
            var _act:uint;
            
            lexer.source = src;
            var errorInfo:Array = [];
            var code:Array = [];
            function put(...args):void
            {
                code.push(args);
            };
            
            while(true)
            {
                _token = lexer.token;
                _state = _stateStack[_stateStack.length - 1];
                if(_actionTable[_inputTable[_token]][_state] == null)
                {
                    /** 人工解决错误 **/
                    if(_token == '<$>' || _token == 'escc' || 
                        _token == 'd' || _token == ',' || _token == '}')
                    {
                        throw new Error("Parse Error:" + lexer.positionInfo);
                    }
                    else
                    {
                        /** 不止一次要用到 **/
                        lexer.token = _token = 'c';
                        errorInfo.push([lexer.yytext, lexer.position]);
                    }
                }
                
                _act = _actionTable[_inputTable[_token]][_state];
                if(_act == 1)
                {
                    return {code:code, error:errorInfo};//acc
                }
                else if((_act & 1) == 1)//shift
                {
                    _outputStack.push(lexer.yytext);
                    _stateStack.push((_act >>> 1) - 1);
                    lexer.advance();
                }
                else if((_act & 1) == 0)//reduce
                {
                    var _pi:uint = _act >>> 1;
                    var _length:uint = _prodList[_pi][1];
                    var _result:* = null;
                    /** actions applying **/
                    /** default action **/
                    if(_length > 0)
                        _result = _outputStack[_outputStack.length - _length];
                    include "parserActions.txt";
                    /** actions applying end **/
                    var _i:uint = 0;
                    while(_i < _length)
                    {
                        _stateStack.pop();
                        _outputStack.pop();
                        _i ++;
                    }
                    _state = _stateStack[_stateStack.length - 1];
                    if(_gotoTable[_prodList[_pi][0]][_state] == null)
                    {
                        throw new Error("Goto Error!" + lexer.positionInfo);
                    }
                    else
                    {
                        _act = _gotoTable[_prodList[_pi][0]][_state];
                    }
                    _stateStack.push((_act >>> 1) - 1);
                    _outputStack.push(_result);
                }
            }
        }
    }
}