package org.lala.compilercompile.interfaces
{
    public interface IItem
    {
        function get id():uint;
        function get production():IProduction;
        function get position():uint;
        function get nextSymbol():ISymbol;
        function createNext():IItem;
        function get data():Object;
        function set data(value:Object):void;
        function goto(sm:ISymbol):IItem;
    }
}