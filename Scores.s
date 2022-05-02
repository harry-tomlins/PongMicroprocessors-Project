#include <xc.inc>
global	L_score,R_score,L_Score_Display,R_Score_Display
extrn	Score_0_LHS,Score_1_LHS,Score_2_LHS,Score_3_LHS,Score_4_LHS,Score_5_LHS,Score_6_LHS,Score_7_LHS,Score_8_LHS,Score_9_LHS,Score_0_RHS,Score_1_RHS,Score_2_RHS,Score_3_RHS
extrn	Score_4_RHS,Score_5_RHS,Score_6_RHS,Score_7_RHS,Score_8_RHS,Score_9_RHS
extrn	player_1_wins, player_2_wins
    
psect	udata_acs
	
L_score:    ds 1
R_score:    ds 1
    
psect	Score_Code,Class=CODE
    

L_Score_Display:
    movf    L_score,W,A
    sublw   0
    bz	    Score_0_L
    movf    L_score,W,A
    sublw   1
    bz	    Score_1_L
    movf    L_score,W,A
    sublw   2
    bz	    Score_2_L    
    movf    L_score,W,A
    sublw   3
    bz	    Score_3_L       
    movf    L_score,W,A
    sublw   4
    bz	    Score_4_L
    movf    L_score,W,A
    sublw   5
    bz	    Score_5_L
    movf    L_score,W,A
    sublw   6
    bz	    Score_6_L
    movf    L_score,W,A
    sublw   7
    bz	    Score_7_L
    movf    L_score,W,A
    sublw   8
    bz	    Score_8_L
    movf    L_score,W,A
    sublw   9
    bz	    Score_9_L
    goto    player_1_wins ;if score is greater than 9 it will announce winner and stop running for now
    
Score_0_L:
    call    Score_0_LHS
    return
Score_1_L:
    call    Score_1_LHS
    return
Score_2_L:
    call    Score_2_LHS
    return
Score_3_L:
    call    Score_3_LHS
    return
Score_4_L:
    call    Score_4_LHS
    return
Score_5_L:
    call    Score_5_LHS
    return
Score_6_L:
    call    Score_6_LHS
    return
Score_7_L:
    call    Score_7_LHS
    return
Score_8_L:
    call    Score_8_LHS
    return
Score_9_L:
    call    Score_9_LHS
    return
    
R_Score_Display:
    movf    R_score,W,A
    sublw   0
    bz	    Score_0_R
    movf    R_score,W,A
    sublw   1
    bz	    Score_1_R
    movf    R_score,W,A
    sublw   2
    bz	    Score_2_R    
    movf    R_score,W,A
    sublw   3
    bz	    Score_3_R       
    movf    R_score,W,A
    sublw   4
    bz	    Score_4_R
    movf    R_score,W,A
    sublw   5
    bz	    Score_5_R
    movf    R_score,W,A
    sublw   6
    bz	    Score_6_R
    movf    R_score,W,A
    sublw   7
    bz	    Score_7_R
    movf    R_score,W,A
    sublw   8
    bz	    Score_8_R
    movf    R_score,W,A
    sublw   9
    bz	    Score_9_R
    goto    player_2_wins ;if score is greater than 9 it will announce winner and stop running for now
    
Score_0_R:
    call    Score_0_RHS
    return
Score_1_R:
    call    Score_1_RHS
    return
Score_2_R:
    call    Score_2_RHS
    return
Score_3_R:
    call    Score_3_RHS
    return
Score_4_R:
    call    Score_4_RHS
    return
Score_5_R:
    call    Score_5_RHS
    return
Score_6_R:
    call    Score_6_RHS
    return
Score_7_R:
    call    Score_7_RHS
    return
Score_8_R:
    call    Score_8_RHS
    return
Score_9_R:
    call    Score_9_RHS
    return