/*	
 *	ACE411 - Embedded Systems
 *	Prof: Apostolos Dollas
 *	LAB1: Simple Timer w/ Interrupts
 *	Author: Odysseas Stavrou (ostavrou@isc.tuc.gr)
 */

									; the directive .def requires a compatible assembler avrasm
.def gpr0=r16						; define gpr0 (general purpose register 0 as r16)
.def gpr1=r17						; define gpr1 (general purpose register 1 as r17)
	
.org 0x0000							; code starts here
	rjmp init						

.org 0x0012							; Timer0 Overflow Interrupt vector
	rjmp ISR_TIM0_OVF				; Timer0 Overflow interrupt handler

/*	
 *	Init routine:
 *		- Initializes the stack (needed for returning from ISR)
 *		- Sets PB0 as output
 *		- Loads the TCNT0 register with a starting value
 *		- Enables Timer0 Interrupts
 *		- Sets prescaler to 1024
 *		- Enables global interrupts
 */
init:
 	ldi gpr0, high(ramend)			
	out sph, gpr0					
	ldi gpr0, low(ramend)
	out spl, gpr0
	
	ldi gpr0, (1<<PB0)				; set PB0 as output
	out DDRB, gpr0					
	
	ldi gpr0, 60						
	out TCNT0, gpr0

	ldi gpr0, (1<<TOIE0)			
	out TIMSK, gpr0					; set TOIE0 bit in TIMSK

	ldi gpr0, (1<<CS00)	| (1<<CS02)	
	out TCCR0, gpr0					; set CS00, CS02 bits in TCCR0 prescaler 1024

	sei								; enable global interrupts	


/*
 *	Main routine
 *	while(1) {}
 */
main:
	jmp main						


/*
 *	ISR for Timer0 Overflow Interrupt
 *	Saves the current SREG and toggles PB0
 *	Reinitializes the TCNT0 register
 *	Restores the SREG 
 *	Re-enables global interrupts and returns
 */
ISR_TIM0_OVF:						; Interrupt Service Routine
	in gpr1, SREG					; save Status Register
	ldi gpr0, 0xff	       			; load 0xff into gpr
	in	r17, PORTB					
	eor r17, gpr0					; toggle output
	out PORTB, r17					
	ldi gpr0, 60					
	out TCNT0, gpr0
	out SREG, gpr1					; restore SREG
	reti							; re-enable global interrupts and return from interrupt
	


