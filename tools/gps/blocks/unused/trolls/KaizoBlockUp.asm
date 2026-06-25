;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; Different Directional Kaizo Blocks by dtothefourth
;
; Acts like a regular kaizo block but is hit by a direction
; other than down
;
; Use act like 25
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


db $42
JMP MarioBelow : JMP MarioAbove : JMP MarioSide
JMP SpriteV : JMP SpriteH : JMP MarioCape : JMP MarioFireball
JMP TopCorner : JMP BodyInside : JMP HeadInside



MarioAbove:
	LDA $7D	
	BMI Skip
	BEQ Skip

	LDA #$C0
	STA $7D
	
	PHY
	
	LDA #$03
	LDX #$0D
	LDY #$03	;URLD
					
	%spawn_bounce_sprite()
	
	PLY
	
	LDA #$06
	%spawn_item_sprite()
	RTL

MarioBelow:
MarioSide:

TopCorner:
BodyInside:
HeadInside:

WallFeet:
WallBody:

SpriteV:
SpriteH:

MarioCape:
MarioFireball:
Skip:
RTL