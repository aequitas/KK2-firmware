


DebugMeny:

bbb30:	call LcdClear
	
	lrv PixelType, 1
	lrv FontSelector, f6x8

	lrv X1, 0	
	lrv Y1, 0
	mPrintString ttt1
	b16load GyroRollZero
	call Print16Signed 

	lrv X1, 0	
	rvadd Y1, 8 
	mPrintString ttt2
	b16load GyroPitchZero
	call Print16Signed 

	lrv X1, 0	
	rvadd Y1, 8 
	mPrintString ttt3
	b16load GyroYawZero
	call Print16Signed 

	lrv X1, 0	
	rvadd Y1, 8 
	mPrintString ttt4
	b16load AccXZero
	call Print16Signed 

	lrv X1, 0	
	rvadd Y1, 8 
	mPrintString ttt5
	b16load AccYZero
	call Print16Signed 

	lrv X1, 0	
	rvadd Y1, 8 
	mPrintString ttt6
	b16load AccZZero
	call Print16Signed 

	lrv X1, 0	
	rvadd Y1, 8 
	mPrintString ttt7
	b16load EscLowLimit
	call Print16Signed 

	lrv X1, 0	
	rvadd Y1, 8 
	mPrintString ttt8
	b16load BattAlarmVoltage
	call Print16Signed 

	call LcdUpdate

	call GetButtonsBlocking

	call LcdClear


	lrv X1, 0	
	lrv Y1, 0
	mPrintString ttt9
	b16ldi Temp, 100
	b16mul Temp, Temp, ServoFilter
	b16load Temp
	call Print16Signed 

	lrv X1, 0	
	rvadd Y1, 8 
	mPrintString ttt10
	b16load Temp
	call Print16Signed 

	lrv X1, 0	
	rvadd Y1, 8 
	mPrintString ttt11
	b16load Temp
	call Print16Signed 

	lrv X1, 0	
	rvadd Y1, 8 
	mPrintString ttt12
	b16load Temp
	call Print16Signed 

	lrv X1, 0	
	rvadd Y1, 8 
	mPrintString ttt13
	b16load GyroAngleRoll
	call Print16Signed 

	lrv X1, 0	
	rvadd Y1, 8 
	mPrintString ttt14
	b16load GyroAnglePitch
	call Print16Signed 

	lrv X1, 0	
	rvadd Y1, 8 
	mPrintString ttt15
	b16load BatteryVoltage
	call Print16Signed 

	lrv X1, 0	
	rvadd Y1, 8 
	mPrintString ttt
	b16load temp
	call Print16Signed 


	call LcdUpdate

	call GetButtonsBlocking

	ret



ttt1:	.db "GyroRollZero: ",0,0
ttt2:	.db "GyroPitchZero: ",0
ttt3:	.db "GyroYawZero: ",0
ttt4:	.db "AccXZero: ",0,0
ttt5:	.db "AccYZero: ",0,0
ttt6:	.db "AccZZero: ",0,0
ttt7:	.db "EscLowLimit: ",0
ttt8:	.db "BattAlarmVoltage:",0

ttt9:	.db "ServoFilter: ",0
ttt10:	.db "Unused: ",0,0
ttt11:	.db "Unused: ",0,0
ttt12:	.db "Unused: ",0,0
ttt13:	.db "AngleRoll: ",0
ttt14:	.db "AnglePitch: ",0,0
ttt15:	.db "BatteryVoltage:",0


ttt:	.db "unused",0,0


/*


debugCU:


	b16ldi Temp, -1
	b16mul Temp, Debug5, Temp
	b16ldi Temper, 2220
	b16add Out5, Temper, Temp

	b16ldi Temp, -10
	b16mul Temp, Debug6, Temp
	b16ldi Temper, 2220
	b16add Out6, Temper, Temp


	b16ldi Temp, -1
	b16mul Temp, Debug7, Temp
	b16ldi Temper, 2220
	b16add Out7, Temper, Temp

	b16ldi Temp, -1
	b16mul Temp, Debug8, Temp
	b16ldi Temper, 2220
	b16add Out8, Temper, Temp

	ret






DebugPwm:
	push t
	sbi OutputPin8
deb3:	sbci t,1
	brcc deb3
	cbi OutputPin8
	pop t
	ret


DebugPwm16_200: 	;FS is 200uS
	push xl
	push xh
	ldi t, low(32768)
	add xl, t
	ldi t, high(32768)
	adc xh, t

	ldi t, 6
deb5:	lsr xh
	ror xl
	dec t
	brne deb5

	sbi OutputPin7
deb4:	sbiw x,1
	brcc deb4
	cbi OutputPin7
	pop xh
	pop xl
	ret


;DebugPwm16: 	;
	push xl
	push xh
	ldi t, low(1000)
	add xl, t
	ldi t, high(1000)
	adc xh, t


	sbi OutputPin8
deb6:	sbiw x,1
	brcc deb6
	cbi OutputPin8
	pop xh
	pop xl
	ret





;Dump:
			
	call LcdClear

	lrv PixelType, 1
	lrv FontSelector, f6x8

	lrv X1, 0
	lrv Y1, 0

	mPrintString deb1
	

	lrv X1, 0
	lrv Y1, 10

	call print16signed


	call LcdUpdate


	ret
	rjmp pc



deb1:	.db "DEBUG:",0,0






;TimeStart:
	cli
	load xl, tcnt1l	
	load xh, tcnt1h
	sei

	sts TimeStampL, xl
	sts TimeStampH, xh
	
	ret
	
;TimeEnd:
	cli
	load xl, tcnt1l	
	load xh, tcnt1h
	sei
	
	lds yl, TimeStampL
	lds yh, TimeStampH

	sub xl, yl
	sbc xh, yh

	brpl tim1

	com xl
	com xh
	ldi t, 1
	add xl, t
	clr t
	adc xh, t

tim1:	ldy 2500
	cp  xl, yl
	cpc xh, yh
	brlo tim2

;	jmp dump

tim2:	ret






	;--- Debug: Output byte Templ (ASCII) to serial port pin at 115200 8N1 ----

SerByteAsciiOut:


	push xl
	swap xl
	rcall su1		;high nibble
	pop xl
	rjmp su1		;low nibble

su1:	andi xl,0x0f
	ldi zl,low(su2*2)	;output one nibble in ASCII
	add zl,xl
	ldi zh,high(su2*2)
	clr xl
	adc zh,xl
	lpm xl,z
	rjmp SerByteOut

su2:	.db "0123456789ABCDEF"


		
SerOut16:
	push xh
	push xl

	mov xl, xh
	rcall SerByteAsciiOut
	pop xl
	push xl
	rcall SerByteAsciiOut

	pop xl
	pop xh
	ret



	


	;--- Debug: Output byte xl (binary) to serial port pin at 28800 8N1 ----

SerByteOut:
	cbi OutputPin8		;startbit
	nop
	nop
	nop

	rcall BaudRateDelay	

	ldi xh,8		;databits

sa3:	ror xl

	brcc sa1
	nop
	sbi OutputPin8
	rjmp sa2
sa1:	cbi OutputPin8
	nop
	nop

sa2:	rcall BaudRateDelay

	dec xh
	brne sa3

	nop
	nop
	nop
	nop

	sbi OutputPin8			;stopbit
	nop 
	nop
	nop
	rcall BaudRateDelay

	ret

BaudRatedelay:

	ldi t,231		;this delay may need tweaking to give errorfree transfer
ba1:	dec t
	brne ba1
	ret


*/
