; Spawn Carried Customizable Shell
; Modified by Cracka

; Based on Carryable Sprite Spawner Blocks Pack
; By Nowieso

; Set block to act as 25

!sfx            = $10
!sfx_bank       = $1DF9
!palOrientation = $08           ; $08-0F = normal orientation, $00-07 = y flipped orientation
!spawnSprite    = $11           ; $04 = green, $05 = red, $06 = blue, $07 = yellow, if spawning custom sprite... set !customSprite = 1
!customSprite   = 0             ; 1 = above sprite number is custom
!disco          = 0             ; 1 = makes shell disco
!ghost          = 0             ; 1 = removes interaction with other sprites
!invincible     = 0             ; 1 = makes shell invincible to star/cape/fire/bounce block
!offscreen      = 0             ; 1 = process shell when offscreen
!friendly       = 0             ; 1 = removes interaction with player

db $37

JMP Mario : JMP Mario : JMP Mario : JMP Return
JMP Return : JMP Return : JMP Return : JMP Mario
JMP Mario : JMP Mario : JMP Return : JMP Return

Mario:
    LDA $1470|!addr             ;do not run the code if player is carrying something
    ORA $148F|!addr             ;do not run the code if player is carrying something
    ORA $187A|!addr             ;do not run the code if player is riding yoshi
    ORA $74                     ;do not run the code if player is climbing
    BNE Return

checkInput:
    LDA $15
    BIT #$40
    BEQ Return

spawnSprite:
    LDA #!spawnSprite           ; sprite number to spawn
    CMP #$53
    BNE +
    JSL $07F7D2
    +

    if !customSprite
        SEC                     ; use SEC for custom sprites

    elseif !customSprite == 0
        CLC                     ; use CLC for vanilla sprites

    endif

    %spawn_sprite()
    BCS Return
    %move_spawn_into_block()    ; move sprite position to block

    LDA #$0B                    ; sprite status: stunned
    STA !14C8,x

    LDA #!spawnSprite           ; sprite number to spawn
    CMP #$53                    ; throwblock
    ORA #$11                    ; buzzy beetle
    BNE +
    LDA #$FF
    STA !1540,x
    +

    LDA #!palOrientation        ; sets palette color/orientation of shell
    SEC : SBC #$08              ; math to format palette/orientation value
    ASL
    STA !15F6,x

    if !ghost
        LDA !1686,x
        ORA #$08                ; remove interaction with other sprites
        STA !1686,x
    endif

    if !disco
        LDA #$01                ; set disco flag
        STA !187B,x
    endif

    if !invincible && !offscreen && !friendly
        LDA !167A,x
        ORA #$86                ; set tweaker bit to make invincible to star/cape/fire/bounce blk.
        STA !167A,x

    elseif !invincible && !offscreen
        LDA !167A,x
        ORA #$06                ; set tweaker bit to make invincible to star/cape/fire/bounce blk.
        STA !167A,x

    elseif !invincible && !friendly
        LDA !167A,x
        ORA #$82                ; set tweaker bit to make invincible to star/cape/fire/bounce blk.
        STA !167A,x

    elseif !offscreen && !friendly
        LDA !167A,x
        ORA #$84                ; set tweaker bit to make invincible to star/cape/fire/bounce blk.
        STA !167A,x

    elseif !invincible
        LDA !167A,x
        ORA #$02                ; set tweaker bit to make invincible to star/cape/fire/bounce blk.
        STA !167A,x

    elseif !friendly
        LDA !167A,x
        ORA #$80                ; set tweaker bit to make invincible to star/cape/fire/bounce blk.
        STA !167A,x

    elseif !offscreen
        LDA !167A,x
        ORA #$04                ; set tweaker bit to make invincible to star/cape/fire/bounce blk.
        STA !167A,x

    endif

destroyBlock:
    %erase_block()
    %glitter()
    LDA #!sfx
    STA !sfx_bank|!addr 

Return:
    RTL

print "This block spawns a custom shell that is automatically carried & the block destroys itself afterwards."