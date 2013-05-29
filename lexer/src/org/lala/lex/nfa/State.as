package org.lala.lex.nfa
{
    import org.lala.lex.interfaces.IBottle;
    import org.lala.lex.interfaces.IEdge;
    import org.lala.lex.interfaces.IInput;
    import org.lala.lex.interfaces.ISet;
    import org.lala.lex.interfaces.IState;
    
    public class State implements IState
    {
        private var _data:Object;
        private var _inputs:Set;
        private var _id:uint;
        private var _final:Boolean;
        private var _inEdges:Set;
        private var _outEdges:Set;
        
        private var _catchBottles:ISet;
        private var _updateBottles:ISet;
        
        public function State(id:uint)
        {
            _id = id;
            _final = false;
            _inputs = new Set;
            _inEdges = new Set;
            _outEdges = new Set;
            _catchBottles = new Set;
            _updateBottles = new Set;
        }
        
        public function get data():Object
        {
            return _data;
        }
        
        public function set data(obj:Object):void
        {
            _data = obj;
        }
        
        public function get inputs():ISet
        {
            return _inputs;
        }
        
        public function get id():uint
        {
            return _id;
        }
        
        public function set id(value:uint):void
        {
            _id = value;
        }
        
        public function get final():Boolean
        {
            return _final;
        }
        
        public function set final(value:Boolean):void
        {
            _final = value;
        }
        
        public function get inEdges():ISet
        {
            return _inEdges;
        }
        
        public function get outEdges():ISet
        {
            return _outEdges;
        }
        
        public function move(ipt:IInput):ISet
        {
            var res:Set = new Set;
            _outEdges.every(function(edge:IEdge):Boolean
            {
                if(edge.input == ipt)
                {
                    res.add(edge.to);
                }
                return false;
            });
            return res;
        }
        
        public function trans(ipt:IInput):IState
        {
            var res:IState = null;
            _outEdges.every(function(edge:IEdge):Boolean
            {
                if(edge.input == ipt)
                {
                    res = edge.to;
                    return true;
                }
                return false;
            });
            return res;
        }
        
        public function addTrans(ipt:IInput, to:IState):IEdge
        {
            var edge:Edge = new Edge(this, ipt, to);
            _outEdges.add(edge);
            _inputs.add(ipt);
            to.inEdges.add(edge);
            return edge;
        }
        
        public function merge(s:IState):void
        {
            throw new Error("Not implement.");
        }

        public function get catchBottles():ISet
        {
            return _catchBottles;
        }

        public function get updateBottles():ISet
        {
            return _updateBottles;
        }
        
        public function toString():String
        {
            var result:Array = [];
            var a:Array;
            function p(str:String):void
            {
                result.push(str);
            }
            p(_id.toString());
            if(_final)
            {
                p("final:" + String(_data));
            }
            if(_updateBottles.size)
            {
                a = [];
                _updateBottles.every(function(bottle:IBottle):Boolean
                {
                    a.push(bottle.id);
                    return false;
                });
                p("u:[" + a.join(",") + "]");
                
            }
            if(_catchBottles.size)
            {
                a = [];
                _catchBottles.every(function(bottle:IBottle):Boolean
                {
                    a.push(bottle.id);
                    return false;
                });
                p("c:[" + a.join(",") + "]");
            }
            return result.join(";");
        }
    }
}