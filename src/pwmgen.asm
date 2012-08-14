


PwmStart:

	;set OCR1A to current time + 0.5ms

	cli
	load xl, tcnt1l	
	load xh, tcnt1h
	sei

	ldi t, low(1250)
	add xl, t
	ldi t, high(1250)
	adc xh, t

	cli
	store ocr1ah, xh
	store ocr1al, xl
	sei

	;set OCR1B to current time + 1.5ms

	ldi t, low(2500)
	add xl, t
	ldi t, high(2500)
	adc xh, t

	cli
	store ocr1bh, xh
	store ocr1bl, xl
	sei


	;turn on OC1a and b interrupt

	;       76543210
	ldi t,0b00000110
	store timsk1, t


	rvsetflagfalse flagPwmEnd


	ret



IsrPwmStart:
	;Generate the rising edge of servo/esc pulses

	load SregSaver, sreg

	lds tt, flagMutePwm
	tst tt
	brmi pwmexit

	sec
	
	lds tt, OutputRateDividerCounter
	dec tt
	brne pwm1
	
		lds tt, OutputRateDivider
		clc	

pwm1:	sts OutputRateDividerCounter, tt
	
	ldi tt, 0xff			;bit pattern for fast and slow update rate
	brcc pwm2
	lds tt, OutputRateBitmask	;bit pattern for fast update rate

pwm2:	lsr tt				;stagger the pin switching to avoid up to 8 pins switching at the same time
	brcc pwm3
	sbi OutputPin1
pwm3:	lsr tt
	brcc pwm4
	sbi OutputPin2
pwm4:	lsr tt
	brcc pwm5
	sbi OutputPin3
pwm5:	lsr tt
	brcc pwm6
	sbi OutputPin4
pwm6:	lsr tt
	brcc pwm7
	sbi OutputPin5
pwm7:	lsr tt
	brcc pwm8
	sbi OutputPin6
pwm8:	lsr tt
	brcc pwm9
	sbi OutputPin7
pwm9:	lsr tt
	brcc pwm12
	sbi OutputPin8 ;<---OBS DEBUG
pwm12:	 

pwmexit:store sreg, SregSaver
	reti





IsrPwmEnd:
	ldi tt, 0xff
	sts flagPwmEnd, tt
	reti





PwmEnd:	b16ldi Temp, 888		;make sure the EscLowLimit is not too high. (hardcoded limit of 20%)
	b16cmp EscLowLimit, Temp
	brlt pwm58
	b16mov EscLowLimit, Temp
pwm58:

	;loop setup

	lrv Index, 0		
	 
	lds t, OutputTypeBitmask
	sts OutputTypeBitmaskCopy, t

	rvflagnot flagInactive, flagArmed	;flagInactive is set to true if outputs should be in inactive state
	rvflagor flagInactive, flagInactive, flagThrottleZero
	
	;loop body

pwm50:	b16load_array PwmOutput, Out1


	lds t, OutputTypeBitmaskCopy		;ESC or SERVO?
	lsr t
	sts OutputTypeBitmaskCopy, t
	brcc pwm51fix
	rjmp pwm51
pwm51fix:

	;---

	rvbrflagfalse flagInactive, pwm52fix	;SERVO, active or inactive?
	rjmp pwm52
pwm52fix:
	b16load_array Temp, FilteredOut1 	;servo active, apply low pass filter
	b16sub Error, PwmOutput, Temp
	
	b16mul Error, Error, ServoFilter

	b16add PwmOutput, Temp, Error
	b16store_array FilteredOut1, PwmOutput
	
	rjmp pwm55

pwm52:	b16load_array PwmOutput, Offset1	;servo inactive, set to offset value
	rjmp pwm55

	;---

pwm51:	rvbrflagtrue flagInactive, pwm54	;ESC, active or inactive?

	b16cmp PwmOutput, EscLowLimit		;ESC active, limit to EscLowLimit
	brge pwm56
	b16mov PwmOutput, EscLowLimit
