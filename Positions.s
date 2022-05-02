#include <xc.inc>

 global page_L0,page_L1,page_L2,page_L3,page_L4,page_L5,page_L6,page_L7,pad_L_page,pad_L_pos, paddle_L_x, paddle_L_size,paddle_L_draw,page_L3a
 global page_R0,page_R1,page_R2,page_R3,page_R4,page_R5,page_R6,page_R7,pad_R_page,pad_R_pos, paddle_R_x, paddle_R_size,paddle_R_draw
 global page_B0,page_B1,page_B2,page_B3,page_B4,page_B5,page_B6,page_B7,ball_page,ball_pos,ball_x,ball_y,ball_draw
 global	power_of_two, counter3
 extrn	LCD_delay_ms, LCD_delay_x4us, LCD_delay, GLCD_Setup, GLCD_Enable, Send_Byte_GLCD_I_LHS, Send_Byte_GLCD_I_RHS, Send_Byte_GLCD_D_LHS, Send_Byte_GLCD_D_RHS, Reset_GLCD, Clear_Screen, Scores, Transmit_Single_LHS, Transmit_Single_RHS
 extrn	paddle_R_collision_check
    
 psect	udata_acs   ; named variables in access ram#


paddle_L_x:	ds 1	;stores xpos of lowest pixel of the paddle
paddle_L_y:	ds 1	;stores the ypos of the paddle
paddle_L_size:	ds 1	;dictates the length of the paddle
paddle_L_x0:	ds 1	;stores original xpos of the lowest pixel of the paddle
paddle_L_z:	ds 1
paddle_L_v:	ds 1 ;velocity of the LHS paddle
paddle_L_x_old:	ds 1

paddle_R_x:	ds 1	;stores xpos of lowest pixel of the paddle
paddle_R_y:	ds 1	;stores the ypos of the paddle
paddle_R_size:	ds 1	;dictates the length of the paddle
paddle_R_x0:	ds 1	;stores original xpos of the lowest pixel of the paddle
paddle_R_z:	ds 1
paddle_R_v:	ds 1 ;velocity of the RHS paddle

    
page_L0:		ds 1 ;pages are used to display the paddles on screen when sent as datat to the GLCD
page_L1:		ds 1
page_L2:		ds 1
page_L3:		ds 1
page_L3a:		ds 1
page_L4:		ds 1
page_L5:		ds 1
page_L6:		ds 1
page_L7:		ds 1
pad_L_page:	ds 1
pad_L_pos:	ds 1

page_R0:		ds 1
page_R1:		ds 1
page_R2:		ds 1
page_R3:		ds 1
page_R4:		ds 1
page_R5:		ds 1
page_R6:		ds 1
page_R7:		ds 1
pad_R_page:	ds 1
pad_R_pos:	ds 1

counter:	ds 1 ;different counters that are needed for looping thoughout the code
counter2:	ds 1
counter3:	ds 1

paddle_current_x: ds 1 ;variables needed to keep track of which pixel
paddle_current_Lx: ds 1
    

    

    
mult_2:		ds 1
    
    
psect	Pos_code, class=CODE   
    
    
paddle_L_xpos: ;takes in an x-coordiante from W and toggles the correct bit to be output on glcd
    movwf   pad_L_page, A ;this variable will convert x-coord into page number
    movwf   pad_L_pos, A  ; this variable will convert x-coord into position within the page
    
    rrcf   pad_L_page, A ;dividing the x-coordinate by 8 to find the corresponding page
    rrcf   pad_L_page, A    
    rrcf   pad_L_page, A
    
    bcf	    pad_L_page, 7, A ; clear the first 5 bits to prevent bits looping round 
    bcf	    pad_L_page, 6, A
    bcf	    pad_L_page, 5, A
    bcf	    pad_L_page, 4, A
    bcf	    pad_L_page, 3, A

    
    bcf	    pad_L_pos, 7, A ;clear the first 5 bits of the x-coordinate to find which bit to toggle in the page
    bcf	    pad_L_pos, 6, A
    bcf	    pad_L_pos, 5, A
    bcf	    pad_L_pos, 4, A
    bcf	    pad_L_pos, 3, A
    
    
    movf    pad_L_page, W, A 
    sublw   0 ;checks if it is page 0
    bz	    page_0
    
    movf    pad_L_page, W, A
    sublw   1 ;checks if it is page 1
    bz	    page_1
    
    movf    pad_L_page, W, A
    sublw   2 ;checks if it is page 2
    bz	    page_2
    
    movf    pad_L_page, W, A
    sublw   3 ;checks if it is page 3
    bz	    page_3
    
    movf    pad_L_page, W, A
    sublw   4 ;checks if it is page 4
    bz	    page_4
    
    movf    pad_L_page, W, A
    sublw   5 ;checks if it is page 5
    bz	    page_5
    
    movf    pad_L_page, W, A
    sublw   6 ;checks if it is page 6
    bz	    page_6
    
    movf    pad_L_page, W, A
    sublw   7 ;checks if it is page 7
    bz	    page_7
    
