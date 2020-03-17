CC= gcc
CFLAGS= -Wall -std=c99 -lm -lgsl -lgslcblas -O2 -Wno-unused-result
SOURCES=  main.c read.c spread.c WELL1024a.c

.PHONY: seir
seir:
	$(CC) $(SOURCES) $(CFLAGS) -o seir
