; Two Tile Wide 32x16 Spawn Carried Shell (Left)
; By Cracka

; Act As 0025

; Based off Carryable Sprite Spawner Blocks Pack By Nowieso
;	WideShatterBlock-L By SJC
;	& Pixel Perfect Spike By MarioFanGamer

!SoundEffect	= $10
!Bank			= $1DF9
!Glitter		= 1				; 1=Use Effect, 0=Don't Use Effect
!SpawnSprite	= $06			; $04 = green, $05 = red, $06 = blue, $07 = yellow, if spawning custom sprite... set !customSprite = 1
!CustomSprite	= 0				; 1 = above sprite number is custom

db $42

JMP MarioBelow : JMP MarioAbove : JMP MarioSide : JMP SpriteV : JMP SpriteH
JMP MarioCape : JMP MarioFireBall : JMP TopCorner : JMP BodyInside : JMP HeadInside

MarioSide:
HeadInside:
MarioFireBall:
BodyInside:
Return:
	RTL

MarioAbove:
TopCorner:
MarioBelow:
	LDA $1470|!addr				;do not run the code if player is carrying something
	ORA $148F|!addr				;do not run the code if player is carrying something
	ORA $187A|!addr				;do not run the code if player is riding yoshi
	ORA $74						;do not run the code if player is climbing
	BNE Return
	BRA CheckInput
	RTL

SpriteH:
	RTL

SpriteV:
	RTL

MarioCape:

CheckInput:
	LDA $15
	BIT #$40
	BEQ Return

CoinCheck:
	PHY
	LDA $98
	AND #$0F
	ASL
	TAY
	LDA $9A
	AND #$0F
	ASL
	TAX
	REP #$20
	LDA SpikeHitbox,y
	AND Bitflags,x
	SEP #$20
	BEQ Miss

; If Hit, Do This...

	LDA #!SpawnSprite			; sprite number to spawn

	if !CustomSprite
		SEC						; use SEC for custom sprites

	else
		CLC						; use CLC for vanilla sprites

	endif

	%spawn_sprite()
	BCS Return
	%move_spawn_into_block()	; move sprite position to block

	LDA #$0B					; sprite status: carried
	STA !14C8,x

	if !Glitter
		%glitter()
	endif

	%erase_block()

	PLY

	REP #$20					;\Move 1 block right.
	LDA $9A						;|
	CLC : ADC #$0010			;|
	STA $9A						;|
	SEP #$20					;/

	if !Glitter
		%glitter()
	endif

	%erase_block()

	LDA #!SoundEffect			;\Play sfx.
	STA !Bank

	RTL

Miss:
	PLY
	RTL

Bitflags:
	dw $8000,$4000,$2000,$1000,$0800,$0400,$0200,$0100
	dw $0080,$0040,$0020,$0010,$0008,$0004,$0002,$0001

SpikeHitbox:
	dw %0000000000000011
	dw %0000000000000111
	dw %0000000000011111
	dw %0000000000111111
	dw %0000000000111111
	dw %0000000001111111
	dw %0000000001111111
	dw %0000000001111111
	dw %0000000000111111
	dw %0000000001111111
	dw %0000000011111111
	dw %0000000011111111
	dw %0000000011111111
	dw %0000000001111111
	dw %0000000000111111
	dw %0000000000001111

print "Left tile of the two-tile wide 32x16 spawn carried shell."