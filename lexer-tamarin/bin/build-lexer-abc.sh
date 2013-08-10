#!/bin/sh
./asc -AS3 -strict -import builtin.abc -import toplevel.abc -import JSON.abc ../../lexer/src/include.as
cp ../../lexer/src/include.abc lexer.abc