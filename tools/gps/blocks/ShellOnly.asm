; https://www.smwcentral.net/?p=section&a=details&id=3985
; Act As 25

db $42
JMP Solid : JMP Solid : JMP Solid : JMP Main : JMP Main : JMP Solid : JMP Solid
JMP Solid : JMP Solid : JMP Solid

Main:
LDA $9E,x
CMP #$04
BCC Solid
CMP #$07
BCC Cont

Solid:
LDY #$01
LDA #$30 ; solid from above
STA $1693
RTL

Cont:
LDA $14C8,x		
CMP #$09		
BEQ Return
CMP #$0A
BEQ Return
BRA Solid

Return:	
RTL

print "Solid block only passable by certain shells (Green, Red, Blue) & their respective koopa forms. Does not work for Yellow or 2 Bounce Green."