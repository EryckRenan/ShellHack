;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; Configurable meters by dtothefourth
;
; Draws a value or bar on the screen with many configuration
; options.
;
; Requires an included ASAR patch which times the drawing routine.
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

!value = $149F		 ; Address of the value you want to display
!indexed = 0		 ; 1 = address is X indexed like a sprite table, set the index as below
!index = !7FB|$6FF   ; FreeRAM to choose slot when in indexed mode
					 ; For example in a sprite you could just copy the !index define and then TXA : STA !index in sprite code to make it the indexed sprite
!indexinit = #$FF    ; Default index, use FF to make it not tied to a slot
!indexsprite = #$FF  ; If not FF, will search for a sprite matching this number and use that index ($9E)

!mode = 0; 0 = text only, 1 = horizontal meter, 2 = vertical meter, 3 = horiz+text, 4 = vert+text

!abs = 0			 ; 1 = treat negative values as positive (absolute value)
!unsigned = 0		 ; 1 = treat as unsigned (0-255 / 0-65535 instead of -128-127 / -32768-32767) Don't use with abs
!16bit = 0			 ; Whether the value being displayed is 8-bit or 16-bit

;Minimum and maximum values, used to determine how full to draw bars based on the value
if !16bit
	!min = #$0000
	!max = #$6000
else
	!min = #$00
	!max = #$30
endif

!TextX = #$10		; X Position of text value, in pixels
!TextY = #$28		; Y Position of text value, in pixels
!TextTile = #$C0    ; Starting tile for '0', expects 1-9 and '-' to follow
!TextProp = #$33	; Properties to use for text tiles
!TextLeft = 0		; If 1, text will be aligned to the left instead of growing digits leftwards

!BarSize = #$06		; How many tiles long the bar is (8x8)
!BarTile = #$A0		; Base tile for full bar, expects tiles for partial bars to follow
!BarWide    = 1		; Makes a bar two tiles wide/tall
!BarWideDbl = 0		; If 1, the bar tile is flipped and draw twice to fill the double bar, otherwise it is just centered in the wide bar
!BarInvert  = 1		; If 1, the empty/filled graphic will be inverted relative to the value (a 0-3 bar will be full at 0 and empty at 3)

!BarX = #$08		; X Position of bar, in pixels
!BarY = #$30		; Y Position of bar, in pixels
!BarProp = #$35		; Properties to use for bar tiles

!BarOverlay = 1		; If 1, draws a static overlay graphic for the bar to fill
!BarOverL = #$B0	; The left or top end of the overlay graphic, must be two wide/tall for a wide bar
!BarOverM = #$B2	; The middle of the overlay graphic which is repeated to fill length of bar, must be two wide/tall for a wide bar
!BarOverR = #$B4	; The right or bottom end of the overlay graphic, must be two wide/tall for a wide bar
!BarOverProp = #$33 ; Properties to use for overlay tiles

!BarBG     = 1		; If 1, will still draw tiles to fill empty space in an unfilled bar
!BarBGTile = #$A1	; Tile to use for empty tiles

if !sa1
  !7FB = $408000
else
  !7FB = $7FB000
endif

!Queue = !7FB|$700 ;32 bytes of FreeRAM, must match MeterRoutine.asm


macro nexttile()
	?loop:
	LDA $0201|!Base2,y
	CMP #$F0
	BEQ ?end
	INY #$4
	CPY #$00
	BNE ?loop
	RTS
	?end:
endmacro

macro div(b)
		REP #$20
        LDY <b>
		if !16bit == 0
		AND #$00FF
		if !unsigned = 0
		BIT #$0080
		BEQ ?noneg
		ORA #$FF00
		?noneg:
		endif
		endif
        STA $4204
        STY $4206
        NOP
        NOP
        NOP
        NOP
        NOP
        NOP
        NOP
        NOP
endmacro

if read1($00FFD5) == $23		; check if the rom is sa-1
	!Base2 = $6000
	!addr = $6000
else
	!Base2 = $0000
	!addr = $0000
endif

init:
	LDA #$00
	STA !Queue
	STA !Queue+4
	STA !Queue+8
	STA !Queue+12
	STA !Queue+16
	STA !Queue+20
	STA !Queue+24
	STA !Queue+28

	if !indexed
	LDA !indexinit
	STA !index
	endif

	RTL



