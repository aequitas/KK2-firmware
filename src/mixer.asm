
.equ	MixvalueThrottle	= 0
.equ	MixvalueRoll		= 1
.equ	MixvaluePitch		= 2
.equ	MixvalueYaw		= 3
.equ	MixvalueOffset		= 4
.equ	MixvalueVolume		= 5
.equ	MixvalueFlags		= 6


.equ	MixflagOn		= 0
.equ	MixflagIdle		= 1
.equ	MixflagLowrate		= 2



.def MixerThrottleL	= r2
.def MixerThrottleH	= r3

.def MixerRollL		= r4
.def MixerRollH		= r5
 
.def MixerPitchL	= r6
.def MixerPitchH	= r7

.def MixerYawL		= r8
.def MixerYawH		= r23


.def	MacAccL		= r17		;16.0bit signed
.def	MacAccH		= r18

.def	MacInput1L	= r19		;16.0bit signed
.def	MacInput1H	= r20

.def	MacInput2	= r21		;0.8bit signed

.def	Sign		= r22



.macro mac	

	;t = mixer value
	;@0 = precalculated command value low
	;@1 = precalculated command value high
	;@2 = precalculated command value sign

	lds Sign, @2
	eor Sign, t

	tst t
	brpl pc + 2

	neg t

	mul @0, t
	mov xl, r1

	mul @1, t
	add xl, r0
	clr xh
	adc xh, r1

	tst Sign
	brpl pc + 4

	sub MacAccL, xl
	sbc MacAccH, xh

	rjmp pc + 3

	add MacAccL, xl
	adc MacAccH, xh
	
	
.endmacro






Mixer:

	b16load RxThrottle		;get and precalc the command values
	lrv MixThrottleSign, 0
	mov MixerThrottleL, xl
	mov MixerThrottleH, xh

	b16load CommandRoll
	sts MixRollSign, xh
	call Xabs
	mov MixerRollL, xl
	mov MixerRollH, xh

	b16load CommandPitch
	sts MixPitchSign, xh
	call Xabs
	mov MixerPitchL, xl
	mov MixerPitchH, xh

	b16load CommandYaw
	sts MixYawSign, xh
	call Xabs
	mov MixerYawL, xl
	mov MixerYawH, xh







	ldi zh, high(RamMixerTable)		;page # to mixer values


	
			;mix channels



	ldi zl, low(RamMixerTable) + 0		
	rcall mix1	
	sts Out1L, MacAccL
	sts Out1H, MacAccH

	ldi zl, low(RamMixerTable) + 8		
	rcall mix1	
	sts Out2L, MacAccL
	sts Out2H, MacAccH

	ldi zl, low(RamMixerTable) + 16		
	rcall mix1	
	sts Out3L, MacAccL
	sts Out3H, MacAccH

	ldi zl, low(RamMixerTable) + 24		
	rcall mix1	
	sts Out4L, MacAccL
	sts Out4H, MacAccH

	ldi zl, low(RamMixerTable) + 32		
	rcall mix1	
	sts Out5L, MacAccL
	sts Out5H, MacAccH

	ldi zl, low(RamMixerTable) + 40		
	rcall mix1	
	sts Out6L, MacAccL
	sts Out6H, MacAccH

	ldi zl, low(RamMixerTable) + 48		
	rcall mix1	
	sts Out7L, MacAccL
	sts Out7H, MacAccH

	ldi zl, low(RamMixerTable) + 56		
	rcall mix1	
	sts Out8L, MacAccL
	sts Out8H, MacAccH

	ret




mix1:	ldd MacAccL, Z + MixvalueOffset			;mix channel
	ldi MacAcch, 0

	ldd t, Z + MixvalueThrottle
	mac MixerThrottleL, MixerThrottleH, MixThrottleSign

	ldd t, Z + MixvalueRoll
	mac MixerRollL, MixerRollH, MixRollSign

	ldd t, Z + MixvaluePitch
	mac MixerPitchL, MixerPitchH, MixPitchSign

	ldd t, Z + MixvalueYaw
	mac MixerYawL, MixerYawH, MixYawSign

	ret




.undef MixerThrottleL
.undef MixerThrottleH

.undef MixerRollL
.undef MixerRollH
 
.undef MixerPitchL
.undef MixerPitchH

.undef MixerYawL
.undef MixerYawH

.undef	MacAccL
.undef	MacAccH

.undef	MacInput1L
.undef	MacInput1H

.undef	MacInput2

.undef	Sign


