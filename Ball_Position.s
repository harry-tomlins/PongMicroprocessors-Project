#include <xc.inc>

global page_B0,page_B1,page_B2,page_B3,page_B4,page_B5,page_B6,page_B7,ball_page,ball_pos,ball_draw,ball_graphics, ball_x, ball_y, ball_temp, ball_v_x, ball_v_y
global	ball_graphics, ball_update, page_B3a,clear_ball_graphics
extrn	LCD_delay_ms, LCD_delay_x4us, LCD_delay, GLCD_Setup, GLCD_Enable, Send_Byte_GLCD_I_LHS, Send_Byte_GLCD_I_RHS, Send_Byte_GLCD_D_LHS, Send_Byte_GLCD_D_RHS
extrn	Reset_GLCD, Clear_Screen, Scores, Transmit_Single_LHS, Transmit_Single_RHS
extrn	power_of_two, counter3,paddle_R_collision_check
    
    
    
psect	udata_acs  
	
page_B0:		ds 1
page_B1:		ds 1
page_B2:		ds 1
page_B3:		ds 1
page_B3a:		ds 1
page_B4:		ds 1
page_B5:		ds 1
page_B6:		ds 1
page_B7:		ds 1
ball_page:	ds 1
ball_pos:	ds 1
ball_current_x:	ds 1
ball_x_old:	ds 1
ball_y_old:	ds 1
ball_x:		ds 1
ball_y:		ds 1
ball_temp:	ds 1
ball_data:	ds 1
ball_instruction:   ds 1

psect	Ball_code, class=CODE

ball_xpos: ;takes in an x-coordiante from W and toggles the correct bit to be output on glcd
    movwf   ball_page, A
    movwf   ball_pos, A
    
    rrcf   ball_page, A ;dividing the x-coordinate by 8 to find the corresponding page
    rrcf   ball_page, A    
    rrcf   ball_page, A
    
    bcf	    ball_page, 7, A ; clear the first 
    bcf	    ball_page, 6, A
    bcf	    ball_page, 5, A
    bcf	    ball_page, 4, A
    bcf	    ball_page, 3, A

    
    bcf	    ball_pos, 7, A ;clear the first 5 bits of the x-coordinate to find which bit to toggle in the page
    bcf	    ball_pos, 6, A
    bcf	    ball_pos, 5, A
    bcf	    ball_pos, 4, A
    bcf	    ball_pos, 3, A
    
    
    movf    ball_page, W, A ;finds the corresponding page to toggle
    sublw   0
    bz	    page_b0
    
    movf    ball_page, W, A
    sublw   1
    bz	    page_b1
    
    movf    ball_page, W, A
    sublw   2
    bz	    page_b2
    
    movf    ball_page, W, A
    sublw   3
    bz	    page_b3
    
    movf    ball_page, W, A
    sublw   4
    bz	    page_b4
    
    movf    ball_page, W, A
    sublw   5
    bz	    page_b5
    
    movf    ball_page, W, A
    sublw   6
    bz	    page_b6
    
    movf    ball_page, W, A
    sublw   7
    bz	    page_b7
    
page_b0:
    movlw   0
    btfsc   ball_pos, 0, A
    addlw   1
    btfsc   ball_pos, 1, A
    addlw   2
    btfsc   ball_pos, 2, A
    addlw   4
    call    power_of_two
    subwf   page_B0, A
    
    return
    
page_b1:
    movlw   0
    btfsc   ball_pos, 0, A
    addlw   1
    btfsc   ball_pos, 1, A
    addlw   2
    btfsc   ball_pos, 2, A
    addlw   4
    call    power_of_two
    subwf   page_B1, A
    
    return
    
    
page_b2:
    movlw   0
    btfsc   ball_pos, 0, A
    addlw   1
    btfsc   ball_pos, 1, A
    addlw   2
    btfsc   ball_pos, 2, A
    addlw   4
    call    power_of_two
    subwf   page_B2, A
    
    return
    
page_b3:
    movlw   0
    btfsc   ball_pos, 0, A
    addlw   1
    btfsc   ball_pos, 1, A
    addlw   2
    btfsc   ball_pos, 2, A
    addlw   4
    call    power_of_two
    subwf   page_B3a, A
    
    return
    
page_b4:
    movlw   0
    btfsc   ball_pos, 0, A
    addlw   1
    btfsc   ball_pos, 1, A
    addlw   2
    btfsc   ball_pos, 2, A
    addlw   4
    call    power_of_two
    subwf   page_B4, A
    
    return
    
