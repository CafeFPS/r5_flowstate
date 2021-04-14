global function InitEULADialog
global function OpenEULADialog
global function OpenEULAReviewFromFooter
global function IsEULAAccepted
global function IsLobbyAndEULAAccepted

struct
{
	var menu
	var agreement
	var acknowledgement
	var footersPanel
	int eulaVersion
	bool reviewing
} file


void function InitEULADialog()
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


void function OpenEULAReviewFromFooter( var button )
{
	OpenEULADialog( true )
}


void function OpenEULADialog( bool review )
{
	file.reviewing = review
	AdvanceMenu( file.menu )
}


void function EULADialog_OnOpen()
{
	file.eulaVersion = GetCurrentEULAVersion()

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
