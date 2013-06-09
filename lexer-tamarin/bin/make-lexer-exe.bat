java -cp ..\..\..\swfutilsex\deploy\swfutilsex.jar net.thecybershadow.swf.tools.AbcMerge JSON.abc lexer.abc ..\src\Main.abc ..\src\combined.abc
createprojector.exe -exe redshell_d.exe ..\src\combined.abc
rename ..\src\combined.exe Main.exe
del ..\src\combined.abc