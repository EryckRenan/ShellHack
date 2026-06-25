;This UberASM will cause a shell to be picked up again when
;bouncing off of it while holding run/grab
;
;By dtothefourth

main:

	LDA $15
	BIT #$40
	BNE +
	RTL
	+

	;LDA $148F
	;BEQ +
	;RTL
	;+

	LDX #!sprite_slots-1
	-

	LDA !14C8,x
	CMP #$09
	BNE +

	LDA !9E,x
	CMP #$04
	BMI +
	CMP #$09
	BPL +

	JSR Shell

	+
	DEX
	BPL -

	RTL

Shell:
	
	JSL $03B664
	JSL $03B69F
	JSL $03B72B

	BCC NoContact
	
	;LDA #$02
	;STA $19

	LDA #$0B
	STA !14C8,x
	LDA #$01
	STA $148F|!addr
	STA $1470|!addr

NoContact:

	RTS