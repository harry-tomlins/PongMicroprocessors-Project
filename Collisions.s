#include <xc.inc>
    global  u_boundary_check,l_boundary_check,invert_x_vel, no_sections,paddle_L_collision_check,ball_y_check,current_x,paddle_R_collision_check
    global  no_sections,col_counter,current_x,ball_x,ball_y,vel_set_1,vel_set_2,vel_set_3,ball_y_check,ball_reset_l,ball_reset_r,ball_x_2
    global  diff
    extrn  ball_v_x, ball_v_y,paddle_L_x,paddle_R_x,ball_x,ball_y, paddle_L_size,L_score,R_score,long_delay,LCD_delay_ms,paddle_L_draw,paddle_R_draw,buzz_check
psect	udata_acs
col_counter:   ds 1
no_sections:	ds 1
current_x:	ds 1
ball_x_2:	ds 1
temp:		ds 1
diff:		ds 1    
psect	Collision_code, class=CODE
    
u_boundary_check: ;checks if the x-ccordinate of the ball is inside the upper boundary
    
    movf    ball_x,W,A
    sublw   61
    bz	    invert_x_vel
    movf    ball_x,W,A
    sublw   60
    bz	    invert_x_vel
    movf    ball_x,W,A
    sublw   59
    bz	    invert_x_vel
    return

l_boundary_check: ;checks if the x-ccordinate of the ball is inside the lower boundary

    
    movf    ball_x,W,A
    sublw   0
    bz	    invert_x_vel
    movf    ball_x,W,A
    sublw   1
    bz	    invert_x_vel
    movf    ball_x,W,A
    sublw   2
    bz	    invert_x_vel
    return
    
    
invert_x_vel: ;multiplies the balls x_velocity by -1
    movf    ball_v_x,W,A
    mullw   -1
    movf    PRODL,W,A
    movwf   ball_v_x,A
    movlw   1
    movwf   buzz_check,A
    return
invert_y_vel: ;multiplies the balls x_velocity by -1
    movf    ball_v_y,W,A
    mullw   -1
    movf    PRODL,W,A
    movwf   ball_v_y,A
    movlw   1
    movwf   buzz_check,A
    return
       
    
paddle_R_collision_check:
    movff   no_sections,col_counter,A ;sets a counter with the number of pixels per section in the paddle
    movff   paddle_R_x, current_x,A ;sets the current x-coordinate being checked in the paddle to the primary paddle pixel
    movf    ball_x,W,A
    addlw   2
    movwf   ball_x_2,A ;sets the x-coordinate of the secondary ball pixel being checked
rloop1:
    movf    ball_x,W,A
    subwf   current_x,W,A ;if the x-coord of ball matches the current position in paddle being checked this will be zero
    addlw   1
    movwf   temp,A
    dcfsnz  temp,A ;if temp is zero then the code will branch to set the balls velocity
    goto    vel_set_3
    movf    ball_x_2,W,A
    subwf   current_x,W,A;if the x-coord of ball matches the current position in paddle being checked this will be zero
    addlw   1
    movwf   temp,A
    dcfsnz  temp,A ;if temp is zero then the code will branch to set the balls velocity
    goto    vel_set_3
    movlw   1
    addwf   current_x,f,A ;increase current_x by 1 so stepping through the paddle 1 pixel at a time
    decfsz  col_counter,A ;decrese the counter so only loop as many times as there are pixels in each paddle section
    bra rloop1

    movff   no_sections,col_counter,A ;reset the counter 
rloop2:    
    movf    ball_x,W,A
    subwf   current_x,W,A ;if the x-coord of ball matches the current position in paddle being checked this will be zero
    addlw   1
    movwf   temp,A
    dcfsnz  temp,A ;if temp is zero then the code will branch to set the balls velocity
    goto    vel_set_2
    movf    ball_x_2,W,A
    subwf   current_x,W,A ;if the x-coord of ball matches the current position in paddle being checked this will be zero
    addlw   1
    movwf   temp,A
    dcfsnz  temp,A ;if temp is zero then the code will branch to set the balls velocity
    goto    vel_set_2
    movlw   1
    addwf   current_x,f,A ;increase current_x by 1 so stepping through the paddle 1 pixel at a time
    decfsz  col_counter,A  ;decrese the counter so only loop as many times as there are pixels in each paddle section
    bra rloop2

    movff   no_sections,col_counter,A ;reset the counter
