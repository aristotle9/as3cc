%lex

%package org.lala.compilercompile.configs.plugins
%class JsonToRustLexer

%%

\s+                             /* skip */
[_a-zA-Z$][_a-zA-Z$0-9]*        return "id"
\{                              return "{"
\}                              return "}"
\[                              return "["
\]                              return "]"
\(                              return "("
\)                              return ")"
:                               return ":"
=                               return "="
\,                              return ","
\.                              return "."
;                               return ";"
"[^"]*"                         return "string"

/lex

%package org.lala.compilercompile.configs.plugins
%class JsonToRustParser
%lexer_name JsonToRustLexer

%%

Sts
    : Sts St { $1.args.push($2); $$ = $1; }
    | { $$ = { type: "sts", args: [] }; }
    ;

St
    : id '=' Exp ';' { $$ = { type: "=", args: [$1, $3] }; }
    | Exp '.' id '(' ArrayMembers ')' ';' { $$ = { type: ".()", args: [$1, $3, $5] }; }
    ;

Exp : '(' Exp ')' { $$ = { type: "()", args: [$2] }; }
    | Object { $$ = { type: "object", args: [$1] }; }
    | Array { $$ = { type: "array", args: [$1] }; }
    | id { $$ = { type: "id", args: [$1] }; }
    | string { $$ = { type: "string", args: [$1] }; }
    ;

Object
    : '{' ObjectMembers '}' { $$ = $2; }
    ;

ObjectMembers
    : ObjectMembers ',' ObjectMember { $1.push($3); $$ = $1; }
    | ObjectMember { $$ = [$1] }
    | { $$ = []; }
    ;

ObjectMember
    : id ':' Exp { $$ = { type: "idkey", args: [$1, $3] }; }
    | string ':' Exp { $$ = { type: "strkey", args: [$1, $3] }; }
    ;

Array
    : '[' ArrayMembers ']' { $$ = $2; }
    ;

ArrayMembers
    : ArrayMembers ',' ArrayMember { $1.push($3); $$ = $1; }
    | ArrayMember { $$ = [$1]; }
    | { $$ = []; }
    ;

ArrayMember
    : Exp
    ;
