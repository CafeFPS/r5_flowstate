global function InitMiniPromo
global function MiniPromo_Start
global function MiniPromo_Stop

//
//
//

const int MINIPROMO_MAX_PAGES = 5
const float MINIPROMO_PAGE_CHANGE_DELAY = 7.0
const bool MINIPROMO_NAV_RIGHT = true
const bool MINIPROMO_NAV_LEFT = false
const bool MINIPROMO_PAGE_FORMAT_DEFAULT = true
const bool MINIPROMO_PAGE_FORMAT_OPENPACK = false

struct MiniPromoPageData
{
	bool          isValid = false
	bool          format = MINIPROMO_PAGE_FORMAT_DEFAULT
	asset         image = $""
	string		  imageName = ""
	string        text1 = ""
	string        text2 = ""
	string        linkType = ""
	array<string> linkData
}

struct
{
	bool grxCallbacksRegistered = false

	array<MiniPromoPageData> allPages
	int                      activePageIndex = -1
	var                      button

	table signalDummy

	bool  navInputCallbacksRegistered = false
	float stickDeflection = 0
	int   lastStickState = eStickState.NEUTRAL

	//
} file


void function InitMiniPromo( var button )
{
	RegisterSignal( "EndAutoAdvancePages" )

	file.button = button

	Hud_AddEventHandler( button, UIE_CLICK, MiniPromoButton_OnActivate )
	Hud_AddEventHandler( button, UIE_GET_FOCUS, MiniPromoButton_OnGetFocus )
	Hud_AddEventHandler( button, UIE_LOSE_FOCUS, MiniPromoButton_OnLoseFocus )
}


void function MiniPromo_Start()
{
	//

	Signal( file.signalDummy, "EndAutoAdvancePages" ) //
	//

	UpdatePromoData()

	if ( !IsPromoDataProtocolValid() )
		return

	file.allPages = InitPages()

	if ( !file.grxCallbacksRegistered )
	{
		AddCallbackAndCallNow_OnGRXOffersRefreshed( OnGRXStateChanged )
		AddCallbackAndCallNow_OnGRXInventoryStateChanged( OnGRXStateChanged )
		file.grxCallbacksRegistered = true
	}
}


void function MiniPromo_Stop()
{
	//

	MiniPromo_Reset()

	if ( file.grxCallbacksRegistered )
	{
		RemoveCallback_OnGRXOffersRefreshed( OnGRXStateChanged )
		RemoveCallback_OnGRXInventoryStateChanged( OnGRXStateChanged )
		file.grxCallbacksRegistered = false
	}
}


//
//
//
//
//
//
//
//


void function OnGRXStateChanged()
{
	if ( !GRX_IsInventoryReady() || !GRX_AreOffersReady() )
		return

	UpdateValidityOfPages( file.allPages )

	int validPageCount = GetValidPageCount()

	if ( validPageCount > 0 )
	{
		if ( file.activePageIndex == -1 )
		{
			foreach ( index, page in file.allPages )
			{
				if ( !page.isValid )
					continue

				file.activePageIndex = index
				break
			}

			Hud_Show( file.button )
			SetPage( file.activePageIndex, true )
			thread AutoAdvancePages()
		}
		else if ( !IsPageValidToShow( file.allPages[file.activePageIndex] ) )
		{
			ChangePage( MINIPROMO_NAV_RIGHT )
			thread AutoAdvancePages()
		}

		var rui = Hud_GetRui( file.button )
		RuiSetInt( rui, "pageCount", validPageCount )
		RuiSetInt( rui, "activePageIndex", GetActivePageIndexForRui() )
	}
	else
	{
		MiniPromo_Reset()
	}
}


void function MiniPromo_Reset()
{
	Signal( uiGlobal.signalDummy, "EndAutoAdvancePages" )
	file.activePageIndex = -1
	Hud_Hide( file.button )
}


