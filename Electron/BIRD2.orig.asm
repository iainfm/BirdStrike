L0050   = $0050
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
L020C   = $020C
L020D   = $020D
L02FC   = $02FC
L4180   = $4180
L4900   = $4900
sv_ifr  = $FE4D
sv_ier  = $FE4E
osasci  = $FFE3
oswrch  = $FFEE
osword  = $FFF1
osbyte  = $FFF4

        org     $1300
.BeebDisStartAddr
        EQUS    "Thanks David,Ian,Martin,Mum,Dad,Susi D"

.L1326
        LDX     #$2F
        LDY     #$13
        LDA     #$07
        JMP     osword

        EQUB    $01,$00,$00,$00,$00,$00,$01,$00

.L1337
        LDX     #$EF
        JSR     L21DA

        BNE     L1348

        LDA     #$72
        STA     L020C
        LDA     #$13
        STA     L020D
.L1348
        LDX     #$AE
        JSR     L21DA

        BNE     L135B

        LDA     L1379
        STA     L020C
        LDA     L137A
        STA     L020D
.L135B
        LDX     #$CC
        JSR     L21DA

        BNE     L1371

.L1362
        LDA     #$81
        LDY     #$01
        LDX     #$00
        JSR     osbyte

        BCS     L1362

        CPX     #$52
        BEQ     L1362

.L1371
        RTS

        EQUB    $C9,$07,$F0,$FB,$6C,$79,$13

.L1379
        EQUB    $EB

.L137A
        EQUB    $E7

.L137B
        LDA     L13AC
        BEQ     L13A1

        LDA     L0077
        BPL     L1394

        DEC     L007A
        SEC
        LDA     L0078
        SBC     #$08
        STA     L0078
        BCS     L13A1

        DEC     L0079
        JMP     L13A1

.L1394
        INC     L007A
        CLC
        LDA     L0078
        ADC     #$08
        STA     L0078
        BCC     L13A1

        INC     L0079
.L13A1
        LDA     #$01
        EOR     L13AC
        STA     L13AC
        JMP     L2BE1

.L13AC
        EQUB    $00

.L13AD
        LDA     L13BE
        BEQ     L13B6

        DEC     L13BE
        RTS

.L13B6
        LDA     #$12
        STA     L13BE
        JMP     L297D

.L13BE
        EQUB    $00

.L13BF
        PLA
        PLA
        LDY     #$FF
.L13C3
        INY
        LDA     #$0A
        JSR     L208D

        LDA     L13DB,Y
        JSR     oswrch

        CMP     #$52
        BNE     L13C3

        LDA     #$96
        JSR     L208D

        JMP     L1E18

.L13DB
        EQUB    $1F,$05,$0F,$11,$01

        EQUS    "GAME OVER"

.L13E9
        RTS

.L13EA
        LDA     L1D55
        BEQ     L13E9

        LDA     L007A
        EOR     #$80
        STA     L007A
        INC     L0077
        PLA
        PLA
        JMP     L2BE4

.L13FC
        LDA     #$01
        BIT     L142B
        BNE     L1413

        LDY     L2D78
        CPY     #$05
        BMI     L142A

        ORA     L142B
        STA     L142B
        JSR     L142C

.L1413
        LDA     #$02
        BIT     L142B
        BNE     L142A

        LDY     L2D78
        CPY     #$10
        BMI     L142A

        ORA     L142B
        STA     L142B
        JMP     L142C

.L142A
        RTS

.L142B
        EQUB    $00

.L142C
        JSR     L2223

        LDA     #$DC
        STA     L2DFC
        LDX     #$F8
        LDY     #$2D
        LDA     #$07
        JSR     osword

        INC     L1D56
        CLC
        LDA     L1D57
        ADC     #$18
        STA     L1D57
        BCC     L144E

        INC     L1D58
.L144E
        RTS

.L144F
        LDA     L1D5C
        AND     #$03
        BNE     L1461

        LDA     #$0F
        JSR     L208D

        JSR     L1778

        JMP     L1467

.L1461
        JSR     L20B3

        JSR     L21A8

.L1467
        JSR     L14AF

        LDY     #$4B
.L146C
        SED
        CLC
        LDA     L2D77
        ADC     #$02
        STA     L2D77
        LDA     L2D78
        ADC     #$00
        STA     L2D78
        CLD
        LDA     #$02
        JSR     L208D

        TYA
        PHA
        LDX     #$E8
        LDY     #$2D
        LDA     #$07
        JSR     osword

        JSR     L2054

        PLA
        TAY
        DEY
        BNE     L146C

        INC     L14C8
        LDX     #$C8
        LDY     #$14
        LDA     #$07
        JSR     osword

        DEC     L14C8
        LDA     #$80
        ORA     L2D76
        STA     L2D76
        RTS

.L14AF
        LDY     #$00
.L14B1
        LDA     L14BD,Y
        JSR     oswrch

        INY
        CPY     #$0B
        BNE     L14B1

        RTS

.L14BD
        EQUB    $11,$06,$1F,$07,$0F,$42,$4F,$4E
        EQUB    $55,$53,$21

.L14C8
        EQUB    $12,$00,$FF,$FF,$00,$00,$00,$00
        EQUB    $00,$00,$00,$00,$00,$00,$00,$00
        EQUB    $00,$00,$00,$00,$00,$00,$00,$00
        EQUB    $00,$00,$00,$00,$00,$00,$00,$00
        EQUB    $00,$00,$00,$00,$00,$00,$00,$00
        EQUB    $00,$00,$00,$00,$00,$00,$00,$00
        EQUB    $00,$00,$00,$00,$00,$00,$00,$00
        EQUB    $FF,$00,$00,$00,$00,$00,$00,$00
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
        EQUB    $00,$00,$00,$00,$00,$00,$00,$00
        EQUB    $00,$00,$00,$00,$00,$00,$00,$00
        EQUB    $00,$00,$00,$00,$00,$00,$00,$00
        EQUB    $00,$00,$00,$00,$00,$00,$00,$00
        EQUB    $00,$00,$00,$00,$00,$00,$00,$00
        EQUB    $00,$00,$00,$00,$00,$00,$00,$00
        EQUB    $00,$00,$00,$00,$00,$00,$00,$00
        EQUB    $C1,$16,$08,$20,$7F

.L15C5
        EQUB    $00

.L15C6
        EQUB    $00

.L15C7
        EQUB    $02

.L15C8
        EQUB    $16,$01,$17,$01,$00,$00,$00,$00
        EQUB    $00,$00,$00,$00,$0D,$0A,$0A,$0A
        EQUB    $11,$03,$13,$01,$06,$00,$00,$00
        EQUB    $13,$03,$04,$00,$00,$00,$20,$20
        EQUB    $EE,$EB,$F1,$E9,$20,$20,$20,$20
        EQUB    $20,$20,$20,$20,$FF,$20,$20,$EC
        EQUB    $F8,$E7,$F0,$20,$F4,$20,$20,$20
        EQUB    $20,$20,$20,$20,$F8,$0D,$0A,$11
        EQUB    $01,$20,$20,$EF,$F7,$F8,$E2,$20
        EQUB    $E6,$20,$E8,$20,$20,$20,$20,$FF
        EQUB    $20,$20,$EF,$F7,$F2,$E8,$20,$FF
        EQUB    $E6,$20,$E8,$20,$20,$E6,$20,$FF
        EQUB    $EC,$EA,$0D,$0A,$11,$03,$20,$20
        EQUB    $EF,$EB,$ED,$F1,$E9,$FF,$20,$FF
        EQUB    $E7,$E0,$F4,$E7,$FF,$20,$20,$20
        EQUB    $ED,$ED,$FF,$20,$FF,$20,$20,$FF
        EQUB    $E7,$E0,$FF,$20,$FF,$F1,$E8,$20
        EQUB    $F8,$F5,$E9,$0D,$0A,$11,$01,$20
        EQUB    $20,$E4,$F7,$F2,$F8,$E2,$F1,$E8
        EQUB    $FF,$20,$20,$F1,$F6,$EB,$20,$20
        EQUB    $E4,$F6,$F8,$E3,$20,$F1,$F3,$E8
        EQUB    $FF,$20,$20,$F1,$E8,$FF,$20,$E5
        EQUB    $E9,$F0,$F4,$E1,$11,$02,$1F,$06
        EQUB    $0A,$46,$49,$52,$45,$42,$49,$52
        EQUB    $44,$20,$28,$63,$29,$20,$41,$6E
        EQUB    $64,$72,$65,$77,$20,$46,$72,$69
        EQUB    $67,$61,$61,$72,$64,$1F,$0D,$0D
        EQUB    $48,$69,$67,$68,$20,$53,$63,$6F
        EQUB    $72,$65,$11,$01,$00

.L16AD
        EQUB    $1F,$0B,$0F,$2E,$2E,$2E,$2E,$2E
        EQUB    $2E,$2E,$2E,$2E,$2E,$2E,$2E,$2E
        EQUB    $00

.L16BE
        EQUB    $1F,$19,$0F,$61,$6E,$64,$72,$65
        EQUB    $77,$20,$20,$00,$1F,$10,$13,$11
        EQUB    $02,$4B,$65,$79,$73,$1F,$07,$15
        EQUB    $11,$01,$5A,$20,$2E,$2E,$2E,$2E
        EQUB    $2E,$2E,$2E,$2E,$2E,$2E,$2E,$2E
        EQUB    $20,$6D,$6F,$76,$65,$20,$6C,$65
        EQUB    $66,$74,$1F,$07,$16,$58,$20,$2E
        EQUB    $2E,$2E,$2E,$2E,$2E,$2E,$2E,$2E
        EQUB    $2E,$2E,$20,$6D,$6F,$76,$65,$20
        EQUB    $72,$69,$67,$68,$74,$1F,$07,$17
        EQUB    $52,$45,$54,$55,$52,$4E,$20,$2E
        EQUB    $2E,$2E,$2E,$2E,$2E,$2E,$2E,$2E
        EQUB    $2E,$2E,$20,$73,$68,$6F,$6F,$74
        EQUB    $1F,$07,$18,$53,$2F,$51,$20,$2E
        EQUB    $2E,$2E,$2E,$2E,$2E,$2E,$20,$73
        EQUB    $6F,$75,$6E,$64,$20,$6F,$6E,$2F
        EQUB    $6F,$66,$66,$1F,$07,$19,$52,$20
        EQUB    $2E,$2E,$2E,$2E,$2E,$2E,$2E,$2E
        EQUB    $2E,$2E,$2E,$2E,$2E,$2E,$2E,$2E
        EQUB    $2E,$20,$72,$65,$73,$74,$00,$1F
        EQUB    $09,$1D,$11,$02,$50,$72,$65,$73
        EQUB    $73,$20,$73,$70,$61,$63,$65,$20
        EQUB    $74,$6F,$20,$70,$6C,$61,$79,$2E
        EQUB    $00,$00

.L1778
        LDY     #$0A
.L177A
        LDA     L180E,Y
        JSR     oswrch

        DEY
        BPL     L177A

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

        JSR     L21EE

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
        JSR     L20B3

        STX     L2382
        INC     L1D5C
.L17EC
        JSR     L20E0

        BNE     L17EC

        JSR     L20B3

        JSR     L21A8

        LDA     #$3C
        JSR     L208D

        LDA     L1D5C
        CMP     #$04
        BNE     L17D1

        LDA     L1A08
        STA     L1D5C
        LDA     #$1A
        JMP     oswrch

.L180E
        EQUB    $10,$03,$FF,$04,$0F,$02,$0F,$00
        EQUB    $F0,$18,$1A

.L1819
        LDA     #$00
        STA     L15C5
        LDA     L2D78
        CMP     L15C7
        BCC     L183F

        BNE     L1830

        LDA     L2D77
        CMP     L15C6
        BCC     L183F

.L1830
        LDA     L2D77
        STA     L15C6
        LDA     L2D78
        STA     L15C7
        DEC     L15C5
.L183F
        LDY     #$00
.L1841
        LDA     L15C8,Y
        JSR     oswrch

        INY
        CPY     #$E5
        BNE     L1841

        LDA     #$1F
        JSR     oswrch

        LDA     #$05
        JSR     oswrch

        LDA     #$0F
        JSR     oswrch

        LDA     L15C7
        JSR     L18D3

        LDA     L15C6
        JSR     L18D3

        LDA     #$30
        JSR     oswrch

        LDX     #$AD
        LDY     #$16
        JSR     L18E7

        LDX     #$CA
        LDY     #$16
        JSR     L18E7

        LDA     #$1F
        JSR     oswrch

        LDA     #$1A
        JSR     oswrch

        LDA     #$0F
        JSR     oswrch

        LDA     L15C5
        BEQ     L18A0

        LDA     #$15
        LDX     #$00
        JSR     osbyte

        TXA
        LDX     #$C0
        LDY     #$15
        JSR     osword

        JMP     L18AD

.L18A0
        LDY     #$FF
.L18A2
        INY
        LDA     L16BE,Y
        JSR     osasci

        CMP     #$0E
        BPL     L18A2

.L18AD
        LDY     #$02
.L18AF
        LDA     L15C8,Y
        JSR     oswrch

        INY
        CPY     #$0D
        BNE     L18AF

        LDA     #$32
        JSR     L208D

.L18BF
        LDA     #$1A
        JSR     oswrch

        LDX     #$5D
        LDY     #$17
        JSR     L18E7

.L18CB
        LDX     #$9D
        JSR     L21DA

        BNE     L18CB

        RTS

.L18D3
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

.L18E7
        STX     L18F1
        STY     L18F2
        LDY     #$FF
.L18EF
        INY
.L18F0
        LDA     L16AD,Y
L18F1 = L18F0+1
L18F2 = L18F0+2
        JSR     oswrch

        CMP     #$00
        BNE     L18EF

        RTS

        EQUB    $00,$00,$00,$00,$00,$00,$00,$00
        EQUB    $00,$00,$00,$15,$08,$00,$80,$00
        EQUB    $00,$05,$00,$00,$00,$00,$08,$08
        EQUB    $1C,$08,$08,$08,$00,$28,$28,$28
        EQUB    $3E,$28,$28,$00,$00,$00,$08,$08
        EQUB    $08,$08,$08,$08,$00,$00,$10,$10
        EQUB    $35,$35,$10,$10,$00,$30,$30,$3F
        EQUB    $03,$03,$3F,$30,$30,$00,$20,$20
        EQUB    $3A,$3A,$20,$20,$00,$00,$00,$00
        EQUB    $05,$00,$00,$00,$00,$00,$00,$00
        EQUB    $00,$00,$00,$00,$00,$00,$00,$00
        EQUB    $00,$2A,$00,$00,$00,$00,$00,$0A
        EQUB    $02,$15,$0A,$00,$00,$00,$00,$2A
        EQUB    $15,$00,$2A,$00,$00,$00,$00,$0A
        EQUB    $00,$02,$0A,$00,$00,$00,$00,$00
        EQUB    $2A,$00,$00,$00,$00,$00,$00,$00
        EQUB    $00,$05,$00,$00,$00,$00,$00,$00
        EQUB    $00,$00,$00,$00,$00,$1A,$05,$00
        EQUB    $C0,$05,$0A,$30,$05,$40,$00,$4A
        EQUB    $15,$00,$2A,$0F,$10,$00,$4A,$15
        EQUB    $00,$00,$48,$80,$20,$0A,$4A,$10
        EQUB    $00,$00,$40,$2A,$0A,$10,$0A,$40
        EQUB    $15,$00,$2A,$85,$30,$80,$25,$0A
        EQUB    $40,$25,$90,$1A,$05,$0A,$00,$20
        EQUB    $40,$00,$0A,$00,$00,$00,$05,$00
        EQUB    $00,$00,$00,$00,$00,$00,$00,$00
        EQUB    $80,$00,$00,$08,$00,$00,$00,$00
        EQUB    $00,$00,$00,$00,$00,$0A,$00,$00
        EQUB    $00,$00,$00,$00,$40,$00,$00,$00
        EQUB    $00,$05,$00,$00,$00,$08,$00,$00
        EQUB    $00,$00,$00,$00,$00,$00,$00,$00
        EQUB    $00,$00,$00,$15,$08,$00,$80,$00
        EQUB    $00,$05,$00,$00,$00,$2A,$2A,$2A
        EQUB    $2A,$2A,$2A,$2A,$2A

