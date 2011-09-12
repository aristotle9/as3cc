package org.lala.lex.utils
{
    import org.lala.lex.interfaces.IEdge;
    import org.lala.lex.interfaces.IInput;
    import org.lala.lex.interfaces.ISet;
    import org.lala.lex.interfaces.IState;
    import org.lala.lex.nfa.InputSet;
    import org.lala.lex.nfa.State;
    
    internal class SubSetInfo
    {
        private var _ste:ISet;
        private var _tag:Object;
        private var _state:IState;
        private var _id:uint;
        
        /** 原来的状态集合 **/
        public function get ste():ISet
        {
            return _ste;    
        }
        public function SubSetInfo(ste:ISet, tag:Object, id:uint)
        {
            _ste = ste;
            _tag = tag;     
            _id = id;
            _state = new State(id);
            _state.data = this;
        }
        /** 状态序号 **/
        public function get id():uint
        {
            return _id;
        }
        /** 新状态 **/
        public function get state():IState
        {
            return _state;
        }
        /** 子集标签 **/
        public function get tag():Object
        {
            return _tag;
        }
        
        public function toString():String
        {
            var result:Array = [];
            function p(str:String):void
            {
                result.push(str);
            }
            function move(from:IState, to:IState, super_to:IState, input:IInput):void
            {
                var res:String = "";
                var ipt:String;
                if(input === InputSet.E)//epsilon
                {
                    ipt = "&epsilon;";
                }
                else
                {
                    ipt = input.info;   
                }
                res += _state.id + ":<f" + from.id;
                res += "> -> " + super_to.id + ":<f";
                res += to.id;
                res += '>[label="' + ipt + '",color="#000",penwidth="1",weight="3"]';
                p(res);
            }
            var tmp:Array = [];
            tmp.push("<f0>" + _state.id + ":" + _tag);
            ste.every(function(s:IState):Boolean
            {
                s.inputs.every(function(ipt:IInput):Boolean
                {
                    if(ipt != InputSet.E)
                    {
                        var super_to:IState = _state.trans(ipt);
                        s.move(ipt).every(function(si:IState):Boolean
                        {
                            move(s, si, super_to, ipt);
                            return false;
                        });
                    }
                    return false;
                });
                if(s.final)
                    tmp.push('<f' + s.id + '>((' + String(s) + '))');
                else
                    tmp.push('<f' + s.id + '>(' + String(s) + ')');
                return false;
            });
            p(_state.id + '[label="' + tmp.join("|") + '",shape="record"]');
            return result.join("\n");
        }
    }
}