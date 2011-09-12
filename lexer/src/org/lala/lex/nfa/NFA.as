package org.lala.lex.nfa
{
    import org.lala.lex.interfaces.IEdge;
    import org.lala.lex.interfaces.IInputSet;
    import org.lala.lex.interfaces.INFA;
    import org.lala.lex.interfaces.ISet;
    import org.lala.lex.interfaces.IState;
    
    public class NFA implements INFA
    {
        private var _entry:IState;
        private var _exits:Set;
        private var _states:Set;
        private var _bottleSize:uint;
        private var _inputSet:IInputSet;
        
        public function NFA()
        {
            _exits = new Set;
            _states = new Set;
        }
        
        public function get entry():IState
        {
            return _entry;
        }
        
        public function set entry(s:IState):void
        {
            _entry = s;
        }
        
        public function get exits():ISet
        {
            return _exits;
        }
        
        public function get states():ISet
        {
            return _states;
        }
        
        public function get inputSet():IInputSet
        {
            return _inputSet;
        }
        
        public function set inputSet(value:IInputSet):void
        {
            _inputSet = value;
        }
        
        public function addState(s:IState):void
        {
            _states.add(s);
        }
        
        public function removeState(s:IState):void
        {
            //移除与该状态相关的状态
            var out:ISet = s.outEdges;
            out.every(function(e:IEdge):Boolean
            {
                e.to.inEdges.remove(e);
                return false;
            });
            var inedge:ISet = s.inEdges;
            inedge.every(function(e:IEdge):Boolean
            {
                e.from.outEdges.remove(e);
                return false;
            });
            //该状态与到该状态的边,从该状态发出的边一同失去引用
            _states.remove(s);
        }
        
        public function hasExit(s:IState):Boolean
        {
            return _exits.contains(s);
        }
        
        public function addExit(s:IState):void
        {
            s.final = true;
            _exits.add(s);
        }
        
        public function removeExit(s:IState):void
        {
            s.final = false;
            _exits.remove(s);
        }

        public function get bottleSize():uint
        {
            return _bottleSize;
        }

        public function set bottleSize(value:uint):void
        {
            _bottleSize = value;
        }

    }
}