page_b5:
    movlw   0
    btfsc   ball_pos, 0, A
    addlw   1
    btfsc   ball_pos, 1, A
    addlw   2
    btfsc   ball_pos, 2, A
    addlw   4
    call    power_of_two
    subwf   page_B5, A
    
    return
    
    
page_b6:
    movlw   0
    btfsc   ball_pos, 0, A
    addlw   1
    btfsc   ball_pos, 1, A
    addlw   2
    btfsc   ball_pos, 2, A
    addlw   4
    call    power_of_two
    subwf   page_B6, A
    
    return
    
    
page_b7:
    movlw   0
    btfsc   ball_pos, 0, A
    addlw   1
    btfsc   ball_pos, 1, A
    addlw   2
    btfsc   ball_pos, 2, A
    addlw   4
    call    power_of_two
    subwf   page_B7, A
    
    return
  

clear_ball:
    movlw   0xFF
    movwf   page_B0, A
    movlw   0xFF
    movwf   page_B1, A   
    movlw   0xFF
    movwf   page_B2, A
    movlw   0xFF
    movwf   page_B3a, A    
    movlw   0xFF
    movwf   page_B4, A    
    movlw   0xFF
    movwf   page_B5, A
    movlw   0xFF
    movwf   page_B6, A
    movlw   0xFF
    movwf   page_B7  ,A  
    return
    
    
output_ball_graphics:
    
    movlw   10111000B
    call    Send_Byte_GLCD_I_RHS;sets  x coordinate to 0 
    movlw   10111000B
    call    Send_Byte_GLCD_I_LHS
    movf    ball_y, W, A
    movff   page_B0, ball_data, A
    call    ball_graphics ;sets y coord 
    movf    ball_y, W, A
    addlw   1
    movff   page_B0, ball_data, A
    call    ball_graphics ;sets y coord
    movf    ball_y, W, A
    addlw   2
    movff   page_B0, ball_data, A
    call    ball_graphics ;sets y coord

    
    movlw   10111001B
    call    Send_Byte_GLCD_I_RHS;sets  x coordinate to 1 
    movlw   10111001B
    call    Send_Byte_GLCD_I_LHS;sets  x coordinate to 1 
    movf    ball_y, W, A
    movff   page_B1, ball_data, A
    call    ball_graphics ;sets y coord 
    movf    ball_y, W, A
    addlw   1
    movff   page_B1, ball_data, A
    call    ball_graphics ;sets y coord
    movf    ball_y, W, A
    addlw   2
    movff   page_B1, ball_data, A
    call    ball_graphics ;sets y coord

    movlw   10111010B
    call    Send_Byte_GLCD_I_RHS;sets  x coordinate to 2 
    movlw   10111010B
    call    Send_Byte_GLCD_I_LHS;sets  x coordinate to 2
    movf    ball_y, W, A
    movff   page_B2, ball_data, A
    call    ball_graphics ;sets y coord 
    movf    ball_y, W, A
    addlw   1
    movff   page_B2, ball_data, A
    call    ball_graphics ;sets y coord
    movf    ball_y, W, A
    addlw   2
    movff   page_B2, ball_data, A
    call    ball_graphics ;sets y coord0 
    
    movlw   10111011B
    call    Send_Byte_GLCD_I_RHS;sets  x coordinate to 3 
    movlw   10111011B
    call    Send_Byte_GLCD_I_LHS;sets  x coordinate to 3 
    movf    ball_y, W, A
    movff   page_B3a, ball_data, A
    call    ball_graphics ;sets y coord 
    movf    ball_y, W, A
    addlw   1
    movff   page_B3a, ball_data, A
    call    ball_graphics ;sets y coord
    movf    ball_y, W, A
    addlw   2
    movff   page_B3a, ball_data, A
    call    ball_graphics ;sets y coord
    
    movlw   10111100B
    call    Send_Byte_GLCD_I_RHS;sets  x coordinate to 4 
    movlw   10111100B
    call    Send_Byte_GLCD_I_LHS;sets  x coordinate to 4
    movf    ball_y, W, A
    movff   page_B4, ball_data, A
    call    ball_graphics ;sets y coord 
    movf    ball_y, W, A
    addlw   1
    movff   page_B4, ball_data, A
    call    ball_graphics ;sets y coord
    movf    ball_y, W, A
    addlw   2
    movff   page_B4, ball_data, A
    call    ball_graphics ;sets y coord 
    
    movlw   10111101B
    call    Send_Byte_GLCD_I_RHS;sets  x coordinate to 5 
    movlw   10111101B
    call    Send_Byte_GLCD_I_LHS;sets  x coordinate to 5 
    movf    ball_y, W, A
    movff   page_B5, ball_data, A
    call    ball_graphics ;sets y coord 
    movf    ball_y, W, A
    addlw   1
    movff   page_B5, ball_data, A
    call    ball_graphics ;sets y coord
    movf    ball_y, W, A
    addlw   2
    movff   page_B5, ball_data, A
    call    ball_graphics ;sets y coord

    movlw   10111110B
    call    Send_Byte_GLCD_I_RHS;sets  x coordinate to 6 
    movlw   10111110B
    call    Send_Byte_GLCD_I_LHS;sets  x coordinate to 6 
    movf    ball_y, W, A
    movff   page_B6, ball_data, A
    call    ball_graphics ;sets y coord 
    movf    ball_y, W, A
    addlw   1
    movff   page_B6, ball_data, A
    call    ball_graphics ;sets y coord
    movf    ball_y, W, A
    addlw   2
    movff   page_B6, ball_data, A
    call    ball_graphics ;sets y coord 
    
    movlw   10111111B
    call    Send_Byte_GLCD_I_RHS;sets  x coordinate to 7 
    movlw   10111111B
    call    Send_Byte_GLCD_I_LHS;sets  x coordinate to 7
    movf    ball_y, W, A
    movff   page_B7, ball_data, A
    call    ball_graphics ;sets y coord 
    movf    ball_y, W, A
    addlw   1
    movff   page_B7, ball_data, A
    call    ball_graphics ;sets y coord
    movf    ball_y, W, A
    addlw   2
    movff   page_B7, ball_data, A
    call    ball_graphics ;sets y coord 
    
    return
    