main:
	LDA $13D4|!addr
	BEQ +

	LDA #$00
	STA !Queue
	STA !Queue+4
	STA !Queue+8
	STA !Queue+12
	STA !Queue+16
	STA !Queue+20
	STA !Queue+24
	STA !Queue+28

	RTL
	+


	LDX #$00
	-
	LDA !Queue,x
	CMP #$AB
	BEQ Next

	LDA #$AB
	STA !Queue,x

	
	REP #$20
	LDA #meter
	STA !Queue+1,x
	SEP #$20

	LDA #meter>>16
	STA !Queue+3,x
	RTL

Next:
	INX #4
	CPX #$20
	BNE -

	RTL

meter:

	if !mode == 0 || !mode > 2
	JSR Text
	endif

	if !16bit
	REP #$20
	endif


	if !indexed

	LDA !index
	BPL ++++++

	LDA !indexsprite
	CMP #$FF
	BEQ ++++++++

	LDX #!sprite_slots-1
	---
	LDA !14C8,X
	BEQ ++++++++++

	LDA !9E,X
	CMP !indexsprite
	BNE ++++++++++
	
	TXA
	STA !index
	
	BRA ++++++

	++++++++++
	DEX
	BPL ---

	++++++++

	if !16bit
	LDA #$0000
	else
	LDA #$00
	endif
	BRA ++++++++
	++++++
	PHX
	TAX
	LDA !value,x
	PLX
	++++++++

	else
	LDA !value
	endif
	
	
	if !abs
	BPL +
	if !16bit
	EOR #$FFFF
	else
	EOR #$FF
	endif
	INC
	+
	endif

	CMP !min
	BCS +
	LDA !min
	+

	CMP !max
	BCC +
	LDA !max
	+

	SEC
	SBC !min
	STA $00

	if !BarInvert
	LDA !max
	SEC
	SBC !min
	SEC
	SBC $00
	STA $00
	endif

	if !16bit
	SEP #$20
	endif

	if !mode == 1 || !mode == 3
	JSR Horizontal
	endif
	if !mode == 2 || !mode == 4
	JSR Vertical
	endif
	RTL

