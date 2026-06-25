;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Surfing Disco Shell
;Based on Flying Disco Shell by RussianMan in place of a disassembly
;This disco shell skips along water and/or lava, allowing it to be ridden across
;
;by dtothefourth
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

!MinSpeed = #$00	; Minimum Y speed before bouncing - making this greater than 0 requires it to fall to start bouncing
!YOffset  = #$08	; Y position of the collision test, 08 is center of shell, 11 allows it to bounce off of solid tiles

!BounceSpeed = #$E0 ; Y speed to give the shell when bouncing

!Bouyancy = 1		; 1 to also bounce if the sprites 'in liquid' state is triggered

!Splash   = 1		; 1 to create a splash effect when bouncing

;Which map16 tiles will cause the shell to bounce, end with $FFFF
;0000 is the water surface
Tiles:
dw $0000,$FFFF

!Lava = 1			; 1 to use a separate tile list for bouncing off of lava
					; This is just to allow the lava splash effect which will require SP4 to be 3/4

;Which map16 tiles will cause the shell to bounce but with lava splash, end with $FFFF
;0004 is the lava surface
LavaTiles:
dw $0004,$FFFF




!MaxRightSpeed = $20
!MaxLeftSpeed = $E0

WallBumpSpeed:
db !MaxLeftSpeed,!MaxRightSpeed

Tilemap:
db $8E,$8A,$8C,$8A

Print "INIT ",pc
INC !187B,x			;flag necessary for correct interactions (bouncing on it and yoshi eating)
LDA #$0A
STA !14C8,x
RTL

Print "MAIN ",pc
PHB
PHK
PLB
JSR Code
PLB
RTL

Code:

LDA !14C8,x
CMP #$0A
BEQ .NoPaletteChange

LDA $13
AND #$01			;change palette every other frame
BNE .NoPaletteChange	

LDA !15F6,x			;makes CFG editor useless (for setting palettes i mean, you can set it to use second gfx page).
INC #2				;
AND #$CF			;
STA !15F6,x			;

.NoPaletteChange		;

JSR GFX				;show graphics


LDA !14C8,x			;if dead
CMP #$0A
BEQ PreReturn
EOR #$08			;
ORA $9D				;or frozen in time and space
BEQ +
RTS
+
%SubOffScreen()			;erase offscreen

%SubHorzPos()			;face player. always.
TYA				;
STA !157C,x			;

;STZ !AA,x			;no Y-speed
JSL $01802A|!BankB		;


LDA !C2,x
BEQ .NoMoreSpeed

LDA !14C8,x
CMP #$0A
BNE .NoMoreSpeed

LDA !B6,x			;disassembled some code from disco shell
LDY !157C,x			;
;CPY #$00			;and y'see something nintendo did in their code. something useless!
BNE .NoRightSpeed		;
CMP #!MaxRightSpeed		;if hit maximum right speed
BPL .NoMoreSpeed		;don't increase speed.

INC !B6,x			;increase X-speed
INC !B6,x			;twice
BRA .NoMoreSpeed		;jump over some code

.NoRightSpeed
CMP #!MaxLeftSpeed		;if hit max left speed
BMI .NoMoreSpeed		;don't decrease
DEC !B6,x			;decrease X-speed
DEC !B6,x			;twice

.NoMoreSpeed
LDA !1588,x			;if hit wall bounce away and maybe trigger bounce sprite
AND #$03			;
BEQ .NoWall			;
PHA				;
JSR WallHit			;
PLA				;
AND #$03			;
DEC				;
TAY				;
LDA WallBumpSpeed,y		;set bumping speed
STA !B6,x			;

.NoWall


JSL $01803A|!BankB		;interact with player and sprites

PreReturn:

			LDA $5B                 ; \ goto .vert_level if vertical level
			AND #$01                ; |
			BNE .vert_level         ; /
			
		if !EXLEVEL
			LDA !D8,x
			CLC
			ADC !YOffset
			STA $00
			LDA !14D4,x
			ADC #$00
			STA $01
			REP #$20				; /
			LDA $00
			CMP.w $13D7|!Base2			; \ If it's beyond level boundaries...
			SEP #$20
			BPL Return				; /
		else
			LDA !D8,x
			CLC
			ADC !YOffset
			CLC                     ; | 
			ADC #$50                ; | if the sprite has gone off the bottom of the level...
			LDA !14D4,x             ; | (if adding 0x50 to the sprite y position would make the high byte >= 2)
			ADC #$00                ; | 
			CMP #$02                ; | 
			BPL .erase              ; / ...erase the sprite
		endif

		BRA Good