ball_graphics: ;takes a value from W (y-coord) and ouputs the data stored in ball_data to the correct y-pos, must have the x already set
    movwf   ball_temp, A
    btfsc   ball_temp, 6, A ;checks to see if pixel is on LHS or RHS
    bra	    ball_R
    bra	    ball_L
ball_R:
    bcf	    ball_temp, 6, A ;clears 7th bit to mke into a coordiante
    movlw   01000000B
    addwf   ball_temp,W,A
    call    Send_Byte_GLCD_I_RHS ;set the ycoordinate of the ball
    movf    ball_data, W, A
    call    Send_Byte_GLCD_D_RHS
    return
ball_L:
    bcf	    ball_temp, 6, A ;clears 7th bit to mke into a coordiante
    movlw   01000000B
    addwf   ball_temp,W,A
    call    Send_Byte_GLCD_I_LHS ;set the ycoordinate of the ball
    movf    ball_data, W, A
    call    Send_Byte_GLCD_D_LHS
    return    
    
ball_draw: ;prints a paddle of size paddle_L_size 
    call    clear_ball ;clears all bytes needed to be displayed
    movlw   3
    movwf   counter3, A
    movff   ball_x, ball_current_x, A
    
ball_loop:
    movf    ball_current_x, W,A
    call    ball_xpos
    movlw   1
    addwf   ball_current_x, A
    decfsz  counter3, A
    bra     ball_loop 
    bra	    output_ball_graphics

ball_update:
    movff   ball_x, ball_x_old, A
    movff   ball_y, ball_y_old, A
    movf    ball_v_x, W, A
    addwf   ball_x, F, A
    movf    ball_v_y, W, A
    addwf   ball_y, F, A
    return
        
