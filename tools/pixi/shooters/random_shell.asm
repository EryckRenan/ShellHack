;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Random Shell Shooter, by Yoshicookiezeus
;; Converted to PIXI by Blind Devil
;;
;; Description: Randomly generates blue, red, green and yellow Koopa shells.
;;
;; Uses first extra bit: NO
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


			!SOUND_TO_GEN = $09
			!SprPossibilities = $03		;how many sprite possibilities, -1

			SPRITE_TO_GEN:
			db $04,$05,$06,$07		;sprite numbers that'll be generated randomly

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; sprite code JSL
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
print "INIT ",pc 
print "MAIN ",pc                                    
		PHB                     
		PHK                     
		PLB                     
		JSR SPRITE_CODE_START   
		PLB                     
		RTL      

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; main bullet bill shooter code
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

Return:
		RTS                     ; RETURN
		
SPRITE_CODE_START:
		
		LDA #$60 : CLC          ; \ if necessary, restore timer to 60 and ignore Mario next to shooter
		%ShooterMain()          ; | check if time to shoot, return if not. (Y now contains new sprite index)
		BCS Return              ; /

		LDA #!SOUND_TO_GEN      ; \ play sound effect
		STA $1DFC|!Base2        ; /

		PHX
		LDA #!SprPossibilities	;how many sprite possibilities, -1
		JSL RANDOM
		TAX
		LDA SPRITE_TO_GEN,x	; \ set sprite number for new sprite
		PLX
		STA.w !9E,y
		LDA #$0A                ;
		STA !14C8,y             ;
		LDA $179B|!Base2,x      ; \ set x position for new sprite
		STA.w !E4,y             ;  |
		LDA $17A3|!Base2,x      ;  |
		STA.w !14E0,y           ; /
		LDA $178B|!Base2,x      ; \ set y position for new sprite
		SEC                     ;  | (y position of generator - 1)
		SBC #$01                ;  |
		STA.w !D8,y             ;  |
		LDA $1793|!Base2,x      ;  |
		SBC #$00                ;  |
		STA !14D4,y             ; /
		PHX                     ; \ before: X must have index of sprite being generated
		TYX                     ;  | routine clears old sprite values...
		JSL $07F7D2|!BankB      ;  | ...and loads in new values for the 6 main sprite tables
		PLX                     ; / 
		
		;JSR Smoke_spawn
		RTS

;RNG routine
RANDOM:
    PHX : PHP
    SEP #$30
    PHA
    JSL $01ACF9|!BankB
    PLX
    CPX #$FF
    BNE .normal
    LDA $148B|!Base2
    BRA .end

.normal
    INX
    LDA $148B|!Base2

if !SA1
        STZ $2250       ; Set multiplication mode.
        REP #$20        ; Accum (16-bit)
        AND #$00FF      ; Mask out high byte.
        STA $2251       ; Write first multiplicand.
        TXA             ; X -> A and mask out high byte.
        AND #$00FF
        STA $2253       ; Write second multiplicand.
        NOP             ; Wait 2 cycles (SEP takes 3, total of 5).
        SEP #$20        ; Accum (8-bit)
        LDA $2307       ; Read multiplication product.
else
        STA $4202       ; Write first multiplicand.
        STX $4203       ; Write second multiplicand.
        NOP #4          ; Wait 8 cycles.
        LDA $4217       ; Read multiplication product (high byte).
endif

.end
PLP : PLX
RTL