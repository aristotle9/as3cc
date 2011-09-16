package org.lala.compilercompile.utils
{
    public class ParserFile
    {
        public var className:String = 'Parser';
        public var lexerName:String = 'Lexer';
        public var packageName:String = '';
        public var userCode:String = '';
        public var imports:String = '';
        public var actions:String = '';
        public var tables:String = '';
        public var initialCode:String = '';
        
        public function ParserFile(parserConfig:Object)
        {
            if(parserConfig.decs != null)
            {
                if(parserConfig.decs['class'] != '')
                    className = parserConfig.decs['class'];
                if(parserConfig.decs['lexerName'] != '')
                    lexerName = parserConfig.decs['lexerName'];
                packageName = parserConfig.decs['package'];
                imports = parserConfig.decs['imports'].join(';\r\n') + ';\r\n';
            }
            
            if(parserConfig.codes != null)
            {
                userCode = parserConfig.codes.join(';\r\n') + ';\r\n';
            }
            
            if(parserConfig.initials != null)
            {
                initialCode = parserConfig.initials.join(';\r\n') + ';\r\n';
            }
        }
        
        public function getRenderObject():Object
        {
            return {
                'class' : className,
                'lexerName' : lexerName,
                'package' : packageName,
                'imports' : imports,
                'usercode' : userCode,
                'tables' : tables,
                'initial' : initialCode,
                'actions' : actions
            };
        }
    }
}