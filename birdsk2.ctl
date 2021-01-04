# Control file for Beebdis.exe to disassemble the BirdSk2 binary
# Data regions originally found using https://www.white-flame.com/wfdis/
# There's probably an easier way to do it though...

# Change this line to reflect the name of your original binary
# Leave the load address as $1200
load $1200 $.BirdSk2.bin

# Where the code executes at
entry $1300

# Data areas to ignore
byte $1200 256
byte $1380 166
byte $1461 9
byte $149b 19
byte $14ca 14
byte $1519 1
byte $15ac 460
byte $180e 11
byte $190a 1270
byte $1e51 27
byte $21de 16
byte $220e 21
byte $2300 270
byte $2619 1
byte $26b0 365
byte $286f 100
byte $295f 100
byte $29f8 64
byte $2bc0 33
byte $2c46 82
byte $2d0a 758

# What to save the output as
save birdsk2.asm

# Probably unnecessary, but to save ambiguity
cpu 6502
