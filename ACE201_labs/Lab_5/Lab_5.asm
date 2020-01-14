.data
    input: .space 4
    out: .asciiz "\nThe Fibonacci number FAA is " # 23, 24
    prompt: .asciiz "\nPlease enter a number in the range 0-24, or Q to quit: \n"
    range_err: .asciiz "\nThis number is outside the allowable range\n"
    .align 2
.text
.globl main
j main
str_to_int:
################################################################################################
#   function int str_to_int(* word)
#   takes a pointer into a word that contains either ab\n\0 or a\n\0\0 or abc\0 (a,b ascii integers 1-9, c is any char)
#   also edits the apropriate string after checking if the number is in a proper range
#   returns only the integer consisting of a*10+b in $v0
#   $t0 is a
#   $t1 is b
#   $t2 is the 3rd character, whatever it is if not a LF then range error
#   $t8 is hardcoded to 0x30
#   $t9 is hardcoded to 10
################################################################################################
    li $t9, 10
    li $t8, 0x00000030
    lb $t0, input                                       # grab decades
    lb $t1, input+1                                     # grab units 
    lb $t2, input+2
    bgt $t2, 0x00000019, range_fault                    # if the 3rd digit is something else
    bne $t1, 0x0000000A, cont                           # if units is LF then decades is the true unit
    bgt $t0, 0x00000039, range_fault                    # is this even a number?
    blt $t0, 0x00000030, range_fault
    sb $t8, out+23                                      # if singe digit add 0
    sb $t0, out+24                                      # add the number
    addi $t0, $t0, -48                                  # convert to integer
    move $v0, $t0                                       # return
    jr $ra
    cont:
        #bgt $t0, 0x00000032, range_fault                # is this even a number?
        #blt $t0, 0x00000030, range_fault
        #bgt $t1, 0x00000039, range_fault                # is this even a number?
        #blt $t1, 0x00000030, range_fault
        sb $t0, out+23                                  # edit the output
        sb $t1, out+24            
        addi $t0, $t0, -48                              # make them both integers
        addi $t1, $t1, -48
        move $v0, $t1                                   # save the units
        mult $t0, $t9                                   # multply by 10
        mflo $t0                                        # get the decades
        add $v0, $v0, $t0                               # add 'em
        bgt $v0, 24, range_fault
        jr $ra                                          # return
    range_fault:
        li $v0, 4
        la $a0, range_err                               # print range error and return to main
        syscall
        j main 

fibo:
############################################################################################################
#   Each stack frame is looks like that, on the first recursion the prev sum is "n" and each time is reduced by 1
#   After reaching f(1) = 1 it writes on current sum 1 and on prev sum 0 and returns
#   If f(0) = 0 it writes on current sum 0 and on prev sum 0 and returns
#   After returning the 2 values are loaded into registers 
#   
#   |_curr_sum_|
#   |_prev_sum_|
#   |____ra____|
#
#   $t0 = current n and later curr_sum
#   $t1 = prev_sum
#
#   after returning from recursion the old curr_sum($t1) goes into now prev_sum
#   and their sum is the new curr_sum
#
#############################################################################################################
    lw $t0, 4($sp)                                       # load n
    
    blt $t0, 2, return_n                                 # if n < 2 return 1,0 or 0,0 in 8($sp) and 4($sp)
    addi $sp, $sp, -12                                   # 12 bytes to the stack
    addi $t0, $t0, -1                                    # n--
    sw $ra, 0($sp)                                       # save the ra
    sw $t0, 4($sp)                                       # save the new n
    
    jal fibo                                             # call it again
    lw $t0, 8($sp)                                       # load curr_sum
    lw $t1, 4($sp)                                       # load prev_sum
    lw $ra, 0($sp)                                       # load the ra
    addi $sp, $sp, 12                                    # restroy the stack
    sw $t0, 4($sp)                                       # new prev_sum = curr_sum
    add $t0, $t1, $t0                                    # curr_sum = prev_sum + previous curr_sum
    sw $t0, 8($sp)  
    jr $ra                                               # take the ra 
    return_n:
        sw $t0, 8($sp)                                   # if the n is 0 store 0 if 1 store 1
        sw $0, 4($sp)                                    # store always 0 on the 1st prev_sum
        jr $ra                                           # begin restoring 
        
main:
    li $v0, 4                                            # prompt user for input
    la $a0, prompt                                       # load the msg adress
    syscall

    li $v0, 8                                            # read a string
    la $a0, input                                        # in here
    li $a1 ,4                                            # max 3 char + \0
    syscall

    lb $t0, input                                        # load input into junky register
    beq $t0,0x0000000a, range_fault
    beq $t0, 0x0000051, quit                             # quit cap
    beq $t0, 0x0000071, quit                             # quit lower
    jal str_to_int                                       # get me dem integer
    move $s0, $v0                                        # save it into s0

    addi $sp, $sp, -12                                   # create stack frame for 1st recursive call
    sw $s0, 4($sp)                                       # we want it to be on the 2nd place
    jal fibo                                             # begin
    lw $s0, 8($sp)                                       # load the last curr_sum
    addi $sp, $sp, 12                                    # destroy the stack
    
    li $v0, 4                                            # print string
    la $a0, out                                          # this string
    syscall
    li $v0, 1                                            # print integer
    move $a0, $s0                                        # this one
    syscall 
    j main                                               # i wanna do it again
quit:
	li $v0, 10
	syscall
