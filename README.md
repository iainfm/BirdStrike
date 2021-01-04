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
