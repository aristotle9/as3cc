#!/bin/sh
./asc -AS3 -strict -import builtin.abc -import toplevel.abc -import JSON.abc -import lexer.abc ../src/Main.as
java -cp ../../tools/swfutilsex.jar net.thecybershadow.swf.tools.AbcMerge JSON.abc lexer.abc ../src/Main.abc ../src/combined.abc
./createprojector -exe redshell ../src/combined.abc
mv ../src/combined lexer-tamarin
rm ../src/combined.abc
echo "lexer-tamarin created."
