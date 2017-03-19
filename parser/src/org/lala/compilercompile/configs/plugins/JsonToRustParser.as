package org.lala.compilercompile.configs.plugins
{
    

    public class JsonToRustParser
    {
        protected var _actionTable:Array;
        protected var _gotoTable:Object;
        protected var _prodList:Array;
        protected var _inputTable:Object;
        
        public function JsonToRustParser()
        {
            _actionTable = 
[null,{0:4,1:1,31:6,39:8,7:2},{0:4,1:7,3:27,36:27,5:31,6:27,7:2,11:27,39:8,21:63,24:27,25:27,27:31,28:27,31:6},{2:25},{26:20,4:18,22:65,23:10,9:12,10:14,12:16,29:32,38:81},{2:16,4:18,23:10,8:45,9:12,10:14,26:20,29:32},{0:4,1:9,3:9,36:9,6:9,7:2,11:9,39:8,24:9,25:9,28:9,30:75,31:6},{35:34,4:18,37:79,9:12,10:14,12:16,13:49,18:40,20:36,36:38,23:10,26:20,29:32},{0:4,1:11,3:11,36:11,5:33,6:11,7:2,11:11,39:8,24:11,25:11,27:33,28:11,31:6},{0:4,1:13,39:8,3:13,36:13,6:13,7:2,24:13,25:13,11:13,28:13,31:6},{32:28,33:30,34:22,4:18,5:26,9:12,10:14,12:16,16:55,17:24,23:10,26:20,29:32},{32:28,33:30,34:22,35:34,4:18,5:26,6:38,9:12,10:14,12:16,37:59,16:57,17:24,18:40,19:59,20:36,36:38,23:10,26:20,29:32},{14:51,15:53},{0:4,1:15,39:8,3:15,36:15,6:15,7:2,24:15,25:15,11:15,28:15,31:6},{18:40,19:61,4:18,20:36,6:38,23:10,9:12,10:14,26:20,12:16,29:32,35:34}]
;_gotoTable = 
{16:{1:17},17:{1:19,3:29,36:39,6:39,24:67,25:69,11:47,28:39},18:{36:77,6:41},19:{1:21,3:21,36:21,6:21,24:21,25:21,11:21,28:21},20:{1:23,3:23,36:23,6:23,24:23,25:23,11:23,28:23},21:{5:35},22:{5:37,27:71},23:{28:73,36:43,6:43},15:{0:5}}
;_prodList = 
[[24,2],[15,2],[15,0],[16,4],[16,7],[17,3],[17,1],[17,1],[17,1],[17,1],[19,3],[21,3],[21,1],[21,0],[22,3],[22,3],[20,3],[18,3],[18,1],[18,0],[23,1]]
;_inputTable = 
{"<$>":1,"id":2,"=":3,";":4,".":5,"(":6,")":7,"string":8,"{":9,"}":10,",":11,":":12,"[":13,"]":14}
;
        }
        
        public function parse(lexer:JsonToRustLexer):*
        {
            var _stateStack:Array = [0];
            var _outputStack:Array = [];
            var _state:uint;
            var _token:*;
            var _act:uint;
            
            while(true)
            {
                _token = lexer.token;
                _state = _stateStack[_stateStack.length - 1];
                if(_actionTable[_inputTable[_token]][_state] == null)
                {
                    throw new Error("Parse Error:" + lexer.positionInfo);
                }
                else
                {
                    _act = _actionTable[_inputTable[_token]][_state];
                }
                if(_act == 1)
                {
                    return _outputStack.pop();//acc
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
                    switch(_pi)
{
case 0x1:
 _outputStack[_outputStack.length - 2].args.push(_outputStack[_outputStack.length - 1]); _result = _outputStack[_outputStack.length - 2]; 
break;
case 0x2:
 _result = { type: "sts", args: [] }; 
break;
case 0x3:
 _result = { type: "=", args: [_outputStack[_outputStack.length - 4], _outputStack[_outputStack.length - 2]] }; 
break;
case 0x4:
 _result = { type: ".()", args: [_outputStack[_outputStack.length - 7], _outputStack[_outputStack.length - 5], _outputStack[_outputStack.length - 3]] }; 
break;
case 0x5:
 _result = { type: "()", args: [_outputStack[_outputStack.length - 2]] }; 
break;
case 0x6:
 _result = { type: "object", args: [_outputStack[_outputStack.length - 1]] }; 
break;
case 0x7:
 _result = { type: "array", args: [_outputStack[_outputStack.length - 1]] }; 
break;
case 0x8:
 _result = { type: "id", args: [_outputStack[_outputStack.length - 1]] }; 
break;
case 0x9:
 _result = { type: "string", args: [_outputStack[_outputStack.length - 1]] }; 
break;
case 0xA:
 _result = _outputStack[_outputStack.length - 2]; 
break;
case 0xB:
 _outputStack[_outputStack.length - 3].push(_outputStack[_outputStack.length - 1]); _result = _outputStack[_outputStack.length - 3]; 
break;
case 0xC:
 _result = [_outputStack[_outputStack.length - 1]] 
break;
case 0xD:
 _result = []; 
break;
case 0xE:
 _result = { type: "idkey", args: [_outputStack[_outputStack.length - 3], _outputStack[_outputStack.length - 1]] }; 
break;
case 0xF:
 _result = { type: "strkey", args: [_outputStack[_outputStack.length - 3], _outputStack[_outputStack.length - 1]] }; 
break;
case 0x10:
 _result = _outputStack[_outputStack.length - 2]; 
break;
case 0x11:
 _outputStack[_outputStack.length - 3].push(_outputStack[_outputStack.length - 1]); _result = _outputStack[_outputStack.length - 3]; 
break;
case 0x12:
 _result = [_outputStack[_outputStack.length - 1]]; 
break;
case 0x13:
 _result = []; 
break;
case 0x14:

break;
}
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

		public static function parse(source:String):Object
		{
			var lexer:JsonToRustLexer = new JsonToRustLexer();
			lexer.source = source;
			var parser:JsonToRustParser = new JsonToRustParser();
			var result:Object = parser.parse(lexer);
			return result;
		}
    }
}