void function UpdateValidityOfPages( array<MiniPromoPageData> pages )
{
	//
	//
	//
	//
	//
	//
	//

	foreach ( page in pages )
	{
		switch ( page.linkType )
		{
			case "openpack":
				page.isValid = GRX_IsInventoryReady() && GRX_GetTotalPackCount() > 0
				break

			case "battlepass":
			case "storecharacter":
				page.isValid = !GRX_IsItemOwnedByPlayer( GetItemFlavorByHumanReadableRef( page.linkData[0] ) )
				break

			case "storeskin":
				ItemFlavor item = GetItemFlavorByHumanReadableRef( page.linkData[0] )
				page.isValid = GRX_GetStoreOfferItems().contains( item ) && !GRX_IsItemOwnedByPlayer( item )
				break

			case "themedstoreskin":
				array<ItemFlavor> themedShopItems
				ItemFlavor ornull themedShopEvent = GetActiveThemedShopEvent( GetUnixTimestamp() )
				if ( themedShopEvent != null )
				{
					expect ItemFlavor( themedShopEvent )

					string location = ThemedShopEvent_GetGRXOfferLocation( themedShopEvent )
					themedShopItems = GRX_GetLocationOfferItems( location )
				}

				ItemFlavor item = GetItemFlavorByHumanReadableRef( page.linkData[0] )
				page.isValid = themedShopItems.contains( item ) && !GRX_IsItemOwnedByPlayer( item )
				break

			case "url":
				page.isValid = true //
				break
		}
	}
}


bool function IsPageValidToShow( MiniPromoPageData page )
{
	return page.isValid
}


int function GetValidPageCount()
{
	int validPageCount = 0

	foreach ( page in file.allPages )
	{
		if ( page.isValid )
			validPageCount++
	}

	return validPageCount
}


int function GetActivePageIndexForRui()
{
	int index = 0

	for ( int i = 0; i < file.activePageIndex; i++ )
	{
		if ( file.allPages[i].isValid )
			index++
	}

	return index
}


array<MiniPromoPageData> function InitPages()
{
	string content = "<m|m_openpack|OPEN PACK||openpack>"
	content += GetPromoDataLayout()
	//
	//
	//
	//
	//
	//
	//

	//
	array< array<string> > matches = RegexpFindAll( content, "<m\\|([^>\\|]*)\\|([^>\\|]*)\\|([^>\\|]*)\\|([^>\\|]+)>" )
	if ( matches.len() > MINIPROMO_MAX_PAGES )
	{
		Warning( "Ignoring extra mini promo pages! Found " + matches.len() + " pages and only " + MINIPROMO_MAX_PAGES + " are supported." )
		matches.resize( MINIPROMO_MAX_PAGES )
	}

	array<MiniPromoPageData> pages

	foreach ( idx, vals in matches )
	{
		//
		//
		//

		//
		//
		MiniPromoPageData newPage
		newPage.imageName = vals[1]
		if( !GetConVarBool( "assetdownloads_enabled" ) || idx == 0 )
			newPage.image = GetPromoImage( newPage.imageName )
		newPage.text1 = vals[2]
		newPage.text2 = vals[3]

		if ( vals[4].slice( 0, 4 ).tolower() == "url:" ) //
		{
			newPage.linkType = "url"
			newPage.linkData.append( vals[4].slice( 4, vals[4].len() ) )
		}
		else
		{
			array<string> linkVals = split( vals[4], ":" )
			if ( linkVals.len() > 0 )
			{
				newPage.linkType = linkVals[0]
				linkVals.remove( 0 )
				newPage.linkData = linkVals
			}
		}

		//
		//
		//

		if ( IsLinkFormatValid( newPage.linkType, newPage.linkData ) )
		{
			newPage.format = newPage.linkType == "openpack" ? MINIPROMO_PAGE_FORMAT_OPENPACK : MINIPROMO_PAGE_FORMAT_DEFAULT
			pages.append( newPage )
		}
		else
		{
			Warning( "Ignoring invalid mini promo link format (" + vals[4] + ")!" )
		}
	}

	return pages
}


bool function IsLinkFormatValid( string linkType, array<string> linkData )
{
	if ( linkType == "openpack" && linkData.len() == 0 )
		return true
	else if ( (linkType == "battlepass" || linkType == "storecharacter" || linkType == "storeskin" || linkType == "themedstoreskin") && linkData.len() == 1 && IsValidItemFlavorHumanReadableRef( linkData[0] ) )
		return true
	else if ( linkType == "url" && linkData.len() == 1 ) //
		return true

	return false
}


