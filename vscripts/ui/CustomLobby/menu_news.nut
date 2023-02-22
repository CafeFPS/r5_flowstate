global function InitR5RNews

const MAX_NEWS_ITEMS = 6

struct NewsPage
{
    string title
    string desc
    asset image
}

struct
{
	var menu
    var prevPageButton
    var nextPageButton
    
    int activePageIndex

    array<NewsPage> newspages

    bool navInputCallbacksRegistered = false
    
} file

void function InitR5RNews( var newMenuArg ) //
{
	var menu = GetMenu( "R5RNews" )
	file.menu = menu

	file.prevPageButton = Hud_GetChild( menu, "PrevPageButton" )
	HudElem_SetRuiArg( file.prevPageButton, "flipHorizontal", true )
	Hud_AddEventHandler( file.prevPageButton, UIE_CLICK, Page_NavLeft )

	file.nextPageButton = Hud_GetChild( menu, "NextPageButton" )
	Hud_AddEventHandler( file.nextPageButton, UIE_CLICK, Page_NavRight )

    for(int i = 0; i < MAX_NEWS_ITEMS; i++)
    {
        var button = Hud_GetChild( menu, "NewsItem" + (i + 1) )
	    Hud_AddEventHandler( button, UIE_CLICK, NewsItem_Activated )
    }

	SetGamepadCursorEnabled( menu, false )

	AddMenuEventHandler( menu, eUIEvent.MENU_OPEN, PromoDialog_OnOpen )
	//AddMenuEventHandler( menu, eUIEvent.MENU_CLOSE, PromoDialog_OnClose )
	AddMenuEventHandler( menu, eUIEvent.MENU_NAVIGATE_BACK, PromoDialog_OnNavigateBack )

	AddMenuFooterOption( menu, LEFT, BUTTON_B, true, "#B_BUTTON_CLOSE", "#B_BUTTON_CLOSE" )
}

void function NewsItem_Activated(var button)
{
    int id = Hud_GetScriptID( button ).tointeger()

    file.activePageIndex = id
    UpdatePageRui( file.activePageIndex )

    Hud_SetSelected( button, true )
	Hud_SetFocused( button )
}

void function Page_NavRight(var button)
{
    NavRight(true)
}

void function Page_NavLeft(var button)
{
    NavLeft(true)
}

void function Page_NavRightScrollWheel()
{
    NavRight(false)
}

void function Page_NavLeftScrollWheel()
{
    NavLeft(false)
}

void function NavRight(bool isbutton = false)
{
    file.activePageIndex++
    if ( file.activePageIndex > file.newspages.len() - 1 )
        file.activePageIndex = 0

    UpdatePageRui( file.activePageIndex )

    if(!isbutton)
        EmitUISound("UI_Menu_MOTD_Tab")
}

void function NavLeft(bool isbutton = false)
{
    file.activePageIndex--
    if ( file.activePageIndex < 0 )
        file.activePageIndex = file.newspages.len() - 1

    UpdatePageRui( file.activePageIndex )
    
    if(!isbutton)
        EmitUISound("UI_Menu_MOTD_Tab")
}

void function PromoDialog_OnNavigateBack()
{
    if(file.navInputCallbacksRegistered)
    {
        RemoveCallback_OnMouseWheelUp( Page_NavLeftScrollWheel )
        RemoveCallback_OnMouseWheelDown( Page_NavRightScrollWheel )
        file.navInputCallbacksRegistered = false
    }

	CloseActiveMenu()
}

void function PromoDialog_OnOpen()
{
    if(!file.navInputCallbacksRegistered)
    {
        AddCallback_OnMouseWheelUp( Page_NavLeftScrollWheel )
        AddCallback_OnMouseWheelDown( Page_NavRightScrollWheel )
        file.navInputCallbacksRegistered = true
    }

    //Get the news from the endpoint
    GetR5RNews()

	file.activePageIndex = 0
	UpdatePageRui( file.activePageIndex )
	UpdatePromoButtons()
}

