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
	BEQ OnAir
	LDY #$00		
	LDA #$25
	STA $1693	
	RTL	
OnAir:
	LDY #$01		
	LDA #$30 
	STA $1693
	RTL

print "Solid when star power is NOT activated"