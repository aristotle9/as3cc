package org.lala.lex.interfaces
{
    /** 捕获的字符串,记录开始,结束位置 **/
    public interface IPairs
    {
        function get start():uint;
        function set start(value:uint):void;
        function get end():uint;
        function set end(value:uint):void;
    }
}