void function GetR5RNews()
{
    //INFO FOR LATER
    //MAX PAGES = 6

    //TEMPOARY NEWS FOR TESTING
    //WILL BE REPLACED WITH A CALL TO THE NEWS ENDPOINT
    file.newspages.clear()

    for(int i = 0; i < 5; i++)
	{
		NewsPage page
		page.title = "Temp News " + (i + 1)
		page.desc = "Temp News Description " + (i + 1)
		page.image = GetAssetFromString( $"rui/promo/S3_General_" + (i + 1).tostring() )
		file.newspages.append(page)
	}
}

void function UpdatePageRui( int pageIndex )
{
    int nextpage = pageIndex + 1
    if ( nextpage > file.newspages.len() - 1 )
        nextpage = 0

    int lastpage = pageIndex - 1
    if ( lastpage < 0 )
        lastpage = file.newspages.len() - 1

    RuiSetImage(Hud_GetRui( Hud_GetChild( file.menu, "CenterNewsImage" ) ), "loadscreenImage", file.newspages[pageIndex].image )
    Hud_SetText(Hud_GetChild( file.menu, "TitleText" ), file.newspages[pageIndex].title )
    Hud_SetText(Hud_GetChild( file.menu, "DescText" ), file.newspages[pageIndex].desc )

    Hud_SetPinSibling( Hud_GetChild( file.menu, "NewsItemSelected" ), Hud_GetHudName( Hud_GetChild( file.menu, "NewsItem" + (pageIndex + 1) ) ) )

    if(file.newspages.len() > 1)
    {
        Hud_Show(Hud_GetChild( file.menu, "RightNewsImage" ))
        Hud_Show(Hud_GetChild( file.menu, "LeftNewsImage" ))
        RuiSetImage(Hud_GetRui( Hud_GetChild( file.menu, "RightNewsImage" ) ), "loadscreenImage", file.newspages[nextpage].image )
        RuiSetImage(Hud_GetRui( Hud_GetChild( file.menu, "LeftNewsImage" ) ), "loadscreenImage", file.newspages[lastpage].image )
    }
    else
    {
        Hud_Hide(Hud_GetChild( file.menu, "RightNewsImage" ))
        Hud_Hide(Hud_GetChild( file.menu, "LeftNewsImage" ))
    }

    SetSmallPreviewItems( pageIndex )
}

void function SetSmallPreviewItems( int pageIndex )
{
    int offset = 0
    //Hide all items
    for(int j = 0; j < MAX_NEWS_ITEMS; j++)
    {
        Hud_Hide( Hud_GetChild( file.menu, "NewsItem" + (j + 1) ) )
    }

    //Show only the ones we need
    for(int j = 0; j < file.newspages.len(); j++)
    {
        Hud_Show( Hud_GetChild( file.menu, "NewsItem" + (j + 1) ) )

        if(j != 0)
            offset -= (Hud_GetWidth(Hud_GetChild( file.menu, "NewsItem1" ))/2) + 5
    }

    Hud_SetX( Hud_GetChild( file.menu, "NewsItem1" ), 0 )

    if( file.newspages.len() > 1 )
        Hud_SetX( Hud_GetChild( file.menu, "NewsItem1" ), offset )
    
    int i = 1
    foreach( NewsPage page in file.newspages )
    {
        RuiSetString( Hud_GetRui( Hud_GetChild( file.menu, "NewsItem" + i ) ), "modeNameText", page.title )
	    RuiSetString( Hud_GetRui( Hud_GetChild( file.menu, "NewsItem" + i ) ), "modeDescText", "" )
	    RuiSetBool( Hud_GetRui( Hud_GetChild( file.menu, "NewsItem" + i )), "alwaysShowDesc", false )
	    RuiSetImage( Hud_GetRui( Hud_GetChild( file.menu, "NewsItem" + i ) ), "modeImage", page.image )

        i++

        if(i > MAX_NEWS_ITEMS)
            break
    }
}

void function UpdatePromoButtons()
{
	if ( file.newspages.len() <= 1 )
    {
		Hud_Hide( file.prevPageButton )
        Hud_Hide( file.nextPageButton )
    }
	else
    {
		Hud_Show( file.prevPageButton )
        Hud_Show( file.nextPageButton )
    }

	var panel = Hud_GetChild( file.menu, "FooterButtons" )
	int width = 200
	Hud_SetWidth( panel, ContentScaledXAsInt( width ) )
}