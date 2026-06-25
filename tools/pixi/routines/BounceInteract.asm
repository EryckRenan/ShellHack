;=====================================================
; Routine for custom interaction with bounce sprites
; By Erik (basically a disassembly of $0293CE)
; Works with Note Block expansion
;
; Output: Y destroyed, carry set if contact with
; a bounce sprite
;=====================================================

optimize address mirrors

if read2($029066) == $904C  ;   Note Block Expansion check
    !max_blocks = 14

    !nb_freeram = $0DE5
    if !sa1
        !nb_freeram = $3500
    endif

    struct note_block !nb_freeram
        .exists:    skip !max_blocks    ;   00 if a block doesn't exist. 01 if it's in init. 80 if it's in main.
        .x_lo:      skip !max_blocks    ;   X position of the block, low byte.
        .y_lo:      skip !max_blocks    ;   Y position of the block, low byte.
        .x_hi:      skip !max_blocks    ;   X position of the block, high byte.
        .y_hi:      skip !max_blocks    ;   Y position of the block, high byte.
        .x_speed:   skip !max_blocks    ;   Block's X speed.
        .y_speed:   skip !max_blocks    ;   Block's Y speed.
        .x_acc:     skip !max_blocks    ;   Accumulationg fraction bits for block's X speed.
        .y_acc:     skip !max_blocks    ;   Accumulationg fraction bits for block's Y speed.
        .direction: skip !max_blocks    ;   Direction the block has. Layer the block is on. Sprite activated flag. (LS----DD)
        .map16:     skip !max_blocks    ;   Value of $9C for the note block. (FF = custom Map16 tile)
        .timer:     skip !max_blocks    ;   Duration of the block.
        .spr_index: skip !max_blocks    ;\  If any, sprite index of a sprite interacting with the note block.
                                        ;/  If fireball interaction is enabled, bit 7 is the fireball enabled flag.
        .free:      skip 1              ;   Holds the next free slot to generate a block.
    endstruct

    struct quake extends note_block
        .type:  skip !max_blocks    ;   Quake sprite type. 0 = empty, 1 = hitting/breaking a block, 2 = Yoshi's stomp.
        .x_lo:  skip !max_blocks    ;   Quake sprite X position, low byte.
        .x_hi:  skip !max_blocks    ;   Quake sprite X position, high byte.
        .y_lo:  skip !max_blocks    ;   Quake sprite Y position, low byte.
        .y_hi:  skip !max_blocks    ;   Quake sprite Y position, high byte.
        .timer: skip !max_blocks    ;   Time for a bounce sprite to interact with a normal sprite. Starts at #$06 and decrements.
    endstruct
else
    !max_blocks = $04

    struct note_block $16CD|!addr
    endstruct

    struct quake extends note_block
        .type:  skip !max_blocks    ;   Quake sprite type. 0 = empty, 1 = hitting/breaking a block, 2 = Yoshi's stomp.
        .x_lo:  skip !max_blocks    ;   Quake sprite X position, low byte.
        .x_hi:  skip !max_blocks    ;   Quake sprite X position, high byte.
        .y_lo:  skip !max_blocks    ;   Quake sprite Y position, low byte.
        .y_hi:  skip !max_blocks    ;   Quake sprite Y position, high byte.
        .timer: skip !max_blocks    ;   Time for a bounce sprite to interact with a normal sprite. Starts at #$06 and decrements.
    endstruct
endif

?bounce_interact:
    LDY.b #(!max_blocks-1)
?-  LDA note_block.quake.type,y
    BNE ?.check_contact
?.next
    DEY
    BPL ?-
    CLC
    RTL

?.check_contact
    LDA !1632,x
    PHY
    LDY $74
    BEQ ?+
    EOR #$01
?+  PLY
    EOR $13F9|!addr
    BNE ?.next
    JSL $03B69F|!bank
    LDA note_block.quake.type,y
    TAX
    LDA note_block.quake.x_lo,y
    CLC
    ADC.l $029656,x
    STA $00
    LDA note_block.quake.x_hi,y
    ADC.l $029658,x
    STA $08
    LDA.l $02965A,x
    STA $02
    LDA note_block.quake.y_lo,y
    CLC
    ADC.l $02965C,x
    STA $01
    LDA note_block.quake.y_hi,y
    ADC.l $02965E,x
    STA $09
    LDA.l $029660,x
    STA $03
    JSL $03B72B|!bank
    LDX $15E9|!addr
    BCC ?.next
; Carry set, interacting with at least one bounce sprite.
    RTL

