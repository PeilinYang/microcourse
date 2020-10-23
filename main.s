	#include <pic18_chip_select.inc>
	#include <xc.inc>
	
psect	code, abs
main:
	org 0x0
	goto	setup
	
	org 0x100		    ; Main code starts here at address 0x10
	
	; ******* Programme FLASH read Setup Code ****  
setup:	
	bcf	CFGS	; point to Flash program memory  
	bsf	EEPGD 	; access Flash program memory
	goto	start
	; ******* My data and where to put it in RAM *
myTable:
	db	'1','a','3','b','5','c','7','8','9'
	db	'1'
	myArray EQU 0x400	; Address in RAM for data
	counter EQU 0x10	; Address of counter variable
 delay: decfsz	0x20, 1
	bra delay
	decfsz	0x22,1
	bra delay
	decfsz	0x24, 1
	bra delay
	return
	; ******* Main programme *********************
start:	
	movlw  0xff		    ;Implementing program to pause/unpause the LED Flashes
	movwf  TRISD,A             ; Set PORTD to inputs
	movlw	0x80
	movwf	0x06,A
	movlw	0x0
	movwf	TRISC, A
	lfsr	0, myArray	; Load FSR0 with address in RAM	
	movlw	low highword(myTable)	; address of data in PM
	movwf	TBLPTRU, A	; load upper bits to TBLPTRU
	movlw	high(myTable)	; address of data in PM
	movwf	TBLPTRH, A	; load high byte to TBLPTRH
	movlw	low(myTable)	; address of data in PM
	movwf	TBLPTRL, A	; load low byte to TBLPTRL
	movlw	10		; 22 bytes to read
	movwf 	counter, A	; our counter register
loop:
	movf	PORTD, W, A	    ; moving input value into W
	cpfsgt	0x06		    ;if any button is pressed, then program is paused.
	bra	loop
	;moving PORTD to the counters, so speed can be changed using buttons		;movlw	0x10
	movwf	0x20, A
	movwf	0x22, A
	movwf	0x24, A
	call	delay
        tblrd*+			; move one byte from PM to TABLAT, increment TBLPRT
	movff	TABLAT, POSTINC0	; move read data from TABLAT to (FSR0), increment FSR0	
	movf	TABLAT, W, A
	clrf	PORTC, A
	movwf	PORTC, A
	decfsz	counter, A	; count down to zero
	bra	loop		; keep going until finished
	
	goto	0

	end	main

