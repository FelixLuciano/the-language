#include <iostream>
#include "parser.tab.hpp"

extern "C" {
    void yyrestart(FILE *input_file);
    extern char* yytext;
    extern YYLTYPE yyloc;

    int yywrap() {
        return 1;
    }
}

using namespace std;

int yyerror(const char* message) {
    cerr << "Syntax error at line " << yylloc.first_line << "-" << yylloc.first_column << ": " << message << endl;
    cerr << "Input near the error: \"" << yytext << "\"" << endl;

    return 0;
}

int main(int argc, char *argv[]) {
    if (argc != 2) {
        fprintf(stderr, "Usage: %s <input_file>\n", argv[0]);

        return 1;
    }

    FILE* yyin = fopen(argv[1], "r");
    if (!yyin) {
        perror("Error opening input file");

        return 1;
    }

    yyparse();
    fclose(yyin);

    return 0;
}
