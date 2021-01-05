org $3000
.start
LDX #$FF
.loop
	INX
	LDA text, X
	JSR $FFE3
	TXA
	CMP #51
	BCC loop

RTS

.text	\ key instructions etc
        EQUB    $28,$63,$29,$41,$2E,$45,$2E,$46			\ Copyright and Hello!
        EQUB    $72,$69,$67,$61,$61,$72,$64,$20
        EQUB    $31,$39,$38,$34,$20,$48,$65,$6C
        EQUB    $6C,$6F,$21
.end

SAVE "bytetxt", start, end
