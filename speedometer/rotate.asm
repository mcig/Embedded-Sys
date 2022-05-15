.text
.global rotate
rotate:
.equ PORTD, 0x0B

ldi r16, 0b00000100
out PORTD, r16
rcall MYDELAY

ldi r16, 0b00001100
out PORTD, r16
rcall MYDELAY

ldi r16, 0b00001000
out PORTD, r16
rcall MYDELAY

ldi r16, 0b00011000
out PORTD, r16
rcall MYDELAY

ldi r16, 0b00010000
out PORTD, r16
rcall MYDELAY

ldi r16, 0b00110000
out PORTD, r16
rcall MYDELAY

ldi r16, 0b00100000
out PORTD, r16
rcall MYDELAY

ldi r16, 0b00100100
out PORTD, r16
rcall MYDELAY
