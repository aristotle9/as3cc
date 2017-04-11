package org.lala.compilercompile.utils
{
    public class TypeScriptTplRender
    {
        public function TypeScriptTplRender()
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
		
		public static const Src:String = String(<r><![CDATA[import { <{ lexerName }> } from './<{ lexerName }>';

export class <{ class }>
{
    protected _actionTable:Array<any>;
    protected _gotoTable:Object;
    protected _prodList:Array<any>;
    protected _inputTable:Object;
    <{ usercode }>
    constructor()
    {
        <{ tables }>
    }
    
    parse(lexer:<{ lexerName }>):any
    {
        var _stateStack:Array<any> = [0];
        var _outputStack:Array<any> = [];
        var _state:number;
        var _token:any;
        var _act:number;
        <{ initial }>
        while(true)
        {
            _token = lexer.token;
            _state = _stateStack[_stateStack.length - 1];
            if(this._actionTable[this._inputTable[_token]][_state] == null)
            {
                throw new Error("Parse Error:" + lexer.positionInfo);
            }
            else
            {
                _act = this._actionTable[this._inputTable[_token]][_state];
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
                var _pi:number = _act >>> 1;
                var _length:number = this._prodList[_pi][1];
                var _result:any = null;
                /** actions applying **/
                /** default action **/
                if(_length > 0)
                    _result = _outputStack[_outputStack.length - _length];
                <{ actions }>
                /** actions applying end **/
                var _i:number = 0;
                while(_i < _length)
                {
                    _stateStack.pop();
                    _outputStack.pop();
                    _i ++;
                }
                _state = _stateStack[_stateStack.length - 1];
                if(this._gotoTable[this._prodList[_pi][0]][_state] == null)
                {
                    throw new Error("Goto Error!" + lexer.positionInfo);
                }
                else
                {
                    _act = this._gotoTable[this._prodList[_pi][0]][_state];
                }
                _stateStack.push((_act >>> 1) - 1);
                _outputStack.push(_result);
            }
        }
    }

    static parse(source:string):Object
    {
        var lexer = new <{ lexerName }>();
        lexer.source = source;
        var parser = new <{ class }>();
        var result:Object = parser.parse(lexer);
        return result;
    }
}
]]></r>); 
    }
}