package org.lala.compilercompile.interfaces
{
    public interface ITableCell
    {
        /** shift/reduce/acc/error/goto **/
        function get type():uint;
        /** shift/goto state **/
        function get state():IState;
        /** reduce production **/
        function get production():IProduction;
    }
}