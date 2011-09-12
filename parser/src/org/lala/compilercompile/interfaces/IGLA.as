package org.lala.compilercompile.interfaces
{
    public interface IGLA
    {
        function get pstates():Vector.<IPState>;
        function getPstate(s:IState, nt:INonTerminal, p:IProduction=null):IPState;
    }
}