addi r5, r0, 8
ori r3, r0, 0xABCD
sw r3, 4(r0)
lw r10, -4(r5)
lb r16, 4(r0)
nand r4, r10, r16

