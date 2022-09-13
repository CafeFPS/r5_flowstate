global function InitFRChallengesSettings
global function OpenFRChallengesSettings
global function CloseFRChallengesSettings

struct
{
	var menu
	bool wpnselectorToggle = false
} file

void function OpenFRChallengesSettings()
{
	CloseAllMenus()
	EmitUISound("UI_Menu_SelectMode_Extend")
	AdvanceMenu( file.menu )	
}

void function CloseFRChallengesSettings()
{
	CloseAllMenus()
}

void function InitFRChallengesSettings( var newMenuArg )
{
	var menu = GetMenu( "FRChallengesSettings" )
	file.menu = menu
	
    AddMenuEventHandler( menu, eUIEvent.MENU_SHOW, OnR5RSB_Show )
	AddMenuEventHandler( menu, eUIEvent.MENU_OPEN, OnR5RSB_Open )
	AddMenuEventHandler( menu, eUIEvent.MENU_CLOSE, OnR5RSB_Close )
	AddMenuEventHandler( menu, eUIEvent.MENU_NAVIGATE_BACK, OnR5RSB_NavigateBack )
	
	AddEventHandlerToButton( menu, "Challenges", UIE_CLICK, ChallengesButtonFunct )
	AddEventHandlerToButton( menu, "History", UIE_CLICK, HistoryButtonFunct )
	
	AddEventHandlerToButton( menu, "WeaponSelector", UIE_CLICK, WeaponSelectorOpenMenu )
	AddEventHandlerToButton( menu, "CharacterSelector", UIE_CLICK, LegendSelectOpen )
	//RuiSetString( Hud_GetRui( Hud_GetChild( file.menu, "StatusDetails" ) ), "details", "Test" )
	Hud_SetText( Hud_GetChild( file.menu, "DurationText" ), "60" )
	AddButtonEventHandler( Hud_GetChild( file.menu, "ShieldSelectorButton"), UIE_CHANGE, ShieldSelectorButton )
	AddButtonEventHandler( Hud_GetChild( file.menu, "SpeedTargetsButton"), UIE_CHANGE, SpeedTargetsButton )
	AddButtonEventHandler( Hud_GetChild( file.menu, "SpawnDistanceButton"), UIE_CHANGE, UpdateSpawnDistance )
	AddButtonEventHandler( Hud_GetChild( file.menu, "HealthButton"), UIE_CHANGE, UpdateAIHealth )
	
	AddButtonEventHandler( Hud_GetChild( file.menu, "InmortalTargetsButton"), UIE_CHANGE, InmortalTargetsButton )
	AddButtonEventHandler( Hud_GetChild( file.menu, "InfiniteAmmoButton"), UIE_CHANGE, InfiniteAmmoButton )
	AddButtonEventHandler( Hud_GetChild( file.menu, "InfiniteAmmo2Button"), UIE_CHANGE, InfiniteAmmoButton2 )
	AddButtonEventHandler( Hud_GetChild( file.menu, "RGBHudButton"), UIE_CHANGE, RGBHudButton )
	AddButtonEventHandler( Hud_GetChild( file.menu, "DummiesColorButton"), UIE_CHANGE, DummiesColorButton )
	AddButtonEventHandler( Hud_GetChild( file.menu, "InfiniteTrainingButton"), UIE_CHANGE, InfiniteTrainingButton )
	AddButtonEventHandler( Hud_GetChild( file.menu, "UseDummyModelButton"), UIE_CHANGE, UseDummyModelButton)
	AddButtonEventHandler( Hud_GetChild( file.menu, "DurationText"), UIE_CHANGE, UpdateChallengeDuration )
	AddButtonEventHandler( Hud_GetChild( file.menu, "SupportTheDev"), UIE_CLICK, SupportTheDev)
	AddButtonEventHandler( Hud_GetChild( file.menu, "BtnServerListLeftArrow"), UIE_CLICK, firstpage)
	AddButtonEventHandler( Hud_GetChild( file.menu, "BtnServerListRightArrow"), UIE_CLICK, secondpage)
	
	var gameMenuButton = Hud_GetChild( menu, "GameMenuButton" )
	ToolTipData gameMenuToolTip
	gameMenuToolTip.descText = "Global Settings"
	Hud_SetToolTipData( gameMenuButton, gameMenuToolTip )
	HudElem_SetRuiArg( gameMenuButton, "icon", $"rui/menu/lobby/settings_icon" )
	HudElem_SetRuiArg( gameMenuButton, "shortcutText", "Global Settings" )
	Hud_AddEventHandler( gameMenuButton, UIE_CLICK, OpenGlobalSettings )
}

void function ShieldSelectorButton(var button)
{
	int desiredVar = GetConVarInt("hud_setting_minimapRotate")
	RunClientScript("ChangeAimTrainer_AI_SHIELDS_LEVELClient", desiredVar.tostring())
}

