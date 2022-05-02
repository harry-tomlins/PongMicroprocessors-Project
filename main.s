#include <xc.inc>
    
  
global	start,game_setup,long_delay,LCD_delay_ms,counter4, long_delay,buzz_check,game_loop  ;Exported values and subroutines

;Subroutines :
extrn	buzzer	;Buzzer Subroutines
extrn	GLCD_Setup, Clear_Screen, LCD_delay_ms ;GLCD Subroutines
extrn   input_setup, randvel, paddle_L_check, paddle_R_check, pos_update, paddle_L_check, paddle_R_check, pos_update ; Velocities Subroutines
extrn	clear_ball_graphics, ball_draw ;Ball_Position Subroutines
extrn	u_boundary_check, l_boundary_check, ball_y_check  ;Collisions Subroutines
extrn	paddle_L_draw, paddle_R_draw	;Positions Subroutines
extrn	L_Score_Display, R_Score_Display    ;Scores Subroutines
;Variables:
extrn	paddle_L_size, paddle_R_size, paddle_L_x, paddle_R_x	;Positions Variables
extrn	ball_x, ball_y, ball_v_x, ball_v_y	;Ball_Position Variables
extrn	no_sections ;Collisions Variables
extrn	L_score, R_score    ;Scores Variables


	
    
    
psect	udata_acs
counter4:	ds 1
counter_ball_x:	ds 1
counter_ball_y:	ds 1 
check:		ds 1
buzz_check:	ds 1


psect	code, abs
      
rst:  org 0x00
      goto start
      
interupt_code_h: org 0x0008
      goto interupted_h
      
    
start:
    call     GLCD_Setup ;sets up the GLCD
    call     Clear_Screen ;clears every pixel on GLCD by setting all bits to 1
    movlw    0x00
    movwf    TRISF,A ;sets up PORTF asan output for testing frame rate
    goto     int_setup ;sets up TIMER0 to be used as an interupt
    bra      game_setup
  
long_delay:
    movlw 17
    call LCD_delay_ms
    return  
    
game_setup:			;initializes the values for the game
    
    call     input_setup ;sets up PORTE and PORTJ as inputs for controlling the paddles
    movlw    10
    movwf    paddle_L_size,A
    movlw    10
    movwf    paddle_R_size,A
    movlw    25
    movwf    paddle_L_x,A
    movlw    25
    movwf    paddle_R_x,A   
    movlw    25
    movwf    ball_x,A
    movlw    63
    movwf    ball_y,A
    movlw    1
    movwf    ball_v_x,A
    movlw    -3
    movwf    ball_v_y,A
    movlw    2
    movwf    no_sections,A
    movlw    0
    movwf    L_score,A
    movlw    0
    movwf    R_score,A
    goto     game_loop
    
    
game_loop:
    movlw   2
    movwf   PORTF,A ;toggle bit 1 of PORTF on and off to measure the refresh rate of the game
    movlw   1
    movwf   check,A		    ;when check is 1 the code loops in mini_loop, the interupt sets it to 0 allowing it to break out
    call clear_ball_graphics	    ;have to clear the ball before moving it so as to ot leave a permenant trail in y-axis
    call paddle_L_check		    ;checks if up or down is pressed on LHS controller
    call paddle_R_check		    ;checks if up or down is pressed on RHS controller
    call u_boundary_check	    ;checks if ball has collided with the upper boundary
    call l_boundary_check	    ;checks if ball has collided with the lower boundary
    call ball_y_check		    ;checks if the ball is in the goal region, then checks if it has collided with the paddle
    call pos_update		    ;updates all positions with the updated velocities
    call ball_draw		    ;displays ball on GLCD
    call paddle_L_draw		    ;displays LHS paddle on GLCD
    call paddle_R_draw		    ;displays RHS paddle on GLCD
    call L_Score_Display	    ;displays LHS players score on GLCD
    call R_Score_Display	    ;displays RHS players score on GLCD
    btfsc   buzz_check,0,A	    ;if a collision has occured during the previous frame buzz_check=1 and the buzzer will be triggered
    goto   buzzer
mini_loop:			    ;if the buzzer is not triggered the code will loop here until the TIMER0 interupt is trigged
    movlw   0		
    addwf   check,A		    ;check gets set to zero during the interupt allowing the loop to be exited
    bz	    game_loop
    bra     mini_loop
    
int_setup:
    bsf     TMR0IE		    
    bsf	    GIE			    ;enables all interupts
    movlw   0xBF
    movwf   TMR0L,A		    ;puting the value 0x63BF into TIMER0 to allow a refresh rate of 41ms
    movlw   0x63
    movwf   TMR0H,A
    movlw   10000011B		    ;turns on TIMER0 at frequency of 1Mhz
    movwf   T0CON,A
    goto    game_setup
    
interupted_h:
    movlw   0
    movwf   PORTF,A		    ;flip this bit to allow rame rate to e meausured
    movlw   0xBF    
    movwf   TMR0L,A
    movlw   0x63
    movwf   TMR0H,A		    ;need to put the value of 0x63BF back into TIMER0 to keep refresh rate constant
    movlw   0 
    movwf   check,A		    ;clears the check variable
    bcf	    TMR0IF		    ;clears the TIMER0 flag
    movlw   0
    movwf  buzz_check,A		    ;clears the buzz_check variable so can break out of buzzer loop
    retfie f
    
 

    
    end rst