Text:
	LDY #$00
	STZ $00

	LDA !TextX
	if !TextLeft == 0
	SEC
	SBC #$10
	endif
	STA $01

	if !16bit == 1

	if !TextLeft == 0
	LDA $01
	SEC
	SBC #$10
	STA $01
	endif

	REP #$20

	if !indexed

	LDA !index
	BPL ++++++

	if !16bit
	LDA #$0000
	else
	LDA #$00
	endif
	BRA ++++++++
	++++++
	PHX
	TAX
	LDA !value,x
	PLX
	++++++++

	else
	LDA !value
	endif
	
	if !unsigned == 0
	BPL +
	EOR #$FFFF
	INC
	+	
	endif

	STA $02

	STZ $04

	-
	CMP #$2710
	BCC +

	INC $04
	SEC
	SBC #$2710
	STA $02
	BRA -

	+
	
	SEP #$20
	LDA $04
	BEQ +

	if !abs == 0 && !unsigned == 0
	LDA $00
	BNE +++++
	JSR NegSign
	+++++
	endif


	INC $00

	%nexttile()
	
	LDA $01
	STA $0200|!Base2,y
	LDA !TextY
	STA $0201|!Base2,y
	LDA !TextTile
	CLC
	ADC $04
	STA $0202|!Base2,y
	LDA !TextProp
	STA $0203|!Base2,y

	PHY : TYA : LSR #2 : TAY
	LDA #$00 : STA $0420|!Base2,y
	PLY

	if !TextLeft == 0
	+
	endif

	LDA $01
	CLC
	ADC #$08
	STA $01

	if !TextLeft == 1
	+
	endif


	REP #$20
	STZ $04
	LDA $02
	-
	CMP #$03E8
	BCC +

	INC $04
	SEC
	SBC #$03E8
	STA $02
	BRA -

	+
	
	SEP #$20

	LDA $00
	BNE ++

	LDA $04
	BEQ +

	if !abs == 0 && !unsigned == 0
	JSR NegSign
	endif

	INC $00
	++

	%nexttile()
	
	LDA $01
	STA $0200|!Base2,y
	LDA !TextY
	STA $0201|!Base2,y
	LDA !TextTile
	CLC
	ADC $04
	STA $0202|!Base2,y
	LDA !TextProp
	STA $0203|!Base2,y

	PHY : TYA : LSR #2 : TAY
	LDA #$00 : STA $0420|!Base2,y
	PLY

	if !TextLeft == 0
	+
	endif


	LDA $01
	CLC
	ADC #$08
	STA $01

	if !TextLeft == 1
	+
	endif


	else

	if !indexed

	LDA !index
	BPL ++++++

	if !16bit
	LDA #$0000
	else
	LDA #$00
	endif
	BRA ++++++++
	++++++
	PHX
	TAX
	LDA !value,x
	PLX
	++++++++

	else
	LDA !value
	endif	

	if !unsigned == 0
	BPL +
	EOR #$FF
	INC
	+	
	endif

	STA $02

	endif


	if !16bit

	REP #$20
	STZ $04
	LDA $02
	-
	CMP #$0064
	BCC +

	INC $04
	SEC
	SBC #$0064
	STA $02
	BRA -

	+
	SEP #$20
	else

	STZ $04
	LDA $02
	-
	CMP #$64
	BCC +

	INC $04
	SEC
	SBC #$64
	STA $02
	BRA -

	+

	endif

	LDA $00
	BNE ++

	LDA $04
	BEQ +

	if !abs == 0 && !unsigned == 0
	JSR NegSign
	endif

	INC $00
	++

	%nexttile()
	
	LDA $01
	STA $0200|!Base2,y
	LDA !TextY
	STA $0201|!Base2,y
	LDA !TextTile
	CLC
	ADC $04
	STA $0202|!Base2,y
	LDA !TextProp
	STA $0203|!Base2,y

	PHY : TYA : LSR #2 : TAY
	LDA #$00 : STA $0420|!Base2,y
	PLY

	if !TextLeft == 0
	+
	endif


	LDA $01
	CLC
	ADC #$08
	STA $01

	if !TextLeft == 1
	+
	endif


	STZ $04
	LDA $02
	-
	CMP #$0A
	BCC +

	INC $04
	SEC
	SBC #$0A
	STA $02
	BRA -

	+

	LDA $00
	BNE ++

	LDA $04
	BEQ +

	if !abs == 0 && !unsigned == 0
	JSR NegSign
	endif

	INC $00
	++

	%nexttile()
	
	LDA $01
	STA $0200|!Base2,y
	LDA !TextY
	STA $0201|!Base2,y
	LDA !TextTile
	CLC
	ADC $04
	STA $0202|!Base2,y
	LDA !TextProp
	STA $0203|!Base2,y

	PHY : TYA : LSR #2 : TAY
	LDA #$00 : STA $0420|!Base2,y
	PLY

	if !TextLeft == 0
	+
	endif


	LDA $01
	CLC
	ADC #$08
	STA $01

	if !TextLeft == 1
	+
	endif


	LDA $02
	STA $04

	%nexttile()
	
	LDA $01
	STA $0200|!Base2,y
	LDA !TextY
	STA $0201|!Base2,y
	LDA !TextTile
	CLC
	ADC $04
	STA $0202|!Base2,y
	LDA !TextProp
	STA $0203|!Base2,y

	PHY : TYA : LSR #2 : TAY
	LDA #$00 : STA $0420|!Base2,y
	PLY

	+

	LDA $01
	CLC
	ADC #$08
	STA $01

	RTS

NegSign:

	if !16bit
	REP #$20
	endif

	if !indexed

	LDA !index
	BPL ++++++

	if !16bit
	LDA #$0000
	else
	LDA #$00
	endif
	BRA ++++++++
	++++++
	PHX
	TAX
	LDA !value,x
	PLX
	++++++++

	else
	LDA !value
	endif

	if !16bit
	SEP #$20
	endif
	BMI +
	RTS
	+

	if !TextLeft == 0
	LDA $01
	SEC
	SBC #$08
	STA $01
	endif

	%nexttile()
	
	LDA $01
	STA $0200|!Base2,y
	LDA !TextY
	STA $0201|!Base2,y
	LDA !TextTile
	CLC
	ADC #$0A
	STA $0202|!Base2,y
	LDA !TextProp
	STA $0203|!Base2,y

	PHY : TYA : LSR #2 : TAY
	LDA #$00 : STA $0420|!Base2,y
	PLY

	+

	LDA $01
	CLC
	ADC #$08
	STA $01

	RTS

