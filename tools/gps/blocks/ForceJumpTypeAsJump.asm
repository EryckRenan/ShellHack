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
    LDA $140D
    BEQ +
    LDA #$00                ; $7E140D   1 byte  Flag    Spin Jump flag. #$00 = normal jump (or on ground); any other value = spinjumping.
    STA $140D
    LDA #$35     			; play jump sound
	STA $1DFC
+	%erase_block()
	%glitter()				; > Create glitter effect.
SpriteV:
SpriteH:
Cape:
Fireball:
RTL

print "This block is forces player's jump type to jump (if spinning) and is erased when Mario touches it."