clear_ball_graphics:
    
    movlw   10111000B
    call    Send_Byte_GLCD_I_RHS;sets  x coordinate to 0 
    movlw   10111000B
    call    Send_Byte_GLCD_I_LHS
    movf    ball_y, W, A
    call    ball_graphics_clear ;sets y coord 
    movf    ball_y, W, A
    addlw   1
    call    ball_graphics_clear ;sets y coord
    movf    ball_y, W, A
    addlw   2
    call    ball_graphics_clear ;sets y coord

    
    movlw   10111001B
    call    Send_Byte_GLCD_I_RHS;sets  x coordinate to 1 
    movlw   10111001B
    call    Send_Byte_GLCD_I_LHS;sets  x coordinate to 1
    movf    ball_y, W, A
    call    ball_graphics_clear ;sets y coord 
    movf    ball_y, W, A
    addlw   1
    call    ball_graphics_clear ;sets y coord
    movf    ball_y, W, A
    addlw   2
    call    ball_graphics_clear ;sets y coord

    movlw   10111010B
    call    Send_Byte_GLCD_I_RHS;sets  x coordinate to 2
    movlw   10111010B
    call    Send_Byte_GLCD_I_LHS;sets  x coordinate to 2
    movf    ball_y, W, A
    call    ball_graphics_clear ;sets y coord 
    movf    ball_y, W, A
    addlw   1
    call    ball_graphics_clear ;sets y coord
    movf    ball_y, W, A
    addlw   2
    call    ball_graphics_clear ;sets y coord0 
    
    movlw   10111011B
    call    Send_Byte_GLCD_I_RHS;sets  x coordinate to 3 
    movlw   10111011B
    call    Send_Byte_GLCD_I_LHS;sets  x coordinate to 3
    movf    ball_y, W, A
    call    ball_graphics_clear ;sets y coord 
    movf    ball_y, W, A
    addlw   1
    call    ball_graphics_clear ;sets y coord
    movf    ball_y, W, A
    addlw   2
    call    ball_graphics_clear ;sets y coord
    
    movlw   10111100B
    call    Send_Byte_GLCD_I_RHS;sets  x coordinate to 4 
    movlw   10111100B
    call    Send_Byte_GLCD_I_LHS;sets  x coordinate to 4
    movf    ball_y, W, A
    call    ball_graphics_clear ;sets y coord 
    movf    ball_y, W, A
    addlw   1
    call    ball_graphics_clear ;sets y coord
    movf    ball_y, W, A
    addlw   2
    call    ball_graphics_clear ;sets y coord 
    
    movlw   10111101B
    call    Send_Byte_GLCD_I_RHS;sets  x coordinate to 5 
    movlw   10111101B
    call    Send_Byte_GLCD_I_LHS;sets  x coordinate to 5 
    movf    ball_y, W, A
    call    ball_graphics_clear ;sets y coord 
    movf    ball_y, W, A
    addlw   1
    call    ball_graphics_clear ;sets y coord
    movf    ball_y, W, A
    addlw   2
    call    ball_graphics_clear ;sets y coord

    movlw   10111110B
    call    Send_Byte_GLCD_I_RHS;sets  x coordinate to 6 
    movlw   10111110B
    call    Send_Byte_GLCD_I_LHS;sets  x coordinate to 6 
    movf    ball_y, W, A
    call    ball_graphics_clear ;sets y coord 
    movf    ball_y, W, A
    addlw   1
    call    ball_graphics_clear ;sets y coord
    movf    ball_y, W, A
    addlw   2
    call    ball_graphics_clear ;sets y coord 
    
    movlw   10111111B
    call    Send_Byte_GLCD_I_RHS;sets  x coordinate to 7 
    movlw   10111111B
    call    Send_Byte_GLCD_I_LHS;sets  x coordinate to 7
    movf    ball_y, W, A
    call    ball_graphics_clear ;sets y coord 
    movf    ball_y, W, A
    addlw   1
    call    ball_graphics_clear;sets y coord
    movf    ball_y, W, A
    addlw   2
    call    ball_graphics_clear ;sets y coord 
    
    return
    
ball_graphics_clear: ;takes a value from W (y-coord) and ouputs the data stored in ball_data to the correct y-pos, must have the x already set
    movwf   ball_temp, A
    btfsc   ball_temp, 6, A ;checks to see if pixel is on LHS or RHS
    bra	    ball_R_c
    bra	    ball_L_c
ball_R_c:
    bcf	    ball_temp, 6, A ;clears 7th bit to mke into a coordiante
    movlw   01000000B
    addwf   ball_temp,W,A
    call    Send_Byte_GLCD_I_RHS ;set the ycoordinate of the ball
    movlw   0xFF  ;clears the byte
    call    Send_Byte_GLCD_D_RHS
    return
ball_L_c:
    bcf	    ball_temp, 6, A ;clears 7th bit to mke into a coordiante
    movlw   01000000B
    addwf   ball_temp,W,A
    call    Send_Byte_GLCD_I_LHS ;set the ycoordinate of the ball
    movlw   0xFF 
    call    Send_Byte_GLCD_D_LHS
    return 
