

RxTest:


	lrv RxTimeoutLimit, 2

rxt1:	call LcdClear
	call GetRxChannels

	b16ldi Temp, 0.1
	b16mul RxRoll, RxRoll, Temp
	b16mul RxPitch, RxPitch, Temp
	b16mul RxYaw, RxYaw, Temp
	b16mul RxAux, RxAux, Temp

	b16ldi Temp, 0.053
	b16mul RxThrottle, RxThrottle, Temp

	lrv PixelType, 1
	lrv FontSelector, f6x8

	lrv X1, 0
	lrv Y1, 0
	mPrintString rxt2
	rvbrflagtrue flagRollValid, rxt7
	mPrintString rxt8
	jmp rxt9
rxt7:	b16load RxRoll
	call Print16Signed 
	ldz -10
	cp  xl, zl
	cpc xh, zh
	brge rxt26
	lrv X1, 92
	mPrintString rxt19
rxt26:	ldz 10
	cp  xl, zl
	cpc xh, zh
	brlt rxt9
	lrv X1, 92
	mPrintString rxt20



rxt9:	lrv X1, 0
	lrv Y1, 9 * 1
	mPrintString rxt3
	rvbrflagtrue flagPitchValid, rxt10
	mPrintString rxt8
	jmp rxt11
rxt10:	b16load RxPitch
	call Print16Signed 
	ldz -10
	cp  xl, zl
	cpc xh, zh
	brge rxt27
	lrv X1, 86
	mPrintString rxt21
rxt27:	ldz 10
	cp  xl, zl
	cpc xh, zh
	brlt rxt11
	lrv X1, 92
	mPrintString rxt22


rxt11:	lrv X1, 0
	lrv Y1, 9 * 2
	mPrintString rxt4
	rvbrflagtrue flagThrottleValid, rxt12
	mPrintString rxt8
	jmp rxt13
rxt12:	b16load RxThrottle
	call Print16Signed 
	ldz 0
	cp  xl, zl
	cpc xh, zh
	brne rxt28
	lrv X1, 92
	mPrintString rxt25
rxt28:	ldz 90
	cp  xl, zl
	cpc xh, zh
	brlt rxt13
	lrv X1, 92
	mPrintString rxt29
	

rxt13:	lrv X1, 0
	lrv Y1, 9 * 3
	mPrintString rxt5
	rvbrflagtrue flagYawValid, rxt14
	mPrintString rxt8
	jmp rxt15
rxt14:	b16load RxYaw
	call Print16Signed 
	ldz -10
	cp  xl, zl
	cpc xh, zh
	brge rxt30
	lrv X1, 92
	mPrintString rxt20
rxt30:	ldz 10
	cp  xl, zl
	cpc xh, zh
	brlt rxt15
	lrv X1, 92
	mPrintString rxt19


rxt15:	lrv X1, 0
	lrv Y1, 9 * 4
	mPrintString rxt6
	rvbrflagtrue flagAuxValid, rxt16
	mPrintString rxt8
	jmp rxt17
rxt16:	b16load RxAux
	call Print16Signed 
	ldz -10
	cp  xl, zl
	cpc xh, zh
	brge rxt31
	lrv X1, 92
	mPrintString rxt33
rxt31:	ldz 10
	cp  xl, zl
	cpc xh, zh
	brlt rxt17
	lrv X1, 92
	mPrintString rxt32


rxt17:	lrv X1, 0
	lrv Y1, 57
	mPrintString rxt18

	call LcdUpdate

	ldi yh, 5
rxt34:	ldi yl, 0
	call wms
	dec yh
	brne rxt34
	
	call GetButtons
	cpi t, 0x08		;BACK?
	brne rxt35

	ret	

rxt35:	jmp rxt1



rxt2:	.db "Aileron  :",0,0
rxt3:	.db "Elevator :",0,0
rxt4:	.db "Throttle :",0,0
rxt5:	.db "Rudder   :",0,0
rxt6:	.db "Auxiliary:",0,0

rxt8:	.db " No signal",0,0

rxt18:	.db "BACK", 0,0

rxt19:	.db "Left",0,0
rxt20:	.db "Right",0
rxt21:	.db "Forward",0
rxt22:	.db "Back",0,0
rxt23:	.db "Up",0,0
rxt24:	.db "Down",0,0
rxt25:	.db "Idle",0,0
rxt29:	.db "Full",0,0
rxt32:	.db "On",0,0
rxt33:	.db "Off",0





