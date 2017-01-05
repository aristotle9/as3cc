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
        public var fields:Array = [];
        
        public function ParserFile(parserConfig:Object)
        {
            if(parserConfig.decs != null)
            {
                if(parserConfig.decs['class'] != '')
                    className = parserConfig.decs['class'];
                if(parserConfig.decs['lexerName'] != '')
                    lexerName = parserConfig.decs['lexerName'];
                packageName = parserConfig.decs['package'];
                imports = parserConfig.decs['imports'].map(function(cls:String, ...args):String { return 'import ' + cls;}).join(';\r\n') + (parserConfig.decs['imports'].length > 0 ? ';\r\n' : '');
            }
            
            if(parserConfig.codes != null)
            {
                userCode = parserConfig.codes.join('\r\n');
            }
            
            if(parserConfig.initials != null)
            {
                initialCode = parserConfig.initials.join('\r\n');
            }
            
            if(parserConfig.fields != null)
            {
                for(var key:String in parserConfig.fields)
                {
                    fields.push(['field_'+ key, parserConfig.fields[key]]);
                }
            }            
        }
        
        public function getRenderObject():Object
        {
            var res:Object = {
                'class' : className,
                'lexerName' : lexerName,
                'package' : packageName,
                'imports' : imports,
                'usercode' : userCode,
                'tables' : tables,
                'initial' : initialCode,
                'actions' : actions,
                'create_date' : new Date()
            };
            fields.forEach(function(p:Array,...args):void
            {
                res[p[0]] = p[1];
            });
            return res; 
        }
    }
}