pwm56:
	rjmp pwm55

pwm54:	b16clr PwmOutput			;ESC inactive, set to zero 

	;---

pwm55:	b16store_array Out1, PwmOutput


	;loop looper

	rvinc Index
	rvcpi Index, 8
	breq pwm57
	rjmp pwm50
pwm57:



.def O1L=r0
.def O1H=r1
.def O2L=r2
.def O2H=r3
.def O3L=r4
.def O3H=r5
.def O4L=r6
.def O4H=r7
.def O5L=r8
.def O5H=r17
.def O6L=r18
.def O6H=r19
.def O7L=r20
.def O7H=r21
.def O8L=r22
.def O8H=r23
	
	
	;this part transfers and conditions the OutN values to the 16bit registers ONH:ONL


;call DebugCU



	b16load Out1
	rcall pwmcond
	mov O1L, xl
	mov O1H, xh

	b16load Out2
	rcall pwmcond
	mov O2L, xl
	mov O2H, xh

	b16load Out3
	rcall pwmcond
	mov O3L, xl
	mov O3H, xh

	b16load Out4
	rcall pwmcond
	mov O4L, xl
	mov O4H, xh

	b16load Out5
	rcall pwmcond
	mov O5L, xl
	mov O5H, xh

	b16load Out6
	rcall pwmcond
	mov O6L, xl
	mov O6H, xh

	b16load Out7
	rcall pwmcond
	mov O7L, xl
	mov O7H, xh

	b16load Out8
	rcall pwmcond
	mov O8L, xl
	mov O8H, xh
		

;cbi OutputPin8		;OBS DEBUG


	;generate the end of the PWM signal, this part is blocking.

	rvbrflagfalse flagPwmEnd, pwm29
	ldi t, 0				;if IsrPwmEnd is true here, the start of PWM pulse end generation is missed
;	call LogError				;log error
	ret					;and return without generating the end of pwm pulse

pwm29:	rvbrflagfalse flagPwmEnd, pwm29		;wait until IsrPwmEnd has run (flagPwmEnd == true)





	ldx 1		;generate the last 0 to 1ms part of the pwm signal
		
	ldy 560
	
pwm13:	sub O1L, xl
	sbc O1H, xh
	brcc pwm14
	cbi OutputPin1
pwm14:	sub O2L, xl
	sbc O2H, xh
	brcc pwm15
	cbi OutputPin2
pwm15:	sub O3L, xl
	sbc O3H, xh
	brcc pwm16
	cbi OutputPin3
pwm16:	sub O4L, xl
	sbc O4H, xh
	brcc pwm17
	cbi OutputPin4
pwm17:	sub O5L, xl
	sbc O5H, xh
	brcc pwm18
	cbi OutputPin5
pwm18:	sub O6L, xl
	sbc O6H, xh
	brcc pwm19
	cbi OutputPin6
pwm19:	sub O7L, xl
	sbc O7H, xh
	brcc pwm20
	cbi OutputPin7
pwm20:	sub O8L, xl
	sbc O8H, xh
	brcc pwm21
	cbi OutputPin8   ;<___OBS

pwm21:	sbiw Y, 1
	brcc pwm13

	ret

.undef O1L
.undef O1H
.undef O2L
.undef O2H
.undef O3L
.undef O3H
.undef O4L
.undef O4H
.undef O5L
.undef O5H
.undef O6L
.undef O6H
.undef O7L
.undef O7H
.undef O8L
.undef O8H





pwmcond:
	
	asr xh		;divide by 8
	ror xl
	asr xh
	ror xl
	asr xh
	ror xl

	ldy 0
	cp  xl, yl
	cpc xh, yh
	brge pwm22	;x < 0 ?
	ldx 0		;yes, set to zero

pwm22:	ldy 555
	cp  xl, yl
	cpc xh, yh
	brlt pwm23	;x >= 555 ?
	ldx 555		;yes, set to 555

pwm23:	ret







/*
	;       76543210
	ldi t,0b
	store , t
*/
