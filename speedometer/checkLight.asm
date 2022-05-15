.text 
.global checkLight

; Analog 2 Digital Converter Regs
.EQU ADCL,  0x0078
.EQU ADCH,  0x0079
.EQU ADCSRA,0x007A
.EQU ADMUX, 0x007C   
.EQU ADSC,  6

checkLight:
	; Analog IO Inits
  	LDI R16, 0B00000000
  	OUT DDRC, R16

    LDI R16, 0B10000111
  	STS ADCSRA, R16

	; Analog2Digital Staff 
 	LDI R16, 0B01000100
  	STS ADMUX, R16

	LDS R16, ADCSRA
    ORI R16, 0x40
    STS ADCSRA, R16

POLL_ANALOG_READ:
	LDS R16, ADCSRA
	SBRC R16, ADSC
    RJMP POLL_ANALOG_READ

    LDS R17, ADCH
	; end Analog2Digital staff