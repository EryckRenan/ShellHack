; Modified by SJandCharlieTheCat

!StunTimer = $FF ; for bobomb, galoomba, etc.

!sfx 			 = $10
!sfx_bank		 = $1DF9
!shelltype       = $00          ; MultiBounceShell sprite number (green)

db $37
JMP Mario : JMP Mario : JMP Mario : JMP Return
JMP Return : JMP Return : JMP Return : JMP Mario
JMP Mario : JMP Mario : JMP Return : JMP Return

PSwitchPal:      db $06,$02

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
    CMP #$4F 
    BNE Return2
    LDA #!shelltype             ; Sprite number to spawn
    SEC                         ; SEC = Custom sprite
    %spawn_sprite()
    BCS Return
    %move_spawn_into_block()    ; Move sprite position to block
      ; Set sprite status to carried
    LDA #$0B
    STA !14C8,x                 ; $0B = carried state
    
    ; Set extension byte 1 for bounce count
    LDA #$01                    ; $01 = one bounce
    STA !7FAB40,x               ; First extension byte ($7FAB40 = Pixi's extension byte table)
    
    ; Initialize !1510 to prevent premature destruction
    LDA #$01                    ; MultiBounce Shell
    STA !1510,x                 ; Internal state counter of the shell
    BRA Return2

Return2:
	RTL
	
;11 beetle (not used)
	
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
