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

	array<string> aboutLines = CollectionEvent_GetAboutText( activeCollectionEvent, GRX_IsOfferRestricted() )
	Assert( aboutLines.len() < 7, "Rui about_collection_event does not support more than 6 lines." )

	foreach ( int lineIdx, string line in aboutLines )
	{
	if ( line == "" )
		continue

	string aboutLine = "%@embedded_bullet_point%" + Localize( line )
	HudElem_SetRuiArg( file.infoPanel, "aboutLine" + lineIdx, aboutLine )
	}

	ItemFlavor backgroundItemFlav = CollectionEvent_GetMainPackFlav( activeCollectionEvent )
	RunClientScript( "UIToClient_ItemPresentation", ItemFlavor_GetGUID( backgroundItemFlav ), -1, 1.21, false, null, false, "collection_event_ref" )
}


void function CollectionEventAboutPage_OnClose()
{
	RunClientScript( "UIToClient_StopBattlePassScene" )
}


