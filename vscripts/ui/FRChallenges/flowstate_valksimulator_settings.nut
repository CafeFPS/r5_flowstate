global function InitValkSimulatorSettings
global function OpenValkSimulatorSettings
global function CloseValkSimulatorSettings

struct
{
	var menu
	bool modifyLocalBeam = true
} file

void function OpenValkSimulatorSettings()
{
	CloseAllMenus()
	EmitUISound("UI_Menu_SelectMode_Extend")
	AdvanceMenu( file.menu )
}

void function CloseValkSimulatorSettings()
{
	CloseAllMenus()
}

void function InitValkSimulatorSettings( var newMenuArg )
{
	var menu = GetMenu( "ValkSimulatorSettings" )
	file.menu = menu
	
    AddMenuEventHandler( menu, eUIEvent.MENU_SHOW, OnR5RSB_Show )
	AddMenuEventHandler( menu, eUIEvent.MENU_OPEN, OnR5RSB_Open )
	AddMenuEventHandler( menu, eUIEvent.MENU_CLOSE, OnR5RSB_Close )
	AddMenuEventHandler( menu, eUIEvent.MENU_NAVIGATE_BACK, OnR5RSB_NavigateBack )

	AddButtonEventHandler( Hud_GetChild( file.menu, "RButton" ), UIE_CHANGE, RButton )

	AddButtonEventHandler( Hud_GetChild( file.menu, "SelectBeamToModifyButton_Local" ), UIE_CLICK, BeamToModifyChanged_Local )
	AddButtonEventHandler( Hud_GetChild( file.menu, "SelectBeamToModifyButton_Enemy" ), UIE_CLICK, BeamToModifyChanged_Enemy )
	AddButtonEventHandler( Hud_GetChild( file.menu, "SelectBeamToModifyButton_Enemy2" ), UIE_CLICK, BeamToModifyChanged_Enemy2 )

	RuiSetInt( Hud_GetRui( Hud_GetChild( file.menu, "SelectBeamToModifyButton_Local" ) ), "status", eFriendStatus.ONLINE_INGAME )
	RuiSetInt( Hud_GetRui( Hud_GetChild( file.menu, "SelectBeamToModifyButton_Enemy" ) ), "status", eFriendStatus.ONLINE_AWAY )
	RuiSetInt( Hud_GetRui( Hud_GetChild( file.menu, "SelectBeamToModifyButton_Enemy2" ) ), "status", eFriendStatus.ONLINE_INGAME )
	
	//Mode
	AddButtonEventHandler( Hud_GetChild( file.menu, "Mode1_Button" ), UIE_CLICK, Mode1Select )
	AddButtonEventHandler( Hud_GetChild( file.menu, "Mode2_Button" ), UIE_CLICK, Mode2Select )
	AddButtonEventHandler( Hud_GetChild( file.menu, "Mode3_Button" ), UIE_CLICK, Mode3Select )
	AddButtonEventHandler( Hud_GetChild( file.menu, "Mode4_Button" ), UIE_CLICK, Mode4Select )

	RuiSetInt( Hud_GetRui( Hud_GetChild( file.menu, "Mode1_Button" ) ), "status", eFriendStatus.ONLINE_INGAME )
	RuiSetInt( Hud_GetRui( Hud_GetChild( file.menu, "Mode2_Button" ) ), "status", eFriendStatus.ONLINE_INGAME )
	RuiSetInt( Hud_GetRui( Hud_GetChild( file.menu, "Mode3_Button" ) ), "status", eFriendStatus.ONLINE_AWAY )
	RuiSetInt( Hud_GetRui( Hud_GetChild( file.menu, "Mode4_Button" ) ), "status", eFriendStatus.ONLINE_INGAME )
	
	BeamToModifyChanged_Enemy( null )
}

void function FormationChanged_Single( var button )
{
	ClientCommand( "CC_AimTrainer_ValkUlt_FormationType 0" )

	RuiSetInt( Hud_GetRui( Hud_GetChild( file.menu, "FormationSingle_Button" ) ), "status", eFriendStatus.ONLINE_AWAY )
	RuiSetInt( Hud_GetRui( Hud_GetChild( file.menu, "FormationSquad_Button" ) ), "status", eFriendStatus.ONLINE_INGAME )
}

void function FormationChanged_Squad( var button )
{
	ClientCommand( "CC_AimTrainer_ValkUlt_FormationType 1" )

	RuiSetInt( Hud_GetRui( Hud_GetChild( file.menu, "FormationSingle_Button" ) ), "status", eFriendStatus.ONLINE_INGAME )
	RuiSetInt( Hud_GetRui( Hud_GetChild( file.menu, "FormationSquad_Button" ) ), "status", eFriendStatus.ONLINE_AWAY )
}

