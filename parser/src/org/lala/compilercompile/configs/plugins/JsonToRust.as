package org.lala.compilercompile.configs.plugins
{
	public class JsonToRust
	{
		private var output: Array;
		private var names: Array;
		private static var name_id: uint = 0;
		public function JsonToRust()
		{
		}
		
		public function trans_code(code: String): String
		{
			var ret: String = null;
			try {
				var ast: Object = JsonToRustParser.parse(code);
				output = [];
				names = [];
				gen_code(ast);
				ret = output.join("");
			} catch(e: Error) {
				ret = code;
			}
			return ret;
		}
		
		private function gen_code(node: Object): void
		{
			var type: String = node.type;
			switch(type)
			{
				case "sts":
					node.args.forEach(function(item: Object, ...args): void
					{
						gen_code(item);
					});
					break;
				case "=":
					if(node.args[0] == "$$") {
						emit(node.args[0]);
						emit(" = Some( ");
						gen_code(node.args[1]);
						emit(" );\n");
					} else {
						emit(node.args[0]);
						emit(" = ");
						gen_code(node.args[1]);
						emit(";\n");
					}
					break;
				case ".()":
					if (node.args[1] == "push" && node.args[0].type == "id" && node.args[0].args[0] == "$$")
					{
						gen_code(node.args[0]);
						emit(".as_mut().unwrap().as_array_mut().unwrap().push(");
						node.args[2].forEach(function(item: Object, i: int, ...args): void
						{
							if (i > 0)
							{
								emit(", ");
							}
							gen_code(item);
						});
						emit(")");
						emit(";\n");
					} else
					{
						gen_code(node.args[0]);
						emit(".", node.args[1], "(");
						node.args[2].forEach(function(item: Object, i: int, ...args): void
						{
							if (i > 0)
							{
								emit(", ");
							}
							gen_code(item);
						});
						emit(")");
						emit(";\n");
					}
					break;
				case "()":
					emit('( ');
					gen_code(node.args[0]);
					emit(' )');
					break;
				case "object":
					emit('{ \n');
					emit("let mut ", push_name(), ": Object = BTreeMap::new();\n");
					node.args[0].forEach(function(item: Object, i: int, ...args): void
					{
						gen_code(item);
					});
					emit("Json::Object( ", pop_name(), " )\n");
					emit(' }');
					break;
				case "array":
					emit('Json::Array( vec![ ');
					node.args[0].forEach(function(item: Object, i: int, ...args): void
					{
						if (i > 0)
						{
							emit(", ");
						}
						gen_code(item);
					});
					emit(' ] )');
					break;
				case "id":
					emit(node.args[0]);
					break;
				case "string":
					emit("Json::String( ", node.args[0], ".to_string() )");
					break;
				case "idkey":
					emit(peek_name(), ".insert( \"", node.args[0], "\".to_string(), "); 
					gen_code(node.args[1]);
					emit(" );\n");
					break;
				case "strkey":
					emit(peek_name(), ".insert( ", node.args[0], ".to_string(), "); 
					gen_code(node.args[1]);
					emit(" );\n");
					break;
			}
		}
		
		private function emit(...args): void
		{
			this.output.push.apply(null, args);
		}
		
		private function push_name():String
		{
			var name: String = "_name_" + name_id ++;
			this.names.push(name);
			return name;
		}
		
		private function peek_name(): String
		{
			return this.names[this.names.length - 1];
		}
		
		private function pop_name(): String
		{
			return this.names.pop();
		}
	}
}