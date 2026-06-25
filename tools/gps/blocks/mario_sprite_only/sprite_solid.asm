db $37

JMP MarioBelow : JMP MarioAbove : JMP MarioSide
JMP SpriteV : JMP SpriteH
JMP Cape : JMP Fireball
JMP MarioCorner : JMP MarioBody : JMP MarioHead
JMP WallFeet : JMP WallBody

MarioBelow:
MarioAbove:
MarioSide:
RTL

SpriteV:
SpriteH:
	LDA $14AF|!addr				; \ If the ON/OFF switch is ON...
	BNE Label_0000				; /
	LDA #$30				; \ Make this block solid.
	STA $1693|!addr				; |
	LDY #$01				; /
	BRA Label_0001
Label_0000: 
	LDA #$25				; \ Make this block passable.
	STA $1693|!addr				; |
	LDY #$00				; /
Label_0001:					; > --------
Cape:
Fireball:
MarioCorner:
MarioBody:
MarioHead:
WallFeet:
WallBody:
RTL




print "Solid for sprite if ON otherwise passable for everything else"