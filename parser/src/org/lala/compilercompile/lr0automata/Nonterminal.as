package org.lala.compilercompile.lr0automata
{
    import org.lala.compilercompile.interfaces.INonTerminal;
    import org.lala.compilercompile.interfaces.IProduction;
    
    public class Nonterminal implements INonTerminal
    {
        protected var _isNullable:Boolean = false;
        protected var _id:uint;
        protected var _text:String;
        protected var _isTerminal:Boolean = false;
        protected var _productions:Vector.<IProduction>;
        
        public function Nonterminal(id:uint, text:String)
        {
            _id = id;
            _text = text;
            _productions = new Vector.<IProduction>;
        }
        
        public function get isNullable():Boolean
        {
            return _isNullable;
        }
        
        public function set isNullable(value:Boolean):void
        {
            _isNullable = value;
        }
        
        public function eachProduction(foo:Function):void
        {
            _productions.some(function(p:IProduction, ... args):Boolean
            {
                return foo(p);
            });
        }
        
        public function get productions():Vector.<IProduction>
        {
            return _productions;
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
        
        public function get preced():uint
        {
            return 0;
        }
        
        public function get assoc():uint
        {
            return 0;
        }
    }
}