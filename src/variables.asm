;--- RAM ---

.equ	LcdBuffer	=0x0100 ;to 0x04ff  Screen buffer, 1024 bytes

.equ	RamMixerTable	=0x0500 ;to 0x053f  SRAM copy of mixer table

.set	RamVariables	=0x0540 ;to 0x07ff  SRAM variables

				;0x0800-0x08ff Stack





;--- EEPROM ---

			;0x0000  to 0x0003  Signature 

.equ	EeMixerTable	=0x0004 ;to 0x0043  Mixer Table, 8bit, 64 bytes

.equ	EeParameterTable=0x0044 ;to 0x005c  Axis gain and limit parameters, 16bit, 24 bytes

.equ	EeSensorCalData	=0x005d ;to 0x006f  Sensor calibration data, 16.8bit, 18 bytes

.set	EeRegisters	=0x0070 ;to



;---  16.8 bit signed registers ---

FixedPointVariableEnumerate Temp
FixedPointVariableEnumerate RxChannel
FixedPointVariableEnumerate RxRoll
FixedPointVariableEnumerate RxPitch
FixedPointVariableEnumerate RxThrottle
FixedPointVariableEnumerate RxYaw
FixedPointVariableEnumerate RxAux

FixedPointVariableEnumerate GyroRoll
FixedPointVariableEnumerate GyroPitch
FixedPointVariableEnumerate GyroYaw
FixedPointVariableEnumerate GyroRollZero
FixedPointVariableEnumerate GyroPitchZero
FixedPointVariableEnumerate GyroYawZero

FixedPointVariableEnumerate AccX
FixedPointVariableEnumerate AccY
FixedPointVariableEnumerate AccZ
FixedPointVariableEnumerate AccXZero
FixedPointVariableEnumerate AccYZero
FixedPointVariableEnumerate AccZZero

FixedPointVariableEnumerate BatteryVoltage
FixedPointVariableEnumerate BatteryVoltageLowpass

FixedPointVariableEnumerate CommandRoll		;output from IMU
FixedPointVariableEnumerate CommandPitch
FixedPointVariableEnumerate CommandYaw

FixedPointVariableEnumerate IntegralRoll	;PI control
FixedPointVariableEnumerate IntegralPitch
FixedPointVariableEnumerate IntegralYaw
FixedPointVariableEnumerate Error
FixedPointVariableEnumerate PgainRoll
FixedPointVariableEnumerate PgainPitch
FixedPointVariableEnumerate PgainYaw
FixedPointVariableEnumerate PlimitRoll
FixedPointVariableEnumerate PlimitPitch
FixedPointVariableEnumerate PlimitYaw
FixedPointVariableEnumerate IgainRoll
FixedPointVariableEnumerate IgainPitch
FixedPointVariableEnumerate IgainYaw
FixedPointVariableEnumerate IlimitRoll
FixedPointVariableEnumerate IlimitPitch
FixedPointVariableEnumerate IlimitYaw

FixedPointVariableEnumerate EscLowLimit

FixedPointVariableEnumerate StickScaleRoll
FixedPointVariableEnumerate StickScalePitch
FixedPointVariableEnumerate StickScaleYaw
FixedPointVariableEnumerate StickScaleThrottle

FixedPointVariableEnumerate Mixvalue

FixedPointVariableEnumerate Out1
FixedPointVariableEnumerate Out2
FixedPointVariableEnumerate Out3
FixedPointVariableEnumerate Out4
FixedPointVariableEnumerate Out5
FixedPointVariableEnumerate Out6
FixedPointVariableEnumerate Out7
FixedPointVariableEnumerate Out8

FixedPointVariableEnumerate FilteredOut1
FixedPointVariableEnumerate FilteredOut2
FixedPointVariableEnumerate FilteredOut3
FixedPointVariableEnumerate FilteredOut4
FixedPointVariableEnumerate FilteredOut5
FixedPointVariableEnumerate FilteredOut6
FixedPointVariableEnumerate FilteredOut7
FixedPointVariableEnumerate FilteredOut8

FixedPointVariableEnumerate Offset1
FixedPointVariableEnumerate Offset2
FixedPointVariableEnumerate Offset3
FixedPointVariableEnumerate Offset4
FixedPointVariableEnumerate Offset5
FixedPointVariableEnumerate Offset6
FixedPointVariableEnumerate Offset7
FixedPointVariableEnumerate Offset8

