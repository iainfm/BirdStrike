\ Build directives

ORIGINAL = FALSE      \ Build an exact copy of the original. False overrides the tamper protection / default high score holder
FIX      = TRUE       \ Needs ORIGINAL = FALSE. Use 'spare' space at $1B11 for the fix
PRESERVE = TRUE       \ Preserve original memory locations where possible when ORIGINAL = FALSE
                      \ Does not apply globally, eg if FIX = TRUE or ENCHTS = TRUE
ENRELO   = FALSE      \ Enable relocation (not working yet)
ENCHTS   = TRUE       \ Requires FIX = TRUE. Enable some PoC modifications.
MAX_1A09 = $10        \ Limit how high L1A09 can get.
                      \ >= $19 will cause glitches.
					  \ <= $06 will affect game difficulty (no. of simultaneous enemy bombs)
					  \ $10 seems safe.
TEST     = FALSE      \ Used for code-relocatability testing					  

\ ToDo: check references to $28D6/7 (player sprite pointer), $2D7C/D and $78/79 for fixed addressing (L2BB0)
\ L2d68 as well
\ 75/76 (&2D13)
\ 7A/7B (&2E00)
\ 88
\ Check memory writes 261A - 26AF

\ Possible SMC locations to investigate:
\ L17A0
\ L17AC

\ L18F5
\ L18F6

\ L240F - Pigeon sprite pointer - changes for L-R / R-L flyer
\ L246C - Pigeon start position?
\ L252F - Pigeon end position?

\ L266F - Screen memory addresses for cloud plotting
\ L2670 - Screen memory addresses for cloud plotting

\ L2672 - Screen memory addresses for cloud plotting
\ L2673 - Screen memory addresses for cloud plotting

\ L28D6 - Player sprite / hit / skull
\ L28D7 - Player sprite / hit / skull

\ L2C1E - Number of 8x8 sprites to plot? 3F (64 bytes for planes?)
\ L2D03 - variable SBC for something

\ Check what updates L008A
\ Check possible SMC @ L2C1E

\ BirdSk2.bin
L0000   = $0000        \ Zero Page uses
L0008   = $0008
L0009   = $0009
L000A   = $000A
L000B   = $000B
L005D   = $005D
L0070   = $0070
L0071   = $0071
L0072   = $0072
L0073   = $0073
L0074   = $0074
L0075   = $0075
L0076   = $0076
L0077   = $0077
L0078   = $0078
L0079   = $0079
L007A   = $007A    \ Bullet X coordinate?
L007B   = $007B
L007C   = $007C
L007D   = $007D
L007E   = $007E    \ Only used in .L25B8
L007F   = $007F    \ Only used in .L25B8
L0080   = $0080    \ Score screen memory location low byte
L0081   = $0081    \ Score screen memory location high byte
L0082   = $0082    \ Sprite pointer low byte (digits, notes, pigeons etc)
L0083   = $0083    \ Sprite pointer high byte
L0084   = $0084    \ Something to do with enemy position / plotting
L0085   = $0085    \ Something to do with enemy position / plotting
L0086   = $0086
L0087   = $0087
enemySpriteAddrLow   = $0088        \ L0088 \ Enemy sprite address low byte (0 = level 1 aircraft, add $40 per level)
enemySpriteAddrHigh  = $0089        \ L0089 \ Enemy sprite address high byte
L008A   = $008A    \ Enemy X coordinate?
L008B   = $008B
L008C   = $008C    \ Something to do with enemy bomb y-position
L008D   = $008D
L008E   = $008E

BYTEvA  = $020A        \ BYTEvA
BYTEvB  = $020B        \ BYTEvB

osword_redirection_C   = $020C
osword_redirection_D   = $020D

WRCHvA  = $020E        \ WRCH vector A
WRCHvB  = $020F        \ WRCH vector B

EVNTvA  = $0220        \ EVNT vector A
EVNTvB  = $0221        \ EVNT vector B

L02FC   = $02FC        \ Busy buffer flag

L3527   = $3527        \ Screen memory locations
L3528   = $3528
L3529   = $3529
L352A   = $352A
L4180   = $4180
L4900   = $4900

LFE4D   = $FE4D        \ Interrupt Flag Register
LFE4E   = $FE4E        \ Interrupt Enable Register

vector_table_low_byte    = $FFB7    \ Vector table address low byte
vector_table_high_byte   = $FFB8    \ Vector table address high byte

osasci  = $FFE3        \ OSASCI
oswrch  = $FFEE        \ OSWRCH
osword  = $FFF1        \ OSWORD
osbyte  = $FFF4        \ OSBYTE

        
org     $1200          \ "P%" as per the original binary

.p0data \ L1200
        \ First 160 bytes of code get copied to page 0 by p0copyloop
        \ These addresses are normally used by BASIC and Econet
		\ Possibly a memory lookup table in the main for zero page addressing
		\        00  01  02  03  04  05  06  07   08  09  0A  0B  0C  0D  0E  0F
        EQUB    $02,$19,$02,$19,$00,$7C,$00,$7C, $72,$E7,$01,$00,$07,$32,$83,$98 \ 00 
        EQUB    $80,$77,$02,$19,$0A,$00,$43,$B4, $19,$00,$07,$00,$00,$19,$00,$00 \ 10
        EQUB    $00,$FF,$FF,$FF,$00,$00,$00,$40, $FF,$FF,$00,$35,$00,$00,$00,$00 \ 20
        EQUB    $8F,$00,$00,$00,$00,$00,$28,$00, $07,$EE,$20,$00,$FF,$00,$00,$7F \ 30 $2800 - castle tower
        EQUB    $FE,$00,$FE,$7E,$00,$00,$00,$00, $00,$00,$40,$08,$05,$FF,$09,$00 \ 40
        EQUB    $00,$00,$00,$00,$00,$00,$00,$00, $00,$00,$9F,$1D,$01,$01,$01,$01 \ 50
        EQUB    $79,$14,$72,$D4,$06,$00,$00,$00, $40,$00,$40,$00,$00,$00,$00,$00 \ 60
        EQUB    $00,$37,$D0,$37,$20,$39,$02,$00                                  \ 70
		EQUW                                      L2E00                          \ 70
		EQUB                                             $00,$6E,$00,$02,$1B,$AA \ 70 $2E00 - clouds etc
        EQUB    $00,$34                                                          \ 80
		EQUW             L1C00                                                   \ 80
		EQUB                    $EF,$80,$98,$7E, $A5,$64                         \ 80
		EQUW                                              L208D
		EQUB    										         $01,$A5,$65,$8D \ 80
        EQUB    $21,$01,$C9,$07,$F0,$03,$6C,$64, $00,$60,$04,$01,$FF,$FF,$FF,$00 \ 90
        
		\ Then follows 96  bytes of padding
        FOR Z, 1, 96
		    EQUB $00
	    NEXT
		
.entry  \ L1300

        \ Official code entry point. Originally needed BIRDSK1 to be loaded at page &3000 first.
        \ *possibly* an anti-tamper mechanism?

        SEI                  \ Disable interrupts
		
		IF ORIGINAL = TRUE
		    LDA     L3527
	    ELSE
		    LDA     #$A4         \ Originally loaded from L3527
			IF PRESERVE = TRUE
		        NOP              \ To keep memory addresses consistent with original
			ENDIF
		ENDIF
        STA     WRCHvA
		
		IF ORIGINAL = TRUE
		    LDA     L3528
		ELSE
		    LDA     #$E0         \ Originally loaded from L3528
			IF PRESERVE = TRUE
		        NOP              \ To keep memory addresses consistent with original
			ENDIF
		ENDIF
        STA     WRCHvB
        
		IF ORIGINAL = TRUE
		    LDA     L3529
		ELSE
		    LDA     #$A6         \ Originally loaded from L3529
			IF PRESERVE = TRUE
		        NOP              \ To keep memory addresses consistent with original
			ENDIF
		ENDIF
        STA     EVNTvA
		
		IF ORIGINAL = TRUE
		    LDA     L352A
		ELSE
		    LDA     #$FF         \ Originally loaded from L352A
			IF PRESERVE = TRUE
		        NOP              \ To keep memory addresses consistent with original
			ENDIF
		ENDIF
        STA     EVNTvB
		
        CLI                  \ Enable interrupts
        LDA     #$0D
        LDX     #$00
        JSR     osbyte       \ Disable output buffer empty event

        LDA     #$0D
        LDX     #$06
        JSR     osbyte       \ Disable ESCAPE pressed event

        LDA     #$0F
        LDX     #$00
        JSR     osbyte       \ Flush all buffers

        SEI                  \ Disable interrupts
        LDA     BYTEvA       \ Vector stuff...
        STA     L0008
        LDA     BYTEvB
        STA     L0009
        LDA     vector_table_low_byte
        STA     L000A
        LDA     vector_table_high_byte
        STA     L000B
        LDY     #$0A
        LDA     (L000A),Y
        STA     BYTEvA
        INY
        LDA     (L000A),Y
        STA     BYTEvB
		
        LDA     #$C8
        LDX     #$03
        LDY     #$00
        JSR     osbyte        \ Disable escape, clear memory on break

        CLI                   \ Enable interrupts
        LDA     #$7C
        JSR     osbyte        \ Clear Esc condition

        LDA     L0008
        STA     BYTEvA
        LDA     L0009
        STA     BYTEvB
        LDX     #$00
		
.p0copyloop     \ L136C
        \ Copy 160 bytes at &1200 to page zero.
		
        LDA     p0data,X
        STA     L0000,X
        INX
        CPX     #$A0
        BNE     p0copyloop

        LDA     #$8C
        LDX     #$0Cb
        JSR     osbyte        \ Set TAPE filing system and baud rate (X)

        JMP     game

		\ Then follows 128 bytes of padding
        FOR Z, 1, 128
		    EQUB $00
	    NEXT
        
		\ Thanks and credits
        EQUS    "Thanks David,Ian,Martin,Mum,Dad,Susi C"

        
.keyCheck       \ Main keyboard scan during gameplay .L1426
        LDX     #$EF             \ Q key
        JSR     keyboardScan

        BNE     checkSkey        \ Skip if pressed

        LDA     #LO(L1461)       \ #$61
        STA     osword_redirection_C      \ Mess with vectors to disable sounds
        LDA     #HI(L1461)       \ #$14
        STA     osword_redirection_D      \ Mess with vectors to disable sounds
		
.checkSkey      \ .L1437
        LDX     #$AE             \ S key
        JSR     keyboardScan

        BNE     checkRkey        \ Skip if pressed
        LDA     wordv_1
        STA     osword_redirection_C      \ Restore default vectors to enable sounds
        LDA     wordv_2
        STA     osword_redirection_D      \ Restore default vectors to enable sounds

.checkRkey      \ .L144A
        LDX     #$CC
        JSR     keyboardScan     \ R key
        BNE     keyCheckComplete

.debounceRkey   \ .L1451  \ De-bounce for R keypress?
        LDA     #$81
        LDY     #$01
        LDX     #$00
        JSR     osbyte    \ Read key with timeout
        BCS     debounceRkey     \ No key detected
        CPX     #$52      \ INKEY value of R
        BEQ     debounceRkey

.keyCheckComplete    \.L1460
        RTS

.L1461  \ Disable sounds - Address used by .keyCheck (osword_redirection_C/D)

        CMP    #$07
		BEQ    keyCheckComplete
		JMP    (wordv_1)

.wordv_1    \ OSWORD redirection vector stored here \L1468
        EQUB    $EB

.wordv_2    \ OSWORD redirection vector stored here \L1469
        EQUB    $E7

.L146A  \ Move enemy / check left bound
        LDA     L149B
        BEQ     L1490

        LDA     L0077
        BPL     L1483

        DEC     L007A
        SEC
        LDA     L0078
        SBC     #$08
        STA     L0078
        BCS     L1490

        DEC     L0079
        JMP     L1490

.L1483  \ Check right bound
        INC     L007A
        CLC
        LDA     L0078
        ADC     #$08
        STA     L0078
        BCC     L1490

        INC     L0079
		
.L1490  \ Enemy left-right zigzag
        LDA     #$01    \ 0 = vertical descent
        EOR     L149B
        STA     L149B
        JMP     L2BE1

.L149B
        EQUB    $00    \ enemy zig-zag state?
		
.L149C  \ Triggered when bullet fired
		LDA     L14AD
		BEQ     L14A5
		DEC     L14AD
		RTS
		
.L14A5  \ Player bullet fired
        LDA     #$12     \ 2nd bullet fire delay?
        STA     L14AD
		JMP     L297D    \ this (or another L297D) may upset the disassembly. Jury's out.
		
.L14AD  EQUB   $00

.gameOver       \ Display Game Over message    \ L14AE
        PLA
        PLA
        LDY     #$FF
		
.gameOverLoop   \ L14B2
        INY
        LDA     #$0A
        JSR     L208D

        LDA     gameOverText,Y    \ Load chr at gameOverText (L14CA), offset Y
        JSR     oswrch            \ Print it

        CMP     #$52              \ Loop untl the "R" of "OVER"
        BNE     gameOverLoop

        LDA     #$96
        JSR     L208D

        JMP     L1E21

.gameOverText   \ GAME OVER message        \ L14CA    
        EQUB    $1F,$05,$0F,$11,$01        \ Red text, centred on screen
        EQUS    "GAME OVER"

.L14D8  \ Enemy has reached bottom of the screen
        RTS

.L14D9
        LDA     timer_L1D55
        BEQ     L14D8

        LDA     L007A
        EOR     #$80
        STA     L007A
        INC     L0077
        PLA
        PLA
        JMP     L2BE4

.L14EB
        LDA     #$01
        BIT     L151A
        BNE     L1502

        LDY     score_high_byte
        CPY     #$05				\ Extra life at 5000?
        BMI     L1519

        ORA     L151A
        STA     L151A
        JSR     L151B

.L1502
        LDA     #$02
        BIT     L151A
        BNE     L1519

        LDY     score_high_byte
        CPY     #$10
        BMI     L1519

        ORA     L151A
        STA     L151A
        JMP     L151B

.L1519
        RTS

.L151A
        EQUB    $00

.L151B
        JSR     L2223

        LDA     #$DC
        STA     L2DFC
        LDX     #$F8
        LDY     #$2D
        LDA     #$07
        JSR     osword        \ Play a sound (extra life)

        INC     L1D56
        CLC
        LDA     L1D57
        ADC     #$18
        STA     L1D57
        BCC     L153D

        INC     L1D58
.L153D
        RTS

.L153E
        LDA     level
        AND     #$03
        BNE     L1550

        LDA     #$0F
        JSR     L208D

        JSR     vduCalls

        JMP     L1556

