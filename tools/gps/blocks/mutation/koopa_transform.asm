!sfx = $06			; sound effect to play...
!channel = $1DFC	; in its respective channel.

db $42
JMP Nope : JMP Nope : JMP Nope : JMP Transform
JMP Transform : JMP Nope : JMP Nope : JMP Nope
JMP Nope : JMP Nope

Transform:
%sprite_block_position()		; Move sprite to block.
PHY		; Preserve Y for glitter and block changing routines.
LDA !9E,x		; If sprite...
CMP #$0D		; isn't any type of Koopa,
BCS Return		; Return.
TAY		; Move sprite number into Y to serve as an index for which sprite to turn into.
;		SMW putting all the koopas in #$00-#$0C made this nice and easy, so, thanks I guess?

LDA !14C8,x		; If sprite...
CMP #$08		; is dead,
BCC Return		; Return.
PHA		; Preserve sprite status.
LDA !B6,x		;
PHA		; Preserve X speed.
LDA !AA,x		;
PHA		; Preserve Y speed.

STZ !187B,x		; Unset disco shell flag.
LDA Koopa,y		; Load sprite value to transform into.
STA !9E,x		; Store to sprite number.

LDA !15F6,x		; \ if the disco shell is not in a valid palette, make it so it is.
AND #$0E		; | only check palette data...
LSR				; | shift it over so its easier to check...
DEC #2			; | and also put together all of the invalid palettes for a faster check.
				; |
CMP #$03		; | if valid palette, don't change color.
BPL +			; | 
LDA !15F6,x		; | load yxppccct...
AND #$F1		; | get rid of current palette...
ORA #$02		; | force one of them...
STA !15F6,x		; | and store it.
				; |
+				; / end of routine.

JSL $07F7D2|!bank		; Reset sprite tables.

PLA		;
STA !AA,x		; Retrieve Y speed.
PLA		;
STA !B6,x		; Retrieve X speed.
PLA		;
STA !14C8,x		; Retrieve sprite status.

PLY		; Retrieve Y.
%glitter()		; Glitter.
%erase_block()		; Erase block.
LDA #!sfx		;
STA !channel|!addr		; "Mario fireball" SFX.
RTL
Return:
PLY		; Retrieve Y.
Nope:
RTL

Koopa: db $01,$02,$03,$00,$05,$06,$07,$04,$00,$0A,$00,$00,$04

print "Transforms Koopas into other Koopas."