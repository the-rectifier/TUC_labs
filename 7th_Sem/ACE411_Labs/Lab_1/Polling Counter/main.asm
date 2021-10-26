/*	
 *	ACE411 - Embedded Systems
 *	Prof: Apostolos Dollas
 *	LAB1: Simple Timer w/ Polling
 *	Author: Odysseas Stavrou (ostavrou@isc.tuc.gr)
 */

								; .def directive requires a compatible assembler 
 .def i=r16						; define i as r16	
 .def j=r17						; define j as r17
 .def gpr0=r18					; define gpr0 (general purpose register 0)
 .def gpr1=r19					; define gpr1 (general purpose register 1)


 /*
  * Program will start here
  * sets direction of PB0 as output
  * jumps to main loop
  */

 start:
	ldi gpr0, (1<<PB0)
	out DDRB, gpr0
	rjmp main


/*
 *	Main program 
 *	will jump to the outer loop and toggle output every 200,009 cycles
 *	pseudo code:
 * 
 *	while(1) {
 *		for(i=0;i<66;i++) {
 *			for(j=0;j<66;j++) {
 *				nop
 *				nop
 *				mulsu(gpr0, gpr1);
 *				mulsu(gpr0, gpr1);
 *				mulsu(gpr0, gpr1);
 *			}
 *		}
 *		toggle();
 *	}
 */		
main:
	rjmp outer_loop
	

/*
 *	Outer Loop:
 *		- Loops for 66 times
 *		- Takes 6 cycles for one loop + 3071 (for nested)
 *		- Last loop is 4 cycles
 *		- Total cycles: 65 * (3071 + 6) + 4 = 200,009
 */
outer_loop:
	clr j						
	cpi i, 65					
	breq toggle					
	inc i						
	rjmp inner_loop				


/*
 *	Inner Loop:
 *		- Loops for 237 times
 *		- Takes 13 cycles for one loop
 *		- Last loop is 3 cycles
 *		- Total cycles: 3071
 */
inner_loop:
	cpi j, 236				
	breq outer_loop			; 1 cycle, 2 if taken
	inc j					
	nop						
	nop						
	mulsu gpr0, gpr1		; 2 cycles
	mulsu gpr0, gpr1		
	mulsu gpr0, gpr1		
	rjmp inner_loop			; 2 cycles



/*
 * Clears registers used for the loops
 * Toggles PORTB
 */
toggle:
	clr i
	clr j
	ldi gpr0, 0xff
	in gpr1, PORTB
	eor gpr1, gpr0
	out PORTB, gpr1
	rjmp main

	
