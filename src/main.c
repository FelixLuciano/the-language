#include <stdio.h>
#include <stdlib.h>
#include <sys/time.h>

#include "parser.tab.h"
#include "ast.h"

extern FILE* yyin;
extern int yylineno, yyleng;
extern char* yytext;
extern int yyparse();
extern Node_t* programNode;

int yyerror(const char* message) {
    fprintf(stderr, "Syntax error at line %d:%d: %s\n", yylloc.first_line, yylloc.first_column, message);
    fprintf(stderr, "Input near the error: \"%.*s\"\n", 10, yytext);

    return 0;
}

int yywrap() {
    return 1;
}

unsigned int getMilliseconds() {
    struct timeval currentTime;
    gettimeofday(&currentTime, NULL);
    return (unsigned int)((currentTime.tv_sec * 1000) + (currentTime.tv_usec / 1000));
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

    char filename[128];

    sprintf(filename, "out-%u", getMilliseconds());

    if (programNode != NULL) {
        FILE *output = fopen(filename, "w");
        if (!output) {
            perror("Error building output");

            return 1;
        }

        fprintf(output, "from the_language import *\n");
        buildScript(programNode, 0, output);
        fprintf(output, ".evaluate(SymbolTable())\n");
        destroyNode(programNode);
        fclose(output);

        char command[256];
        sprintf(command, "python3 %s", filename);
        system(command);
        remove(filename);
    }

    return 0;
}
