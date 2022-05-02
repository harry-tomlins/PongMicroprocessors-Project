#include <xc.inc>

extrn	start
global	LCD_delay_ms, LCD_delay_x4us, LCD_delay, GLCD_Setup, GLCD_Enable, Send_Byte_GLCD_I_LHS, Send_Byte_GLCD_I_RHS, Send_Byte_GLCD_D_LHS, Send_Byte_GLCD_D_RHS, Reset_GLCD, Clear_Screen, Scores, Transmit_Single_LHS, Transmit_Single_RHS
global	Score_0_LHS,Score_1_LHS,Score_2_LHS,Score_3_LHS,Score_4_LHS,Score_5_LHS,Score_6_LHS,Score_7_LHS,Score_8_LHS,Score_9_LHS,Score_0_RHS,Score_1_RHS,Score_2_RHS,Score_3_RHS,Score_4_RHS,Score_5_RHS,Score_6_RHS,Score_7_RHS,Score_8_RHS,Score_9_RHS    
   
psect	udata_acs   ; named variables in access ram#
LCD_cnt_l:	ds 1   ; reserve 1 byte for variable LCD_cnt_l
LCD_cnt_h:	ds 1   ; reserve 1 byte for variable LCD_cnt_h
LCD_cnt_ms:	ds 1   ; reserve 1 byte for ms counter
LCD_counter:	ds 1   ; reserve 1 byte for counting through nessage
counter:	ds 1   
counter_x:	ds 1
x_coord:	ds 1
GLCD_Data   EQU 0x10   ; reserve 1 byte for data to read into GLCD
    
psect	GLCD_code, class=CODE
	

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
	

GLCD_Setup:
    movlw   0x00
    movwf   TRISB, A ;setting all PORTB pins as outputs
    movlw   0x00
    movwf   TRISD, A
    call    Reset_GLCD
    movlw   00111111B
    call    Send_Byte_GLCD_I_LHS ;turns on the display on the LHS
    movlw   00111111B
    call    Send_Byte_GLCD_I_RHS ;turns on the display on the RHS 
    return
    
    

    
    
    
GLCD_Enable:	    ; pulse enable bit RB4 for 750ns
	movlw	00010000B
	addwf	PORTB, F, A ;changing the enable bit RB4 to high
	;bsf	LATB, LCD_E, A	    ; Take enable high
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop

	movlw	00010000B
	subwf	PORTB, F, A ;changes the enable bit RB4 to low
	;bcf	LATB, LCD_E, A	    ; Writes data to LCD
	
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	
	return
	
Send_Byte_GLCD_I_LHS: ;transmit 1 byte of data from W to GLCD
    movwf   GLCD_Data, A
    movlw   00100010B
    movwf   PORTB, A
    movff   GLCD_Data, PORTD, A
    nop
    nop
    nop
    nop
    call    GLCD_Enable
    movlw   10	    ; delay 40us
    call    LCD_delay_x4us
    return
    
Send_Byte_GLCD_I_RHS: ;transmit 1 byte of data from W to GLCD
    movwf   GLCD_Data, A
    movlw   00100001B
    movwf   PORTB, A
    movff   GLCD_Data, PORTD, A
    nop
    nop
    nop
    nop
    call    GLCD_Enable
    movlw   10	    ; delay 40us
    call    LCD_delay_x4us
    return
    
Send_Byte_GLCD_D_LHS: ;transmit 1 byte of data from W to GLCD
    movwf   GLCD_Data, A
    movlw   00100110B
    movwf   PORTB, A
    movff   GLCD_Data, PORTD, A
    nop
    nop
    nop
    nop
    call    GLCD_Enable
    movlw   10	    ; delay 40us
    call    LCD_delay_x4us
    return
    
Send_Byte_GLCD_D_RHS: ;transmit 1 byte of data from W to GLCD
    movwf   GLCD_Data, A
    movlw   00100101B
    movwf   PORTB, A
    movff   GLCD_Data, PORTD, A
    nop
    nop
    nop
    nop
    call    GLCD_Enable
    movlw   10	    ; delay 40us
    call    LCD_delay_x4us
    return
    
 Read_Byte_GLCD_LHS:
    movlw   00111110B
    movwf   PORTB, A
    call    GLCD_Enable
    movlw   10	    ; delay 40us
    call    LCD_delay_x4us
    return
    
