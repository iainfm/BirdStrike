\ Build directives

ORIGINAL = TRUE       \ Build an exact copy of the original. False overrides the tamper protection / default high score holder
FIX      = FALSE      \ Needs ORIGINAL = FALSE. Use 'spare' space at $1B11 for the fix
PRESERVE = TRUE       \ Not currently used. Preserve original memory locations where possible when ORIGINAL = FALSE
                      \ Does not apply globally, eg if FIX = TRUE or ENCHTS = TRUE
ENRELO   = FALSE      \ Enable relocation (not working yet)
ENCHTS   = FALSE      \ Requires FIX = TRUE. Enable some PoC modifications.
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
L0000   = $0000    \ Zero Page uses - original labels below where discovered
L0008   = $0008
L0009   = $0009
L000A   = $000A
L000B   = $000B
L005D   = $005D    \ possible an artefact
L0070   = $0070    \ no
L0071   = $0071    \ bfg
L0072   = $0072    \ pflg
L0073   = $0073    \ bofg
L0074   = $0074    \ mod
L0075   = $0075    \ pls
L0076   = $0076    \ pls+1
L0077   = $0077    \ exp
L0078   = $0078    \ pos
L0079   = $0079    \ pos+1
L007A   = $007A    \ psta \ Bullet X coordinate?
L007B   = $007B
L007C   = $007C    \ py / ra1 ($.OLDSRCE)
L007D   = $007D    \ ra1
L007E   = $007E    \ Only used in .L25B8
L007F   = $007F    \ Only used in .L25B8
L0080   = $0080    \ sd   Score screen memory location low byte  sd
L0081   = $0081    \ sd+1 Score screen memory location high byte sd+1
L0082   = $0082    \ sf   Sprite pointer low byte (digits, notes, pigeons etc) sf
L0083   = $0083    \ sf+1 Sprite pointer high byte sf+1
L0084   = $0084    \ st \ Something to do with enemy position / plotting
L0085   = $0085    \ st+1 \ Something to do with enemy position / plotting
L0086   = $0086    \ gunp
L0087   = $0087    \ gunp+1

enemySpriteAddrLow   = $0088   \ plf     \ L0088 \ Enemy sprite address low byte (0 = level 1 aircraft, add $40 per level)
enemySpriteAddrHigh  = $0089   \ plf+1   \ L0089 \ Enemy sprite address high byte
L008A   = $008A    \ bulst Enemy X coordinate?
L008B   = $008B    \ bulst+1
L008C   = $008C    \ bost      \ Something to do with enemy bomb y-position - bomb stack?
L008D   = $008D    \ bost+1    \ bomb stack hi
L008E   = $008E    \ cnt

BYTEvA  = $020A    \ BYTEvA
BYTEvB  = $020B    \ BYTEvB

osword_redirection_C   = $020C
osword_redirection_D   = $020D

WRCHvA  = $020E        \ WRCH vector A
WRCHvB  = $020F        \ WRCH vector B

EVNTvA  = $0220        \ EVNT vector A
EVNTvB  = $0221        \ EVNT vector B

L02FC   = $02FC        \ picn \ Busy buffer flag

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

        
org     $1200          \ "P%" as per the available disc binary

\\\\\\ 1200 - 13FF probably added by the original cracker to restore vectors used by
\\\\\\ loading music and restore ZPG data prior to launching the game code
\\\\\\ This was handled in the tape version by the decryption routine
\\\\\\ The reason for the table below and the loop to copy it to ZPG is unknown.
\\\\\\ Tape version loads at &1400 and execution starts at &1E00.
\\\\\\
\\\\\\ Note - if the memory of the decrypted tape version (&1400-&2FFF) is saved, the
\\\\\\ game can be run by *LOADing it at 1400, setting $5C-$5F to 1 and CALLing &1E00

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

        \ Un-official code entry point. Restores vectors used by game-loading tune routines.

        SEI                  \ Disable interrupts
		
	    LDA     L3527        \ Restore vectors
        STA     WRCHvA
		
		LDA     L3528
        STA     WRCHvB
        
	    LDA     L3529
        STA     EVNTvA
		
		LDA     L352A
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
        LDX     #$0C
        JSR     osbyte        \ Set TAPE filing system and baud rate (X)

        JMP     game

		\ Then follows 128 bytes of padding
        FOR Z, 1, 128
		    EQUB $00
	    NEXT

.L1400
		\ Thanks and credits
        EQUS    "Thanks David,Ian,Martin,Mum,Dad,Susi C"

        
.keyCheck       \ .opt \ Main keyboard scan during gameplay .L1426
        LDX     #$EF             \ Q key
        JSR     keyboardScan     \ key

        BNE     checkSkey        \ op1    \ Skip if pressed

        LDA     #LO(L1461)       \ (mute MOD 256) \ #$61
        STA     osword_redirection_C      \ &20C  \ Mess with vectors to disable sounds
        LDA     #HI(L1461)       \ (mute DIV 256) \ #$14
        STA     osword_redirection_D      \ &20D  \ Mess with vectors to disable sounds
		
.checkSkey \ .op1 \ .L1437
        LDX     #$AE             \ S key
        JSR     keyboardScan     \ key

        BNE     checkRkey        \ op2 \ Skip if pressed
        LDA     wordv_1          \ soun
        STA     osword_redirection_C      \ &20C  \ Restore default vectors to enable sounds
        LDA     wordv_2          \ soun+1 
        STA     osword_redirection_D      \ &20D \ Restore default vectors to enable sounds

.checkRkey \.op2 \ .L144A
        LDX     #$CC
        JSR     keyboardScan     \ key \ R key
        BNE     keyCheckComplete \ op5

.debounceRkey \ .op3 \ .L1451  \ De-bounce for R keypress?
        LDA     #$81
        LDY     #$01
        LDX     #$00
        JSR     osbyte    \ Read key with timeout
        BCS     debounceRkey \ op3 \ No key detected
        CPX     #$52      \ INKEY value of R
        BEQ     debounceRkey \ op3

.keyCheckComplete \.op5 \.L1460
        RTS

.L1461  \ .mute \ Disable sounds - Address used by .keyCheck (osword_redirection_C/D)

        CMP    #$07
		BEQ    keyCheckComplete  \ op5
		JMP    (wordv_1)         \ (soun)

.wordv_1    \ soun \ OSWORD redirection vector stored here \L1468
        EQUB    $EB

.wordv_2    \ OSWORD redirection vector stored here \L1469
        EQUB    $E7

.L146A \ .nlr  \ Move enemy / check left bound
        LDA     L149B     \ tog
        BEQ     L1490     \ enlr

        LDA     L0077     \ exp
        BPL     L1483     \ rt

        DEC     L007A     \ psta
        SEC
        LDA     L0078     \ pos
        SBC     #$08
        STA     L0078     \ pos
        BCS     L1490     \ enlr

        DEC     L0079     \ pos+1
        JMP     L1490     \ enlr

.L1483  \ .rt
        \ Check right bound
        INC     L007A     \ psta
        CLC
        LDA     L0078     \ pos
        ADC     #$08
        STA     L0078     \ pos
        BCC     L1490     \ enlr

        INC     L0079     \ pos+1
		
.L1490  \ .enlr \ Enemy left-right zigzag
        LDA     #$01    \ 0 = vertical descent
        EOR     L149B   \ tog
        STA     L149B   \ tog
        JMP     L2BE1   \ (no label)

.L149B  \ .tog
        EQUB    $00    \ enemy zig-zag state?
		
.L149C  \ .fpat
        \ Triggered when bullet fired
		LDA     L14AD  \ fp0
		BEQ     L14A5  \ fp1
		DEC     L14AD  \ fp0
		RTS
		
.L14A5  \ .fp1
        \ Player bullet fired
        LDA     #$12     \ 2nd bullet fire delay?
        STA     L14AD    \ fp0
		JMP     L297D    \ this (or another L297D) may upset the disassembly. Jury's out.
		
.L14AD  \ .fp0
        EQUB   $00

.gameOver \ .gov       \ Display Game Over message    \ L14AE
        PLA
        PLA
        LDY     #$FF
		
.gameOverLoop \ .gov1  \ L14B2
        INY
        LDA     #$0A
        JSR     L208D  \ delay

        LDA     gameOverText,Y    \ gov2,Y \ Load chr at gameOverText (L14CA), offset Y
        JSR     oswrch            \ Print it

        CMP     #$52              \ Loop untl the "R" of "OVER"
        BNE     gameOverLoop      \ gov1

        LDA     #$96
        JSR     L208D  \ delay

        JMP     L1E21  \ newgame (original $.S)

.gameOverText \ .gov2
        \ GAME OVER message        \ L14CA    
        EQUB    $1F,$05,$0F,$11,$01        \ Red text, centred on screen
        EQUS    "GAME OVER"

.L14D8  \ .stp4 Enemy has reached bottom of the screen
        RTS

.L14D9  \ .stp6
        LDA     timer_L1D55 \ gex
        BEQ     L14D8       \ stp4

        LDA     L007A       \ psta
        EOR     #$80
        STA     L007A       \ psta
        INC     L0077       \ exp \ 'bug' noted in $.S and C.SOURCE
        PLA
        PLA
        JMP     L2BE4       \ fo+3 / F%+3

.L14EB  \ exg
        LDA     #$01
        BIT     L151A       \ exg3
        BNE     L1502       \ exg1

        LDY     score_high_byte     \ sc+2
        CPY     #$05				\ Extra life at 5000?
        BMI     L1519       \ exg2
        ORA     L151A       \ exg3
        STA     L151A       \ exg3
        JSR     L151B       \ exg4

.L1502  \ .exg1
        LDA     #$02
        BIT     L151A       \ exg3
        BNE     L1519       \ exg2

        LDY     score_high_byte    \ sc+2
        CPY     #$10
        BMI     L1519       \ exg2

        ORA     L151A       \ exg3
        STA     L151A       \ exg3
        JMP     L151B       \ exg4

.L1519  \ .exg2
        RTS

.L151A  \ .exg3
        EQUB    $00

.L151B  \ .exg4
        JSR     L2223        \ mini

        LDA     #$DC
        STA     L2DFC        \ (no label in sources)
        LDX     #$F8
        LDY     #$2D
        LDA     #$07
        JSR     osword       \ Play a sound (extra life)

        INC     L1D56        \ gex+1
        CLC
        LDA     L1D57        \ gex+2
        ADC     #$18
        STA     L1D57        \ gex+2
        BCC     L153D        \ exg5
        INC     L1D58        \ gex+3
.L153D  \ .exg5
        RTS

.L153E  \ .bon  \ Bonus?
        LDA     level        \ fc
        AND     #$03
        BNE     L1550        \ bon0

        LDA     #$0F
        JSR     L208D        \ delay

        JSR     vduCalls     \ stmv

        JMP     L1556        \ bon11

.L1550  \ .bon0
        JSR     L20B1        \ cht
        JSR     playTune     \ tune

.L1556  \ .bon11
        JSR     L159E        \ wbmsg

        LDY     #$4B
.L155B  \ .bon1
        SED
        CLC
        LDA     score_low_byte  \ sc+1
        ADC     #$02
        STA     score_low_byte  \ sc+1
        LDA     score_high_byte \ sc+2
        ADC     #$00
        STA     score_high_byte \ sc+2
        CLD
        LDA     #$02
        JSR     L208D    \ delay

        TYA
        PHA
        LDX     #$E8
        LDY     #$2D
        LDA     #$07
        JSR     osword        \ Play a sound (bonus noise)

        JSR     L2054    \ s7

        PLA
        TAY
        DEY
        BNE     L155B    \ bon1

        INC     L15B7    \ bsou
        LDX     #$B7     \ (bsou AND 255) \ TODO: Implement this
        LDY     #$15     \ (bsou DIV 256) \ TODO: Implement this
        LDA     #$07
        JSR     osword        \ Play a sound (last pip of bonus noise)

        DEC     L15B7    \ bsou
        LDA     #$80
        ORA     gameFlags    \ sc
        STA     gameFlags    \ sc
        RTS

