global function InitKillReplayHud
global function OpenKillReplayHud
global function CloseKillReplayHud
global function ReplayHud_UpdatePlayerHealthAndSheild

struct
{
	var menu
    int basehealthwidth
    int basesheildwidth
} file

void function OpenKillReplayHud(asset image, string killedby, int tier, bool islocalclient)
{
    for(int i = 0; i < 5; i++) {
        Hud_SetVisible( Hud_GetChild( file.menu, "PlayerSheild" + i ), false )
    }

    Hud_SetText(Hud_GetChild( file.menu, "KillReplayPlayerName" ), "")
    RuiSetImage(Hud_GetRui(Hud_GetChild(file.menu, "PlayerImage")), "basicImage", $"")

    //Need to change this to script ids in the future
    Hud_SetVisible( Hud_GetChild( file.menu, "PlayerCard" ), false )
    Hud_SetVisible( Hud_GetChild( file.menu, "PlayerCardTopLine" ), false )
    Hud_SetVisible( Hud_GetChild( file.menu, "PlayerCardBottomLine" ), false )
    Hud_SetVisible( Hud_GetChild( file.menu, "KillReplayKilledBy" ), false )
    Hud_SetVisible( Hud_GetChild( file.menu, "PlayerImage" ), false )
    Hud_SetVisible( Hud_GetChild( file.menu, "KillReplayPlayerName" ), false )
    Hud_SetVisible( Hud_GetChild( file.menu, "PlayerHealth" ), false )

    if(!islocalclient)
    {
        Hud_SetVisible( Hud_GetChild( file.menu, "PlayerCard" ), true )
        Hud_SetVisible( Hud_GetChild( file.menu, "PlayerCardTopLine" ), true )
        Hud_SetVisible( Hud_GetChild( file.menu, "PlayerCardBottomLine" ), true )
        Hud_SetVisible( Hud_GetChild( file.menu, "KillReplayKilledBy" ), true )
        Hud_SetVisible( Hud_GetChild( file.menu, "PlayerImage" ), true )
        Hud_SetVisible( Hud_GetChild( file.menu, "KillReplayPlayerName" ), true )
        Hud_SetVisible( Hud_GetChild( file.menu, "PlayerHealth" ), true )

        Hud_SetVisible( Hud_GetChild( file.menu, "PlayerSheild" + tier ), true )
        Hud_SetText(Hud_GetChild( file.menu, "KillReplayPlayerName" ), killedby)
        RuiSetImage(Hud_GetRui(Hud_GetChild(file.menu, "PlayerImage")), "basicImage", image)
    }

	CloseAllMenus()
	AdvanceMenu( file.menu )
}

void function ReplayHud_UpdatePlayerHealthAndSheild(float health, float sheild, int tier)
{
    Hud_SetWidth( Hud_GetChild( file.menu, "PlayerSheild" + tier ), file.basesheildwidth * sheild )
    Hud_SetWidth( Hud_GetChild( file.menu, "PlayerHealth" ), file.basehealthwidth * health )
}

void function CloseKillReplayHud()
{
	CloseAllMenus()
}

void function InitKillReplayHud( var newMenuArg )
{
	var menu = GetMenu( "KillReplayHud" )
	file.menu = menu

    file.basehealthwidth = Hud_GetWidth( Hud_GetChild( file.menu, "PlayerHealth" ) )
    file.basesheildwidth = Hud_GetWidth( Hud_GetChild( file.menu, "PlayerSheild1" ) )

	AddMenuEventHandler( menu, eUIEvent.MENU_NAVIGATE_BACK, On_NavigateBack )
}

void function On_NavigateBack()
{
	// Needs to be here so people cant close the menu
}