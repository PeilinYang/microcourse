#include <xc.inc>

global  LCD_Setup,LCD_Write_Block,LCD_Clear_Block

psect	udata_acs   ; named variables in access ram
LCD_cnt_l:	ds 1   ; reserve 1 byte for variable LCD_cnt_l
LCD_cnt_h:	ds 1   ; reserve 1 byte for variable LCD_cnt_h
LCD_cnt_ms:	ds 1   ; reserve 1 byte for ms counter
LCD_tmp:	ds 1   ; reserve 1 byte for temporary use
LCD_counter:	ds 1   ; reserve 1 byte for counting through nessage
LCD_data:	ds 1	; reserve for LCD data
LCD_cmd:	ds 1	;reserve for LCD commands
	LCD_RST EQU 5	;reset bit
	LCD_E	EQU 4	; LCD enable bit
    	LCD_RS	EQU 2	; LCD register select bit
	LCD_RW	EQU 3	; LCD read/write select bit
	LCD_CS1 EQU 0	; left column select
	LCD_CS2 EQU 1	; right column select


psect	lcd_code,class=CODE

LCD_Write_Block:
	call    LCD_write_1
	call    LCD_find_pos
	return
	
LCD_Clear_Block:
	call	LCD_clear
	call	LCD_find_pos
	return
LCD_Clear_all:
	call	LCD_clear
	call	LCD_Block1
	call	LCD_Block2
	call	LCD_Block3
	call	LCD_Block4
	call	LCD_Block5
	call	LCD_Block6
	call	LCD_Block7
	call	LCD_Block8
	call	LCD_Block9
	call	LCD_Block10
	call	LCD_Block11
	call	LCD_Block12
	return
