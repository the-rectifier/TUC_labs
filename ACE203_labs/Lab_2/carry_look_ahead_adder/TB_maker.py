f = open("testbench.txt", 'w')
for i in range(0,16):
    for j in range(0, 16):
        for cin in range(0,2):
            f.write('A <= X"%s";\n' % hex(i)[2:])
            f.write('B <= X"%s";\n' % hex(j)[2:])
            f.write("Cin <= '%d';\n" % cin)
            f.write("wait for 1 ns;\n")