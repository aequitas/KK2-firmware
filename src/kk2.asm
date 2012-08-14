
;All code by Rolf R Bakke 2011, 2012

;best viewed with a TAB-setting of 8 and monospace font.



.include "m324Pdef.inc"
.include "macros.inc"
.include "miscmacros.inc"
.include "variables.asm"
.include "hardware.asm"
.include "168mathlib_ram_macros_v1.asm"
.include "constants.asm"

.org 0x0000

	jmp reset
	jmp IntPitch
	jmp IntRoll
	jmp IntYaw
	jmp unused
	jmp IntAux
	jmp unused
	jmp IntThrottle
	jmp unused
	jmp unused
	jmp unused
	jmp unused
	jmp unused
	jmp IsrPwmStart
	jmp IsrPwmEnd
	jmp unused
	jmp unused
	jmp unused
	jmp unused
	jmp unused
	jmp unused
	jmp unused
	jmp unused
	jmp unused
	jmp unused
	jmp unused
	jmp unused
	jmp unused
	jmp unused
	jmp unused
	jmp unused

unused:	reti


;--- Hardware Init ---

reset:	ldi t,low(ramend)	;initalize stack pointer
	out spl,t
	ldi t,high(ramend)
	out sph,t

	ldx 100
	call WaitXms

	call SetupHardware


	;---

	call LcdUpdate

	call ShowVersion

;--- Variables init ---

	call EeInit

	lrv MainMenuCursorYposSave, 0
	lrv MainMenuListYposSave, 0
	
	lrv LoadMenuCursorYposSave, 0
	lrv LoadMenuListYposSave, 0
	
	rvsetflagfalse flagStickCommandSelfLevelOn

	lrv Status, 0
	lrv StatusOldState, 0 

	b16ldi CheckRxDelay, 400 * 10

	ldz CppmChannel1L
	sts CppmPulseArrayAddressL, zl
	sts CppmPulseArrayAddressH, zh

	ldz eeCppmOn
	call ReadEeprom
	sts flagCppmOn, t



;--- MAIN ----
	
	sei


;--- Throttle cal ----

	call GetButtons
	cpi t, 0x09			;both buttons 1 and 4 pressed?
	brne ma5
	call EscThrottleCalibration	;Yes
ma5:


;--- Flight loop init

ma2:	call FlightInit

	
	;       76543210		;clear pending OCR1A and B interrupt
	ldi t,0b00000110
	store tifr1, t

;--- Flight Loop

ma1:	

;sbi OutputPin8		;OBS DEBUG

	call PwmStart			;runtime between PwmStart and B interrupt (in PwmEnd) must not exeed 1.5ms
	call GetRxChannels
	call CheckRx
	call Arming
	call Logic
	call Imu
	call HeightDampening
	call Mixer
	call Beeper
	call Lva
	call PwmEnd

	
	rvcp Status, StatusOldState			;Set LcdUpdate if Status changes and not armed
	breq ma8
	rvmov StatusOldState, Status
	rvflagnot flagA, flagArmed 
	rvflagor  flagLcdUpdate, flagLcdUpdate, flagA 
ma8:
	rvflageor flagA, flagAuxOn, flagAuxOnOldState	;set LcdUpdate true if AuxOn changes state and it is not armed
	rvflagnot flagB, flagArmed
	rvflagand flagA, flagA, flagB 
	rvflagor  flagLcdUpdate, flagLcdUpdate, flagA 
	rvflagand flagAuxOnOldState, flagAuxOn, flagAuxOn

	rvbrflagfalse flagLcdUpdate, ma3		;Update LCD once if flagLcdUpdate is true 
	rvsetflagfalse flagLcdUpdate
	call UpdateFlightDisplay

ma3:	lds xl, flagArmed		;skip buttonreading if armed and arming mode is stick arming
	lds xh, flagArmingType
	and xl, xh
	brflagfalse xl, ma7
	rjmp ma1

ma7:	load t, pinb			;read buttons
	com t
	swap t
	andi t, 0x0f
	cpi t, 0x01			;MENY button pressed?
	breq ma4
	
	lrv ButtonDelay, 0		;No, reset ButtonDelay, and go to start of the loop
	rjmp ma1	

ma4:	rvinc ButtonDelay		;yes, ButtonDelay++
	rvcpi ButtonDelay, 50		;ButtonDelay == 50?
	brne ma6			;yes, goto the meny
	rjmp ma1			;no, go to start of the loop	

ma6:

;--- Meny 

;	         76543210		;disable OCR1A and B interrupt
	ldi tt,0b00000000
	store timsk1, tt

	call Beep

	call MainMenu

	rjmp ma2


.include "cppmsettings.asm"
.include "checkrx.asm"
.include "setuphw.asm"
.include "version.asm"
.include "reset.asm"
.include "beeper.asm"
.include "menu.asm"
.include "lva.asm"
.include "logic.asm"
.include "heightdamp.asm"
.include "loader.asm"
.include "selflevel.asm"
.include "layout.asm"
.include "throttlecal.asm"
.include "eeinit.asm"
.include "sensorcal.asm"
.include "settingsc.asm"
.include "settingsb.asm"
.include "settingsa.asm"
.include "flightdisplay.asm"
.include "arm.asm"
.include "flightinit.asm"
.include "debug.asm"
.include "pieditor.asm"
.include "numedit.asm"
.include "mixedit.asm"
.include "mixer2.asm"
.include "imu.asm"
.include "pwmgen.asm"
.include "rxtest.asm"
.include "readrx.asm"
.include "mainmenu.asm"
.include "sensortest.asm"
.include "sensorreading.asm"
.include "ST7565.asm"
.include "miscsubs.asm"
font6x8:
.include "font6x8.asm"
font8x12:
;.include "font8x12.asm"
font12x16:
.include "font12x16.asm"
symbols16x16:
.include "symbols16x16.asm"
font4x6:
.include "font4x6.asm"

	.db "__date__"


