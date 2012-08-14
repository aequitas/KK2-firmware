
IntRoll:
	in SregSaver, sreg

	lds tt, flagCppmOn		;CPPM mode?
	tst tt
	brpl rx6
	rjmp cppm

rx6:	sbis pind,3			;rising or falling?
	rjmp rx1

	lds tt, tcnt1l			;rising, store the start value
	sts RollStartL, tt
	lds tt, tcnt1h
	sts RollStartH, tt
	
	clr tt
	sts RollDcnt, tt

	out sreg, SregSaver		;exit	
	reti

rx1:	lds tt, tcnt1l			;falling, calculate the pulse length
	lds treg, RollStartL
	sub tt, treg
	sts RollL, tt

	lds tt, tcnt1h
	lds treg, RollStartH
	sbc tt, treg
	sts RollH, tt

	out sreg, SregSaver		;exit	
	reti



IntPitch:
	in SregSaver, sreg

	sbis pind,2			;rising or falling?
	rjmp rx2

	lds tt, tcnt1l			;rising, store the start value
	sts PitchStartL, tt
	lds tt, tcnt1h
	sts PitchStartH, tt

	clr tt
	sts PitchDcnt, tt
	
	out sreg, SregSaver		;exit	
	reti

rx2:	lds tt, tcnt1l			;falling, calculate the pulse length
	lds treg, PitchStartL
	sub tt, treg
	sts PitchL, tt

	lds tt, tcnt1h
	lds treg, PitchStartH
	sbc tt, treg
	sts PitchH, tt

	out sreg, SregSaver		;exit	
	reti



IntThrottle:
	in SregSaver, sreg

	sbis pind,0			;rising or falling?
	rjmp rx3

	lds tt, tcnt1l			;rising, store the start value
	sts ThrottleStartL, tt
	lds tt, tcnt1h
	sts ThrottleStartH, tt
	
	clr tt
	sts ThrottleDcnt, tt

	out sreg, SregSaver		;exit	
	reti

rx3:	lds tt, tcnt1l			;falling, calculate the pulse length
	lds treg, ThrottleStartL
	sub tt, treg
	sts ThrottleL, tt

	lds tt, tcnt1h
	lds treg, ThrottleStartH
	sbc tt, treg
	sts ThrottleH, tt

	out sreg, SregSaver		;exit	
	reti



IntYaw:
	in SregSaver, sreg

	sbis pinb,2			;rising or falling?
	rjmp rx4

	lds tt, tcnt1l			;rising, store the start value
	sts YawStartL, tt
	lds tt, tcnt1h
	sts YawStartH, tt

	clr tt
	sts YawDcnt, tt
	
	out sreg, SregSaver		;exit	
	reti

rx4:	lds tt, tcnt1l			;falling, calculate the pulse length
	lds treg, YawStartL
	sub tt, treg
	sts YawL, tt

	lds tt, tcnt1h
	lds treg, YawStartH
	sbc tt, treg
	sts YawH, tt

	out sreg, SregSaver		;exit	
	reti



IntAux:
	in SregSaver, sreg

	sbis pinb,0			;rising or falling?
	rjmp rx5

	lds tt, tcnt1l			;rising, store the start value
	sts AuxStartL, tt
	lds tt, tcnt1h
	sts AuxStartH, tt

	clr tt
	sts AuxDcnt, tt
	
	out sreg, SregSaver		;exit	
	reti

rx5:	lds tt, tcnt1l			;falling, calculate the pulse length
	lds treg, AuxStartL
	sub tt, treg
	sts AuxL, tt

	lds tt, tcnt1h
	lds treg, AuxStartH
	sbc tt, treg
	sts AuxH, tt

	out sreg, SregSaver		;exit	
	reti


	;--- CPPM ISR ---

cppm:	sbic pind,3			;rising or falling?
	rjmp rx7

	out sreg, SregSaver		;falling, exit	
	reti

