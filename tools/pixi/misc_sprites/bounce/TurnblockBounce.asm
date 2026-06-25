; Turnblock bounce sprite
; by spooonsss, based on Thomas' all.log

; Put this into pixi/misc_sprites/bounce, then add to pixi list.txt:
; BOUNCE:
; 1 TurnblockBounce.asm

; For Pixi v1.40, on SA-1, download bugfix file for pixi/routines/bounce/GetDrawInfo.asm
;   https://github.com/JackTheSpades/SpriteToolSuperDelux/blob/master/routines/Bounce/GetDrawInfo.asm
;
; If spawning this using GPS v1.4.4 %spawn_bounce_sprite(), change the 3 defines starting with !RAM_BounceMap16Low to match pixi's asm/sa1def.asm
;   (on SA-1, starting with !RAM_BounceMap16Low_SA1)
; GPS/defines.asm:
; !RAM_BounceMap16Low = $16C1|!addr
; !RAM_BounceMap16High = $1968|!addr
; !RAM_BounceTileTbl = $196C|!addr
; ; These are the SA-1 defines to the above bounce block sprite defines.
; !RAM_BounceMap16Low_SA1 = $16C1|!addr
; !RAM_BounceMap16High_SA1 = $1968|!addr
; !RAM_BounceTileTbl_SA1 = $196C|!addr
;
;   (though !RAM_BounceTileTbl isn't read by this bounce block)

!tile_number = $40 ; turnblock

print "MAIN", pc
TurnBlockSpr:                     ;-----------| Turnblock bounce sprite MAIN
    LDA $9D                       ;$029076    |\ Return if game frozen.
    BNE Return0290CD              ;$029078    |/
    LDA.w !bounce_init,X          ;$02907A    |\
    BNE CODE_029085               ;$02907D    || If the block was just hit,
    INC.w !bounce_init,X          ;$02907F    || spawn an invisible solid block in its place.
    %InvisibleMap16()
CODE_029085:                      ;           |
    LDA.w !bounce_timer,X         ;$029085    |\ Branch if currently in the 'spinning turnblock' phase.
    BEQ CODE_0290BB               ;$029088    |/
    CMP.b #$01                    ;$02908A    |\ Branch if not time to erase the sprite.
    BNE CODE_0290A8               ;$02908C    |/
    LDA.w !bounce_y_low,X         ;$02908E    |\
    CLC                           ;$029091    ||
    ADC.b #$08                    ;$029092    ||
    AND.b #$F0                    ;$029094    || Center the bounce sprite on the turnblock.
    STA.w !bounce_y_low,X         ;$029096    ||
    LDA.w !bounce_y_high,X        ;$029099    ||
    ADC.b #$00                    ;$02909C    ||
    STA.w !bounce_y_high,X        ;$02909E    |/
    %BounceSetupMap16()
    LDA !bounce_map16_high,x
    XBA
    LDA !bounce_map16_low,x
    REP #$20
    INC
    %ChangeMap16()
    SEP #$20

    BRA CODE_0290BB                ;$0290A6    |

CODE_0290A8:                       ;```````````| Turnblock's sprite isn't done yet.
    %UpdatePos()
    LDA.w !bounce_y_speed,X        ;$0290AE    ||
    CLC                            ;$0290B1    || Set Y speed based on the direction the block is moving.
    ADC #$13 ; ADC.w DATA_029072,Y ;$0290B2
    STA.w !bounce_y_speed,X        ;$0290B5    |/
    LDA.b #!tile_number
    ;LDA !bounce_table_3,x
    %BounceGenericDraw()

CODE_0290BB:                       ;           |
    LDA.w $18CE|!addr,X            ;$0290BB    |\
    BEQ CODE_0290C4                ;$0290BE    || Handle the spinning turnblock's timer.
    DEC.w $18CE|!addr,X            ;$0290C0    |/
    RTL

CODE_0290C4:                       ;```````````| Time to return the turnblock back to normal.
    %BounceSetupMap16()
    LDA !bounce_map16_high,x
    XBA
    LDA !bounce_map16_low,x
    REP #$20
    %ChangeMap16()
    SEP #$20
    STZ !bounce_num,x
Return0290CD:
    RTL