.L159E  \ .wbmsg
        \ Display bonus text
        LDY     #$00
.L15A0  \ .wb1
        LDA     bonusText,Y  \ bmsg,Y
        JSR     oswrch

        INY
        CPY     #$0B
        BNE     L15A0

        RTS

.bonusText \ .bmsg \ L15AC
        \ BONUS! message
        EQUB    $11,$06,$1F,$07,$0F        \ Cyan text, centred
        EQUS    "BONUS!"

.L15B7  \ .bsou
        \ Something to do with the bonus routine
        EQUB    $12 \ (just this byte, the rest is padding?)
		EQUB    $00,$FF,$FF,$00,$00,$00,$00
        EQUB    $FF

\\\\\\ C.SOURCE PART 2 ENDS HERE //////

\\\\\\ HSRTS STARTS HERE //////
.L15C0  \ .nbk		
		EQUB    $B4,$16,$08,$20,$7F

.L15C5  \ .hs
        EQUB    $00

.L15C6
        EQUB    $00

.L15C7  \ .hs+2
        EQUB    $02

.titleScreen \ .m7    \ L15C8
       \ MODE 7 Title Screen
	   
        EQUB    $16,$07,$17,$00,$0A,$20,$00,$00
        EQUB    $00,$00,$00,$00
		
.L15D4	\ .bsk
        EQUB    $9A,$94,$68,$3F
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

.highScoreDots  \ .dts \ L16A0
        \ High score display
        EQUB    $1F,$0B,$0B   \ Move text cursor
        EQUS    "............."
        EQUB    $00
		EQUB    $1F,$19,$0B   \ Move text cursor

.keysText \ .nam       \ L16B4
        
		IF ORIGINAL = TRUE
            EQUS    "andrew  "    \ original high score holder
	    ELSE
		    EQUS    "iainfm  "    \ Credit for my fix :D
		ENDIF
		
        EQUB    $00

.L16BD  \ .ints
        EQUB    $1F,$0E,$0E   \ Move text cursor
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
		
.L175C  \ .sps
        EQUB    $1F,$07,$18   \ Move text cursor
		EQUB    $81,$88       \ Red / flash
        EQUS    "Press space to play."
        EQUB    $00,$00,$00


\\\\\\ Start of 2nd PART $.S and C.SOURCE //////

.vduCalls       \ .stmv    \ L1778
        \ Call the VDU commands at vduCallsTable in reverse order    
        LDY     #$0A
		
.vduLoop        \ .stm4 \ L177A
        LDA     vduCallsTable,Y     \ stm10,Y
        JSR     oswrch

        DEY
        BPL     vduLoop    \ stm4

        LDA     #$80
        STA     L17A0      \ stm2+1 \ SMC
        LDA     #$00
        STA     L17AC      \ stm3+1 \ SMC
        LDA     #$04
        STA     L0070      \ no
		
.L1791  \ .stm1
        LDA     #$1D
        JSR     oswrch

        LDA     #$00
        JSR     oswrch

        JSR     oswrch

        SEC
.L179F  \ .stm2
        LDA     #$00
L17A0 = L179F+1            \ SMC
        SBC     #$80
        STA     L17A0      \ stm2+1
        PHP
        JSR     oswrch

        PLP
		
.L17AB  \ .stm3
        LDA     #$00
L17AC = L17AB+1            \ SMC
        SBC     #$00
        STA     L17AC      \ stm3+1
        JSR     oswrch

        JSR     drawStave  \ stv

        DEC     L0070      \ no
        BNE     L1791      \ stm1

        \ .stm5 (&17BC)
        LDA     level      \ fc
        STA     L1A08      \ tm
        LDA     #$00
        STA     level      \ fc
        LDA     #$26    \ Possible memory address - purpose unknown
        STA     L1A0C      \ tm+4
        LDA     #$88    \ Possible memory address - purpose unknown
        STA     L1A0B      \ tm+3
		
.L17D1  \ .stm6
        CLC
        LDA     L1A0B      \ tm+3
        STA     L1D59      \ not
        LDA     L1A0C      \ tm+4
        ADC     #$0A
        STA     L1A0C      \ tm+4
        STA     L1D5A      \ not+1
        JSR     L20B1      \ cht

        STX     L2382      \ nl
        INC     level      \ fc
		
.L17EC  \ .stm8
        JSR     L20DE      \ nxno

        BNE     L17EC      \ stm8

        JSR     L20B1      \ cht

        JSR     playTune   \ tune

        LDA     #$3C
        JSR     L208D      \ delay

        LDA     level      \ fc
        CMP     #$04 
        BNE     L17D1      \ stm6

        LDA     L1A08      \ tm
        STA     level      \ fc
        LDA     #$1A
        JMP     oswrch \ Restore default windows and then RTS

.vduCallsTable  \ .stm10   \ VDU calls    \ L180E - executed top-to-bottom
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

.L1819  \ .gend
        LDA     #$00
        STA     L15C5  \ hs
        LDA     score_high_byte  \ sc+2
        CMP     L15C7  \ hs+2
        BCC     L183F  \ ge1
        BNE     L1830  \ ge0
        LDA     score_low_byte   \ sc+1
        CMP     L15C6  \ hs+1
        BCC     L183F  \ ge1

.L1830  \ .ge0
        LDA     score_low_byte   \ sc+1
        STA     L15C6  \ hs+1
        LDA     score_high_byte  \ sc+2
        STA     L15C7  \ hs+2
        DEC     L15C5  \ hs
		
.L183F  \ .ge1
        LDA     #$16
        JSR     oswrch

        LDA     #$07
        JSR     oswrch

        LDX     #LO(L15D4)    \ (bsk AND 255)    \ #$D4 self-modifying code
        LDY     #HI(L15D4)    \ (bsk DIV 256)    \ #$15 self-modifying code
        JSR     L18EB    \ wrs

        LDA     #$1F
        JSR     oswrch

        LDA     #$05
        JSR     oswrch

        LDA     #$0B
        JSR     oswrch

        LDA     L15C7    \ hs+2
        JSR     L18D7    \ whs

        LDA     L15C6    \ hs+1
        JSR     L18D7    \ whs

        LDA     #$30     
        JSR     oswrch

        LDX     #LO(highScoreDots) \ (dts AND 255) \ #$A0 self-modifying code
        LDY     #HI(highScoreDots) \ (dts DIV 256) \ #$16 self-modifying code
        JSR     L18EB    \ wrs

        LDX     #LO(L16BD)         \ (ints AND 255) \ #$BD self-modifying code
        LDY     #HI(L16BD)         \ (ints DIV 256) \ #$16 self-modifying code
        JSR     L18EB    \ wrs

        LDA     #$1F
        JSR     oswrch        \ Move cursor to x,y

        LDA     #$1A          \ Restore default windows
        JSR     oswrch

        LDA     #$0B
        JSR     oswrch        \ Move cursor up one line

        LDA     L15C5    \ hs
        BEQ     L18A4    \ ge3

        LDA     #$15
        LDX     #$00
        JSR     osbyte        \ Flush keyboard buffer

        TXA
        LDX     #$C0          \ (nbk AND 255) \ TODO: implement this
        LDY     #$15          \ (nbk DIV 256) \ TODO: implement this
        JSR     osword        \ Read line from input to memory, probably the name for the high score table

        JMP     L18B1    \ ge7

.L18A4  \ .ge3
        LDY     #$FF
.L18A6  \ .ge6
        INY
        LDA     keysText,Y    \ nam,Y \ read and
        JSR     osasci                \ print high score text etc

        CMP     #$20
        BPL     L18A6    \ ge6

.L18B1  \ .ge7
        LDY     #$02
.L18B3  \ .ge5  \ Title screen loop
        LDA     titleScreen,Y    \ m7,Y
        JSR     oswrch

        INY
        CPY     #$0D
        BNE     L18B3    \ ge5

        LDA     #$64
        JSR     L208D    \ delay

.L18C3  \ .space
        LDA     #$1A
        JSR     oswrch

        LDX     #LO(L175C)       \ (sps AND 255) \ #$5C self-modifying code
        LDY     #HI(L175C)       \ (sps DIV 256) \ #$17 self-modifying code
        JSR     L18EB    \ wrs

.L18CF  \ .ge4  \ Wait for spacebar to begin game
        LDX     #$9D     \ Space bar
        JSR     keyboardScan     \ key

        BNE     L18CF    \ ge4

        RTS

.L18D7  \ .whs
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

.L18EB  \ .wrs
        STX     L18F5    \ (wr1+2) \ naughtly self-modifying code
        STY     L18F6    \ (wr1+3) \ naughtly self-modifying code
        LDY     #$FF
		
.L18F3  \ .wr1
        INY
.L18F4
        LDA     highScoreDots,Y  \ dts,Y
L18F5 = L18F4+1          \ wr1+2 \ SMC?
L18F6 = L18F4+2          \ wr1+3 \ SMC?

        JSR     osasci            \ Print the dots in the high score 'table'

        CMP     #$00
        BNE     L18F3    \ wr1
		
\\\\\ $.S / C.SOURCE has an RTS here / end of 2nd part //////

\\\\\ $.X starts here /////
        PHA              \ should
        LDA     L005D    \ be
        CMP     #$01     \ graphics
        BNE     L1907    \ ?
        PLA              \ ?
        RTS              \ ?

.L1907
        JMP     L1907    \ ?                       \ Infinite loop alert

        \ Table below seems to be offset by 2 (ie STA &3002 for correct alignment)
		\ Sprite locations appear to match $.X
		
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

.L1A09  \ .tm+1
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

.unused_L1D54   \ .picn \ Unused?
        EQUB    $00

.timer_L1D55    \ .gex \ Only used for the screen flash timer, I think.
        EQUB    $00

.L1D56  \ .gex+1 \ Something to do with lives(?)
        EQUB    $00

.L1D57  \ .gex+2
        EQUB    $00

.L1D58  \ .gex+3
        EQUB    $00

.L1D59  \ .not
        EQUB    $00

.L1D5A  \ .not+1
        EQUB    $00

.L1D5B  \ Enemy kill counter (x2)
        EQUB    $00

.level  \ .fc \ L1D5C \ Current level
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


.game   \ .Q%   \ L1E00
        \ Game can be run by starting execution here

        LDA     #$C8                        \ Read/write escape/break effect
        LDX     #$03                        \ esc disabled, memory clear on break (&1 in $.S)
        LDY     #$00                        \ could be useful for debugging?
        JSR     osbyte

        JSR     L18C3     \ space           \ No 'press space to play' message if RTS'd

\ * not part of $.S - but in C.SOURCE
        LDX     #$01
        LDA     #$04
        LDY     #$00
        JSR     osbyte                      \ Disable cursor editing

        LDA     osword_redirection_C        \ Get OSWORD indrection vector (low(?) byte - TBC)
        STA     wordv_1
        LDA     osword_redirection_D        \ Get OSWORD indirecton vector (high(?) byte - TBC)
        STA     wordv_2
\ * not part of $.S - but in C.SOURCE

.L1E21  \ .newgame                          \ .newgame as per $.S / C.SOURCE
        JSR     L1819                       \ gend \ Display title screen/high score/controls

        JSR     newGame                     \ S% \ Start game on spacebar from title screen

