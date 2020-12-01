all: logger acmonitor test_aclog
FLAGS= -Wall -g3

logger: logger.c
	gcc ${FLAGS} -fPIC -shared -o logger.so logger.c -lcrypto -ldl -D_FILE_OFFSET_BITS=64
	
acmonitor: acmonitor.c 
	gcc ${FLAGS} acmonitor.c -o acmonitor

test_aclog: test_aclog.c 
	gcc ${FLAGS} test_aclog.c -o test_aclog

run: all logger.so test_aclog 
	LD_PRELOAD=./logger.so ./test_aclog

clean:
	rm -rf file_*
	rm -rf junk_*
	rm -rf logger.so
	rm -rf file_logging.log
	rm -rf acmonitor
	rm -rf test