.L1A08
        EQUB    $FF

.L1A09
        EQUB    $FF

.L1A0A
        EQUB    $FF

.L1A0B
        EQUB    $FF

.L1A0C
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

.L1A60
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
        EQUB    $28,$3C,$34,$3C

        EQUB    $39,$00,$00,$00,$00,$00,$3C,$2D
        EQUB    $22,$00,$00,$00,$30,$24,$10,$13
        EQUB    $16,$19,$1C,$34,$41,$1F,$48,$48
        EQUB    $48,$48,$48,$48,$48,$4C,$44,$41
        EQUB    $53,$54,$41,$4A,$53,$52,$52,$54
        EQUB    $53,$42,$4E,$45,$50,$2E,$7E,$21
        EQUB    $26,$16,$34,$13,$31,$32,$30,$30
        EQUB    $30,$4C,$2E,$0E,$0D,$52,$55,$4E
        EQUB    $0D,$16,$32,$17,$00,$0C,$00,$00
        EQUB    $00,$00,$00,$00,$00,$00,$43,$41
        EQUB    $4C,$4C,$51,$25,$0D,$00,$00,$14
        EQUB    $3C,$00,$00,$00,$00,$00,$00,$3C
        EQUB    $3C,$34,$3C,$28,$00,$00,$3C,$2D
        EQUB    $22,$00,$00,$00,$00,$00,$00,$14
        EQUB    $3C,$00,$14,$00,$00,$00,$00,$00
        EQUB    $00,$00,$00,$00,$00,$00,$00,$00
        EQUB    $14,$00,$00,$00,$00,$05,$00,$28
        EQUB    $00,$01,$00,$14,$00,$00,$00,$28
        EQUB    $14,$00,$00,$00,$00,$00,$3C,$1E
        EQUB    $01,$00,$00,$00,$00,$00,$00,$3C
        EQUB    $3C,$38,$3C,$14,$00,$00,$00,$28
        EQUB    $3C,$00,$00,$00,$00,$00,$3C,$1E
        EQUB    $01,$00,$00,$00,$00,$00,$00,$3C
        EQUB    $3C,$38,$14,$00,$00,$00,$00,$28
        EQUB    $3C,$00,$28,$00,$00,$00,$3C,$1E
        EQUB    $01,$00,$00,$00,$00,$00,$00,$3C
        EQUB    $16,$00,$00,$00,$00,$00,$00,$28
        EQUB    $3C,$00,$00,$00,$00,$00,$3C,$1E
        EQUB    $01,$00,$00,$00,$00,$3C,$38,$3C
        EQUB    $16,$00,$00,$00,$00,$00,$00,$00
        EQUB    $28,$3C,$00,$00,$00,$00,$3C,$1E
        EQUB    $01,$00,$00,$00,$14,$3C,$38,$3C
        EQUB    $16,$00,$00,$00,$28,$00,$00,$00
        EQUB    $28,$3C,$00,$00,$3C,$38,$38,$38
        EQUB    $38,$38,$3C,$10,$38,$38,$38,$38
        EQUB    $38,$38,$38,$30,$14,$3C,$34,$14
        EQUB    $14,$14,$3C,$10,$20,$20,$20,$20
        EQUB    $20,$20,$38,$30,$3C,$30,$00,$3C
        EQUB    $38,$28,$3C,$10,$38,$38,$38,$38
        EQUB    $30,$00,$28,$30,$3C,$30,$00,$3C
        EQUB    $30,$00,$3C,$10,$38,$38,$38,$38
        EQUB    $38,$38,$38,$30,$38,$38,$38,$3C
        EQUB    $10,$00,$00,$00,$38,$38,$38,$38
        EQUB    $38,$38,$38,$30,$3C,$38,$28,$3C
        EQUB    $10,$00,$3C,$10,$38,$30,$00,$38
        EQUB    $38,$38,$38,$30,$3C,$38,$28,$3C
        EQUB    $38,$28,$3C,$10,$38,$30,$00,$28
        EQUB    $38,$38,$38,$30,$3C,$30,$00,$14
        EQUB    $14,$14,$14,$10,$38,$38,$38,$30
        EQUB    $20,$20,$20,$20,$3C,$38,$28,$3C
        EQUB    $38,$28,$3C,$10,$38,$38,$38,$38
        EQUB    $38,$38,$38,$30,$3C,$38,$28,$3C
        EQUB    $10,$00,$3C,$10,$38,$38,$38,$38
        EQUB    $38,$38,$38,$30,$00,$00,$00,$00
        EQUB    $00,$00,$00,$00,$00,$00,$04,$00
        EQUB    $0C,$00,$04,$0C,$08,$08,$06,$08
        EQUB    $06,$0C,$06,$06,$00,$00,$00,$00
        EQUB    $08,$00,$00,$08,$00,$04,$08,$04
        EQUB    $00,$00,$08,$04,$0C,$04,$08,$0C
        EQUB    $02,$04,$0C,$08,$06,$0C,$06,$08
        EQUB    $06,$06,$0C,$06,$08,$04,$08,$0C
        EQUB    $00,$08,$04,$08,$00,$04,$00,$00
        EQUB    $00,$00,$08,$04,$08,$09,$04,$00
        EQUB    $00,$08,$08,$0C,$02,$0C,$02,$02
        EQUB    $02,$02,$02,$07,$08,$04,$00,$00
        EQUB    $04,$04,$01,$09,$15,$01,$09,$06
        EQUB    $09,$06,$09,$06,$00,$00,$09,$06
        EQUB    $09,$06,$09,$06,$00,$00,$09,$06
        EQUB    $09,$06,$09,$06,$00,$00,$09,$06
        EQUB    $09,$06,$09,$06,$00,$00,$00,$07
        EQUB    $08,$06,$09,$06,$00,$00,$00,$0F
        EQUB    $20,$0F,$08,$02,$00,$00,$00,$05
        EQUB    $00,$0E,$01,$0E,$00,$00,$01,$0E
        EQUB    $09,$06,$09,$06

.L1D40
        EQUB    $31,$7A,$D9,$7C,$C9,$77,$12,$7A
        EQUB    $C8,$7C,$BA,$77,$51,$7A,$B8,$7C
        EQUB    $20,$7A,$42,$7A

.L1D54
        EQUB    $00

.L1D55
        EQUB    $00

.L1D56
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

.L1D5C
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

.L1E00
        LDA     #$C8
        LDX     #$03
        LDY     #$00
        JSR     osbyte

        JSR     L18BF

        LDA     L020C
        STA     L1379
        LDA     L020D
        STA     L137A
.L1E18
        JSR     L1819

        JSR     L1E5F

.L1E1E
        JSR     L25B8

        LDA     #$13
        JSR     osbyte

        JSR     L2A94

        JSR     L2A94

        JSR     L29F7

        JSR     L286E

        JSR     L28E2

        JSR     L295E

        JSR     L2C98

        JSR     L2C45

        JSR     L240E

        JSR     L2238

        JSR     L1FE1

        JSR     L1337

        JMP     L1E1E

        EQUS    "G (c)Frigaard 1984"

.L1E5F
        LDA     #$05
        STA     L0070
        JSR     L2835

        LDA     #$49
        JSR     L21A8

        LDA     #$16
        JSR     oswrch

        LDA     #$02
        JSR     oswrch

        LDA     #$00
        STA     L142B
        STA     L008E
        STA     L1D5C
        STA     L1D54
        STA     L1D55
        STA     L2D77
        STA     L2D78
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
.L1EB9
        JSR     L281D

        DEX
        CPX     #$07
        BNE     L1EB9

        STX     L007D
        LDA     #$03
        STA     L1D56
        LDA     #$2F
        STA     L0089
        LDA     #$E8
        STA     L2D71
        LDA     #$04
        STA     L1A09
.L1ED6
        JSR     L20B3

        STX     L2382
        INC     L1D5C
        LDA     L2D79
        CMP     #$0A
        BMI     L1EF6

        LDA     L1D5C
        AND     #$01
        BEQ     L1EF6

        DEC     L2D79
        DEC     L2D79
        DEC     L2D71
.L1EF6
        INC     L1A09
        INC     L1A09
        LDA     #$0C
        JSR     oswrch

        LDA     #$9A
        LDX     #$14
        JSR     osbyte

        JSR     L261A

        JSR     L25C9

        JSR     L21EE

        JSR     L2054

        LDA     #$00
        STA     L1D5B
        STA     L2D76
        STA     L2D7D
        LDY     #$54
.L1F21
        STA     L2D0A,Y
        DEY
        BNE     L1F21

        LDY     #$02
.L1F29
        LDA     L15C8,Y
        JSR     oswrch

        INY
        CPY     #$0D
        BNE     L1F29

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
        JMP     L21A8

.L1FE0
        RTS

.L1FE1
        LDA     L2D76
        BEQ     L1FE0

        SED
        AND     #$02
        BEQ     L1FFF

        CLC
        LDA     #$15
        ADC     L2D77
        STA     L2D77
        LDA     L2D78
        ADC     #$00
        STA     L2D78
        JSR     L258D

.L1FFF
        LDA     #$40
        BIT     L2D76
        BEQ     L2022

        CLC
        LDA     #$01
        ADC     L2D77
        STA     L2D77
        LDA     L2D78
        ADC     #$00
        STA     L2D78
        CLD
        LDX     #$C8
        LDY     #$14
        LDA     #$07
        JSR     osword

        SED
.L2022
        LDA     #$10
        BIT     L2D76
        BEQ     L2043

        CLC
        LDA     #$0A
        ADC     L2D77
        STA     L2D77
        LDA     L2D78
        ADC     #$00
        STA     L2D78
        CLD
        JSR     L20E0

        BNE     L2043

        JSR     L144F

.L2043
        CLD
        JSR     L13FC

        LDA     L2D76
        BPL     L204F

        JMP     L209F

.L204F
        LDA     #$00
        STA     L2D76
.L2054
        LDA     #$34
        STA     L0081
        LDA     #$B0
        STA     L0080
        LDA     #$1C
        STA     L0083
        LDA     #$F0
        AND     L2D78
        JSR     L285A

        LDA     #$0F
        AND     L2D78
        ASL     A
        ASL     A
        ASL     A
        ASL     A
        JSR     L285A

        LDA     #$F0
        AND     L2D77
        JSR     L285A

        LDA     #$0F
        AND     L2D77
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
        LDA     #$13
        JSR     osbyte

        DEC     L1A0A
        BNE     L2092

        PLA
        TAY
        RTS

.L209F
        LDA     #$00
        STA     L2D76
        CLC
        LDA     L0088
        ADC     #$40
        STA     L0088
        LDA     #$64
        JSR     L208D

        JMP     L1ED6

.L20B3
        LDA     #$03
        AND     L1D5C
        TAX
        BNE     L20BE

        LDA     #$33
        RTS

.L20BE
        DEX
        BNE     L20C5

        TXA
        LDX     #$0D
        RTS

.L20C5
        DEX
        BNE     L20CD

        LDA     #$11
        LDX     #$1A
        RTS

.L20CD
        LDA     #$22
        LDX     #$26
        RTS

.L20D2
        LDA     L007D
        BPL     L20DC

        LDA     L0080
        EOR     #$C0
        STA     L0080
.L20DC
        LDA     L2D79
        RTS

.L20E0
        INC     L2382
        LDY     L2382
        LDA     L2382,Y
        STA     L0070
        AND     #$0E
        CMP     #$08
        BPL     L20FB

        CLC
        ADC     L1D59
        STA     L0080
        LDA     #$00
        BEQ     L2105

.L20FB
        CLC
        ADC     L1D59
        ADC     #$78
        STA     L0080
        LDA     #$02
.L2105
        ADC     L1D5A
        STA     L0081
        LDA     #$23
        STA     L0083
        JSR     L2140

        CLC
        LDA     L1D59
        ADC     #$20
        STA     L1D59
        BCC     L211F

        INC     L1D5A
.L211F
        JSR     L2174

        CLC
        LDA     L0080
        ADC     #$08
        STA     L0080
        BCC     L212D

        INC     L0081
.L212D
        CLC
        LDA     L0082
        ADC     #$08
        STA     L0082
        BCC     L2138

        INC     L0083
.L2138
        JSR     L2174

        INY
        LDA     L2382,Y
        RTS

.L2140
        LDA     #$80
        BIT     L0070
        BEQ     L214B

        LDA     #$00
        STA     L0082
        RTS

.L214B
        LSR     A
        BIT     L0070
        BEQ     L2155

        LDA     #$10
        STA     L0082
        RTS

.L2155
        LSR     A
        BIT     L0070
        BEQ     L215F

        LDA     #$20
        STA     L0082
        RTS

.L215F
        LSR     A
        BIT     L0070
        BEQ     L2169

        LDA     #$30
        STA     L0082
        RTS

.L2169
        LDA     #$01
        BIT     L0070
        BEQ     L2173

        LDA     #$40
        STA     L0082
.L2173
        RTS

.L2174
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
        BPL     L219C

.L2191
        LDA     (L0082),Y
        ORA     (L0084),Y
        STA     (L0084),Y
        DEY
        CPY     L0074
        BNE     L2191

.L219C
        LDA     (L0082),Y
        ORA     (L0080),Y
        STA     (L0080),Y
        DEY
        BPL     L219C

        PLA
        TAY
        RTS

.L21A8
        STA     L0070
.L21AA
        LDY     L0070
        LDA     L23B2,Y
        BEQ     L21CE

        STA     L2DFC
        INY
        LDA     L23B2,Y
        STA     L2DFE
        LDX     #$F8
        LDY     #$2D
        LDA     #$07
        JSR     osword

        INC     L0070
        INC     L0070
        JSR     L1326

        JMP     L21AA

.L21CE
        LDA     #$80
        LDX     #$FA
        JSR     osbyte

        CPX     #$0F
        BMI     L21CE

        RTS

.L21DA
        LDA     #$81
        LDY     #$FF
        JSR     osbyte

        INX
        RTS

        EQUB    $00,$00,$00,$00,$00,$00,$00,$00
        EQUB    $00,$00,$00

.L21EE
        LDY     #$00
.L21F0
        LDA     L220E,Y
        JSR     oswrch

        INY
        CPY     #$09
        BNE     L21F0

        LDX     #$05
.L21FD
        LDY     #$09
.L21FF
        LDA     L220E,Y
        JSR     oswrch

        INY
        CPY     #$15
        BNE     L21FF

        DEX
        BNE     L21FD

        RTS

