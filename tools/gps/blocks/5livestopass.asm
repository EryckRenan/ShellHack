; Passable (Horizontally) Once X Or More Freeram Value Is Met
; By Cracka (Tweaked/Modified Below Resource)

; Pass If 5+ Lives
; By Ersanio

; (SA-1 Compatibility Update by Fermin Acosta Jr.)

; Note: If using a midway/checkpoint, may require additional level UberASM if freeram used is cleared on level load!

!freeram	= $7E007C		; $7E007C Empty. Cleared on reset, titlescreen load, overworld load and level load. Length: 1 byte.
!value		= $04			; Set quantity to meet or exceed

db $42

JMP Code : JMP Code : JMP Code
JMP Code : JMP Code
JMP Return : JMP Code
JMP Code : JMP Code : JMP Code

Code:
	LDA !freeram|!addr
	CMP #!value				; Check greater than or equal to !value
	BPL Return				; If equal/greater than !value...
	LDA #$30				;\
	STA $1693|!addr			;| Set block to act as solid (130)
	LDY #$01				;/

Return:
	RTL

print "This block is solid, and only becomes passable once !freeram value has been met or exceeded."