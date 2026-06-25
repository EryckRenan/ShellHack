;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; Sprite Cannon by dtothefourth
;
; Fires any sprite like a launcher
;
; Extended version puts more options on the extra bytes but
; requires at least Pixi 1.2.11
;
; Uses 10 extra bytes, set in the extension box in LM as follows:
;
; SP ST CC SD DE RP MX DI NE FA
;	SP - Sprite number to spawn
;	ST - Sprite state (14C8)
;		Generally 1,8,9,A (9 for carryable stuff like keys, A for kicked sprites)
;   CC - Custom sprite
;		0 - normal, 1 - custom, 5 - custom w/extra bit
;	SD - Speed - How fast to fire sprite (0-7F)
;   DE - Delay before firing initially
;   RP - Repeat time for each fire
;   MX - Maximum number of sprites to fire
;	DI - fire direction, 0 - both, 1 = left only, 2 = right only
;   NE - near distance, won't fire closer than this, 0 for no limit
;   FA - far distance, won't fire closer further this, 0 for no limit
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


!PlaySound = 1
!Sound     = #$09
!SoundBank = $1DFC|!Base2


!OffDisable =    0  ; If 1, will not fire if On/Off is Off
!OffDisableRev = 0  ; If 1, will not fire if On/Off is On

!BluePDisable    = 0  ; If 1, will not fire if blue switch is active
!BluePDisableRev = 0  ; If 1, will not fire if blue switch is inactive

!SilverPDisable    = 0  ; If 1, will not fire if silver switch is active
!SilverPDisableRev = 0  ; If 1, will not fire if silver switch is inactive

!MakeSmoke = 1 ; If 1, creates a puff of smoke when firing



!Timer  = $1504,x



Print "INIT ",pc
	LDA #$04
	JSR GetExtraByte
	STA !Timer
	LDA #$06
	JSR GetExtraByte
	BNE +
	LDA #$FF
	+
	STA !1510,X
	RTL
	
Print "MAIN ",pc			
	PHB
	PHK				
	PLB				
	JSR main	
	PLB
	RTL

main:


	LDA #$00
	%SubOffScreen()

	LDA !14E0,x
	XBA
	LDA !E4,x
	REP #$20
	SEC       
	SBC $94
	STA $0B
	BPL +++

	STA $00
	SEP #$20
	LDA #$07
	JSR GetExtraByte
	REP #$20
	AND #$00FF
	CMP #$0001
	BNE ++++
	JMP +
	++++
	LDA $00
	EOR #$FFFF
	INC
	STA $00
	BRA ++

	+++
	STA $00
	SEP #$20
	LDA #$07
	JSR GetExtraByte
	REP #$20
	AND #$00FF	
	CMP #$0002
	BNE ++
	JMP +

	++

	SEP #$20
	LDA #$08
	JSR GetExtraByte
	REP #$20
	AND #$00FF
	BEQ ++
	STA $02

	LDA $00
	CMP $02
	BCS ++
	JMP +

	++

	SEP #$20
	LDA #$09
	JSR GetExtraByte
	REP #$20
	AND #$00FF
	BEQ ++
	INC
	STA $02

	LDA $00
	CMP $02
	BCC ++
	JMP +

	++

	SEP #$20

	if !OffDisable
	LDA $14AF|!Base2
	BNE +
	endif
	if !OffDisableRev
	LDA $14AF|!Base2
	BEQ +
	endif

	if !BluePDisable
	LDA $14AD|!Base2
	BNE +
	endif
	if !BluePDisableRev
	LDA $14AD|!Base2
	BEQ +
	endif

	if !SilverPDisable
	LDA $14AE|!Base2
	BNE +
	endif
	if !SilverPDisableRev
	LDA $14AE|!Base2
	BEQ +
	endif

	LDA !1510,X
	BEQ +

	LDA !Timer
	DEC
	STA !Timer
	BNE +

	LDA !1510,x
	CMP #$FF
	BEQ ++
	DEC
	STA !1510,x
	++

	LDA #$05
	JSR GetExtraByte
	STA !Timer

	REP #$20
	LDA $0B
	PHA
	SEP #$20

	JSR SpawnSprite
	
	REP #$20
	PLA
	STA $0B	
	SEP #$20

	CPY #$00
	BMI +

	if !PlaySound
	LDA !Sound
	STA !SoundBank
	endif	

	LDA #$FF
	STA $AA,y

	LDA $0C
	BNE ++
	LDA #$F0
	STA $00
	LDA #$03
	JSR GetExtraByte
	EOR #$FF
	INC
	BRA +++
	++
	LDA #$10
	STA $00
	LDA #$03
	JSR GetExtraByte
	+++
	STA $B6,y



	if !MakeSmoke
		REP #$20
		LDA $0B
		CLC
		ADC $7E
		BMI +
		CMP #$0100
		BCS +
		SEP #$20
		STZ $01
		LDA #$1B : STA $02
		LDA #$01
		%SpawnSmoke()
	endif	


	+
	SEP #$20

	RTS

SpawnSprite:
	LDA $E4,x
	STA $00
	LDA $14E0,x
	STA $01

	REP #$20
	LDA $00
	CMP $94
	SEP #$20
	BMI +
	LDA #$00
	BRA ++
	+
	LDA #$01
	++
	STA $0C

	LDA #$02
	JSR GetExtraByte
	STA $02

	LDA #$00
	JSR GetExtraByte
	STA $03

	JSL $02A9DE|!BankB
	BMI EndSpawn

	TYA
	STA !160E,x


	LDA $02
	BEQ +
	PHX
	TYX
	LDA $03
	STA !7FAB9E,x
	PLX
	BRA ++
	+
	LDA $03
	STA !9E,y
	++

	PHX
	TYX
	JSL $07F7D2|!BankB

	LDA $02
	BEQ +

		AND #$04
		ORA #$08
		STA !7FAB10,x
		JSL $0187A7|!BankB

	+
	PLX

	LDA #$01
	JSR GetExtraByte
	STA !14C8,y


	LDA $0C
	BNE +

	LDA $E4,x
	SEC
	SBC #$10
	STA $E4,y
	LDA $14E0,x
	SBC #$00
	STA $14E0,y
	BRA ++
	+
	LDA $E4,x
	CLC
	ADC #$10
	STA $E4,y
	LDA $14E0,x
	ADC #$00
	STA $14E0,y
	++

	LDA $D8,x
	STA $D8,y	
	LDA $14D4,x
	STA $14D4,y	


	EndSpawn:

	RTS


GetExtraByte:
	PHY
	TAY
	LDA !extra_byte_1,x
	STA $0D
	LDA !extra_byte_2,x
	STA $0E
	LDA !extra_byte_3,x
	STA $0F
	LDA [$0D],y
	PLY
	CMP #$00
	RTS	