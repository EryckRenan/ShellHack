; L/R Triggers Bouncing Disco Shell
; By westslasher2

;It's a disco shell that jumps if you press L or R pretty simple stuff.

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Invincible Shell 
; By Sonikku
; 
; Description: A shell that flashes and follows the player, 
; much like state shells are in when Yellow Shellless Koopas
; hop into a shell. This also gives Yoshi the Fire, Flying, and 
; Ground Pound abilities when eaten. The only difference between
; this and the original is that no Yellow Shellless Koopas 
; need to hop into this one for it to flash, as it does it automatically.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; init JSL and main
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

	PRINT "INIT ",pc
	RTL

	PRINT "MAIN ",pc
	PHB
	PHK
	PLB
	JSR SPRITEMAIN
	PLB
	RTL

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; main sprite routine
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
PROP:		
db $00,$00,$00,$40
TILEMAP:		
db $8C,$8A,$8E,$8A

SPRITEMAIN:
%SubOffScreen()
JSL $0190B2	; load generic graphics.
LDY !15EA,x	; load oam..
		
LDA !1570,x	; display a new frame..
AND #$0C	; every #$0C frames.
LSR #2
TAX		; transfer a to x.
LDA TILEMAP,x	; load TILEMAP..
STA $0302|!Base2,y	; store TILEMAP.
STX $0F

LDX $15E9|!Base2	; x = sprite index for sprite..
LDA !15F6,x	; load palette properties..
LDX $0F		
ORA PROP,x	; and load flip..
ORA $64		; and priority bits..
STA $0303|!Base2,y; and store it.

LDA #$F0	; delete the tile behind the shell..
STA $0309|!Base2,y	; since its annoying.

LDX $15E9|!Base2
LDA !14C8,x	; if status..
CMP #$08	; is 8 or less..
BCC DEAD	; its DEAD.
LDA #$01	; if not..
STA !187B,x	; it is flashing and invincible.
INC !1570,x	; increase $1570 (for frame count)..
LDA !15D0,x	; if being eaten..
BNE RETURN	; RETURN.
LDA #$0A	; sprite status is always 0A.
STA !14C8,x	; so it always flashes except when DEAD.
LDA $18
AND #$30	;If the L or R button is pressed
BEQ RETURN	
LDA #$B0	;Boost the shell upward vertically
STA $AA,x
RETURN:	RTS		; RETURN.

DEAD:	
LDA !15F6,x	; flip the..
ORA #$80	; shell..
STA !15F6,x	; vertically.
RTS		; RETURN
