\ Disassembly of Bird Strike from the original tape
\ Tape binary recovered in beebjit by setting a breakpoint at &1E00,
\ loading the game and then saving memory from &1400 to &3000 when
\ the breakpoint was triggered
\
\ Does not have the bug fix
\ Labels from Andy Frigaard's source discs
\ Has hard-coded hi/lo byte addresses
\
\ To Run:
\ Copy the assembled file to an emulator/floppy
\ *LOAD <filename> 1400
\ ?&5D = 1
\ CALL &1E00

\ Zero-page addresses
L005D   = $005D    \ CMP'd with #$01 - nfinite loop if not equal
no      = $0070
bfg     = $0071
pflg    = $0072
bofg    = $0073
mod     = $0074
pls     = $0075
exp     = $0077
pos     = $0078
psta    = $007A
yo      = $007B    \ OLD1/OLDSRCE.BAS
py      = $007C
ra1     = $007D
L007E   = $007E    \ Used by R% (rng?)
L007F   = $007F    \ Used by R% (rng?)
sd      = $0080
sf      = $0082
st      = $0084
gunp    = $0086
plf     = $0088
bulst   = $008A
bost    = $008C
cnt     = $008E

\ osword vectors
L020C   = $020C
L020D   = $020D

\ Unknown - uses osfile workspace
L02FC   = $02FC    \ Defined in PIGSRCE as picn=&2FC, but suspect this is an error(?)
                   \ Variables on the same line (680) in the &2Dxx-&2Fxx range
                   \ .picn defined at $1D54, as per various S/SOURCE.bas files
				   \ picn is reset every new game, L02FC isn't.
				   \ Doesn't seem to affect gameplay or create a bug.

\ Screen addresses
L4180   = $4180
L4900   = $4900

\ System VIA addresses
sv_ifr  = $FE4D
sv_ier  = $FE4E

\ OS calls
osasci  = $FFE3
oswrch  = $FFEE
osword  = $FFF1
osbyte  = $FFF4

org     $1400   \ P% in old money
		
.BeebDisStartAddr
        EQUS    "Thanks David,Ian,Martin,Mum,Dad,Susi C"

.opt
        LDX     #$EF
        JSR     key
        BNE     op1
        LDA     #$61
        STA     L020C
        LDA     #$14
        STA     L020D
		
.op1
        LDX     #$AE
        JSR     key
        BNE     op2
        LDA     soun
        STA     L020C
        LDA     soun+1
        STA     L020D
		
.op2
        LDX     #$CC
        JSR     key
        BNE     op5

.op3
        LDA     #$81
        LDY     #$01
        LDX     #$00
        JSR     osbyte
        BCS     op3
        CPX     #$52
        BEQ     op3

.op5
        RTS

.mute
        CMP     #$07
        BEQ     op5
        JMP     (soun)

.soun
        EQUB    $EB,$E7
		
.nlr
        LDA     tog
        BEQ     enlr
        LDA     exp
        BPL     rt
        DEC     psta
        SEC
        LDA     pos
        SBC     #$08
        STA     pos
        BCS     enlr
        DEC     pos+1
        JMP     enlr

.rt
        INC     psta
        CLC
        LDA     pos
        ADC     #$08
        STA     pos
        BCC     enlr
        INC     pos+1
		
.enlr
        LDA     #$01
        EOR     tog
        STA     tog
        JMP     fo

.tog
        EQUB    $00

.fpat
        LDA     fp0
        BEQ     fp1
        DEC     fp0
        RTS

.fp1
        LDA     #$12
        STA     fp0
        JMP     L297D

.fp0
        EQUB    $00

.gov
        PLA
        PLA
        LDY     #$FF
		
.gov1
        INY
        LDA     #$0A
        JSR     delay
        LDA     gov2,Y
        JSR     oswrch
        CMP     #$52
        BNE     gov1
        LDA     #$96
        JSR     delay
        JMP     newgame

.gov2
        EQUS    $1F,$05,$0F,$11,$01,"GAME OVER"

.stp4_  \ de-duplication of label name
        RTS

.stp6
        LDA     gex
        BEQ     stp4_
        LDA     psta
        EOR     #$80
        STA     psta
        INC     exp
        PLA
        PLA
        JMP     fo+3

.exg
        LDA     #$01
        BIT     exg3
        BNE     exg1
        LDY     sc+2
        CPY     #$05
        BMI     exg2
        ORA     exg3
        STA     exg3
        JSR     exg4

.exg1
        LDA     #$02
        BIT     exg3
        BNE     exg2
        LDY     sc+2
        CPY     #$10
        BMI     exg2
        ORA     exg3
        STA     exg3
        JMP     exg4

.exg2
        RTS

.exg3
        EQUB    $00

.exg4
        JSR     mini
        LDA     #$DC
        STA     L2DFC
        LDX     #$F8
        LDY     #$2D
        LDA     #$07
        JSR     osword
        INC     gex+1
        CLC
        LDA     gex+2
        ADC     #$18
        STA     gex+2
        BCC     exg5
        INC     gex+3
		
.exg5
        RTS

.bon
        LDA     fc
        AND     #$03
        BNE     bon0
        LDA     #$0F
        JSR     delay
        JSR     stmv
        JMP     bon11

.bon0
        JSR     cht
        JSR     tune

.bon11
        JSR     wbmsg
        LDY     #$4B
		
.bon1
        SED
        CLC
        LDA     sc+1
        ADC     #$02
        STA     sc+1
        LDA     sc+2
        ADC     #$00
        STA     sc+2
        CLD
        LDA     #$02
        JSR     delay
        TYA
        PHA
        LDX     #$E8
        LDY     #$2D
        LDA     #$07
        JSR     osword
        JSR     s7
        PLA
        TAY
        DEY
        BNE     bon1
        INC     bsou
        LDX     #$B7
        LDY     #$15
        LDA     #$07
        JSR     osword
        DEC     bsou
        LDA     #$80
        ORA     sc
        STA     sc
        RTS

.wbmsg
        LDY     #$00
		
.wb1
        LDA     bmsg,Y
        JSR     oswrch
        INY
        CPY     #$0B
        BNE     wb1
        RTS

.bmsg
        EQUB    $11,$06,$1F,$07,$0F
        EQUS    "BONUS!"

.bsou
        EQUB    $12,$00,$FF,$FF,$00,$00,$00,$00
        EQUB    $FF,$B4,$16,$08,$20,$7F

.hs
        EQUB    $00

\ .hs+1
        EQUB    $00

\ .hs+2
        EQUB    $02