page_0:  
    movlw   0
    btfsc   pad_L_pos, 0, A 
    addlw   1
    btfsc   pad_L_pos, 1, A
    addlw   2
    btfsc   pad_L_pos, 2, A
    addlw   4         ; W now contains the position of the bit which needs toggling 
    call    power_of_two  ; raise 2 to the power of (literal stored in W)
    subwf   page_L0, A ;subract this value from the page , equivalent to toggling specific bit off
    
    return
    
page_1:
    movlw   0
    btfsc   pad_L_pos, 0, A
    addlw   1
    btfsc   pad_L_pos, 1, A
    addlw   2
    btfsc   pad_L_pos, 2, A
    addlw   4         ; W now contains the position of the bit which needs toggling
    call    power_of_two ; raise 2 to the power of (literal stored in W)
    subwf   page_L1, A ;subract this value from the page , equivalent to toggling specific bit off
    
    return


page_2:
    movlw   0
    btfsc   pad_L_pos, 0, A
    addlw   1
    btfsc   pad_L_pos, 1, A
    addlw   2
    btfsc   pad_L_pos, 2, A
    addlw   4 ; W now contains the position of the bit which needs toggling
    call    power_of_two ; raise 2 to the power of (literal stored in W)
    subwf   page_L2, A ;subract this value from the page , equivalent to toggling specific bit off
    
    return
    
page_3:
    movlw   0
    btfsc   pad_L_pos, 0, A
    addlw   1
    btfsc   pad_L_pos, 1, A
    addlw   2
    btfsc   pad_L_pos, 2, A
    addlw   4 ; W now contains the position of the bit which needs toggling
    call    power_of_two ; raise 2 to the power of (literal stored in W)
    subwf   page_L3a, A ;subract this value from the page , equivalent to toggling specific bit off
    
    return
    
page_4:
    movlw   0
    btfsc   pad_L_pos, 0, A
    addlw   1
    btfsc   pad_L_pos, 1, A
    addlw   2
    btfsc   pad_L_pos, 2, A
    addlw   4 ; W now contains the position of the bit which needs toggling
    call    power_of_two ; raise 2 to the power of (literal stored in W)
    subwf   page_L4, A  ;subract this value from the page , equivalent to toggling specific bit off
    
    return
    
page_5:
    movlw   0
    btfsc   pad_L_pos, 0, A
    addlw   1
    btfsc   pad_L_pos, 1, A
    addlw   2
    btfsc   pad_L_pos, 2, A
    addlw   4 ; W now contains the position of the bit which needs toggling
    call    power_of_two ; raise 2 to the power of (literal stored in W)
    subwf   page_L5, A  ;subract this value from the page , equivalent to toggling specific bit off
    
    return
    
    
page_6:
    movlw   0
    btfsc   pad_L_pos, 0, A
    addlw   1
    btfsc   pad_L_pos, 1, A
    addlw   2
    btfsc   pad_L_pos, 2, A
    addlw   4 ; W now contains the position of the bit which needs toggling
    call    power_of_two; raise 2 to the power of (literal stored in W)
    subwf   page_L6, A ;subract this value from the page , equivalent to toggling specific bit off
    
    return
    
    
