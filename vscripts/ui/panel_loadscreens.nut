#if CLIENT
global function UpdateLoadscreenPreviewMaterial
global function ClLoadscreensInit
#endif

#if UI
global function InitLoadscreenPanel
#endif

struct
{
	#if UI
		var               panel
		//
		var               listPanel
		var               scrollPanel
		var               descriptionElem
		array<ItemFlavor> loadscreenList
		var               loadscreenElem
	#endif

	#if CLIENT
		array<PakHandle> pakHandles
	#endif
} file

#if CLIENT
void function ClLoadscreensInit()
{
	RegisterSignal( "UpdateLoadscreenPreviewMaterial" )
}
#endif

#if UI
void function InitLoadscreenPanel( var panel )
{
	file.panel = panel
	file.listPanel = Hud_GetChild( panel, "LoadscreenList" )
	//
	file.loadscreenElem = Hud_GetChild( panel, "LoadscreenImage" )
	file.descriptionElem = Hud_GetChild( panel, "DescriptionText" )

	SetPanelTabTitle( panel, "#TAB_CUSTOMIZE_LOADSCREEN" )
	//

	AddPanelEventHandler( panel, eUIEvent.PANEL_SHOW, LoadscreenPanel_OnShow )
	AddPanelEventHandler( panel, eUIEvent.PANEL_HIDE, LoadscreenPanel_OnHide )
	AddPanelEventHandler_FocusChanged( panel, LoadscreenPanel_OnFocusChanged )

	AddPanelFooterOption( panel, LEFT, BUTTON_B, true, "#B_BUTTON_BACK", "#B_BUTTON_BACK" )
	AddPanelFooterOption( panel, LEFT, BUTTON_A, false, "#A_BUTTON_SELECT", "", null, CustomizeMenus_IsFocusedItem )
	AddPanelFooterOption( panel, LEFT, BUTTON_X, false, "#X_BUTTON_EQUIP", "#X_BUTTON_EQUIP", null, CustomizeMenus_IsFocusedItemEquippable )
	AddPanelFooterOption( panel, LEFT, BUTTON_X, false, "#X_BUTTON_UNLOCK", "#X_BUTTON_UNLOCK", null, CustomizeMenus_IsFocusedItemLocked )
}

void function LoadscreenPanel_OnShow( var panel )
{
	AddCallback_OnTopLevelCustomizeContextChanged( panel, LoadscreenPanel_Update )
	LoadscreenPanel_Update( panel )
	AddCallback_ItemFlavorLoadoutSlotDidChange_SpecificPlayer( LocalClientEHI(), Loadout_Loadscreen(), OnLoadscreenEquipChanged )
}


void function LoadscreenPanel_OnHide( var panel )
{
	RemoveCallback_OnTopLevelCustomizeContextChanged( panel, LoadscreenPanel_Update )
	LoadscreenPanel_Update( panel )
	RemoveCallback_ItemFlavorLoadoutSlotDidChange_SpecificPlayer( LocalClientEHI(), Loadout_Loadscreen(), OnLoadscreenEquipChanged )
}


void function OnLoadscreenEquipChanged( EHI playerEHI, ItemFlavor flavor )
{
	if ( GetPlaylistVarBool( Lobby_GetSelectedPlaylist(), "force_level_loadscreen", false ) )
		Lobby_UpdateLoadscreenFromPlaylist()
	else
		thread Loadscreen_SetCustomLoadscreen( flavor )
}


void function LoadscreenPanel_Update( var panel )
{
	var scrollPanel = Hud_GetChild( file.listPanel, "ScrollPanel" )

	//
	foreach ( int flavIdx, ItemFlavor unused in file.loadscreenList )
	{
		var button = Hud_GetChild( scrollPanel, "GridButton" + flavIdx )
		CustomizeButton_UnmarkForUpdating( button )
	}
	file.loadscreenList.clear()

	RunClientScript( "UpdateLoadscreenPreviewMaterial", file.loadscreenElem, file.descriptionElem, 0 )

	//
	if ( IsPanelActive( file.panel ) )
	{
		LoadoutEntry entry = Loadout_Loadscreen()
		file.loadscreenList = GetLoadoutItemsSortedForMenu( entry, Loadscreen_GetSortOrdinal )

		Hud_InitGridButtons( file.listPanel, file.loadscreenList.len() )
		foreach ( int flavIdx, ItemFlavor flav in file.loadscreenList )
		{
			var button = Hud_GetChild( scrollPanel, "GridButton" + flavIdx )
			CustomizeButton_UpdateAndMarkForUpdating( button, [entry], flav, PreviewLoadscreen, null )
		}

		//
	}
}


void function LoadscreenPanel_OnFocusChanged( var panel, var oldFocus, var newFocus )
{
	if ( !IsValid( panel ) ) //
		return
	if ( GetParentMenu( panel ) != GetActiveMenu() )
		return

	UpdateFooterOptions()
}


void function PreviewLoadscreen( ItemFlavor flav )
{
	RunClientScript( "UpdateLoadscreenPreviewMaterial", file.loadscreenElem, file.descriptionElem, ItemFlavor_GetGUID( flav ) )
}
#endif //

#if CLIENT
void function UpdateLoadscreenPreviewMaterial( var loadscreenElem, var descriptionElem, SettingsAssetGUID guid )
{
	//
	thread UpdateLoadscreenPreviewMaterial_internal( loadscreenElem, descriptionElem, guid )
}

void function UpdateLoadscreenPreviewMaterial_internal( var loadscreenElem, var descriptionElem, SettingsAssetGUID guid )
{
	Signal( clGlobal.signalDummy, "UpdateLoadscreenPreviewMaterial" )
	EndSignal( clGlobal.signalDummy, "UpdateLoadscreenPreviewMaterial" )

	//
	RuiSetImage( Hud_GetRui( loadscreenElem ), "loadscreenImage", $"" )
	Hud_SetVisible( loadscreenElem, false )
	if ( descriptionElem != null )
	{
		RuiSetString( Hud_GetRui( descriptionElem ), "descText", "" )
		Hud_SetVisible( descriptionElem, false )
	}

	OnThreadEnd(
		function() : ()
		{
			//
			foreach( handle in file.pakHandles )
			{
				if ( handle.isAvailable )
					ReleasePakFile( handle )
			}
		}
	)

	if ( guid == 0 )
		return

	//
	ItemFlavor flavor = GetItemFlavorByGUID( guid )
	Assert( ItemFlavor_GetType( flavor ) == eItemType.loadscreen )
	asset loadscreenImage = Loadscreen_GetLoadscreenImageAsset( flavor )

	if ( loadscreenImage == $"" )
		return

	WaitFrame() //

	Hud_SetVisible( loadscreenElem, true )

	//
	string rpak         = Loadscreen_GetRPakName( flavor )
	PakHandle pakHandle = RequestPakFile( rpak )
	file.pakHandles.append( pakHandle )

	if ( !pakHandle.isAvailable )
		WaitSignal( pakHandle, "PakFileLoaded" )

	RuiSetImage( Hud_GetRui( loadscreenElem ), "loadscreenImage", loadscreenImage )
	Hud_SetVisible( loadscreenElem, true )

	if ( descriptionElem != null )
	{
		RuiSetString( Hud_GetRui( descriptionElem ), "descText", Localize( Loadscreen_GetImageOverlayText( flavor ) ) )
		Hud_SetVisible( descriptionElem, true )
	}

	WaitForever()
}

#endif