void function Mode1Select( var button ) 
{
	ClientCommand( "CC_AimTrainer_ValkUlt_Mode 0" )
	SetConVarInt( "hud_setting_accessibleChat", 3000)
	ClientCommand( "CC_AimTrainer_ValkUlt_Height 3000")

	RuiSetInt( Hud_GetRui( Hud_GetChild( file.menu, "Mode1_Button" ) ), "status", eFriendStatus.ONLINE_AWAY )
	RuiSetInt( Hud_GetRui( Hud_GetChild( file.menu, "Mode2_Button" ) ), "status", eFriendStatus.ONLINE_INGAME )
	RuiSetInt( Hud_GetRui( Hud_GetChild( file.menu, "Mode3_Button" ) ), "status", eFriendStatus.ONLINE_INGAME )
	RuiSetInt( Hud_GetRui( Hud_GetChild( file.menu, "Mode4_Button" ) ), "status", eFriendStatus.ONLINE_INGAME )
}

void function Mode2Select( var button ) 
{
	ClientCommand( "CC_AimTrainer_ValkUlt_Mode 1" )
	SetConVarInt( "hud_setting_accessibleChat", 3500)
	ClientCommand( "CC_AimTrainer_ValkUlt_Height 3500")

	RuiSetInt( Hud_GetRui( Hud_GetChild( file.menu, "Mode1_Button" ) ), "status", eFriendStatus.ONLINE_INGAME )
	RuiSetInt( Hud_GetRui( Hud_GetChild( file.menu, "Mode2_Button" ) ), "status", eFriendStatus.ONLINE_AWAY )
	RuiSetInt( Hud_GetRui( Hud_GetChild( file.menu, "Mode3_Button" ) ), "status", eFriendStatus.ONLINE_INGAME )
	RuiSetInt( Hud_GetRui( Hud_GetChild( file.menu, "Mode4_Button" ) ), "status", eFriendStatus.ONLINE_INGAME )
}

void function Mode3Select( var button ) 
{
	ClientCommand( "CC_AimTrainer_ValkUlt_Mode 2" )
	SetConVarInt( "hud_setting_accessibleChat", 6000)
	ClientCommand( "CC_AimTrainer_ValkUlt_Height 6000")

	RuiSetInt( Hud_GetRui( Hud_GetChild( file.menu, "Mode1_Button" ) ), "status", eFriendStatus.ONLINE_INGAME )
	RuiSetInt( Hud_GetRui( Hud_GetChild( file.menu, "Mode2_Button" ) ), "status", eFriendStatus.ONLINE_INGAME )
	RuiSetInt( Hud_GetRui( Hud_GetChild( file.menu, "Mode3_Button" ) ), "status", eFriendStatus.ONLINE_AWAY )
	RuiSetInt( Hud_GetRui( Hud_GetChild( file.menu, "Mode4_Button" ) ), "status", eFriendStatus.ONLINE_INGAME )
}

void function Mode4Select( var button ) 
{
	ClientCommand( "CC_AimTrainer_ValkUlt_Mode 3" )
	SetConVarInt( "hud_setting_accessibleChat", 6000)
	ClientCommand( "CC_AimTrainer_ValkUlt_Height 6000")

	RuiSetInt( Hud_GetRui( Hud_GetChild( file.menu, "Mode1_Button" ) ), "status", eFriendStatus.ONLINE_INGAME )
	RuiSetInt( Hud_GetRui( Hud_GetChild( file.menu, "Mode2_Button" ) ), "status", eFriendStatus.ONLINE_INGAME )
	RuiSetInt( Hud_GetRui( Hud_GetChild( file.menu, "Mode3_Button" ) ), "status", eFriendStatus.ONLINE_INGAME )
	RuiSetInt( Hud_GetRui( Hud_GetChild( file.menu, "Mode4_Button" ) ), "status", eFriendStatus.ONLINE_AWAY )
}

