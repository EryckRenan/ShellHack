; Spawn Carried Multi-Bounce Shell With 7 Bounces
; Modified by Cracka & Saphros
;
; Special Thanks To TheBiob
;
; Based on Carryable Sprite Spawner Blocks Pack
; By Nowieso

!sfx             = $10
!sfx_bank        = $1DF9
!sprite_number   = $00          ; Multi-Bounce Shell sprite number
!bounce_count    = $07          ; Number of bounces (01-09 = 1-9 bounces, 0A = infinite bounces)

db $37

JMP Mario : JMP Mario : JMP Mario : JMP Return
JMP Return : JMP Return : JMP Return : JMP Mario
JMP Mario : JMP Mario : JMP Return : JMP Return

Mario:
    LDA $1470|!addr             ; Do not run the code if player is carrying something
    ORA $148F|!addr             ; Do not run the code if player is carrying something
    ORA $187A|!addr             ; Do not run the code if player is riding Yoshi
    ORA $74                     ; Do not run the code if player is climbing
    BNE Return

checkInput:
    LDA $15
    BIT #$40
    BEQ Return

spawnSprite:
    LDA #!sprite_number         ; Sprite number to spawn
    SEC                         ; Use SEC for custom sprite, & CLC for vanilla
    %spawn_sprite()
    BCS Return
    %move_spawn_into_block()    ; Move sprite position to block

; Set sprite status to carried
    LDA #$0B
    STA !14C8,x                 ; $0B = carried state

; Set # of bounces
    LDA #!bounce_count
    DEC
    STA !1504,x                 ; Multi-Bounce Shell uses $7E1504 to store bounce count value

; Initialize !1510 to prevent premature destruction
    LDA #$01
    STA !1510,x                 ; Internal state counter of the shell

destroyBlock:
    %erase_block()
    %glitter()
    LDA #!sfx
    STA !sfx_bank|!addr

Return:
    RTL

print "This block spawns a 7 bounce shell that is automatically carried and destroys itself afterwards."
