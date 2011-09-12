package org.lala.compilercompile.lr0automata
{
    import org.lala.compilercompile.interfaces.IItem;
    import org.lala.compilercompile.interfaces.IItemSet;
    import org.lala.compilercompile.interfaces.INonTerminal;
    import org.lala.compilercompile.interfaces.IProductions;
    import org.lala.compilercompile.utils.BaseFFFF;
    
    public class ItemSet implements IItemSet
    {
        protected var _data:Object;
        protected var _size:uint;
        protected var _tag:BaseFFFF;
        protected var _produnctions:IProductions;
        protected var _table:Object;
        protected var _closure:IItemSet;
        
        public function ItemSet(ps:IProductions)
        {
            _produnctions = ps;
            _tag = new BaseFFFF(Math.floor(ps.totleLength / 16) + 1);
            _table = new Object;
        }
        
        public function get tag():String
        {
            return _tag.toString();
        }
        
        public function get size():uint
        {
            return _size;
        }
        
        public function get data():Object
        {
            return _data;
        }
        
        public function set data(value:Object):void
        {
            _data = value;
        }
        
        public function contains(itm:IItem):Boolean
        {
            return _table[itm.id] != null;
        }
        
        public function add(itm:IItem):void
        {
            if(!contains(itm))
            {
                _size ++;
                _tag.add(itm.id);
                _table[itm.id] = itm;
            }
        }
        
        public function get closure():IItemSet
        {
            if(_closure)
                return _closure;
            _closure = new ItemSet(_produnctions);
            var tmp:Vector.<IItem> = new Vector.<IItem>;
            eachItem(function(itm:IItem):Boolean
            {
                _closure.add(itm);
                tmp.push(itm);
                return false;
            });
            for(var i:uint = 0; i < tmp.length; i ++)
            {
                var itm:IItem = tmp[i];
                if(itm.nextSymbol != null && itm.nextSymbol.isTerminal == false)
                {
                    var n:INonTerminal = itm.nextSymbol as INonTerminal;
                    for(var j:uint = 0; j < n.productions.length; j ++)
                    {
                        var nitm:IItem = new Item(n.productions[j], 0);
                        if(!_closure.contains(nitm))
                        {
                            _closure.add(nitm);
                            tmp.push(nitm);
                        }
                    }
                }
            }
            return _closure;
        }
        
        public function get productions():IProductions
        {
            return _produnctions;
        }
        
        public function eachItem(foo:Function):void
        {
            for each(var itm:IItem in _table)
            {
                if(foo(itm))
                    break;
            }
        }
    }
}