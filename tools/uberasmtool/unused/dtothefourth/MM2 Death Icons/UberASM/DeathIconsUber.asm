;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; SMM Death Icons by dtothefourth
;
; Apply this UberASM to gamemode 14 or to specific levels
;
; Requires the included ASAR patch DeathIcons.asm
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;FreeRAM must match DeathIcons.asm
;Default saves to SRAM, if you don't need it to save can move it elsewhere
!Save = 1 ; If 1, saves icons to SRAM so they persist, if change make sure to change both files
!Delay = 1 	  ; If 1, delays death during icon animation (needed to have time for icons to show with instant retry)

if !Save == 0

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

init:
	LDA.L !DeathInit
	CMP #$AB
	BEQ +

	LDA #$AB
	STA.L !DeathInit

	LDA #$00
	STA.L !DeathTotal
	STA.L !DeathPos

	+

	LDA #$00
	STA.L !Timer
	STA.L !DeathSpawned
	RTL



Main:

	if !Delay == 0
	LDA $71
	CMP #$09
	BEQ +
	RTL
	+
	else

	LDA $71
	CMP #$09
	BNE +

	LDA #$00
	STA $71
	BRA ++

	+
	LDA.L !DeathSpawned
	BNE ++

	RTL

	++

	LDA !Timer
	CMP #$30
	BCC +

	LDA #$00
	STA $13FB|!addr
	LDA #$09
	STA $71
	BRA ++
	+
	LDA #$01
	STA $9D
	STA $13FB|!addr

	LDA #$3E
	STA $13E0|!addr

	++
	endif
	
	LDA.L !DeathSpawned
	BIT #$01
	BEQ +
	JMP EndCSpawn
	+
	ORA #$01
	STA.L !DeathSpawned

	STZ $17C0|!addr
	STZ $17C1|!addr
	STZ $17C2|!addr
	STZ $17C3|!addr		


	JSR Check
	BCC EndCSpawn

	LDA.L !DeathTotal
	CMP #$7F
	BEQ +
	INC
	STA.L !DeathTotal
	+

	LDA.L !DeathPos
	INC
	STA.L !DeathPos
	DEC
	ASL
	TAX

	REP #$20
	LDA $010B
	STA.L !DeathL,x

	LDA $94
	STA.L !DeathX,x

	LDA $5B
	AND #$03
	BEQ ++

	LDA $96
	BRA +


	++
	LDA $96
	CMP #$0190
	BMI +
	LDA #$0190
	+
	STA.L !DeathY,x


	+

	SEP #$20
EndCSpawn:


	RTL

!SP1A = $E000

nmi:
	LDA.L !DeathSpawned
	BIT #$01
	BEQ +
	BIT #$02
	BNE +
	ORA #$02
	STA.L !DeathSpawned

	REP #$20
	LDA.w #Icon	
	STA $4342
	LDY.b #Icon>>16
	STY $4344

	LDA #(!SP1A+$0600)
	STA $2116

	REP #$10
	LDA #$00C0
	STA $4345

	SEP #$30


	LDA #$80   
	STA $2115
	LDA #$18
	STA $4341
	LDA #$01
	STA $4340

	LDA #$10	
	STA $420B

	REP #$20
	LDA.w #Icon	
	CLC
	ADC #$0200
	STA $4342
	LDY.b #Icon>>16
	STY $4344

	LDA #(!SP1A+$0700)
	STA $2116

	REP #$10
	LDA #$00C0
	STA $4345

	SEP #$30


	LDA #$80   ;DMA init
	STA $2115
	LDA #$18
	STA $4341
	LDA #$01
	STA $4340

	LDA #$10	;transfer
	STA $420B

	+


	
	RTL

Icon:
incbin DeathIcon.bin

Check:
	LDA !DeathTotal
	BNE +

	SEC
	RTS

	+
	DEC
	STA $0D
	ASL
	TAX


	-
	REP #$20

	LDA $010B
	CMP !DeathL,X
	BNE Next

	LDA $94
	SEC
	SBC !DeathX,X
	CLC
	ADC #$0008
	CMP #$0010
	BCS Next

	LDA $96
	SEC
	SBC !DeathY,X
	CLC
	ADC #$0008
	CMP #$0010
	BCS Next

	print "fail ",pc
	SEP #$20
	CLC
	RTS

Next:
	SEP #$20
	DEX
	DEX
	DEC $0D
	BPL -
	SEC
	RTS
