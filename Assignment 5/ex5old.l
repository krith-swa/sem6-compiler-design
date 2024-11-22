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

doubConst (\+|\-)?[0-9][0-9]*\.[0-9]+ 
intConst (\+|\-)?[0-9][0-9]*
charConst \'.\'
stringConst \"(.)*\"

relop "<"|">"|"<="|">="|"=="|"!="
op ("+"|"-"|"*"|"/"|"%")
bool_op ("!"|"&&"|"||")

space " "
%%
{space} { return *yytext; }
";" {return EOS;}
"if" {return IF;}
"else" {return ELSE;}
"while" { return WHILE; }
"do" { return DO; }
"switch" { return SWITCH; }
"case" { return CASE; }
"default" { return DEFAULT; }
"break" { return BREAK; }
"("|")" { return *yytext; }
"-" {yylval.string = strdup(yytext); return MINUS_OP;}
{bool_op} {yylval.string = strdup(yytext);return BOOL_OP; }
{relop} { yylval.string=strdup(yytext); return REL_OP; }
{op} { yylval.string = strdup(yytext); return ARITH_OP; }
"=" {yylval.string = strdup(yytext); return ASSIGN_OP; }
"and" { return and; }
"or" { return or; }
"not" { return not; }
"true" { return truth; }
"false" { return falsity; }
{intConst} {yylval.num=atoi(yytext); return INTEGER; }
{identifier} { yylval.string=strdup(yytext); return IDENTIFIER; }
"\n" { return *yytext; }
%%