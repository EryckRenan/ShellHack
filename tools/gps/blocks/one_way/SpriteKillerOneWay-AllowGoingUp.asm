;If anything tries to go through the block going up, it will block it,
;otherwise it will let them pass.
;behaves $25

print "Solid for sprites ONLY (block-interactable sprites) when they go down, but allows up"

; Smoke sprite number from puff_of_smoke.asm patch
!smoke_num = $12

db $37
JMP MarioBelow : JMP Return : JMP Return : JMP SpriteV : JMP Return : JMP Return
JMP MarioFireBall : JMP Return : JMP Return : JMP Return : JMP Return


SpriteV:
	LDA !sprite_speed_y,x
	BEQ CarryCheck			
	BMI Return
	BPL KillSprite
    RTL

CarryCheck:
	LDA !14C8,x
	CMP #$0B		            ; kill sprite if not carried
	BNE KillSprite 
	LDA $7D		                ; player y speed
	CMP #$00
	BEQ Return                  ; return
	BMI Return

KillSprite:
    lda.b #!smoke_num		    ; Spawn the smoke sprite
    clc
    phx
    %spawn_sprite()
    plx

    ; Kill the original sprite
    stz !14C8,x

    ; Move the new sprite where the old one was
    bcs Return
    sta $04
    %move_spawn_to_sprite()

    ; If the block is on Layer 2, fix the sprite position
    lda $185E|!addr : beq Return
    phx
    ldx $04
    lda !sprite_x_low,x : sec : sbc $26 : sta !sprite_x_low,x
    lda !sprite_x_high,x : sbc $27 : sta !sprite_x_high,x
    lda !sprite_y_low,x : sec : sbc $28 : sta !sprite_y_low,x
    lda !sprite_y_high,x : sbc $29 : sta !sprite_y_high,x
    plx
	RTL

MarioBelow:
MarioFireBall:
Return:
	RTL