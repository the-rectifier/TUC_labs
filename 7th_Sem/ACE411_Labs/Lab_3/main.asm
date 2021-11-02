/*	
 *	ACE411 - Embedded Systems
 *	Prof: Apostolos Dollas
 *	LAB3: 7-Segment Decoder & 8 digits Multiplexer w/ UART Input 
 *	Author: Odysseas Stavrou (ostavrou@isc.tuc.gr)
 */

.equ bps = (10000000/16/9600) - 1
; define digit counter, holds current digit (1st, 2nd, etc)
.def digit=r20

; Note: Be mindful when using .def directive. It requires compatible assembler (AVRASM2)

; data starts here
.dseg
; allocate 8 bytes for our data and 10 bytes, one for each digit's mask
.org 0x200
	data: .byte 8

; code starts here
.cseg
.org 0x00
	rjmp init
.org 0x12
	rjmp ISR_TIM0_OVF
.org 0x16
    rjmp USART_RXC


/* OK<CR><LF> string to be written in the USART port when a <LF> is recieved */
ok:         .db 0x4f, 0x4b, 0x0d, 0x0a            
/* Decoder's Byte Values for diplaying Digits (padded to 3 words size) */
decoder:    .db 0xc0, 0xf9, 0xf4, 0xb0, 0x99, 0x92, 0x82, 0xf8, 0x80, 0x90, 0xff, 0x00


init:
/* 
 *	Initialization Routine
 *	Inits stack
 *	Inits ring counter
 *	Sets output Direction for PORTA, PORTC
 *	Calls:
 *		- init_usart
 *		- clr_data
 *		- init_timer
 *		- display_digit
 *	routines
 *	Enables Global Interrupts
 *	Jumps to main program loop
 */

    ; init ring, and digit registers
	ldi digit, 0x01
	out PORTC, digit

	; init stack
 	ldi r16, high(ramend)			
	out sph, r16					
	ldi r16, low(ramend)
	out spl, r16
	
	; set direction of porta/portc
	ldi r16, 0xff
	out DDRA, r16
	out DDRC, r16
	; clr r16

	; init usart
    call init_usart
	; clear data
	call clr_data
	; init timer
	call init_timer
	; display the first digit
    call display_digit
	
	;enable global interrupts
	sei

	; jump to main
	rjmp main
        

init_usart:
/*
 *	Initialize USART PORT
 *	Baudrate is 9600 bps
 *	Enable Receive, Transmit
 *	Enable Rx Complete Interrupt
 */

	; load bps to create 9600 baud rate
	ldi r16, low(bps)
	ldi r17, high(bps)

	out UBRRL, r16
	out UBRRH, r17

	; enable Receiving, Transmiting and Interrupt on Complete Transfer
    ldi r16, (1<<RXEN) | (1<<TXEN) | (1<<RXCIE)
    out UCSRB, r16

	ret


reply:
/*	
 *	Write on an empty UDR to transmit OK<CR><LF>
 *	Call puts subroutine repeatedly until the reply string is written
 */
    clr r22
	; load Reply's Address
    ldi zH, high(ok<<1)

	; call putc subroutine to write the byte pointed by Z register (increment Z pointer)
    loop:
		ldi zL, low(ok<<1)
        add zL, r22
        lpm r19, z
        call putc
        inc r22
        cpi r22, 4
        brne loop
    ret

putc:
/* 
 *	Block until the UDR is empty 
 *	When Empty write 1 byte to UDR
 */
	in r18, UCSRA
    sbrs r18, UDRE
    rjmp putc

    ; out UDR, r19
    out TCNT2, r19
    ret


display_digit:
/*
 *	Display a single digit in one 7-Seg Display
 *	Offset by ring counter and write the proper Decoder value on PORTA
 */

	; load our number's address
	ldi yH, high(data)
	ldi yL, low(data)

	; add digit position and subtract 1
	add yL, digit
	dec yL

	; dereference pointer and get digit 
	ld r0, y

	; load masks' address
	ldi zH, high(decoder)
	ldi zL, low(decoder)

	; offset by digit 

	add zL, r0
	; dereference and write to porta
	lpm r16, z
	out PORTA, r16

	ret


