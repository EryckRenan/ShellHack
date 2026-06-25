;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
;	Avoiding Disco Shell by dtothefourth
;
;	Just a quick edit of the disco shell that makes it
;   move away from Mario instead of towards
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


!MaxRightSpeed = $20
!MaxLeftSpeed = $E0

WallBumpSpeed:
db !MaxLeftSpeed,!MaxRightSpeed

Tilemap:
db $8E,$8A,$8C,$8A

Print "INIT ",pc
INC !187B,x		
LDA #$09
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
BEQ ++
CMP #$09
BEQ ++
RTS

++


LDA #$0A
STA !14C8,x

LDA !14C8,x
CMP #$0A
BEQ .NoPaletteChange

LDA $13
AND #$01		
BNE .NoPaletteChange		

LDA !15F6,x			
INC #2				
AND #$CF			
STA !15F6,x			

.NoPaletteChange		

JSR GFX				

LDA $9D				
BNE .Re
LDA !14C8,x
CMP #$02
BEQ .Re
LDA #$04				
%SubOffScreen()		

%SubHorzPos()		
TYA	
EOR #$01			
STA !157C,x			


LDA !B6,x			
LDY !157C,x			
;CPY #$00			
BNE .NoRightSpeed	
CMP #!MaxRightSpeed	
BPL .NoMoreSpeed	

INC !B6,x			
INC !B6,x
INC !B6,x
INC !B6,x			
BRA .NoMoreSpeed	
					
.NoRightSpeed		
CMP #!MaxLeftSpeed	
BMI .NoMoreSpeed	
DEC !B6,x			
DEC !B6,x			
DEC !B6,x			
DEC !B6,x
.NoMoreSpeed
LDA !1588,x		
AND #$03		
BEQ .NoWall		
PHA				
JSR WallHit		
PLA				
AND #$03		
DEC				
TAY				
LDA WallBumpSpeed,y	
STA !B6,x			

.NoWall


JSL $01803A|!BankB	


.Re
LDA #$04        
%SubOffScreen()     
RTS

XDisp:
db $04,$00,$FC,$00

YDisp:
db $F1,$00,$F0,$00

XFlip:
db $00,$00,$00,$40		;only last byte is flip for one of shell's frames

GFX:
%GetDrawInfo()

LDA !14C8,x			
;EOR #$08			
STA $03				

LDA $00				
STA $0300|!Base2,y	

LDA $01				
STA $0301|!Base2,y	

PHY				
LDA $03				
CMP #$0A
BNE .NoAnim			


LDA $14				
.NoAnim
LSR #2				
AND #$03			
TAY				
LDA XFlip,y			
STA $02				
LDA Tilemap,y		
PLY				
STA $0302|!Base2,y		

LDA $02				
ORA !15F6,x			
ORA $64				
STA $0303|!Base2,y	



LDX $15E9|!Base2	

LDA #$00			
LDY #$02			
JSL $01B7B3|!BankB	
RTS				

WallHit:
LDA #$01			
STA $1DF9|!Base2	

LDA !15A0,x			
BNE .NoBlockHit		

LDA !E4,x			
SEC : SBC $1A		
CLC : ADC #$14		
CMP #$1C			
BCC .NoBlockHit		

LDA !1588,x			
AND #$40			
ASL #2				
ROL				
AND #$01			
STA $1933|!Base2	

LDY #$00			
LDA $18A7|!Base2	
JSL $00F160|!BankB	

LDA #$05			
STA !1FE2,x			

.NoBlockHit
RTS				