.m7     \ Mode 7 title screen
        EQUB    $16,$07,$17,$00,$0A,$20,$00,$00
        EQUB    $00,$00,$00,$00
        EQUB    $9A,$94,$68,$3F,$6F,$34,$20,$20
        EQUB    $20,$20,$20,$20,$20,$20,$FF,$20
        EQUB    $20,$5F,$7E,$2F,$6D,$20,$78,$20
        EQUB    $20,$20,$20,$20,$20,$20,$7E,$0D
        EQUB    $9A,$96,$6A,$7D,$7E,$25,$20,$2F
        EQUB    $20,$30,$20,$20,$20,$20,$FF,$20
        EQUB    $20,$6A,$7D,$70,$30,$20,$FF,$2C
        EQUB    $20,$30,$20,$20,$2F,$20,$FF,$5F
        EQUB    $3E,$0D,$9A,$94,$6A,$3F,$60,$6F
        EQUB    $34,$FF,$20,$FF,$2F,$21,$78,$2F
        EQUB    $FF,$20,$20,$20,$60,$60,$FF,$20
        EQUB    $FF,$20,$20,$FF,$2F,$21,$FF,$20
        EQUB    $FF,$6F,$30,$20,$7E,$7B,$34,$0D
        EQUB    $9A,$96,$2A,$7D,$70,$7E,$25,$6F
        EQUB    $30,$FF,$20,$20,$6F,$7C,$3F,$20
        EQUB    $20,$2A,$7C,$7E,$27,$20,$6F,$74
        EQUB    $30,$FF,$20,$20,$6F,$30,$FF,$20
        EQUB    $2B,$34,$6D,$78,$24,$1F,$05,$05
        EQUB    $82
				
		EQUS    "FIREBIRD (c) Andrew Frigaard"
		EQUB    $0D,$1F,$0B,$08,$8D,$83
		EQUS    "High Score"
		
        EQUB    $1F,$0B,$09,$8D,$83
        EQUS    "High Score"

.dts
        EQUB    $1F,$0B,$0B   \ Move text cursor
        EQUS    "............."
        EQUB    $00
		EQUB    $1F,$19,$0B   \ Move text cursor

.nam
        EQUS    "andrew  "
        EQUB    $00

.ints   \ Instructions
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

.sps    \ Press space to play
        EQUB    $1F,$07,$18   \ Move text cursor
		EQUB    $81,$88       \ Red / flash
        EQUS    "Press space to play."
        EQUB    $00,$00,$00

.stmv
        LDY     #$0A
		
.stm4
        LDA     stm10,Y
        JSR     oswrch
        DEY
        BPL     stm4
        LDA     #$80
        STA     stm2+1
        LDA     #$00
        STA     stm3+1
        LDA     #$04
        STA     no
		
.stm1
        LDA     #$1D
        JSR     oswrch
        LDA     #$00
        JSR     oswrch
        JSR     oswrch
        SEC
		
.stm2
        LDA     #$00
		
\ .stm2+1
        SBC     #$80
        STA     stm2+1
        PHP
        JSR     oswrch
        PLP
		
.stm3
        LDA     #$00
		
\ .stm3+1
        SBC     #$00
        STA     stm3+1
        JSR     oswrch
        JSR     stv
        DEC     no
        BNE     stm1
        LDA     fc
        STA     tm
        LDA     #$00
        STA     fc
        LDA     #$26
        STA     tm+4
        LDA     #$88
        STA     tm+3
		
.stm6
        CLC
        LDA     tm+3
        STA     not
        LDA     tm+4
        ADC     #$0A
        STA     tm+4
        STA     not+1
        JSR     cht
        STX     nl
        INC     fc
		
.stm8
        JSR     nxno
        BNE     stm8
        JSR     cht
        JSR     tune
        LDA     #$3C
        JSR     delay
        LDA     fc
        CMP     #$04
        BNE     stm6
        LDA     tm
        STA     fc
        LDA     #$1A
        JMP     oswrch

.stm10
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

.gend
        LDA     #$00
        STA     hs
        LDA     sc+2
        CMP     hs+2
        BCC     ge1
        BNE     ge0
        LDA     sc+1
        CMP     hs+1
        BCC     ge1

.ge0
        LDA     sc+1
        STA     hs+1
        LDA     sc+2
        STA     hs+2
        DEC     hs
		
.ge1
        LDA     #$16
        JSR     oswrch
        LDA     #$07
        JSR     oswrch
        LDX     #$D4
        LDY     #$15
        JSR     wrs
        LDA     #$1F
        JSR     oswrch
        LDA     #$05
        JSR     oswrch
        LDA     #$0B
        JSR     oswrch
        LDA     hs+2
        JSR     whs
        LDA     hs+1
        JSR     whs
        LDA     #$30
        JSR     oswrch
        LDX     #$A0
        LDY     #$16
        JSR     wrs
        LDX     #$BD
        LDY     #$16
        JSR     wrs
        LDA     #$1F
        JSR     oswrch
        LDA     #$1A
        JSR     oswrch
        LDA     #$0B
        JSR     oswrch
        LDA     hs
        BEQ     ge3
        LDA     #$15
        LDX     #$00
        JSR     osbyte
        TXA
        LDX     #$C0
        LDY     #$15
        JSR     osword
        JMP     ge7

.ge3
        LDY     #$FF
		
.ge6
        INY
        LDA     nam,Y
        JSR     osasci
        CMP     #$20
        BPL     ge6

.ge7
        LDY     #$02
		
.ge5
        LDA     m7,Y
        JSR     oswrch
        INY
        CPY     #$0D
        BNE     ge5
        LDA     #$64
        JSR     delay

.space
        LDA     #$1A
        JSR     oswrch
        LDX     #$5C
        LDY     #$17
        JSR     wrs

.ge4
        LDX     #$9D
        JSR     key
        BNE     ge4
        RTS

.whs
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

.wrs
        STX     wr1+2
        STY     wr1+3
        LDY     #$FF
		
.wr1
        INY
		
\ .wr1+1
        LDA     dts,Y
		
\ .wr1+2

\ .wr1+3
        JSR     osasci
        CMP     #$00
        BNE     wr1
        PHA
        LDA     L005D
        CMP     #$01
        BNE     L1907
        PLA
        RTS

.L1907  \ Protection? - infinite loop if ?&5D != &01
        JMP     L1907
		
        \ Lives, explosions, bullet(?) sprites
        EQUB    $00,$00,$05,$00,$00,$00,$00,$08
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

.tm
        EQUB    $FF

\ .tm+1
        EQUB    $FF

\ .tm+2
        EQUB    $FF

\ .tm+3
        EQUB    $FF

\ .tm+4 \ Player sprites
        EQUB    $FF,$FF,$FF,$FF,$00,$04,$00,$04
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

.L1A60  \ Skull, pigeon sprites, KEYS artefacts, scenery, etc
        EQUB    $00,$00,$00,$00,$00,$40,$00,$40
        EQUB    $40,$80,$80,$40,$40,$40,$80,$00
        EQUB    $C0,$80,$80,$40,$C0,$40,$80,$00
        EQUB    $00,$80,$80,$00,$00,$40,$80,$40
        EQUB    $00,$00,$00,$00,$00,$00,$00,$00
        EQUB    $00,$00,$00,$14,$3C,$00,$00,$00
        EQUB    $00,$00,$00,$3C,$3C,$34,$3C,$28
        EQUB    $00,$00,$3C,$2D,$22,$00,$00,$00
        EQUB    $00,$00,$00,$14,$3C,$00,$14,$00
        EQUB    $00,$00,$00,$3C,$3C,$34,$28,$00
        EQUB    $00,$00,$3C,$2D,$22,$00,$00,$00
        EQUB    $00,$00,$00,$14,$3C,$00,$00,$00
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
        EQUB    $48,$4C,$44,$41,$53,$54,$41,$4A
        EQUB    $53,$52,$52,$54,$53,$42,$4E,$45
        EQUB    $50,$2E,$7E,$21,$26,$16,$34,$13
        EQUB    $31,$32,$30,$30,$30,$4C,$2E,$0E
        EQUB    $0D,$52,$55,$4E,$0D,$16,$32,$17
        EQUB    $00,$0C,$00,$00,$00,$00,$00,$00
        EQUB    $00,$00,$43,$41,$4C,$4C,$51,$25
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