rloop3:    
    movf    ball_x,W,A
    subwf   current_x,W,A ;if the x-coord of ball matches the current position in paddle being checked this will be zero
    addlw   1
    movwf   temp,A
    dcfsnz  temp,A ;if temp is zero then the code will branch to set the balls velocity
    goto    vel_set_1
    movf    ball_x_2,W,A
    subwf   current_x,W,A ;if the x-coord of ball matches the current position in paddle being checked this will be zero
    addlw   1
    movwf   temp,A
    dcfsnz  temp,A ;if temp is zero then the code will branch to set the balls velocity
    goto    vel_set_1
    movlw   1
    addwf   current_x,f,A ;increase current_x by 1 so stepping through the paddle 1 pixel at a time
    decfsz  col_counter,A ;decrese the counter so only loop as many times as there are pixels in each paddle section
    bra rloop3
    
    movff   no_sections,col_counter,A ;reset the counter
rloop4:    
    movf    ball_x,W,A
    subwf   current_x,W,A ;if the x-coord of ball matches the current position in paddle being checked this will be zero
    addlw   1
    movwf   temp,A
    dcfsnz  temp,A ;if temp is zero then the code will branch to set the balls velocity
    goto    vel_set_2
    movf    ball_x_2,W,A
    subwf   current_x,W,A ;if the x-coord of ball matches the current position in paddle being checked this will be zero
    addlw   1
    movwf   temp,A
    dcfsnz  temp,A ;if temp is zero then the code will branch to set the balls velocity
    goto    vel_set_2
    movlw   1
    addwf   current_x,f,A ;increase current_x by 1 so stepping through the paddle 1 pixel at a time
    decfsz  col_counter,A ;decrese the counter so only loop as many times as there are pixels in each paddle section
    bra rloop4    
    
    movff   no_sections,col_counter,A ;reset the counter
rloop5:    
    movf    ball_x,W,A
    subwf   current_x,W,A ;if the x-coord of ball matches the current position in paddle being checked this will be zero
    addlw   1
    movwf   temp,A
    dcfsnz  temp,A ;if temp is zero then the code will branch to set the balls velocity
    goto    vel_set_3
    movf    ball_x_2,W,A
    subwf   current_x,W,A ;if the x-coord of ball matches the current position in paddle being checked this will be zero
    addlw   1
    movwf   temp,A
    dcfsnz  temp,A ;if temp is zero then the code will branch to set the balls velocity
    goto    vel_set_3
    movlw   1
    addwf   current_x,f,A ;increase current_x by 1 so stepping through the paddle 1 pixel at a time
    decfsz  col_counter,A ;decrese the counter so only loop as many times as there are pixels in each paddle section
    bra rloop5 
    
    movlw   1
    addwf   L_score,f,A ;if the code has not branched off it means no collision has taken place so the score is increased
    
    call ball_reset_r 
    return
    
    
paddle_L_collision_check: ;repeats exactly same procdure but for the LHS paddle instead of the RHS paddle
    movff   no_sections,col_counter,A
    movff  paddle_L_x, current_x,A
    movf    ball_x,W,A
    addlw   2
    movwf   ball_x_2,A
loop1:
    movf    ball_x,W,A
    subwf   current_x,W,A
    bz	    vel_set_3
    movf    ball_x_2,W,A
    subwf   current_x,W,A
    bz	    vel_set_3
    movlw   1
    addwf   current_x,f,A 
    decfsz  col_counter,A
    bra loop1

    movff   no_sections,col_counter,A
loop2:    
    movf    ball_x,W,A
    subwf   current_x,W,A
    bz	    vel_set_2
    movf    ball_x_2,W,A
    subwf   current_x,W,A
    bz	    vel_set_2
    movlw   1
    addwf   current_x,f,A
    decfsz  col_counter,A
    bra loop2

    movff   no_sections,col_counter,A
loop3:    
    movf    ball_x,W,A
    subwf   current_x,W,A
    bz	    vel_set_1
    movf    ball_x_2,W,A
    subwf   current_x,W,A
    bz	    vel_set_1
    movlw   1
    addwf   current_x,f,A
    decfsz  col_counter,A
    bra loop3
    
    movff   no_sections,col_counter,A
