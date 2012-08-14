
.def	Counter = r17

EeInit:

	ldz 0		;EE initalized?
	call ReadEeprom
	adiw z, 1
	cpi t, 0x19
	brne eei1

	call ReadEeprom
	adiw z, 1
	cpi t, 0x03
	brne eei1

	call ReadEeprom
	adiw z, 1
	cpi t, 0x73
	brne eei1

	call ReadEeprom
	adiw z, 1
	cpi t, 0x02
	brne eei1

	ret		;Yes, return

eei1:			;no, initalize

	ldx EeMixerTable	;Mixertable
	ldy eei2 * 2
	ldi Counter, 64
eei3:	movw z, y
	lpm t, z
	movw z, x
	call WriteEeprom
	adiw x, 1
	adiw y, 1
	dec Counter
	brne eei3


	ldx EeParameterTable	;ParameterTable
	ldy eei4 * 2
	ldi Counter, 24
eei5:	movw z, y
	lpm t, z
	movw z, x
	call WriteEeprom
	adiw x, 1
	adiw y, 1
	dec Counter
	brne eei5

	ldx EeStickScaleRoll	;Stick Scaling
	ldy eei7 * 2
	ldi Counter, 8
eei8:	movw z, y
	lpm t, z
	movw z, x
	call WriteEeprom
	adiw x, 1
	adiw y, 1
	dec Counter
	brne eei8


	ldx 10
	ldz eeEscLowLimit
	call StoreEeVariable16

	ldx 0x24
	ldz eeLcdContrast
	call StoreEeVariable16


	ldx 40
	ldz eeSelflevelPgain
	call StoreEeVariable16

	ldx 20
	ldz eeSelflevelPlimit
	call StoreEeVariable16


	ldx 0
	ldz eeHeightDampeningGain
	call StoreEeVariable16

	ldx 30
	ldz eeHeightDampeningLimit
	call StoreEeVariable16

	ldx 0
	ldz eeBattAlarmVoltage
	call StoreEeVariable16

	ldx 0
	ldz eeServoFilter
	call StoreEeVariable16


	ldx 0
	ldz eeAccTrimRoll
	call StoreEeVariable16

	ldx 0
	ldz eeAccTrimPitch
	call StoreEeVariable16

	ldx 1 
	ldz eeCppmRoll
	call StoreEeVariable8
	ldx 2
	ldz eeCppmPitch
	call StoreEeVariable8
	ldx 3
	ldz eeCppmThrottle
	call StoreEeVariable8
	ldx 4
	ldz eeCppmYaw
	call StoreEeVariable8
	ldx 5
	ldz eeCppmAux
	call StoreEeVariable8


	setflagtrue xl
	ldz eeSelfLevelType
	call StoreEeVariable8

	setflagtrue xl
	ldz eeArmingType
	call StoreEeVariable8

	setflagtrue xl
	ldz eeLinkRollPitch
	call StoreEeVariable8

	setflagtrue xl
	ldz eeAutoDisarm
	call StoreEeVariable8

	setflagfalse xl
	ldz eeSensorsCalibrated
	call StoreEeVariable8
	
	setflagfalse xl
	ldz eeCppmOn
	call StoreEeVariable8



	ldz 0			;EE signature
	ldi t, 0x19
	call WriteEeprom
	adiw z, 1
	ldi t, 0x03
	call WriteEeprom
	adiw z, 1
	ldi t, 0x73
	call WriteEeprom
	adiw z, 1
	ldi t, 0x02
	call WriteEeprom
	adiw z, 1

	ldi Counter, 5
eei6:	call Beep
	ldi yl, 0
	call wms
	dec Counter
	brne eei6

	call SensorTest

	ret





eei2:	.db  100, 0  , 100, 100, 0  , 3  , 0  , 0
	.db  100, 100, 0  ,-100, 0  , 3  , 0  , 0
	.db  100, 0  ,-100, 100, 0  , 3  , 0  , 0
	.db  100,-100, 0  ,-100, 0  , 3  , 0  , 0
	.db  0  , 0  , 0  , 0  , 0  , 0  , 0  , 0
	.db  0  , 0  , 0  , 0  , 0  , 0  , 0  , 0
	.db  0  , 0  , 0  , 0  , 0  , 0  , 0  , 0
	.db  0  , 0  , 0  , 0  , 0  , 0  , 0  , 0
	


eei4:	.dw 50,100,25,20
	.dw 50,100,25,20
	.dw 50,20,50,10


eei7:	.dw 30, 30, 50, 90


.undef Counter
