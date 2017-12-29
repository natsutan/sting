import sys
import os

out_file0 = 'result/weight.hex'
out_file1 = 'result/bn.hex'

exp_dir = '../../data/weight'
exp_file0 = os.path.join(exp_dir, "conv2d_1_kernel_z.hex")
exp_file1 = os.path.join(exp_dir, "conv2d_1_kernel_z.hex")
err_max = 5
err = 0


def comp_simple(fp0, fp1):
    l0 = fp0.readline().rstrip()
    l1 = fp0.readline().rstrip()

    while l0:
        if not l0 == l1:
            error_inc("%s : %s" % (l0, l1))

        l0 = fp0.readline().rstrip()
        l1 = fp0.readline().rstrip()


def error_inc(s):
    global err
    print("ERROR %s" % s)
    err = err + 1
    if err > err_max:
        print("Too many errors.")
        sys.exit(1)


fpo = open(out_file0, 'r')
fpe = open(exp_file0, 'r')
comp_simple(fpe, fpo)

if err == 0:
    print("OK all test passed")