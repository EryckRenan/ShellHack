; Name: Clear Blue P-Switch Timer
; Author: Cracka
; Inspiration: PowStar Block (By Immortality, with help from Kipernal)

; Set to act like 25
db $37

JMP Mario : JMP Mario : JMP Mario
JMP Mario : JMP Mario : JMP Mario : JMP Mario
JMP Mario : JMP Mario : JMP Mario
JMP Mario : JMP Mario

Mario:
LDA #$01		; Load the blue p-switch timer...
STZ $1490		; Reduce the blue p-switch timer to 0
RTL 			; Return!

print "A block that reduces blue p-switch timer to zero when mario passes through."