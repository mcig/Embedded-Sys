#include <avr/io.h>
#include <avr/interrupt.h>

#define TIMER_START_VAL 0
#define PRESCALER_1024_TCCR0B 5; // Timer mode with 1024 prescaler

char rotateMotor(char state, char direction);

enum StepperState
{
    Orange1 = 0,
    Orange2,
    Yellow1,
    Yellow2,
    Pink1,
    Pink2,
    Blue1,
    Blue2
};

enum Direction
{
    Stop = 0,
    Clockwise,
    CounterClockwise,
};

// using only 8 bits
char currState = Orange1;
char currDirection = Clockwise;

// delay handler in between motor steps
ISR(TIMER0_OVF_vect)
{
    // pause the timer0
    TCCR0B = 0;

    currState = rotateMotor(currState, currDirection);

    // restart timer
    TCNT0 = TIMER_START_VAL;
    TCCR0B = PRESCALER_1024_TCCR0B;
}

int main(int argc, char const *argv[])
{
    DDRD = 0b00111100;

    TCNT0 = TIMER_START_VAL; // Target delay
    TCCR0A = 0x00;           // Normal mode
    TCCR0B = PRESCALER_1024_TCCR0B;
    TIMSK0 = (1 << TOIE0); // Enable timer0 overflow interrupt (TOIE0)

    sei(); // Enable global interrupts

    while (1)
        ;

    return 0;
}
