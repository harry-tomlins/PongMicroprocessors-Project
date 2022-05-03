#include <xc.inc>

extrn	Send_Byte_GLCD_D_LHS, Send_Byte_GLCD_D_RHS, Send_Byte_GLCD_I_LHS, Send_Byte_GLCD_I_RHS, Clear_Screen
global	player_1_wins, player_2_wins

psect	udata_acs
	
ypos:	ds 1
ypost:	ds 1
    
psect	Print_Code,Class=CODE
    
player_1_wins:
    movlw   42
    movwf   ypos,A
    call    Clear_Screen
    movlw   10111011B
    call    Send_Byte_GLCD_I_LHS
    movlw   10111011B
    call    Send_Byte_GLCD_I_RHS
    movlw   01101111B
    call    Send_Byte_GLCD_I_LHS
    movlw   01101111B
    call    Send_Byte_GLCD_I_RHS
    call    printW
    call    printspace
    call    printI
    call    printspace
    call    printN
    call    printspace
    call    printN
    call    printspace
    call    printE
    call    printspace
    call    printR
    call    printspace
    call    printcolon
    movlw   43
    movwf   ypos,A
    movlw   10111101B
    call    Send_Byte_GLCD_I_LHS
    movlw   10111101B
    call    Send_Byte_GLCD_I_RHS
    movlw   01101110B
    call    Send_Byte_GLCD_I_LHS
    movlw   01101110B
    call    Send_Byte_GLCD_I_RHS
    call    printP
    call    printspace
    call    printL
    call    printspace
    call    printA
    call    printspace
    call    printY
    call    printspace
    call    printE
    call    printspace
    call    printR
    call    printspace
    call    printspace
    call    printspace
    call    print1
    
    goto    $
    
player_2_wins:
    movlw   42
    movwf   ypos,A
    call    Clear_Screen
    movlw   10111011B
    call    Send_Byte_GLCD_I_LHS
    movlw   10111011B
    call    Send_Byte_GLCD_I_RHS
    movlw   01101111B
    call    Send_Byte_GLCD_I_LHS
    movlw   01101111B
    call    Send_Byte_GLCD_I_RHS
    call    printW
    call    printspace
    call    printI
    call    printspace
    call    printN
    call    printspace
    call    printN
    call    printspace
    call    printE
    call    printspace
    call    printR
    call    printspace
    call    printcolon
    movlw   43
    movwf   ypos,A
    movlw   10111101B
    call    Send_Byte_GLCD_I_LHS
    movlw   10111101B
    call    Send_Byte_GLCD_I_RHS
    movlw   01101110B
    call    Send_Byte_GLCD_I_LHS
    movlw   01101110B
    call    Send_Byte_GLCD_I_RHS
    call    printP
    call    printspace
    call    printL
    call    printspace
    call    printA
    call    printspace
    call    printY
    call    printspace
    call    printE
    call    printspace
    call    printR
    call    printspace
    call    printspace
    call    printspace
    call    print2
    
    goto    $
	
printspace:
    btfss   ypos, 6, A
    call    printspace_L
    btfsc   ypos, 6, A
    call    printspace_R
    return
	
printspace_L:
    movff    ypos, ypost, A
    bcf	    ypost, 6, A
    movlw   01000000B
    addwf   ypost,W,A
    call    Send_Byte_GLCD_I_LHS
    movlw   11111111B
    call    Send_Byte_GLCD_D_LHS
    movlw   1
    addwf   ypos, F, A
    return
    
printspace_R:
    movff    ypos, ypost, A
    bcf	    ypost, 6, A
    movlw   01000000B
    addwf   ypost,W,A
    call    Send_Byte_GLCD_I_RHS
    movlw   11111111B
    call    Send_Byte_GLCD_D_RHS
    movlw   1
    addwf   ypos, F, A
    return
	
print1:
    btfss   ypos, 6, A
    call    print1_L
    btfsc   ypos, 6, A
    call    print1_R
    return
	
print1_L:
    movff    ypos, ypost, A
    bcf	    ypost, 6, A
    movlw   01000000B
    addwf   ypost,W,A
    call    Send_Byte_GLCD_I_LHS
    movlw   01111101B
    call    Send_Byte_GLCD_D_LHS
    movlw   0x00
    call    Send_Byte_GLCD_D_LHS
    movlw   01111111B
    call    Send_Byte_GLCD_D_LHS
    movlw   3
    addwf   ypos, F, A
    return
	
print1_R:
    movff    ypos, ypost, A
    bcf	    ypost, 6, A
    movlw   01000000B
    addwf   ypost,W,A
    call    Send_Byte_GLCD_I_RHS
    movlw   01111101B
    call    Send_Byte_GLCD_D_RHS
    movlw   0x00
    call    Send_Byte_GLCD_D_RHS
    movlw   01111111B
    call    Send_Byte_GLCD_D_RHS
    movlw   3
    addwf   ypos, F, A
    return
	
