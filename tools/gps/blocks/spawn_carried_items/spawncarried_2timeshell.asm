!sfx             = $10
!sfx_bank        = $1DF9
!shelltype       = $00          ; MultiBounceShell sprite number (green)
!bounce_count    = $02          ; Extension byte 1: number of bounces (01 = one bounce)

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
    LDA #!shelltype             ; Sprite number to spawn
    SEC                         ; SEC = Custom sprite
    %spawn_sprite()
    BCS Return
    %move_spawn_into_block()    ; Move sprite position to block
      ; Set sprite status to carried
    LDA #$0B
    STA !14C8,x                 ; $0B = carried state

    TYX         ; Need X for STA <long>,x
    LDA.b #ExtraBytes   ;\ Table low byte in !extra_byte_1 
    STA !extra_byte_1,x ;/
    LDX $15E9           ; Restore X

    BRA Return

    ExtraBytes:
        db $02
    
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

print "This block spawns a one-time usable shell that is automatically carried and destroys itself afterwards."
