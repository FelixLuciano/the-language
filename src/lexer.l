%{
#include "parser.tab.h"
%}

SPACE           [ ]
IDENTIFIER      [a-zA-Z_][a-zA-Z0-9_]*
INTEGER         [0-9]+
STRING          \"([^"]*)\"
COMMENT         \/\/[^\n]*

%%

return          { return RETURN; }
ref             { return REF; }
NULL            { yylval.value = "NULL"; return IDENTIFIER; }
int             { yylval.value = "int"; return IDENTIFIER; }
void            { yylval.value = "void"; return IDENTIFIER; }
else            { return ELSE; }
\;              { return SEPARATOR; }
\+              { yylval.value = "+"; return OP_PLUS; }
\-              { yylval.value = "-"; return OP_MINUS; }
\*              { yylval.value = "*"; return OP_MULT; }
\/              { yylval.value = "/"; return OP_DIV; }
\&\&            { yylval.value = "&&"; return OP_AND; }
\|\|            { yylval.value = "||"; return OP_OR; }
\=\=            { yylval.value = "=="; return OP_COMPARE; }
\!\=            { yylval.value = "!="; return OP_COMPARE; }
\>              { yylval.value = ">"; return OP_COMPARE; }
\<              { yylval.value = "<"; return OP_COMPARE; }
\>\=            { yylval.value = ">="; return OP_COMPARE; }
\<\=            { yylval.value = "<="; return OP_COMPARE; }
\=              { return ASSIGN; }
\+\=            { yylval.value = "+"; return OP_ASSIGN; }
\-\=            { yylval.value = "-"; return OP_ASSIGN; }
\*\=            { yylval.value = "*"; return OP_ASSIGN; }
\/\=            { yylval.value = "/"; return OP_ASSIGN; }
\?              { return TERNARY_QUESTION; }
\:              { return TERNARY_COLON; }
\{              { return OPEN_BRACES; }
\}              { return CLOSE_BRACES; }
\(              { return OPEN_PARENTHESIS; }
\)              { return CLOSE_PARENTHESIS; }
[\n]            { return ENDL; }
{COMMENT}       ;
{INTEGER}       { yylval.value = strdup(yytext); return INTEGER; }
{IDENTIFIER}    { yylval.value = strdup(yytext); return IDENTIFIER; }
{STRING}        { yylval.value = strndup(yytext+1, yyleng-2); return STRING; }
{SPACE}         ;  // Ignore whitespace

%%
