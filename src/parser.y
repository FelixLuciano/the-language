%code requires {
    #include "ast.h"
}

%{
    #include <stdio.h>
    #include <stdlib.h>
    #include "ast.h"

    extern int yylex (void);
    extern int yyerror (char const *);
    Node_t* programNode = NULL;
%}

%locations

%union {
    char* value;
    Node_t* node;
    NodeList_t* children;
}

%token <value> IDENTIFIER INTEGER STRING
%token <value> OP_PLUS OP_MINUS OP_MULT OP_DIV OP_AND OP_OR OP_COMPARE OP_ASSIGN
%token ELSE RETURN REF BLOCKT
%token ASSIGN SEPARATOR ENDL
%token TERNARY_QUESTION TERNARY_COLON
%token OPEN_BRACES CLOSE_BRACES
%token OPEN_PARENTHESIS CLOSE_PARENTHESIS

%left OP_MULT OP_DIV
%left OP_PLUS OP_MINUS
%left OP_AND
%left OP_OR
%left OP_COMPARE
%left TERNARY_QUESTION TERNARY_COLON

%type <node> block statement block_statement inline_statement function_interface_item
%type <node> expression conditional_expression expression_term expression_factor expression_summand expression_product factor
%type <children> statement_sequence expression_chain block_expression_chain inline_expression_chain function_interface call call_expression_sequence

%%

program: statement_sequence {
    programNode = parseBlock("Block", NULL, $1);
    Node_t* call = createNode("Call", "main");

    pushChild(call, createNode("Block", NULL));
    pushChild(programNode, call);
};

block
: OPEN_BRACES ENDL statement_sequence CLOSE_BRACES          { $$ = parseBlock("Block", NULL, $3); }
;

statement_sequence
: %empty                                { $$ = NULL; }
| statement                             { $$ = createChild($1); }
| ENDL statement_sequence               { $$ = $2; }
| statement ENDL statement_sequence     { $$ = createChild($1); mergeChildren($$, $3); }
;

statement
: block_statement   { $$ = $1; }
| inline_statement  { $$ = $1; }
;

block_statement
: block_expression_chain                                                                { $$ = parseStatement($1); }
| IDENTIFIER IDENTIFIER ASSIGN block_expression_chain                                   { $$ = parseDeclaration($1, $2, parseStatement($4)); }
| IDENTIFIER ASSIGN block_expression_chain                                              { $$ = parseAssignment($1, NULL, $3); }
| IDENTIFIER OP_ASSIGN block_expression_chain                                           { $$ = parseAssignment($1, $2, $3); }
| IDENTIFIER IDENTIFIER OPEN_PARENTHESIS CLOSE_PARENTHESIS block                        { $$ = parseFunction($1, $2, NULL, $5); }
| IDENTIFIER IDENTIFIER OPEN_PARENTHESIS function_interface CLOSE_PARENTHESIS block     { $$ = parseFunction($1, $2, $4, $6); }
| RETURN expression_chain                                                               { $$ = createNode("Return", NULL); pushChild($$, parseStatement($2)); }
;

expression_chain
: block_expression_chain    { $$ = $1; }
| inline_expression_chain   { $$ = $1; }
;

block_expression_chain
: block                                                 { $$ = createChild($1); }
| block ELSE block_expression_chain                     { $$ = createChild($1); mergeChildren($$, $3); }
| expression ELSE block_expression_chain                { $$ = createChild($1); mergeChildren($$, $3); }
| IDENTIFIER call block                                 { $$ = createChild(parseBlock("Call", $1, $2)); pushChild($$->node, $3); }
| IDENTIFIER call block ELSE block_expression_chain     { $$ = createChild(parseBlock("Call", $1, $2)); pushChild($$->node, $3); mergeChildren($$, $5); }
;

inline_statement
: inline_expression_chain                                   { $$ = parseStatement($1); }
| IDENTIFIER IDENTIFIER                                     { $$ = parseDeclaration($1, $2, NULL); }
| IDENTIFIER IDENTIFIER ASSIGN inline_expression_chain      { $$ = parseDeclaration($1, $2, parseStatement($4)); }
| IDENTIFIER ASSIGN inline_expression_chain                 { $$ = parseAssignment($1, NULL, $3); }
| IDENTIFIER OP_ASSIGN inline_expression_chain              { $$ = parseAssignment($1, $2, $3); }
;

inline_expression_chain
: expression                                { $$ = createChild($1); }
| expression ELSE inline_expression_chain   { $$ = createChild($1); mergeChildren($$, $3); }
;

expression
: conditional_expression                                                        { $$ = $1; }
| conditional_expression TERNARY_QUESTION expression TERNARY_COLON expression   { $$ = parseTernaryOperation($1, $3, $5); }
;

conditional_expression
: expression_term                                       { $$ = $1; }
| expression_term OP_COMPARE expression_term            { $$ = parseBinaryOperation($2, $1, $3); }
;

expression_term
: expression_factor                         { $$ = $1; }
| expression_factor OP_OR expression_term   { $$ = parseBinaryOperation($2, $1, $3); }
;

expression_factor
: expression_summand                                { $$ = $1; }
| expression_summand OP_AND expression_factor       { $$ = parseBinaryOperation($2, $1, $3); }
;

expression_summand
: expression_product                                { $$ = $1; }
| expression_product OP_PLUS expression_summand     { $$ = parseBinaryOperation($2, $1, $3); }
| expression_product OP_MINUS expression_summand    { $$ = parseBinaryOperation($2, $1, $3); }
;

expression_product
: factor                                            { $$ = $1; }
| factor OP_MULT expression_product                 { $$ = parseBinaryOperation($2, $1, $3); }
| factor OP_DIV expression_product                  { $$ = parseBinaryOperation($2, $1, $3); }
| OPEN_PARENTHESIS expression CLOSE_PARENTHESIS     { $$ = $2; }
;

factor
: INTEGER                                   { $$ = createNode("Integer", $1); }
| STRING                                    { $$ = createNode("String", $1); }
| IDENTIFIER                                { $$ = createNode("Identifier", $1); }
| IDENTIFIER call                           { $$ = parseBlock("Call", $1, $2); pushChild($$, createNode("Block", NULL)); }
;

call
: OPEN_PARENTHESIS CLOSE_PARENTHESIS                            { $$ = NULL; }
| OPEN_PARENTHESIS call_expression_sequence CLOSE_PARENTHESIS   { $$ = $2; }
;

call_expression_sequence
: inline_statement                                      { $$ = createChild($1); }
| inline_statement SEPARATOR call_expression_sequence   { $$ = createChild($1); mergeChildren($$, $3); }
;

function_interface
: function_interface_item                               { $$ = createChild($1); }
| function_interface_item SEPARATOR function_interface  { $$ = createChild($1); mergeChildren($$, $3); }
;

function_interface_item
: IDENTIFIER IDENTIFIER                                 { $$ = parseDeclaration($1, $2, NULL); }
| IDENTIFIER IDENTIFIER ASSIGN conditional_expression   { $$ = parseDeclaration($1, $2, $4); }
| REF IDENTIFIER IDENTIFIER                             { $$ = createNode("Reference", NULL); pushChild($$, parseDeclaration($2, $3, NULL)); }
;

%%
