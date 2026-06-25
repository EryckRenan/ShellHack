; Name: Clear Start Power Timer
; Source: ; Thomas (https://smwc.me/1513299)

; Set to act like 25
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
    LDA $1490|!addr     ; first make sure star power was actually active
    BEQ .ret            ;  (if you don't, the music will reset every time the block is touched)
    STZ $1490|!addr     ; clear star power
    LDA $0DDA|!addr     ; get the backup music register (this retains the song number for star/p-switches/etc.)
    CMP #$FF            ;  if #$FF, that means 'don't override', so we just return
    BEQ .ret
    AND #$7F            ;  clear bit 7 (which indicates star power)
    STA $0DDA|!addr     ;   and store this value back.
    STA $1DFB|!addr     ;  lastly, restore that value to the song number
  .ret
    RTL
MarioHead:
WallFeet:
WallBody:
SpriteV:
SpriteH:
Cape:
Fireball:
    RTL

print "A block that clears the star power timer when player passes through."