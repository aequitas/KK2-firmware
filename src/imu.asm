
Imu:	;--- Get Sensor Data ---

	call AdcRead					;Calculate gyro output
	b16sub GyroRoll, GyroRoll, GyroRollZero
	b16sub GyroPitch, GyroPitch, GyroPitchZero
	b16sub GyroYaw, GyroYaw, GyroYawZero

	b16sub AccX, AccX, AccXZero			;remove offset from Acc
	b16sub AccY, AccY, AccYZero
	b16sub AccZ, AccZ, AccZZero		

	b16add AccX, AccX, AccTrimPitch			;add trim
	b16add AccY, AccY, AccTrimRoll


	;--- Calculate Tilt Angle ---
/*
	b16mov Temp, GyroRoll				;calculate tilt angle with the gyro 
	b16fdiv Temp, 4
	b16sub GyroAngleRoll, GyroAngleRoll, Temp

	b16mov Temp, GyroPitch
	b16fdiv Temp, 4
	b16sub GyroAnglePitch, GyroAnglePitch, Temp

	b16ldi Temper, 8340				;wrap angles at 180 ~ -180 to avoid angle wind up when looping and flipping
	b16ldi Temp, 4170 ;(4170 counts per 180degrees)				

	b16cmp GyroAnglePitch, Temp
	brlt im41
	b16sub GyroAnglePitch, GyroAnglePitch, Temper
im41:
	b16cmp GyroAngleRoll, Temp
	brlt im42
	b16sub GyroAngleRoll, GyroAngleRoll, Temper
im42:
	b16neg Temp

	b16cmp GyroAnglePitch, Temp
	brge im43
	b16add GyroAnglePitch, GyroAnglePitch, Temper
im43:
	b16cmp GyroAngleRoll, Temp
	brge im44
	b16add GyroAngleRoll, GyroAngleRoll, Temper
im44:

*/

	b16ldi Temp, 10					;calculate tilt angle with the acc. (this approximation is good to about 45degrees)
	b16mul AccAngleRoll, AccY, Temp
	b16mul AccAnglePitch, AccX, Temp

/*
	;--- Correct tilt angle ---

	b16ldi Temp, 600				;skip correction at large tilt angles
	b16cmp GyroAnglePitch, Temp
	longbrge im40
	b16cmp GyroAngleRoll, Temp
	longbrge im40

	b16neg Temp
	b16cmp GyroAnglePitch, Temp
	longbrlt im40
	b16cmp GyroAngleRoll, Temp
	longbrlt im40

	b16sub Error, AccAngleRoll, GyroAngleRoll	;Correct gyro driven tilt angle with a small part of the acc driven tilt angle
	b16fdiv Error, 10
	b16add GyroAngleRoll, GyroAngleRoll, Error
		
	b16sub Error, AccAnglePitch, GyroAnglePitch
	b16fdiv Error, 10
	b16add GyroAnglePitch, GyroAnglePitch, Error

im40:
*/
	;--- Calculate Stick and Gyro  ---

	rvbrflagfalse flagThrottleZero, im7	;reset integrals if throttle closed 
	b16clr IntegralRoll
	b16clr IntegralPitch
	b16clr IntegralYaw

im7:	b16fdiv RxRoll, 4			;Right align to the 16.4 multiply usable bit limit.
	b16fdiv RxPitch, 4
	b16fdiv RxYaw, 4

	b16mul RxRoll, RxRoll, StickScaleRoll	;scale Stick input. 
	b16mul RxPitch, RxPitch, StickScalePitch
	b16mul RxYaw, RxYaw, StickScaleYaw
	b16mul RxThrottle, RxThrottle, StickScaleThrottle


	;----- Self level ----

	rvbrflagtrue flagSelflevelOn, im31	;skip if false
	rjmp im30	

im31:	

;--- Roll Axis Self-level P ---

	b16neg RxRoll
	
	b16fmul RxRoll, 3

	b16sub Error, AccAngleRoll, RxRoll	;calculate error
	b16fdiv Error, 4

	b16mul Value, Error, SelflevelPgain	;Proposjonal gain

	b16mov LimitV, SelflevelPlimit		;Proposjonal limit
	rcall limiter
	b16mov RxRoll, Value

	b16fdiv RxRoll, 1


;--- Pitch Axis Self-level P ---

	b16neg RxPitch
	
	b16fmul RxPitch, 3

	b16sub Error, AccAnglePitch, RxPitch	;calculate error
	b16fdiv Error, 4

	b16mul Value, Error, SelflevelPgain	;Proposjonal gain

	b16mov LimitV, SelflevelPlimit		;Proposjonal limit
	rcall limiter
	b16mov RxPitch, Value

	b16fdiv RxPitch, 1
im30:


;--- Roll Axis PI ---
	
	b16sub Error, GyroRoll, RxRoll		;calculate error
	b16fdiv Error, 1

	b16mul Value, Error, PgainRoll		;Proposjonal gain

	b16mov LimitV, PlimitRoll		;Proposjonal limit
	rcall limiter
	b16mov CommandRoll, Value

	b16fdiv Error, 3
	b16mul Temp, Error, IgainRoll		;Integral gain
	b16add Value, IntegralRoll, Temp

	b16mov LimitV, IlimitRoll 		;Integral limit
	rcall limiter
	b16mov IntegralRoll, Value

	b16add CommandRoll, CommandRoll, IntegralRoll


;--- Pitch Axis PI ---

	b16sub Error, RxPitch, GyroPitch	;calculate error
	b16fdiv Error, 1

	b16mul Value, Error, PgainPitch		;Proposjonal gain

	b16mov LimitV, PlimitPitch		;Proposjonal limit
	rcall limiter
	b16mov CommandPitch, Value

	b16fdiv Error, 3
	b16mul Temp, Error, IgainPitch		;Integral gain
	b16add Value, IntegralPitch, Temp

	b16mov LimitV, IlimitPitch 		;Integral limit
	rcall limiter
	b16mov IntegralPitch, Value

	b16add CommandPitch, CommandPitch, IntegralPitch


;--- Yaw Axis PI ---

	b16sub Error, RxYaw, GyroYaw		;calculate error
	b16fdiv Error, 1

	b16mul Value, Error, PgainYaw		;Proposjonal gain

	b16mov LimitV, PlimitYaw		;Proposjonal limit
	rcall limiter
	b16mov CommandYaw, Value

	b16fdiv Error, 3
	b16mul Temp, Error, IgainYaw		;Integral gain
	b16add Value, IntegralYaw, Temp

	b16mov LimitV, IlimitYaw 		;Integral limit
	rcall limiter
	b16mov IntegralYaw, Value

	b16add CommandYaw, CommandYaw, IntegralYaw


;------
	ret



limiter:
	b16cmp Value, LimitV	;high limit
	brlt lim5
	b16mov Value, LimitV

lim5:	b16neg LimitV		;low limit
	b16cmp Value, LimitV
	brge lim6
	b16mov Value, LimitV

lim6:	ret


/*

	b16mov LimitV, 
	b16mov Value, 
	rcall limiter
	b16mov , Value

*/
