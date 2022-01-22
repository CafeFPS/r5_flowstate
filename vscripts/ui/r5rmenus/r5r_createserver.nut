global function InitR5RCreateServer
global function SetMap
global function SetGamemode
global function SetVisibility

struct
{
	var menu
    var startserverbtn
    var changemapbtn
    var changegamemodebtn
    var changevisibilitybtn

    var maplbl
    var gamemodelbl
    var vislbl

    string name
    string gamemode
    string map
    int visibility // eServerVisibility
} file

void function InitR5RCreateServer( var newMenuArg )
{
	var menu = GetMenu( "R5RCreateServer" )
	file.menu = menu

    AddMenuEventHandler( menu, eUIEvent.MENU_SHOW, OnR5RCS_Show )
	AddMenuEventHandler( menu, eUIEvent.MENU_NAVIGATE_BACK, OnR5RCS_NavigateBack )

	SetGamepadCursorEnabled( menu, false )

    //Set RUI/VGUI

    file.startserverbtn = Hud_GetChild( menu, "StartServerBtn" )
	SetButtonRuiText( file.startserverbtn, "Start Server" )
    Hud_AddEventHandler( file.startserverbtn, UIE_CLICK, StartServer )

    file.changemapbtn = Hud_GetChild( menu, "ChangeMapBtn" )
	SetButtonRuiText( file.changemapbtn, "Change Map" )
    Hud_AddEventHandler( file.changemapbtn, UIE_CLICK, ChangeMap )

    file.changegamemodebtn = Hud_GetChild( menu, "ChangeGamemodeBtn" )
	SetButtonRuiText( file.changegamemodebtn, "Change Playlist" )
    Hud_AddEventHandler( file.changegamemodebtn, UIE_CLICK, ChangeGamemode )

    file.changevisibilitybtn = Hud_GetChild( menu, "ChangeVisibilityBtn" )
	SetButtonRuiText( file.changevisibilitybtn, "Change Visibility" )
    Hud_AddEventHandler( file.changevisibilitybtn, UIE_CLICK, ChangeVisibility )

    file.maplbl = Hud_GetChild(file.menu, "ServerMapLbl")
    file.gamemodelbl = Hud_GetChild(file.menu, "ServerGamemodeLbl")
    file.vislbl = Hud_GetChild(file.menu, "ServerVisLbl")

    AddButtonEventHandler( Hud_GetChild( file.menu, "BtnServerName"), UIE_CHANGE, UpdateServerName )
    Hud_SetText( Hud_GetChild( file.menu, "BtnServerName" ), "Type Servername Here" )

    file.name = Hud_GetUTF8Text( Hud_GetChild( file.menu, "BtnServerName" ) )
    file.map = "mp_rr_desertlands_64k_x_64k"
    file.gamemode = "survival_dev"
    file.visibility = eServerVisibility.OFFLINE

    Hud_SetText(file.maplbl, "Current Map: " + file.map)
    Hud_SetText(file.gamemodelbl, "Current Playlist: " + file.gamemode)
    Hud_SetText(file.vislbl, "Current Visibility: " + GetEnumString( "eServerVisibility", file.visibility ) )
}

void function OnR5RCS_Show()
{
	Chroma_MainMenu()
}

void function OnR5RCS_NavigateBack()
{
	CloseActiveMenu()
}

void function StartServer( var button )
{
    thread CreateServer(file.name, file.map, file.gamemode, file.visibility)
}

void function ChangeMap( var button )
{
    AdvanceMenu( GetMenu( "R5RChangeMap" ) )
}

void function ChangeGamemode( var button )
{
    AdvanceMenu( GetMenu( "R5RChangeGamemode" ) )
}

void function ChangeVisibility( var button )
{
    AdvanceMenu( GetMenu( "R5RChangeVisibility" ) )
}

void function SetMap( string map )
{
    //Set selected map
    file.map = map
    Hud_SetText(file.maplbl, "Current Map: " + map)
}

void function SetGamemode( string gamemode )
{
    //Set selected playlist
    file.gamemode = gamemode
    Hud_SetText(file.gamemodelbl, "Current Playlist: " + gamemode)
}

void function SetVisibility( int vis )
{
    //set selected visibility
    file.visibility = vis
    Hud_SetText( file.vislbl, "Current Visibility: " + GetEnumString( "eServerVisibility", file.visibility ) )
}

void function UpdateServerName( var button )
{
    //Update the servername when the text is changed
    file.name = Hud_GetUTF8Text( Hud_GetChild( file.menu, "BtnServerName" ) )
}