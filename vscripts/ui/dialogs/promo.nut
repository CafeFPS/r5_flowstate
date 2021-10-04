global function InitPromoDialog
global function OpenPromoDialogIfNew
global function OpenPromoDialogIfNewAfterPakLoad
global function IsPromoDialogAllowed

global function PromoDialog_OpenHijacked

const PROMO_DIALOG_MAX_PAGES = 9

struct PromoDialogPageData
{
	asset  image = $""
	string imageName = ""
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

	array<PromoDialogPageData> pages
	int                        activePageIndex = 0
	var                        lastPageRui
	var                        activePageRui
	int                        updateID = -1

	int promoVersionSeen_PREDICTED = -1
} file


bool function OpenPromoDialogIfNew()
{
	if( GetConVarBool( "assetdownloads_enabled" ) )
	{
		file.pages = InitPages()
		RunClientScript( "RequestDownloadedImagePakLoad", GetPromoRpakName(), ePakType.DL_PROMO, Hud_GetChild( file.menu, "ActivePage" ), file.pages[0].imageName )
		RunClientScript( "RequestDownloadedImagePakLoad", GetPromoRpakName(), ePakType.DL_PROMO, Hud_GetChild( file.menu, "LastPage" ), file.pages[0].imageName )
	}
	else if ( IsPromoDialogNew() )
	{
		AdvanceMenu( file.menu )
		return true
	}

	return false
}

void function OpenPromoDialogIfNewAfterPakLoad()
{
	RuiSetBool( file.lastPageRui, "isImageLoading", false )
	
	if ( IsPromoDialogNew() )
		AdvanceMenu( file.menu )
}

bool function IsPromoDialogNew()
{
	UpdatePromoData()

	entity player = GetUIPlayer()
	if ( player == null || !IsPromoDialogAllowed() )
		return false

	int promoVersion = GetPromoDataVersion()
	if ( file.promoVersionSeen_PREDICTED == -1 )
		file.promoVersionSeen_PREDICTED = player.GetPersistentVarAsInt( "promoVersionSeen" )

	return promoVersion != 0 && promoVersion != file.promoVersionSeen_PREDICTED
}

bool function IsPromoDialogAllowed()
{
	return (IsPromoDataProtocolValid() && IsLobby() && IsFullyConnected() && GetActiveMenu() == GetMenu( "LobbyMenu" ) && IsTabPanelActive( GetPanel( "PlayPanel" ) ))
}


void function InitPromoDialog( var newMenuArg ) //
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
}


void function PromoDialog_OpenHijacked( string content )
{
	file.hijackContent = content
	AdvanceMenu( file.menu )
}


void function PromoDialog_OnOpen()
{
	file.pages = InitPages()
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
			file.hijackCloseCallback = null
		}
	}
}


void function PromoDialog_OnNavigateBack()
{
	if ( GetUIPlayer() != null && IsFullyConnected() && file.hijackContent == null )
	{
		file.promoVersionSeen_PREDICTED = GetPromoDataVersion()
		ClientCommand( format( "SetPromoVersionSeen %d", file.promoVersionSeen_PREDICTED ) )
	}

	CloseActiveMenu()
}


void function GoToStoreItem( var button )
{
	// TODO
}


array<PromoDialogPageData> function InitPages()
{
	string content = file.hijackContent != null ? expect string( file.hijackContent ) : GetPromoDataLayout()

	if ( content.find( "<" ) != 0 ) //
		content = "<p|0||" + content + ">"

	array< array<string> > matches = RegexpFindAll( content, "<p\\|([^>\\|]*)\\|([^>\\|]*)\\|([^>\\|]*)>" )
	if ( matches.len() > PROMO_DIALOG_MAX_PAGES )
	{
		Warning( "Ignoring extra promo dialog pages! Found " + matches.len() + " pages and only " + PROMO_DIALOG_MAX_PAGES + " are supported." )
		matches.resize( PROMO_DIALOG_MAX_PAGES )
	}

	array<PromoDialogPageData> pages

	foreach ( vals in matches )
	{
		PromoDialogPageData newPage
		newPage.imageName = vals[1]
		if( !GetConVarBool( "assetdownloads_enabled" ) )
			newPage.image = GetPromoImage( vals[1] )
		newPage.title = vals[2]
		newPage.desc = vals[3]
		pages.append( newPage )
	}

	return pages
}


void function RegisterPageChangeInput()
{
	if ( file.pageChangeInputsRegistered )
		return

	RegisterButtonPressedCallback( BUTTON_SHOULDER_LEFT, Page_NavLeft )
	RegisterButtonPressedCallback( BUTTON_DPAD_LEFT, Page_NavLeft )
	RegisterButtonPressedCallback( KEY_LEFT, Page_NavLeft )

	RegisterButtonPressedCallback( BUTTON_SHOULDER_RIGHT, Page_NavRight )
	RegisterButtonPressedCallback( BUTTON_DPAD_RIGHT, Page_NavRight )
	RegisterButtonPressedCallback( KEY_RIGHT, Page_NavRight )


	file.pageChangeInputsRegistered = true

	thread TrackDpadInput()
}


void function DeregisterPageChangeInput()
{
	if ( !file.pageChangeInputsRegistered )
		return

	DeregisterButtonPressedCallback( BUTTON_SHOULDER_LEFT, Page_NavLeft )
	DeregisterButtonPressedCallback( BUTTON_DPAD_LEFT, Page_NavLeft )
	DeregisterButtonPressedCallback( KEY_LEFT, Page_NavLeft )

	DeregisterButtonPressedCallback( BUTTON_SHOULDER_RIGHT, Page_NavRight )
	DeregisterButtonPressedCallback( BUTTON_DPAD_RIGHT, Page_NavRight )
	DeregisterButtonPressedCallback( KEY_RIGHT, Page_NavRight )

	file.pageChangeInputsRegistered = false
}


void function TrackDpadInput()
{
	bool canChangePage = false

	while ( file.pageChangeInputsRegistered )
	{
		float xAxis = InputGetAxis( ANALOG_RIGHT_X )

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
	PromoDialogPageData page = file.pages[pageIndex]

	if( GetConVarBool( "assetdownloads_enabled" ) )
		RuiSetImage( rui, "imageAsset", GetDownloadedImageAsset( GetPromoRpakName(), page.imageName, ePakType.DL_PROMO ) )
	else
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

	return (link.find( "buy:" ) == 0)
}
