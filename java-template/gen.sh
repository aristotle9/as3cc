#!/bin/bash

CUR_DIR=`pwd`
TARGET_DIR=$CUR_DIR/src/org/lala/lex/utils/parser
SRC_DIR=$CUR_DIR/../examples/src

cd $TARGET_DIR
APP_DIR=$CUR_DIR/../lexer-tamarin/bin
APP=lexer-tamarin
$APP_DIR/$APP $SRC_DIR/regexp-codegen-java.lpc
APP_DIR=$CUR_DIR/../parser-tamarin/bin
APP=parser-tamarin
$APP_DIR/$APP $SRC_DIR/regexp-codegen-java.lpc
cd ~-