Horizontal:

	if !16bit == 1
	REP #$20
	endif
	
	LDA !max
	SEC
	SBC !min

	%div(!BarSize)

	LDY #$00

	if !16bit == 0
	SEP #$20
	endif

	LDA $4214
	STA $02
	LSR #3
	STA $04
	
	LDA $4216
	STA $0B
	
	SEP #$20

	LDA $02
	AND #$07
	ASL
	STA $0C

	STZ $06
	STZ $08

	if !BarOverlay

	LDA !BarX
	STA $0A

	LDX !BarSize-3

	%nexttile()
	
	LDA $0A
	STA $0200|!Base2,y
	LDA !BarY
	STA $0201|!Base2,y
	LDA !BarOverL
	STA $0202|!Base2,y
	LDA !BarOverProp
	STA $0203|!Base2,y

	PHY : TYA : LSR #2 : TAY
	LDA #$00 : STA $0420|!Base2,y
	PLY

	if !BarWide

	%nexttile()
	
	LDA $0A
	STA $0200|!Base2,y
	LDA !BarY
	CLC
	ADC #$08
	STA $0201|!Base2,y
	LDA !BarOverL
	CLC
	ADC #$10
	STA $0202|!Base2,y
	LDA !BarOverProp
	STA $0203|!Base2,y

	PHY : TYA : LSR #2 : TAY
	LDA #$00 : STA $0420|!Base2,y
	PLY

	endif

	LDA $0A
	CLC
	ADC #$08
	STA $0A

