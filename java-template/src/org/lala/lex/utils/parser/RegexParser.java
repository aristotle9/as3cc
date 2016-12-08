package    org.lala.lex.utils.parser;

import java.util.*;

/**
 * Created by as3cc on Thu Dec 8 19:17:16 GMT+0800 2016.
 */
public class RegexParser {
    private List<Map<Integer, Integer>> _actionTable;
    private Map<Integer, Map<Integer, Integer>> _gotoTable;
    private ProductionItem[] _prodList;
    private Map<String, Integer> _inputTable;
    
    private LinkedList<Object> codes = new LinkedList<>();
    private void put(Object args) {
        codes.add(args);
    };
    private int _$i = 0;
    private String flags = "";
    private String flags_c = "";
;

    public RegexParser() {
        Map<Integer, Integer> _tmp;
_actionTable = 
new ArrayList<Map<Integer, Integer>>(19);_actionTable.add(null);_tmp = new HashMap<>(21);_tmp.put(0x20, 0x4); _tmp.put(0x21, 0x18); _tmp.put(0x4, 0x2E); _tmp.put(0x5, 0x30); _tmp.put(0x6, 0x1); _tmp.put(0x7, 0x2); _tmp.put(0x8, 0x1C); _tmp.put(0x2A, 0x24); _tmp.put(0x2B, 0x20); _tmp.put(0x24, 0x1E); _tmp.put(0x27, 0x6); _tmp.put(0x10, 0x10); _tmp.put(0x11, 0x12); _tmp.put(0x12, 0x14); _tmp.put(0x14, 0x1A); _tmp.put(0x15, 0xE); _tmp.put(0x16, 0x8); _tmp.put(0x17, 0xC); _tmp.put(0x1A, 0x16); _tmp.put(0x1D, 0xA); _tmp.put(0x2C, 0x22);_actionTable.add(_tmp);_tmp = new HashMap<>(18);_tmp.put(0x0, 0x5); _tmp.put(0x21, 0x18); _tmp.put(0x4, 0x2E); _tmp.put(0x5, 0x30); _tmp.put(0x2C, 0x22); _tmp.put(0x8, 0x1C); _tmp.put(0x9, 0x2F); _tmp.put(0x2A, 0x24); _tmp.put(0x2B, 0x20); _tmp.put(0x24, 0x1E); _tmp.put(0x10, 0x10); _tmp.put(0x11, 0x12); _tmp.put(0x12, 0x14); _tmp.put(0x14, 0x1A); _tmp.put(0x15, 0xE); _tmp.put(0x17, 0xC); _tmp.put(0x1A, 0x16); _tmp.put(0x1D, 0xA);_actionTable.add(_tmp);_tmp = new HashMap<>(19);_tmp.put(0x21, 0x18); _tmp.put(0x4, 0x2E); _tmp.put(0x5, 0x30); _tmp.put(0x7, 0x21); _tmp.put(0x8, 0x1C); _tmp.put(0x9, 0x21); _tmp.put(0xA, 0x21); _tmp.put(0x2B, 0x20); _tmp.put(0x24, 0x1E); _tmp.put(0x10, 0x10); _tmp.put(0x11, 0x12); _tmp.put(0x12, 0x14); _tmp.put(0x14, 0x1A); _tmp.put(0x15, 0xE); _tmp.put(0x17, 0xC); _tmp.put(0x1A, 0x16); _tmp.put(0x2A, 0x24); _tmp.put(0x1D, 0xA); _tmp.put(0x2C, 0x22);_actionTable.add(_tmp);_tmp = new HashMap<>(23);_tmp.put(0x0, 0x7); _tmp.put(0x1, 0x7); _tmp.put(0x2, 0x7); _tmp.put(0x4, 0x2E); _tmp.put(0x5, 0x30); _tmp.put(0x7, 0x7); _tmp.put(0x8, 0x1C); _tmp.put(0x9, 0x7); _tmp.put(0xA, 0x7); _tmp.put(0x2B, 0x20); _tmp.put(0x24, 0x1E); _tmp.put(0xF, 0x7); _tmp.put(0x10, 0x10); _tmp.put(0x11, 0x12); _tmp.put(0x12, 0x14); _tmp.put(0x14, 0x1A); _tmp.put(0x15, 0xE); _tmp.put(0x17, 0xC); _tmp.put(0x1A, 0x16); _tmp.put(0x2A, 0x24); _tmp.put(0x21, 0x18); _tmp.put(0x1D, 0x7); _tmp.put(0x2C, 0x22);_actionTable.add(_tmp);_tmp = new HashMap<>(17);_tmp.put(0x21, 0x18); _tmp.put(0x4, 0x2E); _tmp.put(0x5, 0x30); _tmp.put(0x2C, 0x22); _tmp.put(0x8, 0x1C); _tmp.put(0xA, 0x31); _tmp.put(0x2B, 0x20); _tmp.put(0x24, 0x1E); _tmp.put(0x10, 0x10); _tmp.put(0x11, 0x12); _tmp.put(0x12, 0x14); _tmp.put(0x14, 0x1A); _tmp.put(0x15, 0xE); _tmp.put(0x17, 0xC); _tmp.put(0x1A, 0x16); _tmp.put(0x2A, 0x24); _tmp.put(0x1D, 0xA);_actionTable.add(_tmp);_tmp = new HashMap<>(19);_tmp.put(0x21, 0x18); _tmp.put(0x4, 0x2E); _tmp.put(0x5, 0x30); _tmp.put(0x7, 0x23); _tmp.put(0x8, 0x1C); _tmp.put(0x9, 0x23); _tmp.put(0xA, 0x23); _tmp.put(0x2B, 0x20); _tmp.put(0x24, 0x1E); _tmp.put(0x10, 0x10); _tmp.put(0x11, 0x12); _tmp.put(0x12, 0x14); _tmp.put(0x14, 0x23); _tmp.put(0x15, 0xE); _tmp.put(0x17, 0xC); _tmp.put(0x1A, 0x16); _tmp.put(0x2A, 0x24); _tmp.put(0x1D, 0x23); _tmp.put(0x2C, 0x22);_actionTable.add(_tmp);_tmp = new HashMap<>(19);_tmp.put(0x21, 0x18); _tmp.put(0x4, 0x2E); _tmp.put(0x5, 0x30); _tmp.put(0x7, 0x25); _tmp.put(0x8, 0x1C); _tmp.put(0x9, 0x25); _tmp.put(0xA, 0x25); _tmp.put(0x2B, 0x20); _tmp.put(0x24, 0x1E); _tmp.put(0x10, 0x10); _tmp.put(0x11, 0x12); _tmp.put(0x12, 0x14); _tmp.put(0x14, 0x25); _tmp.put(0x15, 0xE); _tmp.put(0x17, 0xC); _tmp.put(0x1A, 0x16); _tmp.put(0x2A, 0x24); _tmp.put(0x1D, 0x25); _tmp.put(0x2C, 0x22);_actionTable.add(_tmp);_tmp = new HashMap<>(19);_tmp.put(0x21, 0x18); _tmp.put(0x4, 0x2E); _tmp.put(0x5, 0x30); _tmp.put(0x7, 0x27); _tmp.put(0x8, 0x1C); _tmp.put(0x9, 0x27); _tmp.put(0xA, 0x27); _tmp.put(0x2B, 0x20); _tmp.put(0x24, 0x1E); _tmp.put(0x10, 0x10); _tmp.put(0x11, 0x12); _tmp.put(0x12, 0x14); _tmp.put(0x14, 0x27); _tmp.put(0x15, 0xE); _tmp.put(0x17, 0xC); _tmp.put(0x1A, 0x16); _tmp.put(0x2A, 0x24); _tmp.put(0x1D, 0x27); _tmp.put(0x2C, 0x22);_actionTable.add(_tmp);_tmp = new HashMap<>(23);_tmp.put(0x0, 0x9); _tmp.put(0x1, 0x9); _tmp.put(0x2, 0x9); _tmp.put(0x4, 0x2E); _tmp.put(0x5, 0x30); _tmp.put(0x7, 0x9); _tmp.put(0x8, 0x1C); _tmp.put(0x9, 0x9); _tmp.put(0xA, 0x9); _tmp.put(0x2B, 0x20); _tmp.put(0x24, 0x1E); _tmp.put(0xF, 0x9); _tmp.put(0x10, 0x10); _tmp.put(0x11, 0x12); _tmp.put(0x12, 0x14); _tmp.put(0x14, 0x1A); _tmp.put(0x15, 0xE); _tmp.put(0x17, 0xC); _tmp.put(0x1A, 0x16); _tmp.put(0x2A, 0x24); _tmp.put(0x21, 0x18); _tmp.put(0x1D, 0x9); _tmp.put(0x2C, 0x22);_actionTable.add(_tmp);_tmp = new HashMap<>(9);_tmp.put(0x28, 0x26); _tmp.put(0x22, 0x2C); _tmp.put(0x1C, 0x28); _tmp.put(0x5, 0x30); _tmp.put(0x18, 0x45); _tmp.put(0x1B, 0x2E); _tmp.put(0xC, 0x2E); _tmp.put(0xD, 0x2A); _tmp.put(0xE, 0x37);_actionTable.add(_tmp);_tmp = new HashMap<>(1);_tmp.put(0x3, 0x19);_actionTable.add(_tmp);_tmp = new HashMap<>(19);_tmp.put(0x21, 0x18); _tmp.put(0x4, 0x2E); _tmp.put(0x5, 0x30); _tmp.put(0x7, 0x29); _tmp.put(0x8, 0x1C); _tmp.put(0x9, 0x29); _tmp.put(0xA, 0x29); _tmp.put(0x2B, 0x20); _tmp.put(0x24, 0x1E); _tmp.put(0x10, 0x10); _tmp.put(0x11, 0x12); _tmp.put(0x12, 0x14); _tmp.put(0x14, 0x29); _tmp.put(0x15, 0xE); _tmp.put(0x17, 0xC); _tmp.put(0x1A, 0x16); _tmp.put(0x2A, 0x24); _tmp.put(0x1D, 0x29); _tmp.put(0x2C, 0x22);_actionTable.add(_tmp);_tmp = new HashMap<>(3);_tmp.put(0x1F, 0x4F); _tmp.put(0x25, 0x55); _tmp.put(0x13, 0x3F);_actionTable.add(_tmp);_tmp = new HashMap<>(4);_tmp.put(0x29, 0x5B); _tmp.put(0x25, 0x57); _tmp.put(0x1E, 0x4B); _tmp.put(0x26, 0x59);_actionTable.add(_tmp);_tmp = new HashMap<>(2);_tmp.put(0x1E, 0x4D); _tmp.put(0x13, 0x41);_actionTable.add(_tmp);_tmp = new HashMap<>(38);_tmp.put(0x0, 0xB); _tmp.put(0x1, 0xB); _tmp.put(0x2, 0xB); _tmp.put(0x3, 0x1B); _tmp.put(0x4, 0x2E); _tmp.put(0x5, 0x30); _tmp.put(0x7, 0xB); _tmp.put(0x8, 0x1C); _tmp.put(0x9, 0xB); _tmp.put(0xA, 0xB); _tmp.put(0xB, 0x1B); _tmp.put(0xC, 0x2E); _tmp.put(0xD, 0x2A); _tmp.put(0xE, 0x39); _tmp.put(0xF, 0xB); _tmp.put(0x10, 0x10); _tmp.put(0x11, 0x12); _tmp.put(0x12, 0x14); _tmp.put(0x14, 0x1A); _tmp.put(0x15, 0xE); _tmp.put(0x16, 0x8); _tmp.put(0x17, 0xC); _tmp.put(0x18, 0x39); _tmp.put(0x19, 0x47); _tmp.put(0x1A, 0x16); _tmp.put(0x1B, 0x2E); _tmp.put(0x1C, 0x28); _tmp.put(0x1D, 0xB); _tmp.put(0x20, 0xB); _tmp.put(0x21, 0x18); _tmp.put(0x22, 0x2C); _tmp.put(0x23, 0x53); _tmp.put(0x24, 0x1E); _tmp.put(0x27, 0x6); _tmp.put(0x28, 0x26); _tmp.put(0x2A, 0x24); _tmp.put(0x2B, 0x20); _tmp.put(0x2C, 0x22);_actionTable.add(_tmp);_tmp = new HashMap<>(2);_tmp.put(0xC, 0x35); _tmp.put(0x1B, 0x49);_actionTable.add(_tmp);_tmp = new HashMap<>(36);_tmp.put(0x0, 0xD); _tmp.put(0x1, 0xD); _tmp.put(0x2, 0xD); _tmp.put(0x3, 0xD); _tmp.put(0x4, 0x2E); _tmp.put(0x5, 0x30); _tmp.put(0x7, 0xD); _tmp.put(0x8, 0x1C); _tmp.put(0x9, 0xD); _tmp.put(0xA, 0xD); _tmp.put(0xB, 0xD); _tmp.put(0xC, 0x2E); _tmp.put(0xD, 0x2A); _tmp.put(0xE, 0xD); _tmp.put(0xF, 0xD); _tmp.put(0x10, 0x10); _tmp.put(0x11, 0x12); _tmp.put(0x12, 0x14); _tmp.put(0x14, 0x1A); _tmp.put(0x15, 0xE); _tmp.put(0x16, 0x8); _tmp.put(0x17, 0xC); _tmp.put(0x18, 0xD); _tmp.put(0x1A, 0x16); _tmp.put(0x1B, 0x2E); _tmp.put(0x1C, 0x28); _tmp.put(0x1D, 0xD); _tmp.put(0x20, 0xD); _tmp.put(0x21, 0x18); _tmp.put(0x22, 0x2C); _tmp.put(0x24, 0x1E); _tmp.put(0x27, 0x6); _tmp.put(0x28, 0x26); _tmp.put(0x2A, 0x24); _tmp.put(0x2B, 0x20); _tmp.put(0x2C, 0x22);_actionTable.add(_tmp);
;_gotoTable = 
new HashMap<>(0x6);_tmp = new HashMap<>(2);_tmp.put(0xB, 0x33); _tmp.put(0x3, 0x1F);_gotoTable.put(0x18, _tmp);_tmp = new HashMap<>(1);_tmp.put(0x0, 0xF);_gotoTable.put(0x13, _tmp);_tmp = new HashMap<>(9);_tmp.put(0x0, 0x11); _tmp.put(0x1, 0x15); _tmp.put(0x2, 0x17); _tmp.put(0x14, 0x2B); _tmp.put(0x7, 0x2B); _tmp.put(0x9, 0x2B); _tmp.put(0xA, 0x2B); _tmp.put(0x1D, 0x2B); _tmp.put(0xF, 0x3D);_gotoTable.put(0x14, _tmp);_tmp = new HashMap<>(1);_tmp.put(0x16, 0x43);_gotoTable.put(0x15, _tmp);_tmp = new HashMap<>(14);_tmp.put(0x0, 0x13); _tmp.put(0x1, 0x13); _tmp.put(0x2, 0x13); _tmp.put(0x3, 0x1D); _tmp.put(0x7, 0x13); _tmp.put(0x20, 0x51); _tmp.put(0x9, 0x13); _tmp.put(0xA, 0x13); _tmp.put(0xB, 0x1D); _tmp.put(0xE, 0x3B); _tmp.put(0xF, 0x13); _tmp.put(0x14, 0x13); _tmp.put(0x18, 0x3B); _tmp.put(0x1D, 0x13);_gotoTable.put(0x16, _tmp);_tmp = new HashMap<>(5);_tmp.put(0x9, 0x2D); _tmp.put(0xA, 0x2D); _tmp.put(0x14, 0x2D); _tmp.put(0x1D, 0x2D); _tmp.put(0x7, 0x2D);_gotoTable.put(0x17, _tmp);
;_prodList = 
new ProductionItem[] {new ProductionItem(0x19, 0x2), new ProductionItem(0x13, 0x1), new ProductionItem(0x13, 0x4), new ProductionItem(0x15, 0x2), new ProductionItem(0x15, 0x0), new ProductionItem(0x14, 0x3), new ProductionItem(0x14, 0x3), new ProductionItem(0x14, 0x2), new ProductionItem(0x14, 0x2), new ProductionItem(0x14, 0x2), new ProductionItem(0x14, 0x2), new ProductionItem(0x14, 0x3), new ProductionItem(0x14, 0x4), new ProductionItem(0x14, 0x2), new ProductionItem(0x14, 0x1), new ProductionItem(0x17, 0x3), new ProductionItem(0x17, 0x4), new ProductionItem(0x17, 0x5), new ProductionItem(0x17, 0x4), new ProductionItem(0x18, 0x4), new ProductionItem(0x18, 0x2), new ProductionItem(0x18, 0x1), new ProductionItem(0x18, 0x3), new ProductionItem(0x16, 0x1), new ProductionItem(0x16, 0x1)}
;_inputTable = 
new HashMap<>(18);_inputTable.put("/", 0x2); _inputTable.put("[", 0x9); _inputTable.put(",", 0xF); _inputTable.put("]", 0xA); _inputTable.put("(", 0x4); _inputTable.put("{", 0xC); _inputTable.put("^", 0xB); _inputTable.put(")", 0x5); _inputTable.put("|", 0x3); _inputTable.put("?", 0x8); _inputTable.put("}", 0xE); _inputTable.put("escc", 0x12); _inputTable.put("+", 0x7); _inputTable.put("*", 0x6); _inputTable.put("<$>", 0x1); _inputTable.put("-", 0x11); _inputTable.put("c", 0x10); _inputTable.put("d", 0xD)
;
    }

