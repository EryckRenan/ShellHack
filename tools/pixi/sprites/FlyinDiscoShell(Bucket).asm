;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Flying Disco Shell
;
;This is a disco shell that follows player in air.
;
;By RussianMan. Requested by AbuseFreakHacker.
;Credit is optional.
;
;Adjusted by Bucket to match the regular Disco shell's speed
;and physics a _bit_ closer.
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;
; Notes on speed.
;  $20 for Right speed seems to match pretty well with the vanilla discoshell.
;  $DF for Left speed seems to match pretty well with the vanilla discoshell.
;
;  $DF for left matches speed, but when mario is riding going left and holding left,
;    the shell will move slightly faster, which causes mario to bounce back when mario's
;    X-position is greater than the middle of the shell.
;  $E0 for left makes the flying shell move slower than the vanilla shell going left,
;    but prevents the issue described above, and mario will also move just ever so
;    slighty faster than the shell.
;
; Vanilla Disco Shells:
;  - When riding and holding right, mario will move very slightly faster than the discoshell.
;  - When riding and holding left, mario will match the disco shell's speed.
;

!MaxRightSpeed = $20
!MaxLeftSpeed = $E0

!RightAccelleration = #$02
!LeftAccelleration = #$01
; when moving left, we will adjust accel once every few frames.
; this is because vanilla SMW is jaaaaank
!LeftSpeedFrameTimer = #$02
!LeftSpeedFrameTimerAccelleration = #$02
!AddressTableFrameTimer = $1558

WallBumpSpeed:
db !MaxLeftSpeed,!MaxRightSpeed

Tilemap:
db $8C,$8A,$8E,$8A

WingTiles:
db $5D,$C6,$5D,$C6

Print "INIT ",pc
INC !187B,x			;flag necessary for correct interactions (bouncing on it and yoshi eating)

LDA #$0A
STA !14C8,x			;spawn as kicked
RTL

Print "KICKED",pc
Print "MAIN ",pc		;when dead, runs this
PHB
PHK
PLB
JSR Code
PLB
RTL

Code:
LDA #$00			;
%SubOffScreen()			;no more dupe shenanigans I hope

JSR GFX				;show graphics

LDA !14C8,x			;if dead
;EOR #$08			;
CMP #$0A
BCC .skiptoreturn

LDA $9D				;or frozen in time and space
BNE .skiptoreturn				;return

%SubHorzPos()			;face player. always.
TYA				;
STA !157C,x			;

STZ !AA,x			;no Y-speed
JSL $01802A|!BankB		;

;------------------------------------------------------------
; Brand new Velocity Routine!
; Bucket did this junk. because what else do i have to do
; with my life other than fix a sprite that no one likes. :|
;------------------------------------------------------------

; first we determine if we need to set Left or Right speed.
; SubHorzPos was previously stored in 157C,x
; i always CMP #$00 because i don't trust the Z flag.  :|
    LDA !157C,x
    CMP #$00
    BEQ .rightspeed
    BRA .leftspeed

.skiptoreturn
    BRA .Re

.rightspeed
    ; aight we got some right speed to deal with.
    LDA !B6,x
    CLC
    ADC !RightAccelleration
    STA !B6,x

    ; now check if we hit our max, if so we'll set to max.
    CLC
    LDA !B6,x
    CMP #!MaxRightSpeed
    BCC .endofspeed

    ; also check to see if we're currently moving right, opposed to slowing down.
    ; otherwise if we immediately switched direction we'll hit this as well.
    ; we compare against 7F, as this determines which direction we're moving.
    CLC
    LDA !B6,x
    CMP #$7F
    BCS .endofspeed

    ; set to max here.
    LDA #!MaxRightSpeed
    STA !B6,x

    BRA .endofspeed
.leftspeed
    ; aight we got some left speed. it's as if we can read labels or something.

    ; so left-speed in SMW is fucking weird.
    ; this code attempts to NOT apply accelleration every X or so frames,
    ; allowing us to fine-tune some of our speed variables.
    
    ; if zero, we ignore adjusting speed and reset our timer.
    LDA !AddressTableFrameTimer,x
    CMP #$00
    BEQ .timeraccel
    BRA .regularaccel

.timeraccel
    LDA !B6,x
    CLC
    SBC !LeftSpeedFrameTimerAccelleration
    STA !B6,x

    ; reset our timer as well.
    LDA !LeftSpeedFrameTimer
    STA !AddressTableFrameTimer,x

    BRA .acceldone
.regularaccel
    LDA !B6,x
    CLC
    SBC !LeftAccelleration
    STA !B6,x
    BRA .acceldone
.acceldone
    ; now check if we hit our max, if so we'll set to max.
    CLC
    LDA !B6,x
    CMP #!MaxLeftSpeed
    BCS .endofspeed

    ; check to make sure we're currently moving left, not just slowing down.
    CLC
    LDA !B6,x
    CMP #$7F
    BCC .endofspeed

    ; set to max here.
    LDA #!MaxLeftSpeed
    STA !B6,x

    BRA .endofspeed
