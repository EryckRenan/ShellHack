
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; Motor Shell by dtothefourth
;
; Based on Flying Disco Shell by RussianMan in place of a disassembly
;
; Alternates between a normal and spiked shell when bounced on
;
; Uses the spiny graphics for the top half of the shell by default
; (SP4 02)
;
; Setting the extra bit will make it begin as spiny
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

!Continue  = 1   ; If 1, keep going after being bounced on
!Disco     = 0   ; If 1, follow like a disco shell
!Kicked    = 0   ; If 1, start kicked
!KickSpeed = $E0 ; Speed to move at if kicked

!KickSound = 1	 ; If 1, play a sound when starting kicked
!KickSFX   = $13 ; Sound to play
!KickBank  = $1DF9|!Base2


!MaxRightSpeed = $20
!MaxLeftSpeed = $E0

WallBumpSpeed:
db !MaxLeftSpeed,!MaxRightSpeed

;Spiked shell
TilemapUL:
db $80,$82,$80,$82

TilemapDL:
db $9E,$9A,$9C,$9A

;Normal Shell
Tilemap:
db $8E,$8A,$8C,$8A

XDisp:
db $04,$00,$FC,$00

YDisp:
db $F1,$00,$F0,$00

XFlip:
db $00,$00,$00,$40		;only last byte is flip for one of shell's frames

BounceTiles: ;Tiles that bounce the block up like triangles do, end with $FFFF
dw $01B4,$01B5,$FFFF
!BounceSpeed = #$B8 ; Y speed when bouncing off of a tile

Print "INIT ",pc
if !Disco || !Kicked
LDA #$0A
else
LDA #$09
endif
STA !14C8,x
LDA !7FAB10,x
AND #$04
ASL #2
STA !1504,x
STZ !1510,x

; \ GRABBED THIS SECTION FROM GHOST SHELL BY MarkAlarm

    LDA !extra_byte_1,x                 ; \ do math on the first extra byte so that the number picked represents its palette number
    SEC : SBC #$08                      ; |
    ASL                                 ; |
    STA $00                             ; /
    
    LDA !sprite_oam_properties,x        ; \ set shell color based on the first extra byte
    AND #$F1                            ; |
    ORA $00                             ; |
    STA !sprite_oam_properties,x        ; /    

; \ END OF SECTION    

if !Kicked
LDA #!KickSpeed
STA !B6,x

if !KickSound
LDA #!KickSFX
STA !KickBank
endif
endif

RTL

Print "KICKED", pc
Print "MAIN ",pc
PHB
PHK
PLB
JSR Code
PLB
RTL

Code:

LDA !1504,x
BNE +
JSR GFX				;show graphics
BRA ++
+
JSR GFXSpike
++

LDA !14C8,x			;if dead
BEQ ++		;
LDA $9D				;or frozen in time and space
BEQ +
++
JMP .Re				;return
+
%SubOffScreen()			;erase offscreen

LDA !1656,x
AND #$EF
ORA !1504,x
EOR #$10
STA !1656,x

%SubHorzPos()			;face player. always.
TYA				;
STA !157C,x			;



JSR CheckSwap

LDA !14C8,x
CMP #$08
BCC +
CMP #$09
BEQ +
JSL $01802A|!BankB

LDA !1588,x
AND #$03
BEQ +
JSR WallHit
+

if !Disco
LDA !14C8,x
CMP #$08
BNE +
-
LDA #$0A
STA !14C8,x
+
CMP #$09
BEQ -
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
endif

LDA !14C8,x
CMP #$0A
BNE +
JSR TriangleCheck
+


LDA !B6,x
STA !1534,x

LDA !14C8,x
CMP #$08
BCC +
CMP #$0B
BEQ +
JSL $01803A|!BankB
+
.Re

LDA #$00            ;looks like after interaction is checked, it messes with offscreen situation in some way
%SubOffScreen()            ;it looks like it marks sprite as "process offscreen" but also as "respawn when nearby", which can lead to duplication. odd.
RTS


GFX:
%GetDrawInfo()

LDA !14C8,x			;
;EOR #$08			;
STA $03				;set scratch ram to contains information on wether sprite's in normal status.

LDA $00				;
STA $0300|!Base2,y		;shell tile X-pos
LDA $01				;
STA $0301|!Base2,y		;shell tile Y-pos

PHY				;
LDA $03				;if dead, don't animate shell
CMP #$0A
BNE .NoAnim			;

LDA $14				;animate with frame counter and all
LSR #2				;
AND #$03			;fetch correct tile and flip info
BRA +
.NoAnim

LDA #$02
+
TAY				;
LDA XFlip,y			;
STA $02				;
LDA Tilemap,y			;
PLY				;
STA $0302|!Base2,y		;

LDA !14C8,x
CMP #$02
BNE +

LDA $02
ORA #$80
STA $02

+

LDA $02				;flip info

