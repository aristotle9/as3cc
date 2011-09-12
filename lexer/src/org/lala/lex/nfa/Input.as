package org.lala.lex.nfa
{
    import org.lala.lex.interfaces.IInput;
    import org.lala.lex.interfaces.ISet;

    /**
    * 作为输入的抽象,可以是一个字符,可以是一个范围
    **/
    public class Input implements IInput
    {
        protected var _id:uint;
        protected var _from:uint;
        protected var _to:uint;
        protected var _info:String;
        protected var _edges:ISet;
        protected var _compressed:uint;
        
        public function Input(id:uint, info:String="")
        {
            _id = id;
            _info = info;
            _edges = new Set;
        }
        public function setRange(from:uint, to:uint):void
        {
            _from = from;
            _to = to;
        }
        public function get from():uint
        {
            return _from;
        }
        public function get to():uint
        {
            return _to;
        }
        public function get info():String
        {
            var str:String = "";
            if(_info.length)
            {
                return _info;
            }
            if(_from == _to)
            {
                str = String.fromCharCode(_from);
                if(str.match(/\s/) != null)
                    return "#" + _from.toString(16);
                if(str.match(/[\\'"]/) != null)
                    return "\\" + str;
                return str;
            }
            else
            {
                return "0x" + _from.toString(16) + '..0x' + _to.toString(16);
            }
        }
        /** 在一个InputSet中具有唯一的值 **/
        public function get id():uint
        {
            return _id;
        }
        
        public function get edges():ISet
        {
            return _edges;
        }

        public function get compressed():uint
        {
            return _compressed;
        }

        public function set compressed(value:uint):void
        {
            _compressed = value;
        }

    }
}