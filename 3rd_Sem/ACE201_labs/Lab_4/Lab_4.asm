##################################################################################################################################
##														LAB04, HRY201															##
##################################################################################################################################
# Title: Phonebook									Filename: lab04.asm		     											  	 #			
#														     	      															 #
# Authors: Stavrou Odysseas, Kalaitzakis Panagiotis													           Date: 21/11/2019	 #
#														     	                                                                 #
# Description: Simple program written in MIPS - assembly														 Version: 1.03	 #
#    that uses the stack feature to establish a basic phonebook.							                                     #
#    Said phonebook, can hold up to 10 entries. Each entry has 3 fields							                                 #
#    (First Name, Last Name, Phone number) 20 bytes long, each. 																 #
#	 Struct size is 600 bytes					                             													 #
# 									 						                                                                     #	
##################################################################################################################################						      								                                                                 #
.data
	promptOP: .asciiz "\nPlease determine operation, entry (E/e), inquiry (I/i), clear (C/c) or Quit (Q/q):\n"
	askLN: .asciiz "\nPlease enter last name:\n"
	askFN: .asciiz "\nPlease enter first name:\n"
	askPN: .asciiz "\nPlease enter phone number:\n"
	showentry: .asciiz "\nThank you, the new entry is the following:\n \t"
	askentry: .asciiz "\nPlease enter the entry you wish to retrieve:\n"
	noentry: .asciiz "\nThere is no such entry in the phonebook!"
	booksize: .asciiz "\nPhonebook can only hold 10 entries. Pick a number between 1-10."
	exitmessage: .asciiz "\nThank you for using our phonebook!"
	error1: .asciiz "\nCatalogue is FULL, you cannot add another entry. Try again."
	cleared: .asciiz "\nPhonebook Cleared"
	.align 2
	phonebook: .space 600
    user_in:   .space 20
	.align 2

.text
.globl main

init:
###############################################################################################################################
#	Once in the code section initialize the pointers for our struct
#	s0 = user's choice 
# 	s1 = pointer to the struct
#	s2 = pointer to the base of the struct
#	s3 = is the movable pointer
#	s4 = is the position of the movable pointer
#	s5 = init flag, after init we never init again
###############################################################################################################################
    la $s1, phonebook								
	li $s4, 1
    addi $s2, $s1, 600
    add $s3, $0, $s1
	li $s5, 0xffffffff
	la $a0, cleared
	li $v0, 4
	syscall
    j main												# jump main

write_buffer:
###############################################################################################################################
#	void write_buffer(*buffer)
#	writes the buffer(20-bytes to memory)
#	updates the current pointer in s3 eachtime
#	also checks if the struct is full
#	t0 = arg(buffer pointer)
#	t1 = current word
#	t2 = index
###############################################################################################################################
    li $t2, 0											# index 0
    move $t0, $a0										# grab arg
	beq $s3, $s2, ovf									# test if struct is full
    loop:
		lw $t1, ($t0)									# grab word
		sw $t1, ($s3)									# store word
		addi $s3, $s3, 4							 	# step is 4 for both pointers
		addi $t0, $t0, 4
		addi $t2, $t2, 1								# index++ 
		bne $t2,0x0000005, loop							# we stop after 5 words (20-bytes)
    jr $ra												# return
	ovf:
		la $a0, error1									# print full struct error then return
		li $v0, 4
		syscall
		j main
    
get_user:
###############################################################################################################################
#	*buffer get_user(*message, *buffer, size)
#	prompts a user with the message and reads size-1 characters
#	calls the strip function and returns a pointer to buffer
###############################################################################################################################
    li $v0, 4											# print msg
    syscall

    li $v0, 8											# get input from user 
    move $a0, $a2										# max bytes = size - 1
    syscall

    addi $sp, $sp, -4									# 4 bytes to the stack
    sw $ra 0($sp)										# store previous return address

    jal strip											# call strip(*buffer)

    lw $ra 0($sp)										# load last return address
	addi $sp, $sp, 4									# destroy the stack
	
    move $v0, $a2										
    jr $ra												# return with the buffer pointer

strip:
###############################################################################################################################
#	void strip(*buffer)
#	removes \n from giver buffer
#	returns the address to that buffer
# 	if no \n then skips
#	t0 = pointer to the buffer
#	t1 = current byte
#	t2 = index
###############################################################################################################################
    li $t2, 0											# index = 0
    move $t0, $a0										# grab arg
	find_LF:
		add $t0, $t0, 1									# start from 2nd byte
		lbu $t1, ($t0)			    					# bite
		beqz $t1, skip									# if byte == \0 skip it
		bne $t1,0x0000000A,find_LF		  				# check for LF if not bite the next 
		sb $0, ($t0)									# store \0 instead of \n
	skip:	
		jr $ra											# return

