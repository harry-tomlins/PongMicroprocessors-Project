#include <xc.inc>
 
global   buzzer  
extrn game_loop,buzz_check,LCD_delay_ms
    
    
    
psect  buzzer_code, class=CODE    
    
    
buzzer:
    bcf	PORTB, 6, A	    ;set B6 pin high
    btfss   buzz_check,0,A
    goto game_loop
    movlw 1
    call LCD_delay_ms
    bsf	PORTB, 6, A		
    btfss buzz_check,0,A
    goto game_loop
    movlw 1
    call LCD_delay_ms
    btfsc   buzz_check,0,A
    bra buzzer
    goto game_loop
    
    
   


