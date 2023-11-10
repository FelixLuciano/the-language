%{
#include "../build/y.tab.h"
%}

IDENTIFIER      [a-zA-Z][a-zA-Z0-9_]*
INTEGER         [+-]*[0-9]+
COMMENT         \/\/\s.+

%%

return          { return RETURN; }
ref             { return REF; }
NULL            { return NULLE; }
int             { return TYPE; }
void            { return TYPE; }
;               { return SEPARATOR; }
\+              { return OP_PLUS; }
-               { return OP_MINUS; }
\*              { return OP_MULT; }
\/              { return OP_DIV; }
&&              { return OP_AND; }
\|\|            { return OP_OR; }
==              { return OP_EQUAL; }
!=              { return OP_NOT_EQUAL; }
>               { return OP_GREATER; }
\<              { return OP_LOWER; }
>=              { return OP_GREATER_EQUAL; }
\<=             { return OP_LOWER_EQUAL; }
\=              { return ASSIGN; }
\+=             { return ASSIGN_PLUS; }
\-=             { return ASSIGN_MINUS; }
\*=             { return ASSIGN_MULT; }
\/=             { return ASSIGN_DIV; }
\?              { return TERNARY_QUESTION; }
:               { return TERNARY_COLON; }
\n              { return ENDL; }
\s              ;  // Ignore whitespace
{IDENTIFIER}    { return IDENTIFIER; }
{INTEGER}       { return INTEGER; }
{COMMENT}       { return COMMENT; }
.               return yytext[0];

%%
