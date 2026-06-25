; Blocks Mario and sprites in a particular direction.
;  Which direction changes depending on whether a specified switch is on or not.
;
; Set to act like 025.
;
; Note: you can still use two solid sprites (e.g. two keys) to push Mario though.
;  Not sure if there's a good solution to that.

!switch         =   $14AF   ; RAM address to use for the switch (default: ON/OFF switch)

!on_direction   =   1       ; Direction to block when the switch is ON/not activated.
!off_direction  =   0       ; Direction to block when the switch is OFF/activated.
    ; 0 = above (v)
	; 1 = below (^)
	; 2 = left  (>)
	; 3 = right (<)


db $37
JMP MarioV : JMP MarioV : JMP MarioH : JMP SpriteV : JMP SpriteH : JMP Return
JMP MarioFireBall : JMP Return : JMP MarioH : JMP MarioH : JMP WallFeet : JMP WallBody

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Above/Below
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; look at this fresh crop of if statements aren't they beautiful

MarioV:
	if !on_direction <= 1 || !off_direction <= 1 
		LDA !switch
		BNE .off
		if !on_direction <= 1
			LDA $7D
			if !on_direction == 0
				BPL MakeLedge
			else
				BMI MakeSolid
			endif
		endif
		RTL
		
	  .off
		if !off_direction <= 1
			LDA $7D
			if !off_direction == 0
				BPL MakeLedge
			else
				BMI MakeSolid
			endif
		endif
	endif
	RTL

SpriteV:
	if !on_direction <= 1 || !off_direction <= 1 
		LDA !switch
		BNE .off
		if !on_direction <= 1
			LDA $AA,x
			if !on_direction == 0
				BPL MakeLedge
			else
				BMI MakeSolid
			endif
		endif
		RTL
		
	  .off
		if !off_direction <= 1
			LDA $AA,x
			if !off_direction == 0
				BPL MakeLedge
			else
				BMI MakeSolid
			endif
		endif
	endif
	RTL


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Wallrun
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

WallFeet:
	LDA !switch
	BNE .off
	if !on_direction <= 1
		RTL
	else
		LDA $13E3
		if !on_direction == 3
			CMP #$06
		else
			CMP #$07
		endif
		BEQ MakeSolid
		RTL
	endif
.off
	if !off_direction <= 1
		RTL
	else
		LDA $13E3
		if !off_direction == 3
			CMP #$06
		else
			CMP #$07
		endif
		BEQ MakeSolid
		RTL
	endif
	RTL

WallBody:
	LDA !switch
	if !off_direction == 1
		BNE MakeSolid
	else
		BNE .off
	endif
	if !on_direction == 1
		BRA MakeSolid
	endif
.off	RTL


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Left/Right
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

MarioH:
	if !on_direction >= 2 || !off_direction >= 2 
		LDA !switch
		BNE .off
		if !on_direction >= 2
			REP #$20
			LDA $9A
			AND #$FFF0
			if !on_direction == 2
				LDX $7B
				BMI .noWall
				CPX #$35
				BCC .noWall
				STZ $7B
				SEC
				SBC #$000E
				STA $94
			  .noWall
				SEC
				SBC #$0009
				CMP $94
				SEP #$20
				BCS MakeSolid
			else
				LDX $7B
				BPL .noWall
				CPX #$CA
				BCS .noWall
				STZ $7B
				CLC
				ADC #$000E
				STA $94
			  .noWall
				CLC
				ADC #$0009
				CMP $94
				SEP #$20
				BCC MakeSolid
			endif
		endif
		RTL
		
	  .off
		if !off_direction >= 2
			REP #$20
			LDA $9A
			AND #$FFF0
			if !off_direction == 2
				SEC
				SBC #$0009
				CMP $94
				SEP #$20
				BCS MakeSolid
			else
				CLC
				ADC #$0009
				CMP $94
				SEP #$20
				BCC MakeSolid
			endif
		endif
	endif
	RTL

SpriteH:
	if !on_direction >= 2 || !off_direction >= 2
		LDA !switch
		BNE .off
		if !on_direction >= 2
			LDA $B6,x
			if !on_direction == 2
				BPL MakeSolid
			else
				BMI MakeSolid
			endif
		endif
		RTL
		
	  .off
		if !off_direction >= 2
			LDA $B6,x
			if !off_direction == 2
				BPL MakeSolid
			else
				BMI MakeSolid
			endif
		endif
	endif
	RTL


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Fireballs suck
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

MarioFireBall:
	if !on_direction <= 1 || !off_direction <= 1 
		LDA !switch
		BNE .offVert
		if !on_direction <= 1
			LDA $173D,x
			if !on_direction == 0
				BPL MakeLedge
			else
				BMI MakeSolid
			endif
		endif
		RTL
		
	  .offVert
		if !off_direction <= 1
			LDA $173D,x
			if !off_direction == 0
				BPL MakeLedge
			else
				BMI MakeSolid
			endif
		endif
	endif

	if !on_direction >= 2 || !off_direction >= 2
		LDA !switch
		BNE .offHorz
		if !on_direction >= 2
			LDA $1747,x
			if !on_direction == 2
				BPL MakeSolid
			else
				BMI MakeSolid
			endif
		endif
		RTL
		
	  .offHorz
		if !off_direction >= 2
			LDA $1747,x
			if !off_direction == 2
				BPL MakeSolid
			else
				BMI MakeSolid
			endif
		endif
	endif
	RTL



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Returns
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

MakeLedge:
	LDA #$00
	BRA StoreTile

MakeSolid:
	LDA #$30
StoreTile:
	LDY #$01
	STA $1693
Return:
	RTL



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; thanks, asar
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; ON direction
	if !on_direction == 0
		!strA = "above"
	endif
	if !on_direction == 1
		!strA = "below"
	endif
	if !on_direction == 2
		!strA = "the left"
	endif
	if !on_direction == 3
		!strA = "the right"
	endif

; OFF direction
	if !off_direction == 0
		!strB =  "above"
	endif
	if !off_direction == 1
		!strB =  "below"
	endif
	if !off_direction == 2
		!strB =  "the left"
	endif
	if !off_direction == 3
		!strB =  "the right"
	endif
	
print "If the ON/OFF switch is on, solid when hit from !strA. If off, solid when hit from !strB."