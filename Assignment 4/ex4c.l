%{
    #include<stdio.h>
    #include<stdlib.h>
    #include<string.h>
    #include "y.tab.h"

    int debug=0;
%}
term ([a-zA-Z_][a-zA-Z0-9_]*|-?[0-9]+)
relop ("<="|"<"|">="|">"|"=="|"!=")
op ("+"|"-"|"*"|"/"|"%")
bool_op ("!"|"&&"|"||")
%%
";" {return EOS;}
"if" {return IF;}
"else" {return ELSE;}
"while" { return WHILE; }
"do" { return DO; }
"switch" { return SWITCH; }
"case" { return CASE; }
"default" { return DEFAULT; }
"break" { return BREAK; }
{bool_op} {yylval.str = strdup(yytext);return BOOL_OP;}
{term} { yylval.str = strdup(yytext); return TERM; }
{relop} { yylval.str = strdup(yytext); return REL_OP; }
"=" {yylval.str = strdup(yytext); return ASSIGN_OP;}
"(" {return ROUND_LEFT;}
")" {return ROUND_RIGHT;}
"-" {yylval.str = strdup(yytext); return MINUS_OP;}
{op} { yylval.str = strdup(yytext); return ARITH_OP; }
[ \t\n]+ { }
. { return *yytext; }
%%
