





Arming:	rvflagand flagA, flagThrottleZero, flagAutoDisarm	;Auto disarm logic
	rvflagand flagA, flagA, flagArmingType
	rvflagand flagA, flagA, flagArmed
	rvbrflagtrue flagA, arm10	

	b16clr AutoDisarmDelay					;if throttle is non zero or autodisarm is off, clear counter
	rjmp arm12

arm10:	b16inc AutoDisarmDelay					;if throttle is zero and autodisarm is on, inc counter
	b16ldi Temp, 400 * 20
	b16cmp AutoDisarmDelay, Temp				;counter = 20 sec?
	brne arm12

	b16clr AutoDisarmDelay					;Yes, disarm
	rvsetflagfalse flagArmed
	rvsetflagtrue flagLcdUpdate
	ret
arm12:

	;--- 

	rvbrflagtrue flagArmingType, arm4	;arming type?

	rvcpi Status, 0				;always on: skip arming if status is not OK.
	breq arm13
	ret

arm13:	rvsetflagtrue flagArmed			;set and exit
	ret


arm4:	rvbrflagfalse flagThrottleZero, arm1	;Stick: 

	b16ldi Temp, -500			;Rudder in Arming position?
	b16cmp RxYaw, Temp
	brlt arm2

	b16ldi Temp, 500			;Rudder in Safe position?
	b16cmp RxYaw, Temp
	brge arm2
	
arm1:	lrv ArmingDelay, 0			;no, clear delay counter and exit
	ret

arm2:	rvinc ArmingDelay			;yes, ArmingDelay++
	lds t, ArmingDelay
	cpi t, 255
	breq arm9				;Delay reached?
	rjmp arm3

arm9:	b16load RxYaw
	tst xh					;Yes, set or clear flagArmed depending on the rudder direction
	brpl arm6

	rvcpi Status, 0				;skip arming if status is not OK.
	breq arm5
	ret

arm5:	rvsetflagtrue flagArmed			;Arm	
	b16ldi BeeperDelay, 300
	rjmp Arm11

arm6:	rvsetflagfalse flagArmed		;Disarm
	b16ldi BeeperDelay, 150
	
arm11:	rvsetflagtrue flagGeneralBuzzerOn
	rvsetflagtrue flagLcdUpdate
	b16ldi ArmedBeepDds, 400*2
	b16clr AutoDisarmDelay

	;---

	b16ldi Temp, 500
	b16cmp RxRoll, Temp
	brge arm7				;Roll stick in selflevel on position?

	b16ldi Temp, -500
	b16cmp RxRoll, Temp
	brlt arm8				;Roll stick in selflevel off position?

	rjmp arm3

arm7:	rvsetflagtrue flagStickCommandSelfLevelOn
	rjmp arm3

arm8:	rvsetflagfalse flagStickCommandSelfLevelOn
	rjmp arm3

arm3:	ret					;No, exit
