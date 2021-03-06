;This contains examples as for anyone who does not know how
;to write tiles to the overworld border. Best used on
;UberASM tool's gamemode $0E.

;Write "000" on the border:
	
	
	!WritePosition = $7FEC00 ;>Change to $41EC00 for SA-1
	
	main:
	
	LDX.b #(3-1)*2 ;Write 3 times for each 3 tile byte; indexes 0, 2, and 4 to write.
	
	.LoopTile
	LDA #$22			;>See [1]
	STA !WritePosition,x		;>Tile number [TTTTTTTT] byte
	LDA.b #%00111001		;>See [2]
	STA !WritePosition+$01,x	;>Tile properties [YXPCCCTT] byte
	DEX #2				;>Decrease X by 2 (2 bytes per 8x8 tile)
	BPL .LoopTile			;>If there are remaining tiles left, keep writing until X = $FE

	;[1] Number tiles (digits 0-9) are located at page 1 at
	;tiles $22 to $2B (hence the #$22 on the LDA). If you
	;are using a display of numbers that can change, after
	;using the Hex->Dec to convert to decimal, you add each
	;digit byte by $22 to convert them to overworld digits.
	;An example is in [Overworld_Border_Plus.asm] under
	;"if !Enable_Lives_Display" (I, GreenHammerBro added comments).
	
	;[2] Tile Properties:
	;        YXPCCCTT
	;LDA.b #%00111001 (that in hex is #$39).
	;^Bits [TT] is the page number, ranging from 0-3 (%00 to %11), the digit
	;  tiles are located at page 1 (%01).
	; Bits [CCC] is what palette to use, ranging from 0-7 (%000 to %111),
	;  the same way LM displays all the possible colors row. Palette 6 (%110)
	;  is considered the normal palette for numbers.
	; Bits [P] is the priority bit, determines if this tile goes in front
	;  of all layer 1 and 2 stuff. Recommended to have this set to 1 and
	;  and not 0 if you don't want stuff like sprites (clouds) and
	;  layer 1 stuff overlapping it.
	; Bits [X] is the X flip of the tile.
	; Bits [Y] is the Y flip of the tile.
;Another example: Write "TEST" without using loops. Note: On most emulators, the top line of pixels are cutoff:
	
	!WritePosition = $7FEC00 ;>Change to $41EC00 for SA-1
	
	main:
	;Make sure you use fixed-width font in your text editor (uses ASCII art)!
	;|----------Tile Number---------|   |-------------Tile Properties-----------|
	;V                              V   V                                       V
	LDA #$13 : STA !WritePosition+$00 : LDA.b #%00111001 : STA !WritePosition+$01 ;>Tile $13 is "T"
	LDA #$04 : STA !WritePosition+$02 : LDA.b #%00111001 : STA !WritePosition+$03 ;>Tile $04 is "E"
	LDA #$12 : STA !WritePosition+$04 : LDA.b #%00111001 : STA !WritePosition+$05 ;>Tile $12 is "S"
	LDA #$13 : STA !WritePosition+$06 : LDA.b #%00111001 : STA !WritePosition+$07 ;>Tile $13 is "T"
	RTL