.L1550
        JSR     L20B1

        JSR     playTune

.L1556
        JSR     L159E

        LDY     #$4B
.L155B
        SED
        CLC
        LDA     score_low_byte
        ADC     #$02
        STA     score_low_byte
        LDA     score_high_byte
        ADC     #$00
        STA     score_high_byte
        CLD
        LDA     #$02
        JSR     L208D

        TYA
        PHA
        LDX     #$E8
        LDY     #$2D
        LDA     #$07
        JSR     osword        \ Play a sound (bonus noise)

        JSR     L2054

        PLA
        TAY
        DEY
        BNE     L155B

        INC     L15B7
        LDX     #$B7
        LDY     #$15
        LDA     #$07
        JSR     osword        \ Play a sound (last pip of bonus noise)

        DEC     L15B7
        LDA     #$80
        ORA     gameFlags
        STA     gameFlags
        RTS

.L159E  \ Display bonus text
        LDY     #$00
.L15A0
        LDA     bonusText,Y
        JSR     oswrch

        INY
        CPY     #$0B
        BNE     L15A0

        RTS

.bonusText      \L15AC
        \ BONUS! message
        EQUB    $11,$06,$1F,$07,$0F        \ Cyan text, centred
        EQUS    "BONUS!"

.L15B7  \ Something to do with the bonus routine
        EQUB    $12 \ (just this byte, the rest is padding?)
		EQUB    $00,$FF,$FF,$00,$00,$00,$00
        EQUB    $FF,$B4,$16,$08,$20,$7F

.L15C5
        EQUB    $00

.L15C6
        EQUB    $00

.L15C7
        EQUB    $02

.titleScreen    \ L15C8
       \ MODE 7 Title Screen
	   
        EQUB    $16,$07,$17,$00,$0A,$20,$00,$00
        EQUB    $00,$00,$00,$00
