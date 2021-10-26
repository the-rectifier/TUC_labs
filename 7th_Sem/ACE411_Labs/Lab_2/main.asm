/*	
 *	ACE411 - Embedded Systems
 *	Prof: Apostolos Dollas
 *	LAB2: 7-Segment Decoder & 8 digits Multiplexer
 *	Author: Odysseas Stavrou (ostavrou@isc.tuc.gr)
 */

; define ring counter (One-hot), depicts active display (active HIGH)
.def ring=r20
; define digit counter, holds current digit (1st, 2nd, etc)
.def digit=r21

; Note: Be mindful when using .def directive. It requires compatible assembler (AVRASM2)

; data starts here
.dseg
; allocate 8 bytes for our data and 10 bytes, one for each digit's mask
.org 0x200
	data: .byte 8
.org 0x250
	segments: .byte 10

; code starts here
.cseg
.org 0x00
	rjmp init
.org 0x12
	rjmp ISR_TIM0_OVF

/*	
 *	inits the 2 registers ring (r20), and digit (r21)
 *	inits the stack
 *	sets output direction of PORTA/PORTC
 *	calls 3 subroutines to init data, decoder masks, and timer
 */
init:
	; init ring, and digit registers
	ldi ring, 0x01
	ldi digit, 0x01

	; init stack
 	ldi r16, high(ramend)			
	out sph, r16					
	ldi r16, low(ramend)
	out spl, r16
	
	; set direction of porta/portc
	ldi r16, 0xff
	out DDRA, r16
	out DDRC, r16
	clr r16

	call init_data
	call init_segments
	call init_timer
									
	rjmp main


/*	
 *	Inits the timer so that it overflow approximately every 4ms 
 *	for a period of approximately 250Hz
 */
init_timer:
	; init the timer with a value of 99
	ldi r16, 99
	out TCNT0, r16

	; enable TIM0_OVF interrupt
	ldi r16, (1<<TOIE0)
	out TIMSK, r16
		
	; use prescaler of (4) clk/256
	ldi r16, (1<<CS02)
	out TCCR0, r16

	; enable global interrupts
	sei

	ret

/*
 *	Loads the proper values for a CA (Common Anode) 7-Segment Display
 *	---A---
 *	|     |
 *	F     B
 *	|     |
 *	---G---    
 *	|     |
 *	E     C
 *	|     |
 *	---D---
 * -------------------
 * 
 * IE:
 *	---A---
 *	      |
 *	      B
 *	      |
 *	---G---
 *	|     
 *	E     
 *	|     
 *	---D---
 * 
 *	For displaying the number 2 we need segments A,B,G,E,D pulled to ground
 *	Dp G F E | D C B A
 *   1 0 1 0 | 0 1 0 0 => 0xA4
 *	Init the Y register with the address of the segments label and store (w/ post increment) the decoder mask
 */
init_segments:
	; load the y register with the address of the `segments` label
	ldi yH, high(segments)
	ldi yL, low(segments)

	; display digit 0
	ldi r16, 0xC0
	st y+, r16
	; display digit 1
	ldi r16, 0xF9
	st y+, r16
	; display digit 2
	ldi r16, 0xA4
	st y+, r16
	; display digit 3
	ldi r16, 0xB0
	st y+, r16
	; display digit 4
	ldi r16, 0x99
	st y+, r16
	; display digit 5
	ldi r16, 0x92
	st y+, r16
	; display digit 6
	ldi r16, 0x82
	st y+, r16
	; display digit 7
	ldi r16, 0xF8
	st y+, r16
	; display digit 8
	ldi r16, 0x80
	st y+, r16
	; display digit 9
	ldi r16, 0x90
	st y+, r16

	ret

/* 
 *	Store the number we want, printed (in BCD form)
 *	Any 8-digit number stored in this memory address will be displayed
 */
init_data:
	ldi yH, high(data)
	ldi yL, low(data)

	; store bytes in reverse order, number to show 13371337
	; load BCD number in r16
	; store the contents of r16 into the address that y register points at
	ldi r16, 0x07		
	st y+, r16
	ldi r16, 0x03
	st y+, r16
	ldi r16, 0x03
	st y+, r16
	ldi r16, 0x01
	st y+, r16
	ldi r16, 0x07
	st y+, r16
	ldi r16, 0x03
	st y+, r16
	ldi r16, 0x03
	st y+, r16
	ldi r16, 0x01
	st y+, r16

	ret

/*
 *	Displays one digit in PORTA
 *	Called in each ISR for the specific digit
 *  Loads the number's address and offsets by the current digit place
 *	Then loads the decoders' address and offsets by the current digit
 *	Writes output to PORTA
 */
display_digit:
	; load our number's address
	ldi xH, high(data)
	ldi xL, low(data)

	; add digit position and subtract 1
	add xL, digit
	dec xL

	; dereference pointer and get digit 
	ld r0, x

	; load masks' address
	ldi xH, high(segments)
	ldi xL, low(segments)

	; offset by digit 
	add xL, r0
	; dereference and write to porta
	ld r0, x
	out PORTA, r0

	ret

/*
 * Main loop 
 * while(1) {}
 * does nothing
 */
main:
	rjmp main

/* 
 *	Interrupt Service Routine
 *	Called every 4ms to display the next digit
 *	30 blinks per second x 8 displays = 240 blinks per second
 *	At 30 blinks per second (or more), our eyes wont tell the difference
 *	Multiplex each display after the other at 250Hz
 *	Reset ring, and digit registers when the ring register shifts out a carry
 */
ISR_TIM0_OVF:						
	; enable display
	out PORTC, ring	
	; write digit to that display				
	call display_digit

	; re-init timer
	ldi r16, 99
	out TCNT0, r16

	; increase digit and shift left the ring counter
	inc digit
	; clear carry flag
	clc
	lsl ring

	; if last shift shifted out a carry reset registers
	brcs reset

	reti		
	
	; reset registers
	reset:
		ldi ring, 0x01
		ldi digit, 0x01

		reti					
