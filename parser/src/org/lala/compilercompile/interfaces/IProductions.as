package org.lala.compilercompile.interfaces
{
    public interface IProductions
    {
        function createProduction(left:String, ... right):IProduction;
        function eachProduction(foo:Function):void;
        function get symbols():ISymbols;
        function get totleLength():uint;
        function getProduction(index:uint):IProduction;
        function get size():uint;
    }
}