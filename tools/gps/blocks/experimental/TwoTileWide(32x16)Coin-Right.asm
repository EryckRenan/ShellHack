; Two Tile Wide 32x16 Coin (Right)
; By Cracka

; Act As 0025

; Based off WideShatterBlock-L By SJC
;	& Pixel Perfect Spike By MarioFanGamer

!SoundEffect	= $01		; $01=Coin
!Bank			= $1DFC
!Glitter		= 1			; 1=Use Effect, 0=Don't Use Effect

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
	BRA CoinCheck
	RTL

MarioBelow:
	BRA CoinCheck
	RTL

SpriteH:
	RTL

SpriteV:
	RTL

MarioCape:
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

	if !Glitter
		%glitter()
	endif
	
	%erase_block()

	PLY

	REP #$20					;\Move 1 block right.
	LDA $9A						;|
	CLC : ADC #$FFF0			;|
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
	dw %1111111100000000
	dw %1111111100000000
	dw %1111111100000000
	dw %1111111100000000
	dw %1111111100000000
	dw %1111111100000000
	dw %1111111100000000
	dw %1111111100000000
	dw %1111111100000000
	dw %1111111100000000
	dw %1111111100000000
	dw %1111111100000000
	dw %1111111100000000
	dw %1111111100000000
	dw %1111111100000000
	dw %1111111100000000

print "Right tile of the two-tile wide 32x16 coin."