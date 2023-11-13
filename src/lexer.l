%{
#include "../build/parser.tab.h"
%}

SPACE           [ ]
IDENTIFIER      [a-zA-Z][a-zA-Z0-9_]*
INTEGER         [0-9]+
COMMENT         \/\/[^\n]*

%%

return          { return RETURN; }
ref             { return REF; }
NULL            { return IDENTIFIER; }
int             { return IDENTIFIER; }
void            { return IDENTIFIER; }
\;              { return SEPARATOR; }
\+              { yylval.value = "+"; return OP_PLUS; }
\-              { yylval.value = "-"; return OP_MINUS; }
\*              { yylval.value = "*"; return OP_MULT; }
\/              { yylval.value = "/"; return OP_DIV; }
\&\&            { yylval.value = "&&"; return OP_AND; }
\|\|            { yylval.value = "||"; return OP_OR; }
\=\=            { yylval.value = "=="; return OP_EQUAL; }
\!\=            { yylval.value = "!="; return OP_NOT_EQUAL; }
\>              { yylval.value = ">"; return OP_GREATER; }
\<              { yylval.value = "<"; return OP_LOWER; }
\>\=            { yylval.value = ">="; return OP_GREATER_EQUAL; }
\<\=            { yylval.value = "<="; return OP_LOWER_EQUAL; }
\=              { yylval.value = "="; return ASSIGN; }
\+\=            { yylval.value = "!="; return ASSIGN_PLUS; }
\-\=            { yylval.value = "-="; return ASSIGN_MINUS; }
\*\=            { yylval.value = "*="; return ASSIGN_MULT; }
\/\=            { return ASSIGN_DIV; }
\?              { return TERNARY_QUESTION; }
\:              { return TERNARY_COLON; }
\{              { return OPEN_BRACES; }
\}              { return CLOSE_BRACES; }
\(              { return OPEN_PARENTHESIS; }
\)              { return CLOSE_PARENTHESIS; }
[\n]            { return ENDL; }
{COMMENT}       { return COMMENT; }
{INTEGER}       { yylval.value = strdup(yytext); return INTEGER; }
{IDENTIFIER}    { yylval.value = strdup(yytext); return IDENTIFIER; }
{SPACE}         ;  // Ignore whitespace

%%
