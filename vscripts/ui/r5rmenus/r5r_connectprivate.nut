global function InitR5RPrivateServerConnectMenu


struct
{
	var menu

	bool serverexists = false
} file

void function InitR5RPrivateServerConnectMenu( var newMenuArg )
{
	var menu = GetMenu( "PrivateServerConnect" )
	file.menu = menu

	AddMenuEventHandler( menu, eUIEvent.MENU_SHOW, OnR5RCS_Show )
	AddMenuEventHandler( menu, eUIEvent.MENU_NAVIGATE_BACK, OnR5RCS_NavigateBack )

	SetGamepadCursorEnabled( menu, false )

	//Set RUI/VGUI
	var cancel = Hud_GetChild( menu, "Button0" )
	SetButtonRuiText( cancel, "Connect" )
	Hud_AddEventHandler( cancel, UIE_CLICK, ConnectToPrivateServer )

	AddButtonEventHandler( Hud_GetChild( file.menu, "BtnEncKey"), UIE_CHANGE, CheckEncKey )
	Hud_SetText( Hud_GetChild( file.menu, "BtnEncKey" ), "" )

	Hud_SetText( Hud_GetChild( file.menu, "DialogMessage" ), "" )
	file.serverexists = false
}

void function OnR5RCS_Show()
{
	Chroma_MainMenu()

	Hud_SetText( Hud_GetChild( file.menu, "DialogMessage" ), "" )
	file.serverexists = false
}

void function OnR5RCS_NavigateBack()
{
	CloseActiveMenu()
}

void function ConnectToPrivateServer(var button)
{
	if (file.serverexists)
	{
		string enckey = Hud_GetUTF8Text( Hud_GetChild( file.menu, "BtnEncKey" ) )
		JoinPrivateServerFromMenu(enckey);
	}
}

void function CheckEncKey(var button)
{
	string enckey = Hud_GetUTF8Text( Hud_GetChild( file.menu, "BtnEncKey" ) )
	if(enckey == "")
	{
		file.serverexists = false
		Hud_SetText( Hud_GetChild( file.menu, "DialogMessage" ), "" )
	}
	else
	{
		string message = GetPrivateServerMessage(enckey);
		Hud_SetText( Hud_GetChild( file.menu, "DialogMessage" ), message )
		
		if(message == "Error: Server Not Found")
		{
		    file.serverexists = false
		}
		else
		{
			file.serverexists = true
		}
	}
}