void function BeamToModifyChanged_Local( var button )
{
	ClientCommand( "CC_AimTrainer_ValkUlt_StrafeType 0" )

	RuiSetInt( Hud_GetRui( Hud_GetChild( file.menu, "SelectBeamToModifyButton_Local" ) ), "status", eFriendStatus.ONLINE_AWAY )
	RuiSetInt( Hud_GetRui( Hud_GetChild( file.menu, "SelectBeamToModifyButton_Enemy" ) ), "status", eFriendStatus.ONLINE_INGAME )
	RuiSetInt( Hud_GetRui( Hud_GetChild( file.menu, "SelectBeamToModifyButton_Enemy2" ) ), "status", eFriendStatus.ONLINE_INGAME )

	Hud_SetVisible( Hud_GetChild( file.menu, "GButtonText" ), false )
	Hud_SetVisible( Hud_GetChild( file.menu, "GButton" ), false )
	Hud_SetVisible( Hud_GetChild( file.menu, "GTextBox" ), false )

	Hud_SetVisible( Hud_GetChild( file.menu, "GButtonText2" ), false )
	Hud_SetVisible( Hud_GetChild( file.menu, "GButton2" ), false )
	Hud_SetVisible( Hud_GetChild( file.menu, "GTextBox2" ), false )

	Hud_SetVisible( Hud_GetChild( file.menu, "BButtonText" ), false )
	Hud_SetVisible( Hud_GetChild( file.menu, "BButton" ), false )
	Hud_SetVisible( Hud_GetChild( file.menu, "BTextBox" ), false )
}

void function BeamToModifyChanged_Enemy( var button )
{
	ClientCommand( "CC_AimTrainer_ValkUlt_StrafeType 1" )

	RuiSetInt( Hud_GetRui( Hud_GetChild( file.menu, "SelectBeamToModifyButton_Local" ) ), "status", eFriendStatus.ONLINE_INGAME )
	RuiSetInt( Hud_GetRui( Hud_GetChild( file.menu, "SelectBeamToModifyButton_Enemy" ) ), "status", eFriendStatus.ONLINE_AWAY )
	RuiSetInt( Hud_GetRui( Hud_GetChild( file.menu, "SelectBeamToModifyButton_Enemy2" ) ), "status", eFriendStatus.ONLINE_INGAME )
	
	Hud_SetVisible( Hud_GetChild( file.menu, "GButtonText" ), true )
	Hud_SetVisible( Hud_GetChild( file.menu, "GButton" ), true )
	Hud_SetVisible( Hud_GetChild( file.menu, "GTextBox" ), true )

	Hud_SetVisible( Hud_GetChild( file.menu, "GButtonText2" ), false )
	Hud_SetVisible( Hud_GetChild( file.menu, "GButton2" ), false )
	Hud_SetVisible( Hud_GetChild( file.menu, "GTextBox2" ), false )

	Hud_SetVisible( Hud_GetChild( file.menu, "BButtonText" ), false )
	Hud_SetVisible( Hud_GetChild( file.menu, "BButton" ), false )
	Hud_SetVisible( Hud_GetChild( file.menu, "BTextBox" ), false )
}

void function BeamToModifyChanged_Enemy2( var button )
{
	ClientCommand( "CC_AimTrainer_ValkUlt_StrafeType 2" )

	RuiSetInt( Hud_GetRui( Hud_GetChild( file.menu, "SelectBeamToModifyButton_Local" ) ), "status", eFriendStatus.ONLINE_INGAME )
	RuiSetInt( Hud_GetRui( Hud_GetChild( file.menu, "SelectBeamToModifyButton_Enemy" ) ), "status", eFriendStatus.ONLINE_INGAME )
	RuiSetInt( Hud_GetRui( Hud_GetChild( file.menu, "SelectBeamToModifyButton_Enemy2" ) ), "status", eFriendStatus.ONLINE_AWAY )

	Hud_SetVisible( Hud_GetChild( file.menu, "GButtonText" ), false )
	Hud_SetVisible( Hud_GetChild( file.menu, "GButton" ), false )
	Hud_SetVisible( Hud_GetChild( file.menu, "GTextBox" ), false )

	Hud_SetVisible( Hud_GetChild( file.menu, "GButtonText2" ), true )
	Hud_SetVisible( Hud_GetChild( file.menu, "GButton2" ), true )
	Hud_SetVisible( Hud_GetChild( file.menu, "GTextBox2" ), true )

	Hud_SetVisible( Hud_GetChild( file.menu, "BButtonText" ), true )
	Hud_SetVisible( Hud_GetChild( file.menu, "BButton" ), true )
	Hud_SetVisible( Hud_GetChild( file.menu, "BTextBox" ), true )
}

void function SetSettingsMenuOpen( bool open )
{
	// RunClientScript( "LGDuels_SetSettingsMenuOpen", open )
}


void function RButton(var button)
{
	float desiredVar = GetConVarFloat( "hud_setting_adsDof" )
	ClientCommand( "CC_AimTrainer_ValkUlt_DiveAngle " + desiredVar.tostring() )
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
	CloseValkSimulatorSettings()
}

void function OnR5RSB_NavigateBack()
{
	CloseValkSimulatorSettings()
}