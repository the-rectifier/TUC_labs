CC = gcc
CCFLAGS = -O2 -Wall -pedantic -g3 -std=c11
LIBSSL = -lssl -lcrypto

TARGETS = assign_1


all: $(TARGETS)

assign_1: main.c
	$(CC) $(CCFLAGS) $(DBUG) -o $@ $< $(LIBSSL)

clean:
	rm -f $(TARGETS)
