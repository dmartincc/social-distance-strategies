CC= gcc
CFLAGS= -Wall -std=c99 -lm -lgsl -lgslcblas -O2 -Wno-unused-result -pg
SOURCES=  main.c read.c spread.c WELL1024a.c

.PHONY: sir
sir:
	$(CC) $(SOURCES) $(CFLAGS) -o sir
