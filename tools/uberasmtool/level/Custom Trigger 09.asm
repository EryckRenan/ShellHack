; Custom GFX Trigger 09
; By Cracka

; I honestly have a limited understanding of what I'm doing here, I relied heavily on the template in Lunar Magic help doc, hence being trigger # 9!

!freeram	= $7E007C
!value		= $04

Main:
	LDA !freeram
	CMP #!value				; Check greater than or equal to !value
	BPL Trigger				; if equal/greater than !value...
	RTL

Trigger:
	LDA $7FC0FC			;\
	ORA #$0200			;| Trigger ExAnimation
	STA $7FC0FC			;/
	RTL