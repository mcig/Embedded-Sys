#include <stdio.h>
#include <stdlib.h>
#include "uart.h"

int sieve_of_eratosthenes(int n)
{
    int i, j;
    int *primes = (int *)malloc(n * sizeof(int));

    for (i = 0; i < n; i++)
    {
        primes[i] = 0;
    }

    for (i = 2; i < n; i++)
    {
        if (!primes[i])
        {
            for (j = i + i; j < n; j += i)
                primes[j] = 1;
        }
    }

    for (i = 2; i < n; i++)
    {
        if (primes[i])
            printf("%d ", i);
    }

    return 0;
}

unsigned int mygcd(unsigned int a, unsigned int b)
{
    unsigned int t;
    while (a != 0)
    {
        if (a < b)
        {
            t = a;
            a = b;
            b = t;
        }
        a = a - b;
    }
    return b;
}

int main()
{
    uart_init();
    stdout = &uart_output;
    stdin = &uart_input;

    int n = 120;
    int count = sieve_of_eratosthenes(n);

    return 1;
}
