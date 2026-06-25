;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; SMM Death Icons by dtothefourth
;
; Apply this ASAR patch along with the included uberasm
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;FreeRAM must match DeathIconsUber.asm
;Default saves to SRAM, if you don't need it to save can move it elsewhere

!Save  = 0    ; If 1, saves icons to SRAM so they persist, if changed make sure to change both files
!Rapid = 0	  ; If 1, icons show up more quickly. May help with instant retry and lots of icons

if !Save == 1

!DeathTotal	  = $7005FF
!DeathInit	  = $7005FE
!DeathPos	  = $7005FD
!DeathSpawned = $7005FC
!Timer		  = $7005FB

!DeathX	 = $700600
!DeathY	 = $700700
!DeathL  = $700800

else

!DeathTotal	  = $7FB5FF
!DeathInit	  = $7FB5FE
!DeathPos	  = $7FB5FD
!DeathSpawned = $7FB5FC
!Timer		  = $7FB5FB

!DeathX	 = $7FB600
!DeathY	 = $7FB700
!DeathL  = $7FB800


endif

!addr = $0000
!bank = $800000

if read1($00FFD5) == $23
sa1rom
!addr = $6000
!bank  = $000000
endif

org $0180BE
    autoclean JML Draw


freecode


macro nexttile()
	?loop:
	LDA $0201|!addr,y
	CMP #$F0
	BEQ ?end
	INY #$4
	CPY #$00
	BNE ?loop
    JML Done
	?end:
endmacro

Draw:
	LDA.L !DeathSpawned
	BIT #$01
	BEQ ++
   	BIT #$02
	BNE + 
    ++
	JMP Done
	+

	STZ $0F

	LDA.L !Timer
	CMP #$FF
	BEQ +
	INC
	if !Rapid == 1
	CMP #$FF
	BEQ ++
	INC
	++
	endif
	STA.L !Timer
	+
	STA $0E

	LDA.L !DeathTotal
	STA $0D
	BNE +
	RTL
	+
	DEC
	ASL
	TAX

	LDY #$30

IconLoop:


	LDA $0F
	CMP #$20
	BNE +

	JMP Done
	+

	%nexttile()

	REP #$20
	LDA $010B
	CMP !DeathL,x
	SEP #$20
	BNE Next



	REP #$20

	LDA.L !DeathX,x
	SEC
	SBC $1A
	STA $00

	LDA.L !DeathY,x
	SEC
	SBC $1C

	CMP #$00E0
	BCS Next
	STA $02

	LDA $00
	CMP #$0100
	BCS Next

	SEP #$20

	LDA $00
	STA $0200|!addr,Y
	LDA $02
	STA $0201|!addr,Y


	INC $0F


	LDA $0E
	CMP #$0C
	BMI ++
	LDA #$64
	BRA +
	++
	CMP #$06
	BMI ++
	LDA #$62
	BRA +
	++
	LDA #$60
	+
	
	STA $0202|!addr,y
	LDA #$32
	STA $0203|!addr,y

	LDA $0E
	DEC
	STA $0E

	PHY
	TYA
	LSR #2
	TAY
	LDA #$02
	STA $0420|!addr,y
	PLY


	INY
	INY
	INY
	INY

Next:
	SEP #$20
	LDA $0E
	CMP #$FF
	BEQ Done
	DEX
	DEX

	DEC $0D
	BMI Done
	JMP IconLoop
Done:

    LDA $18DF|!addr
    BNE +
    
    JML $0180C3|!bank
    +
    JML $0180C9|!bank