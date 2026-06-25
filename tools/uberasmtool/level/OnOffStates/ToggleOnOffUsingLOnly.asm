; Flip On/Off Using L Only
; By SwiggittyWiggitty

; Based On Flip On/Off on LR v1.0
; By: Tattletale
; https://www.smwcentral.net/?p=section&a=details&id=21711

main:
    LDA $18
    AND #$20          ; Check R button
    BEQ .done         ; If not pressed, skip

    LDA $14AF|!addr   ; Load current state
    EOR #$01          ; Toggle it (0↔1)
    STA $14AF|!addr   ; Store back

    LDA #$0B
    STA $1DF9         ; Play ON/OFF switch sound

.done:
    RTL