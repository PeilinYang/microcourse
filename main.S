#include <xc.inc>

; external subroutines
extrn	LCD_Setup

psect	data    
	; ******* myTable, data in programme memory, and its length *****
    
psect	code, abs	
rst: 	org 0x0
 	goto	setup

	; ******* Programme FLASH read Setup Code ***********************
setup:	
	call	LCD_Setup	; setup LCD
	goto	start
	
	; ******* Main programme ****************************************
start: ;movlw	0x00
	;movwf	TRISJ,A
	;movlw	00000000B
	;movwf	PORTJ,A
	;call	LCD_Clear_Block
	goto	$		; goto current line in code


	end	rst