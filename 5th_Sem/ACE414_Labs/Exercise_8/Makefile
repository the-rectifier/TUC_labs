all: Greeter test_shellcode

Greeter: Greeter.c
	gcc -ansi -static -fno-stack-protector -z execstack -g -no-pie -m32 Greeter.c -o Greeter

test_shellcode: shellcode_test.c
	gcc -fno-stack-protector -z execstack -m32 -ggdb shellcode_test.c -o test_shellcode

clean:
	rm Greeter
	rm test_shellcode