print2:
    btfss   ypos, 6, A
    call    print2_L
    btfsc   ypos, 6, A
    call    print2_R
    return

print2_L:
    movff    ypos, ypost, A
    bcf	    ypost, 6, A
    movlw   01000000B
    addwf   ypost,W,A
    call    Send_Byte_GLCD_I_LHS
    movlw   00011101B
    call    Send_Byte_GLCD_D_LHS
    movlw   01101110B
    call    Send_Byte_GLCD_D_LHS
    movlw   01110110B
    call    Send_Byte_GLCD_D_LHS
    movlw   01111001B
    call    Send_Byte_GLCD_D_LHS
    movlw   4
    addwf   ypos, F, A
    return

print2_R:
    movff    ypos, ypost, A
    bcf	    ypost, 6, A
    movlw   01000000B
    addwf   ypost,W,A
    call    Send_Byte_GLCD_I_RHS
    movlw   00011101B
    call    Send_Byte_GLCD_D_RHS
    movlw   01101110B
    call    Send_Byte_GLCD_D_RHS
    movlw   01110110B
    call    Send_Byte_GLCD_D_RHS
    movlw   01111001B
    call    Send_Byte_GLCD_D_RHS
    movlw   4
    addwf   ypos, F, A
    return
	
printA:
    btfss   ypos, 6, A
    call    printA_L
    btfsc   ypos, 6, A
    call    printA_R
    return
    
printA_L:
    movff    ypos, ypost, A
    bcf	    ypost, 6, A
    movlw   01000000B
    addwf   ypost,W,A
    call    Send_Byte_GLCD_I_LHS
    movlw   00000011B
    call    Send_Byte_GLCD_D_LHS
    movlw   11011100B
    call    Send_Byte_GLCD_D_LHS
    movlw   11011100B
    call    Send_Byte_GLCD_D_LHS
    movlw   00000011B
    call    Send_Byte_GLCD_D_LHS
    movlw   4
    addwf   ypos, F, A
    return
    
printA_R:
    movff    ypos, ypost, A
    bcf	    ypost, 6, A
    movlw   01000000B
    addwf   ypost,W,A
    call    Send_Byte_GLCD_I_RHS
    movlw   00000011B
    call    Send_Byte_GLCD_D_RHS
    movlw   11011100B
    call    Send_Byte_GLCD_D_RHS
    movlw   11011100B
    call    Send_Byte_GLCD_D_RHS
    movlw   00000011B
    call    Send_Byte_GLCD_D_RHS
    movlw   4
    addwf   ypos, F, A
    return
	
printE:
    btfss   ypos, 6, A
    call    printE_L
    btfsc   ypos, 6, A
    call    printE_R
    return
    
printE_L:
    movff    ypos, ypost, A
    bcf	    ypost, 6, A
    movlw   01000000B
    addwf   ypost,W,A
    call    Send_Byte_GLCD_I_LHS
    movlw   0x00
    call    Send_Byte_GLCD_D_LHS
    movlw   01110110B
    call    Send_Byte_GLCD_D_LHS
    movlw   01110110B
    call    Send_Byte_GLCD_D_LHS
    movlw   01110110B
    call    Send_Byte_GLCD_D_LHS
    movlw   4
    addwf   ypos, F, A
    return
    
printE_R:
    movff    ypos, ypost, A
    bcf	    ypost, 6, A
    movlw   01000000B
    addwf   ypost,W,A
    call    Send_Byte_GLCD_I_RHS
    movlw   0x00
    call    Send_Byte_GLCD_D_RHS
    movlw   01110110B
    call    Send_Byte_GLCD_D_RHS
    movlw   01110110B
    call    Send_Byte_GLCD_D_RHS
    movlw   01110110B
    call    Send_Byte_GLCD_D_RHS
    movlw   4
    addwf   ypos, F, A
    return
	
printI:
    btfss   ypos, 6, A
    call    printI_L
    btfsc   ypos, 6, A
    call    printI_R
    return

printI_L:
    movff    ypos, ypost, A
    bcf	    ypost, 6, A
    movlw   01000000B
    addwf   ypost,W,A
    call    Send_Byte_GLCD_I_LHS
    movlw   01111110B
    call    Send_Byte_GLCD_D_LHS
    movlw   0x00
    call    Send_Byte_GLCD_D_LHS
    movlw   01111110B
    call    Send_Byte_GLCD_D_LHS
    movlw   3
    addwf   ypos, F, A
    return

