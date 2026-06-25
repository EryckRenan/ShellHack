;=============================================================
; Shady Koopa
; By Erik
; Description: A koopa which, when stomped, will turn to a
; rainbow shell. It'll go berserk if flipped with a cape,
; however! So be wary of capes... (not a bug, intentional)
;
; Uses extra bits: NO
;
; Uses extra bytes: YES
; Extra byte 1:
;   80 - Stay on ledges
;   40 - Follow Mario
;   C0 - Both of those
;=============================================================

!shellless      = 1     ;   0 - don't spawn a shell-less koopa / 1 - spawn a shell-less koopa
!shellless_num  = $03   ;   sprite number for thomas' shell-less koopa
!flash_time     = $40   ;   time before the shell starts flashing
!explode_time   = $18   ;   time before the shell actually explodes

x_speed:
    db $08,$F8
angry_x_speed:
    db $38,$C8
flashing_pal:
    db $A0,$A2,$A4,$A6,$A8,$AA,$AC,$AE

;---

; On Yoshi's mouth
print "MOUTH",pc
    LDA #$07            ;\
    STA !9E,x           ; |
    JSL $07F7D2|!bank   ; | spawn a vanilla rainbow shell and set its status to eaten
    LDA #$07            ; |
    STA !14C8,x         ; |
    INC !187B,x         ;/
    RTL

;---

; Stunned/Carriable
print "CARRIABLE", pc
stunned_shady_koopa:
    PEA.w ($01)|(stunned_shady_koopa>>16<<8)
    PLB
    PHK                     ;\
    PEA.w .drawn-1          ; | shell graphics routine
    PEA $80C9               ; |
    JML $019F0D|!bank       ;/
.drawn
    PLB
    LDA $9D                 ;\  return if sprites locked
    BNE .return             ;/
    JSL $01802A|!bank       ;   update X/Y position with gravity
    LDA !1588,x
    AND #$04
    BEQ +
    STZ !B6,x
+   LDA !1540,x             ;\  check whether the koopa was interacted with or not
    BEQ .not_cape_stunned   ;/
    DEC                     ;\
    BEQ .die                ; | check whether it's time to explode or disappear
    CMP.b #!explode_time    ; |
    BCS .return             ;/
    LDA $14                 ;\
    LSR #3                  ; |
    BCS .return             ; |
    LDY !15EA,x             ; | flash occasionally
    LDA $0303|!addr,y       ; |
    EOR #$02                ; |
    STA $0303|!addr,y       ;/
.return
    RTL

.not_cape_stunned
    LDA #$02                ;\
    STA !1686,x             ; | set a regular shell
    STZ !167A,x             ;/
    RTL

.die
    LDA !1FD6,x             ;\  check whether the koopa was cape flipped or not
    BEQ ..not_cape_stunned  ;/
    %SubHorzPos()           ;\
    TYA                     ; | face the player
    STA !157C,x             ;/
    LDA #$09                ;\  play sound effect
    STA $1DFC|!addr         ;/
    INC !1FD6,x             ;   mark the setup as done
    LDA angry_x_speed,y     ;\  set X speed
    STA !B6,x               ;/
    LDA #$03                ;\  set inedible and interact with sprites again
    STA !1686,x             ;/
    LDA #$0A                ;\  change state
    STA !14C8,x             ;/
..return
    RTL

..not_cape_stunned
    LDA #$07                ;\
    STA !9E,x               ; |
    LDA #$0A                ; | spawn regular rainbow shell
    STA !14C8,x             ; |
    JSL $07F7D2|!bank       ; |
    INC !187B,x             ;/
    LDA !166E,x             ;\
    ORA #$30                ; | disable fire/cape killing
    STA !166E,x             ;/
    RTL

;---

; Kicked (basically for this sprite what it means is go ballistic)
print "KICKED", pc
ballistic_shady_koopa:
    PEA.w ($01)|(ballistic_shady_koopa>>16<<8)
    PLB
    PHK                     ;\
    PEA.w .drawn-1          ; | shell graphics routine
    PEA $80C9               ; |
    JML $019F0D|!bank       ;/
