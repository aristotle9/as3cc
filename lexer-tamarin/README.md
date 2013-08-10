## Compile a command-line tool with redtamarin

### redtamarin

<https://code.google.com/p/redtamarin/>

### build tools

<https://code.google.com/p/redtamarin/wiki/GettingStarted>

### usage

Copy /redtamarin-tools/bin contents to /as3cc/lexer-tamarin/bin.

Compile lexer.abc lib: build-lexer.abc.bat

```
asc.exe -AS3 -strict -import builtin.abc -import toplevel.abc -import JSON.abc ..\..\lexer\src\include.as 
copy ..\..\lexer\src\include.abc lexer.abc
```

Make a runnable executer: make-lexer-exe.bat

```
java -cp ..\..\..\swfutilsex\deploy\swfutilsex.jar net.thecybershadow.swf.tools.AbcMerge JSON.abc lexer.abc ..\src\Main.abc ..\src\combined.abc
createprojector.exe -exe redshell_d.exe ..\src\combined.abc
rename ..\src\combined.exe Main.exe
del ..\src\combined.abc
```

swfutilsex.jar: <https://github.com/CyberShadow/swfutilsex>