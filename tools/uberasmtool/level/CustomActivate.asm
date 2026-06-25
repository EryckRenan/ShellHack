; Change ExAnimation After X Shell Interactions
; By Cracka
;
; Triggers the animation graphic once Freeram reaches specific value. Intended to be coupled with "Freeram shell" which adds +01 to Freeram address every shell jump interaction.
; 
; Honestly wasn't making much progress till I found this (https://smwc.me/1225539)

!Freeram	= $7E007C
!Value		= $04		; Target value of Freeram
!SFX		= $29		; $29 = Correct

main:
	LDA !Freeram|!addr
	CMP #!Value
	BPL .deactivate		; If less than !Value...

	REP #$20
	LDA $7FC0FC
	ORA #$0001			; Activate Custom Trigger 00
	STA $7FC0FC
	SEP #$20

	RTL

.deactivate
	REP #$20
	LDA $7FC0FC
	AND #$FFFE			; Deactivate Custom Trigger 00
	STA $7FC0FC
	SEP #$20

	LDA !Freeram|!addr
	CMP #!Value
	BNE +

	LDA #!SFX			; Play !SFX sound
	STA $1DFC

	LDA !Freeram|!addr
	INC
	STA !Freeram|!addr

+	RTL