.drawn
    PLB
    LDA !1FD6,x
    EOR #$02
    ORA $9D
    BNE .return
    JSL $01802A|!bank       ;   update X/Y position with gravity
    %SubOffScreen()
    LDA !1588,x             ;\
    AND #$03                ; |
    BEQ .no_wall            ; |
    LDA #$01                ; |
    STA $1DF9|!addr         ; | check if colliding in a wall and flip if so
    LDA !B6,x               ; |
    EOR #$FF                ; |
    INC                     ; |
    STA !B6,x               ;/
.no_wall
    JSL $018032|!bank       ;   interact with sprites
    JSL $01A7DC|!bank       ;\  check if making contact
    BCC .no_contact         ;/
    LDA $1490|!addr         ;\
    BEQ +                   ; | kill shell if the player has star
    %Star()                 ;/  (the shell ignoring the star was on purpose but FINE, i'll change it)
    STZ !167A,x
    BRA .no_contact
+   LDA $187A|!addr         ;\
    BEQ +                   ; | lose Yoshi if on Yoshi
    %LoseYoshi()            ;/  (again, on purpose. again, fair)
    BRA .no_contact
+   JSL $00F5B7|!bank       ;   outright hurt the player
.no_contact
    LDA $14                 ;\
    LSR #2                  ; |
    AND #$07                ; |
    LDY !15EA,x             ; | flash like a rainbow shell
    TAX                     ; |
    LDA flashing_pal,x      ; |
    STA $0303|!addr,y       ;/
    LDX $15E9|!addr
    LDA $14                 ;\
    LSR                     ; |
    AND #$03                ; |
    TAY                     ; |
    CMP #$03                ; |
    LDA shell_animations,y  ; | animate the shell
    STA !1602,x             ; |
    BNE .return             ; |
    LDY !15EA,x             ; |
    LDA $0303|!addr,y       ; |
    ORA #$40                ; |
    STA $0303|!addr,y       ;/
.return
    RTL

shell_animations:
    db $06,$07,$08,$07

;---

; Init routine
print "INIT",pc
    %SubHorzPos()   ;\
    TYA             ; | face player
    STA !157C,x     ;/
    RTL

;---

; Main routine
print "MAIN",pc
shady_koopa:
    PHK                     ;\
    PEA.w .drawn-1          ; | koopa graphics routine
    PEA $80C9               ; |
    JML $018BC3|!bank       ;/
.drawn
    LDA !14C8,x
    EOR #$08
    ORA $9D
    BEQ run_koopa
    RTL

run_koopa:
    %SubOffScreen()
    LDA $14                 ;\
    LSR #3                  ; | change frame
    AND #$01                ; |
    STA !1602,x             ;/

    JSL $01802A|!bank       ;   update X/Y position with gravity

    PEA.w ($01)<<8|(run_koopa>>16)
    PLB

    ; Movement
    LDY !157C,x             ;\
    LDA x_speed,y           ; |
    EOR !15B8,x             ; | check if the sprite is on a slope
    ASL                     ; |
    LDA x_speed,y           ; |
    BCC .no_slope           ;/
    CLC                     ;\  if it is, correct the X speed appropiately
    ADC !15B8,x             ;/
.no_slope
    STA !B6,x

    LDA !extra_byte_1,x
    STA $00
    LDA !1588,x             ;\
    AND #$04                ; | branch if not on ground
    BEQ .no_ground          ;/

; This decides the Y speed to set depending if touching a layer 2 slope while on the ground
    LDA !1588,x             ;\  branch if touching a layer 2 ceiling
    BMI .air                ;/
    LDA #$00
    LDY !15B8,x             ;\  branch if not on a slope
    BEQ +                   ;/
.air
    LDA #$18
+   STA !AA,x
    STZ !151C,x             ;   clear turning flag
    BRA .done_x

.no_ground
    BIT $00                 ;\  check whether to stay on ledges
    BPL .done_x             ;/
    LDA !151C,x             ;\  check if we already turned
    BNE .done_x             ;/
    JSR turn_sprite         ;   flip
    LDA #$01                ;\  set turning timer
    STA !151C,x             ;/

.done_x
    BIT $00                 ;\  check whether to follow the player
    BVC .no_follow          ;/
    LDA $14                 ;\
    AND #$7F                ; | skip if not time to check
    BNE .no_follow          ;/
    LDA !157C,x             ;\  preserve current direction in scratch
    STA $00                 ;/
    %SubHorzPos()           ;\
    CPY $00                 ; | don't bother if it's the same direction
    BEQ .no_follow          ;/
    JSR turn_sprite         ;   flip

.no_follow
    LDA !157C,x             ;\
    INC                     ; |
    AND !1588,x             ; | return if touching an object on
    AND #$03                ; | the direction the player is moving
    BEQ interact            ; |
    JSR turn_sprite         ;/

; Them cursed interaction routines
interact:
    JSL $018032|!bank   ;   interact with sprites
    LDA $14             ;\
    LSR                 ; | don't process cape/bounce interaction every frame
    BCS normal_contact  ;/
    %CapeContact()      ;\  check if interacting with cape
    BCC no_cape_contact ;/
    ; Cape interaction confirmed
    ; This basically sets our Koopa in its carryable state
.cape_contact
    LDA #$03
    STA $1DF9|!addr
    LDA #$00
    JSL $02ACE5|!bank
    LDA #$09
    STA !14C8,x
    LDA.b #!flash_time
    STA !1540,x
    LDA #$06
    STA !1602,x
    INC !1FD6,x
    LDA #$B0
    STA !AA,x
    %SubHorzPos()
    LDA spun_x_speed,y
    STA !B6,x
    TYA
    EOR #$01
    STA !157C,x
    LDA !15F6,x
    ORA #$80
    STA !15F6,x
    LDA #$83
    STA !167A,x
    LDA #$0B
    STA !1686,x
.return
    PLB
    RTL

spun_x_speed:
    db $F8,$08

no_cape_contact:
    %BounceInteract()           ;\
    BCS interact_cape_contact   ; | also go ballistic if smashing the ground or interacting with a quake sprite
    LDA $1887|!addr             ; |
    BNE interact_cape_contact   ;/
normal_contact:
    JSL $01A7DC|!bank
    LDA !14C8,x                 ;\
    CMP #$09                    ; |
    BEQ .stun                   ; | verify if turn into a rainbow shell (implies being smushed as well due to cape shit)
    CMP #$03                    ; |
    BNE .return                 ;/
    LDA #$09
    STA !14C8,x
.stun
    LDA.b #!flash_time
    STA !1540,x
    LDA #$06
    STA !1602,x
    LDA #$83
    STA !167A,x
    if !shellless
        STZ $00
        STZ $01
        STZ $03
        %SubHorzPos()
        STY $0F
        LDA shellless_x_speed,y
        STA $02
        LDA #$09
        STA $04
        LDA.b #!shellless_num
;        SEC                    replaced with clc for non custom sprite
        CLC
        %SpawnSpriteSafe()
        BCS .return
        LDA #$10
        STA !154C,y
        STA !1528,y
        LDA $0F
        STA !157C,y
        TYX
        LDA #$53
        STA !extra_byte_1,x
        LDX $15E9|!addr
    endif
    LDA #$0B                ;\  set inedible and uninteractable
    STA !1686,x             ;/
    STZ !B6,x
.return
    PLB
    RTL

if !shellless
    shellless_x_speed:
        db -$40,$40
endif

;---

turn_sprite:
    LDA !15AC,x
    BNE .return
    LDA #$08          
    STA !15AC,x
    LDA !B6,x
    EOR #$FF
    INC
    STA !B6,x
    LDA !157C,x
    EOR #$01
    STA !157C,x
.return
    RTS

