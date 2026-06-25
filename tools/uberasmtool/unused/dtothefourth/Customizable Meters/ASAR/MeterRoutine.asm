
if read1($00FFD5) == $23	;sa-1 compatibility
  sa1rom
  !sa1 = 1
  !addr = $6000
  !addr3 = $3000
  !BankB = $000000
  !sprite_slots = 22
  !7FB = $408000
else
  !sa1 = 0
  !addr = $0000
  !addr3 = $0000
  !BankB = $800000
  !sprite_slots = 12
  !7FB = $7FB000
endif

org $00A2EE|!BankB
	autoclean JML Draw

!Queue = !7FB|$700 ;32 bytes of FreeRAM


freecode
print "main ",pc
Draw:
	STA $1C

	LDA $13D4|!addr
	BEQ +

	LDA #$00
	STA !Queue
	STA !Queue+4
	STA !Queue+8
	STA !Queue+12
	STA !Queue+16
	STA !Queue+20
	STA !Queue+24
	STA !Queue+28

	JML $008494|!BankB
	+

	PHX
	

	LDX #$00
	-
	LDA !Queue,x
	CMP #$AB
	BNE Next

	LDA #$00
	STA !Queue,x

	LDA !Queue+1,x
	STA $00
	LDA !Queue+2,x
	STA $01
	LDA !Queue+3,x
	STA $02

	PHX

	PHK
	PEA.w Return-1

	JMP [$0000|!addr3]
Return:
	PLX

Next:
	INX #4
	CPX #$20
	BNE -


	PLX

	JML $008494|!BankB
	