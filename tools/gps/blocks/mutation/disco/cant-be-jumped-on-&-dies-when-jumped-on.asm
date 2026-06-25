; Author: Cracka
; Based On: Disco Block By Nowieso, swunsh_

db $37

JMP Return : JMP Return : JMP Return : JMP Sprite
JMP Sprite : JMP Return : JMP Return : JMP Return
JMP Return : JMP Return : JMP Return : JMP Return
shells:							;table for sprite numbers
db $04,$05,$06,$07,$09,$0C		;green, red, blue and yellow koopa, green bouncing parakoopa, yellow parakoopa
Sprite:
	LDA !9E,x					;load sprite number
	PHX							;Push sprite number
	PLX
	LDA !1656,x 
	ORA #$20					; set tweaker bit to not use default interaction with Mario.
	STA !1656,x

Return:
	RTL

print "This block makes most sprites not use default interaction with the player after passing through."