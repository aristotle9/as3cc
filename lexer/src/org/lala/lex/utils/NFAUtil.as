package org.lala.lex.utils
{
    import flash.utils.Dictionary;
    
    import org.lala.lex.interfaces.IEdge;
    import org.lala.lex.interfaces.IInput;
    import org.lala.lex.interfaces.INFA;
    import org.lala.lex.interfaces.ISet;
    import org.lala.lex.interfaces.IState;
    import org.lala.lex.nfa.InputSet;
    import org.lala.lex.nfa.NFA;
    import org.lala.lex.nfa.Set;
    import org.lala.lex.nfa.State;

    public class NFAUtil
    {
        /** 将状态从 startIndex + (0, n-1)重新标记 **/
        public static function reindex_nfa(t:INFA, startIndex:uint=0):INFA
        {
            var index:uint = startIndex;
            var indexed:Array = new Array;
            var i:uint = 0;
            t.entry.id = index ++;
            indexed.push(t.entry);
            while(indexed.length < t.states.size)
            {
                var s:IState = indexed[i ++] as IState;
                s.outEdges.every(function(e:IEdge):Boolean
                {
                    if(indexed.indexOf(e.to) == -1)
                    {
                        e.to.id = index ++;
                        indexed.push(e.to);
                    }
                    return false;
                });
            }
            return t;
        }
        /** e-closure **/
        internal static function e_closure(s:IState):ISet
        {
            var tagged:Vector.<IState> = new Vector.<IState>;
            var i:uint = 0;
            var cur:IState;
            tagged.push(s);
            while(i < tagged.length)
            {
                cur = tagged[i ++];
                cur.move(InputSet.E).every(function(si:IState):Boolean
                {
                    if(tagged.indexOf(si) == -1)
                    {
                        tagged.push(si);
                    }
                    return false; 
                });
            }
            var ste:ISet = new Set;
            tagged.forEach(function(si:IState, ...args):void
            {
                ste.add(si);
            });
            return ste;
        }
        public static function subset_construction(t:INFA):INFA
        {
            function move(ste:ISet, ipt:IInput):ISet
            {
                var res:ISet = new Set;
                ste.every(function(s:IState):Boolean
                {
                    s.move(ipt).every(function(si:IState):Boolean
                    {
                        res.merge(e_closure(si));
                        return false;
                    });
                    return false;
                });
                return res;
            }
            var workQueue:Vector.<SubSetInfo> = new Vector.<SubSetInfo>;
            var workTable:Dictionary = new Dictionary;
            var i:uint = 0;
            var tag:String;
            var sinfo:SubSetInfo;
            var si:SubSetInfo;
            var ste:ISet;
            ste = e_closure(t.entry);
            sinfo = new SubSetInfo(ste, getTag(ste, Math.floor(t.states.size / 16) + 1), i);
            workQueue.push(sinfo);
            workTable[sinfo.tag] = sinfo;
            while(i < workQueue.length)
            {
                si = workQueue[i ++];
                t.inputSet.every(function(ipt:IInput):Boolean
                {
                    ste = move(si.ste, ipt);
                    tag = getTag(ste, Math.floor(t.states.size / 16) + 1);
                    if(workTable[tag] == null)
                    {
                        sinfo = new SubSetInfo(ste, tag, workQueue.length);
                        si.state.addTrans(ipt, sinfo.state);
                        workQueue.push(sinfo);
                        workTable[tag] = sinfo;
                    }
                    else
                    {
                        sinfo = workTable[tag];
                        si.state.addTrans(ipt, sinfo.state);
                    }
                    return false;
                });
            }
            //整理成nfa
            var nfa:INFA = new NFA();
            nfa.inputSet = t.inputSet;
            nfa.bottleSize = t.bottleSize;
            nfa.entry = workQueue[0].state;
            workQueue.forEach(function(sinfo:SubSetInfo, ... args):void
            {
               nfa.addState(sinfo.state); 
               if(getFinal(sinfo.ste))
               {
                   nfa.addExit(sinfo.state);
               }
               sinfo.ste.every(function(s:IState):Boolean
               {
                   sinfo.state.updateBottles.merge(s.updateBottles);
                   sinfo.state.catchBottles.merge(s.catchBottles);
                   return false; 
               });
               //如果是一个空的状态
               if(sinfo.ste.size == 0)
               {
                   nfa.removeExit(sinfo.state);
                   nfa.removeState(sinfo.state);
               }
            });
            return nfa;
        }
        /** hash **/
        internal static function getTag(ste:ISet,base:uint):String
        {
            var res:BaseFFFF = new BaseFFFF(base);//可以表示base * 16个状态的不同子集,即2^(base * 16)
            ste.every(function(s:IState):Boolean
            {
                res.add(s.id);
                return false;
            });
            return res.toString();
        }
        internal static function getFinal(ste:ISet):Boolean
        {
            var res:Boolean = false;
            ste.every(function(s:IState):Boolean
            {
                if(s.final)
                {
                    res = true;
                    return true;
                }
                return false;
            });
            return res;
        }
        /** 最小化算法 **/
        public static function min_dfa(t:INFA, named:Boolean=false):INFA
        {
            var nfa:INFA = new NFA;
            var setA:ISet;
            var setB:ISet;
            var ste:ISet;
            var flag:Boolean = true;
            var workStack:Vector.<ISet> = new Vector.<ISet>;
            var maps:Dictionary = new Dictionary;
            var table:Dictionary;
            var to:IState;
            //初始划分
            if(!named)
                setA = new Set;
            setB = new Set;
            var tmpTable:Object = {};
            t.states.every(function(s:IState):Boolean
            {
                if(t.hasExit(s))
                {
                    if(named)
                    {
                        if(tmpTable[s.data] == null)
                        {
                            tmpTable[s.data] = new Set;
                        }
                        setA = tmpTable[s.data] as ISet;
                        setA.add(s);
                        maps[s] = setA;
                    }
                    else
                    {
                        setA.add(s);
                        //状态所在集合
                        maps[s] = setA;
                    }
                }
                else
                {
                    setB.add(s);
                    maps[s] = setB;
                }
                return false;
            });
            workStack.push(setB);
            if(named)
            {
                for(var tmpKey:String in tmpTable)
                {
                    setA = tmpTable[tmpKey] as ISet;
                    workStack.push(setA);
                }
            }
            else
            {
                workStack.push(setA);
            }
            workStack = workStack.filter(function(ste:ISet, ...args):Boolean
            {
                return ste.size != 0;
            });
            /** 即使只有一个集合,也可能转换到Null集合而出现区分!! **/
//            if(workStack.length == 1)
//            {
//                flag = false;
//            }
            while(flag)
            {
                flag = false;
                for(var i:uint = 0; i < workStack.length; i++)
                {
                    ste = workStack[i];
                    if(ste.size > 1)
                    {
                        t.inputSet.inputs.every(function(ipt:IInput):Boolean
                        {
                            table = new Dictionary;
                            ste.every(function(s:IState):Boolean
                            {
                                to = s.trans(ipt);
                                var t_set:ISet;
                                if(to != null)
                                {
                                    t_set = maps[to];
                                }
                                else
                                {
                                    t_set = Set.NULLSET;
                                }
                                if(table[t_set] == null)
                                {
                                    table[t_set] = new Set;
                                }
                                setA = table[t_set];
                                setA.add(s);
                                return false;
                            });
                            var totle:uint = 0;
                            for(var key:Object in table)
                            {
                                totle ++;
                                if(totle == 2)
                                {
                                    break;
                                }
                            }
                            if(totle == 1)
                            {
                                return false;
                            }
                            flag = true;
                            workStack.splice(i, 1);
                            var j:uint = 0
                            for(key in table)
                            {
                                ste = table[key];
                                ste.every(function(s:IState):Boolean
                                {
                                    maps[s] = ste;
                                    return false;
                                });
                                workStack.splice(i, 0, ste);
                                j ++;
                            }
                            //跳过刚刚生成的集合
                            i += j;
                            //因为外层ste已经修改,再进行循环无用
                            return true;
                        });
                    }
                }
            }
            //整理
            nfa.inputSet = t.inputSet;
            nfa.bottleSize = t.bottleSize;
            var s:IState;
            var seed:IState;
            table = new Dictionary;
            workStack.forEach(function(ste:ISet, i:uint, ...args):void
            {
               s = new State(i);
               ste.every(function(si:IState):Boolean
               {
                   //样本获取
                   seed = si;
                   if(t.entry == seed)
                   {
                       nfa.entry = s;
                       return true;
                   }
                   return false;
               });
               ste.every(function(si:IState):Boolean
               {
                   s.updateBottles.merge(si.updateBottles);
                   s.catchBottles.merge(si.catchBottles);
                   return false;
               });
               if(t.hasExit(seed))
               {
                   nfa.addExit(s);
               }
               s.data = seed;
               ste.data = s;
               nfa.addState(s); 
            });
            //记录下一个状态的所有转换状态
            var moves:Dictionary = new Dictionary;
            workStack.forEach(function(ste:ISet, ...args):void
            {
               s = ste.data as IState;
               seed = s.data as IState;
               moves[s] = new Set;
               t.inputSet.every(function(ipt:IInput):Boolean
               {
                   
                   to = seed.trans(ipt);
                   if(to != null)
                   {
                       s.addTrans(ipt, maps[to].data);
                       //记录前往状态,以便消除死状态
                       moves[s].add(maps[to].data);
                   }
                   return false;
               });
               if(named)
               {
                   s.data = seed.data;
               }
               else
               {
                   //原来集合的信息
                   s.data = ste;
               }
            });
            //消除死状态,以前好像不会出现
            for(var key:Object in moves)
            {
                if(moves[key].size == 1 && key == moves[key].fetch() && key.final == false)
                {
                    nfa.removeState(key as IState);
                }
            }
            //重新编号,消除死状态后会打乱序号
            reindex_nfa(nfa);
            return nfa;
        }
    }
}
/**
 * 大整数运算
 * 0xFFFF + 1进制
 **/
