#!/bin/sh
./asc -AS3 -strict -import builtin.abc -import toplevel.abc -import ../../lexer-tamarin/bin/JSON.abc -import parser.abc ../src/Main.as
java -cp ../../tools/swfutilsex.jar net.thecybershadow.swf.tools.AbcMerge ../../lexer-tamarin/bin/JSON.abc parser.abc ../src/Main.abc ../src/combined.abc
./createprojector -exe redshell ../src/combined.abc
mv ../src/combined parser-tamarin
rm ../src/combined.abc
echo "parser-tamarin created."
