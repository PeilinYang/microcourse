	#include <pic18_chip_select.inc>
	#include <xc.inc>
	
psect	code, abs
main:
	org 0x0
	goto	setup
	
	org 0x100		    ; Main code starts here at address 0x10
	
	; setting ports 
setup:	
	movlw	0xf0		    ;setting portD to 11110000, bits 0-3 is ued for control lines
	movwf	TRISD,A
	movlw	0x0f
	movwf	PORTD,A		    ;setting cp1 and cp2 ,oe1,2 to high voltage
	setf	TRISE		    ;setting portE pull ups.
	banksel	PADCFG1
	bsf	RDPU
	movlb	0x00
	bcf	CFGS		    ; point to Flash program memory  
	bsf	EEPGD		    ; access Flash program memory
	goto	start
	
write1:movlw	0x0f		    ;making sure oe1,2 are high
	movwf	PORTD,A
	clrf	TRISE,A		    ;setting portE to outputs
	movf	PORTC,W,A	    ;placing data on PORTE
	movwf	PORTE,A
	movlw	0x07		    ;pulling cp1 to low
	movwf	PORTD,A
	movlw	0x0f		    ;pulling cp1 high to write to chip1
	movwf	PORTD,A
	return
	
write2:movlw	0x0f		    ;making sure oe1,2 are high
	movwf	PORTD,A
	clrf	TRISE,A		    ;setting portE to outputs
	movf	PORTC,W,A	    ;placing data on PORTE
	movwf	PORTE,A
	movlw	0x0b		    ;pulling cp2 to low
	movwf	PORTD,A
	movlw	0x0f		    ;pulling cp2 high to write to chip2
	movwf	PORTD,A
	return
	
read1: movlw	0x0f		    ;making sure oe1,2 are high
	movwf	PORTD,A
	clrf	PORTE,A
	movlw	0xff		    ;setting portE to input
	movwf	TRISE,A
	movlw	0x0d		    ;pulling oe1 low to read data from chip 1.
	movwf	PORTD,A
	return
	
read2: movlw	0x0f		    ;making sure oe1,2 are high
	movwf	PORTD,A
	clrf	PORTE,A
	movlw	0xff		    ;setting portE to input
	movwf	TRISE,A
	movlw	0x0e		    ;pulling oe2 low to read data from chip 1.
	movwf	PORTD,A
	return
	
delay: decfsz	0x20, 1
	bra delay
	decfsz	0x22,1
	bra delay
	decfsz	0x24, 1
	bra delay
	return
	; ******* Main programme *********************
start:	
	movlw	0xff		;setting portC to inputs
	movwf	TRISC,A
	call	write1
	clrf	PORTE,A
	call	read1
	call	write2
	clrf	PORTE,A
	call	read2
	
	end	main
loop:
	movf	PORTD, W, A	    ; moving input value into W
	cpfsgt	0x06		    ;if any button is pressed, then program is paused.
	bra	loop
	;moving PORTD to the counters, so speed can be changed using buttons		;movlw	0x10
	movwf	0x20, A		;counter1
	movwf	0x22, A		;counter2
	movwf	0x24, A		;counter3
	call	delay
        tblrd*+			; move one byte from PM to TABLAT, increment TBLPRT
	movff	TABLAT, POSTINC0	; move read data from TABLAT to (FSR0), increment FSR0	
	movf	TABLAT, W, A
	clrf	PORTC, A
	movwf	PORTC, A
	decfsz	counter, A	; count down to zero
	bra	loop		; keep going until finished
	
	goto	0

	

