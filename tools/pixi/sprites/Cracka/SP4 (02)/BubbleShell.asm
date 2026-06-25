;=======================================================================================================================
; Bubble Shell
; Modified by Cracka
;
; Based on Bubble With Sprite Inside by Nowieso
; A disassembly of sprite 9D, the flying bubble with a sprite inside.
;
;-----------------------------------------------------------------------------------------------------------------------
;
; First Extra Bit:
;	If the extra bit is clear, the sprite inside the bubble depends on the X-Position
;	If the extra bit is set, the sprite inside the bubble depends on the value in Extra Property Byte 1 (set in the cfg Editor)
;	Useful if you want to avoid being dependent on the X-Position.
;
;-----------------------------------------------------------------------------------------------------------------------
;
; Extra Byte 1:
;	$00 = Green Shell
;	$01 = Red Shell
;	$02 = Blue Shell
;	$03 = Yellow Shell
;
;-----------------------------------------------------------------------------------------------------------------------
;
; Extra Byte 2:
;	$00 = Spawn Right
;	$01 = Spawn Left
;	$02 = Spawn Towards Player
;	$03 = Spawn Away From Player
;
;=======================================================================================================================

!lengthNoInteract	=	$0F			;how many frames to disable interaction with Mario
!sfx				=	$19			;sfx to play
!sfx_bank			=	$1DFC		;sfx bank

BubbleSprXSpeed:		db $08,$F8	;X speed

BubbleSprYAccel:        db $01,$FF	;Y acceleration

BubbleSprYMax:          db $0C,$F4	;Max Y speed
;-----------------------------------------------------------------------------------------------------------------------
;Setup sprite main and init
;-----------------------------------------------------------------------------------------------------------------------
print " INIT ",pc
InitBubbleSpr:						;|
;	LDA !7FAB10,x					;|\ Pick the sprite inside the bubble based on its X position.
;	AND #$04						;|| Or the Extra Property Byte 1 if the extra bit is set
;	BEQ Vanilla						;||
;	LDA !7FAB28,x					;||
	LDA !extra_byte_1,x				;||\ Updated to allow for singular json necessary
	CMP #$03						;|||\
	BNE +							;|||| Vanilla value C2 uses 03 for mushroom, which causes mario to powerup if yoshi eats while in bubble form
	LDA #$04						;|||/
+	BRA Continue					;||/
;Vanilla:							;||
;	LDA !E4,x						;|\ 
;	LSR								;||
;	LSR								;||
;	LSR								;|| Get the sprite number for the block to spawn based on its X position.
;	LSR								;||
;	AND #$03						;||
Continue:							;||
	STA !C2,x     			  		;|/
	DEC !1534,x						;|
	%SubHorzPos()					;|\
	LDA !extra_byte_2,x 			;|| Grab the spawn direction from extra byte 2
	BEQ + 							;||
	CMP #$01						;||
	BEQ +							;||
	CMP #$03						;|| 03 = away 02 or else = towards. CMP 03 BEQ
	BEQ ++							;||
	TYA								;||
	BRA + 							;|| Make default if value > 2, spawn towards player
++	TYA								;|| Make the sprite face Mario.
	EOR #$01						;||
+	STA !157C,x						;|/
RTL									;|
print " MAIN ",pc
BubbleSpriteMain:					;|
	PHB								;|
	PHK								;|
	PLB								;|
	JSR SpriteMain					;|
	PLB								;|
RTL									;|
;-----------------------------------------------------------------------------------------------------------------------
;Actual main code
;-----------------------------------------------------------------------------------------------------------------------
SpriteMain:
	LDA !15EA,x						;|\ 
	CLC								;||
	ADC #$14						;|| Set up a 16x16 tile for the sprite inside the bubble.
	STA !15EA,x						;||
	JSL $0190B2|!bank    			;|/	
	PHX                       		;|
	LDA !C2,x     					;|\ This can be manipulated if sprite set to powerup, when yoshi eats in bubble
	LDY !15EA,x   					;|| 
	TAX                       		;|| Set actual YXPPCCCT for the tile.
	LDA BubbleSprGfxProp1,x 		;||
	ORA $64                   		;||
	STA $0303|!addr,y          		;|/
	LDA $14     					;|\ 
	ASL                       		;||
	ASL                       		;||
	ASL                       		;||
	LDA BubbleSprTiles1,x   		;|| Set actual tile number for the tile, animating it on an 4-frame cycle.
	BCC FirstFrame           		;||
	LDA BubbleSprTiles2,x   		;||
