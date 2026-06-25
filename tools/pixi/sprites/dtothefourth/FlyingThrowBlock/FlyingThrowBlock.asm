
!Tile = #$40				; Tile for block graphics
!Palette = 1				; 0-7, block palette
							; to get the normal throwblock colors use the included pal file

!Direction = 0				; 0 = Right, 1 = Left, 2 = Down, 3 = Up

!Wave = 1					; enable wave motion
WaveSpeed:		db $FF,$01	; how fast it moves in the wave motion
!WaveFrequency = 1			; how often wave speed is added
							; 0 = every frame, 7 = every 8 frames, etc
WaveMax:		db $F4,$0C  ; Maximum speed before reversing wave
							; Must be a multiple of WaveSpeed

!Move = 1					; enable directional movement
MoveSpeed:		db $10,$F0  ; Main movement speed

!Turn = 1					; enable turn around, goes back and forth instead of continuing on
TurnSpeed:		db $01,$FF	; how fast it moves back and forth
!TurnFrequency = 3			; how often turn speed is added
							; 0 = every frame, 7 = every 8 frames, etc
!Pause = #$20				; how many frames to pause at each end of turning


if !Direction = 0 || !Direction = 1
	!WaveDir = !AA				; Wave direction !AA for vertical, !B6 for horizontal
	!MoveDir = !B6				; Move direction !AA for vertical, !B6 for horizontal
else
	!WaveDir = !B6				; Wave direction !AA for vertical, !B6 for horizontal
	!MoveDir = !AA				; Move direction !AA for vertical, !B6 for horizontal
endif

print "MAIN ",pc
	PHB
	PHK
	PLB
	JSR Main
	PLB
	RTL

print "INIT ",pc

	RTL

macro localJSL(dest, rtlop, db)
	PHB			;first save our own DB
	PHK			;first form 24bit return address
	PEA.w ?return-1
	PEA.w <rtlop>-1		;second comes 16bit return address
	PEA.w <db><<8|<db>	;change db to desired value
	PLB
	PLB
	JML <dest>
?return:
	PLB			;restore our own DB
endmacro


Main:

	JSR GFX

	%localJSL($019E95, $F75B, $01)		;draw wings   
      
	LDA $9D								;don't move if sprites locked
	BEQ +
	JMP Locked
	+

	if !Wave
	if !WaveFrequency != 0
		LDA $13							;only update wave speed on certain frames
		AND #$!WaveFrequency
		BNE NoWave
	endif

	LDA !1594,x							;use 1594 to determine which phase of wave
	AND #$01
	TAY
	LDA !WaveDir,x						;increase sprite speed in wave direction
	CLC
	ADC WaveSpeed,Y 
	STA !WaveDir,x
	CMP WaveMax,y						;increase wave phase if at max speed
	BNE NoWave
	INC !1594,x

NoWave:

	endif   

	if !Move
		if !Turn = 0
			LDA #$!Direction				;move in a straight line
			AND #$01
			TAY
			LDA MoveSpeed,Y
			STA !MoveDir,x  
		else

			LDA !1540,x
			BNE NoMove

			if !TurnFrequency != 0			;only update speed on certain frames
			LDA $13
			AND #$!TurnFrequency
			BNE NoMove
			endif

			LDA !1534,X						;use 1534 as turn phase
			CLC
			ADC #$!Direction
			AND #$01
			TAY
			LDA !MoveDir,x					;increase speed in movement direction
			CLC
			ADC TurnSpeed,y
			STA !MoveDir,x
			CMP MoveSpeed,y					;increase turn phase if at max speed
			BNE NoMove
			INC !1534,x
			LDA !Pause						;pause movement at end of turn around
			STA $1540,x
			NoMove:

		endif
	endif
          

	JSL $01A7DC
	BCC EndSpawn

	LDA $16
	AND #$40
	BEQ EndSpawn

	LDA $148F|!addr
	BNE EndSpawn

	STZ !14C8,x

	JSL $02A9DE
	BMI EndSpawn

	LDA #$53	
	STA !9E,y

	
	LDA !E4,x
	STA !E4,y
	LDA !14E0,x
	STA !14E0,y
	LDA !D8,x
	STA !D8,y	
	LDA !14D4,x
	STA !14D4,y	
	PHX
	TYX
	JSL $07F7D2
	PLX

	LDA #$0B
	STA !14C8,y
	RTS

	EndSpawn:


   
        
	INC.W !1570,X				;advance wing animation frame

	JSL $01801A	
	JSL $018022					;Update position without gravity
				
	LDA.W $1491|!addr			;Distance to move Mario when riding    
	STA.W !1528,X  

Locked:

	JSL $01B44F		;Make solid
   
	LDA #$00  
	%SubOffScreen()
	RTS

GFX: 

	%GetDrawInfo()



	LDA $00
	STA $0300|!addr,y	; X position
	LDA $01
	STA $0301|!addr,y	; Y position

	LDA !Tile
	STA $0302|!addr,y	; Tile number
	LDA #$!Palette
	ASL
	ORA #$30
	STA $0303|!addr,y	; Properties



	LDA #$00	; Tile to draw - 1
	LDY #$02	; 16x16 sprite
	JSL $01B7B3

	RTS