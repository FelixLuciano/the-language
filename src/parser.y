%{
    #include "ast.h"

    extern int yylex();
    extern void yyerror(const char*);

    # define YYLLOC_DEFAULT(Current, Rhs, N)                        \
      do                                                            \
      if (N)                                                        \
        {                                                           \
          (Current).first_line   = YYRHSLOC (Rhs, 1).first_line;    \
          (Current).first_column = YYRHSLOC (Rhs, 1).first_column;  \
          (Current).last_line    = YYRHSLOC (Rhs, N).last_line;     \
          (Current).last_column  = YYRHSLOC (Rhs, N).last_column;   \
        }                                                           \
      else                                                          \
        {                                                           \
          (Current).first_line   = (Current).last_line   =          \
            YYRHSLOC (Rhs, 0).last_line;                            \
          (Current).first_column = (Current).last_column =          \
            YYRHSLOC (Rhs, 0).last_column;                          \
        }                                                           \
      while (0)

    #define YYDEBUG 1
    #define YYERROR_VERBOSE
%}

%code requires {  
    #include <string>

    union YYSTYPE {
        std::string string;
        
        YYSTYPE() : string() {}

        ~YYSTYPE() {}

        YYSTYPE& operator=(const YYSTYPE& other) {
            if (this != &other) {
                string = other.string;
            }
            return *this;
        }
    };
}

%locations

%token <string> IDENTIFIER INTEGER STRING
%token <string> OP_PLUS OP_MINUS OP_MULT OP_DIV OP_AND OP_OR OP_COMPARE OP_ASSIGN
%token ELSE RETURN REF BLOCK
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

/* %type <node> program block statement block_statement inline_statement function_interface_item
%type <node> expression conditional_expression expression_term expression_factor expression_summand expression_product factor
%type <children> statement_sequence expression_chain block_expression_chain inline_expression_chain function_interface call call_expression_sequence */

%start program

%%

program
: statement_sequence    
;

block
: OPEN_BRACES ENDL statement_sequence CLOSE_BRACES          
;

statement_sequence
: %empty                                
| statement                             
| ENDL statement_sequence               
| statement ENDL statement_sequence     
;

statement
: block_statement   
| inline_statement  
;

block_statement
: block_expression_chain                                                                
| IDENTIFIER IDENTIFIER ASSIGN block_expression_chain                                   
| IDENTIFIER ASSIGN block_expression_chain                                              
| IDENTIFIER OP_ASSIGN block_expression_chain                                           
| IDENTIFIER IDENTIFIER OPEN_PARENTHESIS CLOSE_PARENTHESIS block                        
| IDENTIFIER IDENTIFIER OPEN_PARENTHESIS function_interface CLOSE_PARENTHESIS block     
| RETURN expression_chain                                                               
;

expression_chain
: block_expression_chain    
| inline_expression_chain   
;

block_expression_chain
: block                                                 
| block ELSE block_expression_chain                     
| IDENTIFIER call block                                 
| IDENTIFIER call block ELSE block_expression_chain     
;

inline_statement
: inline_expression_chain                                   
| IDENTIFIER IDENTIFIER                                     
| IDENTIFIER IDENTIFIER ASSIGN inline_expression_chain      
| IDENTIFIER ASSIGN inline_expression_chain                 
| IDENTIFIER OP_ASSIGN inline_expression_chain              
;

inline_expression_chain
: expression                                
| expression ELSE inline_expression_chain   
;

expression
: conditional_expression                                                        
| conditional_expression TERNARY_QUESTION expression TERNARY_COLON expression   
;

conditional_expression
: expression_term                                       
| expression_term OP_COMPARE expression_term            { Node("Bin_op", "oi").display(); }
;

expression_term
: expression_factor                         
| expression_factor OP_OR expression_term   { Node("Bin_op", "oi").display(); }
;

expression_factor
: expression_summand                                
| expression_summand OP_AND expression_factor       { Node("Bin_op", "oi").display(); }
;

expression_summand
: expression_product                                
| expression_product OP_PLUS expression_summand     { Node("Bin_op", "oi").display(); }
| expression_product OP_MINUS expression_summand    { Node("Bin_op", "oi").display(); }
;

expression_product
: factor                                            
| factor OP_MULT expression_product                 { Node("Bin_op", "oi").display(); }
| factor OP_DIV expression_product                  { Node("Bin_op", "oi").display(); }
| OPEN_PARENTHESIS expression CLOSE_PARENTHESIS     
;

factor
: INTEGER                                   { Node("Integer", "oi").display(); }
| STRING                                    { Node("String", "oi").display(); }
| IDENTIFIER                                { Node("Identifier", "oi").display(); }
| IDENTIFIER call                           { Node("Call", "oi").display(); }
| BLOCK OPEN_PARENTHESIS CLOSE_PARENTHESIS  { Node("Identifier", "block").display(); }
;

call
: OPEN_PARENTHESIS CLOSE_PARENTHESIS                            
| OPEN_PARENTHESIS call_expression_sequence CLOSE_PARENTHESIS   
;

call_expression_sequence
: inline_statement                                      
| inline_statement SEPARATOR call_expression_sequence   
;

function_interface
: function_interface_item                               
| function_interface_item SEPARATOR function_interface  
;

function_interface_item
: IDENTIFIER IDENTIFIER                                 
| IDENTIFIER IDENTIFIER ASSIGN conditional_expression   
| REF IDENTIFIER IDENTIFIER                             
;

%%