FixedPointVariableEnumerate Temper

FixedPointVariableEnumerate SelflevelPgain
FixedPointVariableEnumerate SelflevelPlimit

FixedPointVariableEnumerate HeightDampeningGain
FixedPointVariableEnumerate HeightDampeningLimit

FixedPointVariableEnumerate BattAlarmVoltage

FixedPointVariableEnumerate GyroAngleRoll
FixedPointVariableEnumerate GyroAnglePitch

FixedPointVariableEnumerate AccAngleRoll
FixedPointVariableEnumerate AccAnglePitch

FixedPointVariableEnumerate Debug6
FixedPointVariableEnumerate Debug5
FixedPointVariableEnumerate Debug7
FixedPointVariableEnumerate Debug8

FixedPointVariableEnumerate LimitV
FixedPointVariableEnumerate Value

FixedPointVariableEnumerate LvaDdsAcc

FixedPointVariableEnumerate PwmOutput

FixedPointVariableEnumerate ServoFilter

FixedPointVariableEnumerate ArmedBeepDds

FixedPointVariableEnumerate BeeperDelay

FixedPointVariableEnumerate AccTrimRoll
FixedPointVariableEnumerate AccTrimPitch

FixedPointVariableEnumerate AutoDisarmDelay

FixedPointVariableEnumerate CheckRxDelay

FixedPointVariableEnumerate NoActivityTimer
FixedPointVariableEnumerate NoActivityDds

FixedPointVariableEnumerate LiveUpdateTimer

;--- RAM variables (8bit)----

RamVariableEnumerate Xpos		;pixel pos
RamVariableEnumerate Ypos

RamVariableEnumerate X1			;line start and end
RamVariableEnumerate Y1
RamVariableEnumerate X2
RamVariableEnumerate Y2

RamVariableEnumerate PixelType		;0 = EOR   1 = OR   2 = AND

RamVariableEnumerate FontSelector

RamVariableEnumerate MainMenuCursorYposSave
RamVariableEnumerate MainMenuListYposSave

RamVariableEnumerate LoadMenuCursorYposSave
RamVariableEnumerate LoadMenuListYposSave

RamVariableEnumerate RollStartL		;used in readrx.asm
RamVariableEnumerate RollStartH

RamVariableEnumerate PitchStartL
RamVariableEnumerate PitchStartH

RamVariableEnumerate ThrottleStartL
RamVariableEnumerate ThrottleStartH

RamVariableEnumerate YawStartL
RamVariableEnumerate YawStartH

RamVariableEnumerate AuxStartL
RamVariableEnumerate AuxStartH


RamVariableEnumerate RollL		;output from readrx.asm
RamVariableEnumerate RollH

RamVariableEnumerate PitchL
RamVariableEnumerate PitchH

RamVariableEnumerate ThrottleL
RamVariableEnumerate ThrottleH

RamVariableEnumerate YawL
RamVariableEnumerate YawH

RamVariableEnumerate AuxL
RamVariableEnumerate AuxH

RamVariableEnumerate RollDcnt
RamVariableEnumerate PitchDcnt
RamVariableEnumerate ThrottleDcnt
RamVariableEnumerate YawDcnt
RamVariableEnumerate AuxDcnt

RamVariableEnumerate flagRollValid
RamVariableEnumerate flagPitchValid
RamVariableEnumerate flagThrottleValid
RamVariableEnumerate flagYawValid
RamVariableEnumerate flagAuxValid

RamVariableEnumerate RxTimeoutLimit

RamVariableEnumerate OutputRateBitmask	;for each output channel: 0=slow rate  1=fast rate
RamVariableEnumerate OutputTypeBitmask	;for each output channel: 0=servo 1=ESC
RamVariableEnumerate OutputRateDivider	;
RamVariableEnumerate OutputRateDividerCounter

RamVariableEnumerate flagRollPitchLink

RamVariableEnumerate flagPwmEnd

RamVariableEnumerate flagArmed
RamVariableEnumerate flagArmedOldState
RamVariableEnumerate flagThrottleZero
RamVariableEnumerate ArmingDelay

RamVariableEnumerate TimeStampL		;for debug purposes
RamVariableEnumerate TimeStampH