.L1D40  \ Gravestone locations + other?
        EQUB    $31,$7A,$D9,$7C,$C9,$77,$12,$7A
        EQUB    $C8,$7C,$BA,$77,$51,$7A,$B8,$7C
        EQUB    $20,$7A,$42,$7A

.picn
        EQUB    $00

.gex
        EQUB    $00

\ .gex+1
        EQUB    $00

\ .gex+2
        EQUB    $00

\ .gex+3
        EQUB    $00

.not
        EQUB    $00

\ .not+1
        EQUB    $00

.L1D5B  \ Hard coded in S*.BAS files
        EQUB    $00

.fc     \ Current level / building sprites
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

.Q%
        LDA     #$C8
        LDX     #$03
        LDY     #$00
        JSR     osbyte
        JSR     space
        LDX     #$01
        LDA     #$04
        LDY     #$00
        JSR     osbyte
        LDA     L020C
        STA     soun
        LDA     L020D
        STA     soun+1
		
.newgame
        JSR     gend
        JSR     S%

.GO
        JSR     R%
        JSR     scr
        JSR     mp
        JSR     np
        JSR     mg
        JSR     mb
        JSR     nb
        JSR     mbo
        JSR     nbo
        JSR     B%
        JSR     h0
        JSR     sor
        JSR     opt
        JMP     GO
		
        EQUS    "(c)A.E.Frigaard 1984 Hello!"

.S%
        LDA     #$05
        STA     no
        JSR     E%
        LDA     #$49
        JSR     tune
        LDA     #$16
        JSR     oswrch
        LDA     #$02
        JSR     oswrch
        LDA     #$00
        STA     exg3
        STA     cnt
        STA     fc
        STA     picn
        STA     gex
        STA     sc+1
        STA     sc+2
        STA     plf
        CLC
        LDA     #$20
        STA     de
        LDA     #$03
        STA     de+1
        LDA     #$2A
        STA     de+2
        LDA     #$02
        STA     bfg
        LDA     #$2D
        STA     bulst+1
        STA     bost+1
        STA     pls+1
        LDA     #$47
        STA     bost
        LDA     #$0A
        STA     bulst
        LDA     #$13
        STA     pls
        LDX     #$0F
        LDY     #$07
		
.co1
        JSR     D%
        DEX
        CPX     #$07
        BNE     co1
        STX     ra1
        LDA     #$03
        STA     gex+1
        LDA     #$2F
        STA     plf+1
        LDA     #$F0
        STA     inb
        LDA     #$00
        STA     tm+1
		
.bf
        JSR     cht
        STX     nl
        INC     fc
        LDA     de
        CMP     #$0F
        BMI     b0
        LDA     fc
        AND     #$01
        BEQ     b0
        DEC     de
        DEC     de
        DEC     inb
		
.b0
        INC     tm+1
        INC     tm+1
        LDA     #$0C
        JSR     oswrch
        LDA     #$9A
        LDX     #$14
        JSR     osbyte
        JSR     C%
        JSR     V%
        JSR     stv
        JSR     s7
        LDA     #$00
        STA     L1D5B
        STA     sc
        STA     ba+1
        LDY     #$54
		
.b1
        STA     L2D0A,Y
        DEY
        BNE     b1
        LDA     tm+1
        STA     L2D47
        LDA     #$06
        STA     L2D0A
        LDA     #$1E
        STA     L2D13
        LDA     #$30
        STA     not+1
        LDA     #$88
        STA     not
        LDA     #$80
        STA     gex+2
        LDA     #$32
        STA     gex+3
        LDX     gex+1
		
.pmi
        JSR     mini
        CLC
        LDA     gex+2
        ADC     #$18
        STA     gex+2
        DEX
        BNE     pmi

.ppos
        LDA     #$3A
        STA     sd+1
        LDA     #$81
        STA     sf
        LDX     #$01
        LDY     #$08
		
.pp1
        LDA     #$81
        STA     L2D13,X
        INX
        TYA
        CLC
        ADC     #$50
        STA     L2D13,X
        TAY
        INX
        LDA     sd+1
        ADC     #$00
        STA     L2D13,X
        STA     sd+1
        CLC
        INX
        LDA     sf
        ADC     #$0A
        STA     sf
        STA     L2D13,X
        INX
        LDA     #$D0
        STA     L2D13,X
        INX
        CPX     #$1F
        BMI     pp1
        LDY     #$00
        LDA     (pls),Y
        STA     no
		
.slop
        INY
        INY
        LDA     (pls),Y
        STA     pos
        INY
        LDA     (pls),Y
        STA     pos+1
        JSR     pp
        INY
        INY
        CPY     no
        BMI     slop
        JSR     h7

.sgun
        LDA     #$20
        STA     Xg
        LDA     #$7E
        STA     gunp+1
        LDA     #$90
        STA     gunp
        LDA     #$23
        STA     gun+4
        LDA     #$58
        STA     gun+3
        JSR     gun
        LDA     #$40
        JMP     tune

.sor
        LDA     sc
        BEQ     s7
        SED
        AND     #$02
        BEQ     s1
        CLC
        LDA     #$15
        ADC     sc+1
        STA     sc+1
        LDA     sc+2
        ADC     #$00
        STA     sc+2
        JSR     X%

.s1
        LDA     #$40
        BIT     sc
        BEQ     s4
        CLC
        LDA     #$01
        ADC     sc+1
        STA     sc+1
        LDA     sc+2
        ADC     #$00
        STA     sc+2
        CLD
        LDX     #$B7
        LDY     #$15
        LDA     #$07
        JSR     osword
        SED
.s4
        LDA     #$10
        BIT     sc
        BEQ     s2
        CLC
        LDA     #$0A
        ADC     sc+1
        STA     sc+1
        LDA     sc+2
        ADC     #$00
        STA     sc+2
        CLD
        JSR     nxno
        BNE     s2
        JSR     bon

.s2
        CLD
        JSR     exg
        LDA     sc
        BPL     s3
        JMP     ef

.s3
        LDA     #$00
        STA     sc
        RTS

.s7
        LDA     #$34
        STA     sd+1
        LDA     #$B0
        STA     sd
        LDA     #$1C
        STA     sf+1
        LDA     #$F0
        AND     sc+2
        JSR     w
        LDA     #$0F
        AND     sc+2
        ASL     A
        ASL     A
        ASL     A
        ASL     A
        JSR     w
        LDA     #$F0
        AND     sc+1
        JSR     w
        LDA     #$0F
        AND     sc+1
        ASL     A
        ASL     A
        ASL     A
        ASL     A
        JSR     w
        LDA     #$00
        JMP     w

