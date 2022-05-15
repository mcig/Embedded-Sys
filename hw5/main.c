#include <avr/io.h>
#include <avr/interrupt.h>

#define STEP_STATE_LEN 4
#define TIMER_START_VAL 0x00
#define PRESCALER_1024_TCCR0B (1 << CS00) | (1 << CS02); // Timer mode with 1024 prescaler

enum StepperState
{
    Orange,
    Yellow,
    Pink,
    Blue,
};

enum Direction
{
    Stop,
    Clockwise,
    CounterClockwise,
};

int currState = Orange;
int currDirection = Clockwise;

// delay handler in between motor steps
ISR(TIMER0_OVF_vect)
{
    // pause the timer0
    TCCR0B = 0;

    if (currDirection == 1)
        ;
    // restart timer
    TCCR0B = PRESCALER_1024_TCCR0B;
    TCNT0 = TIMER_START_VAL;
}

int main(int argc, char const *argv[])
{
    DDRD = 0b00111100;

    TCNT0 = TIMER_START_VAL; // Target delay
    TCCR0A = 0x00;           // Normal mode
    TCCR0B = PRESCALER_1024_TCCR0B;
    TIMSK0 = (1 << TOIE0); // Enable timer0 overflow interrupt (TOIE0)

    sei(); // Enable global interrupts

    return 0;
}