.L220E
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

.L2238
        LDA     #$20
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
        JSR     osword

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

        JMP     L13BF

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

.L2382
        EQUB    $0D,$4A,$18,$8C,$8E,$1C,$8A,$84
        EQUB    $14,$82,$20,$44,$05,$00,$48,$18
        EQUB    $86,$84,$14,$86,$84,$14,$88,$2A
        EQUB    $4E,$05,$00,$4A,$18,$8C,$8E,$1C
        EQUB    $8A,$84,$14,$82,$20,$44,$00,$44
        EQUB    $42,$42,$44,$46,$24,$14,$05,$00

.L23B2
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
        JSR     osword

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
        JSR     osword

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
        JSR     osword

        DEC     L0070
        BNE     L2835

        RTS

.L284A
        LDA     #$02
        STA     sv_ier
.L284F
        BIT     sv_ifr
        BEQ     L284F

        LDA     #$82
        STA     sv_ier
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

        EQUB    $00

.L286E
        RTS

        EQUB    $D3,$28

.L2871
        LDA     #$81
        LDY     #$FF
        LDX     #$BD
        JSR     osbyte

        INX
        BEQ     L289E

        DEY
        LDX     #$9E
        JSR     osbyte

        INX
        BNE     L28B4

        LDX     L2D70
        CPX     #$01
        BEQ     L28B4

        DEX
        STX     L2D70
        SEC
        LDA     L0086
        SBC     #$08
        STA     L0086
        BCS     L28B4

        DEC     L0087
        BCC     L28B4

.L289E
        LDX     L2D70
        CPX     #$47
        BEQ     L28B4

        INX
        STX     L2D70
        CLC
        LDA     L0086
        ADC     #$08
        STA     L0086
        BCC     L28B4

        INC     L0087
.L28B4
        SEC
        LDA     #$00
        STA     L0078
        LDY     #$24
.L28BB
        LDA     (L0086),Y
        BEQ     L28C1

        STA     L0078
.L28C1
        TYA
        SBC     #$08
        TAY
        BPL     L28BB

        LDA     L0078
        BEQ     L28D3

        LDA     L2D76
        ORA     #$20
        STA     L2D76
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
        SBC     L0050
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

        EQUB    $01

.L2960
        BIT     L0071
        BNE     L2976

        LDA     #$81
        LDY     #$FF
        LDX     #$B6
        JSR     osbyte

        INX
        BEQ     L2977

        LDA     #$00
        STA     L13BE
        RTS

.L2976
        RTS

.L2977
        JMP     L13AD

        EQUB    $71,$D0,$F9

.L297D
        LDY     #$FF
.L297F
        INY
        INY
        INY
        INY
        LDA     (L008A),Y
        BNE     L297F

        DEY
        DEY
        LDA     #$9D
        STA     (L008A),Y
        INY
        SEC
        LDA     L0086
        SBC     #$6E
        STA     (L008A),Y
        STA     L0080
        INY
        LDA     L0087
        SBC     #$02
        STA     (L008A),Y
        STA     L0081
        INY
        LDA     L2D70
        CLC
        ADC     #$03
        STA     (L008A),Y
        JSR     L29C3

        LDA     #$03
        ORA     L0071
        STA     L0071
        LDA     #$01
        ORA     L2D76
        STA     L2D76
        LDA     #$07
        LDY     #$2D
        LDX     #$D0
        JMP     osword

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

        EQUB    $72

.L29F9
        CMP     #$01
        BPL     L2A37

        DEC     L2D7A
        BNE     L2A37

        LDA     L2D7B
        STA     L2D7A
        LDA     L0070
        JSR     L2CFA

        TAY
        SEC
.L2A0F
        SBC     #$05
        BPL     L2A0F

        TAX
.L2A14
        INY
        INX
        BNE     L2A14

        DEY
        LDA     (L0075),Y
        BMI     L2A33

        LDY     L0070
.L2A1F
        DEY
        LDA     (L0075),Y
        BMI     L2A33

        DEY
        DEY
        DEY
        DEY
        BNE     L2A1F

        LDA     #$80
        ORA     L2D76
        STA     L2D76
        RTS

.L2A33
        EOR     #$80
        STA     (L0075),Y
.L2A37
        RTS

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
        JSR     osword

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
        JSR     L13EA

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

        JSR     L20D2

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
        JMP     L137B

.L2BC0
        BCC     L2BD1

        DEC     L007A
        LDA     L0078
        SBC     #$08
        STA     L0078
        BCS     L2BE1

        DEC     L0079
        JMP     L2BE1

.L2BD1
        INC     L007A
        ROL     A
        BCC     L2BE1

        CLC
        LDA     L0078
        ADC     #$08
        STA     L0078
        BCC     L2BE1

        INC     L0079
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

.L2C08
        TYA
        PHA
        CLC
        LDA     L0078
        ADC     #$78
        STA     L0084
        AND     #$07
        EOR     #$07
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
        STA     (L0084),Y
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

        EQUB    $C0

.L2C47
        BIT     L0073
        BNE     L2C91

        DEC     L0073
        BNE     L2C91

        LDY     #$FF
.L2C51
        INY
        INY
        INY
        INY
        INY
        LDA     (L0075),Y
        BMI     L2C51

        DEY
        DEY
        DEY
        LDA     (L0075),Y
        AND     #$C0
        BNE     L2C69

        INY
        INY
        INY
        JMP     L2C51

.L2C69
        INY
        CLC
        LDA     (L0075),Y
        ADC     #$9D
        STA     L0080
        INY
        LDA     (L0075),Y
        ADC     #$02
        STA     L0081
        JSR     L29C3

        LDY     #$00
.L2C7D
        INY
        INY
        LDA     (L008C),Y
        BNE     L2C7D

        LDA     L0081
        STA     (L008C),Y
        DEY
        LDA     L0080
        STA     (L008C),Y
        LDA     L2D71
        STA     L0073
.L2C91
        LDA     #$C0
        ORA     L0073
        STA     L0073
        RTS

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

.L2CFA
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

.L2D70
        EQUB    $20

.L2D71
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
        EQUB    $00

.L2D77
        EQUB    $00

.L2D78
        EQUB    $00

.L2D79
        EQUB    $20

.L2D7A
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
        EQUB    $00,$01,$81,$FD,$00,$00,$1A,$00
        EQUB    $00,$3C,$06,$CE,$CE,$3B,$7E,$00
        EQUB    $00,$02,$83,$00,$00,$00,$00,$00
        EQUB    $00,$7F,$FF,$FE,$FF,$7E,$78,$00
        EQUB    $00,$03,$86,$FF,$00,$01,$02,$01
        EQUB    $01,$7F,$FF,$FD,$FD,$7E,$78,$00
        EQUB    $00,$04,$81,$F0,$FA,$FC,$10,$0A
        EQUB    $0F,$7F,$FE,$E2,$9C,$7E,$00,$00
        EQUB    $00,$05,$0A,$00,$00,$00,$01,$0C
        EQUB    $00,$7F,$F5,$00,$E2,$7E,$00,$00
        EQUB    $00,$12,$00,$04,$00,$78,$00,$06
        EQUB    $00,$10,$00,$F1,$FF,$06,$00,$10
        EQUB    $00,$10,$00,$F1,$FF,$06,$00,$10
        EQUB    $00,$13,$00,$01,$00,$B4,$00,$06
        EQUB    $00,$13,$00,$01,$00,$FA,$00,$05
        EQUB    $00,$01,$00,$F1,$FF

.L2DFC
        EQUB    $49,$00

.L2DFE
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
        EQUB    $20,$00,$00,$00,$3C,$00,$00,$00

.BeebDisEndAddr
SAVE "BIRD2.orig.bin",BeebDisStartAddr,BeebDisEndAddr


