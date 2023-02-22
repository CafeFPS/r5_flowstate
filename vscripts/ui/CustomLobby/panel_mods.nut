global function InitModsPanel
global function Mods_SetupUI
global function ChangeModsPanel

global enum ModCameraMovement
{
	MAIN_TO_INSTALLED = 0,
	MAIN_TO_BROWSE = 1,
	INSTALLED_TO_MAIN = 2,
	BROWSE_TO_MAIN = 3
}

global enum ModCameraPosition
{
	MAIN = 0,
	INSTALLED = 1,
	BROWSE = 2
}

struct
{
	var menu
	var panel

} file

global int g_modCameraPosition = ModCameraPosition.MAIN

void function InitModsPanel( var panel )
{
	file.panel = panel
	file.menu = GetParentMenu( file.panel )

	Hud_AddEventHandler( Hud_GetChild( panel, "BrowseModsButton" ), UIE_CLICK, ModsButton_Activated )
	Hud_AddEventHandler( Hud_GetChild( panel, "InstalledModsButton" ), UIE_CLICK, ModsButton_Activated )
	Hud_AddEventHandler( Hud_GetChild( panel, "BackButton" ), UIE_CLICK, BackButton_Activated )

	Hud_SetX( Hud_GetChild( panel, "BrowseModsButton" ), -(Hud_GetWidth(Hud_GetChild( panel, "BrowseModsButton" ))/2) + 7.5 )
}

void function Mods_SetupUI()
{
	g_modCameraPosition = ModCameraPosition.MAIN
	SetMainModsButtonVis(true)
}

void function BackButton_Activated(var button)
{
	switch(g_modCameraPosition)
	{
		case ModCameraPosition.BROWSE:
			ChangeModsPanel(ModCameraMovement.BROWSE_TO_MAIN)
			break;
		case ModCameraPosition.INSTALLED:
			ChangeModsPanel(ModCameraMovement.INSTALLED_TO_MAIN)
			break;
	}
}

void function ModsButton_Activated(var button)
{
	ChangeModsPanel(Hud_GetScriptID( button ).tointeger())
}

void function ChangeModsPanel(int type)
{
	switch(type)
	{
		case ModCameraMovement.MAIN_TO_INSTALLED:
			g_modCameraPosition = ModCameraPosition.INSTALLED
			RunClientScript("DefaultToInstalledMods")	
			break;
		case ModCameraMovement.MAIN_TO_BROWSE:
			g_modCameraPosition = ModCameraPosition.BROWSE
			RunClientScript("DefaultToBrowseMods")
			break;
		case ModCameraMovement.INSTALLED_TO_MAIN:
			g_modCameraPosition = ModCameraPosition.MAIN
			RunClientScript( "InstalledModsToDefault")
			break;
		case ModCameraMovement.BROWSE_TO_MAIN:
			g_modCameraPosition = ModCameraPosition.MAIN
			RunClientScript( "BrowseModsToDefault")
			break;
	}

	SetMainModsButtonVis((g_modCameraPosition == ModCameraPosition.MAIN))
}

void function SetMainModsButtonVis(bool vis)
{
	Hud_SetVisible( Hud_GetChild( file.panel, "BrowseModsButton" ), vis )
	Hud_SetVisible( Hud_GetChild( file.panel, "InstalledModsButton" ), vis )
	Hud_SetVisible( Hud_GetChild( file.panel, "BackButton" ), !vis )
}