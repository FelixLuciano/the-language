%{
extern int yylval;
%}

ENDL                            [\n]
SPACE                           [\s]+
KEYWORD                         "return" | "ref" | "NULL"
TYPE                            "INT" | "STRING" | "VOID"
IDENTIFIER                      [a-zA-Z][a-zA-Z0-9_]*
STRING                          [\"\'][^\"\']*[\"\']
INTEGER                         [+-]*[0-9]+
COMMENT                         \/\/\s.+
SEPARATOR                       ';'
OP_PLUS                         '+'
OP_MINUS                        '-'
OP_MULT                         '*'
OP_DIV                          '/'
OP_AND                          "&&"
OP_OR                           "||"
OP_EQUAL                        "=="
OP_NOT_EQUAL                    "!="
OP_GREATER                      '>'
OP_LOWER                        '<'
OP_GREATER_EQUAL                ">="
OP_LOWER_EQUAL                  "<="
ASSIGN                          '='
ASSIGN_PLUS                     "+="
ASSIGN_MINUS                    "-="
ASSIGN_MULT                     "*="
ASSIGN_DIV                      "/="
TERNARY_QUESTION                '?'
TERNARY_COLON                   ':'

%%

{SPACE}+            ;  // Ignore whitespace
{COMMENT}           ;  // Ignore comment
{INTEGER}           { yylval = atoi(yytext); }
.                   { return yytext[0]; }

%%
