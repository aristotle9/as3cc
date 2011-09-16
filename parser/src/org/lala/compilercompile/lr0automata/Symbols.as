package org.lala.compilercompile.lr0automata
{
    import org.lala.compilercompile.interfaces.ISymbol;
    import org.lala.compilercompile.interfaces.ISymbols;
    
    public class Symbols implements ISymbols
    {
        public static const epsilon:ISymbol = new Symbol(0, "epsilon", true, true);
        public static const end:ISymbol = new Symbol(1, "<$>", true);
        protected var _table:Object;
        protected var _list:Array;
        protected var _index:uint;
        public function Symbols()
        {
            _index = 2;
            _table = {
                '<e>':epsilon,
                '<$>':end
            };
            _list = [epsilon, end];
        }
        
        public function defineSymbol(text:String, ter:Boolean, preced:uint=0, assoc:String='nonassoc'):ISymbol
        {
            if(_table[text] != null)
            {
                throw new Error("符号定义重复:" + text);
            }
            return createSymbol(text, ter, preced, assoc);
        }
        
        public function getSymbol(text:String):ISymbol
        {
            if(_table[text] != null)
            {
                return _table[text] as ISymbol;
            }
            return null;
        }
        
        protected function createSymbol(text:String, ter:Boolean, preced:uint=0, assoc:String='nonassoc'):ISymbol
        {
//            var ter:Boolean = false;
//            var fc:String = text.charAt();
//            if(fc == "'" || fc == '"' || fc == '<' || fc == fc.toLowerCase())
//            {
//                ter = true;
//            }
            if(ter)
                var sb:ISymbol = new Symbol(_index ++, text, ter, false, preced, assoc);
            else
                sb = new Nonterminal(_index ++, text);
            _table[text] = sb;
            _list.push(sb);
            return sb;
        }
        
        public function eachNonterminal(foo:Function):void
        {
            _list.some(function(sm:ISymbol, ... args):Boolean
            {
                if(!sm.isTerminal)
                    return foo(sm);
                return false;
            });
        }
        
        public function eachTerminal(foo:Function):void
        {
            _list.some(function(sm:ISymbol, ... args):Boolean
            {
                if(sm.isTerminal)
                    return foo(sm);
                return false;
            });
        }
        
        public function eachSymbol(foo:Function):void
        {
            _list.some(function(sm:ISymbol, ... args):Boolean
            {
                return foo(sm);
            });
        }
        
        public function get size():uint
        {
            return _index;
        }
    }
}