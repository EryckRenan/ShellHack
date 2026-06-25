!right_speed = $53
!left_speed = -!right_speed

db $42
JMP Return : JMP Return : JMP Return
JMP SpriteV : JMP SpriteH : JMP Return : JMP Return
JMP Return : JMP Return : JMP Return

SpriteV:
Return:
	RTL

SpriteH:
	;~ check direction: speed $80 or above => sprite moves left
	LDA !B6,x
	CMP #$80
	BCS Left

Right:
	;~ set sprite x speed to !right_speed
	LDA #!right_speed
	STA !B6,x
	RTL

Left:
	;~ set sprite x speed to !left_speed
	LDA #!left_speed
	STA !B6,x
	RTL

print "Limits sprite speed to $",hex(!right_speed)
