package org.lala.lex.interfaces
{
    public interface IState
    {
        function get data():Object;
        function set data(obj:Object):void;
        /** 更新这些瓶子的开始状态 **/
        function get updateBottles():ISet;
        /** 捕获这些瓶子 **/
        function get catchBottles():ISet;
        function get inputs():ISet;
        function get id():uint;
        function set id(value:uint):void;
        function get final():Boolean;
        function set final(value:Boolean):void;
        function get inEdges():ISet;
        function get outEdges():ISet;
        function move(ipt:IInput):ISet;
        function trans(ipt:IInput):IState;
        function addTrans(ipt:IInput,to:IState):IEdge;
        function merge(s:IState):void;
    }
}