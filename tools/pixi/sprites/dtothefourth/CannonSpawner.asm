;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; Sprite Cannon by dtothefourth
;
; Fires any sprite like a launcher
;
; Uses 4 extra bytes, set in the extension box in LM as follows:
;
; SP ST CC SD
;	SP - Sprite number to spawn
;	ST - Sprite state (14C8)
;		Generally 1,8,9,A (9 for carryable stuff like keys, A for kicked sprites)
;   CC - Custom sprite
;		0 - normal, 1 - custom, 5 - custom w/extra bit
;	SD - Speed - How fast to fire sprite (0-7F)
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


!InitialTime = #$40 ; How many frames before firing after spawning
!RepeatTime  = #$70 ; How many frames between each fire

!PlaySound = 1
!Sound     = #$09
!SoundBank = $1DFC|!Base2


!OffDisable =    0  ; If 1, will not fire if On/Off is Off
!OffDisableRev = 0  ; If 1, will not fire if On/Off is On

!BluePDisable    = 0  ; If 1, will not fire if blue switch is active
!BluePDisableRev = 0  ; If 1, will not fire if blue switch is inactive

!SilverPDisable    = 0  ; If 1, will not fire if silver switch is active
!SilverPDisableRev = 0  ; If 1, will not fire if silver switch is inactive

!DistMin = $0020 ; If not 0, will only fire if Mario is at least this far away horizontally
!DistMax = $00A0 ; If not 0, will only fire if Mario is at most this far away horizontally

!MakeSmoke = 1 ; If 1, creates a puff of smoke when firing

!Direction = 0 ; 0 - both, 1 = left only, 2 = right only

!Max = 0 ; If not 0, limits the number of fired sprites

!Sprite     = !extra_byte_1,X
!State      = !extra_byte_2,x
!Custom     = !extra_byte_3,x
!Speed 		= !extra_byte_4,x

!Timer  = $1504,x



Print "INIT ",pc
	LDA !InitialTime
	STA !Timer
	if !Max
	LDA #!Max
	STA !1510,X
	endif
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
	STA $0E
	BPL +++

	if !Direction = 1
	BRA +
	endif

	EOR #$FFFF
	INC
	BRA ++

	+++
	if !Direction = 2
	BRA +
	endif


	++

	if !DistMin != $0000
	CMP #!DistMin
	BCC +
	endif
	if !DistMax != $0000
	CMP #!DistMax+1
	BCS +
	endif
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

	if !Max
	LDA !1510,X
	BEQ +
	endif

	LDA !Timer
	DEC
	STA !Timer
	BNE +

	if !Max
	DEC !1510,X
	endif

	LDA !RepeatTime
	STA !Timer

	REP #$20
	LDA $0E
	PHA
	SEP #$20

	JSR SpawnSprite
	
	REP #$20
	PLA
	STA $0E	
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
	LDA !Speed
	EOR #$FF
	INC
	BRA +++
	++
	LDA #$10
	STA $00
	LDA !Speed
	+++
	STA $B6,y



	if !MakeSmoke
		REP #$20
		LDA $0E
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

	LDA !Custom
	STA $02

	LDA !Sprite	
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

	LDA !State
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