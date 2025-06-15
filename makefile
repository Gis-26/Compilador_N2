all : aula5.l aula5.y
	clear
	flex -i aula5.l
	bison aula5.y
	gcc aula5.tab.c -o analisador -lfl -lm
	./analisador
