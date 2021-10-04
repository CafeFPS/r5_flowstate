global function InitSettingsPanel
global function SettingsPanel_NavigateToSavedSelection
global function SettingsPanel_GetDefaultImageForIndex

global function SetupSettingsButton
global function SetupSettingsSlider

global function CreateSettingsConVarData
global function SaveSettingsConVars
global function AnySettingsConVarChanged


global enum eConVarType
{
	INT,
	STRING,
	FLOAT,
	BOOL
}

global struct ConVarData
{
	string conVar
	int conVarType
	string value
}

struct
{
	bool justOpened
	var  savedButton

	table<var, string> buttonTitles
	table<var, string> buttonDescriptions
	table<var, asset>  buttonImages
	table<var, bool>   additionalWidget
	var                detailsPanel
	var				   panel

	bool			   anyChanged

	array<asset> panelDefaultImages
} file

void function InitSettingsPanel( var panel )
{
	AddPanelEventHandler( panel, eUIEvent.PANEL_SHOW, OnSettingsPanel_Show )
	AddPanelEventHandler( panel, eUIEvent.PANEL_HIDE, OnSettingsPanel_Hide )

	file.panel = panel
	file.detailsPanel = Hud_GetChild( panel, "DetailsPanel" )

	SetTabRightSound( panel, "UI_Menu_SettingsTab_Select" )
	SetTabLeftSound( panel, "UI_Menu_SettingsTab_Select" )

	AddPanelFooterOption( panel, LEFT, BUTTON_B, true, "#B_BUTTON_CLOSE", "#CLOSE" )

	{
		AddTab( panel, Hud_GetChild( panel, "HudOptionsPanel" ), "#HUD" )
		AddPanelEventHandler( Hud_GetChild( panel, "HudOptionsPanel" ), eUIEvent.PANEL_SHOW, OnSettingsTab_Show )
		file.panelDefaultImages.append( $"rui/menu/settings/settings_hud" )
	}

	#if PC_PROG
		{
			AddTab( panel, Hud_GetChild( panel, "ControlsPCPanelContainer" ), "#MOUSE_KEYBOARD" )
			AddPanelEventHandler( Hud_GetChild( panel, "ControlsPCPanelContainer" ), eUIEvent.PANEL_SHOW, OnSettingsTab_Show )
			file.panelDefaultImages.append( $"rui/menu/settings/settings_pc" )
		}
	#endif

	{
		AddTab( panel, Hud_GetChild( panel, "ControlsGamepadPanel" ), "#CONTROLLER" )
		AddPanelEventHandler( Hud_GetChild( panel, "ControlsGamepadPanel" ), eUIEvent.PANEL_SHOW, OnSettingsTab_Show )
		file.panelDefaultImages.append( $"rui/menu/settings/settings_gamepad" )
	}

	{
		TabDef tabDef = AddTab( panel, Hud_GetChild( panel, "VideoPanelContainer" ), "#VIDEO" )
		tabDef.canNavigateFunc = bool function( var panel, int desiredTabIndex )
		{
			return OnVideoMenu_CanNavigateAway( panel, desiredTabIndex )
		}

		AddPanelEventHandler( Hud_GetChild( panel, "VideoPanelContainer" ), eUIEvent.PANEL_SHOW, OnSettingsTab_Show )
		file.panelDefaultImages.append( $"rui/menu/settings/settings_video" )
	}

	{
		AddTab( panel, Hud_GetChild( panel, "SoundPanel" ), "#AUDIO" )
		AddPanelEventHandler( Hud_GetChild( panel, "SoundPanel" ), eUIEvent.PANEL_SHOW, OnSettingsTab_Show )
		file.panelDefaultImages.append( $"rui/menu/settings/settings_audio" )
	}
}


asset function SettingsPanel_GetDefaultImageForIndex( int index )
{
	return file.panelDefaultImages[index]
}


void function OnSettingsPanel_Show( var panel )
{
	TabData tabData = GetTabDataForPanel( panel )
	ActivateTab( tabData, tabData.activeTabIdx )

	file.anyChanged = false
}


