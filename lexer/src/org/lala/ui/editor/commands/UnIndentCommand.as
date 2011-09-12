package org.lala.ui.editor.commands
{
    import flash.events.Event;
    
    import mx.controls.TextArea;
    
    import org.lala.ui.editor.interfaces.ICommand;
    
    public class UnIndentCommand implements ICommand
    {
        private var _target:TextArea;
        public function UnIndentCommand(target:TextArea)
        {
            _target = target;
        }
        
        public function exec():void
        {
            var i:int;
            var char:int;
            var lineHead:int = 0;
            var left:String;
            var right:String;
            for(i = _target.selectionBeginIndex;true;i--)
            {
                if(i == 0)
                {
                    lineHead = 0;
                    break;
                }
                else
                {
                    char = _target.text.charCodeAt(i);
                    if(char == 0xa || char == 0xd)
                    {
                        lineHead = i + 1;
                        break;
                    }
                }
            }
            var ntext:Array = _target.text.substring(lineHead, _target.selectionEndIndex).split(/\r|\n|\r\n/);
            var offset:uint = 0;
            var foffset:uint = 0;
            ntext = ntext.map(function(line:String, i:int,...args):String
            {
                var z:int = 0;
                while(z < 4 && (line.charAt() == ' ' || line.charAt() == '\t'))
                {
                    line = line.substr(1);
                    z ++;
                }
                if(i == 0)
                {
                    foffset = z;
                }
                offset += z;
                return line;
            });
            var nt:String = ntext.join('\r');
            left = _target.text.substr(0, lineHead);
            right = _target.text.substring(_target.selectionEndIndex);
            _target.text = left + nt + right;
            _target.selectionBeginIndex -= foffset;
            _target.selectionEndIndex -= offset;
            
            _target.dispatchEvent(new Event(Event.CHANGE,true,false));
        }
    }
}