global function InitMGSettings
global function OpenMGSettings
global function CloseMGSettings

struct
{
	var mg_menu
} file

void function OpenMGSettings()
{
	CloseAllMenus()
	EmitUISound("UI_Menu_SelectMode_Extend")
	AdvanceMenu( file.mg_menu )
}

void function CloseMGSettings()
{
	CloseAllMenus()
}


void function InitMGSettings( var newMenuArg )
{
	var mg_menu = GetMenu( "MGSettingsMenu" )
	file.mg_menu = mg_menu
	
	//First column
	AddEventHandlerToButton( mg_menu, "ButtonC1_1_On", UIE_CLICK, ButtonC1_1_On )
	AddEventHandlerToButton( mg_menu, "ButtonC1_1_Off", UIE_CLICK, ButtonC1_1_Off )
	
	AddEventHandlerToButton( mg_menu, "ButtonC1_2_On", UIE_CLICK, ButtonC1_2_On )
	AddEventHandlerToButton( mg_menu, "ButtonC1_2_Off", UIE_CLICK, ButtonC1_2_Off )
	
	AddEventHandlerToButton( mg_menu, "ButtonC1_3_On", UIE_CLICK, ButtonC1_3_On )
	AddEventHandlerToButton( mg_menu, "ButtonC1_3_Off", UIE_CLICK, ButtonC1_3_Off )

	AddEventHandlerToButton( mg_menu, "ButtonC1_4_Toggle", UIE_CLICK, ButtonC1_4_Toggle )
	
	AddEventHandlerToButton( mg_menu, "ButtonC1_5_On", UIE_CLICK, ButtonC1_5_On )
	AddEventHandlerToButton( mg_menu, "ButtonC1_5_Off", UIE_CLICK, ButtonC1_5_Off )

	//Second column
	AddEventHandlerToButton( mg_menu, "ButtonC2_1_Btn", UIE_CLICK, ButtonC2_1_Btn )
	AddEventHandlerToButton( mg_menu, "ButtonC2_2_Btn", UIE_CLICK, ButtonC2_2_Btn )
	AddEventHandlerToButton( mg_menu, "ButtonC2_3_Btn", UIE_CLICK, ButtonC2_3_Btn )
	AddEventHandlerToButton( mg_menu, "ButtonC2_4_Btn", UIE_CLICK, ButtonC2_4_Btn )
	
	
	//Third column
	AddEventHandlerToButton( mg_menu, "ButtonC3_1_Btn", UIE_CLICK, ButtonC3_1_Btn )
	AddEventHandlerToButton( mg_menu, "ButtonC3_2_Btn", UIE_CLICK, ButtonC3_2_Btn )
	AddEventHandlerToButton( mg_menu, "ButtonC3_3_Btn", UIE_CLICK, ButtonC3_3_Btn )

}

//----------------------------------------------------------
void function ButtonC1_1_On(var button)
{
	CloseAllMenus()
	EmitUISound("UI_Menu_SelectMode_Close")
	RunClientScript("MG_Speedometer_destroy")
	RunClientScript("MG_Speedometer_toggle", true)
}

void function ButtonC1_1_Off(var button)
{
	CloseAllMenus()
	EmitUISound("UI_Menu_SelectMode_Close")
	RunClientScript("MG_Speedometer_toggle", false)
}

void function ButtonC1_2_On(var button)
{
	CloseAllMenus()
	EmitUISound("UI_Menu_SelectMode_Close")
	RunClientScript("MG_Ultrakill_styleemeter_destroy")
	RunClientScript("MG_Ultrakill_styleemeter_toggle", true)
}

void function ButtonC1_2_Off(var button)
{
	CloseAllMenus()
	EmitUISound("UI_Menu_SelectMode_Close")
	RunClientScript("MG_Ultrakill_styleemeter_toggle", false)
}

void function ButtonC1_3_On(var button)
{
	CloseAllMenus()
	EmitUISound("UI_Menu_SelectMode_Close")
	RunClientScript("MG_MovementOverlay_toggle", true)
}

void function ButtonC1_3_Off(var button)
{
	CloseAllMenus()
	EmitUISound("UI_Menu_SelectMode_Close")
	RunClientScript("MG_MovementOverlay_toggle", false)
}

void function ButtonC1_4_Toggle(var button)
{
	CloseAllMenus()
	EmitUISound("UI_Menu_SelectMode_Close")
	RunClientScript("MG_ServerCallback_Invis")
}

void function ButtonC1_5_On(var button)
{
	CloseAllMenus()
	EmitUISound("UI_Menu_SelectMode_Close")
	RunClientScript("MG_CoolCamera_Change_Setting", true)
}

void function ButtonC1_5_Off(var button)
{
	CloseAllMenus()
	EmitUISound("UI_Menu_SelectMode_Close")
	RunClientScript("MG_CoolCamera_Change_Setting", false)
}

//----------------------------------------------------------
void function ButtonC2_1_Btn(var button)
{
	CloseAllMenus()
	EmitUISound("UI_Menu_SelectMode_Close")
	RunClientScript("MG_Pet_Destroy")
	RunClientScript("MG_Pet_setActive", "nessy")
	RunClientScript("MG_Pet_Summoner")
}

void function ButtonC2_2_Btn(var button)
{
	CloseAllMenus()
	EmitUISound("UI_Menu_SelectMode_Close")
	RunClientScript("MG_Pet_Destroy")
	RunClientScript("MG_Pet_setActive", "corgi")
	RunClientScript("MG_Pet_Summoner")
}

void function ButtonC2_3_Btn(var button)
{
	CloseAllMenus()
	EmitUISound("UI_Menu_SelectMode_Close")
	RunClientScript("MG_Pet_Destroy")
	RunClientScript("MG_Pet_setActive", "controllerplayer")
	RunClientScript("MG_Pet_Summoner")
}

void function ButtonC2_4_Btn(var button)
{
	CloseAllMenus()
	EmitUISound("UI_Menu_SelectMode_Close")
	RunClientScript("MG_Pet_Destroy")
	RunClientScript("MG_Pet_setActive", "error")
	RunClientScript("MG_Pet_Summoner")
}

//----------------------------------------------------------
void function ButtonC3_1_Btn(var button)
{
	CloseAllMenus()
	string targetName = Hud_GetUTF8Text( Hud_GetChild( file.mg_menu, "SpecTargetName" ) )
	RunClientScript("MG_SpecCam_getTarget", targetName)
}

void function ButtonC3_2_Btn(var button)
{
	CloseAllMenus()
	RunClientScript("MG_FreeCam_init")
}

void function ButtonC3_3_Btn(var button)
{
	CloseAllMenus()
	LaunchExternalWebBrowser( GetCurrentPlaylistVarString("flowstate_MovementGym_LeaderboardsURL", "https://bit.ly/movement-gym"), WEBBROWSER_FLAG_NONE )
}