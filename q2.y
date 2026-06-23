%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define MAX_TOKENS 2000

typedef struct Node {
    char label[50];
    char value[50];
    struct Node* children[10];
    int child_count;
} Node;

Node* createNode(const char* label, const char* value);
void addChild(Node* parent, Node* child);
void print_tree_visual(Node* node, char* prefix, int is_last);
void leftmost_derivation(Node* root);
void rightmost_derivation(Node* root);
Node* find_assignment(Node* node);
void yyerror(const char *s);
int yylex();

int line_number = 1;
char* yytext_val; 
Node* final_root = NULL; 
%}

%union {
    char* sval;
    struct Node* nptr;
}

%token <sval> ID INT_CONST FLOAT_CONST TYPE OP_REL OP_LOGIC OP_ADD OP_MUL
%token IF ELSE WHILE PRINT

%type <nptr> program stmt_list stmt decl_stmt assign_stmt if_stmt while_stmt print_stmt block bool_expr bool_atom expr term factor

%left OP_LOGIC
%left OP_REL
%left OP_ADD
%left OP_MUL
%right '!'

%%

program: 
    stmt_list { final_root = createNode("program", NULL); addChild(final_root, $1); }
    ;

stmt_list: 
    stmt stmt_list { 
        $$ = createNode("stmt_list", NULL);
        addChild($$, $1); 
        if($2) addChild($$, $2); 
    }
    | { $$ = NULL; }
    ;

stmt: decl_stmt | assign_stmt | if_stmt | while_stmt | print_stmt | block;

decl_stmt:
    TYPE ID ';' {
        $$ = createNode("decl_stmt", NULL);
        addChild($$, createNode("TYPE", $1));
        addChild($$, createNode("ID", $2));
        addChild($$, createNode("Delimiter", ";"));
    }
    | TYPE ID '=' expr ';' {
        $$ = createNode("decl_stmt", NULL);
        addChild($$, createNode("TYPE", $1));
        addChild($$, createNode("ID", $2));
        addChild($$, createNode("Assign", "="));
        addChild($$, $4);
        addChild($$, createNode("Delimiter", ";"));
    };

assign_stmt:
    ID '=' expr ';' {
        $$ = createNode("assign_stmt", NULL);
        addChild($$, createNode("ID", $1));
        addChild($$, createNode("Assign", "="));
        addChild($$, $3);
        addChild($$, createNode("Delimiter", ";"));
    };

if_stmt:
    IF '(' bool_expr ')' block {
        $$ = createNode("if_stmt", NULL);
        addChild($$, createNode("IF", "if")); addChild($$, $3); addChild($$, $5);
    }
    | IF '(' bool_expr ')' block ELSE block {
        $$ = createNode("if_stmt", NULL);
        addChild($$, createNode("IF", "if")); addChild($$, $3); addChild($$, $5);
        addChild($$, createNode("ELSE", "else")); addChild($$, $7);
    };

while_stmt:
    WHILE '(' bool_expr ')' block {
        $$ = createNode("while_stmt", NULL);
        addChild($$, createNode("WHILE", "while")); addChild($$, $3); addChild($$, $5);
    };

print_stmt:
    PRINT '(' expr ')' ';' {
        $$ = createNode("print_stmt", NULL);
        addChild($$, createNode("PRINT", "print")); addChild($$, $3); addChild($$, createNode("Delimiter", ";"));
    };

block: '{' stmt_list '}' { $$ = createNode("block", NULL); if($2) addChild($$, $2); };

bool_expr:
    bool_atom { 
        $$ = createNode("bool_expr", NULL); 
        addChild($$, $1);
    }
    | bool_expr OP_LOGIC bool_expr {
        $$ = createNode("bool_expr", NULL);
        addChild($$, $1);
        addChild($$, createNode("LOGIC", $2)); 
        addChild($$, $3);
    }
    | '(' bool_expr ')' { $$ = $2; };

