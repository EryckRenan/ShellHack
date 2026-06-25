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
    LDA $76                 ; $7E0076   Player direction. #$00 = Left; #$01 = Right.    
    EOR #$01
    STA $76
    %erase_block()
    %glitter()              ; > Create glitter effect.
    LDA #$01                ; play coin sound
    STA $1DFC
    BRA Return
SpriteV:
SpriteH:
Cape:
Fireball:
Return:
RTL

print "When obtained, this coin forces player to switch direction their facing and is erased when player touches it."