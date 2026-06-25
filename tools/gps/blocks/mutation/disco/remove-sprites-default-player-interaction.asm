; Author: Cracka
; Based On: Disco Block By Nowieso, swunsh_

db $37

JMP Return : JMP Return : JMP Return : JMP Sprite
JMP Sprite : JMP Return : JMP Return : JMP Return
JMP Return : JMP Return : JMP Return : JMP Return
shells:							;table for sprite numbers
db $04,$05,$06,$07,$09,$0C,$AB		;green, red, blue and yellow koopa, green bouncing parakoopa, yellow parakoopa
Sprite:
	LDA !14C8,x					;sprite status
	CMP #$0B					;check if sprite gets carried
	BEQ Return					;do not run the code if sprite is being carried
	CMP #$08					;check if sprite is dead
	BCC Return					;do not run the code if sprite is dead
	LDA !15D0,x					;do not run the code if Yoshi is about to eat it
	BNE Return
	LDA !9E,x					;load sprite number
	PHX							;Push sprite number
	LDX #$05					;loop counter (table size -1)
	.loop:						;start of loop
	CMP shells,x				;check if sprite is a koopa
	BEQ RemoveSpriteInteraction	;branch if sprite is a koopa
	DEX							;decrease X
	BPL .loop					;branch if plus value, so loop runs only 4 times
	PLX
	RTL
RemoveSpriteInteraction:
	PLX
	LDA !167A,x 
	ORA #$80					; set tweaker bit to not use default interaction with Mario.
	STA !167A,x

Return:
	RTL

print "This block makes most sprites not use default interaction with the player after passing through."