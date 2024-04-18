global function InitKillReplayHud
global function OpenKillReplayHud
global function CloseKillReplayHud
global function ReplayHud_UpdatePlayerData
global function UI_FlowstateCustomSetSpectateTargetCount

struct
{
	var menu
    int basehealthwidth
    int basesheildwidth
	int spectateTargetCount
	string spectatorTarget
	int currentSpectateTarget = 1
	bool ObserverReverse
} file

void function OpenKillReplayHud(asset image, string killedby, int tier, bool islocalclient, bool isProphunt)
{
	file.spectatorTarget = killedby
	
	try{
		RegisterButtonPressedCallback( KEY_ENTER, FocusChat )
		if( IsConnected() && Playlist() != ePlaylists.fs_snd )
		{
			RegisterButtonPressedCallback( MOUSE_LEFT, SpecPrev )
			RegisterButtonPressedCallback( MOUSE_RIGHT, SpecNext )
		}
	}catch(e420){}
	
    for(int i = 0; i < 5; i++) {
        Hud_SetVisible( Hud_GetChild( file.menu, "PlayerSheild" + i ), false )
    }

	Hud_SetText(Hud_GetChild( file.menu, "KillReplayText" ), "Spectating")
	
	if( IsConnected() && Playlist() == ePlaylists.fs_snd )
		Hud_SetText(Hud_GetChild( file.menu, "KillReplayText" ), "Spectating Teammate")
	
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
		
		if( IsConnected() && Playlist() != ePlaylists.fs_snd )
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

	Hud_SetVisible( Hud_GetChild( file.menu, "KillReplayChatBox"), true )
	Hud_SetAboveBlur( Hud_GetChild( file.menu, "KillReplayChatBox"), true )
	Hud_SetEnabled( Hud_GetChild( Hud_GetChild( file.menu, "KillReplayChatBox"), "ChatInputLine" ), false)
	
	//todo make it show only if there is more than 1 player to spectate
	if( IsConnected() && Playlist() != ePlaylists.fs_snd )
	{
		Hud_SetText(Hud_GetChild( file.menu, "ControlsText" ), "%attack% Previous Player")
		Hud_SetText(Hud_GetChild( file.menu, "ControlsText2" ), "%zoom% Next Player")
	} 
	
	if( Playlist() == ePlaylists.fs_snd )
	{
		Hud_SetText(Hud_GetChild( file.menu, "ControlsText" ), "")
		Hud_SetText(Hud_GetChild( file.menu, "ControlsText2" ), "")
	}
	
	if(isProphunt) 
	{
		Hud_SetText(Hud_GetChild( file.menu, "KillReplayText" ), "APEX PROPHUNT - YOU WILL SPAWN THE NEXT ROUND")		
		Hud_SetVisible( Hud_GetChild( file.menu, "PlayerCard" ), true )
		Hud_SetVisible( Hud_GetChild( file.menu, "PlayerCardTopLine" ), true )
		Hud_SetVisible( Hud_GetChild( file.menu, "PlayerCardBottomLine" ), true )
		Hud_SetVisible( Hud_GetChild( file.menu, "KillReplayKilledBy" ), false )
		Hud_SetVisible( Hud_GetChild( file.menu, "PlayerImage" ), true )
		Hud_SetVisible( Hud_GetChild( file.menu, "KillReplayPlayerName" ), true )
		Hud_SetVisible( Hud_GetChild( file.menu, "PlayerHealth" ), true )
	}
}

void function ReplayHud_UpdatePlayerData(float health, float sheild, int tier, string name, asset image)
{
    Hud_SetWidth( Hud_GetChild( file.menu, "PlayerSheild" + tier ), file.basesheildwidth * sheild )
    Hud_SetWidth( Hud_GetChild( file.menu, "PlayerHealth" ), file.basehealthwidth * health )
	Hud_SetText( Hud_GetChild( file.menu, "KillReplayPlayerName" ), name)
	RuiSetImage(Hud_GetRui(Hud_GetChild(file.menu, "PlayerImage")), "basicImage", image)
}

void function CloseKillReplayHud(bool isProphunt)
{
	try{
		DeregisterButtonPressedCallback( KEY_ENTER, FocusChat )
		if( IsConnected() && Playlist() == ePlaylists.fs_snd )
		{
			DeregisterButtonPressedCallback( MOUSE_LEFT,  SpecPrev )
			DeregisterButtonPressedCallback( MOUSE_RIGHT, SpecNext )
		}
	}catch(e420){}
	
	Hud_StopMessageMode( Hud_GetChild( file.menu, "KillReplayChatBox") )
	Hud_SetEnabled( Hud_GetChild( Hud_GetChild( file.menu, "KillReplayChatBox"), "ChatInputLine" ), false)
	Hud_SetVisible( Hud_GetChild( Hud_GetChild( file.menu, "KillReplayChatBox"), "ChatInputLine" ), false )
	Hud_SetVisible( Hud_GetChild( file.menu, "KillReplayChatBox"), false )
	
	if(isProphunt)
	{
		
	}
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

void function UI_FlowstateCustomSetSpectateTargetCount( int targetCount, bool reverse )
{
	file.ObserverReverse = reverse
	file.spectateTargetCount = targetCount
}

bool function FlowstateCustomCanChangeSpectateTarget()
{
	return file.spectateTargetCount	> 1
}
void function SpecNext( var panel )
{
	printt("trying to change spectate target. Max Targets " + file.spectateTargetCount + " | Target Count " + file.currentSpectateTarget )
	ClientCommand( "spec_next" )
}

void function SpecPrev( var panel )
{
	ClientCommand( "spec_prev" )
}

void function FocusChat( var panel )
{
	if(!Hud_IsFocused( Hud_GetChild( Hud_GetChild( file.menu, "KillReplayChatBox"), "ChatInputLine" ) ))
	{
		Hud_StartMessageMode( Hud_GetChild( file.menu, "KillReplayChatBox") )
		Hud_SetEnabled( Hud_GetChild( Hud_GetChild( file.menu, "KillReplayChatBox"), "ChatInputLine" ), true)
		Hud_SetVisible( Hud_GetChild( Hud_GetChild( file.menu, "KillReplayChatBox"), "ChatInputLine" ), true )
		Hud_SetFocused( Hud_GetChild( Hud_GetChild( file.menu, "KillReplayChatBox"), "ChatInputLine" ) )
	} 
}

void function On_NavigateBack()
{
	// Needs to be here so people cant close the menu
}