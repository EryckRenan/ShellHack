;====================
;     DEFINES       
;====================

!Egg = 0		; If set, Mario can summon a Yoshi egg in the brief moment it's in the carryable state after spawning.*
!Yoshi = 0		; If set, Mario can summon sprites while riding Yoshi.*
!Spin = 0		; If set, Mario can summon sprites while spinjumping.
!Climb = 0		; If set, Mario can summon sprites while climbing.*
!Slide = 0		; If set, Mario can summon sprites while sliding.
!Disco = 1		; If set, Mario can summon disco shells.
!SFX = $06		; Sound effect to play when summoning. Default is "Mario fireball".
!Bank = $1DFC		; SFX bank.
!InputAddr = $15		; Address to check for button hold. $15 = byetUDLR. $17 = axlr----
!Input = $40		; Button to hold before tapping L/R. Default is Y or X.

; *Jank may ensue.

;====================

main:
LDA $148F|!addr		; If Mario is already holding something,
ORA $1470|!addr
ORA $9D		; the lock animation/sprites flag is set,
ORA $13D4|!addr		; or the pause flag is set,
BNE Return		; Return.
LDA !InputAddr		; If the player isn't holding...
AND #!Input		; The Y or X button,
BEQ Return		; Return.
LDA $18		; If the player hasn't just pressed...
AND #$30		; L or R,
BEQ Return		; Return.

if !Yoshi == 0
LDA $187A|!addr		; If Mario is riding Yoshi,
BNE Return		; Return.
endif
if !Spin == 0
LDA $140D|!addr		; If Mario is spinjumping,
BNE Return		; Return.
endif
if !Climb == 0
LDA $74		; If Mario is climbing,
BNE Return		; Return.
endif
if !Slide == 0
LDA $13ED|!addr		; If Mario is sliding,
BNE Return		; Return.
endif
BRA +
Return:
RTL
+

LDA #$FF		; A sprite's distance only gets stored if it's less than the current value in $00. This ensures the first sprite checked always is.
STA $00		;
STA $01		;
TAY		; Make Y #$FF to check if no sprite was found later on.

LDX #!sprite_slots-1		; Set up sprite loop.
.loop
LDA !15D0,x		; If sprite is on Yoshi's tongue,
BNE ++		; Go to next slot.
LDA !9E,x		; Checks for a few edge-case sprites.
if !Egg == 0
CMP #$2C		; If sprite is a Yoshi egg,
BEQ ++		; Go to next slot.
endif
CMP #$2F		; If sprite is a springboard,
BNE +		; Different status check.
LDA !14C8,x
CMP #$08
BCC ++
LDA !1540,x		; If springboard's stun timer is set (springboard pressed),
BNE ++		; Go to next slot. Forcing a springboard to be carried when it's stun timer is set makes it spawn a Wiggler when the timer hits 0.
BRA +++
+
if !Disco == 0
CMP #$04		; If sprite...
BCC +
CMP #$08		; is not a Koopa (shell),
BCS +		; Skip.
LDA !187B,x		; If disco flag is set,
BNE ++		; Go to next slot.
+
endif

LDA !14C8,x		; Sprite status.
CMP #$0B		; Go to next slot if...
BCS ++		; Sprite isn't kicked,
CMP #$09		;
BCC ++		; Or carryable.
+++
LDA !14E0,x		; Load high byte of sprite's X position.
XBA		; Switcharoo
LDA !E4,x		; Load low byte of sprite's X position.
REP #$20		; 16-bit mode.
SEC		;
SBC $D1		; Subtract Mario's 16-bit X position.
BCS +		; We only care about distance,
EOR #$FFFF		; Not direction relative to Mario,
INC A		; So this ensures the value is an absolute distance.
+
CMP $00		; If sprite's distance is greater than or equal to the sprite currently checked to be closest,
BCS +		; Skip.
STA $00		; Store sprite's distance as the closest checked so far.
TXY		; Store sprite's slot index in Y to retrieve later.
+
SEP #$20		; 8-bit mode.
++
DEX		; Decrement X.
BPL .loop		; Return to start of loop until all sprite slots are checked.

CPY #$FF		; If no sprite was found, 
BEQ NoSprite		; Return.
TYX		; Retrieve slot of sprite closest to Mario.
LDA #$0B		; Force sprite...
STA !14C8,x		; Into carried state.
LDA #!SFX		; SFX.
STA !Bank|!addr		; Bank.
JSR Effects		; I could've just put the code here but it pushes the branches at the start of this code out of bounds.
NoSprite:
RTL

Effects:
LDY #$03		;
-		;
LDA $17C0|!addr,y		;
BEQ +		;
DEY		;
BPL -		;
RTS		;
+		;
LDA #$02		;
STA $17C0|!addr,y		;
LDA #$08		;
STA $17CC|!addr,y		;
LDA !D8,x		;
STA $17C4|!addr,y		;
LDA !E4,x		;
STA $17C8|!addr,y		; Spawn contact spark at sprite's position.

LDY #$03		;
-		;
LDA $17C0|!addr,y		;
BEQ +		;
DEY		;
BPL -		;
RTS		;
+		;
LDA #$01		;
STA $17C0|!addr,y		;
LDA #$1B		;
STA $17CC|!addr,y		;
LDA $D3		;
CLC		;
ADC #$10		;
STA $17C4|!addr,y		;
LDA $D1		;
STA $17C8|!addr,y		; Spawn smoke at Mario's position.
RTS