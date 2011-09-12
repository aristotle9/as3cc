package org.lala.compilercompile.interfaces
{
    public interface ILALRTable
    {
        function get rows():uint;
        function get cols():uint;
        function toAS3Array():Array;
        function toHTML():String;
    }
}