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
L007A   = $007A
L007B   = $007B
L007C   = $007C
L007D   = $007D
L007E   = $007E
L007F   = $007F
L0080   = $0080
L0081   = $0081
L0082   = $0082
L0083   = $0083
L0084   = $0084
L0085   = $0085
L0086   = $0086
L0087   = $0087
L0088   = $0088
L0089   = $0089
L008A   = $008A
L008B   = $008B
L008C   = $008C
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

L02FC   = $02FC
L3527   = $3527
L3528   = $3528
L3529   = $3529
L352A   = $352A
L4180   = $4180
L4900   = $4900

LFE4D   = $FE4D        \ VIA interrupt address
LFE4E   = $FE4E        \ Something to do with light pens, according to the AUG

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
		
        EQUB    $02,$19,$02,$19,$00,$7C,$00,$7C
        EQUB    $72,$E7,$01,$00,$07,$32,$83,$98        
        EQUB    $80,$77,$02,$19,$0A,$00,$43,$B4
        EQUB    $19,$00,$07,$00,$00,$19,$00,$00
        EQUB    $00,$FF,$FF,$FF,$00,$00,$00,$40
        EQUB    $FF,$FF,$00,$35,$00,$00,$00,$00
        EQUB    $8F,$00,$00,$00,$00,$00,$28,$00
        EQUB    $07,$EE,$20,$00,$FF,$00,$00,$7F
        EQUB    $FE,$00,$FE,$7E,$00,$00,$00,$00
        EQUB    $00,$00,$40,$08,$05,$FF,$09,$00
        EQUB    $00,$00,$00,$00,$00,$00,$00,$00
        EQUB    $00,$00,$9F,$1D,$01,$01,$01,$01
        EQUB    $79,$14,$72,$D4,$06,$00,$00,$00
        EQUB    $40,$00,$40,$00,$00,$00,$00,$00
        EQUB    $00,$37,$D0,$37,$20,$39,$02,$00
        EQUB    $00,$2E,$00,$6E,$00,$02,$1B,$AA
        EQUB    $00,$34,$00,$1C,$EF,$80,$98,$7E
        EQUB    $A5,$64,$8D,$20,$01,$A5,$65,$8D
        EQUB    $21,$01,$C9,$07,$F0,$03,$6C,$64
        EQUB    $00,$60,$04,$01,$FF,$FF,$FF,$00
        
		\ The rest is padding
        EQUB    $00,$00,$00,$00,$00,$00,$00,$00
        EQUB    $00,$00,$00,$00,$00,$00,$00,$00
        EQUB    $00,$00,$00,$00,$00,$00,$00,$00
        EQUB    $00,$00,$00,$00,$00,$00,$00,$00
        EQUB    $00,$00,$00,$00,$00,$00,$00,$00
        EQUB    $00,$00,$00,$00,$00,$00,$00,$00
        EQUB    $00,$00,$00,$00,$00,$00,$00,$00
        EQUB    $00,$00,$00,$00,$00,$00,$00,$00
        EQUB    $00,$00,$00,$00,$00,$00,$00,$00
        EQUB    $00,$00,$00,$00,$00,$00,$00,$00
        EQUB    $00,$00,$00,$00,$00,$00,$00,$00
        EQUB    $00,$00,$00,$00,$00,$00,$00,$00

.entry  \ L1300

        \ Official code entry point. Originally needed BIRDSK1 to be loaded at page &3000 first.
        \ *possibly* an anti-tamper mechanism?
        \
		\ This version hard-codes the memory location values so this is no longer necessary.

        SEI                  \ Disable interrupts
        
		LDA     #$A4         \ Originally loaded from L3527
		NOP                  \ To keep memory addresses consistent with original
        STA     WRCHvA
		
		LDA     #$E0         \ Originally loaded from L3528
		NOP                  \ To keep memory addresses consistent with original
        STA     WRCHvB
        
		LDA     #$A6         \ Originally loaded from L3529
		NOP                  \ To keep memory addresses consistent with original
        STA     EVNTvA
		
		LDA     #$FF         \ Originally loaded from L352A
		NOP                  \ To keep memory addresses consistent with original
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

        EQUB    $00,$00,$00,$00,$00,$00,$00,$00
        EQUB    $00,$00,$00,$00,$00,$00,$00,$00
        EQUB    $00,$00,$00,$00,$00,$00,$00,$00
        EQUB    $00,$00,$00,$00,$00,$00,$00,$00
        EQUB    $00,$00,$00,$00,$00,$00,$00,$00
        EQUB    $00,$00,$00,$00,$00,$00,$00,$00
        EQUB    $00,$00,$00,$00,$00,$00,$00,$00
        EQUB    $00,$00,$00,$00,$00,$00,$00,$00
        EQUB    $00,$00,$00,$00,$00,$00,$00,$00
        EQUB    $00,$00,$00,$00,$00,$00,$00,$00
        EQUB    $00,$00,$00,$00,$00,$00,$00,$00
        EQUB    $00,$00,$00,$00,$00,$00,$00,$00
        EQUB    $00,$00,$00,$00,$00,$00,$00,$00
        EQUB    $00,$00,$00,$00,$00,$00,$00,$00
        EQUB    $00,$00,$00,$00,$00,$00,$00,$00
        EQUB    $00,$00,$00,$00,$00,$00,$00,$00
        
        EQUS    "Thanks David,Ian,Martin,Mum,Dad,Susi C"    \ Thanks and credits

    \ Set up osword vectors based on machine type?
.L1426
        LDX     #$EF
        JSR     readMachineSubType

        BNE     L1437

        LDA     #$61
        STA     osword_redirection_C
        LDA     #$14
        STA     osword_redirection_D
		
.L1437
        LDX     #$AE
        JSR     readMachineSubType

        BNE     L144A
        LDA     wordv_1
        STA     osword_redirection_C
        LDA     wordv_2
        STA     osword_redirection_D

.L144A
        LDX     #$CC
        JSR     readMachineSubType
        BNE     L1460

.L1451
        LDA     #$81
        LDY     #$01
        LDX     #$00
        JSR     osbyte    \ Read key with timeout
        BCS     L1451     \ No key detected
        CPX     #$52      \ INKEY value of R
        BEQ     L1451

.L1460
        RTS

        EQUB    $C9,$07,$F0,$FB,$6C,$68,$14

.wordv_1    \ OSWORD redirection vector stored here
        EQUB    $EB

.wordv_2    \ OSWORD redirection vector stored here
        EQUB    $E7

.L146A
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

.L1483
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
		EQUB    $AD,$AD,$14,$F0,$04,$CE,$AD
        EQUB    $14,$60,$A9,$12,$8D,$AD,$14,$4C
        EQUB    $7D,$29,$00

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

.L14D8
        RTS

.L14D9
        LDA     L1D55
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
        EQUB    $60

.L151A
        EQUB    $00

