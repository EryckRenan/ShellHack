;This code switches direction buttons with each other based on user defines.
;No credit needed (I appreciate it though :) ), just don't claim it as your own.
;Version: 1.0
;Made by: Nowieso
;Last Update: No updates yet
;----------------------------------------------------------------------------------
;Choose the type of code you want to use
; 0 let's the code always run while you are in the level
; 1 let's the code run depending on the state of the ON/OFF Switch
; 2 let's the code run depending on if a blue/silver P-Switch is currently active or not
; 3 let's the code run depending on if the player currently has star-power or not
; 4 let's the code run depending on if the player is riding Yoshi or not
; 5 let's the code run depending on if the player is in water or not
!typeCode = 0

;-----------------------------------------------------------------------------------
;Choose an option you want to use for switching buttons and change the values below.
; 0 switch left with right
; 1 switch left with up
; 2 switch left with down
; 3 switch right with up
; 4 switch right with down
; 5 switch up with down
; 6 normal
; 7 switch left with right AND up with down

;IF YOU CHOSE TYPE 0-----------------------------------------------------------
!choiceNormal = 7

;IF YOU CHOSE TYPE 1-----------------------------------------------------------
!choiceON = 6      ;option to use if the ON/OFF switch is currently ON
!choiceOFF = 6	 ;option to use if the ON/OFF switch is currently OFF

;IF YOU CHOSE TYPE 2-----------------------------------------------------------
!switchType = 0		 ;0 = Blue Switch, 1 = Silver Switch
!choiceActive = 6      ;option to use if the P-Switch is currently active
!choiceInactive = 6	 ;option to use if the P-Switch is currently inactive

;IF YOU CHOSE TYPE 3-----------------------------------------------------------
!choiceStarActive = 6      ;option to use if the player has currently star-power
!choiceStarInactive = 6	   ;option to use if the player has no star-power

;IF YOU CHOSE TYPE 4-----------------------------------------------------------
!choiceRiding = 6				;option to use if the player is riding Yoshi
!choiceNotRiding = 6			;option to use if the player is not riding Yoshi

;IF YOU CHOSE TYPE 5-----------------------------------------------------------
!choiceInWater = 6			;option to use if the player is in water
!choiceNotInWater = 6		;option to use if the player is not in water

;--------------------------------------------------------------------------------
;Don't touch these unless you know what you are doing
;Format: byetUDLR
;--------------------------------------------------------------------------------
!bits0 = %00000011
!bits1 = %00001010
!bits2 = %00000110
!bits3 = %00001001
!bits4 = %00000101
!bits5 = %00001100
;-----------------------------------------------------------------------------------
;START OF THE ACTUAL CODE
;-----------------------------------------------------------------------------------
main:
!choice2 = 6					;without this define, UberASM does not read other values for !choice2
if !typeCode == 0
	!choice = !choiceNormal
elseif !typeCode == 1
	!choice = !choiceON
	!choice2 = !choiceOFF
	LDA $14AF|!addr
	BNE choiceNo						; if switch is OFF, branch
elseif !typeCode == 2
		!choice = !choiceActive
		!choice2 = !choiceInactive
	if !switchType == 0
		LDA $14AD|!addr 				;blue switch timer
		BEQ choiceNo 					;if P is not active, branch
	else
		LDA $14AE|!addr 				;silver switch timer
		BEQ choiceNo 					;if P is not active, branch
	endif
elseif !typeCode == 3
	!choice = !choiceStarActive
	!choice2 = !choiceStarInactive
	LDA $1490|!addr
	BEQ choiceNo						;if player has no star-power, branch
elseif !typeCode == 4
	!choice = !choiceRiding
	!choice2 = !choiceNotRiding
	LDA $187A|!addr
	BEQ choiceNo						;if player is not riding Yoshi, branch
elseif !typeCode == 5
	!choice = !choiceInWater
	!choice2 = !choiceNotInWater
	LDA $75
	BEQ choiceNo						;if player is not in water, branch
endif
;Switch controls:---------------------------------------------------------
choiceYes:
	if !choice == 7
		LDA $15
		BIT #!bits0
		BEQ Switch  ;if buttons are not pressed, branch
		EOR #!bits0 ;switch the buttons
		STA $15
		Switch:
		LDA $16
		BIT #!bits0
		BEQ Switch2 ;if buttons are not pressed, branch
		EOR #!bits0 ;switch the buttons
		STA $16
		Switch2:
		LDA $15
		BIT #!bits5
		BEQ Switch3 ;if buttons are not pressed, branch
		EOR #!bits5 ;switch the buttons
		STA $15
		Switch3:
		LDA $16
		BIT #!bits5
		BEQ endCode ;if buttons are not pressed, branch
		EOR #!bits5 ;switch the buttons
		STA $16
		endCode:
		RTL
	elseif !choice == 6
		RTL
	else
		!bits = !{bits!choice} ;gives !bits the value for the bit defines
		LDA $15
		BIT #!bits
		BEQ + ;if buttons are not pressed, branch
		EOR #!bits ;switch the buttons
		STA $15
		+
		LDA $16
		BIT #!bits
		BEQ + ;if buttons are not pressed, branch
		EOR #!bits ;switch the buttons
		STA $16
		+
		RTL
	endif

choiceNo:
	if !choice2 == 7
		LDA $15
		BIT #!bits0
		BEQ Switch  ;if buttons are not pressed, branch
		EOR #!bits0 ;switch the buttons
		STA $15
		Switch:
		LDA $16
		BIT #!bits0
		BEQ Switch2 ;if buttons are not pressed, branch
		EOR #!bits0 ;switch the buttons
		STA $16
		Switch2:
		LDA $15
		BIT #!bits5
		BEQ Switch3 ;if buttons are not pressed, branch
		EOR #!bits5 ;switch the buttons
		STA $15
		Switch3:
		LDA $16
		BIT #!bits5
		BEQ endCode ;if buttons are not pressed, branch
		EOR #!bits5 ;switch the buttons
		STA $16
		endCode:
		RTL
	elseif !choice2 == 6
		RTL
	else
		!bits = !{bits!choice2} ;gives !bits the value for the bit defines
		LDA $15
		BIT #!bits
		BEQ + ;if buttons are not pressed, branch
		EOR #!bits ;switch the buttons
		STA $15
		+
		LDA $16
		BIT #!bits
		BEQ + ;if buttons are not pressed, branch
		EOR #!bits ;switch the buttons
		STA $16
		+
		RTL
	endif