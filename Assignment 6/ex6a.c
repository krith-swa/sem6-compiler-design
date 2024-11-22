#include<stdio.h>
#include<string.h>

void main()
{
	char icode[10][30], str[20], opr[10];
	int i=0;
	printf("\nEnter the set of intermediate code (terminated by exit):\n");
	do
	{
		scanf("%s", icode[i]);
	}
	while(strcmp(icode[i++],"exit")!=0);
		printf("\nTarget Code Generation");
	printf("\n");
	i=0;
	do
	{
		strcpy(str,icode[i]);
		switch(str[3]){
			case '+':
				strcpy(opr,"ADD");
				break;
			case '-':
				strcpy(opr,"SUB");
				break;
			case '*':
				strcpy(opr,"MUL");
				break;
			case '/':
				strcpy(opr,"DIV");
			break;
	}
	printf("\nMOV R%d, %c", i, str[2]);
	printf("\n%s R%d, %c", opr, i, str[4]);
	printf("\nMOV %c, R%d", str[0], i);      
	}
	while(strcmp(icode[++i],"exit")!=0); 
	printf("\n");   
}
