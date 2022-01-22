global function InitR5RIPServerConnectMenu

struct
{
	var menu
} file

void function InitR5RIPServerConnectMenu( var newMenuArg )
{
	var menu = GetMenu( "IPServerConnect" )
	file.menu = menu

	AddMenuEventHandler( menu, eUIEvent.MENU_SHOW, OnR5RCS_Show )
	AddMenuEventHandler( menu, eUIEvent.MENU_NAVIGATE_BACK, OnR5RCS_NavigateBack )

	SetGamepadCursorEnabled( menu, false )

	//Set RUI/VGUI
	var cancel = Hud_GetChild( menu, "Button0" )
	SetButtonRuiText( cancel, "Connect" )
	Hud_AddEventHandler( cancel, UIE_CLICK, ConnectToIP )
}

void function OnR5RCS_Show()
{
	Chroma_MainMenu()
}

void function OnR5RCS_NavigateBack()
{
	CloseActiveMenu()
}

void function ConnectToIP(var button)
{
	string ip = Hud_GetUTF8Text( Hud_GetChild( file.menu, "BtnServerIP" ) )
	string enckey = Hud_GetUTF8Text( Hud_GetChild( file.menu, "BtnEncKey" ) )
	
	if ( ip == "" || enckey == "")
		return
		
	thread StartServerConnection(ip, enckey)
}

void function StartServerConnection(string ip, string enckey)
{
	SendConnectMenuData(ip, enckey)
	AdvanceMenu( GetMenu( "ConnectingToServer" ) )
	
	wait 2
	
	ConnectToIPFromMenu(ip, enckey)
}