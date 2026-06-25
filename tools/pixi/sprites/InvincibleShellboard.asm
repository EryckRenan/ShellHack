;============================================================================================================================================;
; Invincible Shellboard by KevinM, crm0622					   								 											   	 ;
; (Based upon "Koopas + Shells + Disco Shell" code by KevinM.) 								 											   	 ;
; Special thanks to JamesD28 for help me figuring out to make kill/ride routine properly. :D 											   	 ;
;============================================================================================================================================;
; Caution: Try to kick it way too strong may result headache on Player when you ride on it, which makes unable to jump off... Use wisely! :) ;
; ...unless if you patched "Player X Speed Fix" or something like that on your rom.														   	 ;
;============================================================================================================================================;
; Tip: If you want carry it within pipe properly, change value of $02AC18 to 80! 														   	 ;
;============================================================================================================================================;

;====================================================================================;
; Extra Byte 1:                                										 ;
; If $00, it will spawn in carryable state.                                     	 ;
; Otherwise, the it will spawn kicked towards the Player, and its' speed will be the ;
; value you put here. ($00-$7F)                                                   	 ;
; (Set to negative value [$80-$FF] if you want it spawn kicked opposite way.)		 ;
;                                                                                    ;
; Note: Due to how its' work, using a low speed value ($20 or lower) will spawn it   ;
; in the carryable state instead, but it will make it bounce towards, as if someone  ;
; was tossing it to Player. (Works better if spawned in the air.)               	 ;
;====================================================================================;

