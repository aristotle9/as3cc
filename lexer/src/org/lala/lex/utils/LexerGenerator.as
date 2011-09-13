package org.lala.lex.utils
{
    import flash.utils.ByteArray;
    
    import org.lala.lex.interfaces.IInput;
    import org.lala.lex.interfaces.INFA;
    import org.lala.lex.nfa.InputSet;

    public class LexerGenerator
    {
        private var _config:Object;
        private var _done:Boolean;
        
        private var _dfa:INFA;
        private var _byte:ByteArray;
        
        public function LexerGenerator(conf:Object)
        {
            this._config = conf;
            _done = false;
        }
        
        public function generate():void
        {
            if(!_done)
            {
                createLexDFA();
                createTables();
                _done = true;
            }
        }
        
        private function createLexDFA():void
        {
            var nfa:INFA;
            nfa = RegexUtil.CREATE_NFA(_config.lexer.rules, 0, 0xffff, _config.lexer.states);
            nfa = RegexUtil.NFA_DFA(nfa);
            this._dfa = NFAUtil.min_dfa(nfa, true);
        }
        
        private function createTables():void
        {
            /** 未压缩的转换表 **/
            var stateTable:Array = RegexUtil.DFA_TABLE(_dfa); 
            /** [压缩的转换表,输入的等价表] **/
            var result1:Array = RegexUtil.INPUT_COMPRESS(stateTable);
            /** 最终状态到表达式ID的映射 **/
            var finalStates:Array = RegexUtil.FINAL_STATES(_dfa);
            /** 输入的等价表 **/
            var inputTable:Array = result1[1];
            /** 把输入的等价ID写到输入集上,inputSet.inputTable()才有效 **/
            _dfa.inputSet.every(function(ipt:IInput):Boolean
            {
                if(ipt != InputSet.E)
                {
                    ipt.compressed = inputTable[ipt.id];
                }
                return false;
            });
            /** 起始状态(字符串)到输入ID的转换表 **/
            var statesInputTable:Object = RegexUtil.DFA_INPUT_STATES(_dfa);
            /** 压缩 [压缩的转换表,最终状态表,从字符编码到输入的等价ID的表,起始状态表] **/
            _byte = RegexUtil.TABLES_COMPRESS(result1[0], finalStates, _dfa.inputSet.inputTable(), statesInputTable);
        }
        
        public function get tableBytes():ByteArray
        {
            if(_done)
                return _byte;
            else
                throw new Error("转换未进行.");
        }
        
        public function get actionString():String
        {
            return RegexUtil.ACTION_FILE(_config);
        }
        
        public function get dotString():String
        {
            return RegexUtil.nfa_dot(_dfa);
        }
    }
}