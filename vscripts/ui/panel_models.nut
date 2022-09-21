global function InitModelsPanel
global function ModelsPanel_SetMap

struct PanelData
{
	var panel
	var weaponNameRui
	var listPanel
	var charmsButton

	int index
	//ItemFlavor ornull weaponOrNull
}


struct
{
	table<var, PanelData> panelDataMap

	var         currentPanel = null
	string      currentMap
	string      currentModel

	bool charmsMenuActive = false
	table<int, array<string> > indexedPanelAssets
} file


void function InitModelsPanel( var panel )
{
	Assert( !(panel in file.panelDataMap) )

	if (file.panelDataMap.len() == 0) {
		// ADD mdl/base_models as a default
		InitPanelAssets("")
	}

	PanelData pd
	file.panelDataMap[ panel ] <- pd

	pd.weaponNameRui = Hud_GetRui( Hud_GetChild( panel, "WeaponName" ) )
	pd.index = file.panelDataMap.len() - 1
	if (pd.index > 3) pd.index = 3
	printl("INDEX: " + pd.index)
	pd.listPanel = Hud_GetChild( panel, "WeaponSkinList" )

	AddUICallback_InputModeChanged( OnInputModeChanged )

	AddPanelEventHandler( panel, eUIEvent.PANEL_SHOW, ModelsPanel_OnShow )
	AddPanelEventHandler( panel, eUIEvent.PANEL_HIDE, ModelsPanel_OnHide )
	AddPanelEventHandler_FocusChanged( panel, ModelsPanel_OnFocusChanged )

	AddPanelFooterOption( panel, LEFT, BUTTON_B, true, "#B_BUTTON_BACK", "#B_BUTTON_BACK" )
	AddPanelFooterOption( panel, LEFT, BUTTON_A, false, "#A_BUTTON_SELECT", "", null, CustomizeModelMenus_IsFocusedItem )
	AddPanelFooterOption( panel, LEFT, BUTTON_X, false, "#X_BUTTON_EQUIP", "#X_BUTTON_EQUIP", null, CustomizeModelMenus_IsFocusedItemEquippable )
	AddPanelFooterOption( panel, LEFT, BUTTON_X, false, "#X_BUTTON_UNLOCK", "#X_BUTTON_UNLOCK", null, CustomizeModelMenus_IsFocusedItemLocked )
	AddPanelFooterOption( panel, LEFT, BUTTON_TRIGGER_LEFT, false, "#MENU_ZOOM_CONTROLS_GAMEPAD", "#MENU_ZOOM_CONTROLS", null, ZoomFooter_IsVisible )
	//AddPanelFooterOption( panel, LEFT, BUTTON_DPAD_LEFT, false, "#DPAD_LEFT_RIGHT_SWITCH_CHARACTER", "", PrevButton_OnActivate )
	//AddPanelFooterOption( panel, LEFT, BUTTON_DPAD_RIGHT, false, "", "", NextButton_OnActivate )
}


bool function ZoomFooter_IsVisible()
{
	bool result = CharmsFooter_IsVisible()
	return result
}


bool function SkinsFooter_IsVisible()
{
	return IsCharmsMenuActive()
}

bool function CharmsFooter_IsVisible()
{
	bool result = IsCharmsMenuActive()
	return !result
}

void function InitPanelAssets(string map) {
	file.indexedPanelAssets [0] <- ["mdl/base_models"]

	// if (map == "") return

	array<string> sections = GetMapSections(map) //!FIXME
	printl("LEN / 4: " + sections.len() / 4)
	printl(sections.len())
	if (sections.len() / 4 < 1) {
		// if you cant even fit more than 1 section just put it all in the first one
		file.indexedPanelAssets[0] <- sections
		printl("Only 1 lmao")
	} else {
		int last = 0
		int increment = ceil((sections.len() / 4)).tointeger()

		// Divide all sections accross 4 panels
		// I somehow did this without hurting my brain.. maybe i'm smart
		for(int i = 0; i < 4; i++) {
			int x = i + 1
			int index = increment * x
			bool completed = index > sections.len() - 1
			if (completed) {
				index = sections.len() - 1
			}

			array<string> panelSections = sections.slice(last, index)
			file.indexedPanelAssets[i] <- panelSections
			printl("PANEL ASSETS: " + i.tostring())
			foreach(sec in panelSections) {
				printl(sec)
			}
			if(completed) {
				break
			}
			last = index
		}
	}
}

