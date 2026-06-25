!destroy	 = 1				;1 = destroy after use, 0 = don't destroy
!power_left  = $A0				;how much the block will boost you leftwards, possible values are $80-$FF
!power_up	 = $A0				;how much the block will boost you upwards, possible values are $80-$FF
!sfx		 = $09				;sfx to play
!sfx_bank	 = $1DFC			;sfx bank to use
db $37
JMP Mario : JMP Mario : JMP Mario : JMP Return
JMP Return : JMP Return : JMP Return : JMP Mario
JMP Mario : JMP Mario : JMP Mario : JMP Mario
Mario:
	LDA #!power_left
	STA $7B
	LDA #!power_up
	STA $7D
	LDA #!sfx
	STA !sfx_bank|!addr
if !destroy == 1
	%create_smoke()
	%erase_block()
endif
Return:
RTL
print "This block boosts the player up-left."