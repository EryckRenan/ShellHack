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



MarioSide:
	LDA $7B	
	BPL Skip

	LDA #$20
	STA $7B
	
	PHY
	
	LDA #$03
	LDX #$0D
	LDY #$02	;URLD
					
	%spawn_bounce_sprite()
	
	PLY
	
	LDA #$06
	%spawn_item_sprite()
	RTL

MarioBelow:
MarioAbove:

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