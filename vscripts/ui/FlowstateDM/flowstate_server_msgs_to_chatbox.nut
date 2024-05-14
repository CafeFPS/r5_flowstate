untyped

global function InitServerMSGSToChatBox
global function Open_FS_MsgsChatBox
global function Close_FS_MsgsChatBox
global function FS_MsgsChatBox_SetText

//HudChat_ClearTextFromAllChatPanels()
//HudChat_HasAnyMessageModeStoppedRecently()

struct
{
	var menu
	string chatInputBar_Test
} file

void function InitServerMSGSToChatBox( var newMenuArg )
{
	var menu = GetMenu( "FS_ServerMsgs_To_ChatBox" )
	file.menu = menu

	AddMenuEventHandler( menu, eUIEvent.MENU_NAVIGATE_BACK, On_FSDM__NavigateBack )
}

void function Open_FS_MsgsChatBox()
{
	CloseAllMenus()
	AdvanceMenu( file.menu )
	
	// Hud_SetFocused( Hud_GetChild( file.menu, "ServerMsgTextLine") )

	// var chatTextEntry = Hud_GetChild( file.menu, "ServerMsgTextLine")
    // Hud_SetUTF8Text( chatTextEntry, "test" )

	// Hud_SetVisible( Hud_GetChild( file.menu, "FS_MsgsToChatBox"), true )
	// Hud_SetAboveBlur( Hud_GetChild( file.menu, "FS_MsgsToChatBox"), true )
	// Hud_StartMessageMode( Hud_GetChild( file.menu, "FS_MsgsToChatBox") )
	// Hud_SetEnabled( Hud_GetChild( Hud_GetChild( file.menu, "FS_MsgsToChatBox"), "ChatInputLine" ), true)
	// Hud_SetVisible( Hud_GetChild( Hud_GetChild( file.menu, "FS_MsgsToChatBox"), "ChatInputLine" ), true )
	// Hud_SetFocused( Hud_GetChild( Hud_GetChild( file.menu, "FS_MsgsToChatBox"), "ChatInputLine" ) )
	
	// var chatTextEntry = Hud_GetChild( Hud_GetChild( Hud_GetChild( file.menu, "FS_MsgsToChatBox"), "ChatInputLine" ), "ChatInputTextEntry" )
    // Hud_SetUTF8Text( chatTextEntry, "test" )
}

void function FS_MsgsChatBox_SetText( string text, float height = -1, float width = -1, int x = -1, int y = -1)
{
	var chatTextEntry = Hud_GetChild( file.menu, "ServerMsgTextLine")
	Hud_SetFocused( chatTextEntry )
    
	Hud_GotoRichTextStart( chatTextEntry )
	// Hud_SetDrawTextRui( chatTextEntry, text )
	Hud_SetUTF8Text( chatTextEntry, text )
	Hud_SetSize(chatTextEntry, height, width)
	
	// Hud_SetPos(chatTextEntry, x, y)
	// Hud_SetVisible( Hud_GetChild( file.menu, "FS_MsgsToChatBox"), true )
	// Hud_SetAboveBlur( Hud_GetChild( file.menu, "FS_MsgsToChatBox"), true )
	// Hud_StartMessageMode( Hud_GetChild( file.menu, "FS_MsgsToChatBox") )
	// Hud_SetEnabled( Hud_GetChild( Hud_GetChild( file.menu, "FS_MsgsToChatBox"), "ChatInputLine" ), true)
	// Hud_SetVisible( Hud_GetChild( Hud_GetChild( file.menu, "FS_MsgsToChatBox"), "ChatInputLine" ), true )
	// Hud_SetFocused( Hud_GetChild( Hud_GetChild( file.menu, "FS_MsgsToChatBox"), "ChatInputLine" ) )

	// var chatTextEntry = Hud_GetChild( Hud_GetChild( Hud_GetChild( file.menu, "FS_MsgsToChatBox"), "ChatInputLine" ), "ChatInputTextEntry" )
    // Hud_SetUTF8Text( chatTextEntry, text )
}

void function Close_FS_MsgsChatBox()
{
	// try{
		// DeregisterButtonPressedCallback( KEY_ENTER, FocusChat )
	// }catch(e420){}
	CloseAllMenus()
}

void function On_FSDM__NavigateBack()
{
}