.vert_level:
		LDA $5F				;\Bottom of vertical level (offscreen)
		DEC				;|
		XBA				;|
		LDA #$E0			;/
		REP #$20			
		STA $00				;>$00 = bottom of vertical level
		SEP #$20

		LDA !D8,x
		CLC
		ADC !YOffset
		STA $02
		LDA !14D4,x
		ADC #$00
		STA $03
		REP #$20				; /
		LDA $00
		

		REP #$20
		LDA $02
		CMP $00				;>Bottom of vertical level
		SEP #$20
		BPL Return



Good:

JSR Water

Return:
LDA #$00            ;looks like after interaction is checked, it messes with offscreen situation in some way
%SubOffScreen()            ;it looks like it marks sprite as "process offscreen" but also as "respawn when nearby", which can lead to duplication. odd.
RTS

;not so interesting tables stored away

XDisp:
db $04,$00,$FC,$00

YDisp:
db $F1,$00,$F0,$00

XFlip:
db $00,$00,$00,$40		;only last byte is flip for one of shell's frames

GFX:
%GetDrawInfo()

LDA !14C8,x			;
;EOR #$08			;
STA $03				;set scratch ram to contains information on wether sprite's in normal status.

LDA $00				;
STA $0300|!Base2,y		;shell tile X-pos

LDA $01			
STA !163E,x	;
STA $0301|!Base2,y		;shell tile Y-pos

PHY				;
LDA $03				;if dead, don't animate shell
CMP #$0A
BNE .NoAnim			;

LDA $14				;animate with frame counter and all
.NoAnim
LSR #2				;
AND #$03			;fetch correct tile and flip info
TAY				;
LDA XFlip,y			;
STA $02				;
LDA Tilemap,y			;
PLY				;
STA $0302|!Base2,y		;

LDA $02				;flip info
ORA !15F6,x			;+cfg setting which is useless because we set it afterwards
ORA $64				;and priority
STA $0303|!Base2,y		;store as tile property



LDX $15E9|!Base2		;restore sprite slot

LDA #$00			;1 tile
LDY #$02			;16x16
JSL $01B7B3|!BankB		;
RTS				;

WallHit:
LDA #$01			;hit sound effect
STA $1DF9|!Base2		;

LDA !15A0,x			;if offscreen, don't trigger bounce sprite
BNE .NoBlockHit			;

LDA !E4,x			;
SEC : SBC $1A			;
CLC : ADC #$14			;
CMP #$1C			;
BCC .NoBlockHit			;

LDA !1588,x			;
AND #$40			;
ASL #2				;
ROL				;
AND #$01			;
STA $1933|!Base2		;

LDY #$00			;
LDA $18A7|!Base2		;
JSL $00F160|!BankB		;

LDA #$05			;
STA !1FE2,x			;

.NoBlockHit
RTS				;

Water:

	LDA !AA,x
	BMI +
	CMP !MinSpeed
	BPL ++
	+
	RTS
	++

	PHX
	if !Bouyancy
	LDA !164A,x
	BNE +++
	endif

	STZ $1933|!Base2

	LDA !D8,x
	CLC
	ADC !YOffset
	STA $98

	LDA !14D4,x
	ADC #$00
	STA $99	

	LDA !E4,x
	CLC
	ADC #$08
	STA $9A

	LDA !14E0,x
	ADC #$00
	STA $9B

	REP #$20

	%GetMap16()

	STA $00


	LDX #$00
	
	-
	LDA Tiles,x
	CMP #$FFFF
	BEQ +

	CMP $00
	BEQ +++
	INX
	INX
	BRA -

	+
	
	if !Lava
	LDX #$00
	
	-
	LDA LavaTiles,x
	CMP #$FFFF
	BEQ +

	CMP $00
	BEQ ++++
	INX
	INX
	BRA -

	+
	endif
	PLX

	SEP #$20
	BRA +

	+++

	PLX
	SEP #$20
	LDA !BounceSpeed
	STA !AA,x

	if !Splash
	JSL $0284BC|!BankB
	endif

	+
	RTS

	++++

	PLX
	SEP #$20
	LDA !BounceSpeed
	STA !AA,x

	if !Splash
	JSL $028528|!BankB
	endif

	+
	RTS