void function CharmsButton_Update( var button )
{
	string buttonText
	bool controllerActive = IsControllerModeActive()

	if ( file.charmsMenuActive )
		buttonText = controllerActive ? "#CONTROLLER_SKINS_BUTTON" : "#SKINS_BUTTON"
	else
		buttonText = controllerActive ? "#CONTROLLER_CHARMS_BUTTON" : "#CHARMS_BUTTON"

	HudElem_SetRuiArg( button, "centerText", buttonText )
	UpdateFooterOptions()
}


void function CharmsButton_OnRightStickClick( var button )
{
	EmitUISound( "UI_Menu_accept" )
	CharmsButton_OnClick( button )
}

void function CharmsButton_OnClick( var button )
{
	//CharmsMenuEnableOrDisable()
}

void function OnInputModeChanged( bool controllerModeActive )
{
}

void function ModelsPanel_OnShow( var panel )
{
	printl("ModelsPanel: OnShow")
	RunClientScript( "EnableModelTurn" )

	file.currentPanel = panel

	// (dw): Customize context is already being used for the category, which is unfortunate.
	//AddCallback_OnTopLevelCustomizeContextChanged( panel, ModelsPanel_Update )
	//SetCustomizeContext( PanelData_Get( panel ).weapon )

	thread TrackIsOverScrollBar( file.panelDataMap[panel].listPanel )

	ModelsPanel_Update( panel, true)
}


void function ModelsPanel_OnHide( var panel )
{
	printl("ModelsPanel: OnHide")
	//RemoveCallback_OnTopLevelCustomizeContextChanged( panel, ModelsPanel_Update )
	Signal( uiGlobal.signalDummy, "TrackIsOverScrollBar" )

	RunClientScript( "EnableModelTurn" )
	ModelsPanel_Update( panel, false)
}


void function ModelsPanel_Update( var panel, bool first)// TODO: IMPLEMENT
{
	PanelData pd    = file.panelDataMap[panel]
	var scrollPanel = Hud_GetChild( pd.listPanel, "ScrollPanel" )
	array<string> assetList = GetPanelAssets(pd)

	// cleanup
	if (!first) {
		foreach ( int flavIdx, string unused in assetList)
		{
			var button = Hud_GetChild( scrollPanel, "GridButton" + flavIdx )
			CustomizeModelButton_UnmarkForUpdating( button )
		}
	}

	CustomizeModelMenus_SetActionButton( null )

	// setup, but only if we're active
	if ( IsPanelActive( panel ))
	{
		
		void functionref( string ) previewFunc
        void functionref( string, void functionref() proceedCb) confirmationFunc
		bool ignoreDefaultItemForCount

		previewFunc = PreviewModel
        confirmationFunc = OnEquipped
		ignoreDefaultItemForCount = false
		
		RuiSetString( pd.weaponNameRui, "text", Localize( "Models" ).toupper() )

		Hud_InitGridButtons( pd.listPanel, assetList.len() )

		foreach ( int flavIdx, string ass in assetList )
		{
			var button = Hud_GetChild( scrollPanel, "GridButton" + flavIdx )
			CustomizeModelButton_UpdateAndMarkForUpdating( button, assetList, ass, previewFunc, confirmationFunc )
		}

		CustomizeModelMenus_SetActionButton( Hud_GetChild( panel, "ActionButton" ) )
	}
}

array<string> function GetPanelAssets(PanelData data) {
	if (file.indexedPanelAssets.len() - 1 < data.index) {
		return file.indexedPanelAssets[file.indexedPanelAssets.len() - 1]
	}
	return file.indexedPanelAssets[data.index]
}

void function ModelsPanel_OnFocusChanged( var panel, var oldFocus, var newFocus )
{
	if ( !IsValid( panel ) ) // uiscript_reset
		return
	if ( GetParentMenu( panel ) != GetActiveMenu() )
		return

	UpdateFooterOptions()

	if ( IsControllerModeActive() )
		CustomizeModelMenus_UpdateActionContext( newFocus )
}

void function PreviewModel( string model ) {
	RunClientScript("UIToClient_PreviewModel", model, false)
}

void function ModelsPanel_SetMap( string map ) {
	file.currentMap = map
	InitPanelAssets(map)
	printl("SET MAP TO " + map)
	foreach(key, value in file.panelDataMap) {
		ModelsPanel_Update(key, true)
	}
}

array<string> function deserialize(string serialized) {	
	array<string> assets = split(serialized, ",")
	array<string> result = []

	foreach(ass in assets) {
		printl(ass)
		result.append(ass)
	}

	return result
}

void function OnEquipped(string mdl, void functionref() proceedCb) {
	RunClientScript("SetEquippedSection", mdl)
    proceedCb()
}