;======================================================
; Para-Spiny v1.2
; By Arinsu
;======================================================
; Description: A spiny that flies in a pattern like the
; red parakoopas.
; Uses first extra bit: YES
; When set, it will fly vertically. Else, it will fly
; horizontally.
;======================================================

; If 0, the horizontally-moving spiny will not move up and down
!HorizontalSpinyMovesUpAndDown = 1

Tilemap:
       db $80,$82,$80,$82
Speeds:              ; cumulative values for X or Y speeds
       db $FF,$01
TargetSpeed:         ; maximum speed before turning
       db $F0,$10
WingsXDisp:
       db $FF,$F8,$08,$0A
WingsYDisp:
       db $02,$FA,$02,$FA
WingsTiles:
       db $5D,$C6,$5D,$C6
WingProps:
       db $76,$76,$36,$36

;=================================
; INIT and MAIN Wrappers
;=================================

print "INIT ",pc
       JSL $01ACF9|!bank
       STA !1570,x
       %SubHorzPos()
       TYA
       STA !157C,x
       RTL

print "MAIN ",pc
       PHB
       PHK
       PLB
       JSR ParaSpiny
       PLB
       RTL

;========================
; Main routine
;========================

ParaSpiny:
       JSR Graphics
       LDA !14C8,x
       EOR #$08
       ORA $9D
       BNE Return
       INC !1570,x
       LDA !1570,x
       LSR #3
       AND #$01
       STA !1602,x
       LDA !7FAB10,x
       AND #$04
       BNE .DoneUpdating
.Horz:
       JSL $018022|!bank
if !HorizontalSpinyMovesUpAndDown
       LDY #$FC
       LDA !1570,x
       AND #$20
       BEQ +
       LDY #$04
+      STY !AA,x
else
       BRA +
endif
.DoneUpdating:
       JSL $01801A|!bank
+
       LDA !1540,x
       BNE .NotChangeYet
       INC !151C,x
       LDA !151C,x
       AND #$03
       BNE .NotChangeYet
.Speed:
       LDA !C2,x
       AND #$01
       TAY
       LDA !B6,x
       CLC
       ADC Speeds,y
       STA !AA,x
       STA !B6,x
       CMP TargetSpeed,y
       BNE .NotChangeYet
       INC !C2,x
       LDA #$30
       STA !1540,x
.NotChangeYet:
       LDY !157C,x
       LDA !B6,x
       CMP Speeds,y
       BNE +
       TYA
       EOR #$01
       STA !157C,x
+      LDA !7FAB10,x
       AND #$04
       EOR #$04
       LSR #2
       ;TAY
       %SubOffScreen()
       JSL $01803A|!bank
Return:
       RTS

;========================
; Graphics routine
;========================

; jesus this is horrible. so i commented it.
Graphics:
       %GetDrawInfo()
       CPY #$FC
       BEQ Return
       LDA !157C,x           ;\
       ASL                   ; | multiply the direction
       ; CLC                 ; | add our frame index to index the tables
       ADC !1602,x           ; |
       TAX                   ;/
       STX $02
       LDA $00               ;\
       ; CLC                 ; | wings x pos
       ADC WingsXDisp,x      ; |
       STA $0300|!Base2,y    ;/
       REP #$21
       LDA $00               ;\  x and y pos
       STA $0300+4|!Base2,y  ;/
       SEP #$20
       LDA $01               ;\
       ; CLC                 ; | wings y pos
       ADC WingsYDisp,x      ; |
       STA $0301|!Base2,y    ;/
       LDA WingsTiles,x      ;\  wings tilemap
       STA $0302|!Base2,y    ;/
       LDA $64               ;\
       ORA WingProps,x       ; | wings properties
       STA $0303|!Base2,y    ;/
       LDA Tilemap,x         ;\  tilemap
       STA $0302+4|!Base2,y  ;/
       LDA Props,x           ;\ get direction
       LDX $15E9|!Base2      ; |
       ORA !15F6,x           ; |
       ORA $64               ; | properties (cfg)
       STA $0303+4|!Base2,y  ;/

       TYA                   ;\
       LSR #2                ; | index into tilesize
       TAY                   ;/
       LDX $02
       LDA WingsSize,x       ;\  variable size, depending on the wing frame
       STA $0460|!Base2,y    ;/
       LDA #$02              ;\  spiny is 16x16
       STA $0460+1|!Base2,y  ;/

       LDX $15E9|!Base2      ;   retrieve index
       LDA #$01              ;   2 tiles
       LDY #$FF              ;   variable size
       %FinishOAMWrite()     ;   finish write
       RTS                   ;   CURSE THIS ROUTINE

WingsSize:
       db $00,$02,$00,$02
Props:
       db $40,$40,$00,$00

