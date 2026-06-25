;A disassembly of the parachute sprites (goomba & bomb)
; Uses Extra Property Byte 1:
;   00: Para-Goomba
;   01: Para-Bomb

!TileTopGoombaNormal            = $A3   ;|\ each tile is 8x8
!TileBottomGoombaNormal         = $B3   ;||
!TileTopLeftGoombaTilted        = $E8   ;||
!TileTopRightGoombaTilted       = $E9   ;||
!TileBottomLeftGoombaTilted     = $F8   ;||
!TileBottomRightGoombaTilted    = $F9   ;|/

!TileTopBombNormal              = $A2   ;|\ each tile is 8x8
!TileBottomBombNormal           = $B2   ;||
!TileTopLeftBombTilted          = $C2   ;||
!TileTopRightBombTilted         = $C3   ;||
!TileBottomLeftBombTilted       = $D2   ;||
!TileBottomRightBombTilted      = $D3   ;|/

!TileParachute                  = $E2   ;|\ tiles are 16x16
!TileParachuteTilted            = $E6   ;|/

;-----------------------------------------------------------------------------------------------------------------------
;Setup sprite main and init
;do not change anything below this unless you know what you are doing
;-----------------------------------------------------------------------------------------------------------------------
!Routine_ObjInteract = $019138|!bank

tableAngleValues:               ;Increment/decrement values, used for the parachute sprite's angles.
    db $01,$FF
tableMaxMinValue:               ;Max/min angle values for the parachute sprite.
    db $0F,$00
tableXSpeedsAngles:             ;X speeds for each angular value (00-0F). Inverted when moving left.
    db $00,$02,$04,$06,$08,$0A,$0C,$0E
    db $0E,$0C,$0A,$08,$06,$04,$02,$00

print " INIT ",pc

RTL

print " MAIN ",pc
    PHB
    PHK
    PLB
    JSR SpriteMain
    PLB
RTL

