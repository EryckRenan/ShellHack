; Shell that gives you flight and cape if you land on it by Brakkie
; based on shell disassembly by Kevin

; If extra bit is set spawns as a spiny shell that you can spinjump on

; gives a cape when jumping on a shell or spinning on a spiny shell, also gives fly if set
!GiveFly            = $00   ; 0 = just gives cape; 1 = enables to fly when you get cape

; Palettes of the shells
!ShellPal           = %00001010 ;YXPPCCCT
!SpinyPal           = %00001001

;============================================
; Spin patch Customizable variables cause spin patch dosnt work with these custom shells

!spinDrop       = 1 ; Prefer controller direction for drops-- center otherwise
!spinUp         = 1 ; Center item if spinning when up-throw
!spinKick       = 1 ; Prefer controller direction for kicking
!spinKickCenter = 1 ; Center item if spinning when kick

!dropDirection  = 1 ; Prefer controller direction for drops

;============================================

; SFX that plays when kicking the sprite.
!KickedSFX          = $03
!KickedSFXAddr      = $1DF9|!addr

; Time to disable contact with Mario after kicking the shell.
!KickNoInteractTime = $10

; X speed when kicked sideways by Mario.
!KickXSpeed         = $2E

; Y speed when thrown upwards by Mario.
!KickYSpeed         = $90

; X speed when dropped by Mario.
!DropXSpeed         = $04

; X offset from Mario of the Shell when dropped..
!DropXOffset        = $0D

; X offset from Mario of the Shell when carried. Depends on Mario's direction and turning animation:
; Right, left, left while turning, right when turning, sliding/going down a pipe/climbing while turning, centered.
!CarryXOffset       = $0B,$F5,$04,$FC,$04,$00

; Shell tilemap (the first tile is used twice while spinning, but X flipped the second time)
!SpinyTiles         = $0C,$0A,$0E,$0C
!ShellTiles         = $8C,$8A,$8E,$8C

; Y speed Mario gets when killing a Shell with a spinjump 
; If using a high negative value, it'll act like the spin boost, with the difference that
; the speed given doesn't depend on if you're holding the jump button or not.
!SpinKillYSpeed     = $F8

; Acceleration and max speed when in Disco Shell state
!DiscoXAcceleration = $02
!DiscoMaxXSpeed     = $20

; Speed to give Disco Shells when bumping into a wall
!DiscoBumpXSpeed    = $20

; X speed that Mario gets when jumping on the Disco Shell
!DiscoXBoost        = $18

; Y speed given by purple triangle blocks when a kicked Shell touches it.
!TriangleYSpeed     = $B8

; If 1, the Shell in stationary state will bounce higher on the ground when dropped.
; (Originally this is only done by Goombas).
!DropExtraBoost     = 0

;=======================================================================================;
; Sprite code                                                                           ;
; Don't edit from here unless you know what you're doing!                               ;
;=======================================================================================;
!addr = !Base2
!bank = !BankB

;===================================;
; Init routine                      ;
;===================================;
print "INIT ",pc : Init:
    lda #$00
    sta !1510,x             ;/ Infinite bounce
    sta !1540,x             ;| Set stun timer.
    lsr                     ;\
    bcc +                   ;|
    lda !167A,x             ;| If the "don't despawn" flag is set, set the "process offscreen" flag in the tweaker byte.
    ora #$04                ;|
    sta !167A,x             ;/
+

