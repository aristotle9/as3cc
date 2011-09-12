package org.lala.compilercompile.lr0automata
{
    import flash.utils.Dictionary;
    
    import org.lala.compilercompile.interfaces.IItem;
    import org.lala.compilercompile.interfaces.IItemSet;
    import org.lala.compilercompile.interfaces.IProductions;
    import org.lala.compilercompile.interfaces.IState;
    import org.lala.compilercompile.interfaces.ISymbol;
    
    public class State implements IState
    {
        protected var _id:uint;
        protected var _table:Dictionary;
        protected var _itemSet:IItemSet;
        
        public function State(id:uint)
        {
            _id = id;
            _table = new Dictionary;
        }
        
        public function get id():uint
        {
            return _id;
        }
        
        public function get itemSet():IItemSet
        {
            return _itemSet;
        }
        
        public function goto(smsq:Vector.<ISymbol>):IState
        {
            if(smsq.length == 0)
                return this;
            if(trans(smsq[0]) == null)
                return null;
            else
            {
                var s:IState = trans(smsq[0]);
                if(smsq.length == 1)
                {
                    return s;
                }
                else
                {
                    return s.goto(smsq.slice(1));
                }
            }
        }
        
        public function trans(sm:ISymbol):IState
        {
            if(_table[sm] != null)
                return _table[sm];
            else if(sm == Symbols.epsilon)
                return this;
            else 
                return null;
        }
        
        public function addTrans(sm:ISymbol, s:IState):void
        {
            if(_table[sm] != null && sm != Symbols.end)
                throw new Error("已经存在该边.");
            _table[sm] = s;
        }

        public function set itemSet(value:IItemSet):void
        {
            _itemSet = value;
        }
        
        public function eachGoto(foo:Function):void
        {
            for(var key:Object in _table)
            {
                if(foo(key, _table[key]))
                    break;
            }
        }
        
        public function toString():String
        {
            var res:String = "<tr><td>";
            res += id + '</td></tr>';
            itemSet.closure.eachItem(function(itm:IItem):Boolean
            {
                res += '<tr><td align="left">' + String(itm) + '</td></tr>';
                return false;
            });
            return res; 
        }
    }
}