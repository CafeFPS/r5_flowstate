global function InitGammaMenu

struct {
	var menu

	float sliderFrac = 0.5
	float resetFrac = 0.5
	float lastStickMoveUpdateTime = 0
	float stickDeflection = 0

	bool registeredAcceptButtonPress = false
} file

void function InitGammaMenu()
{
	var menu = GetMenu( "GammaMenu" )
	file.menu = menu

	AddMenuEventHandler( menu, eUIEvent.MENU_OPEN, OnGammaMenu_Open )
	AddMenuEventHandler( menu, eUIEvent.MENU_CLOSE, OnGammaMenu_Close )
	AddMenuEventHandler( menu, eUIEvent.MENU_NAVIGATE_BACK, OnGammaMenu_NavigateBack )

	AddMenuFooterOption( menu, LEFT, BUTTON_A, true, "#A_BUTTON_SET_BRIGHTNESS" )
	AddMenuFooterOption( menu, LEFT, BUTTON_B, true, "#B_BUTTON_DISMISS_RUI", "#DISMISS" )
}

const float NUM_GAMMA_STEPS = 20.0

float function GetGammaNormalizedValue()
{
	return VideoOptions_GetGammaAdjustment()
}


void function SetGammaFromNormalizedValue( float normalizedGamma )
{
	VideoOptions_SetGammaAdjustment( normalizedGamma )
}


void function OnGammaMenu_Open()
{
	var gammaLeftRui   = Hud_GetRui( Hud_GetChild( file.menu, "GammaElementLeft" ) )
	var gammaCenterRui = Hud_GetRui( Hud_GetChild( file.menu, "GammaElementCenter" ) )
	var gammaRightRui  = Hud_GetRui( Hud_GetChild( file.menu, "GammaElementRight" ) )
	var sliderHintRui  = Hud_GetRui( Hud_GetChild( file.menu, "SliderHint" ) )

	RuiSetImage( gammaLeftRui, "basicImage", $"rui/menu/common/gamma_image" )
	RuiSetFloat3( gammaLeftRui, "basicImageColor", <0.0075, 0.0075, 0.0075> )

	RuiSetImage( gammaCenterRui, "basicImage", $"rui/menu/common/gamma_image" )
	RuiSetFloat3( gammaCenterRui, "basicImageColor", <0.25, 0.25, 0.25> )

	RuiSetImage( gammaRightRui, "basicImage", $"rui/menu/common/gamma_image" )
	RuiSetFloat3( gammaRightRui, "basicImageColor", <0.995, 0.995, 0.995> )

	RuiSetString( sliderHintRui, "labelText", "#GAMMA_ADJUST_CONTROLS" )

	thread RegisterAcceptButtonPressAfterRelease()

	RegisterButtonPressedCallback( BUTTON_DPAD_LEFT, OnDpadLeft )
	RegisterButtonPressedCallback( BUTTON_DPAD_RIGHT, OnDpadRight )

	RegisterStickMovedCallback( ANALOG_RIGHT_X, OnStickMoved )
	RegisterStickMovedCallback( ANALOG_RIGHT_Y, OverrideYScroll )

	var gammaSliderRui = Hud_GetRui( Hud_GetChild( file.menu, "GammaSlider" ) )

	file.sliderFrac = GetGammaNormalizedValue()
	file.resetFrac = file.sliderFrac

	thread GammaMenuThink( gammaSliderRui )
}


void function GammaMenuThink( var gammaSliderRui )
{
	while ( GetTopNonDialogMenu() == file.menu )
	{
		if ( file.stickDeflection > 0.25 && Time() - file.lastStickMoveUpdateTime > 0.15 )
		{
			file.sliderFrac = min( 1.0, file.sliderFrac + (1 / NUM_GAMMA_STEPS) )
			file.lastStickMoveUpdateTime = Time()
		}
		else if ( file.stickDeflection < -0.25 && Time() - file.lastStickMoveUpdateTime > 0.15 )
		{
			file.sliderFrac = max( 0.0, file.sliderFrac - (1 / NUM_GAMMA_STEPS) )
			file.lastStickMoveUpdateTime = Time()
		}

		RuiSetFloat( gammaSliderRui, "sliderFrac", file.sliderFrac )

		SetGammaFromNormalizedValue( file.sliderFrac )
		WaitFrame()
	}
}


void function OnDpadLeft( ... )
{
	file.sliderFrac = max( 0, file.sliderFrac - 1 / NUM_GAMMA_STEPS )
}


void function OnDpadRight( ... )
{
	file.sliderFrac = min( 1.0, file.sliderFrac + 1 / NUM_GAMMA_STEPS )
}


void function OnStickMoved( ... )
{
	file.stickDeflection = expect float( vargv[1] )
}


void function OverrideYScroll( ... )
{}


void function OnGammaMenu_Close()
{
	DeregisterButtonPressedCallback( BUTTON_DPAD_LEFT, OnDpadLeft )
	DeregisterButtonPressedCallback( BUTTON_DPAD_RIGHT, OnDpadRight )

	DeregisterStickMovedCallback( ANALOG_RIGHT_X, OnStickMoved )
	DeregisterStickMovedCallback( ANALOG_RIGHT_Y, OverrideYScroll )

	DeregisterAcceptButtonPress()

	if ( !GetConVarBool( "gamma_adjusted" ) )
		SetConVarBool( "gamma_adjusted", true )
}


void function OnGammaMenu_NavigateBack()
{
	SetGammaFromNormalizedValue( file.resetFrac )
	CloseActiveMenu()
}


void function AcceptGammaSetting( var button )
{
	CloseActiveMenu()
}


void function RegisterAcceptButtonPressAfterRelease()
{
	while ( InputIsButtonDown( BUTTON_A ) )
		WaitFrame()

	RegisterAcceptButtonPress()
}


void function RegisterAcceptButtonPress()
{
	if ( !file.registeredAcceptButtonPress )
	{
		RegisterButtonPressedCallback( BUTTON_A, AcceptGammaSetting )
		file.registeredAcceptButtonPress = true
	}
}


void function DeregisterAcceptButtonPress()
{
	if ( file.registeredAcceptButtonPress )
	{
		DeregisterButtonPressedCallback( BUTTON_A, AcceptGammaSetting )
		file.registeredAcceptButtonPress = false
	}
}