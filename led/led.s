.text
.global main
main:
    ldi r16, 0b00000101
    out 0x25, r16
    ldi r16, 0b00100000
    out 0x04, r16
    clr r18
loop:
    ldi r20, 11
    check_timer:
    in r17, 0x26
    cp r17, r18
    mov r18, r17
    brsh check_timer
decrement:
    dec r20
    brne check_timer
toggle:
    out 0x03, r16
    rjmp loop