bool_atom:
    expr OP_REL expr {
        $$ = createNode("bool_atom", NULL);
        addChild($$, $1);
        addChild($$, createNode("REL", $2)); 
        addChild($$, $3);
    }
    | '!' bool_expr {
        $$ = createNode("bool_atom", NULL); 
        addChild($$, createNode("NOT", "!")); 
        addChild($$, $2);
    };
##
expr:
    term { 
        $$ = createNode("expr", NULL); 
        addChild($$, $1);
    }
    | expr OP_ADD term {
        $$ = createNode("expr", NULL);
        addChild($$, $1);
        addChild($$, createNode("Operator", $2)); 
        addChild($$, $3);
    };

term:
    factor { 
        $$ = createNode("term", NULL);
        addChild($$, $1); 
    }
    | term OP_MUL factor {
        $$ = createNode("term", NULL);
        addChild($$, $1);
        addChild($$, createNode("Operator", $2)); 
        addChild($$, $3);
    };

factor:
    ID { 
        $$ = createNode("factor", NULL);
        addChild($$, createNode("ID", $1)); 
    }
    | INT_CONST { 
        $$ = createNode("factor", NULL);
        addChild($$, createNode("Int", $1)); 
    }
    | FLOAT_CONST { 
        $$ = createNode("factor", NULL);
        addChild($$, createNode("Float", $1)); 
    }
    | '(' expr ')' { 
        $$ = createNode("factor", NULL);
        addChild($$, createNode("Delimiter", "("));
        addChild($$, $2); 
        addChild($$, createNode("Delimiter", ")"));
    };

%%

##
int yylex() {
    char token_type[50], token_val[50];
    int l_num;
    
    if (scanf("<%[^,], %[^,], %d>\n", token_type, token_val, &l_num) == 3) {
        line_number = l_num;
        
        if (strcmp(token_type, "KEYWORD") == 0) {
            if (strcmp(token_val, "int") == 0 || strcmp(token_val, "float") == 0) {
                yylval.sval = strdup(token_val); return TYPE;
            }
            if (strcmp(token_val, "if") == 0) return IF;
            if (strcmp(token_val, "else") == 0) return ELSE;
            if (strcmp(token_val, "while") == 0) return WHILE;
            if (strcmp(token_val, "print") == 0) return PRINT;
        }
        if (strcmp(token_type, "ID") == 0) {
            yylval.sval = strdup(token_val); return ID;
        }
        if (strcmp(token_type, "INT_CONST") == 0) {
            yylval.sval = strdup(token_val); return INT_CONST;
        }
        if (strcmp(token_type, "FLOAT_CONST") == 0) {
            yylval.sval = strdup(token_val); return FLOAT_CONST;
        }
        if (strcmp(token_type, "OP_ARITH") == 0) {
            yylval.sval = strdup(token_val);
            if (strcmp(token_val, "+") == 0 || strcmp(token_val, "-") == 0) return OP_ADD;
            if (strcmp(token_val, "*") == 0 || strcmp(token_val, "/") == 0 || strcmp(token_val, "%") == 0) return OP_MUL;
        }
        if (strcmp(token_type, "OP_REL") == 0) {
            yylval.sval = strdup(token_val); return OP_REL;
        }
        if (strcmp(token_type, "OP_LOGIC") == 0) {
            yylval.sval = strdup(token_val);
            if (strcmp(token_val, "!") == 0) return '!';
            return OP_LOGIC;
        }
        if (strcmp(token_type, "ASSIGN") == 0) return '=';
        if (strcmp(token_type, "DELIMITER") == 0) {
            return token_val[0];
        }
    }
    return 0;
}

Node* createNode(const char* label, const char* value) {
    Node* n = (Node*)malloc(sizeof(Node));
    if (!n) return NULL;
    strncpy(n->label, label, 49);
    if(value) strncpy(n->value, value, 49); else n->value[0]='\0';
    n->child_count = 0;
    for(int i=0; i<10; i++) n->children[i] = NULL;
    return n;
}

