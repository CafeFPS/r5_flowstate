global function UICodeCallback_MainMenuPromosUpdated

global function InitPromoDialog
global function OpenPromoDialogIfNew
global function IsPromoDialogAllowed

global function PromoDialog_OpenHijacked

struct PageContent
{
	asset image = $""
	string title = ""
	string desc = ""
	string link = ""
}

enum eTransType
{
	// must match TRANSTYPE_* in promo.rui
	NONE = 0,
	SLIDE_LEFT = 1,
	SLIDE_RIGHT = 2,

	_count,
}

struct
{
	var  menu
	var  prevPageButton
	var  nextPageButton
	bool pageChangeInputsRegistered

	string ornull      hijackContent = null
	void functionref() hijackCloseCallback = null

	MainMenuPromos&      promoData
	array<asset>         images
	table<string, asset> imageMap
	array<PageContent>   pages
	int                  activePageIndex = 0



	var lastPageRui
	var activePageRui
	int updateID = -1
} file

const int PROMO_PROTOCOL = 1

void function UICodeCallback_MainMenuPromosUpdated()
{
	printt( "Promos updated" )

	#if R5DEV
		if ( GetConVarInt( "mainMenuPromos_preview" ) == 1 )
			file.promoData = GetMainMenuPromos()
	#endif // DEV
}


void function OpenPromoDialogIfNew()
{
	entity player = GetUIPlayer()
	file.promoData = GetMainMenuPromos()

	if ( player == null || !IsPromoDialogAllowed() )
		return

	int promoVersionSeen = player.GetPersistentVarAsInt( "promoVersionSeen" )

	if ( file.promoData.version != 0 && file.promoData.version != promoVersionSeen )
		AdvanceMenu( file.menu )
}


bool function IsPromoDialogAllowed()
{
	return ( file.promoData.prot == PROMO_PROTOCOL && IsLobby() && IsFullyConnected() && GetActiveMenu() == GetMenu( "LobbyMenu" ) && IsTabPanelActive( GetPanel( "PlayPanel" ) ) )
}


void function InitPromoDialog()
{
	var menu = GetMenu( "PromoDialog" )
	file.menu = menu

	file.prevPageButton = Hud_GetChild( menu, "PrevPageButton" )
	HudElem_SetRuiArg( file.prevPageButton, "flipHorizontal", true )
	Hud_AddEventHandler( file.prevPageButton, UIE_CLICK, Page_NavLeft )

	file.nextPageButton = Hud_GetChild( menu, "NextPageButton" )
	Hud_AddEventHandler( file.nextPageButton, UIE_CLICK, Page_NavRight )

	file.lastPageRui = Hud_GetRui( Hud_GetChild( menu, "LastPage" ) )
	file.activePageRui = Hud_GetRui( Hud_GetChild( menu, "ActivePage" ) )

	SetDialog( menu, true )
	SetGamepadCursorEnabled( menu, false )

	AddMenuEventHandler( menu, eUIEvent.MENU_OPEN, PromoDialog_OnOpen )
	AddMenuEventHandler( menu, eUIEvent.MENU_CLOSE, PromoDialog_OnClose )
	AddMenuEventHandler( menu, eUIEvent.MENU_NAVIGATE_BACK, PromoDialog_OnNavigateBack )

	AddMenuFooterOption( menu, LEFT, BUTTON_B, true, "#B_BUTTON_CLOSE", "#B_BUTTON_CLOSE" )
	AddMenuFooterOption( menu, LEFT, BUTTON_X, true, "#X_BUTTON_BUY", "#BUY", GoToStoreItem, PageHasBuyOption )

	RequestMainMenuPromos() // This will be ignored if there was a recent request. "infoblock_requestInterval"

	var dataTable = GetDataTable( $"datatable/promo_images.rpak" )
	for ( int i = 0; i < GetDatatableRowCount( dataTable ); i++ )
	{
		string name = GetDataTableString( dataTable, i, GetDataTableColumnByName( dataTable, "name" ) ).tolower()
		asset image = GetDataTableAsset( dataTable, i, GetDataTableColumnByName( dataTable, "image" ) )
		file.images.append( image )
		if ( name != "" )
			file.imageMap[name] <- image
	}
}


void function PromoDialog_OpenHijacked( string content, void functionref() closeCallback )
{
	file.hijackContent = content
	file.hijackCloseCallback = closeCallback
	AdvanceMenu( file.menu )
}


void function PromoDialog_OnOpen()
{
	string content

	if ( file.hijackContent != null )
		content = expect string( file.hijackContent )
	else
		content = file.promoData.layout

	if ( content.find( "<" ) != 0 ) // plain text
		content = "<p|0| |" + content + ">"

	// Test content
	//			"<page|imageIndex|Title text|Message text>"
	//content = "<p|1|Playable Characters|Gibraltar / Mirage / Caustic\nhello world>"
	//content += "<p|0|Bleedout Bug Fixed|Please bug it if you continue to see the issue.>"
	//content += "<p|2|hello|world>"
	//content += "<p|3|Page 4|Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. Lorem Ipsum is simply dummy text of the printing and typesetting industry.>"

	file.pages = InitPages( content )
	file.activePageIndex = 0

	UpdatePageRui( file.activePageRui, 0 )
	UpdatePromoButtons()
	RegisterPageChangeInput()
}


void function PromoDialog_OnClose()
{
	DeregisterPageChangeInput()

	if ( file.hijackContent != null )
	{
		file.hijackContent = null
		if ( file.hijackCloseCallback != null )
		{
			file.hijackCloseCallback()
		}
	}
}


