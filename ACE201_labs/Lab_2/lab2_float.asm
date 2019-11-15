# Title: Simple Calculator											Filename: lab02.asm						
# Authors: Staurou Odysseas, Kalaitzakis Panagiotis								Date: 20/10/2019
# Description: Either adds, subtracts, multiplies or divides two integers read from keyboard then exits		Version: 1.01				

############################################################# Data Segment #############################################################
.data

str1: .asciiz "\nPlease enter first Number: "
str2: .asciiz "\nPlease enter operator: "
str3: .asciiz "\nPlease enter second Number: "
str4: .asciiz "\nThe result is: "

error1: .asciiz "\nERROR: Uknown Operator. Acceptable inputs +,-,*,/ Try again: "
error2: .asciiz "\nCan't divide by Zero!"

n2: .word 1

operations: .asciiz "+-*/"

n1: .word 1

############################################################# Code Segment #############################################################
.text

	main:
	
		li $v0, 4 				# Prompt user to enter the first integer
		la $a0, str1
		syscall

		li $v0, 5 				# Syscall for reading integer
		syscall

		sw $v0, n1				# Moves integer entered from user, from $v0 to memory for later use

	OPERATOR: 	
		  
		li $v0, 4			# Prompts user to enter an operator
		la $a0, str2
		syscall
		
		li $v0, 12			# Syscall for reading character
		syscall
													
		move $s0, $v0			# Moves operator input from $v0 to $s0 thus storing it (not using memory)	
													
		li $t0, 0			# Loads 0 to $t0, which will be used as a counter index (i)
	
	LOOP:					# Makes sure userinput operator is acceptable
		
		lb $a0, operations($t0)		# Loads (i) byte of string "operations" to $a0
		
		add $t0, $t0, 1			# i++
		
		beq $t0, 5, RETRY		# if(i=5), jump to label RETRY -----> user input stored in $s0 does not match one of the following +-*/ since index is now bigger than string
		
		bne $a0, $s0, LOOP		# if(byte[i]!=userinput), branch to LOOP again to check for next byte 	 
	
	SECOND_INT:
	
		li $v0, 4				# Prompts user to enter the second integer
		la $a0, str3
		syscall
		
		li $v0, 5				# Syscall for reading integer
		syscall	
		
		sw $v0, n2				# Stores integer read from $v0, to memory for later use	

		beq $s0, 0x0000002B, ADDITION
		beq $s0, 0x0000002D, SUBTRACTION
		beq $s0, 0x0000002A, MULTIPLICATION
		beq $s0, 0x0000002F, DIVISION
	
	RESULT:					# Prints result for +,-,* operations (result will be an integer)
	
		li $v0, 4
		la $a0, str4
		syscall
					
		li $v0, 1		# Syscall for printing integer, moves stored result from $t0 to $a0 for printing it.
		move $a0, $s0           
		syscall			
					
	EXIT:					
		li $v0, 10		# Syscall for exit 
		syscall									
	
	ADDITION:				
		lw $t0, n1		# Loads integers stored in memory to $t0 and $t1 respectivly	
		lw $t1, n2		
		add $s0, $t0, $t1	# Adds $t1 to $t0 and stores result in $t0 overwritting previously loaded n1
		j RESULT		
	
	SUBTRACTION:	
		lw $t0, n1		# Loads integers stored in memory to $t0 and $t1 respectivly
		lw $t1, n2
		sub $s0, $t0, $t1	# Subtracts $t1 from $t0 and stores result in $t0 overwritting previously loaded n1
		j RESULT
	
	MULTIPLICATION:
		lw $t0, n1		# Loads integers stored in memory to $t0 and $t1 respectivly
		lw $t1, n2
		mult $t0, $t1		# Multiplies $t0 by $t1 and stores integer quotient in special LO register 
		mflo $s0		# Moves result stored in LO register to $t0
		j RESULT
	
	DIVISION:	
			
		lw $t0, n1		# Loads integers stored in memory to $t0 and $t1 respectivly
		lw $t1, n2
		
		beq $t1, $zero, NULL 	# Checks if integer stored in $t1 is 0 and jumps to NULL if true
		
		mtc1 $t0, $f1		# Moves integer values from $t0 and $t1 to $f1 and $f2 (COPROCESSOR_1) respectivly 
		mtc1 $t1, $f2
		
		cvt.s.w $f1, $f1	# Converts integer values (words) to single precision floating point numbers for division 
		cvt.s.w $f2, $f2
		
		div.s $f12, $f1, $f2	# Executes division between two float numbers, stores float result in $f12
		
		li $v0, 4		# Prints result message
		la $a0, str4
		syscall
		
		li $v0, 2		# System call for printing float stored in $f12
		syscall
		j EXIT
	
	RETRY:
		li $v0, 4		# Prints error1
		la $a0, error1
		syscall
		j OPERATOR
	
	NULL:					# Warns user that he can't divide by zero and exit
		li $v0, 4
		la $a0, error2
		syscall
		j SECOND_INT
