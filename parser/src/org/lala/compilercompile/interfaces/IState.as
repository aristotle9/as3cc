package org.lala.compilercompile.interfaces
{
    public interface IState
    {
        function get id():uint;
        function get itemSet():IItemSet;
        function set itemSet(value:IItemSet):void;
        function goto(smsq:Vector.<ISymbol>):IState;
        function trans(sm:ISymbol):IState;
        function addTrans(sm:ISymbol, s:IState):void;
        function eachGoto(foo:Function):void;
    }
}