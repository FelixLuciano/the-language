%{
#include <stdio.h>
#include <stdlib.h>

extern FILE *yyin;
extern int yylex (void);
extern int yyerror (char const *);
extern int yyparse();

struct Node {
    char* type;
    char* value;
    struct NodeChildren* children;
};

struct NodeChildren {
    struct Node* node;
    struct NodeChildren* next;
};

struct Node* createNode(char* type, char* value) {
    struct Node* newNode = malloc(sizeof(struct Node));

    newNode->type = type;
    newNode->value = value;
    newNode->children = NULL;

    return newNode;
}

struct NodeChildren* createChildren(struct Node* node) {
    struct NodeChildren* children = malloc(sizeof(struct NodeChildren));

    children->node = node;
    children->next = NULL;

    return children;
}

void pushChildren(struct Node* tree, struct Node* node) {
    struct NodeChildren* children = createChildren(node);

    if (tree->children == NULL) {
        tree->children = children;

        return;
    }

    struct NodeChildren* last;
    for (last = tree->children; last->next != NULL; last = last->next);

    last->next = children;
}

void mergeChildren(struct NodeChildren* tree, struct NodeChildren* children) {
    if (children == NULL) {
        return;
    }

    tree->next = children;
}

void ident(int size) {
    for (; size > 0; size--) {
        printf("  ");
    }
}

void display(struct Node* tree, int deep) {
    ident(deep);
    printf("%s(\"%s\", [", tree->type, tree->value);

    if (tree->children != NULL) {
        printf("\n");
    }

    for (struct NodeChildren* children = tree->children; children != NULL; children = children->next) {
        display(children->node, deep+1);

        if (children->next != NULL) {
            printf(",\n");
        }
        else {
            printf("\n");
            ident(deep);
        }
    }

    printf("])");

    if (deep == 0) {
        printf("\n");
    }
}

struct Node* parseBlock(char* type, char* value, struct NodeChildren* children) {
    struct Node* node = createNode(type, value);
    
    node->children = children;

    return node;
}

struct Node* parseBinaryOperation(char* operator, struct Node* x, struct Node* y) {
    struct Node* node = createNode("Binary_operation", operator);

    pushChildren(node, x);
    pushChildren(node, y);

    return node;
}

struct Node* parseTernaryOperation(struct Node* condition, struct Node* a, struct Node* b) {
    struct Node* node = createNode("Ternary_operation", "None");

    pushChildren(node, condition);
    pushChildren(node, a);
    pushChildren(node, b);

    return node;
}

%}

%union {
    char* value;
    struct Node* node;
    struct NodeChildren* children;
}

%token <value> IDENTIFIER INTEGER
%token <value> OP_PLUS OP_MINUS OP_MULT OP_DIV OP_AND OP_OR OP_EQUAL OP_NOT_EQUAL OP_GREATER OP_LOWER OP_GREATER_EQUAL OP_LOWER_EQUAL ASSIGN ASSIGN_PLUS ASSIGN_MINUS ASSIGN_MULT ASSIGN_DIV
%token COMMENT
%token RETURN REF
%token SEPARATOR ENDL
%token TERNARY_QUESTION TERNARY_COLON
%token OPEN_BRACES CLOSE_BRACES
%token OPEN_PARENTHESIS CLOSE_PARENTHESIS

%left OP_MULT OP_DIV
%left OP_PLUS OP_MINUS
%left OP_AND
%left OP_OR
%left OP_EQUAL OP_NOT_EQUAL OP_GREATER OP_LOWER OP_GREATER_EQUAL OP_LOWER_EQUAL
%left TERNARY_QUESTION TERNARY_COLON

%type <node> factor expression conditional_expression expression_term expression_factor expression_summand expression_product statement program
%type <children> statement_list block expression_list call

%%

program: statement_list { $$ = parseBlock("Block", "None", $1); display($$, 0); }

block:
  OPEN_BRACES CLOSE_BRACES                   { $$ = NULL; }
| OPEN_BRACES statement_list CLOSE_BRACES    { $$ = $2; }
;

statement_list:
  %empty                            { $$ = NULL; }
| statement                         { $$ = createChildren($1); }
| ENDL statement_list               { $$ = $2; }
| statement ENDL statement_list     { $$ = createChildren($1); mergeChildren($$, $3); }
;

statement:
  expression                    { $$ = $1; }
| expression COMMENT            { $$ = $1; }
| RETURN expression             { $$ = createNode("Return", "None"); pushChildren($$, $2); }
| RETURN expression COMMENT     { $$ = createNode("Return", "None"); pushChildren($$, $2); }
;

expression_list:
  expression                                { $$ = createChildren($1); }
| expression SEPARATOR expression_list      { $$ = createChildren($1); mergeChildren($$, $3); }
;

expression:
  conditional_expression                                                        { $$ = $1; }
| conditional_expression TERNARY_QUESTION expression TERNARY_COLON expression   { $$ = parseTernaryOperation($1, $3, $5); }
;

conditional_expression:
  expression_term                                       { $$ = $1; }
| expression_term OP_EQUAL expression_term              { $$ = parseBinaryOperation($2, $1, $3); }
| expression_term OP_NOT_EQUAL expression_term          { $$ = parseBinaryOperation($2, $1, $3); }
| expression_term OP_GREATER expression_term            { $$ = parseBinaryOperation($2, $1, $3); }
| expression_term OP_LOWER expression_term              { $$ = parseBinaryOperation($2, $1, $3); }
| expression_term OP_GREATER_EQUAL expression_term      { $$ = parseBinaryOperation($2, $1, $3); }
| expression_term OP_LOWER_EQUAL expression_term        { $$ = parseBinaryOperation($2, $1, $3); }
;

expression_term:
  expression_factor                         { $$ = $1; }
| expression_factor OP_OR expression_term   { $$ = parseBinaryOperation($2, $1, $3); }
;

expression_factor:
  expression_summand                                { $$ = $1; }
| expression_summand OP_AND expression_factor       { $$ = parseBinaryOperation($2, $1, $3); }
;

expression_summand:
  expression_product                                { $$ = $1; }
| expression_product OP_PLUS expression_summand     { $$ = parseBinaryOperation($2, $1, $3); }
| expression_product OP_MINUS expression_summand    { $$ = parseBinaryOperation($2, $1, $3); }
;

expression_product:
  factor                                            { $$ = $1; }
| factor OP_MULT expression_product                 { $$ = parseBinaryOperation($2, $1, $3); }
| factor OP_DIV expression_product                  { $$ = parseBinaryOperation($2, $1, $3); }
| OPEN_PARENTHESIS expression CLOSE_PARENTHESIS     { $$ = $2; }
;

call:
  OPEN_PARENTHESIS CLOSE_PARENTHESIS                    { $$ = NULL; }
| OPEN_PARENTHESIS expression_list CLOSE_PARENTHESIS    { $$ = $2; }
;

factor:
  INTEGER           { $$ = createNode("Integer", $1); }
| IDENTIFIER        { $$ = createNode("Identifier", $1); }
| IDENTIFIER call   { $$ = parseBlock("Call", $1, $2); }
;

%%
