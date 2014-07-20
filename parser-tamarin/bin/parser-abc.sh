#!/bin/sh
./asc -AS3 -strict -import builtin.abc -import toplevel.abc -import ../../lexer-tamarin/bin/JSON.abc ../../parser/src/include.as
cp ../../parser/src/include.abc parser.abc