import avmplus.FileSystem;
import avmplus.System;

import org.lala.compilercompile.configs.ParserConfig;
import org.lala.compilercompile.lr0automata.LR0Automata;
// import com.maccherone.json.JSON;

function parse_arguments(): Object {
    var free_args = [];
    var named_args = {};
    for(var i = 0; i < System.argv.length; i ++) {
        var item = System.argv[i];
        if (item.indexOf("--") == 0) {
            if (i + 1 < System.argv.length) {
                var item2 = System.argv[i + 1];
                if (item2.indexOf("--") == 0) {
                    named_args[item.substring(2)] = true;
                } else {
                    named_args[item.substring(2)] = System.argv[i + 1];
                }
                i += 1;
            } else {
                named_args[item.substring(2)] = true;
            }
        } else {
            free_args.push(item);
        }
    }
    return {
        named_args: named_args,
        free_args: free_args
    };
}

var args = parse_arguments();

var configPath:String = args.free_args[0];
trace('using config file: ' + configPath);

var config:ParserConfig = new ParserConfig(FileSystem.read(configPath));

/// change config by command line arguments
if (args.named_args["output_type"]) {
    config.data.parser.fields.output_type = args.named_args["output_type"];
    // trace(JSON.encode(config));
}

var lr0a:LR0Automata = new LR0Automata(config);

var output:Object = lr0a.saveParserFile();
var outputPath:String = args.free_args.length >= 2 ? args.free_args[1] : output.name;
trace('output file: ' + outputPath);

FileSystem.write(outputPath, output.data);
trace('success.');