FirstFrame:							;||
    STA $0302|!addr,y          		;|/
	PLX                       		;|
	LDA !1534,x             		;|\ 
	CMP #$60                		;||
	BCS DrawGFX	           			;|| Draw the bubble.
	AND #$02                		;|| If the bubble's timer is close to running out, make it flash every 2 frames.
	BEQ SkipGFXRoutine         		;||
DrawGFX:							;||
    JSR BubbleSpriteGraphics		;|/
SkipGFXRoutine:						;|
    LDA !14C8,x             		;|\ 
	CMP #$02                		;||
	BNE SpriteAlive           		;|| If the bubble hasn't been killed by something, reset it to its normal state
	LDA #$08                		;|| Not sure what the point of this is, but it's the reason you get a million points from throwing shells at bubbles.
	STA !14C8,x             		;||
	BRA DropLifeTimer          		;|/
SpriteAlive:						;|
    LDA $9D							;|\ Return if game frozen.   
	BNE ReturnNotPopped          	;|/
	LDA $13      					;|\ 
	AND #$01                		;||
	BNE DontDecTimer           		;||
	DEC !1534,x             		;|| Decrease lifespan timer every 2 frames.
	LDA !1534,x             		;|| If about to run out, play the pop sound.
	CMP #$04                		;||
	BNE DontDecTimer           		;||
	LDA #!sfx               		;|| SFX for popping the bubble.
	STA !sfx_bank|!addr           	;|/ 
DontDecTimer:						;|
    LDA !1534,x             		;|\ 
	DEC A                     		;|| Branch if time to erase the bubble and spawn the sprite inside.
	BEQ BubblePopped      			;|/
	CMP #$07                		;|\ Return if the bubble is already popping.
	BCC ReturnNotPopped				;|/
	LDA #$00						;|
	%SubOffScreen()  				;|  Process offscreen from -$40 to +$30.
	JSL $018022|!bank				;|\ Update X/Y position.
	JSL $01801A|!bank				;|/  
	JSL $019138|!bank      			;|  Process interaction with blocks.
	LDY !157C,x     				;|\ 
	LDA BubbleSprXSpeed,y 			;|| Store X speed.
	STA !B6,x    					;|/
	LDA $13      					;|\ 
	AND #$01                		;||
	BNE CheckSprBlocked        		;||
	LDA !151C,x             		;||
	AND #$01                		;||
	TAY                       		;|| Update Y speed every other frame.
	LDA !AA,x    					;|| If at the maximum Y speed in the current direction, invert the direction of acceleration.
	CLC                       		;||
	ADC BubbleSprYAccel,y 			;||
	STA !AA,x    					;||
	CMP BubbleSprYMax,y 			;||
	BNE CheckSprBlocked           	;||
	INC !151C,x             		;|/
CheckSprBlocked:					;|
    LDA !1588,x  					;|\ Branch if hitting a block.						
    BNE DropLifeTimer           	;|/
	JSL $018032|!bank				;|  Process sprite interaction.      
	LDA #!lengthNoInteract     		;|\ 
    STA !1564,x  					;|/
    DEC !1564,x  					;|/
	JSL $01A7DC|!bank				;|\ Return if not being touching by Mario.    
	BCC Return          			;|/
;	STZ $7D       					;|\ Clear Mario's speed.
;	STZ $7B       					;|/
DropLifeTimer:						;|  Bubble has been hit.
    LDA !1534,x             		;|\ 
	CMP #$07                		;||
	BCC ReturnNotPopped          	;|| Drop its lifespan timer down so it pops.
	LDA #$01                		;||
	STA !1534,x             		;|/
ReturnNotPopped:					;|
RTS                      			;|
BubblePopped:						;|  Erasing the bubble and replacing it with the sprite inside.
    LDY !C2,x     					;|\
	LDA BubbleSprites,y     		;|| Get the sprite to spawn.
	STA !9E,x       				;|/
	PHA                       		;|
	JSL $07F7D2|!bank				;|  Initialize the new sprite.    
	PLY                       		;|
    LDA #$09
    STA !14C8,x
