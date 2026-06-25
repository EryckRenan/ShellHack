print "This block stuns most shells upon contact (except for multi bounce shells) & if shell is disco converts to a regular shell."

db $37
JMP Return : JMP Return : JMP Return : JMP Sprite
JMP Sprite : JMP Return : JMP Return : JMP Return
JMP Return : JMP Return : JMP Return : JMP Return
shells:						;table for sprite numbers
db $04,$05,$06,$07,$09,$0C	;green, red, blue and yellow koopa, green bouncing parakoopa, yellow parakoopa
Sprite:
	LDA !14C8,x				;sprite status
	CMP #$0B				;check if sprite gets carried
	BEQ Return				;do not run the code if sprite is being carried
	CMP #$08				;check if sprite is dead
	BCC Return				;do not run the code if sprite is dead
	CMP #$09
	BNE +	 				;check if sprite is stunned 
	LDA $5C 
	CMP #$01
	BEQ Return
+	LDA !15D0,x				;do not run the code if Yoshi is about to eat it
	BNE Return				;
	LDA !9E,x				;load sprite number
	PHX						;Push sprite number
	LDX #$05				;loop counter (table size -1)
	.loop:					;start of loop
	CMP shells,x			;check if sprite is a koopa
	BEQ TurnIntoDisco		;branch if sprite is a koopa
	DEX						;decrease X
	BPL .loop				;branch if plus value, so loop runs only 4 times
	PLX
RTL
TurnIntoDisco:
	PLX
	LDA #$00				; sprite speed
	STA !B6,x
	LDA #$0A				; sprite status: kicked
	STA !14C8,x
	LDA #$01
	STA $5C
Return:
RTL