.delay
        STA     tm+2
        TYA
        PHA
		
.del1
        JSR     scr
        DEC     tm+2
        BNE     del1
        PLA
        TAY
        RTS

.ef
        LDA     #$00
        STA     sc
        CLC
        LDA     plf
        ADC     #$40
        STA     plf
        LDA     #$64
        JSR     delay
        JMP     bf

.cht
        LDA     #$03
        AND     fc
        TAX
        BNE     ct1
        LDA     #$33
        RTS

.ct1
        DEX
        BNE     ct2
        TXA
        LDX     #$0D
        RTS

.ct2
        DEX
        BNE     ct3
        LDA     #$11
        LDX     #$1A
        RTS

.ct3
        LDA     #$22
        LDX     #$26
        RTS

.patch
        LDA     ra1
        BPL     patch2
        LDA     sd
        EOR     #$C0
        STA     sd
		
.patch2
        LDA     de
        RTS

.nxno
        INC     nl
        LDY     nl
        LDA     nl,Y
        STA     no
        AND     #$0E
        CMP     #$08
        BPL     n1
        CLC
        ADC     not
        STA     sd
        LDA     #$00
        BEQ     n2

.n1
        CLC
        ADC     not
        ADC     #$78
        STA     sd
        LDA     #$02
.n2
        ADC     not+1
        STA     sd+1
        LDA     #$23
        STA     sf+1
        JSR     chnot
        CLC
        LDA     not
        ADC     #$20
        STA     not
        BCC     n3

        INC     not+1
		
.n3
        JSR     pno
        CLC
        LDA     sd
        ADC     #$08
        STA     sd
        BCC     n4
        INC     sd+1
		
.n4
        CLC
        LDA     sf
        ADC     #$08
        STA     sf
        BCC     n5
        INC     sf+1
.n5
        JSR     pno
        INY
        LDA     nl,Y
        RTS

.chnot
        LDA     #$80
        BIT     no
        BEQ     c1
        LDA     #$00
        STA     sf
        RTS

.c1
        LSR     A
        BIT     no
        BEQ     c2
        LDA     #$10
        STA     sf
        RTS

.c2
        LSR     A
        BIT     no
        BEQ     c3
        LDA     #$20
        STA     sf
        RTS

.c3
        LSR     A
        BIT     no
        BEQ     c4
        LDA     #$30
        STA     sf
        RTS

.c4
        LDA     #$01
        BIT     no
        BEQ     c5
        LDA     #$40
        STA     sf
		
.c5
        RTS

.pno    \ similar to .s5
        TYA
        PHA
        LDY     #$07
        CLC
        LDA     sd
        ADC     #$78
        STA     st
        LDA     sd+1
        ADC     #$02
        STA     st+1
        LDA     sd
        AND     #$07
        EOR     #$07
        STA     mod
        CMP     #$07
        BPL     top

.bot
        LDA     (sf),Y
        ORA     (st),Y
        STA     (st),Y
        DEY
        CPY     mod
        BNE     bot

.top
        LDA     (sf),Y
        ORA     (sd),Y
        STA     (sd),Y
        DEY
        BPL     top
        PLA
        TAY
        RTS

.tune
        STA     no
		
.t1
        LDY     no
        LDA     tl,Y
        BEQ     t3
        STA     L2DFC
        INY
        LDA     tl,Y
        STA     L2DFE
        LDX     #$F8
        LDY     #$2D
        LDA     #$07
        JSR     osword

        INC     no
        INC     no
        JMP     t1

.t3
        LDA     #$80
        LDX     #$FA
        JSR     osbyte
        CPX     #$0F
        BMI     t3
        RTS

.key
        LDA     #$81
        LDY     #$FF
        JSR     osbyte
        INX
        RTS
		
		\ Artefacts?
        EQUB    $E8,$60,$00,$00,$00,$00,$00,$00
        EQUB    $00,$00,$00,$00,$00,$00,$00,$00

.stv
        LDY     #$00
		
.L21F0
        LDA     sl,Y
        JSR     oswrch
        INY
        CPY     #$09
        BNE     L21F0
        LDX     #$05
		
.L21FD
        LDY     #$09
		
.L21FF
        LDA     sl,Y
        JSR     oswrch
        INY
        CPY     #$15
        BNE     L21FF
        DEX
        BNE     L21FD
        RTS

.sl     \ Stave data
        EQUB    $12,$00,$04,$19,$04,$00,$01,$EC
        EQUB    $03,$19,$01,$00,$03,$00,$00,$19
        EQUB    $00,$00,$FD,$F0,$FF

.mini
        LDA     #$10
        STA     sf
        LDA     #$19
        STA     sf+1
        LDA     gex+2
        STA     sd
        LDA     gex+3
        STA     sd+1
        JMP     pb

.h0
        LDA     #$20
        BIT     sc
        BNE     h1
        LDA     gex
        BNE     h12

.stp4
        RTS

.h1
        LDX     #$00
        LDY     #$07
        JSR     D%
        LDA     #$07
        LDY     #$2D
        LDX     #$E0
        JSR     osword
        LDA     #$FF
        STA     gex
        LDA     #$60
        STA     nbo
        STA     np
        STA     mg
        STA     nb
        JSR     gun
        LDA     #$1A
        STA     gun+4
        LDA     #$10
        STA     gun+3
        JMP     gun

.h12
        DEC     gex
        LDA     gex
        CMP     #$FE
        BNE     h3
        LDX     #$00
        LDY     #$00
        JMP     D%

.h3
        CMP     #$DC
        BNE     h4
        JSR     gun
        LDA     #$38
        STA     gun+3
        JMP     gun

.h4
        CMP     #$8C
        BNE     h5
        JSR     gun
        LDA     #$60
        STA     gun+3
        JMP     gun

.h5
        CMP     #$01
        BNE     stp4
        DEC     gex+1
        BNE     L22B3
        JMP     gov

.L22B3
        JSR     gun
        JSR     sgun
        LDY     L2D13
		
.h6
        LDA     (pls),Y
        CMP     #$C0
        BNE     h8
        DEY
        LDA     (pls),Y
        BPL     h9
        EOR     #$80
        STA     (pls),Y
        DEY
        LDA     (pls),Y
        STA     pos+1
        DEY
        LDA     (pls),Y
        STA     pos
        JSR     pp
        JMP     h10

.h8
        DEY
		
.h9
        DEY
        DEY
		
.h10
        DEY
        DEY
        BNE     h6

.h7
        LDA     #$20
        STA     mg
        LDA     #$A5
        STA     np
        LDA     #$A9
        STA     nbo
        STA     nb
        SEC
        LDA     gex+2
        SBC     #$18
        STA     gex+2
        JMP     mini

        \ Musical notes sprites / bombs / player
        EQUB    $00,$00,$00,$00,$00,$14,$3C,$3C
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