void function OnSettingsTab_Show( var panel )
{
	TabData tabData = GetTabDataForPanel( file.panel )

	var rui = Hud_GetRui( Settings_GetDetailPanel( panel ) )
	RuiSetArg( rui, "headerText", "" )
	RuiSetArg( rui, "selectionText", "" )
	RuiSetArg( rui, "descText", "" )
	RuiSetAsset( rui, "detailImage", SettingsPanel_GetDefaultImageForIndex( tabData.activeTabIdx ) )
}

void function OnSettingsPanel_Hide( var panel )
{
	TabData tabData = GetTabDataForPanel( panel )
	DeactivateTab( tabData )

	if ( file.anyChanged )
	{
		// synchronize convars that appear in multiple tabs
		SaveSettingsConVars( SoundPanel_GetConVarData() )
		SaveSettingsConVars( GameplayPanel_GetConVarData() )
		SaveSettingsConVars( ControlsPCPanel_GetConVarData() )
		SaveSettingsConVars( ControlsGamepadPanel_GetConVarData() )

		table settingsTable = {
			Audio = SettingsConVarsToTable( SoundPanel_GetConVarData() ),
			Gameplay = SettingsConVarsToTable( GameplayPanel_GetConVarData() ),
			ControlsPC = SettingsConVarsToTable( ControlsPCPanel_GetConVarData() ),
			ControlsGamepad = SettingsConVarsToTable( ControlsGamepadPanel_GetConVarData() ),
		}

		PIN_Settings( settingsTable )

		if ( IsFullyConnected() )
			RunClientScript( "UIToClient_SettingsUpdated" )
	}
}


table function SettingsConVarsToTable( array<ConVarData> conVarDataList )
{
	table settingsTable = {}

	foreach ( conVarData in conVarDataList )
	{
		settingsTable[conVarData.conVar] <- conVarData.value
	}

	return settingsTable
}



void function SettingsPanel_NavigateToSavedSelection()
{
}


var function SetupSettingsButton( var button, string buttonText, string description, asset image, bool showAdditional = false )
{
	SetButtonRuiText( button, buttonText )
	file.buttonTitles[ button ] <- buttonText
	file.buttonDescriptions[ button ] <- description
	file.buttonImages[ button ] <- image
	file.additionalWidget[ button ] <- showAdditional

	if ( Hud_HasChild( button, "RightButton" ) )
	{
		var childButton = Hud_GetChild( button, "RightButton" )
		AddButtonEventHandler( childButton, UIE_GET_FOCUS, SettingsButton_GetFocus )
		AddButtonEventHandler( childButton, UIE_LOSE_FOCUS, SettingsButton_LoseFocus )
		file.buttonTitles[ childButton ] <- buttonText
		file.buttonDescriptions[ childButton ] <- description
		file.buttonImages[ childButton ] <- image
		file.additionalWidget[ childButton ] <- showAdditional
	}
	if ( Hud_HasChild( button, "LeftButton" ) )
	{
		var childButton = Hud_GetChild( button, "LeftButton" )
		AddButtonEventHandler( childButton, UIE_GET_FOCUS, SettingsButton_GetFocus )
		AddButtonEventHandler( childButton, UIE_LOSE_FOCUS, SettingsButton_LoseFocus )
		file.buttonTitles[ childButton ] <- buttonText
		file.buttonDescriptions[ childButton ] <- description
		file.buttonImages[ childButton ] <- image
		file.additionalWidget[ childButton ] <- showAdditional
	}

	AddButtonEventHandler( button, UIE_GET_FOCUS, SettingsButton_GetFocus )
	AddButtonEventHandler( button, UIE_LOSE_FOCUS, SettingsButton_LoseFocus )

	//ToolTipData toolTipData
	//toolTipData.titleText = buttonText
	//toolTipData.descText = description
	//Hud_SetToolTipData( button, toolTipData )

	return button
}

