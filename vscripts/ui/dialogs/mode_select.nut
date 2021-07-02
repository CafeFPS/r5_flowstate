global function InitModeSelectDialog

struct {
	var menu

	var modeSelectPopup
	var modeList

	var closeButton

	table<var, string> buttonToMode

} file

void function InitModeSelectDialog( var newMenuArg )
{
	var menu = GetMenu( "ModeSelectDialog" )
	file.menu = menu

	SetDialog( menu, true )
	SetClearBlur( menu, false )

	file.modeSelectPopup = Hud_GetChild( menu, "ModeSelectPopup" )
	AddMenuEventHandler( menu, eUIEvent.MENU_OPEN, OnOpenModeSelectDialog )
	AddMenuEventHandler( menu, eUIEvent.MENU_CLOSE, OnCloseModeSelectDialog )

	file.modeList = Hud_GetChild( file.modeSelectPopup, "ModeList" )

	file.closeButton = Hud_GetChild( menu, "CloseButton" )
	Hud_AddEventHandler( file.closeButton, UIE_CLICK, OnCloseButton_Activate )
}


void function OnOpenModeSelectDialog()
{
	// TEMP START
	foreach ( button, playlistName in file.buttonToMode )
	{
		Hud_RemoveEventHandler( button, UIE_CLICK, OnModeButton_Activate )
	}
	file.buttonToMode.clear()
	// TEMP END

	var ownerButton = GetModeSelectButton()

	UIPos ownerPos   = REPLACEHud_GetAbsPos( ownerButton )
	UISize ownerSize = REPLACEHud_GetSize( ownerButton )

	array<string> playlists = Lobby_GetPlaylists()

	Hud_InitGridButtons( file.modeList, playlists.len() )
	var scrollPanel = Hud_GetChild( file.modeList, "ScrollPanel" )
	for ( int i = 0; i < playlists.len(); i++ )
	{
		var button = Hud_GetChild( scrollPanel, ("GridButton" + i) )

		if ( i == 0 )
		{
			int buttonHeight = Hud_GetHeight( button )
			int popupHeight = buttonHeight * playlists.len()
			Hud_SetPos( file.modeSelectPopup, ownerPos.x, ownerPos.y - popupHeight )
			Hud_SetSize( file.modeSelectPopup, ownerSize.width, popupHeight )
			Hud_SetSize( file.modeList, ownerSize.width, popupHeight )

			Hud_SetFocused( button )
			Hud_SetSelected( button, true )
		}

		ModeButton_Init( button, playlists[i] )
	}
}


void function OnCloseModeSelectDialog()
{
	var modeSelectButton = GetModeSelectButton()
	Hud_SetSelected( modeSelectButton, false )
	Hud_SetFocused( modeSelectButton )
}


void function ModeButton_Init( var button, string playlistName )
{
	var lobbyModeSelectButton = GetModeSelectButton()
	//Assert( Hud_GetWidth( lobbyModeSelectButton ) == Hud_GetWidth( button ), "" + Hud_GetWidth( lobbyModeSelectButton ) + " != " + Hud_GetWidth( button ) )

	InitButtonRCP( button )
	var rui = Hud_GetRui( button )

	string name = GetPlaylistVarString( playlistName, "name", "#HUD_UNKNONWN" )
	RuiSetString( rui, "buttonText", Localize( name ) )

	bool isPlaylistAvailable = Lobby_IsPlaylistAvailable( playlistName )

	if ( !isPlaylistAvailable )
	{
		ToolTipData toolTipData
		toolTipData.titleText = "#PLAYLIST_UNAVAILABLE"
		toolTipData.descText = Lobby_GetPlaylistStateString( Lobby_GetPlaylistState( playlistName ) )

		Hud_SetToolTipData( button, toolTipData )
	}
	else
	{
		ToolTipData toolTipData
		toolTipData.titleText = "" //name
		toolTipData.descText = GetPlaylistVarString( playlistName, "description", "#HUD_UNKNOWN" )

		Hud_SetToolTipData( button, toolTipData )
	}

	Hud_SetLocked( button, !isPlaylistAvailable )
	Hud_AddEventHandler( button, UIE_CLICK, OnModeButton_Activate )
	file.buttonToMode[button] <- playlistName
}


void function OnModeButton_Activate( var button )
{
	if ( Hud_IsLocked( button ) )
		return

	Lobby_SetSelectedPlaylist( file.buttonToMode[button] )
	CloseAllDialogs()
}


void function OnCloseButton_Activate( var button )
{
	CloseAllDialogs()
}