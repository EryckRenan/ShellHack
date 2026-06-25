;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Shell shooter
;	by MarioFanGamer
;
; This shooter spawns kicked Koopa shells (number
; determined in the ASM file).
;
; Be aware though that the number you have to enter for
; the shell must be the same as the Koopas. That's
; because shells aren't seperate sprites but are
; stunned Koopas ("sprites" DA-DF simply spawn
; carryable Koopas). This also applies to other
; carryable sprites.
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

!Sprite = $04

!Timer = $60
!TimerEB = $30

ShellPositionLow:
db $0C,$F4

ShellPositionHigh:
db $00,$FF

ShellSpeed:
db $30,$D0

print "INIT ",pc
print "MAIN ",pc
PHB : PHK : PLB
	JSR Shooter
PLB
RTL

Return:
RTS

Shooter:
	LDA $17AB|!Base2,x
	BNE Return
	LDY #!Timer
	LDA $1783,x
	AND #$40
	BEQ +
	LDY #!TimerEB
+	TYA
	STA $17AB,x

	LDA $94
	SEC : SBC $179B|!Base2,x
	ADC #$11
	CMP #$22
	BCC Return

	LDA $178B|!Base2,x	
	CMP $1C
	LDA $1793|!Base2,x
	SBC $1D
	BNE Return

	LDA $17A3|!Base2,x
	XBA
	LDA $179B|!Base2,x
	REP #$20
	SEC : SBC $1A
	CMP #$00F0
	SEP #$20
	BCS Return

	JSL $02A9DE|!BankB
	BMI Return

	LDA #$09
	STA $1DFC|!Base2

	PHX
	TYX
	LDA #!Sprite
	STA !9E,x
	JSL $07F7D2|!BankB
	PLX

	LDA $178B|!Base2,x
	SEC : SBC #$01
	STA !D8,y
	LDA $1793|!Base2,x
	SBC #$00
	STA !14D4,y

	PHY
	JSR SubHorzPos
	STY $00
	LDA ShellPositionHigh,y
	STA $01
	LDA ShellPositionLow,y
	PLY
	CLC : ADC $179B|!Base2,x
	STA !E4,y
	LDA $17A3|!Base2,x
	ADC $01
	STA !14E0,y

	LDA #$0A
	STA !14C8,y

	PHY
	LDY $00
	LDA ShellSpeed,y
	PLY
	STA !B6,y

	JSR SpawnSmoke
RTS

SubHorzPos:
	LDY #$00
	LDA $94
	CMP $179B|!Base2,x
	LDA $95
	SBC $17A3|!Base2,x
	BPL +
	INY
+
RTS

SpawnSmoke:
	LDY #$03
-	LDA $17C0|!Base2,y
	BEQ +
	DEY
	BPL -
RTS

+	LDA #$01
	STA $17C0|!Base2,y
	LDA #$1B
	STA $17CC|!Base2,y

	LDA $178B|!Base2,x
	STA $17C4|!Base2,y

	PHY
	LDY $00
	LDA ShellPositionLow,y
	PLY
	CLC : ADC $179B|!Base2,x
	STA $17C8|!Base2,y
RTS
