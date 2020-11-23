#include <xc.inc>

global  LCD_Setup

psect	udata_acs   ; named variables in access ram
LCD_cnt_l:	ds 1   ; reserve 1 byte for variable LCD_cnt_l
LCD_cnt_h:	ds 1   ; reserve 1 byte for variable LCD_cnt_h
LCD_counter:	ds 1   ; reserve 1 byte for counting through nessage
LCD_data equ 0x10	; reserve for LCD data
LCD_cmd equ 0x11	;reserve for LCD commands
	LCD_RST EQU 5	;reset bit
	LCD_E	EQU 4	; LCD enable bit
    	LCD_RS	EQU 2	; LCD register select bit
	LCD_RW	EQU 3	; LCD read/write select bit
	LCD_CS1 EQU 0	; left column select
	LCD_CS2 EQU 1	; right column select


psect	lcd_code,class=CODE


LCD_Setup:
	clrf    LATB, A	    ; RB0:5 all outputs (instruction 
	clrf	TRISB, A
	clrf	LATD,A
	clrf	TRISD,A		    ; portD all outputs (dataline
	bcf	PORTB,LCD_RST
	;movlw	10		; wait 40us
	;call	LCD_delay_x4us
	bsf	PORTB,LCD_RST	    ;relase from reset.
	movlw	00111110B
	movwf	LCD_cmd
	call	LCD_write_cmd	    ;display off
	;movlw	10		; wait 40us
	;call	LCD_delay_x4us
	movlw	00111111B
	movwf	LCD_cmd
	call	LCD_write_cmd	    ;display on
	movlw	11000000B
	movwf	LCD_cmd
	call	LCD_write_cmd	    ;start at line 0
	;call	LCD_Clear_all
	;movlw	10		; wait 40us
	;call	LCD_delay_x4us
	call	LCD_clear
	call	LCD_Block1
	return

LCD_write_cmd:			; Transmits byte stored in W to instruction reg
	movf	LCD_cmd,W,A
	movwf   PORTD, A		;PORTD now contains the bit configuration for different instructions. ; output data bits to LCD
	bcf	PORTB, LCD_RW,A		;data write, RW = 0
	bcf	PORTB, LCD_RS, A	; setting write cmd, RS = 0
	;call	LCD_delay1
	call    LCD_Enable		; Pulse enable Bit 
	return

LCD_write_data:			; Transmits byte stored in W to data reg(PORTD ,then to the LCD
	movf	LCD_data,W,A
	movwf   PORTD, A		; output data bits to LCD
	bcf	PORTB, LCD_RW,A		;data write, RW = 0
	bsf	PORTB, LCD_RS, A	; Data write set RS = 1
	;call	LCD_delay1
	call    LCD_Enable		; Pulse enable Bit 
	return
LCD_write_1:
	movlw	11111110B
	movwf	LCD_data
	return

LCD_clear:
	movlw	00000000B
	movwf	LCD_data
	return
LCD_Block1:
	bsf	PORTB, LCD_CS1,A    ;select column 0
	bcf	PORTB, LCD_CS2,A    ;not select column 1
	call	LCD_Enable
	movlw	10111000B	    ;select page0 in column 0
	movwf	LCD_cmd
	call	LCD_write_cmd	    ;send instruction to LCD
	movlw	01000000B	    ;start from cursor position 0
	movwf	LCD_cmd
	call	LCD_write_cmd
	movlw	0x20		    ;want to write in 0-31 cursor positions, 0x20 = 32
	movwf	LCD_counter,A
    loop1:			    ;writes data 32 times ,should fill up 1/4 of an entire line.
	call	LCD_write_data
	decfsz	LCD_counter,A
	bra	loop1
	return	

LCD_Enable:	    ; pulse enable bit LCD_E for 500ns
	bcf	PORTB, LCD_E, A	    ;put enable low
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	bsf	PORTB, LCD_E, A	    ; Take enable high
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	bcf	PORTB, LCD_E, A	    ; Writes data to LCD
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	return

; ** a few delay routines below here as LCD timing can be quite critical ****

LCD_delay_x4us:		    ; delay given in chunks of 4 microsecond in W
	movwf	LCD_cnt_l, A	; now need to multiply by 16
	swapf   LCD_cnt_l, F, A	; swap nibbles
	movlw	0x0f	    
	andwf	LCD_cnt_l, W, A ; move low nibble to W
	movwf	LCD_cnt_h, A	; then to LCD_cnt_h
	movlw	0xf0	    
	andwf	LCD_cnt_l, F, A ; keep high nibble in LCD_cnt_l
	call	LCD_delay
	return

LCD_delay:			; delay routine	4 instruction loop == 250ns	    
	movlw 	0x00		; W=0
lcdlp1:	decf 	LCD_cnt_l, F, A	; no carry when 0x00 -> 0xff
	subwfb 	LCD_cnt_h, F, A	; no carry when 0x00 -> 0xff
	bc 	lcdlp1		; carry, then loop again
	return			; carry reset so return

LCD_delay1:
    nop
    nop
    nop
    nop
    nop
    return

    end


