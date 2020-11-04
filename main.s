	#include <pic18_chip_select.inc>
	#include <xc.inc>
	
psect	code, abs
main:
	org 0x0
	goto	spi_masterinit
	goto	start
	
	org 0x100		    ; Main code starts here at address 0x10
	
	; setting ports 
spi_masterinit:
	bcf	CKE		    ;cke bit in ssp2stat
	movlw	(SSP2CON1_SSPEN_MASK)(SSP2CON1_CKP_MASK)(SSP2CON1_SSPM1_MASK)
	movwf	SSP2CON1,A
	;sdo2 output, sck2 output
	bcf	TRISD,PORTD_SDO2_POSN,A
	bcf	TRISD,PORTD_SCK2_POSN,A
	return
	
	
spi_mastertransmit:
	
	movwf	SSP2BUF,A   ;write data to output buffer
	return
	
wait_transmit:
	btfss	SSP2IF	    ;check interrupt bit
	bra	wait_transmit
	bcf	SSP2IF	    ;clear interrupt bit
	return
	
		
delay: movlw	0x01
	movwf	0x20, A		;counter1
	movwf	0x22, A		;counter2
	movwf	0x24, A		;counter3
    delay1:	
	decfsz	0x20, 1
	bra delay1
	decfsz	0x22,1
	bra delay1
	decfsz	0x24, 1
	bra delay1
	return
	; ******* Main programme *********************
start:	
	movlw	0xaa	    ;data is 0xaa
	call	spi_mastertransmit
	call	wait_transmit
	call	delay
	
	goto	start
	end	main

	

