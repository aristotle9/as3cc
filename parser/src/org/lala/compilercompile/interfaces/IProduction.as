package org.lala.compilercompile.interfaces
{
    public interface IProduction
    {
        function get id():uint;
        function get preced():uint;
        function set preced(value:uint):void;
        function get assoc():String;
        function set assoc(value:String):void;
        function get size():uint;
        function get left():INonTerminal;
        function get right():Vector.<ISymbol>;
        function get preLength():uint;
        function set preLength(value:uint):void;
        function contains(symbol:ISymbol):Boolean;
    }
}