.nl
        EQUB    $0D,$4A,$18,$8C,$8E,$1C,$8A,$84
        EQUB    $14,$82,$20,$44,$05,$00,$48,$18
        EQUB    $86,$84,$14,$86,$84,$14,$88,$2A
        EQUB    $4E,$05,$00,$4A,$18,$8C,$8E,$1C
        EQUB    $8A,$84,$14,$82,$20,$44,$00,$44
        EQUB    $42,$42,$44,$46,$24,$14,$05,$00

.tl     \ tunes
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

.B%
pg = B%
        LDA     #$1B
        STA     sf+1
        LDA     ba+1
        BNE     b0_
        LDA     #$42
        BIT     sc
        BEQ     ep
        LDA     #$02
        BIT     L02FC    \ Should this be picn?
        BEQ     pg1
        LDA     #$1B
        STA     sf+1
        STA     pg+1
        LDA     #$68
        STA     ba
        STA     sd
        LDA     #$00
        STA     xps+1
        LDA     #$4C
        STA     L2D7F
        LDA     #$4B
        STA     b5-2
        BNE     b3

.pg1
        LDA     #$1A
        STA     sf+1
        STA     pg+1
        LDA     #$00
        STA     ba
        STA     sd
        STA     L2D7F
        LDA     #$4C
        STA     xps+1
        LDA     #$49
        STA     b5-2
.b3
        LDA     #$00
        STA     py
        INC     L02FC    \ Should this be picn?
        LDA     #$07
        AND     ra1
        TAX
        LDA     #$4B
		
\ .b5-2
        CLC
		
.b5
        ADC     #$05
        TAY
        LDA     py
        ADC     #$10
        STA     py
        TYA
        DEX
        BPL     b5
        STA     ba+1
        STA     sd+1
        LDX     #$02
        STX     ba+2
        LDA     bis,X
        STA     sf
        JMP     pb

.ep
        RTS

.b0_    \ de-duplication of label
        LDA     ba
        STA     sd
        LDA     ba+1
        STA     sd+1
        BPL     b1_
        DEC     ba+2
        BNE     ep
        EOR     #$80
        STA     sd+1
        LDA     #$10
        ORA     sc
        STA     sc
        LDA     #$00
        STA     ba+1
        BEQ     bx

.b1_    \ de-duplication of label
        LDA     ba+2
        AND     #$7F
        TAX
        LDA     bis,X
        STA     sf
        LDY     #$00
        LDA     (bulst),Y
        STA     no
		
.h
        INY
        LDA     (bulst),Y
        SEC
        SBC     py
        BMI     nh
        CMP     #$07
        BPL     nh
        INY
        INY
        LDA     (bulst),Y
        BEQ     nh+2
        INY
        LDA     (bulst),Y
        SEC
        SBC     L2D7F
        BMI     nh+3
        CMP     #$03
        BPL     nh+3
        LDA     #$E8
        STA     (bulst),Y
        TAX
        LDA     #$07
        LDY     #$2D
        JSR     osword
        LDA     #$10
        STA     ba+2
        LDA     #$80
        ORA     ba+1
        STA     ba+1
        JSR     pb

.bx
        LDA     #$1B
        STA     sf+1
        LDA     #$70
        STA     sf
        JMP     pb

.b9
        LDA     #$04
        ORA     sc
        STA     sc
        LDA     #$00
        STA     ba+1
.x
        RTS

.nh
        INY
        INY
		
\ .nh+2
        INY
		
\ .nh+3
        CPY     no
        BMI     h
        LDA     #$80
        EOR     ba+2
        STA     ba+2
        BMI     x
        JSR     pb
        LDA     L2D7F
		
.xps
        CMP     #$00
		
\ .xps+1
        BEQ     b9
        AND     #$1F
        BNE     b6
        LDA     #$07
        LDY     #$2D
        LDX     #$F0
        JSR     osword

.b6
        LDX     ba+2
        DEX
        BPL     b7

        LDX     #$07
.b7
        STX     ba+2
        LDA     bis,X
        STA     sf
        LDA     xps+1
        BEQ     b10
        INC     L2D7F
        CLC
        LDA     ba
        ADC     #$08
        STA     ba
        STA     sd
        BCC     pb
        INC     ba+1
        INC     sd+1
        JMP     pb

.b10
        DEC     L2D7F
        SEC
        LDA     ba
        SBC     #$08
        STA     ba
        STA     sd
        BCS     pb
        DEC     ba+1
        DEC     sd+1
		
.pb
        LDY     #$17
		
.b8
        LDA     (sf),Y
        EOR     (sd),Y
        STA     (sd),Y
        DEY
        BPL     b8
        RTS

.X%
        LDY     L1D5B
        CPY     #$09
        BPL     L25B7
        LDA     L1D40,Y
        STA     sd
        INY
        LDA     L1D40,Y
        STA     sd+1
        INY
        STY     L1D5B
        LDY     #$04
        LDA     #$55
		
.L25A7
        STA     (sd),Y
        DEY
        BPL     L25A7
        LDY     #$09
        ASL     A
        STA     (sd),Y
        LDY     #$01
        LDA     #$FF
        STA     (sd),Y
		
.L25B7
        RTS

.R%
        LDA     ra1
        AND     #$48
        ADC     #$38
        ASL     A
        ASL     A
        ROL     L007F
        ROL     L007E
        ROL     ra1
        LDA     ra1
        RTS

.V%
        LDY     #$00
		
.L25CB
        LDA     L26B0,Y
        JSR     oswrch
        INY
        BNE     L25CB
        LDA     plf
        STA     sf
        LDA     plf+1
        STA     sf+1
        LDA     #$1F
        STA     L2C1D+1
        LDA     #$E0
        STA     no
        LDY     #$00
		
.L25E7
        INY
        LDX     L27C3,Y
        INY
        LDA     L27C3,Y
        BIT     no
        BNE     L25FF
        STA     plf+1
        STX     plf
        INY
        LDX     L27C3,Y
        INY
        LDA     L27C3,Y
		
.L25FF
        STX     pos
        STA     pos+1
        JSR     pp
        CPY     L27C3
        BMI     L25E7
        LDA     #$3F
        STA     L2C1D+1
        LDA     sf
        STA     plf
        LDA     sf+1
        STA     plf+1
        RTS
        EQUB    $00

.C%
        LDA     #$44
        STA     pos+1
        LDA     #$FF
        LDX     #$05
		
.L2622
        LDY     #$00
        STY     pos
		
.L2626
        STA     (pos),Y
        INY
        BNE     L2626
        INC     pos+1
        DEX
        BNE     L2622
        LDY     #$1F
		
.L2632
        LDA     L2EE0,Y
        STA     (pos),Y
        DEY
        BPL     L2632
        LDA     #$2E
        STA     yo
        LDA     #$20
        STA     pos
        LDX     #$08
		
.L2644
        LDA     L2D5F,X
        STA     psta
        LDY     #$3F
		
.L264B
        LDA     (psta),Y
        STA     (pos),Y
        DEY
        BPL     L264B
        CLC
        LDA     pos
        ADC     #$40
        STA     pos
        BCC     L265D
        INC     pos+1
		
.L265D
        DEX
        BPL     L2644
        LDY     #$1F
		
