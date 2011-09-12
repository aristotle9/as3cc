package org.lala.compilercompile.lr0automata
{
    import org.lala.compilercompile.interfaces.IGLA;
    import org.lala.compilercompile.interfaces.IItem;
    import org.lala.compilercompile.interfaces.INonTerminal;
    import org.lala.compilercompile.interfaces.IPState;
    import org.lala.compilercompile.interfaces.IProduction;
    import org.lala.compilercompile.interfaces.IProductions;
    import org.lala.compilercompile.interfaces.ISet;
    import org.lala.compilercompile.interfaces.IState;
    import org.lala.compilercompile.interfaces.ISymbol;
    import org.lala.compilercompile.interfaces.ISymbols;
    
    /** 状态,出边 关系图生成,以及 Lookahead集合计算 **/
    public class GLA implements IGLA
    {
        protected var _states:Vector.<IState>;
        protected var _productions:IProductions;
        protected var _symbols:ISymbols;
        protected var _pstates:Vector.<IPState>;
        protected var _psTable:Object;
        
        public function GLA(states:Vector.<IState>, productions:IProductions, symbols:ISymbols)
        {
            _states = states;
            _productions = productions;
            _symbols = symbols;
            _pstates = new Vector.<IPState>;
            _psTable = new Object;
            /**
            * init
            * ===>init();
            * calculateReads
            * calculateIncludes
            * calculateLookback
            * ===>getRelationOfReadsAndIncludesAndLookback();
            * calculateRead
            * calculateFollow
            * calculateLA
            * createParserTable
            **/
            init();
            getRelationOfReadsAndIncludesAndLookback();
            set_valued_function();
        }
        /** create (p,A), (p,aAb->B) **/
        protected function init():void
        {
            var pstate:IPState;
            var id:uint;
            _states.forEach(function(s:IState, ... args):void
            {
                /** 生成终结符(p,A) **/
               s.eachGoto(function(sm:ISymbol, ns:IState):Boolean
               {
                   /** 非终结符的转换 A **/
                   if(sm.isTerminal == false)
                   {
                       id = getId(s, sm); 
                       pstate = new PState(id, s, sm as INonTerminal);
                       _pstates.push(pstate);
                       _psTable[pstate.id] = pstate;
                   }
                   return false;
               });
               /** 生成归约产生式(p,A->B) **/
               s.itemSet.closure.eachItem(function(itm:IItem):Boolean
               {
                   /** 点号在最后位置 **/
                   if(itm.position == itm.production.size)
                   {
                       id = getId(s, null, itm.production);
                       pstate = new PState(id, s, null, itm.production);
                       _pstates.push(pstate);
                       _psTable[pstate.id] = pstate;
                   }
                   return false;
               });
            });
        }
        /**
        * PState id = state * (ps.size + sys.size) + (p.id + sys.size) | s.id
        **/
        protected function getId(state:IState, symbol:ISymbol, production:IProduction=null):uint
        {
            if(production == null)
            {
                return state.id * (_productions.size + _symbols.size) + symbol.id;
            }
            else
            {
                return state.id * (_productions.size + _symbols.size) + _symbols.size + production.id;
            }
        }
        /**
        * 计算DR, Reads关系,includes关系,lookback关系
        **/
        protected function getRelationOfReadsAndIncludesAndLookback():void
        {
            var p1:IPState;
            var p2:IPState;
            var id:uint;
            var nt:INonTerminal;
            var i:int;
            var sym1:ISymbol;
            var sym2:ISymbol;
            var s1:IState;
            _states.forEach(function(s:IState, ... args):void
            {
               s.eachGoto(function(sm:ISymbol, ns:IState):Boolean
               {
                   if(sm.isTerminal == false)
                   {
                       nt = sm as INonTerminal;
                       p1 = getPstate(s, nt);
                       /** 计算reads关系,dr集合 **/
                       ns.eachGoto(function(nsm:ISymbol, nns:IState):Boolean
                       {
                           if(nsm.isTerminal)
                           {
                               p1.dr.add(nsm);
                           }
                           else if(nsm.isNullable)
                           {
                               p2 = getPstate(ns, nsm as INonTerminal);
                               p1.addReads(p2);
                           }
                           return false;
                       });
                       /** 计算includes关系 **/
                       nt.productions.forEach(function(p:IProduction, ... args):void
                       {
                           /** 设置为>0时,不进行计算 **/
                           /** 上述条件有误:B -> A => (i,A) includes (i,B) **/
                          for(i = p.size - 1; i >= 0; i --)
                          {
                              sym1 = p.right[i];
                              if(sym1.isTerminal == false)
                              {
                                  s1 = s.goto(p.right.slice(0, i));
                                  id = getId(s1, sym1);
                                  if(id == p1.id)
                                  {
//                                      throw new Error("自己不能包含自己.");
                                      continue;
                                  }
                                  p2 = _psTable[id];
                                  p2.addIncludes(p1);
                              }
                              if(!sym1.isNullable)
                                  break;
                          }
                           /** 计算lookback关系 **/
                          s1 = s.goto(p.right);
                          p2 = getPstate(s1, null, p);
                          p2.addLookback(p1);
                       });
                   }
                   return false;
               });
            });
        }
        protected function set_valued_function():void
        {
            var S:Vector.<IPState>;
            var N:Array;
            /** DeRemer & Penello 算法 **/
            function traverse_reads(pst:IPState):void
            {
                var d:uint;
                var ELEMENT:IPState;
                S.push(pst);
                d = S.length;
                N[pst.id] = d;
                pst.readSet = pst.dr.clone();
                pst.reads.every(function(p2:IPState):Boolean
                {
                    if(N[p2.id] == null)
                    {
                        traverse_reads(p2);
                    }
                    N[pst.id] = Math.min(N[pst.id], N[p2.id]);
                    pst.readSet.merge(p2.readSet);
                    return false;
                });
                if(N[pst.id] == d)
                {
                    ELEMENT = S.pop();
                    ELEMENT.readSet = pst.readSet.clone();
                    N[ELEMENT.id] = uint.MAX_VALUE;
                    while(ELEMENT.id != pst.id)
                    {
                        ELEMENT = S.pop();
                        ELEMENT.readSet = pst.readSet.clone();
                        N[ELEMENT.id] = uint.MAX_VALUE;
                    }
                }
            }
            function reads_bootstrap():void
            {
                S = new Vector.<IPState>;
                N = new Array;
                _pstates.forEach(function(pst:IPState, ... args):void
                {
                    if(!pst.type && N[pst.id] == null)
                    {
                        traverse_reads(pst);
                    }
                });
            }
            reads_bootstrap();
            function traverse_follow(pst:IPState):void
            {
                var d:uint;
                var ELEMENT:IPState;
                S.push(pst);
                d = S.length;
                N[pst.id] = d;
                pst.followSet = pst.readSet.clone();
                pst.includes.every(function(p2:IPState):Boolean
                {
                    if(N[p2.id] == null)
                    {
                        traverse_follow(p2);
                    }
                    N[pst.id] = Math.min(N[pst.id], N[p2.id]);
                    pst.followSet.merge(p2.followSet);
                    return false;
                });
                if(N[pst.id] == d)
                {
                    ELEMENT = S.pop();
                    ELEMENT.followSet = pst.followSet.clone();
                    N[ELEMENT.id] = uint.MAX_VALUE;
                    while(ELEMENT.id != pst.id)
                    {
                        ELEMENT = S.pop();
                        ELEMENT.followSet = pst.followSet.clone();
                        N[ELEMENT.id] = uint.MAX_VALUE;
                    }
                }
            }
            function follow_bootstrap():void
            {
                S = new Vector.<IPState>;
                N = new Array;
                _pstates.forEach(function(pst:IPState, ... args):void
                {
                    if(!pst.type && N[pst.id] == null)
                    {
                        traverse_follow(pst);
                    }
                });
            }
            follow_bootstrap();
            function la_bootstrap():void
            {
                _pstates.forEach(function(pst:IPState, ... args):void
                {
                    if(pst.type)
                    {
                        pst.lookback.every(function(p2:IPState):Boolean
                        {
                            pst.lookaheadSet.merge(p2.followSet);
                            return false;
                        });
                    }
                });
            }
            la_bootstrap();
        }
        public function get pstates():Vector.<IPState>
        {
            return _pstates;
        }
        
        public function getPstate(s:IState, nt:INonTerminal, p:IProduction=null):IPState
        {
            var id:uint = getId(s, nt, p);
            return _psTable[id];
        }
        
        public function drawGraph():String
        {
            var result:Array = [];
            function log(str:String):void
            {
                result.push(str);
            }
            log("digraph G");
            log("{");
            log('graph[rankdir="LR",bgcolor="#ffffe1"]');
            log('node[shape="rect",color="#8080FF",fillcolor="#CCCCFF",style="filled",penwidth="1.5",fontname="Consolas",fontsize="10"]');
            log('edge[arrowsize="0.6",penwidth="0.5",fontname="Consolas",fontsize="10"]');
            _pstates.forEach(function(p:IPState,...args):void
            {
                log(p.id + '[label="' + String(p) + '"]');
            });
            _pstates.forEach(function(p:IPState,...args):void
            {
                if(p.type == false)
                {
                    p.reads.every(function(ip:IPState):Boolean
                    {
                        log(p.id + ' -> ' + ip.id + '[color="#ff0000"]');
                        return false;
                    });
                    p.includes.every(function(ip:IPState):Boolean
                    {
                        log(p.id + ' -> ' + ip.id + '[color="#00ff00"]');
                        return false;
                    });
                }
                else
                {
                    p.lookback.every(function(ip:IPState):Boolean
                    {
                        log(p.id + ' -> ' + ip.id + '[color="#0000ff"]');
                        return false;
                    });
                }
            });
            log("}");
            return result.join("\n");
        }
    }
}