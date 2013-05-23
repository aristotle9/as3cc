package org.lala.ui.editor.commands
{
    import flash.events.Event;
    import flash.net.FileFilter;
    import flash.net.FileReference;
    import flash.text.TextField;
    
    import org.lala.ui.editor.interfaces.ICommand;
    
    public class OpenCommand implements ICommand
    {
        private var _target:TextField;
        public function OpenCommand(target:TextField)
        {
            _target = target;
        }
        
        public function exec():void
        {
            var fileRef:FileReference = new FileReference;
            fileRef.addEventListener(Event.SELECT, function(event:Event):void
            {
                fileRef.load();
            });
            fileRef.addEventListener(Event.COMPLETE, function(event:Event):void
            {
                _target.text = fileRef.data.toString();
                _target.dispatchEvent(new Event(Event.CHANGE,true,false));
            });
            fileRef.browse([new FileFilter("lpc","*.lpc")]);
        }
    }
}