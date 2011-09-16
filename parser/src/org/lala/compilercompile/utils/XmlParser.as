package org.lala.compilercompile.utils
{
    public class XmlParser
    {
        private var _data:Object;
        
        public function XmlParser(xml:XML)
        {
            _data = parse_lexer(xml);
            _data.parser = parse_parser(xml);
        }
        
        protected function parse_parser(xml:XML):Object
        {
            var parser:XMLList = xml.parser.children();
            var table:Object = {start:'',rules:[],operators:{}};
            var precedence:uint = 0;
            var decs:Object = {'class':'', imports:[], 'package':'',lexerName:''};
            var codes:Array = [];
            var initials:Array = [];
            
            for each(var rule:XML in parser)
            {
                switch(String(rule.name()))
                {
                    case 'declares':
                        if(String(rule.className))
                        {
                            decs['class'] = String(rule.className);
                        }
                        if(String(rule.lexerName))
                        {
                            decs['lexerName'] = String(rule.lexerName);
                        }
                        if(String(rule['package']))
                        {
                            decs['package'] = String(rule['package']);
                        }
                        if(String(rule['imports']))
                        {
                            decs['imports'] = String(rule['imports']).split(/\s+/);
                        }
                        break;
                    case 'code':
                        codes.push(String(rule));
                        break;
                    case 'initial':
                        initials.push(String(rule));
                        break;
                    case "operators":
                        for each(var item:XML in rule.children())
                        {
                            var assoc:uint = 2;
                            if(String(item.@assoc) == "left")
                            {
                                assoc = 0
                            }
                            else if(String(item.@assoc) == "right")
                            {
                                assoc = 1
                            }
                            else if(String(item.@assoc) == "none")
                            {
                                assoc = 2
                            }
                            var arr:Array = String(item).split(/[\s,]+/);
                            arr.forEach(function(op:String,...args):void
                            {
                                table.operators[op] = {preced: precedence, assoc: assoc};
                            });
                            precedence ++;
                        }
                        break;
                    case "rule":
                        var r:Object = {head:String(rule.@head),rhs:[]};
                        for each(var rhs:XML in rule.children())
                        {
                            var ri:Object = {pattern:null, preced:null, action:null};
                            ri.pattern = String(rhs.pattern[0]).split(/\s+/);
                            if(ri.pattern[0] == "")
                            {
                                /** epsilon **/
                                ri.pattern = [];
                            }
                            if(String(rhs.@precedence))
                            {
                                ri.preced = String(rhs.@precedence);
                            }
                            if(String(rhs.action))
                            {
                                ri.action = String(rhs.action);
                            }
                            r.rhs.push(ri);
                        }
                        table.rules.push(r);
                        break;
                }
            }
            table.decs = decs;
            table.codes = codes;
            table.initials = initials;
            //开始产生式,没有指定时为第一个规则的头
            if(String(xml.parser.@start).length)
            {
                table.start = String(xml.parser.@start);
            }
            else
            {
                table.start = table.rules[0].head;
            }
            return table;
        }
        /** 语法分析已经不需要lexer配置 **/
        protected function parse_lexer(xml:XML):Object
        {
            return {};
        }
        
        protected function esc(src:String):String
        {
            return src.replace(/[\\\*\|\?\+\[\]\(\)\^\.\-\{\}]/g,"\\$&");
        }
        
        public function get data():Object
        {
            return _data;
        }
    }
}