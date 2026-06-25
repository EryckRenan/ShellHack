; A Turnblock
; by spooonsss

; Add this asm to GPS and set ActAs to 130.
; Use the next map16 slot for the spinning block. Set ActAs to 25. (No .asm needed for this second block)
; Also read TurnblockBounce.asm instructions

!bounce_num			= $08+$01		; The bounce block sprite number: $08+${number of TurnblockBounce.asm from pixi's list.txt}
!bounce_properties	= $0A			; The properties of bounce blocks (palette, tile number high byte)

db $42

JMP MarioBelow : JMP MarioAbove : JMP MarioSide
JMP SpriteV : JMP SpriteH
JMP Cape : JMP Fireball
JMP MarioCorner : JMP MarioBody : JMP MarioHead
JMP WallFeet : JMP WallBody


SpriteV:
    %sprite_block_position()
    %check_sprite_kicked_vertical()
    BCS ActivateBlock
    RTL
SpriteH:
    ; stunned/dropped shells do not activate the sides
    ; ref HandleSprStunned:... $0195E2 "If the sprite is touching the side of a block and is not a shell, then interact with that block."
    LDA !9E,X
    CMP.b #$0D
    BCS +
    LDA !14C8,x
    CMP #$09
    BEQ return
    +
    %sprite_block_position()
    %check_sprite_kicked_horizontal()
    BCS ActivateBlock
    RTL

Cape:
    LDA $0F
    STA $1933|!addr
    BRA ActivateBlock

MarioBelow:
    LDA $7D
    BPL return
ActivateBlock:
    ; save sprite index
    PHX
	LDA #!bounce_num
	LDX #$FF ; $9C value
	LDY #$00 ; direction
    ; $03-$04 is map16 number already
	%spawn_bounce_sprite()
	LDA #!bounce_properties
	STA $1901|!addr,y
	LDA.b #$FF					;$028875	|||
	STA.w $18CE|!addr,Y				;$028877	||/
    PLX
    LDY #$01
    RTL

MarioCorner:
MarioAbove:
    ; act as 11E to smash if big and spinjumping
    LDY #$01
    LDA #$1E
    STA $1693|!addr

MarioSide:
Fireball:
MarioBody:
MarioHead:
WallFeet:
WallBody:
return:
    RTL

print "A custom Turnblock"
