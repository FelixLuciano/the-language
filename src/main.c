#include <stdio.h>

extern FILE* yyin;
extern int yylineno, yyleng;
extern char* yytext;
extern int yyparse();

int yyerror(const char* s) {
    fprintf(stderr, "Syntax error at line %d, column %d: %s\n", yylineno, yyleng, s);
    fprintf(stderr, "Input near the error: \"%.*s\"\n", 10, yytext);

    return 0;
}

int main(int argc, char *argv[]) {
    if (argc != 2) {
        fprintf(stderr, "Usage: %s <input_file>\n", argv[0]);

        return 1;
    }

    yyin = fopen(argv[1], "r");
    if (!yyin) {
        perror("Error opening input file");

        return 1;
    }

    yyparse();
    fclose(yyin);

    return 0;
}
