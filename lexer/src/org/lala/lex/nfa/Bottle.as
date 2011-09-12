package org.lala.lex.nfa
{
    import org.lala.lex.interfaces.IBottle;
    import org.lala.lex.interfaces.IPairs;
    import org.lala.lex.interfaces.IState;
    
    public class Bottle implements IBottle
    {
        private var _start:uint;
        private var _id:uint;
        
        public function Bottle(id:uint)
        {
            _id = id;
        }
        
        public function get start():uint
        {
            return _start;
        }
        
        public function set start(value:uint):void
        {
            _start = value;
        }
        
        public function get id():uint
        {
            return _id;
        }
        
        public function get pairs():Vector.<IPairs>
        {
            return null;
        }
        
        public function add(P:IPairs):void
        {
        }
        
        public function result():String
        {
            return null;
        }
    }
}