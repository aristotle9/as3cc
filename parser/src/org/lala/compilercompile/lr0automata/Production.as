package org.lala.compilercompile.lr0automata
{
    import org.lala.compilercompile.interfaces.INonTerminal;
    import org.lala.compilercompile.interfaces.IProduction;
    import org.lala.compilercompile.interfaces.ISymbol;
    
    public class Production implements IProduction
    {
        protected var _id:uint;
        protected var _preced:uint=0;
        protected var _assoc:uint=2;//none assoc
        protected var _left:INonTerminal;
        protected var _right:Vector.<ISymbol>;
        protected var _preLength:uint;
        
        public function Production(id:uint,left:INonTerminal)
        {
            _id = id;
            _left = left;
            _right = new Vector.<ISymbol>;
        }
        
        public function get preLength():uint
        {
            return _preLength;
        }

        public function set preLength(value:uint):void
        {
            _preLength = value;
        }

        public function get id():uint
        {
            return _id;
        }
        
        public function get size():uint
        {
            return right.length;
        }
        
        public function get left():INonTerminal
        {
            return _left;
        }
        
        public function get right():Vector.<ISymbol>
        {
            return _right;
        }
        
        public function contains(symbol:ISymbol):Boolean
        {
            return _right.indexOf(symbol) != -1;
        }

        public function get preced():uint
        {
            return _preced;
        }

        public function set preced(value:uint):void
        {
            _preced = value;
        }

        public function get assoc():uint
        {
            return _assoc;
        }

        public function set assoc(value:uint):void
        {
            _assoc = value;
        }


    }
}