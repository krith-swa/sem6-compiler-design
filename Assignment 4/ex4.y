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

%token <string> identifier
%token and or not truth falsity
%token <string> relop
%type <string> E
%type <string> C
%left '+' '-'
%left '/' '*'
%nonassoc relop
%%

S: A | B ;

A:
identifier '=' E '\n' {
    printf("%s = %s\n\n", $1, $3); return 0;
    }

E:
E '+' E {
printf("%s%d = %s %s %s\n", "temp", tempCount, $1, "+", $3);
    char temp[10];
    sprintf(temp, "temp%d", tempCount);
    $$ = strdup(temp);
    tempCount++; 
    }

| E '*' E {
    printf("%s%d = %s %s %s\n", "temp", tempCount, $1, "*", $3);
    char temp[10];
    sprintf(temp, "temp%d", tempCount);
    $$ = strdup(temp);
    tempCount++;
    }

| '-' E {
    printf("%s%d = %s %s\n", "temp", tempCount, "-", $2);
    char temp[10];
    sprintf(temp, "temp%d", tempCount);
    $$ = strdup(temp);
    tempCount++;
    }

| identifier {
    $$ = strdup($1);
    }
;

B: identifier '=' C '\n'{
    printf("%d: %s = %s\n\n", address, $1, $3);
    address++; return 0;
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

| identifier relop identifier {
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