.L2662
        LDA     L2EC0,Y
        STA     (pos),Y
        DEY
        BPL     L2662

.L266A
        LDY     #$00
		
.L266C
        LDX     #$07
		
.L266E
        LDA     L4900,Y

.L2671
        STA     L4180,X
        INY
        DEX
        BPL     L266E
        CLC
        LDA     L2671+1
        ADC     #$08
        STA     L2671+1
        BCC     L2686
        INC     L2671+2
		
.L2686
        CPY     #$80
        BNE     L266C
        LDA     L266E+1
        EOR     #$80
        STA     L266E+1
        BMI     L2697
        INC     L266E+2
.L2697
        LDA     #$44
        CMP     L2671+2
        BNE     L266A
        STY     L2671+1
        INX
        STX     L266E+1
        LDA     #$49
        STA     L266E+2
        LDA     #$41
        STA     L2671+2
        RTS

.L26B0  \ Scenery art VDU calls
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

.L27C3  \ Trees / scenery sprites
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

.D%
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

.E%
        LDA     no
        ASL     A
        ASL     A
        ASL     A
        ASL     A
        ADC     #$70
        TAX
        LDA     #$08
        LDY     #$2D
        JSR     osword
        DEC     no
        BNE     E%
        RTS

.scr
        LDA     #$02
        STA     sv_ier
		
.L284F
        BIT     sv_ifr
        BEQ     L284F
        LDA     #$82
        STA     sv_ier
        RTS

.w
        STA     sf
        LDY     #$0F
		
.L285E
        LDA     (sf),Y
        STA     (sd),Y
        DEY
        BPL     L285E
        CLC
        LDA     sd
        ADC     #$10
        STA     sd
        RTS
        BRK
		
.mg
        EQUB    $60
        EQUB    $D3,$28
        LDA     #$81
        LDY     #$FF
        LDX     #$BD
        JSR     osbyte
        INX
        BEQ     r
        DEY
        LDX     #$9E
        JSR     osbyte
        INX
        BNE     gd
        LDX     Xg
        CPX     #$01
        BEQ     gd
        DEX
        STX     Xg
        SEC
        LDA     gunp
        SBC     #$08
        STA     gunp
        BCS     gd
        DEC     gunp+1
        BCC     gd

.r
        LDX     Xg
        CPX     #$47
        BEQ     gd
        INX
        STX     Xg
        CLC
        LDA     gunp
        ADC     #$08
        STA     gunp
        BCC     gd
        INC     gunp+1
		
.gd
        SEC
        LDA     #$00
        STA     pos
        LDY     #$24
		
.ch
        LDA     (gunp),Y
        BEQ     cop
        STA     pos
		
.cop
        TYA
        SBC     #$08
        TAY
        BPL     ch
        LDA     pos
        BEQ     gun
        LDA     sc
        ORA     #$20
        STA     sc
		
.gun
        LDY     #$27
		
.gop
        LDA     L1A60,Y
        BEQ     gz
        EOR     (gunp),Y
        STA     (gunp),Y
		
.gz     \ TODO: Check gz/mb - may be mixed up
        DEY
        BPL     gop
        RTS

.mb     \ TODO: Check gz/mb - may be mixed up
        LDY     #$00
        LDA     (bulst),Y
        STA     no
        LDA     inb+1
        STA     sf
        LDA     buf
        STA     sf+1
		
.ntbu
        INY
        LDA     (bulst),Y
        STA     exp
        INY
        LDA     (bulst),Y
        STA     sd
        INY
        LDA     (bulst),Y
        STA     sd+1
        BNE     bu1
        INY
        LDA     #$FE
        AND     bfg
        STA     bfg
        JMP     nxbu

.bu1
        INY
        JSR     s5
        LDA     (bulst),Y
        BPL     bu2

.bu7
        LDA     #$00
        STA     sd+1
        BEQ     nxbu

.bu2
        SEC
        LDA     #$07
        AND     sd
        CMP     #$05
        BMI     bu3
        LDA     sd
        SBC     #$05
        STA     sd
        JMP     bu4

.bu3
        LDA     sd
        SBC     #$7D
        STA     sd
        LDA     sd+1
        SBC     #$02
        STA     sd+1
		
.bu4
        SEC
        LDA     exp
        SBC     #$05
        STA     exp
        CMP     #$02
        BEQ     bu7
        JSR     s5

.nxbu
        DEY
        DEY
        DEY
        LDA     exp
        STA     (bulst),Y
        INY
        LDA     sd
        STA     (bulst),Y
        INY
        LDA     sd+1
        STA     (bulst),Y
        INY
        CPY     no
        BMI     ntbu
        RTS

.nb
        RTS
        EQUB    $01
        BIT     bfg
        BNE     nwb0
        LDA     #$81
        LDY     #$FF
        LDX     #$B6
        JSR     osbyte
        INX
        BEQ     nwb1
        LDA     #$00
        STA     fp0
        RTS

.nwb0
        RTS

.nwb1
        JMP     fpat
        EQUB    $71,$D0,$F9

.L297D  \ Hard-coded in S*.BAS
        LDY     #$FF
		
.nwb2
        INY
        INY
        INY
        INY
        LDA     (bulst),Y
        BNE     nwb2
        DEY
        DEY
        LDA     #$9D
        STA     (bulst),Y
        INY
        SEC
        LDA     gunp
        SBC     #$6E
        STA     (bulst),Y
        STA     sd
        INY
        LDA     gunp+1
        SBC     #$02
        STA     (bulst),Y
        STA     sd+1
        INY
        LDA     Xg
        CLC
        ADC     #$03
        STA     (bulst),Y
        JSR     s5
        LDA     #$03
        ORA     bfg
        STA     bfg
        LDA     #$01
        ORA     sc
        STA     sc
        LDA     #$07
        LDY     #$2D
        LDX     #$D0
        JMP     osword

.s5     \ similar to .pno
        TYA
        PHA
        LDY     #$05
        CLC
        LDA     sd
        ADC     #$78
        STA     st
        LDA     sd+1
        ADC     #$02
        STA     st+1
        LDA     sd
        AND     #$07
        EOR     #$07
        STA     mod
        CMP     #$05
        BPL     top_s5

.bot_s5
        LDA     (sf),Y
        EOR     (st),Y
        STA     (st),Y
        DEY
        CPY     mod
        BNE     bot_s5

.top_s5
        LDA     (sf),Y
        EOR     (sd),Y
        STA     (sd),Y
        DEY
        BPL     top_s5
        PLA
        TAY
        RTS

.np
        RTS
        EQUB    $72
        CMP     #$01
        BPL     nw
        DEC     de+1
        BNE     nw
        LDA     de+2
        STA     de+1
        LDA     no
        JSR     ra2
        TAY
        SEC
		
.n2_    \ de-duplication of label
        SBC     #$05
        BPL     n2_
        TAX
		
.n3_    \ de-duplication of label
        INY
        INX
        BNE     n3_
        DEY
        LDA     (pls),Y
        BMI     fy
        LDY     no
		
