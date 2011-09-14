package org.lala.lex.interfaces
{
    public interface IInputSet
    {
        function getInput4Char(char:String):IInput;
        function getInput4Range(from:uint, to:uint):Vector.<IInput>;
        function getInput4All():Vector.<IInput>;
        function createInclusiveStates(states:Array):void;
        function createExclusiveStates(states:Array):void;
        function getInput4States(states:Array):Vector.<IInput>;
        function every(foo:Function):void;
        /** 与getInput4Char区别在于不会产生新的区间 **/
        function char2Input(code:uint):IInput;
        function get inputs():Vector.<IInput>;
        function inputTable():Array;
        /** 起始状态到输入的转换 **/
        function statesInputTable(fgTableRow:Array):Object;
    }
}