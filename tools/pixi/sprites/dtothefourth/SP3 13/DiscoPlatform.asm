;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Based on Flying Disco Shell by RussianMan in place of a disassembly
;Acts like a disco shell but is combined with a rideable brown platform
;Usable with vanilla platform graphics (SP3 13)
;
;by dtothefourth
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

!MaxRightSpeed = $20
!MaxLeftSpeed = $E0

WallBumpSpeed:
db !MaxLeftSpeed,!MaxRightSpeed

Tilemap:
db $8E,$8A,$8C,$8A

Print "INIT ",pc
INC !187B,x			;flag necessary for correct interactions (bouncing on it and yoshi eating)
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
CMP #$08
BEQ ++
RTS
++

LDA !14C8,x
CMP #$0A
BEQ .NoPaletteChange

LDA $13				;change palette every other frame
AND #$01			;
BNE .NoPaletteChange		;

LDA !15F6,x			;makes CFG editor useless (for setting palettes i mean, you can set it to use second gfx page).
INC #2				;
AND #$CF			;
STA !15F6,x			;

.NoPaletteChange		;

JSR GFX				;show graphics



LDA $9D				;or frozen in time and space
BEQ +
JMP Return			;return
+
%SubOffScreen()			;erase offscreen

;JSL $01B44F

LDA !E4,x
CLC
ADC #$10
STA !E4,x
LDA !14E0,x
ADC #$00
STA !14E0,x

%SubHorzPos()			;face player. always.

LDA !E4,x
SEC
SBC #$10
STA !E4,x
LDA !14E0,x
SBC #$00
STA !14E0,x

TYA				;
STA !157C,x			;

;STZ !AA,x			;no Y-speed
	;

%SubVertPos()

LDA $7D
BMI NoContact2

LDA $0F              
CMP #$E6             
BPL NoContact

JSL $01A7DC
BCC NoContact2


LDA !E4,X
CLC
ADC #$10
STA !E4,x
LDA !14E0,x
ADC #$00
STA !14E0,x

JSL $01802A|!BankB	

LDA !E4,X
SEC
SBC #$10
STA !E4,x
LDA !14E0,x
SBC #$00
STA !14E0,x

STZ $7D   

LDA #$01
STA $1471|!Base2

LDY #$00
LDA $1491|!Base2

BPL +      
DEY        
+
CLC        
ADC $94    
STA $94    
TYA        
ADC $95    
STA $95   

LDA #$E1       
LDY $187A|!Base2     
BEQ +          
LDA #$D1       
+
CLC            
ADC !D8,x      
STA $96        
LDA !14D4,x    
ADC #$FF       
STA $97     
BRA +

NoContact:

JSL $01A7DC
BCC NoContact2
JSL $00F5B7

NoContact2:
LDA !E4,X
CLC
ADC #$10
STA !E4,x
LDA !14E0,x
ADC #$00
STA !14E0,x

JSL $01802A|!BankB	

LDA !E4,X
SEC
SBC #$10
STA !E4,x
LDA !14E0,x
SBC #$00
STA !14E0,x

+

LDA !14C8,x
CMP #$08
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

LDA #$0A
STA !14C8,x

JSL $01803A|!BankB		;interact with player and sprites

LDA #$08
STA !14C8,x

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


LDA $00		
SEC
SBC #$02
STA $0300|!Base2,y		;shell tile X-pos

LDA $01				;
STA $0301|!Base2,y		;shell tile Y-pos

LDA #$60
STA $0302|!Base2,y		;

LDA #$31
STA $0303|!Base2,y		;store as tile property

INY #4

LDA $00		
CLC
ADC #$0E
STA $0300|!Base2,y		;shell tile X-pos

LDA $01				;
STA $0301|!Base2,y		;shell tile Y-pos

LDA #$61
STA $0302|!Base2,y		;

LDA #$31
STA $0303|!Base2,y		;store as tile property

INY #4

LDA $00		
CLC
ADC #$1E
STA $0300|!Base2,y		;shell tile X-pos

LDA $01				;
STA $0301|!Base2,y		;shell tile Y-pos

LDA #$61
STA $0302|!Base2,y		;

LDA #$31
STA $0303|!Base2,y		;store as tile property

INY #4

LDA $00		
CLC
ADC #$22
STA $0300|!Base2,y		;shell tile X-pos

LDA $01				;
STA $0301|!Base2,y		;shell tile Y-pos

LDA #$62
STA $0302|!Base2,y		;

LDA #$31
STA $0303|!Base2,y		;store as tile property

INY #4


LDA !14C8,x			;
;EOR #$08			;
STA $03				;set scratch ram to contains information on wether sprite's in normal status.

LDA $00				;
CLC
ADC #$10
STA $0300|!Base2,y		;shell tile X-pos

LDA $01				;
STA $0301|!Base2,y		;shell tile Y-pos

PHY				;
LDA $03				;if dead, don't animate shell
CMP #$08
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




LDA #$04	
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