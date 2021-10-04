global function InitEULADialog
global function OpenEULADialog
global function IsEULAAccepted
global function IsLobbyAndEULAAccepted

struct
{
	var menu
	var agreement
	var acknowledgement
	var footersPanel
	var parentMenuPanel
	int eulaVersion
	bool reviewing
} file


void function InitEULADialog( var newMenuArg )
{
	var menu = GetMenu( "EULADialog" )
	file.menu = menu

	SetDialog( menu, true )
	SetGamepadCursorEnabled( menu, false )

	file.agreement = Hud_GetChild( menu, "Agreement" )
	file.acknowledgement = Hud_GetRui( Hud_GetChild( menu, "Acknowledgement" ) )
	file.footersPanel = Hud_GetChild( menu, "FooterButtons" )

	AddMenuFooterOption( menu, LEFT, BUTTON_A, true, "#A_BUTTON_ACCEPT", "#A_BUTTON_ACCEPT", AcceptEULA, IsNotReviewingAndStandardVersion )
	AddMenuFooterOption( menu, LEFT, BUTTON_A, true, "#A_BUTTON_CONTINUE", "#A_BUTTON_CONTINUE", AcceptEULA, IsNotReviewingAndEUVersion )
	AddMenuFooterOption( menu, LEFT, BUTTON_B, true, "#B_BUTTON_DECLINE", "#B_BUTTON_DECLINE", null, IsNotReviewingAndStandardVersion )
	AddMenuFooterOption( menu, LEFT, BUTTON_B, true, "#B_BUTTON_CANCEL", "#CANCEL", null, IsNotReviewingAndEUVersion )
	AddMenuFooterOption( menu, LEFT, BUTTON_B, true, "#B_BUTTON_CLOSE", "#CLOSE", null, IsReviewing )

	AddMenuEventHandler( menu, eUIEvent.MENU_OPEN, EULADialog_OnOpen )
	AddMenuEventHandler( menu, eUIEvent.MENU_CLOSE, EULADialog_OnClose )
}


bool function IsReviewing()
{
	return file.reviewing
}


bool function IsEUVersion()
{
	return ShouldUserSeeEULAForEU()
}


bool function IsNotReviewingAndStandardVersion()
{
	return !IsReviewing() && !IsEUVersion()
}


bool function IsNotReviewingAndEUVersion()
{
	return !IsReviewing() && IsEUVersion()
}


void function OpenEULADialog( bool review, var parentMenu = null )
{
	file.reviewing = review
	file.parentMenuPanel = parentMenu
	AdvanceMenu( file.menu )
}


void function EULADialog_OnOpen()
{
	file.eulaVersion = GetCurrentEULAVersion()

	if( file.reviewing && file.parentMenuPanel != null )
		ScrollPanel_SetActive( file.parentMenuPanel, false )
		
	RegisterStickMovedCallback( ANALOG_RIGHT_Y, FocusAgreementForScrolling )
	RegisterButtonPressedCallback( BUTTON_DPAD_UP, FocusAgreementForScrolling )
	RegisterButtonPressedCallback( BUTTON_DPAD_DOWN, FocusAgreementForScrolling )

	var frameElem = Hud_GetChild( file.menu, "DialogFrame" )
	RuiSetImage( Hud_GetRui( frameElem ), "basicImage", $"rui/menu/common/dialog_gradient" )

	int agreementHeight = IsReviewing() ? 480 : 410
	Hud_SetHeight( file.agreement, ContentScaledYAsInt( agreementHeight ) )

	string acknowledgementText = ""
	if ( !IsReviewing() )
		acknowledgementText = IsEUVersion() ? "#EULA_ACKNOWLEDGEMENT_EU" : "#EULA_ACKNOWLEDGEMENT"
	RuiSetArg( file.acknowledgement, "acknowledgementText", Localize( acknowledgementText ) )

	int footerPanelWidth = IsReviewing() ? 200 : 422
	Hud_SetWidth( file.footersPanel, ContentScaledXAsInt( footerPanelWidth ) )
}


void function EULADialog_OnClose()
{
	if ( uiGlobal.launching )
	{
		if ( IsEULAAccepted() )
			PrelaunchValidateAndLaunch()
		else
			SetLaunchState( eLaunchState.WAIT_TO_CONTINUE, "", Localize( "#MAINMENU_CONTINUE" ) )
	}

	if( file.reviewing && file.parentMenuPanel != null )
		ScrollPanel_SetActive( file.parentMenuPanel, true )

	DeregisterStickMovedCallback( ANALOG_RIGHT_Y, FocusAgreementForScrolling )
	DeregisterButtonPressedCallback( BUTTON_DPAD_UP, FocusAgreementForScrolling )
	DeregisterButtonPressedCallback( BUTTON_DPAD_DOWN, FocusAgreementForScrolling )
}


void function AcceptEULA( var button )
{
	SetEULAVersionAccepted( file.eulaVersion )
	CloseActiveMenu()
}


bool function IsEULAAccepted()
{
	return GetEULAVersionAccepted() >= GetCurrentEULAVersion()
}


bool function IsLobbyAndEULAAccepted()
{
	return IsLobby() &&	IsEULAAccepted()
}

void function FocusAgreementForScrolling( ... )
{
	if( !Hud_IsFocused( file.agreement ) )
		Hud_SetFocused( file.agreement );
}