package org.lala.compilercompile.utils
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
import java.util.*;
<{ imports }>
/**
 * Created by as3cc on <{ create_date }>.
 */
public class <{ class }> {
    private List<Map<Integer, Integer>> _actionTable;
    private Map<Integer, Map<Integer, Integer>> _gotoTable;
    private ProductionItem[] _prodList;
    private Map<String, Integer> _inputTable;
    <{ usercode }>
    public <{ class }>() {
        <{ tables }>
    }

    public Object parse(<{ lexerName }> lexer) throws Exception {

        Deque<Integer> _stateStack = new ArrayDeque<>();
        _stateStack.push(0);

        LinkedList<Object> _outputStack = new LinkedList<>();
        int _act;
        <{ initial }>
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
                int _length = _prodList[_pi].body_length;
                Object _result = null;
                /** actions applying **/
                /** default action **/
                if (_length > 0) {
                    _result = _outputStack.get(_outputStack.size() - _length);
                }
                <{ actions }>
                /** actions applying end **/
                int _i = 0;
                while (_i < _length) {
                    _stateStack.pop();
                    _outputStack.removeLast();
                    _i ++;
                }
                _state = _stateStack.peek();
                _act_obj = _gotoTable.get(_prodList[_pi].header_id).get(_state);
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
        <{ lexerName }> lexer = new <{ lexerName }>();
        lexer.setSource(source);
        <{ class }> parser = new <{ class }>();
        Object result = parser.parse(lexer);
        return result;
    }

    public static final class ProductionItem {
        public final int header_id;
        public final int body_length;
        public ProductionItem(int header_id, int body_length) {
            this.header_id = header_id;
            this.body_length = body_length;
        }
    }
}
]]></r>);
    }
}