clr_data:
/* 
 *	Loop through each byte of the data array and set them all on 0x0a
 *	Decoding 0x0a will end up with all segments off (0xff)
 */

    ldi xH, high(data+8)
	ldi xL, low(data+8)

	; turn off all digits
	ldi r16, 0x0a		
	st -x, r16
	ldi r16, 0x0a
	st -x, r16
	ldi r16, 0x0a
	st -x, r16
	ldi r16, 0x0a
	st -x, r16
	ldi r16, 0x0a
	st -x, r16
	ldi r16, 0x0a
	st -x, r16
	ldi r16, 0x0a
	st -x, r16
	ldi r16, 0x0a
	st -x, r16

	ret

init_timer:
/* 
 *	Initialize timer with a frequency of 250 Hz
 *	prescaler of clk/256 
 *	and an initial TCNT0 value of 99
 */

	; init the timer with a value of 99
	ldi r16, 99
	out TCNT0, r16

	; enable TIM0_OVF interrupt
	ldi r16, (1<<TOIE0)
	out TIMSK, r16
		
	; use prescaler of (4) clk/256
	ldi r16, (1<<CS02)
	out TCCR0, r16

	ret


; main program while(1) {}
main:
	rjmp main


parse_input:
/*
 *	Parse the Recieved Byte and act accordingly
 *	Consume RCX flag
 *	Ignore <CR>, 'A', 'T' characters
 *	Clear display on 'C', and 'N' characters
 *	Reply with 'OK<CR><LF>' on <LF> character
 *	Anything else is considered a number (assuming an always correct input)
 *	Shift data 1 place right and store byte on data (0x0200)
 */

	; flush UDR register and consume RCX flag
	in r0, UDR
	in r0, UDR
	mov r16, r1


	check_input:
	; check and ignore <CR>, 'A', 'T' characters
	; if such, just return from interrupt
	cpi r16, 0x0D
	breq return_uart
	cpi r16, 0x41
	breq return_uart
	cpi r16, 0x54
	breq return_uart

	check_number:
	; if 'N', clear display (call to clr_data routine) to accomodate for the new numbers
	; reply will be handled when <LF> will arrive
	; and return from interrupt
	cpi r16, 0x4E
	brne check_newline
	call clr_data
	rjmp return_uart

	check_newline:
	; if <LF> reply with OK (call to reply routine)
	; and return from interrupt
	cpi r16, 0x0A
	brne check_clear
	call reply
	rjmp return_uart

	check_clear:
	; if 'C', clear display (call to clr_data routine)
	; reply will be handled when <LF> will arrive
	; and return from interrupt
	cpi r16, 0x43
	brne do_number
	call clr_data
	rjmp return_uart

	
	do_number:
	; Assuming the input is always correct
	; Arriving here means we have a number
	; AND with 0x0F mask to convert to number
	; Shift everything to the right by 1
	; Store number

	andi r16, 0x0F
	ldi xH, high(data+6)
	ldi r19, 0x06
	shift:
	; load address of 2nd to last byte
	ldi xL, low(data)
	add xL, r19
	; save byte
	ld r0, x
	; inc xL pointer so it points to last byte
	mov r18, xL
	inc r18
	mov xL, r18
	; store 2nd to last byte
	st x, r0
	; decreace offset
	dec r19
	cpi r19, -1
	brne shift
	
	; when shift ends, store recieved byte
	ldi xL, low(data)
	st x, r16
	
	rjmp return_uart


USART_RXC:
/*	
 *	USART Recieve Complete Interrupt Handler
 *	Save SREG
 *	Jump to parse Input subroutine
 *	Restore SREG
 *	Return from interrupt
 */
	; save SREG
	in r16, SREG
	push r16

	rjmp parse_input

	; restore SREG and return
return_uart:
	pop r16
	out SREG, r16
    reti

ISR_TIM0_OVF:
/*
 *	Timer0 Overflow Interrupt Handler
 *	Saves/Restores SREG
 *	Re-inits Timer
 *	Displays Next digit (left shift PORTC)
 *	If PORTC shifts out a carry, reset PORTC and Ring Counter
 *	Increments Ring counter
 */

	; save SREG
	in r16, SREG
	push r16

    ; re-init timer
	ldi r16, 99
	out TCNT0, r16

	; load PORTC 
    in r16, PORTC
	; shift left by 1
    lsl r16
	; if carry shifted out reset and return
    brcs reset
	; write new PORTC
    out PORTC, r16

    ; increase digit
	inc digit

    call display_digit

	; pop SREG and return
	return:
		pop r16
		out SREG, r16 
		reti

    reset:
        ldi digit, 0x1
        ldi r16, 0x1
        out PORTC, r16
        call display_digit

		rjmp return

	

