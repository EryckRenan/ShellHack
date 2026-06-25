;Custom Block that makes shells stay kicked infinitely, made by dtothefourth.


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
	LDA $9E,x
	CMP #$04
	BCC Return
	CMP #$07
	BCS Return

	LDA $14C8,x		
	CMP #$09		
	BEQ StickV
	CMP #$0A
	BEQ StickV
	BRA Return
StickV:
	LDA $AA,X
	BPL Return
	LDA #$00				
	STA $AA,x				
	LDA #$01				
	STA $B6,x				

	LDA $D8,X
	AND #$F0
	CLC
	ADC #$06
	STA $D8,X

	LDY #$00
	LDA #$1D
	STA $1693

	LDA #$0A
	STA $14C8,x
Return:				
RTL

SpriteH:
	LDA $9E,x
	CMP #$04
	BCC Return
	CMP #$07
	BCS Return

	LDA $14C8,x		
	CMP #$09		
	BEQ StickH
	CMP #$0A
	BEQ StickH
	BRA Return
StickH:
	LDA $B6,X
	BMI Right

	LDA #$00				
	STA $AA,x				
	LDA #$01				
	STA $B6,x				

	LDA $E4,X
	AND #$F0
	CLC
	ADC #$04
	STA $E4,X

	LDY #$00
	LDA #$1D
	STA $1693

	LDA #$0A
	STA $14C8,x
	RTL

Right:
	LDA #$00			
	STA $AA,x			
	LDA #$FF			
	STA $B6,x			

	LDA $E4,X
	AND #$F0
	CLC
	ADC #$0C
	STA $E4,X

	LDY #$00
	LDA #$1D
	STA $1693

	LDA #$0A
	STA $14C8,x
	RTL

Cape:
Fireball:
MarioCorner:
MarioBody:
MarioHead:
WallFeet:
WallBody:
RTL