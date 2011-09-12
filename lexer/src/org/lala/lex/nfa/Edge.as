package org.lala.lex.nfa
{
    import org.lala.lex.interfaces.IEdge;
    import org.lala.lex.interfaces.IInput;
    import org.lala.lex.interfaces.IState;
    
    public class Edge implements IEdge
    {
        private var _from:IState;
        private var _to:IState;
        private var _input:IInput;
        
        public function Edge(from:IState, ipt:IInput, to:IState)
        {
            _from = from;
            _input = ipt;
            _to = to;
        }
        
        public function get input():IInput
        {
            return _input;
        }
        
        public function get from():IState
        {
            return _from;
        }
        
        public function get to():IState
        {
            return _to;
        }
    }
}