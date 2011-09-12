package org.lala.ui.editor.commands
{
    import flash.events.Event;
    
    import mx.controls.TextArea;
    
    import org.lala.ui.editor.interfaces.ICommand;
    
    public class DeleteLinesCommand implements ICommand
    {
        private var _target:TextArea;
        public function DeleteLinesCommand(target:TextArea)
        {
            _target = target;
        }
        
        public function exec():void
        {
            var i:int;
            var char:int;
            var lineHead:int = 0;
            var lineTail:int = 0;
            var left:String;
            var right:String;
            for(i = _target.selectionBeginIndex; true; i --)
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
                        lineHead = i;
                        break;
                    }
                }
            }
            for(i = _target.selectionEndIndex; true; i ++)
            {
                if(i == _target.text.length)
                {
                    lineTail = _target.text.length;
                    break;
                }
                else
                {
                    char = _target.text.charCodeAt(i);
                    if(char == 0xa || char == 0xd)
                    {
                        lineTail = i + 1;
                        break;
                    }
                }
            }
            left = _target.text.substr(0, lineHead);
            right = _target.text.substring(lineTail);
            _target.text = left + right;
            _target.selectionBeginIndex = lineHead;
            _target.selectionEndIndex = lineHead;
            
            _target.dispatchEvent(new Event(Event.CHANGE,true,false));
        }
    }
}