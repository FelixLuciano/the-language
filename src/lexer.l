%{
    #include "parser.tab.hpp"
    #include <string>

    #define SAVE_STRING(value) (yylval.string = new std::string(value))
    #define SAVE_YY_STRING yylval.string = new std::string(yytext, yyleng)
    #define SAVE_YY_INTEGER SAVE_YY_STRING; yylval.integer = std::stoll(*yylval.string)

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
NULL            { SAVE_STRING("NULL"); return IDENTIFIER; }
int             { SAVE_STRING("int"); return IDENTIFIER; }
void            { SAVE_STRING("void"); return IDENTIFIER; }
else            { return ELSE; }
\;              { return SEPARATOR; }
\+              { SAVE_STRING("+"); return OP_PLUS; }
\-              { SAVE_STRING("-"); return OP_MINUS; }
\*              { SAVE_STRING("*"); return OP_MULT; }
\/              { SAVE_STRING("/"); return OP_DIV; }
\&\&            { SAVE_STRING("&&"); return OP_AND; }
\|\|            { SAVE_STRING("||"); return OP_OR; }
\=\=            { SAVE_STRING("=="); return OP_COMPARE; }
\!\=            { SAVE_STRING("!="); return OP_COMPARE; }
\>              { SAVE_STRING(">"); return OP_COMPARE; }
\<              { SAVE_STRING("<"); return OP_COMPARE; }
\>\=            { SAVE_STRING(">="); return OP_COMPARE; }
\<\=            { SAVE_STRING("<="); return OP_COMPARE; }
\=              { return ASSIGN; }
\+\=            { SAVE_STRING("+"); return OP_ASSIGN; }
\-\=            { SAVE_STRING("-"); return OP_ASSIGN; }
\*\=            { SAVE_STRING("*"); return OP_ASSIGN; }
\/\=            { SAVE_STRING("/"); return OP_ASSIGN; }
\?              { return TERNARY_QUESTION; }
\:              { return TERNARY_COLON; }
\{              { return OPEN_BRACES; }
\}              { return CLOSE_BRACES; }
\(              { return OPEN_PARENTHESIS; }
\)              { return CLOSE_PARENTHESIS; }
[\n]            { return ENDL; }
{COMMENT}       ;
{INTEGER}       { SAVE_YY_INTEGER; return INTEGER; }
{IDENTIFIER}    { SAVE_YY_STRING; return IDENTIFIER; }
{STRING}        { yylval.string = new std::string(yytext+1, yyleng-2); return STRING; }
{SPACE}         ;  // Ignore whitespace

%%
