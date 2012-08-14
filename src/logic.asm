
Logic:

	;--- live update ---

	rvbrflagtrue flagArmed, liv1		;skip all if armed	

	b16dec LiveUpdateTimer			;set flagLcdUpdate every second
	b16clr Temp
	b16cmp LiveUpdateTimer, Temp
	brge liv1

	rvsetflagtrue flagLcdUpdate
	b16ldi LiveUpdateTimer, 400

liv1:

	;--- determine if selflevel is on ---

	rvflagand flagA, flagSelflevelType, flagStickCommandSelflevelOn
	rvflagnot flagC, flagSelflevelType
	rvflagand flagB, flagC, flagAuxOn
	rvflagor  flagSelflevelOn, flagA, flagB


	;--- turn on led if armed ---

	rvbrflagtrue flagArmed, log1
	LedOff
	ret

log1:	LedOn
	ret

