package org.lala.lex.interfaces
{
    /** 用于装捕获串的瓶子 **/
    public interface IBottle
    {
        /** 开始标号,供更新 **/
        function get start():uint;
        function set start(value:uint):void;
        /** id **/
        function get id():uint;
        function get pairs():Vector.<IPairs>;
        function add(P:IPairs):void;
        function result():String;
    }
}