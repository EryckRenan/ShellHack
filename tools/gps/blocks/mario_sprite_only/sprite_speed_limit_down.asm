!down_speed = $19

db $42
JMP Return : JMP Return : JMP Return
JMP SpriteV : JMP SpriteH : JMP Return : JMP Return
JMP Return : JMP Return : JMP Return

SpriteH:
Return:
	RTL

SpriteV:
	;~ check direction: speed $80 or above => sprite moves Up
	LDA !AA,x
	CMP #$80
	BCS Return

Down:
	;~ skip if sprite is slower than !down_speed
	LDA !AA,x
	CMP #!down_speed
	BCC Return

	;~ set sprite y speed to !down_speed
	LDA #!down_speed
	STA !AA,x
	RTL

print "Limits sprite downward speed to $",hex(!down_speed)
