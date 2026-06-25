;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; Sprite Information - by dtothefourth
;
; Draws a number over each sprite showing a chosen value
;
; Includes an optional freeRAM trigger to turn it on and off
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

Tiles: ;8x8 tiles for each number
db $80,$81,$82,$83,$84,$85,$86,$87,$88,$89,$8A,$8B,$8C,$8D,$8E,$8F

!Props = #$31  ; Properties for the number tiles

!Data = "LDA !D8,x" ;Data to display

!Trigger     = $7FB700 ; FreeRAM for turning it on and off if needed, doesn't do anything on its own
!TriggerInit = #$01    ; Change to 00 to start off

!Offset = #$F8 ; Amount to add to Y position

init:
	LDA !TriggerInit
	STA !Trigger
	RTL

main:
	LDA !Trigger
	BEQ ++

	LDA $13D4|!addr
	BEQ +
	++
	RTL
	+

	LDX #!sprite_slots-1

	LDY #$30
	-

	LDA !14C8,x
	BNE +
	JMP next
	+

	LDA !15C4,x
	AND #$01
	BEQ +
	JMP next
	+

	LDA !186C,x
	BEQ +
	JMP next
	+
		
loop:
	LDA $0201|!addr,y
	CMP #$F0
	BEQ end
	INY #$4
	BNE loop
	RTL
	end:



	LDA !E4,x
	STA $00

	LDA !14E0,x
	STA $01

	LDA !D8,x
	STA $02

	LDA !14D4,x
	STA $03

	REP #$20
	LDA $00
	SEC
	SBC $1A
	STA $04
	SEP #$20

	STA $0200|!addr,y

	REP #$20
	LDA $02
	SEC
	SBC $1C
	SEP #$20
	CLC
	ADC !Offset
	STA $0201|!addr,y

	PHX
	!Data
	AND #$F0
	LSR #4
	TAX

	LDA Tiles,x
	STA $0202|!addr,y
	


	PLX

	LDA !Props
	STA $0203|!addr,y

	PHY
	TYA
	LSR #2
	TAY
	LDA $05
	AND #$01
	STA $0420|!addr,y
	PLY


loop2:
	LDA $0201|!addr,y
	CMP #$F0
	BEQ end2
	INY #$4
	BNE loop2
	RTL
	end2:


	REP #$20
	LDA $00
	SEC
	SBC $1A
	STA $04
	SEP #$20
	CLC
	ADC #$08
	STA $0200|!addr,y

	REP #$20
	LDA $02
	SEC
	SBC $1C
	SEP #$20
	CLC
	ADC !Offset
	STA $0201|!addr,y

	PHX
	!Data
	AND #$0F
	TAX

	LDA Tiles,x
	STA $0202|!addr,y
	


	PLX

	LDA !Props
	STA $0203|!addr,y

	PHY
	TYA
	LSR #2
	TAY
	LDA $05
	AND #$01
	STA $0420|!addr,y
	PLY


next:
	DEX
	BMI +
	JMP -
	+
	RTL
	 
