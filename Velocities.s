#include <xc.inc>

global	input_setup, randvel, paddle_L_check, paddle_R_check, pos_update
global	ball_v_x, ball_v_y, paddle_L_v, paddle_R_v
extrn	ball_x, ball_y, paddle_L_x, paddle_R_x
    
psect	udata_acs
ball_v_x:	ds 1
ball_v_y:	ds 1
paddle_L_v:	ds 1
paddle_R_v:	ds 1
    
psect	Velocities, class=CODE
    
input_setup:
    
    movlw   0
    movwf   paddle_L_v,A ;reset paddle velocities
    movwf   paddle_R_v,A
    call randvel
    movlw   0x0F
    movwf   TRISE, A ;setting up as input for buttons
    movlw   0xFF
    movwf   TRISJ, A ;setting up as input for buttons
    return
    
randvel:
    movlw   1
    movwf   ball_v_y,A
    movwf   ball_v_x,A
    return

paddle_L_check:
    movlw   1
    subwf   PORTE, W, A ;checks if down button being pressed
    bz	downspeedL
    movlw   8
    subwf   PORTE, W, A ;checks if up button being pressed
    bz	upspeedL
    
nospeedL: ;called if no buttons or two buttons being pressed
    movlw   0
    movwf   paddle_L_v,A ;sets paddle velocity to 0
    return

downspeedL:
    movlw   2
    movwf   paddle_L_v,A ;sets paddle velocity to 2
    return

upspeedL:
    movlw   -2
    movwf   paddle_L_v,A ;sets paddle velocity to -2
    return

paddle_R_check:
    movlw   1
    subwf   PORTJ, W, A ;checks if down button being pressed
    bz	downspeedR
    movlw   8
    subwf   PORTJ, W, A ;checks if up button being pressed
    bz	upspeedR
    
nospeedR: ;if no buttons or two buttons were pressed code comes here
    movlw   0
    movwf   paddle_R_v,A ;sets paddle velocity to 0
    return

downspeedR:
    movlw   2
    movwf   paddle_R_v,A ;sets paddle velocity to 2
    return

upspeedR:
    movlw   -2
    movwf   paddle_R_v,A ;sets paddle velocity to 2
    return

pos_update: ;adds the paddle velocities to the positions to find position of the paddle at next frame
    movf    paddle_L_v, W, A
    addwf   paddle_L_x, F, A
    bcf	    paddle_L_x, 6, A
    bcf	    paddle_L_x, 7, A
    movf    paddle_R_v, W, A
    addwf   paddle_R_x, F, A
    bcf	    paddle_R_x, 6, A
    bcf	    paddle_R_x, 7, A
    movf    ball_v_x, W, A
    addwf   ball_x, F, A
    bcf	    ball_x, 7, A ;clear the 7th bit so dont get an overflow above allowed coordinates
    movf    ball_v_y, W, A
    addwf   ball_y, F, A
    bcf	    ball_y, 7, A ;clear the 7th bit so dont get an overflow above allowed coordinates
    return
