;===========================================================;
;															;
; Float While Carrying Specific Shell						;
; By Cracka													;
;															;
; When carrying/holding specified sprite(s), and pressing	;
;  the A or B button, the player will either hover, or		;
;  float upward/downward.									;
;															;
; Based on Discoshell ON/OFF By 4thDragon					;
;															;
;===========================================================;

;!Freeram		= $7E007C			; Make sure this is the same as the conditional block used in level
!CarriedState	= $09				; 01 = Passable
!DefaultState	= $00				; 00 = Solid
!DiscoCarry		= 1					; 1 = Yes, 0 = No, the shell won't turn into a disco as long as you carry the shell
!SaveProps		= !1510				; Leave this as is, unless you have a reason!
!FloatSpeed		= $F0				; 00 = No Vertical Change (Hover), 05-0F Downward Float, FA-F0 Upward Float
!AdditionalHold	= 1					; 0 = No Additional Button Hold Required, 1 = Additional Button Hold Required
!Button			= $80				; Additional Button Required To Be Held (byetUDLR) 01=Right, 02=Left, 04=Down, 08=Up, 10=Start, 20=Select, 40=Y or X, 80=B or A
!Custom			= 0					; 1 = Custom, 0 = Not Custom

spritetable:
;	db $04, $05, $06, $07			; sprite-IDs
	db $06							; blue shell

main:
	LDA $9D							; sprites locked?
	ORA $13D4|!addr					; game paused?
	BNE return						; if so do nothin
	STZ $85
;if !AdditionalHold
;	LDA $15
;	AND #!Button
;	BEQ return
;endif

start:
	LDX #!sprite_slots-1			; spritetable 12 bytes 
outloop:
;	LDY #$04						; 5 slots
	LDY #$00						; 1
inloop:
	LDA spritetable,y
if !Custom
	CMP $7FAB9E,x					; spawn custom sprite
else
	CMP $9E,x						; spawn vanilla sprite
endif
	BNE next_sprite
	LDA !sprite_status,x			; sprite status
;	CMP #$09						; carryable
;	BEQ carry_check
;	CMP #$0A						; kicked
;	BEQ carry_check
;if !DiscoCarry
	CMP #$0B						; carry
	BEQ carry_check
	CMP #$07
	BEQ mouth_check
;endif
;	LDA #$FF	;\reset timer
;	STZ $13F3|!addr

	LDA #$12
	STA $1DFC

	BRA next_sprite
return:
	RTL
carry_check:
	LDA $148F|!addr					; player holding object flag
	ORA $1470|!addr					; carrying something flag
	BNE switch_check				; carrying, set carried state
	BRA switch_off
mouth_check:
;	LDA $18E7|!addr					; yoshi holding object flag
;	BNE switch_check				; carrying, set carried state


switch_check:
	LDA #$01
	STA $85

;	LDA $00		 					; switch flag ($00 = ON, $01 = OFF)
;	BEQ switch_off
;	.switch_on:
;	LDA !sprite_misc_187b,x
;	CMP #$01
;	BEQ next_sprite
;	LDA #$01
;	STA !sprite_misc_187b,x			; disco flag			  
;	LDA #$0A						; kicked 
;	STA !sprite_status,x			
	LDA !sprite_oam_properties,x	; sprite props
	STA !SaveProps,x				; save props for later
	LDA $94							;\
	SEC								;|
	SBC !sprite_x_low,x				;|
	STA $0E							;| SubHorzPos: 			
	LDA $95							;| mario left or right from the sprite	
	SBC !sprite_x_high,x			;|							
	STA $0F							;|
	BPL mario_right					;/
mario_left:
	LDA !sprite_speed_x,x
	BNE .end1
	LDA #$E0
	STA !sprite_speed_x,x
	.end1
	BRA next_sprite
mario_right:
	LDA !sprite_speed_x,x			; sprite Xspeed
	BNE .end2
	LDA #$20
	STA !sprite_speed_x,x
	.end2
	BRA next_sprite
switch_off:
	LDA !sprite_misc_187b,x
	BEQ next_sprite
	STZ !sprite_misc_187b,x
	LDA #$09
	STA !sprite_status,x
	STZ !sprite_speed_x,x
	LDA !SaveProps,x				;set props when off	
	STA !sprite_oam_properties,x
		STZ $85							; turn swim off
		BRA next_sprite
next_sprite:
	DEY
	BPL inloop
	DEX
	BPL outloop
	RTL
