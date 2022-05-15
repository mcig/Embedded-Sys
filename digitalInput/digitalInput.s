.text
.global main

main:
    .equ PIND, 0x09
    .equ DDRD, 0x0A
    .equ PORTD, 0x0B

    ldi r16, 0b00001000
    out DDRD, r16
    out PORTD, r16
    
myloop:
    mov r18, r17 ; keep previously read value
    nop
    in r17, PIND
    nop
    andi r17, 0b00000100
    lsr r17
    lsr r17

    cpi r18, 0b00000000 ; if previosly button is not pressed, return
    breq myloop

    cpi r17, 0b00000001 ; if now button is pressed, return
    breq myloop

    ; if button goes from 1 to 0, toggle LED

toggle: 
    ldi r19, 0xFF ; eor reg
    eor r16, r19
    out PORTD, r16
    rjmp myloop
