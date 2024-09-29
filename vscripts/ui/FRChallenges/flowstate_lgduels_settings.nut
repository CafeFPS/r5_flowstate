global function InitLGDuelsSettings
global function OpenLGDuelsSettings
global function CloseLGDuelsSettings
global function LoadLgDuelSettings

struct
{
	var menu
	bool modifyLocalBeam = true
} file

void function OpenLGDuelsSettings()
{
	CloseAllMenus()
	EmitUISound("UI_Menu_SelectMode_Extend")
	AdvanceMenu( file.menu )
	SetSettingsMenuOpen( true )
}

void function CloseLGDuelsSettings()
{	
	SetSettingsMenuOpen( false )
	CloseAllMenus()
} 

void function InitLGDuelsSettings( var newMenuArg )
{
	var menu = GetMenu( "FRLGDuelsSettings" )
	file.menu = menu
	
    AddMenuEventHandler( menu, eUIEvent.MENU_SHOW, OnR5RSB_Show )
	AddMenuEventHandler( menu, eUIEvent.MENU_OPEN, OnR5RSB_Open )
	AddMenuEventHandler( menu, eUIEvent.MENU_CLOSE, OnR5RSB_Close )
	AddMenuEventHandler( menu, eUIEvent.MENU_NAVIGATE_BACK, OnR5RSB_NavigateBack )
	AddButtonEventHandler( Hud_GetChild( file.menu, "RButton" ), UIE_CHANGE, RButton )
	AddButtonEventHandler( Hud_GetChild( file.menu, "GButton" ), UIE_CHANGE, GButton )
	AddButtonEventHandler( Hud_GetChild( file.menu, "BButton" ), UIE_CHANGE, BButton )
	
	AddButtonEventHandler( Hud_GetChild( file.menu, "PresetGreenButton" ), UIE_CLICK, PresetGreenButton )
	AddButtonEventHandler( Hud_GetChild( file.menu, "PresetRedButton" ), UIE_CLICK, PresetRedButton )
	AddButtonEventHandler( Hud_GetChild( file.menu, "PresetBlueButton" ), UIE_CLICK, PresetBlueButton )
	AddButtonEventHandler( Hud_GetChild( file.menu, "PresetPurpleButton" ), UIE_CLICK, PresetPurpleButton )
	AddButtonEventHandler( Hud_GetChild( file.menu, "PresetYellowButton" ), UIE_CLICK, PresetYellowButton )
	
	AddButtonEventHandler( Hud_GetChild( file.menu, "SelectBeamToModifyButton_Local" ), UIE_CLICK, BeamToModifyChanged_Local )
	AddButtonEventHandler( Hud_GetChild( file.menu, "SelectBeamToModifyButton_Enemy" ), UIE_CLICK, BeamToModifyChanged_Enemy )

	RuiSetInt( Hud_GetRui( Hud_GetChild( file.menu, "SelectBeamToModifyButton_Local" ) ), "status", eFriendStatus.ONLINE_AWAY )
	RuiSetInt( Hud_GetRui( Hud_GetChild( file.menu, "SelectBeamToModifyButton_Enemy" ) ), "status", eFriendStatus.ONLINE_INGAME )
}

void function BeamToModifyChanged_Local( var button )
{
	RuiSetInt( Hud_GetRui( Hud_GetChild( file.menu, "SelectBeamToModifyButton_Local" ) ), "status", eFriendStatus.ONLINE_AWAY )
	RuiSetInt( Hud_GetRui( Hud_GetChild( file.menu, "SelectBeamToModifyButton_Enemy" ) ), "status", eFriendStatus.ONLINE_INGAME )
	
	file.modifyLocalBeam = true
	RunClientScript( "LGDuels_SetModifyingLocalBeam", file.modifyLocalBeam )
}

void function BeamToModifyChanged_Enemy( var button )
{
	RuiSetInt( Hud_GetRui( Hud_GetChild( file.menu, "SelectBeamToModifyButton_Local" ) ), "status", eFriendStatus.ONLINE_INGAME )
	RuiSetInt( Hud_GetRui( Hud_GetChild( file.menu, "SelectBeamToModifyButton_Enemy" ) ), "status", eFriendStatus.ONLINE_AWAY )
	
	file.modifyLocalBeam = false
	RunClientScript( "LGDuels_SetModifyingLocalBeam", file.modifyLocalBeam )
}

void function SetSettingsMenuOpen( bool open )
{
	RunClientScript( "LGDuels_SetSettingsMenuOpen", open )
}

void function PresetRedButton(var button)
{
	RunClientScript( "LGDuels_SetPresetRed", file.modifyLocalBeam )
}

void function PresetGreenButton(var button)
{
	RunClientScript( "LGDuels_SetPresetGreen", file.modifyLocalBeam )
}

void function PresetYellowButton(var button)
{
	RunClientScript( "LGDuels_SetPresetYellow", file.modifyLocalBeam )
}

void function PresetBlueButton(var button)
{
	RunClientScript( "LGDuels_SetPresetBlue", file.modifyLocalBeam )
}

void function PresetPurpleButton(var button)
{
	RunClientScript( "LGDuels_SetPresetPurple", file.modifyLocalBeam )
}

void function RButton(var button)
{
	int desiredVar = GetConVarInt( "noise_filter_scale" )
	RunClientScript( "LGDuels_SetR", desiredVar, file.modifyLocalBeam )
}

void function GButton(var button)
{
	int desiredVar = GetConVarInt( "net_minimumPacketLossDC" )
	RunClientScript( "LGDuels_SetG", desiredVar, file.modifyLocalBeam )
}

void function BButton(var button)
{
	int desiredVar = GetConVarInt( "net_wifi" )
	RunClientScript( "LGDuels_SetB", desiredVar, file.modifyLocalBeam )
}

void function OnR5RSB_Show()
{
    //
}

void function OnR5RSB_Open()
{
	//
}


void function OnR5RSB_Close()
{
	RunClientScript( "LGDuels_SaveToServerPersistence" )
	CloseLGDuelsSettings()
}

void function OnR5RSB_NavigateBack()
{
	CloseLGDuelsSettings()
}

void function LoadLgDuelSettings( float s1, int s2, int s3, int s4, float s5, int s6, int s7, int s8  )
{	//TODO: Deprecate
	//printt("Running LGDuels_SetFromPersistence with : ", s1, s2, s3, s4)
	RunClientScript( "LGDuels_SetFromPersistence", s1, s2, s3, s4, s5, s6, s7, s8 )
}
