package org.lala.lex.utils
{
    import flash.utils.ByteArray;

    public class CFileGenerator
    {
        //状态跳转与二阶输入转换表
        protected var stateTable:Array;
        //终结状态与词法的对应表
        protected var finalStates:Object;
        //一阶转换表
        protected var inputTable:Array;
        //初始状态与输入的对应表
        protected var initialInput:Object;
        //使用已经压缩的字节生成c/c++语言使用的代码文件
        public function CFileGenerator(data:ByteArray)
        {
            var byte:ByteArray = new ByteArray;
            byte.writeBytes(data);
            byte.inflate();
            
            stateTable = byte.readObject() as Array;
            finalStates = byte.readObject() as Object;
            inputTable = byte.readObject() as Array;
            initialInput = byte.readObject() as Object;
        }
        
        public function getInputArray():String
        {
            return transformInputArray(inputTable);
        }
        
        public function getStates():String
        {
            return transformStates(stateTable, finalStates);
        }
        
        //生成一阶输入转换数组
        protected static function transformInputArray(inputTable:Array):String
        {
            //单元个数
            var length:uint = inputTable.length;
            //字符编码范围
            var min:uint = inputTable[0][0];
            var max:uint = inputTable[length - 1][1];
            
            //转出的数组代码:{min, max, length, trple x length }
            var ret:Vector.<uint> = new Vector.<uint>;
            ret.push(min, max, length);
            for each(var a:Array in inputTable)
            {
                ret.push(a[0], a[1], a[2]);
            }
            return '{' + ret.join(', ') + '}';
        }
        
        //生成二阶输入与状态转换表
        protected static function transformStates(stateTable:Array, finalStates:Object):String
        {
            //状态个数
            var length:uint = stateTable.length;
            //true表示是dead,有时候死状态也不会有对应的词法单元
            var isDeadState:Vector.<Boolean> = new Vector.<Boolean>(length);
            //对应的词法单元序号,非终结符的值为0xffff
            var lexerCode:Vector.<uint> = new Vector.<uint>(length);
            //二阶转换表与输出状态实体偏移值,死状态的值为0xffffffff,应该不会用到
            var entityOffset:Vector.<uint> = new Vector.<uint>(length);
            //单元实体集合
            var entities:Vector.<uint> = new Vector.<uint>;
            
            //记录偏移,头的长度是3,偏移是3 * length
            var relativeOffset:uint = 3 * length;
            stateTable.forEach(function(a:Array, i:uint, p:*):void
            {
                isDeadState[i] = a[0];
                if(finalStates.hasOwnProperty(i))
                {
                    lexerCode[i] = finalStates[i];
                }
                else
                {
                    lexerCode[i] = 0xffffffff;
                }
                
                //不是死状态
                if(!a[0])
                {
                    entityOffset[i] = relativeOffset;
                    //一个单元实体的内容是:输出状态长度,二阶转换表的长度,输出状态,二阶转换表(三个一组)
                    relativeOffset += 2 + a[1].length + a[2].length * 3;
                    //填充单元实体,好像第一个状态可以移除
                    entities.push(a[1].length, a[2].length);
                    entities.push.apply(null, a[1]);
                    for each(var b:Array in a[2])
                    {
                        entities.push.apply(null, b);
                    }
//                    trace(relativeOffset);
//                    trace(entities.length);
//                    trace();
                }
                else
                {
                    //死状态的偏移值是0xffffffff,是否是死状态不靠这个值来判断
                    entityOffset[i] = 0xffffffff;
                }
            });
            var ret:Vector.<uint> = new Vector.<uint>;
            for(var i:uint = 0; i < length; i++)
            {
                ret.push(isDeadState[i], lexerCode[i], entityOffset[i]);
            }
            ret = ret.concat(entities);
            return '{' + ret.join(', ') + '}';
        }
        
    }
}