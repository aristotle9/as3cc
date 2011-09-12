package org.lala.compilercompile.interfaces
{
    public interface IItemSet
    {
        function get tag():String;
        function get size():uint;
        function get data():Object;
        function set data(value:Object):void;
        function contains(itm:IItem):Boolean;
        function add(itm:IItem):void;
        function get closure():IItemSet;
        function get productions():IProductions;
        function eachItem(foo:Function):void;
    }
}