void function AutoAdvancePages()
{
	//
	Signal( uiGlobal.signalDummy, "EndAutoAdvancePages" )
	EndSignal( uiGlobal.signalDummy, "EndAutoAdvancePages" )

	while ( true )
	{
		float delay = file.allPages[file.activePageIndex].linkType == "openpack" ? MINIPROMO_PAGE_CHANGE_DELAY * 3 : MINIPROMO_PAGE_CHANGE_DELAY
		wait delay

		while ( GetFocus() == file.button )
			WaitFrame()

		ChangePage( MINIPROMO_NAV_RIGHT )
	}
}


void function ChangePage( bool direction )
{
	Assert( direction == MINIPROMO_NAV_LEFT || direction == MINIPROMO_NAV_RIGHT )
	Assert( file.activePageIndex != -1 )

	int numPages      = file.allPages.len()
	int nextPageIndex = file.activePageIndex

	for ( int i = 1; i < numPages; i++ )
	{
		int candidatePageIndex          = direction == MINIPROMO_NAV_RIGHT ? (file.activePageIndex + i) % numPages : (file.activePageIndex - i + numPages) % numPages
		//
		MiniPromoPageData candidatePage = file.allPages[candidatePageIndex]
		if ( IsPageValidToShow( candidatePage ) )
		{
			nextPageIndex = candidatePageIndex
			break
		}
		//
		//
		//
		//
	}

	if ( nextPageIndex != file.activePageIndex )
		SetPage( nextPageIndex )
	//
	//
}


void function SetPage( int pageIndex, bool instant = false )
{
	//

	var rui = Hud_GetRui( file.button )

	float time = instant ? Time() - 10 : Time()
	RuiSetGameTime( rui, "initTime", time )

	int lastActivePage = file.activePageIndex
	file.activePageIndex = pageIndex

	MiniPromoPageData lastPage = file.allPages[lastActivePage]
	if( GetConVarBool( "assetdownloads_enabled" ) && lastActivePage > 0 )
		RuiSetImage( rui, "lastImageAsset", GetDownloadedImageAsset( GetMiniPromoRpakName(), lastPage.imageName, ePakType.DL_MINI_PROMO ) )
	else
		RuiSetImage( rui, "lastImageAsset", lastPage.image )
	RuiSetBool( rui, "lastFormat", lastPage.format )
	RuiSetString( rui, "lastText1", lastPage.text1 )
	RuiSetString( rui, "lastText2", lastPage.text2 )

	MiniPromoPageData page = file.allPages[file.activePageIndex]
	if( GetConVarBool( "assetdownloads_enabled" ) && file.activePageIndex > 0 )
		RuiSetImage( rui, "imageAsset", GetDownloadedImageAsset( GetMiniPromoRpakName(), page.imageName, ePakType.DL_MINI_PROMO, file.button ) )
	else
		RuiSetImage( rui, "imageAsset", page.image )
	RuiSetBool( rui, "format", page.format )
	RuiSetString( rui, "text1", page.text1 )
	RuiSetString( rui, "text2", page.text2 )

	RuiSetInt( rui, "activePageIndex", GetActivePageIndexForRui() )

	int ownedPacks = GRX_IsInventoryReady() ? GRX_GetTotalPackCount() : 0
	if ( ownedPacks > 0 )
	{
		RuiSetInt( rui, "ownedPacks", ownedPacks )

		ItemFlavor ornull pack = GetNextLootBox()
		expect ItemFlavor( pack )
		//
		//
		//
		//
		//
		//
		//

		asset packIcon            = GRXPack_GetOpenButtonIcon( pack )
		int packRarity            = ItemFlavor_GetQuality( pack )
		vector ornull customColor = GRXPack_GetCustomColor( pack, 0 )

		vector packColor = <1, 1, 1>
		if ( customColor != null )
			packColor = expect vector( customColor )
		else
			packColor = GetKeyColor( COLORID_TEXT_LOOT_TIER0, packRarity + 1 ) / 255.0

		vector countTextCol              = <255, 78, 29> * 1.0 / 255.0
		vector ornull customCountTextCol = GRXPack_GetCustomCountTextCol( pack )
		if ( customCountTextCol != null )
			countTextCol = expect vector(customCountTextCol)

		vector rarityColor = GetKeyColor( COLORID_TEXT_LOOT_TIER0, packRarity + 1 ) / 255.0

		RuiSetAsset( rui, "packIcon", packIcon )
		RuiSetColorAlpha( rui, "packColor", SrgbToLinear( packColor ), 1.0 )
		RuiSetColorAlpha( rui, "packCountTextCol", SrgbToLinear( countTextCol ), 1.0 )
		RuiSetColorAlpha( rui, "rarityColor", SrgbToLinear( rarityColor ), 1.0 )
	}
}


