package org.lala.utils
{
    public class TplRender
    {
        [Embed(source="asserts/lexer.txt", mimeType="application/octet-stream")]
        private var Src:Class;
        public function TplRender()
        {
        }
        
        public function render(data:Object):String
        {
            var str:String = String(new Src());
            return str.replace(/<{\s*(\w+)\s*\}>/g,function(...args):String
            {
                if(data[args[1]] != null)
                {
                    return String(data[args[1]]);
                }
                return '';
            });
        }
    }
}