.L151B
        JSR     L2223

        LDA     #$DC
        STA     L2DFC
        LDX     #$F8
        LDY     #$2D
        LDA     #$07
        JSR     osword        \ Play a sound

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
        LDA     L1D5C
        AND     #$03
        BNE     L1550

        LDA     #$0F
        JSR     L208D

        JSR     vduCalls

        JMP     L1556

.L1550
        JSR     L20B1

        JSR     L21A6

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
        JSR     osword        \ Play a sound

        JSR     L2054

        PLA
        TAY
        DEY
        BNE     L155B

        INC     L15B7
        LDX     #$B7
        LDY     #$15
        LDA     #$07
        JSR     osword        \ Play a sound

        DEC     L15B7
        LDA     #$80
        ORA     L2D76
        STA     L2D76
        RTS

.L159E
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

.L15B7
        EQUB    $12,$00,$FF,$FF,$00,$00,$00,$00
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
        EQUB    $00,$00,$00,$00,$9A,$94,$68,$3F
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
        EQUS    "andrew  "    \ original high score holder
        EQUB    $00
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
		EQUB    $1F,$07,$18   \ Move text cursor
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
        STA     L17A0
        LDA     #$00
        STA     L17AC
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
L17A0 = L179F+1
        SBC     #$80
        STA     L17A0
        PHP
        JSR     oswrch

        PLP
.L17AB
        LDA     #$00
L17AC = L17AB+1
        SBC     #$00
        STA     L17AC
        JSR     oswrch

        JSR     drawStave

        DEC     L0070
        BNE     L1791

        LDA     L1D5C
        STA     L1A08
        LDA     #$00
        STA     L1D5C
        LDA     #$26
        STA     L1A0C
        LDA     #$88
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
        INC     L1D5C
.L17EC
        JSR     L20DE

        BNE     L17EC

        JSR     L20B1

        JSR     L21A6

        LDA     #$3C
        JSR     L208D

        LDA     L1D5C
        CMP     #$04
        BNE     L17D1

        LDA     L1A08
        STA     L1D5C
        LDA     #$1A
        JMP     oswrch \ Restore default windows

.vduCallsTable         \ VDU calls    \ L180E
        EQUB    $10    \ Clear graphics area
		EQUB    $03    \ Disable printer
		EQUB    $FF    \ terminator character?
		EQUB    $04    \ Write text at text cursor
		EQUB    $0F    \ Paged mode off
		EQUB    $02    \ Enable printer
		EQUB    $0F    \ Paged mode off
		EQUB    $00    \ nada
        EQUB    $F0    \ ?
		EQUB    $18    \ Define graphics colour
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

        LDX     #$D4
        LDY     #$15
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

        LDX     #$A0
        LDY     #$16
        JSR     L18EB

        LDX     #$BD
        LDY     #$16
        JSR     L18EB

        LDA     #$1F
        JSR     oswrch

        LDA     #$1A
        JSR     oswrch

        LDA     #$0B
        JSR     oswrch

        LDA     L15C5
        BEQ     L18A4

        LDA     #$15
        LDX     #$00
        JSR     osbyte

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
        JSR     osasci        \ print instructions text

        CMP     #$20
        BPL     L18A6

.L18B1
        LDY     #$02
.L18B3
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

        LDX     #$5C
        LDY     #$17
        JSR     L18EB

.L18CF
        LDX     #$9D
        JSR     readMachineSubType

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
        JMP     osasci

.L18EB
        STX     L18F5
        STY     L18F6
        LDY     #$FF
.L18F3
        INY
.L18F4
        LDA     highScoreDots,Y
L18F5 = L18F4+1
L18F6 = L18F4+2
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

        EQUB    $00,$00,$05,$00,$00,$00,$00,$08    \ Lives icon, RAF(?) logo, explosion sprites
        EQUB    $08,$1C,$08,$08,$08,$00,$28,$28
        EQUB    $28,$3E,$28,$28,$00,$00,$00,$08
        EQUB    $08,$08,$08,$08,$08,$00,$00,$10
        EQUB    $10,$35,$35,$10,$10,$00,$30,$30
        EQUB    $3F,$03,$03,$3F,$30,$30,$00,$20
        EQUB    $20,$3A,$3A,$20,$20,$00,$00,$00
        EQUB    $00,$05,$00,$00,$00,$00,$00,$00
        EQUB    $00,$00,$00,$00,$00,$00,$00,$00
        EQUB    $00,$00,$2A,$00,$00,$00,$00,$00
        EQUB    $0A,$02,$15,$0A,$00,$00,$00,$00
        EQUB    $2A,$15,$00,$2A,$00,$00,$00,$00
        EQUB    $0A,$00,$02,$0A,$00,$00,$00,$00
        EQUB    $00,$2A,$00,$00,$00,$00,$00,$00
        EQUB    $00,$00,$05,$00,$00,$00,$00,$00
        EQUB    $00,$00,$00,$00,$00,$00,$1A,$05
        EQUB    $00,$C0,$05,$0A,$30,$05,$40,$00
        EQUB    $4A,$15,$00,$2A,$0F,$10,$00,$4A
        EQUB    $15,$00,$00,$48,$80,$20,$0A,$4A
        EQUB    $10,$00,$00,$40,$2A,$0A,$10,$0A
        EQUB    $40,$15,$00,$2A,$85,$30,$80,$25
        EQUB    $0A,$40,$25,$90,$1A,$05,$0A,$00
        EQUB    $20,$40,$00,$0A,$00,$00,$00,$05
        EQUB    $00,$00,$00,$00,$00,$00,$00,$00
        EQUB    $00,$80,$00,$00,$08,$00,$00,$00
        EQUB    $00,$00,$00,$00,$00,$00,$0A,$00
        EQUB    $00,$00,$00,$00,$00,$40,$00,$00
        EQUB    $00,$00,$05,$00,$00,$00,$08,$00
        EQUB    $00,$00,$00,$00,$00,$00,$00,$00
        EQUB    $00,$00,$00,$00,$15,$08,$00,$80
        EQUB    $00,$00,$05,$00,$00,$00,$2A,$2A
        EQUB    $2A,$2A,$2A,$2A,$2A,$2A

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
		EQUB    $00,$04,$00,$04
        EQUB    $28,$04,$00,$04,$00,$00,$00,$00
        EQUB    $28,$00,$00,$00,$28,$00,$28,$00
        EQUB    $28,$00,$00,$00,$00,$04,$00,$04
        EQUB    $28,$04,$00,$04,$00,$00,$00,$00
        EQUB    $28,$00,$00,$00,$00,$00,$00,$00
        EQUB    $00,$00,$04,$2C,$00,$00,$00,$00
        EQUB    $00,$00,$14,$28,$00,$00,$00,$00
        EQUB    $00,$00,$14,$28,$00,$00,$00,$00
        EQUB    $00,$00,$04,$2C,$00,$00,$00,$00
        EQUB    $00,$00,$00,$28

