# Control file for Beebdis.exe to disassemble the BirdSk2 binary
# Data regions originally found using https://www.white-flame.com/wfdis/
# There's probably an easier way to do it though...

# Change this line to reflect the name of your original binary
# Leave the load address as $1200
load $1400 decryptedtape.bin

# Where the code executes at
entry $1461
entry $1E00
entry $2871
entry $2960
entry $29f9
entry $2bc0
entry $2c47

# Strings
string $1400 38
string $14CA 14
string $1e51 27
string $15b1 6
string $1665 29
# string $1687 10
# string $1696 10

# Data areas to ignore - note: labels in these areas won't be translated by beebdis
byte $149b 1
byte $14ad 1
byte $151a 1
byte $15ac 460
byte $180e 11
byte $190a 1270
byte $21de 16
byte $220e 21
byte $2300 270
byte $2619 1
byte $26b0 365
byte $286f 2
byte $295f 1
byte $297a 3
byte $29f8 1
byte $2c46 1
byte $2d0a 758

# Options
# hexdump
symbols symbols.asm

# What to save the output as
save decryptedtape.asm

# Probably unnecessary, but to save ambiguity
cpu 6502