printI_R:
    movff    ypos, ypost, A
    bcf	    ypost, 6, A
    movlw   01000000B
    addwf   ypost,W,A
    call    Send_Byte_GLCD_I_RHS
    movlw   01111110B
    call    Send_Byte_GLCD_D_RHS
    movlw   0x00
    call    Send_Byte_GLCD_D_RHS
    movlw   01111110B
    call    Send_Byte_GLCD_D_RHS
    movlw   3
    addwf   ypos, F, A
    return
	
printL:
    btfss   ypos, 6, A
    call    printL_L
    btfsc   ypos, 6, A
    call    printL_R
    return
    
printL_L:
    movff    ypos, ypost, A
    bcf	    ypost, 6, A
    movlw   01000000B
    addwf   ypost,W,A
    call    Send_Byte_GLCD_I_LHS
    movlw   0x00
    call    Send_Byte_GLCD_D_LHS
    movlw   01111111B
    call    Send_Byte_GLCD_D_LHS
    movlw   01111111B
    call    Send_Byte_GLCD_D_LHS
    movlw   01111111B
    call    Send_Byte_GLCD_D_LHS
    movlw   4
    addwf   ypos, F, A
    return
    
printL_R:
    movff    ypos, ypost, A
    bcf	    ypost, 6, A
    movlw   01000000B
    addwf   ypost,W,A
    call    Send_Byte_GLCD_I_RHS
    movlw   0x00
    call    Send_Byte_GLCD_D_RHS
    movlw   01111111B
    call    Send_Byte_GLCD_D_RHS
    movlw   01111111B
    call    Send_Byte_GLCD_D_RHS
    movlw   01111111B
    call    Send_Byte_GLCD_D_RHS
    movlw   4
    addwf   ypos, F, A
    return
	
printN:
    btfss   ypos, 6, A
    call    printN_L
    btfsc   ypos, 6, A
    call    printN_R
    return
    
printN_L:
    movff    ypos, ypost, A
    bcf	    ypost, 6, A
    movlw   01000000B
    addwf   ypost,W,A
    call    Send_Byte_GLCD_I_LHS
    movlw   0x00
    call    Send_Byte_GLCD_D_LHS
    movlw   11111001B
    call    Send_Byte_GLCD_D_LHS
    movlw   11100111B
    call    Send_Byte_GLCD_D_LHS
    movlw   10011111B
    call    Send_Byte_GLCD_D_LHS
    movlw   0x00
    call    Send_Byte_GLCD_D_LHS
    movlw   5
    addwf   ypos, F, A
    return
    
printN_R:
    movff    ypos, ypost, A
    bcf	    ypost, 6, A
    movlw   01000000B
    addwf   ypost,W,A
    call    Send_Byte_GLCD_I_RHS
    movlw   0x00
    call    Send_Byte_GLCD_D_RHS
    movlw   11111001B
    call    Send_Byte_GLCD_D_RHS
    movlw   11100111B
    call    Send_Byte_GLCD_D_RHS
    movlw   10011111B
    call    Send_Byte_GLCD_D_RHS
    movlw   0x00
    call    Send_Byte_GLCD_D_RHS
    movlw   5
    addwf   ypos, F, A
    return
	
printP:
    btfss   ypos, 6, A
    call    printP_L
    btfsc   ypos, 6, A
    call    printP_R
    return
   
printP_L:
    movff    ypos, ypost, A
    bcf	    ypost, 6, A
    movlw   01000000B
    addwf   ypost,W,A
    call    Send_Byte_GLCD_I_LHS
    movlw   0x00
    call    Send_Byte_GLCD_D_LHS
    movlw   11110110B
    call    Send_Byte_GLCD_D_LHS
    movlw   11110110B
    call    Send_Byte_GLCD_D_LHS
    movlw   11111001B
    call    Send_Byte_GLCD_D_LHS
    movlw   4
    addwf   ypos, F, A
    return
   
printP_R:
    movff    ypos, ypost, A
    bcf	    ypost, 6, A
    movlw   01000000B
    addwf   ypost,W,A
    call    Send_Byte_GLCD_I_RHS
    movlw   0x00
    call    Send_Byte_GLCD_D_RHS
    movlw   11110110B
    call    Send_Byte_GLCD_D_RHS
    movlw   11110110B
    call    Send_Byte_GLCD_D_RHS
    movlw   11111001B
    call    Send_Byte_GLCD_D_RHS
    movlw   4
    addwf   ypos, F, A
    return
	
printR:
    btfss   ypos, 6, A
    call    printR_L
    btfsc   ypos, 6, A
    call    printR_R
    return
    
