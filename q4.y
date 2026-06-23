%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define MAX_TOKENS 2000
#define MAX_ERRORS 100

typedef struct Node {
    char label[50];
    char value[50];
    struct Node* children[15];
    int child_count;
} Node;

/* Error tracking for Q3 compatibility */
typedef struct {
    int  line;
    char type[64];
    char message[256];
    char token[64];
} SyntaxError;

SyntaxError error_list[MAX_ERRORS];
int error_count = 0;

Node* createNode(const char* label, const char* value);
void  addChild(Node* parent, Node* child);
void  yyerror(const char *s);
int   yylex();

int   line_number = 1;
char* yytext; 
Node* final_root = NULL;

/* Enable Debugging for Stack Trace */
extern int yydebug;

static void record_error(const char* msg, const char* tok, int line) {
    if (error_count >= MAX_ERRORS) return;
    SyntaxError* e = &error_list[error_count++];
    e->line = line;
    strncpy(e->token, tok ? tok : "", 63);
    strncpy(e->message, msg ? msg : "", 255);
    strncpy(e->type, "Syntax Error", 63);
}
%}

/* FIXED: Added quotes around "verbose" */
%define parse.error "verbose"

%union {
    char* sval;
    struct Node* nptr;
}

%token <sval> ID INT_CONST FLOAT_CONST TYPE OP_REL OP_LOGIC OP_ADD OP_MUL
%token IF ELSE WHILE PRINT

%type <nptr> program stmt_list stmt decl_stmt assign_stmt if_stmt while_stmt print_stmt block bool_expr bool_term bool_atom expr term factor

%left OP_LOGIC
%left OP_REL
%left OP_ADD
%left OP_MUL
%right '!'

%%

program: stmt_list { final_root = createNode("program", NULL); addChild(final_root, $1); };

stmt_list: stmt stmt_list { $$ = createNode("stmt_list", NULL); addChild($$, $1); if($2) addChild($$, $2); }
          | { $$ = NULL; };

stmt: decl_stmt | assign_stmt | if_stmt | while_stmt | print_stmt | block | error ';' { yyerrok; $$ = createNode("error", NULL); };

decl_stmt: TYPE ID ';' { $$ = createNode("decl_stmt", NULL); addChild($$, createNode("TYPE", $1)); addChild($$, createNode("ID", $2)); }
         | TYPE ID '=' expr ';' { $$ = createNode("decl_stmt", NULL); addChild($$, createNode("TYPE", $1)); addChild($$, createNode("ID", $2)); addChild($$, $4); };

assign_stmt: ID '=' expr ';' { $$ = createNode("assign_stmt", NULL); addChild($$, createNode("ID", $1)); addChild($$, $3); };

if_stmt: IF '(' bool_expr ')' block ELSE block { $$ = createNode("if_stmt", NULL); addChild($$, $3); addChild($$, $5); addChild($$, $7); }
       | IF '(' bool_expr ')' block { $$ = createNode("if_stmt", NULL); addChild($$, $3); addChild($$, $5); };

while_stmt: WHILE '(' bool_expr ')' block { $$ = createNode("while_stmt", NULL); addChild($$, $3); addChild($$, $5); };

print_stmt: PRINT '(' expr ')' ';' { $$ = createNode("print_stmt", NULL); addChild($$, $3); };

block: '{' stmt_list '}' { $$ = createNode("block", NULL); if($2) addChild($$, $2); };

bool_expr: bool_term | bool_expr OP_LOGIC bool_term { $$ = createNode("bool_expr", NULL); addChild($$, $1); addChild($$, $3); };
bool_term: bool_atom | '!' bool_term { $$ = createNode("bool_term", NULL); addChild($$, createNode("NOT", "!")); addChild($$, $2); };
bool_atom: expr OP_REL expr { $$ = createNode("bool_atom", NULL); addChild($$, $1); addChild($$, $3); }
         | '(' bool_expr ')' { $$ = $2; };

expr: term | expr OP_ADD term { $$ = createNode("expr", NULL); addChild($$, $1); addChild($$, $3); };
term: factor | term OP_MUL factor { $$ = createNode("term", NULL); addChild($$, $1); addChild($$, $3); };
factor: ID { $$ = createNode("factor", $1); } | INT_CONST { $$ = createNode("factor", $1); } 
      | FLOAT_CONST { $$ = createNode("factor", $1); } | '(' expr ')' { $$ = $2; };

%%

int yylex() {
    char t[50], v[50]; int l;
    if (scanf("<%[^,], %[^,], %d>\n", t, v, &l) == 3) {
        line_number = l; yytext = strdup(v);
        if (!strcmp(t, "KEYWORD")) {
            if (!strcmp(v, "int") || !strcmp(v, "float")) { yylval.sval = strdup(v); return TYPE; }
            if (!strcmp(v, "if")) return IF; if (!strcmp(v, "else")) return ELSE;
            if (!strcmp(v, "while")) return WHILE; if (!strcmp(v, "print")) return PRINT;
        }
        if (!strcmp(t, "ID")) { yylval.sval = strdup(v); return ID; }
        if (!strcmp(t, "INT_CONST")) { yylval.sval = strdup(v); return INT_CONST; }
        if (!strcmp(t, "FLOAT_CONST")) { yylval.sval = strdup(v); return FLOAT_CONST; }
        if (!strcmp(t, "OP_ARITH")) { yylval.sval = strdup(v); return (v[0]=='+'||v[0]=='-') ? OP_ADD : OP_MUL; }
        if (!strcmp(t, "OP_REL")) { yylval.sval = strdup(v); return OP_REL; }
        if (!strcmp(t, "OP_LOGIC")) { yylval.sval = strdup(v); return (!strcmp(v, "!")) ? '!' : OP_LOGIC; }
        if (!strcmp(t, "ASSIGN")) return '=';
        if (!strcmp(t, "DELIMITER")) return v[0];
    }
    return 0;
}

Node* createNode(const char* l, const char* v) {
    Node* n = malloc(sizeof(Node));
    strcpy(n->label, l); if(v) strcpy(n->value, v); else n->value[0]='\0';
    n->child_count = 0; return n;
}

void addChild(Node* p, Node* c) { if(c && p && p->child_count < 15) p->children[p->child_count++] = c; }

void yyerror(const char *s) { record_error(s, yytext, line_number); }

int main() {
    yydebug = 1; // Enables the Stack Trace required by Q1 (Compre) 
    printf("--- PARSING STACK TRACE ---\n");
    yyparse();
    if(error_count == 0) printf("\nSUCCESS: Evaluation Program Parsed.\n");
    else printf("\nFAILED: %d Errors Found.\n", error_count);
    return 0;
}
