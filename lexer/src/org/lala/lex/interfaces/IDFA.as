package org.lala.lex.interfaces
{
    public interface IDFA
    {
        function get entry():IState;
        function set entry(s:IState):void;
        function get exits():ISet;
        function get states():ISet;
        function get inputSet():IInputSet;
        function set inputSet(value:IInputSet):void;
        function get bottleSize():uint;
        function set bottleSize(value:uint):void;
        function addState(s:IState):void;
        function removeState(s:IState):void;
        function hasExit(s:IState):Boolean;
        function addExit(s:IState):void;
        function removeExit(s:IState):void;
    }
}