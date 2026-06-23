%{
#include <stdio.h>
int line_number = 1;
%}

 /* Regular Expression Definitiions */
DIGIT       [0-9]
LETTER      [a-zA-Z_]
ID          {LETTER}({LETTER}|{DIGIT})*
INT_CONST   {DIGIT}+
FLOAT_CONST {DIGIT}+"."{DIGIT}+
WS          [ \t]+

%%

"\n"            { line_number++; }
{WS}            { } /* Skip spaces and tabs */

    /* Keywords */
"int"           { printf("<KEYWORD, int, %d>\n", line_number); }
"float"         { printf("<KEYWORD, float, %d>\n", line_number); }
"if"            { printf("<KEYWORD, if, %d>\n", line_number); }
"else"          { printf("<KEYWORD, else, %d>\n", line_number); }
"while"         { printf("<KEYWORD, while, %d>\n", line_number); }
"print"         { printf("<KEYWORD, print, %d>\n", line_number); }

    /* Operators */
"=="|"!="|"<="|">="|"<"|">" { printf("<OP_REL, %s, %d>\n", yytext, line_number); }
"&&"|"||"|"!"               { printf("<OP_LOGIC, %s, %d>\n", yytext, line_number); }
"+"|"-"|"*"|"/"|"%"         { printf("<OP_ARITH, %s, %d>\n", yytext, line_number); }
"="                         { printf("<ASSIGN, =, %d>\n", line_number); }

    /* Delimiters */
";"|"("|")"|"{"|"}"         { printf("<DELIMITER, %s, %d>\n", yytext, line_number); }

    /* Constants and Identifiers  */
{FLOAT_CONST}   { printf("<FLOAT_CONST, %s, %d>\n", yytext, line_number); }
{INT_CONST}     { printf("<INT_CONST, %s, %d>\n", yytext, line_number); }
{ID}            { printf("<ID, %s, %d>\n", yytext, line_number); }

    /* Lexical Error Reporting  */
.               { printf("Lexical Error: Unexpected '%s' at line %d\n", yytext, line_number); }

%%

int yywrap() {
    return 1;
}

int main() {
    yylex();
    return 0;
}
