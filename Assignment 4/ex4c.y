%{
    #include <stdlib.h>
    #include <stdio.h>
    int yylex(void);
    extern FILE* yyin;
    #include "y.tab.h"
    int error = 0;
    /*extern int debug;*/
    int termCount = 1, controlCount = 1, switchCount = 0, numberCase = 1;
    int cc = 1, tc = 1, nc = 1, sc = 0;
%}
%token TERM ASSIGN_OP ARITH_OP REL_OP ID BOOL_OP EOS IF ELSE WHILE SWITCH CASE DEFAULT BREAK DO MINUS_OP ROUND_LEFT ROUND_RIGHT
%union
{
    int intval;
    float floatval;
    char *str;
}
%type<str> TERM REL_OP ARITH_OP ASSIGN_OP BOOL_OP MINUS_OP
%%
line: /* empty */
    | TERM ASSIGN_OP TERM ARITH_OP TERM EOS { printf("t%d := %s %s %s\n%s := t%d\n", termCount, $3, $4, $5, $1, termCount); termCount++; } line
    | TERM ASSIGN_OP TERM MINUS_OP TERM EOS { printf("t%d := %s %s %s\n%s := t%d\n", termCount, $3, $4, $5, $1, termCount); termCount++; } line
    | TERM ASSIGN_OP TERM REL_OP TERM EOS { printf("t%d := %s %s %s\n%s := t%d\n", termCount, $3, $4, $5, $1, termCount); termCount++; } line
    | TERM ASSIGN_OP TERM EOS { printf("%s := %s\n", $1, $3); } line
    | TERM ASSIGN_OP MINUS_OP TERM EOS {printf("t%d := -%s\n%s := t%d\n", termCount, $4, $1, termCount); termCount++; } line
    | TERM ASSIGN_OP TERM BOOL_OP TERM EOS { printf("t%d := %s %s %s\n%s := t%d\n", termCount, $3, $4, $5, $1, termCount); termCount++; } line
    | while_block
    | switch_block

while_block: WHILE ROUND_LEFT TERM REL_OP TERM ROUND_RIGHT '{' { printf("LABEL_%d: if not %s %s %s then goto FALSE_%d\nTRUE_%d: ", controlCount, $3, $4, $5, controlCount, controlCount); } line '}' { printf("FALSE_%d: ", controlCount); controlCount++; } line
    | WHILE ROUND_LEFT TERM ARITH_OP TERM ROUND_RIGHT '{' { printf("LABEL_%d: if not %s %s %s then goto FALSE_%d\nTRUE_%d: ", controlCount, $3, $4, $5, controlCount, controlCount); } line '}' { printf("FALSE_%d: ", controlCount); controlCount++; } line
    | WHILE ROUND_LEFT TERM BOOL_OP TERM ROUND_RIGHT '{' { printf("LABEL_%d: if not %s %s %s then goto FALSE_%d\nTRUE_%d: ", controlCount, $3, $4, $5, controlCount, controlCount); } line '}' { printf("FALSE_%d: ", controlCount); controlCount++; } line
    | WHILE ROUND_LEFT TERM ROUND_RIGHT DO '{' { printf("LABEL_%d: if not %s then goto FALSE_%d\nTRUE_%d: ", controlCount, $3, controlCount, controlCount); } line '}' { printf("FALSE_%d: ", controlCount); cc++; } line

switch_block: SWITCH ROUND_LEFT TERM REL_OP TERM ROUND_RIGHT '{' { printf("t%d := %s %s %s\n", termCount, $3, $4, $5); switchCount = termCount; termCount++; } cases_block '}' { printf("NEXT_%d: ", controlCount); controlCount++; } line
    | SWITCH ROUND_LEFT TERM ARITH_OP TERM ROUND_RIGHT '{' { printf("t%d := %s %s %s\n", termCount, $3, $4, $5); switchCount = termCount; termCount++; } cases_block '}' { printf("NEXT_%d: ", controlCount); controlCount++; } line
    | SWITCH ROUND_LEFT TERM MINUS_OP TERM ROUND_RIGHT '{' { printf("t%d := %s %s %s\n", termCount, $3, $4, $5); switchCount = termCount; termCount++; } cases_block '}' { printf("NEXT_%d: ", controlCount); controlCount++; } line
    | SWITCH ROUND_LEFT TERM BOOL_OP TERM ROUND_RIGHT '{' { printf("t%d := %s %s %s\n", termCount, $3, $4, $5); switchCount = termCount; termCount++; } cases_block '}' { printf("NEXT_%d: ", controlCount); controlCount++; } line
    | SWITCH ROUND_LEFT TERM ROUND_RIGHT '{' { printf("t%d := %s\n", termCount, $3); switchCount = termCount; termCount++; } cases_block '}' { printf("NEXT_%d: ", controlCount); controlCount++; } line
    | BREAK EOS line { printf("goto NEXT_%d\n", controlCount); }

cases_block: /* empty */
     | CASE TERM ':' { printf("CASE_%d: if not t%d == %s goto CASE_%d\n", numberCase, switchCount, $2, numberCase + 1); numberCase++; } line cases_block
     | DEFAULT { printf("CASE_%d: ", numberCase); numberCase++; } ':' line { printf("goto NEXT_%d\n", controlCount); } cases_block
%%
int yyerror(char* s)
{
  fprintf(stderr, "%s\n", s);
  return 0;
}
int yywrap(){
    return 1;
}

int main(int argc, char **argv){
    /*yydebug = 1;*/
    if(argc != 2){
        fprintf(stderr, "Enter file name as argument!\n");
        return 1;
    }
    yyin = fopen(argv[1], "rt");
    if (!yyin){
        fprintf(stderr, "File not found!\n");
        return 2;
    }
    yyparse();
    printf("\n");
    return 0;
}
