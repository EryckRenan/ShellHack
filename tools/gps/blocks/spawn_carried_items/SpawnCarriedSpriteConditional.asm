; Spawn Carried Sprite (Conditional)
; Modified by Cracka

; Based on Carryable Sprite Spawner Blocks Pack
; By Nowieso

; Set block to act as 25

!sfx 			= $10
!sfx_bank		= $1DF9

; Sprite Properties
!ActAsSprite	= $04			; $04 = Green, $05 = Red, $06 = Blue, $07 = Yellow
!Custom			= 0				; 0 = Vanilla, 1 = Custom
!Status			= $0B			; 08 = Normal Routine, 09 = Stationary / Carryable, 0A = Kicked, 0B = Being Carried
!Disco			= 0				; 0 = No, 1 = Yes
!Ghost			= 0				; 0 = No, 1 = Yes. If Carry = 1, Set As 1

; Conditions - Don't Run Code If...
!Carry			= 0				; Player Is Carrying Something. 0 = Don't Allow, 1 = Allow
!Yoshi			= 0				; Player Is Riding Yoshi. 0 = Don't Allow, 1 = Allow

!JumpType		= 0				; Player Spin Jump Type. 0 = Allow Both (Vanilla), 1 = Don't Allow Normal Jump (Or On Ground), 2 = Don't Allow Spin Jumping
!OnOff			= 0				; ON/OFF Switch. 0 = Allow Both (Vanilla), 1 = Don't Allow ON State, 2 = Don't Allow OFF State
!Star 			= 0				; Player Has (Active) Star Power. 0 = Vanilla, 1 = Don't Allow When Inactive, 2 = Don't Allow When Active
!PSwitch		= 0				; Player Has (Actived) Blue/Silver P-Switch. 0 = Vanilla, 1 = Don't Allow When Inactive, 2 = Don't Allow When Active

db $37

JMP Mario : JMP Mario : JMP Mario : JMP Return
JMP Return : JMP Return : JMP Return : JMP Mario
JMP Mario : JMP Mario : JMP Return : JMP Return

Mario:

; BEQ Conditions (is zero)

	if !JumpType == 1
		LDA $140D|!addr
		BEQ Return				; Not spin jumping
	endif

	if !OnOff == 1
		LDA $14AF|!addr
		BEQ Return				; Switch State On
	endif

	if !Star == 1
		LDA $1490|!addr
		BEQ Return				; Star inactive
	endif

	if !PSwitch == 1
		LDA $14AB|!addr
		BEQ Return				; P-Switch inactive
	endif

	if !Yoshi == 0
		ORA $187A|!addr
	endif

; BNE Conditions (non-zero)

	LDA #$00

	if !Carry == 0
		ORA $1470|!addr
	endif

	if !Carry == 0
		ORA $148F|!addr
	endif

	if !JumpType == 2
		ORA $140D|!addr
	endif

	if !OnOff == 2
		ORA $14AF|!addr
	endif

	if !Star == 2
		ORA $1490|!addr
	endif

	if !PSwitch == 2
		ORA $14AB|!addr
	endif

BNE Return

checkInput:
	LDA $15
	BIT #$40
	BEQ Return

spawnSprite:
	LDA #!ActAsSprite			;sprite number to spawn

if !Custom
	SEC 						; if custom sprite... use SEC
elseif !Custom == 0
	CLC							; if vanilla sprite... use CLC
endif

	%spawn_sprite()
	BCS Return
	%move_spawn_into_block()	; move sprite position to block

	LDA #!Status				; Sprite Status
	STA !14C8,x

if !Yoshi
	ORA #$08					; Allow Carrying Items While Riding Yoshi!
	STA !167A,x
endif

if !Ghost
	ORA #$08					; Remove Interaction With Other Sprites
	STA !1686,x
endif

if !Disco
	LDA #$01					; Make Disco Shell
	STA !187B,x
endif

destroyBlock:
	%erase_block()
	%glitter()
	LDA #!sfx
	STA !sfx_bank|!addr	

Return:
	RTL

print "This block spawns a carried sprite based on defined conditions. The block destroys itself afterwards."