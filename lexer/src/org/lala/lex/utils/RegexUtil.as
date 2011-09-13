package org.lala.lex.utils
{
    import com.maccherone.json.JSON;
    
    import flash.utils.ByteArray;
    
    import mx.utils.Base64Encoder;
    
    import org.lala.lex.interfaces.IBottle;
    import org.lala.lex.interfaces.IEdge;
    import org.lala.lex.interfaces.IInput;
    import org.lala.lex.interfaces.IInputSet;
    import org.lala.lex.interfaces.INFA;
    import org.lala.lex.interfaces.ISet;
    import org.lala.lex.interfaces.IState;
    import org.lala.lex.nfa.Bottle;
    import org.lala.lex.nfa.InputSet;
    import org.lala.lex.nfa.NFA;
    import org.lala.lex.nfa.Set;
    import org.lala.lex.nfa.State;
    import org.lala.lex.utils.parser.RegexParser;

    public class RegexUtil
    {
        /** 
        * <pre>
        * 后缀式的正则表达式生成NFA,使用Thompson[Aho改进]算法,使用空边
        * 在此之前可以对Range进行预处理,生成一个有限的InputSet集
        * 并将Range操作改为BOR操作
        * <b>非Thompsom自动机无法对边输入集进行修正</b>
        * </pre>
        * @param rnp 正则表达式的逆波兰表达式
        * @param inputSet 输入集,用于输入的统一管理
        * @param bottleIndex 瓶子起始的标号,用于多个正则表达式合并后按含义分组,c[起始标号者为终态]
        **/
        public static function reg_nfa(rnp:Vector.<RegToken>,inputSet:IInputSet=null, bottleIndex:uint=0):INFA
        {
            var workStack:Vector.<INFA> = new Vector.<INFA>;
            var numStack:Vector.<RegToken> = new Vector.<RegToken>;
            var stateIndex:uint = 0
            var sa:IState;
            var sb:IState;
            var sea:IState;
            var seb:IState;
            var nfaT:INFA;
            var nfaS:INFA;
            inputSet == null ? inputSet = new InputSet : false;
            var ipt:IInput;
            var ipts:Vector.<IInput>;
            var edge:IEdge;
            var inputs:ISet;
            var from:int;
            var to:int;
            var bottleSize:uint = 0;
            
            function createState():IState
            {
                return new State(stateIndex ++);
            }
            var i:uint;
            var tk:RegToken;
            for(i = 0; i < rnp.length - 2; i ++)
            {
                tk = rnp[i];
                switch(tk.type)
                {
                    case RegToken.CHAR:
                        /** 向前看两个符号 **/
                        if((i + 1 < rnp.length && rnp[i + 1] == RegToken.TKRANGE) || 
                        (i + 2 < rnp.length && rnp[i + 2] == RegToken.TKRANGE))
                        {
                            break;
                        }
                        sa = createState();
                        sb = createState();
                        nfaT = new NFA();
                        ipt = inputSet.getInput4Char(tk.char);
                        edge = sa.addTrans(ipt, sb);
                        ipt.edges.add(edge);
                        nfaT.entry = sa;
                        nfaT.addExit(sb);
                        nfaT.addState(sa);
                        nfaT.addState(sb);
                        workStack.push(nfaT);
                        break;
                    case RegToken.RANGE:
                    case RegToken.DIGIT:
                    case RegToken.SPACE:
                    case RegToken.WORD:
                        if(tk.type == RegToken.RANGE)
                        {
                            from = rnp[i - 2].char.charCodeAt();
                            to = rnp[i - 1].char.charCodeAt();
                            ipts = inputSet.getInput4Range(from, to);
                        }
                        else if(tk.type == RegToken.DIGIT)
                        {
                            ipts = inputSet.getInput4Range(0x30, 0x39);
                        }
                        else if(tk.type == RegToken.SPACE)
                        {
                            ipts = inputSet.getInput4Range(0x20, 0x20);
                            ipts.push(inputSet.getInput4Char("\t"));
                            ipts.push(inputSet.getInput4Char("\r"));
                            ipts.push(inputSet.getInput4Char("\n"));
                        }
                        else if(tk.type == RegToken.WORD)
                        {
                            ipts = inputSet.getInput4Range(0x30, 0x39);
                            ipts = ipts.concat((inputSet.getInput4Range(0x61, 0x7a)));
                            ipts = ipts.concat((inputSet.getInput4Range(0x41, 0x5a)));
                        }
                        
                        sa = createState();
                        sb = createState();
                        nfaT = new NFA();
                        ipts.forEach(function(ipt:IInput, ... args):void
                        {
                            edge = sa.addTrans(ipt, sb);
                            ipt.edges.add(edge);
                        });
                        nfaT.entry = sa;
                        nfaT.addExit(sb);
                        nfaT.addState(sa);
                        nfaT.addState(sb);
                        workStack.push(nfaT);
                        break;
                    case RegToken.BNOT:
                    case RegToken.DOT:
                        inputs = new Set;
                        if(tk.type == RegToken.BNOT)
                        {
                            /** 得到最近的自动机 **/
                            nfaS = workStack.pop();
                            nfaS.states.every(function(s:IState):Boolean
                            {
                                s.outEdges.every(function(e:IEdge):Boolean
                                {
                                    /** 拆除所有的边,以及相应的输入中的边 **/
                                    e.input.edges.remove(e);
                                    inputs.add(e.input);
                                    return false;
                                });
                                return false;
                            });
                        }
                        ipts = inputSet.getInput4All();
                        /** 重新组装一个OR机 **/
                        sa = createState();
                        sb = createState();
                        nfaT = new NFA();
                        ipts.forEach(function(ipt:IInput, ... args):void
                        {
                            if(tk.type == RegToken.BNOT && inputs.contains(ipt))
                            {
                                return;
                            }
                            edge = sa.addTrans(ipt, sb);
                            ipt.edges.add(edge);
                        });
                        nfaT.entry = sa;
                        nfaT.addExit(sb);
                        nfaT.addState(sa);
                        nfaT.addState(sb);
                        workStack.push(nfaT);
                        break;
                    case RegToken.CAT:
                        nfaS = workStack.pop();
                        nfaT = workStack.pop();
                        sea = nfaT.exits.fetch() as IState;
                        seb = nfaS.exits.fetch() as IState;
                        nfaS.entry.outEdges.every(function(e:IEdge):Boolean
                        {
                            edge = sea.addTrans(e.input, e.to);
                            e.to.inEdges.remove(e);
                            if(e.input != InputSet.E)
                            {
                                e.input.edges.remove(e);
                                e.input.edges.add(edge);
                            }
                            return false;
                        });
                        sea.updateBottles.merge(nfaS.entry.updateBottles);
                        sea.catchBottles.merge(nfaS.entry.catchBottles);
                        nfaS.removeState(nfaS.entry);
                        nfaT.removeExit(sea);
                        nfaT.states.merge(nfaS.states);
                        nfaT.addExit(seb);
                        workStack.push(nfaT);
                        break;
                    case RegToken.OR:
                    case RegToken.BOR:
                        sa = createState();
                        sb = createState();
                        nfaS = workStack.pop();
                        nfaT = workStack.pop();
                        sea = nfaT.exits.fetch() as IState;
                        seb = nfaS.exits.fetch() as IState;
                        sa.addTrans(InputSet.E, nfaT.entry);
                        sa.addTrans(InputSet.E, nfaS.entry);
                        sea.addTrans(InputSet.E, sb);
                        seb.addTrans(InputSet.E, sb);
                        nfaT.removeExit(sea);
                        nfaS.removeExit(seb);
                        nfaT.entry = sa;
                        nfaT.addExit(sb);
                        nfaT.addState(sa);
                        nfaT.addState(sb);
                        nfaT.states.merge(nfaS.states);
                        workStack.push(nfaT);
                        break;
                    case RegToken.STAR:
                    case RegToken.MORE:
                    case RegToken.ASK:
                        sa = createState();
                        sb = createState();
                        nfaT = workStack.pop();
                        sea = nfaT.exits.fetch() as IState;
                        sa.addTrans(InputSet.E, nfaT.entry);
                        if(tk.type != RegToken.MORE)
                        {
                            sa.addTrans(InputSet.E, sb);
                        }
                        if(tk.type != RegToken.ASK)
                        {
                            sea.addTrans(InputSet.E, nfaT.entry);
                        }
                        sea.addTrans(InputSet.E, sb);
                        nfaT.removeExit(sea);
                        nfaT.addState(sa);
                        nfaT.addState(sb);
                        nfaT.entry = sa;
                        nfaT.addExit(sb);
                        workStack.push(nfaT);
                        break;
                    case RegToken.NUM:
                        numStack.push(tk);
                        break;
                    case RegToken.CATCHAS:
                        if(numStack.length > 0)
                        {
                            tk = numStack.pop();
                            /** Bottle's id is CatchAs's param with bottleIndex offset **/
                            var bottle:IBottle = new Bottle(parseInt(tk.char) + bottleIndex);
                            bottleSize ++;
                            nfaT = workStack.pop();
                            nfaT.entry.updateBottles.add(bottle);
                            sa = nfaT.exits.fetch() as IState;
                            sa.catchBottles.add(bottle);
                            workStack.push(nfaT);
                        }
                        else
                        {
                            throw new Error("无法捕捉,无标号.");
                        }
                }
            }
            nfaT = workStack.pop();
            nfaT.inputSet = inputSet;
            nfaT.bottleSize = bottleSize;
            return nfaT;
        }
        /** nfa合并,使用在开头添加公共开始状态,结尾不合并 **/
        public static function nfa_or(nfas:Array, rules:Array):INFA
        {
            var sa:IState;
            var nfaT:INFA;
            var nfaS:INFA;
            var inputSet:IInputSet = nfas[0].inputSet;
            /** 标好号 **/
            var start:uint = 1;
            var i:uint = 0;
            while(i < nfas.length)
            {
                nfaS = nfas[i];
                NFAUtil.reindex_nfa(nfaS, start);
                start += nfaS.states.size;
                i ++;
            }
            /** 公共起始状态 **/
            sa = new State(0);
            i = 0;
            while(i < nfas.length)
            {
                nfaS = nfas[i];
                var ipts:Vector.<IInput> = inputSet.getInput4States(rules[i].p[1]);
                ipts.forEach(function(ipt:IInput, ...args):void
                {
                    sa.addTrans(ipt, nfaS.entry);
                });
//                sa.addTrans(InputSet.E, nfaS.entry);
                i ++;
            }
            /** 合体到nfaT **/
            nfaT = nfas[0];
            nfaT.addState(sa);
            nfaT.entry = sa;
            i = 1;
            while(i < nfas.length)
            {
                nfaS = nfas[i];
                nfaT.states.merge(nfaS.states);
                nfaT.exits.merge(nfaS.exits);
                nfaT.bottleSize += nfaS.bottleSize;
                i ++;
            }
            return nfaT;
        }
        /** 创建一个词法nfa **/
        public static function CREATE_NFA(rules:Array, inputFrom:uint=0, inputTo:uint=0xff, states:Object=null):INFA
        {
            var tokens:Vector.<RegToken>
            var rpn:Vector.<RegToken>;
            var nfa:INFA;
            var nfas:Array = new Array;
            var inputSet:IInputSet = new InputSet(inputFrom,inputTo);
//            var bottleIndex:uint = 0;
            var parser:RegexParser = new RegexParser();
            var regMachine:RegexpMachine002 = new RegexpMachine002(inputSet);
            
            rules.forEach(function(raw:Object, ... args):void
            {
//                tokens = RegexUtil.lex_with_extends(raw.p[0]);
//                rpn = RegexUtil.shunting_yard(tokens);
//                nfa = RegexUtil.reg_nfa(rpn,inputSet,bottleIndex);
                var compiled:Object = parser.parse(raw.p[0]);
                regMachine.code = compiled.code;
                nfa = regMachine.execute();
                
                nfas.push(nfa);
//                bottleIndex += nfa.bottleSize;
            });
            //输入集的inputs已经稳定
            if(states === null)
            {
                states = {inclusive:[],exclusive:[]};
            }
            inputSet.createInclusiveStates(states.inclusive);
            inputSet.createExclusiveStates(states.exclusive);
            
            for(var i:uint = 0; i < nfas.length; i ++)
            {
                nfa = nfas[i] as INFA;
                NFAUtil.reindex_nfa(nfa);
                nfa = NFAUtil.subset_construction(nfa);
                nfa = NFAUtil.min_dfa(nfa);
                /** 给每个最终状态写上名字,用于第二阶段的冲突解决(需要一个优先级表),第三阶段的初始划分 **/
                nfa.exits.every(function(s:IState):Boolean
                {
                    s.data = i;
                    return false;
                });
                nfas[i] = nfa;
            }
            return RegexUtil.nfa_or.call(null, nfas, rules);          
        }
        /** 合并,并处理冲突:破坏性的,会丢失原来的data数据 **/
        public static function NFA_DFA(t:INFA):INFA
        {
            var nfa:INFA = NFAUtil.subset_construction(t);
            nfa.exits.every(function(s:IState):Boolean
            {
                var sinfo:SubSetInfo = s.data as SubSetInfo;
                var finalName:uint = uint.MAX_VALUE;
                sinfo.ste.every(function(si:IState):Boolean
                {
                    if(si.final && Number(si.data) < finalName)
                    {
                        finalName = Number(si.data);
                    }
                    return false;
                });
                s.data = finalName;
                return false;
            });
            return nfa;
        }
        /** DFA到表格的转换,表格压缩在以后进行 **/
        public static function DFA_TABLE(t:INFA):Array
        {
            var inputSet:IInputSet = t.inputSet;
            var table:Array = new Array(t.states.size);
            t.states.every(function(s:IState):Boolean
            {
                s.outEdges.every(function(e:IEdge):Boolean
                {
                    if(table[s.id] == null)
                    {
                        table[s.id] = new Array(inputSet.inputs.length);
                        table[s.id][0] = s.id;
                    }
                    var row:Array = table[s.id];
                    row[e.input.id] = e.to.id;
                    return false;
                });
                return false;
            });
            return table;
        }
        /** 起始状态到输入的转换 **/
        public static function DFA_INPUT_STATES(t:INFA):Object
        {
            var inputSet:IInputSet = t.inputSet;
            return inputSet.statesInputTable();
        }
        
        /** 输入压缩,使用状态对边的作用来划分 **/
        public static function INPUT_COMPRESS(table:Array):Array
        {
            var stateSize:uint = table.length;
            var inputSize:uint;
            var workStack:Vector.<Vector.<uint>> = new Vector.<Vector.<uint>>;
            var i:uint;
            var j:uint;
            var s:uint;
            var tmpTable:Object;
            var curSet:Vector.<uint>;
            var workSet:Vector.<uint>;
            i = 0;
            while(table[i] == null)
            {
                i++;
            }
            inputSize = table[i].length;
            i = 1;
            curSet = new Vector.<uint>;
            while(i < inputSize)
            {
                curSet.push(i ++);
            }
            workStack.push(curSet);
            var flag:Boolean = true;
            for(s = 0; s < stateSize && flag; s ++)
            {
                if(table[s] == null)
                {
                    continue;
                }
                flag = false;
                for(j = 0; j < workStack.length; j ++)
                {
                    curSet = workStack[j];
                    if(curSet.length == 1)
                    {
                        continue;
                    }
                    /** 全部为单一元集合时,可以跳出 **/
                    flag = true;
                    /** 投射 **/
                    tmpTable = {};
                    curSet.forEach(function(ipt:uint, ... args):void
                    {
                        var to:* = table[s][ipt];
                        if(to == null)
                        {
                            to = "NULL";
                        }
                        if(tmpTable[to] == null)
                        {
                            tmpTable[to] = new Vector.<uint>;
                        }
                        workSet = tmpTable[to];
                        workSet.push(ipt);
                        
                    });
                    /** 检测影子个数 **/
                    var totle:uint = 0;
                    var x:*;
                    for(x in tmpTable)
                    {
                        totle ++;
                        if(totle == 2)
                        {
                            break;
                        }
                    }
                    if(totle == 1)
                    {
                        continue;
                    }
                    /** 新的划分 **/
                    totle = 0;
                    for(x in tmpTable)
                    {
                        workStack.splice(j + 1, 0, tmpTable[x]);
                        totle ++;
                    }
                    workStack.splice(j, 1);
                    j += totle - 1;
                }
            }
            /** 等价表 **/
            var result:Array = new Array(inputSize);
            var newTable:Array = new Array(stateSize);
            i = 0;
            while(i < stateSize)
            {
                newTable[i ++] = new Array(workStack.length);
            }
            result[0] = uint.MAX_VALUE;
            i = 0;
            var seed:uint;
            while(i < workStack.length)
            {
                curSet = workStack[i];
                curSet.forEach(function(ipt:uint, ... args):void
                {
                    result[ipt] = i;
                });
                seed = curSet[0];
                newTable.forEach(function(a:Array, s:uint, ... args):void
                {
                    if(table[s] != null)
                        a[i] = table[s][seed];
                });
                i ++;
            }
            return [newTable,result];
        }
        /** 接受状态关联的词法单元序号 **/
        public static function FINAL_STATES(t:INFA):Array
        {
            var finals:Array;
            finals = new Array(t.states.size);
            t.exits.every(function(s:IState):Boolean
            {
                finals[s.id] = Number(s.data);
                return false;
            });
            return finals;
        }
        /** 代码打印 **/
        public static function PRETTY_PRINT(stateTable:Array,finalTable:Array,inputTable:Array):String
        {
            var table1:Array = stateTable.map(function(row:Array, ...args):String
            {
                return '[' + row.join() + ']';
            });
            var table2:Array = inputTable.map(function(item:Array, i:uint, ... args):String
            {
                return (i != 0 && i % 4 == 0 ? "\n[" : '[') + item.join() + ']';
            });
            return 'stateTrans = [' + table1.join(",\n") + '];\nfinalIndices = [' + finalTable[0].join() + '];\nfinalNames = '+ JSON.encode(finalTable[1]) + ';\ninputTrans = [' + table2.join() + '];';  
        }
        /** 表格数据压缩 **/
        public static function TABLES_COMPRESS(stateTable:Array,finalTable:Array,inputTable:Array,statesInputTable:Object):ByteArray
        {
            var data:ByteArray = new ByteArray;
            data.writeObject(stateTable);
            data.writeObject(finalTable);
            data.writeObject(inputTable);
            data.writeObject(statesInputTable);
            data.deflate();
            return data;
        }
        /** 产生词法action辅助程序 **/
        public static function ACTION_FILE(config:Object):String
        {
            var result:Array = [];
            function p(str:String):void
            {
                result.push(str);
            };
            p("switch(__findex)\r\n{");
            (config.lexer.rules as Array).forEach(function(rule:Object, i:uint, parent:Array):void
            {
                if(String(rule.a).length > 0)
                {
                    /** 跳过 epsilon 和 end **/
                    p("case 0x" + i.toString(16).toUpperCase() + ":");
                    p("    " + String(rule.a).replace(/\$\$/g,"yytext") + ';');
                    p("    break;");
                }
            });
            p("}");
            return result.join("\r\n");
        }
        /** 解析词法源文件xml **/
        public static function PARSE_LEXER_SOURCE(xml:XML):Object
        {
            var rules:Array = new Array;
            var lexer:XMLList = xml.lexer[0].children();
            var precedence:uint = 1;
            var states:Object = {inclusive:[], exclusive:[]};
            var arr:Array;
            for each(var item:XML in lexer) 
            {
                switch(String(item.name()))
                {
                    case "tokens":
                        for each(var it:XML in item.children())
                        {
                            var p:Array = [esc(String(it.pattern))];
                            if(String(it.@states).length)
                            {
                                p.push(String(it.@states).split(/[\s,]+/));
                            }
                            else
                            {
                                p.push([]);
                            }
                            rules.push({p: p, a: String(it.action)});
                        }
                        precedence ++;
                        break;
                    case "states":
                        if(String(item.inclusive).length)
                        {
                            arr = String(item.inclusive).split(/[\s,]+/);
                            arr.forEach(function(src:String,...args):void
                            {
                                if(src.length)
                                    states.inclusive.push(src);
                            });
                        }
                        if(String(item.exclusive).length)
                        {
                            arr = String(item.exclusive).split(/[\s,]+/);
                            arr.forEach(function(src:String,...args):void
                            {
                                if(src.length)
                                    states.exclusive.push(src);
                            });
                        }
                        break;
                }
            }
            return {lexer:{rules:rules, states: states}};
        }
        /** 转义正则表达式 **/
        public static function esc(src:String):String
        {
            var a:Array = src.match(/^(['"])((?:[^"\\]|\\.)+)\1$/); 
            if(a)
            {
                return (a[2] as String).replace(/[\\\*\|\?\+\[\]\(\)\^\.\-\{\}]/g,"\\$&");
            }
            return src;
        }
        /** nfa绘制 **/
        public static function nfa_dot(t:INFA):String
        {
            var result:Array = [];
            function p(str:String):void
            {
                result.push(str);
            }
            function move(edge:IEdge):void
            {
                var res:String = "";
                var ipt:String;
                if(edge.input === InputSet.E)//epsilon
                {
                    ipt = "&epsilon;";
                }
                else
                {
                    ipt = edge.input.info;   
                }
                res += edge.from.id;
                res += " -> ";
                res += edge.to.id;
                res += '[label="' + ipt + '"]';
                p(res);
            }
            p("digraph G");
            p("{");
            p('graph[rankdir="LR",bgcolor="#ffffe1"]');
            p('node[shape="circle",color="#8080FF",fillcolor="#CCCCFF",style="filled",penwidth="1.5"]');
            p('edge[arrowsize="0.6",penwidth="0.5"]');
            t.exits.every(function(s:IState):Boolean
            {
                p(s.id + '[shape="doublecircle"]');
                return false;
            });
            p("start -> " + t.entry.id)
            p('start[style="invis"]');
            t.states.every(function(from:IState):Boolean
            {
                p(from.id + '[label="' + String(from) + '"]');
                from.outEdges.every(function(e:IEdge):Boolean
                {
                    move(e);
                    return false;
                });
                return false;
            });
            p("}");
            return result.join("\n");
        }
        /** 打印由子集构造法生成的dfa,可视化原来的状态的子集 **/
        public static function dfa_of_nfa_dot(t:INFA):String
        {
            var result:Array = [];
            function p(str:String):void
            {
                result.push(str);
            }
            function move(edge:IEdge):void
            {
                var res:String = "";
                var ipt:String;
                if(edge.input === InputSet.E)//epsilon
                {
                    ipt = "&epsilon;";
                }
                else
                {
                    ipt = edge.input.info;   
                }
                res += edge.from.id;
                res += " -> ";
                res += edge.to.id;
                res += '[label="' + ipt + '",color="#8080FF",penwidth="1.5",weight="0.5"]';
                p(res);
            }
            p("digraph G");
            p("{");
            p('graph[rankdir="LR",bgcolor="#ffffe1"]');
            p('node[shape="circle",color="#8080FF",fillcolor="#CCCCFF",style="filled",penwidth="1.5"]');
            p('edge[arrowsize="0.6",penwidth="0.5"]');
            t.exits.every(function(s:IState):Boolean
            {
                p(s.id + '[color="#E000C1"]');
                return false;
            });
            p("start -> " + t.entry.id + '[label="start",color="#8080FF",penwidth="1.5"]');
            p('start[style="invis"]');
            t.states.every(function(from:IState):Boolean
            {
                p(from.data.toString());
                from.outEdges.every(function(e:IEdge):Boolean
                {
                    move(e);
                    return false;
                });
                return false;
            });
            p("}");
            return result.join("\n");
        }
        /**
        * Shunting-yard algorithm
        * 把正则表达式改成后缀表示
        **/
        public static function shunting_yard(input:Vector.<RegToken>):Vector.<RegToken>
        {
            var output:Vector.<RegToken> = new Vector.<RegToken>;
            var opt:Vector.<RegToken> = new Vector.<RegToken>;
            var bp:Vector.<RegToken> = new Vector.<RegToken>;
            var pnum:Vector.<int> = new Vector.<int>;
            var plen:int = 0;
            var i:int = 0;
            while(i < input.length)
            {
                var tk:RegToken = input[i];
                if(tk.type >= RegToken.CHAR && tk.type < RegToken.NUM)
                {
                    output.push(tk);
                }
                else if(tk.type <= RegToken.BNOT)
                {
                    while(opt.length)
                    {
                        var op:RegToken = opt[opt.length - 1];
                        if(tk.type >= op.type)
                        {
                            output.push(opt.pop());
                        }
                        else
                        {
                            break;
                        }
                    }
                    opt.push(tk);
                }
                else if(tk.type == RegToken.LP || tk.type == RegToken.LB)
                {
                    if(tk.type == RegToken.LP)
                    {
                        pnum.push(plen);
                        plen ++;
                    }
                    opt.push(tk);
                    bp.push(tk);
                }
                else if(tk.type == RegToken.RP || tk.type == RegToken.RB)
                {
                    while(opt.length && opt[opt.length - 1].type != RegToken.LP && opt[opt.length - 1].type != RegToken.LB)
                    {
                        output.push(opt.pop());
                    }
                    if(opt.length == 0)
                    {
                        throw new Error("need a" + bp[bp.length - 1]);
                    }
                    if(opt[opt.length - 1].type == RegToken.LP)
                    {
                        output.push(new RegToken(pnum.pop().toString(), RegToken.NUM));
                        output.push(RegToken.TKCATCHAS);
                    }
                    bp.pop();
                    opt.pop();
                }
                else if(tk.type == RegToken.END)
                {
                    output.push(tk);
                    while(opt.length)
                    {
                        if(opt[opt.length - 1].type == RegToken.LP)
                        {
                            throw new Error("need a )");
                        }
                        else if(opt[opt.length - 1].type == RegToken.LB)
                        {
                            throw new Error("need a ]");
                        }
                        else
                        {
                            output.push(opt.pop());
                        }
                    }
                }
                i ++;
            }
            return output;
        }
        /**
        * 正则表达式的手工词法分析器
        * <pre>
        * 目前支持的运算有:
        * Star(*) Many(+) Ask(?)
        * Cat Or(|) Bor Bnot(^) Range(-)
        * Bnot仅仅对第一分量为All有效,ex:[^ab],incorrect:[a-z^ab]
        * 没有Dot等通配符
        * 辅助运算符:
        * CatchAs,由括号自动生成
        * </pre>
        ***/
        public static function lex_with_extends(_src:String):Vector.<RegToken>
        {
            var regTokens:Vector.<RegToken> = new Vector.<RegToken>;
            var i:int = 0;
            var j:int = 0;
            var src:String = _src;
            var len:int = src.length;
            var flag:uint = 0;
            var bflag:uint = 0;
            var tk:RegToken;
            regTokens.push(RegToken.TKLP);
            j ++;
            while(i < len)
            {
                var char:String = src.charAt(i);
                if(flag != 1 && char == "\\")
                {
                    flag = 1;
                    i ++;
                    continue;
                }
                if(flag == 1)
                {
                    var tchar:String = null;
                    switch(char)
                    {
                        case "t":
                            tchar = "\t";
                            break;
                        case "n":
                            tchar = "\n";
                            break;
                        case "r":
                            tchar = "\r";
                            break;
                        //oct \0##
                        case "0":
                            tchar = String.fromCharCode(parseInt(src.substr(i + 1, 2), 8));
                            i += 2;
                            break;
                        //hex \x##
                        case "x":
                            tchar = String.fromCharCode(parseInt(src.substr(i + 1, 2), 16));
                            i += 2;
                            break;
                        //unicode \u####
                        case "u":
                            tchar = String.fromCharCode(parseInt(src.substr(i + 1, 4), 16));
                            i += 4;
                            break;
                        case "d":
                            tk = RegToken.TKDIGIT;
                            break;
                        case "s":
                            tk = RegToken.TKSPACE;
                            break;
                        case "w":
                            tk = RegToken.TKWORD;
                            break;
                        default:
                            tchar = char;
                            break;
                    }
                    if(tchar != null)
                    {
                        tk = new RegToken(tchar, RegToken.CHAR);
                    }
                    flag = 0;
                }
                else
                {
                    tk = RegToken.getToken(char);
                }
                if(bflag == 2)
                {
                    if((tk.type >= RegToken.CHAR && tk.type < RegToken.NUM) && (regTokens[j - 1].type >= RegToken.CHAR && regTokens[j - 1].type < RegToken.NUM))
                    {
                        regTokens.push(RegToken.TKBOR);
                        j ++;
                    }
                }
                else
                {
                    if((tk.type >= RegToken.CHAR && tk.type < RegToken.NUM) || tk.type == RegToken.END || tk.type == RegToken.LP || tk.type == RegToken.LB)
                    {
                        if(j > 0)
                        {
                            var otk:RegToken = regTokens[j - 1];
                            if(otk.type == RegToken.RP || (otk.type >= RegToken.CHAR && otk.type < RegToken.NUM) || otk.type < RegToken.CAT || otk.type == RegToken.RB)
                            {
                                regTokens.push(RegToken.TKCAT);
                                j ++;
                            }
                        }
                    }
                }
                if(tk.type == RegToken.LB)
                {
                    bflag = 2;
                }
                if(tk.type == RegToken.RB)
                {
                    bflag = 0;
                }
                regTokens.push(tk);
                i ++;
                j ++;
            }
            regTokens.push(RegToken.TKRP);
            regTokens.push(RegToken.TKCAT);
            regTokens.push(RegToken.TKEND);
            return regTokens;
        }
    }
}