-



	%nexttile()
	
	LDA $0A
	STA $0200|!Base2,y
	LDA !BarY
	STA $0201|!Base2,y
	LDA !BarOverM
	STA $0202|!Base2,y
	LDA !BarOverProp
	STA $0203|!Base2,y

	PHY : TYA : LSR #2 : TAY
	LDA #$00 : STA $0420|!Base2,y
	PLY

	if !BarWide

	%nexttile()

	LDA $0A
	STA $0200|!Base2,y
	LDA !BarY
	CLC
	ADC #$08
	STA $0201|!Base2,y
	LDA !BarOverM
	CLC
	ADC #$10
	STA $0202|!Base2,y
	LDA !BarOverProp
	STA $0203|!Base2,y

	PHY : TYA : LSR #2 : TAY
	LDA #$00 : STA $0420|!Base2,y
	PLY

	endif


	LDA $0A
	CLC
	ADC #$08
	STA $0A

	DEX
	BPL -
	+


	%nexttile()
	
	LDA $0A
	STA $0200|!Base2,y
	LDA !BarY
	STA $0201|!Base2,y
	LDA !BarOverR
	STA $0202|!Base2,y
	LDA !BarOverProp
	STA $0203|!Base2,y

	PHY : TYA : LSR #2 : TAY
	LDA #$00 : STA $0420|!Base2,y
	PLY

	if !BarWide

	%nexttile()
	
	LDA $0A
	STA $0200|!Base2,y
	LDA !BarY
	CLC
	ADC #$08
	STA $0201|!Base2,y
	LDA !BarOverR
	CLC
	ADC #$10
	STA $0202|!Base2,y
	LDA !BarOverProp
	STA $0203|!Base2,y

	PHY : TYA : LSR #2 : TAY
	LDA #$00 : STA $0420|!Base2,y
	PLY
	endif

	endif


	LDA !BarX
	STA $0A

	STZ $0F

	if !16bit
	REP #$20
	endif

	LDA $00
	-

	if !16bit
	REP #$20
	CMP #$0000
	else
	CMP #$00
	endif

	BEQ +
	CMP $02
	BCC +
	SEC
	SBC $02

	BMI +++
	BEQ +++

	PHA

	SEP #$20

	LDA $0B
	BEQ ++

	LDA $0F
	CLC
	ADC $0B
	STA $0F
	CMP !BarSize
	BMI ++

	SEC
	SBC !BarSize
	STA $0F

	if !16bit
	REP #$20
	endif

	PLA
	DEC

	BRA +++

	++

	if !16bit
	REP #$20
	endif

	PLA

	+++

	INC $06
	BRA -

	+

	SEP #$20

	STZ $0F

	-
	if !16bit
	REP #$20
	CMP #$0000
	else
	CMP #$00
	endif

	BEQ +
	CMP $04
	BCC +
	SEC
	SBC $04

	BMI +++
	BEQ +++

	PHA

	SEP #$20

	LDA $0C
	BEQ ++

	LDA $0F
	CLC
	ADC $0C
	STA $0F
	CMP #$08
	BMI ++

	SEC
	SBC #$08
	STA $0F

	if !16bit
	REP #$20
	endif


	PLA
	DEC

	BRA +++

	++

	if !16bit
	REP #$20
	endif

	PLA

	+++


	SEP #$20

	INC $08
	BRA -
	+





	LDA $08
	BNE +

	+
	SEP #$20
	LDX $06
	DEX
	BMI +
	-

	%nexttile()
	
	LDA $0A
	STA $0200|!Base2,y
	LDA !BarY
	if !BarWide == 1 && !BarWideDbl == 0
	CLC
	ADC #$04
	endif
	STA $0201|!Base2,y
	LDA !BarTile
	STA $0202|!Base2,y
	LDA !BarProp
	STA $0203|!Base2,y

	PHY : TYA : LSR #2 : TAY
	LDA #$00 : STA $0420|!Base2,y
	PLY


	if !BarWide == 1 && !BarWideDbl == 1
	
	%nexttile()
	
	LDA $0A
	STA $0200|!Base2,y
	LDA !BarY
	CLC
	ADC #$08
	STA $0201|!Base2,y
	LDA !BarTile
	STA $0202|!Base2,y
	LDA !BarProp
	ORA #$80
	STA $0203|!Base2,y

	PHY : TYA : LSR #2 : TAY
	LDA #$00 : STA $0420|!Base2,y
	PLY

	endif


	LDA $0A
	CLC
	ADC #$08
	STA $0A

	DEX
	BPL -
	+

	LDA $08
	BEQ +

	%nexttile()
	
	LDA $0A
	STA $0200|!Base2,y
	LDA !BarY
	if !BarWide == 1 && !BarWideDbl == 0
	CLC
	ADC #$04
	endif
	STA $0201|!Base2,y
	LDA !BarTile
	CLC
	ADC $08
	STA $0202|!Base2,y
	LDA !BarProp
	STA $0203|!Base2,y

	PHY : TYA : LSR #2 : TAY
	LDA #$00 : STA $0420|!Base2,y
	PLY


	if !BarWide == 1 && !BarWideDbl == 1

	%nexttile()
	
	LDA $0A
	STA $0200|!Base2,y
	LDA !BarY
	CLC
	ADC #$08
	STA $0201|!Base2,y
	LDA !BarTile
	CLC
	ADC $08
	STA $0202|!Base2,y
	LDA !BarProp
	ORA #$80
	STA $0203|!Base2,y

	PHY : TYA : LSR #2 : TAY
	LDA #$00 : STA $0420|!Base2,y
	PLY

	endif

	LDA $0A
	CLC
	ADC #$08
	STA $0A

	INC $06

	+


	if !BarBG

	DEC $06
	
	LDA !BarSize-1
	SEC
	SBC $06
	TAX
	DEX
	BMI +
	-

	%nexttile()
	
	LDA $0A
	STA $0200|!Base2,y
	LDA !BarY
	if !BarWide == 1 && !BarWideDbl == 0
	CLC
	ADC #$04
	endif
	STA $0201|!Base2,y
	LDA !BarBGTile
	STA $0202|!Base2,y
	LDA !BarProp
	STA $0203|!Base2,y

	PHY : TYA : LSR #2 : TAY
	LDA #$00 : STA $0420|!Base2,y
	PLY


	if !BarWide == 1 && !BarWideDbl == 1
	
	%nexttile()
	
	LDA $0A
	STA $0200|!Base2,y
	LDA !BarY
	CLC
	ADC #$08
	STA $0201|!Base2,y
	LDA !BarBGTile
	STA $0202|!Base2,y
	LDA !BarProp
	ORA #$80
	STA $0203|!Base2,y

	PHY : TYA : LSR #2 : TAY
	LDA #$00 : STA $0420|!Base2,y
	PLY

	endif


	LDA $0A
	CLC
	ADC #$08
	STA $0A

	DEX
	BPL -
	+
	endif

	RTS