.L1A60  \ Skull
        EQUB    $00,$00,$00,$00,$00,$40,$00,$40
        EQUB    $40,$80,$80,$40,$40,$40,$80,$00
        EQUB    $C0,$80,$80,$40,$C0,$40,$80,$00
        EQUB    $00,$80,$80,$00,$00,$40,$80,$40
		\ Pigeon sprite ($1A80)
        EQUB    $00,$00,$00,$00,$00,$00,$00,$00
        EQUB    $00,$00,$00,$14,$3C,$00,$00,$00
        EQUB    $00,$00,$00,$3C,$3C,$34,$3C,$28
        EQUB    $00,$00,$3C,$2D,$22,$00,$00,$00
		\ Pigeon sprite ($1AA0) s, pigeon, numbers, some scenery sprites
        EQUB    $00,$00,$00,$14,$3C,$00,$14,$00
        EQUB    $00,$00,$00,$3C,$3C,$34,$28,$00
        EQUB    $00,$00,$3C,$2D,$22,$00,$00,$00
        EQUB    $00,$00,$00,$14,$3C,$00,$00,$00
		\ Pigeon TBC
        EQUB    $00,$00,$00,$3C,$39,$00,$00,$00
        EQUB    $00,$00,$3C,$2D,$22,$00,$00,$00
        EQUB    $00,$00,$00,$00,$14,$3C,$00,$00
        EQUB    $00,$3C,$34,$3C,$39,$00,$00,$00
		
        EQUB    $00,$00,$3C,$2D,$22,$00,$00,$00
        EQUB    $14,$00,$00,$00,$14,$3C,$00,$00
        EQUB    $28,$3C,$34,$3C,$39,$00,$00,$00
        EQUB    $00,$00,$3C,$2D,$22,$00,$00,$00
        
        EQUB    $30,$24,$10,$13,$16,$19,$1C,$34            
        EQUB    $41,$1F,$48,$48,$48,$48,$48,$48
        EQUB    $48
        
        EQUS    "LDASTAJSRRTSBNE"                    \ BASIC/keyboard/source artefacts?
        EQUS    "P.~!&"
        EQUS $16,$34,$13
        EQUS    "12000L."
        EQUB    $0E
        EQUB    $0D
        EQUS    "RUN"
        EQUB    $0D,$16,$32,$17
        EQUB    $00,$0C,$00,$00,$00,$00,$00,$00
        EQUB    $00,$00
        EQUS    "CALLQ%"
        
        EQUB    $0D,$00,$00,$14,$3C,$00,$00,$00
        EQUB    $00,$00,$00,$3C,$3C,$34,$3C,$28
        EQUB    $00,$00,$3C,$2D,$22,$00,$00,$00
        EQUB    $00,$00,$00,$14,$3C,$00,$14,$00
        EQUB    $00,$00,$00,$00,$00,$00,$00,$00
        EQUB    $00,$00,$00,$00,$14,$00,$00,$00
        EQUB    $00,$05,$00,$28,$00,$01,$00,$14
        EQUB    $00,$00,$00,$28,$14,$00,$00,$00
        EQUB    $00,$00,$3C,$1E,$01,$00,$00,$00
        EQUB    $00,$00,$00,$3C,$3C,$38,$3C,$14
        EQUB    $00,$00,$00,$28,$3C,$00,$00,$00
        EQUB    $00,$00,$3C,$1E,$01,$00,$00,$00
        EQUB    $00,$00,$00,$3C,$3C,$38,$14,$00
        EQUB    $00,$00,$00,$28,$3C,$00,$28,$00
        EQUB    $00,$00,$3C,$1E,$01,$00,$00,$00
        EQUB    $00,$00,$00,$3C,$16,$00,$00,$00
        EQUB    $00,$00,$00,$28,$3C,$00,$00,$00
        EQUB    $00,$00,$3C,$1E,$01,$00,$00,$00
        EQUB    $00,$3C,$38,$3C,$16,$00,$00,$00
        EQUB    $00,$00,$00,$00,$28,$3C,$00,$00
        EQUB    $00,$00,$3C,$1E,$01,$00,$00,$00
        EQUB    $14,$3C,$38,$3C,$16,$00,$00,$00
        EQUB    $28,$00,$00,$00,$28,$3C,$00,$00
        EQUB    $3C,$38,$38,$38,$38,$38,$3C,$10
        EQUB    $38,$38,$38,$38,$38,$38,$38,$30
        EQUB    $14,$3C,$34,$14,$14,$14,$3C,$10
        EQUB    $20,$20,$20,$20,$20,$20,$38,$30
        EQUB    $3C,$30,$00,$3C,$38,$28,$3C,$10
        EQUB    $38,$38,$38,$38,$30,$00,$28,$30
        EQUB    $3C,$30,$00,$3C,$30,$00,$3C,$10
        EQUB    $38,$38,$38,$38,$38,$38,$38,$30
        EQUB    $38,$38,$38,$3C,$10,$00,$00,$00
        EQUB    $38,$38,$38,$38,$38,$38,$38,$30
        EQUB    $3C,$38,$28,$3C,$10,$00,$3C,$10
        EQUB    $38,$30,$00,$38,$38,$38,$38,$30
        EQUB    $3C,$38,$28,$3C,$38,$28,$3C,$10
        EQUB    $38,$30,$00,$28,$38,$38,$38,$30
        EQUB    $3C,$30,$00,$14,$14,$14,$14,$10
        EQUB    $38,$38,$38,$30,$20,$20,$20,$20
        EQUB    $3C,$38,$28,$3C,$38,$28,$3C,$10
        EQUB    $38,$38,$38,$38,$38,$38,$38,$30
        EQUB    $3C,$38,$28,$3C,$10,$00,$3C,$10
        EQUB    $38,$38,$38,$38,$38,$38,$38,$30
        EQUB    $00,$00,$00,$00,$00,$00,$00,$00
        EQUB    $00,$00,$04,$00,$0C,$00,$04,$0C
        EQUB    $08,$08,$06,$08,$06,$0C,$06,$06
        EQUB    $00,$00,$00,$00,$08,$00,$00,$08
        EQUB    $00,$04,$08,$04,$00,$00,$08,$04
        EQUB    $0C,$04,$08,$0C,$02,$04,$0C,$08
        EQUB    $06,$0C,$06,$08,$06,$06,$0C,$06
        EQUB    $08,$04,$08,$0C,$00,$08,$04,$08
        EQUB    $00,$04,$00,$00,$00,$00,$08,$04
        EQUB    $08,$09,$04,$00,$00,$08,$08,$0C
        EQUB    $02,$0C,$02,$02,$02,$02,$02,$07
        EQUB    $08,$04,$00,$00,$04,$04,$01,$09
        EQUB    $15,$01,$09,$06,$09,$06,$09,$06
        EQUB    $00,$00,$09,$06,$09,$06,$09,$06
        EQUB    $00,$00,$09,$06,$09,$06,$09,$06
        EQUB    $00,$00,$09,$06,$09,$06,$09,$06
        EQUB    $00,$00,$00,$07,$08,$06,$09,$06
        EQUB    $00,$00,$00,$0F,$20,$0F,$08,$02
        EQUB    $00,$00,$00,$05,$00,$0E,$01,$0E
        EQUB    $00,$00,$01,$0E,$09,$06,$09,$06