.gameLoop       \ .GO \ L1E27    \ Main game loop
        IF ORIGINAL = TRUE
		    JSR L25B8                       \ R%
		ELSE
		    IF ENCHTS = TRUE
                JSR     rng                 \ L25B8 \ pseudo random number generator?
            ELSE
			    JSR L25B8                   \ R%
	        ENDIF
        ENDIF
		
        JSR     vsyncWait                   \ scr \ Wait for vsync

        JSR     L2A94                       \ mp \ Enemy movement

        JSR     smc_L29F7                   \ np \ Self modifying code - next enemy?

        JSR     smc_L286E                   \ mg \ Player movement? - either an RTS or JMP $28D3 (load skull sprite?) - changed by .L2245/.L22E2

        JSR     L28E2                       \ mb \ Bullet Y movement

        JSR     smc_L295E                   \ nb \ Player fire - either an RTS or JMP absolute

        JSR     L2C98                       \ mbo \ Enemy bombs

        JSR     smc_L2C45                   \ nbo \ Drop a bomb? - either an RTS or an LDA

        JSR     L240E                       \ B%  \ Pigeon

        JSR     L2238                       \ H% \ .h0 \ Player hit detection

        JSR     L1FE0                       \ Gravestones plot / pigeon reset after hit
											\ sor (&1FDB in C.SOURCE)

        JSR     keyCheck                    \ opt \ Keyboard scan
		
		                                    \ $.S has an extra JSRkey and LDX#&8F here

        JMP     gameLoop                    \ branch back around
        
        EQUS    "(c)A.E.Frigaard 1984 Hello!"

.newGame        \ S% \ L1E6C    \ Set up new game
        LDA     #$05       \ Used to calculate address locations of sound envelopes
        STA     L0070      \ no
        JSR     L2835      \ E% \ Define-envelope routine

        LDA     #$49       \ New game tune
        JSR     playTune   \ tune

        LDA     #$16
        JSR     oswrch     \ VDU 22 (change mode)

        LDA     #$02
        JSR     oswrch     \ To mode 2

        LDA     #$00
        STA     L151A      \ exg3
        STA     L008E      \ cnt
        STA     level      \ fc       \ Reset level
        STA     unused_L1D54          \ picn \ Unused? Perhaps not.
        STA     timer_L1D55           \ gex  \ 'Lightning' effect timer
        STA     score_low_byte        \ sc+1 \ Reset score
        STA     score_high_byte       \ sc+2 \ Reset score
		
		IF ENRELO = TRUE
		    LDA #(L2F00 AND $FF)      \ Get address dynamically
			ENDIF
        STA     enemySpriteAddrLow    \ plf \ Reset enemey aircraft to level 1 biplane
		                              \ (This messes up relocation)
        CLC
        LDA     #$20
        STA     L2D79                 \ de
		
        LDA     #$03     \ Lives? Possible memory address
        STA     L2D7A    \ de+1
        LDA     #$2A     \ Initial x position? Possible memory address
        STA     L2D7B    \ de+2
        LDA     #$02
        STA     L0071    \ bfg
		
		\ Zero page memory lookups
        \ LDA     #$2D \ L2D0A_high

		LDA     #L2D47 DIV 256 \ #HI(L2D47)
        STA     L008B    \ bulst+1 \ ($8B) = $472D (check)
        STA     L008D    \ bost+1  \ ($8C) = $2D47
        STA     L0076    \ pls+1   \ ($75) = $2D13
		
        \ LDA     #$47
		LDA     #L2D47 MOD 256  \ #LO(L2D47)
        STA     L008C    \ bost \($8C) = $2D47
        
		\ LDA     #$0A
		LDA     #L2D0A MOD 256 \ #LO(L2D0A)
        STA     L008A    \ bulst \ ($8A) = $2D0A
        \ LDA     #$13
		LDA     #L2D13 MOD 256 \ #LO(L2D13)
        STA     L0075    \ pls \ ($75) = $2D13
		
        LDX     #$0F
        LDY     #$07

		
.L1EC6  \ .co1
        JSR     L281D    \ D% \ Set palette

        DEX
        CPX     #$07
        BNE     L1EC6   \ co1

        STX     L007D   \ ra1
        LDA     #$03    \ Lives
        STA     L1D56   \ gex+1
        LDA     #HI(L2F00)    \ #$2F                 
        STA     enemySpriteAddrHigh   \ plf+1
        LDA     #$F0    
        STA     useless \ inb
        LDA     #$00
        STA     L1A09   \ tm+1 \ Part of the problem
		
