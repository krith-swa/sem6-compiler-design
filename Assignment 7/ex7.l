/*lexical analyser*/

%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "y.tab.h"
int yylex(void);
int yyerror(char* s);
FILE* flex;
extern YYSTYPE yylval;
int line = 0;
%}

identifier [a-zA-Z_][a-zA-Z0-9_]*

intConst (\+|\-)?[0-9]+
doubConst (\+|\-)?[0-9]+\.[0-9]+
charConst \'.\'
strConst \"(.)*\"

arithop "+"|"-"|"*"|"/"
relop ">"|"<"|">="|"<="|"=="
boolop "!"|"&&"|"||"

%%

[ \t]   {}
\n      {}

"void"  {fprintf(flex, " %25s | %-25s \n", yytext, "type void"); return VOID;}
"int"   {fprintf(flex, " %25s | %-25s \n", yytext, "type int"); return INT;}

"("     {fprintf(flex, " %25s | %-25s \n", yytext, "sp char - left parantheses"); return LEFTB;}
")"     {fprintf(flex, " %25s | %-25s \n", yytext, "sp char - right parantheses"); return RIGHTB;}

"="     {fprintf(flex, " %25s | %-25s \n", yytext, "equal-to op"); return ASSIGN_OP;}

"+"     {fprintf(flex, " %25s | %-25s \n", yytext, "plus op"); return PLUS_OP;}
"-"     {fprintf(flex, " %25s | %-25s \n", yytext, "minus op"); return MINUS_OP;}
"*"     {fprintf(flex, " %25s | %-25s \n", yytext, "mul op"); return MUL_OP;}
"/"     {fprintf(flex, " %25s | %-25s \n", yytext, "div op"); return DIV_OP;}

{intConst}|{doubConst} {fprintf(flex, " %25s | %-25s \n", yytext, "numeric constant"); yylval.num = atoi(strdup(yytext)); return CONSTANT;}
{strConst} {fprintf(flex, " %25s | %-25s \n", yytext, "string constant"); yylval.string = strdup(yytext); return STRING;}

{identifier} {fprintf(flex, " %25s | %-25s \n", yytext, "identifier"); yylval.string = strdup(yytext); return ID;}

","     {fprintf(flex, " %25s | %-25s \n", yytext, "sp char - comma"); return COMMA;}
";"     {fprintf(flex, " %25s | %-25s \n", yytext, "sp char - semi-colon"); return EOS;}
.

%%