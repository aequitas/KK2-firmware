
.equ f4x6	= 0
.equ f6x8	= 1
.equ f8x12	= 2
.equ f12x16	= 3
.equ s16x16	= 4


.equ	MixvalueThrottle	= 0
.equ	MixvalueRoll		= 1
.equ	MixvaluePitch		= 2
.equ	MixvalueYaw		= 3
.equ	MixvalueOffset		= 4
.equ	MixvalueFlags		= 5

.equ	bMixerFlagType		= 0	;1 = ESC  0 = servo
.equ	fEsc			= 1
.equ	fServo			= 0

.equ	bMixerFlagRate		= 1	;1 = high 0 = low
.equ	fHigh			= 1
.equ	fLow			= 0


.equ GyroLowLimit = 500		;limits for sensor testing
.equ GyroHighLimit = 630

.equ AccLowLimit = 450
.equ AccHighLimit = 850

