#include <avr/interrupt.h>

#define TIMER_START_VAL 0xf0
#define PRESCALER_1024_TCCR0B 5; // Timer mode with 1024 prescaler
#define ABS(a) ((a) < 0 ? -(a) : (a))

#define MID_POINT 500

char rotateMotor(char state, char direction);
int checkLight();
char getMotorDirection(int currLight);

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
char motorState = Orange1;
char motorDirection = Stop;

// delay handler in between motor steps
ISR(TIMER0_OVF_vect)
{
    // pause the timer0
    TCCR0B = 0;

    motorState = rotateMotor(motorState, motorDirection);

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
    {
        int currLight = checkLight();

        motorDirection = getMotorDirection(currLight);
    }

    return 0;
}

char getMotorDirection(int currLight)
{
    // int lightDiff = ABS(currLight - targetLight);
    if (currLight < MID_POINT)
    {
        return Clockwise;
    }
    else
    {
        return CounterClockwise;
    }
}