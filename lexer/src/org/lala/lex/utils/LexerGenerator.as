package org.lala.lex.utils
{
    import com.maccherone.json.JSON;
    
    import flash.utils.ByteArray;
    
    import org.lala.lex.interfaces.IInput;
    import org.lala.lex.interfaces.INFA;
    import org.lala.lex.nfa.InputSet;

    public class LexerGenerator
    {
        private var _config:Object;
        private var _done:Boolean;
        
        private var _dfa:INFA;
        private var _byte:ByteArray;
        
        private var _finalIndices:Object;
        private var _stateTrans:Array;
        private var _inputTrans:Array;
        private var _statesInputTable:Object;
        
        public function LexerGenerator(conf:Object)
        {
            this._config = conf;
            _done = false;
        }
        
        public function generate():void
        {
            if(!_done)
            {
                createLexDFA();
                createTables();
                _done = true;
            }
        }
        
        private function createLexDFA():void
        {
            var nfa:INFA;
            nfa = RegexUtil.CREATE_NFA(_config.lexer.rules, 0, 0xffff, _config.lexer.states);
            nfa = RegexUtil.NFA_DFA(nfa);
            this._dfa = NFAUtil.min_dfa(nfa, true);
        }
        
        private function createTables():void
        {
            /** 未压缩的转换表 **/
            var stateTable:Array = RegexUtil.DFA_TABLE(_dfa); 
            /** [压缩的转换表,输入的等价表] **/
            var result1:Object = RegexUtil.INPUT_COMPRESS(stateTable);
            var fgTable:Array = RegexUtil.COMPRESS2(result1.table, result1.colLength);
            /** 最终状态到表达式ID的映射 **/
            var finalStates:Object = RegexUtil.FINAL_STATES(_dfa);
            /** 输入的等价表 **/
            var inputTable:Array = result1.input;
            /** 把输入的等价ID写到输入集上,inputSet.inputTable()才有效 **/
            _dfa.inputSet.every(function(ipt:IInput):Boolean
            {
                if(ipt != InputSet.E)
                {
                    ipt.compressed = inputTable[ipt.id];
                }
                return false;
            });
            /** 起始状态(字符串)到输入ID的转换表 **/
            var statesInputTable:Object = RegexUtil.DFA_INPUT_STATES(_dfa, fgTable[0]);
            /** 压缩 [压缩的转换表,最终状态表,从字符编码到输入的等价ID的表,起始状态表] **/
//            _byte = RegexUtil.TABLES_COMPRESS(fgTable, finalStates, _dfa.inputSet.inputTable(), statesInputTable);
            
            _stateTrans = fgTable;
            _finalIndices = finalStates;
            _inputTrans = _dfa.inputSet.inputTable();
            _statesInputTable = statesInputTable;
        }
        
        public function get tableBytes():ByteArray
        {
            if(_done)
                return _byte;
            else
                throw new Error("转换未进行.");
        }
        
        public function get actionString():String
        {
            return RegexUtil.ACTION_FILE(_config);
        }
        
        public function get tableString():String
        {
            var ret:Array = [];
            ret.push('_transTable = ');
            ret.push(com.maccherone.json.JSON.encode(_stateTrans));
            ret.push(';_finalTable = ');
            ret.push(com.maccherone.json.JSON.encode(_finalIndices).replace(/"(\d+)"(?=\s*:)/g,'$1'));
            ret.push(';_inputTable = ');
            ret.push(com.maccherone.json.JSON.encode(_inputTrans));
            ret.push(';_initialTable = ');
            ret.push(com.maccherone.json.JSON.encode(_statesInputTable));
            ret.push(';');
            return ret.join('\r\n');
        }
        
        public function get dotString():String
        {
            return RegexUtil.nfa_dot(_dfa);
        }
        
        public function saveLexerFile():Object
        {
			var data:String;
			var fileName: String;
			var fileData:LexerFile = new LexerFile(_config.lexer);
			
			var outputType:String = _config.lexer.fields.output_type;
			
			if(outputType == null)
				outputType = OutputFileType.ACTIONSCRIPT3;
			
			if(outputType == OutputFileType.ACTIONSCRIPT3)
			{
				fileData.actions = actionString;
				fileData.tables = tableString;

				data = (new TplRender()).render(fileData.getRenderObject());
				fileName = fileData.className + '.as';
			}
			else if(outputType == OutputFileType.JAVA)
			{
	            fileData.actions = JavaFileGenerator.getActions(_config);
	            fileData.tables = javaTableString;
				
				data = (new JavaTplRender()).render(fileData.getRenderObject())
				fileName = fileData.className + '.java';
			}
			else if(outputType == OutputFileType.RUST)
			{
				var rfg: RustFileGenerator = new RustFileGenerator(_config, this._stateTrans, this._finalIndices, this._inputTrans, this._statesInputTable);
				data = rfg.render();
				fileName = rfg.fileName;
			}
			else if(outputType == OutputFileType.TYPESCRIPT)
			{
				var tfg: TypeScriptFileGenerator = new TypeScriptFileGenerator(_config, this._stateTrans, this._finalIndices, this._inputTrans, this._statesInputTable);
				data = tfg.render();
				fileName = tfg.fileName;
			}
			
            return {
				data: data,
				name: fileName
			};
        }
		
		public function get javaTableString():String
		{
			var jFileGen: JavaFileGenerator = new JavaFileGenerator(this._stateTrans, this._finalIndices, this._inputTrans, this._statesInputTable);
			var ret:Array = [];
			ret.push('_transTable = ');
			ret.push(jFileGen.transTable);
			ret.push(';_finalTable = ');
			ret.push(jFileGen.finalTable);
			ret.push(';_inputTable = ');
			ret.push(jFileGen.inputTable);
			ret.push(';_initialTable = ');
			ret.push(jFileGen.initialTable);
			ret.push(';');
			return ret.join('\r\n');
		}
    }
}