package org.lala.compilercompile.utils
{
    import mx.utils.StringUtil;

    public class SimpleParser
    {
        protected var _rows:Array;
        public function SimpleParser(src:String)
        {
            _rows = new Array;
            var lines:Array = src.split(/[\n\r]+/);
            lines.forEach(function(l:String, ... args):void
            {
                l = StringUtil.trim(l);
                if(l.length > 0)
                {
                    _rows.push(l.split(/[\s:]+/));
                }
            });
        }
        public function get rows():Array
        {
            return _rows;
        }
    }
}