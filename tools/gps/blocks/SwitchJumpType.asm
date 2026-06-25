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
    LDA $140D               ; $7E140D   1 byte  Flag    Spin Jump flag. #$00 = normal jump (or on ground); any other value = spinjumping.
    EOR #$01
    STA $140D
    %erase_block()
    %glitter()              ; > Create glitter effect.
    LDA $140D
    BNE +
    LDA #$35                ; play jump sound
    STA $1DFC
    BNE Return   
+   LDA #$04                ; play spin sound
    STA $1DFC
SpriteV:
SpriteH:
Cape:
Fireball:
Return:
RTL

print "This block is forces player's jump type to spin (if not spinning) and is erased when Mario touches it."