class BaseFFFF
{
    private var _entity:Vector.<uint>;
    private var _maxlen:uint; 
    public function BaseFFFF(max:uint=0x0F)
    {
        _entity = new Vector.<uint>(max);
        _maxlen = max;
        while(_entity.length < max)
        {
            _entity.push(0);
        }
    }
    /** 一次只能加一个2^p **/
    public function add(p:uint):void
    {
        var n:uint = Math.floor(p / 16);
        var m:uint = p % 16;
        var pre:uint;
        var i:uint = n;
        if(n >= _maxlen)
        {
                throw new Error("越界.");
        }
        _entity[i] += 1 << m;
        while(_entity[i] > 0xFFFF)
        {
            if(i + 1 >= _maxlen)
            {
                throw new Error("越界.");
            }
            pre = _entity[i];
            _entity[i + 1] += (pre >> 16) & 0xFFFF;
            _entity[i] = pre & 0xFFFF;
            i ++;
        }
    }
    public function toString():String
    {
        var a:Array = [];
        function zero(str:String):String
        {
            while(str.length < 4)
            {
                str = "0" + str;
            }
            return str.toUpperCase();
        }
        _entity.forEach(function(n:uint, ...args):void
        {
            a.push(zero(n.toString(16)));
        });
        return a.reverse().join(",");
    }
}