.L1EE3  \ .bf
        JSR     L20B1   \ cht 

        STX     L2382   \ nl
        INC     level   \ fc \ Increment level number
        LDA     L2D79   \ de
        CMP     #$0F
        BMI     L1F03   \ b0

        LDA     level   \ fc
        AND     #$01    \ Is level even?
        BEQ     L1F03   \ b0 \ Yes, branch
		                \ If not... (don't know why; reduces L2D79 by 2 every 2nd level)
        DEC     L2D79   \ de \ Commenting these out gives a slightly different corruption
        DEC     L2D79   \ de \ 
        DEC     useless \ inb
		
.L1F03  \ .b0
		\ The glitch/crash bug lies with the two INCs below
		\ To create a byte-for-byte original version leave them in and uncomment the NOPs
		\ To fix the bug comment out the INCs
		\ To fix the bug and maintain addresses consistent with the original comment the INCs and uncomment the NOPs
		\ This is all deprecated. See .zeroLoop (L1F2E)
		\ Now this is deprecated. .zeroLoop fix affects difficulty (# of enemy bombs)
		\ Need something that caps L1A09 to < = $19
		\ Probably need to jsr, do the deed and rts
		
		
		IF FIX = FALSE
            INC     L1A09      \ tm+1 \ J'accuse! NOP this out (x3 to keep addresses consistent for fix) - Changed to NOPping the STA 24d7 out
            INC     L1A09      \ tm+1 \ J'accuse! NOP this out (x3 to keep addresses consistent for fix) - Changed to NOPping the STA 24d7 out
        ELSE
		    JSR     gameFix    \ 3 bytes
			NOP:NOP:NOP
		ENDIF
		
		LDA     #$0C
        JSR     oswrch   \ Clear screen

        LDA     #$9A
        LDX     #$14
        JSR     osbyte   \ Write to Video ULA CPL and cursor width?

        JSR     L261A    \ C% Draw clouds - not culprit

        JSR     drawLineArt \ V%   \ Draw scenery - not culprit

        JSR     drawStave \ stv \ not culprit

        JSR     L2054     \ s7

        LDA     #$00
        STA     L1D5B        \ (no label?) Reset Ememy kill counter
        STA     gameFlags    \ sc \ Reset game flags
        STA     L2D7D        \ ba+1 \ Reset Pigeon position
        LDY     #$54
		
.zeroLoop       \ .b1 \L1F2E
        STA     L2D0A,Y      \ (no label?) \ Zero 2D0A to 2D5E (backwards)
        DEY
        BNE     zeroLoop     \ .b1
		LDA     L1A09        \ tm+1 \ Restore 2D47
		\ Original fix removed from here
		STA     L2D47        \ (no label?) NOPping this out will cure the code overwrite issue too, but no double-fire
		
        LDA     #$06
        STA     L2D0A        \ (no label)
        LDA     #$1E         \ Probably not a memory pointer
        STA     L2D13        \ (no label)
        LDA     #$30
        STA     L1D5A        \ not+1
        LDA     #$88
        STA     L1D59        \ not
        LDA     #$80
        STA     L1D57        \ gex+2
        LDA     #$32
        STA     L1D58        \ gex+3
        LDX     L1D56        \ gex+1  \ Lives
		
\\\\\\\\ PIGSRCE @ &2221 / C.SOURCE @ &1F5B ////////   \\\\\\\ $.S overlaps PIGSRCE ///////

.L1F5B  \ .pmi
        JSR     L2223   \ mini

        CLC
        LDA     L1D57   \ gex+2
        ADC     #$18    \ #$20 in PIGSRCE / &18 in $.S / &18 in C.SOURCE
        STA     L1D57   \ gex+2
        DEX
		                \ BNE pmi in PIGSRCE / $.S
		                \ CPX #7 in PIGSRCE
        BNE     L1F5B   \ pmi
                        \ STX ra1 in PIGSRCE
.ppos   LDA     #$3A
        STA     L0081
        LDA     #$81
        STA     L0082   \ need changing to #LO(something)?
        LDX     #$01
        LDY     #$08
.L1F76  \ .pp1

        \\\\\ NOTE: If C.SOURCE is assembled with !pls = 0, addresses will be out by
		\\\\\ five bytes at .slop/.L1FAA. Set !pls = &2D13 to correct.
		
        LDA     #$81
        STA     L2D13,X \ !pls,X    \ causes an extra 1 byte cf C.SOURCE if !pls=0
        INX
        TYA
        CLC	
        ADC     #$50
        STA     L2D13,X \ !pls,X    \ causes an extra 1 byte cf C.SOURCE if !pls=0
        TAY
        INX
        LDA     L0081
        ADC     #$00
        STA     L2D13,X \ !pls,X    \ causes an extra 1 byte cf C.SOURCE if !pls=0
                        \ extra code in PIGSRCE here &2257-&225F (not in C.SOURCE)
        STA     L0081
        CLC
        INX
        LDA     L0082
        ADC     #$0A
        STA     L0082
        STA     L2D13,X \ !pls,X    \ causes an extra 1 byte cf C.SOURCE if !pls=0
        INX
        LDA     #$D0
        STA     L2D13,X \ !pls,X    \ causes an extra 1 byte cf C.SOURCE if !pls=0
        INX
        CPX     #$1F
        BMI     L1F76   \ pp1

        LDY     #$00
        LDA     (L0075),Y  \ (pls),Y
        STA     L0070      \ no
.L1FAA  \ .slop (&1FA5 in C.SOURCE if !pls=0)
        INY
        INY
        LDA     (L0075),Y  \ (pls),Y
        STA     L0078      \ pos
        INY
        LDA     (L0075),Y  \ (pls),Y
        STA     L0079      \ pos+1
        JSR     L2C08      \ pp

        INY
        INY
        CPY     L0070      \ no
        BMI     L1FAA      \ slop

        JSR     L22E2      \ h7

.L1FC1  \ .sgun (&1FBC in C.SOURCE if !pls=0)
        LDA     #$20
        STA     playerXpos \ Xg
        LDA     #$7E
        STA     L0087      \ gunp+1
        LDA     #$90
        STA     L0086      \ gunp
        LDA     #HI(L2358) \ $23       \ Memory reference - player sprite pointer
        STA     L28D7      \ gun+4
        LDA     #LO(L2358) \ $58       \ Memory reference - player sprite pointer
        STA     L28D6      \ gun+3
        JSR     L28D3      \ gun (JMP in PIGSRCE, JSR in $.S)
		
\\\\\ END OF PIGSRCE MATCH /////   \\\\\\ $.S continues //////  \\\\\\ C.SOURCE continute //////

        LDA     #$40       \ Begin level tune
        JMP     playTune   \ tune

.L1FE0  \ .sor  (@ &239D in PIGSRCE / &1FDB in C.SOURCE if !pls=0)
        LDA     gameFlags \ sc
        BEQ     L2054     \ s7 Zero? Skip to L2054

        SED
        AND     #$02      \ Bit 2 set?
        BEQ     L1FFE     \ s1 Skip to L1FFE

        CLC
        LDA     #$15      \ #&05\pl in PIGSRCE/$.S / &15\pl in C.SOURCE if !pls=0
        ADC     score_low_byte  \ sc+1
        STA     score_low_byte  \ sc+1
        LDA     score_high_byte \ sc+2
        ADC     #$00
        STA     score_high_byte \ sc+2
        JSR     L258D \ X%

.L1FFE  \ .s1   \ &1FF9 in C.SOURCE if !pls=0
        LDA     #$40      \ #&10 in PIGSRCE / &40 in $.S
        BIT     gameFlags \ sc
        BEQ     L2021 \ s2 / s4 in $.S and C.SOURCE

        CLC
        LDA     #$01      \ #&10\pig in PIGSRCE, #1\wng in $.S and C.SOURCE
        ADC     score_low_byte  \ sc+1
        STA     score_low_byte  \ sc+1
        LDA     score_high_byte \ sc+2
        ADC     #$00
        STA     score_high_byte \ sc+2
        CLD
        LDX     #$B7          \ Not in PIGSRCE? but in $.S (bsou AND 255) in C.SOURCE TODO
        LDY     #$15          \ (bsou DIV 256) in C.SOURCE TODO
        LDA     #$07          \
        JSR     osword        \ Play a sound (plane winged?)

        SED
.L2021  \ .s4 ...if !pls=0
        LDA     #$10		  \ Pigeon hit - add a note to the stave
        BIT     gameFlags
        BEQ     L2042         \ s2

        CLC                   \ and reward the player
        LDA     #$0A              \ pig in $.S/C.SOURCE
        ADC     score_low_byte    \ sc+1 \ Wing hit - 10 points
        STA     score_low_byte    \ sc+1
        LDA     score_high_byte   \ sc+2
        ADC     #$00              \ Add carry to high byte
        STA     score_high_byte   \ sc+2
        CLD
        JSR     L20DE             \ nxno

        BNE     L2042             \ s2

        JSR     L153E             \ bon

.L2042  \ .s2   (&203D in C.SOURCE if !pls=0)
        CLD
        JSR     L14EB             \ exg

        LDA     gameFlags         \ sc
        BPL     L204E             \ s3 \ Bit 8 clear? Skip to reset game flag

        JMP     nextLevel         \ ef \ Next level

.L204E  \ .s3   (&2049 in C.SOURCE if !pls=0)
        LDA     #$00    \ Reset game flag
        STA     gameFlags \ sc
        RTS     \ 'sor' in $.S / C.SOURCE

.L2054  \ .s7   (&204F in C.SOURCE if !pls=0)
        LDA     #$34    \ Score screen memory location high byte ($33 in PIGSRCE)
        STA     L0081   \ sd+1
        LDA     #$B0    \ Score screen memory location low byte  ($90 in PIGSRCE)
        STA     L0080   \ sd
        LDA     #HI(L1C00)  \ $1C    \ Possible memory reference (score digits pointer)
        STA     L0083   \ sf+1
        LDA     #$F0
        AND     score_high_byte      \ sc+2
        JSR     L285A   \ w / W%

        LDA     #$0F
        AND     score_high_byte \ sc+2
        ASL     A
        ASL     A
        ASL     A
        ASL     A
        JSR     L285A   \ w / W%

        LDA     #$F0
        AND     score_low_byte  \ sc+1
        JSR     L285A   \ w / W%

        LDA     #$0F
        AND     score_low_byte  \ sc+1
        ASL     A
        ASL     A
        ASL     A
        ASL     A
        JSR     L285A   \ w / W% (JMP in PIGSRCE) / JSR in C.SOURCE

        LDA     #$00    \ PIGSRCE deviates here, $.S continues
        JMP     L285A   \ W%

.L208D  \ .delay (&2088 in C.SOURCE if !pls=0) \ aka ($8A),#0
        STA     L1A0A   \ tm+2
        TYA
        PHA
		
.L2092  \ .del1 (&208D in C.SOURCE if !pls=0)
        JSR     vsyncWait \ scr

        DEC     L1A0A     \ tm+2
        BNE     L2092     \ del1

        PLA
        TAY
        RTS

.nextLevel      \ .ef     \ L209D (&2098 in C.SOURCE if !pls=0)
        LDA     #$00
        STA     gameFlags    \ sc \ Reset gameFlags to zero
        CLC
        LDA     enemySpriteAddrLow        \ plf \ Enemy sprite address
        ADC     #$40                      \ Add $40 to get new aircraft
        STA     enemySpriteAddrLow        \ plf \ Store it back
		                                  \ Need an adc on the high byte here eventually
        LDA     #$64
        JSR     L208D   \ delay

        JMP     L1EE3   \ bf

.L20B1  \ .cht  (&20AC in C.SOURCE if !pls=0)
        LDA     #$03
        AND     level   \ fc
        TAX
        BNE     L20BC   \ ctl

        LDA     #$33
        RTS

.L20BC  \ .ctl  (&20B7 in C.SOURCE if !pls=0)
        DEX
        BNE     L20C3   \ ct2

        TXA
        LDX     #$0D
        RTS

.L20C3	\ .ct2  (&20BE in C.SOURCE if !pls=0)
        DEX
        BNE     L20CB   \ ct3
        LDA     #$11
        LDX     #$1A
        RTS

.L20CB  \ .ct3  (&20C6 in C.SOURCE if !pls=0)
        LDA     #$22
        LDX     #$26
        RTS

.L20D0  \ .patch  (&20CB in C.SOURCE if !pls=0)
        LDA     L007D    \ ra1
        BPL     L20DA    \ patch2

        LDA     L0080    \ sd
        EOR     #$C0
        STA     L0080    \ sd
		
.L20DA  \ .patch2  (&20D5 in C.SOURCE if !pls=0)
        LDA     L2D79    \ de
        RTS     \ dirn when above

.L20DE  \ .nxno (&20D9 in C.SOURCE if !pls=0)
        INC     L2382    \ nl
        LDY     L2382    \ nl
        LDA     L2382,Y  \ nl,Y
        STA     L0070    \ no
        AND     #$0E
        CMP     #$08
        BPL     L20F9    \ n1

        CLC
        ADC     L1D59    \ not
        STA     L0080    \ sd
        LDA     #$00
        BEQ     L2103    \ n2

.L20F9  \ .n1   (&20F4 in C.SOURCE if !pls=0)
        CLC
        ADC     L1D59    \ not
        ADC     #$78
        STA     L0080    \ sd
        LDA     #$02
		
.L2103 \ .n2    (&20FE in C.SOURCE if !pls=0)
        ADC     L1D5A    \ not+1
        STA     L0081    \ sd+1
        LDA     #HI(L2300)    \ #$23     \ Note sprite pointer
        STA     L0083    \ sf+1
        JSR     L213E    \ chnot

        CLC
        LDA     L1D59    \ not
        ADC     #$20
        STA     L1D59    \ not
        BCC     L211D    \ n3

        INC     L1D5A    \ not+1 \ Deal with page boundaries
		
.L211D  \ .n3   (&2118 in C.SOURCE if !pls=0)
        JSR     L2172    \ pno

        CLC
        LDA     L0080    \ sd
        ADC     #$08     
        STA     L0080    \ sd
        BCC     L212B    \ .n4

        INC     L0081    \ sd+1 \ Deal with page boundaries
		
.L212B  \ .n4   (&2126 in C.SOURCE if !pls=0)
        CLC
        LDA     L0082    \ sf
        ADC     #$08     \ Note sprite offset
        STA     L0082    \ sf \ Score sprite pointer low byte
        BCC     L2136    \ n5

        INC     L0083    \ sf+1 \ Deal with page boundaries
		
.L2136  \ .n5   (&2131 in C.SOURCE if !pls=0)
        JSR     L2172    \ pno

        INY
        LDA     L2382,Y  \ nl,Y
        RTS

.L213E  \ .chnot  (&2039 in C.SOURCE if !pls=0)
        LDA     #$80
        BIT     L0070    \ no
        BEQ     L2149    \ c1

        LDA     #LO(L1C00) \ $00   \ Number 0 sprite
        STA     L0082    \ sf
        RTS

.L2149  \ .c1   (&2144 in C.SOURCE if !pls=0)
        LSR     A
        BIT     L0070    \ no
        BEQ     L2153    \ c2

        LDA     #LO(L1C10) \ #$10
        STA     L0082    \ sf \ Number 1 sprite
        RTS

.L2153  \ .c2   (&214E in C.SOURCE if !pls=0)
        LSR     A
        BIT     L0070    \ no
        BEQ     L215D    \ c3

        LDA     #LO(L1C20) \ #$20
        STA     L0082    \ sf \ Number 2 sprite
        RTS

.L215D	\ .c3   (&2158 in C.SOURCE if !pls=0) \ Something to do with plotting dots on the stave
        LSR     A
        BIT     L0070    \ no
        BEQ     L2167    \ c4

        LDA     #LO(L1C30) \ #$30
        STA     L0082    \ sf \ Number 3 sprite
        RTS

.L2167  \ .c4   (&2162 in C.SOURCE if !pls=0)
        LDA     #$01
        BIT     L0070    \ no
        BEQ     L2171    \ c5

        LDA     #LO(L1C40) \ #$40   \ Number 4 sprite
        STA     L0082    \ sf
.L2171  \ .c5  (&216C in C.SOURCE if !pls=0)
        RTS

.L2172  \ .pno  (&216D in C.SOURCE if !pls=0) \ Possibly something to do with pigeon hit
        TYA
        PHA
        LDY     #$07
        CLC
        LDA     L0080    \ sd
        ADC     #$78
        STA     L0084    \ st
        LDA     L0081    \ sd+1
        ADC     #$02
        STA     L0085    \ st+1
        LDA     L0080    \ sd
        AND     #$07
        EOR     #$07
        STA     L0074    \ mod
        CMP     #$07
        BPL     L219A    \ top

.L218F  \ .bot  (&218A in C.SOURCE if !pls=0)
        LDA     (L0082),Y    \ (sf),Y
        ORA     (L0084),Y    \ (st),Y
        STA     (L0084),Y    \ (st),Y \ Draw note top(?) half
        DEY
        CPY     L0074        \ mod
        BNE     L218F        \ bot

.L219A  \ .top  (&2195 in C.SOURCE if !pls=0) \ not the culprit
        LDA     (L0082),Y    \ (sf),Y
        ORA     (L0080),Y    \ (sd),Y
        STA     (L0080),Y    \ Draw note bottom(?) half
        DEY
        BPL     L219A        \ top
        PLA
        TAY
        RTS

.playTune       \ .tune (&21A1 in C.SOURCE if !pls=0) \ L21A6  \ Sound routines (start of level chimes, bonus tunes etc); not the culprit
        STA     L0070        \ no
		
.playTuneLoop   \ .t1   (&21A3 in C.SOURCE if !pls=0) \ L21A8
        \ Sound player routine 
        LDY     L0070        \ no
        LDA     L23B2,Y      \ tl,Y
        BEQ     holdLoop     \ t3
        STA     L2DFC        \ (no label)
        INY
        LDA     L23B2,Y      \ tl,Y
        STA     L2DFE        \ (no label)
        LDX     #$F8         
        LDY     #$2D
        LDA     #$07
        JSR     osword       \ Play a sound
        INC     L0070        \ no
        INC     L0070        \ no
        JMP     playTuneLoop \ t1

.holdLoop       \ .t3 (&21C4 in C.SOURCE if !pls=0) \ L21C9 \ Wait for tune to (almost) finish?
        LDA     #$80
        LDX     #$FA          \ Sound channel 1
        JSR     osbyte        \ Read ADC channel or get buffer status
        CPX     #$0F
        BMI     holdLoop      \ t3
        RTS

\\\\\\ END OF 1st PART $.S (&21DF) ////// \\\\\\ C.SOURCE continues //////


.keyboardScan   \ (&21D0 in C.SOURCE if !pls=0) \ .L21D5
        LDA     #$81          \ X = (CC, AE, EF)
        LDY     #$FF          \     ( R,  S,  Q)
        JSR     osbyte        \ keyboard scan (Y=$FF)

        INX                   \ return X=0 if scanned key pressed (for BEQ)
        RTS
		
\\\\\\ END OF C.SOURCE FIRST PART ////

        EQUB    $E8,$60       \ could be INX : RTS? Don't think it will ever execute though
		EQUB    $00,$00,$00,$00,$00,$00
        EQUB    $00,$00,$00,$00,$00,$00,$00,$00

.drawStave      \ stv \ Draw stave    \ L21EE
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

\\\\ $.PIGSRCE at &2377 ////

.L2223  \ .mini \ not the culprit - load player lives address - Differs from PIGSRCE
        LDA     #LO(L1910) \ #$10
        STA     L0082      \ sf
        LDA     #HI(L1910) \ #$19
        STA     L0083      \ sf+1
        LDA     L1D57      \ gex+2
        STA     L0080      \ sd
        LDA     L1D58      \ gex+3
        STA     L0081      \ sd+1
        JMP     L2581      \ pb

\\\\ PIGSRCE &22AF ////

.L2238  \ .h0                  \ Death-check - .h0 in PIGSRCE
        LDA     #$20           \ Change to RTS for invincibility
        BIT     gameFlags      \ sc
        BNE     L2245          \ h1

        LDA     timer_L1D55    \ gex?
        BNE     L2278          \ h12?

.L2244  \ .stp4 \ PIGSRCE @ &238C
        RTS

.L2245  \ .h1   \ PIGSRCE @ &22BC
        LDX     #$00
        LDY     #$07
        JSR     L281D          \ D% \ Flash screen white when player hit

        LDA     #$07
        LDY     #$2D
        LDX     #$E0
        JSR     osword         \ Play a sound (player hit / lightning)

        LDA     #$FF
        STA     timer_L1D55    \ gex?
		
		\ Self-modifying code section
        LDA     #$60           \ RTS opcode
        STA     smc_L2C45      \ nbo
        STA     smc_L29F7      \ np
        STA     smc_L286E      \ mg
        STA     smc_L295E      \ nb
        JSR     L28D3          \ gun

        LDA     #HI(L1A10) \#$1A     \ Memory reference (lost life sprite 1)
        STA     L28D7          \ gun+4
        LDA     #LO(L1A10) \#$10     \ Memory reference (lost life sprite 1)
        STA     L28D6          \ gun+3
        JMP     L28D3          \ gun

.L2278  \ .h12  \ PIGSRCE @ &22EF
        DEC     timer_L1D55    \ gex \ Screen flash timer
        LDA     timer_L1D55    \ gex
        CMP     #$FE
        BNE     L2289          \ h3

        LDX     #$00
        LDY     #$00
        JMP     L281D          \ D% \ Unflash screen

.L2289  \ .h3   \ PIGSRCE @ &2300
        CMP     #$DC
        BNE     L2298          \ h4

        JSR     L28D3          \ gun

        LDA     #LO(L1A38)     \ #$38    \ Memory reference (lost life sprite 2)
        STA     L28D6          \ gun+3
        JMP     L28D3          \ gun

.L2298  \ .h4   \ PIGSRCE @ &230F
        CMP     #$8C
        BNE     L22A7          \ h5

        JSR     L28D3          \ gun

        LDA     #LO(L1A60)     \ #$60    \ Memory reference (Skull sprite)
        STA     L28D6          \ gun+3
        JMP     L28D3          \ gun

.L22A7  \ .h5   \ PIGSRCE @ &231E - Deviates
        CMP     #$01
        BNE     L2244          \ stp4

        DEC     L1D56          \ not in PIGSRCE
        BNE     L22B3          \ gun in PIGSRCE

        JMP     gameOver       \ not in PIGSRCE

.L22B3
        JSR     L28D3          \ gun

        JSR     L1FC1 \ not in PIGSRCE

        LDY     L2D13          \ !pls
		
.L22BC  \ .h6   \ PIGSRCE @ &2328
        LDA     (L0075),Y      \ (pls),Y
        CMP     #$C0
        BNE     L22DB          \ h8

        DEY
        LDA     (L0075),Y      \ (pls),Y
        BPL     L22DC          \ h9

        EOR     #$80
        STA     (L0075),Y      \ (pls),Y
        DEY
        LDA     (L0075),Y      \ (pls),Y
        STA     L0079          \ pos+1
        DEY
        LDA     (L0075),Y      \ (pls),Y
        STA     L0078          \ pos
        JSR     L2C08          \ pp

        JMP     L22DE          \ h10

.L22DB  \ .h8   \ PIGSRCE @ &2347
        DEY
.L22DC  \ .h9   \ PIGSRCE @ &2348
        DEY
        DEY
.L22DE  \ .h10  \ PIGSRCE @ &234A
        DEY
        DEY
        BNE     L22BC \ h6

.L22E2  \ .h7   \ PIGSRCE @ &234E    \ Self-modifying code calls
        LDA     #$20        \ JSR opcode
        STA     smc_L286E   \ mg
        LDA     #$A5        \ LDA zeropage opcode
        STA     smc_L29F7   \ np
        LDA     #$A9        \ LDA# opcode
        STA     smc_L2C45   \ nbo
        STA     smc_L295E   \ nb
		                    \ DEC/BEQ in PIGSRCE here
        SEC
        LDA     L1D57       \ gex+2
        SBC     #$18        \ #&20 in PIGSRCE
        STA     L1D57       \ gex+2
        JMP     L2223       \ mini (JSR in PIGSRCE)
		                    \ JMP sgun in PIGSRCE
							
\\\\\\ PIGSRCE continues at this point //////

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

.L2382  \ .nl
        EQUB    $0D,$4A,$18,$8C,$8E,$1C,$8A,$84
        EQUB    $14,$82,$20,$44,$05,$00,$48,$18
        EQUB    $86,$84,$14,$86,$84,$14,$88,$2A
        EQUB    $4E,$05,$00,$4A,$18,$8C,$8E,$1C
        EQUB    $8A,$84,$14,$82,$20,$44,$00,$44
        EQUB    $42,$42,$44,$46,$24,$14,$05,$00

.L23B2  \ .tl
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

.L240E  \ B% \ .pg? \ PIGSRCE @ &240E
        LDA     #HI(L1BB8)    \ #$1B     \ Pigeon sprite memory pointer \ &B in PIGSRCE
L240F = L240E+1          \ SMC - $1A = L-R $1B = R-L
        STA     L0083    \ sf+1
        LDA     L2D7D    \ ba+1
        BNE     L248E    \ b0

        LDA     #$42
        BIT     gameFlags \ sc
        BEQ     L248D     \ ep

        LDA     #$02
        BIT     L02FC     \ picn
        BEQ     L2444     \ pg1
		
        \ Wing hit? Send R-L pigeon
        LDA     #HI(L1BB8)    \ #$1B     \ Pigeon R-L sprite pointer \ #&B in PIGSRCE
        STA     L0083    \ sf+1
        STA     L240F    \ pg+1 \ self-modifying code
        LDA     #$68
        STA     L2D7C    \ ba
        STA     L0080    \ sd
        LDA     #$00     \ Pigeon end position?
        STA     L252F    \ xps+1
        LDA     #$4C
        STA     L2D7F    \ ba+3
        LDA     #$4B
        STA     L246C    \ b5-2
        BNE     L245F    \ b3

.L2444  \ .pg1  \ PIGSRCE @ &2444 \ Wing hit? Send L-R pigeon
        LDA     #HI(L1A88)    \ #$1A     \ Pigeon L-R sprite pointer \ &A in PIGSRCE
        STA     L0083    \ sf+1 \ need changing to #HI(something) (done)
        STA     L240F    \ pg+1
        LDA     #$00
        STA     L2D7C    \ ba
        STA     L0080    \ sd
        STA     L2D7F    \ ba+3
        LDA     #$4C     \ Pigeon end position?
        STA     L252F    \ xps+1
        LDA     #$49
        STA     L246C    \ b5-2

.L245F  \ .b3   \ PIGSRCE @ &245F
        LDA     #$00
        STA     L007C    \ py
        INC     L02FC    \ picn
        LDA     #$07
        AND     L007D    \ ra1
        TAX
.L246B
        LDA     #$4B     \ #&49 in PIGSRCE - Deviation
L246C = L246B+1 \ b5-2
        CLC
.L246E  \ .b5   \ PIGSRCE @ &246E
        ADC     #$05
        TAY
        LDA     L007C    \ py
        ADC     #$10
        STA     L007C    \ py
        TYA
        DEX
        BPL     L246E    \ b5

        STA     L2D7D    \ ba+1
        STA     L0081    \ sd+1
        LDX     #$02
        STX     L2D7E    \ ba+2
        LDA     L2D68,X  \ bis,X
        STA     L0082    \ sf
        JMP     L2581    \ pb

.L248D  \ .ep   \ PIGSRCE @ &248D
        RTS

.L248E  \ .b0   \ PIGSRCE @ &248E
        LDA     L2D7C    \ ba
        STA     L0080    \ sd
        LDA     L2D7D    \ ba+1
        STA     L0081    \ sd+1
        BPL     L24B2    \ b1

        DEC     L2D7E    \ ba+2
        BNE     L248D    \ ep

        EOR     #$80
        STA     L0081    \ sd+1
        LDA     #$10
        ORA     gameFlags \ sc
        STA     gameFlags \ sc
        LDA     #$00      \ missing from PIGSRCE
        STA     L2D7D
        BEQ     L24FE     \ bx?

.L24B2  \ .b1   \ PIGSRCE @ &24B2
        LDA     L2D7E     \ ba+2
        AND     #$7F
        TAX
        LDA     L2D68,X   \ bix,X
        STA     L0082     \ sf
        LDY     #$00
        LDA     (L008A),Y \ (bulst),Y
        STA     L0070     \ no
		
.L24C3  \ .h    \ PIGSRCE @ &24C3
        INY
        LDA     (L008A),Y \ (bulst),Y
        SEC
        SBC     L007C     \ py
        BMI     L2517     \ nh

        CMP     #$07
        BPL     L2517     \ nh

        INY
        INY
        LDA     (L008A),Y \ (bulst),Y
        BEQ     L2519     \ nh+2

        INY
        LDA     (L008A),Y \ (bulst),Y
        SEC
        SBC     L2D7F     \ ba+3
        BMI     L251A     \ nh+3

        CMP     #$03
        BPL     L251A

        LDA     #$E8
        STA     (L008A),Y
        TAX
        LDA     #$07
        LDY     #$2D
        JSR     osword        \ Play a sound (pigeon hit)

        LDA     #$10
        STA     L2D7E         \ ba+2
        LDA     #$80
        ORA     L2D7D         \ ba+1
        STA     L2D7D         \ ba+1
        JSR     L2581         \ pb

.L24FE  \ .bx   \ PIGSRCE @ &24FE    \ hit pigeon sprite plot
        LDA     #HI(L1B70) \ #$1B    \ Possible memory address (&B in PIGSRCE)
        STA     L0083         \ sf+1
        LDA     #LO(L1B70) \ #$70    \ Possible memory address
        STA     L0082         \ sf
        JMP     L2581         \ pb

.L2509  \ .b9   \ PIGSRCE @ &2509
        LDA     #$04
        ORA     gameFlags     \ sc
        STA     gameFlags     \ sc
        LDA     #$00
        STA     L2D7D         \ ba+1
		
.L2516  \ .x    \ PIGSRCE @ &2516
        RTS

.L2517  \ .nh   \ PIGSRCE @ &2517
        INY
        INY
.L2519  \ .nh+2
        INY
.L251A  \ .nh+3
        CPY     L0070         \ no
        BMI     L24C3         \ h

        LDA     #$80
        EOR     L2D7E         \ ba+2
        STA     L2D7E         \ ba+2
        BMI     L2516         \ x

        JSR     L2581         \ pb

        LDA     L2D7F         \ ba+3
		
.L252E  \ .xps  \ PIGSRCE @ &252E
        CMP     #$00          \ #76 in PIGSRCE
L252F = L252E+1               \ xps+1  \ SMC?
        BEQ     L2509         \ b9

        AND     #$1F
        BNE     L253F         \ b6

        LDA     #$07
        LDY     #$2D
        LDX     #$F0
        JSR     osword        \ Play a sound (pigeon chirp...just like pigeons do (no pun intended))

.L253F  \ .b6   \ PIGSRCE @ &253F
        LDX     L2D7E         \ ba+2
        DEX
        BPL     L2547         \ b7

        LDX     #$07
		
.L2547  \ .b7   \ PIGSRCE @ &2547
        STX     L2D7E         \ ba+2
        LDA     L2D68,X       \ bis,X
        STA     L0082         \ sf
        LDA     L252F         \ xps+1
        BEQ     L256C         \ b10

        INC     L2D7F         \ ba+3
        CLC
        LDA     L2D7C         \ ba
        ADC     #$08
        STA     L2D7C         \ ba
        STA     L0080         \ sd
        BCC     L2581         \ pb

        INC     L2D7D         \ ba+1
        INC     L0081         \ sd+1
        JMP     L2581         \ pb

.L256C  \ .b10  \ PIGSRCE @ &256C
        DEC     L2D7F         \ ba+3
        SEC
        LDA     L2D7C         \ ba
        SBC     #$08
        STA     L2D7C         \ ba
        STA     L0080         \ sd
        BCS     L2581         \ pb

        DEC     L2D7D         \ ba+1
        DEC     L0081         \ sd+1
		
.L2581  \ .pb   \ PIGSRCE @ &2581
        LDY     #$17
		
.L2583 \ .b8     \ PIGSRCE @ &2583     \ not the culprit
        LDA     (L0082),Y     \ (sf),Y
        EOR     (L0080),Y     \ (sd),Y
        STA     (L0080),Y     \ (sd),Y \ Draw pigeon
        DEY
        BPL     L2583         \ b8

        RTS
		
\\\\\\\\\\\\\ END OF PIGSRCE ///////////////

.L258D  \ X%
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

.L25B8  \ R% (random?)   \ RNG?
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
						 
.drawLineArt    \ V%     \ .L25C9
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

.L261A  \ C%
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

.L281D  \ D% \ PLOT X, Y, 00 ?
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

.L2835  \ E% \ Define envelopes
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

.vsyncWait  \ .scr            \ L284A
        LDA     #$02          \ https://tobylobster.github.io/mos/mos/S-s3.html
        STA     LFE4E         \ Enable vsync interrupt
		
.vsyncLoop      \ L284F
        BIT     LFE4D
        BEQ     vsyncLoop     \ Wait for vsync

        LDA     #$82
        STA     LFE4E         \ Disable vsync interrupt
        RTS

.L285A  \ .w
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
		
\\\\\\ $.OLDSOURCE matches from here to &2D0A with some minor exceptions //////		

.smc_L286E \ .mg ($.OLDSRCE) (move gun?) \ ZX key processing
        RTS     \ but changes in code to &20 (JMP $28D3) .L2245/.L22E2
        EQUB    $D3,$28 \ address for JMP above (gun)

        LDA     #$81      \ .L2871
        LDY     #$FF
        LDX     #$BD      \ X key (INKEY value)
        JSR     osbyte    \ Keyboard scan
        INX
        BEQ     L289E     \ r \ X pressed
        DEY
        LDX     #$9E      \ Z key (INKEY value)
        JSR     osbyte    \ Keyboard scan
        INX
        BNE     L28B4     \ gd \ Not Z
        LDX     playerXpos     \ Xg \ $2D70     \ X pos?
        CPX     #$01           \ Player min X bound
        BEQ     L28B4     \ gd
        DEX
        STX     playerXpos     \ Xg $2D70
        SEC
        LDA     $86       \ gunp
        SBC     #$08
        STA     $86       \ gunp
        BCS     L28B4     \ gd
        DEC     $87       \ gunp+1
        BCC     L28B4     \ gd \ 'always'
		
.L289E  \ .r ($.OLDSRCE)
        LDX     playerXpos     \ Xg \ $2D70
        CPX     #$47           \ player max X bound
        BEQ     L28B4          \ gd
        INX
        STX     playerXpos     \ Xg \ $2D70
        CLC
        LDA     L0086          \ gunp \ $86
        ADC     #$08
        STA     L0086          \ gunp \ $86
        BCC     L28B4          \ gd
        INC     L0087          \ gunp+1 \ $87
		
.L28B4  \ .gd ($.OLDSRCE)
        SEC
        LDA     #$00
        STA     L0078          \ pos \ $78
        LDY     #$24
		
.L28BB  \ .ch ($.OLDSRCE)
        LDA     (L0086),Y      \ (gunp),Y \ $86
        BEQ     L28C1          \ cop
        STA     L0078          \ pos \ $78
		
.L28C1  \ .cop ($.OLDSRCE)
        TYA
        SBC     #$08
        TAY
        BPL     L28BB      \ ch
        LDA     L0078      \ pos \ $78
        BEQ     L28D3      \ gun
        LDA     gameFlags  \ sc \ $2D76
        ORA     #$20
        STA     gameFlags  \ sc \ $2D76

.L28D3  \ .gun ($.OLDSRCE)
        LDY     #$27
		
.L28D5  \ .gop ($.OLDSRCE)
        LDA     L1A60,Y    \ gunf,Y \ Load skull sprite?
L28D6 = L28D5+1 \ gun+3    \ SMC - player sprite / hit / skull
L28D7 = L28D5+2 \ gun+4    \ SMC - player sprite / hit / skull
        BEQ     L28DE      \ gz

        EOR     (L0086),Y  \ (gunp),Y
        STA     (L0086),Y  \ (gunp),Y
		
.L28DE  \ .mb (move bullet?) \ .gz in ($.OLDSRCE
        DEY
        BPL     L28D5        \ gop
        RTS

.L28E2  \ .mb ($.OLDSRCE)
        LDY     #$00
        LDA     (L008A),Y   \ (bulst),Y
        STA     L0070       \ no
        LDA     L2D72       \ buf
        STA     L0082       \ st
        LDA     bulletSprite\ buf+1
        STA     L0083       \ sf+1
		
.L28F2  \ .ntbu
        INY
        LDA     (L008A),Y   \ (bulst),Y
        STA     L0077       \ exp
        INY
        LDA     (L008A),Y   \ (bulst),Y
        STA     L0080       \ sd
        INY
        LDA     (L008A),Y   \ (bulst),Y
        STA     L0081       \ sd+1
        BNE     L290D       \ bu1

        INY
        LDA     #$FE
        AND     L0071
        STA     L0071
        JMP     L2947

.L290D  \ .bu1 ($.OLDSRCE)
        INY
        JSR     L29C3       \ s5

        LDA     (L008A),Y   \ (bulst),Y
        BPL     L291B       \ bu2

.L2915  \ .bu7 ($.OLDSRCE)
        LDA     #$00
        STA     L0081       \ sd+1
        BEQ     L2947       \ nxby \ 'alws'

.L291B  \ .bu2
        SEC
        LDA     #$07
        AND     L0080       \ sd
        CMP     #$05
        BMI     L292D       \ bu3
        LDA     L0080       \ sd
        SBC     #$05
        STA     L0080       \ sd
        JMP     L2939       \ bu4

.L292D  \ .bu3 ($.OLDSRCE)
        LDA     L0080       \ sd
        SBC     #$7D
        STA     L0080       \ sd
        LDA     L0081       \ sd+1
        SBC     #$02
        STA     L0081       \ sd+1
		
.L2939  \ .bu4 ($.OLDSRCE)
        SEC
        LDA     L0077       \ exp
        SBC     #$05
        STA     L0077       \ exp
        CMP     #$02
        BEQ     L2915       \ bu7
        JSR     L29C3       \ s5

.L2947  \ .nxbu ($.OLDSRCE) \ Player bullet plotting?
        DEY
        DEY
        DEY
        LDA     L0077       \ exp
        STA     (L008A),Y   \ (bulst),Y
        INY
        LDA     L0080       \ sd
        STA     (L008A),Y   \ (bulst),Y
        INY
        LDA     L0081       \ sd+1
        STA     (L008A),Y   \ (bulst),Y
        INY
        CPY     L0070       \ no
        BMI     L28F2       \ ntbu
        RTS

.smc_L295E \ .nb ($.OLDSRCE) \ Check for fire press
        RTS     \ Changed in code to LDA# $01

.L295F
        EQUB    $01    \ for when smc_L295E changes to LDA 
		
.L2960  BIT     L0071  \ bfg \ $71
        BNE     L2976  \ nwb0
        LDA     #$81   
        LDY     #$FF
        LDX     #$B6   \ Deviates - &A6 in $.OLDSRCE \ Return key (INKEY value)
        JSR     osbyte \ Keyboard scan
        INX
        BEQ     L2977  \ nwb1
		
.L2970  \\\\\\\ $.S overwrites the code of $.G here //////
        \\\\\\\ C.SOURCE CONTAIN THIS //////
        LDA     #$00
        STA     L14AD  \ fp0 \ $14AD
        RTS
                    
.L2976 \ .nwb0 ($.OLDSRCE)
        RTS
                    
.L2977 \ .nwb1 - Deviates from $.OLDSRCE 
        JMP     L149C  \ fpat

\\\\\\ This section is a hangover from the 'G' file ///////
        \ ADC     ($D0),Y
        \.L297C  SBC     $FFA0,Y
        
		\ L297D = L297C + 1	
        EQUB    $71,$D0,$F9  \ This may be code... but probably isn't. Never executes.
\\\\\\                                              ///////

.L297D  LDY     #$FF

.L297F  \ .nwb2
        INY
        INY
        INY
        INY
        LDA     (L008A),Y    \ (bulst),Y \ $8A
        BNE     L297F        \ nwb2
        DEY
        DEY
        LDA     #$9D
        STA     (L008A),Y    \ (bulst),Y \ $8A
        INY
        SEC
        LDA     L0086        \ gunp \ $86
        SBC     #$6E
        STA     (L008A),Y    \ (bulst),Y \ $8A
        STA     L0080        \ sd \ $80
        INY
        LDA     L0087        \ gunp+1 \ $87
        SBC     #$02
        STA     (L008A),Y    \ (bulst),Y \ $8A
        STA     L0081        \ sd+1 \ $81
        INY
        LDA     playerXpos   \ Xg \ $2D70
        CLC
        ADC     #$03
        STA     (L008A),Y    \ (bulst),Y \ $8A
        JSR     L29C3        \ s5
        LDA     #$03
        ORA     L0071        \ bfg \ $71
        STA     L0071        \ bfg \ $71
        LDA     #$01
        ORA     gameFlags    \ sc \ $2D76
        STA     gameFlags    \ sc \ $2D76
        LDA     #$07    
        LDY     #$2D
        LDX     #$D0
        JMP     osword    \ Play a sound (player fire)

.L29C3  \ .s5 ($.OLDSRCE) 
        \ Bullet plotting?    \ RTSing here prevents bug
        TYA     \ Y is high ($18) here when the bug hits (called from $2cbd)
        PHA
        LDY     #$05
        CLC
        LDA     L0080    \ sd
        ADC     #$78
        STA     L0084    \ st
        LDA     L0081    \ sd+1
        ADC     #$02
        STA     L0085    \ st+1
        LDA     L0080    \ sd
        AND     #$07
        EOR     #$07
        STA     L0074    \ mod
        CMP     #$05
        BPL     L29EB    \ top

.L29E0  \ .bot ($.OLDSRCE)
        \ Not the culprit...or is it?
        LDA     (L0082),Y    \ (sf),Y
        EOR     (L0084),Y    \ (st),Y
        STA     (L0084),Y    \ (st),Y
		
							 \ B-Em at point of crash w/ wp on writes to $2852:
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
        CPY     L0074        \ mod
        BNE     L29E0        \ bot

.L29EB  \ .top ($.OLDSRCE)
        \ triggered when bomb dropped - smooth animation as per screen memory layout
        \ not the culprit, but is complicit (code address in $80)
        LDA     (L0082),Y    \ (sf),Y
        EOR     (L0080),Y    \ (sd),Y  \ Un-draw bomb?
        STA     (L0080),Y    \ (sd),Y  \ Draw bomb
        DEY
        BPL     L29EB        \ top

        PLA
        TAY
        RTS

.smc_L29F7 \ .np ($.OLDSRCE)
        \ Something to do with next enemy
        RTS     \ Changed to LDA (opcode $A5) zeropage by L22E2, back to RTS (opcode $60) by L2245

        EQUB    L0072    \ $72    \ zeropage address when .smc_L29F7 is an LDA (pflg)
		
.L29F9
        CMP     #$01
        BPL     L2A37    \ nw
        DEC     L2D7A    \ ti \ $2D7A
        BNE     L2A37    \ nw
        LDA     L2D7B    \ ti+1 \ $2D7B
        STA     L2D7A    \ ti   \ $2d7A
        LDA     L0070    \ no   \ $70
        JSR     L2CFA    \ ra2
        TAY
        SEC
		
.L2A0F  \ .n2 ($.OLDSRCE)
        SBC     #$05
        BPL     L2A0F        \ n2
        TAX
		
.L2A14  \ .n3 ($.OLDSRCE)
        INY
        INX
        BNE     L2A14        \ n3
        DEY
        LDA     (L0075),Y    \ (pls),Y \ $75
        BMI     L2A33        \ fy
        LDY     L0070        \ no \ $70
		
.L2A1F  \ .se ($.OLDSRCE)
        DEY
        LDA     (L0075),Y    \ (pls),Y \ $75
        BMI     L2A33        \ fy
        DEY
		DEY
		DEY
		DEY
        BNE     L2A1F        \ se
        LDA     #$80
        ORA     gameFlags    \ sc \ $2D76
        STA     gameFlags    \ sc \ $2D76
        RTS
                    
.L2A33  \ .fy ($.OLDSRCE)
        EOR     #$80
        STA     (L0075),Y    \ (pls),Y \ $75
		
.L2A37  \ .nw ($.OLDSRCE)
        RTS		
		
.L2A38  \ .pxp ($.OLDSRCE)   \ Enemy explosion
        LDA     L0077        \ exp
        BEQ     L2A91        \ nx

        LDX     #HI(L1910)   \ #$19   \ Deviates - #9 in $.OLDSRCE
        STX     enemySpriteAddrHigh   \ plf+1
        LDA     enemySpriteAddrLow    \ plf
        PHA
        LDA     L0077        \ exp
        CMP     #$15
        BNE     L2A53        \ px1

        LDA     #LO(L2F40)    \ #$40
        STA     enemySpriteAddrLow
        JSR     L2C08

        JMP     L2A88

.L2A53  \ .px1 ($.OLDSRCE)
        CMP     #$0C
        BNE     L2A68         \ px2

        LDA     #LO(L2F40)    \ #$40  \ Deviates - #0 in $.OLDSRCE
        STA     enemySpriteAddrLow    \ plf
        JSR     L2C08         \ pp

        LDA     #LO(L2F80)    \ #$80
        STA     enemySpriteAddrLow
        JSR     L2C08

        JMP     L2A88

.L2A68  \ .px2 ($.OLDSRCE)
        CMP     #$06
        BNE     L2A7D         \ px3

        LDA     #LO(L2F80)    \ #$80  \ Deviates - #&40 in  $.OLDSRCE
        STA     enemySpriteAddrLow    \ plf
        JSR     L2C08         \ pp

        LDA     #LO(L2FC0)    \ #$C0
        STA     enemySpriteAddrLow
        JSR     L2C08

        JMP     L2A88

.L2A7D  \ .px3 ($.OLDSRCE)
        CMP     #$01
        BNE     L2A88         \ px4

        LDA     #LO(L2FC0)    \ #$C0
        STA     enemySpriteAddrLow    \ plf
        JSR     L2C08         \ pp

.L2A88  \ .px4 ($.OLDSRCE)
        LDA     #HI(L2F00)    \ #$2F
        STA     enemySpriteAddrHigh   \ plf+1
        PLA
        STA     enemySpriteAddrLow    \ plf+1
        DEC     L0077         \ exp
		
.L2A91  \ .nx  ($.OLDSRCE)
        JMP     L2BE4         \ fo+3

.L2A94  \ .mp ($.OLDSRCE)
        LDY     #$00
        LDA     (L0075),Y     \ (pls),Y
        STA     L0070         \ no
        STY     L0072         \ pflg
		
.L2A9C  \ .nxpl ($.OLDSRCE)
        INY
        LDA     (L0075),Y     \ (pls),Y
        STA     L0077         \ exp
        INY
        LDA     (L0075),Y     \ (pls),Y
        STA     L0078         \ pos
        INY
        LDA     (L0075),Y     \ (pls),Y
        STA     L0079         \ pos+1
        INY
        LDA     (L0075),Y     \ (pls),Y
        STA     L007A         \ psta
        INY
        LDA     (L0075),Y     \ (pls),Y
        STA     L007B         \ yo
        LDA     L0077         \ exp
        AND     #$C0
        BNE     L2ABE         \ p0

        JMP     L2A38         \ pxp

.L2ABE  \ .p0 ($.OLDSRCE)
        LDA     L007A         \ psta
        BPL     L2AC5         \ p1

        JMP     L2C00         \ pl1

.L2AC5  \ .p1 ($.OLDSRCE)
        DEC     L0077         \ exp
        TYA
        PHA
        LDY     #$00
        LDA     (L008A),Y     \ (bulst),Y
        STA     L0080         \ sd
		
.L2ACF  \ .h  ($.OLDSRCE)
        INY
        LDA     (L008A),Y     \ (bulst),Y
        SEC
        SBC     L007B         \ yo
        BMI     L2B1E         \ nh

        CMP     #$08
        BPL     L2B1E         \ nh

        INY
        INY
        LDA     (L008A),Y     \ (bulst),Y
        BEQ     L2B20         \ nh+2

        INY
        LDA     (L008A),Y     \ (bulst),Y
        SEC
        SBC     L007A         \ psta
        BMI     L2B21         \ nh+3

        CMP     #$07          \ Wing hit?
        BPL     L2B21         \ nh+3

        CMP     #$03          \ Critical hit
.L2AEF  BEQ     L2AFE         \ $2AEF Change to BNE for easy kills (EOR $20)

        LDA     #$40          \ Trigger pigeon
        ORA     gameFlags
        STA     gameFlags
        ASL     A
        STA     (L008A),Y
        BNE     L2B21

.L2AFE  \ .o ($.OLDSRCE) \ Enemy critical hit
        LDA     #HI(L1940)    \ Deviates - #25 in $.OLDSRCE\#$19    \ possible memory reference (L19xx) - enemy explosion
        STA     L0077    \ exp
        LDA     #$D8     \ what is this?
        STA     (L008A),Y \ (bulst),Y \ ?(2D0A+8)
        TAX
        LDA     #$07
        LDY     #$2D
        JSR     osword        \ Play a sound (enemy explosion)

        PLA
        TAY
        LDA     #$02
        ORA     gameFlags \ sc
        STA     gameFlags \ sc
        JSR     L2C08     \ pp

        JMP     L2A38     \ pxp

.L2B1E  \ .nh ($.OLDSRCE)
        INY
        INY
.L2B20
        INY
.L2B21
        CPY     L0080    \ sd
        BMI     L2ACF    \ h

        PLA
        TAY
        LDA     L0073    \ bofg \ $3F/$FF makes all the planes descend at once
        AND     #$BF     
        STA     L0073    \ bofg
        INC     L0072    \ pflg
        JSR     L2C08    \ pp

        LDA     L007B    \ yo
        CMP     #$AF
        BNE     L2B4C    \ hop5

        SEC
        LDA     L0078    \ pos
        SBC     #$87
        STA     L0078    \ pos
        LDA     L0079    \ pos+1
        SBC     #$48 
        STA     L0079    \ pos+1
        LDA     #$C0     \ what is this?
        STA     L007B    \ yo
        JSR     L14D9    \ deviates - h9 in $.OLDSRCE

.L2B4C  \ .hop5 ($.OLDSRCE)
        LDA     #$3F
        AND     L0077     \ exp
        BNE     L2B88     \ mid
        SEC
        LDA     L007A     \ psta
        SBC     playerXpos    \ Xg
        STA     L0077     \ exp
        LDA     #$00
        BCS     L2B60     \ pl3

        SEC
        ROR     A
		
.L2B60  \ .pl3
        ROR     A
        STA     L0080    \ sd
        LDA     L0077    \ exp
        BNE     L2B6A    \ pl5

        JSR     L20D0    \ &FFFF in $.OLDSRCE...which is odd.

.L2B6A  \ .pl5 ($.OLDSRCE)
        BPL     L2B71    \ pl4
        EOR     #$FF
        CLC
        ADC     #$01
		
.L2B71  \ .pl4 ($.OLDSRCE)
        CMP     #$02
        BMI     L2B84    \ pl6
        STA     L2D03    \ ra3+1
        JSR     L2CFD    \ ra2+3
        LSR     L2D03    \ ra3+1
        CLC
        ADC     L2D03    \ ra3+1
        AND     #$3F
		
.L2B84  \ .pl6 ($.OLDSRCE)
        ORA     L0080    \ sd
        STA     L0077    \ psta
		
.L2B88  \ .mid ($.OLDSRCE)
        LDA     L0077    \ exp
        LDX     L007A    \ psta
        CPX     #$01
        BPL     L2B97    \ nl

        ORA     #$40
        AND     #$7F
        JMP     L2B9F    \ do

.L2B97  \ .nl ($.OLDSRCE)
        CPX     #$48
        BMI     L2BA1    \ do+2

        ORA     #$80
        AND     #$BF
		
.L2B9F  \ .do ($.OLDSRCE)
        STA     L0077    \ exp
.L2BA1
        INC     L007B    \ yo
        LDA     #$07
        AND     L0078    \ pos
        CMP     #$07
        BEQ     L2BB0    \ pl2

        INC     L0078    \ pos
        JMP     L2BBD    \ lft

.L2BB0  \ .pl2 ($.OLDSRCE)
        CLC
        LDA     L0078    \ pos
        ADC     #$79
        STA     L0078    \ pos
        LDA     L0079    \ pos+1
        ADC     #$02
        STA     L0079    \ pos+1
		
.L2BBD  \ .lft? ($.OLDSRCE differs)
        JMP     L146A    \ LDA exp : \ ROLA in $.OLDSRCE
		
		
.L2BC0  BCC     L2BD1    \ rgt
        DEC     L007A    \ psta \ $7A
        LDA     L0078    \ pos \ $78
        SBC     #$08
        STA     L0078    \ pos \ $78
        BCS     L2BE1    \ fo
        DEC     L0079    \ pos+1 \ $79
        JMP     L2BE1    \ fo
                    
.L2BD1  \ .rgt ($.OLDSRCE)
        INC     L007A    \ psta \ $7A
        ROL     A
        BCC     L2BE1    \ fo
        CLC
        LDA     L0078    \ pos \ $78
        ADC     #$08
        STA     L0078    \ pos \ $78
        BCC     L2BE1    \ fo
        INC     L0079    \ pos+1 \ $79		

.L2BE1  \ .fo ($.OLDSRCE)
        JSR     L2C08    \ pp

.L2BE4  \ .fo+3
        DEY
        DEY
        DEY
        DEY
        LDA     L0077     \ exp
        STA     (L0075),Y \ (pls),Y
        INY
        LDA     L0078     \ pos
        STA     (L0075),Y \ {pls),Y
        INY
        LDA     L0079     \ pos+1
        STA     (L0075),Y \ (pls),Y
        INY
        LDA     L007A     \ psta
        STA     (L0075),Y \ (pls),Y
        INY
        LDA     L007B     \ yo
        STA     (L0075),Y \ (pls),Y
		
.L2C00  \ .pl1 ($.OLDSRCE)
        CPY     L0070   \ no
        BEQ     L2C07   \ hop7

        JMP     L2A9C   \ nxpl

.L2C07  \ .hop7 ($.OLDSRCE)
        RTS

.L2C08  \ .pp  ($.OLDSRCE) (plot plane?) Enemy drawing?
        TYA
        PHA
        CLC
        LDA     L0078   \ pos
        ADC     #$78    \ interlace?
        STA     L0084   \ st
        AND     #$07    \ 0 - 7
        EOR     #$07    \ 7 - 0
        STA     L0074   \ mod
        LDA     L0079   \ pos+1
        ADC     #$02
        STA     L0085   \ st+1
.L2C1D
        LDY     #$3F
L2C1E = L2C1D+1

.L2C1F  \ .plo ($.OLDSRCE)
        LDX     #$07
        CPX     L0074        \ mod
        BEQ     L2C33        \ tp

.L2C25  \ .bt ($.OLDSRCE)
        LDA     (enemySpriteAddrLow),Y   \(plf),Y
        BEQ     L2C2D        \ bz

        EOR     (L0084),Y    \ (st),Y
        STA     (L0084),Y    \ (st),Y \ NOPping this causes enemies to flicker. Memory copy for smooth animation?
		
.L2C2D  \ .bz ($.OLDSRCE)
        DEY
        DEX
        CPX     L0074      \ mod
        BNE     L2C25      \ bt

.L2C33  \ .tp  ($.OLDSRCE)
        LDA     (enemySpriteAddrLow),Y   \ (plf),Y
        BEQ     L2C3B      \ tz

        EOR     (L0078),Y  \ (pos),Y
        STA     (L0078),Y  \ (pos),Y
		
.L2C3B  \ .tz ($.OLDSRCE)
        DEY
        DEX
        BPL     L2C33  \ tp
        TYA
        BPL     L2C1F  \ plo

        PLA
        TAY
        RTS

.smc_L2C45      \ .nbo ($.OLDSRCE)       \ Drop a bomb if $2C49!=$60
        RTS     \ Gets changed to $A9 (LDA#) by L22E2

        EQUB    $C0    \ Making this the value being loaded into A
		BIT     L0073  \ bofg \ and this the next instruction
		
.L2C49  BNE     L2C91  \ nbo4 \ Only drop bomb if top bit of L0073 is clear (and...) - SteveF
        DEC     L0073  \ bofg
        BNE     L2C91  \ nbo4
        LDY     #$FF
		
.L2C51  \ .nbo2 ($.OLDSRCE)
        INY
        INY
        INY
        INY
        INY
        LDA     (L0075),Y    \ (pls),Y \ $75
        BMI     L2C51        \ nbo2
        DEY
        DEY
        DEY
        LDA     (L0075),Y    \ (pls),Y \ $75
        AND     #$C0
        BNE     L2C69        \ nbo5
        INY
        INY
        INY
        JMP     L2C51        \ nbo2
                    
.L2C69  \ .nbo5 ($.OLDSRCE)
        INY
        CLC
        LDA     (L0075),Y    \ (pls),Y \ $75
        ADC     #$9D
        STA     L0080        \ sd \$80
        INY
        LDA     (L0075),Y    \ (pls),Y \ $75
        ADC     #$02
        STA     L0081        \ sd+1 \ $81
        JSR     L29C3        \ s5
        LDY     #$00
		
.L2C7D  \ .nbo3 ($.OLDSRCE) 
        INY                  \ Find a free bomb slot
        INY
        LDA     (L008C),Y    \ (bost),Y \ $8C
        BNE     L2C7D        \ nbo3
        LDA     L0081        \ sd+1 \ $81
        STA     (L008C),Y    \ (bost),Y \ $8C
        DEY
        LDA     L0080        \ sd \ $80
        STA     (L008C),Y    \ (bost),Y \ $8C
        LDA     useless      \ inb \ $2D71
        STA     L0073        \ bofg \ $73
		
.L2C91  \ .nbo4 ($.OLDSRCE)
        LDA     #$C0         \ 
        ORA     L0073        \ bofg \ $73
        STA     L0073        \ bofg \ $73
        RTS
		
.L2C98  \ .mbo ($.OLDSRCE)                  \ Something to do with enemy bomb plotting
        LDY     #$00                        \ Y = 0
        LDA     (L008C),Y                   \ (bost),Y\ A = ?(&2D47+0)
		
		\ NOPping the following line out may be the best glitch-fix option? No - bombs!
        STA     L0070                       \ no \ ?&70 = A                (=?&2D47)
        LDA     L2D74                       \ bof \ ?&2D74 = A              (seems pointless!)
        STA     L0082 \ Store bomb sprite LO\ sf \ ?&82 = A                (=?&2D47)
        LDA     L2D75                       \ bof+1 \ A = ?&2D75
        STA     L0083 \ Store bomb sprite HI\ sf+1 \ ?&83 = A                (=?&2D75)
		
.L2CA8  \ .ntbo ($.OLDSRCE)                 \ Loop to 'do stuff' to bombs, SteveF on stardot
        INY                                 \ Y = Y + 1               (Y = 1)
        LDA     (L008C),Y                   \ (bost),Y \ A = ?(&2D47+1)          (A = ?&2D48)
        STA     L0080                       \ sd \ ?&80 = A                (A = ?&2D48)
        INY                                 \ Y = Y + 1               (Y = 2)
        LDA     (L008C),Y                   \ (bost),Y \ A = ?&(2D47+2)          (A = ?&2D49)
        STA     L0081                       \ sd+1 \ ?&81 = A (?(&2D47+2))   (?&81 = ?&2D49)
        BNE     L2CBD                       \ bo1 \ Branch if not zero to .L2CBD

        LDA     #$7F                        \ A = &7F
        AND     L0073                       \ bofg \ A = &7F AND ?&73        (clear top bit)
        STA     L0073                       \ bofg \ ?&73 = A
        JMP     L2CF5                       \ bo7 \ Goto .L2CF5

.L2CBD  \ .bo1 ($.OLDSRCE)
        JSR     L29C3                       \ s5 \ PROC L29C3, then back here

        LDA     L0080                       \ sd \ A = ?&80
        AND     #$07                        \ A = A AND 7 (set bit 7)
        CMP     #$06                        \ A = 6
        BPL     L2CD1                       \ bo2 \ IF A > 6 goto .L2CD1 (check this)

        INC     L0080                       \ sd \ ?&80 = ?&80 + 1
        INC     L0080                       \ sd \?&80 = ?&80 + 1
        LDA     L0081                       \ sd+1 A = ?&81
        JMP     L2CDE                       \ bo4 \ Goto .L2CDE

.L2CD1  \ .bo2 ($.OLDSRCE)
        CLC                                 \ Clear carry
        LDA     L0080                       \ sd \ A = ?&80
        ADC     #$7A                        \ A = A + ?&7A (C=0)
        STA     L0080                       \ sd \ ?&80 = A
        LDA     L0081                       \ sd+1 \ A = ?&81
        ADC     #$02                        \ A = A + 2
        STA     L0081                       \ sd+1 \ ?&81 = A
		
.L2CDE  \ .bo4 ($.OLDSRCE)
        \ Triggered when bomb hits bottom of screen
        CMP     #$80                        \ A = &80 (128)? 
        BMI     L2CE8                       \ bo6 \ Less? Goto .L2CE8   (check this)

        LDA     #$00                        \ A = 0
        STA     (L008C),Y                   \ (bost),Y\ ?&(2D47+0) = 0
        BEQ     L2CF5                       \ bo7 \ Goto .L2CF5 '\ always'

.L2CE8  \ .bo6 ($.OLDSRCE)
        JSR     L29C3                       \ s5 \ PROC L29C3

        DEY                                 \ Y = Y - 1
        LDA     L0080                       \ sd \ A = ?&80
		
		\ How does Y get to 19 here if $1A09 ~= $1A?
		\ Because of the loop at L2CA8 - Y incs depending on the value of ?&2D47
        STA     (L008C),Y                   \ (bost),Y \ $(2D47+Y)    \ ?&(2D47+Y) = ?&80
		\
		
        INY                                 \ Y = Y + 1
        LDA     L0081                       \ sd+1 \ A = ?&81
        STA     (L008C),Y                   \ (bost),Y \ $(2D47+Y)    \ ?&(2D47+Y) = ?&81
		
.L2CF5  \ .bo7 ($.OLDSRCE)
        CPY     L0070                       \ no \ Y : ?&70?
        BMI     L2CA8                       \ Intbo \ Branch if minus to .L2CA8 (loop) *** No glitch if this NOPped J'accuse surtout

        RTS                                 \ Return

.L2CFA  \ .ra2 ($.OLDSRCE)
        STA     L2D03                       \ Does this ever execute? Yes, from .L29F9

.L2CFD
        SEC
        LDA     L007C       \ ra1 ($.OLDSRCE)
        AND     #$7F
		
.L2D02  \ .ra3 ($.OLDSRCE)
        SBC     #$10
		
L2D03 = L2D02+1             \ SMC?
        BPL     L2D02       \ ra3 ($.OLDSRCE)

        ADC     L2D03       \ ra3+1 ($.OLDSRCE)
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

.L2D68  \ .bis
        EQUB    $88,$A0,$B8,$D0,$E8,$D0,$B8,$88

.playerXpos  \ .Xg \ .L2D70 \ Gun X
        EQUB    $20    \ Initial player X pos

.useless \ .inb \ L2D71
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

.gameFlags      \ sc \ L2D76 \ Game flags
        EQUB    $00		\ pigeon flying, 10 = add notes (use for bonus cheat), 80 = end level (c 2d76 80)

.score_low_byte \ $2D77
        EQUB    $00

.score_high_byte\ $2D78
        EQUB    $00

.L2D79  \ .de
        EQUB    $20

.L2D7A  \ .de+1 \ Life / lives counter?
        EQUB    $03

.L2D7B  \ .de+2
        EQUB    $42

.L2D7C  \ .ba  \ aka ($80)
        EQUB    $00

.L2D7D  \ ba+1 \ aka ($81) Pigeon position
        EQUB    $00

.L2D7E  \ ba+2
        EQUB    $06

.L2D7F  \ ba+3
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
        EQUB    $20,$00,$00,$00,$3C,$00,$00
		
IF ORIGINAL = TRUE
        EQUB    $3A
	ELSE
		EQUB    $00
ENDIF


.BeebDisEndAddr

IF BeebDisEndAddr > &3000
    PRINT "WARNING: Code over-run by", BeebDisEndAddr-&3000,"bytes."
ENDIF

SAVE "$.BirdSk2",p0data,BeebDisEndAddr

