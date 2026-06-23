%{
#include "q7_tac.tab.h"
#include <string.h>
#include <stdlib.h>
#include <stdio.h>

int line_number = 1;
%}

DIGIT       [0-9]
LETTER      [a-zA-Z_]
ID          {LETTER}({LETTER}|{DIGIT})*
INT_CONST   {DIGIT}+
FLOAT_CONST {DIGIT}+"."{DIGIT}+
WS          [ \t\r]+

%%

"\n"            { line_number++; }
{WS}            { }

"int"           { yylval.sval = strdup(yytext); return TYPE; }
"float"         { yylval.sval = strdup(yytext); return TYPE; }
"bool"          { yylval.sval = strdup(yytext); return TYPE; }

"if"            { return IF; }
"else"          { return ELSE; }
"while"         { return WHILE; }
"print"         { return PRINT; }
","             { return COMMA; }

"=="|"!="|"<="|">="|"<"|">" { yylval.sval = strdup(yytext); return OP_REL; }
"&&"|"||"                   { yylval.sval = strdup(yytext); return OP_LOGIC; }
"+"|"-"                     { yylval.sval = strdup(yytext); return OP_ADD; }
"*"|"/"|"%"                 { yylval.sval = strdup(yytext); return OP_MUL; }

"="                         { return '='; }
"!"                         { return '!'; }

";"|"("|")"|"{"|"}"         { return yytext[0]; }

{FLOAT_CONST}               { yylval.sval = strdup(yytext); return FLOAT_CONST; }
{INT_CONST}                 { yylval.sval = strdup(yytext); return INT_CONST; }
{ID}                        { yylval.sval = strdup(yytext); return ID; }

.                           { printf("Lexical Error at line %d: %s\n", line_number, yytext); }

%%

int yywrap() { return 1; }
