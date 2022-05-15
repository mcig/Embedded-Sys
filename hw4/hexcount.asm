.text 
.global main
; Digital IO Regs
.EQU PORTB, 0x03   		
.EQU DDRB, 0x04

.EQU PORTD, 0x0B   		
.EQU DDRD, 0x0A
.EQU DDRC,  0x07       

; Analog 2 Digital Converter Regs
.EQU ADCL,  0x0078
.EQU ADCH,  0x0079
.EQU ADCSRA,0x007A
.EQU ADMUX, 0x007C   
.EQU ADSC,  6

; EEPROM Read/Write Regs
.EQU EECR, 0x1F
.EQU EEDR, 0x20
.EQU EEARL,  0x21
.EQU EEARH,  0x22
.EQU EERE, 0
.EQU EEWE, 1
.EQU EEMWE, 2

; EEPROM Read/Write Address
.EQU EEPROM_LOW_ADDRESS, 0x3A
.EQU EEPROM_HIGH_ADDRESS, 0x01

main:
	; Digital IO Inits
    LDI R16, 0B00011100
	OUT DDRD, R16
	
    LDI R16, 0B00001111
	OUT DDRB, R16
	
	; Analog IO Inits
  	LDI R16, 0B00000000
  	OUT DDRC, R16

    LDI R16, 0B10000111
  	STS ADCSRA, R16
	
	; EEPROM GPRs
	LDI R27, EEPROM_LOW_ADDRESS
	LDI R28, EEPROM_HIGH_ADDRESS

	; Delay Registers
	ldi r29, 100
	ldi r30, 150
	ldi r31, 200
	; end delay registers
	
	; read start value from eeprom
POLL_EEPROM_READ:
	SBIC EECR, EEWE
	RJMP POLL_EEPROM_READ
	
	OUT EEARL, R27
	OUT EEARH, R28
	SBI EECR, EERE
	IN R18, EEDR

MAIN_LOOP:
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

	; Switch for selecting output values
GET_OUT_VALUES_FROM_R18:
	LDI R19, 0b00011100
	LDI R20, 0b00001110
	CPI R18, 0
	BREQ GOT_VALUES

	LDI R19, 0b00010000
	LDI R20, 0b00001000
	CPI R18, 1
	BREQ GOT_VALUES

	LDI R19, 0b00001100
	LDI R20, 0b00001101
	CPI R18, 2
	BREQ GOT_VALUES

	LDI R19, 0b00011000
	LDI R20, 0b00001101
	CPI R18, 3
	BREQ GOT_VALUES

	LDI R19, 0b00010000
	LDI R20, 0b00001011
	CPI R18, 4
	BREQ GOT_VALUES

	LDI R19, 0b00011000
	LDI R20, 0b00000111
	CPI R18, 5
	BREQ GOT_VALUES

	LDI R19, 0b00011100
	LDI R20, 0b00000111
	CPI R18, 6
	BREQ GOT_VALUES

	LDI R19, 0b00010000
	LDI R20, 0b00001100
	CPI R18, 7
	BREQ GOT_VALUES

	LDI R19, 0b00011100
	LDI R20, 0b00001111
	CPI R18, 8
	BREQ GOT_VALUES

	LDI R19, 0b00010000
	LDI R20, 0b00001111
	CPI R18, 9
	BREQ GOT_VALUES

	LDI R19, 0b00010100
	LDI R20, 0b00001111
	CPI R18, 10
	BREQ GOT_VALUES

	LDI R19, 0b00011100
	LDI R20, 0b00000011
	CPI R18, 11
	BREQ GOT_VALUES

	LDI R19, 0b00001100
	LDI R20, 0b00000110
	CPI R18, 12
	BREQ GOT_VALUES

	LDI R19, 0b00011100
	LDI R20, 0b00001001
	CPI R18, 13
	BREQ GOT_VALUES

	LDI R19, 0b00001100
	LDI R20, 0b00000111
	CPI R18, 14
	BREQ GOT_VALUES

	LDI R19, 0b00000100
	LDI R20, 0b00000111
	CPI R18, 15
	BREQ GOT_VALUES

GOT_VALUES:
	CPI R17, 2
	BRSH COUNT_FORWARDS

	CPI R18, 0
	BRNE SKIP_RESET_DEC
	LDI R18, 15
	RJMP OUTPUT_VALUES
SKIP_RESET_DEC:
	dec r18
	RJMP OUTPUT_VALUES

COUNT_FORWARDS:
	CPI R18, 15
	BRNE SKIP_RESET_INC
	LDI R18, 0
	RJMP OUTPUT_VALUES
SKIP_RESET_INC:
	inc r18

OUTPUT_VALUES:
	OUT PORTD, R19
	OUT PORTB, R20

	LONG_DELAY:
	dec r31
	brne LONG_DELAY
	dec r30
	brne LONG_DELAY
	dec r29
	brne LONG_DELAY
	
	OUT PORTD, R19
	OUT PORTB, R20

EEPROM_WRITE_POLL:
	SBIC EECR, EEWE
	RJMP EEPROM_WRITE_POLL

	OUT EEARL, R27
	OUT EEARH, R28

	OUT EEDR, R18

	SBI EECR, EEMWE
	SBI EECR, EEWE

	rjmp MAIN_LOOP
	