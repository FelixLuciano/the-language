#include <stdio.h>

extern FILE* yyin;
extern int yyparse();


void yyerror(const char* s) {
    fprintf(stderr, "%s\n", s);
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
