package org.lala.lex.nfa
{
    import org.lala.lex.interfaces.IEdge;
    import org.lala.lex.interfaces.IInput;
    import org.lala.lex.interfaces.IInputSet;
    import org.lala.lex.interfaces.ISet;

    /** 管理一个自动机的边 **/
    public class InputSet implements IInputSet
    {
        public static const E:IInput = new Input(0,"&epsilon;");
        protected var _from:uint;
        protected var _to:uint;
        
        protected var _uid:uint = 1;
        protected var _list:Vector.<IInput>;
        protected var _inputs:Vector.<IInput>;
        
        /** 起始状态边:特殊的Input **/
        protected var _inclusives:Object;
        protected var _exclusives:Object;
        /**
        * 构造函数
        * 表示一个从from 到 to的有序字符集是输入集的上限,包括端点
        * @param from 起始位置
        * @param to 结束位置
        ***/
        public function InputSet(from:uint=0x00,to:uint=0xFF)
        {
            _from = from;
            _to = to;
            _inputs = new Vector.<IInput>;
            _list = new Vector.<IInput>;
            var rg:IInput = new Input(getUid());
            rg.setRange(_from, _to);
            _list.push(rg);
            _inputs.push(rg);
            
            _inclusives = {};
            _exclusives = {};
        }
        public function getInput4Char(char:String):IInput
        {
            var code:uint = char.charCodeAt();
            return split(code, code)[0];
        }
        public function getInput4Range(from:uint, to:uint):Vector.<IInput>
        {
            return split(from, to);
        }
        public function getInput4All():Vector.<IInput>
        {
            return _list.slice();
        }
        public function every(foo:Function):void
        {
            _inputs.some(function(ipt:IInput,...args):Boolean
            {
                return foo(ipt);
            });
        }
        public function get inputs():Vector.<IInput>
        {
            return _inputs;            
        }
        protected function getUid():uint
        {
            return _uid ++;
        }
        /**
        * 分割一个新的区间:
        * 左落脚点,要求与左边的区间分离
        ***/
        protected function createLeftPoint(from:uint):void
        {
            var i:uint;
            var ipt:IInput;
            var left:IInput;
            var edge:IEdge;
            i = find(from);
            if(_list[i].from == from)
            {
                return;
            }
            /** 准备分割 **/
            ipt = _list[i];
            /** 实行重用方案,让原来的输入为右输入 **/
            left = new Input(getUid());
            left.setRange(ipt.from, from - 1);
            ipt.setRange(from, ipt.to);
            /** 复制一份边 **/
            ipt.edges.every(function(e:IEdge):Boolean
            {
                edge = e.from.addTrans(left, e.to);
                left.edges.add(edge);
                return false;
            });
            _list.splice(i, 0, left);
            _inputs.push(left);
            return;
        }
        /**
        * 分割一个新的区间:
        * 右落脚点,要求与右边的区间分离
        ***/
        protected function createRightPoint(to:uint):void
        {
            var i:uint;
            var ipt:IInput;
            var right:IInput;
            var edge:IEdge;
            i = find(to);
            if(_list[i].to == to)
            {
                return;
            }
            /** 准备分割 **/
            ipt = _list[i];
            /** 右分量 **/
            right = new Input(getUid());
            /** 设置左右区间长度 **/
            right.setRange(to + 1, ipt.to);
            ipt.setRange(ipt.from, to);
            /** 复制边 **/
            ipt.edges.every(function(e:IEdge):Boolean
            {
                edge = e.from.addTrans(right, e.to);
                right.edges.add(edge);
                return false;
            });
            _list.splice(i + 1, 0, right);
            _inputs.push(right);
            return;
        }
        /**
        * 添加裂缝
        * 在from to 之间分割
        * 像产生新的点,新的区间可以重复使用该操作
        ***/
        protected function split(from:int, to:int):Vector.<IInput>
        {
            var i:uint = 0;
            var j:uint = 0;
            createLeftPoint(from);
            createRightPoint(to);
            i = find(from);
            j = find(to);
            return _list.slice(i, j + 1);
        }
        /**
        * 二分查找
        ***/
        protected function find(code:uint):uint
        {
            var min:uint;
            var max:uint;
            var mid:uint;
            min = 0;
            max = _list.length - 1;
            while(true)
            {
                mid = (min + max) >>> 1;
                if(_list[mid].from <= code && _list[mid].to >= code)
                {
                    return mid;
                }
                else if(_list[mid].from > code)
                {
                    max = mid - 1;
                }
                else
                {
                    min = mid + 1;
                }
            }
            return 0;
        }
        
        public function char2Input(code:uint):IInput
        {
            if(code < _from || code > _to)
            {
                throw new Error("Out of charset expected.");
            }
            return _list[find(code)];
        }
        
        public function inputTable():Array
        {
            var result:Array = new Array;
            var last:Array;
            _list.forEach(function(ipt:IInput, i:uint, ...args):void
            {
                if(result.length >= 1)
                {
                    last = result[result.length - 1];
                    if(last[2] == ipt.compressed)
                    {
                        result[result.length - 1][1] = ipt.to;
                    }
                    else
                    {
                        result.push([ipt.from,ipt.to,ipt.compressed]);
                    }
                }
                else
                {
                    result.push([ipt.from,ipt.to,ipt.compressed]);
                }
            });
            return result;
        }
        
        public function createInclusiveStates(states:Array):void
        {
            states.push("INITIAL");
            states.forEach(function(src:String, ... args):void
            {
                if(src != '' && _inclusives[src] == null && _exclusives[src] == null)
                {
                    var ipt:IInput = new Input(getUid(), src);
                    ipt.setRange(0,0);
                    _inclusives[src] = ipt;
                    _inputs.push(ipt);
                }
            });
        }
        
        public function createExclusiveStates(states:Array):void
        {
            states.forEach(function(src:String, ... args):void
            {
                if(src != '' && _inclusives[src] == null && _exclusives[src] == null)
                {
                    var ipt:IInput = new Input(getUid(), src);
                    ipt.setRange(0,0);
                    _exclusives[src] = ipt;
                    _inputs.push(ipt);
                }
            });
        }
        
        public function getInput4States(states:Array):Vector.<IInput>
        {
            states = states.filter(function(src:String,...args):Boolean
            {
                return src.length == 0 ? false : true;
            });
            var res:Vector.<IInput> = new Vector.<IInput>;
            var ipt:IInput;
            if(states.length == 0)
            {
                for each(ipt in _inclusives)
                {
                    res.push(ipt);
                }
                return res;
            }
            if(states.length == 1 && states[0] == "*")
            {
                for each(ipt in _inclusives)
                {
                    res.push(ipt);
                }
                for each(ipt in _exclusives)
                {
                    res.push(ipt);
                }
                return res;                
            }
            var tmp:Object = {};//去除重复
            states.forEach(function(src:String, ... args):void
            {
                if(src.length == 0)
                {
                    return;
                }
                if(_inclusives[src] != null)
                {
                    tmp[src] = _inclusives[src];
                    return;
                }
                if(_exclusives[src] != null)
                {
                    tmp[src] = _exclusives[src];
                    return;
                }
            });
            for each(ipt in tmp)
            {
                res.push(ipt);
            }
            return res;
        }
        /** 起始状态到输入的转换 **/
        public function statesInputTable():Object
        {
            var res:Object = {};
            var src:String;
            for(src in _inclusives)
            {
                res[src] = (_inclusives[src] as IInput).compressed;
            }
            for(src in _exclusives)
            {
                res[src] = (_exclusives[src] as IInput).compressed;
            }
            return res;
        }
    }
}