%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "y.tab.h"
int yylex(void);
int yyerror();
extern FILE* yyin;
extern int line;
int error = 0;
int regCount = 1;
char reg[10];
%}

%union {
    char* string;
    int num;
    };

%type <string> expr boolop
%type <num> numexpr

%token <string> VOID INT FLOAT DOUBLE CHAR STR
%token <string> LEFTCURLY RIGHTCURLY LEFTSQUARE RIGHTSQUARE LEFT RIGHT COMMA EOS
%token <string> ASSIGN_OP PLUS_OP MINUS_OP MUL_OP DIV_OP MOD_OP REL_OP NOT_OP AND_OP OR_OP
%token <string> ID STRING
%token <num> CONSTANT

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
| FLOAT
| DOUBLE
| CHAR
| STR
| type LEFTSQUARE RIGHTSQUARE
;

var:
var COMMA var
| ID
| assignment
;

assignment:
ID ASSIGN_OP expr {
    printf("MOV %s, %s\n", $1, $3);
}
| ID ASSIGN_OP numexpr {
    printf("MOV %s, %d\n", $1, $3);
}
;

expr:
ID {
    sprintf(reg, "reg%d", regCount++);
    printf("MOV %s, %s\n", reg, $1);
    $$ = strdup(reg);
}
| expr PLUS_OP expr {
    if (strcmp($1, "0") && strcmp($3, "0")) {
        printf("ADD %s, %s\n", $1, $3);
        $$ = strdup($1);
    }
    else {
        $$ = strdup($1);
    }
}
| expr MINUS_OP expr {
    if (strcmp($1, "0") && strcmp($3, "0")) {
        printf("SUB %s, %s\n", $1, $3);
        $$ = strdup($1);
    }
    else {
        $$ = strdup($1);
    }
}
| expr MUL_OP expr {
    if (strcmp($1, "1") && strcmp($3, "1")) {
        printf("MUL %s, %s\n", $1, $3);
        $$ = strdup($1);
    }
    else {
        $$ = strdup($1);
    }
}
| expr DIV_OP expr {
    if (strcmp($1, "1") && strcmp($3, "1")) {
        printf("DIV %s, %s\n", $1, $3);
        $$ = strdup($1);
    }
    else {
        $$ = strdup($1);
    }
}
| expr REL_OP expr
| expr boolop expr
| NOT_OP expr
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

boolop:
AND_OP {
    $$ = strdup($1);
}
| OR_OP {
    $$ = strdup($1);
}
;

%%

int yywrap(){
    return 1;
}

int yyerror() {
    fprintf(stderr, "\n\nSyntax is NOT valid! Error at line %d\n", line);
    error = 1;
    return 0;
}

int main(int argc, char *argv[])
{   
    printf("(till) Code Generator: \n");
    if (argc != 2) {
        printf("Please enter the sample file as the second argument!\n");
        exit(0);
    }

    yyin = fopen(argv[1], "r");
    if (!yyin) {
        printf("File not found!\n");
        exit(0);
    }

    yyparse();
    if(!error){
        printf("\n\nValid syntax!\n");
    }

    return 0;
}
