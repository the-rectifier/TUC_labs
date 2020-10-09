f = open("combinations.txt",'w')
f.write("-- a1 a0 b1 b0 cin\n")
f.write("-- MSB---------LSB\n")
for a1 in range(0,2):
    for a0 in range(0,2):
        for b1 in range(0,2):
            for b0 in range(0,2):
                for cin in range(0,2):
                    f.write("\
--state: %d%d%d%d%d\n\
a(1) <= '%d';\n\
a(0) <= '%d';\n\
b(1) <= '%d';\n\
b(0) <= '%d';\n\
cin <= '%d';\n\
wait for 25 ns;\n" % (a1,a0,b1,b0,cin,a1,a0,b1,b0,cin))
