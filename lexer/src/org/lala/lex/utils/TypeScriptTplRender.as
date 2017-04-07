package org.lala.lex.utils
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
		
		private static const Src:String = String(<r><![CDATA[<{ imports }>
const DEADSTATE    = 0xFFFFFFFF;
const INVALID_CHAR = 0xFFFFFFFF;
export class <{ class }>
{
    protected _transTable:Array<any>;
    protected _finalTable:Object;
    protected _inputTable:Array<any>;
    protected _initialTable:Object;

    protected _start:number;
    protected _oldStart:number;
    protected _tokenName:string;
    protected _yytext: any;
    protected _yy:Object;
    protected _ended:boolean;
    protected _initialInput:number;
    protected _initialState:string;

    protected _line:number;
    protected _col:number;
    protected _advanced:boolean;

    protected _source:string;
    <{ usercode }>
    constructor()
    {
        <{ tables }>
    }

    yyrestart(src:string=null):void
    {
        if(src != null)
        {
            this._source = src;
        }
        this._ended = false;
        this._start = 0;
        this._oldStart = 0;
        this._line = 1;
        this._col = 0;
        this._advanced = true;
        this._tokenName = null;
        this._yy = {};
        this.initialState = "INITIAL";
        <{ initial }>
    }

    set source(src:string)
    {
        this._source = src;
        this.yyrestart();
    }

    get token():string
    {
        if(this._advanced)
        {
            this._tokenName = this.next();
            this._advanced = false;
        }
        return this._tokenName;
    }

    advance():void
    {
        this._advanced = true;
    }

    get startIdx():number
    {
        return this._oldStart;
    }

    get endIdx():number
    {
        return this._start;
    }

    get position():[number, number]
    {
        return [this._line,this._col];
    }

    get positionInfo():string
    {
        return this.token + '@row:' + this.position.join('col:');
    }

    get yytext(): any
    {
        return this._yytext;
    }

    get yyleng():number
    {
        return this.endIdx - this.startIdx;
    }

    set yytext(value: any)
    {
        this._yytext = value;
    }

    get yy():Object
    {
        return this._yy;
    }

    get tokenName():string
    {
        return this._tokenName;
    }

    next():string
    {
        var _findex: any;
        var _nextState: any;
        var _char:number;
        var _begin:number;
        var _next:number;
        var _ochar:number;
        var _curState:number;
        var _lastFinalState:number;
        var _lastFinalPosition:number;

        while(true)
        {
            _findex = null;
            _nextState = null;
            _char = 0;
            _begin = this._start;
            _next = this._start;
            _ochar = INVALID_CHAR;
            _lastFinalState = DEADSTATE;
            _lastFinalPosition = this._start;
            _curState = this._transTable[0][1][this._initialInput];
            while(true)
            {
                _char = this._source.charCodeAt(_next);
                /** 计算行,列位置 **/
                if(_ochar != INVALID_CHAR)
                {
                    if(_char == 0x0d)//\r
                    {
                        this._col = 0;
                        this._line ++;
                    }
                    else if(_char == 0x0a)//\n
                    {
                        if(_ochar != 0x0d)// != \r
                        {
                            this._col = 0;
                            this._line ++;
                        }
                    }
                    else
                    {
                        this._col ++;
                    }
                }
                _ochar = _char;
                /** 计算行,列位置--结束 **/
                _nextState = this.trans(_curState, _char);
                if(_nextState == DEADSTATE)
                {
                    if(_begin == _lastFinalPosition)
                    {
                        if(this._start == this._source.length)
                        {
                            if(this._ended == false)
                            {
                                this._ended = true;
                                return "<$>";
                            }
                            else
                            {
                                throw new Error("已经到达末尾.");
                            }
                        }
                        throw new Error("意外的字符,line:" + this.position.join(",col:") + 'of ' + this._source.substr(_begin,20));
                    }
                    else
                    {
                        _findex = this._finalTable[_lastFinalState];
                        this._start = _lastFinalPosition;
                        this._oldStart = _begin;
                        this._yytext = this._source.substring(this.startIdx, this.endIdx);
                        <{ actions }>
                        break;
                    }
                }
                else
                {
                    _findex = this._finalTable[_nextState];
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
        // return "";//这里的值会影响返回值!!
    }
    trans(curState:number,char:number):number
    {
        if(isNaN(char))
            return DEADSTATE;
        if(char < this._inputTable[0][0] || char > this._inputTable[this._inputTable.length - 1][1])
            throw new Error("输入超出有效范围,line:" + this.position.join(",col:"));
        if(this._transTable[curState][0] == true)
            return DEADSTATE;

        var ipt:number = this.find(char,this._inputTable);
        var ipt2:number = this.find(ipt, this._transTable[curState][2]);
        return this._transTable[curState][1][ipt2];
    }

    find(code:number,seg:Array<any>):number
    {
        var min:number;
        var max:number;
        var mid:number;
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
        // return 0;
    }

    begin(state:string=null):void
    {
        if(state == null)
        {
            this.initialState = "INITIAL";
            return;
        }
        this.initialState = state;
    }

    get initialState():string
    {
        return this._initialState;
    }

    set initialState(value:string)
    {
        if(this._initialTable[value] === undefined)
        {
            throw new Error("未定义的起始状态:" + value);
        }
        this._initialState = value;
        this._initialInput = this._initialTable[value];
    }

	static lex_seq(source:string):Array<any>
	{
		var lexer = new <{ class }>();
		lexer.source = source;
		var tokens:Array<any> = [];
		var token:string = lexer.token;
		while(token != '<$>')
		{
			tokens.push({token: token, text: lexer.yytext, start: lexer.startIdx, end: lexer.endIdx});
			lexer.advance();
			token = lexer.token;
		}
		return tokens;
	}
}
]]></r>);
    }
}