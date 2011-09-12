package org.lala.compilercompile.lr0automata
{
    import org.lala.compilercompile.interfaces.INonTerminal;
    import org.lala.compilercompile.interfaces.IProduction;
    import org.lala.compilercompile.interfaces.IProductions;
    import org.lala.compilercompile.interfaces.ISymbol;
    import org.lala.compilercompile.interfaces.ISymbols;
    
    public class Productions implements IProductions
    {
        protected var _index:uint;
        protected var _list:Vector.<IProduction>;
        protected var _symbols:ISymbols;
        //记录总长度,在计算项的id时必须要设置正确的id
        protected var _totleLength:uint;
        
        public function Productions()
        {
            _symbols = new Symbols;
            _list = new Vector.<IProduction>;
            _index = 0;
        }
        
        public function createProduction(left:String, ...right):IProduction
        {
            var l:INonTerminal = _symbols.getSymbol(left) as INonTerminal;
            var p:IProduction = new Production(_index ++, l);
            if(right.length == 1 && _symbols.getSymbol(right[0]) == Symbols.epsilon)
            {
                //empty
            }
            else
            {
                for(var i:uint = 0; i < right.length; i ++)
                {
                    var sm:ISymbol = _symbols.getSymbol(right[i]); 
                    p.right.push(sm);
                    if(sm.isTerminal)
                    {
                        if(p.preced <= sm.preced)
                        {
                            p.preced = sm.preced;
                            p.assoc = sm.assoc;
                        }
                    }
                }
            }
            p.preLength = _totleLength;
            l.productions.push(p);
            _list.push(p);
            //项比产生式的长度多一个点
            _totleLength += p.right.length + 1;
            return p;
        }
        
        public function eachProduction(foo:Function):void
        {
            _list.some(function(p:IProduction, ... args):Boolean
            {
                return foo(p);
            });
        }
        
        public function get symbols():ISymbols
        {
            return _symbols;
        }
        
        public function get totleLength():uint
        {
            return _totleLength;
        }
        
        public function getProduction(index:uint):IProduction
        {
            return _list[index];
        }
        
        public function get size():uint
        {
            return _index;
        }
    }
}