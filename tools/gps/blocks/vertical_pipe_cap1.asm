;acts like $130
db $42
JMP MarioBelow : JMP MarioAbove : JMP MarioSide : JMP SpriteV : JMP SpriteH : JMP MarioCape
JMP MarioFireBall : JMP TopCorner : JMP BodyInside : JMP HeadInside

print "This is the no yoshi/sprite vertical pipe cap 1/2"

TopCorner:
MarioAbove:
MarioSide:
HeadInside:
BodyInside:
MarioBelow:
	LDA $1470	;\if carrying/on yoshi, then cement
	ORA $148F	;|
	ORA $187A	;|
	BNE cement	;/

	LDY #$01	;\otherwise act like the 1/2 of vertical pipe
	LDA #$37	;|
	STA $1693	;/
	BRA return
cement:
SpriteV:
SpriteH:
MarioFireBall:
	LDY #$01
	LDA #$30
	STA $1693
MarioCape:
return:
RTL
