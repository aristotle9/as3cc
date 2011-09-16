package org.lala.compilercompile.lr0automata
{
    import com.maccherone.json.JSON;
    
    import flash.net.FileReference;
    import flash.utils.ByteArray;
    
    import org.lala.compilercompile.interfaces.IConfig;
    import org.lala.compilercompile.interfaces.IGLA;
    import org.lala.compilercompile.interfaces.IItem;
    import org.lala.compilercompile.interfaces.IItemSet;
    import org.lala.compilercompile.interfaces.ILALRTable;
    import org.lala.compilercompile.interfaces.INonTerminal;
    import org.lala.compilercompile.interfaces.IProduction;
    import org.lala.compilercompile.interfaces.IProductions;
    import org.lala.compilercompile.interfaces.IState;
    import org.lala.compilercompile.interfaces.ISymbol;
    import org.lala.compilercompile.interfaces.ISymbols;
    import org.lala.compilercompile.interfaces.ITableCell;
    import org.lala.compilercompile.utils.ParserFile;
    import org.lala.compilercompile.utils.SimpleParser;
    import org.lala.compilercompile.utils.TplRender;
    import org.lala.compilercompile.utils.XmlParser;

    public class LR0Automata
    {
        protected var _productions:IProductions;
        protected var _symbols:ISymbols;
        protected var _states:Vector.<IState>;
        protected var _stateIndex:uint;
        protected var _startState:IState;
        protected var _startProduction:IProduction;
        protected var _gla:IGLA;
        protected var _parserTable:ILALRTable;
        
        protected var _srcProvider:IConfig;
        protected var _twoTable:Array;
        
        public function LR0Automata(srcProvider:IConfig)
        {
            _srcProvider = srcProvider;
            _productions = new Productions;
            _symbols = _productions.symbols;
            init();
            nullable();
            construct();
            _gla = new GLA(_states, _productions, _symbols);
            _parserTable = new LALRTable(_states, _symbols, _gla);
        }
        
        protected function init():void
        {
            var symTable:Object = {};
            var sorted:Array = [];
            /** 计算产生式中的终结符 **/
            (_srcProvider.data.parser.rules as Array).forEach(function(rule:Object, ... args):void
            {
                if(symTable[rule.head] == null)
                {
                    symTable[rule.head] = {nt: true, text: rule.head}
                    sorted.push(symTable[rule.head]);
                }
                else
                {
                    symTable[rule.head].nt = true;
                }
                (rule.rhs as Array).forEach(function(rhs:Object,...args):void
                {
                    (rhs.pattern as Array).forEach(function(text:String,...args):void
                    {
                        if(symTable[text] == null)
                        {
                            symTable[text] = {nt: false, text: text};
                            sorted.push(symTable[text]);
                        }
                    });
                });
            });
            
            sorted.forEach(function(obj:Object, ... args):void
            {
                /** 记录所有终结符 **/
                if(obj.nt == false)
                {
                    var preced:uint = 0;
                    var assoc:String = 'nonassoc';
                    if(_srcProvider.data.parser.operators[obj.text])
                    {
                        preced = Number(_srcProvider.data.parser.operators[obj.text].preced);
                        assoc = _srcProvider.data.parser.operators[obj.text].assoc;
                    }
                    _symbols.defineSymbol(obj.text, true, preced, assoc);
                }
            });
            sorted.forEach(function(obj:Object, ... args):void
            {
                /** 记录所有非终结符 **/
                if(obj.nt == true)
                {
                    _symbols.defineSymbol(obj.text, false);
                }
            });
            _symbols.defineSymbol("E'", false);
            /** 使用XML格式的语法文件解析结果来初始化产生式 **/
            _startProduction = _productions.createProduction("E'", _srcProvider.data.parser.start, "<$>");
            var production:IProduction;
            for each(var rule:Object in _srcProvider.data.parser.rules)
            {
                var head:String = rule.head;
                for each(var rhs:Object in rule.rhs)
                {
                    production = _productions.createProduction.apply(_productions, [head].concat(rhs.pattern));
                    if(rhs.preced)//自定义优先级
                    {
                        var op:Object = _srcProvider.data.parser.operators[rhs.preced];
                        production.preced = op.preced;
                        production.assoc = op.assoc;
                    }
                }
            }
        }
        
        /**
        * 整理isNullable,即计算isNullable函数
        **/
        protected function nullable():void
        {
            //一开始,除了epsilon,其余的都是false
            var flag:Boolean = true;
            while(flag)
            {
                flag = false;
                _productions.eachProduction(function(p:IProduction):Boolean
                {
                    if(p.left.isNullable == false)
                    {
                        var i:uint = 0;
                        var f:Boolean = true;
                        for(; i < p.right.length; i ++)
                        {
                            if(p.right[i].isNullable == false)
                            {
                                f = false;
                                break;
                            }
                        }
                        if(f)
                        {
                            p.left.isNullable = true;
                            flag = true;
                        }
                    }
                    return false; 
                });
            }
            //扫描后的isNullable都有正确设置
        }
        /** 计算状态转换图 **/
        protected function construct():void
        {
            var endState:IState;
            var preEndState:IState;
            var endIndex:uint;
            var table:Object = new Object;
            _states = new Vector.<IState>;
            var s:IState = createState();
            var ns:IState;
            var itemSet:IItemSet = new ItemSet(_productions);
            var itm:IItem = new Item(_startProduction, 0);
            itemSet.add(itm);
            s.itemSet = itemSet;
            _startState = s;
            table[s.itemSet.tag] = s;
            _states.push(s);
            var i:uint = 0;
            while(i != _states.length)
            {
                s = _states[i];
                _symbols.eachSymbol(function(sm:ISymbol):Boolean
                {
                    var itemSet:IItemSet = new ItemSet(_productions);
                    s.itemSet.closure.eachItem(function(itm:IItem):Boolean
                    {
                        var nitm:IItem = itm.goto(sm);
                        if(nitm != null)
                        {
                            itemSet.add(nitm);
                        }
                        return false;
                    });
                    if(itemSet.size)
                    {
                        if(table[itemSet.tag] == null)
                        {
                            if(sm != Symbols.end)
                            {
                                ns = createState();
                            }
                            else
                            {
                                /** 把最终状态记录,然后在末尾插入到状态队列最后 **/
                                ns = new State(uint.MAX_VALUE);
                                endState = ns;
                                preEndState = s;
                                endIndex = _states.length;
                            }
                            ns.itemSet = itemSet;
                            table[itemSet.tag] = ns;
                            _states.push(ns);
                        }
                        else
                        {
                            ns = table[itemSet.tag];
                        }
                        s.addTrans(sm, ns);
                    }
                    return false;
                });
                i ++;
            }
            /** 状态的id尚未使用,可以替换状态 **/
            ns = createState();
            ns.itemSet = endState.itemSet;
            preEndState.addTrans(Symbols.end, ns);
            _states.splice(endIndex, 1, ns);
        }
        
        public function get states():Vector.<IState>
        {
            return _states;
        }
        
        public function get startState():IState
        {
            return _startState;
        }
        
        protected function createState():IState
        {
            return new State(_stateIndex ++);
        }
        
        public function toString():String
        {
            var result:Array = [];
            function p(str:String):void
            {
                result.push(str);
            }
            function line(s1:IState, s2:IState, sm:ISymbol):void
            {
                p(s1.id + " -> " + s2.id + '[label="' + sm.text + '"]');
            }
            function node(s:IState):void
            {
                p(s.id + '[label=<<table border="0" cellborder="0" cellpadding="3">' + String(s) + '</table>>]');
            }
            p("digraph G");
            p("{");
            p('graph[rankdir="LR",bgcolor="#ffffe1"]');
            p('node[shape="rect",color="#8080FF",fillcolor="#CCCCFF",style="filled",penwidth="1.5",fontname="Consolas",fontsize="10"]');
            p('edge[arrowsize="0.6",penwidth="0.5",fontname="Consolas",fontsize="10"]');
            states.forEach(function(s:IState, ... args):void
            {
               node(s);
               s.eachGoto(function(sm:ISymbol, ns:IState):Boolean
               {
                   line(s, ns, sm);
                   return false;
               });
            });
            p("}");
            return result.join("\n");
        }
        
        public function glaString():String
        {
            return _gla["drawGraph"]();
        }
        
        public function get table():Array
        {
            return _parserTable.toAS3Array();
        }
        
        /** action表与goto表分开,以符号为第一坐标 **/
        public function get twoTables():Array
        {
            if(_twoTable == null)
            {
                var actionRows:Array = new Array;
                var gotoRows:Object = {};
                _parserTable.toAS3Array().forEach(function(cols:Array, i:int, ...args):void
                {
                    cols.forEach(function(cell:*, j:int, ...args2):void
                    {
                        if(cell is ITableCell)
                        {
                            if(cell.type == TableCell.GOTO)
                            {
                                if(gotoRows[j] == null)
                                {
                                    gotoRows[j] = {};//new Array(_states.length - 1);
                                }
                                gotoRows[j][i] = cell["toUint"]();
                            }
                            else
                            {
                                if(actionRows[j] == null)
                                {
                                    actionRows[j] = {};//new Array(_states.length - 1);
                                }
                                actionRows[j][i] = cell["toUint"]();
                            }
                        }
                    });
                });
                _twoTable = [actionRows, gotoRows];
            }
            return _twoTable;
        }
        
        /** 供解析程序使用的产生式列表,包括[产生式头id,产生式体长度] **/
        public function get prds():Array
        {
            var result:Array = [];
            /** 产生式的序号与其id一致 **/
            for(var i:int = 0; i < _productions.size; i ++)
            {
                var p:IProduction = _productions.getProduction(i);
                result[i] = [p.left.id, p.size];   
            }
            return result;
        }
        
        /** 终结符表,从符号到id **/
        public function get inputSymbols():Object
        {
            var res:Object = {};
            _symbols.eachTerminal(function(sm:ISymbol):Boolean
            {
                if(sm != Symbols.epsilon)
                {
                    res[sm.text] = sm.id;
                }
                return false;
            });
            return res;
        }
        
        /** 压缩,二进制化 **/
        public function binaryOutput():ByteArray
        {
            var dat:ByteArray = new ByteArray;
            var r:Array = twoTables;
            dat.writeObject(r[0]);
            dat.writeObject(r[1]);
            dat.writeObject(prds);
            dat.writeObject(inputSymbols);
            dat.deflate();
            return dat;
        }
        
        /** actions代码片断 **/
        public function actionsOutput():String
        {
            var result:Array = [];
            function p(str:String):void
            {
                result.push(str);
            };
            p("switch(_pi)\r\n{");
            var i:uint = 1;//第一个扩展跳过
            for each(var rule:Object in _srcProvider.data.parser.rules)
            {
                for each(var rhs:Object in rule.rhs)
                {
                    if(rhs.action != null)
                    {
                        p("case 0x" + i.toString(16).toUpperCase() + ":");
                        p(String(rhs.action).replace(/\$(\$|\d+)|@(\d+)/g, function(...args):String
                        {
                            if(args[1] == "$")
                            {
                                return "_result";
                            }
                            else if(args[1].length)
                            {
                                var off:int = 1 + rhs.pattern.length - parseInt(args[1]);
                                if(off < 1 || off > rhs.pattern.length)
                                {
                                    throw new Error("动作代码中$n越界:" + rule.head + " -> " + rhs.pattern.join(" ") + ",with $"+args[1]);
                                }
                                return "_outputStack[_outputStack.length - " + off + "]";
                            }
                            else
                            {
                                return "_outputStack[_outputStack.length - " + (parseInt(args[2]) + 1) + ']';
                            }
                        }));
                        p("break;");
                    }
                    i ++;
                }
            }
            p("}");
            return result.join("\r\n");
        }
        
        public function tableOutput():String
        {
            var lalrTable:Array = twoTables;
            var ret:Array = [];
            ret.push('_actionTable = ');
            ret.push(JSON.encode(lalrTable[0]).replace(/"(\d+)"(?=\s*:)/g,'$1'));
            ret.push(';_gotoTable = ');
            ret.push(JSON.encode(lalrTable[1]).replace(/"(\d+)"(?=\s*:)/g,'$1'));
            ret.push(';_prodList = ');
            ret.push(JSON.encode(prds));
            ret.push(';_inputTable = ');
            ret.push(JSON.encode(inputSymbols));
            ret.push(';');
            return ret.join('\r\n');    
        }
        
        public function tableString():String
        {
            var result:Array = new Array;
            function p(str:String):void
            {
                result.push(str);
            }
            var i:uint = 0;
            while(i < table.length)
            {
                p(table[i].toString());
                i ++;
            }
            return result.join("\n");
        }
        
        public function get symbols():Array
        {
            var result:Array = new Array();
            result.push(Symbols.epsilon, Symbols.end);
            _symbols.eachTerminal(function(sm:ISymbol):Boolean
            {   
                if(sm != Symbols.epsilon && sm != Symbols.end)
                    result.push(sm);
                return false;
            });
            _symbols.eachNonterminal(function(sm:ISymbol):Boolean
            {   
                result.push(sm);
                return false;
            });
            result.sortOn("id", Array.NUMERIC);
            return result;
        }
        
        public function saveParserFile():void
        {
            var fileRef:FileReference = new FileReference;
            var render:TplRender = new TplRender();
            var fileData:ParserFile = new ParserFile(_srcProvider.data.parser);
            fileData.actions = actionsOutput();
            fileData.tables = tableOutput();
            fileRef.save(render.render(fileData.getRenderObject()), fileData.className + '.as');
        }
    }
}