printR_L:
    movff   ypos, ypost, A
    bcf	    ypost, 6, A
    movlw   01000000B
    addwf   ypost,W,A
    call    Send_Byte_GLCD_I_LHS
    movlw   0x00
    call    Send_Byte_GLCD_D_LHS
    movlw   11001110B
    call    Send_Byte_GLCD_D_LHS
    movlw   10110110B
    call    Send_Byte_GLCD_D_LHS
    movlw   01111001B
    call    Send_Byte_GLCD_D_LHS
    movlw   4
    addwf   ypos, F, A
    return
    
printR_R:
    movff    ypos, ypost, A
    bcf	    ypost, 6, A
    movlw   01000000B
    addwf   ypost,W,A
    call    Send_Byte_GLCD_I_RHS
    movlw   0x00
    call    Send_Byte_GLCD_D_RHS
    movlw   11001110B
    call    Send_Byte_GLCD_D_RHS
    movlw   10110110B
    call    Send_Byte_GLCD_D_RHS
    movlw   01111001B
    call    Send_Byte_GLCD_D_RHS
    movlw   4
    addwf   ypos, F, A
    return
	
printW:
    btfss   ypos, 6, A
    call    printW_L
    btfsc   ypos, 6, A
    call    printW_R
    return
    
printW_L:
    movff    ypos, ypost, A
    bcf	    ypost, 6, A
    movlw   01000000B
    addwf   ypost,W,A
    call    Send_Byte_GLCD_I_LHS
    movlw   11000000B
    call    Send_Byte_GLCD_D_LHS
    movlw   00111111B
    call    Send_Byte_GLCD_D_LHS
    movlw   11000001B
    call    Send_Byte_GLCD_D_LHS
    movlw   00111111B
    call    Send_Byte_GLCD_D_LHS
    movlw   11000000B
    call    Send_Byte_GLCD_D_LHS
    movlw   5
    addwf   ypos, F, A
    return
    
printW_R:
    movff    ypos, ypost, A
    bcf	    ypost, 6, A
    movlw   01000000B
    addwf   ypost,W,A
    call    Send_Byte_GLCD_I_RHS
    movlw   11000000B
    call    Send_Byte_GLCD_D_RHS
    movlw   00111111B
    call    Send_Byte_GLCD_D_RHS
    movlw   11000001B
    call    Send_Byte_GLCD_D_RHS
    movlw   00111111B
    call    Send_Byte_GLCD_D_RHS
    movlw   11000000B
    call    Send_Byte_GLCD_D_RHS
    movlw   5
    addwf   ypos, F, A
    return
	
printY:
    btfss   ypos, 6, A
    call    printY_L
    btfsc   ypos, 6, A
    call    printY_R
    return
    
printY_L:
    movff    ypos, ypost, A
    bcf	    ypost, 6, A
    movlw   01000000B
    addwf   ypost,W,A
    call    Send_Byte_GLCD_I_LHS
    movlw   11111100B
    call    Send_Byte_GLCD_D_LHS
    movlw   11110011B
    call    Send_Byte_GLCD_D_LHS
    movlw   00001111B
    call    Send_Byte_GLCD_D_LHS
    movlw   11110011B
    call    Send_Byte_GLCD_D_LHS
    movlw   11111100B
    call    Send_Byte_GLCD_D_LHS
    movlw   5
    addwf   ypos, F, A
    return
    
printY_R:
    movff    ypos, ypost, A
    bcf	    ypost, 6, A
    movlw   01000000B
    addwf   ypost,W,A
    call    Send_Byte_GLCD_I_RHS
    movlw   11111100B
    call    Send_Byte_GLCD_D_RHS
    movlw   11110011B
    call    Send_Byte_GLCD_D_RHS
    movlw   00001111B
    call    Send_Byte_GLCD_D_RHS
    movlw   11110011B
    call    Send_Byte_GLCD_D_RHS
    movlw   11111100B
    call    Send_Byte_GLCD_D_RHS
    movlw   5
    addwf   ypos, F, A
    return
    
printcolon:
    btfss   ypos, 6, A
    call    printcolon_L
    btfsc   ypos, 6, A
    call    printcolon_R
    return
	
printcolon_L:
    movff    ypos, ypost, A
    bcf	    ypost, 6, A
    movlw   01000000B
    addwf   ypost,W,A
    call    Send_Byte_GLCD_I_LHS
    movlw   10011001B
    call    Send_Byte_GLCD_D_LHS
    movlw   10011001B
    call    Send_Byte_GLCD_D_LHS
    movlw   2
    addwf   ypos, F, A
    return
    
printcolon_R:
    movff    ypos, ypost, A
    bcf	    ypost, 6, A
    movlw   01000000B
    addwf   ypost,W,A
    call    Send_Byte_GLCD_I_RHS
    movlw   10011001B
    call    Send_Byte_GLCD_D_RHS
    movlw   10011001B
    call    Send_Byte_GLCD_D_RHS
    movlw   1
    addwf   ypos, F, A
    return