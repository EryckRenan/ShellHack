; - this tile boosts any sprite that touches it horizontally; Mario can pass through; insert as 25
; - the value of !boostspeed can be changed; $0002 means the sprite will be boosted rightward 2 pixels per frame, $FFFE means it will be boosted leftward 2 pixels per frame, etc.
; - code by Katun24

!boostspeed = $0002

db $42
JMP Return			; Mario touching the tile from below
JMP Return			; Mario touching the tile from above
JMP Return			; Mario touching the tile from the side
JMP BoostSprite		; sprite touching the tile from above or below
JMP BoostSprite		; sprite touching the tile from the side
JMP Return			; capespin touching the tile
JMP Return			; fire flower fireball touching the tile
JMP Return			; Mario touching the upper corners of the tile
JMP Return			; Mario's lower half is inside the block
JMP Return			; Mario's upper half is inside the block

BoostSprite:
	LDA $14C8,X				; return if the sprite status is below 8 (= non-alive)
	CMP #$08
	BCC Return
	
	LDA $14E0,X
	XBA
	LDA $E4,X
	REP #$20
	CLC : ADC #!boostspeed
	SEP #$20
	STA $E4,X
	XBA
	STA $14E0,X

Return:
	RTL