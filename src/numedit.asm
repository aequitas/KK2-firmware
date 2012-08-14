.def 	TypRate = r17
.def	Counter = r18

NumberEdit:

	PushAll

	ldi TypRate, 1

	;print new footer
	
	lrv PixelType, 2
	lrv FontSelector, f6x8

	lrv X1,0
	lrv Y1,56
	lrv X2,127
	lrv Y2,64
	call HilightRectangle

	lrv PixelType, 1
	lrv X1, 0
	lrv Y1, 57
	mPrintString num1


	;make window

.equ	wx1 = 30
.equ	wy1 = 19
.equ	wx2 = 98
.equ	wy2 = 42

num2:	lrv X1,wx1
	lrv Y1,wy1
	lrv X2,wx2
	lrv Y2,wy2
	lrv PixelType, 2
	call HilightRectangle
	lrv X1,wx1
	lrv Y1,wy1
	lrv X2,wx2
	lrv Y2,wy2
	lrv PixelType, 1
	call Rectangle
	lrv X1,wx1+1
	lrv Y1,wy1+1
	lrv X2,wx2-1
	lrv Y2,wy2-1
	call Rectangle
	
	;print number

	lrv X1, 34
	lrv Y1, 24
	lrv FontSelector, f12x16
	call Print16Signed

	call LcdUpdate
	
	ldi Counter, 30
num3:	call GetButtons		;wait until button relesaed or time out
	cpi t, 0
	breq num4
	dec Counter
	brne num3

num4:	cpi t, 0
	brne num11
	ldi TypRate,1
num11:

	call GetButtons		;wait until button pressed
	cpi t, 0x00
	breq num4

	call Beep

	cpi t,0x08		;CLR
	brne num5
	ldx 0
	rjmp num2

num5:	cpi t,0x04		;DOWN
	brne num7
	sub xl, TypRate
	clr t
	sbc xh, t
	cp xl, yl
	cpc xh, yh
	brge num6
	movw X, Y
num6:	inc TypRate
	cpi TypRate, 255
	brlo num12
	ldi TypRate, 255
num12:	rjmp num2

num7:	cpi t,0x02		;UP
	brne num9
	add xl, TypRate
	clr t
	adc xh, t
	cp xl, zl
	cpc xh, zh
	brlt num8
	movw X, Z
num8:	rjmp num6

num9:	cpi t,0x01		;DONE
	brne num10
	mov r0, xl
	mov r1, xh	

	PopAll
	ret

num10:	rjmp num2

.undef TypRate
.undef Counter


num1:	.db"CLR  DOWN   UP   DONE", 0
