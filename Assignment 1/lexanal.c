#include<stdio.h>
#include<string.h>
#include <ctype.h>
#define maxbuffsize 1000


int startadd=1000;

struct symboltable{
	char identifier_name[30],type[10],value[10];
	int bytes,address;
	
}symbols[10];

int ind=0;
char lastdt[30];
char lastiden[30];


int search(char buff[])
{

	for(int i=0;i<ind;i++)
	{
		if(strcmp(symbols[i].identifier_name,buff)==0) return i+1;
	}
	return 0;
}

int issplchar(char buff)
{
	char splchars[]={';', ',' ,'.','[', ']', '(', ')', '{', '}', '[',']'};

	for(int i=0;i<11;i++)
	{
		if(buff==splchars[i]) return 1;
	}
	
	return 0;
}


int isfuncall(char buff[])
{

	char funcalls[][30]={"printf","main","scanf","getch","clrscr","getchar"};

	for(int i=0;i<5;i++)
	{
		if(strcmp(funcalls[i],buff)==0)
			return 1;
	}
	return 0;

}

int iskeyword(char buff[])
{
	char keywords[][30]={"auto","break","case","char","const","continue","default","do","double","else","enum","extern","float","for","goto","if","int","long","register","return","short","signed","sizeof","static","struct","switch","typedef","union","unsigned","void","volatile","while"};

	for(int i=0;i<32;i++)
	{
		if(strcmp(keywords[i],buff)==0)
			return 1;
	}
	return 0;
}

int isdatatype(char buff[])
{
	char datatypes[][30]={"int","float","double","char"};

	for(int i=0;i<4;i++)
	{
		if(strcmp(datatypes[i],buff)==0)
			return 1;
	}
	return 0;
}

int numbytes(char buff[])
{
	if(strcmp("int",buff)==0) return 2;
	if(strcmp("float",buff)==0) return 4;
	if(strcmp("double",buff)==0) return 8;
	if(strcmp("char",buff)==0) return 1;
	return 0;

}


int isoperand(char buff)
{
	if(buff=='+' || buff=='-')return 1;
	if(buff=='*' || buff=='/' || buff=='%')return 2;
	if(buff=='<' || buff=='>' || buff=='!')return 3;
	if(buff=='=')return 4;
	if(buff=='&' || buff=='|')return 5;
	return 0;
}

int main(int argc, char* argv[])
{

 //Reading file into buffer
 char buff[maxbuffsize+1];
 char fname[30];
 strcpy(fname, argv[1]);

 FILE *fp=fopen(fname,"r");

 if(!fp){printf("FIle does not exist\n");return 0;}

 int size=fread(buff,sizeof(char),maxbuffsize,fp);
 buff[size++]='\0';

 fclose(fp);

 printf("CODE:\n%s\n\n",buff);



 for(int i=0;i<size;i++)
 {
  
	while(buff[i]!='\0' && buff[i]==' ' && buff[i]=='\n') i++;

	char temp[200]; int j=0;

	if(issplchar(buff[i]))
	{
	printf("%c : Special Character\n",buff[i]);
	continue;
	}
	if(isoperand(buff[i]))
	{
		if(isoperand(buff[i])==1)
		{
			if(buff[i]==buff[i+1]){
				printf("%c%c : Unary operator\n",buff[i],buff[i+1]);
				i++;
			}
			else if(buff[i+1]=='='){
				printf("%c%c : Arithmetic assignent operator\n",buff[i],buff[i+1]);
				i++;
			}
			else{
				printf("%c : Arithmetic operator\n",buff[i]);
			}
			continue;
		}
		else if(isoperand(buff[i])==2)
		{


			if(buff[i]=='/' && buff[i+1]=='/'){while(buff[i+1]!='\n')i++;i=i+1;}
			else if(buff[i]=='/' && buff[i+1]=='*'){while(buff[i]!='*' || buff[i+1]!='/')i++;i=i+1;}

			else if(buff[i+1]=='='){
				printf("%c%c : Arithmetic assignent operator\n",buff[i],buff[i+1]);
				i++;
			}
			else
				printf("%c : Arithmetic operator\n",buff[i]);
			continue;
		}
		else if(isoperand(buff[i])==3)
		{
			if(buff[i+1]=='=')
			{
				printf("%c%c : Relational operator\n",buff[i],buff[i+1]);
				i++;
			}
			else{
				printf("%c : Relational operator\n",buff[i]);
			}
			continue;
		}
		else if(isoperand(buff[i])==4)
		{
			if(buff[i]==buff[i+1]){
				printf("%c%c : Relational operator\n",buff[i],buff[i+1]);
				i++;
			}
			else{
				printf("%c : Assignment operator\n",buff[i]);
	
				int store=i;
				char val[30];int j=0;
				
				i+=1;
				while(buff[i]==' ')i++;
				while(isdigit(buff[i]))
				val[j++]=buff[i++];
				val[j]='\0';
				strcpy(symbols[search(lastiden)-1].value,val);
				
				
				i=store;
				
			}
			continue;
		}
		else if(isoperand(buff[i])==5)
		{
			if(buff[i]==buff[i+1]){
				printf("%c%c : Logical operator\n",buff[i],buff[i+1]);
				i++;
			}
			else{
				printf("%c : Bitwise operator\n",buff[i]);
			}
			continue;
		}

		
	}

	if(buff[i]=='#')
	{
	 while(buff[i]!='\0' && buff[i]!='\n')
	{
 		temp[j++]=buff[i++];
	}
	temp[j]='\0';
	printf("%s : preprocessor directive\n",temp);

	continue;
	}

	if(isalpha(buff[i])||buff[i]=='_')
	{
	 temp[j++]=buff[i++];
	 while(isalnum(buff[i]) || buff[i]=='_')
		temp[j++]=buff[i++];
	 temp[j]='\0';
	

	if(isfuncall(temp))
		{
			if(buff[i]=='('){
				
				temp[j]=buff[i];
				
				do{
					i++;
					j++;
					temp[j]=buff[i];
				}while(buff[i]!=')');	
				
				j+=1;
				temp[j]='\0';
				printf("%s : function call\n",temp);
				
				continue;		

			}
			
		}

	else if(iskeyword(temp))
	     {
		printf("%s : Keyword\n",temp);
		
		if(isdatatype(temp))
		{
			strcpy(lastdt,temp);
		}
		i--;
		continue;
	     }
	else{
		printf("%s :  Identifier\n",temp);
		strcpy(lastiden,temp);
		if(search(temp)==0)
		{
			strcpy(symbols[ind].identifier_name,temp);	
			strcpy(symbols[ind].type,lastdt);		
			symbols[ind].bytes=numbytes(lastdt);
			symbols[ind].address=startadd;
			startadd+=numbytes(lastdt);
			ind+=1;
		}
		i-=1;
		continue;
	}

         
	}

	if(isdigit(buff[i]))
	{
		
		while(isdigit(buff[i]))
			temp[j++]=buff[i++];

		temp[j]='\0';
		i-=1;

		printf("%s : Integer constant\n",temp);
		continue;

		
	}

	

	
 }

printf("\nSYMBOL TABLE\nname type  bytes   address      value\n");
 for(int i=0;i<ind;i++)
 {
	printf("%s    %s     %d      %d        %s\n",symbols[i].identifier_name,symbols[i].type,symbols[i].bytes,symbols[i].address,symbols[i].value);
 }


 





return 0;
}