.L1D40
        EQUB    $31,$7A,$D9,$7C,$C9,$77,$12,$7A
        EQUB    $C8,$7C,$BA,$77,$51,$7A,$B8,$7C
        EQUB    $20,$7A,$42,$7A

.L1D54
        EQUB    $00

.L1D55
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

.L1D5B
        EQUB    $00

.L1D5C  \ Game data? $1D5C is the current level

        EQUB    $00,$00,$00,$00,$28,$3C,$0D,$2D
        EQUB    $2D,$0D,$3C,$2C,$28,$0F,$31,$31
        EQUB    $35,$30,$1A,$0F,$28,$0F,$30,$30
        EQUB    $33,$30,$25,$1E,$34,$1C,$1E,$0E
        EQUB    $36,$1E,$2C,$1C,$3C,$1C,$2C,$3C
        EQUB    $34,$1C,$2C,$1C,$1C,$3C,$28,$20
        EQUB    $28,$0C,$3C,$34,$34,$2C,$2C,$1C
        EQUB    $3C,$38,$3C,$1C,$1C,$2C,$3C,$34
        EQUB    $2C,$3C,$1C,$2C,$3C,$38,$2C,$1C
        EQUB    $2C,$38,$1C,$38,$2C,$1C,$39,$33
        EQUB    $33,$27,$33,$33,$3C,$38,$14,$11
        EQUB    $11,$11,$11,$11,$1C,$1C,$2C,$24
        EQUB    $3C,$2C,$1C,$1C,$20,$35,$30,$20
        EQUB    $20,$30,$30,$18,$38,$10,$30,$10
        EQUB    $38,$30,$30,$18,$3A,$10,$30,$10
        EQUB    $10,$30,$1A,$1A,$3D,$00,$30,$30
        EQUB    $28,$00,$30,$30,$20,$20,$30,$30
        EQUB    $20,$20,$30,$30,$04,$04,$0D,$24
        EQUB    $30,$38,$30,$18,$04,$08,$00,$00
        EQUB    $20,$20,$30,$30,$00,$08,$04,$04
        EQUB    $30,$3A,$30,$30

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

        JSR     L1E6C                       \ Start game on spacebar from title screen

.L1E27    \ Main game loop

        JSR     L25B8                       \ unknown

        JSR     L284A                       \ Delay? - plays at high speed when disabled. Also clears an interrupt(?)

        JSR     L2A94                       \ Enemy movement (First attempt produced Level completion check? Jumped to next level if RTS'd)

        JSR     L29F7                       \ unknown

        JSR     L286E                       \ unknown

        JSR     L28E2                       \ Player bullet

        JSR     L295E                       \ unknown

        JSR     L2C98                       \ Enemy bombs

        JSR     L2C45                       \ unknown

        JSR     L240E                       \ Pigeon

        JSR     L2238                       \ Player hit detection

        JSR     L1FE0                       \ Gravestones plot / pigeon reset after hit

        JSR     L1426                       \ 

        JMP     L1E27                       \ branch back around
        
        EQUS    "(c)A.E.Frigaard 1984 Hello!"

.L1E6C
        LDA     #$05
        STA     L0070
        JSR     L2835

        LDA     #$49
        JSR     L21A6

        LDA     #$16
        JSR     oswrch

        LDA     #$02
        JSR     oswrch

        LDA     #$00
        STA     L151A
        STA     L008E
        STA     L1D5C
        STA     L1D54
        STA     L1D55
        STA     score_low_byte
        STA     score_high_byte
        STA     L0088
        CLC
        LDA     #$20
        STA     L2D79
        LDA     #$03
        STA     L2D7A
        LDA     #$2A
        STA     L2D7B
        LDA     #$02
        STA     L0071
        LDA     #$2D
        STA     L008B
        STA     L008D
        STA     L0076
        LDA     #$47
        STA     L008C
        LDA     #$0A
        STA     L008A
        LDA     #$13
        STA     L0075
        LDX     #$0F
        LDY     #$07
.L1EC6
        JSR     L281D

        DEX
        CPX     #$07
        BNE     L1EC6

        STX     L007D
        LDA     #$03
        STA     L1D56
        LDA     #$2F
        STA     L0089
        LDA     #$F0
        STA     useless
        LDA     #$00
        STA     L1A09
.L1EE3
        JSR     L20B1

        STX     L2382
        INC     L1D5C
        LDA     L2D79
        CMP     #$0F
        BMI     L1F03

        LDA     L1D5C
        AND     #$01
        BEQ     L1F03

        DEC     L2D79
        DEC     L2D79
        DEC     useless
.L1F03
        INC     L1A09
        INC     L1A09
        LDA     #$0C
        JSR     oswrch

        LDA     #$9A
        LDX     #$14
        JSR     osbyte

        JSR     L261A

        JSR     L25C9

        JSR     drawStave

        JSR     L2054

        LDA     #$00
        STA     L1D5B
        STA     L2D76
        STA     L2D7D
        LDY     #$54
.L1F2E
        STA     L2D0A,Y
        DEY
        BNE     L1F2E

        LDA     L1A09
        STA     L2D47
        LDA     #$06
        STA     L2D0A
        LDA     #$1E
        STA     L2D13
        LDA     #$30
        STA     L1D5A
        LDA     #$88
        STA     L1D59
        LDA     #$80
        STA     L1D57
        LDA     #$32
        STA     L1D58
        LDX     L1D56
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
        STA     L0082
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
        STA     L2D70
        LDA     #$7E
        STA     L0087
        LDA     #$90
        STA     L0086
        LDA     #$23
        STA     L28D7
        LDA     #$58
        STA     L28D6
        JSR     L28D3

        LDA     #$40
        JMP     L21A6

.L1FE0
        LDA     L2D76
        BEQ     L2054

        SED
        AND     #$02
        BEQ     L1FFE

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
        BIT     L2D76
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
        JSR     osword        \ Play a sound

        SED
.L2021
        LDA     #$10
        BIT     L2D76
        BEQ     L2042

        CLC
        LDA     #$0A
        ADC     score_low_byte
        STA     score_low_byte
        LDA     score_high_byte
        ADC     #$00
        STA     score_high_byte
        CLD
        JSR     L20DE

        BNE     L2042

        JSR     L153E

.L2042
        CLD
        JSR     L14EB

        LDA     L2D76
        BPL     L204E

        JMP     L209D

.L204E
        LDA     #$00
        STA     L2D76
        RTS

.L2054
        LDA     #$34
        STA     L0081
        LDA     #$B0
        STA     L0080
        LDA     #$1C
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

.L208D
        STA     L1A0A
        TYA
        PHA
.L2092
        JSR     L284A

        DEC     L1A0A
        BNE     L2092

        PLA
        TAY
        RTS

.L209D
        LDA     #$00
        STA     L2D76
        CLC
        LDA     L0088
        ADC     #$40
        STA     L0088
        LDA     #$64
        JSR     L208D

        JMP     L1EE3

.L20B1
        LDA     #$03
        AND     L1D5C
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
        LDA     #$23
        STA     L0083
        JSR     L213E

        CLC
        LDA     L1D59
        ADC     #$20
        STA     L1D59
        BCC     L211D

        INC     L1D5A
.L211D
        JSR     L2172

        CLC
        LDA     L0080
        ADC     #$08
        STA     L0080
        BCC     L212B

        INC     L0081
.L212B
        CLC
        LDA     L0082
        ADC     #$08
        STA     L0082
        BCC     L2136

        INC     L0083
.L2136
        JSR     L2172

        INY
        LDA     L2382,Y
        RTS

.L213E
        LDA     #$80
        BIT     L0070
        BEQ     L2149

        LDA     #$00
        STA     L0082
        RTS

.L2149
        LSR     A
        BIT     L0070
        BEQ     L2153

        LDA     #$10
        STA     L0082
        RTS

.L2153
        LSR     A
        BIT     L0070
        BEQ     L215D

        LDA     #$20
        STA     L0082
        RTS

.L215D	\ Something to do with the plotting of dots on the stave
        LSR     A
        BIT     L0070
        BEQ     L2167

        LDA     #$30
        STA     L0082
        RTS

.L2167
        LDA     #$01
        BIT     L0070
        BEQ     L2171

        LDA     #$40
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
        STA     (L0084),Y
        DEY
        CPY     L0074
        BNE     L218F

.L219A
        LDA     (L0082),Y
        ORA     (L0080),Y
        STA     (L0080),Y
        DEY
        BPL     L219A

        PLA
        TAY
        RTS

.L21A6
        STA     L0070
.L21A8
        \ Sound player routine (start of level chimes, bonus tunes etc)
        LDY     L0070
        LDA     L23B2,Y
        BEQ     L21C9

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
        JMP     L21A8

.L21C9
        LDA     #$80
        LDX     #$FA          \ Sound channel 1
        JSR     osbyte        \ Read ADC channel or get buffer status

        CPX     #$0F
        BMI     L21C9

        RTS

.readMachineSubType           \ readMachineSubType
        LDA     #$81
        LDY     #$FF
        JSR     osbyte        \ Read machine sub type?)

        INX
        RTS

        EQUB    $E8,$60,$00,$00,$00,$00,$00,$00
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

