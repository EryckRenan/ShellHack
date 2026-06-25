; Hurt/Death Turnblock
; By Cracka

; Modified TurnblockSpinsInfinitely.asm From FluxBaserom2.0.9.9.7
; By MarioFanGamer, modifications by SJC

; Note: Map16 Tile $49 was sacrificed to allow for alternate palette options for turning block animation.
;  If you need this bush tile back, it was Palette 5, Priority Off, FE FE FE FE, & Act as 49! 

; Act as 130

db $37

JMP MarioBelow : JMP MarioAbove : JMP MarioSide : JMP SpriteV : JMP SpriteH
JMP MarioCape : JMP MarioFireBall : JMP TopCorner : JMP HeadInside : JMP BodyInside
JMP WallRun : JMP WallFeet

!YXPPCCCT = $0C 				; 0C is Palette E
!DamageType		= 1				; 0 = Hurt, 1 = Kill

SharedBounce:
	PHX
;	PHY
;	LDA #$01 ; $1699, bounce sprite. 01 normal turnblock. 07 is turning turnblock
;	LDX #$05 ; $9C, Map16 tile. 02 is tile 25. 05 is always turning
	LDA.b #$01+$08
	LDX #$49 ; $9C value
	LDY #$00
	%spawn_bounce_sprite()
	LDA #!YXPPCCCT
	STA $1901,y
;	PLY
	PLX
	RTL

MarioBelow:
	if !DamageType
		JSL $00F606				; Kill Player
	elseif !DamageType
		JSL $00F5B7				; Hurt Player
	endif
	RTL

SpriteH:
	%check_sprite_kicked_horiz_alt() ; changed from %check_sprite_kicked_horizontal()
	BCS SpriteShared
	RTL

SpriteV:
	LDA $14C8,x
	CMP #$09
	BCC Return
	LDA $AA,x
	BPL Return
	LDA #$10
	STA $AA,x

SpriteShared:
	%sprite_block_position()

MarioCape:
	BRA SharedBounce

MarioFireBall:
BodyInside:
WallFeet:

MarioAbove:
	if !DamageType
		JSL $00F606				; Kill Player
	elseif !DamageType
		JSL $00F5B7				; Hurt Player
	endif
	RTL

TopCorner:
HeadInside:
MarioSide:
WallRun:

Return:
RTL

print "A turnblock that spins forever after being activated, and will hurt/kill the player if they come in contact. ***Disclaimer, grey palette will turn to palette 6 once animation begins. This can be corrected by tweaking a few colors in palette 6."
