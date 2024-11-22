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
\n              {printf("newline\n");}

{line_comment}  {printf("comment\n"); return COMMENT;}
{import}        {printf("import\n"); return IMPORT;}
{access_type}   {printf("access\n"); return ACCESS;}
"class"         {printf("class\n"); return CLASS;}
"static"         {printf("static\n"); return STATIC;}
"main"         {printf("main\n"); return MAIN;}

"void"         {printf("void\n"); return VOID;}
"char"           {printf("chartype\n"); return CHAR;}
"int"           {printf("inttype\n"); return INT;}
"float"           {printf("floattype\n"); return FLOAT;}
"double"           {printf("doubletype\n"); return DOUBLE;}
"String"         {printf("Stringtype\n"); return STR;}

"System.out.println"    {printf("print"); return PRINT;}

"{"             {printf("left{\n"); return LEFTCURLY;}
"}"             {printf("right}\n"); return RIGHTCURLY;}
"["             {printf("left[\n"); return LEFTSQUARE;}
"]"             {printf("right]\n"); return RIGHTSQUARE;}
"("             {printf("left(\n"); return LEFT;}
")"             {printf("right)\n"); return RIGHT;}

"="             {printf("=\n"); return ASSIGN_OP;}

"+"             {printf("+\n"); return PLUS_OP;}
"-"             {printf("-\n"); return MINUS_OP;}
"*"             {printf("*\n"); return MUL_OP;}
"/"             {printf("/\n"); return DIV_OP;}
"%"             {printf("mod\n"); return MOD_OP;}

"!"             {printf("not\n"); return NOT_OP;}
"&&"            {printf("and\n"); return AND_OP;}
"||"            {printf("or\n"); return OR_OP;}

{relop}         {printf("relop\n"); return REL_OP;}

{intConst}|{doubConst}|{charConst}      {printf("const\n"); return CONSTANT;}
{stringConst}   {printf("string\n"); return STRING;}

{identifier}    {printf("id\n"); return ID;}

","             {printf(",\n"); return COMMA;}
";"             {printf("EOS\n"); return EOS;}
.

%%
