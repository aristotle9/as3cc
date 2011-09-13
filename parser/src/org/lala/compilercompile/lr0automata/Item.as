package org.lala.compilercompile.lr0automata
{
    import org.lala.compilercompile.interfaces.IItem;
    import org.lala.compilercompile.interfaces.IProduction;
    import org.lala.compilercompile.interfaces.IState;
    import org.lala.compilercompile.interfaces.ISymbol;
    
    public class Item implements IItem
    {
        protected var _id:uint;
        protected var _production:IProduction;
        protected var _position:uint;
        protected var _data:Object;
        
        public function Item(p:IProduction, position:uint)
        {
            _production = p;
            _position = position;
            _id = p.preLength + position;
        }
        
        public function get id():uint
        {
            return _id;
        }
        
        public function get production():IProduction
        {
            return _production;
        }
        
        public function get position():uint
        {
            return _position;
        }
        
        public function get nextSymbol():ISymbol
        {
            if(position == production.size)
            {
                return null;
            }
            return production.right[position];
        }
        
        public function createNext():IItem
        {
            if(position == production.size)
            {
                return null;
            }
            return new Item(production, position + 1);
        }

        public function get data():Object
        {
            return _data;
        }

        public function set data(value:Object):void
        {
            _data = value;
        }
        
        public function goto(sm:ISymbol):IItem
        {
            if(nextSymbol == null)
                return null;
            if(nextSymbol == sm)
            {
                return new Item(_production, position + 1);
            }
            return null;
        }
        
        public function toString():String
        {
            var res:String = '(' + production.id + '): ';
            res += production.left.htmlText;
            res += " -&gt; ";
            var a:Array = [];
            production.right.forEach(function(sm:ISymbol, i:uint, ...args):void
            {
                if(i == position)
                {
                    a.push("&bull;");
                }
                a.push(sm.htmlText);
            });
            if(position == production.size)
            {
                a.push("&bull;");
            }   
            res += a.join(" ");
            return res;
        }
    }
}