package org.lala.compilercompile.utils
{
    /**
    * 大整数运算
    * 0xFFFF + 1进制
    **/
    public class BaseFFFF
    {
        private var _entity:Vector.<uint>;
        private var _maxlen:uint; 
        public function BaseFFFF(max:uint=0x0F)
        {
            _entity = new Vector.<uint>(max);
            _maxlen = max;
            while(_entity.length < max)
            {
                _entity.push(0);
            }
        }
        /** 一次只能加一个2^p **/
        public function add(p:uint):void
        {
            var n:uint = Math.floor(p / 16);
            var m:uint = p % 16;
            var pre:uint;
            var i:uint = n;
            if(n >= _maxlen)
            {
                throw new Error("越界.");
            }
            _entity[i] += 1 << m;
            while(_entity[i] > 0xFFFF)
            {
                if(i + 1 >= _maxlen)
                {
                    throw new Error("越界.");
                }
                pre = _entity[i];
                _entity[i + 1] += (pre >> 16) & 0xFFFF;
                _entity[i] = pre & 0xFFFF;
                i ++;
            }
        }
        public function toString():String
        {
            var a:Array = [];
            function zero(str:String):String
            {
                while(str.length < 4)
                {
                    str = "0" + str;
                }
                return str.toUpperCase();
            }
            _entity.forEach(function(n:uint, ...args):void
            {
                a.push(zero(n.toString(16)));
            });
            return a.reverse().join(",");
        }
    }
}