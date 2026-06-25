; By Cracka
; Based On P-Switch Solid/Passable Blocks

db $37

JMP OnSolid : JMP OnSolid : JMP OnSolid
JMP OnSolid : JMP OnSolid
JMP OnSolid : JMP OnSolid
JMP OnSolid : JMP OnSolid : JMP OnSolid
JMP OnSolid : JMP OnSolid

OnSolid:
	LDA $1490
	BEQ OffAir
	LDY #$01		
	LDA #$30
	STA $1693	
	RTL	
OffAir:
	LDY #$00		
	LDA #$25
	STA $1693
	RTL

print "Solid when star power is activated"