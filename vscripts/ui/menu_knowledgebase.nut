global function InitKnowledgeBaseMenu
global function HaveNewPatchNotes
global function HaveNewCommunityNotes

//

struct
{
	array<var> subjectButtons
	int lastSelectedIndex
	var descriptionRui
} file

void function InitKnowledgeBaseMenu()
{
	var menu = GetMenu( "KnowledgeBaseMenu" )
	file.lastSelectedIndex = 0

	int visibleButtonCount = (KNB_SUBJECT_COUNT + 1)	//
	for ( int idx = 0; idx < 15; ++idx )
	{
		string btnName = "BtnKNBSubject" + format( "%02d", idx )
		var button = Hud_GetChild( menu, btnName )
		file.subjectButtons.append( button )

		if ( idx > (visibleButtonCount - 1) )
		{
			Hud_SetVisible( button, false )
			continue
		}

		string labelText = (idx == 0) ? format( "#COMMUNITYUPDATE_NAME" ) : format( "#KNB_SUBJECT_%02d_NAME", (idx - 1) )

		Hud_SetVisible( button, true )
		SetButtonRuiText( button, labelText )
		AddButtonEventHandler( button, UIE_CLICK, OnKBNSubjectButtonClick )
		AddButtonEventHandler( button, UIE_GET_FOCUS, OnKBNSubjectButtonFocus )
	}

	var ruiContainer = Hud_GetChild( menu, "LabelDetails" )
	file.descriptionRui = Hud_GetRui( ruiContainer )

	AddMenuEventHandler( menu, eUIEvent.MENU_OPEN, OnOpenKnowledgeBaseMenu )
	AddMenuFooterOption( menu, LEFT, BUTTON_A, true, "#A_BUTTON_SELECT" )
	AddMenuFooterOption( menu, LEFT, BUTTON_B, true, "#B_BUTTON_BACK", "#B_BUTTON_BACK" )
}

int function GetPatchNotesCurrentVersion()
{
	return GetCurrentPlaylistVarInt( "faq_patchnotes_version", -1 )
}

int function GetPatchNotesLastSeenVersion()
{
	return GetConVarInt( "menu_faq_patchnotes_version" )
}

bool function HaveNewPatchNotes()
{
	int lastSeenVersion = GetPatchNotesLastSeenVersion()
	int currentVersion = GetPatchNotesCurrentVersion()
	if ( lastSeenVersion < currentVersion )
		return true
	return false
}

void function MarkPatchNotesAsCurrent()
{
	int currentVersion = GetPatchNotesCurrentVersion()
	if ( currentVersion < 0 )
		return

	int lastSeenVersion = GetPatchNotesLastSeenVersion()
	if ( lastSeenVersion == currentVersion )
		return

	SetConVarInt( "menu_faq_patchnotes_version", currentVersion )
}

//
int function GetCommunityNotesCurrentVersion()
{
	return GetCurrentPlaylistVarInt( "faq_community_version", -1 )
}

int function GetCommunityNotesLastSeenVersion()
{
	return GetConVarInt( "menu_faq_community_version" )
}

bool function HaveNewCommunityNotes()
{
	int lastSeenVersion = GetCommunityNotesLastSeenVersion()
	int currentVersion = GetCommunityNotesCurrentVersion()
	if ( lastSeenVersion < currentVersion )
		return true
	return false
}

void function MarkCommunityNotesAsCurrent()
{
	int currentVersion = GetCommunityNotesCurrentVersion()
	if ( currentVersion < 0 )
		return

	int lastSeenVersion = GetCommunityNotesLastSeenVersion()
	if ( lastSeenVersion == currentVersion )
		return

	SetConVarInt( "menu_faq_community_version", currentVersion )
}

//

void function OnOpenKnowledgeBaseMenu()
{
	UI_SetPresentationType( ePresentationType.NO_MODELS )

	RuiSetGameTime( file.descriptionRui, "initTime", Time() )

	SetConVarBool( "menu_faq_viewed", true )

	SetNamedRuiBool( file.subjectButtons[0], "isNew", HaveNewCommunityNotes() )
	SetNamedRuiBool( file.subjectButtons[1], "isNew", HaveNewPatchNotes() )

	thread HACK_DelayedSetFocus_BecauseWhy( file.subjectButtons[file.lastSelectedIndex] )
}

void function OnKBNSubjectButtonClick( var button )
{
	int buttonIDRaw = int( Hud_GetScriptID( button ) )
	file.lastSelectedIndex = buttonIDRaw

	if ( buttonIDRaw == 0 )
	{
		MarkCommunityNotesAsCurrent()
		AdvanceToKnowledgeBaseSubmenu( KNB_COMMUNITY_INDEX )
	}
	else
	{
		int buttonID = (buttonIDRaw - 1)
		if ( buttonID == KNB_PATCHNOTES_INDEX )
			MarkPatchNotesAsCurrent()
		AdvanceToKnowledgeBaseSubmenu( buttonID )
	}
}

void function OnKBNSubjectButtonFocus( var button )
{
	int buttonIDRaw = int( Hud_GetScriptID( button ) )

	RuiSetGameTime( file.descriptionRui, "startTime", Time() )

	if ( buttonIDRaw == 0 )
	{
		string descText = format( "#COMMUNITYUPDATE_DESC" )
		RuiSetString( file.descriptionRui, "messageText", Localize( descText ) )
		RuiSetBool( file.descriptionRui, "isNew", HaveNewCommunityNotes() )
	}
	else
	{
		int buttonID = (buttonIDRaw - 1)
		string descText = format( "#KNB_SUBJECT_%02d_DESC", buttonID )
		RuiSetString( file.descriptionRui, "messageText", Localize( descText ) )
		RuiSetBool( file.descriptionRui, "isNew", (buttonID == KNB_PATCHNOTES_INDEX) && HaveNewPatchNotes() )
	}
}

