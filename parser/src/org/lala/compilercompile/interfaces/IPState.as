package org.lala.compilercompile.interfaces
{
    public interface IPState
    {
        function get state():IState;
        /**
         * false:非产生式状态
         **/
        function get type():Boolean;
        function get nonterminal():INonTerminal;
        function get production():IProduction;
        function get id():uint;
        //以下为关系集
        function get reads():ISet;
        function get lookback():ISet;
        function get includes():ISet;
        function addReads(pst:IPState):void;
        function addIncludes(pst:IPState):void;
        function addLookback(pst:IPState):void;
        //以下为中间变量集值
        function get dr():ISet;
        function get readSet():ISet;
        function set readSet(value:ISet):void;
        function get followSet():ISet;
        function set followSet(value:ISet):void;
        function get lookaheadSet():ISet; 
    }
}