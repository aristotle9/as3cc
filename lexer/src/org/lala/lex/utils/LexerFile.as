package org.lala.lex.utils
{
    public class LexerFile
    {
        public var className:String = 'Lexer';
        public var packageName:String = '';
        public var userCode:String = '';
        public var imports:String = '';
        public var actions:String = '';
        public var tables:String = '';
        public var initialCode:String = '';
        public var fields:Array = [];
        
        public function LexerFile(lexerConfig:Object)
        {
            if(lexerConfig.decs != null)
            {
                if(lexerConfig.decs['class'] != '')
                    className = lexerConfig.decs['class'];
                packageName = lexerConfig.decs['package'];
                if(lexerConfig.decs['imports'].length > 0)
                    imports = 'import ' + lexerConfig.decs['imports'].join(';\r\nimport ') + ';\r\n';
            }
            
            if(lexerConfig.codes != null)
            {
                userCode = lexerConfig.codes.join(';\r\n');
            }
            
            if(lexerConfig.initials != null)
            {
                initialCode = lexerConfig.initials.join(';\r\n') + ';\r\n';
            }
            
            if(lexerConfig.fields != null)
            {
                for(var key:String in lexerConfig.fields)
                {
                    fields.push(['field_'+ key, lexerConfig.fields[key]]);
                }
            }
        }
        
        public function getRenderObject():Object
        {
            var res:Object = {
                'class' : className,
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