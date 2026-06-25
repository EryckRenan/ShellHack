; Toggle On/Off Switch State When Carrying Blue Shell (Level UberASM)
; By Cracka

; Modified https://bin.smwcentral.net/u/51302/SwimShell.zip
; By Dirty/aka cthulhu 

; empty ram, possible you'll have to modify these depending on what other patches you've used.
!IsHolding = $140B|!addr      ; 00 no 01 yes
!IsWaterLevel = $140C|!addr   ; check if water level

	!CarriedState	= $00		; 00 = On
	!DefaultState	= $01		; 01 = Off

if read1($00FFD5) == $23		; check if the rom is sa-1
	sa1rom
	!9E = $3200
	!1626 = $758E
	!14C8 = $3242
	!Slot = #$14
else
	lorom
	!9E = $9E
	!1626 = $1626
	!14C8 = $14C8
	!Slot = #11
endif

main:

LDA $1407|!addr               ; check if the player is flying
ORA $75                       ; check if the player is swimming
ORA $187A|!addr               ; check if the player is on yoshi
ORA $74                       ; check if the player is climbing
ORA $13D4|!addr               ; check if the game is paused
BNE .abort                    ; abort if one of these checks comes back positive
LDA $148F|!addr               ; is carrying flag
CMP #$01                      ; check if player is carrying something
BEQ .fullhands                ;
BRA .abort
.fullhands
LDA $148F|!addr               ; is carrying flag
ORA $1470|!addr               ; is carrying flag
BNE .cont                     ; for safety check and see if the player is still in fact holding something
BRA .abort                    ;
.cont
PHX                           ; push x
LDX !Slot                     ; loop through sprites on screen (14 for sa-1 compat.)
.Loop
LDA !14C8,X                   ; sprite status
CMP #$0B                      ; check if sprite status is carried, thanks KevinM for pointing out the 0D mistake
BNE .notCarried               ;
LDA !9E,X                     ; sprite number
CMP #$06                      ; check if the sprite being carried is a blue shell
BEQ .isBlueShell              ;
.notCarried
DEX                           ; subtract x
BPL .Loop                     ;
PLX                           ; pull x
BRA .abort                    ; gotta blast
.isBlueShell
PLX                           ; pull x..
BRA .BlueShell                ; branch to blue shell code
.BlueShell
LDA #$01
STA !IsHolding

	LDA $148F|!addr				; player holding object flag
	ORA $1470|!addr				; carrying something flag
	BEQ +						; not carrying, set default state
	LDA #!CarriedState			; set carried on/off switch state
	BRA ++
	+ LDA #!DefaultState		; set default on/off switch state
	++ STA $7E14AF,x

.abort
RTL
