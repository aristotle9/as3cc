package org.lala.ui.editor.commands
{
    import flash.events.Event;
    import flash.text.TextField;
    
    import org.lala.ui.editor.interfaces.ICommand;
    
    public class IndentCommand implements ICommand
    {
        private var _target:TextField;
        public function IndentCommand(target:TextField)
        {
            _target = target;
        }
        
        public function exec():void
        {
            var i:int;
            var char:int;
            var lineHead:int = 0;
            if(_target.selectionBeginIndex == _target.selectionEndIndex)
            {
                var left:String = _target.text.substr(0, _target.selectionBeginIndex);
                var right:String = _target.text.substring(_target.selectionBeginIndex);
                _target.text = left + '    ' + right;
//                _target.selectionBeginIndex += 4;
//                _target.selectionEndIndex += 4;
            }
            else
            {
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
                var nt:String = ntext.join('\r    ');
                left = _target.text.substr(0, lineHead);
                right = _target.text.substring(_target.selectionEndIndex);
                _target.text = left + '    ' + nt + right;
//                _target.selectionBeginIndex += 4;
//                _target.selectionEndIndex += ntext.length * 4;
            }
            _target.dispatchEvent(new Event(Event.CHANGE,true,false));
        }
    }
}