Reset_GLCD: ;transmit 1 byte of data from W to GLCD
    movwf   GLCD_Data, A
    movlw   00000010B
    movwf   PORTB, A
    movff   GLCD_Data, PORTD, A
    nop
    nop
    nop
    nop
    call    GLCD_Enable
    movlw   00000001B
    movwf   PORTB, A
    movff   GLCD_Data, PORTD, A
    nop
    nop
    nop
    nop
    call    GLCD_Enable
    return
    
Clear_Screen:
    movlw   8
    movwf   counter_x, A
loop_LHS:   
    movlw   64
    movwf   counter, A
    movlw   10111000B
    addwf   counter_x, W, A
    movwf   x_coord, A
    movlw   01000000B ;setting y adress to 0
    call    Send_Byte_GLCD_I_LHS  
    movf    x_coord, W, A
    call    Send_Byte_GLCD_I_LHS 
    call    Transmit_Single_LHS
    decfsz  counter_x, A
    bra	    loop_LHS

    movlw   8
    movwf   counter_x, A
loop_RHS:   
    movlw   64
    movwf   counter, A
    movlw   10111000B
    addwf   counter_x, W, A
    movwf   x_coord, A
    movlw   01000000B ;setting y adress to 0
    call    Send_Byte_GLCD_I_RHS  
    movf    x_coord, W, A
    call    Send_Byte_GLCD_I_RHS 
    call    Transmit_Single_RHS
    decfsz  counter_x, A
    bra	    loop_RHS
    
    movlw   01000000B ;setting y adress to 0
    call    Send_Byte_GLCD_I_RHS  
    movlw   10111000B
    call    Send_Byte_GLCD_I_RHS
    call    Transmit_Single_RHS
    
    movlw   01000000B ;setting y adress to 0
    call    Send_Byte_GLCD_I_LHS  
    movlw   10111000B
    call    Send_Byte_GLCD_I_LHS
    call    Transmit_Single_LHS
    
    
    return

    
Transmit_Single_LHS: ;transmits a single value from W as many imes as is stored in counter
    movlw   0xFF
    call    Send_Byte_GLCD_D_LHS
    decfsz  counter, A
    bra	    Transmit_Single_LHS
    return
    
Transmit_Single_RHS: ;transmits a single value from W as many imes as is stored in counter
    movlw   0xFF
    call    Send_Byte_GLCD_D_RHS
    decfsz  counter, A
    bra	    Transmit_Single_RHS
    return

Scores:
Score_1_LHS:
    movlw   01101101B ;setting y adress to 45
    call    Send_Byte_GLCD_I_LHS  
    movlw   10111000B ;setting x adress to zero
    call    Send_Byte_GLCD_I_LHS 
    movlw   11111111B
    call    Send_Byte_GLCD_D_LHS
    movlw   01111101B
    call    Send_Byte_GLCD_D_LHS
    movlw   0x00
    call    Send_Byte_GLCD_D_LHS
    movlw   01111111B
    call    Send_Byte_GLCD_D_LHS
    return
    
Score_2_LHS:
    movlw   01101101B ;setting y adress to 45
    call    Send_Byte_GLCD_I_LHS  
    movlw   10111000B ;setting x adress to zero
    call    Send_Byte_GLCD_I_LHS 
    movlw   00011101B
    call    Send_Byte_GLCD_D_LHS
    movlw   01101110B
    call    Send_Byte_GLCD_D_LHS
    movlw   01110110B
    call    Send_Byte_GLCD_D_LHS
    movlw   01111001B
    call    Send_Byte_GLCD_D_LHS
    return

Score_3_LHS:
    movlw   01101101B ;setting y adress to 45
    call    Send_Byte_GLCD_I_LHS  
    movlw   10111000B ;setting x adress to zero
    call    Send_Byte_GLCD_I_LHS 
    movlw   10111101B
    call    Send_Byte_GLCD_D_LHS
    movlw   01110110B
    call    Send_Byte_GLCD_D_LHS
    movlw   01110110B
    call    Send_Byte_GLCD_D_LHS
    movlw   10001001B
    call    Send_Byte_GLCD_D_LHS
    return
    
Score_4_LHS:
    movlw   01101101B ;setting y adress to 45
    call    Send_Byte_GLCD_I_LHS  
    movlw   10111000B ;setting x adress to zero
    call    Send_Byte_GLCD_I_LHS 
    movlw   11000000B
    call    Send_Byte_GLCD_D_LHS
    movlw   11011111B
    call    Send_Byte_GLCD_D_LHS
    movlw   00000111B
    call    Send_Byte_GLCD_D_LHS
    movlw   11011111B
    call    Send_Byte_GLCD_D_LHS
    return
    
