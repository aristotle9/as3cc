import avmplus.FileSystem;
import avmplus.System;

import org.lala.lex.configs.LexConfig;
import org.lala.lex.utils.LexerGenerator;

function compile(config:LexConfig):LexerGenerator
{
	var lex:LexerGenerator = new LexerGenerator(config.data);
	lex.generate();
	return lex;
}

var configPath:String = System.argv[0];
trace('using config file: ' + configPath);
var config:LexConfig = new LexConfig(FileSystem.read(configPath));
var lexGen:LexerGenerator = compile(config);
var output:Object = lexGen.saveLexerFile();
var outputPath:String = System.argv.length > 1 ? System.argv[1] : output.name;
trace('output file: ' + outputPath);
FileSystem.write(outputPath, output.data);
trace('success.');