.data
    out_string: 
            .asciiz "\nHello, World! \n"
    input_string:
            .word 4 #4 bytes address in memory of input_string
    
.text
    main:
        la $a0, out_string #load the address of out_string into a0 register
        li $v0, 4 #load op-code '4', for printing into v0 register
        syscall #call it

        la $a0, input_string #loads the memory input into a0
        li $v0, 8 #loads op-code 8 for reding input
        syscall

        la $a0, out_string
        li $v0, 4
        syscall

        la $a0, input_string
        syscall

        li $v0, 10 #loads op-code 10 for terminating the program
        syscall