;Custom Block that makes shells stay kicked until you jump on them, made by dtothefourth.


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
	LDA #$FC				
	STA $AA,x				
	LDA #$00				
	STA $B6,x				

	LDA $D8,X
	AND #$F0
	CLC
	ADC #$0B
	STA $D8,X

	LDY #$00
	LDA #$1D
	STA $1693

	LDA #$09
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
	
	LDA $B6,x
	CMP #$01
	BEQ MatchL
	
	LDA $14C8,x		
	CMP #$09	
	BNE KickedL
	LDA #$01
	STA $1504,X
	JMP SetSpeedL
KickedL:
	STZ $1504,x	
SetSpeedL:
	LDA #$01				
	STA $B6,x				

MatchL:
	LDA $E4,X
	AND #$F0
	CLC
	ADC #$04
	STA $E4,X

	LDY #$00
	LDA #$1D
	STA $1693


	LDA $1504,x
	BEQ CheckBounce

	LDA #$09
	STA $14C8,x	

	RTL

Right:
	LDA #$00			
	STA $AA,x	
	
	LDA $B6,x
	CMP #$FF
	BEQ MatchR
		
		
	LDA $14C8,x		
	CMP #$09	
	BNE KickedR
	LDA #$01
	STA $1504,X
	JMP SetSpeedR
KickedR:
	STZ $1504,x	
SetSpeedR:	
	LDA #$FF			
	STA $B6,x			

MatchR:
	LDA $E4,X
	AND #$F0
	CLC
	ADC #$0C
	STA $E4,X

	LDY #$00
	LDA #$1D
	STA $1693


	LDA $1504,x
	BEQ CheckBounce

	LDA #$09
	STA $14C8,x	

	RTL

CheckBounce:
	LDA #$0A
	STA $14C8,x

	PHY

	LDA $1697
	BEQ Return2 

	LDY #$03
LoopSprites:
	LDA $17C0,y
	CMP #$02
	BNE NoSprite

	LDA $17C8,y
	SEC
	SBC $E4,X 
	BPL NoNegate
	EOR #$FF
	CLC
	ADC #$01
NoNegate:
	CMP #$10
	BPL NoSprite

	LDA $D8,X
	SEC
	SBC $17C4,y
	CLC
	ADC #$04
	BMI NoSprite
	CMP #$10
	BPL NoSprite

	LDA #$01
	STA $1504,x


	JMP Return2

NoSprite:
	DEY
	BPL LoopSprites

Return2:
	PLY
	RTL

Cape:
Fireball:
MarioCorner:
MarioBody:
MarioHead:
WallFeet:
WallBody:
RTL