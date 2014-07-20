import avmplus.FileSystem;
import avmplus.System;

import org.lala.compilercompile.configs.ParserConfig;
import org.lala.compilercompile.lr0automata.LR0Automata;

var configPath:String = System.argv[0];
trace('using config file: ' + configPath);
var config:ParserConfig = new ParserConfig(FileSystem.read(configPath));
var lr0a:LR0Automata = new LR0Automata(config);
var output:Object = lr0a.saveParserFile();
var outputPath:String = System.argv.length > 1 ? System.argv[1] : output.name;
trace('output file: ' + outputPath);
FileSystem.write(outputPath, output.data);
trace('success.');