//lexical analyser for a C program

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>

#define MAX 1000

/*void ispredir(char str[MAX]) {
	if (str[0] == '#') {
		for (int i=0; str[i]!='\n'; i++) {
			printf("%c",str[i]);
			}
		printf(" - preprocessor directive\n");
		}
	}

int iskeyword() {
	
	}*/

int main() {
	//reading code from the source code file
	FILE* code; char input[MAX], ch;
	code = fopen("code.txt","r");
	
	if (code == NULL) {
		printf("Error! File not found!\n");
		exit(0);
		}
		
	else {
		int i = 0;
		while (!feof(code)) {
			ch = fgetc(code);
			input[i++] = ch;
			}
		}
		
	fclose(code);
	
	//printing the array of input characters
	/*for (int i=0; input[i]!=EOF; i++) {
		printf("%c", input[i]);
		}*/
	
	//performing lexical analysis on the code to identify tokens
	for (int i=0; input[i]!=EOF; i++) {
		//parse input - driver code
		int j;
		if (input[i] == '#') {
			for (j=i; input[j]!='\n'; j++) {
				printf("%c", input[j]);
				}
			printf(" - preprocessor directive\n");
			i = i+j;
			}
		else {
			printf("%c", input[i]);
			}
		}
	
	return 0;	
	}
