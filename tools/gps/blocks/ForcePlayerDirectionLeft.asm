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
    LDA $76
    BEQ +
    LDA #$00                ; $7E0076   Player direction. #$00 = Left; #$01 = Right.    
    STA $76
    LDA #$01                ; play coin sound
	STA $1DFC
+	%erase_block()
	%glitter()				; > Create glitter effect.
SpriteV:
SpriteH:
Cape:
Fireball:
RTL

print "When obtained, this coin forces player to face left and is erased when player touches it."