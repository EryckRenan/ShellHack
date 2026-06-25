db $42
JMP MarioBelow : JMP MarioAbove : JMP MarioSide
JMP SpriteV : JMP SpriteH : JMP MarioCape : JMP MarioFireball
JMP TopCorner : JMP BodyInside : JMP HeadInside

print "A coin that can be collected by throwing a shell or by collecting it."
	

SpriteV:
SpriteH:
LDA $9E,x
CMP #$08
BCS TheEnd
CMP #$04
BCC TheEnd
	

LDA $0A		;\ 
AND #$F0	;| Update the position
STA $9A		;| of the block
LDA $0B		;| so it doesn't shatter
STA $9B		;| where the players at
LDA $0C		;|
AND #$F0	;|
STA $98		;|
LDA $0D		;|
STA $99		;/
	
LDA $14C8,x		;\
CMP #$09		;|If the shell is kicked,
BEQ ShatterBlock	;|Destroy the block.
CMP #$0A		;|
BEQ ShatterBlock	;/
MarioCape:
MarioFireball:
TheEnd:
RTL

MarioBelow:
MarioAbove:
MarioSide:
TopCorner:
HeadInside:
BodyInside:	
ShatterBlock:
	LDA #$01		; Play sound
	STA $1DFC
	INC $13CC
		
	LDA $7F                   
        ORA $81                   
        BNE Return
	%glitter()
	%erase_block()
Return:
	RTL			
