!CarryOverride = $18E6|!addr    ;FreeRAM, cleared on level load, must match CarryToggle.asm

!FullDisable = 0   		;If 1, just disable carrying entirely

!TimedDrop   = 1		;If 1 and not fully disabled, drop after carrying for some amount of time
!CarryTime   = $30 		;Drop item after this many frames
!CoolDown	 = $20		;How long before you can carry something again after dropping
!NoContact   = $0C		;How many frames to make carried sprite not interact with Mario after dropping
!Timer		 = $7FB600  ;FreeRAM, only used if not fully disabling


if !FullDisable

init:
	LDA #$01
	STA !CarryOverride
	RTL

else

init:
	LDA #$00
	STA !Timer
	RTL

main:
	LDA !CarryOverride
	BEQ +
	DEC
	STA !CarryOverride
	RTL
	+

	if !TimedDrop
	LDA $1470|!addr
	ORA $148F|!addr
	BEQ init

	LDA !Timer
	INC
	STA !Timer
	CMP #!CarryTime
	BNE +

	LDA #!CoolDown
	STA !CarryOverride

	STZ $1470|!addr
	STZ $148F|!addr

	LDX #!sprite_slots-1
	-
	LDA !14C8,x
	CMP #$0B
	BNE ++

	LDA #$09
	STA !14C8,x

	LDA #!NoContact
	STA !154C,x

	++
	DEX
	BPL -

	BRA init

	+
	endif

	RTL

endif

