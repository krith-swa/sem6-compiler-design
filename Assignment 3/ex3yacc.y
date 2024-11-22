%{
#include <stdlib.h>
#include <stdio.h>
int yylex(void);
int yyerror();
extern FILE* yyin;
#include "y.tab.h"
int error = 0;
extern int line;
%}

%token COMMENT IMPORT ACCESS CLASS STATIC MAIN PRINT
%token VOID INT FLOAT DOUBLE CHAR STR
%token LEFTCURLY RIGHTCURLY LEFTSQUARE RIGHTSQUARE LEFT RIGHT COMMA EOS
%token ASSIGN_OP PLUS_OP MINUS_OP MUL_OP DIV_OP MOD_OP REL_OP NOT_OP AND_OP OR_OP
%token ID CONSTANT STRING

%%
program: 
COMMENT program {
    return 0;
    }
| import_block program {
    return 0;
    }
| class_block program {
    return 0;
    }
| '\n'
| 
;

import_block: 
IMPORT ID EOS
;

class_block: 
ACCESS CLASS ID LEFTCURLY function RIGHTCURLY
;

function: 
ACCESS STATIC VOID MAIN LEFT mainarg RIGHT LEFTCURLY block RIGHTCURLY
;

mainarg:
STR ID LEFTSQUARE RIGHTSQUARE
| STR LEFTSQUARE RIGHTSQUARE ID
;

block: 
statement block
|
;

statement:
declnstatement EOS
| assignment EOS
| printstatement EOS
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
ID ASSIGN_OP expr
;

printstatement:
PRINT LEFT printinner RIGHT
;

printinner:
printinner PLUS_OP printinner
| expr
| STRING
|
; 

expr:
CONSTANT
| ID
| expr arithop expr
| expr REL_OP expr
| expr boolop expr
| NOT_OP expr
;

arithop:
MOD_OP
| MUL_OP
| DIV_OP
| PLUS_OP
| MINUS_OP
;

boolop:
AND_OP
| OR_OP
;

%%

int yywrap(){
    return 1;
}

int yyerror() {
    fprintf(stderr, "\nSyntax is NOT valid! Error at line %d\n", line);
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
        printf("\nValid syntax!\n");
    }

    return 0;
}
