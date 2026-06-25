;This is a stopper block that holds a dropped/kicked throw block
;and maintains it from disappearing if touched. Note: there is
;a rare chance that the throw block could "jump" straight up
;from the block and back down. This is also useful for
;"pixel-perfect kicking the throw block at the percise position".
;behaves $025

!status	= $09	;*$09 = able to be re-carried
		;*$0A = unable to be re-carried
		; but can be spinjumped (for
		; kaizo hacks)

db $42
JMP ret : JMP ret : JMP ret : JMP sprite : JMP sprite : JMP ret
JMP ret : JMP ret : JMP ret : JMP ret

sprite:
	LDA !154C,x	;\so no kicking the throw block repeatly
	CMP #$0C	;|
	BCS ret		;/(prior kicking it causes it breifly to lose interaction)
	LDA !14C8,x	;\if kicked/dropped = hold it
	CMP #$0A	;|
	BEQ holdit	;|
	CMP #$09	;|
	BEQ holdit	;/
ret:
	RTL
holdit:
	LDA #!status	;\become carryable
	STA !14C8,x	;/
	LDA #$F0	;\halt x and y speed
	STA !AA,x	;|
	STZ !B6,x	;/
	LDA #$FF	;\don't expire
	STA !C2,x	;|
	STA !1540,x	;/
	LDA #$01	;\keep facing in one direction
	STA !157C,x	;/

	REP #$20	;\set position..
	LDA $0A		;|
	AND #$FFF0	;|
	STA $9A		;|
	LDA $0C		;|
	AND #$FFF0	;|
	DEC A		;|
	STA $98		;|
	SEP #$20	;/

	LDA $9A		;\..so the centering sprite
	STA !E4,x	;|works.
	LDA $9B		;|
	STA !14E0,x	;|
	LDA $98		;|
	STA !D8,x	;|
	LDA $99		;|
	STA !14D4,x	;/
	RTL