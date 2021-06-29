global function CollectionEventAboutPage_Init

struct {
	var menu
	var infoPanel
} file

void function CollectionEventAboutPage_Init( var menu )
{
	file.menu = menu
	//
	AddMenuEventHandler( menu, eUIEvent.MENU_OPEN, CollectionEventAboutPage_OnOpen )
	AddMenuEventHandler( menu, eUIEvent.MENU_CLOSE, CollectionEventAboutPage_OnClose )

	file.infoPanel = Hud_GetChild( file.menu, "InfoPanel" )

	AddMenuFooterOption( menu, LEFT, BUTTON_B, true, "#B_BUTTON_BACK", "#B_BUTTON_BACK" )
}


void function CollectionEventAboutPage_OnOpen()
{
	ItemFlavor ornull activeCollectionEvent = GetActiveCollectionEvent( GetUnixTimestamp() )
	if ( activeCollectionEvent == null )
		return
	expect ItemFlavor(activeCollectionEvent)

	HudElem_SetRuiArg( file.infoPanel, "eventName", ItemFlavor_GetLongName( activeCollectionEvent ) )
	HudElem_SetRuiArg( file.infoPanel, "bgPatternImage", CollectionEvent_GetBGPatternImage( activeCollectionEvent ) )
	HudElem_SetRuiArg( file.infoPanel, "headerIcon", CollectionEvent_GetHeaderIcon( activeCollectionEvent ) )
	HudElem_SetRuiArg( file.infoPanel, "specialTextCol", SrgbToLinear( CollectionEvent_GetAboutPageSpecialTextCol( activeCollectionEvent ) ) )

	string aboutText = ""
	foreach( int lineIdx, string line in CollectionEvent_GetAboutText( activeCollectionEvent, GRX_IsOfferRestricted() ) )
	{
		if ( line == "" )
			continue

		if ( lineIdx > 0 )
			aboutText += "\n"

		aboutText += "%@embedded_bullet_point%"
		aboutText += Localize( line )
	}
	HudElem_SetRuiArg( file.infoPanel, "aboutTextLines", aboutText )

	ItemFlavor backgroundItemFlav = CollectionEvent_GetMainPackFlav( activeCollectionEvent )
	RunClientScript( "UIToClient_ItemPresentation", ItemFlavor_GetGUID( backgroundItemFlav ), -1, 1.21, false, null, false, "collection_event_ref" )
}


void function CollectionEventAboutPage_OnClose()
{
	RunClientScript( "UIToClient_StopBattlePassScene" )
}


