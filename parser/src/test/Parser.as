package test
{
    import flash.utils.ByteArray;

    public class Parser
    {
        [Embed(source="parserData.dat", mimeType="application/octet-stream")]
        private var DataArrays:Class;
        public var actionTable:Array;
        public var gotoTable:Array;
        public var prodList:Array;
        public var inputTable:Object;
        
        public function Parser()
        {
            var encoded:ByteArray = new DataArrays() as ByteArray;
            encoded.inflate();
            actionTable = encoded.readObject() as Array;
            gotoTable = encoded.readObject() as Array;
            prodList = encoded.readObject() as Array;
            inputTable = encoded.readObject() as Object;
        }
        
        public function parse(lexer:Lexer):*
        {
            var stateStack:Array = [0];
            var outputStack:Array = [];
            var state:uint;
            var token:*;
            var act:uint;
            while(true)
            {
                token = lexer.token;
                state = stateStack[stateStack.length - 1];
                if(actionTable[inputTable[token]][state] == null)
                {
                    throw new Error("Parse Error:" + lexer.positionInfo);
                }
                else
                {
                    act = actionTable[inputTable[token]][state];
                }
                if(act == 1)
                {
                    return outputStack.pop();//acc
                }
                else if((act & 1) == 1)//shift
                {
                    outputStack.push(lexer.yytext);
                    stateStack.push((act >>> 1) - 1);
                    lexer.advance();
                }
                else if((act & 1) == 0)//reduce
                {
                    var pi:uint = act >>> 1;
                    var length:uint = prodList[pi][1];
                    var result:* = null;
                    /** actions applying **/
                    /** default action **/
                    if(length > 0)
                        result = outputStack[outputStack.length - length];
                    include "parserActions.txt";
                    /** actions applying end **/
                    var i:uint = 0;
                    while(i < length)
                    {
                        stateStack.pop();
                        outputStack.pop();
                        i ++;
                    }
                    state = stateStack[stateStack.length - 1];
                    if(gotoTable[prodList[pi][0]][state] == null)
                    {
                        throw new Error("Goto Error!" + lexer.positionInfo);
                    }
                    else
                    {
                        act = gotoTable[prodList[pi][0]][state];
                    }
                    stateStack.push((act >>> 1) - 1);
                    outputStack.push(result);
                }
            }
        }
    }
}