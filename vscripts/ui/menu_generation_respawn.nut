global function InitGenerationRespawnMenu

global function OnRegenButtonClick

global function ConfirmRegen1
global function ConfirmRegen2
global function ConfirmRegen3

global function GetGenImage

const NUM_ADVOCATE_LINES 			= 7
const ADVOCATE_LINE_DELAY 			= 2.0
const ADVOCATE_LINE_FADE_IN_TIME 	= 3.0
const BACKGROUND_ALPHA				= 200

const array<asset> genImages =
[
	$"ui/menu/generation_icons/generation_0",
	$"ui/menu/generation_icons/generation_1",
	$"ui/menu/generation_icons/generation_2",
	$"ui/menu/generation_icons/generation_3",
	$"ui/menu/generation_icons/generation_4",
	$"ui/menu/generation_icons/generation_5",
	$"ui/menu/generation_icons/generation_6",
	$"ui/menu/generation_icons/generation_7",
	$"ui/menu/generation_icons/generation_8",
	$"ui/menu/generation_icons/generation_9"
]

struct {
	bool buttonsRegistered = false
	var menu = null
	array<var> advocateLines = []
	var genIcon = null
	var warningText = null
	var genButton = null
	var blackBackground = null
	var flare = null
	string bootText = ""
	var bootTextLabel = null
	var bootLogo = null
	bool textFadingIn = true
	bool regenSequenceStarted = false
} file

void function InitGenerationRespawnMenu()
{
	RegisterSignal( "StopCursorBlink" )

	var menu = GetMenu( "Generation_Respawn" )

	AddMenuEventHandler( menu, eUIEvent.MENU_OPEN, OnOpen_Generation_Respawn )
	AddMenuEventHandler( menu, eUIEvent.MENU_CLOSE, OnClose_Generation_Respawn )
	AddMenuEventHandler( menu, eUIEvent.MENU_NAVIGATE_BACK, OnGenerationRespawnMenu_NavigateBack )

	AddEventHandlerToButtonClass( menu, "GenerationRespawnButtonClass", UIE_CLICK, OnRegenButtonClick )

	//
	AddMenuFooterOption( menu, LEFT, BUTTON_B, true, "#B_BUTTON_BACK", "#B_BUTTON_BACK" )
}

bool function ShouldShowGenIcon()
{
	return GetGen() < genImages.len()
}

void function UpdateMenu()
{
	Assert( file.menu != null )

	file.advocateLines = []
	for ( int i = 0; i < NUM_ADVOCATE_LINES; i++ )
	{
		var elem = GetElem( file.menu, "AdvocateLine" + i )
		Hud_SetAlpha( elem, 0 )
		Hud_SetText( elem, "#GENERATION_RESPAWN_ADVOCATE_LINE" + i, "#GENERATION_NUMERIC_" + (GetGen() + 2) )
		Hud_Hide( elem )

		file.advocateLines.append( elem )
	}

	file.genIcon = GetElem( file.menu, "NextGenIcon" )
	Hud_SetAlpha( file.genIcon, 0 )
	if ( ShouldShowGenIcon() )
		Hud_SetImage( file.genIcon, genImages[ GetGen() ] )

	Hud_Hide( file.genIcon )

	string xpRate = format( "%.0f", 100.0 )

	file.warningText = GetElem( file.menu, "WarningText" )
	Hud_SetText( file.warningText, "#GENERATION_RESPAWN_CONFIRM_MESSAGE_0" )//
	Hud_SetAlpha( file.warningText, 0 )
	Hud_Hide( file.warningText )

	file.genButton = GetElem( file.menu, "GenerationRespawnButtonClass" )
	//
	Hud_SetEnabled( file.genButton, false )
	Hud_Hide( file.genButton )

	file.blackBackground = GetElem( file.menu, "blackBackground" )
	Hud_SetAlpha( file.blackBackground, BACKGROUND_ALPHA )
	Hud_Show( file.blackBackground )

	file.flare = GetElem( file.menu, "Flare" )
	Hud_SetAlpha( file.flare, 0 )
	Hud_Hide( file.flare )

	file.bootText = ""
	file.bootTextLabel = GetElem( file.menu, "BootText" )
	Hud_Hide( file.bootTextLabel )

	file.bootLogo = GetElem( file.menu, "BootLogo" )
	Hud_Hide( file.bootLogo )
}

