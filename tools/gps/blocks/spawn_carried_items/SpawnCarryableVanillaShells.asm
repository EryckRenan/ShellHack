; Spawn Carried Vanilla Shells
; Modified by Cracka & SJandCharlieTheCat
;
; Based on Carryable Sprite Spawner Blocks Pack
; By Nowieso

!sfx 			 = $10
!sfx_bank		 = $1DF9
!StunTimer = $FF                ; for bobomb, galoomba, etc.

db $37

JMP Mario : JMP Mario : JMP Mario : JMP Return
JMP Return : JMP Return : JMP Return : JMP Mario
JMP Mario : JMP Mario : JMP Return : JMP Return

NoTimer:
	CLC
	%spawn_sprite()
	BCS Return
	%move_spawn_into_block()	;move sprite position to block
	LDA #$0B		
    STA !14C8,x					;sprite carried status
destroyBlock:
	%erase_block()
	%glitter()
	LDA #!sfx
	STA !sfx_bank|!addr
Return:
    RTL

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
ArbitraryLabel:
    LDA $1693
    CPY #$00
    CMP #$49
    BNE Next
	LDA #$04					; green koopa shell
    BRA NoTimer
Next:
    LDA $1693
    CPY #$00
    CMP #$4A
    BNE Next2
	LDA #$05					; red koopa shell
    BRA NoTimer
Next2:
    LDA $1693
    CPY #$00
    CMP #$4B
    BNE Next3
	LDA #$06					; blue koopa shell
    BRA NoTimer
Next3:
    LDA $1693
    CPY #$00
    CMP #$4C
    BNE Next4
	LDA #$07					; yellow koopa shell
    BRA NoTimer
Next4:
    LDA $1693
    CPY #$00
    CMP #$4D
    BNE Next5
	LDA #$08					; green koopa shell (extra bounce)
    BRA NoTimer
Next5:
    LDA $1693
    CPY #$00
    CMP #$4E
    BNE Return2
    LDA #$11                    ; buzzy beetle
    BRA TimerSpawn
Return2:
	RTL

TimerSpawn:	
	CLC
	%spawn_sprite()
	BCS Return2
	%move_spawn_into_block()	;move sprite position to block
	LDA #$0B		
    STA !14C8,x			;sprite carried status
	LDA #!StunTimer
	STA !1540,x

destroyBlock2:
	%erase_block()
	%glitter()
	LDA #!sfx
	STA !sfx_bank|!addr	
    RTL

print "This block spawns a sprite, automatically carried, with the block erasing itself afterwards. Note that the bobomb and mechakoopa require the correct sprite GFX to display properly."
