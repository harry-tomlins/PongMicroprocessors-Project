#include <xc.inc>
 
global   buzzer  
extrn game_loop,buzz_check,LCD_delay_ms
    
    
    
psect  buzzer_code, class=CODE    
    
    
buzzer:
    bcf	PORTB, 6, A	    ;set B6 pin low
    btfss   buzz_check,0,A
    goto game_loop
    movlw 1
    call LCD_delay_ms ;set the frequency of buzzer to 500Hz by having 2ms time period
    bsf	PORTB, 6, A		;set B6 pin high
    btfss buzz_check,0,A ;if buzz_check has been toggeled from within the interupt then branch back to main code
    goto game_loop
    movlw 1
    call LCD_delay_ms
    btfsc   buzz_check,0,A
    bra buzzer
    goto game_loop
    
    
   