page_7:
    movlw   0
    btfsc   pad_L_pos, 0, A
    addlw   1
    btfsc   pad_L_pos, 1, A
    addlw   2
    btfsc   pad_L_pos, 2, A
    addlw   4 ; W now contains the position of the bit which needs toggling
    call    power_of_two ; raise 2 to the power of (literal stored in W)
    subwf   page_L7, A ;subract this value from the page , equivalent to toggling specific bit off
    
    return
    
       
    
power_of_two: ;takes a value from W and multiples y 2 n times
    addlw   0 ;checking if n=0
    bz	    exit
    movwf   counter, A
    movlw   1
    movwf   mult_2, A
ploop:
    rlncf   mult_2, A ;bit shifting to the left, i.e multiplying by 2
    decfsz  counter, A
    bra	    ploop
    movf    mult_2, W, A
    return
exit:
    movlw   1
    return

clear_paddle_L: ;sets every page to 11111111B, which is equivalent to clearing every bit
    movlw   0xFF
    movwf   page_L0, A
    movlw   0xFF
    movwf   page_L1, A   
    movlw   0xFF
    movwf   page_L2, A
    movlw   0xFF
    movwf   page_L3a, A    
    movlw   0xFF
    movwf   page_L4, A    
    movlw   0xFF
    movwf   page_L5, A
    movlw   0xFF
    movwf   page_L6, A
    movlw   0xFF
    movwf   page_L7  ,A  
    return
    
Paddle_update:
    movff   paddle_L_x, paddle_L_x_old, A
    movf    paddle_L_v, W, A
    addwf   paddle_L_x, F, A
    return
    
paddle_L_draw: ;prints a paddle of size paddle_L_size 
    call     clear_paddle_L ;clears all bytes needed to be displayed
    movff    paddle_L_size,counter3, A ;this means the draw loop will only repeat for as many times as paddle_L_size
    movff    paddle_L_x, paddle_current_Lx, A ;this is used to keep track of which pixel in the paddle you are ouytputting without changing the actual stored coordinate of the paddle
    
draw_loop:
    movf    paddle_current_Lx, W,A
    call    paddle_L_xpos  ;each pixel in the paddle is toggeled in the correct pages
    movlw   1
    addwf   paddle_current_Lx, A ;incriment the x-coordinate each time so can display the whole paddle 
    decfsz  counter3, A
    bra     draw_loop 
    bra	    output_L_graphics ;when finished correctly writing into the pages the data is sent to the GLCD
    

        
    
    
