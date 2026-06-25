; On/Off Switch (Triggerable By Right Side Only)
; By Cracka

; If !EnableSfx is set to 1, locate "addmusick/1DF9" folder. Copy "0B ON Off switch.txt" to "addmusick/1DFC".
;  Locate "Addmusic_sound effects.txt" & add a new line to the bottom of 1DFC referencing new sfx (Ex: "39	0B ON OFF switch.txt").
;  Update !SfxNumber to reflect new sfx.

!EnableSfx		= 1				; 0 = No, 1 = Yes
!SfxNumber		= $39			; $1DFC ($39 ON/OFF switch sound effect)

db $37

JMP MarioBelow : JMP MarioAbove : JMP MarioSide
JMP SpriteV : JMP SpriteH : JMP MarioCape : JMP MarioFireball
JMP TopCorner : JMP BodyInside : JMP HeadInside

MarioBelow:
MarioAbove:
MarioSide:
TopCorner:
BodyInside:
HeadInside:
WallFeet:
WallBody:
	RTL

SpriteV:
	LDA $14C8,x					; Sprite Status
	CMP #$09					; If stunned/carryable, don't...
	BEQ Return
	CMP #$0B					; If being carried, don't...
	BEQ Return
	CMP #02						; If killed and falling off screen, don't...
	BEQ Return
	LDA $AA,x					; Sprite Y Speed
	BPL Return					; Return if 00-7F, to avoid triggering from top
	BRA Toggle

SpriteH:
	LDA $14C8,x					; Sprite Status
	CMP #$09					; If stunned/carryable, don't...
	BEQ Return
	CMP #$0B					; If being carried, don't...
	BEQ Return
	CMP #02						; If killed and falling off screen, don't...
	BEQ Return
	LDA $B6,x					; Sprite X Speed
	BPL Return					; Return if 00-7F, to avoid triggering from left side

Toggle:
	LDA $14AF|!addr
	EOR #$01					; Toggle ON/OFF switch status
	STA $14AF|!addr

	if !EnableSfx
		LDA #!SfxNumber
		STA $1DFC				; Play sound
	endif

	RTL

MarioCape:
MarioFireball:
Return:
	RTL

print "ON/OFF switch block that hurts player upon contact."