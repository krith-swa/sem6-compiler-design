%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "string.h"
int yylex(void);
int yyerror();
extern FILE* yyin;
extern FILE* flex;
FILE* fsyn;
FILE* ftar;
extern int line;
int error = 0;
int regCount = 0;
char reg[10];
%}

%union {
    char* string;
    int num;
};

%type <string> expr
%type <num> numexpr

%token <string> VOID INT
%token <string> LEFTB RIGHTB COMMA EOS
%token <string> ASSIGN_OP PLUS_OP MINUS_OP MUL_OP DIV_OP
%token <string> ID STRING
%token <num> CONSTANT

%left PLUS_OP MINUS_OP
%left MUL_OP DIV_OP

%start program

%%

program: 
statement program {
    return 0;
}
| '\n'
|
;

statement: 
declnstatement EOS
| assignment EOS
;

declnstatement:
type var
;

type: 
INT
| VOID
;

var:
var COMMA var
| ID
| assignment
;

assignment:
ID ASSIGN_OP expr {
    fprintf(ftar, "MOV %s, %s\n", $1, $3);
}
| ID ASSIGN_OP numexpr {
    fprintf(ftar, "MOV %s, %d\n", $1, $3);
}
;

expr:
ID {
    sprintf(reg, "R%d", ++regCount);
    fprintf(ftar, "MOV %s, %s\n", reg, $1);
    $$ = strdup(reg);
}
| expr PLUS_OP expr {
    if (strcmp($3, "0") && strcmp($1, "0")) {
        fprintf(ftar, "ADD %s, %s\n", $1, $3);
        $$ = strdup($1);
    }
    else {
        if (strcmp($1, "0"))
            $$ = strdup($1);
        else
            $$ = strdup($3);
    }
}
| expr MINUS_OP expr {
    if (strcmp($3, "0") && strcmp($1, "0")) {
        fprintf(ftar, "SUB %s, %s\n", $1, $3);
        $$ = strdup($1);
    }
    else {
        if (strcmp($1, "0"))
            $$ = strdup($1);
        else
            $$ = strdup($3);
    }
}
| expr MUL_OP expr {
    if (strcmp($3, "1") && strcmp($1, "1")) {
        fprintf(ftar, "MUL %s, %s\n", $1, $3);
        $$ = strdup($1);
    }
    else {
        if (strcmp($1, "1"))
            $$ = strdup($1);
        else
            $$ = strdup($3);
    }
}
| expr DIV_OP expr {
    if (strcmp($3, "1") && strcmp($1, "1")) {
        fprintf(ftar, "DIV %s, %s\n", $1, $3);
        $$ = strdup($1);
    }
    else {
        if (strcmp($1, "1"))
            $$ = strdup($1);
        else
            $$ = strdup($3);
    }
}
| numexpr {
    char number[10];
    sprintf(number, "%d", $1);
    $$ = strdup(number);
}
;

numexpr:
CONSTANT {
    $$ = $1;
}
| numexpr PLUS_OP numexpr {
    $$ = $1 + $3;
}
| numexpr MINUS_OP numexpr {
    $$ = $1 - $3;
}
| numexpr MUL_OP numexpr {
    $$ = $1 * $3;
}
| numexpr DIV_OP numexpr {
    $$ = $1 / $3;
}
;

%%

int yywrap() {
    return 1;
}

int yyerror() {
    fprintf(stderr, "\n\nInvalid syntax!\n");
    return 0;
}

int main(int argc, char* argv[]) {
    if (argc != 2) {
        printf("Enter file name as second argument\n");
        exit(0);
    }

    yyin = fopen(argv[1], "r");
    if (!yyin) {
        printf("File not found!\n");
        exit(0);
    }

    flex = fopen("output_lex.txt", "w");
    if (!flex) {
        printf("Output file lex error!\n");
        exit(0);
    }

    fsyn = fopen("output_syntax.txt", "w");
    if (!fsyn) {
        printf("Output file syn error!\n");
        exit(0);
    }

    ftar = fopen("output_target.txt", "w");
    if (!ftar) {
        printf("Output file target error!\n");
        exit(0);
    }

    yyparse();
    if (!error) {
        fprintf(fsyn, "\nValid syntax!\n");
    }

    return 0;
}