void addChild(Node* parent, Node* child) {
    if(child && parent && parent->child_count < 10) {
        parent->children[parent->child_count++] = child;
    }
}

void print_tree_visual(Node* node, char* prefix, int is_last) {
    if (!node) return;
    printf("%s", prefix);
    printf(is_last ? "+-- " : "|-- ");
    if (node->value[0] != '\0') printf("%s: [%s]\n", node->label, node->value);
    else printf("%s\n", node->label);

    char new_prefix[MAX_TOKENS];
    sprintf(new_prefix, "%s%s", prefix, is_last ? "    " : "|   ");
    for (int i = 0; i < node->child_count; i++) {
        print_tree_visual(node->children[i], new_prefix, i == node->child_count - 1);
    }
}

void leftmost_derivation(Node* root) {
    if (!root) return;
    Node* sentential[MAX_TOKENS];
    int count = 1, step = 1;
    sentential[0] = root;
    while(1) {
        printf("Step %d: ", step++);
        for(int i=0; i<count; i++) printf("%s ", sentential[i]->value[0]? sentential[i]->value : sentential[i]->label);
        printf("\n");
        int pos = -1;
        for(int i=0; i<count; i++) if(sentential[i]->child_count > 0) { pos = i; break; }
        if(pos == -1) break;
        Node* temp[MAX_TOKENS]; int idx = 0;
        for(int i=0; i<pos; i++) temp[idx++] = sentential[i];
        for(int i=0; i<sentential[pos]->child_count; i++) temp[idx++] = sentential[pos]->children[i];
        for(int i=pos+1; i<count; i++) temp[idx++] = sentential[i];
        count = idx;
        for(int i=0; i<count; i++) sentential[i] = temp[i];
    }
}

void rightmost_derivation(Node* root) {
    if (!root) return;
    Node* sentential[MAX_TOKENS];
    int count = 1, step = 1;
    sentential[0] = root;
    while(1) {
        printf("Step %d: ", step++);
        for(int i=0; i<count; i++) printf("%s ", sentential[i]->value[0]? sentential[i]->value : sentential[i]->label);
        printf("\n");
        int pos = -1;
        for(int i=count-1; i>=0; i--) if(sentential[i]->child_count > 0) { pos = i; break; }
        if(pos == -1) break;
        Node* temp[MAX_TOKENS]; int idx = 0;
        for(int i=0; i<pos; i++) temp[idx++] = sentential[i];
        for(int i=0; i<sentential[pos]->child_count; i++) temp[idx++] = sentential[pos]->children[i];
        for(int i=pos+1; i<count; i++) temp[idx++] = sentential[i];
        count = idx;
        for(int i=0; i<count; i++) sentential[i] = temp[i];
    }
}

Node* find_assignment(Node* node) {
    if(!node) return NULL;
    if(strcmp(node->label,"assign_stmt")==0) return node;
    for(int i=0; i<node->child_count; i++) {
        Node* res = find_assignment(node->children[i]);
        if(res) return res;
    }
    return NULL;
}
#Error declaration
void yyerror(const char *s) { 
    fprintf(stderr, "Syntax Error: %s on line %d\n", s, line_number);
}
##
int main() {
    if (yyparse() == 0) {
        printf("\nSYNTAX ANALYSIS: Syntactically correct.\n");
        if (final_root) {
            printf("\nPARSE TREE:\n");
            print_tree_visual(final_root, "", 1);
        }
        Node* assign = find_assignment(final_root);
        if(assign) {
            printf("\n=== LEFTMOST DERIVATION (First Assignment) ===\n");
            leftmost_derivation(assign);
            printf("\n=== RIGHTMOST DERIVATION (First Assignment) ===\n");
            rightmost_derivation(assign);
        }
    } else {
        printf("\nSYNTAX ANALYSIS: Syntactically incorrect.\n");
    }
    return 0;
}
