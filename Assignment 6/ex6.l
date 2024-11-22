%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "y.tab.h"
int yylex(void);
int yyerror(char* s);
extern YYSTYPE yylval;
int line = 0;
%}

identifier [a-zA-Z_][a-zA-Z0-9_]*

doubConst (\+|\-)?[0-9][0-9]*\.[0-9]+ 
intConst (\+|\-)?[0-9][0-9]*
charConst \'.\'
stringConst \"(.)*\"

op ("+"|"-"|"*"|"/"|"%")
relop "<"|">"|"<="|">="|"=="|"!="
boolop ("!"|"&&"|"||")

%%
[ \t]           {}
\n              {}

"void"         {printf(" %25s | %-25s \n", yytext, "type void"); return VOID;}
"char"           {printf(" %25s | %-25s \n", yytext, "type char"); return CHAR;}
"int"           {printf(" %25s | %-25s \n", yytext, "type int"); return INT;}
"float"           {printf(" %25s | %-25s \n", yytext, "type float"); return FLOAT;}
"double"           {printf(" %25s | %-25s \n", yytext, "type double"); return DOUBLE;}
"String"         {printf(" %25s | %-25s \n", yytext, "type string"); return STR;}

"{"             {printf(" %25s | %-25s \n", yytext, "left curly"); return LEFTCURLY;}
"}"             {printf(" %25s | %-25s \n", yytext, "right curly"); return RIGHTCURLY;}
"["             {printf(" %25s | %-25s \n", yytext, "left square"); return LEFTSQUARE;}
"]"             {printf(" %25s | %-25s \n", yytext, "right square"); return RIGHTSQUARE;}
"("             {printf(" %25s | %-25s \n", yytext, "left parantheses"); return LEFT;}
")"             {printf(" %25s | %-25s \n", yytext, "right parantheses"); return RIGHT;}

"="             {printf(" %25s | %-25s \n", yytext, "equal to op"); return ASSIGN_OP;}

"+"             {printf(" %25s | %-25s \n", yytext, "plus op"); return PLUS_OP;}
"-"             {printf(" %25s | %-25s \n", yytext, "minus op"); return MINUS_OP;}
"*"             {printf(" %25s | %-25s \n", yytext, "mul op"); return MUL_OP;}
"/"             {printf(" %25s | %-25s \n", yytext, "div op"); return DIV_OP;}
"%"             {printf(" %25s | %-25s \n", yytext, "mod op"); return MOD_OP;}

"!"             {printf(" %25s | %-25s \n", yytext, "not op"); return NOT_OP;}
"&&"            {printf(" %25s | %-25s \n", yytext, "and op"); return AND_OP;}
"||"            {printf(" %25s | %-25s \n", yytext, "or op"); return OR_OP;}

{relop}         {printf(" %25s | %-25s \n", yytext, "rel op"); return REL_OP;}

{intConst}|{doubConst}|{charConst}      {printf(" %25s | %-25s \n", yytext, "numeric constant"); yylval.num=atoi(strdup(yytext)); return CONSTANT;}
{stringConst}   {printf(" %25s | %-25s \n", yytext, "string constant"); yylval.string=strdup(yytext); return STRING;}

{identifier}    {printf(" %25s | %-25s \n", yytext, "identifier"); yylval.string=strdup(yytext); return ID;}

","             {printf(" %25s | %-25s \n", yytext, "comma"); return COMMA;}
";"             {printf(" %25s | %-25s \n", yytext, "semi-colon"); return EOS;}
.

%%
