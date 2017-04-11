package    org.lala.lex.utils.parser;

import java.util.HashMap;
import java.util.LinkedList;
import java.util.List;
import java.util.Map;

/**
 * Created by as3cc on Tue Apr 11 19:01:42 GMT+0800 2017.
 */
public class RegexLexer {

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
    
    public void setToken(String value) {
        _tokenName = value;
    }

    public RegexLexer() {
        _transTable = 
new StateTransItem[] {new StateTransItem(false, new long[] {0xFFFFFFFFL, 0x3L, 0x2L, 0x1L}, new RangeItem[] {new RangeItem(0L, 32L, 0L), new RangeItem(33L, 33L, 1L), new RangeItem(34L, 34L, 2L), new RangeItem(35L, 35L, 3L)} ), new StateTransItem(false, new long[] {0xFFFFFFFFL, 0xFL, 0xEL, 0xDL, 0xCL, 0xBL, 0xAL, 0x9L, 0x8L, 0x7L, 0x6L, 0x5L, 0x4L}, new RangeItem[] {new RangeItem(0L, 0L, 0L), new RangeItem(1L, 1L, 1L), new RangeItem(2L, 2L, 2L), new RangeItem(3L, 3L, 3L), new RangeItem(4L, 4L, 4L), new RangeItem(5L, 5L, 5L), new RangeItem(6L, 6L, 6L), new RangeItem(7L, 7L, 7L), new RangeItem(8L, 28L, 8L), new RangeItem(29L, 29L, 9L), new RangeItem(30L, 30L, 10L), new RangeItem(31L, 31L, 11L), new RangeItem(32L, 32L, 12L), new RangeItem(33L, 35L, 0L)} ), new StateTransItem(false, new long[] {0xFFFFFFFFL, 0xFL, 0xEL, 0xDL, 0x8L, 0x12L, 0x11L, 0x10L}, new RangeItem[] {new RangeItem(0L, 0L, 0L), new RangeItem(1L, 1L, 1L), new RangeItem(2L, 2L, 2L), new RangeItem(3L, 3L, 3L), new RangeItem(4L, 7L, 4L), new RangeItem(8L, 8L, 5L), new RangeItem(9L, 9L, 6L), new RangeItem(10L, 27L, 4L), new RangeItem(28L, 28L, 7L), new RangeItem(29L, 32L, 4L), new RangeItem(33L, 35L, 0L)} ), new StateTransItem(false, new long[] {0xFFFFFFFFL, 0x16L, 0x15L, 0x14L, 0x13L}, new RangeItem[] {new RangeItem(0L, 21L, 0L), new RangeItem(22L, 24L, 1L), new RangeItem(25L, 25L, 2L), new RangeItem(26L, 26L, 3L), new RangeItem(27L, 27L, 4L), new RangeItem(28L, 35L, 0L)} ), new StateTransItem(true, null, null), new StateTransItem(true, null, null), new StateTransItem(true, null, null), new StateTransItem(true, null, null), new StateTransItem(true, null, null), new StateTransItem(true, null, null), new StateTransItem(true, null, null), new StateTransItem(true, null, null), new StateTransItem(true, null, null), new StateTransItem(false, new long[] {0xFFFFFFFFL, 0x1FL, 0x17L, 0xEL, 0x1DL, 0x1CL, 0x1BL, 0x1AL, 0x19L, 0x1EL, 0x21L, 0x20L, 0x18L}, new RangeItem[] {new RangeItem(0L, 0L, 0L), new RangeItem(1L, 1L, 1L), new RangeItem(2L, 9L, 2L), new RangeItem(10L, 11L, 3L), new RangeItem(12L, 12L, 4L), new RangeItem(13L, 13L, 5L), new RangeItem(14L, 14L, 6L), new RangeItem(15L, 15L, 7L), new RangeItem(16L, 16L, 8L), new RangeItem(17L, 18L, 2L), new RangeItem(19L, 19L, 9L), new RangeItem(20L, 20L, 10L), new RangeItem(21L, 21L, 11L), new RangeItem(22L, 23L, 2L), new RangeItem(24L, 24L, 12L), new RangeItem(25L, 32L, 2L), new RangeItem(33L, 35L, 0L)} ), new StateTransItem(true, null, null), new StateTransItem(true, null, null), new StateTransItem(true, null, null), new StateTransItem(true, null, null), new StateTransItem(true, null, null), new StateTransItem(true, null, null), new StateTransItem(false, new long[] {0xFFFFFFFFL, 0x14L}, new RangeItem[] {new RangeItem(0L, 25L, 0L), new RangeItem(26L, 26L, 1L), new RangeItem(27L, 35L, 0L)} ), new StateTransItem(true, null, null), new StateTransItem(false, new long[] {0xFFFFFFFFL, 0x16L}, new RangeItem[] {new RangeItem(0L, 21L, 0L), new RangeItem(22L, 24L, 1L), new RangeItem(25L, 35L, 0L)} ), new StateTransItem(true, null, null), new StateTransItem(false, new long[] {0xFFFFFFFFL, 0x22L}, new RangeItem[] {new RangeItem(0L, 22L, 0L), new RangeItem(23L, 24L, 1L), new RangeItem(25L, 35L, 0L)} ), new StateTransItem(false, new long[] {0xFFFFFFFFL, 0x23L}, new RangeItem[] {new RangeItem(0L, 10L, 0L), new RangeItem(11L, 11L, 1L), new RangeItem(12L, 12L, 0L), new RangeItem(13L, 14L, 1L), new RangeItem(15L, 17L, 0L), new RangeItem(18L, 18L, 1L), new RangeItem(19L, 19L, 0L), new RangeItem(20L, 20L, 1L), new RangeItem(21L, 21L, 0L), new RangeItem(22L, 24L, 1L), new RangeItem(25L, 35L, 0L)} ), new StateTransItem(false, new long[] {0xFFFFFFFFL, 0x24L}, new RangeItem[] {new RangeItem(0L, 10L, 0L), new RangeItem(11L, 11L, 1L), new RangeItem(12L, 12L, 0L), new RangeItem(13L, 14L, 1L), new RangeItem(15L, 17L, 0L), new RangeItem(18L, 18L, 1L), new RangeItem(19L, 19L, 0L), new RangeItem(20L, 20L, 1L), new RangeItem(21L, 21L, 0L), new RangeItem(22L, 24L, 1L), new RangeItem(25L, 35L, 0L)} ), new StateTransItem(true, null, null), new StateTransItem(true, null, null), new StateTransItem(true, null, null), new StateTransItem(true, null, null), new StateTransItem(true, null, null), new StateTransItem(true, null, null), new StateTransItem(true, null, null), new StateTransItem(false, new long[] {0xFFFFFFFFL, 0x25L}, new RangeItem[] {new RangeItem(0L, 22L, 0L), new RangeItem(23L, 24L, 1L), new RangeItem(25L, 35L, 0L)} ), new StateTransItem(false, new long[] {0xFFFFFFFFL, 0x26L}, new RangeItem[] {new RangeItem(0L, 10L, 0L), new RangeItem(11L, 11L, 1L), new RangeItem(12L, 12L, 0L), new RangeItem(13L, 14L, 1L), new RangeItem(15L, 17L, 0L), new RangeItem(18L, 18L, 1L), new RangeItem(19L, 19L, 0L), new RangeItem(20L, 20L, 1L), new RangeItem(21L, 21L, 0L), new RangeItem(22L, 24L, 1L), new RangeItem(25L, 35L, 0L)} ), new StateTransItem(false, new long[] {0xFFFFFFFFL, 0x27L}, new RangeItem[] {new RangeItem(0L, 10L, 0L), new RangeItem(11L, 11L, 1L), new RangeItem(12L, 12L, 0L), new RangeItem(13L, 14L, 1L), new RangeItem(15L, 17L, 0L), new RangeItem(18L, 18L, 1L), new RangeItem(19L, 19L, 0L), new RangeItem(20L, 20L, 1L), new RangeItem(21L, 21L, 0L), new RangeItem(22L, 24L, 1L), new RangeItem(25L, 35L, 0L)} ), new StateTransItem(true, null, null), new StateTransItem(true, null, null), new StateTransItem(false, new long[] {0xFFFFFFFFL, 0x28L}, new RangeItem[] {new RangeItem(0L, 10L, 0L), new RangeItem(11L, 11L, 1L), new RangeItem(12L, 12L, 0L), new RangeItem(13L, 14L, 1L), new RangeItem(15L, 17L, 0L), new RangeItem(18L, 18L, 1L), new RangeItem(19L, 19L, 0L), new RangeItem(20L, 20L, 1L), new RangeItem(21L, 21L, 0L), new RangeItem(22L, 24L, 1L), new RangeItem(25L, 35L, 0L)} ), new StateTransItem(false, new long[] {0xFFFFFFFFL, 0x29L}, new RangeItem[] {new RangeItem(0L, 10L, 0L), new RangeItem(11L, 11L, 1L), new RangeItem(12L, 12L, 0L), new RangeItem(13L, 14L, 1L), new RangeItem(15L, 17L, 0L), new RangeItem(18L, 18L, 1L), new RangeItem(19L, 19L, 0L), new RangeItem(20L, 20L, 1L), new RangeItem(21L, 21L, 0L), new RangeItem(22L, 24L, 1L), new RangeItem(25L, 35L, 0L)} ), new StateTransItem(true, null, null)}
;_finalTable = 
new HashMap<>(33);_finalTable.put(0x4L, 0x0L); _finalTable.put(0x5L, 0x4L); _finalTable.put(0x6L, 0x1L); _finalTable.put(0x7L, 0x2L); _finalTable.put(0x8L, 0x1CL); _finalTable.put(0x9L, 0x3L); _finalTable.put(0xAL, 0x6L); _finalTable.put(0xBL, 0x5L); _finalTable.put(0xCL, 0xAL); _finalTable.put(0xDL, 0x1CL); _finalTable.put(0xEL, 0x12L); _finalTable.put(0xFL, 0x1BL); _finalTable.put(0x10L, 0x8L); _finalTable.put(0x11L, 0x7L); _finalTable.put(0x12L, 0x9L); _finalTable.put(0x13L, 0xEL); _finalTable.put(0x14L, 0xDL); _finalTable.put(0x15L, 0xBL); _finalTable.put(0x16L, 0xCL); _finalTable.put(0x17L, 0x1AL); _finalTable.put(0x18L, 0x1AL); _finalTable.put(0x19L, 0x1AL); _finalTable.put(0x1AL, 0x1AL); _finalTable.put(0x1BL, 0x16L); _finalTable.put(0x1CL, 0x17L); _finalTable.put(0x1DL, 0x13L); _finalTable.put(0x1EL, 0x15L); _finalTable.put(0x1FL, 0x18L); _finalTable.put(0x20L, 0x14L); _finalTable.put(0x21L, 0x19L); _finalTable.put(0x25L, 0xFL); _finalTable.put(0x26L, 0x10L); _finalTable.put(0x29L, 0x11L)
;_inputTable = 
new RangeItem[] {new RangeItem(0L, 8L, 17L), new RangeItem(9L, 9L, 26L), new RangeItem(10L, 10L, 0L), new RangeItem(11L, 12L, 17L), new RangeItem(13L, 13L, 0L), new RangeItem(14L, 31L, 17L), new RangeItem(32L, 32L, 26L), new RangeItem(33L, 39L, 17L), new RangeItem(40L, 40L, 31L), new RangeItem(41L, 41L, 5L), new RangeItem(42L, 42L, 32L), new RangeItem(43L, 43L, 30L), new RangeItem(44L, 44L, 25L), new RangeItem(45L, 45L, 28L), new RangeItem(46L, 46L, 2L), new RangeItem(47L, 47L, 1L), new RangeItem(48L, 48L, 24L), new RangeItem(49L, 55L, 23L), new RangeItem(56L, 57L, 22L), new RangeItem(58L, 62L, 17L), new RangeItem(63L, 63L, 29L), new RangeItem(64L, 64L, 17L), new RangeItem(65L, 70L, 18L), new RangeItem(71L, 90L, 17L), new RangeItem(91L, 91L, 6L), new RangeItem(92L, 92L, 3L), new RangeItem(93L, 93L, 8L), new RangeItem(94L, 94L, 9L), new RangeItem(95L, 96L, 17L), new RangeItem(97L, 97L, 18L), new RangeItem(98L, 98L, 14L), new RangeItem(99L, 99L, 20L), new RangeItem(100L, 100L, 11L), new RangeItem(101L, 101L, 18L), new RangeItem(102L, 102L, 13L), new RangeItem(103L, 109L, 17L), new RangeItem(110L, 110L, 21L), new RangeItem(111L, 113L, 17L), new RangeItem(114L, 114L, 12L), new RangeItem(115L, 115L, 10L), new RangeItem(116L, 116L, 19L), new RangeItem(117L, 117L, 15L), new RangeItem(118L, 118L, 17L), new RangeItem(119L, 119L, 10L), new RangeItem(120L, 120L, 16L), new RangeItem(121L, 122L, 17L), new RangeItem(123L, 123L, 4L), new RangeItem(124L, 124L, 7L), new RangeItem(125L, 125L, 27L), new RangeItem(126L, 65535L, 17L)}
;_initialTable = 
new HashMap<>(3);_initialTable.put("REPEAT", 0x1L); _initialTable.put("INITIAL", 0x3L); _initialTable.put("BRACKET", 0x2L)
;
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
        ;

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
                        switch ((int)_fIndex) {
case 0x0:
    return "*";
case 0x1:
    return "+";
case 0x2:
    return "?";
case 0x3:
    return "|";
case 0x4:
    return "(";
case 0x5:
    return ")";
case 0x6:
    this.begin("BRACKET"); return "[";
case 0x7:
    return "^";
case 0x8:
    return "-";
case 0x9:
    this.begin("INITIAL"); return "]";
case 0xA:
    this.begin("REPEAT"); return "{";
case 0xB:
    return ",";
case 0xC:
    _yytext = Integer.valueOf((String)_yytext); return "d";
case 0xE:
    this.begin("INITIAL"); return "}";
case 0xF:
    _yytext = Character.toString((char)Integer.parseInt(((String)_yytext).substring(2, 4), 8)); return "c";
case 0x10:
    _yytext = Character.toString((char)Integer.parseInt(((String)_yytext).substring(2, 4), 16)); return "c";
case 0x11:
    _yytext = Character.toString((char)Integer.parseInt(((String)_yytext).substring(2, 6), 16)); return "c";
case 0x12:
    return "escc";
case 0x13:
    _yytext = "\r"; return "c";
case 0x14:
    _yytext = "\n"; return "c";
case 0x15:
    _yytext = "\t"; return "c";
case 0x16:
    _yytext = "\b"; return "c";
case 0x17:
    _yytext = "\f"; return "c";
case 0x18:
    _yytext = "/"; return "c";
case 0x19:
    return "escc";
case 0x1A:
    _yytext = ((String)_yytext).substring(1, 2); return "c";
case 0x1B:
    return "/";
case 0x1C:
    return "c";
}
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
        RegexLexer lexer = new RegexLexer();
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
