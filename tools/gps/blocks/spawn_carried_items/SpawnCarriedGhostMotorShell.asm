!sfx 			 = $10
!sfx_bank		 = $1DF9
!shelltype		 = $03			;$04 = green, $05 = red, $06 = blue, $07 = yellow
db $37
JMP Mario : JMP Mario : JMP Mario : JMP Return
JMP Return : JMP Return : JMP Return : JMP Mario
JMP Mario : JMP Mario : JMP Return : JMP Return
Mario:
	LDA $1470|!addr				;do not run the code if player is carrying something
	ORA $148F|!addr				;do not run the code if player is carrying something
	ORA $187A|!addr				;do not run the code if player is riding yoshi
	ORA $74						;do not run the code if player is climbing
	BNE Return
checkInput:
	LDA $15
	BIT #$40
	BEQ Return
spawnSprite:
	LDA #!shelltype				;sprite number to spawn
	SEC
	%spawn_sprite()
	BCS Return
	%move_spawn_into_block()	;move sprite position to block
	LDA #$0B		
	STA !14C8,x					;sprite carried status
	LDA !1686,x 
	ORA #$08					; remove interaction with other sprites
	STA !1686,x
destroyBlock:
	%erase_block()
	%glitter()
	LDA #!sfx
	STA !sfx_bank|!addr	
Return:
RTL
print "This block spawns a motor shell that is automatically carried and destroys itself afterwards."