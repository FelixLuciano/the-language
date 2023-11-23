%{
    #include "parser.tab.hpp"
    #include <string>
    extern "C" int yywrap();
%}

SPACE           [ ]
IDENTIFIER      [a-zA-Z_][a-zA-Z0-9_]*
INTEGER         [0-9]+
STRING          \"([^"]*)\"
COMMENT         \/\/[^\n]*

%%

return          { return RETURN; }
ref             { return REF; }
block           { return BLOCK; }
NULL            { yylval.string = "NULL"; return IDENTIFIER; }
int             { yylval.string = "int"; return IDENTIFIER; }
void            { yylval.string = "void"; return IDENTIFIER; }
else            { return ELSE; }
\;              { return SEPARATOR; }
\+              { yylval.string = "+"; return OP_PLUS; }
\-              { yylval.string = "-"; return OP_MINUS; }
\*              { yylval.string = "*"; return OP_MULT; }
\/              { yylval.string = "/"; return OP_DIV; }
\&\&            { yylval.string = "&&"; return OP_AND; }
\|\|            { yylval.string = "||"; return OP_OR; }
\=\=            { yylval.string = "=="; return OP_COMPARE; }
\!\=            { yylval.string = "!="; return OP_COMPARE; }
\>              { yylval.string = ">"; return OP_COMPARE; }
\<              { yylval.string = "<"; return OP_COMPARE; }
\>\=            { yylval.string = ">="; return OP_COMPARE; }
\<\=            { yylval.string = "<="; return OP_COMPARE; }
\=              { return ASSIGN; }
\+\=            { yylval.string = "+"; return OP_ASSIGN; }
\-\=            { yylval.string = "-"; return OP_ASSIGN; }
\*\=            { yylval.string = "*"; return OP_ASSIGN; }
\/\=            { yylval.string = "/"; return OP_ASSIGN; }
\?              { return TERNARY_QUESTION; }
\:              { return TERNARY_COLON; }
\{              { return OPEN_BRACES; }
\}              { return CLOSE_BRACES; }
\(              { return OPEN_PARENTHESIS; }
\)              { return CLOSE_PARENTHESIS; }
[\n]            { return ENDL; }
{COMMENT}       ;
{INTEGER}       { yylval.string = std::string(yytext, yyleng); return INTEGER; }
{IDENTIFIER}    { yylval.string = std::string(yytext, yyleng); return IDENTIFIER; }
{STRING}        { yylval.string = std::string(yytext+1, yyleng-2); return STRING; }
{SPACE}         ;  // Ignore whitespace

%%
