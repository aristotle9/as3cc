package org.lala.lex.interfaces
{
    public interface IEdge
    {
        function get input():IInput;
        function get from():IState;
        function get to():IState;
    }
}