%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "y.tab.h"
int yylex(void);
void yyerror(char*);
int yywrap(void);
int tempCount = 1;
int address = 100;
%}

%union {
    char *string;
    int num;
    };

%type <string> E C
%type <num> N
%token <string> IDENTIFIER REL_OP ARITH_OP BOOL_OP MINUS_OP ASSIGN_OP
%token <num> INTEGER
%token and or not truth falsity
%token EOS IF ELSE WHILE DO SWITCH CASE DEFAULT BREAK
%left '+' '-' '/' '*' '%'
%nonassoc relop
%%

S: A S {
    return 0;
    }

| B S {
    return 0;
}

| '\n'
|
;

A:
IDENTIFIER ASSIGN_OP E EOS {
    printf("%s = %s\n\n", $1, $3);
    }

| IDENTIFIER ASSIGN_OP N EOS {
    printf("%s = %d\n\n", $1, $3);
    }
;

E:
E ARITH_OP E {
printf("%s%d = %s %s %s\n", "temp", tempCount, $1, $2, $3);
    char temp[10];
    sprintf(temp, "temp%d", tempCount);
    $$ = strdup(temp);
    tempCount++; 
    }

| MINUS_OP E {
    printf("%s%d = %s %s\n", "temp", tempCount, "-", $2);
    char temp[10];
    sprintf(temp, "temp%d", tempCount);
    $$ = strdup(temp);
    tempCount++;
    }

| IDENTIFIER {
    $$ = strdup($1);
    }
;

N:
N ARITH_OP N {
printf("%s%d = %d %s %d\n", "temp", tempCount, $1, $2, $3);
    char temp[10];
    sprintf(temp, "temp%d", tempCount);
    $$ = strdup(temp);
    tempCount++; 
    }

| MINUS_OP N {
    printf("%s%d = %s %d\n", "temp", tempCount, "-", $2);
    char temp[10];
    sprintf(temp, "temp%d", tempCount);
    $$ = strdup(temp);
    tempCount++;
    }

| INTEGER {
    $$ = $1;
    }
;

B: IDENTIFIER ASSIGN_OP C '\n'{
    printf("%d: %s = %s\n\n", address, $1, $3);
    address++;
    }

C:
C ' ' or ' ' C {
    printf("%d: temp%d = %s or %s\n",
    address, tempCount, $1, $5);
    char temp[10];
    sprintf(temp, "temp%d", tempCount);
    $$ = strdup(temp);
    address++;
    tempCount++;
    }

| C ' ' and ' ' C {
    printf("%d: temp%d = %s and %s\n", address, tempCount, $1, $5);
    char temp[10];
    sprintf(temp, "temp%d", tempCount);
    $$ = strdup(temp);
    address++; 
    tempCount++;
    }

| not ' ' C {
    printf("%d: temp%d = not %s\n", address, tempCount, $3);
    char temp[10];
    sprintf(temp, "temp%d", tempCount);
    $$ = strdup(temp);
    address++;
    tempCount++;
    }

| IDENTIFIER REL_OP IDENTIFIER {
    printf("%d: if %s %s %s, goto %d\n", address, $1, $2, $3, address + 3);
    address++;
    printf("%d: temp%d = 0\n", address, tempCount);
    address++;
    printf("%d: goto %d\n", address, address + 2);
    address++;
    printf("%d: temp%d = 1\n", address, tempCount);
    char temp[10];
    sprintf(temp, "temp%d", tempCount);
    $$ = strdup(temp);
    address++;
    tempCount++;
    }

| truth {
    printf("%d: temp%d = 1\n", address, tempCount);
    char temp[10];
    sprintf(temp, "temp%d", tempCount);
    $$ = strdup(temp);
    tempCount++;
    address++;
    }

| falsity {
    printf("%d: temp%d = 0\n", address, tempCount);
    char temp[10];
    sprintf(temp, "temp%d", tempCount);
    $$ = strdup(temp);
    tempCount++;
    address++;
    }
%%
int yywrap(){
    return 1;
    }
void yyerror(char* msg){
    fprintf(stderr, "%s", msg);
    return;
    }
int main(){
    printf("Enter expression: ");
    yyparse();
    return 0;
    }