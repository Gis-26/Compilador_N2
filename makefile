COMPILER_NAME = lion
SOURCE_FILES = lion.l lion.y
INPUT_EXT = .rei
OUTPUT_EXEC = lion

all: $(SOURCE_FILES)
	flex lion.l
	bison -d lion.y
	gcc lion.tab.c -o $(OUTPUT_EXEC) -lm
	./$(OUTPUT_EXEC)

run: all

clean:
	rm -f $(OUTPUT_EXEC) lex.yy.c lion.tab.c lion.tab.h
