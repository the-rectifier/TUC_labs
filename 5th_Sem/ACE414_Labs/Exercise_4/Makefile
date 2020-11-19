all: logger acmonitor test_aclog
FLAGS= -Wall -g3

logger: logger.c
	gcc ${FLAGS} -fPIC -shared -o logger.so logger.c -lcrypto -ldl

acmonitor: acmonitor.c 
	gcc ${FLAGS} acmonitor.c -o acmonitor

test_aclog: test_aclog.c 
	gcc ${FLAGS} test_aclog.c -o test_aclog

run: all logger.so test_aclog 
	LD_PRELOAD=./logger.so ./test_aclog

clean:
	rm -rf logger.so
	rm -rf test_aclog
	rm -rf acmonitor
	rm -rf file_logging.log
	rm -rf file_*