LCD_Setup:
	clrf    LATB, A	    ; RB0:5 all outputs (instruction 
	clrf	TRISB, A
	clrf	LATD,A
	clrf	TRISD,A		    ; portD all outputs (dataline
	bcf	PORTB,LCD_RST
	bsf	PORTB,LCD_RST	    ;relase from reset.
	movlw	00111110B
	movwf	LCD_cmd
	call	LCD_write_cmd	    ;display off
	;movlw	10		; wait 40us
	;call	LCD_delay_x4us
	movlw	00111111B
	movwf	LCD_cmd
	call	LCD_write_cmd	    ;display on
	call	LCD_Clear_all
	;movlw	10		; wait 40us
	;call	LCD_delay_x4us
	return

LCD_write_cmd:	    ; Transmits byte stored in W to instruction reg
	movf	LCD_cmd,W,A
	movwf   PORTD, A    ;PORTD now contains the bit configuration for different instructions.
	;movwf   LATD, A	    ; output data bits to LCD
	bcf	PORTB, LCD_RW,A	;data write, RW = 0
	bcf	PORTB, LCD_RS, A	; setting write cmd, RS = 0
	;call	LCD_delay
	call    LCD_Enable  ; Pulse enable Bit 
	;movlw	10	    ; delay 40us
	;call	LCD_delay_x4us
	return

LCD_write_data:	    ; Transmits byte stored in W to data reg(PORTD ,then to the LCD
	movf	LCD_data,W,A
	movwf   PORTD, A
	;movwf   LATD, A	    ; output data bits to LCD
	bcf	PORTB, LCD_RW,A	;data write, RW = 0
	bsf	PORTB, LCD_RS, A	; Data write set RS = 1
	;call	LCD_delay
	call    LCD_Enable  ; Pulse enable Bit 
	;movlw	10	    ; delay 40us
	;call	LCD_delay_x4us
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
	movlw	00111111B
	movwf	LCD_cmd
	call	LCD_write_cmd	    ;display on
	movlw	10111000B	    ;select page0 in column 0
	movwf	LCD_cmd
	call	LCD_write_cmd	    ;send instruction to LCD
	movlw	0x20		    ;want to write in 0-31 cursor positions, 0x20 = 32
	movwf	LCD_counter,A
	movf	LCD_data, W, A		    ;data to be displayed(want a solid block so all bits are 1)
    loop1:
	call	LCD_write_data
	decfsz	LCD_counter,A
	bra	loop1
	return	
	
LCD_Block2:
	bsf	PORTB, LCD_CS1,A    ;select column 0
	bcf	PORTB, LCD_CS2,A    ;not select column 1
	movlw	00111111B
	movwf	LCD_cmd
	call	LCD_write_cmd	    ;display on
	movlw	10111000B	    ;select page0 in column 0
	movwf	LCD_cmd
	call	LCD_write_cmd	    ;send instruction to LCD
	movlw	11100000B	    ;start from cursor position 32
	movwf	LCD_cmd
	call	LCD_write_cmd
	movlw	0x20		    ;want to write in 32-63 cursor positions, 0x20 = 32
	movwf	LCD_counter,A
	movf	LCD_data, W, A		    ;data to be displayed
    loop2:
	call	LCD_write_data
	decfsz	LCD_counter,A
	bra	loop2
	return	
	
LCD_Block5:
	bsf	PORTB, LCD_CS1,A    ;select column 0
	bcf	PORTB, LCD_CS2,A    ;not select column 1
	movlw	00111111B
	movwf	LCD_cmd
	call	LCD_write_cmd	    ;display on
	movlw	10111010B	    ;select page2 in column 0
	movwf	LCD_cmd
	call	LCD_write_cmd	    ;send instruction to LCD
	movlw	0x20		    ;want to write in 0-31 cursor positions, 0x20 = 32
	movwf	LCD_counter,A
	movf	LCD_data, W, A		    ;data to be displayed
    loop5:
	call	LCD_write_data
	decfsz	LCD_counter,A
	bra	loop5
	return	
	
LCD_Block9:
	bsf	PORTB, LCD_CS1,A    ;select column 0
	bcf	PORTB, LCD_CS2,A    ;not select column 1
	movlw	00111111B
	movwf	LCD_cmd
	call	LCD_write_cmd	    ;display on
	movlw	10111100B	    ;select page4 in column 0
	movwf	LCD_cmd
	call	LCD_write_cmd	    ;send instruction to LCD
	movlw	0x20		    ;want to write in 32 cursor positions, 0x20 = 32
	movwf	LCD_counter,A
	movf	LCD_data, W, A		    ;data to be displayed
    loop9:
	call	LCD_write_data
	decfsz	LCD_counter,A
	bra	loop9
	return	
	
LCD_Block6:
	bsf	PORTB, LCD_CS1,A    ;select column 0
	bcf	PORTB, LCD_CS2,A    ;not select column 1
	movlw	00111111B
	movwf	LCD_cmd
	call	LCD_write_cmd	    ;display on
	movlw	10111010B	    ;select page2 in column 0
	movwf	LCD_cmd
	call	LCD_write_cmd	    ;send instruction to LCD
	movlw	11100000B	    ;start from cursor position 32
	movwf	LCD_cmd
	call	LCD_write_cmd
	movlw	0x20		    ;want to write in 32-63 cursor positions, 0x20 = 32
	movwf	LCD_counter,A
	movf	LCD_data, W, A		    ;data to be displayed
    loop6:
	call	LCD_write_data
	decfsz	LCD_counter,A
	bra	loop6
	return	
	
LCD_Block10:
	bsf	PORTB, LCD_CS1,A    ;select column 0
	bcf	PORTB, LCD_CS2,A    ;not select column 1
	movlw	00111111B
	movwf	LCD_cmd
	call	LCD_write_cmd	    ;display on
	movlw	10111000B	    ;select page4 in column 0
	movwf	LCD_cmd
	call	LCD_write_cmd	    ;send instruction to LCD
	movlw	11100000B	    ;start from cursor position 32
	movwf	LCD_cmd
	call	LCD_write_cmd
	movlw	0x20		    ;want to write in 32-63 cursor positions, 0x20 = 32
	movwf	LCD_counter,A
	movf	LCD_data, W, A		    ;data to be displayed
    loop10:
	call	LCD_write_data
	decfsz	LCD_counter,A
	bra	loop10
	return	
	
LCD_Block3:
	bcf	PORTB, LCD_CS1,A    ; not select column 0
	bsf	PORTB, LCD_CS2,A    ;select column 1
	movlw	00111111B
	movwf	LCD_cmd
	call	LCD_write_cmd	    ;display on
	movlw	10111000B	    ;select page0 in column 1
	movwf	LCD_cmd
	call	LCD_write_cmd	    ;send instruction to LCD
	movlw	0x20		    ;want to write in 0-31 cursor positions, 0x20 = 32
	movwf	LCD_counter,A
	movf	LCD_data, W, A		    ;data to be displayed(want a solid block so all bits are 1)
    loop3:
	call	LCD_write_data
	decfsz	LCD_counter,A
	bra	loop3
	return	
	
LCD_Block7:
	bcf	PORTB, LCD_CS1,A    ; not select column 0
	bsf	PORTB, LCD_CS2,A    ;select column 1
	movlw	00111111B
	movwf	LCD_cmd
	call	LCD_write_cmd	    ;display on
	movlw	10111010B	    ;select page2 in column 1
	movwf	LCD_cmd
	call	LCD_write_cmd	    ;send instruction to LCD
	movlw	0x20		    ;want to write in 0-31 cursor positions, 0x20 = 32
	movwf	LCD_counter,A
	movf	LCD_data, W, A		    ;data to be displayed(want a solid block so all bits are 1)
    loop7:
	call	LCD_write_data
	decfsz	LCD_counter,A
	bra	loop7
	return	
	
LCD_Block11:
	bcf	PORTB, LCD_CS1,A    ;not select column 0
	bsf	PORTB, LCD_CS2,A    ;select column 1
	movlw	00111111B
	movwf	LCD_cmd
	call	LCD_write_cmd	    ;display on
	movlw	10111100B	    ;select page4 in column 1
	movwf	LCD_cmd
	call	LCD_write_cmd	    ;send instruction to LCD
	movlw	0x20		    ;want to write in 0-31 cursor positions, 0x20 = 32
	movwf	LCD_counter,A
	movf	LCD_data, W, A		    ;data to be displayed(want a solid block so all bits are 1)
    loop11:
	call	LCD_write_data
	decfsz	LCD_counter,A
	bra	loop11
	return	
	
LCD_Block4:
	bcf	PORTB, LCD_CS1,A    ;not select column 0
	bsf	PORTB, LCD_CS2,A    ;select column 1
	movlw	00111111B
	movwf	LCD_cmd
	call	LCD_write_cmd	    ;display on
	movlw	10111000B	    ;select page0 in column 1
	movwf	LCD_cmd
	call	LCD_write_cmd	    ;send instruction to LCD
	movlw	11100000B	    ;start from cursor position 32
	movwf	LCD_cmd
	call	LCD_write_cmd
	movlw	0x20		    ;want to write in 32-63 cursor positions, 0x20 = 32
	movwf	LCD_counter,A
	movf	LCD_data, W, A		    ;data to be displayed
    loop4:
	call	LCD_write_data
	decfsz	LCD_counter,A
	bra	loop4
	return	
	
LCD_Block8:
	bcf	PORTB, LCD_CS1,A    ;not select column 0
	bsf	PORTB, LCD_CS2,A    ;select column 1
	movlw	00111111B
	movwf	LCD_cmd
	call	LCD_write_cmd	    ;display on
	movlw	10111010B	    ;select page2 in column 1
	movwf	LCD_cmd
	call	LCD_write_cmd	    ;send instruction to LCD
	movlw	11100000B	    ;start from cursor position 32
	movwf	LCD_cmd
	call	LCD_write_cmd
	movlw	0x20		    ;want to write in 32-63 cursor positions, 0x20 = 32
	movwf	LCD_counter,A
	movf	LCD_data, W, A		    ;data to be displayed
    loop8:
	call	LCD_write_data
	decfsz	LCD_counter,A
	bra	loop8
	return	
	
LCD_Block12:
	bcf	PORTB, LCD_CS1,A    ;not select column 0
	bsf	PORTB, LCD_CS2,A    ;select column 1
	movlw	00111111B
	movwf	LCD_cmd
	call	LCD_write_cmd	    ;display on
	movlw	10111100B	    ;select page4 in column 1
	movwf	LCD_cmd
	call	LCD_write_cmd	    ;send instruction to LCD
	movlw	11100000B	    ;start from cursor position 32
	movwf	LCD_cmd
	call	LCD_write_cmd
	movlw	0x20		    ;want to write in 32-63 cursor positions, 0x20 = 32
	movwf	LCD_counter,A
	movf	LCD_data, W, A		    ;data to be displayed
    loop12:
	call	LCD_write_data
	decfsz	LCD_counter,A
	bra	loop12
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
   
	
LCD_find_pos:
	btfsc	PORTH,0
	call	LCD_Block1
	btfsc	PORTH,1
	call	LCD_Block2
	btfsc	PORTH,2
	call	LCD_Block3
	btfsc	PORTH,3
	call	LCD_Block4
	btfsc	PORTH,4
	call	LCD_Block5
	btfsc	PORTH,5
	call	LCD_Block6
	btfsc	PORTH,6
	call	LCD_Block7
	btfsc	PORTH,7
	call	LCD_Block8
	btfsc	PORTJ,0
	call	LCD_Block9
	btfsc	PORTJ,1
	call	LCD_Block10
	btfsc	PORTJ,2
	call	LCD_Block11
	btfsc	PORTJ,3
	call	LCD_Block12
	return
; ** a few delay routines below here as LCD timing can be quite critical ****
LCD_delay_ms:		    ; delay given in ms in W
	movwf	LCD_cnt_ms, A
lcdlp2:	movlw	250	    ; 1 ms delay
	call	LCD_delay_x4us	
	decfsz	LCD_cnt_ms, A
	bra	lcdlp2
	return
    
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

    

    end


