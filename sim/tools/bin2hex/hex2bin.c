//
// Created by natu on 2017/12/28.
//
#include <stdio.h>
#include <stdlib.h>

void usage(void);

int main(int argc, char *argv[])
{
    FILE *fpin, *fpout;
    unsigned int data;

    if(argc!=3) {
        usage();
    }

    fpin = fopen(argv[1], "rb");
    if(fpin==NULL) {
        printf("can't open %s\n", argv[1]);
        exit(1);
    }
    fpout = fopen(argv[2], "w");
    if(fpout==NULL) {
        printf("can't open %s\n", argv[2]);
        exit(1);
    }

    while((fread(&data, 4, 1, fpin)!=0)) {
        fprintf(fpout, "%08x\n", data);
    }

    fclose(fpin);
    fclose(fpout);
    return 0;
}

void usage(void)
{
    printf("usage:hex2bin infile outfile\n");
    exit(1);

}