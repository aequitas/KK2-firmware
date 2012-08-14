
.def Item		= r17



SettingsC:

sux11:	call LcdClear
	
	lrv PixelType, 1
	lrv FontSelector, f6x8

	lrv X1,0		;self level
	lrv Y1,1
	mPrintString sux1
	ldz eeSelfLevelType
	call GetEeVariable8 
	brflagfalse xl, sux18
	mPrintString sux16
	rjmp sux19
sux18:	mPrintString sux17
sux19:
	lrv X1,0		;Arming
	lrv Y1,10
	mPrintString sux3
	call GetEeVariable8 
	brflagfalse xl, sux25
	mPrintString sux16
	rjmp sux27
sux25:	mPrintString sux15
sux27:
	lrv X1,0		;Link Roll Pitch
	lrv Y1,19
	mPrintString sux4
	call GetEeVariable8 
	brflagfalse xl, sux30
	mPrintString sux28
	rjmp sux32
sux30:	mPrintString sux29
sux32:

	lrv X1,0		;Auto disarm
	lrv Y1,28
	mPrintString sux5
	call GetEeVariable8 
	brflagfalse xl, sux33
	mPrintString sux28
	rjmp sux34
sux33:	mPrintString sux29
sux34:

	lrv X1,0		;CPPM
	lrv Y1,37
	mPrintString sux35
	call GetEeVariable8 
	brflagfalse xl, sux36
	mPrintString sux28
	rjmp sux37
sux36:	mPrintString sux29
sux37:




	;footer
	lrv X1, 0
	lrv Y1, 57
	mPrintString sux6

	;print selector
	ldzarray sux7*2, 4, Item
	lpm t, z+
	sts X1, t
	lpm t, z+
	sts Y1, t
	lpm t, z+
	sts X2, t
	lpm t, z
	sts Y2, t
	lrv PixelType, 0
	call HilightRectangle

	call LcdUpdate

	call GetButtonsBlocking

	cpi t, 0x08		;BACK?
	brne sux8
	ret	

sux8:	cpi t, 0x04		;PREV?
	brne sux9	
	dec Item
	brpl sux10
	ldi Item, 4
sux10:	rjmp sux11	

sux9:	cpi t, 0x02		;NEXT?
	brne sux12
	inc Item
	cpi item, 5
	brne sux13
	ldi Item, 0
sux13:	rjmp sux11	

sux12:	cpi t, 0x01		;CHANGE?
	brne sux14

	ldzarray eeSelfLevelType, 1, Item	;toggle flag
	call GetEeVariable8
	ldi t, 0x80
	eor xl, t
	ldzarray eeSelfLevelType, 1, Item
	call StoreEeVariable8

sux14:	rjmp sux11




sux1:	.db "Self-Level  : ", 0, 0
sux3:	.db "Arming      : ", 0, 0
sux4:	.db "Link Roll Pitch: ", 0
sux5:	.db "Auto Disarm : ", 0, 0
sux35:	.db "CPPM Enabled: ", 0, 0
sux6:	.db "BACK PREV NEXT CHANGE", 0
sux15:	.db "On",0, 0
sux16:	.db "Stick",0
sux17:	.db "AUX",0
sux28:	.db "Yes",0
sux29:	.db "No",0,0



sux7:	.db 83, 0, 114, 9
	.db 83, 9, 114, 18
	.db 100, 18, 122, 27
	.db 83, 27, 104, 36
	.db 83, 36, 104, 45


.undef Item

