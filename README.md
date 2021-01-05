# BirdStrike

This is a project to reverse-engineer and fix the BBC Micro game 'Bird Strike' by Andrew Frigaard

The original had a fault that after level 13 graphical corruptions appear and the game crashes when level 23 loads.

This source code was obtained by disassembling the original binary file "BIRDSK2" with WFDis and Beebdis.exe (Beebdis control file included).

It can then be assembled with beebasm.exe (eg beebasm.exe -i birdsk2.asm) to produce a 6502 binary.

To run, load the binary into the memory of a BBC Micro with

```
PAGE=&3000
*LOAD birdsk2 1200
CALL &1E00
```

If that doesn't work (hangs at 'press space to play') try the following:

```
PAGE=&3000
*LOAD birdsk2 1200
?&3527 = &A4
?&3528 = &E0
?&3529 = &A6
?&352A = &FF

CALL &1300
```

This emulates the loader program BIRDSK1 being loaded, which BIRDSK2 copies some memory locations from - possibly as an anti-tamper/copy protection method.

## SaveStates

A number of BeebEm save states have been added for anyone wanting to see the glitch without having to play through the levels, or for debugging/analysis purposes, etc.

They are:

1) Fresh game loaded, never been played. Press space and enjoy!
2) Level 9 - a few levels before the first glitch I can spot.
3) Level 13 - the first visible glitch - a 'stuck' enemy bomb at the top of the screen
4) Level 20 - many glitches present by this point - cloud/pigeon sprite corruption etc
5) Level 22 - the last level before the game crashes completely. Down the plane and it's all over!

The save states have invincibility enabled. To disable enter the following command in the BeebEm debugger:
```
c 2238 A9
```

(To re-enable repeat but replace A9 with 60 (RTS))