.L2223
        LDA     #$10
        STA     L0082
        LDA     #$19
        STA     L0083
        LDA     L1D57
        STA     L0080
        LDA     L1D58
        STA     L0081
        JMP     L2581

.L2238                          \ Death-check
        LDA     #$20            \ Change to RTS for invincibility
        BIT     L2D76
        BNE     L2245

        LDA     L1D55
        BNE     L2278

.L2244
        RTS

.L2245
        LDX     #$00
        LDY     #$07
        JSR     L281D

        LDA     #$07
        LDY     #$2D
        LDX     #$E0
        JSR     osword            \ Play a sound

        LDA     #$FF
        STA     L1D55
        LDA     #$60
        STA     L2C45
        STA     L29F7
        STA     L286E
        STA     L295E
        JSR     L28D3

        LDA     #$1A
        STA     L28D7
        LDA     #$10
        STA     L28D6
        JMP     L28D3

.L2278
        DEC     L1D55
        LDA     L1D55
        CMP     #$FE
        BNE     L2289

        LDX     #$00
        LDY     #$00
        JMP     L281D

.L2289
        CMP     #$DC
        BNE     L2298

        JSR     L28D3

        LDA     #$38
        STA     L28D6
        JMP     L28D3

.L2298
        CMP     #$8C
        BNE     L22A7

        JSR     L28D3

        LDA     #$60
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

.L22E2
        LDA     #$20
        STA     L286E
        LDA     #$A5
        STA     L29F7
        LDA     #$A9
        STA     L2C45
        STA     L295E
        SEC
        LDA     L1D57
        SBC     #$18
        STA     L1D57
        JMP     L2223

        EQUB    $00,$00,$00,$00,$00,$14,$3C,$3C    \ Musical notes and player sprite
        EQUB    $38,$38,$38,$38,$38,$38,$38,$20
        EQUB    $00,$00,$00,$00,$00,$14,$38,$3C
        EQUB    $38,$38,$38,$38,$38,$38,$38,$00
        EQUB    $00,$00,$00,$00,$00,$14,$38,$3C
        EQUB    $00,$00,$00,$00,$00,$38,$38,$20
        EQUB    $00,$00,$00,$00,$00,$38,$38,$30
        EQUB    $00,$00,$00,$00,$00,$00,$00,$00
        EQUB    $00,$00,$00,$00,$00,$3C,$3C,$10
        EQUB    $00,$00,$00,$00,$00,$38,$38,$30
        EQUB    $01,$04,$04,$01,$01,$01,$00,$00
        EQUB    $00,$04,$04,$04,$2C,$04,$04,$04
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
        LDA     #$1B
L240F = L240E+1
        STA     L0083
        LDA     L2D7D
        BNE     L248E

        LDA     #$42
        BIT     L2D76
        BEQ     L248D

        LDA     #$02
        BIT     L02FC
        BEQ     L2444

        LDA     #$1B
        STA     L0083
        STA     L240F
        LDA     #$68
        STA     L2D7C
        STA     L0080
        LDA     #$00
        STA     L252F
        LDA     #$4C
        STA     L2D7F
        LDA     #$4B
        STA     L246C
        BNE     L245F

.L2444
        LDA     #$1A
        STA     L0083
        STA     L240F
        LDA     #$00
        STA     L2D7C
        STA     L0080
        STA     L2D7F
        LDA     #$4C
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
        STA     L0082
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
        ORA     L2D76
        STA     L2D76
        LDA     #$00
        STA     L2D7D
        BEQ     L24FE

.L24B2
        LDA     L2D7E
        AND     #$7F
        TAX
        LDA     L2D68,X
        STA     L0082
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
        JSR     osword        \ Play a sound

        LDA     #$10
        STA     L2D7E
        LDA     #$80
        ORA     L2D7D
        STA     L2D7D
        JSR     L2581

.L24FE
        LDA     #$1B
        STA     L0083
        LDA     #$70
        STA     L0082
        JMP     L2581