rx7:	push xl				;rising, calculate pulse length:
	push xh
	push zl
	push zh
	
	lds xl, tcnt1l			;X = TCNT1 - CppmPulseStart, CppmPulseStart = TCNT1
	lds xh, tcnt1h
	lds zl, CppmPulseStartL
	lds zh, CppmPulseStartH
	sts CppmPulseStartL, xl
	sts CppmPulseStartH, xh
	sub xl, zl
	sbc xh, zh

	brpl rx8			;X = ABS(X)
	ldz 0
	sub zl, xl
	sbc zh, xh
	movw x, z
rx8:	
	ldz 6250			;pulse longer than 2.5ms?
	cp  xl, zl
	cpc xh, zh
	brlo rx11

	ldz CppmChannel1L		;yes, reset cppm sequence and exit
	rjmp rx10

rx11:	lds zl, CppmPulseArrayAddressL	;store channel in channel array.
	lds zh, CppmPulseArrayAddressH

	st z+, xl
	st z+, xh

	ldx CppmChannel9L		;end of array reached?
	cp  zl, xl
	cpc zh, xh
	brlo rx10
	breq rx10

	ldz CppmChannel9L		;yes, limit

rx10:	sts CppmPulseArrayAddressL, zl	;store array pointer
	sts CppmPulseArrayAddressH, zh

	clr tt				;reset timeout counter
	sts CppmTimeoutCounter, tt

	pop zh
	pop zl
	pop xh
	pop xl

	out sreg, SregSaver		;exit	
	reti


	;---


GetRxChannels:

	;--- Roll ---

	rvbrflagfalse flagCppmOn, rx12

	ldz eeCppmRoll
	rcall GetCppmChannel
	rjmp rx13


rx12:	cli				;get roll channel value
	lds xl, RollL
	lds xh, RollH
	sei

rx13:	rcall gt1m1			;sanitize
	clr yh				;store in register
	b16store RxRoll

	
	;--- Pitch

	rvbrflagfalse flagCppmOn, rx14

	ldz eeCppmPitch
	rcall GetCppmChannel
	rjmp rx15

rx14:	cli				;get Pitch channel value
	lds xl, PitchL
	lds xh, PitchH
	sei

rx15:	rcall gt1m1			;sanitize
	clr yh				;store in register
	b16store RxPitch


	;--- Throttle ---

	rvbrflagfalse flagCppmOn, rx16

	ldz eeCppmThrottle
	rcall GetCppmChannel
	rjmp rx17

rx16:	cli				;get Throttle channel value
	lds xl, ThrottleL
	lds xh, ThrottleH
	sei

rx17:	rvsetflagfalse flagThrottleZero

	rcall Xabs			;X = ABS(X)

	ldz 2875			;X = X - 2875
	sub xl, zl
	sbc xh, zh

	ldz 0				;X < 0 ?
	cp  xl, zl
	cpc xh, zh
	brge gt8m8

	rjmp rx30			;yes, set to zero

gt8m8:	ldz 3000			;X > 3000?
	cp  xl, zl
	cpc xh, zh
	brlt gt7m2

rx30:	ldx 0				;Yes, set to zero
	rvsetflagtrue flagThrottleZero

gt7m2:	clr yh				;store in register
	b16store RxThrottle


	;--- Yaw ---

	rvbrflagfalse flagCppmOn, rx18

	ldz eeCppmYaw
	rcall GetCppmChannel
	rjmp rx19

rx18:	cli				;get Yaw channel value
	lds xl, YawL
	lds xh, YawH
	sei

rx19:	rcall gt1m1			;sanitize

	clr yh				;store in register
	b16store RxYaw

	
	;--- AUX ---

	rvbrflagfalse flagCppmOn, rx20

	ldz eeCppmAux
	rcall GetCppmChannel
	rjmp rx21

rx20:	cli				;get Aux channel value
	lds xl, AuxL
	lds xh, AuxH
	sei

