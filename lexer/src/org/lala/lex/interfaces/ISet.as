package org.lala.lex.interfaces
{
    public interface ISet
    {
        function get size():uint;
        function get data():Object;
        function set data(obj:Object):void;
        function clone():ISet;
        function merge(ste:ISet):void;
        function contains(obj:Object):Boolean;
        function add(obj:Object):void;
        function remove(obj:Object):void;
        function every(foo:Function):void;
        function fetch():Object;
    }
}