print "Makes Mario spin jump when he touches the top of the block"

db $42

JMP Return : JMP Mario : JMP Return : JMP Return : JMP Return : JMP Return : JMP Return
JMP Return : JMP Return : JMP Return

Mario:
  LDA #$01     ; set spin jump flag
  STA $7E140D
  LDA #$04     ; play spin jump sound
  STA $1DFC
  LDA #$B0     ; set y-speed
  STA $7E007D
	LDA $19      ; if not small mario and spin jumping, explode the block
	CMP #$00     ; if this CMP isn't here, mario becomes small mario...
	BNE Explode
Return:
  RTL
  
  
Explode:

  %shatter_block()
  RTL