void function OnOpen_Generation_Respawn()
{
	file.menu = GetMenu( "Generation_Respawn" )

	Signal( file.menu, "StopMenuAnimation" )
	EndSignal( file.menu, "StopMenuAnimation" )

	UpdateMenu()
	thread OpenMenuAnimated()

	WaitFrame()

	if ( !file.buttonsRegistered )
	{
		RegisterButtonPressedCallback( BUTTON_A, OpenMenuStatic )
		RegisterButtonPressedCallback( KEY_ENTER, OpenMenuStatic )
		RegisterButtonPressedCallback( KEY_SPACE, OpenMenuStatic )
		file.buttonsRegistered = true
	}
}

void function OnClose_Generation_Respawn()
{
	if ( file.buttonsRegistered )
	{
		DeregisterButtonPressedCallback( BUTTON_A, OpenMenuStatic )
		DeregisterButtonPressedCallback( KEY_ENTER, OpenMenuStatic )
		DeregisterButtonPressedCallback( KEY_SPACE, OpenMenuStatic )
		file.buttonsRegistered = false
	}

	Signal( file.menu, "StopMenuAnimation" )
}

void function OnGenerationRespawnMenu_NavigateBack()
{
	StopUISound( "UI_Pilot_Regenerate" )
	if ( file.regenSequenceStarted == false )
		CloseActiveMenu()
	else
		Signal( file.menu, "StopMenuAnimation" )
}

void function OpenMenuAnimated()
{
	OnThreadEnd(
		function() : ()
		{
			foreach ( elem in file.advocateLines )
			{
				Hud_SetAlpha( elem, 255 )
				Hud_Show( elem )
			}

			if ( ShouldShowGenIcon() )
			{
				Hud_SetAlpha( file.genIcon, 255 )
				Hud_Show( file.genIcon )
			}

			Hud_SetAlpha( file.warningText, 255 )
			Hud_Show( file.warningText )

			Hud_SetEnabled( file.genButton, true )
			Hud_Show( file.genButton )
			Hud_SetFocused( file.genButton )

			Hud_SetAlpha( file.blackBackground, BACKGROUND_ALPHA )

			file.textFadingIn = false
		}
	)

	Hud_SetAlpha( file.blackBackground, BACKGROUND_ALPHA )

	EndSignal( file.menu, "StopMenuAnimation" )

	Assert( file.advocateLines.len() == NUM_ADVOCATE_LINES )

	for ( int i = 0; i < file.advocateLines.len(); i++ )
	{
		Hud_Show( file.advocateLines[i] )
		Hud_FadeOverTimeDelayed( file.advocateLines[i], 255, ADVOCATE_LINE_FADE_IN_TIME, ADVOCATE_LINE_DELAY * i, INTERPOLATOR_ACCEL )
	}

	wait ADVOCATE_LINE_DELAY * file.advocateLines.len()

	if ( ShouldShowGenIcon() )
	{
		Hud_SetAlpha( file.genIcon, 0 )
		Hud_Show( file.genIcon )
	}
	Hud_FadeOverTimeDelayed( file.genIcon, 255, ADVOCATE_LINE_FADE_IN_TIME, 0.0, INTERPOLATOR_ACCEL )

	Hud_SetAlpha( file.warningText, 0 )
	Hud_Show( file.warningText )
	Hud_FadeOverTimeDelayed( file.warningText, 255, ADVOCATE_LINE_FADE_IN_TIME, 0.0, INTERPOLATOR_ACCEL )

	wait ADVOCATE_LINE_FADE_IN_TIME

	Hud_SetEnabled( file.genButton, true )
	Hud_Show( file.genButton )
	Hud_SetFocused( file.genButton )
}

void function OpenMenuStatic( var button )
{
	Signal( file.menu, "StopMenuAnimation" )
	StopUISound( "UI_Pilot_Regenerate" )
}

void function OnRegenButtonClick( var button )
{
	if ( file.buttonsRegistered )
	{
		DeregisterButtonPressedCallback( BUTTON_A, OpenMenuStatic )
		DeregisterButtonPressedCallback( KEY_ENTER, OpenMenuStatic )
		DeregisterButtonPressedCallback( KEY_SPACE, OpenMenuStatic )
		file.buttonsRegistered = false
	}

	DialogData dialogData
	dialogData.header = "#GENERATION_RESPAWN_CONFIRM_MESSAGE_1"

	AddDialogButton( dialogData, "#GENERATION_RESPAWN_CONFIRM_BUTTON_1", ConfirmRegen1 )
	AddDialogButton( dialogData, "#CANCEL" )

	AddDialogFooter( dialogData, "#A_BUTTON_SELECT" )
	AddDialogFooter( dialogData, "#B_BUTTON_CANCEL" )

	OpenDialog( dialogData )
}

