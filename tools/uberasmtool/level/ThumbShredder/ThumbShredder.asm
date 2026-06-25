; Thomas
;;; which item to spawn
!spriteNum      =   $05
; 04 = green shell, 05 = red shell, 06 = blue shell, 07 = yellow shell
; 0F = goomba, 11 = buzzy beetle shell
; 2F = spring, 3E = p-switch, 53 = throwblock, 80 = key

;;; if spawning a p-switch, this is the color switch to spawn
!pswitchColor   =   $00
; 00 = blue, 01 = silver

;;; settings for which buttons will spawn the item (default: L or R)
; which input address to use (either $16 or $18 is recommended; see SMWC's RAM map)
!inputAddress   =   $18
; which buttons to use to spawn the item (see above address)
!inputValue     =   %00110000

;===================================================================================
main:
    LDA !inputAddress
    AND #!inputValue
    BEQ .ret
    LDX #!sprite_slots-1
  - LDA !14C8,x
    BEQ .found
    DEX
    BPL -
  .ret:
    RTL
    
  .found:
    LDA #!spriteNum : STA !9E,x
    LDA #$0B        : STA !14C8,x
    JSL $07F7D2|!bank
    
    if !spriteNum == $3E
        ; set p-switch color
        LDA #!pswitchColor
        STA !C2,x
    endif
    
    LDA $76 : EOR #$01 : TAY
    LDA $94 : CLC : ADC .xOffsL,y : STA !E4,x
    LDA $95 :       ADC .xOffsH,y : STA !14E0,x
    
    LDA #$0D
    LDY $73
    BNE +
    LDY $19
    BNE ++
  + LDA #$0F
 ++ CLC     : ADC $96  : STA !D8,x
    LDA $97 : ADC #$00 : STA !14D4,x

    RTL
    
  .xOffsL: db $0B,$F5
  .xOffsH: db $00,$FF