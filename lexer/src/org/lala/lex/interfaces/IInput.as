package org.lala.lex.interfaces
{
    public interface IInput
    {
        function get id():uint;
        function get info():String;
        function setRange(from:uint, to:uint):void;
        function get from():uint;
        function get to():uint;
        /** 
        * 使用该输入的所有的边
        * 必须细心维护,特别是cat操作时会进行顶点切换
        * 主要用在第一次构造自动机时,以后的自动机用不到该集合
        ***/
        function get edges():ISet;
        /** 
        * 经过压缩后的边的映射
        ***/
        function get compressed():uint;
        function set compressed(value:uint):void;
    }
}