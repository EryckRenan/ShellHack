; L/R Toggles Disco Shell
; Modified By Cracka

; L/R Triggers Bouncing Disco Shell
; By westslasher2

; It's a disco shell that jumps if you press L or R pretty simple stuff.

;=======================================================================================;
;																						;
; Extra Byte 1:																			;
;  Sets The Trigger Type																;
;   $00 = Vanilla Disco Shell.															;
;   $01 = Press Button.																	;
;   $02 = Holding Button.																;
;   $03 = ON/OFF Switch State, Triggered When Set To OFF.								;
;																						;
;=======================================================================================;
;																						;
; Extra Byte 2:																			;
;  Determines Which Variables Are Being Toggled											;
;   $00 = Vanilla Disco Shell.															;
;   $01 = Vertical (Y-Axis) Speed.														;
;   $02 = Horizontal (X-Axis) Speed.													;
;   $03 = Both Vertical (Y-Axis) & Horizontal (X-Axis) Speed.							;
;																						;
;=======================================================================================;
;																						;
; Extra Byte 3:																			;
;  Determines The Vertical (Y-Axis) Speed												;
;   $00 = Frozen In Place.																;
;   $B0 = Vertical Boost.																;
;																						;
;=======================================================================================;
;																						;
; Extra Byte 4:																			;
;  Determines The Horizontal (X-Axis) Speed												;
;   $00 = Frozen In Place.																;
;   $B0 = Vertical Boost.																;
;																						;
;=======================================================================================;

; Note:
;  [01 01 B0 00] westslasher2's Bouncing Disco Shell
;  [03 02 00 10] Titan Mario II - Rightward Kicked Disco Shell (When ON/OFF Switch Is Off)

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

	LDA !extra_byte_1,x
	BEQ RETURN              ; if == #$00, return

	CMP #$03
	BNE .check02
	LDA $14AF|!addr         ; Check ON/OFF Switch Status
	BEQ RETURN              ; Ignore If OFF State
	BRA .done

	.check02:
	CMP #$02
	BNE .check01
	LDA $17                 ; Holding Buttons
	AND #$30                ; L Or R Buttons
	BEQ RETURN
	BRA .done

	.check01:
	CMP #$01
	BNE .done
	LDA $18                 ; Pressed Buttons
	AND #$30                ; L Or R Buttons
	BEQ RETURN

	.done:
	LDA !extra_byte_2,x
	BEQ RETURN              ; if == #$00, return

	CMP #$01
	BNE .check02b
	LDA !extra_byte_3,x     ; Shell's Vertical Speed
	STA $AA,x
	BRA RETURN

	.check02b:
	CMP #$02
	BNE .check03b
	LDA !extra_byte_4,x     ; Shell's Horizontal Speed
	STA $B6,x
	BRA RETURN

	.check03b:
	CMP #$03
	BNE RETURN
	LDA !extra_byte_3,x     ; Shell's Vertical Speed
	STA $AA,x
	LDA !extra_byte_4,x     ; Shell's Horizontal Speed
	STA $B6,x

RETURN:	RTS		; RETURN.

DEAD:	
LDA !15F6,x	; flip the..
ORA #$80	; shell..
STA !15F6,x	; vertically.
RTS		; RETURN
