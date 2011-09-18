package org.lala.lex.configs.parser
{
    

    public class LexParser
    {
        protected var _actionTable:Array;
        protected var _gotoTable:Object;
        protected var _prodList:Array;
        protected var _inputTable:Object;
        
        public function LexParser()
        {
            _actionTable = 
[null,{1:1,82:62,27:2,3:60,51:58},{0:24,2:9,8:34,78:88,16:4,17:6,18:8,19:10,20:12,21:14,22:16,23:18,24:20,25:22,28:26,29:28,30:30,31:32,32:36,34:40,46:48,47:50,48:42,49:46,52:38,63:44},{0:24,2:11,8:34,78:88,16:4,17:6,18:8,19:10,20:12,21:14,22:16,23:18,24:20,25:22,28:26,29:28,30:30,31:32,32:36,34:40,46:48,47:50,48:42,49:46,52:38,63:44},{64:95,3:60,4:59,5:61,6:63,7:65,73:95,10:69,11:71,12:52,13:54,14:56,47:50,48:95,49:46,82:62,51:58,84:95,46:48,83:95,26:95,27:103,63:44},{0:24,2:13,8:34,78:88,16:4,17:6,18:8,19:10,20:12,21:14,22:16,23:18,24:20,25:22,28:26,29:28,30:30,31:32,32:36,34:40,46:48,47:50,48:42,49:46,52:38,63:44},{0:24,2:15,8:34,78:88,16:4,17:6,18:8,19:10,20:12,21:14,22:16,23:18,24:20,25:22,28:26,29:28,30:30,31:32,32:36,34:40,46:48,47:50,48:42,49:46,52:38,63:44},{0:24,2:17,8:34,78:88,16:4,17:6,18:8,19:10,20:12,21:14,22:16,23:18,24:20,25:22,28:26,29:28,30:30,31:32,32:36,34:40,46:48,47:50,48:42,49:46,52:38,63:44},{0:24,2:19,8:34,9:67,78:88,16:4,17:6,18:8,19:10,20:12,21:14,22:16,23:18,24:20,25:22,28:26,29:28,30:30,31:32,32:36,33:107,34:40,46:48,47:50,48:42,49:46,52:38,63:44},{0:24,2:21,8:34,78:88,16:4,17:6,18:8,19:10,20:12,21:14,22:16,23:18,24:20,25:22,28:26,29:28,30:30,31:32,32:36,34:40,46:48,47:50,48:42,49:46,52:38,63:44},{0:24,2:23,8:34,78:88,16:4,17:6,18:8,19:10,20:12,21:14,22:16,23:18,24:20,25:22,28:26,29:28,30:30,31:32,32:36,34:40,46:48,47:50,48:42,49:46,52:38,63:44},{0:24,2:25,8:34,78:88,16:4,17:6,18:8,19:10,20:12,21:14,22:16,23:18,24:20,25:22,28:26,29:28,30:30,31:32,32:36,34:40,46:48,47:50,48:42,49:46,52:38,63:44},{64:97,73:97,12:52,13:54,46:48,47:50,48:97,49:46,83:97,84:97,14:56,26:97,63:44},{0:24,2:27,8:34,78:88,16:4,17:6,18:8,19:10,20:12,21:14,22:16,23:18,24:20,25:22,28:26,29:28,30:30,31:32,32:36,34:40,46:48,47:50,48:42,49:46,52:38,63:44},{0:24,2:29,8:34,78:88,16:4,17:6,18:8,19:10,20:12,21:14,22:16,23:18,24:20,25:22,28:26,29:28,30:30,31:32,32:36,34:40,46:48,47:50,48:42,49:46,52:38,63:44},{0:24,2:31,8:34,78:88,16:4,17:6,18:8,19:10,20:12,21:14,22:16,23:18,24:20,25:22,28:26,29:28,30:30,31:32,32:36,34:40,46:48,47:50,48:42,49:46,52:38,63:44},{50:131},{64:74,96:78,73:72,74:167,75:66,76:80,46:48,47:50,49:46,83:74,86:80,87:70,89:64,90:76,93:68,63:44},{64:74,96:78,73:72,74:169,75:66,76:80,46:48,47:50,49:46,83:74,86:80,87:70,89:64,90:76,93:68,63:44},{64:74,49:46,83:74,47:50,73:72,76:171,46:48,63:44},{64:74,97:193,98:86,99:82,95:86,73:72,76:173,46:48,47:50,49:46,83:74,85:86,86:173,90:76,91:84,92:193,63:44},{97:199,98:86,99:82,85:86,91:84,92:195,95:86},{85:185,98:185,95:185},{0:24,2:33,8:34,78:88,16:4,17:6,18:8,19:10,20:12,21:14,22:16,23:18,24:20,25:22,28:26,29:28,30:30,31:32,32:36,34:40,46:48,47:50,48:42,49:46,52:38,63:44},{65:114,66:110,37:112,43:125,44:90,45:96,15:92,53:98,54:100,55:102,56:104,57:116,58:106,59:108,62:94},{80:132,81:126,68:130,69:159,70:118,71:124,72:134,61:120,94:128,79:122},{65:114,66:110,37:112,44:73,45:96,15:73,53:98,54:100,55:102,56:104,57:116,58:106,59:108,62:94},{57:116,58:133,35:109,67:117,38:113,39:115,40:117,41:117,42:123,59:133,65:114,77:133},{65:114,66:110,37:112,44:75,45:96,15:75,53:98,54:100,55:102,56:104,57:116,58:106,59:108,62:94},{65:114,66:110,36:111,37:112,44:77,45:96,15:77,53:98,54:100,55:102,56:104,57:116,58:106,59:108,60:135,62:94},{65:114,66:110,37:112,44:79,45:96,15:79,53:98,54:100,55:102,56:104,57:116,58:106,59:108,62:94},{65:114,66:110,37:112,44:81,45:96,15:81,53:98,54:100,55:102,56:104,57:116,58:106,59:108,62:94},{65:114,66:110,37:112,44:83,45:96,15:83,53:98,54:100,55:102,56:104,57:116,58:106,59:108,62:94},{65:114,66:110,37:112,44:85,45:96,15:85,53:98,54:100,55:102,56:104,57:116,58:106,59:108,62:94},{65:114,66:110,37:112,44:87,45:96,15:87,53:98,54:100,55:102,56:104,57:116,58:106,59:108,62:94},{80:132,81:126,68:130,70:137,71:124,72:134,61:137,94:128,79:122},{77:179,57:116,65:114},{80:132,81:126,68:130,70:139,71:124,72:134,88:191,61:139,94:128,79:122},{68:130,72:163,94:128}]
;_gotoTable = 
{64:{15:91},65:{44:127,15:93},66:{40:119,41:121,67:157},67:{61:143},68:{61:145,70:161},69:{61:147,70:147},70:{72:165},39:{0:5},40:{0:7},41:{3:57},42:{2:35},43:{2:37},44:{2:39},45:{2:41},46:{2:43},47:{2:45},48:{2:47},49:{2:49},50:{2:51},51:{2:53},52:{2:55},53:{64:149,26:99,83:149},54:{48:129,64:101,26:101,83:101,73:129,84:183},55:{27:105},56:{64:151},57:{64:153,83:181},58:{64:155,83:155},59:{76:175},60:{76:177,86:189},61:{85:187,98:201,95:197},62:{15:89},63:{61:141}}
;_prodList = 
[[71,2],[39,3],[40,2],[40,2],[40,2],[40,2],[40,2],[40,2],[40,2],[40,2],[40,2],[40,2],[40,0],[45,2],[46,2],[47,2],[48,2],[49,1],[50,2],[51,3],[44,2],[43,2],[53,2],[53,1],[54,1],[54,1],[52,1],[52,1],[52,1],[41,2],[41,0],[55,4],[56,3],[56,1],[57,3],[57,2],[58,1],[58,0],[59,2],[60,3],[60,0],[61,5],[61,1],[61,0],[42,5],[62,1],[62,0],[64,2],[64,1],[65,2],[65,2],[65,2],[65,2],[65,2],[65,2],[65,3],[65,1],[66,2],[66,1],[63,1],[63,0],[67,2],[67,1],[68,2],[69,4],[69,1],[70,1],[70,0]]
;_inputTable = 
{"|":18,"}":21,"dec_inc":32,"grammar_dec_nonassoc":15,"dec_class":31,"lex_end":25,"grammar_dec_initial":9,"<":35,"dec_initial":28,"grammar_dec_start":11,"lex_code":29,"dec_import":30,"<$>":1,"lex_begin":23,"dec_package":26,"dec_exc":33,"grammar_dec_field":10,"grammar_dec_prec":19,"action":38,"grammar_dec_lexer_name":5,"dec_field":34,"pattern":37,"grammar_string":12,":":16,"grammar_action_body":22,"grammar_dec_right":14,"grammar_rule_begin":2,"grammar_id":4,"name":27,"grammar_code":8,";":17,"grammar_dec_class":3,"rule_start":24,"grammar_dec_package":6,"grammar_dec_left":13,"grammar_dec_import":7,"{":20,">":36}
;
        }
        
        public function parse(lexer:LexLexer):*
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
 _result = {decs: _outputStack[_outputStack.length - 3], rules: _outputStack[_outputStack.length - 1]}; 
break;
case 0x2:
 _result = _outputStack[_outputStack.length - 2]; _result.lex.push(_outputStack[_outputStack.length - 1]); 
break;
case 0x3:

                    _result = _outputStack[_outputStack.length - 2];
                    _outputStack[_outputStack.length - 1][1].forEach(function(sm:String, ...args):void
                    {
                        _result.operators[sm] = {preced:_result.preced, assoc: _outputStack[_outputStack.length - 1][0]};
                    });
                    _result.preced ++;
                
break;
case 0x4:
 _result = _outputStack[_outputStack.length - 2]; _result.start = _outputStack[_outputStack.length - 1]; 
break;
case 0x5:
 _result = _outputStack[_outputStack.length - 2]; _result.decs['class'] = _outputStack[_outputStack.length - 1]; 
break;
case 0x6:
 _result = _outputStack[_outputStack.length - 2]; _result.decs['lexerName'] = _outputStack[_outputStack.length - 1]; 
break;
case 0x7:
 _result = _outputStack[_outputStack.length - 2]; _result.decs['package'] = _outputStack[_outputStack.length - 1]; 
break;
case 0x8:
 _result = _outputStack[_outputStack.length - 2]; _result.decs['imports'].push(_outputStack[_outputStack.length - 1]); 
break;
case 0x9:
 _result = _outputStack[_outputStack.length - 2]; _result['codes'].push(_outputStack[_outputStack.length - 1]); 
break;
case 0xA:
 _result = _outputStack[_outputStack.length - 2]; _result['initials'].push(_outputStack[_outputStack.length - 1]); 
break;
case 0xB:
 _result = _outputStack[_outputStack.length - 2]; _result['fields'][_outputStack[_outputStack.length - 1].name] = _outputStack[_outputStack.length - 1].value; 
break;
case 0xC:
 _result = {lex:[],start:null,operators:{}, preced:0,  
                            decs:{'class':'', 'imports':[], 'package': '', lexerName: ''}, 
                            codes: [], initials: [], fields:{} };
                          
break;
case 0xD:
 _result = _outputStack[_outputStack.length - 1] 
break;
case 0xE:
 _result = _outputStack[_outputStack.length - 1] 
break;
case 0xF:
 _result = _outputStack[_outputStack.length - 1] 
break;
case 0x10:
 _result = _outputStack[_outputStack.length - 1] 
break;
case 0x11:

break;
case 0x12:
 _result = _outputStack[_outputStack.length - 1] 
break;
case 0x13:
 _result = {name: _outputStack[_outputStack.length - 2], value: _outputStack[_outputStack.length - 1]}; 
break;
case 0x14:
 _result = _outputStack[_outputStack.length - 1]; 
break;
case 0x15:
 _result = [_outputStack[_outputStack.length - 2],_outputStack[_outputStack.length - 1]]; 
break;
case 0x16:
 _result = _outputStack[_outputStack.length - 2]; _result.push(_outputStack[_outputStack.length - 1]); 
break;
case 0x17:
 _result = [_outputStack[_outputStack.length - 1]]; 
break;
case 0x18:

break;
case 0x19:

break;
case 0x1A:
 _result = 'left'; 
break;
case 0x1B:
 _result = 'right'; 
break;
case 0x1C:
 _result = 'nonassoc'; 
break;
case 0x1D:
 _result = _outputStack[_outputStack.length - 2]; _result.push(_outputStack[_outputStack.length - 1]); 
break;
case 0x1E:
 _result = []; 
break;
case 0x1F:
 _result = {head:_outputStack[_outputStack.length - 4],rhs:_outputStack[_outputStack.length - 2]}; 
break;
case 0x20:
 _result = _outputStack[_outputStack.length - 3]; _result.push(_outputStack[_outputStack.length - 1]); 
break;
case 0x21:
 _result = [_outputStack[_outputStack.length - 1]]; 
break;
case 0x22:
_result = {pattern:_outputStack[_outputStack.length - 3],preced:_outputStack[_outputStack.length - 2],action:_outputStack[_outputStack.length - 1]};
break;
case 0x23:
_result = {pattern:_outputStack[_outputStack.length - 2],action:_outputStack[_outputStack.length - 1]};
break;
case 0x24:

break;
case 0x25:
 _result = []; 
break;
case 0x26:
 _result = _outputStack[_outputStack.length - 1]; 
break;
case 0x27:
 _result = _outputStack[_outputStack.length - 2]; 
break;
case 0x28:
 _result = ""; 
break;
case 0x29:
 _result = _outputStack[_outputStack.length - 5] + _outputStack[_outputStack.length - 4] + _outputStack[_outputStack.length - 3] + _outputStack[_outputStack.length - 2] + _outputStack[_outputStack.length - 1]; 
break;
case 0x2A:

break;
case 0x2B:
 _result = ""; 
break;
case 0x2C:

            _result = {rules:_outputStack[_outputStack.length - 2], states:{inclusive:[],exclusive:[]}, decs:{'imports':[], 'package':'', 'class':''}, codes:[], initials:[], fields:{}};
            _outputStack[_outputStack.length - 4].forEach(function(arr:Array,...args):void
            {
                switch(arr[0])
                {
                case 'include':
                    _result.states.inclusive.push.apply(null,arr[1]);
                    break;
                case 'exclude':
                    _result.states.exclusive.push.apply(null,arr[1]);
                    break;
                case 'import':
                    _result.decs['imports'].push(arr[1]);
                    break;
                case 'class':
                    _result.decs['class'] = arr[1];
                    break;
                case 'package':
                    _result.decs['package'] = arr[1];
                    break;
                case 'initial':
                    _result.initials.push(arr[1]);
                    break;
                case 'code':
                    _result.codes.push(arr[1]);
                    break;
                case 'field':
                    _result.fields[arr[1]] = arr[2];
                    break;
                }
            });
        
break;
case 0x2D:

break;
case 0x2E:
 _result = []; 
break;
case 0x2F:
 _result = _outputStack[_outputStack.length - 2]; _result.push(_outputStack[_outputStack.length - 1]); 
break;
case 0x30:
 _result = [_outputStack[_outputStack.length - 1]]; 
break;
case 0x31:
 _result = ['package', _outputStack[_outputStack.length - 1]]; 
break;
case 0x32:
 _result = ['initial', _outputStack[_outputStack.length - 1]]; 
break;
case 0x33:
 _result = ['import', _outputStack[_outputStack.length - 1]]; 
break;
case 0x34:
 _result = ['class', _outputStack[_outputStack.length - 1]]; 
break;
case 0x35:
 _result = ['include', _outputStack[_outputStack.length - 1]]; 
break;
case 0x36:
 _result = ['exclude', _outputStack[_outputStack.length - 1]]; 
break;
case 0x37:
 _result = ['field', _outputStack[_outputStack.length - 2], _outputStack[_outputStack.length - 1]]; 
break;
case 0x38:
 _result = ['code', _outputStack[_outputStack.length - 1]]; 
break;
case 0x39:
 _result = _outputStack[_outputStack.length - 2]; _result.push(_outputStack[_outputStack.length - 1]); 
break;
case 0x3A:
 _result = [_outputStack[_outputStack.length - 1]]; 
break;
case 0x3B:

break;
case 0x3C:
 _result = []; 
break;
case 0x3D:
 _result = _outputStack[_outputStack.length - 2]; _result.push(_outputStack[_outputStack.length - 1]); 
break;
case 0x3E:
 _result = [_outputStack[_outputStack.length - 1]]; 
break;
case 0x3F:
 _result = {p:_outputStack[_outputStack.length - 2],a:_outputStack[_outputStack.length - 1]}; 
break;
case 0x40:
 _result = [_outputStack[_outputStack.length - 1],_outputStack[_outputStack.length - 3]]; 
break;
case 0x41:
 _result = [_outputStack[_outputStack.length - 1], []]; 
break;
case 0x42:

break;
case 0x43:
 _result = ""; 
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
    }
}