rx21:	rcall gt1m1			;sanitize

	rvsetflagfalse flagAuxOn
	tst xh
	brmi gt9m3
	breq gt9m3
	rvsetflagtrue flagAuxOn
	
gt9m3:	clr yh				;store in register
	b16store RxAux


	;--- Check rx ---


	rvsetflagtrue flagRollValid	
	rvsetflagtrue flagPitchValid	
	rvsetflagtrue flagThrottleValid	
	rvsetflagtrue flagYawValid	
	rvsetflagtrue flagAuxValid	

	rvbrflagtrue flagCppmOn, rx22
	rjmp rx24

rx22:	rvinc CppmTimeoutCounter			;CPPM timeout?
	rvcp CppmTimeoutCounter, RxTimeoutLimit
	brlo rx23			
	rvdec CppmTimeoutCounter
	rvsetflagfalse flagRollValid			;yes, set flags to false and values to zero
	rvsetflagfalse flagPitchValid	
	rvsetflagfalse flagThrottleValid	
	rvsetflagfalse flagYawValid	
	rvsetflagfalse flagAuxValid	
	b16clr RxRoll
	b16clr RxPitch
	b16clr RxThrottle
	rvsetflagtrue flagThrottleZero
	b16clr RxYaw
	b16clr RxAux
	rvsetflagfalse flagAuxOn

rx23:	ret


rx24:	rvinc RollDcnt					;signal timed out?
	rvcp RollDcnt, RxTimeoutLimit
	brlo rx25			
	rvdec RollDcnt
	rvsetflagfalse flagRollValid			;Yes, set flag to false and set value to 0
	b16clr RxRoll

rx25:	rvinc PitchDcnt					;signal timed out?
	rvcp PitchDcnt, RxTimeoutLimit
	brlo rx26			
	rvdec PitchDcnt
	rvsetflagfalse flagPitchValid			;Yes, set flag to false and set value to 0
	b16clr RxPitch

rx26:	rvinc ThrottleDcnt				;signal timed out?
	rvcp ThrottleDcnt, RxTimeoutLimit
	brlo rx27			
	rvdec ThrottleDcnt
	rvsetflagfalse flagThrottleValid		;Yes, set flag to false and set value to 0
	b16clr RxThrottle
	rvsetflagtrue flagThrottleZero

rx27:	rvinc YawDcnt					;signal timed out?
	rvcp YawDcnt, RxTimeoutLimit
	brlo rx28			
	rvdec YawDcnt
	rvsetflagfalse flagYawValid			;Yes, set flag to false and set value to 0
	b16clr RxYaw

rx28:	rvinc AuxDcnt					;signal timed out?
	rvcp AuxDcnt, RxTimeoutLimit
	brlo rx29			
	rvdec AuxDcnt
	rvsetflagfalse flagAuxValid			;Yes, set flag to false and set value to 0
	b16clr RxAux
	rvsetflagfalse flagAuxOn

rx29:	ret


	;----

GetCppmChannel:
	call ReadEeprom
	dec t
	mov r0, t
	ldzarray CppmChannel1L, 2, r0
	cli
	ld xl, z+
	ld xh, z
	sei

	ret



gt1m1:	rcall Xabs	;X = ABS(X)

	ldz 3750	;X = X - 3750
	sub xl, zl
	sbc xh, zh

	ldz -1500	;X < -1500?
	cp  xl, zl
	cpc xh, zh
	brlt gt1m2

	ldz 1500	;X > 1500?
	cp  xl, zl
	cpc xh, zh
	brge gt1m2

	ret		;No, exit

gt1m2:	ldx 0		;Yes, set to zero
	ret





Xabs:	tst xh		;X = ABS(X)
	brpl xa1

	com xl
	com xh
	
	ldi t,1
	add xl,t
	clr t
	adc xh,t

xa1:	ret