.L15D4	EQUB    $9A,$94,$68,$3F
        EQUB    $6F,$34,$20,$20,$20,$20,$20,$20
        EQUB    $20,$20,$FF,$20,$20,$5F,$7E,$2F
        EQUB    $6D,$20,$78,$20,$20,$20,$20,$20
        EQUB    $20,$20,$7E,$0D,$9A,$96,$6A,$7D
        EQUB    $7E,$25,$20,$2F,$20,$30,$20,$20
        EQUB    $20,$20,$FF,$20,$20,$6A,$7D,$70
        EQUB    $30,$20,$FF,$2C,$20,$30,$20,$20
        EQUB    $2F,$20,$FF,$5F,$3E,$0D,$9A,$94
        EQUB    $6A,$3F,$60,$6F,$34,$FF,$20,$FF
        EQUB    $2F,$21,$78,$2F,$FF,$20,$20,$20
        EQUB    $60,$60,$FF,$20,$FF,$20,$20,$FF
        EQUB    $2F,$21,$FF,$20,$FF,$6F,$30,$20
        EQUB    $7E,$7B,$34,$0D,$9A,$96,$2A,$7D
        EQUB    $70,$7E,$25,$6F,$30,$FF,$20,$20
        EQUB    $6F,$7C,$3F,$20,$20,$2A,$7C,$7E
        EQUB    $27,$20,$6F,$74,$30,$FF,$20,$20
        EQUB    $6F,$30,$FF,$20,$2B,$34,$6D,$78
        EQUB    $24,$1F,$05,$05,$82                \ ?, [, [no cursor], [green]
        EQUS    "FIREBIRD (c) Andrew Frigaard"
        EQUB     $0D,$1F,$0B,$08,$8D,$83
        EQUS    "High Score"
        EQUB    $1F,$0B,$09,$8D,$83
        EQUS    "High Score"

.highScoreDots  \ L16A0
        \ High score display
        EQUB    $1F,$0B,$0B   \ Move text cursor
        EQUS    "............."
        EQUB    $00
		EQUB    $1F,$19,$0B   \ Move text cursor

.keysText       \ L16B4
        
		IF ORIGINAL = TRUE
            EQUS    "andrew  "    \ original high score holder
	    ELSE
		    EQUS    "iainfm  "    \ Credit for my fix :D
		ENDIF
		
        EQUB    $00

.L16BD  EQUB    $1F,$0E,$0E   \ Move text cursor
		EQUB    $8D,$83       \ Double-height / yellow
        EQUS    "Keys"        \ Double height line 1
        EQUB    $1F,$0E,$0F   \ Move text cursor
		EQUB    $8D,$83       \ Double-height / yellow
        EQUS    "Keys"        \ Double height line 2
        EQUB    $1F,$06,$11   \ Move text cursor
		EQUB    $86           \ Cyan
        EQUS    "Z ............ move left"
        EQUB    $1F,$06,$12   \ Move text cursor
		EQUB    $86           \ Cyan
        EQUS    "X ........... move right"
        EQUB    $1F,$06,$13   \ Move text cursor
		EQUB    $86           \ Cyan
        EQUS    "RETURN ........... shoot"
        EQUB    $1F,$06,$14   \ Move text cursor
		EQUB    $86           \ Cyan
        EQUS    "S/Q ....... sound on/off"
        EQUB    $1F,$06,$15   \ Move text cursor
		EQUB    $86           \ Cyan
        EQUS    "R ................. rest"
        EQUB    $00
.L175C  EQUB    $1F,$07,$18   \ Move text cursor
		EQUB    $81,$88       \ Red / flash
        EQUS    "Press space to play."
        EQUB    $00,$00,$00

.vduCalls       \ Call the VDU commands at vduCallsTable in reverse order    \ L1778
        LDY     #$0A
.vduLoop        \ L177A
        LDA     vduCallsTable,Y
        JSR     oswrch

        DEY
        BPL     vduLoop

        LDA     #$80
        STA     L17A0      \ SMC
        LDA     #$00
        STA     L17AC      \ SMC
        LDA     #$04
        STA     L0070
.L1791
        LDA     #$1D
        JSR     oswrch

        LDA     #$00
        JSR     oswrch

        JSR     oswrch

        SEC
.L179F
        LDA     #$00
L17A0 = L179F+1            \ SMC
        SBC     #$80
        STA     L17A0
        PHP
        JSR     oswrch

        PLP
.L17AB
        LDA     #$00
L17AC = L17AB+1            \ SMC
        SBC     #$00
        STA     L17AC
        JSR     oswrch

        JSR     drawStave

        DEC     L0070
        BNE     L1791

        LDA     level
        STA     L1A08
        LDA     #$00
        STA     level
        LDA     #$26    \ Possible memory address - purpose unknown
        STA     L1A0C
        LDA     #$88    \ Possible memory address - purpose unknown
        STA     L1A0B
.L17D1
        CLC
        LDA     L1A0B
        STA     L1D59
        LDA     L1A0C
        ADC     #$0A
        STA     L1A0C
        STA     L1D5A
        JSR     L20B1

        STX     L2382
        INC     level
.L17EC
        JSR     L20DE

        BNE     L17EC

        JSR     L20B1

        JSR     playTune

        LDA     #$3C
        JSR     L208D

        LDA     level
        CMP     #$04
        BNE     L17D1

        LDA     L1A08
        STA     level
        LDA     #$1A
        JMP     oswrch \ Restore default windows and then RTS

.vduCallsTable         \ VDU calls    \ L180E - executed top-to-bottom
        EQUB    $10    \ Clear graphics area
		EQUB    $03    \ 
		EQUB    $FF    \ 
		EQUB    $04    \ 
		EQUB    $0F    \ 
		EQUB    $02    \ 
		EQUB    $0F    \ 
		EQUB    $00    \ 
        EQUB    $F0    \ 
		EQUB    $18    \ Define graphics window
		EQUB    $1A    \ Restore default windows

.L1819
        LDA     #$00
        STA     L15C5
        LDA     score_high_byte
        CMP     L15C7
        BCC     L183F

        BNE     L1830

        LDA     score_low_byte
        CMP     L15C6
        BCC     L183F

.L1830
        LDA     score_low_byte
        STA     L15C6
        LDA     score_high_byte
        STA     L15C7
        DEC     L15C5
.L183F
        LDA     #$16
        JSR     oswrch

        LDA     #$07
        JSR     oswrch

        LDX     #LO(L15D4)          \ #$D4 self-modifying code
        LDY     #HI(L15D4)          \ #$15 self-modifying code
        JSR     L18EB

        LDA     #$1F
        JSR     oswrch

        LDA     #$05
        JSR     oswrch

        LDA     #$0B
        JSR     oswrch

        LDA     L15C7
        JSR     L18D7

        LDA     L15C6
        JSR     L18D7

        LDA     #$30
        JSR     oswrch

        LDX     #LO(highScoreDots) \ #$A0 self-modifying code
        LDY     #HI(highScoreDots) \ #$16 self-modifying code
        JSR     L18EB

        LDX     #LO(L16BD)         \ #$BD self-modifying code
        LDY     #HI(L16BD)         \ #$16 self-modifying code
        JSR     L18EB

        LDA     #$1F
        JSR     oswrch        \ Move cursor to x,y

        LDA     #$1A          \ Restore default windows
        JSR     oswrch

        LDA     #$0B
        JSR     oswrch        \ Move cursor up one line

        LDA     L15C5
        BEQ     L18A4

        LDA     #$15
        LDX     #$00
        JSR     osbyte        \ Flush keyboard buffer

        TXA
        LDX     #$C0
        LDY     #$15
        JSR     osword        \ Read line from input to memory, probably the name for the high score table

        JMP     L18B1

.L18A4
        LDY     #$FF
.L18A6
        INY
        LDA     keysText,Y    \ read and
        JSR     osasci        \ print high score text etc

        CMP     #$20
        BPL     L18A6

.L18B1
        LDY     #$02
.L18B3  \ Title screen loop
        LDA     titleScreen,Y
        JSR     oswrch

        INY
        CPY     #$0D
        BNE     L18B3

        LDA     #$64
        JSR     L208D

.L18C3
        LDA     #$1A
        JSR     oswrch

        LDX     #LO(L175C)       \ #$5C self-modifying code
        LDY     #HI(L175C)       \ #$17 self-modifying code
        JSR     L18EB

.L18CF  \ Wait for spacebar to begin game
        LDX     #$9D     \ Space bar
        JSR     keyboardScan

        BNE     L18CF

        RTS

.L18D7
        PHA
        LSR     A
        LSR     A
        LSR     A
        LSR     A
        CLC
        ADC     #$30
        JSR     osasci

        PLA
        AND     #$0F
        CLC
        ADC     #$30
        JMP     osasci    \ with implied RTS

.L18EB
        STX     L18F5    \ naughtly self-modifying code
        STY     L18F6    \ naughtly self-modifying code
        LDY     #$FF
.L18F3
        INY
.L18F4
        LDA     highScoreDots,Y
L18F5 = L18F4+1          \ SMC?
L18F6 = L18F4+2          \ SMC?

        JSR     osasci            \ Print the dots in the high score 'table'

        CMP     #$00
        BNE     L18F3

        PHA
        LDA     L005D
        CMP     #$01
        BNE     L1907

        PLA
        RTS

.L1907
        JMP     L1907                              \ Infinite loop alert

        \ Table below seems to be offset by 2 (ie STA &30002 for correct alignment)
		
.L190A  EQUB    $00,$00,$05,$00,$00,$00            \ Yellow dot? Probably junk
		
.L1910  EQUB    $00,$08,$08,$1C,$08,$08,$08,$00    \ Player lives
		EQUB    $28,$28,$28,$3E,$28,$28,$00,$00
		EQUB    $00,$08,$08,$08,$08,$08,$08,$00 
		
.L1928  EQUB    $00,$10,$10,$35,$35,$10,$10,$00    \ 'RAF' logo? Seems to be unused.
		EQUB    $30,$30,$3F,$03,$03,$3F,$30,$30
		EQUB    $00,$20,$20,$3A,$3A,$20,$20,$00
		
.L1940	EQUB    $00,$00,$00,$05,$00,$00,$00,$00    \ Enemy explosion 1 (L)
		EQUB    $00,$00,$00,$00,$00,$00,$00,$00
		EQUB    $00,$00,$00,$00,$2A,$00,$00,$00
		
.L1958	EQUB    $00,$00,$0A,$02,$15,$0A,$00,$00    \ Enemy explosion 1 (M)
		EQUB    $00,$00,$2A,$15,$00,$2A,$00,$00
		EQUB    $00,$00,$0A,$00,$02,$0A,$00,$00
		
.L1970	EQUB    $00,$00,$00,$2A,$00,$00,$00,$00    \ Enemy explosion 1 (R)
		EQUB    $00,$00,$00,$00,$05,$00,$00,$00
		EQUB    $00,$00,$00,$00,$00,$00,$00,$00

.L1988	EQUB    $1A,$05,$00,$C0,$05,$0A,$30,$05    \ Enemy explosion 2 (L)
		EQUB    $40,$00,$4A,$15,$00,$2A,$0F,$10
		EQUB    $00,$4A,$15,$00,$00,$48,$80,$20
		
.L19A0	EQUB    $0A,$4A,$10,$00,$00,$40,$2A,$0A    \ Enemy explosion 2 (R)
		EQUB    $10,$0A,$40,$15,$00,$2A,$85,$30
		EQUB    $80,$25,$0A,$40,$25,$90,$1A,$05
		
.L19B8	EQUB    $0A,$00,$20,$40,$00,$0A,$00,$00    \ Enemy explosion 3 (L)
		EQUB    $00,$05,$00,$00,$00,$00,$00,$00
		EQUB    $00,$00,$00,$80,$00,$00,$08,$00
		
.L19D0	EQUB    $00,$00,$00,$00,$00,$00,$00,$00    \ Enemy explosion 3 (M)
		EQUB    $0A,$00,$00,$00,$00,$00,$00,$40
		EQUB    $00,$00,$00,$00,$05,$00,$00,$00
		
.L19E8	EQUB    $08,$00,$00,$00,$00,$00,$00,$00    \ Enemy explosion 3 (R)
		EQUB    $00,$00,$00,$00,$00,$00,$15,$08
		EQUB    $00,$80,$00,$00,$05,$00,$00,$00
		
.L1A00	EQUB    $2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A    \ White vertical line (padding?)

.L1A08
        EQUB    $FF

.L1A09
        EQUB    $FF

.L1A0A
        EQUB    $FF

.L1A0B
        EQUB    $FF

.L1A0C  
        EQUB    $FF,$FF,$FF,$FF
		\ Life lost animation sprites
.L1A10  \ Label added by iainfm
        EQUB    $00,$04,$00,$04,$28,$04,$00,$04 \ Player hit 1
        EQUB    $00,$00,$00,$00,$28,$00,$00,$00
        EQUB    $28,$00,$28,$00,$28,$00,$00,$00
        EQUB    $00,$04,$00,$04,$28,$04,$00,$04
        EQUB    $00,$00,$00,$00,$28,$00,$00,$00
		
.L1A38  \ Label added by iainfm
        EQUB    $00,$00,$00,$00,$00,$00,$04,$2C \ Player hit 2
        EQUB    $00,$00,$00,$00,$00,$00,$14,$28
        EQUB    $00,$00,$00,$00,$00,$00,$14,$28
        EQUB    $00,$00,$00,$00,$00,$00,$04,$2C
        EQUB    $00,$00,$00,$00,$00,$00,$00,$28

.L1A60
        EQUB    $00,$00,$00,$00,$00,$40,$00,$40 \ Skull
        EQUB    $40,$80,$80,$40,$40,$40,$80,$00
        EQUB    $C0,$80,$80,$40,$C0,$40,$80,$00
        EQUB    $00,$80,$80,$00,$00,$40,$80,$40
		
.L1A80  EQUB    $00,$00,$00,$00,$00,$00,$00,$00

.L1A88  EQUB    $00,$00,$00,$14,$3C,$00,$00,$00 \ Pigeon L-R 1
        EQUB    $00,$00,$00,$3C,$3C,$34,$3C,$28
        EQUB    $00,$00,$3C,$2D,$22,$00,$00,$00

.L1AA0  EQUB    $00,$00,$00,$14,$3C,$00,$14,$00 \ Pigeon L-R 2
        EQUB    $00,$00,$00,$3C,$3C,$34,$28,$00
        EQUB    $00,$00,$3C,$2D,$22,$00,$00,$00
		
.L1AB8  EQUB    $00,$00,$00,$14,$3C,$00,$00,$00 \ Pigeon L-R 3
        EQUB    $00,$00,$00,$3C,$39,$00,$00,$00
        EQUB    $00,$00,$3C,$2D,$22,$00,$00,$00
		
.L1AD0  EQUB    $00,$00,$00,$00,$14,$3C,$00,$00 \ Pigeon L-R 4
        EQUB    $00,$3C,$34,$3C,$39,$00,$00,$00
        EQUB    $00,$00,$3C,$2D,$22,$00,$00,$00
		
.L1AE8  EQUB    $14,$00,$00,$00,$14,$3C,$00,$00 \ Pigeon L-R 5
        EQUB    $28,$3C,$34,$3C,$39,$00,$00,$00
        EQUB    $00,$00,$3C,$2D,$22,$00,$00,$00
        
.L1B00  EQUB    $30,$24,$10,$13,$16,$19,$1C,$34            
        EQUB    $41,$1F,$48,$48,$48,$48,$48,$48
        EQUB    $48
        
.gameFix    \ L1B11
\ PRINT ORIGINAL, FIX, ENCHTS
        IF ORIGINAL = TRUE
		    \ junk BASIC/keyboard/source artefacts?
			EQUS    "LDASTAJSRRTSBNE"
            EQUS    "P.~!&"
            EQUB    $16,$34,$13
            EQUS    "12000L."
            EQUB    $0E
            EQUB    $0D
            EQUS    "RUN"
            EQUB    $0D,$16,$32,$17
            EQUB    $00,$0C,$00,$00,$00,$00,$00,$00
            EQUB    $00,$00
            EQUS    "CALLQ%"
			EQUB    $0D,$00,$00,$14,$3C,$00,$00,$00    \ Part pigeon? Possibly corrupt 
            EQUB    $00,$00,$00,$3C,$3C,$34,$3C,$28
            EQUB    $00,$00,$3C,$2D,$22,$00,$00,$00    \ Part pigeon? Possibly corrupt
            EQUB    $00,$00,$00,$14,$3C,$00,$14,$00
            EQUB    $00,$00,$00,$00,$00,$00,$00,$00
			\ 95 bytes total
		ELSE
		IF FIX = TRUE
		    \ Use this space for the memory-overwrite fix
		    \ PHP    \ Probably unnecessary
		    \ LDA    L1A09
			\ CMP    #MAX_1A09    \ L1A09 seems safe at $10.
			\ BEQ    maxedOut
			\ INC    L1A09
			\ INC    L1A09
            \ PLP    \ Also probably unnecessary
			
			\ msc27's method:
			LDA     L1A09
			CMP     #MAX_1A09
			BCS     maxedOut
			ADC     #$02
			STA     L1A09
.maxedOut   RTS
		ENDIF
		
        IF ENCHTS = TRUE
.rng        \ $1B11 (originally at L25B8)
            LDA     L007D
            AND     #$48
            ADC     #$38
            ASL     A
            ASL     A
            ROL     L007F
            ROL     L007E
            ROL     L007D    \ Randomise pigeon height?
            LDA     L007D    \ Why? - could probably save 2 bytes here.
							 
			\ Proof of concept cheats
.cheat1     LDX     #$CF         \ 2 bytes    \ '1' key
			JSR     keyboardScan \ 3 bytes
			BNE     ch1Skip      \ 2 bytes
			
			LDA     #$80         \ 2 bytes    \ Set the game flags
			STA     gameFlags    \ 3 bytes    \ to level complete
.ch1Skip

.cheat2     LDX     #$CE         \ 2 bytes     \ '2' key
            JSR     keyboardScan \ 3 bytes
			BNE     ch2Skip      \ 2 bytes
			
			LDA     #$C9         \ 2 bytes     \ I am invincible!
			EOR     L2238        \ 3 bytes     \ Toggle RTS/LDA#
			STA     L2238        \ 3 bytes     \ and store
.debounce2  LDX     #$CE
			JSR     keyboardScan
			BEQ     debounce2	
.ch2Skip

.cheat3     LDX     #$EE         \ '3' key
			JSR     keyboardScan
			BNE     ch3Skip
			LDA     #$10       \ trigger
			STA     gameFlags  \ a pigeon
			\ or
			\ LDA     #$20     \ make all hits critical
			\ EOR     L2AEF    \ aka
			\ STA     L2AEF    \ Golden Gun mode
.debounce3  LDX     #$EE
            JSR     keyboardScan
			BEQ     debounce3
.ch3Skip
            RTS              \ 1 byte
		ENDIF
	ENDIF
	
	\ Blank out the unused remainder
	PRINT (&1B70-P%), "bytes free at",~P%
	IF P% <> $1B70
	    FOR Z, P%, $1B6F
            EQUB    $00
        NEXT
	ENDIF
	
		\ PRINT (&1B70-P%), "bytes free at",~P%
        \ P% must = &1B70 here
		IF P% <> &1B70 
		     PRINT "WARNING: P% out by",P%-&1B70, "bytes at", ~P%
		ENDIF
		
.L1B70  EQUB    $00,$00,$00,$00,$14,$00,$00,$00    \ Label added by iainfm - hit pigeon
        EQUB    $00,$05,$00,$28,$00,$01,$00,$14
        EQUB    $00,$00,$00,$28,$14,$00,$00,$00
		
.L1BB8  EQUB    $00,$00,$3C,$1E,$01,$00,$00,$00    \ Pigeon R-L 1
        EQUB    $00,$00,$00,$3C,$3C,$38,$3C,$14
        EQUB    $00,$00,$00,$28,$3C,$00,$00,$00
		
.L1BD0  EQUB    $00,$00,$3C,$1E,$01,$00,$00,$00    \ Pigeon R-L L2
        EQUB    $00,$00,$00,$3C,$3C,$38,$14,$00
        EQUB    $00,$00,$00,$28,$3C,$00,$28,$00
		
.L1BE8  EQUB    $00,$00,$3C,$1E,$01,$00,$00,$00    \ Pigeon R-L 3
        EQUB    $00,$00,$00,$3C,$16,$00,$00,$00
        EQUB    $00,$00,$00,$28,$3C,$00,$00,$00
		
        EQUB    $00,$00,$3C,$1E,$01,$00,$00,$00    \ Pigeon R-L 4
        EQUB    $00,$3C,$38,$3C,$16,$00,$00,$00
        EQUB    $00,$00,$00,$00,$28,$3C,$00,$00
		
        EQUB    $00,$00,$3C,$1E,$01,$00,$00,$00    \ Pigeon R-L 5
        EQUB    $14,$3C,$38,$3C,$16,$00,$00,$00
        EQUB    $28,$00,$00,$00,$28,$3C,$00,$00
		
.L1C00  EQUB    $3C,$38,$38,$38,$38,$38,$3C,$10    \ Number 0 label added by iainfm
        EQUB    $38,$38,$38,$38,$38,$38,$38,$30
.L1C10  EQUB    $14,$3C,$34,$14,$14,$14,$3C,$10    \ Number 1
        EQUB    $20,$20,$20,$20,$20,$20,$38,$30
		
.L1C20  EQUB    $3C,$30,$00,$3C,$38,$28,$3C,$10    \ Number 2
        EQUB    $38,$38,$38,$38,$30,$00,$28,$30
.L1C30  EQUB    $3C,$30,$00,$3C,$30,$00,$3C,$10    \ Number 3
        EQUB    $38,$38,$38,$38,$38,$38,$38,$30
		
.L1C40  EQUB    $38,$38,$38,$3C,$10,$00,$00,$00    \ Number 4
        EQUB    $38,$38,$38,$38,$38,$38,$38,$30
        EQUB    $3C,$38,$28,$3C,$10,$00,$3C,$10    \ Number 5
        EQUB    $38,$30,$00,$38,$38,$38,$38,$30
		
.L1C60  EQUB    $3C,$38,$28,$3C,$38,$28,$3C,$10    \ Number 6
        EQUB    $38,$30,$00,$28,$38,$38,$38,$30
        EQUB    $3C,$30,$00,$14,$14,$14,$14,$10    \ Number 7
        EQUB    $38,$38,$38,$30,$20,$20,$20,$20
		
.L1C80  EQUB    $3C,$38,$28,$3C,$38,$28,$3C,$10    \ Number 8
        EQUB    $38,$38,$38,$38,$38,$38,$38,$30
        EQUB    $3C,$38,$28,$3C,$10,$00,$3C,$10    \ Number 9
        EQUB    $38,$38,$38,$38,$38,$38,$38,$30
		
.L1CA0  EQUB    $00,$00,$00,$00,$00,$00,$00,$00    \ Tree top
        EQUB    $00,$00,$04,$00,$0C,$00,$04,$0C
        EQUB    $08,$08,$06,$08,$06,$0C,$06,$06
        EQUB    $00,$00,$00,$00,$08,$00,$00,$08
		
.L1CC0  EQUB    $00,$04,$08,$04,$00,$00,$08,$04    \ Tree middle
        EQUB    $0C,$04,$08,$0C,$02,$04,$0C,$08
        EQUB    $06,$0C,$06,$08,$06,$06,$0C,$06
        EQUB    $08,$04,$08,$0C,$00,$08,$04,$08
		
.L1CE0  EQUB    $00,$04,$00,$00,$00,$00,$08,$04    \ Tree base
        EQUB    $08,$09,$04,$00,$00,$08,$08,$0C
        EQUB    $02,$0C,$02,$02,$02,$02,$02,$07
        EQUB    $08,$04,$00,$00,$04,$04,$01,$09
		
.L1D00  EQUB    $15,$01,$09,$06,$09,$06,$09,$06    \ 1st House roof
        EQUB    $00,$00,$09,$06,$09,$06,$09,$06
        EQUB    $00,$00,$09,$06,$09,$06,$09,$06
        EQUB    $00,$00,$09,$06,$09,$06,$09,$06
		
.L1D20  EQUB    $00,$00,$00,$07,$08,$06,$09,$06    \ 2nd House roof
        EQUB    $00,$00,$00,$0F,$20,$0F,$08,$02
        EQUB    $00,$00,$00,$05,$00,$0E,$01,$0E
        EQUB    $00,$00,$01,$0E,$09,$06,$09,$06

.L1D40  \ Screen memory locations
        EQUB    $31,$7A,$D9,$7C,$C9,$77,$12,$7A   \ Gravestone locations
        EQUB    $C8,$7C
		EQUB    $BA,$77,$51,$7A,$B8,$7C           \ Unknown - unused player graves?
        EQUB    $20,$7A,$42,$7A

.unused_L1D54   \ Unused?
        EQUB    $00

.timer_L1D55    \ Only used for the screen flash timer, I think.
        EQUB    $00

.L1D56  \ Something to do with lives(?)
        EQUB    $00

.L1D57
        EQUB    $00

.L1D58
        EQUB    $00

.L1D59
        EQUB    $00

.L1D5A
        EQUB    $00

.L1D5B  \ Enemy kill counter (x2)
        EQUB    $00

.level  \ L1D5C \ Current level
        EQUB    $00

.L1D5D  \ Game data?
        EQUB    $00,$00,$00

\ .test   NOP
		
.L1D60  \ Building features
        EQUB    $28,$3C,$0D,$2D,$2D,$0D,$3C,$2C    \ Castle clock
        EQUB    $28,$0F,$31,$31,$35,$30,$1A,$0F
        EQUB    $28,$0F,$30,$30,$33,$30,$25,$1E
        EQUB    $34,$1C,$1E,$0E,$36,$1E,$2C,$1C
		
.L1D80  EQUB    $3C,$1C,$2C,$3C,$34,$1C,$2C,$1C    \ Castle tower
        EQUB    $1C,$3C,$28,$20,$28,$0C,$3C,$34
        EQUB    $34,$2C,$2C,$1C,$3C,$38,$3C,$1C
        EQUB    $1C,$2C,$3C,$34,$2C,$3C,$1C,$2C
		
.L1DA0  EQUB    $3C,$38,$2C,$1C,$2C,$38,$1C,$38    \ Castle/house door
        EQUB    $2C,$1C,$39,$33,$33,$27,$33,$33
        EQUB    $3C,$38,$14,$11,$11,$11,$11,$11
        EQUB    $1C,$1C,$2C,$24,$3C,$2C,$1C,$1C
		
.L1DC0  EQUB    $20,$35,$30,$20,$20,$30,$30,$18    \ Blue house LH wall
        EQUB    $38,$10,$30,$10,$38,$30,$30,$18
        EQUB    $3A,$10,$30,$10,$10,$30,$1A,$1A
        EQUB    $3D,$00,$30,$30,$28,$00,$30,$30
        
.L1DE0  EQUB    $20,$20,$30,$30,$20,$20,$30,$30    \ Blue house RH wall
        EQUB    $04,$04,$0D,$24,$30,$38,$30,$18
        EQUB    $04,$08,$00,$00,$20,$20,$30,$30
        EQUB    $00,$08,$04,$04,$30,$3A,$30,$30


.game   \L1E00
        \ Game can be run by starting execution here

        LDA     #$C8                        \ Read/write escape/break effect
        LDX     #$03                        \ esc disabled, memory clear on break
        LDY     #$00                        \ could be useful for debugging?
        JSR     osbyte

        JSR     L18C3                       \ No 'press space to play' message if RTS'd

        LDX     #$01
        LDA     #$04
        LDY     #$00
        JSR     osbyte                      \ Disable cursor editing

        LDA     osword_redirection_C        \ Get OSWORD indrection vector (low(?) byte - TBC)
        STA     wordv_1
        LDA     osword_redirection_D        \ Get OSWORD indirecton vector (high(?) byte - TBC)
        STA     wordv_2
.L1E21
        JSR     L1819                       \ Display title screen/high score/controls

        JSR     newGame                     \ Start game on spacebar from title screen

.gameLoop       \ L1E27    \ Main game loop
        IF ORIGINAL = TRUE
		    JSR L25B8
		ELSE
		    IF ENCHTS = TRUE
                JSR     rng        \ L25B8                       \ unknown, possibly pseudo random number generator?
            ELSE
			    JSR L25B8
	        ENDIF
        ENDIF
		
        JSR     vsyncWait                   \ Wait for vsync

        JSR     L2A94                       \ Enemy movement

        JSR     smc_L29F7                   \ Self modifying code - next enemy?

        JSR     smc_L286E                   \ Player movement? - either an RTS or JMP $28D3 (load skull sprite?) - changed by .L2245/.L22E2

        JSR     L28E2                       \ Bullet Y movement

        JSR     smc_L295E                   \ Player fire - either an RTS or JMP absolute

        JSR     L2C98                       \ Enemy bombs

        JSR     smc_L2C45                   \ Drop a bomb? - either an RTS or an LDA

        JSR     L240E                       \ Pigeon

        JSR     L2238                       \ Player hit detection

        JSR     L1FE0                       \ Gravestones plot / pigeon reset after hit

        JSR     keyCheck                    \ Keyboard scan

        JMP     gameLoop                    \ branch back around
        
        EQUS    "(c)A.E.Frigaard 1984 Hello!"

.newGame        \ L1E6C    \ Set up new game
        LDA     #$05       \ Used to calculate address locations of sound envelopes
        STA     L0070
        JSR     L2835      \ Define-envelope routine

        LDA     #$49       \ New game tune
        JSR     playTune

        LDA     #$16
        JSR     oswrch     \ VDU 22 (change mode)

        LDA     #$02
        JSR     oswrch     \ To mode 2

        LDA     #$00
        STA     L151A      
        STA     L008E
        STA     level                 \ Reset level
        STA     unused_L1D54          \ Unused? Perhaps not.
        STA     timer_L1D55           \ 'Lightning' effect timer
        STA     score_low_byte        \ Reset score
        STA     score_high_byte       \ Reset score
		
		IF ENRELO = TRUE
		    LDA #(L2F00 AND $FF)      \ Get address dynamically
			ENDIF
        STA     enemySpriteAddrLow    \ Reset enemey aircraft to level 1 biplane
		                              \ (This messes up relocation)
        CLC
        LDA     #$20
        STA     L2D79
		
        LDA     #$03     \ Lives? Possible memory address
        STA     L2D7A
        LDA     #$2A     \ Initial x position? Possible memory address
        STA     L2D7B
        LDA     #$02
        STA     L0071
		
		\ Zero page memory lookups
        \ LDA     #$2D \ L2D0A_high

		LDA     #L2D47 DIV 256 \ #HI(L2D47)
        STA     L008B    \ ($8B) = $472D (check)
        STA     L008D    \ ($8C) = $2D47
        STA     L0076    \ ($75) = $2D13
		
        \ LDA     #$47
		LDA     #L2D47 MOD 256 \ #LO(L2D47)
        STA     L008C    \ ($8C) = $2D47
        
		\ LDA     #$0A
		LDA     #L2D0A MOD 256 \ #LO(L2D0A)
        STA     L008A    \ ($8A) = $2D0A
        \ LDA     #$13
		LDA     #L2D13 MOD 256 \ #LO(L2D13)
        STA     L0075    \ ($75) = $2D13
		
        LDX     #$0F
        LDY     #$07

		
.L1EC6
        JSR     L281D    \ Set palette

        DEX
        CPX     #$07
        BNE     L1EC6

        STX     L007D
        LDA     #$03    \ Lives
        STA     L1D56
        LDA     #HI(L2F00)    \ #$2F                 
        STA     enemySpriteAddrHigh
        LDA     #$F0
        STA     useless
        LDA     #$00
        STA     L1A09    \ Part of the problem
.L1EE3
        JSR     L20B1

        STX     L2382
        INC     level    \ Increment level number
        LDA     L2D79
        CMP     #$0F
        BMI     L1F03

        LDA     level
        AND     #$01     \ Is level even?
        BEQ     L1F03    \ Yes, branch
		                 \ If not... (don't know why; reduces L2D79 by 2 every 2nd level)
        DEC     L2D79    \ Commenting these out gives a slightly different corruption
        DEC     L2D79
        DEC     useless
.L1F03
		\ The glitch/crash bug lies with the two INCs below
		\ To create a byte-for-byte original version leave them in and uncomment the NOPs
		\ To fix the bug comment out the INCs
		\ To fix the bug and maintain addresses consistent with the original comment the INCs and uncomment the NOPs
		\ This is all deprecated. See .zeroLoop (L1F2E)
		\ Now this is deprecated. .zeroLoop fix affects difficulty (# of enemy bombs)
		\ Need something that caps L1A09 to < = $19
		\ Probably need to jsr, do the deed and rts
		
		
		IF FIX = FALSE
            INC     L1A09      \ J'accuse! NOP this out (x3 to keep addresses consistent for fix) - Changed to NOPping the STA 24d7 out
            INC     L1A09      \ J'accuse! NOP this out (x3 to keep addresses consistent for fix) - Changed to NOPping the STA 24d7 out
        ELSE
		    JSR     gameFix    \ 3 bytes
			NOP:NOP:NOP
		ENDIF
		
		LDA     #$0C
        JSR     oswrch   \ Clear screen

        LDA     #$9A
        LDX     #$14
        JSR     osbyte   \ Write to Video ULA CPL and cursor width?

        JSR     L261A    \ Draw clouds - not culprit

        JSR     drawLineArt    \ Draw scenery - not culprit

        JSR     drawStave \ not culprit

        JSR     L2054

        LDA     #$00
        STA     L1D5B        \ Reset Ememy kill counter
        STA     gameFlags    \ Reset game flags
        STA     L2D7D        \ Reset Pigeon position
        LDY     #$54
		
.zeroLoop       \L1F2E
        STA     L2D0A,Y      \ Zero 2D0A to 2D5E (backwards)
        DEY
        BNE     zeroLoop
		LDA     L1A09        \ Restore 2D47
		\ Original fix removed from here
		STA     L2D47        \ NOPping this out will cure the code overwrite issue too, but no double-fire
		
        LDA     #$06
        STA     L2D0A
        LDA     #$1E         \ Probably not a memory pointer
        STA     L2D13
        LDA     #$30
        STA     L1D5A
        LDA     #$88
        STA     L1D59
        LDA     #$80
        STA     L1D57
        LDA     #$32
        STA     L1D58
        LDX     L1D56    \ Lives
.L1F5B
        JSR     L2223

        CLC
        LDA     L1D57
        ADC     #$18
        STA     L1D57
        DEX
        BNE     L1F5B

        LDA     #$3A
        STA     L0081
        LDA     #$81
        STA     L0082   \ need changing to #LO(something)?
        LDX     #$01
        LDY     #$08
.L1F76
        LDA     #$81
        STA     L2D13,X
        INX
        TYA
        CLC
        ADC     #$50
        STA     L2D13,X
        TAY
        INX
        LDA     L0081
        ADC     #$00
        STA     L2D13,X
        STA     L0081
        CLC
        INX
        LDA     L0082
        ADC     #$0A
        STA     L0082
        STA     L2D13,X
        INX
        LDA     #$D0
        STA     L2D13,X
        INX
        CPX     #$1F
        BMI     L1F76

        LDY     #$00
        LDA     (L0075),Y
        STA     L0070
.L1FAA
        INY
        INY
        LDA     (L0075),Y
        STA     L0078
        INY
        LDA     (L0075),Y
        STA     L0079
        JSR     L2C08

        INY
        INY
        CPY     L0070
        BMI     L1FAA

        JSR     L22E2

.L1FC1
        LDA     #$20
        STA     playerXpos
        LDA     #$7E
        STA     L0087
        LDA     #$90
        STA     L0086
        LDA     #HI(L2358) \ $23       \ Memory reference - player sprite pointer
        STA     L28D7
        LDA     #LO(L2358) \ $58       \ Memory reference - player sprite pointer
        STA     L28D6
        JSR     L28D3

        LDA     #$40       \ Begin level tune
        JMP     playTune

.L1FE0
        LDA     gameFlags
        BEQ     L2054     \ Zero? Skip to L2054

        SED
        AND     #$02      \ Bit 2 set?
        BEQ     L1FFE     \ Skip to L1FFE

        CLC
        LDA     #$15
        ADC     score_low_byte
        STA     score_low_byte
        LDA     score_high_byte
        ADC     #$00
        STA     score_high_byte
        JSR     L258D

.L1FFE
        LDA     #$40
        BIT     gameFlags
        BEQ     L2021

        CLC
        LDA     #$01
        ADC     score_low_byte
        STA     score_low_byte
        LDA     score_high_byte
        ADC     #$00
        STA     score_high_byte
        CLD
        LDX     #$B7
        LDY     #$15
        LDA     #$07
        JSR     osword        \ Play a sound (plane winged?)

        SED
.L2021
        LDA     #$10		  \ Pigeon hit - add a note to the stave
        BIT     gameFlags
        BEQ     L2042

        CLC
        LDA     #$0A
        ADC     score_low_byte    \ Wing hit - 10 points
        STA     score_low_byte
        LDA     score_high_byte
        ADC     #$00              \ Add carry to high byte
        STA     score_high_byte
        CLD
        JSR     L20DE

        BNE     L2042

        JSR     L153E

.L2042
        CLD
        JSR     L14EB

        LDA     gameFlags
        BPL     L204E   \ Bit 8 clear? Skip to reset game flag

        JMP     nextLevel   \ Next level

.L204E
        LDA     #$00    \ Reset game flag
        STA     gameFlags
        RTS

.L2054
        LDA     #$34    \ Score screen memory location high byte
        STA     L0081
        LDA     #$B0    \ Score screen memory location low byte
        STA     L0080
        LDA     #HI(L1C00)  \ $1C    \ Possible memory reference (score digits pointer)
        STA     L0083
        LDA     #$F0
        AND     score_high_byte
        JSR     L285A

        LDA     #$0F
        AND     score_high_byte
        ASL     A
        ASL     A
        ASL     A
        ASL     A
        JSR     L285A

        LDA     #$F0
        AND     score_low_byte
        JSR     L285A

        LDA     #$0F
        AND     score_low_byte
        ASL     A
        ASL     A
        ASL     A
        ASL     A
        JSR     L285A

        LDA     #$00
        JMP     L285A

.L208D                       \ aka ($8A),#0
        STA     L1A0A
        TYA
        PHA
.L2092
        JSR     vsyncWait

        DEC     L1A0A
        BNE     L2092

        PLA
        TAY
        RTS

.nextLevel      \ L209D
        LDA     #$00
        STA     gameFlags    \ Reset gameFlags to zero
        CLC
        LDA     enemySpriteAddrLow        \ Enemy sprite address
        ADC     #$40                      \ Add $40 to get new aircraft
        STA     enemySpriteAddrLow        \ Store it back
		                                  \ Need an adc on the high byte here eventually
        LDA     #$64
        JSR     L208D

        JMP     L1EE3

.L20B1
        LDA     #$03
        AND     level
        TAX
        BNE     L20BC

        LDA     #$33
        RTS

.L20BC
        DEX
        BNE     L20C3

        TXA
        LDX     #$0D
        RTS

.L20C3	
        DEX
        BNE     L20CB

        LDA     #$11
        LDX     #$1A
        RTS

.L20CB
        LDA     #$22
        LDX     #$26
        RTS

.L20D0
        LDA     L007D
        BPL     L20DA

        LDA     L0080
        EOR     #$C0
        STA     L0080
.L20DA
        LDA     L2D79
        RTS

.L20DE
        INC     L2382
        LDY     L2382
        LDA     L2382,Y
        STA     L0070
        AND     #$0E
        CMP     #$08
        BPL     L20F9

        CLC
        ADC     L1D59
        STA     L0080
        LDA     #$00
        BEQ     L2103

.L20F9
        CLC
        ADC     L1D59
        ADC     #$78
        STA     L0080
        LDA     #$02
.L2103
        ADC     L1D5A
        STA     L0081
        LDA     #HI(L2300)    \ #$23     \ Note sprite pointer
        STA     L0083
        JSR     L213E

        CLC
        LDA     L1D59
        ADC     #$20
        STA     L1D59
        BCC     L211D

        INC     L1D5A    \ Deal with page boundaries
.L211D
        JSR     L2172

        CLC
        LDA     L0080
        ADC     #$08
        STA     L0080
        BCC     L212B

        INC     L0081    \ Deal with page boundaries
.L212B
        CLC
        LDA     L0082
        ADC     #$08     \ Note sprite offset
        STA     L0082    \ Score sprite pointer low byte
        BCC     L2136

        INC     L0083    \ Deal with page boundaries
.L2136
        JSR     L2172

        INY
        LDA     L2382,Y
        RTS

.L213E
        LDA     #$80
        BIT     L0070
        BEQ     L2149

        LDA     #LO(L1C00) \ $00   \ Number 0 sprite
        STA     L0082
        RTS

.L2149
        LSR     A
        BIT     L0070
        BEQ     L2153

        LDA     #LO(L1C10) \ #$10
        STA     L0082  \ Number 1 sprite
        RTS

.L2153
        LSR     A
        BIT     L0070
        BEQ     L215D

        LDA     #LO(L1C20) \ #$20
        STA     L0082  \ Number 2 sprite
        RTS

.L215D	\ Something to do with the plotting of dots on the stave
        LSR     A
        BIT     L0070
        BEQ     L2167

        LDA     #LO(L1C30) \ #$30
        STA     L0082  \ Number 3 sprite
        RTS

.L2167
        LDA     #$01
        BIT     L0070
        BEQ     L2171

        LDA     #LO(L1C40) \ #$40   \ Number 4 sprite
        STA     L0082
.L2171
        RTS

.L2172  \ Possibly something to do with pigeon hit
        TYA
        PHA
        LDY     #$07
        CLC
        LDA     L0080
        ADC     #$78
        STA     L0084
        LDA     L0081
        ADC     #$02
        STA     L0085
        LDA     L0080
        AND     #$07
        EOR     #$07
        STA     L0074
        CMP     #$07
        BPL     L219A

.L218F
        LDA     (L0082),Y
        ORA     (L0084),Y
        STA     (L0084),Y    \ Draw note top(?) half
        DEY
        CPY     L0074
        BNE     L218F

.L219A  \ not the culprit
        LDA     (L0082),Y
        ORA     (L0080),Y
        STA     (L0080),Y    \ Draw note bottom(?) half
        DEY
        BPL     L219A

        PLA
        TAY
        RTS

.playTune       \ L21A6  \ Sound routines (start of level chimes, bonus tunes etc); not the culprit
        STA     L0070
		
.playTuneLoop   \ L21A8
        \ Sound player routine 
        LDY     L0070
        LDA     L23B2,Y
        BEQ     holdLoop
        STA     L2DFC
        INY
        LDA     L23B2,Y
        STA     L2DFE
        LDX     #$F8
        LDY     #$2D
        LDA     #$07
        JSR     osword        \ Play a sound
        INC     L0070
        INC     L0070
        JMP     playTuneLoop

.holdLoop       \ L21C9       \ Wait for tune to (almost) finish?
        LDA     #$80
        LDX     #$FA          \ Sound channel 1
        JSR     osbyte        \ Read ADC channel or get buffer status
        CPX     #$0F
        BMI     holdLoop
        RTS

.keyboardScan                 \ .L21D5
        LDA     #$81          \ X = (CC, AE, EF)
        LDY     #$FF          \     ( R,  S,  Q)
        JSR     osbyte        \ keyboard scan (Y=$FF)

        INX                   \ return X=0 if scanned key pressed (for BEQ)
        RTS

        EQUB    $E8,$60       \ could be INX : RTS? Don't think it will ever execute though
		EQUB    $00,$00,$00,$00,$00,$00
        EQUB    $00,$00,$00,$00,$00,$00,$00,$00

.drawStave      \ Draw stave    \ L21EE
        LDY     #$00

.staveLoop1     \ L21F0
        LDA     staveData,Y
        JSR     oswrch
        INY
        CPY     #$09
        BNE     staveLoop1
        LDX     #$05

.staveLoop2     \ L21FD
        LDY     #$09

.staveLoop3     \ L21FF
        LDA     staveData,Y
        JSR     oswrch
        INY
        CPY     #$15
        BNE     staveLoop3
        DEX
        BNE     staveLoop2
        RTS

.staveData      \ L220E
        EQUB    $12,$00,$04,$19,$04,$00,$01,$EC
        EQUB    $03,$19,$01,$00,$03,$00,$00,$19
        EQUB    $00,$00,$FD,$F0,$FF

.L2223  \ not the culprit - load player lives address
        LDA     #LO(L1910) \ #$10
        STA     L0082
        LDA     #HI(L1910) \ #$19
        STA     L0083
        LDA     L1D57
        STA     L0080
        LDA     L1D58
        STA     L0081
        JMP     L2581

.L2238                          \ Death-check
        LDA     #$20            \ Change to RTS for invincibility
        BIT     gameFlags
        BNE     L2245

        LDA     timer_L1D55
        BNE     L2278

.L2244
        RTS

.L2245
        LDX     #$00
        LDY     #$07
        JSR     L281D          \ Flash screen white when player hit

        LDA     #$07
        LDY     #$2D
        LDX     #$E0
        JSR     osword         \ Play a sound (player hit / lightning)

        LDA     #$FF
        STA     timer_L1D55
		
		\ Self-modifying code section
        LDA     #$60           \ RTS opcode
        STA     smc_L2C45
        STA     smc_L29F7
        STA     smc_L286E
        STA     smc_L295E
        JSR     L28D3

        LDA     #HI(L1A10) \#$1A     \ Memory reference (lost life sprite 1)
        STA     L28D7
        LDA     #LO(L1A10) \#$10     \ Memory reference (lost life sprite 1)
        STA     L28D6
        JMP     L28D3

.L2278
        DEC     timer_L1D55    \ Screen flash timer
        LDA     timer_L1D55
        CMP     #$FE
        BNE     L2289

        LDX     #$00
        LDY     #$00
        JMP     L281D    \ Unflash screen

.L2289
        CMP     #$DC
        BNE     L2298

        JSR     L28D3

        LDA     #LO(L1A38) \ #$38    \ Memory reference (lost life sprite 2)
        STA     L28D6
        JMP     L28D3

.L2298
        CMP     #$8C
        BNE     L22A7

        JSR     L28D3

        LDA     #LO(L1A60) \ #$60    \ Memory reference (Skull sprite)
        STA     L28D6
        JMP     L28D3

.L22A7
        CMP     #$01
        BNE     L2244

        DEC     L1D56
        BNE     L22B3

        JMP     gameOver

.L22B3
        JSR     L28D3

        JSR     L1FC1

        LDY     L2D13
.L22BC
        LDA     (L0075),Y
        CMP     #$C0
        BNE     L22DB

        DEY
        LDA     (L0075),Y
        BPL     L22DC

        EOR     #$80
        STA     (L0075),Y
        DEY
        LDA     (L0075),Y
        STA     L0079
        DEY
        LDA     (L0075),Y
        STA     L0078
        JSR     L2C08

        JMP     L22DE

.L22DB
        DEY
.L22DC
        DEY
        DEY
.L22DE
        DEY
        DEY
        BNE     L22BC

.L22E2  \ Self-modifying code calls
        LDA     #$20        \ JSR opcode
        STA     smc_L286E
        LDA     #$A5        \ LDA zeropage opcode
        STA     smc_L29F7
        LDA     #$A9        \ LDA# opcode
        STA     smc_L2C45
        STA     smc_L295E
        SEC
        LDA     L1D57
        SBC     #$18
        STA     L1D57
        JMP     L2223

.L2300  \ $2300 Musical notes and other sprites
        EQUB    $00,$00,$00,$00,$00,$14,$3C,$3C    \ Crotchet
        EQUB    $38,$38,$38,$38,$38,$38,$38,$20
		
.L2310  EQUB    $00,$00,$00,$00,$00,$14,$38,$3C    \ Minim
        EQUB    $38,$38,$38,$38,$38,$38,$38,$00
		
.L2320  EQUB    $00,$00,$00,$00,$00,$14,$38,$3C    \ Semibreve
        EQUB    $00,$00,$00,$00,$00,$38,$38,$20
		
.L2330  EQUB    $00,$00,$00,$00,$00,$38,$38,$30    \ Dot
        EQUB    $00,$00,$00,$00,$00,$00,$00,$00
		
.L2340  EQUB    $00,$00,$00,$00,$00,$3C,$3C,$10    \ Rest
        EQUB    $00,$00,$00,$00,$00,$38,$38,$30
		
.L2350  EQUB    $01,$04,$04,$01,$01,$01,$00,$00    \ Enemy bomb
		
.L2358  EQUB    $00,$04,$04,$04,$2C,$04,$04,$04    \ Player sprite label added by iainfm
        EQUB    $00,$00,$00,$14,$3C,$14,$14,$00		
        EQUB    $28,$28,$28,$3D,$3E,$3E,$3C,$28    
        EQUB    $00,$04,$04,$04,$2C,$04,$04,$04
        EQUB    $00,$00,$00,$00,$28,$00,$00,$00
		
        EQUB    $00,$00

.L2382
        EQUB    $0D,$4A,$18,$8C,$8E,$1C,$8A,$84
        EQUB    $14,$82,$20,$44,$05,$00,$48,$18
        EQUB    $86,$84,$14,$86,$84,$14,$88,$2A
        EQUB    $4E,$05,$00,$4A,$18,$8C,$8E,$1C
        EQUB    $8A,$84,$14,$82,$20,$44,$00,$44
        EQUB    $42,$42,$44,$46,$24,$14,$05,$00

.L23B2
		\ Start of level / bonus tunes
        EQUB    $65,$17,$5D,$05,$59,$0A,$65,$05
        EQUB    $79,$0A,$81,$05,$89,$1E,$79,$1E
        EQUB    $00,$6D,$17,$75,$05,$79,$0A,$75
        EQUB    $05,$79,$0A,$6D,$05,$65,$1E,$59
        EQUB    $1E,$00,$65,$17,$5D,$05,$59,$0A
        EQUB    $65,$05,$79,$0A,$81,$05,$89,$1E
        EQUB    $79,$0F,$00,$79,$0F,$81,$0F,$81
        EQUB    $0F,$79,$0F,$75,$0F,$79,$1E,$00
        EQUB    $59,$05,$59,$05,$59,$05,$49,$0F
        EQUB    $00,$41,$05,$35,$0A,$39,$05,$3D
        EQUB    $05,$41,$05,$65,$0A,$65,$0A,$55
        EQUB    $14,$00,$14,$00

.L240E
        LDA     #HI(L1BB8)    \ #$1B     \ Pigeon sprite memory pointer
L240F = L240E+1          \ SMC - $1A = L-R $1B = R-L
        STA     L0083
        LDA     L2D7D
        BNE     L248E

        LDA     #$42
        BIT     gameFlags
        BEQ     L248D

        LDA     #$02
        BIT     L02FC
        BEQ     L2444
		
        \ Wing hit? Send R-L pigeon
        LDA     #HI(L1BB8)    \ #$1B     \ Pigeon R-L sprite pointer
        STA     L0083
        STA     L240F    \ self-modifying code
        LDA     #$68
        STA     L2D7C
        STA     L0080
        LDA     #$00     \ Pigeon end position?
        STA     L252F
        LDA     #$4C
        STA     L2D7F
        LDA     #$4B
        STA     L246C
        BNE     L245F

.L2444  \ Wing hit? Send L-R pigeon
        LDA     #HI(L1A88)    \ #$1A     \ Pigeon L-R sprite pointer
        STA     L0083    \ need changing to #HI(something) (done)
        STA     L240F
        LDA     #$00
        STA     L2D7C
        STA     L0080
        STA     L2D7F
        LDA     #$4C    \ Pigeon end position?
        STA     L252F
        LDA     #$49
        STA     L246C
.L245F
        LDA     #$00
        STA     L007C
        INC     L02FC
        LDA     #$07
        AND     L007D
        TAX
.L246B
        LDA     #$4B
L246C = L246B+1
        CLC
.L246E
        ADC     #$05
        TAY
        LDA     L007C
        ADC     #$10
        STA     L007C
        TYA
        DEX
        BPL     L246E

        STA     L2D7D
        STA     L0081
        LDX     #$02
        STX     L2D7E
        LDA     L2D68,X
        STA     L0082     \ ooft
        JMP     L2581

.L248D
        RTS

.L248E
        LDA     L2D7C
        STA     L0080
        LDA     L2D7D
        STA     L0081
        BPL     L24B2

        DEC     L2D7E
        BNE     L248D

        EOR     #$80
        STA     L0081
        LDA     #$10
        ORA     gameFlags
        STA     gameFlags
        LDA     #$00
        STA     L2D7D
        BEQ     L24FE

.L24B2
        LDA     L2D7E
        AND     #$7F
        TAX
        LDA     L2D68,X
        STA     L0082     \ ooft
        LDY     #$00
        LDA     (L008A),Y
        STA     L0070
.L24C3
        INY
        LDA     (L008A),Y
        SEC
        SBC     L007C
        BMI     L2517

        CMP     #$07
        BPL     L2517

        INY
        INY
        LDA     (L008A),Y
        BEQ     L2519

        INY
        LDA     (L008A),Y
        SEC
        SBC     L2D7F
        BMI     L251A

        CMP     #$03
        BPL     L251A

        LDA     #$E8
        STA     (L008A),Y
        TAX
        LDA     #$07
        LDY     #$2D
        JSR     osword        \ Play a sound (pigeon hit)

        LDA     #$10
        STA     L2D7E
        LDA     #$80
        ORA     L2D7D
        STA     L2D7D
        JSR     L2581

.L24FE  \ hit pigeon sprite plot
        LDA     #HI(L1B70) \ #$1B    \ Possible memory address
        STA     L0083
        LDA     #LO(L1B70) \ #$70    \ Possible memory address
        STA     L0082
        JMP     L2581

.L2509
        LDA     #$04
        ORA     gameFlags
        STA     gameFlags
        LDA     #$00
        STA     L2D7D
.L2516
        RTS

.L2517
        INY
        INY
.L2519
        INY
.L251A
        CPY     L0070
        BMI     L24C3

        LDA     #$80
        EOR     L2D7E
        STA     L2D7E
        BMI     L2516

        JSR     L2581

        LDA     L2D7F
.L252E
        CMP     #$00
L252F = L252E+1               \ SMC?
        BEQ     L2509

        AND     #$1F
        BNE     L253F

        LDA     #$07
        LDY     #$2D
        LDX     #$F0
        JSR     osword        \ Play a sound (pigeon chirp...just like pigeons do (no pun intended))

.L253F
        LDX     L2D7E
        DEX
        BPL     L2547

        LDX     #$07
.L2547
        STX     L2D7E
        LDA     L2D68,X
        STA     L0082    \ ooft
        LDA     L252F
        BEQ     L256C

        INC     L2D7F
        CLC
        LDA     L2D7C
        ADC     #$08
        STA     L2D7C
        STA     L0080
        BCC     L2581

        INC     L2D7D
        INC     L0081
        JMP     L2581

.L256C
        DEC     L2D7F
        SEC
        LDA     L2D7C
        SBC     #$08
        STA     L2D7C
        STA     L0080
        BCS     L2581

        DEC     L2D7D
        DEC     L0081
.L2581
        LDY     #$17
.L2583 \ not the culprit
        LDA     (L0082),Y
        EOR     (L0080),Y
        STA     (L0080),Y    \ Draw pigeon
        DEY
        BPL     L2583

        RTS

.L258D
        LDY     L1D5B
        CPY     #$09
        BPL     L25B7

        LDA     L1D40,Y
        STA     L0080
        INY
        LDA     L1D40,Y
        STA     L0081
        INY
        STY     L1D5B
        LDY     #$04
        LDA     #$55
.L25A7  \ not the culprit
        STA     (L0080),Y    \ Draw gravestone element
        DEY
        BPL     L25A7    \ not the culprit

        LDY     #$09
        ASL     A
        STA     (L0080),Y    \ Draw gravestone element
        LDY     #$01
        LDA     #$FF
        STA     (L0080),Y    \ Draw gravestone element
.L25B7
        RTS

.L25B8  \ Doesn't seem to do much other than ROL 7d/e/f. RNG?
        \ Candidate to move elsewhere and add enhancements to?
        LDA     L007D    \ 2 bytes
        AND     #$48     \ 2
        ADC     #$38     \ 2
        ASL     A        \ 1
        ASL     A        \ 1
        ROL     L007F    \ 3
        ROL     L007E    \ 3
        ROL     L007D    \ 3 \ Randomise pigeon height?
        LDA     L007D    \ 2 \ Why? - could probably save 2 bytes here.
        RTS              \ 1
                         \ 20 bytes total
						 
.drawLineArt        \ .L25 C9
        LDY     #$00
.drawLineArtLoop    \ .L25CB
        LDA     sceneryLineArt,Y
        JSR     oswrch

        INY
        BNE     drawLineArtLoop

        LDA     enemySpriteAddrLow
        STA     L0082
        LDA     enemySpriteAddrHigh
        STA     L0083
        LDA     #$1F    \ Something to do with scenery sprite plotting. Possible memory location
        STA     L2C1E
        LDA     #$E0    \ Possible memory location
        STA     L0070
        LDY     #$00
.L25E7
        INY
        LDX     L27C3,Y
        INY
        LDA     L27C3,Y
        BIT     L0070
        BNE     L25FF

        STA     enemySpriteAddrHigh
        STX     enemySpriteAddrLow
        INY
        LDX     L27C3,Y
        INY
        LDA     L27C3,Y
.L25FF
        STX     L0078
        STA     L0079
        JSR     L2C08

        CPY     L27C3
        BMI     L25E7

        LDA     #$3F
        STA     L2C1E
        LDA     L0082
        STA     enemySpriteAddrLow
        LDA     L0083
        STA     enemySpriteAddrHigh
        RTS

        EQUB    $00

.L261A
        LDA     #$44     \ screen memory - cloud start address
        STA     L0079
        LDA     #$FF
        LDX     #$05
.L2622
        LDY     #$00     \ screen memory - cloud start address
        STY     L0078
.L2626
        STA     (L0078),Y
        INY
        BNE     L2626

        INC     L0079
        DEX
        BNE     L2622

        LDY     #$1F
.L2632
        LDA     L2EE0,Y
        STA     (L0078),Y
        DEY
        BPL     L2632

        LDA     #HI(L2E20)    \ $2E    \ Possible memory reference - clouds was L2EE0
        STA     L007B
        LDA     #LO(L2E20)    \ #$20
        STA     L0078
        LDX     #$08
.L2644
        LDA     L2D5F,X
        STA     L007A
        LDY     #$3F
.L264B
        LDA     (L007A),Y
        STA     (L0078),Y
        DEY
        BPL     L264B

        CLC
        LDA     L0078
        ADC     #$40
        STA     L0078
        BCC     L265D

        INC     L0079
.L265D
        DEX
        BPL     L2644

        LDY     #$1F
.L2662
        LDA     L2EC0,Y
        STA     (L0078),Y
        DEY
        BPL     L2662

.L266A
        LDY     #$00
.L266C
        LDX     #$07
.L266E

        \ Cloud drawing routines? I think this maybe mirrors them top-to-bottom and/or left-to-right?
		
        LDA     L4900,Y
L266F = L266E+1            \ SMC - Cloud screen memory address
L2670 = L266E+2            \ SMC - Cloud screen memory address
.L2671
        STA     L4180,X
L2672 = L2671+1            \ SMC - Cloud screen memory address
L2673 = L2671+2            \ SMC - Cloud screen memory address
        INY
        DEX
        BPL     L266E

        CLC
        LDA     L2672
        ADC     #$08
        STA     L2672
        BCC     L2686

        INC     L2673
.L2686
        CPY     #$80
        BNE     L266C

        LDA     L266F
        EOR     #$80
        STA     L266F
        BMI     L2697

        INC     L2670
.L2697
        LDA     #$44
        CMP     L2673
        BNE     L266A

        STY     L2672
        INX
        STX     L266F
        LDA     #$49
        STA     L2670
        LDA     #$41
        STA     L2673
        RTS

.sceneryLineArt  \  .L26B0 Scenery line art VDU calls, used by .L25CB
        EQUB    $12,$00,$06,$19,$04,$00,$00,$13
        EQUB    $00,$19,$05,$04,$01,$17,$00,$19
        EQUB    $05,$2C,$01,$3C,$00,$19,$04,$7E
        EQUB    $04,$3E,$00,$19,$05,$1A,$04,$20
        EQUB    $00,$19,$05,$84,$03,$20,$00,$19
        EQUB    $05,$52,$03,$28,$00,$19,$05,$20
        EQUB    $03,$38,$00,$19,$05,$16,$03,$46
        EQUB    $00,$19,$05,$16,$03,$52,$00,$19
        EQUB    $05,$20,$03,$60,$00,$19,$05,$52
        EQUB    $03,$74,$00,$19,$05,$BB,$03,$7C
        EQUB    $00,$19,$04,$7E,$04,$42,$00,$19
        EQUB    $15,$1A,$04,$24,$00,$19,$15,$84
        EQUB    $03,$24,$00,$19,$15,$52,$03,$2C
        EQUB    $00,$19,$15,$20,$03,$3C,$00,$19
        EQUB    $04,$20,$03,$64,$00,$19,$15,$52
        EQUB    $03,$78,$00,$19,$15,$BB,$03,$80
        EQUB    $00,$12,$00,$02,$19,$04,$00,$05
        EQUB    $17,$00,$19,$05,$C4,$04,$28,$00
        EQUB    $19,$04,$E2,$04,$1C,$00,$19,$05
        EQUB    $DE,$03,$38,$00,$19,$04,$80,$02
        EQUB    $82,$00,$19,$05,$48,$03,$0E,$01
        EQUB    $19,$05,$AC,$03,$45,$01,$19,$05
        EQUB    $1A,$04,$4A,$01,$19,$05,$00,$05
        EQUB    $AE,$01,$19,$04,$2C,$01,$C8,$00
        EQUB    $19,$05,$8A,$02,$40,$01,$19,$05
        EQUB    $3E,$03,$04,$01,$19,$04,$F4,$01
        EQUB    $64,$00,$19,$05,$FA,$00,$DC,$00
        EQUB    $19,$05,$8C,$00,$54,$01,$19,$05
        EQUB    $00,$00,$68,$01,$12,$00,$04,$19
        EQUB    $04,$9E,$02,$96,$00,$19,$15,$F4
        EQUB    $01,$78,$00,$19,$05,$58,$02,$64
        EQUB    $00,$19,$05,$90,$01,$5A,$00,$00
		
.L27B0  EQUB    $7D,$2D,$20,$13    \ label added by iainfm. Seems unused
		
		EQUB    $28,$A9,$09,$85    \ might be some code in here
        EQUB    $83,$A9,$F0,$85,$82,$4C,$13,$28
		
		
        EQUB    $A9,$00,$8D

.L27C3  
        EQUB    $58
		EQUW    L1CA0    \ EQUB    $A0,$1C         \ Tree top
		EQUB    $93,$73,$49,$71,$60                \ Screen memory plot locations
        EQUB    $76,$99,$75,$44,$73,$C9,$78,$B4
        EQUB    $76
		EQUW    L1CC0    \ EQUB $C0,$1C            \ Tree middle
		EQUB    $13,$76,$93,$78,$C9
        EQUB    $73,$49,$76,$E0,$78,$44,$78,$C4
        EQUB    $75
		EQUW    L1CE0    \ EQUB    $E0,$1C         \ Tree middle
		EQUB    $13,$7B,$4A,$7B,$60
        EQUB    $7B,$C4,$7A
		EQUW    L1D00    \ EQUB    $00,$1D         \ 1st house roof
		EQUB    $B0,$78,$20
        EQUB    $78,$5C,$78
		EQUW    L1D20    \ EQUB    $20,$1D         \ 2nd house roof
		EQUB    $00,$78,$88
        EQUB    $76
		EQUW    L1D60    \ EQUB    $60,$1D         \ Castle clock
		EQUB    $60,$70
		
.L2800  EQUW    L1D80    \ EQUB    $80,$1D         \ Castle tower
        EQUB    $E0
        EQUB    $72,$60,$75,$E0,$77,$80,$7A,$A0
        EQUB    $7A,$DC,$7A
		EQUW    L1DA0    \ EQUB    $A0,$1D         \ Castle/house door
		EQUB    $60,$7A,$30
        EQUB    $7B
		EQUW    L1DC0    \ EQUB    $C0,$1D         \ Blue house LH wall
		EQUB    $08,$79
		EQUW    L1DE0    \ EQUB    $E0,$1D         \ Blue house RH wall
		EQUB    $28
        EQUB    $79,$00

.L281D  \ PLOT X, Y, 00 ?
        LDA     #$13
        JSR     oswrch

        TXA
        JSR     oswrch

        TYA
        JSR     oswrch

        LDA     #$00
        JSR     oswrch

        JSR     oswrch

        JMP     oswrch    \ with implied RTS

.L2835  \ Define envelopes
        \ Need to recode this for relocation
		\ Memory locations used (in order) are:
		\ $2DC0, $2DB0, $2DA0, $2D90, $2D80
		\ (AddressLO = (A * 16) + $70) (5 >= A > 0)  
		\ (AddressHI = $2D)
            LDA     L0070     \ A = 5
            ASL     A         \ A = 5 * 2
            ASL     A         \ * 2
            ASL     A         \ * 2
            ASL     A         \ * 2
            ADC     #LO(L2D80 - &10) \ #$70      \ + $70 (112)
            TAX               \ If A was 5 on entry, X is now $C0
            LDA     #$08
            LDY     #HI(L2D80 - &10) \#$2D          \ Memory HI address
		IF TEST = TRUE
			BCC     pageOK
			INY
		ENDIF
.pageOK     JSR     osword        \ Define an envelope
            DEC     L0070
            BNE     L2835
        RTS

.vsyncWait      \ L284A
        LDA     #$02          \ https://tobylobster.github.io/mos/mos/S-s3.html
        STA     LFE4E         \ Enable vsync interrupt
		
.vsyncLoop      \ L284F
        BIT     LFE4D
        BEQ     vsyncLoop     \ Wait for vsync

        LDA     #$82
        STA     LFE4E         \ Disable vsync interrupt
        RTS

.L285A
        STA     L0082    \ ooft
        LDY     #$0F
.L285E  \ not the culprit
        LDA     (L0082),Y
        STA     (L0080),Y    \ Draw player score
        DEY
        BPL     L285E

        CLC
        LDA     L0080
        ADC     #$10    \ screen memory - score area?
        STA     L0080
        RTS

        BRK
.smc_L286E      \ ZX key processing
        RTS     \ but changes in code to &20 (JMP $28D3) .L2245/.L22E2
        EQUB    $D3,$28 \ address for JMP above

        LDA     #$81      \ .L2871
        LDY     #$FF
        LDX     #$BD      \ X key (INKEY value)
        JSR     osbyte    \ Keyboard scan
        INX
        BEQ     L289E     \ X pressed
        DEY
        LDX     #$9E      \ Z key (INKEY value)
        JSR     osbyte    \ Keyboard scan
        INX
        BNE     L28B4     \ Not Z
        LDX     playerXpos     \ $2D70     \ X pos?
        CPX     #$01           \ Player min X bound
        BEQ     L28B4
        DEX
        STX     playerXpos     \ $2D70
        SEC
        LDA     $86
        SBC     #$08
        STA     $86
        BCS     L28B4
        DEC     $87
        BCC     L28B4
.L289E  LDX     playerXpos     \ $2D70
        CPX     #$47           \ player max X bound
        BEQ     L28B4
        INX
        STX     playerXpos     \ $2D70
        CLC
        LDA     L0086          \ $86
        ADC     #$08
        STA     L0086          \ $86
        BCC     L28B4
        INC     L0087          \ $87
.L28B4  SEC
        LDA     #$00
        STA     L0078          \ $78
        LDY     #$24
.L28BB  LDA     (L0086),Y      \ $86
        BEQ     L28C1
        STA     L0078          \ $78
.L28C1  TYA
        SBC     #$08
        TAY
        BPL     L28BB
        LDA     L0078          \ $78
        BEQ     L28D3
        LDA     gameFlags  \ $2D76
        ORA     #$20
        STA     gameFlags  \ $2D76

.L28D3
        LDY     #$27
.L28D5
        LDA     L1A60,Y    \ Load skull sprite?
L28D6 = L28D5+1            \ SMC - player sprite / hit / skull
L28D7 = L28D5+2            \ SMC - player sprite / hit / skull
        BEQ     L28DE

        EOR     (L0086),Y
        STA     (L0086),Y
.L28DE
        DEY
        BPL     L28D5

        RTS

.L28E2
        LDY     #$00
        LDA     (L008A),Y
        STA     L0070
        LDA     L2D72
        STA     L0082
        LDA     bulletSprite
        STA     L0083
.L28F2
        INY
        LDA     (L008A),Y
        STA     L0077
        INY
        LDA     (L008A),Y
        STA     L0080
        INY
        LDA     (L008A),Y
        STA     L0081
        BNE     L290D

        INY
        LDA     #$FE
        AND     L0071
        STA     L0071
        JMP     L2947

.L290D
        INY
        JSR     L29C3

        LDA     (L008A),Y
        BPL     L291B

.L2915
        LDA     #$00
        STA     L0081
        BEQ     L2947

.L291B
        SEC
        LDA     #$07
        AND     L0080
        CMP     #$05
        BMI     L292D

        LDA     L0080
        SBC     #$05
        STA     L0080
        JMP     L2939

.L292D
        LDA     L0080
        SBC     #$7D
        STA     L0080
        LDA     L0081
        SBC     #$02
        STA     L0081
		
.L2939
        SEC
        LDA     L0077
        SBC     #$05
        STA     L0077
        CMP     #$02
        BEQ     L2915

        JSR     L29C3

.L2947  \ Player bullet plotting?
        DEY
        DEY
        DEY
        LDA     L0077
        STA     (L008A),Y
        INY
        LDA     L0080
        STA     (L008A),Y
        INY
        LDA     L0081
        STA     (L008A),Y
        INY
        CPY     L0070
        BMI     L28F2

        RTS

.smc_L295E      \ Check for fire press
        RTS     \ Changed in code to LDA# $01

.L295F
        EQUB    $01    \ for when smc_L295E changes to LDA 
		
.L2960  BIT     L0071  \ $71
        BNE     L2976
        LDA     #$81   
        LDY     #$FF
        LDX     #$B6   \ Return key (INKEY value)   
        JSR     osbyte \ Keyboard scan
        INX
        BEQ     L2977
        LDA     #$00
        STA     L14AD  \ $14AD
        RTS
                    
.L2976  RTS
                    
.L2977  JMP     L149C
        \ ADC     ($D0),Y
        \.L297C  SBC     $FFA0,Y
        
		\ L297D = L297C + 1	
        EQUB    $71,$D0,$F9  \ This may be code... but probably isn't. Never executes.


.L297D  LDY     #$FF

.L297F  INY
        INY
        INY
        INY
        LDA     (L008A),Y    \ $8A
        BNE     L297F
        DEY
        DEY
        LDA     #$9D
        STA     (L008A),Y    \ $8A
        INY
        SEC
        LDA     L0086        \ $86
        SBC     #$6E
        STA     (L008A),Y    \ $8A
        STA     L0080        \ $80
        INY
        LDA     L0087        \ $87
        SBC     #$02
        STA     (L008A),Y    \ $8A
        STA     L0081        \ $81
        INY
        LDA     playerXpos     \ $2D70
        CLC
        ADC     #$03
        STA     (L008A),Y    \ $8A
        JSR     L29C3
        LDA     #$03
        ORA     L0071        \ $71
        STA     L0071        \ $71
        LDA     #$01
        ORA     gameFlags      \ $2D76
        STA     gameFlags      \ $2D76
        LDA     #$07    
        LDY     #$2D
        LDX     #$D0
        JMP     osword    \ Play a sound (player fire)

.L29C3  \ Bullet plotting?    \ RTSing here prevents bug
        TYA     \ Y is high ($18) here when the bug hits (called from $2cbd)
        PHA
        LDY     #$05
        CLC
        LDA     L0080
        ADC     #$78
        STA     L0084    \ 
        LDA     L0081
        ADC     #$02
        STA     L0085
        LDA     L0080
        AND     #$07
        EOR     #$07
        STA     L0074
        CMP     #$05
        BPL     L29EB

.L29E0  \ Not the culprit...or is it?
        LDA     (L0082),Y
        EOR     (L0084),Y
        STA     (L0084),Y    \ B-Em at point of crash w/ wp on writes to $2852:
                             \ cpu core6502: 29E4: break on write to 2852, value=55
                             \ 29E4: 9184       STA (84),Y  >?
		                     \ A=55 X=01 Y=04 S=F8 P=     C PC=29E6
							 \ 0080 : D6 25 D4 25 4E 28 90 7E 80 2F 0A 2D 47 2D 00 8D
							 \
							 \ Continuing gives:
							 \ cpu core6502: 29E4: break on write to 2852, value=D0
                             \ 29E4: 9184       STA (84),Y  >r
							 \ A=D0 X=01 Y=04 S=F8 P=N    C PC=29E6
							 \ 0080 : D6 25 D6 25 4E 28 90 7E 80 2F 0A 2D 47 2D 00 8D
							 \
							 \ Continuing gives:
							 \ cpu core6502: 29EF: break on write to 2852, value=75
                             \ 29EF: 9180       STA (80),Y  >r
							 \ A=75 X=01 Y=02 S=F8 P=     C PC=29F1
							 \ 0080 : 50 28 D6 25 C8 2A 90 7E 80 2F 0A 2D 47 2D 00 8D
							 \
							 \ cpu core6502: 29EF: break on write to 2852, value=0
                             \ 29EF: 9180       STA (80),Y  >
							 \ A=00 X=01 Y=02 S=F8 P=    ZC PC=29F1
							 \ 0080 : 50 28 50 28 C8 2A 90 7E 80 2F 0A 2D 47 2D 00 8D
							 \
							 \ cpu core6502: 29EF: break on write to 2852, value=0
                             \ 29EF: 9180       STA (80),Y  >
							 \ A=00 X=01 Y=00 S=F8 P=    ZC PC=29F1
							 \ 0080 : 52 28 50 28 CA 2A 90 7E 80 2F 0A 2D 47 2D 00 8D
							 
							 \ cpu core6502: BRK at 2852
                             \ 2852: 00         BRK         >
							 
        DEY
        CPY     L0074
        BNE     L29E0

.L29EB  \ triggered when bomb dropped - smooth animation as per screen memory layout
        \ not the culprit, but is complicit (code address in $80)
        LDA     (L0082),Y
        EOR     (L0080),Y    \ Un-draw bomb?
        STA     (L0080),Y    \ Draw bomb
        DEY
        BPL     L29EB

        PLA
        TAY
        RTS

.smc_L29F7      \ Something to do with next enemy
        RTS     \ Changed to LDA (opcode $A5) zeropage by L22E2, back to RTS (opcode $60) by L2245

        EQUB    L0072    \ $72    \ zeropage address when .smc_L29F7 is an LDA
		
.L29F9  CMP     #$01
        BPL     L2A37
        DEC     L2D7A  \ $2D7A
        BNE     L2A37
        LDA     L2D7B  \ $2D7B
        STA     L2D7A  \ $2d7A
        LDA     L0070  \ $70
        JSR     L2CFA
        TAY
        SEC
.L2A0F  SBC     #$05
        BPL     L2A0F
        TAX
.L2A14  INY
        INX
        BNE     L2A14
        DEY
        LDA     (L0075),Y    \ $75
        BMI     L2A33
        LDY     L0070        \ $70
.L2A1F  DEY
        LDA     (L0075),Y    \ $75
        BMI     L2A33
        DEY
		DEY
		DEY
		DEY
        BNE     L2A1F
        LDA     #$80
        ORA     gameFlags    \ $2D76
        STA     gameFlags    \ $2D76
        RTS
                    
.L2A33  EOR     #$80
        STA     (L0075),Y    \ $75
.L2A37  RTS		
		
.L2A38  \ Enemy explosion
        LDA     L0077
        BEQ     L2A91

        LDX     #HI(L1910)   \ #$19
        STX     enemySpriteAddrHigh
        LDA     enemySpriteAddrLow
        PHA
        LDA     L0077
        CMP     #$15
        BNE     L2A53

        LDA     #LO(L2F40)    \ #$40
        STA     enemySpriteAddrLow
        JSR     L2C08

        JMP     L2A88

.L2A53
        CMP     #$0C
        BNE     L2A68

        LDA     #LO(L2F40)    \ #$40
        STA     enemySpriteAddrLow
        JSR     L2C08

        LDA     #LO(L2F80)    \ #$80
        STA     enemySpriteAddrLow
        JSR     L2C08

        JMP     L2A88

.L2A68
        CMP     #$06
        BNE     L2A7D

        LDA     #LO(L2F80)    \ #$80
        STA     enemySpriteAddrLow
        JSR     L2C08

        LDA     #LO(L2FC0)    \ #$C0
        STA     enemySpriteAddrLow
        JSR     L2C08

        JMP     L2A88

.L2A7D
        CMP     #$01
        BNE     L2A88

        LDA     #LO(L2FC0)    \ #$C0
        STA     enemySpriteAddrLow
        JSR     L2C08

.L2A88
        LDA     #HI(L2F00)    \ #$2F
        STA     enemySpriteAddrHigh
        PLA
        STA     enemySpriteAddrLow
        DEC     L0077
.L2A91
        JMP     L2BE4

.L2A94
        LDY     #$00
        LDA     (L0075),Y
        STA     L0070
        STY     L0072
.L2A9C
        INY
        LDA     (L0075),Y
        STA     L0077
        INY
        LDA     (L0075),Y
        STA     L0078
        INY
        LDA     (L0075),Y
        STA     L0079
        INY
        LDA     (L0075),Y
        STA     L007A
        INY
        LDA     (L0075),Y
        STA     L007B
        LDA     L0077
        AND     #$C0
        BNE     L2ABE

        JMP     L2A38

.L2ABE
        LDA     L007A
        BPL     L2AC5

        JMP     L2C00

.L2AC5
        DEC     L0077
        TYA
        PHA
        LDY     #$00
        LDA     (L008A),Y
        STA     L0080
.L2ACF
        INY
        LDA     (L008A),Y
        SEC
        SBC     L007B
        BMI     L2B1E

        CMP     #$08
        BPL     L2B1E

        INY
        INY
        LDA     (L008A),Y
        BEQ     L2B20

        INY
        LDA     (L008A),Y
        SEC
        SBC     L007A
        BMI     L2B21

        CMP     #$07          \ Wing hit?
        BPL     L2B21

        CMP     #$03          \ Critical hit
.L2AEF  BEQ     L2AFE         \ $2AEF Change to BNE for easy kills (EOR $20)

        LDA     #$40          \ Trigger pigeon
        ORA     gameFlags
        STA     gameFlags
        ASL     A
        STA     (L008A),Y
        BNE     L2B21

.L2AFE  \ Enemy critical hit
        LDA     #HI(L1940)    \#$19    \ possible memory reference (L19xx) - enemy explosion
        STA     L0077
        LDA     #$D8     \ what is this?
        STA     (L008A),Y \ ?(2D0A+8)
        TAX
        LDA     #$07
        LDY     #$2D
        JSR     osword        \ Play a sound (enemy explosion)

        PLA
        TAY
        LDA     #$02
        ORA     gameFlags
        STA     gameFlags
        JSR     L2C08

        JMP     L2A38

.L2B1E
        INY
        INY
.L2B20
        INY
.L2B21
        CPY     L0080
        BMI     L2ACF

        PLA
        TAY
        LDA     L0073    \ $3F/$FF makes all the planes descend at once
        AND     #$BF     
        STA     L0073
        INC     L0072
        JSR     L2C08

        LDA     L007B
        CMP     #$AF
        BNE     L2B4C

        SEC
        LDA     L0078
        SBC     #$87
        STA     L0078
        LDA     L0079
        SBC     #$48
        STA     L0079
        LDA     #$C0  \ what is this?
        STA     L007B
        JSR     L14D9

.L2B4C
        LDA     #$3F
        AND     L0077
        BNE     L2B88

        SEC
        LDA     L007A
        SBC     playerXpos
        STA     L0077
        LDA     #$00
        BCS     L2B60

        SEC
        ROR     A
.L2B60
        ROR     A
        STA     L0080
        LDA     L0077
        BNE     L2B6A

        JSR     L20D0

.L2B6A
        BPL     L2B71

        EOR     #$FF
        CLC
        ADC     #$01
.L2B71
        CMP     #$02
        BMI     L2B84

        STA     L2D03
        JSR     L2CFD

        LSR     L2D03
        CLC
        ADC     L2D03
        AND     #$3F
.L2B84
        ORA     L0080
        STA     L0077
.L2B88
        LDA     L0077
        LDX     L007A
        CPX     #$01
        BPL     L2B97

        ORA     #$40
        AND     #$7F
        JMP     L2B9F

.L2B97
        CPX     #$48
        BMI     L2BA1

        ORA     #$80
        AND     #$BF
.L2B9F
        STA     L0077
.L2BA1
        INC     L007B
        LDA     #$07
        AND     L0078
        CMP     #$07
        BEQ     L2BB0

        INC     L0078
        JMP     L2BBD

.L2BB0
        CLC
        LDA     L0078
        ADC     #$79
        STA     L0078
        LDA     L0079
        ADC     #$02
        STA     L0079
.L2BBD
        JMP     L146A
		
.L2BC0  BCC     L2BD1
        DEC     L007A    \ $7A
        LDA     L0078    \ $78
        SBC     #$08
        STA     L0078    \ $78
        BCS     L2BE1
        DEC     L0079    \ $79
        JMP     L2BE1
                    
.L2BD1  INC     L007A    \ $7A
        ROL     A
        BCC     L2BE1
        CLC
        LDA     L0078    \ $78
        ADC     #$08
        STA     L0078    \ $78
        BCC     L2BE1
        INC     L0079    \ $79		

.L2BE1
        JSR     L2C08

.L2BE4
        DEY
        DEY
        DEY
        DEY
        LDA     L0077
        STA     (L0075),Y
        INY
        LDA     L0078
        STA     (L0075),Y
        INY
        LDA     L0079
        STA     (L0075),Y
        INY
        LDA     L007A
        STA     (L0075),Y
        INY
        LDA     L007B
        STA     (L0075),Y
.L2C00
        CPY     L0070
        BEQ     L2C07

        JMP     L2A9C

.L2C07
        RTS

.L2C08  \ Enemy drawing?
        TYA
        PHA
        CLC
        LDA     L0078
        ADC     #$78    \ interlace?
        STA     L0084
        AND     #$07    \ 0 - 7
        EOR     #$07    \ 7 - 0
        STA     L0074
        LDA     L0079
        ADC     #$02
        STA     L0085
.L2C1D
        LDY     #$3F
L2C1E = L2C1D+1
.L2C1F
        LDX     #$07
        CPX     L0074
        BEQ     L2C33

.L2C25
        LDA     (enemySpriteAddrLow),Y
        BEQ     L2C2D

        EOR     (L0084),Y
        STA     (L0084),Y    \ NOPping this causes enemies to flicker. Memory copy for smooth animation?
.L2C2D
        DEY
        DEX
        CPX     L0074
        BNE     L2C25

.L2C33
        LDA     (enemySpriteAddrLow),Y
        BEQ     L2C3B

        EOR     (L0078),Y
        STA     (L0078),Y
.L2C3B
        DEY
        DEX
        BPL     L2C33

        TYA
        BPL     L2C1F

        PLA
        TAY
        RTS

.smc_L2C45      \ Drop a bomb if $2C49!=$60
        RTS     \ Gets changed to $A9 (LDA#) by L22E2

        EQUB    $C0    \ Making this the value being loaded into A
		BIT     L0073  \ and this the next instruction
		
.L2C49  BNE     L2C91
        DEC     L0073
        BNE     L2C91
        LDY     #$FF
.L2C51  INY
        INY
        INY
        INY
        INY
        LDA     (L0075),Y    \ $75
        BMI     L2C51
        DEY
        DEY
        DEY
        LDA     (L0075),Y    \ $75
        AND     #$C0
        BNE     L2C69
        INY
        INY
        INY
        JMP     L2C51
                    
.L2C69  INY
        CLC
        LDA     (L0075),Y    \ $75
        ADC     #$9D
        STA     L0080        \ $80
        INY
        LDA     (L0075),Y    \ $75
        ADC     #$02
        STA     L0081        \ $81
        JSR     L29C3
        LDY     #$00
.L2C7D  INY                  \ Find a free bomb slot
        INY
        LDA     (L008C),Y    \ $8C
        BNE     L2C7D
        LDA     L0081        \ $81
        STA     (L008C),Y    \ $8C
        DEY
        LDA     L0080        \ $80
        STA     (L008C),Y    \ $8C
        LDA     useless      \ $2D71
        STA     L0073        \ $73
.L2C91  LDA     #$C0
        ORA     L0073        \ $73
        STA     L0073        \ $73
        RTS
		
.L2C98                                      \ Something to do with enemy bomb plotting
        LDY     #$00                        \ Y = 0
        LDA     (L008C),Y                   \ A = ?(&2D47+0)
		
		\ NOPping the following line out may be the best glitch-fix option? No - bombs!
        STA     L0070                       \ ?&70 = A                (=?&2D47)
		
		\ Use this space to AND L0070 with, say, $10?
		
        LDA     L2D74                       \ ?&2D74 = A              (seems pointless!)
        STA     L0082 \ Store bomb sprite LO\ ?&82 = A                (=?&2D47)
        LDA     L2D75                       \ A = ?&2D75
        STA     L0083 \ Store bomb sprite HI\ ?&83 = A                (=?&2D75)
		
.L2CA8  \ Loop to 'do stuff' to bombs, SteveF on stardot
        INY                                 \ Y = Y + 1               (Y = 1)
        LDA     (L008C),Y                   \ A = ?(&2D47+1)          (A = ?&2D48)
        STA     L0080                       \ ?&80 = A                (A = ?&2D48)
        INY                                 \ Y = Y + 1               (Y = 2)
        LDA     (L008C),Y                   \ A = ?&(2D47+2)          (A = ?&2D49)
        STA     L0081                       \ ?&81 = A (?(&2D47+2))   (?&81 = ?&2D49)
        BNE     L2CBD                       \ Branch if not zero to .L2CBD

        LDA     #$7F                        \ A = &7F
        AND     L0073                       \ A = &7F AND ?&73        (clear top bit)
        STA     L0073                       \ ?&73 = A
        JMP     L2CF5                       \ Goto .L2CF5

.L2CBD
        JSR     L29C3                       \ PROC L29C3, then back here

        LDA     L0080                       \ A = ?&80
        AND     #$07                        \ A = A AND 7 (set bit 7)
        CMP     #$06                        \ A = 6
        BPL     L2CD1                       \ IF A > 6 goto .L2CD1 (check this)

        INC     L0080                       \ ?&80 = ?&80 + 1
        INC     L0080                       \ ?&80 = ?&80 + 1
        LDA     L0081                       \ A = ?&81
        JMP     L2CDE                       \ Goto .L2CDE

.L2CD1
        CLC                                 \ Clear carry
        LDA     L0080                       \ A = ?&80
        ADC     #$7A                        \ A = A + ?&7A (C=0)
        STA     L0080                       \ ?&80 = A
        LDA     L0081                       \ A = ?&81
        ADC     #$02                        \ A = A + 2
        STA     L0081                       \ ?&81 = A
		
.L2CDE  \ Triggered when bomb hits bottom of screen
        CMP     #$80                        \ A = &80 (128)? 
        BMI     L2CE8                       \ Less? Goto .L2CE8   (check this)

        LDA     #$00                        \ A = 0
        STA     (L008C),Y                   \ ?&(2D47+0) = 0
        BEQ     L2CF5                       \ Goto .L2CF5

.L2CE8
        JSR     L29C3                       \ PROC L29C3

        DEY                                 \ Y = Y - 1
        LDA     L0080                       \ A = ?&80
		
		\ How does Y get to 19 here if $1A09 ~= $1A?
		\ Because of the loop at L2CA8 - Y incs depending on the value of ?&2D47
        STA     (L008C),Y    \ $(2D47+Y)    \ ?&(2D47+Y) = ?&80
		\
		
        INY                                 \ Y = Y + 1
        LDA     L0081                       \ A = ?&81
        STA     (L008C),Y    \ $(2D47+Y)    \ ?&(2D47+Y) = ?&81
.L2CF5
        CPY     L0070                       \ Y : ?&70?
        BMI     L2CA8                       \ Branch if minus to .L2CA8 (loop) *** No glitch if this NOPped J'accuse surtout

        RTS                                 \ Return

.L2CFA  STA     L2D03                       \ Does this ever execute? Yes, from .L29F9
.L2CFD
        SEC
        LDA     L007C
        AND     #$7F
.L2D02
        SBC     #$10
L2D03 = L2D02+1             \ SMC?
        BPL     L2D02

        ADC     L2D03
        RTS

.L2D0A
        EQUB    $06,$02,$31,$00,$05,$02,$39,$00
        EQUB    $06

.L2D13
        EQUB    $1E,$9E,$F0,$35,$9E,$C0,$81,$A8
        EQUB    $3A,$95,$D0,$81,$F8,$3A,$9F,$D0
        EQUB    $81,$48,$3B,$A9,$D0,$81,$98,$3B
        EQUB    $B3,$D0,$81,$E8,$3B,$BD,$D0,$00
        EQUB    $00,$00,$00,$00,$00,$00,$00,$00
        EQUB    $00,$00,$00,$00,$00,$00,$00,$00
        EQUB    $00,$00,$00,$00

.L2D47  \ aka ($8C)                                \ Number of active bomb slots
        EQUB    $02                                \ First byte is copied from 1A09
		EQUB    $D6,$00,$00,$00,$00,$00,$00        \ Screen memory pairs of bomb positions
        EQUB    $00,$00,$00,$00,$00,$00,$00,$00    \ Unknown how many are used for this (at least 3 pairs)
        EQUB    $00,$00,$00,$00,$00,$00,$00,$00    \ Last byte is $2D5E ($2D0A + $54)

.L2D5F
        EQUB    $80,$40,$40,$00,$80,$00,$40,$80
        EQUB    $00

.L2D68
        EQUB    $88,$A0,$B8,$D0,$E8,$D0,$B8,$88

.playerXpos  \ .L2D70
        EQUB    $20    \ Initial player X pos

.useless        \ L2D71
                \ Seems to be completely redundent. Set to $D7 here, changed to
                \ $F0 by L1EC6 (at the beginning of a new game), then decremented
				\ once by L1EE3. Possibly a removed or planned feature?
				\ Update - probably not useless. Used by .L2C7D (STA'd to $73)
        EQUB    $D7

.L2D72 
        EQUB    $00

.bulletSprite   \ L2D73
        EQUB    $1A  \ player bullet 'sprite'

.L2D74
        EQUB    LO(L2350)    \ $50     \ Enemy bomb sprite low

.L2D75
        EQUB    HI(L2350)    \ $23     \ Enemy bomb sprite high

.gameFlags      \ L2D76 \ Game flags
        EQUB    $00		\ pigeon flying, 10 = add notes (use for bonus cheat), 80 = end level (c 2d76 80)

.score_low_byte \ $2D77
        EQUB    $00

.score_high_byte\ $2D78
        EQUB    $00

.L2D79
        EQUB    $20

.L2D7A  \ Life / lives counter?
        EQUB    $03

.L2D7B
        EQUB    $42

.L2D7C  \ aka ($80)
        EQUB    $00

.L2D7D  \ aka ($81) Pigeon position
        EQUB    $00

.L2D7E
        EQUB    $06

.L2D7F
        EQUB    $00
		
.L2D80  EQUB    $01,$81,$FD,$00,$00,$28,$00         \ 14 bytes of envelope data
        EQUB    $00,$3C,$06,$CE,$CE,$3B,$7E         \ Pigeon 'tweet' / hit
		EQUB    $00,$00 \ padding?
		
.L2D90  EQUB    $02,$83,$00,$00,$00,$00,$00         \ 14 bytes of envelope data
        EQUB    $00,$7F,$FF,$FE,$FF,$7E,$78         \ Enemy explosion
        EQUB    $00,$00 \ padding?


.L2DA0  EQUB    $03,$86,$FF,$00,$01,$02,$01         \ 14 bytes of envelope data
        EQUB    $01,$7F,$FF,$FD,$FD,$7E,$78         \ Player explosion
        EQUB    $00,$00 \ padding?

			
.L2DB0  EQUB    $04,$81,$FB,$E6,$FE,$10,$01         \ 14 bytes of envelope data
        EQUB    $5A,$7F,$FE,$E2,$9C,$7E,$00         \ Player fire noise
        EQUB    $00,$00 \ padding?


.L2DC0  EQUB    $05,$0A,$00,$00,$00,$01,$0C         \ 14 bytes of envelope data
        EQUB    $00,$7F,$F5,$00,$E2,$7E,$00		    \ Tune voice

		EQUB    $00
		
        EQUB    $00,$12,$00,$04,$00,$50,$00,$14
        EQUB    $00,$10,$00,$02,$00,$06,$00,$A0
        EQUB    $00,$10,$00,$03,$00,$07,$00,$C8
        EQUB    $00,$13,$00,$01,$00,$B4,$00,$0A
        EQUB    $00,$13,$00,$01,$00,$FA,$00,$0A
        EQUB    $00,$01,$00,$05,$00

.L2DFC
        EQUB    $49,$00

.L2DFE  \ ?
        EQUB    $0F,$00
		
.L2E00  \ Sprites (label added by iainfm)
		EQUB    $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF    \ Clouds
		EQUB    $FF,$FF,$FF,$FF,$FF,$AA,$AA,$00
		EQUB    $55,$AA,$FF,$AA,$55,$55,$00,$00
		EQUB    $FF,$FF,$55,$FF,$FF,$FF,$FF,$00
.L2E20	EQUB    $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
		EQUB    $FF,$FF,$FF,$FF,$FF,$FF,$FF,$AA
		EQUB    $FF,$FF,$FF,$FF,$FF,$AA,$55,$00
		EQUB    $FF,$FF,$FF,$55,$FF,$FF,$FF,$55
		EQUB    $FF,$FF,$FF,$FF,$FF,$FF,$FF,$AA
		EQUB    $FF,$FF,$FF,$FF,$FF,$FF,$AA,$00
		EQUB    $FF,$FF,$FF,$AA,$FF,$55,$00,$00
		EQUB    $FF,$55,$FF,$FF,$FF,$FF,$FF,$00
		EQUB    $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
		EQUB    $FF,$FF,$FF,$FF,$FF,$FF,$FF,$AA
		EQUB    $FF,$FF,$FF,$FF,$FF,$AA,$55,$00
		EQUB    $FF,$FF,$FF,$FF,$55,$FF,$FF,$FF
		EQUB    $AA,$FF,$FF,$FF,$FF,$FF,$FF,$AA
		EQUB    $FF,$55,$AA,$FF,$FF,$AA,$00,$00
		EQUB    $FF,$FF,$FF,$55,$AA,$00,$00,$00
		EQUB    $FF,$FF,$FF,$FF,$FF,$00,$00,$00
		EQUB    $FF,$FF,$FF,$FF,$FF,$FF,$55,$00
		EQUB    $FF,$FF,$FF,$FF,$FF,$FF,$FF,$55
		EQUB    $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
		EQUB    $FF,$FF,$FF,$FF,$FF,$FF,$FF,$00

.L2EC0  \ Sprites
        EQUB    $FF,$FF,$FF,$FF,$FF,$FF,$AA,$55    \ Cloud part
        EQUB    $FF,$FF,$AA,$55,$FF,$55,$FF,$FF
        EQUB    $55,$FF,$FF,$FF,$FF,$FF,$FF,$AA
        EQUB    $FF,$FF,$AA,$AA,$AA,$00,$00,$00

 \ .test  NOP

.L2EE0 \ Sprites for clouds and enemy aircraft
        EQUB    $FF,$FF,$55,$55,$55,$00,$00,$00    \ Cloud part
        EQUB    $FF,$FF,$FF,$FF,$FF,$FF,$FF,$00
        EQUB    $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
        EQUB    $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
.L2F00  EQUB    $00,$05,$00,$00,$00,$00,$05,$00    \ Wave 1 aircraft sprite - label added
        EQUB    $00,$0F,$0A,$0A,$0A,$0A,$0F,$00
        EQUB    $00,$0F,$00,$00,$00,$00,$0F,$15
        EQUB    $00,$0F,$05,$15,$0F,$05,$0F,$00
        EQUB    $0A,$0F,$2F,$3F,$2F,$0F,$0F,$0A
        EQUB    $00,$0F,$00,$00,$0A,$00,$0F,$15
        EQUB    $00,$0F,$00,$00,$00,$00,$0F,$00
        EQUB    $00,$0F,$0A,$0A,$0A,$0A,$0F,$00
.L2F40  EQUB    $00,$04,$00,$00,$00,$00,$00,$00    \ Wave 2 aircraft sprite
        EQUB    $00,$0C,$04,$00,$00,$00,$00,$00
        EQUB    $00,$0C,$00,$08,$04,$00,$05,$05
        EQUB    $00,$0D,$15,$04,$04,$08,$00,$00
        EQUB    $08,$2F,$3F,$06,$0C,$08,$00,$00
        EQUB    $00,$0C,$00,$00,$04,$08,$05,$05
        EQUB    $00,$0C,$04,$08,$00,$00,$00,$00
        EQUB    $00,$0C,$00,$00,$00,$00,$00,$00
.L2F80  EQUB    $00,$00,$00,$14,$14,$00,$00,$00    \ Wave 3 aircraft
        EQUB    $00,$00,$00,$00,$28,$3C,$00,$00
        EQUB    $00,$00,$00,$00,$00,$3C,$0A,$00
        EQUB    $28,$14,$00,$00,$14,$29,$14,$00
        EQUB    $00,$3C,$28,$28,$3E,$2B,$16,$28
        EQUB    $28,$00,$00,$00,$00,$3C,$00,$00
        EQUB    $00,$00,$00,$00,$00,$3C,$0A,$00
        EQUB    $00,$00,$00,$14,$3C,$28,$00,$00
.L2FC0  EQUB    $00,$00,$00,$00,$14,$00,$00,$00    \ Wave 4 aircraft
        EQUB    $30,$00,$00,$10,$3C,$10,$00,$00
        EQUB    $38,$28,$28,$3E,$14,$3C,$30,$00
        EQUB    $30,$00,$00,$20,$3C,$20,$00,$00
        EQUB    $10,$00,$00,$00,$3C,$00,$00,$00
        EQUB    $30,$00,$00,$34,$3C,$34,$10,$00
        EQUB    $38,$28,$28,$3A,$14,$38,$20,$00
        EQUB    $20,$00,$00,$00,$3C,$00,$00,$3A

.BeebDisEndAddr

IF BeebDisEndAddr > &3000
    PRINT "WARNING: Code over-run by", BeebDisEndAddr-&3000,"bytes."
ENDIF

SAVE "$.BirdSk2",p0data,BeebDisEndAddr

