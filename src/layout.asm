
.def	Item=r4
.def	Output=r5
.def	flagShowAll=r6
.def	flagUnused=r7
.def	Counter=r8

.set xoff = 96
.set yoff = 32


MotorLayOut:

	clr Item

mot1:	call LcdClear

	
	lrv X1, 0
	lrv Y1, 0
	lrv FontSelector, f6x8
	lrv PixelType, 1
	mPrintString mot11

	tst Item		;item == ALL?
	brne mot13
	
	mPrintString mot12	;Yes, print "ALL"
	
	setflagtrue flagShowAll
	
	ldi t,8			;show all 8 outputs
	mov Counter, t
	clr Output
mot14:	call ShowMotor
	inc OutPut		 
	dec Counter
	tst Counter
	brne mot14
	rjmp mot15


mot13:	mov OutPut, Item	;No, show single motor.
	dec OutPut

	mov xl, Item
	clr xh
	call Print16Signed

	setflagfalse flagShowAll

	call ShowMotor



mot15:	lrv FontSelector, f6x8 	;footer
	lrv PixelType, 1
	lrv X1, 0
	lrv Y1, 57
	mPrintString mot21



	call LcdUpdate


	call GetButtonsBlocking

	cpi t, 0x08		;BACK?
	brne mot22
	ret			;Yes, return

mot22:	cpi t, 0x04		;NEXT?
	brne mot23
	inc Item
	ldi t, 9
	cp Item, t
	brne mot25
	clr Item
mot25:	rjmp mot1


mot23:	cpi t, 0x02		;PREV?
	brne mot24
	dec Item
	tst Item
	brpl mot26
	ldi t, 8
	mov Item, t
mot26:	rjmp mot1	

mot24:	rjmp mot1


ShowMotor:
	ldzarray RamMixerTable, 8, Output

	lrv PixelType, 1

	setflagtrue flagUnused	


	
	clr yh
	ldd xl, Z + MixvalueRoll
	clr xh
	tst xl		;extend sign
	brpl mot2
	ser yh
	ser xh

mot2:	b16store Mixvalue
	b16clr Temp
	b16cmp Mixvalue, Temp
	breq mot3
	setflagfalse flagUnused

mot3:	b16ldi Temp, 0.25
	b16mul Mixvalue, Mixvalue, Temp
	b16ldi Temp, xoff
	b16add Mixvalue, Mixvalue, Temp
	b16load Mixvalue
	sts X1, xl



	clr yh
	ldd xl, Z + MixvaluePitch
	clr xh
	tst xl		;extend sign
	brpl mot4
	ser yh
	ser xh

mot4:	b16store Mixvalue
	b16clr Temp
	b16cmp Mixvalue, Temp
	breq mot5
	setflagfalse flagUnused

mot5:	b16ldi Temp, -0.25
	b16mul Mixvalue, Mixvalue, Temp
	b16ldi Temp, yoff
	b16add Mixvalue, Mixvalue, Temp
	b16load Mixvalue
	sts Y1, xl





	clr yh
	ldd xl, Z + MixvalueThrottle
	clr xh
	tst xl		;extend sign
	brpl mot16
	ser yh
	ser xh

mot16:	b16store Mixvalue
	b16clr Temp
	b16cmp Mixvalue, Temp
	breq mot20
	setflagfalse flagUnused

mot20:



	ldd xl, Z + MixvalueYaw

	tst xl
	breq mot6
	setflagfalse flagUnused


mot6:	brflagfalse flagUnused, mot7	;Output unused?

	brflagfalse flagShowAll, mot8   ;Yes, ShowAll true?
	ret				; Yes, skip drawing and return

mot8:	lrv X1, 66			; No, Print 'Not used' and return
	lrv Y1, 27
	mPrintString mot9
	ret

mot7:	ldd xl, Z + MixvalueFlags	;No, Motor or servo Output?
	sbrc xl, bMixerFlagType
	rjmp mot17

	brflagtrue flagShowAll, mot18	;servo, ShowAll false?
	lrv X1, 66			;Yes, print "servo" and return
	lrv Y1, 27
	mPrintString mot19

mot18:	ret
	

mot17:	lrv X2, xoff			;Motor
	lrv Y2, yoff

	call Bresenham			;draw line

	rvsub X1, 4			;print symbol
	rvsub Y1, 7
	lrv FontSelector, s16x16
	ldi t, 4
	ldd xl, Z + MixvalueYaw
	tst xl 
	brmi mot10
	ldi t, 5
mot10:	call PrintChar
	
	rvsub X1, 14			;print motor number in symbol
	rvadd Y1, 5
	lrv FontSelector, f4x6
	lrv PixelType, 0
	mov t, Output
	call PrintChar


	brflagfalse flagShowAll, mot35	;Print CW or CCW if flagShowAll is false
	rjmp mot27
mot35:	lrv FontSelector, f6x8 
	lrv PixelType, 1
	lrv X1, 0
	lrv Y1, 15
	mPrintString mot31
	lrv X1, 0
	lrv Y1, 24
	mPrintString mot32
	lrv X1, 0
	lrv Y1, 33
	mPrintString mot33
	lrv X1, 0
	lrv Y1, 42
	ldd xl, Z + MixvalueYaw
	tst xl 
	brmi mot30
	mPrintString mot28
	rjmp mot27
mot30:	mPrintString mot29
mot27:	ret



mot9:	.db "Unused.", 0

mot11:	.db "Motor: ", 0
mot12:	.db "ALL", 0

mot19:	.db "Servo.", 0, 0

mot21:	.db "BACK  NEXT",0,0

mot28:	.db "CW", 0, 0
mot29:	.db "CCW", 0

mot31:	.db "Direction",0
mot32:	.db "seen from",0
mot33:	.db "above:",0, 0


.undef	Item
.undef	Output
.undef	flagShowAll
.undef	flagUnused
.undef	Counter