loop4:    
    movf    ball_x,W,A
    subwf   current_x,W,A
    bz	    vel_set_2
    movf    ball_x_2,W,A
    subwf   current_x,W,A
    bz	    vel_set_2
    movlw   1
    addwf   current_x,f,A
    decfsz  col_counter,A
    bra loop4    
    
    movff   no_sections,col_counter,A
loop5:    
    movf    ball_x,W,A
    subwf   current_x,W,A
    bz	    vel_set_3
    movf    ball_x_2,W,A
    subwf   current_x,W,A
    bz	    vel_set_3
    movlw   1
    addwf   current_x,f,A
    decfsz  col_counter,A
    bra loop5 
    
    movlw   1
    addwf   R_score,f,A
    
    call ball_reset_l
    return
    
vel_set_3:
    call invert_y_vel ;need to invert ball's y-vel
    movf    ball_v_x,W,A
    addlw   4 ;if the velocity was negative then this will cause a change of sign thus a carry
    bc	negative_3 ;branches on carry
    bra	positive_3 ;if there was no carry then the velocity must have been positive
    
negative_3:
    movlw   -3
    movwf   ball_v_x,A
    return
positive_3:
    movlw   3
    movwf   ball_v_x,A
    return
    
vel_set_2:
    call invert_y_vel
    movf    ball_v_x,W,A
    addlw   4  ;if the velocity was negative then this will cause a change of sign thus a carry
    bc	negative_2  ;branches on carry
    bra	positive_2  ;if there was no carry then the velocity must have been positive
    
negative_2:
    movlw   -2
    movwf   ball_v_x,A
    return
positive_2:
    movlw   2
    movwf   ball_v_x,A
    return
    
vel_set_1:
    call invert_y_vel
    movf    ball_v_x,W,A
    addlw   4  ;if the velocity was negative then this will cause a change of sign thus a carry
    bc	negative_1  ;branches on carry
    bra	positive_1  ;if there was no carry then the velocity must have been positive
    
negative_1:
    movlw   -1
    movwf   ball_v_x,A
    return
positive_1:
    movlw   1
    movwf   ball_v_x,A
    return    


ball_y_check: ;takes a value from W and checks if ball is inside the goal area
    nop
    movf    ball_y,W,A
    sublw   4
    bz	    paddle_L_collision_check
    movf    ball_y,W,A
    sublw   3
    bz	    paddle_L_collision_check
    movf    ball_y,W,A
    sublw   2
    bz	    paddle_L_collision_check
    movf    ball_y,W,A
    sublw   1
    bz	    paddle_L_collision_check
    movf    ball_y,W,A
    sublw   121
    bz	    right_jump
    movf    ball_y,W,A
    sublw   122
    bz	    right_jump
    movf    ball_y,W,A
    sublw   123
    bz	    right_jump
    return
    
right_jump:
    goto	paddle_R_collision_check   
very_long_delay:
    movlw 0xFF
    call LCD_delay_ms
    return
    
    
    
ball_reset_l:
    movlw   30
    movwf   ball_y,A  ;dictates the balls y-coodinate upon reset if RHS player scored
    call    invert_y_vel
    call    ball_initial_calc
    call    paddle_L_draw
    call    paddle_R_draw
    call    very_long_delay
    return

    
ball_reset_r:
    movlw   98
    movwf   ball_y,A  ;dictates the balls y-coodinate upon reset if RHS player scored
    call    invert_y_vel
    call    ball_initial_calc
    call    paddle_L_draw
    call    paddle_R_draw
    call    very_long_delay
    return
    
velr_3:
    goto   vel_set_3 
    
    
    
ball_initial_calc: ;puts the ball at an x_pos of paddle_L_x-paddle_R_x
    movf    paddle_L_x,W,A
    subwf   paddle_R_x,W,A
    movwf   diff,A
    bcf	    diff,7,A
    bcf	    diff,6,A
    movlw   60  ;need to check if the x_pos is bigger than 60 or smaller than 3, if so need to put ball back inot playing arena
    subwf   diff,W,A
    bc	    check ;branches if diff bigger than 60
    movlw   3
    subwf   diff,W,A
    bc	    x_pos_set
    bra	    check2
    
check:
    movlw   4
    subwf   diff,A
    bra	x_pos_set   
check2:
    movlw   4
    addwf   diff,f,A
    bra	    x_pos_set
 
x_pos_set:
    movff   diff,ball_x,A
    return