; 1300 54 68 61 6E 6B 73 20 44 61 76 69 64 2C 49 61 6E Thanks David,Ian DDDDDDDDDDDDDDDD
; 1310 2C 4D 61 72 74 69 6E 2C 4D 75 6D 2C 44 61 64 2C ,Martin,Mum,Dad, DDDDDDDDDDDDDDDD
; 1320 53 75 73 69 20 44 A2 2F A0 13 A9 07 4C F1 FF 01 Susi D-/----L--- DDDDDDOOOOOOOOOD
; 1330 00 00 00 00 00 01 00 A2 EF 20 DA 21 D0 0A A9 72 --------- -!---r DDDDDDDOOOOOOOOO
; 1340 8D 0C 02 A9 13 8D 0D 02 A2 AE 20 DA 21 D0 0C AD ---------- -!--- OOOOOOOOOOOOOOOO
; 1350 79 13 8D 0C 02 AD 7A 13 8D 0D 02 A2 CC 20 DA 21 y-----z------ -! OOOOOOOOOOOOOOOO
; 1360 D0 0F A9 81 A0 01 A2 00 20 F4 FF B0 F5 E0 52 F0 -------- -----R- OOOOOOOOOOOOOOOO
; 1370 F1 60 C9 07 F0 FB 6C 79 13 EB E7 AD AC 13 F0 21 -`----ly-------! OODDDDDDDDDOOOOO
; 1380 A5 77 10 10 C6 7A 38 A5 78 E9 08 85 78 B0 12 C6 -w---z8-x---x--- OOOOOOOOOOOOOOOO
; 1390 79 4C A1 13 E6 7A 18 A5 78 69 08 85 78 90 02 E6 yL---z--xi--x--- OOOOOOOOOOOOOOOO
; 13A0 79 A9 01 4D AC 13 8D AC 13 4C E1 2B 00 AD BE 13 y--M-----L-+---- OOOOOOOOOOOODOOO
; 13B0 F0 04 CE BE 13 60 A9 12 8D BE 13 4C 7D 29 00 68 -----`-----L})-h OOOOOOOOOOOOOODO
; 13C0 68 A0 FF C8 A9 0A 20 8D 20 B9 DB 13 20 EE FF C9 h----- - --- --- OOOOOOOOOOOOOOOO
; 13D0 52 D0 F0 A9 96 20 8D 20 4C 18 1E 1F 05 0F 11 01 R---- - L------- OOOOOOOOOOODDDDD
; 13E0 47 41 4D 45 20 4F 56 45 52 60 AD 55 1D F0 FA A5 GAME OVER`-U---- DDDDDDDDDOOOOOOO
; 13F0 7A 49 80 85 7A E6 77 68 68 4C E4 2B A9 01 2C 2B zI--z-whhL-+--,+ OOOOOOOOOOOOOOOO
; 1400 14 D0 10 AC 78 2D C0 05 30 20 0D 2B 14 8D 2B 14 ----x---0 -+--+- OOOOOOOOOOOOOOOO
; 1410 20 2C 14 A9 02 2C 2B 14 D0 10 AC 78 2D C0 10 30  ,---,+----x---0 OOOOOOOOOOOOOOOO
; 1420 09 0D 2B 14 8D 2B 14 4C 2C 14 60 00 20 23 22 A9 --+--+-L,-`- #"- OOOOOOOOOOODOOOO
; 1430 DC 8D FC 2D A2 F8 A0 2D A9 07 20 F1 FF EE 56 1D ---------- ---V- OOOOOOOOOOOOOOOO
; 1440 18 AD 57 1D 69 18 8D 57 1D 90 03 EE 58 1D 60 AD --W-i--W----X-`- OOOOOOOOOOOOOOOO
; 1450 5C 1D 29 03 D0 0B A9 0F 20 8D 20 20 78 17 4C 67 \-)----- -  x-Lg OOOOOOOOOOOOOOOO
; 1460 14 20 B3 20 20 A8 21 20 AF 14 A0 4B F8 18 AD 77 - -  -! ---K---w OOOOOOOOOOOOOOOO
; 1470 2D 69 02 8D 77 2D AD 78 2D 69 00 8D 78 2D D8 A9 -i--w--x-i--x--- OOOOOOOOOOOOOOOO
; 1480 02 20 8D 20 98 48 A2 E8 A0 2D A9 07 20 F1 FF 20 - - -H------ --  OOOOOOOOOOOOOOOO
; 1490 54 20 68 A8 88 D0 D5 EE C8 14 A2 C8 A0 14 A9 07 T h------------- OOOOOOOOOOOOOOOO
; 14A0 20 F1 FF CE C8 14 A9 80 0D 76 2D 8D 76 2D 60 A0  --------v--v-`- OOOOOOOOOOOOOOOO
; 14B0 00 B9 BD 14 20 EE FF C8 C0 0B D0 F5 60 11 06 1F ---- -------`--- OOOOOOOOOOOOODDD
; 14C0 07 0F 42 4F 4E 55 53 21 12 00 FF FF 00 00 00 00 --BONUS!-------- DDDDDDDDDDDDDDDD
; 14D0 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ---------------- DDDDDDDDDDDDDDDD
; 14E0 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ---------------- DDDDDDDDDDDDDDDD
; 14F0 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ---------------- DDDDDDDDDDDDDDDD
; 1500 FF 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ---------------- DDDDDDDDDDDDDDDD
; 1510 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ---------------- DDDDDDDDDDDDDDDD
; 1520 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ---------------- DDDDDDDDDDDDDDDD
; 1530 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ---------------- DDDDDDDDDDDDDDDD
; 1540 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ---------------- DDDDDDDDDDDDDDDD
; 1550 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ---------------- DDDDDDDDDDDDDDDD
; 1560 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ---------------- DDDDDDDDDDDDDDDD
; 1570 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ---------------- DDDDDDDDDDDDDDDD
; 1580 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ---------------- DDDDDDDDDDDDDDDD
; 1590 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ---------------- DDDDDDDDDDDDDDDD
; 15A0 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ---------------- DDDDDDDDDDDDDDDD
; 15B0 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ---------------- DDDDDDDDDDDDDDDD
; 15C0 C1 16 08 20 7F 00 00 02 16 01 17 01 00 00 00 00 --- ------------ DDDDDDDDDDDDDDDD
; 15D0 00 00 00 00 0D 0A 0A 0A 11 03 13 01 06 00 00 00 ---------------- DDDDDDDDDDDDDDDD
; 15E0 13 03 04 00 00 00 20 20 EE EB F1 E9 20 20 20 20 ------  ----     DDDDDDDDDDDDDDDD
; 15F0 20 20 20 20 FF 20 20 EC F8 E7 F0 20 F4 20 20 20     -  ---- -    DDDDDDDDDDDDDDDD
; 1600 20 20 20 20 F8 0D 0A 11 01 20 20 EF F7 F8 E2 20     -----  ----  DDDDDDDDDDDDDDDD
; 1610 E6 20 E8 20 20 20 20 FF 20 20 EF F7 F2 E8 20 FF - -    -  ---- - DDDDDDDDDDDDDDDD
; 1620 E6 20 E8 20 20 E6 20 FF EC EA 0D 0A 11 03 20 20 - -  - -------   DDDDDDDDDDDDDDDD
; 1630 EF EB ED F1 E9 FF 20 FF E7 E0 F4 E7 FF 20 20 20 ------ ------    DDDDDDDDDDDDDDDD
; 1640 ED ED FF 20 FF 20 20 FF E7 E0 FF 20 FF F1 E8 20 --- -  ---- ---  DDDDDDDDDDDDDDDD
; 1650 F8 F5 E9 0D 0A 11 01 20 20 E4 F7 F2 F8 E2 F1 E8 -------  ------- DDDDDDDDDDDDDDDD
; 1660 FF 20 20 F1 F6 EB 20 20 E4 F6 F8 E3 20 F1 F3 E8 -  ---  ---- --- DDDDDDDDDDDDDDDD
; 1670 FF 20 20 F1 E8 FF 20 E5 E9 F0 F4 E1 11 02 1F 06 -  --- --------- DDDDDDDDDDDDDDDD
; 1680 0A 46 49 52 45 42 49 52 44 20 28 63 29 20 41 6E -FIREBIRD (c) An DDDDDDDDDDDDDDDD
; 1690 64 72 65 77 20 46 72 69 67 61 61 72 64 1F 0D 0D drew Frigaard--- DDDDDDDDDDDDDDDD
; 16A0 48 69 67 68 20 53 63 6F 72 65 11 01 00 1F 0B 0F High Score------ DDDDDDDDDDDDDDDD
; 16B0 2E 2E 2E 2E 2E 2E 2E 2E 2E 2E 2E 2E 2E 00 1F 19 .............--- DDDDDDDDDDDDDDDD
; 16C0 0F 61 6E 64 72 65 77 20 20 00 1F 10 13 11 02 4B -andrew  ------K DDDDDDDDDDDDDDDD
; 16D0 65 79 73 1F 07 15 11 01 5A 20 2E 2E 2E 2E 2E 2E eys-----Z ...... DDDDDDDDDDDDDDDD
; 16E0 2E 2E 2E 2E 2E 2E 20 6D 6F 76 65 20 6C 65 66 74 ...... move left DDDDDDDDDDDDDDDD
; 16F0 1F 07 16 58 20 2E 2E 2E 2E 2E 2E 2E 2E 2E 2E 2E ---X ........... DDDDDDDDDDDDDDDD
; 1700 20 6D 6F 76 65 20 72 69 67 68 74 1F 07 17 52 45  move right---RE DDDDDDDDDDDDDDDD
; 1710 54 55 52 4E 20 2E 2E 2E 2E 2E 2E 2E 2E 2E 2E 2E TURN ........... DDDDDDDDDDDDDDDD
; 1720 20 73 68 6F 6F 74 1F 07 18 53 2F 51 20 2E 2E 2E  shoot---S/Q ... DDDDDDDDDDDDDDDD
; 1730 2E 2E 2E 2E 20 73 6F 75 6E 64 20 6F 6E 2F 6F 66 .... sound on/of DDDDDDDDDDDDDDDD
; 1740 66 1F 07 19 52 20 2E 2E 2E 2E 2E 2E 2E 2E 2E 2E f---R .......... DDDDDDDDDDDDDDDD
; 1750 2E 2E 2E 2E 2E 2E 2E 20 72 65 73 74 00 1F 09 1D ....... rest---- DDDDDDDDDDDDDDDD
; 1760 11 02 50 72 65 73 73 20 73 70 61 63 65 20 74 6F --Press space to DDDDDDDDDDDDDDDD
; 1770 20 70 6C 61 79 2E 00 00 A0 0A B9 0E 18 20 EE FF  play.------- -- DDDDDDDDOOOOOOOO
; 1780 88 10 F7 A9 80 8D A0 17 A9 00 8D AC 17 A9 04 85 ---------------- OOOOOOOOOOOOOOOO
; 1790 70 A9 1D 20 EE FF A9 00 20 EE FF 20 EE FF 38 A9 p-- ---- -- --8- OOOOOOOOOOOOOOOO
; 17A0 00 E9 80 8D A0 17 08 20 EE FF 28 A9 00 E9 00 8D ------- --(----- OOOOOOOOOOOOOOOO
; 17B0 AC 17 20 EE FF 20 EE 21 C6 70 D0 D5 AD 5C 1D 8D -- -- -!-p---\-- OOOOOOOOOOOOOOOO
; 17C0 08 1A A9 00 8D 5C 1D A9 26 8D 0C 1A A9 88 8D 0B -----\--&------- OOOOOOOOOOOOOOOO
; 17D0 1A 18 AD 0B 1A 8D 59 1D AD 0C 1A 69 0A 8D 0C 1A ------Y----i---- OOOOOOOOOOOOOOOO
; 17E0 8D 5A 1D 20 B3 20 8E 82 23 EE 5C 1D 20 E0 20 D0 -Z- - --#-\- - - OOOOOOOOOOOOOOOO
; 17F0 FB 20 B3 20 20 A8 21 A9 3C 20 8D 20 AD 5C 1D C9 - -  -!-< - -\-- OOOOOOOOOOOOOOOO
; 1800 04 D0 CE AD 08 1A 8D 5C 1D A9 1A 4C EE FF 10 03 -------\---L---- OOOOOOOOOOOOOODD
; 1810 FF 04 0F 02 0F 00 F0 18 1A A9 00 8D C5 15 AD 78 ---------------x DDDDDDDDDOOOOOOO
; 1820 2D CD C7 15 90 19 D0 08 AD 77 2D CD C6 15 90 0F ---------w------ OOOOOOOOOOOOOOOO
; 1830 AD 77 2D 8D C6 15 AD 78 2D 8D C7 15 CE C5 15 A0 -w-----x-------- OOOOOOOOOOOOOOOO
; 1840 00 B9 C8 15 20 EE FF C8 C0 E5 D0 F5 A9 1F 20 EE ---- --------- - OOOOOOOOOOOOOOOO
; 1850 FF A9 05 20 EE FF A9 0F 20 EE FF AD C7 15 20 D3 --- ---- ----- - OOOOOOOOOOOOOOOO
; 1860 18 AD C6 15 20 D3 18 A9 30 20 EE FF A2 AD A0 16 ---- ---0 ------ OOOOOOOOOOOOOOOO
; 1870 20 E7 18 A2 CA A0 16 20 E7 18 A9 1F 20 EE FF A9  ------ ---- --- OOOOOOOOOOOOOOOO
; 1880 1A 20 EE FF A9 0F 20 EE FF AD C5 15 F0 12 A9 15 - ---- --------- OOOOOOOOOOOOOOOO
; 1890 A2 00 20 F4 FF 8A A2 C0 A0 15 20 F1 FF 4C AD 18 -- ------- --L-- OOOOOOOOOOOOOOOO
; 18A0 A0 FF C8 B9 BE 16 20 E3 FF C9 0E 10 F5 A0 02 B9 ------ --------- OOOOOOOOOOOOOOOO
; 18B0 C8 15 20 EE FF C8 C0 0D D0 F5 A9 32 20 8D 20 A9 -- --------2 - - OOOOOOOOOOOOOOOO
; 18C0 1A 20 EE FF A2 5D A0 17 20 E7 18 A2 9D 20 DA 21 - ---]-- ---- -! OOOOOOOOOOOOOOOO
; 18D0 D0 F9 60 48 4A 4A 4A 4A 18 69 30 20 E3 FF 68 29 --`HJJJJ-i0 --h) OOOOOOOOOOOOOOOO
; 18E0 0F 18 69 30 4C E3 FF 8E F1 18 8C F2 18 A0 FF C8 --i0L----------- OOOOOOOOOOOOOOOO
; 18F0 B9 AD 16 20 EE FF C9 00 D0 F5 60 00 00 00 00 00 --- ------`----- OOOOOOOOOOODDDDD
; 1900 00 00 00 00 00 00 15 08 00 80 00 00 05 00 00 00 ---------------- DDDDDDDDDDDDDDDD
; 1910 00 08 08 1C 08 08 08 00 28 28 28 3E 28 28 00 00 --------(((>((-- DDDDDDDDDDDDDDDD
; 1920 00 08 08 08 08 08 08 00 00 10 10 35 35 10 10 00 -----------55--- DDDDDDDDDDDDDDDD
; 1930 30 30 3F 03 03 3F 30 30 00 20 20 3A 3A 20 20 00 00?--?00-  ::  - DDDDDDDDDDDDDDDD
; 1940 00 00 00 05 00 00 00 00 00 00 00 00 00 00 00 00 ---------------- DDDDDDDDDDDDDDDD
; 1950 00 00 00 00 2A 00 00 00 00 00 0A 02 15 0A 00 00 ----*----------- DDDDDDDDDDDDDDDD
; 1960 00 00 2A 15 00 2A 00 00 00 00 0A 00 02 0A 00 00 --*--*---------- DDDDDDDDDDDDDDDD
; 1970 00 00 00 2A 00 00 00 00 00 00 00 00 05 00 00 00 ---*------------ DDDDDDDDDDDDDDDD
; 1980 00 00 00 00 00 00 00 00 1A 05 00 C0 05 0A 30 05 --------------0- DDDDDDDDDDDDDDDD
; 1990 40 00 4A 15 00 2A 0F 10 00 4A 15 00 00 48 80 20 @-J--*---J---H-  DDDDDDDDDDDDDDDD
; 19A0 0A 4A 10 00 00 40 2A 0A 10 0A 40 15 00 2A 85 30 -J---@*---@--*-0 DDDDDDDDDDDDDDDD
; 19B0 80 25 0A 40 25 90 1A 05 0A 00 20 40 00 0A 00 00 -%-@%----- @---- DDDDDDDDDDDDDDDD
; 19C0 00 05 00 00 00 00 00 00 00 00 00 80 00 00 08 00 ---------------- DDDDDDDDDDDDDDDD
; 19D0 00 00 00 00 00 00 00 00 0A 00 00 00 00 00 00 40 ---------------@ DDDDDDDDDDDDDDDD
; 19E0 00 00 00 00 05 00 00 00 08 00 00 00 00 00 00 00 ---------------- DDDDDDDDDDDDDDDD
; 19F0 00 00 00 00 00 00 15 08 00 80 00 00 05 00 00 00 ---------------- DDDDDDDDDDDDDDDD
; 1A00 2A 2A 2A 2A 2A 2A 2A 2A FF FF FF FF FF FF FF FF ********-------- DDDDDDDDDDDDDDDD
; 1A10 00 04 00 04 28 04 00 04 00 00 00 00 28 00 00 00 ----(-------(--- DDDDDDDDDDDDDDDD
; 1A20 28 00 28 00 28 00 00 00 00 04 00 04 28 04 00 04 (-(-(-------(--- DDDDDDDDDDDDDDDD
; 1A30 00 00 00 00 28 00 00 00 00 00 00 00 00 00 04 2C ----(----------, DDDDDDDDDDDDDDDD
; 1A40 00 00 00 00 00 00 14 28 00 00 00 00 00 00 14 28 -------(-------( DDDDDDDDDDDDDDDD
; 1A50 00 00 00 00 00 00 04 2C 00 00 00 00 00 00 00 28 -------,-------( DDDDDDDDDDDDDDDD
; 1A60 00 00 00 00 00 40 00 40 40 80 80 40 40 40 80 00 -----@-@@--@@@-- DDDDDDDDDDDDDDDD
; 1A70 C0 80 80 40 C0 40 80 00 00 80 80 00 00 40 80 40 ---@-@-------@-@ DDDDDDDDDDDDDDDD
; 1A80 00 00 00 00 00 00 00 00 00 00 00 14 3C 00 00 00 ------------<--- DDDDDDDDDDDDDDDD
; 1A90 00 00 00 3C 3C 34 3C 28 00 00 3C 2D 22 00 00 00 ---<<4<(--<-"--- DDDDDDDDDDDDDDDD
; 1AA0 00 00 00 14 3C 00 14 00 00 00 00 3C 3C 34 28 00 ----<------<<4(- DDDDDDDDDDDDDDDD
; 1AB0 00 00 3C 2D 22 00 00 00 00 00 00 14 3C 00 00 00 --<-"-------<--- DDDDDDDDDDDDDDDD
; 1AC0 00 00 00 3C 39 00 00 00 00 00 3C 2D 22 00 00 00 ---<9-----<-"--- DDDDDDDDDDDDDDDD
; 1AD0 00 00 00 00 14 3C 00 00 00 3C 34 3C 39 00 00 00 -----<---<4<9--- DDDDDDDDDDDDDDDD
; 1AE0 00 00 3C 2D 22 00 00 00 14 00 00 00 14 3C 00 00 --<-"--------<-- DDDDDDDDDDDDDDDD
; 1AF0 28 3C 34 3C 39 00 00 00 00 00 3C 2D 22 00 00 00 (<4<9-----<-"--- DDDDDDDDDDDDDDDD
; 1B00 30 24 10 13 16 19 1C 34 41 1F 48 48 48 48 48 48 0$-----4A-HHHHHH DDDDDDDDDDDDDDDD
; 1B10 48 4C 44 41 53 54 41 4A 53 52 52 54 53 42 4E 45 HLDASTAJSRRTSBNE DDDDDDDDDDDDDDDD
; 1B20 50 2E 7E 21 26 16 34 13 31 32 30 30 30 4C 2E 0E P.~!&-4-12000L.- DDDDDDDDDDDDDDDD
; 1B30 0D 52 55 4E 0D 16 32 17 00 0C 00 00 00 00 00 00 -RUN--2--------- DDDDDDDDDDDDDDDD
; 1B40 00 00 43 41 4C 4C 51 25 0D 00 00 14 3C 00 00 00 --CALLQ%----<--- DDDDDDDDDDDDDDDD
; 1B50 00 00 00 3C 3C 34 3C 28 00 00 3C 2D 22 00 00 00 ---<<4<(--<-"--- DDDDDDDDDDDDDDDD
; 1B60 00 00 00 14 3C 00 14 00 00 00 00 00 00 00 00 00 ----<----------- DDDDDDDDDDDDDDDD
; 1B70 00 00 00 00 14 00 00 00 00 05 00 28 00 01 00 14 -----------(---- DDDDDDDDDDDDDDDD
; 1B80 00 00 00 28 14 00 00 00 00 00 3C 1E 01 00 00 00 ---(------<----- DDDDDDDDDDDDDDDD
; 1B90 00 00 00 3C 3C 38 3C 14 00 00 00 28 3C 00 00 00 ---<<8<----(<--- DDDDDDDDDDDDDDDD
; 1BA0 00 00 3C 1E 01 00 00 00 00 00 00 3C 3C 38 14 00 --<--------<<8-- DDDDDDDDDDDDDDDD
; 1BB0 00 00 00 28 3C 00 28 00 00 00 3C 1E 01 00 00 00 ---(<-(---<----- DDDDDDDDDDDDDDDD
; 1BC0 00 00 00 3C 16 00 00 00 00 00 00 28 3C 00 00 00 ---<-------(<--- DDDDDDDDDDDDDDDD
; 1BD0 00 00 3C 1E 01 00 00 00 00 3C 38 3C 16 00 00 00 --<------<8<---- DDDDDDDDDDDDDDDD
; 1BE0 00 00 00 00 28 3C 00 00 00 00 3C 1E 01 00 00 00 ----(<----<----- DDDDDDDDDDDDDDDD
; 1BF0 14 3C 38 3C 16 00 00 00 28 00 00 00 28 3C 00 00 -<8<----(---(<-- DDDDDDDDDDDDDDDD
; 1C00 3C 38 38 38 38 38 3C 10 38 38 38 38 38 38 38 30 <88888<-88888880 DDDDDDDDDDDDDDDD
; 1C10 14 3C 34 14 14 14 3C 10 20 20 20 20 20 20 38 30 -<4---<-      80 DDDDDDDDDDDDDDDD
; 1C20 3C 30 00 3C 38 28 3C 10 38 38 38 38 30 00 28 30 <0-<8(<-88880-(0 DDDDDDDDDDDDDDDD
; 1C30 3C 30 00 3C 30 00 3C 10 38 38 38 38 38 38 38 30 <0-<0-<-88888880 DDDDDDDDDDDDDDDD
; 1C40 38 38 38 3C 10 00 00 00 38 38 38 38 38 38 38 30 888<----88888880 DDDDDDDDDDDDDDDD
; 1C50 3C 38 28 3C 10 00 3C 10 38 30 00 38 38 38 38 30 <8(<--<-80-88880 DDDDDDDDDDDDDDDD
; 1C60 3C 38 28 3C 38 28 3C 10 38 30 00 28 38 38 38 30 <8(<8(<-80-(8880 DDDDDDDDDDDDDDDD
; 1C70 3C 30 00 14 14 14 14 10 38 38 38 30 20 20 20 20 <0------8880     DDDDDDDDDDDDDDDD
; 1C80 3C 38 28 3C 38 28 3C 10 38 38 38 38 38 38 38 30 <8(<8(<-88888880 DDDDDDDDDDDDDDDD
; 1C90 3C 38 28 3C 10 00 3C 10 38 38 38 38 38 38 38 30 <8(<--<-88888880 DDDDDDDDDDDDDDDD
; 1CA0 00 00 00 00 00 00 00 00 00 00 04 00 0C 00 04 0C ---------------- DDDDDDDDDDDDDDDD
; 1CB0 08 08 06 08 06 0C 06 06 00 00 00 00 08 00 00 08 ---------------- DDDDDDDDDDDDDDDD
; 1CC0 00 04 08 04 00 00 08 04 0C 04 08 0C 02 04 0C 08 ---------------- DDDDDDDDDDDDDDDD
; 1CD0 06 0C 06 08 06 06 0C 06 08 04 08 0C 00 08 04 08 ---------------- DDDDDDDDDDDDDDDD
; 1CE0 00 04 00 00 00 00 08 04 08 09 04 00 00 08 08 0C ---------------- DDDDDDDDDDDDDDDD
; 1CF0 02 0C 02 02 02 02 02 07 08 04 00 00 04 04 01 09 ---------------- DDDDDDDDDDDDDDDD
; 1D00 15 01 09 06 09 06 09 06 00 00 09 06 09 06 09 06 ---------------- DDDDDDDDDDDDDDDD
; 1D10 00 00 09 06 09 06 09 06 00 00 09 06 09 06 09 06 ---------------- DDDDDDDDDDDDDDDD
; 1D20 00 00 00 07 08 06 09 06 00 00 00 0F 20 0F 08 02 ------------ --- DDDDDDDDDDDDDDDD
; 1D30 00 00 00 05 00 0E 01 0E 00 00 01 0E 09 06 09 06 ---------------- DDDDDDDDDDDDDDDD
; 1D40 31 7A D9 7C C9 77 12 7A C8 7C BA 77 51 7A B8 7C 1z-|-w-z-|-wQz-| DDDDDDDDDDDDDDDD
; 1D50 20 7A 42 7A 00 00 00 00 00 00 00 00 00 00 00 00  zBz------------ DDDDDDDDDDDDDDDD
; 1D60 28 3C 0D 2D 2D 0D 3C 2C 28 0F 31 31 35 30 1A 0F (<----<,(-1150-- DDDDDDDDDDDDDDDD
; 1D70 28 0F 30 30 33 30 25 1E 34 1C 1E 0E 36 1E 2C 1C (-0030%-4---6-,- DDDDDDDDDDDDDDDD
; 1D80 3C 1C 2C 3C 34 1C 2C 1C 1C 3C 28 20 28 0C 3C 34 <-,<4-,--<( (-<4 DDDDDDDDDDDDDDDD
; 1D90 34 2C 2C 1C 3C 38 3C 1C 1C 2C 3C 34 2C 3C 1C 2C 4,,-<8<--,<4,<-, DDDDDDDDDDDDDDDD
; 1DA0 3C 38 2C 1C 2C 38 1C 38 2C 1C 39 33 33 27 33 33 <8,-,8-8,-933'33 DDDDDDDDDDDDDDDD
; 1DB0 3C 38 14 11 11 11 11 11 1C 1C 2C 24 3C 2C 1C 1C <8--------,$<,-- DDDDDDDDDDDDDDDD
; 1DC0 20 35 30 20 20 30 30 18 38 10 30 10 38 30 30 18  50  00-8-0-800- DDDDDDDDDDDDDDDD
; 1DD0 3A 10 30 10 10 30 1A 1A 3D 00 30 30 28 00 30 30 :-0--0--=-00(-00 DDDDDDDDDDDDDDDD
; 1DE0 20 20 30 30 20 20 30 30 04 04 0D 24 30 38 30 18   00  00---$080- DDDDDDDDDDDDDDDD
; 1DF0 04 08 00 00 20 20 30 30 00 08 04 04 30 3A 30 30 ----  00----0:00 DDDDDDDDDDDDDDDD
; 1E00 A9 C8 A2 03 A0 00 20 F4 FF 20 BF 18 AD 0C 02 8D ------ -- ------ OOOOOOOOOOOOOOOO
; 1E10 79 13 AD 0D 02 8D 7A 13 20 19 18 20 5F 1E 20 B8 y-----z- -- _- - OOOOOOOOOOOOOOOO
; 1E20 25 A9 13 20 F4 FF 20 94 2A 20 94 2A 20 F7 29 20 %-- -- -* -* -)  OOOOOOOOOOOOOOOO
; 1E30 6E 28 20 E2 28 20 5E 29 20 98 2C 20 45 2C 20 0E n( -( ^) -, E, - OOOOOOOOOOOOOOOO
; 1E40 24 20 38 22 20 E1 1F 20 37 13 4C 1E 1E 47 20 28 $ 8" -- 7-L--G ( OOOOOOOOOOOOODDD
; 1E50 63 29 46 72 69 67 61 61 72 64 20 31 39 38 34 A9 c)Frigaard 1984- DDDDDDDDDDDDDDDO
; 1E60 05 85 70 20 35 28 A9 49 20 A8 21 A9 16 20 EE FF --p 5(-I -!-- -- OOOOOOOOOOOOOOOO
; 1E70 A9 02 20 EE FF A9 00 8D 2B 14 85 8E 8D 5C 1D 8D -- -----+----\-- OOOOOOOOOOOOOOOO
; 1E80 54 1D 8D 55 1D 8D 77 2D 8D 78 2D 85 88 18 A9 20 T--U--w--x-----  OOOOOOOOOOOOOOOO
; 1E90 8D 79 2D A9 03 8D 7A 2D A9 2A 8D 7B 2D A9 02 85 -y----z--*-{---- OOOOOOOOOOOOOOOO
; 1EA0 71 A9 2D 85 8B 85 8D 85 76 A9 47 85 8C A9 0A 85 q-------v-G----- OOOOOOOOOOOOOOOO
; 1EB0 8A A9 13 85 75 A2 0F A0 07 20 1D 28 CA E0 07 D0 ----u---- -(---- OOOOOOOOOOOOOOOO
; 1EC0 F8 86 7D A9 03 8D 56 1D A9 2F 85 89 A9 E8 8D 71 --}---V--/-----q OOOOOOOOOOOOOOOO
; 1ED0 2D A9 04 8D 09 1A 20 B3 20 8E 82 23 EE 5C 1D AD ------ - --#-\-- OOOOOOOOOOOOOOOO
; 1EE0 79 2D C9 0A 30 10 AD 5C 1D 29 01 F0 09 CE 79 2D y---0--\-)----y- OOOOOOOOOOOOOOOO
; 1EF0 CE 79 2D CE 71 2D EE 09 1A EE 09 1A A9 0C 20 EE -y--q--------- - OOOOOOOOOOOOOOOO
; 1F00 FF A9 9A A2 14 20 F4 FF 20 1A 26 20 C9 25 20 EE ----- -- -& -% - OOOOOOOOOOOOOOOO
; 1F10 21 20 54 20 A9 00 8D 5B 1D 8D 76 2D 8D 7D 2D A0 ! T ---[--v--}-- OOOOOOOOOOOOOOOO
; 1F20 54 99 0A 2D 88 D0 FA A0 02 B9 C8 15 20 EE FF C8 T----------- --- OOOOOOOOOOOOOOOO
; 1F30 C0 0D D0 F5 AD 09 1A 8D 47 2D A9 06 8D 0A 2D A9 --------G------- OOOOOOOOOOOOOOOO
; 1F40 1E 8D 13 2D A9 30 8D 5A 1D A9 88 8D 59 1D A9 80 -----0-Z----Y--- OOOOOOOOOOOOOOOO
; 1F50 8D 57 1D A9 32 8D 58 1D AE 56 1D 20 23 22 18 AD -W--2-X--V- #"-- OOOOOOOOOOOOOOOO
; 1F60 57 1D 69 18 8D 57 1D CA D0 F1 A9 3A 85 81 A9 81 W-i--W-----:---- OOOOOOOOOOOOOOOO
; 1F70 85 82 A2 01 A0 08 A9 81 9D 13 2D E8 98 18 69 50 --------------iP OOOOOOOOOOOOOOOO
; 1F80 9D 13 2D A8 E8 A5 81 69 00 9D 13 2D 85 81 18 E8 -------i-------- OOOOOOOOOOOOOOOO
; 1F90 A5 82 69 0A 85 82 9D 13 2D E8 A9 D0 9D 13 2D E8 --i------------- OOOOOOOOOOOOOOOO
; 1FA0 E0 1F 30 D2 A0 00 B1 75 85 70 C8 C8 B1 75 85 78 --0----u-p---u-x OOOOOOOOOOOOOOOO
; 1FB0 C8 B1 75 85 79 20 08 2C C8 C8 C4 70 30 EC 20 E2 --u-y -,---p0- - OOOOOOOOOOOOOOOO
; 1FC0 22 A9 20 8D 70 2D A9 7E 85 87 A9 90 85 86 A9 23 "- -p--~-------# OOOOOOOOOOOOOOOO
; 1FD0 8D D7 28 A9 58 8D D6 28 20 D3 28 A9 40 4C A8 21 --(-X--( -(-@L-! OOOOOOOOOOOOOOOO
; 1FE0 60 AD 76 2D F0 FA F8 29 02 F0 14 18 A9 15 6D 77 `-v----)------mw OOOOOOOOOOOOOOOO
; 1FF0 2D 8D 77 2D AD 78 2D 69 00 8D 78 2D 20 8D 25 A9 --w--x-i--x- -%- OOOOOOOOOOOOOOOO
; 2000 40 2C 76 2D F0 1C 18 A9 01 6D 77 2D 8D 77 2D AD @,v------mw--w-- OOOOOOOOOOOOOOOO
; 2010 78 2D 69 00 8D 78 2D D8 A2 C8 A0 14 A9 07 20 F1 x-i--x-------- - OOOOOOOOOOOOOOOO
; 2020 FF F8 A9 10 2C 76 2D F0 1A 18 A9 0A 6D 77 2D 8D ----,v------mw-- OOOOOOOOOOOOOOOO
; 2030 77 2D AD 78 2D 69 00 8D 78 2D D8 20 E0 20 D0 03 w--x-i--x-- - -- OOOOOOOOOOOOOOOO
; 2040 20 4F 14 D8 20 FC 13 AD 76 2D 10 03 4C 9F 20 A9  O-- ---v---L- - OOOOOOOOOOOOOOOO
; 2050 00 8D 76 2D A9 34 85 81 A9 B0 85 80 A9 1C 85 83 --v--4---------- OOOOOOOOOOOOOOOO
; 2060 A9 F0 2D 78 2D 20 5A 28 A9 0F 2D 78 2D 0A 0A 0A ---x- Z(---x---- OOOOOOOOOOOOOOOO
; 2070 0A 20 5A 28 A9 F0 2D 77 2D 20 5A 28 A9 0F 2D 77 - Z(---w- Z(---w OOOOOOOOOOOOOOOO
; 2080 2D 0A 0A 0A 0A 20 5A 28 A9 00 4C 5A 28 8D 0A 1A ----- Z(--LZ(--- OOOOOOOOOOOOOOOO
; 2090 98 48 A9 13 20 F4 FF CE 0A 1A D0 F6 68 A8 60 A9 -H-- -------h-`- OOOOOOOOOOOOOOOO
; 20A0 00 8D 76 2D 18 A5 88 69 40 85 88 A9 64 20 8D 20 --v----i@---d -  OOOOOOOOOOOOOOOO
; 20B0 4C D6 1E A9 03 2D 5C 1D AA D0 03 A9 33 60 CA D0 L-----\-----3`-- OOOOOOOOOOOOOOOO
; 20C0 04 8A A2 0D 60 CA D0 05 A9 11 A2 1A 60 A9 22 A2 ----`-------`-"- OOOOOOOOOOOOOOOO
; 20D0 26 60 A5 7D 10 06 A5 80 49 C0 85 80 AD 79 2D 60 &`-}----I----y-` OOOOOOOOOOOOOOOO
; 20E0 EE 82 23 AC 82 23 B9 82 23 85 70 29 0E C9 08 10 --#--#--#-p)---- OOOOOOOOOOOOOOOO
; 20F0 0A 18 6D 59 1D 85 80 A9 00 F0 0A 18 6D 59 1D 69 --mY--------mY-i OOOOOOOOOOOOOOOO
; 2100 78 85 80 A9 02 6D 5A 1D 85 81 A9 23 85 83 20 40 x----mZ----#-- @ OOOOOOOOOOOOOOOO
; 2110 21 18 AD 59 1D 69 20 8D 59 1D 90 03 EE 5A 1D 20 !--Y-i -Y----Z-  OOOOOOOOOOOOOOOO
; 2120 74 21 18 A5 80 69 08 85 80 90 02 E6 81 18 A5 82 t!---i---------- OOOOOOOOOOOOOOOO
; 2130 69 08 85 82 90 02 E6 83 20 74 21 C8 B9 82 23 60 i------- t!---#` OOOOOOOOOOOOOOOO
; 2140 A9 80 24 70 F0 05 A9 00 85 82 60 4A 24 70 F0 05 --$p------`J$p-- OOOOOOOOOOOOOOOO
; 2150 A9 10 85 82 60 4A 24 70 F0 05 A9 20 85 82 60 4A ----`J$p--- --`J OOOOOOOOOOOOOOOO
; 2160 24 70 F0 05 A9 30 85 82 60 A9 01 24 70 F0 04 A9 $p---0--`--$p--- OOOOOOOOOOOOOOOO
; 2170 40 85 82 60 98 48 A0 07 18 A5 80 69 78 85 84 A5 @--`-H-----ix--- OOOOOOOOOOOOOOOO
; 2180 81 69 02 85 85 A5 80 29 07 49 07 85 74 C9 07 10 -i-----)-I--t--- OOOOOOOOOOOOOOOO
; 2190 0B B1 82 11 84 91 84 88 C4 74 D0 F5 B1 82 11 80 ---------t------ OOOOOOOOOOOOOOOO
; 21A0 91 80 88 10 F7 68 A8 60 85 70 A4 70 B9 B2 23 F0 -----h-`-p-p--#- OOOOOOOOOOOOOOOO
; 21B0 1D 8D FC 2D C8 B9 B2 23 8D FE 2D A2 F8 A0 2D A9 -------#-------- OOOOOOOOOOOOOOOO
; 21C0 07 20 F1 FF E6 70 E6 70 20 26 13 4C AA 21 A9 80 - ---p-p &-L-!-- OOOOOOOOOOOOOOOO
; 21D0 A2 FA 20 F4 FF E0 0F 30 F5 60 A9 81 A0 FF 20 F4 -- ----0-`---- - OOOOOOOOOOOOOOOO
; 21E0 FF E8 60 00 00 00 00 00 00 00 00 00 00 00 A0 00 --`------------- OOODDDDDDDDDDDOO
; 21F0 B9 0E 22 20 EE FF C8 C0 09 D0 F5 A2 05 A0 09 B9 --" ------------ OOOOOOOOOOOOOOOO
; 2200 0E 22 20 EE FF C8 C0 15 D0 F5 CA D0 F0 60 12 00 -" ----------`-- OOOOOOOOOOOOOODD
; 2210 04 19 04 00 01 EC 03 19 01 00 03 00 00 19 00 00 ---------------- DDDDDDDDDDDDDDDD
; 2220 FD F0 FF A9 10 85 82 A9 19 85 83 AD 57 1D 85 80 ------------W--- DDDOOOOOOOOOOOOO
; 2230 AD 58 1D 85 81 4C 81 25 A9 20 2C 76 2D D0 06 AD -X---L-%- ,v---- OOOOOOOOOOOOOOOO
; 2240 55 1D D0 34 60 A2 00 A0 07 20 1D 28 A9 07 A0 2D U--4`---- -(---- OOOOOOOOOOOOOOOO
; 2250 A2 E0 20 F1 FF A9 FF 8D 55 1D A9 60 8D 45 2C 8D -- -----U--`-E,- OOOOOOOOOOOOOOOO
; 2260 F7 29 8D 6E 28 8D 5E 29 20 D3 28 A9 1A 8D D7 28 -)-n(-^) -(----( OOOOOOOOOOOOOOOO
; 2270 A9 10 8D D6 28 4C D3 28 CE 55 1D AD 55 1D C9 FE ----(L-(-U--U--- OOOOOOOOOOOOOOOO
; 2280 D0 07 A2 00 A0 00 4C 1D 28 C9 DC D0 0B 20 D3 28 ------L-(---- -( OOOOOOOOOOOOOOOO
; 2290 A9 38 8D D6 28 4C D3 28 C9 8C D0 0B 20 D3 28 A9 -8--(L-(---- -(- OOOOOOOOOOOOOOOO
; 22A0 60 8D D6 28 4C D3 28 C9 01 D0 99 CE 56 1D D0 03 `--(L-(-----V--- OOOOOOOOOOOOOOOO
; 22B0 4C BF 13 20 D3 28 20 C1 1F AC 13 2D B1 75 C9 C0 L-- -( ------u-- OOOOOOOOOOOOOOOO
; 22C0 D0 19 88 B1 75 10 15 49 80 91 75 88 B1 75 85 79 ----u--I--u--u-y OOOOOOOOOOOOOOOO
; 22D0 88 B1 75 85 78 20 08 2C 4C DE 22 88 88 88 88 88 --u-x -,L-"----- OOOOOOOOOOOOOOOO
; 22E0 D0 DA A9 20 8D 6E 28 A9 A5 8D F7 29 A9 A9 8D 45 --- -n(----)---E OOOOOOOOOOOOOOOO
; 22F0 2C 8D 5E 29 38 AD 57 1D E9 18 8D 57 1D 4C 23 22 ,-^)8-W----W-L#" OOOOOOOOOOOOOOOO
; 2300 00 00 00 00 00 14 3C 3C 38 38 38 38 38 38 38 20 ------<<8888888  DDDDDDDDDDDDDDDD
; 2310 00 00 00 00 00 14 38 3C 38 38 38 38 38 38 38 00 ------8<8888888- DDDDDDDDDDDDDDDD
; 2320 00 00 00 00 00 14 38 3C 00 00 00 00 00 38 38 20 ------8<-----88  DDDDDDDDDDDDDDDD
; 2330 00 00 00 00 00 38 38 30 00 00 00 00 00 00 00 00 -----880-------- DDDDDDDDDDDDDDDD
; 2340 00 00 00 00 00 3C 3C 10 00 00 00 00 00 38 38 30 -----<<------880 DDDDDDDDDDDDDDDD
; 2350 01 04 04 01 01 01 00 00 00 04 04 04 2C 04 04 04 ------------,--- DDDDDDDDDDDDDDDD
; 2360 00 00 00 14 3C 14 14 00 28 28 28 3D 3E 3E 3C 28 ----<---(((=>><( DDDDDDDDDDDDDDDD
; 2370 00 04 04 04 2C 04 04 04 00 00 00 00 28 00 00 00 ----,-------(--- DDDDDDDDDDDDDDDD
; 2380 00 00 0D 4A 18 8C 8E 1C 8A 84 14 82 20 44 05 00 ---J-------- D-- DDDDDDDDDDDDDDDD
; 2390 48 18 86 84 14 86 84 14 88 2A 4E 05 00 4A 18 8C H--------*N--J-- DDDDDDDDDDDDDDDD
; 23A0 8E 1C 8A 84 14 82 20 44 00 44 42 42 44 46 24 14 ------ D-DBBDF$- DDDDDDDDDDDDDDDD
; 23B0 05 00 65 17 5D 05 59 0A 65 05 79 0A 81 05 89 1E --e-]-Y-e-y----- DDDDDDDDDDDDDDDD
; 23C0 79 1E 00 6D 17 75 05 79 0A 75 05 79 0A 6D 05 65 y--m-u-y-u-y-m-e DDDDDDDDDDDDDDDD
; 23D0 1E 59 1E 00 65 17 5D 05 59 0A 65 05 79 0A 81 05 -Y--e-]-Y-e-y--- DDDDDDDDDDDDDDDD
; 23E0 89 1E 79 0F 00 79 0F 81 0F 81 0F 79 0F 75 0F 79 --y--y-----y-u-y DDDDDDDDDDDDDDDD
; 23F0 1E 00 59 05 59 05 59 05 49 0F 00 41 05 35 0A 39 --Y-Y-Y-I--A-5-9 DDDDDDDDDDDDDDDD
; 2400 05 3D 05 41 05 65 0A 65 0A 55 14 00 14 00 A9 1B -=-A-e-e-U------ DDDDDDDDDDDDDDOO
; 2410 85 83 AD 7D 2D D0 77 A9 42 2C 76 2D F0 6F A9 02 ---}--w-B,v--o-- OOOOOOOOOOOOOOOO
; 2420 2C FC 02 F0 1F A9 1B 85 83 8D 0F 24 A9 68 8D 7C ,----------$-h-| OOOOOOOOOOOOOOOO
; 2430 2D 85 80 A9 00 8D 2F 25 A9 4C 8D 7F 2D A9 4B 8D ------/%-L----K- OOOOOOOOOOOOOOOO
; 2440 6C 24 D0 1B A9 1A 85 83 8D 0F 24 A9 00 8D 7C 2D l$--------$---|- OOOOOOOOOOOOOOOO
; 2450 85 80 8D 7F 2D A9 4C 8D 2F 25 A9 49 8D 6C 24 A9 ------L-/%-I-l$- OOOOOOOOOOOOOOOO
; 2460 00 85 7C EE FC 02 A9 07 25 7D AA A9 4B 18 69 05 --|-----%}--K-i- OOOOOOOOOOOOOOOO
; 2470 A8 A5 7C 69 10 85 7C 98 CA 10 F3 8D 7D 2D 85 81 --|i--|-----}--- OOOOOOOOOOOOOOOO
; 2480 A2 02 8E 7E 2D BD 68 2D 85 82 4C 81 25 60 AD 7C ---~--h---L-%`-| OOOOOOOOOOOOOOOO
; 2490 2D 85 80 AD 7D 2D 85 81 10 18 CE 7E 2D D0 EE 49 ----}------~---I OOOOOOOOOOOOOOOO
; 24A0 80 85 81 A9 10 0D 76 2D 8D 76 2D A9 00 8D 7D 2D ------v--v----}- OOOOOOOOOOOOOOOO
; 24B0 F0 4C AD 7E 2D 29 7F AA BD 68 2D 85 82 A0 00 B1 -L-~-)---h------ OOOOOOOOOOOOOOOO
; 24C0 8A 85 70 C8 B1 8A 38 E5 7C 30 4C C9 07 10 48 C8 --p---8-|0L---H- OOOOOOOOOOOOOOOO
; 24D0 C8 B1 8A F0 44 C8 B1 8A 38 ED 7F 2D 30 3C C9 03 ----D---8---0<-- OOOOOOOOOOOOOOOO
; 24E0 10 38 A9 E8 91 8A AA A9 07 A0 2D 20 F1 FF A9 10 -8--------- ---- OOOOOOOOOOOOOOOO
; 24F0 8D 7E 2D A9 80 0D 7D 2D 8D 7D 2D 20 81 25 A9 1B -~----}--}- -%-- OOOOOOOOOOOOOOOO
; 2500 85 83 A9 70 85 82 4C 81 25 A9 04 0D 76 2D 8D 76 ---p--L-%---v--v OOOOOOOOOOOOOOOO
; 2510 2D A9 00 8D 7D 2D 60 C8 C8 C8 C4 70 30 A5 A9 80 ----}-`----p0--- OOOOOOOOOOOOOOOO
; 2520 4D 7E 2D 8D 7E 2D 30 EE 20 81 25 AD 7F 2D C9 00 M~--~-0- -%----- OOOOOOOOOOOOOOOO
; 2530 F0 D7 29 1F D0 09 A9 07 A0 2D A2 F0 20 F1 FF AE --)--------- --- OOOOOOOOOOOOOOOO
; 2540 7E 2D CA 10 02 A2 07 8E 7E 2D BD 68 2D 85 82 AD ~-------~--h---- OOOOOOOOOOOOOOOO
; 2550 2F 25 F0 18 EE 7F 2D 18 AD 7C 2D 69 08 8D 7C 2D /%-------|-i--|- OOOOOOOOOOOOOOOO
; 2560 85 80 90 1D EE 7D 2D E6 81 4C 81 25 CE 7F 2D 38 -----}---L-%---8 OOOOOOOOOOOOOOOO
; 2570 AD 7C 2D E9 08 8D 7C 2D 85 80 B0 05 CE 7D 2D C6 -|----|------}-- OOOOOOOOOOOOOOOO
; 2580 81 A0 17 B1 82 51 80 91 80 88 10 F7 60 AC 5B 1D -----Q------`-[- OOOOOOOOOOOOOOOO
; 2590 C0 09 10 23 B9 40 1D 85 80 C8 B9 40 1D 85 81 C8 ---#-@-----@---- OOOOOOOOOOOOOOOO
; 25A0 8C 5B 1D A0 04 A9 55 91 80 88 10 FB A0 09 0A 91 -[----U--------- OOOOOOOOOOOOOOOO
; 25B0 80 A0 01 A9 FF 91 80 60 A5 7D 29 48 69 38 0A 0A -------`-})Hi8-- OOOOOOOOOOOOOOOO
; 25C0 26 7F 26 7E 26 7D A5 7D 60 A0 00 B9 B0 26 20 EE &-&~&}-}`----& - OOOOOOOOOOOOOOOO
; 25D0 FF C8 D0 F7 A5 88 85 82 A5 89 85 83 A9 1F 8D 1E ---------------- OOOOOOOOOOOOOOOO
; 25E0 2C A9 E0 85 70 A0 00 C8 BE C3 27 C8 B9 C3 27 24 ,---p-----'---'$ OOOOOOOOOOOOOOOO
; 25F0 70 D0 0C 85 89 86 88 C8 BE C3 27 C8 B9 C3 27 86 p---------'---'- OOOOOOOOOOOOOOOO
; 2600 78 85 79 20 08 2C CC C3 27 30 DC A9 3F 8D 1E 2C x-y -,--'0--?--, OOOOOOOOOOOOOOOO
; 2610 A5 82 85 88 A5 83 85 89 60 00 A9 44 85 79 A9 FF --------`--D-y-- OOOOOOOOODOOOOOO
; 2620 A2 05 A0 00 84 78 91 78 C8 D0 FB E6 79 CA D0 F2 -----x-x----y--- OOOOOOOOOOOOOOOO
; 2630 A0 1F B9 E0 2E 91 78 88 10 F8 A9 2E 85 7B A9 20 ----.-x----.-{-  OOOOOOOOOOOOOOOO
; 2640 85 78 A2 08 BD 5F 2D 85 7A A0 3F B1 7A 91 78 88 -x---_--z-?-z-x- OOOOOOOOOOOOOOOO
; 2650 10 F9 18 A5 78 69 40 85 78 90 02 E6 79 CA 10 E4 ----xi@-x---y--- OOOOOOOOOOOOOOOO
; 2660 A0 1F B9 C0 2E 91 78 88 10 F8 A0 00 A2 07 B9 00 ----.-x--------- OOOOOOOOOOOOOOOO
; 2670 49 9D 80 41 C8 CA 10 F6 18 AD 72 26 69 08 8D 72 I--A------r&i--r OOOOOOOOOOOOOOOO
; 2680 26 90 03 EE 73 26 C0 80 D0 E2 AD 6F 26 49 80 8D &---s&-----o&I-- OOOOOOOOOOOOOOOO
; 2690 6F 26 30 03 EE 70 26 A9 44 CD 73 26 D0 CC 8C 72 o&0--p&-D-s&---r OOOOOOOOOOOOOOOO
; 26A0 26 E8 8E 6F 26 A9 49 8D 70 26 A9 41 8D 73 26 60 &--o&-I-p&-A-s&` OOOOOOOOOOOOOOOO
; 26B0 12 00 06 19 04 00 00 13 00 19 05 04 01 17 00 19 ---------------- DDDDDDDDDDDDDDDD
; 26C0 05 2C 01 3C 00 19 04 7E 04 3E 00 19 05 1A 04 20 -,-<---~->-----  DDDDDDDDDDDDDDDD
; 26D0 00 19 05 84 03 20 00 19 05 52 03 28 00 19 05 20 ----- ---R-(---  DDDDDDDDDDDDDDDD
; 26E0 03 38 00 19 05 16 03 46 00 19 05 16 03 52 00 19 -8-----F-----R-- DDDDDDDDDDDDDDDD
; 26F0 05 20 03 60 00 19 05 52 03 74 00 19 05 BB 03 7C - -`---R-t-----| DDDDDDDDDDDDDDDD
; 2700 00 19 04 7E 04 42 00 19 15 1A 04 24 00 19 15 84 ---~-B-----$---- DDDDDDDDDDDDDDDD
; 2710 03 24 00 19 15 52 03 2C 00 19 15 20 03 3C 00 19 -$---R-,--- -<-- DDDDDDDDDDDDDDDD
; 2720 04 20 03 64 00 19 15 52 03 78 00 19 15 BB 03 80 - -d---R-x------ DDDDDDDDDDDDDDDD
; 2730 00 12 00 02 19 04 00 05 17 00 19 05 C4 04 28 00 --------------(- DDDDDDDDDDDDDDDD
; 2740 19 04 E2 04 1C 00 19 05 DE 03 38 00 19 04 80 02 ----------8----- DDDDDDDDDDDDDDDD
; 2750 82 00 19 05 48 03 0E 01 19 05 AC 03 45 01 19 05 ----H-------E--- DDDDDDDDDDDDDDDD
; 2760 1A 04 4A 01 19 05 00 05 AE 01 19 04 2C 01 C8 00 --J---------,--- DDDDDDDDDDDDDDDD
; 2770 19 05 8A 02 40 01 19 05 3E 03 04 01 19 04 F4 01 ----@--->------- DDDDDDDDDDDDDDDD
; 2780 64 00 19 05 FA 00 DC 00 19 05 8C 00 54 01 19 05 d-----------T--- DDDDDDDDDDDDDDDD
; 2790 00 00 68 01 12 00 04 19 04 9E 02 96 00 19 15 F4 --h------------- DDDDDDDDDDDDDDDD
; 27A0 01 78 00 19 05 58 02 64 00 19 05 90 01 5A 00 00 -x---X-d-----Z-- DDDDDDDDDDDDDDDD
; 27B0 7D 2D 20 13 28 A9 09 85 83 A9 F0 85 82 4C 13 28 }- -(--------L-( DDDDDDDDDDDDDDDD
; 27C0 A9 00 8D 58 A0 1C 93 73 49 71 60 76 99 75 44 73 ---X---sIq`v-uDs DDDDDDDDDDDDDDDD
; 27D0 C9 78 B4 76 C0 1C 13 76 93 78 C9 73 49 76 E0 78 -x-v---v-x-sIv-x DDDDDDDDDDDDDDDD
; 27E0 44 78 C4 75 E0 1C 13 7B 4A 7B 60 7B C4 7A 00 1D Dx-u---{J{`{-z-- DDDDDDDDDDDDDDDD
; 27F0 B0 78 20 78 5C 78 20 1D 00 78 88 76 60 1D 60 70 -x x\x --x-v`-`p DDDDDDDDDDDDDDDD
; 2800 80 1D E0 72 60 75 E0 77 80 7A A0 7A DC 7A A0 1D ---r`u-w-z-z-z-- DDDDDDDDDDDDDDDD
; 2810 60 7A 30 7B C0 1D 08 79 E0 1D 28 79 00 A9 13 20 `z0{---y--(y---  DDDDDDDDDDDDDOOO
; 2820 EE FF 8A 20 EE FF 98 20 EE FF A9 00 20 EE FF 20 --- --- ---- --  OOOOOOOOOOOOOOOO
; 2830 EE FF 4C EE FF A5 70 0A 0A 0A 0A 69 70 AA A9 08 --L---p----ip--- OOOOOOOOOOOOOOOO
; 2840 A0 2D 20 F1 FF C6 70 D0 EC 60 A9 02 8D 4E FE 2C -- ---p--`---N-, OOOOOOOOOOOOOOOO
; 2850 4D FE F0 FB A9 82 8D 4E FE 60 85 82 A0 0F B1 82 M------N-`------ OOOOOOOOOOOOOOOO
; 2860 91 80 88 10 F9 18 A5 80 69 10 85 80 60 00 60 D3 --------i---`-`- OOOOOOOOOOOOODOD
; 2870 28 A9 81 A0 FF A2 BD 20 F4 FF E8 F0 21 88 A2 9E (------ ----!--- DOOOOOOOOOOOOOOO
; 2880 20 F4 FF E8 D0 2E AE 70 2D E0 01 F0 27 CA 8E 70  ----.-p----'--p OOOOOOOOOOOOOOOO
; 2890 2D 38 A5 86 E9 08 85 86 B0 1A C6 87 90 16 AE 70 -8-------------p OOOOOOOOOOOOOOOO
; 28A0 2D E0 47 F0 0F E8 8E 70 2D 18 A5 86 69 08 85 86 --G----p----i--- OOOOOOOOOOOOOOOO
; 28B0 90 02 E6 87 38 A9 00 85 78 A0 24 B1 86 F0 02 85 ----8---x-$----- OOOOOOOOOOOOOOOO
; 28C0 78 98 E9 08 A8 10 F4 A5 78 F0 08 AD 76 2D 09 20 x-------x---v--  OOOOOOOOOOOOOOOO
; 28D0 8D 76 2D A0 27 B9 60 1A F0 04 51 86 91 86 88 10 -v--'-`---Q----- OOOOOOOOOOOOOOOO
; 28E0 F4 60 A0 00 B1 8A 85 70 AD 72 2D 85 82 AD 73 2D -`-----p-r----s- OOOOOOOOOOOOOOOO
; 28F0 85 83 C8 B1 8A 85 77 C8 B1 8A 85 80 C8 B1 8A 85 ------w--------- OOOOOOOOOOOOOOOO
; 2900 81 D0 0A C8 A9 FE 25 71 85 71 4C 47 29 C8 20 C3 ------%q-qLG)- - OOOOOOOOOOOOOOOO
; 2910 29 B1 8A 10 06 A9 00 85 81 F0 2C 38 A9 07 25 80 )---------,8--%- OOOOOOOOOOOOOOOO
; 2920 C9 05 30 09 A5 80 E9 05 85 80 4C 39 29 A5 80 E9 --0-------L9)--- OOOOOOOOOOOOOOOO
; 2930 7D 85 80 A5 81 E5 50 85 81 38 A5 77 E9 05 85 77 }-----P--8-w---w OOOOOOOOOOOOOOOO
; 2940 C9 02 F0 D1 20 C3 29 88 88 88 A5 77 91 8A C8 A5 ---- -)----w---- OOOOOOOOOOOOOOOO
; 2950 80 91 8A C8 A5 81 91 8A C8 C4 70 30 95 60 60 01 ----------p0-``- OOOOOOOOOOOOOOOD
; 2960 24 71 D0 12 A9 81 A0 FF A2 B6 20 F4 FF E8 F0 07 $q-------- ----- OOOOOOOOOOOOOOOO
; 2970 A9 00 8D BE 13 60 60 4C AD 13 71 D0 F9 A0 FF C8 -----``L--q----- OOOOOOOOOODDDOOO
; 2980 C8 C8 C8 B1 8A D0 F8 88 88 A9 9D 91 8A C8 38 A5 --------------8- OOOOOOOOOOOOOOOO
; 2990 86 E9 6E 91 8A 85 80 C8 A5 87 E9 02 91 8A 85 81 --n------------- OOOOOOOOOOOOOOOO
; 29A0 C8 AD 70 2D 18 69 03 91 8A 20 C3 29 A9 03 05 71 --p--i--- -)---q OOOOOOOOOOOOOOOO
; 29B0 85 71 A9 01 0D 76 2D 8D 76 2D A9 07 A0 2D A2 D0 -q---v--v------- OOOOOOOOOOOOOOOO
; 29C0 4C F1 FF 98 48 A0 05 18 A5 80 69 78 85 84 A5 81 L---H-----ix---- OOOOOOOOOOOOOOOO
; 29D0 69 02 85 85 A5 80 29 07 49 07 85 74 C9 05 10 0B i-----)-I--t---- OOOOOOOOOOOOOOOO
; 29E0 B1 82 51 84 91 84 88 C4 74 D0 F5 B1 82 51 80 91 --Q-----t----Q-- OOOOOOOOOOOOOOOO
; 29F0 80 88 10 F7 68 A8 60 60 72 C9 01 10 3A CE 7A 2D ----h-``r---:-z- OOOOOOOODOOOOOOO
; 2A00 D0 35 AD 7B 2D 8D 7A 2D A5 70 20 FA 2C A8 38 E9 -5-{--z--p -,-8- OOOOOOOOOOOOOOOO
; 2A10 05 10 FC AA C8 E8 D0 FC 88 B1 75 30 16 A4 70 88 ----------u0--p- OOOOOOOOOOOOOOOO
; 2A20 B1 75 30 0F 88 88 88 88 D0 F5 A9 80 0D 76 2D 8D -u0----------v-- OOOOOOOOOOOOOOOO
; 2A30 76 2D 60 49 80 91 75 60 A5 77 F0 55 A2 19 86 89 v-`I--u`-w-U---- OOOOOOOOOOOOOOOO
; 2A40 A5 88 48 A5 77 C9 15 D0 0A A9 40 85 88 20 08 2C --H-w-----@-- -, OOOOOOOOOOOOOOOO
; 2A50 4C 88 2A C9 0C D0 11 A9 40 85 88 20 08 2C A9 80 L-*-----@-- -,-- OOOOOOOOOOOOOOOO
; 2A60 85 88 20 08 2C 4C 88 2A C9 06 D0 11 A9 80 85 88 -- -,L-*-------- OOOOOOOOOOOOOOOO
; 2A70 20 08 2C A9 C0 85 88 20 08 2C 4C 88 2A C9 01 D0  -,---- -,L-*--- OOOOOOOOOOOOOOOO
; 2A80 07 A9 C0 85 88 20 08 2C A9 2F 85 89 68 85 88 C6 ----- -,-/--h--- OOOOOOOOOOOOOOOO
; 2A90 77 4C E4 2B A0 00 B1 75 85 70 84 72 C8 B1 75 85 wL-+---u-p-r--u- OOOOOOOOOOOOOOOO
; 2AA0 77 C8 B1 75 85 78 C8 B1 75 85 79 C8 B1 75 85 7A w--u-x--u-y--u-z OOOOOOOOOOOOOOOO
; 2AB0 C8 B1 75 85 7B A5 77 29 C0 D0 03 4C 38 2A A5 7A --u-{-w)---L8*-z OOOOOOOOOOOOOOOO
; 2AC0 10 03 4C 00 2C C6 77 98 48 A0 00 B1 8A 85 80 C8 --L-,-w-H------- OOOOOOOOOOOOOOOO
; 2AD0 B1 8A 38 E5 7B 30 47 C9 08 10 43 C8 C8 B1 8A F0 --8-{0G---C----- OOOOOOOOOOOOOOOO
; 2AE0 3F C8 B1 8A 38 E5 7A 30 38 C9 07 10 34 C9 03 F0 ?---8-z08---4--- OOOOOOOOOOOOOOOO
; 2AF0 0D A9 40 0D 76 2D 8D 76 2D 0A 91 8A D0 23 A9 19 --@-v--v-----#-- OOOOOOOOOOOOOOOO
; 2B00 85 77 A9 D8 91 8A AA A9 07 A0 2D 20 F1 FF 68 A8 -w--------- --h- OOOOOOOOOOOOOOOO
; 2B10 A9 02 0D 76 2D 8D 76 2D 20 08 2C 4C 38 2A C8 C8 ---v--v- -,L8*-- OOOOOOOOOOOOOOOO
; 2B20 C8 C4 80 30 AA 68 A8 A5 73 29 BF 85 73 E6 72 20 ---0-h--s)--s-r  OOOOOOOOOOOOOOOO
; 2B30 08 2C A5 7B C9 AF D0 14 38 A5 78 E9 87 85 78 A5 -,-{----8-x---x- OOOOOOOOOOOOOOOO
; 2B40 79 E9 48 85 79 A9 C0 85 7B 20 EA 13 A9 3F 25 77 y-H-y---{ ---?%w OOOOOOOOOOOOOOOO
; 2B50 D0 36 38 A5 7A ED 70 2D 85 77 A9 00 B0 02 38 6A -68-z-p--w----8j OOOOOOOOOOOOOOOO
; 2B60 6A 85 80 A5 77 D0 03 20 D2 20 10 05 49 FF 18 69 j---w-- - --I--i OOOOOOOOOOOOOOOO
; 2B70 01 C9 02 30 0F 8D 03 2D 20 FD 2C 4E 03 2D 18 6D ---0---- -,N---m OOOOOOOOOOOOOOOO
; 2B80 03 2D 29 3F 05 80 85 77 A5 77 A6 7A E0 01 10 07 --)?---w-w-z---- OOOOOOOOOOOOOOOO
; 2B90 09 40 29 7F 4C 9F 2B E0 48 30 06 09 80 29 BF 85 -@)-L-+-H0---)-- OOOOOOOOOOOOOOOO
; 2BA0 77 E6 7B A9 07 25 78 C9 07 F0 05 E6 78 4C BD 2B w-{--%x-----xL-+ OOOOOOOOOOOOOOOO
; 2BB0 18 A5 78 69 79 85 78 A5 79 69 02 85 79 4C 7B 13 --xiy-x-yi--yL{- OOOOOOOOOOOOOOOO
; 2BC0 90 0F C6 7A A5 78 E9 08 85 78 B0 15 C6 79 4C E1 ---z-x---x---yL- OOOOOOOOOOOOOOOO
; 2BD0 2B E6 7A 2A 90 0B 18 A5 78 69 08 85 78 90 02 E6 +-z*----xi--x--- OOOOOOOOOOOOOOOO
; 2BE0 79 20 08 2C 88 88 88 88 A5 77 91 75 C8 A5 78 91 y -,-----w-u--x- OOOOOOOOOOOOOOOO
; 2BF0 75 C8 A5 79 91 75 C8 A5 7A 91 75 C8 A5 7B 91 75 u--y-u--z-u--{-u OOOOOOOOOOOOOOOO
; 2C00 C4 70 F0 03 4C 9C 2A 60 98 48 18 A5 78 69 78 85 -p--L-*`-H--xix- OOOOOOOOOOOOOOOO
; 2C10 84 29 07 49 07 85 74 A5 79 69 02 85 85 A0 3F A2 -)-I--t-yi----?- OOOOOOOOOOOOOOOO
; 2C20 07 E4 74 F0 0E B1 88 F0 04 51 84 91 84 88 CA E4 --t------Q------ OOOOOOOOOOOOOOOO
; 2C30 74 D0 F2 B1 88 F0 04 51 78 91 78 88 CA 10 F4 98 t------Qx-x----- OOOOOOOOOOOOOOOO
; 2C40 10 DD 68 A8 60 60 C0 24 73 D0 46 C6 73 D0 42 A0 --h-``-$s-F-s-B- OOOOOODOOOOOOOOO
; 2C50 FF C8 C8 C8 C8 C8 B1 75 30 F7 88 88 88 B1 75 29 -------u0-----u) OOOOOOOOOOOOOOOO
; 2C60 C0 D0 06 C8 C8 C8 4C 51 2C C8 18 B1 75 69 9D 85 ------LQ,---ui-- OOOOOOOOOOOOOOOO
; 2C70 80 C8 B1 75 69 02 85 81 20 C3 29 A0 00 C8 C8 B1 ---ui--- -)----- OOOOOOOOOOOOOOOO
; 2C80 8C D0 FA A5 81 91 8C 88 A5 80 91 8C AD 71 2D 85 -------------q-- OOOOOOOOOOOOOOOO
; 2C90 73 A9 C0 05 73 85 73 60 A0 00 B1 8C 85 70 AD 74 s---s-s`-----p-t OOOOOOOOOOOOOOOO
; 2CA0 2D 85 82 AD 75 2D 85 83 C8 B1 8C 85 80 C8 B1 8C ----u----------- OOOOOOOOOOOOOOOO
; 2CB0 85 81 D0 09 A9 7F 25 73 85 73 4C F5 2C 20 C3 29 ------%s-sL-, -) OOOOOOOOOOOOOOOO
; 2CC0 A5 80 29 07 C9 06 10 09 E6 80 E6 80 A5 81 4C DE --)-----------L- OOOOOOOOOOOOOOOO
; 2CD0 2C 18 A5 80 69 7A 85 80 A5 81 69 02 85 81 C9 80 ,---iz----i----- OOOOOOOOOOOOOOOO
; 2CE0 30 06 A9 00 91 8C F0 0D 20 C3 29 88 A5 80 91 8C 0------- -)----- OOOOOOOOOOOOOOOO
; 2CF0 C8 A5 81 91 8C C4 70 30 AF 60 8D 03 2D 38 A5 7C ------p0-`---8-| OOOOOOOOOOOOOOOO
; 2D00 29 7F E9 10 10 FC 6D 03 2D 60 06 02 31 00 05 02 )-----m--`--1--- OOOOOOOOOODDDDDD
; 2D10 39 00 06 1E 9E F0 35 9E C0 81 A8 3A 95 D0 81 F8 9-----5----:---- DDDDDDDDDDDDDDDD
; 2D20 3A 9F D0 81 48 3B A9 D0 81 98 3B B3 D0 81 E8 3B :---H;----;----; DDDDDDDDDDDDDDDD
; 2D30 BD D0 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ---------------- DDDDDDDDDDDDDDDD
; 2D40 00 00 00 00 00 00 00 02 D6 00 00 00 00 00 00 00 ---------------- DDDDDDDDDDDDDDDD
; 2D50 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 80 ---------------- DDDDDDDDDDDDDDDD
; 2D60 40 40 00 80 00 40 80 00 88 A0 B8 D0 E8 D0 B8 88 @@---@---------- DDDDDDDDDDDDDDDD
; 2D70 20 D7 00 1A 50 23 00 00 00 20 03 42 00 00 06 00  ---P#--- -B---- DDDDDDDDDDDDDDDD
; 2D80 01 81 FD 00 00 1A 00 00 3C 06 CE CE 3B 7E 00 00 --------<---;~-- DDDDDDDDDDDDDDDD
; 2D90 02 83 00 00 00 00 00 00 7F FF FE FF 7E 78 00 00 ------------~x-- DDDDDDDDDDDDDDDD
; 2DA0 03 86 FF 00 01 02 01 01 7F FF FD FD 7E 78 00 00 ------------~x-- DDDDDDDDDDDDDDDD
; 2DB0 04 81 F0 FA FC 10 0A 0F 7F FE E2 9C 7E 00 00 00 ------------~--- DDDDDDDDDDDDDDDD
; 2DC0 05 0A 00 00 00 01 0C 00 7F F5 00 E2 7E 00 00 00 ------------~--- DDDDDDDDDDDDDDDD
; 2DD0 12 00 04 00 78 00 06 00 10 00 F1 FF 06 00 10 00 ----x----------- DDDDDDDDDDDDDDDD
; 2DE0 10 00 F1 FF 06 00 10 00 13 00 01 00 B4 00 06 00 ---------------- DDDDDDDDDDDDDDDD
; 2DF0 13 00 01 00 FA 00 05 00 01 00 F1 FF 49 00 0F 00 ------------I--- DDDDDDDDDDDDDDDD
; 2E00 FF FF FF FF FF FF FF FF FF FF FF FF FF AA AA 00 ---------------- DDDDDDDDDDDDDDDD
; 2E10 55 AA FF AA 55 55 00 00 FF FF 55 FF FF FF FF 00 U---UU----U----- DDDDDDDDDDDDDDDD
; 2E20 FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF AA ---------------- DDDDDDDDDDDDDDDD
; 2E30 FF FF FF FF FF AA 55 00 FF FF FF 55 FF FF FF 55 ------U----U---U DDDDDDDDDDDDDDDD
; 2E40 FF FF FF FF FF FF FF AA FF FF FF FF FF FF AA 00 ---------------- DDDDDDDDDDDDDDDD
; 2E50 FF FF FF AA FF 55 00 00 FF 55 FF FF FF FF FF 00 -----U---U------ DDDDDDDDDDDDDDDD
; 2E60 FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF AA ---------------- DDDDDDDDDDDDDDDD
; 2E70 FF FF FF FF FF AA 55 00 FF FF FF FF 55 FF FF FF ------U-----U--- DDDDDDDDDDDDDDDD
; 2E80 AA FF FF FF FF FF FF AA FF 55 AA FF FF AA 00 00 ---------U------ DDDDDDDDDDDDDDDD
; 2E90 FF FF FF 55 AA 00 00 00 FF FF FF FF FF 00 00 00 ---U------------ DDDDDDDDDDDDDDDD
; 2EA0 FF FF FF FF FF FF 55 00 FF FF FF FF FF FF FF 55 ------U--------U DDDDDDDDDDDDDDDD
; 2EB0 FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF 00 ---------------- DDDDDDDDDDDDDDDD
; 2EC0 FF FF FF FF FF FF AA 55 FF FF AA 55 FF 55 FF FF -------U---U-U-- DDDDDDDDDDDDDDDD
; 2ED0 55 FF FF FF FF FF FF AA FF FF AA AA AA 00 00 00 U--------------- DDDDDDDDDDDDDDDD
; 2EE0 FF FF 55 55 55 00 00 00 FF FF FF FF FF FF FF 00 --UUU----------- DDDDDDDDDDDDDDDD
; 2EF0 FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF ---------------- DDDDDDDDDDDDDDDD
; 2F00 00 05 00 00 00 00 05 00 00 0F 0A 0A 0A 0A 0F 00 ---------------- DDDDDDDDDDDDDDDD
; 2F10 00 0F 00 00 00 00 0F 15 00 0F 05 15 0F 05 0F 00 ---------------- DDDDDDDDDDDDDDDD
; 2F20 0A 0F 2F 3F 2F 0F 0F 0A 00 0F 00 00 0A 00 0F 15 --/?/----------- DDDDDDDDDDDDDDDD
; 2F30 00 0F 00 00 00 00 0F 00 00 0F 0A 0A 0A 0A 0F 00 ---------------- DDDDDDDDDDDDDDDD
; 2F40 00 04 00 00 00 00 00 00 00 0C 04 00 00 00 00 00 ---------------- DDDDDDDDDDDDDDDD
; 2F50 00 0C 00 08 04 00 05 05 00 0D 15 04 04 08 00 00 ---------------- DDDDDDDDDDDDDDDD
; 2F60 08 2F 3F 06 0C 08 00 00 00 0C 00 00 04 08 05 05 -/?------------- DDDDDDDDDDDDDDDD
; 2F70 00 0C 04 08 00 00 00 00 00 0C 00 00 00 00 00 00 ---------------- DDDDDDDDDDDDDDDD
; 2F80 00 00 00 14 14 00 00 00 00 00 00 00 28 3C 00 00 ------------(<-- DDDDDDDDDDDDDDDD
; 2F90 00 00 00 00 00 3C 0A 00 28 14 00 00 14 29 14 00 -----<--(----)-- DDDDDDDDDDDDDDDD
; 2FA0 00 3C 28 28 3E 2B 16 28 28 00 00 00 00 3C 00 00 -<((>+-((----<-- DDDDDDDDDDDDDDDD
; 2FB0 00 00 00 00 00 3C 0A 00 00 00 00 14 3C 28 00 00 -----<------<(-- DDDDDDDDDDDDDDDD
; 2FC0 00 00 00 00 14 00 00 00 30 00 00 10 3C 10 00 00 --------0---<--- DDDDDDDDDDDDDDDD
; 2FD0 38 28 28 3E 14 3C 30 00 30 00 00 20 3C 20 00 00 8((>-<0-0-- < -- DDDDDDDDDDDDDDDD
; 2FE0 10 00 00 00 3C 00 00 00 30 00 00 34 3C 34 10 00 ----<---0--4<4-- DDDDDDDDDDDDDDDD
; 2FF0 38 28 28 3A 14 38 20 00 20 00 00 00 3C 00 00 00 8((:-8 - ---<--- DDDDDDDDDDDDDDDD

if(0)
Begin:Strings discovered
string $1300 38 ; "Thanks David,Ian,Martin,Mum,Dad,Susi D"
string $13BB 3 ; "L})"
string $13E0 10 ; "GAME OVER`"
string $13F6 4 ; "whhL"
string $142C 3 ; " #""
string $145A 3 ; "  x"
string $146F 3 ; "w-i"
string $1477 3 ; "x-i"
string $148F 4 ; " T h"
string $14AC 3 ; "v-`"
string $14C2 6 ; "BONUS!"
string $15EC 8 ; "        "
string $15FD 7 ; "       "
string $1613 4 ; "    "
string $163D 3 ; "   "
string $1681 28 ; "FIREBIRD (c) Andrew Frigaard"
string $16A0 10 ; "High Score"
string $16B0 13 ; "............."
string $16C1 8 ; "andrew  "
string $16CF 4 ; "Keys"
string $16D8 24 ; "Z ............ move left"
string $16F3 24 ; "X ........... move right"
string $170E 24 ; "RETURN ........... shoot"
string $1729 24 ; "S/Q ....... sound on/off"
string $1744 24 ; "R ................. rest"
string $1762 20 ; "Press space to play."
string $18D2 6 ; "`HJJJJ"
string $18D9 3 ; "i0 "
string $18E2 3 ; "i0L"
string $1918 6 ; "(((>(("
string $1930 3 ; "00?"
string $1935 3 ; "?00"
string $1939 6 ; "  ::  "
string $1A00 8 ; "********"
string $1A6B 3 ; "@@@"
string $1A93 5 ; "<<4<("
string $1A9A 3 ; "<-""
string $1AAB 4 ; "<<4("
string $1AB2 3 ; "<-""
string $1ACA 3 ; "<-""
string $1AD9 4 ; "<4<9"
string $1AE2 3 ; "<-""
string $1AF0 5 ; "(<4<9"
string $1AFA 3 ; "<-""
string $1B0A 27 ; "HHHHHHHLDASTAJSRRTSBNEP.~!&"
string $1B28 7 ; "12000L."
string $1B31 3 ; "RUN"
string $1B42 6 ; "CALLQ%"
string $1B53 5 ; "<<4<("
string $1B5A 3 ; "<-""
string $1B93 4 ; "<<8<"
string $1BAB 3 ; "<<8"
string $1BD9 3 ; "<8<"
string $1BF1 3 ; "<8<"
string $1C00 7 ; "<88888<"
string $1C08 8 ; "88888880"
string $1C18 10 ; "      80<0"
string $1C23 4 ; "<8(<"
string $1C28 5 ; "88880"
string $1C2E 4 ; "(0<0"
string $1C38 12 ; "88888880888<"
string $1C48 12 ; "88888880<8(<"
string $1C5B 12 ; "88880<8(<8(<"
string $1C6B 7 ; "(8880<0"
string $1C78 15 ; "8880    <8(<8(<"
string $1C88 12 ; "88888880<8(<"
string $1C98 8 ; "88888880"
string $1D4B 3 ; "wQz"
string $1D4F 5 ; "| zBz"
string $1D66 3 ; "<,("
string $1D6A 4 ; "1150"
string $1D72 5 ; "0030%"
string $1D82 3 ; ",<4"
string $1D89 4 ; "<( ("
string $1D8E 5 ; "<44,,"
string $1D94 3 ; "<8<"
string $1D99 5 ; ",<4,<"
string $1D9F 4 ; ",<8,"
string $1DAA 8 ; "933'33<8"
string $1DBA 4 ; ",$<,"
string $1DC0 7 ; " 50  00"
string $1DCC 3 ; "800"
string $1DDA 3 ; "00("
string $1DDE 10 ; "00  00  00"
string $1DEB 4 ; "$080"
string $1DF4 4 ; "  00"
string $1DFC 4 ; "0:00"
string $1E2E 5 ; ") n( "
string $1E34 5 ; "( ^) "
string $1E3A 5 ; ", E, "
string $1E40 5 ; "$ 8" "
string $1E4D 18 ; "G (c)Frigaard 1984"
string $1E62 4 ; "p 5("
string $1F10 4 ; "! T "
string $1F5B 3 ; " #""
string $1FEE 3 ; "mw-"
string $1FF5 3 ; "x-i"
string $1FFA 3 ; "x- "
string $2000 4 ; "@,v-"
string $2009 3 ; "mw-"
string $2010 3 ; "x-i"
string $2024 3 ; ",v-"
string $202C 3 ; "mw-"
string $2033 3 ; "x-i"
string $2062 6 ; "-x- Z("
string $206A 3 ; "-x-"
string $2071 3 ; " Z("
string $2076 6 ; "-w- Z("
string $207E 3 ; "-w-"
string $2085 3 ; " Z("
string $208A 3 ; "LZ("
string $20DD 3 ; "y-`"
string $210E 3 ; " @!"
string $211F 3 ; " t!"
string $2138 3 ; " t!"
string $214A 4 ; "`J$p"
string $2154 4 ; "`J$p"
string $215E 4 ; "`J$p"
string $21C7 3 ; "p &"
string $2239 4 ; " ,v-"
string $2266 3 ; "^) "
string $22F2 3 ; "^)8"
string $22FD 3 ; "L#""
string $2306 10 ; "<<8888888 "
string $2316 9 ; "8<8888888"
string $232D 3 ; "88 "
string $2335 3 ; "880"
string $234D 3 ; "880"
string $2368 8 ; "(((=>><("
string $23A9 6 ; "DBBDF$"
string $2418 4 ; "B,v-"
string $24B3 4 ; "~-)"
string $24C8 3 ; "|0L"
string $24DA 4 ; "-0<"
string $24F9 3 ; "}- "
string $2514 3 ; "}-`"
string $2520 3 ; "M~-"
string $2524 3 ; "~-0"
string $2559 3 ; "|-i"
string $256D 3 ; "-8"
string $25B9 5 ; "})Hi8"
string $25C0 6 ; "&&~&}"
string $25EE 3 ; "'$p"
string $2654 3 ; "xi@"
string $267A 3 ; "r&i"
string $268B 3 ; "o&I"
string $2690 3 ; "o&0"
string $26AD 3 ; "s&`"
string $27B0 3 ; "}- "
string $27C7 5 ; "sIq`v"
string $27CD 3 ; "uDs"
string $27DB 3 ; "sIv"
string $27DF 3 ; "xDx"
string $27E7 5 ; "{J{`{"
string $27F1 6 ; "x x\x "
string $2803 3 ; "r`u"
string $2810 4 ; "`z0{"
string $288F 3 ; "p-8"
string $2909 4 ; "qLG)"
string $292A 3 ; "L9)"
string $2975 3 ; "``L"
string $29F6 3 ; "``r"
string $2A30 4 ; "v-`I"
string $2ABB 3 ; "L8*"
string $2AD4 3 ; "{0G"
string $2AE6 3 ; "z08"
string $2B16 3 ; "v- "
string $2B1A 4 ; ",L8*"
string $2B4D 3 ; "?%w"
string $2B5E 3 ; "8jj"
string $2B81 3 ; "-)?"
string $2B91 4 ; "@)L"
string $2BB2 3 ; "xiy"
string $2BBC 3 ; "yL{"
string $2C0C 3 ; "xix"
string $2C66 3 ; "LQ,"
string $2CB5 3 ; "%s"
string $2CFF 3 ; "|)"
string $2EE2 3 ; "UUU"
string $2F22 3 ; "/?/"
string $2FA1 5 ; "<((>+"
string $2FD0 4 ; "8((>"
string $2FDB 3 ; " < "
string $2FEB 3 ; "4<4"
string $2FF0 4 ; "8((:"
End:Strings discovered

endif