.L2509
        LDA     #$04
        ORA     L2D76
        STA     L2D76
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
L252F = L252E+1
        BEQ     L2509

        AND     #$1F
        BNE     L253F

        LDA     #$07
        LDY     #$2D
        LDX     #$F0
        JSR     osword        \ Play a sound

.L253F
        LDX     L2D7E
        DEX
        BPL     L2547

        LDX     #$07
.L2547
        STX     L2D7E
        LDA     L2D68,X
        STA     L0082
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
.L2583
        LDA     (L0082),Y
        EOR     (L0080),Y
        STA     (L0080),Y
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
.L25A7
        STA     (L0080),Y
        DEY
        BPL     L25A7

        LDY     #$09
        ASL     A
        STA     (L0080),Y
        LDY     #$01
        LDA     #$FF
        STA     (L0080),Y
.L25B7
        RTS

.L25B8
        LDA     L007D
        AND     #$48
        ADC     #$38
        ASL     A
        ASL     A
        ROL     L007F
        ROL     L007E
        ROL     L007D
        LDA     L007D
        RTS

.L25C9
        LDY     #$00
.L25CB
        LDA     L26B0,Y
        JSR     oswrch

        INY
        BNE     L25CB

        LDA     L0088
        STA     L0082
        LDA     L0089
        STA     L0083
        LDA     #$1F
        STA     L2C1E
        LDA     #$E0
        STA     L0070
        LDY     #$00
.L25E7
        INY
        LDX     L27C3,Y
        INY
        LDA     L27C3,Y
        BIT     L0070
        BNE     L25FF

        STA     L0089
        STX     L0088
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
        STA     L0088
        LDA     L0083
        STA     L0089
        RTS

        EQUB    $00

.L261A
        LDA     #$44
        STA     L0079
        LDA     #$FF
        LDX     #$05
.L2622
        LDY     #$00
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

        LDA     #$2E
        STA     L007B
        LDA     #$20
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
L266F = L266E+1
L2670 = L266E+2
.L2671
        STA     L4180,X
L2672 = L2671+1
L2673 = L2671+2
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

.L26B0
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
        EQUB    $7D,$2D,$20,$13,$28,$A9,$09,$85
        EQUB    $83,$A9,$F0,$85,$82,$4C,$13,$28
        EQUB    $A9,$00,$8D

.L27C3
        EQUB    $58,$A0,$1C,$93,$73,$49,$71,$60
        EQUB    $76,$99,$75,$44,$73,$C9,$78,$B4
        EQUB    $76,$C0,$1C,$13,$76,$93,$78,$C9
        EQUB    $73,$49,$76,$E0,$78,$44,$78,$C4
        EQUB    $75,$E0,$1C,$13,$7B,$4A,$7B,$60
        EQUB    $7B,$C4,$7A,$00,$1D,$B0,$78,$20
        EQUB    $78,$5C,$78,$20,$1D,$00,$78,$88
        EQUB    $76,$60,$1D,$60,$70,$80,$1D,$E0
        EQUB    $72,$60,$75,$E0,$77,$80,$7A,$A0
        EQUB    $7A,$DC,$7A,$A0,$1D,$60,$7A,$30
        EQUB    $7B,$C0,$1D,$08,$79,$E0,$1D,$28
        EQUB    $79,$00

.L281D
        LDA     #$13
        JSR     oswrch

        TXA
        JSR     oswrch

        TYA
        JSR     oswrch

        LDA     #$00
        JSR     oswrch

        JSR     oswrch

        JMP     oswrch

.L2835
        LDA     L0070
        ASL     A
        ASL     A
        ASL     A
        ASL     A
        ADC     #$70
        TAX
        LDA     #$08
        LDY     #$2D
        JSR     osword        \ Define an envelope

        DEC     L0070
        BNE     L2835

        RTS

.L284A
        LDA     #$02
        STA     LFE4E         \ Clear interrupt?
.L284F
        BIT     LFE4D
        BEQ     L284F

        LDA     #$82
        STA     LFE4E
        RTS

.L285A
        STA     L0082
        LDY     #$0F
.L285E
        LDA     (L0082),Y
        STA     (L0080),Y
        DEY
        BPL     L285E

        CLC
        LDA     L0080
        ADC     #$10
        STA     L0080
        RTS

        BRK
.L286E
        EQUB    $60

        EQUB    $D3,$28,$A9,$81,$A0,$FF,$A2,$BD
        EQUB    $20,$F4,$FF,$E8,$F0,$21,$88,$A2
        EQUB    $9E,$20,$F4,$FF,$E8,$D0,$2E,$AE
        EQUB    $70,$2D,$E0,$01,$F0,$27,$CA,$8E
        EQUB    $70,$2D,$38,$A5,$86,$E9,$08,$85
        EQUB    $86,$B0,$1A,$C6,$87,$90,$16,$AE
        EQUB    $70,$2D,$E0,$47,$F0,$0F,$E8,$8E
        EQUB    $70,$2D,$18,$A5,$86,$69,$08,$85
        EQUB    $86,$90,$02,$E6,$87,$38,$A9,$00
        EQUB    $85,$78,$A0,$24,$B1,$86,$F0,$02
        EQUB    $85,$78,$98,$E9,$08,$A8,$10,$F4
        EQUB    $A5,$78,$F0,$08,$AD,$76,$2D,$09
        EQUB    $20,$8D,$76,$2D

.L28D3
        LDY     #$27
.L28D5
        LDA     L1A60,Y
L28D6 = L28D5+1
L28D7 = L28D5+2
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
        LDA     L2D73
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

.L2947
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

.L295E
        RTS

        EQUB    $01,$24,$71,$D0,$12,$A9,$81,$A0
        EQUB    $FF,$A2,$B6,$20,$F4,$FF,$E8,$F0
        EQUB    $07,$A9,$00,$8D,$AD,$14,$60,$60
        EQUB    $4C,$9C,$14,$71,$D0,$F9,$A0,$FF
        EQUB    $C8,$C8,$C8,$C8,$B1,$8A,$D0,$F8
        EQUB    $88,$88,$A9,$9D,$91,$8A,$C8,$38
        EQUB    $A5,$86,$E9,$6E,$91,$8A,$85,$80
        EQUB    $C8,$A5,$87,$E9,$02,$91,$8A,$85
        EQUB    $81,$C8,$AD,$70,$2D,$18,$69,$03
        EQUB    $91,$8A,$20,$C3,$29,$A9,$03,$05
        EQUB    $71,$85,$71,$A9,$01,$0D,$76,$2D
        EQUB    $8D,$76,$2D,$A9,$07,$A0,$2D,$A2
        EQUB    $D0,$4C,$F1,$FF

.L29C3
        TYA
        PHA
        LDY     #$05
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
        CMP     #$05
        BPL     L29EB

.L29E0
        LDA     (L0082),Y
        EOR     (L0084),Y
        STA     (L0084),Y
        DEY
        CPY     L0074
        BNE     L29E0

