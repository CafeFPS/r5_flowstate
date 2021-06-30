global function InitMusicPackPanel

struct
{
	var               panel
	//
	var               listPanel
	var               previewElem
	array<ItemFlavor> musicPackList
	string            playingPreviewAlias
} file

void function InitMusicPackPanel( var panel )
{
	file.panel = panel
	file.listPanel = Hud_GetChild( panel, "MusicPackList" )
	file.previewElem = Hud_GetChild( panel, "Preview" )
	//

	SetPanelTabTitle( panel, "#TAB_CUSTOMIZE_MUSIC_PACK" )
	//

	AddPanelEventHandler( panel, eUIEvent.PANEL_SHOW, MusicPacksPanel_OnShow )
	AddPanelEventHandler( panel, eUIEvent.PANEL_HIDE, MusicPacksPanel_OnHide )
	AddPanelEventHandler_FocusChanged( panel, MusicPacksPanel_OnFocusChanged )

	AddPanelFooterOption( panel, LEFT, BUTTON_B, true, "#B_BUTTON_BACK", "#B_BUTTON_BACK" )
	AddPanelFooterOption( panel, LEFT, BUTTON_A, false, "#A_BUTTON_SELECT", "", null, CustomizeMenus_IsFocusedItem )
	AddPanelFooterOption( panel, LEFT, BUTTON_X, false, "#X_BUTTON_EQUIP", "#X_BUTTON_EQUIP", null, CustomizeMenus_IsFocusedItemEquippable )
	AddPanelFooterOption( panel, LEFT, BUTTON_X, false, "#X_BUTTON_UNLOCK", "#X_BUTTON_UNLOCK", null, CustomizeMenus_IsFocusedItemLocked )
}


void function MusicPacksPanel_OnShow( var panel )
{
	AddCallback_OnTopLevelCustomizeContextChanged( panel, MusicPacksPanel_Update )
	MusicPacksPanel_Update( panel )
}


void function MusicPacksPanel_OnHide( var panel )
{
	RemoveCallback_OnTopLevelCustomizeContextChanged( panel, MusicPacksPanel_Update )
	MusicPacksPanel_Update( panel )
}


void function MusicPacksPanel_Update( var panel )
{
	var scrollPanel = Hud_GetChild( file.listPanel, "ScrollPanel" )

	//
	foreach ( int flavIdx, ItemFlavor unused in file.musicPackList )
	{
		var button = Hud_GetChild( scrollPanel, "GridButton" + flavIdx )
		CustomizeButton_UnmarkForUpdating( button )
	}
	file.musicPackList.clear()

	if ( file.playingPreviewAlias != "" )
		StopUISoundByName( file.playingPreviewAlias )
	file.playingPreviewAlias = ""

	//
	if ( IsPanelActive( file.panel ) )
	{
		LoadoutEntry entry = Loadout_MusicPack()
		file.musicPackList = GetLoadoutItemsSortedForMenu( entry, MusicPack_GetSortOrdinal )

		Hud_InitGridButtons( file.listPanel, file.musicPackList.len() )
		foreach ( int flavIdx, ItemFlavor flav in file.musicPackList )
		{
			var button = Hud_GetChild( scrollPanel, "GridButton" + flavIdx )
			CustomizeButton_UpdateAndMarkForUpdating( button, [entry], flav, PreviewMusicPack, null )
		}

		//
	}
}


void function MusicPacksPanel_OnFocusChanged( var panel, var oldFocus, var newFocus )
{
	if ( !IsValid( panel ) ) //
		return
	if ( GetParentMenu( panel ) != GetActiveMenu() )
		return

	UpdateFooterOptions()
}


void function PreviewMusicPack( ItemFlavor flav )
{
	Assert( ItemFlavor_GetType( flav ) == eItemType.music_pack )

	var rui = Hud_GetRui( file.previewElem )
	RuiSetBool( rui, "isVisible", true )
	RuiSetBool( rui, "battlepass", true )
	RuiSetInt( rui, "rarity", ItemFlavor_GetQuality( flav ) )
	RuiSetImage( rui, "portraitImage", MusicPack_GetPortraitImage( flav ) )
	RuiSetFloat( rui, "portraitBlend", MusicPack_GetPortraitBlend( flav ) )
	RuiSetString( rui, "quipTypeText", "#MUSIC_PACK" )
	//
	//

	string previewAlias = MusicPack_GetPreviewMusic( flav )

	if ( previewAlias == file.playingPreviewAlias )
		return

	if ( file.playingPreviewAlias != "" )
		StopUISoundByName( file.playingPreviewAlias )

	EmitUISound( previewAlias )
	file.playingPreviewAlias = previewAlias
}