Score_5_LHS:
    movlw   01101101B ;setting y adress to 45
    call    Send_Byte_GLCD_I_LHS  
    movlw   10111000B ;setting x adress to zero
    call    Send_Byte_GLCD_I_LHS 
    movlw   01110000B
    call    Send_Byte_GLCD_D_LHS
    movlw   01110110B
    call    Send_Byte_GLCD_D_LHS
    movlw   01110110B
    call    Send_Byte_GLCD_D_LHS
    movlw   10001110B
    call    Send_Byte_GLCD_D_LHS
    return
    
Score_6_LHS:
    movlw   01101101B ;setting y adress to 45
    call    Send_Byte_GLCD_I_LHS  
    movlw   10111000B ;setting x adress to zero
    call    Send_Byte_GLCD_I_LHS 
    movlw   10000011B
    call    Send_Byte_GLCD_D_LHS
    movlw   01110101B
    call    Send_Byte_GLCD_D_LHS
    movlw   01110110B
    call    Send_Byte_GLCD_D_LHS
    movlw   10001110B
    call    Send_Byte_GLCD_D_LHS
    return
    
Score_7_LHS:
    movlw   01101101B ;setting y adress to 45
    call    Send_Byte_GLCD_I_LHS  
    movlw   10111000B ;setting x adress to zero
    call    Send_Byte_GLCD_I_LHS 
    movlw   11111110B
    call    Send_Byte_GLCD_D_LHS
    movlw   00011110B
    call    Send_Byte_GLCD_D_LHS
    movlw   11100110B
    call    Send_Byte_GLCD_D_LHS
    movlw   11111000B
    call    Send_Byte_GLCD_D_LHS
    return
    
Score_8_LHS:
    movlw   01101101B ;setting y adress to 45
    call    Send_Byte_GLCD_I_LHS  
    movlw   10111000B ;setting x adress to zero
    call    Send_Byte_GLCD_I_LHS 
    movlw   10011001B
    call    Send_Byte_GLCD_D_LHS
    movlw   01100110B
    call    Send_Byte_GLCD_D_LHS
    movlw   01100110B
    call    Send_Byte_GLCD_D_LHS
    movlw   10011001B
    call    Send_Byte_GLCD_D_LHS
    return
    
Score_9_LHS:
    movlw   01101101B ;setting y adress to 45
    call    Send_Byte_GLCD_I_LHS  
    movlw   10111000B ;setting x adress to zero
    call    Send_Byte_GLCD_I_LHS 
    movlw   10111001B
    call    Send_Byte_GLCD_D_LHS
    movlw   01110110B
    call    Send_Byte_GLCD_D_LHS
    movlw   01110110B
    call    Send_Byte_GLCD_D_LHS
    movlw   10000001B
    call    Send_Byte_GLCD_D_LHS
    return
    
Score_0_LHS:
    movlw   01101101B ;setting y adress to 45
    call    Send_Byte_GLCD_I_LHS  
    movlw   10111000B ;setting x adress to zero
    call    Send_Byte_GLCD_I_LHS 
    movlw   10000001B
    call    Send_Byte_GLCD_D_LHS
    movlw   01111110B
    call    Send_Byte_GLCD_D_LHS
    movlw   01111110B
    call    Send_Byte_GLCD_D_LHS
    movlw   10000001B
    call    Send_Byte_GLCD_D_LHS
    return
 
Score_1_RHS:
    movlw   01001111B ;setting y adress to 45
    call    Send_Byte_GLCD_I_RHS  
    movlw   10111000B ;setting x adress to zero
    call    Send_Byte_GLCD_I_RHS 
    movlw   11111111B
    call    Send_Byte_GLCD_D_RHS
    movlw   01111101B
    call    Send_Byte_GLCD_D_RHS
    movlw   0x00
    call    Send_Byte_GLCD_D_RHS
    movlw   01111111B
    call    Send_Byte_GLCD_D_RHS
    return
    
Score_2_RHS:
    movlw   01001111B ;setting y adress to 45
    call    Send_Byte_GLCD_I_RHS  
    movlw   10111000B ;setting x adress to zero
    call    Send_Byte_GLCD_I_RHS 
    movlw   00011101B
    call    Send_Byte_GLCD_D_RHS
    movlw   01101110B
    call    Send_Byte_GLCD_D_RHS
    movlw   01110110B
    call    Send_Byte_GLCD_D_RHS
    movlw   01111001B
    call    Send_Byte_GLCD_D_RHS
    return

