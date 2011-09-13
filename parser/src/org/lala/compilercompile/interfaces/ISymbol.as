package org.lala.compilercompile.interfaces
{
    public interface ISymbol
    {
        function get isNullable():Boolean;
        function set isNullable(value:Boolean):void;
        function get isTerminal():Boolean;
        function get text():String;
        function get htmlText():String;
        function get id():uint;
        function get preced():uint;
        function get assoc():uint;
    }
}