.endofspeed

;------------------------------------------------------------
; End of that crap.
;------------------------------------------------------------




LDA !1588,x			;if hit wall bounce away and maybe trigger bounce sprite
AND #$03			;
BEQ .NoWall			;
PHA				;
JSR WallHit			;
PLA				;
AND #$03			;
DEC				;
TAY				;
LDA WallBumpSpeed,y		;set bumping speed
STA !B6,x			;

.NoWall
LDA $13				;change palette every other frame
LSR				;
BCS .NoPaletteChange		;slightly faster
;AND #$01			;
;BNE .NoPaletteChange		;

LDA !15F6,x			;makes CFG editor useless (for setting palettes i mean, you can set it to use second gfx page).
INC #2				;
AND #$CF			;
STA !15F6,x			;

.NoPaletteChange
;LDA #$0A			;weird workaround for sprites
;STA !14C8,x			;because they don't react to shell like they should unless it's in thrown state (not 100% accurate, yellow koopas won't jump over it)

JSL $01803A|!BankB		;interact with player and sprites

;LDA !14C8,x			;if it got killed in process
;CMP #$0A			;
;BNE .Re			;leave it be

;LDA #$08			;restore state to normal
;STA !14C8,x			;(sadly kills flying shell <-> flying shell death, both must be in kicked state) (not the case anymore, thanks KICKED state)

.Re
RTS

;not so interesting tables stored away

XDisp:
db $04,$00,$FC,$00

YDisp:
db $F1,$00,$F0,$00

WingSize:
db $00,$02,$00,$02

WingXDisp:
db $FB,$F3,$0D,$0D

WingYDisp:
db $FF,$F7,$FF,$F7

WingProps:
db $76,$76,$36,$36

XFlip:
db $00,$00,$00,$40		;only last byte is flip for one of shell's frames

GFX:
%GetDrawInfo()

STZ $03
LDA !14C8,x			;
;EOR #$08			;
CMP #$0A
BCS .OK
INC $03				;set scratch ram to contains information on wether sprite's in normal status.

.OK
LDA $00				;
STA $0300|!Base2,y		;shell tile X-pos

LDA $01				;
STA $0301|!Base2,y		;shell tile Y-pos

PHY				;
LDA $03				;if dead, don't animate shell
BNE .NoAnim			;

LDA $14				;animate with frame counter and all

.NoAnim
LSR #2				;
AND #$03			;fetch correct tile and flip info
TAY				;
LDA XFlip,y			;
STA $02				;
LDA Tilemap,y			;
PLY				;
STA $0302|!Base2,y		;

LDA $02				;flip info
ORA !15F6,x			;+cfg setting which is useless because we set it afterwards
ORA $64				;and priority
STA $0303|!Base2,y		;store as tile property

PHY				;
TYA				;
LSR #2				;
TAY				;
LDA #$02			;
STA $0460|!Base2,y      	;we set different sizes for wings, so we must set size for shell as well
PLY				;

LDA $03				;if dead don't animate wings
BNE .NoAnim2			;

LDA $14				;

.NoAnim2
LSR #3				;
AND #$01			;
STA $02				;

LDX #$01			;2 wings tiles

.Loop
INY #4				;next OAM slot

PHX				;load wing value
TXA				;
ASL				;so we have two wings attached from different sides
CLC				;
ADC $02				;
TAX				;
LDA $00				;
CLC				;wings x pos
ADC WingXDisp,x			;
STA $0300|!Base2,y		;

LDA $01				;
CLC				;wings y pos
ADC WingYDisp,x			;
STA $0301|!Base2,y		;

LDA WingTiles,x			;wings tiles
STA $0302|!Base2,y		;

LDA $64				;
ORA WingProps,x			;wings properties
STA $0303|!Base2,y		;

PHY
TYA				;can be 8x8 or 16x16 depending on frame
LSR #2				;
TAY				;
LDA WingSize,x			;
STA $0460|!Base2,y      	;
PLY
PLX

DEX				;next wing
BPL .Loop			;

LDX $15E9|!Base2		;restore sprite slot

LDA #$02			;3 tiles total
LDY #$FF			;custom sizes
JSL $01B7B3|!BankB		;
RTS				;

WallHit:
LDA #$01			;hit sound effect
STA $1DF9|!Base2		;

LDA !15A0,x			;if offscreen, don't trigger bounce sprite
BNE .NoBlockHit			;

LDA !E4,x			;
SEC : SBC $1A			;
CLC : ADC #$14			;
CMP #$1C			;
BCC .NoBlockHit			;

LDA !1588,x			;
AND #$40			;
ASL #2				;
ROL				;
AND #$01			;
STA $1933|!Base2		;

LDY #$00			;
LDA $18A7|!Base2		;
JSL $00F160|!BankB		;

LDA #$05			;
STA !1FE2,x			;

.NoBlockHit
RTS				;