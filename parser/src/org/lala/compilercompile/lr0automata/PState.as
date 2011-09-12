package org.lala.compilercompile.lr0automata
{
    import org.lala.compilercompile.interfaces.INonTerminal;
    import org.lala.compilercompile.interfaces.IPState;
    import org.lala.compilercompile.interfaces.IProduction;
    import org.lala.compilercompile.interfaces.ISet;
    import org.lala.compilercompile.interfaces.IState;
    import org.lala.compilercompile.interfaces.ISymbol;
    
    public class PState implements IPState
    {
        protected var _state:IState;
        protected var _nonterminal:INonTerminal;
        protected var _production:IProduction;
        /**
        * false:非产生式状态
        **/
        protected var _type:Boolean;
        protected var _id:uint;
        protected var _dr:ISet;
        protected var _reads:ISet;
        protected var _includes:ISet;
        protected var _lookback:ISet;
        
        protected var _readSet:ISet;
        protected var _followSet:ISet;
        protected var _lookaheadSet:ISet;
        
        public function PState(id:uint, state:IState, nt:INonTerminal, p:IProduction=null)
        {
            _id = id;
            _state = state;
            _nonterminal = nt;
            _production = p;
            _type = false;
            if(nt == null && p != null)
            {
                _type = true;
            }
            
            _dr = new SymbolSet();
            _reads = new SymbolSet();
            _includes = new SymbolSet();
            _lookback = new SymbolSet();
            
//            _readSet = new SymbolSet();
            _lookaheadSet = new SymbolSet;
        }
        
        public function get state():IState
        {
            return _state;
        }
        
        public function get type():Boolean
        {
            return _type;
        }
        
        public function get nonterminal():INonTerminal
        {
            return _nonterminal;
        }
        
        public function get production():IProduction
        {
            return _production;
        }
        
        public function get id():uint
        {
            return _id;
        }
        
        public function get reads():ISet
        {
            return _reads;
        }
        
        public function get lookback():ISet
        {
            return _lookback;
        }
        
        public function get includes():ISet
        {
            return _includes;
        }
        
        public function addReads(pst:IPState):void
        {
            _reads.add(pst);
        }
        
        public function addIncludes(pst:IPState):void
        {
            _includes.add(pst);
        }
        
        public function addLookback(pst:IPState):void
        {
            _lookback.add(pst);
        }
        
        public function get dr():ISet
        {
            return _dr;
        }
        
        public function get readSet():ISet
        {
            return _readSet;
        }
        
        public function set readSet(value:ISet):void
        {
            _readSet = value;    
        }
        
        public function get followSet():ISet
        {
            return _followSet;
        }
        
        public function set followSet(value:ISet):void
        {
            _followSet = value;    
        }
        
        public function get lookaheadSet():ISet
        {
            return _lookaheadSet;
        }
        
        public function toString():String
        {
            /** 调试信息,疑之前计算的LA集对于特殊的产生式有误 **/
            var result:Array = [];
            result.push("s:" + _state.id);
            result.push("a:" + (_type == false ? _nonterminal.text : "null"));
            result.push("p:" + (_type == true ? _production.id : "null"));
            var str:Array = [];
            if(_type == false)
            {
                _dr.every(function(sm:ISymbol):Boolean
                {
                    str.push(sm.text);
                    return false;
                });
            }
            result.push("dr: " + str.join(" "));
            result.push("id:" + _id);
            return result.join("\\n");
        }
    }
}