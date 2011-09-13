package org.lala.compilercompile.lr0automata
{
    import org.lala.compilercompile.interfaces.IGLA;
    import org.lala.compilercompile.interfaces.ILALRTable;
    import org.lala.compilercompile.interfaces.IPState;
    import org.lala.compilercompile.interfaces.IState;
    import org.lala.compilercompile.interfaces.ISymbol;
    import org.lala.compilercompile.interfaces.ISymbols;
    import org.lala.compilercompile.interfaces.ITableCell;
    
    public class LALRTable implements ILALRTable
    {
        protected var _states:Vector.<IState>;
        protected var _symbols:ISymbols;
        protected var _gla:IGLA;
        protected var _table:Array;
        
        public function LALRTable(states:Vector.<IState>, symbols:ISymbols, gla:IGLA)
        {
            var i:uint;
            _states = states;
            _symbols = symbols;
            _gla = gla;
            _table = new Array(rows);
            for(i = 0; i < rows; i ++)
            {
                _table[i] = new Array;
                /** epsilon边就当作状态序号,反正也不会有输入的 **/
                _table[i][0] = i;
            }
            createTable();
        }
        
        protected function createTable():void
        {
            var cell:ITableCell;
            _gla.pstates.forEach(function(pst:IPState, ... args):void
            {
               if(pst.type)
               {
                   pst.lookaheadSet.every(function(sm:ISymbol):Boolean
                   {
                       if(_table[pst.state.id][sm.id] == null)
                       {
                           cell = new TableCell(TableCell.REDUCE, null, pst.production);
                           _table[pst.state.id][sm.id] = cell;
                       }
                       else
                       {
                           /**
                           * 不能使用优先级与结合性来解决,文法不是LALR的[最好产生警告]
                           **/
                           throw new Error("Reduce/Reduce conflict.");
                       }
                       return false;
                   });
               }
            });
            _states.forEach(function(s:IState, ... args):void
            {
                s.eachGoto(function(sm:ISymbol, ns:IState):Boolean
                {
                    if(_table[s.id][sm.id] == null)
                    {
                        cell = new TableCell(sm.isTerminal ? (sm.id == 1 ? TableCell.ACC :TableCell.SHIFT) : TableCell.GOTO, ns, null);
                        _table[s.id][sm.id] = cell;
                    }
                    else
                    {
                        /**
                        * S/R冲突的解决方法:
                        * 在归约产生式体中得到优先级最高的终结符
                        * 移入终结符是对应的列代表的终结符:与前者比较
                        * 优先级不同:使用优先级高的终结符代表的产生式
                        * 优先级相同:这种情况下结合性也必须相同[否则产生警告],左结合的:归约;右结合的:移入,无结合的:警告
                        **/
                        cell = _table[s.id][sm.id];
                        if(sm.assoc == 2 || cell.production.assoc == 2)//无结合
                        {
                            throw new Error("无结合性,但是需要结合性来解决的S/R冲突:@符号" + sm.text + ' &表达式' + String(cell.production));
                        }
                        if(sm.preced > cell.production.preced)
                        {
                            cell = new TableCell(TableCell.SHIFT, ns);
                            _table[s.id][sm.id] = cell;
                        }
                        else if(sm.preced == cell.production.preced)
                        {
                            if(sm.assoc != cell.production.assoc)
                            {
                                throw new Error("优先级相同,结合性不同的S/R冲突:@符号" + sm.text + ' &表达式' + String(cell.production));
                            }
                            else
                            {
                                if(sm.assoc == 1)//右结合
                                {
                                    //移入
                                    cell = new TableCell(TableCell.SHIFT, ns);
                                    _table[s.id][sm.id] = cell;
                                }
                                //左结合不用更改表格内容
                            }
                        }
//                        throw new Error("Shift/Reduce conflict.");
                    }
                    return false;
                });
            });
        }
        
        public function get rows():uint
        {
            return _states.length;
        }
        
        public function get cols():uint
        {
            return _symbols.size;
        }
        
        public function toAS3Array():Array
        {
            return _table;
        }
        
        public function toHTML():String
        {
            return null;
        }
    }
}