    public Object parse(RegexLexer lexer) throws Exception {

        Deque<Integer> _stateStack = new ArrayDeque<>();
        _stateStack.push(0);

        LinkedList<Object> _outputStack = new LinkedList<>();
        int _act;
        ;

        while (true) {

            String _token = lexer.getToken();
            int _token_id = _inputTable.get(_token);
            int _state = _stateStack.peek();
            Integer _act_obj = _actionTable.get(_token_id).get(_state);

            if (_act_obj == null) {
                throw new Exception("Parse Error: " + lexer.getPositionInfo());
            } else {
                _act = _act_obj;
            }

            if (_act == 1) {
                return _outputStack.removeLast();
            } else if ((_act & 1) == 1) {
                _outputStack.add(lexer.getYYText());
                _stateStack.push((_act >>> 1) - 1);
                lexer.advance();
            } else if ((_act & 1) == 0) {
                int _pi = _act >>> 1;
                int _length = _prodList[_pi].length;
                Object _result = null;
                /** actions applying **/
                /** default action **/
                if (_length > 0) {
                    _result = _outputStack.get(_outputStack.size() - _length);
                }
                switch(_pi)
{
case 0x1:
 _result = codes; 
break;
case 0x2:
 _result = codes; 
break;
case 0x3:

                flags_c = (String) (_outputStack.get(_outputStack.size() - 1));
                if (flags.indexOf(flags_c) != -1) {
                    throw new Exception("Flag Repeated:" + lexer.getPositionInfo());
                }
                if ("igm".indexOf(flags_c) == -1) {
                    throw new Exception("Unknow Flag:" + lexer.getPositionInfo());
                }
                flags = flags + flags_c;
            
break;
case 0x4:

break;
case 0x5:
 put("or"); 
break;
case 0x6:

break;
case 0x7:

break;
case 0x8:
 put("star"); 
break;
case 0x9:
 put("more"); 
break;
case 0xA:
 put("ask");  
break;
case 0xB:
 put(new Object[]{"include", (_outputStack.get(_outputStack.size() - 2))}); 
break;
case 0xC:
 put(new Object[]{"exclude", (_outputStack.get(_outputStack.size() - 2))}); 
break;
case 0xD:
 put("cat"); 
break;
case 0xE:
 put("single"); 
break;
case 0xF:

                        _$i = (Integer)(_outputStack.get(_outputStack.size() - 2)) - 1;
                        while(_$i > 0)
                        {
                            put("dupl");
                            _$i --;
                        }
                        _$i = (Integer)(_outputStack.get(_outputStack.size() - 2)) - 1;
                        while(_$i > 0)
                        {
                            put("cat");
                            _$i --;
                        }
                    
break;
case 0x10:

                            put("ask");
                            _$i = (Integer)(_outputStack.get(_outputStack.size() - 2)) - 1;
                            while(_$i > 0)
                            {
                                put("dupl");
                                _$i --;
                            }
                            _$i = (Integer)(_outputStack.get(_outputStack.size() - 2)) - 1;
                            while(_$i > 0)
                            {
                                put("cat");
                                _$i --;
                            }
                        
break;
case 0x11:

                                _$i = (Integer)(_outputStack.get(_outputStack.size() - 4)) - 1;
                                while(_$i > 0)
                                {
                                    put("dupl");
                                    _$i --;
                                }
                                _$i = (Integer)(_outputStack.get(_outputStack.size() - 2)) - (Integer)(_outputStack.get(_outputStack.size() - 4));
                                if(_$i > 0)
                                {
                                    put("dupl");
                                    put("ask");
                                    while(_$i > 1)
                                    {
                                        put("dupl");
                                        _$i --;
                                    }
                                }
                                _$i = (Integer)(_outputStack.get(_outputStack.size() - 2)) - 1;
                                while(_$i > 0)
                                {
                                    put("cat");
                                    _$i --;
                                }
                            
break;
case 0x12:

                                _$i = (Integer)(_outputStack.get(_outputStack.size() - 3));
                                while(_$i > 0)
                                {
                                    put("dupl");
                                    _$i --;
                                }
                                put("star");
                                _$i = (Integer)(_outputStack.get(_outputStack.size() - 3));
                                while(_$i > 0)
                                {
                                    put("cat");
                                    _$i --;
                                }
                            
break;
case 0x13:
 _$i = (Integer)(_outputStack.get(_outputStack.size() - 4)); _result = _$i + 1; put(new Object[]{"c", (_outputStack.get(_outputStack.size() - 3))}); put(new Object[]{"c", (_outputStack.get(_outputStack.size() - 1))}); put("range"); 
break;
case 0x14:
 _$i = (Integer)(_outputStack.get(_outputStack.size() - 2)); _result = _$i + 1; put("single"); 
break;
case 0x15:
 put("single"); _result = 1; 
break;
case 0x16:
 put(new Object[]{"c", (_outputStack.get(_outputStack.size() - 3))}); put(new Object[]{"c", (_outputStack.get(_outputStack.size() - 1))}); put("range"); _result = 1; 
break;
case 0x17:
 put(new Object[]{"c", (_outputStack.get(_outputStack.size() - 1))}); 
break;
case 0x18:
 put(new Object[]{"escc", (_outputStack.get(_outputStack.size() - 1))}); 
break;
}
                /** actions applying end **/
                int _i = 0;
                while (_i < _length) {
                    _stateStack.pop();
                    _outputStack.removeLast();
                    _i ++;
                }
                _state = _stateStack.peek();
                _act_obj = _gotoTable.get(_prodList[_pi].id).get(_state);
                if (_act_obj == null) {
                    throw new Exception("Goto Error!" + lexer.getPositionInfo());
                } else {
                    _act = _act_obj;
                }

                _stateStack.push((_act >>> 1) - 1);
                _outputStack.add(_result);
            }
        }
    }

    public static Object parse(String source) throws Exception {
        RegexLexer lexer = new RegexLexer();
        lexer.setSource(source);
        RegexParser parser = new RegexParser();
        Object result = parser.parse(lexer);
        return result;
    }

    public static final class ProductionItem {
        public final int id;
        public final int length;
        public ProductionItem(int id, int length) {
            this.id = id;
            this.length = length;
        }
    }
}
