package org.lala.compilercompile.lr0automata
{
    import flash.utils.Dictionary;
    
    import org.lala.compilercompile.interfaces.ISet

    public class SymbolSet implements ISet
    {
        public static const NULLSET:ISet = new SymbolSet;
        private var _table:Dictionary;
        private var _size:uint;
        private var _data:Object;
        
        public function SymbolSet()
        {
            _table = new Dictionary;
            _size = 0;
        }
        public function add(obj:Object):void
        {
            if(contains(obj))
            {
                return;
            }
            _table[obj] = obj;
            _size ++;
        }
        public function merge(second:ISet):void
        {
            second.every(function(obj:Object):Boolean
            {
                add(obj);
                return false;
            });
        }
        public function clone():ISet
        {
            var newset:SymbolSet = new SymbolSet;
            every(function(obj:Object):Boolean
            {
               newset.add(obj);
               return false;
            });
            return newset;
        }
        /** 取一个,如果只有一个元素 **/
        public function fetch():Object
        {
            var res:Object;
            every(function(obj:Object):Boolean
            {
                res = obj;
                return true;
            });
            return res;
        }
        public function contains(obj:Object):Boolean
        {
            return !(_table[obj] == null);
        }
        public function remove(obj:Object):void
        {
            if(contains(obj))
            {
                delete _table[obj];
                _size --;
            }
        }
        public function get size():uint
        {
            return _size;
        }
        /** 不要作删除动作!! **/
        public function every(foo:Function):void
        {
            for(var obj:Object in _table)
            {
                if(foo(obj))
                    break;
            }
        }
        public function get data():Object
        {
            return _data;
        }
        public function set data(value:Object):void
        {
            _data = value;
        }

        
    }
}