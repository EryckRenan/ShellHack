; Name: Clear Blue P-Switch Timer
; Author: Cracka
; Inspiration: PowStar Block (By Immortality, with help from Kipernal)

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
MarioHead:
WallFeet:
WallBody:
	LDA $14AD		; $7E14AD blue p-switch timer
	BEQ +			; only run if timer exists
	LDA #$01		; reduce timer to 1
	STA $14AD
+	RTL
SpriteV:
SpriteH:
Cape:
Fireball:
RTL

print "A block that clears blue p-switch timer when player passes through."