print "vertical ",pc

Vertical:
	if !16bit == 1
	REP #$20
	endif
	
	LDA !max
	SEC
	SBC !min

	%div(!BarSize)

	LDY #$00

	if !16bit == 0
	SEP #$20
	endif

	LDA $4214
	STA $02
	LSR #3
	STA $04
	
	LDA $4216
	STA $0B
	
	SEP #$20

	LDA $02
	AND #$07
	ASL
	STA $0C


	STZ $06
	STZ $08

	if !BarOverlay

	LDA !BarSize-1
	ASL #3
	CLC
	ADC !BarY
	STA $0A

	LDX !BarSize-3

	%nexttile()
	
	LDA $0A
	STA $0201|!Base2,y
	LDA !BarX
	STA $0200|!Base2,y
	LDA !BarOverR
	STA $0202|!Base2,y
	LDA !BarOverProp
	STA $0203|!Base2,y

	PHY : TYA : LSR #2 : TAY
	LDA #$00 : STA $0420|!Base2,y
	PLY

	if !BarWide

	%nexttile()
	
	LDA $0A
	STA $0201|!Base2,y
	LDA !BarX
	CLC
	ADC #$08
	STA $0200|!Base2,y
	LDA !BarOverR
	CLC
	ADC #$01
	STA $0202|!Base2,y
	LDA !BarOverProp
	STA $0203|!Base2,y

	PHY : TYA : LSR #2 : TAY
	LDA #$00 : STA $0420|!Base2,y
	PLY


	endif
	
	LDA $0A
	SEC
	SBC #$08
	STA $0A

