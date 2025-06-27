#make linux
#all : aula5.l aula5.y
#	clear
#	flex -i aula5.l
#	bison aula5.y
#	gcc aula5.tab.c -o analisador -lfl -lm
#	./analisador

#make windows + MSYS2
all: aula5.l aula5.y
	clear
	flex -i aula5.l
	bison -d aula5.y
	gcc aula5.tab.c lex.yy.c -o analisador.exe -lfl -lm
	./analisador.exe
