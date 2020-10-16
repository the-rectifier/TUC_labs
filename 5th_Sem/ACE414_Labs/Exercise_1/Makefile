CC=/usr/bin/gcc
CFLAGS=-std=c11 -Wall -g3
TARGET=demo
SRCS=demo.c simple_crypto.c simple_crypto.h

all:
	${CC} ${CFLAGS} -o ${TARGET} ${SRCS}

clean:
	rm -f ${TARGET}
	