-

	%nexttile()
	
	LDA $0A
	STA $0201|!Base2,y
	LDA !BarX
	STA $0200|!Base2,y
	LDA !BarOverM
	STA $0202|!Base2,y
	LDA !BarOverProp
	STA $0203|!Base2,y

	PHY : TYA : LSR #2 : TAY
	LDA #$00 : STA $0420|!Base2,y
	PLY

	if !BarWide

	%nexttile()
	
	LDA $0A
	STA $0201|!Base2,y
	LDA !BarX
	CLC
	ADC #$08
	STA $0200|!Base2,y
	LDA !BarOverM
	CLC
	ADC #$01
	STA $0202|!Base2,y
	LDA !BarOverProp
	STA $0203|!Base2,y

	PHY : TYA : LSR #2 : TAY
	LDA #$00 : STA $0420|!Base2,y
	PLY


	endif



	LDA $0A
	SEC
	SBC #$08
	STA $0A


	DEX
	BPL -
	+


	%nexttile()
	
	LDA $0A
	STA $0201|!Base2,y
	LDA !BarX
	STA $0200|!Base2,y
	LDA !BarOverL
	STA $0202|!Base2,y
	LDA !BarOverProp
	STA $0203|!Base2,y

	PHY : TYA : LSR #2 : TAY
	LDA #$00 : STA $0420|!Base2,y
	PLY

	if !BarWide

	%nexttile()
	
	LDA $0A
	STA $0201|!Base2,y
	LDA !BarX
	CLC
	ADC #$08
	STA $0200|!Base2,y
	LDA !BarOverL
	CLC
	ADC #$01
	STA $0202|!Base2,y
	LDA !BarOverProp
	STA $0203|!Base2,y

	PHY : TYA : LSR #2 : TAY
	LDA #$00 : STA $0420|!Base2,y
	PLY

	endif


	endif


	LDA !BarSize-1
	ASL #3
	CLC
	ADC !BarY
	STA $0A



	STZ $0F

	if !16bit
	REP #$20
	endif

	LDA $00
	-
	if !16bit
	REP #$20
	CMP #$0000
	else
	CMP #$00
	endif

	BEQ +
	CMP $02
	BCC +
	SEC
	SBC $02

	BMI +++
	BEQ +++

	PHA

	SEP #$20
	LDA $0B
	BEQ ++

	LDA $0F
	CLC
	ADC $0B
	STA $0F
	CMP !BarSize
	BMI ++

	SEC
	SBC !BarSize
	STA $0F

	if !16bit
	REP #$20
	endif

	PLA
	DEC

	BRA +++

	++

	if !16bit
	REP #$20
	endif

	PLA

	+++

	INC $06
	BRA -

	+

	SEP #$20

	print "loop ",pc

	STZ $0F

	-
	if !16bit
	REP #$20
	CMP #$0000
	else
	CMP #$00
	endif
	BEQ +
	CMP $04
	BCC +
	SEC
	SBC $04
	SEP #$20

	BMI +++
	BEQ +++
	PHA

	LDA $0C
	BEQ ++

	LDA $0F
	CLC
	ADC $0C
	STA $0F
	CMP #$08
	BMI ++

	SEC
	SBC #$08
	STA $0F

	PLA
	DEC

	BRA +++

	++

	PLA

	+++


	INC $08
	BRA -
	+

	SEP #$20
	LDX $06
	DEX
	BMI +
	-

	%nexttile()
	
	LDA $0A
	STA $0201|!Base2,y
	LDA !BarX
	if !BarWide == 1 && !BarWideDbl == 0
	CLC
	ADC #$04
	endif
	STA $0200|!Base2,y
	LDA !BarTile
	STA $0202|!Base2,y
	LDA !BarProp
	STA $0203|!Base2,y

	PHY : TYA : LSR #2 : TAY
	LDA #$00 : STA $0420|!Base2,y
	PLY

	if !BarWide == 1 && !BarWideDbl == 1

	%nexttile()
	
	LDA $0A
	STA $0201|!Base2,y
	LDA !BarX
	CLC
	ADC #$08
	STA $0200|!Base2,y
	LDA !BarTile
	STA $0202|!Base2,y
	LDA !BarProp
	ORA #$40
	STA $0203|!Base2,y

	PHY : TYA : LSR #2 : TAY
	LDA #$00 : STA $0420|!Base2,y
	PLY

	endif

	LDA $0A
	SEC
	SBC #$08
	STA $0A


	DEX
	BPL -
	+

	LDA $08
	BEQ +

	%nexttile()
	
	LDA $0A
	STA $0201|!Base2,y
	LDA !BarX
	if !BarWide == 1 && !BarWideDbl == 0
	CLC
	ADC #$04
	endif
	STA $0200|!Base2,y
	LDA !BarTile
	CLC
	ADC $08
	STA $0202|!Base2,y
	LDA !BarProp
	STA $0203|!Base2,y

	PHY : TYA : LSR #2 : TAY
	LDA #$00 : STA $0420|!Base2,y
	PLY

	if !BarWide == 1 && !BarWideDbl == 1
	
	%nexttile()
	
	LDA $0A
	STA $0201|!Base2,y
	LDA !BarX
	CLC
	ADC #$08
	STA $0200|!Base2,y
	LDA !BarTile
	CLC
	ADC $08
	STA $0202|!Base2,y
	LDA !BarProp
	ORA #$40
	STA $0203|!Base2,y

	PHY : TYA : LSR #2 : TAY
	LDA #$00 : STA $0420|!Base2,y
	PLY
	endif

	LDA $0A
	SEC
	SBC #$08
	STA $0A

	INC $06
	+

	if !BarBG

	DEC $06
	
	LDA !BarSize-1
	SEC
	SBC $06
	TAX
	DEX
	BMI +
	-

	%nexttile()
	
	LDA $0A
	STA $0201|!Base2,y
	LDA !BarX
	if !BarWide == 1 && !BarWideDbl == 0
	CLC
	ADC #$04
	endif
	STA $0200|!Base2,y
	LDA !BarBGTile
	STA $0202|!Base2,y
	LDA !BarProp
	STA $0203|!Base2,y

	PHY : TYA : LSR #2 : TAY
	LDA #$00 : STA $0420|!Base2,y
	PLY

	if !BarWide == 1 && !BarWideDbl == 1

	%nexttile()
	
	LDA $0A
	STA $0201|!Base2,y
	LDA !BarX
	CLC
	ADC #$08
	STA $0200|!Base2,y
	LDA !BarBGTile
	STA $0202|!Base2,y
	LDA !BarProp
	ORA #$40
	STA $0203|!Base2,y

	PHY : TYA : LSR #2 : TAY
	LDA #$00 : STA $0420|!Base2,y
	PLY

	endif

	LDA $0A
	SEC
	SBC #$08
	STA $0A


	DEX
	BPL -
	+
	endif



	RTS
