
global function InitEstablishUserPanel

struct
{
	var menu
	var panel
	var errorDisplay

	var signInStatus
} file

void function InitEstablishUserPanel( var panel )
{
	RegisterSignal( "EndShowEstablishUserPanel" )

	file.panel = panel
	file.menu = GetParentMenu( file.panel )

	AddPanelEventHandler( file.panel, eUIEvent.PANEL_SHOW, OnShowEstablishUserPanel )
	AddPanelEventHandler( file.panel, eUIEvent.PANEL_HIDE, OnHideEstablishUserPanel )

	file.errorDisplay = Hud_GetChild( file.panel, "ErrorDisplay" )
	Hud_EnableKeyBindingIcons( Hud_GetChild( file.errorDisplay, "ContinueFooter" ) )

	file.signInStatus = Hud_GetChild( file.panel, "SignInStatus" )
	Hud_EnableKeyBindingIcons( file.signInStatus )

	//AddPanelFooterOption( file.panel, LEFT, BUTTON_A, false, "#A_BUTTON_SELECT" )
	//AddPanelFooterOption( file.panel, LEFT, BUTTON_B, false, "#B_BUTTON_CLOSE", "#CLOSE" )
	//AddPanelFooterOption( file.panel, LEFT, BUTTON_BACK, false, "", "", ClosePostGameMenu )
}

void function OnShowEstablishUserPanel( var panel )
{
	thread EstablishUserPanelThink( panel )
}


void function EstablishUserPanelThink( var panel )
{
	Signal( uiGlobal.signalDummy, "EndShowEstablishUserPanel" )
	EndSignal( uiGlobal.signalDummy, "EndShowEstablishUserPanel" )

	string sig = string( Time() )
	printt( sig + "Hud_IsVisible for register panel:", Hud_IsVisible( file.panel ) )

	int state
	int lastState = -1

	//ShowError( "Example error string!" )
	//ShowSignInStatus( "#A_BUTTON_START" )
	//return

	while ( Hud_IsVisible( file.panel ) )
	{
		state = GetUserSignInState()

		if ( state != lastState )
		{
			if ( lastState == -1 )
				printt( sig + "userSignInState changed from: -1 to:", GetEnumString( "userSignInState", state ) )
			else
				printt( sig + "userSignInState changed from:", GetEnumString( "userSignInState", lastState ), "to:", GetEnumString( "userSignInState", state ) )

			//if ( state == userSignInState.SIGNED_IN && lastState != -1 )
			//	wait 0.1 // wait an extra frame so that old input from the newly activated controller doesn't activate the play button.

			if ( state == userSignInState.ERROR )
			{
				ShowError( Durango_GetErrorString() )
			}
			else if ( state == userSignInState.SIGNED_OUT )
			{
				if ( IsDialog( GetActiveMenu() ) ) // Close data center dialog if it's open
					CloseActiveMenu( true )

				ShowSignInStatus( "#A_BUTTON_START" )
			}
			else if ( state == userSignInState.SIGNING_IN )
			{
				ShowSignInStatus( "#SIGNING_IN" )
			}
		}

		lastState = state

		WaitFrame()
	}
}

void function OnHideEstablishUserPanel( var panel )
{
	Signal( uiGlobal.signalDummy, "EndShowEstablishUserPanel" )
}

void function ShowError( string error )
{
	Hud_Hide( file.signInStatus )

	var frameElem = Hud_GetRui( Hud_GetChild( file.errorDisplay, "DialogFrame" ) )
	var imageElem = Hud_GetRui( Hud_GetChild( file.errorDisplay, "DialogImage" ) )
	var headerElem = Hud_GetChild( file.errorDisplay, "DialogHeader" )
	var messageElem = Hud_GetRui( Hud_GetChild( file.errorDisplay, "DialogMessageRui" ) )
	var footerElem = Hud_GetChild( file.errorDisplay, "ContinueFooter" )

	RuiSetImage( frameElem, "basicImage", $"rui/menu/common/dialog_gradient" )
	RuiSetImage( imageElem, "basicImage", $"ui/menu/common/dialog_error" )
	Hud_SetText( headerElem, "#ERROR" )
	RuiSetString( messageElem, "messageText", error )
	Hud_SetText( footerElem, "#A_BUTTON_CONTINUE" )

	Hud_Show( file.errorDisplay )
}

void function ShowSignInStatus( string status )
{
	Hud_Hide( file.errorDisplay )

	Hud_SetText( file.signInStatus, status )
	Hud_Show( file.signInStatus )
}
