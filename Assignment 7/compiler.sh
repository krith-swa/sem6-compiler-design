#!/bin/bash
echo "__COMPILER__"

lex ex7.l

yacc -d ex7a.y
gcc -o tac.out y.tab.c lex.yy.c
./tac.out sample.txt

yacc -d ex7b.y
gcc -o tar.out y.tab.c lex.yy.c
./tar.out sample.txt

echo -e "\n\nLexical Analyser: "
cat output_lex.txt

echo -e "\n\nSyntax Analyser: "
cat output_syntax.txt

echo -e "\n\nTAC: "
cat output_tac.txt

echo -e "\n\nTarget code: "
cat output_target.txt

echo -e "\n\nSuccessful compilation!"