void function firstpage(var button)
{
	Hud_SetText( Hud_GetChild( file.menu, "Pages" ), "  Page: 1/2  " )
	array<var> challengesRows = GetElementsByClassname( file.menu, "SettingsBtn2" )
	foreach ( var elem in challengesRows )
	{
		Hud_SetVisible( elem, false )
	}
	array<var> challengesRows2 = GetElementsByClassname( file.menu, "SettingsBtn" )
	foreach ( var elem in challengesRows2 ) 
	{
		Hud_SetVisible( elem, true )
	}
}

void function secondpage(var button)
{
	Hud_SetText( Hud_GetChild( file.menu, "Pages" ), "  Page: 2/2  " )
	array<var> challengesRows = GetElementsByClassname( file.menu, "SettingsBtn" )
	foreach ( var elem in challengesRows ) 
	{
		Hud_SetVisible( elem, false )
	}
	array<var> challengesRows2 = GetElementsByClassname( file.menu, "SettingsBtn2" )
	foreach ( var elem in challengesRows2 ) 
	{
		Hud_SetVisible( elem, true )
	}
}

void function SupportTheDev(var button)
{
	LaunchExternalWebBrowser( "https://ko-fi.com/r5r_colombia", WEBBROWSER_FLAG_NONE )
}

void function SpeedTargetsButton(var button)
{
	int desiredVar = GetConVarInt("hud_setting_accessibleChat")
	RunClientScript("ChangeAimTrainer_STRAFING_SPEEDClient", desiredVar.tostring())	
}

void function InmortalTargetsButton(var button)
{
	int desiredVar = GetConVarInt("hud_setting_streamerMode")
	RunClientScript("ChangeAimTrainer_INMORTAL_TARGETSClient", desiredVar.tostring())
}

void function InfiniteAmmoButton(var button)
{
	int desiredVar = GetConVarInt("hud_setting_showTips")
	RunClientScript("ChangeAimTrainer_INFINITE_AMMOClient", desiredVar.tostring())
}

void function InfiniteAmmoButton2(var button)
{
	int desiredVar = GetConVarInt("hud_setting_compactOverHeadNames")
	RunClientScript("ChangeAimTrainer_INFINITE_AMMO2Client", desiredVar.tostring())
}

void function RGBHudButton(var button)
{
	int desiredVar = GetConVarInt("hud_setting_showMeter")
	RunClientScript("ChangeRGB_HUDClient", desiredVar.tostring())
}

void function DummiesColorButton(var button)
{
	int desiredVar = GetConVarInt("noise_filter_scale")
	RunClientScript("ChangeAimTrainer_AI_DUMMIES_COLORClient", desiredVar.tostring())
}

void function InfiniteTrainingButton(var button)
{
	int desiredVar = GetConVarInt("hud_setting_showMedals")
	RunClientScript("ChangeAimTrainer_INFINITE_CHALLENGEClient", desiredVar.tostring())
}

void function UseDummyModelButton(var button)
{
	int desiredVar = GetConVarInt("hud_setting_showLevelUp")
	RunClientScript("ChangeAimTrainer_USER_WANNA_BE_A_DUMMYClient", desiredVar.tostring())
}

void function WeaponSelectorOpenMenu(var button)
{
	RunClientScript("OpenFRChallengesSettingsWpnSelector")
}

void function LegendSelectOpen(var button)
{
	RunClientScript("OpenCharacterSelectAimTrainer", true)
}

void function UpdateChallengeDuration(var button)
{
	string desiredTime = Hud_GetUTF8Text( Hud_GetChild( file.menu, "DurationText" ) )
	RunClientScript("ChangeChallengeDurationClient", desiredTime)
}

void function UpdateSpawnDistance(var button)
{
	float desiredDistance = GetConVarFloat("net_minimumPacketLossDC")
	RunClientScript("ChangeAimTrainer_AI_SPAWN_DISTANCE", desiredDistance)
}

void function UpdateAIHealth(var button)
{
	float desiredHealth = GetConVarFloat("net_wifi")
	RunClientScript("ChangeAimTrainer_AI_HEALTH", desiredHealth)
}

void function HistoryButtonFunct(var button)
{
	CloseAllMenus()
	RunClientScript("ServerCallback_OpenFRChallengesHistory", PlayerKillsForChallengesUI)
}

void function ChallengesButtonFunct(var button)
{
	CloseAllMenus()
	RunClientScript("ServerCallback_OpenFRChallengesMainMenu", PlayerKillsForChallengesUI)
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
	//
}

void function OnR5RSB_NavigateBack()
{
	CloseAllMenus()
	RunClientScript("ServerCallback_OpenFRChallengesMainMenu", PlayerKillsForChallengesUI)	
}

void function OpenGlobalSettings(var button)
{
    CloseAllMenus()
	AdvanceMenu( GetMenu( "SystemMenu" ) )	
}