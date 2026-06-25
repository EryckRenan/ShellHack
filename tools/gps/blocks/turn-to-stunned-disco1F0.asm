db $37

JMP MarioBelow : JMP MarioAbove : JMP MarioSide
JMP SpriteV : JMP SpriteH
JMP Cape : JMP Fireball
JMP MarioCorner : JMP MarioBody : JMP MarioHead
JMP WallFeet : JMP WallBody

MarioBelow:
MarioAbove:
MarioSide:
MarioCorner:
MarioBody:
MarioHead:
WallFeet:
WallBody:
	%erase_block()
	%glitter()				; > Create glitter effect.
SpriteV:
    LDA #$F0
    LDY #$01
    STA $1693
    LDA !9E,x				;load sprite number
	PHX						;Push sprite number
	PLX
	LDA #$09				;sprite status: stunned
	STA !14C8,x
	LDA #$01				;discoshell: true
	STA !187B,x
SpriteH:
Cape:
Fireball:
RTL

print "This block acts like a 1F0 that converts the sprite above to disco and is erased when Mario touches it."