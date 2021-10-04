//

global function InitLoadscreenPreviewMenu
global function LoadscreenPreviewMenu_SetLoadscreenToPreview


struct
{
	var loadscreenElem

	ItemFlavor ornull loadscreenToPreview
} file


void function InitLoadscreenPreviewMenu( var newMenuArg ) //
{
	var menu = GetMenu( "LoadscreenPreviewMenu" )

	file.loadscreenElem = Hud_GetChild( menu, "LoadscreenImage" )

	AddMenuEventHandler( menu, eUIEvent.MENU_OPEN, LoadscreenPreviewMenu_OnOpen )
	AddMenuEventHandler( menu, eUIEvent.MENU_CLOSE, LoadscreenPreviewMenu_OnClose )

	AddMenuFooterOption( menu, LEFT, BUTTON_B, true, "#B_BUTTON_BACK", "#B_BUTTON_BACK" )
}


void function LoadscreenPreviewMenu_SetLoadscreenToPreview( ItemFlavor loadscreen )
{
	file.loadscreenToPreview = loadscreen
}


void function LoadscreenPreviewMenu_OnOpen()
{
	Assert( file.loadscreenToPreview != null )
	RunClientScript( "UpdateLoadscreenPreviewMaterial", file.loadscreenElem, null, ItemFlavor_GetGUID( expect ItemFlavor(file.loadscreenToPreview) ) )
}


void function LoadscreenPreviewMenu_OnClose()
{
	file.loadscreenToPreview = null
	RunClientScript( "UpdateLoadscreenPreviewMaterial", file.loadscreenElem, null, 0 )
}


