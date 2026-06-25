;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; Toggle Carry by dtothefourth
;
; Adds a RAM toggle which disables
; carrying items when it is set,
; or just totally disabled carrying
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

!FullDisable   = 0           ;If 1, remove carrying entirely
!CarryOverride = $18E6|!addr ;FreeRAM, cleared on level load, only used if not fully disabling


!addr = $0000
!bank = $800000

if read1($00FFD5) == $23
sa1rom
!addr = $6000
!bank  = $000000
endif


org $01AA5E
    autoclean JSL Carry
    NOP #2

org $01E6D2
    autoclean JSL Carry
    NOP #2    

org $00F26F
    autoclean JSL ThrowBlock
    NOP #2    


freecode
   
    Carry:
        if !FullDisable
        LDA #$01
        RTL
        else
        LDA !CarryOverride
        BEQ +
        LDA #$01
        RTL
        +
        LDA $1470|!addr
        ORA $187A|!addr
        RTL
        endif
   
    ThrowBlock:
        if !FullDisable
        LDA #$01
        RTL
        else
        LDA !CarryOverride
        BEQ +
        LDA #$01
        RTL
        +
        LDA $148F|!addr
        ORA $187A|!addr
        RTL
        endif