.L29EB
        LDA     (L0082),Y
        EOR     (L0080),Y
        STA     (L0080),Y
        DEY
        BPL     L29EB

        PLA
        TAY
        RTS

.L29F7
        RTS

        EQUB    $72,$C9,$01,$10,$3A,$CE,$7A,$2D
        EQUB    $D0,$35,$AD,$7B,$2D,$8D,$7A,$2D
        EQUB    $A5,$70,$20,$FA,$2C,$A8,$38,$E9
        EQUB    $05,$10,$FC,$AA,$C8,$E8,$D0,$FC
        EQUB    $88,$B1,$75,$30,$16,$A4,$70,$88
        EQUB    $B1,$75,$30,$0F,$88,$88,$88,$88
        EQUB    $D0,$F5,$A9,$80,$0D,$76,$2D,$8D
        EQUB    $76,$2D,$60,$49,$80,$91,$75,$60

.L2A38
        LDA     L0077
        BEQ     L2A91

        LDX     #$19
        STX     L0089
        LDA     L0088
        PHA
        LDA     L0077
        CMP     #$15
        BNE     L2A53

        LDA     #$40
        STA     L0088
        JSR     L2C08

        JMP     L2A88

.L2A53
        CMP     #$0C
        BNE     L2A68

        LDA     #$40
        STA     L0088
        JSR     L2C08

        LDA     #$80
        STA     L0088
        JSR     L2C08

        JMP     L2A88

.L2A68
        CMP     #$06
        BNE     L2A7D

        LDA     #$80
        STA     L0088
        JSR     L2C08

        LDA     #$C0
        STA     L0088
        JSR     L2C08

        JMP     L2A88

.L2A7D
        CMP     #$01
        BNE     L2A88

        LDA     #$C0
        STA     L0088
        JSR     L2C08

.L2A88
        LDA     #$2F
        STA     L0089
        PLA
        STA     L0088
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

        CMP     #$07
        BPL     L2B21

        CMP     #$03
        BEQ     L2AFE

        LDA     #$40
        ORA     L2D76
        STA     L2D76
        ASL     A
        STA     (L008A),Y
        BNE     L2B21

.L2AFE
        LDA     #$19
        STA     L0077
        LDA     #$D8
        STA     (L008A),Y
        TAX
        LDA     #$07
        LDY     #$2D
        JSR     osword        \ Play a sound (enemy explosion)

        PLA
        TAY
        LDA     #$02
        ORA     L2D76
        STA     L2D76
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
        LDA     L0073
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
        LDA     #$C0
        STA     L007B
        JSR     L14D9

.L2B4C
        LDA     #$3F
        AND     L0077
        BNE     L2B88

        SEC
        LDA     L007A
        SBC     L2D70
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

        EQUB    $90,$0F,$C6,$7A,$A5,$78,$E9,$08
        EQUB    $85,$78,$B0,$15,$C6,$79,$4C,$E1
        EQUB    $2B,$E6,$7A,$2A,$90,$0B,$18,$A5
        EQUB    $78,$69,$08,$85,$78,$90,$02,$E6
        EQUB    $79

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
        LDA     (L0088),Y
        BEQ     L2C2D

        EOR     (L0084),Y
        STA     (L0084),Y    \ NOPping this causes enemies to flicker. Memory copy for smooth animation?
.L2C2D
        DEY
        DEX
        CPX     L0074
        BNE     L2C25

.L2C33
        LDA     (L0088),Y
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

.L2C45
        RTS

        EQUB    $C0,$24,$73,$D0,$46,$C6,$73,$D0
        EQUB    $42,$A0,$FF,$C8,$C8,$C8,$C8,$C8
        EQUB    $B1,$75,$30,$F7,$88,$88,$88,$B1
        EQUB    $75,$29,$C0,$D0,$06,$C8,$C8,$C8
        EQUB    $4C,$51,$2C,$C8,$18,$B1,$75,$69
        EQUB    $9D,$85,$80,$C8,$B1,$75,$69,$02
        EQUB    $85,$81,$20,$C3,$29,$A0,$00,$C8
        EQUB    $C8,$B1,$8C,$D0,$FA,$A5,$81,$91
        EQUB    $8C,$88,$A5,$80,$91,$8C,$AD,$71
        EQUB    $2D,$85,$73,$A9,$C0,$05,$73,$85
        EQUB    $73,$60

.L2C98
        LDY     #$00
        LDA     (L008C),Y
        STA     L0070
        LDA     L2D74
        STA     L0082
        LDA     L2D75
        STA     L0083
.L2CA8
        INY
        LDA     (L008C),Y
        STA     L0080
        INY
        LDA     (L008C),Y
        STA     L0081
        BNE     L2CBD

        LDA     #$7F
        AND     L0073
        STA     L0073
        JMP     L2CF5

.L2CBD
        JSR     L29C3

        LDA     L0080
        AND     #$07
        CMP     #$06
        BPL     L2CD1

        INC     L0080
        INC     L0080
        LDA     L0081
        JMP     L2CDE

.L2CD1
        CLC
        LDA     L0080
        ADC     #$7A
        STA     L0080
        LDA     L0081
        ADC     #$02
        STA     L0081
.L2CDE
        CMP     #$80
        BMI     L2CE8

        LDA     #$00
        STA     (L008C),Y
        BEQ     L2CF5

.L2CE8
        JSR     L29C3

        DEY
        LDA     L0080
        STA     (L008C),Y
        INY
        LDA     L0081
        STA     (L008C),Y
.L2CF5
        CPY     L0070
        BMI     L2CA8

        RTS

        STA     L2D03
.L2CFD
        SEC
        LDA     L007C
        AND     #$7F
.L2D02
        SBC     #$10
L2D03 = L2D02+1
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

.L2D47
        EQUB    $02,$D6,$00,$00,$00,$00,$00,$00
        EQUB    $00,$00,$00,$00,$00,$00,$00,$00
        EQUB    $00,$00,$00,$00,$00,$00,$00,$00

.L2D5F
        EQUB    $80,$40,$40,$00,$80,$00,$40,$80
        EQUB    $00

.L2D68
        EQUB    $88,$A0,$B8,$D0,$E8,$D0,$B8,$88

.L2D70  \ Something to do with player bounds?
        EQUB    $20

.useless        \ L2D71
                \ Seems to be completely redundent. Set to $D7 here, changed to
                \ $F0 by L1EC6 (at the beginning of a new game), then decremented
				\ once by L1EE3. Possibly a removed or planned feature?
        EQUB    $D7

.L2D72
        EQUB    $00

.L2D73
        EQUB    $1A

.L2D74
        EQUB    $50

.L2D75
        EQUB    $23

.L2D76
        EQUB    $00		\ pigeon flying, 10 = add notes (use for bonus cheat), 80 = end level - c 2d76 80

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

.L2D7C
        EQUB    $00

.L2D7D
        EQUB    $00

.L2D7E
        EQUB    $06

