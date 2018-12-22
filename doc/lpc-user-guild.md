LPC User Guild
==============

The lpc file is a parser configuration for a language. The as3cc programs use lpc file as source to generate a lexer or a parser.

Lpc file consists of two parts: a lexer config part and a parser config part. as3cc-lexer uses the lexer part and as3cc-parser uses the parser part.

This document is guild for writing lpc file. For more detail, please check [the lpc file of lpc language](#../examples/src/lexer_highlight.lpc).

Table of Contents
=================

* [Comments](#comments)
* [Scaffold](#scaffold)
* [Lexer Declarations](#lexer-declarations)
    * [Package Command](#package-command)
    * [Class Command](#class-command)
    * [Import Command](#import-command)
    * [Initial Command](#initial-command)
    * [Field Command](#field-command)
    * [Code Block](#code-block)
    * [Include Command](#include-command)
    * [Exclude Command](#exclude-command)
* [Token Rules](#token-rules)
    * [Lexer Rule Pattern](#lexer-rule-pattern)
    * [Expression](#expression)
    * [Special Characters](#special-characters)
    * [Special Expression](#special-expression)
* [Parser Declarations](#parser-declarations)
    * [Package Command](#package-command-1)
    * [Class Command](#class-command-1)
    * [Import Command](#import-command-1)
    * [Initial Command](#initial-command-1)
    * [Field Command](#field-command-1)
    * [Lexer Name Command](#lexer-name-command)
    * [Left Command](#left-command)
    * [Right Command](#right-command)
    * [Non-associative Command](#non-associative-command)
    * [Start Command](#start-command)
* [Grammar Rules](#grammar-rules)

Comments
========
Comment always begins with `/*`, and ends with `*/`. Anything between them is ignored. Comments can appearance at anywhere in lpc file.

Scaffold
========

```
%lex
/* Lexer declarations */
%%
/* Token rules */
/lex
/* Parser declarations */
%%
/* Grammar rules */
```

Lexer Declarations
==================
Lexer declarations are commands which effect lexer code generating. In detail, token rule declarations effect token parsing, and code config declarations provide configuration options for targe code.

## Package Command

`%package package_name`

Package command specifics the package name of the generated code file.

## Class Command

`%class class_name`

Class command specifics the class name of the generated lexer.

## Import Command

`%import imported_package_name`

Import commands are used in target code template's import part.

## Initial Command

`%initial %{initial_code%}`

Initial command specifics a code block in the target code template's initial part.

## Field Command

`%field field_name %{field_content%}`

Field command defines a named filed with code block, which could be used in code template, this is target language specific.

## Code Block

`%{code%}`

Arbitrary number of code blocks can appearance at lexer declaration's area, and where these are include is determined by target code template.

## Include Command

`%s state1 state2 ...`

Inlcude command defines a list of lexer states which are inclusive.

The generated lexer has a global state, which effects next match's candidate rules. A rule defined in lpc's lexer part belongs to many states, which in the leads's angle brackets. `INITAL` state is the start state. A rule without leading angle brackets could be matched in `INITIAL` state or any other inclusive states. Otherwise a rule can only be used to match under its belonged states.

In other words, a rule only can be matched in its states, and empty state rule belongs to all inclusive states and 'INITIAL' state.

A rule which leads `<*>` belongs to all states, that include `INITIAL` state, inclusive states and exclusive states.

Lexer's state can be changed in rule action, of which rule is currently be matched.

## Exclude Command

`%x state1 state2 ...`

Inlcude command defines a list of lexer states which are exclusive.

Token Rules
===========

```
Rules
    : RuleList
    |
    ;

RuleList
    : RuleList RuleItem
    | RuleItem
    ;

RuleItem
    : Pattern LexAction
    ;

Pattern
    : "<" Names ">" pattern
    | pattern
    ;

LexAction
    : action
    |
    ;

Names
    : Names name
    | name
    ;
```

## Lexer Rule Pattern

Lexer rule pattern is a tiny regular expression language, and it's complied to DFA implemention in target code by as3cc-lexer. Compared to JavaScript Regex, it is lack of named group and back-traking.

For more detail, please check [the lpc file of lexer rule pattern](#../examples/src/regexp-codegen.lpc).

## Expression

| Expression | Meaning |
|---|---|
| ab | concat expression a and expression b |
| a\|b | match expression a or expression b |
| a* | repeat expression a zero or more times |
| a+ | repeat expression a one or more times |
| a? | repeat expression a zero or one time |
| (a) | group expression a |
| a{n} | repeat expression a exactly n times |
| a{n,m} | repeat expression a between n and m times |
| a{n,} | repeat expression a n or more times |
| a{,n} | repeat expression a zero to n times |
| \[xyz\] | character set include x, y, z |
| \[x-y\] | character set from x to y |
| \[^xyz\] | character set excludes x, y, z |

## Special Characters

| Special Characters | Meaning |
|---|---|
| `\0[0-7]{2}` | octal |
| `\x[0-9a-fA-F]{2}` | hex ascii |
| `\u[0-9a-fA-F]{4}` | hex unicode |
| \d | `[0-9]` |
| \s | `[ \t\r\n\f]` |
| \w | `[0-9a-zA-Z_]` |
| \r | return |
| \n | new line |
| \t | tab |
| \b | backspace |
| \f | form |
| `\c` | escape next character c, literal |
| `.` | all characters |

## Special Expression

| Special Expression | Meaning |
|---|---|
| `[.]` | `.` |
| `[\d]` | `\d` |
| `[\s]` | `\s` |
| `[\w]` | `\w` |
| `[*]` | `\*` |
| `[+]` | `\+` |
| `[?]` | `\?` |
| `[(]` | `\(` |
| `[)]` | `\)` |
| `[|]` | `\|` |
| `[[]` | `\[` |
| `[{]` | `\{` |
| `[}]` | `\}` |

Parser Declarations
===================
Parser declarations are commands which effect parser code generating. In detail, Grammar rule declarations effect grammar parsing, and code config declarations provide configuration options for targe code.

## Package Command

`%package package_name`

## Class Command

`%class class_name`

## Import Command

`%import imported_package_name`

## Initial Command

`%initial %{initial_code%}`

## Field Command

`%field field_name %{field_content%}`

## Lexer Name Command

`%lexer_name lexer_name`

The lexer class name used in this parser.

## Left Command

`%left token1 token2 ...`

Left command defines a list of operators with left associative and the same precedence. Left and right commands' orders are important. The latter has high precedence than former.

## Right Command

`%right token1 token2 ...`

Right command defines a list of operators with right associative and the same precedence. Left and right commands' orders are important. The latter has high precedence than former.

## Non-associative Command

`%nonassoc token1 token2 ...`

Non-associative commands normally are not used explicitly. A symbol which not declared in left or right command default has `nonassoc` associative. A symbol with `nonassoc` will potentially cause an shift-reduce conflict, then the association must be defined.

## Start Command

`%start start_symbol`

Start command specifics the start symbol of the language grammar. When start command is absent, the first symbol is used as the start symbol.

Grammar Rules
=============

```
GrammarRules
    : GrammarRules GrammarRule
    |
    ;

GrammarRule
    : grammar_id ":" HandleActions ";"
    ;

HandleActions
    : HandleActions "|" HandleAction
    | HandleAction
    ;

HandleAction
    : Handle Prec Action
    | Handle Action
    ;

Handle
    : Tokens
    |
    ;

Prec
    : grammar_dec_prec Symbol
    ;

Action
    : "{" ActionBody "}"
    |
    ;

ActionBody
    : ActionBody "{" ActionBody "}" ActionBody
    | grammar_action_body
    |
    ;

Symbol
    : grammar_id
    | grammar_string
    ;
```