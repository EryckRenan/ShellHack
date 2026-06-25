; Offscreen indicator
; Author: Thomas
; Source: https://www.smwcentral.net/?p=section&a=details&id=40804

; Displays a small sprite at the top/bottom of the screen to show where Mario is when he's offscreen.
;  Change the settings below as you need to, then insert with UberASM as level ASM.
;
; Note that this will not work in game mode ASM due to timing issues,
;  so you should use the patch version instead.
;
; Alternatively, you can change the "main:" label to "nmi:",
;  though using NMI for this kind of thing isn't ideal.

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;; GRAPHICAL SETTINGS ;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Tile and YXPPCCCT for the marker when Mario is above the screen.
!tileAbove  =   $1D     ; Tile number
!propsAbove =   $28     ; YXPPCCCT properties
!sizeAbove  =   0       ; Size of the tile. 0 = 8x8, 1 = 16x16.

; Tile and YXPPCCCT for the marker when Mario is below the screen.
!tileBelow  =   $1D     ; Tile number
!propsBelow =   $28     ; YXPPCCCT properties
!sizeBelow  =   0       ; Size of the tile. 00 = 8x8, 1 = 16x16.

; Minimum number of pixels the tile should be offset from the very top/bottom of the screen.
;  Use this if you want a small gap between the very edge and the actual tile.
!yOffAbove  =   $02     ; From the top of the screen
!yOffBelow  =   $02     ; From the bottom of the screen

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;; SCALING SETTINGS ;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Scaling makes it so that as Mario moves farther off screen,
;  the marker will move towards the center of the screen to indicate how far off he is.

; This value controls the ratio of the distance offscreen to how far the marker moves.
;  If 0, scaling will not be applied.
;  Otherwise, it should be a power of 2, i.e. 1, 2, 4, 8, etc.
;   A value of 1 indicates a constant ratio. 2 is 1/2, 4 is 1/4, etc.
!scaleRate  =   2

; If using scaling, these two values indicate the maximum distance the
;  marker should be allowed to move away from its base offset.
!yAboveMax  =   $40
!yBelowMax  =   $40

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;; OTHER SETTINGS ;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

!oamIndex   =   $0000   ; OAM index (from $0200) to use.
    ; ^ don't touch this one unless you know how it works.
    ;   this default value isn't really used by much so it should be fine.

  
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

main:
    LDA $71
    CMP #$09
    BEQ .ret
    LDY #$00
    REP #$20
    LDA $80
    BMI .above
    LDX $19
    BNE +
    CLC : ADC #$0008
  + SEC : SBC #$00D9
    BMI .ret
    STA $00
    INY
    BRA .offscreen
    
  .above:
    SEC : SBC #$FFE1
    BPL .ret
    EOR #$FFFF : INC
    STA $00
    
  .offscreen:
    SEP #$20
    LDA $7E
    CLC : ADC XOffs,y
    STA $0200|!addr+!oamIndex
    if !scaleRate > 0
        LDA $01
        BNE .max
        LDA $00
        if !scaleRate > 1 : LSR #log2(!scaleRate)
        CLC : ADC MinYOffs,y
        CMP MaxYOffs,y
        BCC .gotYOff
      .max:
        LDA MaxYOffs,y
      .gotYOff:
        CPY #$00
        BEQ .setYOff
        EOR #$FF : INC
        CLC : ADC #$D7
      .setYOff:
    else
        LDA yOffs,y
    endif
    STA $0201|!addr+!oamIndex
    LDA Tiles,y
    STA $0202|!addr+!oamIndex
    LDA Props,y
    STA $0203|!addr+!oamIndex
    LDA Sizes,y
    STA $0420|!addr+(!oamIndex/4)
  .ret:
    SEP #$20
    RTL

XOffs:
    db $04-(!sizeAbove*4),$04-(!sizeBelow*4)
Tiles:
    db !tileAbove,!tileBelow
Props:
    db !propsAbove,!propsBelow
Sizes:
    db !sizeAbove*2,!sizeBelow*2
    
if !scaleRate > 0
    MinYOffs:
        db !yOffAbove,!yOffBelow+(!sizeBelow*8)
    MaxYOffs:
        db !yAboveMax+!yOffAbove,!yBelowMax+!yOffBelow+(!sizeBelow*8)
else
    yOffs:
        db !yOffAbove,$D8-(!sizeBelow*8)-!yOffBelow
endif