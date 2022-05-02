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
    movwf   paddle_L_v,A
    movwf   paddle_R_v,A
    call randvel
    movlw   0x0F
    movwf   TRISE, A
    movlw   0xFF
    movwf   TRISJ, A
    return
    
randvel:
    movlw   1
    movwf   ball_v_y,A
    movwf   ball_v_x,A
    return

paddle_L_check:
    movlw   1
    subwf   PORTE, W, A
    bz	downspeedL
    movlw   8
    subwf   PORTE, W, A
    bz	upspeedL
    
nospeedL:
    movlw   0
    movwf   paddle_L_v,A
    return

downspeedL:
    movlw   2
    movwf   paddle_L_v,A
    return

upspeedL:
    movlw   -2
    movwf   paddle_L_v,A
    return

paddle_R_check:
    movlw   1
    subwf   PORTJ, W, A
    bz	downspeedR
    movlw   8
    subwf   PORTJ, W, A
    bz	upspeedR
nospeedR:
    movlw   0
    movwf   paddle_R_v,A
    return

downspeedR:
    movlw   2
    movwf   paddle_R_v,A
    return

upspeedR:
    movlw   -2
    movwf   paddle_R_v,A
    return

pos_update:
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
    bcf	    ball_x, 7, A
    movf    ball_v_y, W, A
    addwf   ball_y, F, A
    bcf	    ball_y, 7, A
    return