output_L_graphics:
    
    movlw   10111000B
    call    Send_Byte_GLCD_I_LHS;sets  x coordinate to 0 
    movlw   01000011B ;sets y coord to 3
    call    Send_Byte_GLCD_I_LHS 
    movf    page_L0, W, A ;ouputs the first byte to the glcd
    call    Send_Byte_GLCD_D_LHS     
    movf    page_L0, W, A ;automatically incriments the y-value  
    call    Send_Byte_GLCD_D_LHS;sets  x coordinate to 0     
    
    movlw   10111001B
    call    Send_Byte_GLCD_I_LHS;sets  x coordinate to 1 
    movlw   01000011B ;sets y coord to 3
    call    Send_Byte_GLCD_I_LHS
    movf    page_L1, W, A ;ouputs the first byte to the glcd
    call    Send_Byte_GLCD_D_LHS     
    movf    page_L1, W, A ;automatically incriments the y-value  
    call    Send_Byte_GLCD_D_LHS;sets  x coordinate to 0 

    movlw   10111010B
    call    Send_Byte_GLCD_I_LHS;sets  x coordinate to 2 
    movlw   01000011B ;sets y coord to 3
    call    Send_Byte_GLCD_I_LHS
    movf    page_L2, W, A ;ouputs the first byte to the glcd
    call    Send_Byte_GLCD_D_LHS     
    movf    page_L2, W, A ;automatically incriments the y-value 
    call    Send_Byte_GLCD_D_LHS;sets  x coordinate to 0 
    
    movlw   10111011B
    call    Send_Byte_GLCD_I_LHS;sets  x coordinate to 3 
    movlw   01000011B ;sets y coord to 3
    call    Send_Byte_GLCD_I_LHS
    movf    page_L3a, W, A ;ouputs the first byte to the glcd
    call    Send_Byte_GLCD_D_LHS   
    movf    page_L3a, W, A ;automatically incriments the y-value 
    call    Send_Byte_GLCD_D_LHS;sets  x coordinate to 0  

    movlw   10111100B
    call    Send_Byte_GLCD_I_LHS;sets  x coordinate to 4 
    movlw   01000011B ;sets y coord to 3
    call    Send_Byte_GLCD_I_LHS
    movf    page_L4, W, A ;ouputs the first byte to the glcd
    call    Send_Byte_GLCD_D_LHS   
    movf    page_L4, W, A ;automatically incriments the y-value  
    call    Send_Byte_GLCD_D_LHS  
    
    movlw   10111101B
    call    Send_Byte_GLCD_I_LHS;sets  x coordinate to 5 
    movlw   01000011B ;sets y coord to 3
    call    Send_Byte_GLCD_I_LHS
    movf    page_L5, W, A ;ouputs the first byte to the glcd
    call    Send_Byte_GLCD_D_LHS   
    movf    page_L5, W, A ;automatically incriments the y-value 
    call    Send_Byte_GLCD_D_LHS

    movlw   10111110B
    call    Send_Byte_GLCD_I_LHS;sets  x coordinate to 6 
    movlw   01000011B ;sets y coord to 3
    call    Send_Byte_GLCD_I_LHS 
    movf    page_L6, W, A ;ouputs the first byte to the glcd
    call    Send_Byte_GLCD_D_LHS    
    movf    page_L6, W, A ;automatically incriments the y-value  
    call    Send_Byte_GLCD_D_LHS 
    
    movlw   10111111B
    call    Send_Byte_GLCD_I_LHS;sets  x coordinate to 7 
    movlw   01000011B ;sets y coord to 3
    call    Send_Byte_GLCD_I_LHS 
    movf    page_L7, W, A ;ouputs the first byte to the glcd
    call    Send_Byte_GLCD_D_LHS     
    movf    page_L7, W, A ;automatically incriments the y-value 
    call    Send_Byte_GLCD_D_LHS
    
    return
    
    
    
    
    
    
    
    
paddle_R_xpos: ;takes in an x-coordiante from W and toggles the correct bit to be output on glcd
    movwf   pad_R_page, A
    movwf   pad_R_pos, A
    
    rrcf   pad_R_page, A ;dividing the x-coordinate by 8 to find the corresponding page
    rrcf   pad_R_page, A    
    rrcf   pad_R_page, A
    
    bcf	    pad_R_page, 7, A ; clear the first 
    bcf	    pad_R_page, 6, A
    bcf	    pad_R_page, 5, A
    bcf	    pad_R_page, 4, A
    bcf	    pad_R_page, 3, A

    
    bcf	    pad_R_pos, 7, A ;clear the first 5 bits of the x-coordinate to find which bit to toggle in the page
    bcf	    pad_R_pos, 6, A
    bcf	    pad_R_pos, 5, A
    bcf	    pad_R_pos, 4, A
    bcf	    pad_R_pos, 3, A
    
    
    movf    pad_R_page, W, A ;finds the corresponding page to toggle
    sublw   0
    bz	    page_r0
    
    movf    pad_R_page, W, A
    sublw   1
    bz	    page_r1
    
    movf    pad_R_page, W, A
    sublw   2
    bz	    page_r2
    
    movf    pad_R_page, W, A
    sublw   3
    bz	    page_r3
    
    movf    pad_R_page, W, A
    sublw   4
    bz	    page_r4
    
    movf    pad_R_page, W, A
    sublw   5
    bz	    page_r5
    
    movf    pad_R_page, W, A
    sublw   6
    bz	    page_r6
    
    movf    pad_R_page, W, A
    sublw   7
    bz	    page_r7
    
