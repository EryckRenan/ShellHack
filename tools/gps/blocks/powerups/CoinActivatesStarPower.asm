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
    LDA #$80                ; $7E140D   1 byte  Flag    Spin Jump flag. #$00 = normal jump (or on ground); any other value = spinjumping.
    STA $1490
    LDA #$0A     			; play powerup sound
	STA $1DF9
+	%erase_block()
	%glitter()				; > Create glitter effect.
SpriteV:
SpriteH:
Cape:
Fireball:
RTL

print "A coin that activates star power and is erased when Mario touches it."