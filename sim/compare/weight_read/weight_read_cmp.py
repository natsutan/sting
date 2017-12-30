import sys
import os

out_file0 = 'result/weight.hex'
out_file1 = 'result/bn.hex'

exp_dir = '../../data/weight'
exp_file0 = os.path.join(exp_dir, "conv2d_1_kernel_z.hex")
exp_file1 = os.path.join(exp_dir, "batch_normalization_1.hex")
err_max = 5
err = 0


def comp_simple(title, fp0, fp1):
    print("run %s" % title)
    l0 = fp0.readline().rstrip()
    l1 = fp1.readline().rstrip()

    while l0:
        if not l0 == l1:
            error_inc("%s %s : %s" % (title, l0, l1))

        l0 = fp0.readline().rstrip()
        l1 = fp1.readline().rstrip()


def error_inc(s):
    global err
    print("ERROR %s" % s)
    err = err + 1
    if err > err_max:
        print("Too many errors.")
        sys.exit(1)


fpo0 = open(out_file0, 'r')
fpe0 = open(exp_file0, 'r')
fpo1 = open(out_file1, 'r')
fpe1 = open(exp_file1, 'r')
comp_simple("convtest", fpe0, fpo0)
comp_simple("bntest", fpe1, fpo1)

if err == 0:
    print("OK all test passed")

