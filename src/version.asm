
ShowVersion:
	call LcdClear
	
	lrv PixelType, 1
	lrv FontSelector, f6x8

	lrv X1, 0
	lrv Y1, 10
	mPrintString sho1

	lrv X1, 0
	lrv Y1, 19
	mPrintString sho2

	call LcdUpdate

	ldx 1000
	call WaitXms

	ret

	


sho1:	.db "Version 1.1",0
sho2:	.db "By Rolf Runar Bakke",0
