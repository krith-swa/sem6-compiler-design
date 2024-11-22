%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "y.tab.h"
int yylex(void);
int yyerror(char* s);
extern int yylval;
int line = 0;
%}

line_comment \/\/(.)*
import "import"
access_type "public"|"private"|"extern"|"protected"
identifier [a-zA-Z_][a-zA-Z0-9_]*

doubConst (\+|\-)?[1-9][0-9]*\.[0-9]+ 
intConst (\+|\-)?[1-9][0-9]*
charConst \'.\'
stringConst \"(.)*\"

op ("+"|"-"|"*"|"/"|"%")
relop "<"|">"|"<="|">="|"=="|"!="
boolop ("!"|"&&"|"||")

%%
[ \t]           {}
\n              {}

{line_comment}  {return COMMENT;}
{import}        {return IMPORT;}
{access_type}   {return ACCESS;}
"class"         {return CLASS;}
"static"         {return STATIC;}
"main"         {return MAIN;}

"void"         {return VOID;}
"char"           {return CHAR;}
"int"           {return INT;}
"float"           {return FLOAT;}
"double"           {return DOUBLE;}
"String"         {return STR;}

"System.out.println"    {return PRINT;}

"{"             {return LEFTCURLY;}
"}"             {return RIGHTCURLY;}
"["             {return LEFTSQUARE;}
"]"             {return RIGHTSQUARE;}
"("             {return LEFT;}
")"             {return RIGHT;}

"="             {return ASSIGN_OP;}

"+"             {return PLUS_OP;}
"-"             {return MINUS_OP;}
"*"             {return MUL_OP;}
"/"             {return DIV_OP;}
"%"             {return MOD_OP;}

"!"             {return NOT_OP;}
"&&"            {return AND_OP;}
"||"            {return OR_OP;}

{relop}         {return REL_OP;}

{intConst}|{doubConst}|{charConst}      {return CONSTANT;}
{stringConst}   {return STRING;}

{identifier}    {return ID;}

","             {return COMMA;}
";"             {return EOS;}
.

%%
