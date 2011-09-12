package org.lala.compilercompile.lr0automata
{
    import org.lala.compilercompile.interfaces.ISymbol;
    /** 终结符专用 **/
    public class Symbol implements ISymbol
    {
        protected var _isTerminal:Boolean;
        protected var _isNullable:Boolean;
        protected var _text:String;
        protected var _id:uint;
        protected var _preced:uint;
        protected var _assoc:uint;
        
        public function Symbol(id:uint, text:String, isTerminal:Boolean=true, isNullable:Boolean=false, preced:uint=0, assoc:uint=0)
        {
            _id = id;
            _text = text;
            _preced = preced;
            _assoc = assoc;
            _isTerminal = isTerminal;
            _isNullable = isNullable;
        }
        
        public function get isTerminal():Boolean
        {
            return _isTerminal;
        }
        
        public function get text():String
        {
            return _text;
        }
        
        public function get id():uint
        {
            return _id;
        }

        public function get isNullable():Boolean
        {
            return _isNullable;
        }

        public function set isNullable(value:Boolean):void
        {
            _isNullable = value;
        }

        public function get preced():uint
        {
            return _preced;
        }

        public function get assoc():uint
        {
            return _assoc;
        }


    }
}