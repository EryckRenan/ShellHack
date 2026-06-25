; Four Tile Centered 32x32 Spawn Carried Shell (Top Right)
; By Cracka

; Act As 0025

; Based off Carryable Sprite Spawner Blocks Pack By Nowieso
;	32x32 Key Lock Block By HammerBrother
;	& Pixel Perfect Spike By MarioFanGamer

!SoundEffect	= $10
!Bank			= $1DF9
!AfterFX		= 1				; 0 = Don't Use Effect, 1 = Glitter, 2 = Smoke
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

;		LDX #$03		;\Fix a bug where if mario is sliding
;	-	STZ $17C0|!addr,x		;|and unlocks the block, one of the smoke
;		DEX			;|is missing
;		BPL -			;/

;	if !Glitter
;		%glitter()
;	endif

	if !AfterFX == 0
		BRA +
	elseif !AfterFX == 1
		%glitter()
		BRA +
	elseif !AfterFX == 2
		%create_smoke()
	endif
+

	%erase_block()

	PLY

	REP #$20
	LDY #$04		;>Start loop
-
	SEP #$20		;>Because this subroutine is 8-bit mode
	%swap_XY()		;>Vertical levels have their $99 and $9B swapped.
	REP #$21		;>Even with PLP, this needed to prevent game crashes.

	LDA $9A			;\Shift X position
	ADC XPosShft,y		;|
	STA $9A			;/

	LDA $98			;\Shift Y position
	CLC			;|
	ADC YPosShft,y		;|
	STA $98			;/

	PHY
	SEP #$20

;	if !Glitter
;		%glitter()
;	endif

	if !AfterFX == 0
		BRA +
	elseif !AfterFX == 1
		%glitter()
		BRA +
	elseif !AfterFX == 2
		%create_smoke()
	endif
+

	%erase_block()

	REP #$20
	PLY

	DEY			;\next pair of bytes
	DEY			;/
	BPL -			;>if >= 0, loop.
	SEP #$20

	LDY #$00		;\Right when it disappears, shouldn't stop the player's
	LDA #$25		;|movement.
	STA $1693|!addr		;/

	LDA #!SoundEffect			;\Play sfx.
	STA !Bank

	RTL

Miss:
	PLY
	RTL

XPosShft:
	dw $0010,$0000,$FFF0
YPosShft:
	dw $0000,$0010,$0000

Bitflags:
	dw $8000,$4000,$2000,$1000,$0800,$0400,$0200,$0100
	dw $0080,$0040,$0020,$0010,$0008,$0004,$0002,$0001

SpikeHitbox:
	dw %0000000000000000
	dw %0000000000000000
	dw %0000000000000000
	dw %0000000000000000
	dw %0000000000000000
	dw %0000000000000000
	dw %0000000000000000
	dw %1100000000000000
	dw %1110000000000000
	dw %1111100000000000
	dw %1111110000000000
	dw %1111110000000000
	dw %1111111000000000
	dw %1111111000000000
	dw %1111111000000000

print "Upper right tile of the four-tile centered 32x32 spawn carried shell."