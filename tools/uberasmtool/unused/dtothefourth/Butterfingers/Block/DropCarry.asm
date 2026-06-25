; Sample block that makes you drop what you are carrying
; Requires the patch and the uberasm to be applied but not set to fully disable carrying

!CarryOverride = $18E6|!addr    ;FreeRAM, cleared on level load, must match CarryToggle.asm
!CoolDown	 = $04		;How long before you can carry something again after dropping
!NoContact   = $0C		;How many frames to make carried sprite not interact with Mario after dropping


db $42 ; or db $37
JMP MarioBelow : JMP MarioAbove : JMP MarioSide
JMP SpriteV : JMP SpriteH : JMP MarioCape : JMP MarioFireball
JMP TopCorner : JMP BodyInside : JMP HeadInside



MarioBelow:
MarioAbove:
MarioSide:
TopCorner:
BodyInside:
HeadInside:
	LDA #!CoolDown
	STA !CarryOverride

	STZ $1470|!addr
	STZ $148F|!addr

    if !sa1
	LDX #$15
	else
	LDX #$0B
	endif
	
	-
	LDA !14C8,x
	CMP #$0B
	BNE ++

	LDA #$09
	STA !14C8,x

	LDA #!NoContact
	STA !154C,x

	++
	DEX
	BPL -

    RTL
SpriteV:
SpriteH:

MarioCape:
MarioFireball:
RTL