%{
#include <stdio.h>
#include <stdlib.h>
#include "y.tab.h"
void yyerror(char*);
extern YYSTYPE yylval;
%}
digit [0-9]
letter [a-zA-Z]
identifier (_|{letter})(_|{digit}|{letter})*
relop "<"|">"|"<="|">="|"=="|"!="
space " "
%%
{space} { return *yytext; }
"="|"+"|"*"|"-" { return *yytext; }
"\n" { return *yytext; }
{relop} { yylval.string=strdup(yytext); return relop; }
"and" { return and; }
"or" { return or; }
"not" { return not; }
"true" { return truth; }
"false" { return falsity; }
{identifier} { yylval.string=strdup(yytext); return identifier;
}
%%