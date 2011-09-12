package org.lala.lex.nfa
{
    import mx.collections.ArrayCollection;

    public class NFAState
    {
        private var _id:uint;
        protected var _table:Object = {};
        public function NFAState(num:uint)
        {
            _id = num;
        }
        public function addTrans(a:String, state:NFAState):void
        {
            var to:ArrayCollection;
            if(_table.hasOwnProperty(a))
            {
                to = ArrayCollection(_table[a]);
                to.addItem(state);
            }
            else
            {
                to = new ArrayCollection();
                to.addItem(state);
                _table[a] = to;
            }
        }
        public function get inputs():Array
        {
            var res:Array = [];
            for(var key:String in _table)
            {
                res.push(key);
            }
            return res;
        }
        public function move(a:String):ArrayCollection
        {
            if(_table.hasOwnProperty(a))
            {
                return _table[a];
            }
            return null;
        }
        /** 只对无进入边的状态有用 **/
        public function merge(s:NFAState):void
        {
            var inps:Array = s.inputs;
            var to_s:ArrayCollection;
            for each(var key:String in inps)
            {
                to_s = s.move(key);
                for each(var to:NFAState in to_s)
                {
                    addTrans(key, to);
                }
            }
        }
        public function get id():uint
        {
            return _id;
        }

        public function set id(value:uint):void
        {
            _id = value;
        }


    }
}