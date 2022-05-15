#include <avr/io.h>
#include <util/delay.h>

int main()
{
    int i;
    while (1)
    {
        DDRB = 0xFF;              /* set PORTB for output */
        for (i = 0; i < 50; i++)  /* busy-wait (65536 x 4 x 50) cycles */
            _delay_loop_2(65535); /* busy-wait (65536 x 4) cycles */
        PORTB = 0xFF;             /* set PORTB high */
        for (i = 0; i < 50; i++)
            _delay_loop_2(65535);
        PORTB = 0x00; /* set PORTB low */
    }
    return 1;
}