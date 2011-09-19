package org.lala.lex.utils
{
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

    public class RegexpMachine002
    {
        private var _code:Array;
        private var _inputSet:IInputSet;
        private var _stateIndex:uint;
        
        private var _bottleIndex:uint = 0;
        private var _workStack:Vector.<INFA>;
        private var _codeStack:Vector.<Array>;
        
        public function RegexpMachine002(inputSet:IInputSet=null)
        {
            _inputSet = inputSet == null ? new InputSet() : inputSet;
        }
        
        public function set code(value:Array):void
        {
            _code = value;
            _stateIndex = 0;
            _workStack = new Vector.<INFA>;
            _codeStack = new Vector.<Array>;
        }
        
        public function execute():INFA
        {
            var sa:IState;
            var sb:IState;
            var sea:IState;
            var seb:IState;
            var nfaT:INFA;
            var nfaS:INFA;
            var ipt:IInput;
            var ipts:Vector.<IInput>;
            var edge:IEdge;
            var inputs:ISet;
            var from:int;
            var to:int;
            var bottleSize:uint = _bottleIndex;
            
            var instr:Array;
            var operand:Array;
            
            for(var i:uint = 0; i < _code.length; i ++)
            {
                instr = _code[i]; 
                switch(instr[0])
                {
                    case 'c':
                    case 'escc':
                        _codeStack.push(instr);
                        break;
                    case 'single':
                        operand = _codeStack.pop();
                        
                        sa = createState();
                        sb = createState();
                        nfaT = new NFA();
                        if(operand[0] == 'c')
                        {
                            ipt = _inputSet.getInput4Char(operand[1]);
                            edge = sa.addTrans(ipt, sb);
                            ipt.edges.add(edge);
                        }
                        else
                        {
                            switch(operand[1])
                            {
                                case '.':
                                    ipts = _inputSet.getInput4All();
                                    break;
                                case '\\d':
                                    ipts = _inputSet.getInput4Range(0x30, 0x39);
                                    break;
                                case '\\s':
                                    ipts = _inputSet.getInput4Range(0x20, 0x20);
                                    ipts.push(_inputSet.getInput4Char("\t"));
                                    ipts.push(_inputSet.getInput4Char("\r"));
                                    ipts.push(_inputSet.getInput4Char("\n"));
                                    ipts.push(_inputSet.getInput4Char("\f"));
                                    break;
                                case '\\w':
                                    ipts = _inputSet.getInput4Range(0x30, 0x39);
                                    ipts = ipts.concat((_inputSet.getInput4Range(0x61, 0x7a)));
                                    ipts = ipts.concat((_inputSet.getInput4Range(0x41, 0x5a)));
                                    ipts.push(_inputSet.getInput4Char("_"));
                                    break;
                            }
                            ipts.forEach(function(ipt:IInput, ... args):void
                            {
                                edge = sa.addTrans(ipt, sb);
                                ipt.edges.add(edge);
                            });
                        }
                        nfaT.entry = sa;
                        nfaT.addExit(sb);
                        nfaT.addState(sa);
                        nfaT.addState(sb);
                        _workStack.push(nfaT);
                        break;
                    case 'range':
                        operand = _codeStack.pop();
                        to = String(operand[1]).charCodeAt();
                        operand = _codeStack.pop();
                        from = String(operand[1]).charCodeAt();
                        ipts = _inputSet.getInput4Range(from, to);
                        
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
                        _workStack.push(nfaT);
                        break;
                    /** 复制栈顶机器 **/
                    case 'dupl':
                        nfaT = _workStack.pop();
                        nfaS = nfaT.clone();
                        _workStack.push(nfaT, nfaS);
                        break;
                    case 'include':
                    case 'exclude':
                        var arity:int = instr[1];
                        inputs = new Set;
                        while(arity > 0)
                        {
                            nfaS = _workStack.pop();
                            nfaS.entry.outEdges.every(function(e:IEdge):Boolean
                            {
                                e.input.edges.remove(e);
                                inputs.add(e.input);
                                return false;
                            });
                            arity --;
                        }
                        
                        sa = createState();
                        sb = createState();
                        nfaT = new NFA();
                        if(instr[0] == 'exclude')
                        {
                            ipts = _inputSet.getInput4All();
                            ipts.forEach(function(ipt:IInput, ... args):void
                            {
                                if(inputs.contains(ipt))
                                {
                                    return;
                                }
                                edge = sa.addTrans(ipt, sb);
                                ipt.edges.add(edge);
                            });
                        }
                        else
                        {
                            inputs.every(function(ipt:IInput):Boolean
                            {
                                edge = sa.addTrans(ipt, sb);
                                ipt.edges.add(edge);
                                return false;
                            });
                        }
                        nfaT.entry = sa;
                        nfaT.addExit(sb);
                        nfaT.addState(sa);
                        nfaT.addState(sb);
                        _workStack.push(nfaT);
                        break;
                    case 'cat':
                        nfaS = _workStack.pop();
                        nfaT = _workStack.pop();
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
                        _workStack.push(nfaT);
                        break;
                    case 'or':
                        sa = createState();
                        sb = createState();
                        nfaS = _workStack.pop();
                        nfaT = _workStack.pop();
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
                        _workStack.push(nfaT);
                        break;
                    case 'star':
                    case 'more':
                    case 'ask':
                        sa = createState();
                        sb = createState();
                        nfaT = _workStack.pop();
                        sea = nfaT.exits.fetch() as IState;
                        sa.addTrans(InputSet.E, nfaT.entry);
                        if(instr[0] != 'more')
                        {
                            sa.addTrans(InputSet.E, sb);
                        }
                        if(instr[0] != 'ask')
                        {
                            sea.addTrans(InputSet.E, nfaT.entry);
                        }
                        sea.addTrans(InputSet.E, sb);
                        nfaT.removeExit(sea);
                        nfaT.addState(sa);
                        nfaT.addState(sb);
                        nfaT.entry = sa;
                        nfaT.addExit(sb);
                        _workStack.push(nfaT);
                        break;
                    case 'trailla'://trail lookahead
                        //一个正则表达式最多只有一个捕捉,并且位于最后第二个位置,最后是cat
                        //验证
                        if(_workStack.length != 2 || i != _code.length - 2)
                        {
                            throw new Error('无法构造NFA,不正确的尾部正向预查.');
                        }
                        var bottle:IBottle = new Bottle(bottleSize);
                        bottleSize ++;
                        nfaT = _workStack.pop();
                        nfaT.entry.updateBottles.add(bottle);
                        sa = nfaT.exits.fetch() as IState;
                        sa.catchBottles.add(bottle);
                        _workStack.push(nfaT);
                        break;
                }
            }
            nfaT = _workStack.pop();
            nfaT.inputSet = _inputSet;
            _bottleIndex += bottleSize;
            nfaT.bottleSize = bottleSize;
            return nfaT;
        }
        
        private function createState():IState
        {
            return new State(_stateIndex ++);
        }
    }
}