.Shell:
    lda #$04                ;\ Briefly disable quake sprite interaction
    sta !1FE2,x             ;/ (this is done in vanilla for Shells, don't know why it matters)
    jsr FaceMario

.Carryable:
    lda #$09                ;\ Set carryable state.
    sta !14C8,x             ;/

    STZ $00 : STZ $01
    LDA #$08 : STA $02
    
    rtl

.Normal:
    jsl $01ACF9|!bank       ;\ Random frame counter for animation.
    sta !1570,x             ;/
    jsr FaceMario
    rtl

;===================================;
; Main routine wrapper              ;
;===================================;
print "MAIN ",pc : Main:
    phb
    phk
    plb

; Call appropriate routine for the relevant states (8,9,A,B).
    lda !14C8,x : cmp #$08 : bcc .Dead
                  cmp #$09 : beq +
                  cmp #$0A : beq ++
                  cmp #$0B : beq +++
    bra ++++
+   jsr HandleStationary : bra ++++     ;> Stunned/Stationary Shell
++  jsr HandleKicked     : bra ++++     ;> Kicked/Disco Shell
+++ jsr HandleCarried    : ++++         ;> Carried Shell
; Set to handle states < 8 with vanilla routines.
    lda !14C8,x
    cmp #$08
    lda #$80
    bcs +
.Dead:
    lda !14C8,x
    cmp #$02
    BNE .notFalling
    LDA !15F6,x
    AND #$80
    BNE ++
        LDA !1686,x : ORA #$80 : STA !1686,x ; $1686
        LDA !15F6,x : ORA #$80 : STA !15F6,x
        LDA !B6,x
        BMI .minus
            LSR
        bra .done
        .minus
            SEC : ROR 
        .done
        STA !B6,x
    ++
    JSR StationaryGFX
.notFalling
    lda #$00
+    
    sta !extra_prop_2,x
    plb
    rtl

FaceMario:
    %SubHorzPos()
    tya
    sta !157C,x
    rts

;===================================;
; HandleSpriteStationary routine    ;
;===================================;
HandleStationary:
    lda $9D                 ;\
    beq +                   ;| If sprites are locked, just draw graphics.
    jmp .DrawGraphics       ;/
+ 
    jsl $01802A|!bank       ;> Update X/Y positions with gravity and interact with blocks.
    lda !1588,x             ;\
    and #$04                ;| If on the ground, make it bounce on it.
    beq +                   ;|
    jsr BounceOnGround      ;/
+   lda !1588,x             ;\
    and #$08                ;| If not touching the ceiling, skip.
    beq +                   ;/
    lda #$10                ;\ Make it go down.
    sta !AA,x               ;/
    lda !1588,x             ;\
    and #$03                ;| If touching the side of a block, skip.
    bne +                   ;/
    lda !E4,x               ;\
    clc                     ;|
    adc #$08                ;|
    sta $9A                 ;|
    lda !14E0,x             ;|
    adc #$00                ;|
    sta $9B                 ;|
    lda !D8,x               ;|
    and #$F0                ;|
    sta $98                 ;| Interact with the block
    lda !14D4,x             ;| (i.e., hit the block and trigger its effect).
    sta $99                 ;|
    lda !1588,x             ;|
    and #$20                ;|
    asl #3                  ;|
    rol                     ;|
    and #$01                ;|
    sta $1933|!addr         ;|
    ldy #$00                ;|
    lda $1868|!addr         ;|
    jsl $00F160|!bank       ;/
    lda #$08                ;\ Briefly disable interaction with quake sprites
    sta !1FE2,x             ;/ to avoid being hit by the block's bounce sprite.
+   lda !1588,x             ;\
    and #$03                ;| If not touching the side of a block, skip.
    beq +                   ;/
    lda !B6,x               ;\
    asl                     ;|
    php                     ;| Bounce the Shell backwards at 1/4th of its original speed.
    ror !B6,x               ;|
    plp                     ;|
    ror !B6,x               ;/
+   jsr SprMarioInteract    ;> Interact with sprites and Mario.
.DrawGraphics:
    jsr StationaryGFX       ;> Draw GFX.
    lda #$00                ;\ Handle offscreen.
    %SubOffScreen()         ;/
    rts

;===================================================;
; Make the carryable sprite bounce on the ground    ;
; when its speed is non-zero.                       ;
;===================================================;
BounceOnGround:
    lda !B6,x               ;\
    php                     ;|
    bpl +                   ;|
    eor #$FF                ;|
    inc                     ;|
+   lsr                     ;| Halve the sprite's X speed.
    plp                     ;|
    bpl +                   ;|
    eor #$FF                ;|
    inc                     ;|
+   sta !B6,x               ;/
    lda !AA,x
    pha
    lda !1588,x             ;\
    bmi +                   ;|
    lda #$00                ;| Set some Y speed
    ldy !15B8,x             ;| (gets overwritten unless touching layer 2 from above)
    beq ++                  ;|
+   lda #$18                ;|
++  sta !AA,x               ;/
    pla
    lsr #2
if !DropExtraBoost
    clc                     ;\ Use higher values from the table, like Goombas do.
    adc #$13                ;/
endif
    tay
    lda .BounceYSpeed,y     ;\
    ldy !1588,x             ;| Set Y speed using the table
    bmi .Return             ;| (unless it's on layer 2)
    sta !AA,x               ;/
.Return:
    rts

; Bounce speeds for carryable sprites when hitting the ground.
; Indexed by Y speed divided by 4.
.BounceYSpeed:
    db $00,$00,$00,$F8,$F8,$F8,$F8,$F8
    db $F8,$F7,$F6,$F5,$F4,$F3,$F2,$E8
    db $E8,$E8,$E8,$00,$00,$00,$00,$FE
    db $FC,$F8,$EC,$EC,$EC,$E8,$E4,$E0
    db $DC,$D8,$D4,$D0,$CC,$C8

;===========================================================;
; This routine handles graphics for the stationary shell:   ;
; - Set animation frame.                                    ;
; - Draw graphics.                                          ;
; - Shake the shell if Koopa about to exit it.              ;
; - Draw eyes if applicable.                                ;
;===========================================================;
StationaryGFX:
    LDA #$01
    STA !163E,x
    JMP ShellGraphics
    RTS

;===================================;
; HandleSpriteKicked routine        ;
;===================================;
HandleKicked:
    lda !187B,x             ;\ Branch if Disco Shell.
    beq +                   ;|
    jmp DiscoShell          ;/
+   lda !167A,x             ;\
    and #$10                ;| If it can't be kicked like a shell
    beq KickedShell         ;|
    jsr SetCarryable        ;| turn into carryable state
    jmp StationaryGFX       ;/ and draw graphics.

;===================================;
; Handle normal Kicked Shell        ;
;===================================;
KickedShell:
    lda !1528,x             ;\
    bne +                   ;|
    lda !B6,x               ;|
    clc                     ;| If not being caught by a Koopa, return to carryable if it slows down enough.
    adc #$20                ;|
    cmp #$40                ;|
    bcs +                   ;|
    jsr SetCarryable        ;/
+   stz !1528,x             ;\
    lda $9D                 ;|
    ora !163E,x             ;| If sprites are locked or (?) is happening, just draw graphics.
    beq +                   ;|
    jmp FinishHandleKicked_0;/
+   lda #$00                ;\
    ldy !B6,x               ;|
    beq +                   ;| Set direction based on speed.
    bpl ++                  ;|
    inc                     ;|
++  sta !157C,x             ;/
+   lda !15B8,x
    pha
    jsl $01802A|!bank       ; Update X/Y positions with gravity and interact with blocks.
    pla
    beq +
    sta $00
    ldy !164A,x             ;\
    bne +                   ;|
    cmp !15B8,x             ;|
    beq +                   ;| If just gone onto a slope, not in water and it's moving faster
    eor !B6,x               ;| than the slopes angle, make it bounce slightly.
    bmi +                   ;|
    lda #$F8                ;|
    sta !AA,x               ;/
    bra ++
+   lda !1588,x             ;\
    and #$04                ;|
    beq +                   ;| If on the ground, set Y speed to $10.
    lda #$10                ;|
    sta !AA,x               ;/
++  lda $1860|!addr         ;\
    cmp #$B5                ;|
    beq ++                  ;|
    cmp #$B4                ;| If touching a purple triangle, set Y speed.
    bne +                   ;|
++  lda #!TriangleYSpeed    ;|
    sta !AA,x               ;/
+   lda !1588,x             ;\
    and #$03                ;| If hitting the side of a block, interact with it.
    beq FinishHandleKicked  ;|
    jsr SideBlockInteract   ;/
FinishHandleKicked:
    jsr SprMarioInteract
.0: lda #$00
    %SubOffScreen()
    jmp KickedGFX

;====================================;
; Handle kicked Shell in Disco state ;
;====================================;
DiscoShell:
    lda $9D                 ;\
    beq +                   ;| If sprites are frozen, just draw GFX.
    jmp KickedGFX           ;/
+   jsl $01802A|!bank       ;> Update X/Y positions with gravity and interact with blocks.
    lda !151C,x             ;\
    and #$1F                ;|
    bne +                   ;| Follow Mario, except when $151C is non-zero (unused?)
    jsr FaceMario           ;/
+   lda !B6,x               ;\
    ldy !157C,x             ;|
    bne +                   ;|
    cmp #!DiscoMaxXSpeed    ;|
    bpl ++                  ;|
    clc                     ;|
    adc #!DiscoXAcceleration;| Handle X acceleration.
    bra ++                  ;|
+   cmp #-!DiscoMaxXSpeed   ;|
    bmi +                   ;|
    sec                     ;|
    sbc #!DiscoXAcceleration;|
++  sta !B6,x               ;/
+   lda !1588,x             ;\
    and #$03                ;|
    beq +                   ;|
    pha                     ;| If hitting the side of a block,
    jsr SideBlockInteract   ;| interact with it and bump the Shell.
    pla                     ;|
    and #$03                ;|
    tay                     ;|
    lda .BumpXSpeed-1,y     ;|
    sta !B6,x               ;/
+   lda !1588,x             ;\
    and #$04                ;|
    beq +                   ;| If on the ground, set its Y speed to $10.
    lda #$10                ;|
    sta !AA,x               ;/
+   lda !1588,x             ;\
    and #$08                ;| If hitting a ceiling, clear its Y speed.
    beq +                   ;|
    stz !AA,x               ;/
+   lda !1510,x             ;\
    and #$04                ;| If the "Disco speed boost from triangles" flag is not set, skip.
    beq +                   ;/
    lda $1860|!addr         ;\
    cmp #$B5                ;|
    beq ++                  ;|
    cmp #$B4                ;| If touching a purple triangle, set Y speed.
    bne +                   ;|
++  lda #!TriangleYSpeed    ;|
    sta !AA,x               ;/
+   lda $13                 ;\
    and #$01                ;|
    bne +                   ;|
    lda !15F6,x             ;| Cycle through the palettes every other frame.
    inc #2                  ;|
    and #$CF                ;|
    sta !15F6,x             ;/
+   jmp FinishHandleKicked  ;> Interaction, offscreen handle and GFX.

.BumpXSpeed:
    db -!DiscoBumpXSpeed,!DiscoBumpXSpeed

;===================================================================;
; This routine is called when bumping into a block from the sides:  ;
; - Play bump SFX.                                                  ;
; - Invert the Shell's X speed and direction.                       ;
; - If far anough onscreen, trigger the block that's been touched.  ;
;===================================================================;
SideBlockInteract:
    lda #$01                ;\ Play SFX.
    sta $1DF9|!addr         ;/
    lda !B6,x               ;\
    eor #$FF                ;| Invert X speed.
    inc                     ;|
    sta !B6,x               ;/
    lda !157C,x             ;\
    eor #$01                ;| Invert direction.
    sta !157C,x             ;/
    lda !1510,x             ;\
    and #$02                ;| If the "interact with block offscreen" flag is set, don't check if onscreen.
    bne +                   ;/
    lda !15A0,x             ;\ If offscreen, return.
    bne .Return             ;/
    lda !E4,x               ;\
    sec                     ;|
    sbc $1A                 ;| If not far enough on screen, return.
    clc                     ;|
    adc #$14                ;|
    cmp #$1C                ;|
    bcc .Return             ;/
+   lda !1588,x             ;\
    and #$40                ;|
    asl #2                  ;|
    rol                     ;|
    and #$01                ;| Trigger the block.
    sta $1933|!addr         ;|
    ldy #$00                ;|
    lda $18A7|!addr         ;|
    jsl $00F160|!bank       ;/
    lda #$05                ;\ Briefly disable interaction with quake sprite
    sta !1FE2,x             ;/ (to avoid being hit by the block's bounce sprite).
.Return:
    rts

;===========================================================;
; This routine handles graphics for the kicked shell:       ;
; - Change animation frame every so often.                  ;
; - Draw graphics.                                          ;
; - Flip the Shell when using the 4th animation frame.      ;
;===========================================================;
KickedGFX:
    STZ !163E,x
    JMP ShellGraphics
    RTS

;============================================================;
; Sprite<->Sprite interaction and Mario<->Sprite interaction ;
;============================================================;
SprMarioInteract:
    jsl $01803A|!bank       ;\ Interact with sprites, and check for contact with Mario.
    bcc .Return             ;/ Return if no contact.
    lda $1490|!addr         ;\ If Mario has a star
    beq NoStar              ;|
    lda !167A,x             ;| and the sprite can be starkilled
    and #$02                ;|
    bne NoStar              ;|
    %Star()                 ;/ kill.
.Return:
    rts

NoStar:
    stz $18D2|!addr
    lda !154C,x                 ;\ If contact is disabled, return.
    bne SprMarioInteract_Return ;/
    lda #$08                        ;\ Briefly disable contact.
    sta !154C,x                 ;/
    lda !14C8,x
    cmp #$09
    bne NotStationaryInteract
    jmp StationaryInteract

NotStationaryInteract:
    lda #$14                ;\
    sta $01                 ;|
    lda $05                 ;|
    sec                     ;|
    sbc $01                 ;|
    rol $00                 ;|
    cmp $D3                 ;|
    php                     ;|
    lsr $00                 ;|
    lda $0B                 ;|
    sbc #$00                ;| Don't bounce on the sprite if one of these is true:
    plp                     ;|  - Mario's Y position is too low w.r.t. the sprite's Y position.
    sbc $D4                 ;|  - Mario is moving upwards, the sprite can't be hit while moving upward
    bmi NotBouncing         ;|     and Mario hasn't bounced on any other enemies.
    lda $7D                 ;|  - Both Mario and the sprite are on the ground.
    bpl +                   ;|
    lda !190F,x             ;|
    and #$10                ;|
    bne +                   ;|
    lda $1697|!addr         ;|
    beq NotBouncing         ;|
+   lda !1588,x             ;|
    and #$04                ;|
    beq +                   ;|
    lda $72                 ;|
    beq NotBouncing         ;/
+   lda !1656,x             ;\
    and #$10                ;| If the sprite can be bounced on, jump.
    bne JumpOnSprite        ;/
    lda $140D|!addr         ;\
    ora $187A|!addr         ;| If not spinjumping or riding Yoshi, don't bounce.
    beq NotBouncing         ;/
Boost:                      ; Otherwise, spinjump on the enemy.
    lda #$02                ;\ Play SFX.
    sta $1DF9|!addr         ;/
    jsl $01AA33|!bank       ;> Boost Mario's speed.
    jsl $01AB99|!bank       ;> Display contact GFX.
    rts

NotBouncing:
    lda $13ED|!addr         ;\ If sliding
    beq +                   ;|
    lda !190F,x             ;| and sprite can be killed with slide
    and #$04                ;|
    bne +                   ;|
    lda #$03                ;|
    sta $1DF9|!addr         ;|
    %Star()                 ;/ kill.
    rts
+   lda $1497|!addr         ;\
    bne .Return             ;| If Mario is invulnerable or riding Yoshi, return.
    lda $187A|!addr         ;|
    bne .Return             ;/
    lda !1686,x             ;\
    and #$10                ;| If set to change direction when touched, do it.
    bne +                   ;|
    jsr FaceMario           ;/
+   jsl $00F5B7|!bank       ;> Hurt Mario.
.Return:
    rts

SetCape:
    LDA #$80                ; $7E14AD   1 byte  Timer   Blue P-Switch timer. Decrements every fourth frame (you can convert seconds to this timer value via PSwitchTimerLength = Seconds * 15). The P-switch running out sound is played when this hits #$1E.
    STA $14AD
    LDA #!GiveFly
    BEQ .noFly
    LDA $140D|!addr         ; if not spinjump, branch
    BEQ +                   
    LDA #$0C                ; sets "running when last jumped"
    STA $72
    BRA .noFly
	lda #$43                ; set pose of the player
	sta $13E0|!addr
.noFly
    RTS

JumpOnSprite:
    lda $140D|!addr         ;\
    ora $187A|!addr         ;| If not spinjumping or riding Yoshi, it's a normal jump.
    beq NormalJump          ;/


SpinJumpKill:               ;> Otherwise, kill with a spinjump.
	LDA !extra_bits,x               ;\ Get settings from sprite
    AND #$04						;| If extra bit is set, then spiny
    BEQ +
    jsl $01AB99|!bank       ;> Display contact GFX
    LDA !14C8,x 
    CMP #$0A
    BNE .notKicked
    JSR SetCape
    BRA .Kicked
    .notKicked
    BRA .skip
    .Kicked
    jsl $01AA33|!bank       ;/
    lda #$02                ;\ Play SFX.
    sta $1DF9|!addr         ;/
    BRA .skip
+   jsl $01AB99|!bank       ;> Display contact GFX
    lda #$F8                ;\
    sta $7D                 ;|
    lda $187A|!addr         ;| Boost Mario upwards (if on Yoshi).
    beq +                   ;|
    jsl $01AA33|!bank       ;/
+   lda #$04                ;\
    sta !14C8,x             ;| Set as "spinjump killed".
    lda #$1F                ;|
    sta !1540,x             ;/
    jsl $07FC3B|!bank       ;> Generate stars from spinjump kill.
    jsr GivePoints          ;> Give points.
    lda #$08                ;\ Play SFX.
    sta $1DF9|!addr         ;/
.skip
    RTS

NormalJump:
	LDA !extra_bits,x               ;\ Get settings from sprite
    AND #$04						;| If extra bit is set, then spiny
    BEQ +
    jsl $00F5B7|!bank       ;> Hurt Mario.
    rts
+   jsr Boost               ;> Set Y speed, display contact GFX, play SFX.
    lda !187B,x             ;\ If not Disco Shell, branch.
    beq NormalBounce        ;/
.DiscoShell:
    %SubHorzPos()           ;\
    tya                     ;| Boost Mario's X speed based on his relative position.
    lda ..XBoost,y          ;|
    sta $7B                 ;/
    rts

..XBoost:
    db !DiscoXBoost,-!DiscoXBoost

NormalBounce:
    jsr GivePoints          ;> Handle consecutive enemies stomped and all that ****.
    JSR SetCape
    lda !1686,x             ;\
    and #$40                ;|
    beq DoesntSpawnNewSprite;|
    ldy !9E,x               ;|
    lda .SpriteToSpawn,y    ;| If set to spawn a new sprite, change its number based on the table.
    sta !9E,x               ;| (this also makes the Special Shell able to be bounced on twice, since it spawns a normal Green Shell).
    lda !15F6,x             ;|
    and #$0E                ;|
    sta $0F                 ;|
    jsl $07F78B|!bank       ;/
    lda !15F6,x             ;\
    and #$F1                ;| Restore palette.
    ora $0F                 ;|
    sta !15F6,x             ;/
    stz !AA,x               ;> Reset speed.
.Return:
    rts

.SpriteToSpawn:
    db $00,$01,$02,$03,$04,$05,$06,$07,$04,$04,$05,$05,$07

DoesntSpawnNewSprite:
    lda !9E,x               ;\
    sec                     ;|
    sbc #$04                ;|
    cmp #$0D                ;|
    bcs +                   ;|
    lda $1407|!addr         ;|
    bne ++                  ;| If the sprite dies when jumped on,
+   lda !1656,x             ;| or if it's sprite 4-10 and Mario flies into it,
    and #$20                ;| squish the sprite.
    beq NoSquish            ;|
++  lda #$03                ;|
    sta !14C8,x             ;|
    lda #$20                ;|
    sta !1540,x             ;|
    stz !B6,x               ;|
    stz !AA,x               ;/
    rts

NoSquish:
    lda !1662,x             ;\
    bpl DontFallStraightDown;|
    lda #$02               ;| If set to fall straight down, set state to 2. 
    sta !14C8,x             ;| and reset speeds.
    stz !B6,x               ;|
    stz !AA,x               ;/
.Return:
    rts

DontFallStraightDown:
    ldy !14C8,x             ;\
    stz !1626,x             ;| If in kicked state, turn into carryable state.
    cpy #$0A                ;|
    beq SetCarryable        ;/
    jmp SpinJumpKill        ; Otherwise, kill with a spinjump.

SetCarryable:
    bit !1510,x             ;\ If "infinite bounces" flag is set, don't turn carryable.
    bmi NoSquish_Return     ;/
    bvc +                   ;> If "kill after one bounce flag" is not set, turn into carryable.
    jmp SpinJumpKill        ;> Otherwise, kill with a spinjump.
+   
    stz !1540,x             ; Otherwise, reset stun timer.
    lda #$09                ;\ Set state to carryable.
    sta !14C8,x             ;/
    rts

StationaryInteract:
    lda $140D|!addr         ;\ If spinjumping
    ora $187A|!addr         ;| or on Yoshi
    beq CheckCarrying       ;|
    lda $7D                 ;| and moving downwards
    bmi CheckCarrying       ;|
    lda !1656,x             ;| and sprite can be jumped on
    and #$10                ;|
    beq CheckCarrying       ;|
    jmp SpinJumpKill        ;/ then kill the sprite with a spinjump.

CheckCarrying:
    bit $15                 ;\ If X/Y held
    bvc KickShell           ;| (for some reason SMW uses LDA $15 : AND #$40 : BEQ but they use BIT $15 : BVC elsewhere)
    lda $1470|!addr         ;| and not carrying a sprite already
    ora $187A|!addr         ;| and not on Yoshi
    bne KickShell           ;|
    lda #$0B                ;| make Mario pick up the sprite.
    sta !14C8,x             ;|
    inc $1470|!addr         ;|
    lda #$08                ;|
    sta $1498|!addr         ;/
    rts

KickShell:
    jsr GivePoints          ; Give points
    lda #$03                ;\ Play SFX.
    sta $1DF9|!addr         ;/
    lda #$0A                ;\ Set kicked state.
    sta !14C8,x             ;/
    lda #$10                ;\ Briefly disable interaction with Mario.
    sta !154C,x             ;/
    %SubHorzPos()           ;\
    lda KickXSpeeds,y       ;| Set X speed based on throw direction.
    sta !B6,x               ;/
    rts

KickXSpeeds:
    db -!KickXSpeed,!KickXSpeed,$CC,$34

;===============================================================;
; This routine:                                                 ;
; - Increases Mario's consecutive enemies killed counter.       ;
; - Play SFX based on (consecutive enemies bounced on by Mario) ;
;    + (consecutive enemies killed by sprite).                  ;
; - Give points based on the same value.                        ;
;===============================================================;
GivePoints:
    lda $1697|!addr         ;\
    clc                     ;|
    adc !1626,x             ;|
    inc $1697|!addr         ;|
    tay                     ;| Play bounce SFX when $1697+$1626,x < #$08
    iny                     ;| (if >= @$08, it spawns a 1up score sprite which plays the SFX)
    cpy #$08                ;|
    bcs +                   ;|
    lda .SFX-1,y            ;|
    sta $1DF9|!addr         ;/
+   tya                     ;\
    cmp #$08                ;|
    bcc +                   ;| Give points accordingly (input capped to $08 = 1up)
    lda #$08                ;|
+   jsl $02ACE5|!bank       ;/
    rts

.SFX:
    db $13,$14,$15,$16,$17,$18,$19

;=======================================================;
; Set fireball and cape immunity for the Disco Shell    ;
; depending on the flags set in the Extra Byte 2.       ;
;=======================================================;
SetDiscoShell:
    inc !187B,x             ; Set Disco Shell flag.
    lda !1510,x             ;\
    and #$18                ;|
    eor #$18                ;| Set fireball and cape immunity in the tweaker byte from the Extra Byte 2 flags.
    asl                     ;|
    ora !166E,x             ;|
    sta !166E,x             ;/
    rts

;===================================;
; HandleSpriteCarried routine       ;
;===================================;
HandleCarried:
    jsr ActuallyHandleCarried
    lda $13DD|!addr         ;\
    ora $1419|!addr         ;| If turning while sliding, going down a pipe, or facing the screen
    bne +                   ;| center the item on Mario, and change OAM index to $00
    lda $1499|!addr         ;| (to make it draw in front of Mario).
    beq ++                  ;|
+   stz !15EA,x             ;/
++  lda $64                 ;\
    pha                     ;|
    lda $1419|!addr         ;| If going down a pipe, send behind objects.
    beq +                   ;|
    lda #$10                ;|
    sta $64                 ;/
+   jsr StationaryGFX       ;> Draw the sprite.
    pla                     ;\ Restore $64.
    sta $64                 ;/
    rts

ActuallyHandleCarried:
    jsl $019138|!bank       ; Interact with blocks
    lda $71                 ;\
    cmp #$01                ;|
    bcc +                   ;|
    lda $1419|!addr         ;| If Mario let go of the sprite, return to carryable state.
    bne +                   ;|
    lda #$09                ;|
    sta !14C8,x             ;/
.Return:
    rts
+   lda !14C8,x             ;\
    cmp #$08                ;| If returned to normal state, return.
    beq .Return             ;/
    lda $9D                 ;\
    beq +                   ;| If sprites locked, just handle offset from Mario.
    jmp OffsetFromMario     ;/
+   jsl $018032|!bank       ;> Interact with sprites.
    lda $1419|!addr         ;\
    bne +                   ;|
    bit $15                 ;| If X/Y held or Mario going down a pipe, offset the sprite from his position.
    bvc LetGoOfSprite       ;|
+   jmp OffsetFromMario     ;/

LetGoOfSprite:
    stz !1626,x
    stz !AA,x
    lda #$09
    sta !14C8,x
    lda $15                 ;\
    and #$08                ;| Throw up if up button held.
    bne KickUp              ;/
    lda $15                 ;\
    and #$04                ;| Throw sideways if left/right held.
    beq KickSideways        ;/

Drop:
    ldy $76                 ;\
    if !spinDrop            ; spin jump patch
    if !dropDirection
    LDA $13EF|!addr         ; \ If the player is on the ground...
    BEQ +                   ; |
    LDA $73                 ; | And ducking...
    BNE .default            ; | > Do the default
+   LDA $15                 ; \
    AND #$03                ; | If the player is holding left or right...
    BEQ .default            ; |
    AND #$01                ; | \ Set Y to be the held direction
    TAY                     ; | /   Priority goes to right if both are held
    BRA +                   ; /
    .default                ;
    endif

    LDY $76                 ; \ Else set Y to mario's facing direction
    LDA $140D|!addr         ; | \
    ORA $14A6|!addr         ; | | If the player is spinning...
    BEQ +                   ; | /
    LDA $D1                 ; | \
    STA !E4,X               ; | | Set the sprite's x position to be mario's
    LDA $D2                 ; | |   x position. This centers it.
    STA !14E0,X             ; | /
+   endif                   ; If the player isn't spinning...

    lda $D1                 ;|
    clc                     ;|
    adc .XOffsetLow,y       ;| Offset sprite from Mario based on his direction.
    sta !E4,x               ;|
    lda $D2                 ;|
    adc .XOffsetHigh,y      ;|
    sta !14E0,x             ;/
    %SubHorzPos()           ;\
    lda .XSpeed,y           ;|
    clc                     ;| Set sprite's X speed based on drop direction + Mario's X speed.
    adc $7B                 ;|
    sta !B6,x               ;/
    stz !AA,x               ;> Reset sprite's Y speed.
    JMP FinishKicking

.XOffsetLow:
    db -!DropXOffset,!DropXOffset

.XOffsetHigh:
    db $FF,$00

.XSpeed:
    db -!DropXSpeed,!DropXSpeed

KickUp:
    if !spinUp              ; patch fix
    LDA $140D|!addr         ; \ \
    ORA $14A6|!addr         ; | | If the player is spinning...
    BEQ .default            ; | /
    LDA $D1                 ; | \
    STA !E4,X               ; | | Set the sprite's x position to be mario's x
    LDA $D2                 ; | |   position. This centers it.
    STA !14E0,X             ; | /
    .default                ; /
    endif

    jsl $01AB6F|!bank       ;> Show contact GFX.
    lda #!KickYSpeed        ;\ Set Y speed.
    sta !AA,x               ;/
    lda $7B                 ;\
    sta !B6,x               ;| Give the sprite half of Mario's X speed.
    asl                     ;|
    ror !B6,x               ;/
    bra FinishKicking

KickSideways:
    if !spinKickCenter       ; patch fix
    LDA $140D|!addr         ; \ \
    ORA $14A6|!addr         ; | | If the player is spinning...
    BEQ .default            ; | /
    LDA $D1                 ; | \
    STA !E4,X               ; | | Set the sprite's x position to be mario's x
    LDA $D2                 ; | |   position. This centers it.
    STA !14E0,X             ; | /
    .default                ; /
    endif

    jsl $01AB6F|!bank       ;> Show contact GFX.
    lda #$0A                ;\ Set kicked state.
    sta !14C8,x             ;/

    if !spinKick            ; spin fix
    LDA $13EF|!addr         ; \ If the player is on the ground...
    BEQ +                   ; |
    LDA $73                 ; | And ducking...
    BNE .default2           ; | > Do the default
+   LDA $15                 ; \
    BIT #$03                ; | If the player is holding left or right...
    BEQ .default2           ; |
    AND #$01                ; | \ Set Y to be the held direction
    TAY                     ; | /   (Priority goes to right if both are held)
    BRA +                   ; /
    .default2               ; \ Else...
    LDY  $76                ; | > Set Y to mario's facing direction
+   LDA $187A|!addr         ; \ Restore overwritten code
    ; saves 1 byte

KickRecover:
    BEQ +
    INY #2
+   LDA KickXSpeeds,y       ; > Data table for shell speed
    STA !B6,X
    EOR $7B
    BMI FinishKicking
    LDA $7B
    CMP #$80 : ROR          ; Signed division by 2 (saves 2 bytes)
    CLC : ADC !B6,X         ; (saves 1 byte)
    STA !B6,X
    BRA FinishKicking
    endif

    ldy $76
    lda $187A|!addr         ;\
    beq +                   ;| If on Yoshi, use different speeds.
    iny #2                  ;/ (which is impossible without glitches :thonk:)
+   lda KickXSpeeds,y       ;\
    sta !B6,x               ;|
    eor $7B                 ;|
    bmi FinishKicking       ;|
    lda $7B                 ;| Set base X speed, and add half of Mario's speed
    sta $00                 ;| if moving in the same direction as him.
    asl $00                 ;|
    ror                     ;|
    clc                     ;|
    adc KickXSpeeds,y       ;|
    sta !B6,x               ;/

FinishKicking:
    lda #!KickNoInteractTime;\ Briefly disable interaction with Mario.
    sta !154C,x             ;/
    lda #$0C                ;\ Briefly show kicked pose.
    sta $149A|!addr         ;/
    rts

OffsetFromMario:
    lda $76                 ;\
    eor #$01                ;| SMW uses branches for this...
    tay                     ;/
    lda $1499|!addr         ;\
    beq +                   ;|
    iny #2                  ;| Set Y to 2/3 or 3/4 when turning.
    cmp #$05                ;|
    bcc +                   ;|
    iny                     ;/
+   lda $1419|!addr         ;\
    beq +                   ;|
    cmp #$02                ;|
    beq ++                  ;| If turning while sliding, going down a pipe, or climbing, set Y to 5.
+   lda $13DD|!addr         ;|
    ora $74                 ;|
    beq +++                 ;|
++  ldy #$05                ;/
+++ phy
    ldy #$00                ;\
    lda $1471|!addr         ;|
    cmp #$03                ;|
    beq +                   ;|
    ldy #$3D                ;|
+   lda $94,y               ;|
    sta $00                 ;| Use Mario's position on the next frame,
    lda $95,y               ;| unless Mario is on a brown chained platform or a falling grey platform
    sta $01                 ;| (which use the current frame).
    lda $96,y               ;|
    sta $02                 ;|
    lda $97,y               ;|
    sta $03                 ;/
    ply
    lda $00                 ;\
    clc                     ;|
    adc .XOffsetLow,y       ;|
    sta !E4,x               ;| Offset horizontally.
    lda $01                 ;|
    adc .XOffsetHigh,y      ;|
    sta !14E0,x             ;/
    lda #$0D                ;\> Y offset when big.
    ldy $73                 ;|
    bne +                   ;| Offset vertically.
    ldy $19                 ;|
    bne ++                  ;|
+   lda #$0F                ;|> Y offset when ducking or small.
++  ldy $1498|!addr         ;|
    beq +                   ;|
    lda #$0F                ;|> Y offset when picking up an item.
+   clc                     ;|
    adc $02                 ;|
    sta !D8,x               ;|
    lda $03                 ;|
    adc #$00                ;|
    sta !14D4,x             ;/
    lda #$01                ;\
    sta $148F|!addr         ;| Set carrying item flags.
    sta $1470|!addr         ;/
    rts

.XOffsetLow:
    db !CarryXOffset

.XOffsetHigh:
    db $00,$FF,$00,$FF,$00,$00

;===================================;
; Shell graphics routine            ;
;===================================;

Tilemap:        db !ShellTiles
SpinyTilemap:   db !SpinyTiles
GfxProps:       db $00,$00,$00,$00
   
WingTiles:      db $08,$18,$09,$19
;WingTilesStat:  db $08,$18,$09,$19

WingXDisp:      db $13,$13,$0B,$0B
WingXDispStat:  db $8B,$8B,$8B,$8B

WingProps:      db %01110101,%01110101,%01110101,%01110101
   
ShellGraphics:
    %GetDrawInfo()
    LDA $00				;
    STA $0300|!Base2,y		;shell tile X-pos
    LDA $01				;
    STA $0301|!Base2,y		;shell tile Y-pos

    PHY				;
    LDA !163E,x         ; if stationary or dead, don't animate shell
    BNE .NoAnim
    LDA $14				;animate with frame counter and all
.NoAnim
    LSR #2				;
    AND #$03			;fetch correct tile and flip info
    TAY				;
    LDA GfxProps,y			;
    STA $02				;
    lda !extra_bits,x       ;\ Get settings from sprite
    and #$04				;| Check if extra bit. If set, branch to vertical
    beq +
    lda SpinyTilemap,y   ;| ($1602 starts from 6 for shells)
    bra ++
+   lda Tilemap,y        ;| ($1602 starts from 6 for shells)
++  PLY				;
    STA $0302|!Base2,y		;

    LDA !187B,x             ; if disco shell, switches through the palettes
    BEQ .noDisco
    lda !extra_bits,x       ;\ Get settings from sprite
    and #$04				;| Check if extra bit, sets graphic page
    beq +
    lda #$01
+   CLC : ADC !15F6,x
    BRA .DiscoPal
.noDisco
    lda !extra_bits,x       ;\ Get settings from sprite
    and #$04				;| Check if extra bit, sets graphic page
    beq +
    lda #!SpinyPal
    bra ++
+   lda #!ShellPal
.DiscoPal
++  ora $64                 ;\
    STA $0303|!Base2,y		;store as tile property
 

    LDA #$00			;3 tiles total
    LDY #$02			;custom sizes
    JSL $01B7B3|!BankB		;
    RTS				;
