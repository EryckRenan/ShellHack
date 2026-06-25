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
    LDA #$01                ; $7E140D   1 byte  Flag    Spin Jump flag. #$00 = normal jump (or on ground); any other value = spinjumping.
    STA $140D
	%erase_block()
	%glitter()				; > Create glitter effect.
SpriteV:
SpriteH:
Cape:
Fireball:
RTL

print "This block is simply erased when Mario touches it. It's used for several purposes in the baserom: a 1F0 that disappears after you touch it; disappearing indicators, etc."