RamVariableEnumerate flagLcdUpdate

RamVariableEnumerate flagSelfLevelType
RamVariableEnumerate flagSelfLevelOn
RamVariableEnumerate flagStickCommandSelfLevelOn

RamVariableEnumerate flagArmingType
RamVariableEnumerate flagAuxOn
RamVariableEnumerate flagAuxOnOldState

RamVariableEnumerate ButtonDelay

RamVariableEnumerate flagSensorsOk

RamVariableEnumerate flagA
RamVariableEnumerate flagB
RamVariableEnumerate flagC

RamVariableEnumerate Index

RamVariableEnumerate OutputTypeBitmaskCopy

RamVariableEnumerate flagInactive

RamVariableEnumerate flagLvaBuzzerOn

RamVariableEnumerate flagGeneralBuzzerOn

RamVariableEnumerate Status
RamVariableEnumerate StatusOldState

RamVariableEnumerate flagAutoDisarm

RamVariableEnumerate flagMutePwm

RamVariableEnumerate flagCppmOn

RamVariableEnumerate CppmPulseStartL
RamVariableEnumerate CppmPulseStartH

RamVariableEnumerate CppmPulseArrayAddressL
RamVariableEnumerate CppmPulseArrayAddressH

RamVariableEnumerate CppmChannel1L
RamVariableEnumerate CppmChannel1H
RamVariableEnumerate CppmChannel2L
RamVariableEnumerate CppmChannel2H
RamVariableEnumerate CppmChannel3L
RamVariableEnumerate CppmChannel3H
RamVariableEnumerate CppmChannel4L
RamVariableEnumerate CppmChannel4H
RamVariableEnumerate CppmChannel5L
RamVariableEnumerate CppmChannel5H
RamVariableEnumerate CppmChannel6L
RamVariableEnumerate CppmChannel6H
RamVariableEnumerate CppmChannel7L
RamVariableEnumerate CppmChannel7H
RamVariableEnumerate CppmChannel8L
RamVariableEnumerate CppmChannel8H
RamVariableEnumerate CppmChannel9L
RamVariableEnumerate CppmChannel9H


RamVariableEnumerate CppmTimeoutCounter


;--- EEPROM registers ----

EEVariableEnumerate16 eeLcdContrast

EEVariableEnumerate16 eeSelflevelPgain		;do not change the order of these variables, works as an array
EEVariableEnumerate16 eeSelflevelPlimit
EEVariableEnumerate16 eeAccTrimRoll
EEVariableEnumerate16 eeAccTrimPitch

EEVariableEnumerate16 eeEscLowLimit		;do not change the order of these variables, works as an array
EEVariableEnumerate16 eeHeightDampeningGain
EEVariableEnumerate16 eeHeightDampeningLimit
EEVariableEnumerate16 eeBattAlarmVoltage
EEVariableEnumerate16 eeServoFilter

EEVariableEnumerate16 eeStickScaleRoll		;do not change the order of these variables, works as an array
EEVariableEnumerate16 eeStickScalePitch
EEVariableEnumerate16 eeStickScaleYaw
EEVariableEnumerate16 eeStickScaleThrottle

EEVariableEnumerate8 eeCppmRoll			;do not change the order of these variables, works as an array
EEVariableEnumerate8 eeCppmPitch
EEVariableEnumerate8 eeCppmThrottle
EEVariableEnumerate8 eeCppmYaw
EEVariableEnumerate8 eeCppmAux

EEVariableEnumerate8 eeSelfLevelType		;true=Stick command  false=Aux    ;do not change the order of these variables, works as an array
EEVariableEnumerate8 eeArmingType		;true=Stick command  false=always on
EEVariableEnumerate8 eeLinkRollPitch		;true=on  false=off 
EEVariableEnumerate8 eeAutoDisarm		;true=on  false=off
EEVariableEnumerate8 eeCppmOn			;true=on  false=off

EEVariableEnumerate8 eeSensorsCalibrated	





;--- Registers (global) ----

					;r0-r1 used by the HW multiplier

					;r2-r8 part of the local variables pool

.def	treg			=r9	;temp reg for ISR

.def	SregSaver		=r13	;Storage of the SREG, used in ISR

.def	t			=r16	;Main temporary register

					;R17-R24 is the local variables pool

.def	tt			=r25	;Temp reg for ISR

