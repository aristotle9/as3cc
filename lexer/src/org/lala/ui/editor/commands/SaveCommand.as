package org.lala.ui.editor.commands
{
    import flash.events.Event;
    import flash.net.FileFilter;
    import flash.net.FileReference;
    import flash.text.TextField;
    
    import org.lala.ui.editor.interfaces.ICommand;
    
    public class SaveCommand implements ICommand
    {
        private var _target:TextField;
        public function SaveCommand(target:TextField)
        {
            _target = target;
        }
        
        public function exec():void
        {
            var fileRef:FileReference = new FileReference;
            fileRef.save(_target.text, "");
        }
    }
}