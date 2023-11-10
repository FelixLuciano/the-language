EXECUTABLE = parse
CC = gcc
CFLAGS =

.PHONY: build test

all: build

build: src/**
	flex -o build/lex.yy.c src/lexer.l
	bison -o build/y.tab.c -d src/parser.y -Wcounterexamples
	$(CC) $(CFLAGS) -o build/$(EXECUTABLE) build/lex.yy.c build/y.tab.c src/main.c -lfl

test:
	./build/$(EXECUTABLE) example/calculator.txt
