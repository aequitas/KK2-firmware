

MainMenu:

men23:	ldy men1 * 2

	lds xl, MainMenuListYposSave
	lds xh, MainMenuCursorYposSave

	ldi t, 14

	call Menu

	sts MainMenuListYposSave, yl
	sts MainMenuCursorYposSave, yh

	brcs men22		;BACK pressed?
	ret			;Yes, return
	
men22:	lsl xl			;No, calculate index    Z = *mem18 * 2 + xl * 2
	ldz men18 * 2
	add zl, xl
	clr t
	adc zh, t

	lpm xl, z+		; x = (Z)
	lpm xh, z
	
	movw z, x		;z = x
	
	icall			;go to choosen menu item code  (sound like an apple product!  lawlz)

	call Beep

	call LcdClear		;blank screen
	call LcdUpdate	

men20:	call GetButtons		;wait until buttons relesed
	cpi t, 0
	brne men20	
	
	jmp men23




men1:	.db "PI Editor           "
	.db "Receiver Test       "
	.db "Mode Settings       "
	.db "Stick Scaling       "
	.db "Misc. Settings      "
	.db "Self-level Settings "
	.db "Sensor Test         "
	.db "Sensor Calibration  "
	.db "CPPM settings       "
	.db "Mixer Editor        "
	.db "Show Motor Layout   "
	.db "Load Motor Layout   "
	.db "Debug               "
	.db "Factory Reset       "


men18:	.dw PiEditor
	.dw RxTest
	.dw SettingsC
	.dw SettingsA
	.dw SettingsB
	.dw SelflevelSettings
	.dw SensorTest
	.dw CalibrateSensors
	.dw CppmSettings
	.dw MixerEditor
	.dw MotorLayout
	.dw LoadMixer
	.dw DebugMeny
	.dw FactoryReset


