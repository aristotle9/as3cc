package org.lala.lex.utils
{
    public class JavaTplRender
    {
        public function JavaTplRender()
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
		
		private static const Src:String = String(<r><![CDATA[<{ field_package }>
import java.util.HashMap;
import java.util.LinkedList;
import java.util.List;
import java.util.Map;
<{ imports }>
/**
 * Created by as3cc on <{ create_date }>.
 */
public class <{ class }> {

    private StateTransItem[] _transTable;
    private Map<Long, Long> _finalTable;
    private Map<String, Long> _initialTable;
    private RangeItem[] _inputTable;

    private static final long DEADSTATE = 0xFFFFFFFFL;

    private long _start;
    private long _oldStart;
    private String _tokenName;
    private Object _yytext;
    private Object _yy;
    private boolean _ended;
    private long _initialInput;
    private String _initialState;

    private long _line;
    private long _col;
    private boolean _advanced;

    private String _source;
    <{ usercode }>
    public <{ class }>() {
        <{ tables }>
    }

    private void yyrestart(String src) {
        if(src != null) {
            _source = src;
        }
        _ended = false;
        _start = 0;
        _oldStart = 0;
        _line = 1;
        _col = 0;
        _advanced = true;
        _tokenName = null;
        _yy = null;

        //setInitialState("INITIAL");
        //展开 setInitialState, 这里能确保不会抛出异常
        _initialState = "INITIAL";
        _initialInput = _initialTable.get(_initialState);
        <{ initial }>
    }

    public void setSource(String src) {
        yyrestart(src);
    }

    public String getToken() throws Exception {
        if (_advanced) {
            _tokenName = next();
            _advanced = false;
        }
        return _tokenName;
    }

    public void advance() {
        _advanced = true;
    }

    public long getStartIndex() {
        return _oldStart;
    }

    public long getEndIndex() {
        return _start;
    }

    public long[] getPosition() {
        return new long[] {_line, _col};
    }

    public String getPositionInfo() throws Exception {
        return getToken() + "@row:" + _line + "col:" + _col;
    }

    public Object getYYText() {
        return _yytext;
    }

    private void setYYText(Object value) {
        this._yytext = value;
    }

    public int getYYLeng() {
        return (int) (getEndIndex() - getStartIndex());
    }

    public Object getYY() {
        return _yy;
    }

    public String getTokenName() {
        return _tokenName;
    }

    private String next() throws Exception {
        //外层循环是因为有些 token 会在词法层忽略掉, 不会有返回的 action
        while (true) {
            long _nextState = 0L;
            long _ch = 0L;
            long _next = _start;
            long _och = Long.MAX_VALUE;
            long _curState = _transTable[0].toStates[(int) _initialInput];
            long _lastFinalState = DEADSTATE;
            long _lastFinalPosition = _start;
            while (true) {
                if (_next < _source.length()) {
                    _ch = _source.codePointAt((int) _next);
                    /** 计算行,列位置 **/
                    if (_och != Long.MAX_VALUE) {
                        if (_ch == 0x0dL) {//\r
                            _col = 0L;
                            _line++;
                        } else if (_ch == 0x0aL) {//\n
                            if (_och != 0x0dL) { // != \r
                                _col = 0L;
                                _line++;
                            }
                        } else {
                            _col++;
                        }
                    }

                    _och = _ch;
                    _nextState = trans(_curState, _ch);
                } else {
                    _nextState = DEADSTATE;
                }
                if (_nextState == DEADSTATE) {
                    if (_start == _lastFinalPosition) {
                        if (_start == _source.length()) {
                            if (!_ended) {
                                _ended = true;
                                return "<$>";
                            } else {
                                throw new Exception("已经达到末尾.");
                            }
                        } else {
                            throw new Exception("意外的字符, line:" + _line + ", col:" + _col + " of " + _source.substring((int) _start, (int) (_start + 20)));
                        }
                    } else {
                        _yytext = _source.substring((int) _start, (int) _lastFinalPosition);
                        _oldStart = _start;
                        _start = _lastFinalPosition;
                        long _fIndex = _finalTable.get(_lastFinalState);
                        <{ actions }>
                        break;
                    }
                } else {
                    _next += 1;
                    if (_finalTable.containsKey(_nextState)) {
                        _lastFinalState = _nextState;
                        _lastFinalPosition = _next;
                    }
                    _curState = _nextState;
                }
            }
        }
    }

    private void begin(String state) throws Exception {
        setInitialState(state);
    }

    private void begin() {
        //setInitialState("INITIAL");
        //展开 setInitialState, 这里能确保不会抛出异常
        _initialState = "INITIAL";
        _initialInput = _initialTable.get(_initialState);
    }

    private void setInitialState(String state) throws Exception {
        if (!_initialTable.containsKey(state)) {
            throw new Exception("未定义的初始状态: " + state);
        }
        _initialState = state;
        _initialInput = _initialTable.get(state);
    }

    private String getInitialState() {
        return _initialState;
    }

    private static long find(long code, RangeItem[] table) {
        int max = table.length - 1;
        int min = 0;
        int mid;

        while(true) {
            mid = (min + max) >>> 1;
            if(table[mid].from <= code) {
                if(table[mid].to >= code) {
                    return table[mid].value;
                } else {
                    min = mid + 1;
                }
            } else {
                max = mid - 1;
            }
        }
    }

    private long trans(long curState, long ch) throws Exception {
        if (ch < _inputTable[0].from || ch > _inputTable[_inputTable.length - 1].to) {
            throw new Exception(positionMessage("输入字符超出有效范围."));
        }

        if (_transTable[(int)curState].isDead) {
            return DEADSTATE;
        }

        long pubInput = find(ch, _inputTable);
        long innerInput = find(pubInput, _transTable[(int)curState].transEdge);
        return _transTable[(int)curState].toStates[(int)innerInput];
    }

    private String positionMessage(String msg) {
        return "line: " + _line + " col: " + _col + " " + msg;
    }

    public static List<TokenItem> LexSeq(String source) throws Exception {
        <{ class }> lexer = new <{ class }>();
        lexer.setSource(source);
        List<TokenItem> tokens = new LinkedList<>();
        String token = lexer.getToken();
        while (!token.equals("<$>")) {
            tokens.add(new TokenItem(token, lexer.getYYText(), lexer.getStartIndex(), lexer.getEndIndex()));
            lexer.advance();
            token = lexer.getToken();
        }
        return tokens;
    }

    public static final class RangeItem {
        public final long from;
        public final long to;
        public final long value;

        public RangeItem(long from, long to, long value) {
            this.from = from;
            this.to = to;
            this.value = value;
        }
    }

    public static final class StateTransItem {
        public final boolean isDead;
        public final long[] toStates;
        public final RangeItem[] transEdge;

        public StateTransItem(boolean isDead, long[] toStates, RangeItem[] transEdge) {
            this.isDead = isDead;
            this.toStates = toStates;
            this.transEdge = transEdge;
        }
    }

    public static final class TokenItem {
        public final String name;
        public final Object value;
        public final long startIndex;
        public final long endIndex;

        public TokenItem(String name, Object value, long startIndex, long endIndex) {
            this.name = name;
            this.value = value;
            this.startIndex = startIndex;
            this.endIndex = endIndex;
        }
    }
}
]]></r>);
    }
}