; Para-Goomba/Bomb misc RAM:
; $C2   - Swing direction (odd = left, even = right)
; $151C - Flag for having hit the side of a block. When set, the sprite locks its animation and sinks straight down.
; $1540 - Timer after landing for the parachute to decend.
; $1570 - Current "angle" (max #$0F)
; $157C - Horizontal direction the sprite is facing.
; $1602 - Current animation frame for the parachute. 0 = normal, 1 = tilt left, 2 = tilt right
;          For the parachute's subroutine, values are C (normal) and D (tilted).
    
SpriteMain:                     ;| Para-Goomba MAIN / Para-Bomb MAIN
    LDA !14C8,x                 ;|\ 
    CMP #$08                    ;|| Skip to graphics if dead.
    BEQ SpriteAlive             ;||
    JMP TurnIntoOtherSpr        ;|/

SpriteAlive:
    LDA $9D                     ;|\ 
    BNE handleGFX               ;|| Skip movement if game frozen or landing on the ground.
    LDA !1540,x                 ;||
    BNE handleGFX               ;|/
    LDA $13                     ;|\ 
    LSR                         ;||
    BCC checkWallContact        ;|| Move downwards one pixel every two frames.
    INC !D8,x                   ;||
    BNE checkWallContact        ;||
    INC !14D4,x                 ;|/
checkWallContact:
    LDA !151C,x                 ;|\ Skip horizontal movement if the sprite hit a wall.
    BNE handleGFX               ;|/
    LDA $13                     ;|\ 
    LSR                         ;||
    BCC handleXSpeed            ;||
    LDA !C2,x                   ;||
    AND #$01                    ;||
    TAY                         ;|| Every two frames, increase/decrease the current angle.
    LDA !1570,x                 ;|| If at the maximum, invert direction of movement.
    CLC                         ;||
    ADC tableAngleValues,y      ;||
    STA !1570,x                 ;||
    CMP tableMaxMinValue,y      ;||
    BNE handleXSpeed            ;||
    INC !C2,x                   ;|/
handleXSpeed:
    LDA !B6,x                   ;|\ 
    PHA                         ;||
    LDY !1570,x                 ;||
    LDA !C2,x                   ;||
    LSR                         ;||
    LDA tableXSpeedsAngles,y    ;||
    BCC storeXSpeed             ;||
    EOR #$FF                    ;|| Update X position, using the angle and current direction to find the X speed.
    INC A                       ;||
storeXSpeed:                    ;||
    CLC                         ;||
    ADC !B6,x                   ;||
    STA !B6,x                   ;||
    JSL $018022|!bank           ;|| Update X position without gravity
    PLA                         ;||
    STA !B6,x                   ;|/
    ;BRA handleGFX              ;| no idea why Nintendo put a BRA here

handleGFX:                      ;Handle the parachute's graphics.
    LDA #$00                    ;|\ 
    %SubOffScreen()             ;|/ Process offscreen
    JMP GFX                     ;Draw GFX and interact with Mario.
;-----------------------------------------------------------------------------------------------------------------------
;GFX Routine
;-----------------------------------------------------------------------------------------------------------------------
tableAnimationFrames:           ;Animation frames for the parachute, indexed by the sprite's angle ($1570).
    db $0D,$0D,$0D,$0D,$0C,$0C,$0C,$0C
    db $0C,$0C,$0C,$0C,$0D,$0D,$0D,$0D
tableDirections:                ;Horizontal directions for the frames designated above.
    db $00,$00,$00,$00,$00,$00,$00,$00
    db $01,$01,$01,$01,$01,$01,$01,$01  
tableXOffsetLow:                ;X offsets (low) for the Goomba/Bob-omb.
    db $F8,$F8,$FA,$FA,$FC,$FC,$FE,$FE
    db $02,$02,$04,$04,$06,$06,$08,$08
tableXOffsetHigh:               ;X offsets (high) for the Goomba/Bob-omb.
    db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
    db $00,$00,$00,$00,$00,$00,$00,$00
tableYOffset:                   ;Y offsets for the Goomba/Bob-omb from the parachute.
    db $0E,$0E,$0F,$0F,$10,$10,$10,$10
    db $10,$10,$10,$10,$0F,$0F,$0E,$0E
tableSprNumbers:                ;Sprite numbers for the parachute sprites to turn into. (Goomba, Bomb)
    db $0F,$0D
tableYXPPCCCT:                  ;YXPPCCCT data indexes of each frame for the Goomba/Bob-omb's draw call.
    db $01,$05,$00

GFX:                            ;Parachute sprite GFX routine.
    STZ $185E|!addr             ;|\ 
    LDY #$F0                    ;||
    LDA !1540,x                 ;||
    BEQ HasLanded               ;||
    LSR                         ;||
    EOR #$0F                    ;||
    STA $185E|!addr             ;||
    CLC                         ;||
    ADC #$F0                    ;|| Get vertical position for the parachute.
    TAY                         ;|| Normally one tile above the sprite;
HasLanded:                      ;|| when landing, sinks into it instead.
    STY $00                     ;||
    LDA !D8,x                   ;||
    PHA                         ;||
    CLC                         ;||
    ADC $00                     ;||
    STA !D8,x                   ;||
    LDA !14D4,x                 ;||
    PHA                         ;||
    ADC #$FF                    ;||
    STA !14D4,x                 ;|/
    LDA !15F6,x                 ;|\ 
    PHA                         ;|| Set the parachute's palette.
    AND #$F1                    ;||
    ORA #$06                    ;|| Palette to use.
    STA !15F6,x                 ;|/
    LDY !1570,x                 ;|\ 
    LDA tableAnimationFrames,y  ;|| Get animation frame/direction for the parachute.
    STA !1602,x                 ;||  0C = normal, 0D = tilted.
    LDA tableDirections,y       ;||
    STA !157C,x                 ;|/
    JSR SubSprGfx2Entry1        ;|\ Draw a 16x16 tile.
    PLA                         ;||
    STA !15F6,x                 ;|/
    LDA !15EA,x                 ;|
    CLC                         ;|
    ADC #$04                    ;|
    STA !15EA,x                 ;|
    LDY !1570,x                 ;|\ 
    LDA !E4,x                   ;|| 
    PHA                         ;||
    CLC                         ;||
    ADC tableXOffsetLow,y       ;||
    STA !E4,x                   ;|| Get horizontal position for the Goomba/Bob-omb.
    LDA !14E0,x                 ;||
    PHA                         ;||
    ADC tableXOffsetHigh,y      ;||
    STA !14E0,x                 ;|/
    STZ $00                     ;|\ 
    LDA tableYOffset,y          ;||
    SEC                         ;||
    SBC $185E|!addr             ;||
    BPL handleYPos              ;||
    DEC $00                     ;||
handleYPos:                     ;|| Get vertical position for the Goomba/Bob-omb, offset from the parachute.
    CLC                         ;|| 
    ADC !D8,x                   ;||
    STA !D8,x                   ;||
    LDA !14D4,x                 ;||
    ADC $00                     ;||
    STA !14D4,x                 ;|/
    LDA !1602,x                 ;|\ 
    SEC                         ;||
    SBC #$0C                    ;||
    CMP #$01                    ;||
    BNE StoreAnimationFrame     ;|| Get animation frame for the Goomba/Bob-omb.
    CLC                         ;||  00 = normal, 01 = tilted left, 02 = tilted right.
    ADC !157C,x                 ;||
StoreAnimationFrame:            ;||
    STA !1602,x                 ;|/
    LDA !1540,x                 ;|\ 
    BEQ NotLanded               ;|| If it landed on the ground, clear the animation frame.
    STZ !1602,x                 ;|/
NotLanded:
    LDY !1602,x                 ;|\ 
    LDA tableYXPPCCCT,y         ;|| Draw four 8x8s.
    JSR SubSprGfx0Entry0        ;|/ The first shared GFX routine. This creates 4 8x8 tiles in a 16x16 block
    JSL $01803A|!bank           ;|\ Process interaction with Mario and other sprites.
    BCC NoInteraction           ;||
    PLA : PLA : PLA : PLA       ;||
    BRA TurnIntoOtherSpr        ;|/
NoInteraction:
    LDA !1540,x                 ;|\ 
    BEQ HasntLanded             ;|| Branch depending on whether the sprite has landed or in the process of landing.
    DEC A                       ;||
    BNE LandedOnGround          ;|/
    STZ !AA,x                   ;|\ 
    PLA                         ;||
    PLA                         ;||
    PLA                         ;||
    STA !14D4,x                 ;||
    PLA                         ;||
    STA !D8,x                   ;||
    LDA #$80                    ;||
    STA !1540,x                 ;|| Turn the sprite into a Bob-omb/Goomba, and set its stun timer.
TurnIntoOtherSpr:               ;||
    ; LDA !9E,x                 ;|| replaced by custom code to load from extra property byte 1
    ; SEC                       ;||
    ; SBC #$3F                  ;||
    ; TAY                       ;||
    LDA !extra_prop_1,x         ;|\ load sprite number based on extra prop 1
    TAY                         ;||
    LDA tableSprNumbers,y       ;||
    STA !9E,x                   ;||
    JSL $07F78B|!bank           ;|| Subroutine to reload tweaker bytes for a sprite slot
    LDA #$00
    STA !extra_bits,x           ;|/ change into vanilla sprite
RTS                             ;|
;-----------------------------------------------------------------------------------------------------------------------
;main sprite behaviour
;-----------------------------------------------------------------------------------------------------------------------
LandedOnGround:                 ;Landed on the ground, waiting for parachute to fall.
    ;JSL !Routine_ObjInteract   ;|\ Useless. (likely leftover from an older version)
    ;JSR IsOnGround             ;||
    ;BEQ NotOnGround            ;||
    ;JSR SetSomeYSpeed          ;|| 
;NotOnGround:                   ;||
    ;JSL $01801A                ;||
    ;INC !AA,x                  ;|/
    BRA RestorePosValues        ;| Restore position values.

HasntLanded:                    ;| Hasn't landed.
    TXA                         ;|\ 
    EOR $13                     ;||
    LSR                         ;|| Process object interaction every other frame.
    BCC RestorePosValues        ;||
    JSL !Routine_ObjInteract    ;|/
    JSR IsTouchingObjSide       ;|\ 
    BEQ NotTouchingObjSide      ;||
    LDA #$01                    ;|| If it hits the side of a block, lock its angle at #$07.
    STA !151C,x                 ;||
    LDA #$07                    ;||
    STA !1570,x                 ;|/
NotTouchingObjSide:
    JSR IsOnGround              ;|\ 
    BEQ RestorePosValues        ;|| If it hits the ground, start the "falling parachute" timer.
    LDA #$20                    ;||
    STA !1540,x                 ;|/
RestorePosValues:
    PLA                         ;|\ 
    STA !14E0,x                 ;||
    PLA                         ;||
    STA !E4,x                   ;|| Restore position values.
    PLA                         ;||
    STA !14D4,x                 ;||
    PLA                         ;||
    STA !D8,x                   ;|/
RTS
;-----------------------------------------------------------------------------------------------------------------------
;Routines to check which sides the sprite is blocked from (object interaction, $1588)
;-----------------------------------------------------------------------------------------------------------------------
IsOnGround:                     ;| Subroutine (JSR) to check if a sprite is touching the top of a solid block.
    LDA !1588,x                 ;|\ check if blocked from below
    AND #$04                    ;|/
RTS

IsTouchingObjSide:              ;Subroutine (JSR) to check if a sprite is touching the sides of a solid block.
    LDA !1588,x                 ;|\ check if blocked from the sides
    AND #$03                    ;|/
RTS
;-----------------------------------------------------------------------------------------------------------------------
;Set Y-Speed Routine
;Subroutine to set Y speed for a sprite when on the ground.

;Used in the vanilla sprite although it does literally nothing
;-----------------------------------------------------------------------------------------------------------------------
;SetSomeYSpeed:
    ;LDA !1588,x                ;|\ 
    ;BMI IsOnLayer2             ;||
    ;LDA #$00                   ;|| 
    ;LDY !15B8,x                ;|| If standing on a slope or Layer 2, give the sprite a Y speed of #$18.
    ;BEQ StoreYSpeed            ;|| Else, clear its Y speed.
;IsOnLayer2:                    ;||
    ;LDA #$18                   ;||
;StoreYSpeed:                   ;||
    ;STA !AA,x                  ;|/
;RTS
;-----------------------------------------------------------------------------------------------------------------------
;Third shared GFX routine. This one creates a single 16x16 tile
; Misc RAM input:
; $157C - Horizontal direction the sprite is facing.
; $1602 - Animation frame.
;-----------------------------------------------------------------------------------------------------------------------
SprTilemapOffset:
    db $00,$0E

SprTilemap:
;Goomba
    db !TileTopGoombaNormal,!TileTopGoombaNormal,!TileBottomGoombaNormal,!TileBottomGoombaNormal
    db !TileTopRightGoombaTilted,!TileTopLeftGoombaTilted,!TileBottomRightGoombaTilted,!TileBottomLeftGoombaTilted
    db !TileTopLeftGoombaTilted,!TileTopRightGoombaTilted,!TileBottomLeftGoombaTilted,!TileBottomRightGoombaTilted
    db !TileParachute,!TileParachuteTilted
;Bomb
    db !TileTopBombNormal,!TileTopBombNormal,!TileBottomBombNormal,!TileBottomBombNormal
    db !TileTopRightBombTilted,!TileTopLeftBombTilted,!TileBottomRightBombTilted,!TileBottomLeftBombTilted
    db !TileTopLeftBombTilted,!TileTopRightBombTilted,!TileBottomLeftBombTilted,!TileBottomRightBombTilted
    db !TileParachute,!TileParachuteTilted

SubSprGfx2Entry1:
    STZ $04
    %GetDrawInfo()              ;
    LDA !157C,x                 ;
    STA $02                     ;
    ;LDY !9E,x                  ;|\ loads sprite number in vanilla, which, obviously, doesn't work here
    LDA !extra_prop_1,x         ;|\ 
    TAY
    LDA !1602,x                 ;||
    CLC                         ;||
    ADC SprTilemapOffset,y      ;|| Set tile number.
    LDY !15EA,x                 ;|| Restore OAM index
    TAX                         ;||
    LDA SprTilemap,x            ;||
    STA $0302|!addr,y           ;|/
    LDX $15E9|!addr             ;| restore sprite slot
    LDA $00                     ;|\ 
    STA $0300|!addr,y           ;|| Set X/Y offsets.
    LDA $01                     ;||
    STA $0301|!addr,y           ;|/
    LDA !157C,x                 ;|\ 
    LSR                         ;||
    LDA #$00                    ;||
    ORA !15F6,x                 ;||
    BCS StoreProps              ;|| Set YXPPCCCT.
    EOR #$40                    ;||  Flip X if the sprite is facing left.
StoreProps:                     ;||
    ORA $04                     ;||
    ORA $64                     ;||
    STA $0303|!addr,y           ;|/
    TYA                         ;|
    LSR                         ;|
    LSR                         ;|
    TAY                         ;|
    LDA #$02                    ;|\ 
    ORA !15A0,x                 ;|| Draw a 16x16.
    STA $0460|!addr,y           ;||
    JSR CheckIfOnScreen         ;|/
RTS
;-----------------------------------------------------------------------------------------------------------------------
;Check if on-screen routine
;Checks whether tiles being drawn are actually on the screen, and don't draw if not.
;-----------------------------------------------------------------------------------------------------------------------
CheckIfOnScreen:
    LDA !186C,x                 ;|\ Return if on-screen.
    BEQ ReturnCheckIfOnScreen   ;|/
    PHX                         ;|
    LSR                         ;|\ 
    BCC checkTopTile            ;||
    PHA                         ;||
    LDA #$01                    ;||
    STA $0460|!addr,y           ;||
    TYA                         ;|| Draw bottom tile if on-screen.
    ASL                         ;||
    ASL                         ;||
    TAX                         ;||
    LDA #$80                    ;||
    STA $0300|!addr,x           ;||
    PLA                         ;|/
checkTopTile:
    LSR                         ;|\ 
    BCC IsOffScreen             ;||
    LDA #$01                    ;||
    STA $0461|!addr,y           ;||
    TYA                         ;|| Draw top tile if on-screen.
    ASL                         ;||
    ASL                         ;||
    TAX                         ;||
    LDA #$80                    ;||
    STA $0304|!addr,x           ;|/
IsOffScreen:
    PLX                         ;restore X
ReturnCheckIfOnScreen:
RTS
;-----------------------------------------------------------------------------------------------------------------------
;The first shared GFX routine.
;This creates 4 8x8 tiles in a 16x16 block.

; Misc RAM input:
; $1602 - Animation frame.
    
; Scratch RAM setup:
; A = Index (divided by 4) to the YXPPCCCT properties table.
; Y = Additional Y position offset for the graphics, when using Entry1.

; Scratch RAM usage and output:
; $00 = Tile X offset.
; $01 = Tile Y offset.
; $02 = Index to the sprite tilemap table.
; $03 = General YXPPCCCT for the sprite.
; $04 = Used to count the 8x8 tiles. Returns with #$00.
; $05 = A; index (divided by 4) to the YXPPCCCT properties table.
; $0F = Y; additional Y offset.
;-----------------------------------------------------------------------------------------------------------------------
GeneralSprDispX:                ;X displacements for each 8x8 in the first shared GFX routine.
    db $00,$08,$00,$08

GeneralSprDispY:                ;Y displacements for each 8x8 in the first shared GFX routine.
    db $00,$00,$08,$08

GeneralSprGfxProp:              ;YXPPCCCT bytes for tiles in the first shared GFX routine (four 8x8s). p = normal in the representations.
    db $00,$00,$00,$00          ; 00 - pp   |      pq   |      qp
    db $00,$40,$00,$40          ;      pp   | 04 - pq   | 05 - qp
    
    db $00,$40,$80,$C0          ; 08 - pq   |      qq
    db $40,$40,$00,$00          ;      bd   | 0C - pp
    
    db $40,$00,$C0,$80          ; 10 - qp   |      qq
    db $40,$40,$40,$40          ;      db   | 14 - qq

SubSprGfx0Entry0:
    LDY #$00                    ;|
    STA $05                     ;|
    STY $0F                     ;|
    %GetDrawInfo()              ;|
    LDY $0F                     ;|\ 
    TYA                         ;||
    CLC                         ;|| Add Y position offset to the draw position.
    ADC $01                     ;||
    STA $01                     ;|/
    ;LDY !9E,x                  ;|\ loads sprite number in vanilla, which, obviously, doesn't work here
    LDA !extra_prop_1,x         ;|\ 
    TAY
    LDA !1602,x                 ;||
    ASL                         ;|| $02 = Index to the tilemap table for the tile.
    ASL                         ;||
    ADC SprTilemapOffset,y      ;||
    STA $02                     ;|/
    LDA !15F6,x                 ;|\ 
    ORA $64                     ;|| $03 = YXPPCCCT.
    STA $03                     ;|/
    LDY !15EA,x                 ;| Restore OAM index
    LDA #$03                    ;|\ $04 = Counter for the current tile being drawn.
    STA $04                     ;|/
    PHX                         ;|
GFXLoop:
    LDX $04                     ;|
    LDA $00                     ;|\ 
    CLC                         ;|| Store X position.
    ADC GeneralSprDispX,x       ;||
    STA $0300|!addr,y           ;|/
    LDA $01                     ;|\ 
    CLC                         ;|| Store Y position.
    ADC GeneralSprDispY,x       ;||
    STA $0301|!addr,y           ;|/
    LDA $02                     ;|\ 
    CLC                         ;||
    ADC $04                     ;|| Store tile number.
    TAX                         ;||
    LDA SprTilemap,x            ;||
    STA $0302|!addr,y           ;|/
    LDA $05                     ;|\ 
    ASL                         ;||
    ASL                         ;||
    ADC $04                     ;|| Store YXPPCCCT.
    TAX                         ;||
    LDA GeneralSprGfxProp,x     ;||
    ORA $03                     ;||
    STA $0303|!addr,y           ;|/
    INY                         ;|\ 
    INY                         ;||
    INY                         ;|| Loop for all 4 tiles.
    INY                         ;||
    DEC $04                     ;||
    BPL GFXLoop                 ;|/
    PLX                         ;|
    LDA #$03                    ;|\ 
    LDY #$00                    ;|| Draw 4 8x8 tiles.
    JSL $01B7B3|!bank           ;|/
RTS