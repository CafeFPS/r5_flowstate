global function InitR5RConnectMenu
global function SendConnectMenuData

struct
{
	var menu

	var header
	var text
	var text2

	string servername = "Super Cool Temp Server Name"
	string gamemode
} file

void function InitR5RConnectMenu( var newMenuArg )
{
	var menu = GetMenu( "ConnectingToServer" )
	file.menu = menu

	AddMenuEventHandler( menu, eUIEvent.MENU_SHOW, OnR5RSB_Show )
	AddMenuEventHandler( menu, eUIEvent.MENU_NAVIGATE_BACK, OnR5RSB_NavigateBack )

	//Setup RUI/VGUI
	file.header = Hud_GetChild( menu, "DialogHeader" )

	file.text = Hud_GetChild( menu, "DialogMessage" )
	file.text2 = Hud_GetChild( menu, "DialogMessage2" )

	var cancel = Hud_GetChild( menu, "Button0" )
	SetButtonRuiText( cancel, "Cancel" )
	Hud_AddEventHandler( cancel, UIE_CLICK, CancelConnect )
}

void function OnR5RSB_Show()
{
	Chroma_MainMenu()

	Hud_SetText(file.header, "Connecting To Server")
	Hud_SetText(file.text, file.servername)
	Hud_SetText(file.text2, file.gamemode)
}

void function OnR5RSB_NavigateBack()
{
	CloseActiveMenu()
}

void function CancelConnect(var button)
{
	SetCancelConnect()
	CloseActiveMenu()
}

void function SendConnectMenuData(string name, string gamemode)
{
	file.servername = name
	file.gamemode = gamemode
}