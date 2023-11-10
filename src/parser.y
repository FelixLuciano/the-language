%{
#include <stdio.h>
extern FILE *yyin;
extern int yylex (void);
void yyerror (char const *);
extern int yyparse();
extern int yylval;
%}

%token ENDL
%token IDENT
%token KEYWORD
%token TYPE
%token IDENTIFIER
%token STRING
%token INTEGER
%token SEPARATOR
%token OP_PLUS
%token OP_MINUS
%token OP_MULT
%token OP_DIV
%token OP_AND
%token OP_OR
%token OP_EQUAL
%token OP_NOT_EQUAL
%token OP_GREATER
%token OP_LOWER
%token OP_GREATER_EQUAL
%token OP_LOWER_EQUAL
%token ASSIGN
%token ASSIGN_PLUS
%token ASSIGN_MINUS
%token ASSIGN_MULT
%token ASSIGN_DIV
%token TERNARY_QUESTION
%token TERNARY_COLON

%left OP_MULT OP_DIV
%left OP_PLUS OP_MINUS
%left OP_AND
%left OP_OR
%left OP_EQUAL OP_NOT_EQUAL OP_GREATER OP_LOWER OP_GREATER_EQUAL OP_LOWER_EQUAL
%left TERNARY_QUESTION TERNARY_COLON

%%

statement_list: statement ENDL statement_list
              | statement ENDL
              | statement
              ;

statement: KEYWORD conditional_expression
         | conditional_expression
         ;

expression_list: conditional_expression ',' expression_list
               | conditional_expression
               ;

conditional_expression: expression TERNARY_QUESTION conditional_expression TERNARY_COLON conditional_expression
                      | expression
                      ;

expression: '(' expression ')'
          | factor OP_MULT expression
          | factor OP_DIV expression
          | factor OP_PLUS expression
          | factor OP_MINUS expression
          | factor OP_AND expression
          | factor OP_OR expression
          | factor OP_EQUAL expression
          | factor OP_NOT_EQUAL expression
          | factor OP_GREATER expression
          | factor OP_LOWER expression
          | factor OP_GREATER_EQUAL expression
          | factor OP_LOWER_EQUAL expression
          | factor
          ;

call: '(' expression_list ')'
    | '(' ')'
    ;

factor: INTEGER
      | STRING
      | IDENTIFIER
      | IDENTIFIER call
      ;

%%
