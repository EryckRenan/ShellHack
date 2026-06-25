; Hurt/Death Breakable By Item
; By Cracka

; Based On Breakable By Item
; From RHR Baserom 5.12

; Act As 12F

!DamageType		= 1				; 0 = Hurt, 1 = Kill

db $42

JMP Return : JMP Return : JMP WallBody
JMP SpriteV : JMP SpriteH : JMP Return : JMP Return
JMP Return : JMP Return

WallBody:
	if !DamageType
		JSL $00F606				; Kill Player
	elseif !DamageType
		JSL $00F5B7				; Hurt Player
	endif
	RTL

SpriteV:
	%check_sprite_kicked_vertical()
	bcs Shatter
	rtl
SpriteH:
	%check_sprite_kicked_horizontal()
	bcs Shatter
	rtl
Shatter:
	%sprite_block_position()
	lda $0F : pha
	%shatter_block()
	pla : sta $0F
Return:
	rtl

print "Shatters when a sprite is kicked/thrown at it, but hurts or kills player upon contact."