array<var> function SetupSettingsSlider( var slider, string buttonText, string description, asset image, bool showAdditional = false )
{
	var dropButton = Hud_GetChild( slider, "BtnDropButton" )

	SetButtonRuiText( dropButton, buttonText )
	file.buttonTitles[ dropButton ] <- buttonText
	file.buttonDescriptions[ dropButton ] <- description
	file.buttonImages[ dropButton ] <- image
	file.additionalWidget[ dropButton ] <- showAdditional

	AddButtonEventHandler( dropButton, UIE_GET_FOCUS, DropButton_GetFocus )
	AddButtonEventHandler( dropButton, UIE_LOSE_FOCUS, DropButton_GetFocus )
	Hud_AddEventHandler( slider, UIE_GET_FOCUS, ScrollIntoView_OnFocus )

	return [dropButton, slider]
}

void function DisplaySettingInfoForButton( var button, var rui )
{
	RuiSetArg( rui, "selectionText", file.buttonTitles[ button ] )
	RuiSetArg( rui, "descText", file.buttonDescriptions[ button ] )
	RuiSetAsset( rui, "detailImage", file.buttonImages[ button ] )
	RuiSetBool( rui, "showCbInfo", file.additionalWidget[ button ] )
}

void function SettingsButton_GetFocus( var button )
{
	DisplaySettingInfoForButton( button, Hud_GetRui( Settings_GetDetailPanel( button ) ) )
	ScrollIntoView_OnFocus( button )
}

void function SettingsButton_LoseFocus( var button )
{
	TabData tabData = GetTabDataForPanel( file.panel )

	var rui = Hud_GetRui( Settings_GetDetailPanel( button ) )
	RuiSetArg( rui, "selectionText", "" )
	RuiSetArg( rui, "descText", "" )
	RuiSetAsset( rui, "detailImage", SettingsPanel_GetDefaultImageForIndex( tabData.activeTabIdx ) )
	RuiSetBool( rui, "showCbInfo", false )
}


void function SettingsButton_Activate( var button )
{
	var rui = Hud_GetRui( Settings_GetDetailPanel( button ) )
	RuiSetArg( rui, "selectionText", file.buttonTitles[ button ] )
	RuiSetArg( rui, "descText", file.buttonDescriptions[ button ] )
	RuiSetAsset( rui, "detailImage", file.buttonImages[ button ] )
}

void function DropButton_GetFocus( var button )
{
	DisplaySettingInfoForButton( button, Hud_GetRui( Settings_GetDetailPanel( button ) ) )
}

void function ScrollIntoView_OnFocus( var panel )
{
	ScrollPanel_ScrollIntoView( file.panel )
}


var function Settings_GetDetailPanel( var button )
{
	var parentElement = Hud_GetParent( button )
	while ( parentElement != null )
	{
		if ( Hud_HasChild( parentElement, "DetailsPanel" ) )
			return Hud_GetChild( parentElement, "DetailsPanel" )

		parentElement = Hud_GetParent( parentElement )
	}

	Assert( false, "Should be unreachable" )
	return file.detailsPanel
}


ConVarData function CreateSettingsConVarData( string conVar, int conVarType )
{
	ConVarData conVarData
	conVarData.conVar = conVar
	conVarData.conVarType = conVarType
	conVarData.value = GetConVarString( conVar )

	return conVarData
}


void function SaveSettingsConVars( array<ConVarData> savedConVarData )
{
	if ( AnySettingsConVarChanged( savedConVarData ) )
		file.anyChanged = true

	foreach ( conVarData in savedConVarData )
	{
		conVarData.value = GetConVarString( conVarData.conVar )
	}
}


bool function AnySettingsConVarChanged( array<ConVarData> savedConVarData )
{
	foreach ( conVarData in savedConVarData )
	{
		switch ( conVarData.conVarType )
		{
			case eConVarType.INT:
				if ( int( conVarData.value ) != GetConVarInt( conVarData.conVar ) )
					return true
			case eConVarType.FLOAT:
				if ( float( conVarData.value ) != GetConVarFloat( conVarData.conVar ) )
					return true
			case eConVarType.STRING:
				if ( conVarData.value != GetConVarString( conVarData.conVar ) )
					return true
			case eConVarType.BOOL:
				if ( (int( conVarData.value ) != 0) != GetConVarBool( conVarData.conVar ) )
					return true
		}
	}

	return false
}
