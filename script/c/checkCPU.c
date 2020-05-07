#include <stdio.h>

/*
 * Check CPU Endian
 * $ gcc -o checkCPU.o checkCPU.c
 * $ ./checkCPU.o
 */

int main(void)
{
    {
        union w {
            int a;
            char b;
        } c;

        c.a = 1;

        if (c.b == 1)
            printf("The CPU is Litle-Endian\n");
        else
            printf("The CPU is Big-Endian\n");
    }
    {
        int foo = 0x12345678;
        char *bar = (char *)&foo;

        if (*bar == 0x78)
            printf("The CPU is Litle-Endian\n");
        else
            printf("The CPU is Big-Endian\n");
    }

    return 0;
}

