EXECUTABLE = thec
CC = gcc
CFLAGS =

.PHONY: build test

all: build

build: src/**
	bison --debug -o build/parser.tab.c -d src/parser.y -Wcounterexamples
	flex -o build/lexer.yy.c src/lexer.l
	$(CC) $(CFLAGS) -o bin/$(EXECUTABLE) build/parser.tab.c build/lexer.yy.c src/main.c -lfl

test:
	./bin/$(EXECUTABLE) example/calculator.txt
