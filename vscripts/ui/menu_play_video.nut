
global function InitPlayVideoMenu
global function PlayVideoMenu
global function SetVideoCompleteFunc

const string INTRO_VIDEO = "intro"

global enum eVideoSkipRule
{
	INSTANT,
	HOLD,
	NO_SKIP
}

struct
{
	var menu
	string video
	string milesAudio
	int skipRule = eVideoSkipRule.INSTANT
	var ruiSkipLabel
	bool holdInProgress = false
	void functionref() videoCompleteFunc
} file

void function InitPlayVideoMenu( var newMenuArg )
{
	RegisterSignal( "PlayVideoMenuClosed" )
	RegisterSignal( "SkipVideoHoldReleased" )

	var menu = GetMenu( "PlayVideoMenu" )
	file.menu = menu

	SetGamepadCursorEnabled( menu, false )

	AddMenuEventHandler( menu, eUIEvent.MENU_OPEN, OnPlayVideoMenu_Open )
	AddMenuEventHandler( menu, eUIEvent.MENU_CLOSE, OnPlayVideoMenu_Close )
	AddMenuEventHandler( menu, eUIEvent.MENU_NAVIGATE_BACK, OnPlayVideoMenu_NavigateBack )

	var vguiSkipLabel = Hud_GetChild( menu, "SkipLabel" )
	Hud_SetAboveBlur( vguiSkipLabel, true )
	file.ruiSkipLabel = Hud_GetRui( vguiSkipLabel )
}

void function PlayVideoMenu( bool isDialog, string video, string milesAudio = "", int skipRule = eVideoSkipRule.INSTANT, void functionref() func = null )
{
	Assert( video != "" )

	SetDialog( file.menu, isDialog ) //
	file.video = video
	file.milesAudio = milesAudio
	file.skipRule = skipRule
	file.videoCompleteFunc = func
	AdvanceMenu( file.menu )
}

void function SetVideoCompleteFunc( void functionref() func )
{
	file.videoCompleteFunc = func
}

void function OnPlayVideoMenu_Open()
{
	EndSignal( uiGlobal.signalDummy, "PlayVideoMenuClosed" )

	Assert( file.video != "" )

	bool forceUseCaptioning = false
	if ( GetLanguage() != "english" && file.video != INTRO_VIDEO )
		forceUseCaptioning = true

	DisableBackgroundMovie()
	SetMouseCursorVisible( false )
	StopVideos( eVideoPanelContext.UI )
	uiGlobal.playingVideo = true
	UIMusicUpdate()
	PlayVideoFullScreen( file.video, file.milesAudio, forceUseCaptioning )

	if ( file.skipRule == eVideoSkipRule.HOLD )
		thread WaitForSkipInput()

	WaitSignal( uiGlobal.signalDummy, "PlayVideoEnded" )

	if ( GetActiveMenu() == file.menu )
		thread CloseActiveMenu()
}

void function OnPlayVideoMenu_Close()
{
	Signal( uiGlobal.signalDummy, "PlayVideoMenuClosed" )

	StopVideos( eVideoPanelContext.UI )
	if ( file.milesAudio != "" )
		StopUISoundByName( file.milesAudio )
	file.video = ""
	file.milesAudio = ""
	EnableBackgroundMovie()
	SetMouseCursorVisible( true )
	uiGlobal.playingVideo = false
	UIMusicUpdate()

	if ( file.videoCompleteFunc != null )
		thread file.videoCompleteFunc()
}

void function OnPlayVideoMenu_NavigateBack()
{
	if ( file.skipRule == eVideoSkipRule.INSTANT )
		CloseActiveMenu()
}

void function WaitForSkipInput()
{
	EndSignal( uiGlobal.signalDummy, "PlayVideoEnded" )

	array<int> inputs

	// Gamepad
	inputs.append( BUTTON_A )
	inputs.append( BUTTON_B )
	inputs.append( BUTTON_X )
	inputs.append( BUTTON_Y )
	inputs.append( BUTTON_SHOULDER_LEFT )
	inputs.append( BUTTON_SHOULDER_RIGHT )
	inputs.append( BUTTON_TRIGGER_LEFT )
	inputs.append( BUTTON_TRIGGER_RIGHT )
	inputs.append( BUTTON_BACK )
	inputs.append( BUTTON_START )

	// Keyboard/Mouse
	inputs.append( KEY_SPACE )
	inputs.append( KEY_ESCAPE )
	inputs.append( KEY_ENTER )
	inputs.append( KEY_PAD_ENTER )

	WaitFrame() // Without this the skip message would show instantly if you chose the main menu intro option with BUTTON_A or KEY_SPACE
	foreach ( input in inputs )
	{
		if ( input == BUTTON_A || input == KEY_SPACE )
		{
			RegisterButtonPressedCallback( input, ThreadSkipButton_Press )
			RegisterButtonReleasedCallback( input, SkipButton_Release )
		}
		else
		{
			RegisterButtonPressedCallback( input, NotifyButton_Press )
		}
	}

	OnThreadEnd(
		function() : ( inputs )
		{
			foreach ( input in inputs )
			{
				if ( input == BUTTON_A || input == KEY_SPACE )
				{
					DeregisterButtonPressedCallback( input, ThreadSkipButton_Press )
					DeregisterButtonReleasedCallback( input, SkipButton_Release )
				}
				else
				{
					DeregisterButtonPressedCallback( input, NotifyButton_Press )
				}
			}
		}
	)

	WaitSignal( uiGlobal.signalDummy, "PlayVideoEnded" )
}

void function ThreadSkipButton_Press( var button )
{
	thread SkipButton_Press()
}

void function NotifyButton_Press( var button )
{
	ShowAndFadeSkipLabel()
}

void function SkipButton_Press()
{
	if ( file.holdInProgress )
		return

	file.holdInProgress = true

	float holdStartTime = Time()
	table hold // Table is needed to pass by reference
	hold.completed <- false

	EndSignal( uiGlobal.signalDummy, "SkipVideoHoldReleased" )
	EndSignal( uiGlobal.signalDummy, "PlayVideoEnded" )

	OnThreadEnd(
		function() : ( hold )
		{
			if ( hold.completed )
				Signal( uiGlobal.signalDummy, "PlayVideoEnded" )

			file.holdInProgress = false
		}
	)

	ShowAndFadeSkipLabel()

	float holdDuration = 0
	while ( holdDuration < 1.5 )
	{
		WaitFrame()
		holdDuration = Time() - holdStartTime
	}

	hold.completed = true
}

void function SkipButton_Release( var button )
{
	Signal( uiGlobal.signalDummy, "SkipVideoHoldReleased" )
}

void function ShowAndFadeSkipLabel()
{
	RuiSetGameTime( file.ruiSkipLabel, "initTime", Time() )
	RuiSetGameTime( file.ruiSkipLabel, "startTime", Time() )
}
