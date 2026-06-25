; Sticky Ceiling When On/Off Set To Off
; Modified By Cracka
; 
; Based On https://www.smwcentral.net/?p=section&a=details&id=14496
; MellyMellouange

; Act As 25

!Trigger = 2 	; set what triggers the sticky ceiling. 0 = always on, 1 = on/off switch, 2 = p-timer, 3 = star timer

db $42

JMP MarioBelow : JMP MarioAbove : JMP MarioSide
JMP SpriteV : JMP SpriteH
JMP Cape : JMP Fireball
JMP MarioCorner : JMP MarioHead : JMP MarioBody

ClippingY:
db $18,$10,$10,$0D

MarioBelow:
if !Trigger == 0
	BRA Routine

elseif !Trigger == 1
    LDA $14AF|!addr     ; check On/Off state
    BNE Return          ; return if Off
    BEQ Routine

elseif !Trigger == 2
    LDA $14AD|!addr     ; check blue p-switch timer
    BEQ Return          ; return if not set
    BNE Routine

elseif !Trigger == 3
    LDA $1490|!addr     ; check star power timer
    BEQ Return          ; return if not set
    BNE Routine
endif

Routine:
	LDA $7D		; This block is only active for Mario when his Vertical Speed is negative.
	BPL Return	; (AKA Going upwards)

	EOR #$FF
	LSR
	LSR
	LSR		; Get the amount of pixels that Mario's Y speed makes him shift.
	LSR		; This must be stored for later.
	INC		;
	STA $00		; $00 is scratch RAM that will temporarily be used to store
	STZ $13DC|!addr	; Mario's displacement from the block.
	PHX
	LDX #$00
	LDA $73
	BNE Ducking	;
	LDA $19		; Get statusses which affect Mario's "top" clipping value.
	BNE NoPowerUp	;
Ducking:
	INX 
NoPowerUp:
	LDA $187A|!addr
	BEQ NoYoshi
	INX
	INX
NoYoshi:
	LDA ClippingY,x	; Load a value depending on Mario's status (big, ducking, on yoshi, etc)
	PLX
	CLC
	ADC $00		; Add that to the displacement value.
	STA $00	

	LDA $98		;-------------
	SEC		;
	SBC #$20
	STA $98		; Starting from the block's position - #$20...
	LDA $99
	SBC #$00
	STA $99

	LDA $98
	CLC
	ADC $00		; Then add the value from $0F
	STA $96		; ($0F = displacement from the top of the block)
	LDA $99
	ADC #$00
	STA $97

	LDA $15
	BPL DropSpeed	; If holding the B button,
	LDA #$A4	; Sets Mario's Y speed to something negative.
	STA $7D
	BRA Return

	DropSpeed:
	STZ $7D		; If not holding the B button, set Y Speed to 0.

MarioHead:
MarioBody:
MarioSide:
MarioCorner:
MarioAbove:
Cape:
Fireball:
SpriteH:
Return:
	RTL

SpriteV:

	LDA !AA,x
	BPL Return
	
	EOR #$FF
	LSR
	LSR
	LSR
	LSR
	INC
	STA $0F
	
	LDA $98
	SEC
	SBC #$10
	STA $98
	LDA $99
	SBC #$00
	STA $99

	LDA !D8,x
	CLC
	ADC $0F
	STA !D8,x
	LDA !14D4,x
	ADC #$00
	STA !14D4,x
	
	LDA !14C8,x
	CMP #$09
	BEQ GoUp
	CMP #$0A
	BEQ GoUp
	RTL
	
GoUp:
	LDA #$E0
	STA !AA,x
	RTL

print "When On/Off switch is in the On state the player and enemies will stick to when they jump into it from below. Player will passthrough like air when switch state is Off"