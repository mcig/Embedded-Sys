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

; takes in 2 parameters, k = 2
; R24: current step motor state
; R22: the direction
; RET: R24: next state
rotateMotor:
    ; if direction is stop, do nothing
    cpi r22, STOP
    brne rotateMotor_rotate
    ret

rotateMotor_rotate: 
    ; if direction is clockwise, increment the current step motor state
    cpi r22, CLOCKWISE
    breq nextStateRight

    cpi r24, 0
    brne skipResettingLeft

	ldi r24, STEPPER_STATES_LENGTH - 1
	rjmp getStateOutput

skipResettingLeft:
	dec r24
	rjmp getStateOutput

nextStateRight:
	cpi r24, STEPPER_STATES_LENGTH - 1
	brne skipResettingRight
	ldi r24, 0
	rjmp getStateOutput

skipResettingRight:
	inc r24

getStateOutput:
    ldi r18, 0b00100100 ; r18: next state port out value
    rjmp lookupTable
outputToPorts:    
    out PORTD, r18
    ; returns r24 which is next state
    ret

lookupTable:
    ldi r18, 0b00000100
    cpi r24, Orange1
    breq outputToPorts

    ldi r18, 0b00001100
    cpi r24, Orange2
    breq outputToPorts

    ldi r18, 0b00001000
    cpi r24, Yellow1
    breq outputToPorts

    ldi r18, 0b00011000
    cpi r24, Yellow2
    breq outputToPorts

    ldi r18, 0b00010000
    cpi r24, Pink1
    breq outputToPorts

    ldi r18, 0b00110000
    cpi r24, Pink2
    breq outputToPorts

    ldi r18, 0b00100000
    cpi r24, Blue1
    breq outputToPorts

    ldi r18, 0b00100100
    cpi r24, Blue2
    breq outputToPorts

    rjmp outputToPorts
