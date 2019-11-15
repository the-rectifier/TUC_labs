.data
	prompt: .asciiz "\n Enter String to be processed: "
	res_prompt: .asciiz "\n Processed String is: "
	.align 2
	input_buffer: .space 100
	.align 2
	out_buffer : .space 100

.text
	j main

get_input:
##################################################################################
#	
#	buffer of 100 chars
#	
##################################################################################
	li $v0, 4
	la $a0, prompt
	syscall

	li $v0, 8
	la $a0, input_buffer
	li $a1, 100
	syscall
	jr $ra

process_input:
##################################################################################
#	
#	$t0 = input_buffer pointer
#	$t1 = output_buffer pointer
#	$t2 = current word(32bit)
#	$t3 = current byte
#	$t4 = upper_bound
#	$t5 = lower_bound
#	$t6 = byte index(i) 
#	$t7 = witten space flag
#	$t8 = space char
#
##################################################################################
	li $t8, 0x00000020								#hard-code space into t8 more on that later
	la $t0, input_buffer								#load the address of the input buffer
	la $t1, out_buffer									#load the address of the output buffer
	li $t7, 0										#we haven't written any spaces yet
get_word:
	lw $t2, ($t0)									#load the first word into t2
	addi $t0,$t0,0x00000004							#increase memory pointer by 4 for the next time 
	li $t6, 0										#offset 0 (1st byte of word)
get_bytes:
	andi $t3, $t2, 0x000000FF							#grab only the LSB
	srl $t2, $t2, 8									#shift word by 1 byte for the next time
process_byte:
	nop								
special_check_1: 										#checking for special chars
	li $t4, 0x00000020								#load byte 0x20 (space) into t4
	li $t5, 0x00000030								#load byte 0x30 (0) into t5
	slt $t5, $t3, $t5									#curr byte < 0x30?
	slt $t4, $t4, $t3									#curr byte > 0x20? (0x20 > curr byte)
	beq $t4, $t5, check_space							#check whether we already saved a space
	li $t4, 0x00000039								#load byte 0x39 (9) into t4
	li $t5, 0x00000041								#load byte 0x41 (A) into t4
	slt $t5, $t3, $t5									#curr byte < 0x39?
	slt $t4, $t4, $t3									#curr byte > 0x41? (0x41 > curr byte)
	beq $t4, $t5, check_space							#check whether we already saved a space
	li $t4, 0x0000005A								#you get the idea....
	li $t5, 0x00000061
	slt $t5, $t3, $t5
	slt $t4, $t4, $t3
	beq $t4, $t5, check_space
	li $t4, 0x0000007A
	li $t5, 0x0000007F
	slt $t5, $t3, $t5
	slt $t4, $t4, $t3
	beq $t4, $t5,check_space
space_check:
	beq $t3, 0x00000020, check_space					#check if current byte is a space character, jump to check whether to write it or not
caps_check:
	li $t7, 0										#if byte is not a space or a special character we can reset the space flag
	li $t4, 0										#reset upper bound
	li $t5, 0										#reset lower bound
	slti $t4, $t3, 0x0000005B							#check if byte is less than 0x5B and set t4 as 1
	slti $t5, $t3, 0x00000041							#check if byte is less that 0x41 and set t5 as 1
	xor $t4, $t4,$t5									#if the byte is a Capital Ascii then t4 will be 0 and t5 will be 1 so we simply check if the xor is 1
	bnez $t4, uncap_it								#if t4 is not 0 we uncap		
nl_check:
	beq $t3, 0x0000000A, break_loop						#if byte is a new line char we break the loop
store_it:
	sb $t3, ($t1)									#if all above checks passed then we can save an unmodified byte
	addi $t1, $t1, 0x00000001							#increase the byte write pointer by 1 
	beq $t6, 0x00000003, get_word						#if we read 4 bytes we get the next word
	addi $t6, $t6, 1									#add 1 to the bytes index
	j get_bytes										#bite the next one, pun intended 								
uncap_it:
	addi $t3, $t3, 0x0000020							#add 32 bits to byte to make it a lower ascii char
	li $t7, 0										#dont forget to reset the space flag if we uncap
	j store_it										#store it, if lower/capital character obviously it's not a special char
check_space:
	beq $t6, 0x00000003, get_word						#spaces may span more than 4 bytes so we keep an eye to our byte index
	addi $t6, $t6, 1									#increase byte index regardless of character
	beq $t7, 0x00000001, get_bytes						#if we already wrote a space then get the next byte
	li $t7, 1										#if not then set the flag
	sb $t8, ($t1)									#same princible applies for both spaces and special chars, so we store a space everytime
	addi $t1, $t1, 0x00000001							#increase byte writing pointer by 1
	j get_bytes										#bite the next one								
break_loop:
	sb $t3, ($t1)									#store new line character 
	jr $ra											#return to main
	
print_output:
##################################################################################
#	
#	print the modified buffer
#
##################################################################################
	li $v0, 4
	la $a0, res_prompt
	syscall

	li $v0, 4
	la $a0, out_buffer
	syscall	
	jr $ra

main:
	jal get_input
	jal process_input
	jal print_output
	
	li $v0, 10
	syscall
	