.se
        DEY
        LDA     (pls),Y
        BMI     fy
        DEY
        DEY
        DEY
        DEY
        BNE     se
        LDA     #$80
        ORA     sc
        STA     sc
        RTS

.fy
        EOR     #$80
        STA     (pls),Y
		
.nw
        RTS

.pxp
        LDA     exp
        BEQ     nx
        LDX     #$19
        STX     plf+1
        LDA     plf
        PHA
        LDA     exp
        CMP     #$15
        BNE     px1
        LDA     #$40
        STA     plf
        JSR     pp
        JMP     px4

.px1
        CMP     #$0C
        BNE     px2
        LDA     #$40
        STA     plf
        JSR     pp
        LDA     #$80
        STA     plf
        JSR     pp
        JMP     px4

.px2
        CMP     #$06
        BNE     px3
        LDA     #$80
        STA     plf
        JSR     pp
        LDA     #$C0
        STA     plf
        JSR     pp
        JMP     px4

.px3
        CMP     #$01
        BNE     px4
        LDA     #$C0
        STA     plf
        JSR     pp

.px4
        LDA     #$2F
        STA     plf+1
        PLA
        STA     plf
        DEC     exp
		
.nx
        JMP     fo+3

.mp
        LDY     #$00
        LDA     (pls),Y
        STA     no
        STY     pflg
		
.nxpl
        INY
        LDA     (pls),Y
        STA     exp
        INY
        LDA     (pls),Y
        STA     pos
        INY
        LDA     (pls),Y
        STA     pos+1
        INY
        LDA     (pls),Y
        STA     psta
        INY
        LDA     (pls),Y
        STA     yo
        LDA     exp
        AND     #$C0
        BNE     p0
        JMP     pxp

.p0
        LDA     psta
        BPL     p1
        JMP     pl1

.p1
        DEC     exp
        TYA
        PHA
        LDY     #$00
        LDA     (bulst),Y
        STA     sd
		
.h_     \ de-duplication of label
        INY
        LDA     (bulst),Y
        SEC
        SBC     yo
        BMI     nh_
        CMP     #$08
        BPL     nh_
        INY
        INY
        LDA     (bulst),Y
        BEQ     L2B20
        INY
        LDA     (bulst),Y
        SEC
        SBC     psta
        BMI     L2B21
        CMP     #$07
        BPL     L2B21
        CMP     #$03
        BEQ     o
        LDA     #$40
        ORA     sc
        STA     sc
        ASL     A
        STA     (bulst),Y
        BNE     L2B21

.o
        LDA     #$19
        STA     exp
        LDA     #$D8
        STA     (bulst),Y
        TAX
        LDA     #$07
        LDY     #$2D
        JSR     osword

        PLA
        TAY
        LDA     #$02
        ORA     sc
        STA     sc
        JSR     pp
        JMP     pxp

.nh_    \ de-duplication of label
        INY
        INY
.L2B20
        INY
.L2B21
        CPY     sd
        BMI     h_
        PLA
        TAY
        LDA     bofg
        AND     #$BF
        STA     bofg
        INC     pflg
        JSR     pp
        LDA     yo
        CMP     #$AF
        BNE     hop5
        SEC
        LDA     pos
        SBC     #$87
        STA     pos
        LDA     pos+1
        SBC     #$48
        STA     pos+1
        LDA     #$C0
        STA     yo
        JSR     stp6

.hop5
        LDA     #$3F
        AND     exp
        BNE     mid
        SEC
        LDA     psta
        SBC     Xg
        STA     exp
        LDA     #$00
        BCS     pl3
        SEC
        ROR     A
		
.pl3
        ROR     A
        STA     sd
        LDA     exp
        BNE     pl5
        JSR     patch

.pl5
        BPL     pl4
        EOR     #$FF
        CLC
        ADC     #$01
		
.pl4
        CMP     #$02
        BMI     pl6
        STA     ra3+1
        JSR     ra2+3
        LSR     ra3+1
        CLC
        ADC     ra3+1
        AND     #$3F
		
.pl6
        ORA     sd
        STA     exp
		
.mid
        LDA     exp
        LDX     psta
        CPX     #$01
        BPL     nl_
        ORA     #$40
        AND     #$7F
        JMP     do

.nl_    \ de-duplication of label
        CPX     #$48
        BMI     L2BA1
        ORA     #$80
        AND     #$BF
		
.do
        STA     exp
		
.L2BA1
        INC     yo
        LDA     #$07
        AND     pos
        CMP     #$07
        BEQ     pl2
        INC     pos
        JMP     lft

.pl2
        CLC
        LDA     pos
        ADC     #$79
        STA     pos
        LDA     pos+1
        ADC     #$02
        STA     pos+1
.lft
        JMP     nlr
        BCC     rgt
        DEC     psta
        LDA     pos
        SBC     #$08
        STA     pos
        BCS     fo
        DEC     pos+1
        JMP     fo

.rgt
        INC     psta
        ROL     A
        BCC     fo
        CLC
        LDA     pos
        ADC     #$08
        STA     pos
        BCC     fo
        INC     pos+1
.fo
        JSR     pp

\ .fo+3
        DEY
        DEY
        DEY
        DEY
        LDA     exp
        STA     (pls),Y
        INY
        LDA     pos
        STA     (pls),Y
        INY
        LDA     pos+1
        STA     (pls),Y
        INY
        LDA     psta
        STA     (pls),Y
        INY
        LDA     yo
        STA     (pls),Y
		
.pl1
        CPY     no
        BEQ     hop7
        JMP     nxpl

.hop7
        RTS

.pp
        TYA
        PHA
        CLC
        LDA     pos
        ADC     #$78
        STA     st
        AND     #$07
        EOR     #$07
        STA     mod
        LDA     pos+1
        ADC     #$02
        STA     st+1
		
.L2C1D
        LDY     #$3F
		
\ .L2C1D+1

.plo
        LDX     #$07
        CPX     mod
        BEQ     tp

.bt
        LDA     (plf),Y
        BEQ     bz
        EOR     (st),Y
        STA     (st),Y
.bz
        DEY
        DEX
        CPX     mod
        BNE     bt

.tp
        LDA     (plf),Y
        BEQ     tz
        EOR     (pos),Y
        STA     (pos),Y
		
.tz
        DEY
        DEX
        BPL     tp
        TYA
        BPL     plo
        PLA
        TAY
        RTS

.nbo
        RTS
        EQUB    $C0
        BIT     bofg
        BNE     nbo4
        DEC     bofg
        BNE     nbo4
        LDY     #$FF
		
.nbo2
        INY
        INY
        INY
        INY
        INY
        LDA     (pls),Y
        BMI     nbo2
        DEY
        DEY
        DEY
        LDA     (pls),Y
        AND     #$C0
        BNE     nbo5
        INY
        INY
        INY
        JMP     nbo2

.nbo5
        INY
        CLC
        LDA     (pls),Y
        ADC     #$9D
        STA     sd
        INY
        LDA     (pls),Y
        ADC     #$02
        STA     sd+1
        JSR     s5
        LDY     #$00
.nbo3
        INY
        INY
        LDA     (bost),Y
        BNE     nbo3
        LDA     sd+1
        STA     (bost),Y
        DEY
        LDA     sd
        STA     (bost),Y
        LDA     inb
        STA     bofg
		
