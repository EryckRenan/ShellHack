; Created By Cracka Using Blockreator
; & Utilizing Pixel Perfect Spike By MarioFanGamer

db $37

JMP MarioBelow : JMP MarioAbove : JMP MarioSide
JMP SpriteV : JMP SpriteH
JMP Cape : JMP Fireball
JMP MarioCorner : JMP MarioBody : JMP MarioHead
JMP WallFeet : JMP WallBody

MarioBelow:
	RTL

MarioAbove:
	BRA Hit
	RTL

MarioSide:
	BRA Hit
	RTL

SpriteV:
	LDA #$B4				; \ Make this block act like block #$01B4.
	STA $1693|!addr				; |
	LDY #$01				; /
	RTL

SpriteH:
	LDA #$B4				; \ Make this block act like block #$01B4.
	STA $1693|!addr				; |
	LDY #$01				; /

Cape:
Fireball:
	RTL

MarioCorner:
	BRA Hit
	RTL

MarioBody:
MarioHead:
WallFeet:
WallBody:
RTL

Hit:
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

	JSL $00F606				; > Kill the player.

	PLY

	RTL
Miss:
	PLY
	RTL

Bitflags:
	dw $8000,$4000,$2000,$1000,$0800,$0400,$0200,$0100
	dw $0080,$0040,$0020,$0010,$0008,$0004,$0002,$0001

SpikeHitbox:
	dw %0011100000000000
	dw %1111111000000000
	dw %1111111100000000
	dw %1111111110000000
	dw %1111111111000000
	dw %1111111111100000
	dw %1111111111110000
	dw %1111111111111000
	dw %1111111111111100
	dw %1111111111111110
	dw %1111111111111111
	dw %1111111111111111
	dw %0111111111111111
	dw %0011111111111110
	dw %0001111111111100

print "This block acts like a left facing purple triangle to sprites but will kill player if they come in contact."