void function PromoDialog_OnNavigateBack()
{
	UserClosedPromoDialog( null )
}


void function UserClosedPromoDialog( var button )
{
	entity player = GetUIPlayer()
	if ( player != null && IsFullyConnected() && file.hijackContent == null )
		ClientCommand( "SetPromoVersionSeen " + string( file.promoData.version ) )

	CloseActiveMenu()
}


void function GoToStoreItem( var button )
{
	// TODO
}


array<PageContent> function InitPages( string content )
{
	array<PageContent> pages
	array<string> elements = RegexpFindSimple( content, "<([^>]+)>" )
	int pageIndex = 0

	foreach ( element in elements )
	{
		array<string> vals = split( element, "|" )

		//printt( element )
		//foreach ( val in vals )
		//	printt( "val:", val )

		if ( vals[0] == "p" ) // page
		{
			if ( vals.len() != 4 && vals.len() != 3 )
				continue

			PageContent newPage

			string imageVal = vals[1].tolower()
			if ( imageVal in file.imageMap )
				newPage.image = file.imageMap[imageVal]
			else
				newPage.image = file.images[int(imageVal)]

			newPage.title = vals[2]
			newPage.desc = vals.len() == 3 ? "" : vals[3]
			//if ( vals[1] == "1" ) // Testing buy button
			//	newPage.link = "buy:test"

			pages.append( newPage )
		}
		else
		{
			Warning( "Unrecognized element: " + vals[0] )
		}
	}

	return pages
}


void function RegisterPageChangeInput()
{
	if ( file.pageChangeInputsRegistered )
		return

	RegisterButtonPressedCallback( BUTTON_SHOULDER_LEFT, Page_NavLeft )
	RegisterButtonPressedCallback( BUTTON_DPAD_LEFT, Page_NavLeft )

	RegisterButtonPressedCallback( BUTTON_SHOULDER_RIGHT, Page_NavRight )
	RegisterButtonPressedCallback( BUTTON_DPAD_RIGHT, Page_NavRight )

	file.pageChangeInputsRegistered = true

	thread TrackDpadInput()
}


void function DeregisterPageChangeInput()
{
	if ( !file.pageChangeInputsRegistered )
		return

	DeregisterButtonPressedCallback( BUTTON_SHOULDER_LEFT, Page_NavLeft )
	DeregisterButtonPressedCallback( BUTTON_DPAD_LEFT, Page_NavLeft )

	DeregisterButtonPressedCallback( BUTTON_SHOULDER_RIGHT, Page_NavRight )
	DeregisterButtonPressedCallback( BUTTON_DPAD_RIGHT, Page_NavRight )

	file.pageChangeInputsRegistered = false
}

void function TrackDpadInput()
{
	bool canChangePage = false

	while ( file.pageChangeInputsRegistered )
	{
		float xAxis = InputGetAxis( ANALOG_LEFT_X )

		if ( !canChangePage )
			canChangePage = fabs( xAxis ) < 0.5

		if ( canChangePage )
		{
			if ( xAxis > 0.9 )
			{
				ChangePage( 1 )
				canChangePage = false
			}
			else if ( xAxis < -0.9 )
			{
				ChangePage( -1 )
				canChangePage = false
			}
		}

		WaitFrame()
	}
}

void function Page_NavLeft( var button )
{
	ChangePage( -1 )
}


void function Page_NavRight( var button )
{
	ChangePage( 1 )
}


void function ChangePage( int delta )
{
	Assert( delta == -1 || delta == 1 )

	int newPageIndex = file.activePageIndex + delta
	if ( newPageIndex < 0 || newPageIndex >= file.pages.len() )
		return

	int lastPageIndex = file.activePageIndex
	file.activePageIndex = newPageIndex
	int transType = delta == 1 ? eTransType.SLIDE_LEFT : eTransType.SLIDE_RIGHT

	UpdatePageRui( file.lastPageRui, lastPageIndex )
	UpdatePageRui( file.activePageRui, file.activePageIndex )
	TransitionPage( file.activePageRui, transType )
	EmitUISound( "UI_Menu_MOTD_Tab" )

	UpdatePromoButtons()
}


void function UpdatePageRui( var rui, int pageIndex )
{
	PageContent page = file.pages[pageIndex]

	RuiSetImage( rui, "imageAsset", page.image )
	RuiSetString( rui, "titleText", page.title )
	RuiSetString( rui, "descText", page.desc )
	RuiSetInt( rui, "activePageIndex", file.activePageIndex )
	RuiSetInt( rui, "pageIndex", pageIndex )
	RuiSetInt( rui, "pageCount", file.pages.len() )

	PIN_Message( page.title, page.desc )
}


void function TransitionPage( var rui, int transType )
{
	file.updateID++
	RuiSetInt( rui, "transType", transType )
	RuiSetInt( rui, "updateID", file.updateID )
}


void function UpdatePromoButtons()
{
	if ( file.activePageIndex == 0 )
		Hud_Hide( file.prevPageButton )
	else
		Hud_Show( file.prevPageButton )

	if ( file.activePageIndex == file.pages.len() - 1 )
		Hud_Hide( file.nextPageButton )
	else
		Hud_Show( file.nextPageButton )

	var panel = Hud_GetChild( file.menu, "FooterButtons" )
	int width = PageHasBuyOption() ? 422 : 200
	Hud_SetWidth( panel, ContentScaledXAsInt( width ) )

	UpdateFooterOptions()
}


bool function PageHasBuyOption()
{
	string link = file.pages[file.activePageIndex].link

	return ( link.find( "buy:" ) == 0 )
}