.nbo4
        LDA     #$C0
        ORA     bofg
        STA     bofg
        RTS

.mbo
        LDY     #$00
        LDA     (bost),Y
        STA     no
        LDA     buf+1
        STA     sf
        LDA     bof+1
        STA     sf+1
.ntbo
        INY
        LDA     (bost),Y
        STA     sd
        INY
        LDA     (bost),Y
        STA     sd+1
        BNE     bo1
        LDA     #$7F
        AND     bofg
        STA     bofg
        JMP     bo7

.bo1
        JSR     s5
        LDA     sd
        AND     #$07
        CMP     #$06
        BPL     bo2
        INC     sd
        INC     sd
        LDA     sd+1
        JMP     bo4

.bo2
        CLC
        LDA     sd
        ADC     #$7A
        STA     sd
        LDA     sd+1
        ADC     #$02
        STA     sd+1
		
.bo4
        CMP     #$80
        BMI     bo6
        LDA     #$00
        STA     (bost),Y
        BEQ     bo7

.bo6
        JSR     s5
        DEY
        LDA     sd
        STA     (bost),Y
        INY
        LDA     sd+1
        STA     (bost),Y
		
.bo7
        CPY     no
        BMI     ntbo
        RTS

.ra2
        STA     ra3+1
		
\ .ra2+1
\ .ra2+2
\ .ra2+3
        SEC
        LDA     py
        AND     #$7F
		
.ra3
        SBC     #$10
		
\ .ra3+1
        BPL     ra3
        ADC     ra3+1
        RTS

.L2D0A  \ Unknown - hard-coded in *.BAS
        EQUB    $06,$02,$31,$00,$05,$02,$39,$00
        EQUB    $06

.L2D13  \ Unknown - hard-coded in *.BAS
        EQUB    $1E,$9E,$F0,$35,$9E,$C0,$81,$A8
        EQUB    $3A,$95,$D0,$81,$F8,$3A,$9F,$D0
        EQUB    $81,$48,$3B,$A9,$D0,$81,$98,$3B
        EQUB    $B3,$D0,$81,$E8
        EQUB    $3B,$BD,$D0,$00,$00,$00,$00,$00
        EQUB    $00,$00,$00,$00,$00,$00,$00,$00
        EQUB    $00,$00,$00,$00,$00,$00,$00,$00

.L2D47  \ Bomb slots / stack - hard-coded in *.BAS
        EQUB    $02,$D6,$00,$00,$00,$00,$00,$00
        EQUB    $00,$00,$00,$00,$00,$00,$00,$00
        EQUB    $00,$00,$00,$00,$00,$00,$00,$00

.L2D5F
        EQUB    $80,$40,$40,$00,$80,$00,$40,$80
        EQUB    $00

.bis
        EQUB    $88,$A0,$B8,$D0,$E8,$D0,$B8,$88

.Xg
        EQUB    $20

.inb
        EQUB    $D7

\ .inb+1
        EQUB    $00

.buf
        EQUB    $1A

\ .buf+1
.bof
        EQUB    $50

\ .bof+1
        EQUB    $23

.sc
        EQUB    $00

\ .sc+1
        EQUB    $00

\ .sc+2
        EQUB    $00

.de
        EQUB    $20

\ .de+1
        EQUB    $03

\ .de+2
        EQUB    $42

.ba
        EQUB    $00

\ .ba+1
        EQUB    $00

\ .ba+2
        EQUB    $06

.L2D7F  \ Envelope data
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

.L2DFC  \  Hard-coded in *.BAS
        EQUB    $49,$00

.L2DFE  \ Cloud / Enemy sprites from &2E00  - hard-coded in *.BAS
        EQUB    $0F,$00,$FF,$FF,$FF,$FF,$FF,$FF
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

.L2EC0
        EQUB    $FF,$FF,$FF,$FF,$FF,$FF,$AA,$55
        EQUB    $FF,$FF,$AA,$55,$FF,$55,$FF,$FF
        EQUB    $55,$FF,$FF,$FF,$FF,$FF,$FF,$AA
        EQUB    $FF,$FF,$AA,$AA,$AA,$00,$00,$00

.L2EE0
        EQUB    $FF,$FF,$55,$55,$55,$00,$00,$00
        EQUB    $FF,$FF,$FF,$FF,$FF,$FF,$FF,$00
        EQUB    $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
        EQUB    $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
        EQUB    $00,$05,$00,$00,$00,$00,$05,$00
        EQUB    $00,$0F,$0A,$0A,$0A,$0A,$0F,$00
        EQUB    $00,$0F,$00,$00,$00,$00,$0F,$15
        EQUB    $00,$0F,$05,$15,$0F,$05,$0F,$00
        EQUB    $0A,$0F,$2F,$3F,$2F,$0F,$0F,$0A
        EQUB    $00,$0F,$00,$00,$0A,$00,$0F,$15
        EQUB    $00,$0F,$00,$00,$00,$00,$0F,$00
        EQUB    $00,$0F,$0A,$0A,$0A,$0A,$0F,$00
        EQUB    $00,$04,$00,$00,$00,$00,$00,$00
        EQUB    $00,$0C,$04,$00,$00,$00,$00,$00
        EQUB    $00,$0C,$00,$08,$04,$00,$05,$05
        EQUB    $00,$0D,$15,$04,$04,$08,$00,$00
        EQUB    $08,$2F,$3F,$06,$0C,$08,$00,$00
        EQUB    $00,$0C,$00,$00,$04,$08,$05,$05
        EQUB    $00,$0C,$04,$08,$00,$00,$00,$00
        EQUB    $00,$0C,$00,$00,$00,$00,$00,$00
        EQUB    $00,$00,$00,$14,$14,$00,$00,$00
        EQUB    $00,$00,$00,$00,$28,$3C,$00,$00
        EQUB    $00,$00,$00,$00,$00,$3C,$0A,$00
        EQUB    $28,$14,$00,$00,$14,$29,$14,$00
        EQUB    $00,$3C,$28,$28,$3E,$2B,$16,$28
        EQUB    $28,$00,$00,$00,$00,$3C,$00,$00
        EQUB    $00,$00,$00,$00,$00,$3C,$0A,$00
        EQUB    $00,$00,$00,$14,$3C,$28,$00,$00
        EQUB    $00,$00,$00,$00,$14,$00,$00,$00
        EQUB    $30,$00,$00,$10,$3C,$10,$00,$00
        EQUB    $38,$28,$28,$3E,$14,$3C,$30,$00
        EQUB    $30,$00,$00,$20,$3C,$20,$00,$00
        EQUB    $10,$00,$00,$00,$3C,$00,$00,$00
        EQUB    $30,$00,$00,$34,$3C,$34,$10,$00
        EQUB    $38,$28,$28,$3A,$14,$38,$20,$00
        EQUB    $20,$00,$00,$00,$3C,$00,$00,$3A

.BeebDisEndAddr
SAVE "decryptedtape-asm.bin",BeebDisStartAddr,BeebDisEndAddr