page_r0:
    movlw   0
    btfsc   pad_R_pos, 0, A
    addlw   1
    btfsc   pad_R_pos, 1, A
    addlw   2
    btfsc   pad_R_pos, 2, A
    addlw   4
    call    power_of_two
    subwf   page_R0, A
    
    return
    
page_r1:
    movlw   0
    btfsc   pad_R_pos, 0, A
    addlw   1
    btfsc   pad_R_pos, 1, A
    addlw   2
    btfsc   pad_R_pos, 2, A
    addlw   4
    call    power_of_two
    subwf   page_R1, A
    
    return
    
page_r2:
    movlw   0
    btfsc   pad_R_pos, 0, A
    addlw   1
    btfsc   pad_R_pos, 1, A
    addlw   2
    btfsc   pad_R_pos, 2, A
    addlw   4
    call    power_of_two
    subwf   page_R2, A
    
    return
    
page_r3:
    movlw   0
    btfsc   pad_R_pos, 0, A
    addlw   1
    btfsc   pad_R_pos, 1, A
    addlw   2
    btfsc   pad_R_pos, 2, A
    addlw   4
    call    power_of_two
    subwf   page_R3, A
    
    return
    
page_r4:
    movlw   0
    btfsc   pad_R_pos, 0, A
    addlw   1
    btfsc   pad_R_pos, 1, A
    addlw   2
    btfsc   pad_R_pos, 2, A
    addlw   4
    call    power_of_two
    subwf   page_R4, A
    
    return
    
page_r5:
    movlw   0
    btfsc   pad_R_pos, 0, A
    addlw   1
    btfsc   pad_R_pos, 1, A
    addlw   2
    btfsc   pad_R_pos, 2, A
    addlw   4
    call    power_of_two
    subwf   page_R5, A
    
    return
    
    
page_r6:
    movlw   0
    btfsc   pad_R_pos, 0, A
    addlw   1
    btfsc   pad_R_pos, 1, A
    addlw   2
    btfsc   pad_R_pos, 2, A
    addlw   4
    call    power_of_two
    subwf   page_R6, A
    
    return
    
    
page_r7:
    movlw   0
    btfsc   pad_R_pos, 0, A
    addlw   1
    btfsc   pad_R_pos, 1, A
    addlw   2
    btfsc   pad_R_pos, 2, A
    addlw   4
    call    power_of_two
    subwf   page_R7, A
    
    return
  

clear_paddle_R:
    movlw   0xFF
    movwf   page_R0, A
    movlw   0xFF
    movwf   page_R1, A   
    movlw   0xFF
    movwf   page_R2, A
    movlw   0xFF
    movwf   page_R3, A    
    movlw   0xFF
    movwf   page_R4, A    
    movlw   0xFF
    movwf   page_R5, A
    movlw   0xFF
    movwf   page_R6, A
    movlw   0xFF
    movwf   page_R7  ,A  
    return
    
    