void function ConfirmRegen1()
{
	DialogData dialogData
	dialogData.header = "#GENERATION_RESPAWN_CONFIRM_MESSAGE_2"

	AddDialogButton( dialogData, "#GENERATION_RESPAWN_CONFIRM_BUTTON_2", ConfirmRegen2 )
	AddDialogButton( dialogData, "#CANCEL" )

	AddDialogFooter( dialogData, "#A_BUTTON_SELECT" )
	AddDialogFooter( dialogData, "#B_BUTTON_CANCEL" )

	OpenDialog( dialogData )
}

void function ConfirmRegen2()
{
	DialogData dialogData
	dialogData.header = "#GENERATION_RESPAWN_CONFIRM_MESSAGE_3"

	AddDialogButton( dialogData, "#GENERATION_RESPAWN_CONFIRM_BUTTON_3", ConfirmRegen3 )
	AddDialogButton( dialogData, "#CANCEL" )

	AddDialogFooter( dialogData, "#A_BUTTON_SELECT" )
	AddDialogFooter( dialogData, "#B_BUTTON_CANCEL" )

	OpenDialog( dialogData )
}

void function ConfirmRegen3()
{
	GenUp()
}

void function GenUp()
{
	int currentGen = GetGen()

	//
	ClientCommand( "GenUp" )

	//
	thread RebootScreen( currentGen )
	//
}

//
//
//
//
//
//
//

