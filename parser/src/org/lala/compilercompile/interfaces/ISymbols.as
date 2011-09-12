package org.lala.compilercompile.interfaces
{
    public interface ISymbols
    {
        /**
        * 定义一个符号
        * @param text 代表字符串
        * @param ter true表示终结符,false表示非终结符
        * @param preced 终结符解决二义性的优先级
        * @param assoc 终结符解决二义性的结合性
        * @return 所定义的符号
        **/
        function defineSymbol(text:String,ter:Boolean, preced:uint=0, assoc:uint=0):ISymbol;
        function getSymbol(text:String):ISymbol;
        function eachNonterminal(foo:Function):void;
        function eachTerminal(foo:Function):void;
        function eachSymbol(foo:Function):void;
        function get size():uint;
    }
}