output_R_graphics:
    
    movlw   10111000B
    call    Send_Byte_GLCD_I_RHS;sets  x coordinate to 0 
    movlw   01111011B ;sets y coord to 59
    call    Send_Byte_GLCD_I_RHS
    movf    page_R0, W, A ;ouputs the first byte to the glcd
    call    Send_Byte_GLCD_D_RHS;sets  x coordinate to 0     
    movf    page_R0, W, A ;automatically incriments the y-value so 
    call    Send_Byte_GLCD_D_RHS;sets  x coordinate to 0     
    
    movlw   10111001B
    call    Send_Byte_GLCD_I_RHS;sets  x coordinate to 1
    movlw   01111011B  ;sets y coord to 60
    call    Send_Byte_GLCD_I_RHS 
    movf    page_R1, W, A ;ouputs the first byte to the glcd
    call    Send_Byte_GLCD_D_RHS;sets  x coordinate to 0     
    movf    page_R1, W, A ;automatically incriments the y-value so 
    call    Send_Byte_GLCD_D_RHS;sets  x coordinate to 0 

    movlw   10111010B
    call    Send_Byte_GLCD_I_RHS;sets  x coordinate to 2 
    movlw   01111011B  ;sets y coord to 60
    call    Send_Byte_GLCD_I_RHS
    movf    page_R2, W, A ;ouputs the first byte to the glcd
    call    Send_Byte_GLCD_D_RHS;sets  x coordinate to 0     
    movf    page_R2, W, A ;automatically incriments the y-value so 
    call    Send_Byte_GLCD_D_RHS;sets  x coordinate to 0 
    
    movlw   10111011B
    call    Send_Byte_GLCD_I_RHS;sets  x coordinate to 3 
    movlw   01111011B  ;sets y coord to 60
    call    Send_Byte_GLCD_I_RHS;sets  x coordinate to 0 
    movf    page_R3, W, A ;ouputs the first byte to the glcd
    call    Send_Byte_GLCD_D_RHS;sets  x coordinate to 0     
    movf    page_R3, W, A ;automatically incriments the y-value so 
    call    Send_Byte_GLCD_D_RHS;sets  x coordinate to 0  

    movlw   10111100B
    call    Send_Byte_GLCD_I_RHS;sets  x coordinate to 4 
    movlw   01111011B  ;sets y coord to 60
    call    Send_Byte_GLCD_I_RHS
    movf    page_R4, W, A ;ouputs the first byte to the glcd
    call    Send_Byte_GLCD_D_RHS;sets  x coordinate to 0     
    movf    page_R4, W, A ;automatically incriments the y-value so 
    call    Send_Byte_GLCD_D_RHS;sets  x coordinate to 0  
    
    movlw   10111101B
    call    Send_Byte_GLCD_I_RHS;sets  x coordinate to 5 
    movlw   01111011B  ;sets y coord to 60
    call    Send_Byte_GLCD_I_RHS;
    movf    page_R5, W, A ;ouputs the first byte to the glcd
    call    Send_Byte_GLCD_D_RHS;sets  x coordinate to 0     
    movf    page_R5, W, A ;automatically incriments the y-value so 
    call    Send_Byte_GLCD_D_RHS;sets  x coordinate to 0

    movlw   10111110B
    call    Send_Byte_GLCD_I_RHS;sets  x coordinate to 6 
    movlw   01111011B  ;sets y coord to 60
    call    Send_Byte_GLCD_I_RHS
    movf    page_R6, W, A ;ouputs the first byte to the glcd
    call    Send_Byte_GLCD_D_RHS;sets  x coordinate to 0     
    movf    page_R6, W, A ;automatically incriments the y-value so 
    call    Send_Byte_GLCD_D_RHS;sets  x coordinate to 0 
    
    movlw   10111111B
    call    Send_Byte_GLCD_I_RHS;sets  x coordinate to 7 
    movlw   01111011B  ;sets y coord to 60
    call    Send_Byte_GLCD_I_RHS
    movf    page_R7, W, A ;ouputs the first byte to the glcd
    call    Send_Byte_GLCD_D_RHS;sets  x coordinate to 0     
    movf    page_R7, W, A ;automatically incriments the y-value so 
    call    Send_Byte_GLCD_D_RHS;sets  x coordinate to 0 
    
    return
    
    
paddle_R_draw: ;prints a paddle of size paddle_L_size 
    call    clear_paddle_R ;clears all bytes needed to be displayed
    movff   paddle_R_size,counter3, A
    movff   paddle_R_x, paddle_current_x, A
    
draw_R_loop:
    movf    paddle_current_x, W,A
    call    paddle_R_xpos
    movlw   1
    addwf   paddle_current_x, A
    decfsz  counter3, A
    bra     draw_R_loop 
    bra	    output_R_graphics
    
    


    

    


