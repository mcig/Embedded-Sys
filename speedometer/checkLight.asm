.text 
.global checkLight

.EQU DDRC,  0x07       

; Analog 2 Digital Converter Regs
.EQU ADCL,  0x0078
.EQU ADCH,  0x0079
.EQU ADCSRA,0x007A
.EQU ADMUX, 0x007C   
.EQU ADSC,  6

.equ STOP, 0
.equ CLOCKWISE, 1
.equ COUNTERCLOCKWISE, 2

; Parameters: None
; Return integer: light Value

checkLight:
	; Analog IO Inits
  	LDI r18, 0B00000000
  	OUT DDRC, r18

    LDI r18, 0B10000111
  	STS ADCSRA, r18

	; Analog2Digital Staff 
 	LDI r18, 0B01000010
  	STS ADMUX, r18

	LDS r18, ADCSRA
    ORI r18, 0x40
    STS ADCSRA, r18

POLL_ANALOG_READ:
	LDS r18, ADCSRA
	SBRC r18, ADSC
    RJMP POLL_ANALOG_READ

    LDS r24, ADCL ; maxVal 0xFF
    LDS r25, ADCH ; maxVal 0x03

	ret
