TARGET_DIR=target
SDK_DIR=tools/redtamarin/mac
export ASC=$(SDK_DIR)/asc.jar
ASC_CC=$(SDK_DIR)/asc
PROJECTOR=$(SDK_DIR)/createprojector

AS3_IMPORT=-import $(SDK_DIR)/builtin.abc -import $(SDK_DIR)/toplevel.abc
JSON_IMPORT=-import $(TARGET_DIR)/JSON.abc

JSON.abc:
	mkdir -p $(TARGET_DIR)
	$(ASC_CC) -AS3 -strict $(AS3_IMPORT) pretty_json_encoder/include.as
	mv pretty_json_encoder/include.abc $(TARGET_DIR)/JSON.abc

lexer.abc: JSON.abc
	$(ASC_CC) -AS3 -strict $(AS3_IMPORT) $(JSON_IMPORT) lexer/src/include.as
	mv lexer/src/include.abc $(TARGET_DIR)/lexer.abc

lexer-main.abc: lexer.abc
	$(ASC_CC) -AS3 -strict $(AS3_IMPORT) $(JSON_IMPORT) -import $(TARGET_DIR)/lexer.abc lexer-tamarin/src/Main.as
	mv lexer-tamarin/src/Main.abc $(TARGET_DIR)/lexer-main.abc

as3cc-lexer: lexer-main.abc
	java -cp tools/swfutilsex.jar net.thecybershadow.swf.tools.AbcMerge $(TARGET_DIR)/JSON.abc $(TARGET_DIR)/lexer.abc $(TARGET_DIR)/lexer-main.abc $(TARGET_DIR)/as3cc-lexer.abc
	$(PROJECTOR) -exe $(SDK_DIR)/redshell $(TARGET_DIR)/as3cc-lexer.abc

parser.abc: JSON.abc
	$(ASC_CC) -AS3 -strict $(AS3_IMPORT) $(JSON_IMPORT) parser/src/include.as
	mv parser/src/include.abc $(TARGET_DIR)/parser.abc

parser-main.abc: parser.abc
	$(ASC_CC) -AS3 -strict $(AS3_IMPORT) $(JSON_IMPORT) -import $(TARGET_DIR)/parser.abc parser-tamarin/src/Main.as
	mv parser-tamarin/src/Main.abc $(TARGET_DIR)/parser-main.abc

as3cc-parser: parser-main.abc
	java -cp tools/swfutilsex.jar net.thecybershadow.swf.tools.AbcMerge $(TARGET_DIR)/JSON.abc $(TARGET_DIR)/parser.abc $(TARGET_DIR)/parser-main.abc $(TARGET_DIR)/as3cc-parser.abc
	$(PROJECTOR) -exe $(SDK_DIR)/redshell $(TARGET_DIR)/as3cc-parser.abc

all: as3cc-lexer as3cc-parser

clean:
	rm $(TARGET_DIR)/*.abc
	rm $(TARGET_DIR)/as3cc-*
