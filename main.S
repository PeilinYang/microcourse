#include <xc.inc>

; external subroutines
extrn	LCD_Setup, LCD_Write_Block, LCD_Clear_Block
	
psect	udata_acs   ; reserve data space in access ram
counter:    ds 1    ; reserve one byte for a counter variable
delay_count:ds 1    ; reserve one byte for counter in the delay routine
    
psect	udata_bank4 ; reserve data anywhere in RAM (here at 0x400)
myArray:    ds 0x80 ; reserve 128 bytes for message data

psect	data    
	; ******* myTable, data in programme memory, and its length *****
myTable:
	db	'O',0x0a
					; message, plus carriage return
	myTable_l   EQU	1	; length of data
	align	2
    
psect	code, abs	
rst: 	org 0x0
 	goto	setup

	; ******* Programme FLASH read Setup Code ***********************
setup:	bcf	CFGS	; point to Flash program memory  
	bsf	EEPGD 	; access Flash program memory
	call	LCD_Setup	; setup LCD
	goto	start
	
	; ******* Main programme ****************************************
start: movlw	0x00
	movwf	TRISJ,A
	movlw	00000000B
	movwf	PORTJ,A
	call	LCD_Clear_Block
	goto	$		; goto current line in code

	; a delay subroutine if you need one, times around loop in delay_count
delay:	decfsz	delay_count, A	; decrement until zero
	bra	delay
	return

	end	rst