Get_Entry:
###############################################################################################################################
# 	procedure that calls get_user 3 times with the right arguments that grabs user input
#	also calls write buffer that stores each time the buffer
#	after writing the last buffer prints out the written entry
#	and moves up the positonal register s4
###############################################################################################################################
														# get first name
    la $a0, askFN										# message is first name prompt
    li $a1, 20											# size = 20
    la $a2, user_in										# buffer pointer
    jal get_user										# call get_user with args
    move $a0, $v0										# move returned value
    jal write_buffer									# call write_buffer with arg
														# get last name
	la $a0, askLN										# you get the point
    li $a1, 20
    la $a2, user_in
    jal get_user
    move $a0, $v0
    jal write_buffer
														# get phone
	la $a0, askPN
    li $a1, 20
    la $a2, user_in
    jal get_user
    move $a0, $v0
    jal write_buffer

	jal Print_last										# print last entry (this one)
	addi $s4, $s4, 1									# one more entry 
    j main												# return

Print_last:
###############################################################################################################################
# 	procedure that prints latest entry
#	prints the position in the struct
#	then a dot (lmao)
#	then each segment (20-bytes each)
#	t0 = 60 bytes less that current position (beginning of entry)
###############################################################################################################################
	li $v0, 4											# print the message
	la $a0, showentry								
	syscall

	move $a0, $s4										# print the number
	li $v0, 1
	syscall

	li $a0, 0x0000002E									# print the dot
	li $v0, 11
	syscall 
	li $a0, 0x00000020									# then a space
	li $v0, 11
	syscall
	addi $t0, $s3, -60									# move back 60 bytes to the beginning of entry
	move $a0, $t0										# print name
	li $v0, 4
	syscall
	li $a0, 0x00000020									# print space
	li $v0, 11
	syscall
	addi $t0, $t0, 20									# move pointer to last name segment
	move $a0, $t0										# print last name
	li $v0, 4							
	syscall
	li $a0, 0x00000020									# one more space
	li $v0, 11
	syscall
	addi $t0, $t0, 20									# move another 20 bytes to phone entry
	move $a0, $t0										# print phone 
	li $v0, 4
	syscall
	jr $ra												# return

Print_Entry:
###############################################################################################################################
# 	procedure that prints requested entry (using position in list)
#	wont print anything if position requested is higher than current
#	also checks that given entry is between 1,10
#	t0 = top of list
#	t1 = given entry numbers
#	t8 = current possition
#	t9 = hardcoded 60 (step)
###############################################################################################################################
	li $t9, 60											# hardcode 60 into t9
	move $t0, $s1										# initialize registers
	move $t8, $s4
	addi $t8, $t8, -1

	la $a0, askentry									# prompt user to enter entry number
	li $v0, 4
	syscall

	la $v0, 5
	syscall

	move $t1, $v0										
	bgt $t1, $t8, oob									# check if given number is higher than current position
	bgt $t1, 0x0000000A, oob							# check if given number is outside of possible range
	blt $t1, 0x00000001, oob

	addi $t1, $t1, -1									# lists start at 0!
	mult $t1,$t9 										# this many bytes above struct pointer
	mflo $t9
	add $t0, $t0, $t9									# add em to it

	li $v0, 1											# print number
	addi $t1, $t1, 1									# you know how this goes... 
	move $a0, $t1
	syscall
	li $a0, 0x0000002E
	li $v0, 11
	syscall
	li $a0, 0x00000020
	li $v0, 11
	syscall
	li $v0, 4
	la $a0, 0($t0)
	syscall
	li $a0, 0x00000020
	li $v0, 11
	syscall
	addi $t0, $t0, 20
	li $v0, 4
	la $a0, 0($t0)
	syscall
	li $a0, 0x00000020
	li $v0, 11
	syscall
	addi $t0, $t0, 20
	li $v0, 4
	la $a0, 0($t0)
	syscall
	j main

	oob:												# print error saying no such entry is found and jump main
		li $v0, 4										
		la $a0, noentry
		syscall
		j main
	
Prompt_User:
###############################################################################################################################
#	char Prompt_User(*message)
#	prompts a user for their choice
#	returns a character in v0
###############################################################################################################################
    li $v0, 4
    syscall

    li $v0, 12
    syscall
 	jr $ra

Exit:
###############################################################################################################################
#	display  exit message then terminate
###############################################################################################################################
	la $a0, exitmessage
	li $v0, 4
	syscall

	li $v0, 10
	syscall

#clear:
###############################################################################################################################
#	reset current pointer to the top 
# 	also reset positional register
#	display a cleared message 
#	jump main
###############################################################################################################################
#	move $s3, $s1
#	li $s4, 1

#	la $a0, cleared
#	li $v0, 4
#	syscall
#	j main
main:
###############################################################################################################################
#	calls prompt_user with arg and gets his choice
# 	case insensitive
###############################################################################################################################
	bne $s5, 0xffffffff,init							# we init only once
    la $a0, promptOP
 	jal Prompt_User
    move $s0, $v0
 	beq $s0, 0x00000045, Get_Entry						# new Entry (E)?
    beq $s0, 0x00000049, Print_Entry					# inquiry (I)?
	beq $s0, 0x00000051, Exit							# exit (Q)?
    beq $s0, 0x00000065, Get_Entry						# new Entry (e)?
 	beq $s0, 0x00000069, Print_Entry					# inquiry (i)?
	beq $s0, 0x00000071, Exit							# exit (q)?
	#beq $s0, 0x00000043, clear							# clear (C)?
	#beq $s0, 0x00000063, clear							# clear (c)?
	beq $s0, 0x00000043, init							# clear (C)?
	beq $s0, 0x00000063, init							# clear (c)?
	j main