; https://www.smwcentral.net/?p=section&a=details&id=3985
; Act As 25

db $42
JMP Solid : JMP Solid : JMP Solid : JMP Main : JMP Main : JMP Solid : JMP Solid
JMP Solid : JMP Solid : JMP Solid

Main:
	LDA !187B,x 		; disco flag check
	BNE Solid
	LDY #$01
	LDA #$30 			; passable
	STA $1693
RTL

Solid:
	LDY #$00
	LDA #$25 			; act as solid
	STA $1693
	RTL


Return:	
	RTL

print "This block is solid to non-disco sprites, and passable by mario & disco sprites."