void function RebootScreen( int lastGen )
{
	foreach ( elem in file.advocateLines )
		Hud_Hide( elem )
	Hud_Hide( file.genIcon )
	Hud_Hide( file.warningText )
	Hud_SetEnabled( file.genButton, false )
	Hud_Hide( file.genButton )
	Hud_SetAlpha( file.blackBackground, 255 )

	array<var> cancelButtons = GetElementsByClassname( file.menu, "cancelbuttons" )
	foreach ( elem in cancelButtons )
	{
		Hud_SetEnabled( elem, false )
		Hud_Hide( elem )
	}

	EmitUISound( "UI_Pilot_Regenerate" )

	OnThreadEnd(
		function() : ()
		{
			Hud_Hide( file.blackBackground )
			Hud_Hide( file.bootLogo )
			Hud_Hide( file.flare )
			Hud_Hide( file.bootTextLabel )
			if ( uiGlobal.loadingLevel == "" && IsConnected() )
				CloseActiveMenu()
		}
	)
	file.regenSequenceStarted = true
	EndSignal( file.menu, "StopMenuAnimation" )

	//
	//
	//

	Hud_SetScale( file.flare, 10.0, 10.0 )
	Hud_Show( file.flare )
	Hud_FadeOverTime( file.flare, 255, 1.0, INTERPOLATOR_ACCEL )
	wait 1.0
	Hud_Show( file.blackBackground )

	//
	//
	//

	if ( !file.buttonsRegistered )
	{
		RegisterButtonPressedCallback( BUTTON_A, OpenMenuStatic )
		RegisterButtonPressedCallback( KEY_ENTER, OpenMenuStatic )
		RegisterButtonPressedCallback( KEY_SPACE, OpenMenuStatic )
		file.buttonsRegistered = true
	}

	//
	//
	//

	Hud_ScaleOverTime( file.flare, 1.5, 0.05, 0.4, INTERPOLATOR_ACCEL )
	wait 0.4
	Hud_ScaleOverTime( file.flare, 0.2, 0.05, 0.15, INTERPOLATOR_LINEAR )
	Hud_FadeOverTimeDelayed( file.flare, 0, 0.05, 0.1, INTERPOLATOR_ACCEL )
	wait 1.15

	//
	//
	//

	Hud_SetText( file.bootTextLabel, "_" )
	Hud_Show( file.bootTextLabel )
	Hud_Show( file.bootLogo )

	thread BlinkCursor()
	wait 1.5

	//
	//
	//

	AddTextLine( "RSPN Modular X-BIOS v" + ( lastGen ) + "." + RandomIntRange( 10, 1000 ) )
	AddTextLine( "***ARES CLASS VI PROHIBITED DEVICE DETECTED***" )
	AddTextLine( "" )
	AddTextLine( "WP97-NT7-X" )

	wait 0.5

	float startTime = Time()

	AddTextLine( "" )
	AddTextLine( "" )
	AddTextLine( "RSPN Adaptive Bootloader v1.55" )
	AddTextLine( "Verifying Consistency" )
	for ( int i = 0; i < 15; i++ )
	{
		wait 0.08
		AddText( "." )
	}
	AddTextLine( "Done." )
	AddTextLine( "" )
	thread BlinkCursor()
	wait 1.0
	AddTypeLine( "exec regen_respawn_v2.cfg -loopback 255 -verbose" )
	AddTextLine( "" )
	AddTextLine( "Execing config: regen_respawn_v2.cfg" )
	wait 0.5
	AddTextLine( "" )
	AddTextLine( "Hunk_OnRegenStart: 155146160" )
	wait 0.2
	AddTextLine( "Validating Operator Credentials..." )
	wait 0.5
	AddTextLine( "OVERRIDE! Rescind code ARES-081699 accepted." )
	AddTextLine( "" )
	wait 0.3

	AddTextLine( "Backing up to /ext/xsdcard/" + ( lastGen ) + ".00" )
	wait 0.3
	AddTextLine( "Backing up /core/mem/weapons" )
	for ( int i = 0; i < 28; i++ )
	{
		wait 0.015
		AddText( "." )
	}
	wait 0.1
	AddTextLine( "Backing up /core/mem/titans" )
	for ( int i = 0; i < 6; i++ )
	{
		wait 0.15
		AddText( "." )
	}
	wait 0.1
	AddTextLine( "Backing up /core/mem/factions" )
	for ( int i = 0; i < 6; i++ )
	{
		wait 0.15
		AddText( "." )
	}
	wait 0.1
	AddTextLine( "Backing up /core/purchase_auth/*" )
	for ( int i = 0; i < 16; i++ )
	{
		wait 0.1
		AddText( "." )
	}

	wait 0.2
	AddTextLine( "Wrote 56 chunks in 12 blocks." )
	AddTextLine( "Generating md9sum" )
	for ( int i = 0; i < 8; i++ )
	{
		wait 0.05
		AddText( "." )
	}
	AddTextLine( "" )
	wait 0.4

	AddTextLine( "Flashing BIOS version " + ( lastGen + 1 ) + ".0" )
	for ( int i = 0; i < 15; i++ )
	{
		wait 0.15
		AddText( "." )
	}
	AddTextLine( "Done." )
	AddTextLine( "" )
	thread BlinkCursor()

	wait 0.5
	AddTypeLine( "cl_reboot -soft -restore -remote" )
	AddTextLine( "" )
	wait 1.0
	AddTextLine( "mnt /ext/xsdcard/" + ( lastGen ) + ".00" )
	AddTextLine( "Restore: writing blocks" )
	for ( int i = 0; i < 12; i++ )
	{
		wait 0.15
		AddText( "." )
	}
	AddTextLine( "Verify md9sum" )
	for ( int i = 0; i < 8; i++ )
	{
		wait 0.05
		AddText( "." )
	}
	AddTextLine( "Verified!  Regen complete in 0m " + int(Time() - startTime) + "s" )
	AddTextLine( "" )
	wait 0.5

	AddTextLine( "Reinitializing software, please wait..." )
	wait 3.5
}

void function AddTextLine( string text )
{
	Signal( file.bootTextLabel, "StopCursorBlink" )

	if ( file.bootText != "" )
		file.bootText += "\n"
	file.bootText += text
	Hud_SetText( file.bootTextLabel, file.bootText )
}

void function AddText( string text )
{
	Signal( file.bootTextLabel, "StopCursorBlink" )

	file.bootText += text
	Hud_SetText( file.bootTextLabel, file.bootText )
}

void function AddTypeLine( string text )
{
	if ( file.bootText != "" )
		file.bootText += "\n"
	for ( int i = 1; i < text.len() + 1; i++ )
	{
		AddText( text.slice( i - 1, i ) )
		wait 0.01
	}
}

void function BlinkCursor()
{
	EndSignal( file.bootTextLabel, "StopCursorBlink" )

	string oldText = file.bootText

	while ( true )
	{
		Hud_SetText( file.bootTextLabel, file.bootText + "\n_" )
		wait 0.25
		Hud_SetText( file.bootTextLabel, file.bootText + "\n" )
		wait 0.25
	}
}

asset function GetGenImage( int gen )
{
	return genImages[ gen ]
}
