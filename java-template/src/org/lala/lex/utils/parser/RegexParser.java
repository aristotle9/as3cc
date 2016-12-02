package    org.lala.lex.utils.parser;

import java.util.*;

/**
 * Created by as3cc on Mon Nov 28 14:49:04 GMT+0800 2016.
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
;

    public RegexParser() {
        Map<Integer, Integer> _tmp;
_actionTable = 
new ArrayList<Map<Integer, Integer>>(18);_actionTable.add(null);_tmp = new HashMap<>(18);_tmp.put(0x20, 0x18); _tmp.put(0x26, 0x1A); _tmp.put(0x3, 0x28); _tmp.put(0x4, 0x2A); _tmp.put(0x5, 0x1); _tmp.put(0x6, 0x2); _tmp.put(0x7, 0x16); _tmp.put(0x25, 0x1E); _tmp.put(0xE, 0xA); _tmp.put(0xF, 0xC); _tmp.put(0x10, 0xE); _tmp.put(0x12, 0x14); _tmp.put(0x13, 0x8); _tmp.put(0x14, 0x6); _tmp.put(0x17, 0x10); _tmp.put(0x27, 0x1C); _tmp.put(0x1A, 0x4); _tmp.put(0x1D, 0x12);_actionTable.add(_tmp);_tmp = new HashMap<>(18);_tmp.put(0x20, 0x18); _tmp.put(0x26, 0x1A); _tmp.put(0x3, 0x28); _tmp.put(0x4, 0x2A); _tmp.put(0x25, 0x1E); _tmp.put(0x6, 0x1D); _tmp.put(0x7, 0x16); _tmp.put(0x8, 0x1D); _tmp.put(0xE, 0xA); _tmp.put(0xF, 0xC); _tmp.put(0x10, 0xE); _tmp.put(0x12, 0x14); _tmp.put(0x13, 0x8); _tmp.put(0x14, 0x6); _tmp.put(0x17, 0x10); _tmp.put(0x27, 0x1C); _tmp.put(0x1A, 0x4); _tmp.put(0x1D, 0x12);_actionTable.add(_tmp);_tmp = new HashMap<>(21);_tmp.put(0x0, 0x5); _tmp.put(0x1, 0x5); _tmp.put(0x3, 0x28); _tmp.put(0x4, 0x2A); _tmp.put(0x25, 0x1E); _tmp.put(0x6, 0x5); _tmp.put(0x7, 0x16); _tmp.put(0x8, 0x5); _tmp.put(0x26, 0x1A); _tmp.put(0xD, 0x5); _tmp.put(0xE, 0xA); _tmp.put(0xF, 0xC); _tmp.put(0x10, 0xE); _tmp.put(0x20, 0x18); _tmp.put(0x12, 0x14); _tmp.put(0x13, 0x8); _tmp.put(0x14, 0x6); _tmp.put(0x17, 0x10); _tmp.put(0x27, 0x1C); _tmp.put(0x1A, 0x5); _tmp.put(0x1D, 0x12);_actionTable.add(_tmp);_tmp = new HashMap<>(17);_tmp.put(0x20, 0x18); _tmp.put(0x3, 0x28); _tmp.put(0x4, 0x2A); _tmp.put(0x25, 0x1E); _tmp.put(0x26, 0x1A); _tmp.put(0x7, 0x16); _tmp.put(0x8, 0x2B); _tmp.put(0xE, 0xA); _tmp.put(0xF, 0xC); _tmp.put(0x10, 0xE); _tmp.put(0x12, 0x14); _tmp.put(0x13, 0x8); _tmp.put(0x14, 0x6); _tmp.put(0x17, 0x10); _tmp.put(0x27, 0x1C); _tmp.put(0x1A, 0x4); _tmp.put(0x1D, 0x12);_actionTable.add(_tmp);_tmp = new HashMap<>(18);_tmp.put(0x20, 0x18); _tmp.put(0x26, 0x1A); _tmp.put(0x3, 0x28); _tmp.put(0x4, 0x2A); _tmp.put(0x25, 0x1E); _tmp.put(0x6, 0x1F); _tmp.put(0x7, 0x16); _tmp.put(0x8, 0x1F); _tmp.put(0xE, 0xA); _tmp.put(0xF, 0xC); _tmp.put(0x10, 0xE); _tmp.put(0x12, 0x1F); _tmp.put(0x13, 0x8); _tmp.put(0x14, 0x6); _tmp.put(0x17, 0x10); _tmp.put(0x27, 0x1C); _tmp.put(0x1A, 0x1F); _tmp.put(0x1D, 0x12);_actionTable.add(_tmp);_tmp = new HashMap<>(18);_tmp.put(0x20, 0x18); _tmp.put(0x26, 0x1A); _tmp.put(0x3, 0x28); _tmp.put(0x4, 0x2A); _tmp.put(0x25, 0x1E); _tmp.put(0x6, 0x21); _tmp.put(0x7, 0x16); _tmp.put(0x8, 0x21); _tmp.put(0xE, 0xA); _tmp.put(0xF, 0xC); _tmp.put(0x10, 0xE); _tmp.put(0x12, 0x21); _tmp.put(0x13, 0x8); _tmp.put(0x14, 0x6); _tmp.put(0x17, 0x10); _tmp.put(0x27, 0x1C); _tmp.put(0x1A, 0x21); _tmp.put(0x1D, 0x12);_actionTable.add(_tmp);_tmp = new HashMap<>(18);_tmp.put(0x20, 0x18); _tmp.put(0x26, 0x1A); _tmp.put(0x3, 0x28); _tmp.put(0x4, 0x2A); _tmp.put(0x25, 0x1E); _tmp.put(0x6, 0x23); _tmp.put(0x7, 0x16); _tmp.put(0x8, 0x23); _tmp.put(0xE, 0xA); _tmp.put(0xF, 0xC); _tmp.put(0x10, 0xE); _tmp.put(0x12, 0x23); _tmp.put(0x13, 0x8); _tmp.put(0x14, 0x6); _tmp.put(0x17, 0x10); _tmp.put(0x27, 0x1C); _tmp.put(0x1A, 0x23); _tmp.put(0x1D, 0x12);_actionTable.add(_tmp);_tmp = new HashMap<>(21);_tmp.put(0x0, 0x7); _tmp.put(0x1, 0x7); _tmp.put(0x3, 0x28); _tmp.put(0x4, 0x2A); _tmp.put(0x25, 0x1E); _tmp.put(0x6, 0x7); _tmp.put(0x7, 0x16); _tmp.put(0x8, 0x7); _tmp.put(0x26, 0x1A); _tmp.put(0xD, 0x7); _tmp.put(0xE, 0xA); _tmp.put(0xF, 0xC); _tmp.put(0x10, 0xE); _tmp.put(0x20, 0x18); _tmp.put(0x12, 0x14); _tmp.put(0x13, 0x8); _tmp.put(0x14, 0x6); _tmp.put(0x17, 0x10); _tmp.put(0x27, 0x1C); _tmp.put(0x1A, 0x7); _tmp.put(0x1D, 0x12);_actionTable.add(_tmp);_tmp = new HashMap<>(9);_tmp.put(0x23, 0x20); _tmp.put(0x4, 0x2A); _tmp.put(0x15, 0x3D); _tmp.put(0x18, 0x28); _tmp.put(0x19, 0x22); _tmp.put(0xA, 0x28); _tmp.put(0xB, 0x31); _tmp.put(0xC, 0x24); _tmp.put(0x1E, 0x26);_actionTable.add(_tmp);_tmp = new HashMap<>(1);_tmp.put(0x2, 0x15);_actionTable.add(_tmp);_tmp = new HashMap<>(18);_tmp.put(0x20, 0x18); _tmp.put(0x26, 0x1A); _tmp.put(0x3, 0x28); _tmp.put(0x4, 0x2A); _tmp.put(0x25, 0x1E); _tmp.put(0x6, 0x25); _tmp.put(0x7, 0x16); _tmp.put(0x8, 0x25); _tmp.put(0xE, 0xA); _tmp.put(0xF, 0xC); _tmp.put(0x10, 0xE); _tmp.put(0x12, 0x25); _tmp.put(0x13, 0x8); _tmp.put(0x14, 0x6); _tmp.put(0x17, 0x10); _tmp.put(0x27, 0x1C); _tmp.put(0x1A, 0x25); _tmp.put(0x1D, 0x12);_actionTable.add(_tmp);_tmp = new HashMap<>(3);_tmp.put(0x1C, 0x47); _tmp.put(0x11, 0x39); _tmp.put(0x21, 0x4B);_actionTable.add(_tmp);_tmp = new HashMap<>(4);_tmp.put(0x21, 0x4D); _tmp.put(0x22, 0x4F); _tmp.put(0x1B, 0x43); _tmp.put(0x24, 0x51);_actionTable.add(_tmp);_tmp = new HashMap<>(2);_tmp.put(0x11, 0x3B); _tmp.put(0x1B, 0x45);_actionTable.add(_tmp);_tmp = new HashMap<>(33);_tmp.put(0x0, 0x9); _tmp.put(0x1, 0x9); _tmp.put(0x2, 0x17); _tmp.put(0x3, 0x28); _tmp.put(0x4, 0x2A); _tmp.put(0x6, 0x9); _tmp.put(0x7, 0x16); _tmp.put(0x8, 0x9); _tmp.put(0x9, 0x17); _tmp.put(0xA, 0x28); _tmp.put(0xB, 0x33); _tmp.put(0xC, 0x24); _tmp.put(0xD, 0x9); _tmp.put(0xE, 0xA); _tmp.put(0xF, 0xC); _tmp.put(0x10, 0xE); _tmp.put(0x12, 0x14); _tmp.put(0x13, 0x8); _tmp.put(0x14, 0x6); _tmp.put(0x15, 0x33); _tmp.put(0x16, 0x3F); _tmp.put(0x17, 0x10); _tmp.put(0x18, 0x28); _tmp.put(0x19, 0x22); _tmp.put(0x1A, 0x9); _tmp.put(0x1D, 0x12); _tmp.put(0x1E, 0x26); _tmp.put(0x1F, 0x49); _tmp.put(0x20, 0x18); _tmp.put(0x23, 0x20); _tmp.put(0x25, 0x1E); _tmp.put(0x26, 0x1A); _tmp.put(0x27, 0x1C);_actionTable.add(_tmp);_tmp = new HashMap<>(2);_tmp.put(0x18, 0x41); _tmp.put(0xA, 0x2F);_actionTable.add(_tmp);_tmp = new HashMap<>(31);_tmp.put(0x0, 0xB); _tmp.put(0x1, 0xB); _tmp.put(0x2, 0xB); _tmp.put(0x3, 0x28); _tmp.put(0x4, 0x2A); _tmp.put(0x6, 0xB); _tmp.put(0x7, 0x16); _tmp.put(0x8, 0xB); _tmp.put(0x9, 0xB); _tmp.put(0xA, 0x28); _tmp.put(0xB, 0xB); _tmp.put(0xC, 0x24); _tmp.put(0xD, 0xB); _tmp.put(0xE, 0xA); _tmp.put(0xF, 0xC); _tmp.put(0x10, 0xE); _tmp.put(0x12, 0x14); _tmp.put(0x13, 0x8); _tmp.put(0x14, 0x6); _tmp.put(0x15, 0xB); _tmp.put(0x17, 0x10); _tmp.put(0x18, 0x28); _tmp.put(0x19, 0x22); _tmp.put(0x1A, 0xB); _tmp.put(0x1D, 0x12); _tmp.put(0x1E, 0x26); _tmp.put(0x20, 0x18); _tmp.put(0x23, 0x20); _tmp.put(0x25, 0x1E); _tmp.put(0x26, 0x1A); _tmp.put(0x27, 0x1C);_actionTable.add(_tmp);
;_gotoTable = 
new HashMap<>(0x5);_tmp = new HashMap<>(1);_tmp.put(0x0, 0xD);_gotoTable.put(0x12, _tmp);_tmp = new HashMap<>(7);_tmp.put(0x0, 0xF); _tmp.put(0x1, 0x13); _tmp.put(0x12, 0x27); _tmp.put(0x6, 0x27); _tmp.put(0x8, 0x27); _tmp.put(0x1A, 0x27); _tmp.put(0xD, 0x37);_gotoTable.put(0x13, _tmp);_tmp = new HashMap<>(4);_tmp.put(0x8, 0x29); _tmp.put(0x12, 0x29); _tmp.put(0x1A, 0x29); _tmp.put(0x6, 0x29);_gotoTable.put(0x14, _tmp);_tmp = new HashMap<>(2);_tmp.put(0x9, 0x2D); _tmp.put(0x2, 0x19);_gotoTable.put(0x15, _tmp);_tmp = new HashMap<>(11);_tmp.put(0x0, 0x11); _tmp.put(0x1, 0x11); _tmp.put(0x2, 0x1B); _tmp.put(0x15, 0x35); _tmp.put(0x6, 0x11); _tmp.put(0x8, 0x11); _tmp.put(0x9, 0x1B); _tmp.put(0x12, 0x11); _tmp.put(0xB, 0x35); _tmp.put(0x1A, 0x11); _tmp.put(0xD, 0x11);_gotoTable.put(0x16, _tmp);
;_prodList = 
new ProductionItem[] {new ProductionItem(0x17, 0x2), new ProductionItem(0x12, 0x1), new ProductionItem(0x13, 0x3), new ProductionItem(0x13, 0x3), new ProductionItem(0x13, 0x2), new ProductionItem(0x13, 0x2), new ProductionItem(0x13, 0x2), new ProductionItem(0x13, 0x2), new ProductionItem(0x13, 0x3), new ProductionItem(0x13, 0x4), new ProductionItem(0x13, 0x2), new ProductionItem(0x13, 0x1), new ProductionItem(0x14, 0x3), new ProductionItem(0x14, 0x4), new ProductionItem(0x14, 0x5), new ProductionItem(0x14, 0x4), new ProductionItem(0x15, 0x4), new ProductionItem(0x15, 0x2), new ProductionItem(0x15, 0x1), new ProductionItem(0x15, 0x3), new ProductionItem(0x16, 0x1), new ProductionItem(0x16, 0x1)}
;_inputTable = 
new HashMap<>(17);_inputTable.put("[", 0x8); _inputTable.put(",", 0xE); _inputTable.put("]", 0x9); _inputTable.put("(", 0x3); _inputTable.put("{", 0xB); _inputTable.put("^", 0xA); _inputTable.put(")", 0x4); _inputTable.put("|", 0x2); _inputTable.put("?", 0x7); _inputTable.put("}", 0xD); _inputTable.put("+", 0x6); _inputTable.put("*", 0x5); _inputTable.put("<$>", 0x1); _inputTable.put("-", 0x10); _inputTable.put("c", 0xF); _inputTable.put("escc", 0x11); _inputTable.put("d", 0xC)
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
 put("or"); 
break;
case 0x3:

break;
case 0x4:

break;
case 0x5:
 put("star"); 
break;
case 0x6:
 put("more"); 
break;
case 0x7:
 put("ask");  
break;
case 0x8:
 put(new Object[]{"include", (_outputStack.get(_outputStack.size() - 2))}); 
break;
case 0x9:
 put(new Object[]{"exclude", (_outputStack.get(_outputStack.size() - 2))}); 
break;
case 0xA:
 put("cat"); 
break;
case 0xB:
 put("single"); 
break;
case 0xC:

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
case 0xD:

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
case 0xE:

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
case 0xF:

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
case 0x10:
 _$i = (Integer)(_outputStack.get(_outputStack.size() - 4)); _result = _$i + 1; put(new Object[]{"c", (_outputStack.get(_outputStack.size() - 3))}); put(new Object[]{"c", (_outputStack.get(_outputStack.size() - 1))}); put("range"); 
break;
case 0x11:
 _$i = (Integer)(_outputStack.get(_outputStack.size() - 2)); _result = _$i + 1; put("single"); 
break;
case 0x12:
 put("single"); _result = 1; 
break;
case 0x13:
 put(new Object[]{"c", (_outputStack.get(_outputStack.size() - 3))}); put(new Object[]{"c", (_outputStack.get(_outputStack.size() - 1))}); put("range"); _result = 1; 
break;
case 0x14:
 put(new Object[]{"c", (_outputStack.get(_outputStack.size() - 1))}); 
break;
case 0x15:
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
