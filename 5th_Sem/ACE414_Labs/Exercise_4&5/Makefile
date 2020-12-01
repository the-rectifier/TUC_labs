all: logger acmonitor test_aclog create_files
FLAGS= -Wall -g3

logger:	logger.c
	gcc ${FLAGS} -fPIC -shared -o logger.so logger.c -lcrypto -ldl 
	
acmonitor:	acmonitor.c 
	gcc ${FLAGS} acmonitor.c -o acmonitor

test_aclog: test_aclog.c 
	gcc ${FLAGS} test_aclog.c -o test_aclog

create_files:	create_files.c
	gcc ${FLAGS} create_files.c -o create_files

run: all logger.so test_aclog 
	LD_PRELOAD=./logger.so ./test_aclog

clean:
	rm -rf file_*
	rm -rf junk_*
	rm -rf logger.so
	rm -rf file_logging.log
	rm -rf acmonitor
	rm -rf test
	rm -rf create_files

