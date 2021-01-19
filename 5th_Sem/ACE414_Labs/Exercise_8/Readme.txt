ACE414 - Systems and Services Security
Assignment 8 - Simple Buffer Overflow POC
Stavrou Odysseas - 2018030199

1.) Approach:

    The stack of the readString() function looks something like this:
            |/////////////|
    ESP ->  |-------------|
    BUF ->  |             |
            |             |
            |     BUF     |
            |             |
            |             |
            |-------------|
            |      Ι      |
            |-------------|
    EBP ->  |PREV STACK FR|
            |-------------|
            |     EIP     |
            |-------------|
            |/////////////|

    By using the gets() function we can overwrite pass the end of the given buffer effectively controlling the EIP register thus the flow of instructions.

    Returning from readString() the stack is destroyed and the EBP is popped (leave):

                |/////////////|
                |-------------|
    ESP,EBP ->  |PREV STACK FR|                       |-------------|         
                |-------------|    -> -> ->    ESP -> |     EIP     |
                |     EIP     |                       |-------------|
                |-------------|
                |/////////////|

    After leave the ret instruction is called that pops the EIP and jumps to the instruction pointed by it.

    We know that the global variable "Name" resides in some area of memory that is marked as rwx (using mprotect),
    so it makes sense that we overwrite EIP with Name's address.
    We need to determine how much data we need to write before overwritting the EIP value, and also find Name's address

    Examining the source code, we see that the first 128 bytes of the buf variable are copied into the Name buffer, 
    so our payload should be the first thing we write into the buffer
    so that it gets copied into the executable segment.

    After inserting the payload we need to insert some junk data in order to fill the remaining stack frame and,
    then inject Name's address to jump to our malicous shellcode and execute it.
    So the exploit order should be: payload -> some junk -> Name's address.


2.) Writting the exploit:
    Name's address: Since the executable is static and non-PIE then the addresses never change, so using GDB we can simply do "p &Name" and grab the output.
    Also Name's address can be obtained using "objdump -t Greeter | grep Name"

    Required padding: 
        i.) Using GDB set breakpoint at the "ret" instruction of readString()
        ii.) Using python, print a recognizable byte pattern like the alphabet ("AAAABBBB...") so it's easier to find in memory, redirect that output to a file
            Note: for larger buffers better use a pattern creator and finder
            Run with the python output as argument.
        iii.) Step into the ret, GDB should produce an error that it cannot access memory in a specified address.
        iv.) That address converted into string is the pattern portion that has been written into EIP.
        v.) Now we know how much data we need to control the EIP, 48 bytes.

    Payload: 
        For starters, i used the int3 instruction (0xCC) before using a shellcode, just to see if i jump correctly.
        Then i used the following shellcode: http://shell-storm.org/shellcode/files/shellcode-811.php
        Basically, it pushes the string "/bin/sh" onto the stack and then calls the execve syscall to execute a shell.
        

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

        Payload length: 28 bytes

    Intermediate junk:
        Since the payload is part of the padding to reach EIP, the correct padding after we write our payload is 48 - 28 bytes = 20.

    Finally the exploit is:
        payload + 20 (whatever) bytes + Name's address + newline

        Pack a newline so it triggers gets() immediately

3.) Exploiting
    We need to use a little trick in order to have a successful shell. 
    If we were to execute:
    
    ./exploit.py | ./Greeter
    
    then the pipe would close and the newly opened shell will have no input so it closes.

    We can circumvent this by appeding a stray "cat" command to keep the pipe open like this:

    (./exploit.py;cat) | ./Greeter 

    "Boom", we got shell.


Notes: The program is written really badly in order for a BOF attack to be possible and also many compiler flags need to be set
        in order to disable core Security features like the stack smashing detection and PIE.

Run "exploit.py" and pipe the output to Greeter's input as shown above, to exploit the packed Greeter program.
Run "pwn_exp.py" to exploit any compiled version of Greeter, written using the pwntools library (pip install pwntools).
(It grabs Name's address from the ELF directly, and handles the IO redirection to and from the opened shell)


Standalone Testing the Shellcode:
    To test the shellcode outside the binary i created a simple C program that first maps a place in memory and then marks it as 
    rwx. It then copies the shellcode into that memory segment. After that it casts the sellcode's address into a function pointer 
    that returns nothing and then calls the shellcode.

