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
int tempCount = 1;
char temp[10];
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
    printf("%s = %s\n", $1, $3);
    printf("MOV %s, %s\n", $1, reg);
}
| ID ASSIGN_OP numexpr {
    printf("%s = %d\n", $1, $3);
    printf("MOV %s, R0\n", $1);
}
;

expr:
ID {
    sprintf(reg, "R%d", tempCount);
    sprintf(temp, "temp%d", tempCount++);
    printf("%s = %s\n", temp, $1);
    printf("MOV %s, %s\n", reg, $1);
    $$ = strdup(temp);
}
| expr PLUS_OP expr {
    if (strcmp($1, "0") && strcmp($3, "0")) {
        sprintf(reg, "R%d", tempCount);
        sprintf(temp, "temp%d", tempCount++);
        printf("%s = %s %s %s\n", temp, $1, "+", $3);
        $$ = strdup(temp);

        int lreg = 0, rreg = 0;
        if (strlen($1)>=5 && strlen($3)>=5) {
            lreg = temp[strlen($1)-1];
            rreg = temp[strlen($3)-1];
            sprintf(temp, "R%d", rreg);
            sprintf(reg, "R%d", lreg);
            printf("ADD %s, %s\n", reg, temp);
        }
        else if (strlen($1)>=5) {
            lreg = temp[strlen($1)-1];
            sprintf(temp, "R%d", lreg);
            printf("ADD %s, %s\n", temp, $3);
        }
        else if (strlen($3)>=5) {
            rreg = temp[strlen($3)-1];
            sprintf(temp, "R%d", rreg);
            printf("ADD %s, %s\n", reg, temp);
        }
        else {
            printf("here\n");
            printf("ADD %s, %s\n", reg, $3);
        }
    }
    else {
        sprintf(temp, "temp%d", tempCount-1);
        $$ = strdup($1);
    }
}
| expr MINUS_OP expr {
    if (strcmp($1, "0") && strcmp($3, "0")) {
        sprintf(temp, "temp%d", tempCount++);
        printf("%s = %s %s %s\n", temp, $1, "-", $3);
        $$ = strdup(temp);
    }
    else {
        sprintf(temp, "temp%d", tempCount-1);
        $$ = strdup($1);
    }
}
| expr MUL_OP expr {
    if (strcmp($1, "1") && strcmp($3, "1")) {
        sprintf(reg, "R%d", tempCount);
        sprintf(temp, "temp%d", tempCount++);
        printf("%s = %s %s %s\n", temp, $1, "*", $3);
        $$ = strdup(temp);

        int lreg = 0, rreg = 0;
        printf("length: %d %d\n", strlen($1), strlen($3));
        if (strlen($1)>=5 && strlen($3)>=5) {
            lreg = temp[strlen($1)-1];
            rreg = temp[strlen($3)-1];
            sprintf(temp, "R%d", rreg);
            sprintf(reg, "R%d", lreg);
            printf("MUL %s, %s\n", reg, temp);
        }
        else if (strlen($1)>=5) {
            lreg = temp[strlen($1)-1];
            sprintf(temp, "R%d", lreg);
            printf("MUL %s, %s\n", temp, $3);
        }
        else if (strlen($3)>=5) {
            rreg = temp[strlen($3)-1];
            sprintf(temp, "R%d", rreg);
            printf("MUL %s, %s\n", reg, temp);
        }
        else {
            printf("MUL %s, %s\n", reg, $3);
        }
    }
    else {
        sprintf(temp, "temp%d", tempCount-1);
        $$ = strdup($1);
    }
}
| expr DIV_OP expr {
    if (strcmp($3, "1")) {
        sprintf(temp, "temp%d", tempCount++);
        printf("%s = %s %s %s\n", temp, $1, "/", $3);
        $$ = strdup(temp);
    }
    else {
        sprintf(temp, "temp%d", tempCount-1);
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
    printf("MOV R0, #%d\n", $1);
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
    printf("Syntax Analyser: \n");
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