ORA !15F6,x			;+cfg setting which is useless because we set it afterwards
ORA $64				;and priority
STA $0303|!Base2,y		;store as tile property

LDX $15E9|!Base2		;restore sprite slot

LDA #$00			;1 tile
LDY #$02			;16x16
JSL $01B7B3|!BankB		;
RTS				;


GFXSpike:
%GetDrawInfo()

LDA !14C8,x			;
;EOR #$08			;
STA $03				;set scratch ram to contains information on whether sprite's in normal status.

LDA $00				;
STA $0300|!Base2,y		;shell tile X-pos
STA $0308|!Base2,y		;shell tile X-pos
CLC
ADC #$08
STA $0304|!Base2,y		;shell tile X-pos
STA $030C|!Base2,y		;shell tile X-pos

LDA $01				;
STA $0301|!Base2,y		;shell tile Y-pos
STA $0305|!Base2,y		;shell tile Y-pos
CLC
ADC #$08
STA $0309|!Base2,y		;shell tile Y-pos
STA $030D|!Base2,y		;shell tile Y-pos

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
ORA #$01
EOR #$40
STA $02				;
LDA TilemapUL,y			;
PLY				;
STA $0302|!Base2,y		;
INC
STA $0306|!Base2,y		;

PHY
LDA $03				;if dead, don't animate shell
CMP #$0A
BNE .NoAnim2			;

LDA $14				;animate with frame counter and all
.NoAnim2
LSR #2				;
AND #$03			;fetch correct tile and flip info
TAY				;
LDA TilemapDL,y			;
PLY				;
STA $030A|!Base2,y		;
INC
STA $030E|!Base2,y		;


LDA $02				;flip info
BIT #$40
BEQ +
LDA $0302|!Base2,y		;
PHA
LDA $0306|!Base2,y		;
STA $0302|!Base2,y		;
PLA
STA $0306|!Base2,y		;

LDA $030A|!Base2,y		;
PHA
LDA $030E|!Base2,y		;
STA $030A|!Base2,y		;
PLA
STA $030E|!Base2,y		;
LDA $02
+

ORA !15F6,x			;+cfg setting which is useless because we set it afterwards
ORA $64				;and priority
STA $0303|!Base2,y		;store as tile property
STA $0307|!Base2,y		;store as tile property
AND #$FE
STA $030B|!Base2,y		;store as tile property
STA $030F|!Base2,y		;store as tile property

LDX $15E9|!Base2		;restore sprite slot

LDA #$03			;4 tiles
LDY #$00			;8x8
JSL $01B7B3|!BankB		;
RTS				;

WallHit:
LDA #$01			;hit sound effect
STA $1DF9|!Base2		;

if !Disco
LDA !1588,x
AND #$03
LSR
TAY
LDA WallBumpSpeed,y
STA !B6,x
else
LDA !B6,x
EOR #$FF
INC
STA !B6,x
endif

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

CheckSwap:
LDA !1504,x
BNE ++
LDA !14C8,x
CMP #$09
BNE +
LDA !1510,x
CMP #$0A
BNE +
LDA $7D
BPL +

LDA !1504,x
EOR #$10
STA !1504,x

if !Continue
LDA #$0A
STA !14C8,x
LDA !1534,x
STA !B6,x

LDA !AA,x
BPL +++
STZ !AA,x
+++
endif

LDA $7D
STA !1510,x
RTS

+
LDA !14C8,x
STA !1510,x
RTS
++
LDA !14C8,x
CMP #$0A
BNE +
LDA !1510,x
BMI +
LDA $7D
BPL +

LDY #$03
-
LDA $17C0|!addr,y
CMP #$02
BNE +

LDA $17C8|!addr,y
SEC
SBC !E4,x
CLC
ADC #$10
CMP #$20
BCS +

LDA $17C4|!addr,y
SEC
SBC !D8,x
CLC
ADC #$10
CMP #$20
BCC ++

+
DEY
BPL -
LDA $7D
STA !1510,x
RTS
++
LDA !1504,x
EOR #$10
STA !1504,x
LDA $7D
STA !1510,x
RTS

TriangleCheck:


    LDA !E4,x
    CLC
    ADC #$08
    STA $9A
    LDA !14E0,x
    ADC #$00
    STA $9B
    LDA !D8,x
    CLC
    ADC #$0C
    STA $98
    LDA !14D4,x
    ADC #$00
    STA $99

    STZ $1933|!addr
	PHX
	REP #$20
    %GetMap16()
    CMP #$FFFF
    BEQ TriangleEnd
    STA $00

	LDX #$00



	-
	LDA BounceTiles,X
	CMP #$FFFF
	BEQ TriangleEnd
	CMP $00
	BNE TriangleNext

	PLX
	SEP #$20
	LDA !BounceSpeed
	STA !AA,X
	RTS

TriangleNext:
	INX
	INX
	BRA -

TriangleEnd:
	SEP #$20
	PLX
	RTS

print "VERG30"