Return:								;|
RTS                       			;|
;-----------------------------------------------------------------------------------------------------------------------
;Graphics Routine
;-----------------------------------------------------------------------------------------------------------------------
BubbleSprTiles1:					;| First animation frame of the sprite inside the bubble
	db $8C,$8C,$8C,$8C,$8C

BubbleSprTiles2:					;| Second animation frame of the sprite inside the bubble
	db $8C,$8C,$8C,$8C,$8C

BubbleSprGfxProp1:					;| Property Byte of Sprite inside the bubble
	db $0A,$08,$06,$04,$04

BubbleSprites:						;| Sprite inside the bubble
	db $04,$05,$06,$07,$07

BubbleTileDispX:					;| X offsets for each tile in the bubble.
	db $F8,$08,$F8,$08,$FF
	db $F9,$07,$F9,$07,$00
	db $FA,$06,$FA,$06,$00

BubbleTileDispY:					;| Y offsets for each tile in the bubble.
	db $F6,$F6,$02,$02,$FC
	db $F5,$F5,$03,$03,$FC
	db $F4,$F4,$04,$04,$FB

BubbleTiles:						;| Tilemap of the bubble
	db $A0,$A0,$A0,$A0,$99

BubbleGfxProp:						;| Property Byte for each tile of the bubble
	db $07,$47,$87,$C7,$03

BubbleSize:							;| Tile size for each tile of the bubble
	db $02,$02,$02,$02,$00

DATA_02D9D2:						;| Indices to the X/Y offset tables for each frame of animation.
	db $00,$05,$0A,$05

BubbleSpriteGraphics:
	%GetDrawInfo()        			;|  Bubble GFX routine.
	LDA $14    						;|\ 
	LSR                       		;||
	LSR                       		;||
	LSR                       		;|| $02 = index to the offset tables for each frame of animation.
	AND #$03                		;||
	TAY                       		;||
	LDA DATA_02D9D2,y       		;||
	STA $02                   		;|/
	LDA !15EA,x   					;|
	SEC                       		;|
	SBC #$14                		;|
	STA !15EA,x   					;|
	TAY                       		;|
	PHX                       		;|
	LDA !1534,x             		;|\ $03 = Timer for the popping animation.
	STA $03                   		;|/
	LDX #$04          				;|  Number of tiles to use for the bubble (excluding the sprite inside).
GFXLoop:        					;|
	PHX             				;|
	TXA                       		;|
	CLC                       		;|
	ADC $02                   		;|
	TAX                       		;|
	LDA $00                   		;|\ 
	CLC                       		;|| Store X position to OAM.
	ADC BubbleTileDispX,x   		;||
	STA $0300|!addr,y   	      	;|/
	LDA $01                   		;|\ 
	CLC                       		;|| Store Y position to OAM.
	ADC BubbleTileDispY,x   		;||
	STA $0301|!addr,y         		;|/
	PLX                       		;|
	LDA BubbleTiles,x       		;|\ Store tile number to OAM.
	STA $0302|!addr,y         	 	;|/
	LDA BubbleGfxProp,x     		;|\ 
	ORA $64                   		;|| Store YXPPCCCT to OAM.
	STA $0303|!addr,y   	       	;|/
	LDA $03                   		;|\ 
	CMP #$06                		;|| If popping the bubble, change the tile number and YXPPCCCT.
	BCS FinishOAM           		;||
	CMP #$03                		;||
	LDA #$02                		;||
	ORA $64                   		;|| Change YXPPCCCT.
	STA $0303|!addr,y  	        	;||
	LDA #$64                		;|| Tile A to use for the bubble's pop animation.
	BCS BubblePopAn           		;||
	LDA #$66                		;|| Tile B to use for the bubble's pop animation.
BubblePopAn:        				;||
	STA $0302|!addr,y   	       	;|/
FinishOAM:							;|
    PHY                       		;|
	TYA                       		;|\ 
	LSR                       		;||
	LSR                       		;|| Set size for the tile
	TAY                       		;||
	LDA BubbleSize,x        		;||
	STA $0460|!addr,y      			;|/
	PLY                       		;|
	INY                       		;|\ 
	INY                       		;||
    INY                       		;|| Loop for all of the tiles.
	INY                       		;||
	DEX                       		;||
	BPL GFXLoop          			;|/
	PLX                       		;|
	LDY #$FF                		;|\ 
	LDA #$04						;|| Upload 5 manually-sized tiles.
	JSL $01B7B3|!bank				;|/
RTS        							;|
