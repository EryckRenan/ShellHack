;insert with act as 130
db $37

JMP Mario : JMP Mario : JMP Mario
JMP Return : JMP Return : JMP Return : JMP Return
JMP Mario : JMP Mario : JMP Mario
JMP Mario : JMP Mario

!Freeram	= $7E007C

Mario:
	LDA !Freeram
	BEQ Return
	CMP #$00
	BEQ Return				; If Freeram is set...
    LDY #$00            ;\ Act as air for Mario
    LDA #$25            ;|
    STA $1693|!addr     ;/
Return:
    RTL

print "Only passable by Mario. To sprites, it will obey the act-as setting."