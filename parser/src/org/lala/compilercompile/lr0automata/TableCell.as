package org.lala.compilercompile.lr0automata
{
    import org.lala.compilercompile.interfaces.IProduction;
    import org.lala.compilercompile.interfaces.IState;
    import org.lala.compilercompile.interfaces.ITableCell;
    
    public class TableCell implements ITableCell
    {
        public static const SHIFT:uint = 1;
        public static const REDUCE:uint = 2;
        public static const ACC:uint = 3;
        public static const GOTO:uint = 4;
        public static const ERROR:uint = 5;
        
        protected var _type:uint;
        protected var _state:IState;
        protected var _production:IProduction;
        
        public function TableCell(type:uint, state:IState=null, production:IProduction=null)
        {
            _type = type;
            _state = state;
            _production = production;
        }
        
        public function get type():uint
        {
            return _type;
        }
        
        public function get state():IState
        {
            return _state;
        }
        
        public function get production():IProduction
        {
            return _production;
        }
        
        public function toString():String
        {
            return toUint().toString();
            switch(_type)
            {
                case REDUCE:
                    return 'r'+_production.id;
                case SHIFT:
                    return 's'+_state.id;
                case ACC:
                    return "acc";
                case GOTO:
                    return _state.id.toString();
                case ERROR:
                    return 'err';
            }
            return "undefined";
        }
        /**
        * <pre>表的内容数字化:reduce:偶数 action奇数 acc:1 error:null
        * (x & 1) == 0 => reduce
        * x >> 1 = 产生式编号
        * (x & 1) == 1 => shift
        * (x >> 1) - 1 = 目标标号
        * 0 2 4 6 8
        * 0 1 2 3 4
        * 
        * 3 5 7 9
        * 0 1 2 3
        * 
        * 1 acc</pre>
        ***/
        public function toUint():uint
        {
            switch(_type)
            {
                case REDUCE:
                    return _production.id << 1;
                case SHIFT:
                    return ((_state.id + 1) << 1) + 1;
                case ACC:
                    return 1;
                case GOTO:
                    return ((_state.id + 1) << 1) + 1;
                case ERROR:
                    return uint.MAX_VALUE;
            }
            return uint.MAX_VALUE;
        }
    }
}