;===================;
; Define properties ;
;===================;
!RidingMethod = 1							; Set your preferred riding method between both. (Default = 0)
											; (0 = Makes you keep run indefinitely while riding, Very straightforward to use, Fairly exploitable... etc.)
											; (1 = Can manipulate its' speed with your manual control while riding, More tricky to use, Way much exploitable if you know what you're doing, Really good for precise moving... etc.)
											; (There's high amounts of chance you could die during goal sequence if you kicked really fast for "!RidingMethod = 1", and I have absolutely no idea how to fix that unfortunately... So not really recommend to make goal sequence section with ground only.)
if !RidingMethod = 0
!GoalSequenceFix = 1						; Keep set to 1 if you want fix jankiness (99% approximately, I guess... :P) which also had potential to make Player die inconsistently on offscreen during goal sequence when Player get goal tape or orb while riding on it. (Only applied if you set "!RidingMethod" to 0.)
											; (Make sure you put long enough ground for goal sequence section to not screw up!)
endif
!InstaGlideFlag = 0							; Set to 1 if you want to glide immediately after flying when you take off from it. (Hold Y or X when you jump to perform.) (Only applied if you set "!RidingMethod" to 0.)
!InstaGlideXSpeed = $2F						; X speed which will make you glide immediately if its' X-Speed is same as or greater than this value. (Only applied if you set "!RidingMethod" to 0, and set "!InstaGlideFlag" to 1.)
!KickedSFX = $03							; SFX that plays when kicking it.
!KickedSFXAddr = $1DF9|!addr				; Set SFX address you want use.
!KickNoInteractTime = $10					; Time to disable contact with Player after kicking it.
!InterruptNoInteractTime = $10				; Time to disable contact with Player/Sprite if it got interrupt by anything.
!KickXSpeed = $2E							; X speed when side-kicked by Player.
!KickYSpeed = $90							; Y speed when thrown upwards by Player.
!DropXSpeed = $04 							; X speed when dropped by Player.
!DropXOffset = $0D							; X offset from Player of that when dropped.
!CarryXOffset = $0B,$F5,$04,$FC,$04,$00		; X offset from Player of that when carried. Depends on Player's direction and turning animation.
											; ("Right", "Left", "Left while turning", "Right when turning", "Sliding/going down a pipe/climbing while turning", "Centered".)
!ShellboardTiles = $8C,$8A,$8E				; Set tilemap. (The first tile is used twice while spinning, but X flipped the second time.)
!SWPassedLevel = $0125						; A level that triggers the "Special World passed" flag when you beat. (Default = $0125)
!TriangleYSpeed = $B8						; Y speed given by purple triangle blocks when touches it during kicked state.
!SpinBoost = 0								; Set if you want get free SPEEEEEEEEEEEEEEEEN boost when you ride/touched it in kicked state!

;==================================================================================;
; Sprite code (NOT recommend to change unless you know what exactly you're doing!) ;
;==================================================================================;
!addr = !Base2
!bank = !BankB

!SWPassedFlag = $1EA2|!addr+!SWPassedLevel
if !SWPassedLevel > $24
    !SWPassedFlag := !SWPassedFlag-$DC
endif

;===================;
; Init/Main wrapper ;
;===================;
print "INIT ",pc
    lda #$04                ;\ Briefly disable quake sprite interaction.
    sta !1FE2,x             ;/
    lda !extra_byte_1,x     ;\ Extra Byte 1 = 0 --> Stationary.
    beq .Carryable          ;/
    jsr FacePlayer
    lda !extra_byte_1,x     ;\ Extra Byte 1 >= 0 --> Kicked.
    bra .Kicked             ;/
.Kicked:
    lda #!KickedSFX         ;\ Play kicked SFX.
    sta !KickedSFXAddr      ;/
    lda !extra_byte_1,x
+   cpy #$00                ;\
    beq +                   ;| Invert X speed if facing left.
    eor #$FF                ;|
    inc                     ;/
+   sta !B6,x               ;> Set X speed.
    lda #$0A                ;\ Set kicked state.
    bra +                   ;/
.Carryable:
    lda #$09                ;\ Set carryable state.
+   sta !14C8,x             ;/
	rtl

;===================================;
; Main routine wrapper              ;
;===================================;
print "MAIN ",pc
phb : phk : plb
	lda !15F6,x				;\ Flip it vertically.
	ora #$80				;|
	sta !15F6,x				;/
	lda $13                 ;\
    and #$01                ;|
    lda !15F6,x             ;| Cycle through the palettes every other frame.
    inc #2                  ;|
    and #$CF                ;|
    sta !15F6,x             ;/

    lda !14C8,x : cmp #$06 : beq ShellboardDead					; Call related routines depends on its' state.
				  cmp #$07 : beq ShellboardEaten
				  cmp #$08 : beq ShellboardStop
                  cmp #$09 : beq +
                  cmp #$0A : beq ++
                  cmp #$0B : beq +++
+   	jsr ShellboardMain : bra ++++
++  	jsr ShellboardKicked : bra ++++
+++ 	jsr ShellboardCarried : ++++

;===============;
; Handle states ;
;===============;
    lda !14C8,x
    cmp #$08
    lda #$80
    bcs +
	lda !14C8,x
	cmp #$04
	beq ShellboardDead
	cmp #$05
	beq ShellboardDead
ShellboardStop:
    lda #!InterruptNoInteractTime
    sta !154C,x
	lda #!InterruptNoInteractTime
    sta !1564,x
    lda #$09
    sta !14C8,x
	lda #$00
	%SubOffScreen()
plb : rtl
ShellboardEaten:
	inc !187B,x
plb : rtl
ShellboardDead:
    lda #$00
+   sta !extra_prop_2,x
plb : rtl

FacePlayer:
    %SubHorzPos()
    tya
    sta !157C,x
    rts

ShellboardMain:
    lda $9D                 ;\
    beq +                   ;| If sprites are locked, just draw graphics.
    jmp .DrawGFX       		;/
+   jsr HandleStunned       ;> Handle stunned timer and stuff.
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
    sta $98                 ;| Interact with the block.
    lda !14D4,x             ;| (i.e., Hit the block and trigger its effect.)
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
    lda #$08                ;\ Briefly disable interaction with quake sprites.
    sta !1FE2,x             ;/ ...to avoid being hit by the block's bounce sprite.
+   lda !1588,x             ;\
    and #$03                ;| If not touching the side of a block, skip.
    beq +                   ;/
    lda !B6,x               ;\
    asl                     ;|
    php                     ;| Bounce it backwards at 1/4th of its' original speed.
    ror !B6,x               ;|
    plp                     ;|
    ror !B6,x               ;/
+   jsr SprPlayerInteract   ;> Interact with sprites and Player.
.DrawGFX:
    jsr StationaryGFX       ;> Draw GFX.
    lda #$00                ;\ Handle offscreen.
    %SubOffScreen()         ;/
    rts

HandleStunned:
    lda !1540,x
    ora !1558,x
    sta !C2,x
    lda !1558,x             ;\
    beq CheckUnstun         ;|
    cmp #$01                ;|
    bne CheckUnstun         ;| Branch if no Koopa jumping into it.
    ldy !1594,x             ;|
    lda !15D0,x             ;|
    bne CheckUnstun         ;/
	jsl $07F78B|!bank       ;> Load sprite tables.
.Return:
    rts

CheckUnstun:
    lda !1540,x              ;\ If not stunned, return.
    beq HandleStunned_Return ;/

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
    lda #$00                ;| Set some Y speed.
    ldy !15B8,x             ;| (Gets overwritten unless touching layer 2 from above.)
    beq ++                  ;|
+   lda #$18                ;|
++  sta !AA,x               ;/
    pla
    lsr #2
    tay
    lda .BounceYSpeed,y     ;\
    ldy !1588,x             ;| Set Y speed using the table.
    bmi .Return             ;| (...unless it's on layer 2.)
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

StationaryGFX:
    lda #$06                ;\
    ldy !15EA,x             ;|
    bne .0                  ;| Set animation frame.
    lda #$08                ;|
.0: sta !1602,x             ;/
    lda !15EA,x             ;\
    pha                     ;|
    beq +                   ;| If OAM index is not 0, add 8 to it.
    clc                     ;|
    adc #$08                ;|
+   sta !15EA,x             ;/
    jsr ShellboardGFX       ;> Draw the sprite.
    pla
    sta !15EA,x
    lda !SWPassedFlag       ;\ If Special World passed, return.
    bmi .Return             ;/
    lda !1602,x             ;\
    cmp #$06                ;| If the opening of the sprite isn't facing the screen, return.
    bne .Return             ;/
.Return:
    rts

ShellboardKicked:
	lda !167A,x         		;\
    and #$10                	;| If it can't be kicked like a shell...
    beq KickedShellboard		;|
    jsr SetCarryable			;| Turn into carryable state.
    jmp StationaryGFX       	;/ ...and draw graphics.

KickedShellboard:
	lda !1528,x              ;\
    bne +                    ;|
    lda !B6,x                ;|
    clc                      ;| If not being caught by a Koopa, return to carryable if it slows down enough.
    adc #$20                 ;|
    cmp #$40                 ;|
    bcs +                    ;|
    jsr SetCarryable         ;/
+   stz !1528,x              ;\
    lda $9D                  ;|
    ora !163E,x              ;| If sprites are locked or (?) is happening, just draw graphics.
    beq +                    ;|
    jmp FinishHandleKicked_0 ;/
+   lda #$00                 ;\
    ldy !B6,x                ;|
    beq +                    ;| Set direction based on speed.
    bpl ++                   ;|
    inc                      ;|
++  sta !157C,x              ;/
+   lda !15B8,x
    pha
    jsl $01802A|!bank		;> Update X/Y positions with gravity and interact with blocks.
	jsl $01B44F|!bank		;> Solid routine.
    pla
    beq +
    sta $00
    ldy !164A,x             ;\
    bne +                   ;|
    cmp !15B8,x             ;|
    beq +                   ;| If just gone onto a slope, not in water and it's moving faster...
    eor !B6,x               ;| Than the slopes angle, make it bounce slightly.
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
    jsr SprPlayerInteract
.0: lda #$00
    %SubOffScreen()
    jmp KickedGFX

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
    lda #$05                ;\ Briefly disable interaction with quake sprite.
    sta !1FE2,x             ;/ (...To avoid being hit by the block's bounce sprite.)
.Return:
    rts

KickedGFX:
    lda $14                 ;\
    lsr #2                  ;|
    and #$03                ;|
    tay                     ;|
    phy                     ;|
    lda .AnimationFrames,y  ;|
    jsr StationaryGFX_0     ;| Animate the spinning shell.
    stz !1558,x             ;|
    ply                     ;|
    lda .GfxProps,y         ;|
    ldy !15EA,x             ;|
    eor $030B|!addr,y       ;|
    sta $030B|!addr,y       ;/
    rts

.AnimationFrames:
    db $06,$07,$08,$07

.GfxProps:
    db $00,$00,$00,$40

ShowSparkle:
 	ora !186C,x			; Don't show the sparkles if the sprite is offscreen vertically.
	bne .Return			;
	jsl $01ACF9|!bank	; Access RNG routine.
	and #$0F			;
	clc					;
	ldy #$00			;
	adc #$FC			;
	bpl $01				;
	dey					;
	clc					;
	adc !E4,x			;
	sta $02				;
	tya					;
	adc !14E0,x			;
	pha					;
	lda $02				;
	cmp $1A				;
	pla					;
	sbc $1B				; If the sparkle would be offscreen...
	bne .Return			; End the sparkle routine.
	lda $148E|!addr		;
	and #$0F			;
	clc					;
	adc #$FE			;
	adc !D8,x			;
	sta $00				;
	lda !14D4,x			;
	adc #$00			;
	sta $01				; Set the Y position of the sparkle.
	jsl $0285BA|!bank	; Create several sparkles. ★★★
.Return:
	rts
	
SmokeParticles:				; (Directly copied from Thomas[Kaizoman]'s "Shell-less Koopa" code.)
    lda.w !1588,x
    beq .Return
    lda $13
    and.b #$03
    ora $86
    bne .Return
    lda.b #$04
    sta $00
    lda.b #$0A
    sta $01
    lda !15A0,x
    ora !186C,x
    bne .Return
    ldy.b #$03
.SmokeLoop
    lda.w $17C0|!addr,y
    beq FoundSmokeSlot
    dey
    bpl .SmokeLoop
.Return
    rts

FoundSmokeSlot:
    lda.b #$03
    sta.w $17C0|!addr,y
    lda !E4,x
    adc $00
    sta.w $17C8|!addr,y
    lda !D8,x
    adc $01
    sta.w $17C4|!addr,y
    lda.b #$13
    sta.w $17CC|!addr,y
    rts

SprPlayerInteract:
    jsl $01803A|!bank       ;\ Interact with sprites, and check for contact with Player.
	bcc ++++++				;|
	lda !14C8,x				;|
	cmp #$09				;|
	beq ++++++				;|
	lda !14C8,x				;|
	cmp #$0A				;|
	bne ++					;|
	lda $19					;|
	cmp #$02				;|
	bne +					;|
	lda #$01				;|
	sta !1FE2,x				;|
	lda $1493|!addr			;|\
	cmp #$01				;||
	bcc +					;|/
	stz !1FE2,x				;|
	stz $13E8|!addr			;|
+	jsl $01A7DC|!bank		;|
	bcc +++++				;|
if !RidingMethod = 0
if !GoalSequenceFix = 0
	lda $1493|!addr			;|\
	cmp #$0A				;||
	bcs ++++				;|/
endif
if !GoalSequenceFix = 1
	lda $1493|!addr			;|\
	cmp #$01				;||
	bcs ++++				;|/
endif
	lda $13					;|\ Sparkle frame counter.
	and #$06				;|| Display sparkles once every 0x06 frames...
	jsr ShowSparkle			;|/
	jsr SmokeParticles		;|>
	lda !B6,x				;|\
	sta $7B					;||
	bra ++					;|/
endif
if !RidingMethod = 1
	lda $13					;|\
	and #$06				;||
	jsr ShowSparkle			;|/
	jsr SmokeParticles		;|>
	lda $16					;|\ Send off Player if pressed B or A, depends on its' X-speed. 
	eor $18					;||
	cmp #$80				;||
	bne ++++				;||
	lda !B6,x				;||
	sta $7B					;|/
endif
++
if !InstaGlideFlag
	lda $19					;|\
	cmp #$02				;||
	bne +++					;||
	lda !B6,x				;||
	cmp #!InstaGlideXSpeed	;||
	bcc +++					;||
	lda #$01				;||
	sta $1407|!addr			;||
	lda #$00				;||
	sta $1408|!addr			;|/
endif
+++	lda #$13				;\ Sparkles for a bit when you jump off.
	sta $18D3|!addr			;/
++++	
	%SubVertPos()			;\ (Directly copied from "SMB2 Shyguy + Giant Shyguy" by mikeyk.)
	lda $0E					;| Calculate with Player/Sprite Y position. (Player Y position - Sprite Y position)
	cmp #$E6				;| If this value is greater than E6... (x > E6)
	bmi +++++				;| Then, Player is touching the shell from the side or bottom.
	bra NoStar				;|
+++++
	lda $7D         		;| If Player speed is upward, return.
    bmi .Return             ;|
	bra RideShellboard		;|
++++++
    bcc .Return             ;/ Return if no contact.
    lda $1490|!addr         ;\ If Player has a star...
    beq NoStar              ;|
    lda !167A,x             ;| And the sprite can be star"kill"ed...
    and #$02                ;|
    bne NoStar              ;|
    %Star()                 ;/ Slam.
.Return:
    rts
	
RideShellboard:
	lda #$E1				;\
	sta !1534,x				;|
	lda #$D1				;|
	sta !1FD6,x				;|
	bra DoneIndexing		;/
	
DoneIndexing:
if !SpinBoost
	lda $1493|!addr			;\
	cmp #$01				;|
	bcc	+					;/
	stz $14A6|!addr			;\
	bra ++					;/
+	lda #$13				;\ SPEEEEEEEEEEEEEEEEN!
	sta $14A6|!addr			;/
endif
++	lda #$01                ;\ Set "On sprite" flag.
    sta $1471|!addr        	;/
	lda !1534,x             ;\
    ldy $187A|!addr         ;| Set Player's Y position to E1 or D1 depending if on yoshi.
    beq NoYoshi            	;|
    lda !1FD6,x             ;|
	
NoYoshi:
	clc                     ;|
    adc !D8,x               ;|
    sta $96                 ;|
    lda !14D4,x             ;|
    adc #$FF                ;|
    sta $97                 ;/
if !RidingMethod = 0
if !GoalSequenceFix = 0
	lda $1493|!addr
	cmp #$0A
	bcc +
endif
if !GoalSequenceFix = 1
	lda $1493|!addr
	cmp #$01
	bcc +
endif
	ldy #$00                ;\
    lda $1491|!addr         ;| Set to 01 or FF depending on direction. (Until "Peace sign" completely end in goal sequence.)
    bpl Label9              ;|\ Set Player's new X position. (Until "Peace sign" completely end in goal sequence.)
    dey                     ;|/

Label9:
	clc                     ;|
    adc $94             	;|
    sta $94             	;|
    tya                     ;|
    adc $95                 ;|
    sta $95                 ;/
endif
if !RidingMethod = 1
    ldy #$00                ;\
    lda $1491|!addr         ;| Set to 01 or FF depending on direction.
    bpl Label9              ;|\ Set Player's new X position.
    dey                     ;|/

Label9:
	clc                     ;|
    adc $94             	;|
    sta $94             	;|
    tya                     ;|
    adc $95                 ;|
    sta $95                 ;/
	lda $D1					;\ (Special thanks to JamesD28 for help me to figure this out properly! :D)
	sta !E4,x				;|
	lda $D2					;|
	sta !14E0,x				;/
endif
+	rts

NoStar:
    stz $18D2|!addr
    lda !154C,x             	  ;\ If contact is disabled, return.
    bne SprPlayerInteract_Return  ;/
    lda #!InterruptNoInteractTime ;\ Briefly disable contact.
    sta !154C,x             	  ;/
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
    sbc #$00                ;| Don't stand on the sprite if one of these is true:
    plp                     ;|  - Player's Y position is too low w.r.t. the sprite's Y position.
    sbc $D4                 ;|  - Player is moving upwards, the sprite can't be hit while moving upward.
    bmi NotStanding         ;|    and Player hasn't stood on any other enemies.
    lda $7D                 ;|  - Both Player and the sprite are on the ground.
    bpl +                   ;|
    lda !190F,x             ;|
    and #$10                ;|
    bne +                   ;|
    lda $1697|!addr         ;|
    beq NotStanding         ;|
+   lda !1588,x             ;|
    and #$04                ;|
    beq +                   ;|
    lda $72                 ;|
    beq NotStanding         ;/
+   lda !1656,x             ;\
    and #$10                ;| If the sprite can be stood on, jump.
    bne JumpOnSprite        ;/
    rts

NotStanding:
    lda $13ED|!addr         ;\ If sliding...
    beq +                   ;|
    lda !190F,x             ;| And sprite can be killed with slide...
    and #$04                ;|
    bne +                   ;|
    lda #$03                ;|
    sta $1DF9|!addr         ;|
    %Star()                 ;/ Slam.
    rts
+   lda $1497|!addr         ;\
    bne .Return             ;| If Player is invulnerable or riding Yoshi, return.
    lda $187A|!addr         ;|
    bne .Return             ;/
    lda !1686,x             ;\
    and #$10                ;| If set to change direction when touched, do it.
    bne .Return             ;|
    jsr FacePlayer          ;/
.Return:
    rts

JumpOnSprite:
    bra KickShellboard      ;> Kick it either you spinjumping or riding Yoshi.

NoSquish:
    lda !1662,x              ;\
    bpl DontFallStraightDown ;|
    lda #$09                 ;| If set to fall straight down, set state to 9.
    sta !14C8,x              ;/
.Return:
    rts

DontFallStraightDown:
    ldy !14C8,x             ;\
    stz !1626,x             ;| If in kicked state, turn into carryable state.
    cpy #$0A                ;|
    beq SetCarryable        ;/

SetCarryable:
    stz !1540,x             ;> Reset stun timer...
	lda #$09                ;\ ...and set state to carryable.
    sta !14C8,x             ;/
    rts

StationaryInteract:
    lda $140D|!addr         ;\ If spinjumping...
    ora $187A|!addr         ;| Or on Yoshi.
    beq CheckCarrying       ;|
    lda $7D                 ;| ...and moving downwards.
    bmi CheckCarrying       ;|
    lda !1656,x             ;| ...and sprite can be jumped on.
    and #$10                ;|
    beq CheckCarrying       ;|
	jmp JumpOnSprite        ;/ Then jump.

CheckCarrying:
    bit $15                 ;\ If X/Y held.
    bvc KickShellboard      ;| (For some reason, SMW uses LDA $15 : AND #$40 : BEQ, but they use BIT $15 : BVC elsewhere.)
    lda $1470|!addr         ;| ...and not carrying a sprite already.
    ora $187A|!addr         ;| ...and not on Yoshi.
    bne KickShellboard      ;|
    lda #$0B                ;| Make Player pick up the sprite.
    sta !14C8,x             ;|
    inc $1470|!addr         ;|
    lda #$08                ;|
    sta $1498|!addr         ;/
    rts

KickShellboard:
    jsr GivePoints           ;> Give points.
    lda #!KickedSFX          ;\ Play SFX.
    sta !KickedSFXAddr       ;/
    lda !1540,x              ;\ (Probably useless.)
    sta !C2,x                ;/
    lda #$0A                 ;\ Set kicked state.
    sta !14C8,x              ;/
    lda #!KickNoInteractTime ;\ Briefly disable interaction with Player.
    sta !154C,x              ;/
    %SubHorzPos()            ;\
    lda KickXSpeeds,y        ;| Set X speed based on throw direction.
    sta !B6,x                ;/
	rts

KickXSpeeds:
    db -!KickXSpeed,!KickXSpeed,$CC,$34

GivePoints:
    lda $1697|!addr         ;\
    clc                     ;|
    adc !1626,x             ;|
    inc $1697|!addr         ;|
    tay                     ;| Play bounce SFX when $1697+$1626,x < #$08.
    iny                     ;| (If >= @$08, it spawns a 1UP score sprite which plays the SFX.)
    cpy #$08                ;|
    bcs +                   ;|
    lda .SFX-1,y            ;|
    sta $1DF9|!addr         ;/
+   tya                     ;\
    cmp #$08                ;|
    bcc +                   ;| Give points accordingly. (Input capped to $08 = 1UP.)
    lda #$08                ;|
+   jsl $02ACE5|!bank       ;/
	rts

.SFX:
    db $13,$14,$15,$16,$17,$18,$19

ShellboardCarried:
    jsr ActuallyHandleCarried
    lda $13DD|!addr         ;\
    ora $1419|!addr         ;| If turning while sliding, going down a pipe, or facing the screen.
    bne +                   ;| Center the item on Player, and change OAM index to $00.
    lda $1499|!addr         ;| (...to make it draw in front of Player.)
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
    jsl $019138|!bank       ; Interact with blocks.
    lda $71                 ;\
    cmp #$01                ;|
    bcc +                   ;|
    lda $1419|!addr         ;| If Player let go of the sprite, return to carryable state.
    bne +                   ;|
    lda #$09                ;|
    sta !14C8,x             ;/
.Return:
    rts
+   lda !14C8,x             ;\
    cmp #$08                ;| If returned to normal state, return.
    beq .Return             ;/
    lda $9D                 ;\
    beq +                   ;| If sprites locked, just handle offset from Player.
    jmp OffsetFromPlayer    ;/
+   jsr HandleStunned       ;> Handle stun timer stuff.
    jsl $018032|!bank       ;> Interact with sprites.
    lda $1419|!addr         ;\
    bne +                   ;|
    bit $15                 ;| If X/Y held or Player going down a pipe, offset the sprite from his position.
    bvc LetGoOfSprite       ;|
+   jmp OffsetFromPlayer    ;/

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
    lda $D1                 ;|
    clc                     ;|
    adc .XOffsetLow,y       ;| Offset sprite from Player based on his direction.
    sta !E4,x               ;|
    lda $D2                 ;|
    adc .XOffsetHigh,y      ;|
    sta !14E0,x             ;/
    %SubHorzPos()           ;\
    lda .XSpeed,y           ;|
    clc                     ;| Set sprite's X speed based on drop direction + Player's X speed.
    adc $7B                 ;|
    sta !B6,x               ;/
    stz !AA,x               ;> Reset sprite's Y speed.
    bra FinishKicking

.XOffsetLow:
    db -!DropXOffset,!DropXOffset

.XOffsetHigh:
    db $FF,$00

.XSpeed:
    db -!DropXSpeed,!DropXSpeed

KickUp:
    jsl $01AB6F|!bank       ;> Show contact GFX.
    lda #!KickYSpeed        ;\ Set Y speed.
    sta !AA,x               ;/
    lda $7B                 ;\
    sta !B6,x               ;| Give the sprite half of Player's X speed.
    asl                     ;|
    ror !B6,x               ;/
    bra FinishKicking

KickSideways:
    jsl $01AB6F|!bank       ;> Show contact GFX.
    lda !1540,x             ;\ (Probably useless.)
    sta !C2,x               ;/
    lda #$0A                ;\ Set kicked state.
    sta !14C8,x             ;/
    ldy $76
    lda $187A|!addr         ;\
    beq +                   ;| If on Yoshi, use different speeds.
    iny #2                  ;/
+   lda KickXSpeeds,y       ;\
    sta !B6,x               ;|
	eor $7B                 ;|
    bmi FinishKicking       ;|
    lda $7B                 ;| Set base X speed, and add half of Player's speed.
    sta $00                 ;| ...if moving in the same direction as him.
    asl $00                 ;|
    ror                     ;|
    clc                     ;|
    adc KickXSpeeds,y       ;|
    sta !B6,x               ;/

FinishKicking:
    lda #!KickNoInteractTime ;\ Briefly disable interaction with Player.
    sta !154C,x              ;/
    lda #$0C                 ;\ Briefly show kicked pose.
    sta $149A|!addr          ;/
    rts

OffsetFromPlayer:
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
    sta $00                 ;| Use Player's position on the next frame.
    lda $95,y               ;| ...unless Player is on a brown chained platform or a falling grey platform.
    sta $01                 ;| (Which use the current frame.)
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

;==================;
; Main GFX routine ;
;==================;
ShellboardGFX:
    %GetDrawInfo()
    lda $00                 ;\ Set X/Y position.
    sta $0300|!addr,y       ;|
    lda $01                 ;|
    sta $0301|!addr,y       ;/
    ldy !1602,x             ;\ Set tile based on animation frame.
    lda .Tilemap-6,y        ;| ($1602 starts from 6 for shells...)
    ldy !15EA,x             ;| (Restore OAM index.)
    sta $0302|!addr,y       ;/
    lda !157C,x             ;\ Set YXPPCCCT.
    lsr                     ;|
    lda #$80                ;|
    ora !15F6,x             ;|
    bcs +                   ;|
    eor #$40                ;| (Flip if facing left)
+   ora $64                 ;|
    sta $0303|!addr,y       ;/
    tya                     ;\ Set size. (16x16)
    lsr #2                  ;|
    tay                     ;|
    lda #$02                ;|
    ora !15A0,x             ;|
    sta $0460|!addr,y       ;/
    jsr CheckDrawOnscreen
    rts

.Tilemap:
    db !ShellboardTiles

;===============================;
; On-screen draw related stuffs ;
;===============================;
CheckDrawOnscreen:
    lda !186C,x             ;\ Return if on-screen.
    beq .Return             ;/
    lsr                     ;\ Draw bottom tile if on-screen.
    bcc +                   ;|
    pha                     ;|
    lda #$01                ;|
    sta $0460|!addr,y       ;|
    tya                     ;|
    asl #2                  ;|
    tax                     ;|
    lda #$80                ;|
    sta $0300|!addr,x       ;|
    pla                     ;/
+   lsr                     ;\ Draw top tile if on-screen.
    bcc +                   ;|
    lda #$01                ;|
    sta $0461|!addr,y       ;|
    tya                     ;|
    asl #2                  ;|
    tax                     ;|
    lda #$80                ;|
    sta $0304|!addr,x       ;/
+   ldx $15E9|!addr         ;> Restore sprite index.
.Return:
    rts
