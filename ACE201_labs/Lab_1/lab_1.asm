.data

	out_string: .asciiz "\n Hello World!\n"
	string1: .asciiz "Enter text here: "
	string2: .asciiz "\nHello "
	string3: .asciiz " World!"
	userInput: .space 1024

.text

	main:
		#PRINT "HELLO, WORLD!"
		li $v0, 4 #load op-code 4 for printing out string
		la $a0, out_string #load out_string insto a0 register
		syscall #print it (takes args from a0 register)
		
		#Prompt User for input
		li $v0, 4
		la $a0, string1
		syscall

		#Get Input from User:
		li $v0, 8 #Load op-code 8 for readind a string
		la $a0, userInput #store string into userInput
		li $a1, 1024 #load size as well 
		syscall
		

		#Displaying Hello + userInput
		li $v0, 4
		la $a0, string2
		syscall

    	li $a2, 0 #index = 0
		li $t0, 2
	loop:
    		lb $a3, userInput($a2)  #loads the first byte of userInput into a3
		addiu $a2, $a2, 1 #index = index + 1 (no overflow)
		bne $a3, $0, loop #if byte == \0 else calls loop again
    		beq $a1, $a2, skip  #if index is "a1" bytes long then there is no \n, so we skip
		subu $a2, $a2, $t0 #we loaded 2 into t0 and we substract them (no pseudo instruction)
    		sb $0, userInput($a2) #substitude last character with \0 
	skip:
    		#Displaying userInput
		li $v0, 4
		la $a0, userInput
		syscall

		#Displaying World + string3
		li $v0, 4
		la $a0, string3
		syscall

		#Exiting
		li $v0, 10 #op-code 10 for terminating
		syscall
