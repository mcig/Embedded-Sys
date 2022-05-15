.text
.global rotateMotor

.equ PORTD, 0x0B

.equ STEPPER_STATES_LENGTH, 8
.equ Orange1, 0
.equ Orange2, 1
.equ Yellow1, 2
.equ Yellow2, 3
.equ Pink1, 4 
.equ Pink2, 5
.equ Blue1, 6
.equ Blue2, 7

.equ STOP, 0
.equ CLOCKWISE, 1
.equ COUNTERCLOCKWISE, 2

; takes in 2 parameters, k = 2
; R24: current step motor state
; R23: the direction

rotateMotor:
    ; if direction is stop, do nothing
    cpi r23, STOP
    brne rotateMotor_rotate
    ret

rotateMotor_rotate: 
    ; if direction is clockwise, increment the current step motor state
    cpi r23, CLOCKWISE
    brsh nextStateRight

    cpi r23, 0
    brne skipResettingLeft

	ldi r23, STEPPER_STATES_LENGTH - 1
	rjmp getStateOutput

skipResettingLeft:
	dec r23
	rjmp getStateOutput

nextStateRight:
	cpi r23, STEPPER_STATES_LENGTH - 1
	brne skipResettingRight
	ldi r23, 0
	rjmp getStateOutput

skipResettingRight:
	inc r23

getStateOutput:
    ldi r18, 0 ; r18: next state port out value
    rjmp lookupTable
outputToPorts:    
    out PORTD, r18
    mov r24, r23
    ret

lookupTable:
ldi r18, 0b00000100
cpi r18, Orange1
breq outputToPorts

ldi r18, 0b00001100
cpi r18, Orange2
breq outputToPorts

ldi r18, 0b00001000
cpi r18, Yellow1
breq outputToPorts

ldi r18, 0b00011000
cpi r18, Yellow2
breq outputToPorts

ldi r18, 0b00010000
cpi r18, Pink1
breq outputToPorts

ldi r18, 0b00110000
cpi r18, Pink2
breq outputToPorts

ldi r18, 0b00100000
cpi r18, Blue1
breq outputToPorts

ldi r18, 0b00100100
cpi r18, Blue2
breq outputToPorts
