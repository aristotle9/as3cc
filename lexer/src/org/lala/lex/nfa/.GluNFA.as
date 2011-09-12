package org.lala.lex.nfa
{
    import mx.collections.ArrayCollection;

    /** Glushkov **/
    public class GluNFA
    {
        private var _inputs:ArrayCollection;
        private var _states:ArrayCollection;
        private var _entry:NFAState;
        private var _exits:ArrayCollection;
        public function GluNFA()
        {
            _inputs = new ArrayCollection;
            _states = new ArrayCollection;
            _exits = new ArrayCollection;
        }
        
        public function addState(state:NFAState):void
        {
            _states.addItem(state);
        }
        
        public function addInput(input:String):void
        {
            _inputs.addItem(input);
        }
        
        public function removeState(s:NFAState):void
        {
            if(_states.contains(s))
            {
                _states.removeItemAt(_states.getItemIndex(s));
            }
            if(hasExit(s))
                removeExits(s);
        }
        
        public function merge(nfa:GluNFA):void
        {
            _inputs.addAll(nfa.inputs);//因为regex中相同的char是不同的对象,所以会产生不同的实例
            _states.addAll(nfa.states);
        }
        
        public function get entry():NFAState
        {
            return _entry;
        }
        
        public function set entry(value:NFAState):void
        {
            _entry = value;
        }
        
        public function hasExit(s:NFAState):Boolean
        {
            return _exits.contains(s);
        }
        
        public function addExits(s:NFAState):void
        {
            _exits.addItem(s);
        }
        
        public function removeExits(s:NFAState):void
        {
            _exits.removeItemAt(_exits.getItemIndex(s));
        }
        
        public function get exits():ArrayCollection
        {
            return _exits;
        }
        
        public function get inputs():ArrayCollection
        {
            return _inputs;
        }
        
        public function get states():ArrayCollection
        {
            return _states;
        }
        /** 不要作删除动作 **/
        public function everyState(foo:Function):void
        {
            for each(var s:NFAState in _states)
            {
                if(foo(s))
                    break;
            }
        }
    }
}