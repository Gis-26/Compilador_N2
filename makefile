#Compilar o codigo e executar
all: matrix.l matrix.y
	flex matrix.l
	bison -d matrix.y
	gcc matrix.tab.c -o Matrix -lm
	./Matrix

# excluir os arquivos compilados
clean:
	rm -f Matrix lex.yy.c matrix.tab.c matrix.tab.h