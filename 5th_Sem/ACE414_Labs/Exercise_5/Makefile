all: logger 
FLAGS= -Wall -g3

logger: logger.c
	gcc ${FLAGS} -fPIC -shared -o logger.so logger.c -lcrypto -ldl -D_FILE_OFFSET_BITS=64

clean:
	rm -rf logger.so
	rm -rf file_logging.log