//
void function MiniPromoButton_OnActivate( var button )
{
	//

	MiniPromoPageData page = file.allPages[file.activePageIndex]

	if ( page.linkType == "openpack" )
	{
		if ( GRX_IsInventoryReady() && GRX_GetTotalPackCount() > 0 )
		{
			EmitUISound( "UI_Menu_OpenLootBox" )
			OnLobbyOpenLootBoxMenu_ButtonPress()
		}
	}
	else if ( page.linkType == "battlepass" )
	{
		EmitUISound( "UI_Menu_Accept" )

		string panelName = "PassPanelV2"

		TabData lobbyTabData = GetTabDataForPanel( GetMenu( "LobbyMenu" ) )
		ActivateTab( lobbyTabData, Tab_GetTabIndexByBodyName( lobbyTabData, panelName ) )
	}
	else if ( page.linkType == "storecharacter" )
	{
		ItemFlavor character = GetItemFlavorByHumanReadableRef( page.linkData[0] )
		if ( GRX_IsItemOwnedByPlayer( character ) )
			return

		EmitUISound( "UI_Menu_Accept" )
		JumpToStoreCharacter( character )
	}
	else if ( page.linkType == "storeskin" )
	{
		ItemFlavor skin = GetItemFlavorByHumanReadableRef( page.linkData[0] )
		if ( GRX_IsItemOwnedByPlayer( skin ) )
			return

		EmitUISound( "UI_Menu_Accept" )
		JumpToStoreSkin( skin )
	}
	else if ( page.linkType == "themedstoreskin" )
	{
		ItemFlavor skin = GetItemFlavorByHumanReadableRef( page.linkData[0] )
		if ( GRX_IsItemOwnedByPlayer( skin ) )
			return

		EmitUISound( "UI_Menu_Accept" )
		JumpToThemedShop()
	}
	else if ( page.linkType == "url" )
	{
		EmitUISound( "UI_Menu_Accept" )
		LaunchExternalWebBrowser( page.linkData[0], WEBBROWSER_FLAG_NONE )
	}

	//
}


void function MiniPromoButton_OnGetFocus( var button )
{
	if ( file.navInputCallbacksRegistered )
		return

	file.lastStickState = eStickState.NEUTRAL
	RegisterStickMovedCallback( ANALOG_RIGHT_X, OnStickMoved )
	AddCallback_OnMouseWheelUp( ChangePromoPageToLeft )
	AddCallback_OnMouseWheelDown( ChangePromoPageToRight )
	file.navInputCallbacksRegistered = true
}


void function MiniPromoButton_OnLoseFocus( var button )
{
	if ( !file.navInputCallbacksRegistered )
		return

	DeregisterStickMovedCallback( ANALOG_RIGHT_X, OnStickMoved )
	RemoveCallback_OnMouseWheelUp( ChangePromoPageToLeft )
	RemoveCallback_OnMouseWheelDown( ChangePromoPageToRight )
	file.navInputCallbacksRegistered = false
}


void function OnStickMoved( ... )
{
	float stickDeflection = expect float( vargv[1] )
	//

	int stickState = eStickState.NEUTRAL
	if ( stickDeflection > 0.25 )
		stickState = eStickState.RIGHT
	else if ( stickDeflection < -0.25 )
		stickState = eStickState.LEFT

	if ( stickState != file.lastStickState && file.activePageIndex != -1 )
	{
		if ( stickState == eStickState.RIGHT )
		{
			//
			ChangePage( MINIPROMO_NAV_RIGHT )
			thread AutoAdvancePages()
		}
		else if ( stickState == eStickState.LEFT )
		{
			//
			ChangePage( MINIPROMO_NAV_LEFT )
			thread AutoAdvancePages()
		}
	}

	file.lastStickState = stickState
}


void function ChangePromoPageToLeft()
{
	if ( file.activePageIndex == -1 )
		return

	ChangePage( MINIPROMO_NAV_LEFT )
	thread AutoAdvancePages()
}


void function ChangePromoPageToRight()
{
	if ( file.activePageIndex == -1 )
		return

	ChangePage( MINIPROMO_NAV_RIGHT )
	thread AutoAdvancePages()
}