.L2D7F
        EQUB    $00,$01,$81,$FD,$00,$00,$28,$00
        EQUB    $00,$3C,$06,$CE,$CE,$3B,$7E,$00
        EQUB    $00,$02,$83,$00,$00,$00,$00,$00
        EQUB    $00,$7F,$FF,$FE,$FF,$7E,$78,$00
        EQUB    $00,$03,$86,$FF,$00,$01,$02,$01
        EQUB    $01,$7F,$FF,$FD,$FD,$7E,$78,$00
        EQUB    $00,$04,$81,$FB,$E6,$FE,$10,$01
        EQUB    $5A,$7F,$FE,$E2,$9C,$7E,$00,$00
        EQUB    $00,$05,$0A,$00,$00,$00,$01,$0C
        EQUB    $00,$7F,$F5,$00,$E2,$7E,$00,$00
        EQUB    $00,$12,$00,$04,$00,$50,$00,$14
        EQUB    $00,$10,$00,$02,$00,$06,$00,$A0
        EQUB    $00,$10,$00,$03,$00,$07,$00,$C8
        EQUB    $00,$13,$00,$01,$00,$B4,$00,$0A
        EQUB    $00,$13,$00,$01,$00,$FA,$00,$0A
        EQUB    $00,$01,$00,$05,$00

.L2DFC
        EQUB    $49,$00

.L2DFE  \ Sprites
        EQUB    $0F,$00,$FF,$FF,$FF,$FF,$FF,$FF    \ Cloud part
        EQUB    $FF,$FF,$FF,$FF,$FF,$FF,$FF,$AA
        EQUB    $AA,$00,$55,$AA,$FF,$AA,$55,$55
        EQUB    $00,$00,$FF,$FF,$55,$FF,$FF,$FF
        EQUB    $FF,$00,$FF,$FF,$FF,$FF,$FF,$FF
        EQUB    $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
        EQUB    $FF,$AA,$FF,$FF,$FF,$FF,$FF,$AA
        EQUB    $55,$00,$FF,$FF,$FF,$55,$FF,$FF
        EQUB    $FF,$55,$FF,$FF,$FF,$FF,$FF,$FF
        EQUB    $FF,$AA,$FF,$FF,$FF,$FF,$FF,$FF
        EQUB    $AA,$00,$FF,$FF,$FF,$AA,$FF,$55
        EQUB    $00,$00,$FF,$55,$FF,$FF,$FF,$FF
        EQUB    $FF,$00,$FF,$FF,$FF,$FF,$FF,$FF
        EQUB    $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
        EQUB    $FF,$AA,$FF,$FF,$FF,$FF,$FF,$AA
        EQUB    $55,$00,$FF,$FF,$FF,$FF,$55,$FF
        EQUB    $FF,$FF,$AA,$FF,$FF,$FF,$FF,$FF
        EQUB    $FF,$AA,$FF,$55,$AA,$FF,$FF,$AA
        EQUB    $00,$00,$FF,$FF,$FF,$55,$AA,$00
        EQUB    $00,$00,$FF,$FF,$FF,$FF,$FF,$00
        EQUB    $00,$00,$FF,$FF,$FF,$FF,$FF,$FF
        EQUB    $55,$00,$FF,$FF,$FF,$FF,$FF,$FF
        EQUB    $FF,$55,$FF,$FF,$FF,$FF,$FF,$FF
        EQUB    $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
        EQUB    $FF,$00

.L2EC0  \ Sprites
        EQUB    $FF,$FF,$FF,$FF,$FF,$FF,$AA,$55    \ Cloud part
        EQUB    $FF,$FF,$AA,$55,$FF,$55,$FF,$FF
        EQUB    $55,$FF,$FF,$FF,$FF,$FF,$FF,$AA
        EQUB    $FF,$FF,$AA,$AA,$AA,$00,$00,$00

.L2EE0 \ Sprites for clouds and enemy aircraft
        EQUB    $FF,$FF,$55,$55,$55,$00,$00,$00    \ Cloud part
        EQUB    $FF,$FF,$FF,$FF,$FF,$FF,$FF,$00
        EQUB    $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
        EQUB    $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
        EQUB    $00,$05,$00,$00,$00,$00,$05,$00    \ Wave 1 aircraft sprite
        EQUB    $00,$0F,$0A,$0A,$0A,$0A,$0F,$00
        EQUB    $00,$0F,$00,$00,$00,$00,$0F,$15
        EQUB    $00,$0F,$05,$15,$0F,$05,$0F,$00
        EQUB    $0A,$0F,$2F,$3F,$2F,$0F,$0F,$0A
        EQUB    $00,$0F,$00,$00,$0A,$00,$0F,$15
        EQUB    $00,$0F,$00,$00,$00,$00,$0F,$00
        EQUB    $00,$0F,$0A,$0A,$0A,$0A,$0F,$00
        EQUB    $00,$04,$00,$00,$00,$00,$00,$00    \ Wave 2 aircraft sprite
        EQUB    $00,$0C,$04,$00,$00,$00,$00,$00
        EQUB    $00,$0C,$00,$08,$04,$00,$05,$05
        EQUB    $00,$0D,$15,$04,$04,$08,$00,$00
        EQUB    $08,$2F,$3F,$06,$0C,$08,$00,$00
        EQUB    $00,$0C,$00,$00,$04,$08,$05,$05
        EQUB    $00,$0C,$04,$08,$00,$00,$00,$00
        EQUB    $00,$0C,$00,$00,$00,$00,$00,$00
        EQUB    $00,$00,$00,$14,$14,$00,$00,$00    \ Wave 3 aircraft
        EQUB    $00,$00,$00,$00,$28,$3C,$00,$00
        EQUB    $00,$00,$00,$00,$00,$3C,$0A,$00
        EQUB    $28,$14,$00,$00,$14,$29,$14,$00
        EQUB    $00,$3C,$28,$28,$3E,$2B,$16,$28
        EQUB    $28,$00,$00,$00,$00,$3C,$00,$00
        EQUB    $00,$00,$00,$00,$00,$3C,$0A,$00
        EQUB    $00,$00,$00,$14,$3C,$28,$00,$00
        EQUB    $00,$00,$00,$00,$14,$00,$00,$00    \ Wave 4 aircraft
        EQUB    $30,$00,$00,$10,$3C,$10,$00,$00
        EQUB    $38,$28,$28,$3E,$14,$3C,$30,$00
        EQUB    $30,$00,$00,$20,$3C,$20,$00,$00
        EQUB    $10,$00,$00,$00,$3C,$00,$00,$00
        EQUB    $30,$00,$00,$34,$3C,$34,$10,$00
        EQUB    $38,$28,$28,$3A,$14,$38,$20,$00
        EQUB    $20,$00,$00,$00,$3C,$00,$00,$3A

.BeebDisEndAddr
SAVE "birdsk2.bin",p0data,BeebDisEndAddr

