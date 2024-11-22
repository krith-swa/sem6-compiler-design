/*Lexical Analyser for Java using the lex tool*/

%{
#include <stdio.h>
#include <stdlib.h>
%}

line_comment \/\/(.)*
multi_comment \/\*([^*]|[\r\n]|(\*+([^*/]|[\r\n])))*\*+\/

access_type "public"|"private"|"extern"|"protected"
datatype "char"|"int"|"short"|"long"|"float"|"double"|"enum"|"signed"|"unsigned"|"String"|"void"
funcall "print"|"println"|"printf"|"getch"|"clrscr"|"getchar"|"getline"|"read"|"next"|"nextInt"|"nextFloat"|"nextLong"|"nextShort"|"nextDouble"|"nextBoolean"|"nextByte"|"nextLine"|"switch"|"for"|"while"|"main"
keyword {access_type}|{datatype}|"auto"|"break"|"case"|"const"|"continue"|"default"|"do"|"else"|"for"|"goto"|"if"|"register"|"return"|"sizeof"|"static"|"struct"|"typedef"|"union"|"volatile"|"class"|"static"|"System"|"out"|"Scanner"|"new"|"in"|"null"|"try"|"catch"|"finally"|"import"|"java"|"util"

doubConst (\+|\-)?[1-9][0-9]*\.[0-9]+ 
intConst_dec (\+|\-)?[0-9]+
intConst_hex (\+|\-)?[1-9a-fA-F][0-9a-fA-F]*h
charConst \'.\'
stringConst \"(.)*\"

identifier [a-zA-Z_][a-zA-Z0-9_]*

assignOp =
bitwiseOp "^"|"&"|"|"|"<<"|">>" 
arithAssignOp "+="|"-="|"*="|"\="|"%="
relOp <|<=|>|>=|=|!= 
arithOp "+"|"-"|"*"|"/"|"%"
incOp "++"
decOp "--"
logicOp &&|\|\||! 

separators ";"|","|"."|"["|"]"|"("|")"|"{"|"}"|"["|"]"

comment {line_comment}|{multi_comment}
constVal {doubConst}|{intConst_dec}|{intConst_hex}|{charConst}|{stringConst}
operator {assignOp}|{bitwiseOp}|{arithAssignOp}|{relOp}|{arithOp}|{logicOp}

%%

{line_comment}  {printf("   %25s | %-25s \n", yytext, "Single-line comment");}
{multi_comment} {printf("   %25s | %-25s \n", yytext, "Multi-line comment");}

{keyword}       {printf("   %25s | %-25s \n", yytext, "Keyword");}
{funcall}       {printf("   %25s | %-25s \n", yytext, "In-built Function");}

{doubConst}     {printf("   %25s | %-25s \n", yytext, "Real const");}
{intConst_dec}  {printf("   %25s | %-25s \n", yytext, "Integer Constant (decimal)");}
{intConst_hex}  {printf("   %25s | %-25s \n", yytext, "Integer Constant (hexadecimal)");}
{charConst}     {printf("   %25s | %-25s \n", yytext, "Character Constant");}
{stringConst}   {printf("   %25s | %-25s \n", yytext, "String Constant");}

{bitwiseOp}     {printf("   %25s | %-25s \n", yytext, "Bitwise Operator");}
{assignOp}      {printf("   %25s | %-25s \n", yytext, "Assignment Operator");}
{arithAssignOp} {printf("   %25s | %-25s \n", yytext, "Arith Assign Operator");}
{incOp}       	{printf("   %25s | %-25s \n", yytext, "Increment Operator");}
{decOp}       	{printf("   %25s | %-25s \n", yytext, "Decrement Operator");}
{arithOp}       {printf("   %25s | %-25s \n", yytext, "Arithmetic Operator");}
{logicOp}       {printf("   %25s | %-25s \n", yytext, "Logical Operator");}
{relOp}         {printf("   %25s | %-25s \n", yytext, "Relational Operator");}

{separators}    {printf("   %25s | %-25s \n", yytext, "Separator");}

{identifier}    {printf("   %25s | %-25s \n", yytext, "Identifier");}

.|\n {}

%%

int yywrap(){}

int main(int argc, char *argv[]){
	if (argc != 2) {
		printf("Please enter the sample file as the second argument!\n");
		exit(0);
	}
	yyin = fopen(argv[1], "r");
	if (yyin == NULL) {printf("File not found!\n");
		exit(0);
	}
	printf("\n\n");
	yylex();
	printf("\n\n");
	return 0;
}