Score_3_RHS:
    movlw   01001111B ;setting y adress to 45
    call    Send_Byte_GLCD_I_RHS  
    movlw   10111000B ;setting x adress to zero
    call    Send_Byte_GLCD_I_RHS 
    movlw   10111101B
    call    Send_Byte_GLCD_D_RHS
    movlw   01110110B
    call    Send_Byte_GLCD_D_RHS
    movlw   01110110B
    call    Send_Byte_GLCD_D_RHS
    movlw   10001001B
    call    Send_Byte_GLCD_D_RHS
    return
    
Score_4_RHS:
    movlw   01001111B ;setting y adress to 45
    call    Send_Byte_GLCD_I_RHS  
    movlw   10111000B ;setting x adress to zero
    call    Send_Byte_GLCD_I_RHS 
    movlw   11000000B
    call    Send_Byte_GLCD_D_RHS
    movlw   11011111B
    call    Send_Byte_GLCD_D_RHS
    movlw   00000111B
    call    Send_Byte_GLCD_D_RHS
    movlw   11011111B
    call    Send_Byte_GLCD_D_RHS
    return
    
Score_5_RHS:
    movlw   01001111B ;setting y adress to 45
    call    Send_Byte_GLCD_I_RHS  
    movlw   10111000B ;setting x adress to zero
    call    Send_Byte_GLCD_I_RHS 
    movlw   01110000B
    call    Send_Byte_GLCD_D_RHS
    movlw   01110110B
    call    Send_Byte_GLCD_D_RHS
    movlw   01110110B
    call    Send_Byte_GLCD_D_RHS
    movlw   10001110B
    call    Send_Byte_GLCD_D_RHS
    return
    
Score_6_RHS:
    movlw   01001111B ;setting y adress to 45
    call    Send_Byte_GLCD_I_RHS  
    movlw   10111000B ;setting x adress to zero
    call    Send_Byte_GLCD_I_RHS 
    movlw   10000011B
    call    Send_Byte_GLCD_D_RHS
    movlw   01110101B
    call    Send_Byte_GLCD_D_RHS
    movlw   01110110B
    call    Send_Byte_GLCD_D_RHS
    movlw   10001110B
    call    Send_Byte_GLCD_D_RHS
    return
    
Score_7_RHS:
    movlw   01001111B ;setting y adress to 45
    call    Send_Byte_GLCD_I_RHS  
    movlw   10111000B ;setting x adress to zero
    call    Send_Byte_GLCD_I_RHS 
    movlw   11111110B
    call    Send_Byte_GLCD_D_RHS
    movlw   00011110B
    call    Send_Byte_GLCD_D_RHS
    movlw   11100110B
    call    Send_Byte_GLCD_D_RHS
    movlw   11111000B
    call    Send_Byte_GLCD_D_RHS
    return
    
Score_8_RHS:
    movlw   01001111B ;setting y adress to 45
    call    Send_Byte_GLCD_I_RHS  
    movlw   10111000B ;setting x adress to zero
    call    Send_Byte_GLCD_I_RHS 
    movlw   10011001B
    call    Send_Byte_GLCD_D_RHS
    movlw   01100110B
    call    Send_Byte_GLCD_D_RHS
    movlw   01100110B
    call    Send_Byte_GLCD_D_RHS
    movlw   10011001B
    call    Send_Byte_GLCD_D_RHS
    return
    
Score_9_RHS:
    movlw   01001111B ;setting y adress to 15
    call    Send_Byte_GLCD_I_RHS  
    movlw   10111000B ;setting x adress to zero
    call    Send_Byte_GLCD_I_RHS 
    movlw   10111001B
    call    Send_Byte_GLCD_D_RHS
    movlw   01110110B
    call    Send_Byte_GLCD_D_RHS
    movlw   01110110B
    call    Send_Byte_GLCD_D_RHS
    movlw   10000001B
    call    Send_Byte_GLCD_D_RHS
    return
    
Score_0_RHS:
    movlw   01001111B ;setting y adress to 15
    call    Send_Byte_GLCD_I_RHS  
    movlw   10111000B ;setting x adress to zero
    call    Send_Byte_GLCD_I_RHS 
    movlw   10000001B
    call    Send_Byte_GLCD_D_RHS
    movlw   01111110B
    call    Send_Byte_GLCD_D_RHS
    movlw   01111110B
    call    Send_Byte_GLCD_D_RHS
    movlw   10000001B
    call    Send_Byte_GLCD_D_RHS
    return
    
   


