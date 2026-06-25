; by dirty !
; this patch is probably not compatible with these: https://www.smwcentral.net/?p=memorymap&game=smw&u=0&address=008F49&sizeOperation=%3D&sizeValue=&region[]=hijack&type=*&description=
;
;

; sa1 stuff
if read1($00FFD5) == $23		; check if the rom is sa-1
	sa1rom
	!SA1 = 1
	!addr = $6000
	!bank = $000000
	!9E = $3200
	!1626 = $758E
	!14C8 = $3242
	!Slot = #$14
else
	lorom
	!SA1 = 0
	!addr = $0000
	!bank = $800000
	!9E = $9E
	!1626 = $1626
	!14C8 = $14C8
	!Slot = #11
endif


; empty ram, possible you'll have to modify these depending on what other patches you've used.
!IsHolding = $140B|!addr      ; 02 red, 03 blue, 04 yellow
!IsWaterLevel = $140C|!addr   ; only used for blue shell

org $01A018|!bank             ; ReleaseSprCarried
autoclean JSL ReleaseCheck
NOP

org $01A685|!bank             ; Sprite Interactions w/ Carried Sprites
autoclean JSL InteractCheck

org $00EA3F|!bank             ; Determines if water level or not
autoclean JSL LevelCheck
NOP #2

org $00EA42|!bank             ; Determines if water level or not
autoclean JSL SwimStuff
NOP

org $008F49|!bank             ; Status bar, runs every frame
autoclean JSL Main

freedata

InteractCheck:
LDA !IsHolding                ;
CMP #$00                      ; check if player is holding a shell
BEQ .neverHeld                ;
STZ !IsHolding                ; if held, clear
.neverHeld
LDA !9E,X                     ; original code
CMP #$83                      ; original code
RTL

ReleaseCheck:
LDA !IsHolding                ;
CMP #$00                      ; check if player is holding a shell
BEQ .neverHeld                ;
STZ !IsHolding                ; if held, clear
.neverHeld
STZ !1626,X                   ; original code
LDY #$00                      ; original code
RTL

LevelCheck:
LDA $85                       ;
CMP #$01                      ; check if the level is originally a water level
BNE .notwater                 ;
LDA #$01                      ;
STA !IsWaterLevel             ; store it to empty space if it IS an original water level
.notwater
STZ $13F9|!addr               ; original code
STZ $13FA|!addr               ; original code
RTL

Abort:
LDA $0DBE|!addr               ;
INC A                         ; one giant hasta la vista baby
RTL

Main:
LDA $1407|!addr               ; check if the player is flying
ORA $75                       ; check if the player is swimming
ORA $187A|!addr               ; check if the player is on yoshi
ORA $74                       ; check if the player is climbing
ORA $13D4|!addr               ; check if the game is paused
BNE Abort                     ; abort if one of these checks comes back positive
LDA $148F|!addr               ; is carrying flag
CMP #$01                      ; check if player is carrying something
BEQ HandsFull                 ;
LDA $0DBE|!addr               ; original code
INC A                         ; original code
RTL

; huge thanks to KevinM for helping with the slot, and with DA-DF not being real sprites
HandsFull:
LDA $148F|!addr               ; is carrying flag
ORA $1470|!addr               ; is carrying flag
BNE .cont                     ; for safety check and see if the player is still in fact holding something
BRA .exit                     ;
.cont
PHX                           ; push x
LDX !Slot                       ; loop through sprites on screen (14 for sa-1 compat.)
.Loop
LDA !14C8,X                   ; sprite status
CMP #$0B                      ; check if sprite status is carried, thanks KevinM for pointing out the 0D mistake
BNE .notCarried               ;
LDA !9E,X                     ; sprite number
CMP #$06                      ; check if the sprite being carried is a blue shell
BEQ .isBlueShell              ;
LDA !9E,X                     ; sprite number
CMP #$07                      ; check if the sprite being carried is a yellow shell
BEQ .isYellowShell            ;
LDA !9E,X                     ; sprite number
CMP #$05                      ; check if the sprite being carried is a red shell
BEQ .isRedShell               ;
.notCarried
DEX                           ; subtract x
BPL .Loop                     ;
PLX                           ; pull x
BRA .exit                     ; gotta blast
.isRedShell
LDA !IsHolding                ;
CMP #$02                      ; kind of unique compared to the other shells, this really only calls when its held and the down button is pressed
BNE .notYet                   ;
LDA #$06                      ; coin sprite state
STA !14C8,X                   ; turn sprite (red shell) to coin
.notYet
PLX                           ; pull x
BRA RedShell                  ; branch to red shell code
.isBlueShell
PLX                           ; pull x..
BRA BlueShell                 ; branch to blue shell code
.isYellowShell
PLX                           ; .. you get it by now
BRA YellowShell               ; branch to yellow shell code
.exit
LDA $0DBE|!addr               ; original code
INC A                         ; original code
RTL

RedShell:                     ; ran out of ideas for the red shell, went basic
LDA $15                       ;
AND #$04                      ; check if down is pressed
BEQ .notDown                  ;
LDA #$03                      ; fire flower
STA $19                       ; powerup player
LDA #$02                      ;
STA !IsHolding                ; finally set this so the shell turns to coin
.notDown
LDA $0DBE|!addr               ; original code
INC A                         ; original code
RTL

YellowShell:
JSL $02858F|!bank             ; sparkle effect
LDA #$04                      ;
STA !IsHolding                ; yellow shell is held
LDA $77                       ; check if the player is grounded
AND #$04                      ;
BNE .exit                     ; abort if the player is grounded
LDA !IsHolding                ;
CMP #$04                      ; check if yellow shell still in hand
BNE .exit                     ;
LDA $96 : PHA                 ; store mario's y pos, push a
SEC : SBC #$10                ; set carry, subtract 10 from y (so mario isn't buggy)
STA $96                       ; store to marios y
JSL $0286BF|!bank             ; yellow yoshi stomp
PLA : STA $96                 ; pull a and store into y position (move yoshi stomp to old mario y)
.exit
LDA $0DBE|!addr               ; original code
INC A                         ; original code
RTL

BlueShell:
LDA #$03                      ;
STA !IsHolding                ; blue shell is held
LDA $0DBE|!addr               ; original code
INC A                         ; original code
RTL

SwimStuff:
LDA !IsHolding                ;
CMP #$03                      ; check if blue shell is still being held
BNE .exit                     ;
;LDA #$01                      ;
;STA $85                       ; if still held, player is swimming (and change level to water level)
;STA $75                       ;

; works as intended, slight jank if the shell is thrown upwards before shell jumping, causing player to kick with downward speed
;LDA #$00						; Makes player jump while holding if $00
;STA $7E140D						; Makes player spin while holding if $01

LDA $148F|!addr               ; is carrying flag
ORA $1470|!addr               ; is carrying flag
BNE +
LDA #$00
BRA ++
+ LDA #$01
++ STA $7E14AF

BRA .isWater                  ; end
.exit
LDA !IsWaterLevel             ;
CMP #$01                      ; the player is not holding the shell, check if the level was originally a water level
BEQ .isWater                  ;
STZ $85                       ; if not originally water, set to 0
.isWater
STZ $13FA|!addr               ; original code
LDA $85                       ; original code
RTL
