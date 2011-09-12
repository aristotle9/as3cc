package org.lala.compilercompile.interfaces
{
    public interface INonTerminal extends ISymbol
    {
        function eachProduction(foo:Function):void;
        function get productions():Vector.<IProduction>
    }
}