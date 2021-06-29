global function UserInfoPanels_LevelInit
//


struct SingleCurrencyBalanceElement
{
	var         element
	ItemFlavor& currency
}

struct FileStruct_LifetimeLevel
{
	table<var, bool>                    activeUserInfoPanelSet
	array<SingleCurrencyBalanceElement> singleCurrencyBalanceElementList
}
FileStruct_LifetimeLevel& fileLevel

void function UserInfoPanels_LevelInit()
{
	FileStruct_LifetimeLevel newFileLevel
	fileLevel = newFileLevel

	SetupUserInfoPanelToolTips()
	AddCallbackOrMaybeCallNow_OnAllItemFlavorsRegistered( SetupUserInfoPanels )
}

//
//
//
//


void function SetupUserInfoPanelToolTips()
{
	ToolTipData ttd
	ttd.tooltipStyle = eTooltipStyle.CURRENCY
	ttd.descText = "#CURRENCIES_TOOLTIP"

	foreach ( var menu in uiGlobal.allMenus )
	{
		array<var> userInfoElemList = GetElementsByClassname( menu, "UserInfo" )

		foreach ( var elem in userInfoElemList )
			Hud_SetToolTipData( elem, ttd )
	}
}


void function SetupUserInfoPanels()
{
	foreach ( var menu in uiGlobal.allMenus )
	{
		array<var> userInfoElemList = GetElementsByClassname( menu, "UserInfo" )

		if ( userInfoElemList.len() > 0 )
		{
			foreach ( var elem in userInfoElemList )
			{
				var rui = Hud_GetRui( elem )
				RuiSetImage( rui, "symbol1", ItemFlavor_GetIcon( GRX_CURRENCIES[GRX_CURRENCY_PREMIUM] ) )
				RuiSetImage( rui, "symbol2", ItemFlavor_GetIcon( GRX_CURRENCIES[GRX_CURRENCY_CREDITS] ) )
				RuiSetImage( rui, "symbol3", ItemFlavor_GetIcon( GRX_CURRENCIES[GRX_CURRENCY_CRAFTING] ) )

				fileLevel.activeUserInfoPanelSet[elem] <- true //
			}

			//
			//
			//
			//
			//
			//
			//
			//
			//
		}
	}

	table<string, int> singleCurrencyElementTypesTable = {
		["PremiumBalance"] = GRX_CURRENCY_PREMIUM,
		["CreditBalance"] = GRX_CURRENCY_CREDITS,
		["CraftingBalance"] = GRX_CURRENCY_CRAFTING,
	}
	foreach( string classname, int currencyIndex in singleCurrencyElementTypesTable )
	{
		ItemFlavor currency = GRX_CURRENCIES[currencyIndex]
		foreach ( var elem in GetElementsByClassnameForMenus( classname, uiGlobal.allMenus ) )
		{
			var rui = Hud_GetRui( elem )
			RuiSetImage( rui, "symbol", ItemFlavor_GetIcon( currency ) )

			SingleCurrencyBalanceElement scbe
			scbe.element = elem
			scbe.currency = currency
			fileLevel.singleCurrencyBalanceElementList.append( scbe )
		}
	}

	AddCallbackAndCallNow_OnGRXInventoryStateChanged( UpdateActiveUserInfoPanels )
	AddCallbackAndCallNow_OnGRXOffersRefreshed( UpdateActiveUserInfoPanels )
}


void function UpdateActiveUserInfoPanels()
{
	bool isReady = GRX_IsInventoryReady() && GRX_AreOffersReady()
	int premiumBalance, creditsBalance, craftingBalance
	if ( isReady )
	{
		premiumBalance = GRXCurrency_GetPlayerBalance( GetUIPlayer(), GRX_CURRENCIES[GRX_CURRENCY_PREMIUM] )
		creditsBalance = GRXCurrency_GetPlayerBalance( GetUIPlayer(), GRX_CURRENCIES[GRX_CURRENCY_CREDITS] )
		craftingBalance = GRXCurrency_GetPlayerBalance( GetUIPlayer(), GRX_CURRENCIES[GRX_CURRENCY_CRAFTING] )
	}

	foreach( var elem, bool unused in fileLevel.activeUserInfoPanelSet )
	{
		var rui = Hud_GetRui( elem )
		//
		RuiSetBool( rui, "isQuerying", !isReady )

		if ( isReady )
		{
			#if(DEV)
				RuiSetBool( rui, "hasUnknownItems", GetConVarBool( "grx_hasUnknownItems" ) )
			#endif
			RuiSetInt( rui, "count1", premiumBalance )
			RuiSetInt( rui, "count2", creditsBalance )
			RuiSetInt( rui, "count3", craftingBalance )
		}
	}

	foreach( SingleCurrencyBalanceElement scbe in fileLevel.singleCurrencyBalanceElementList )
	{
		var rui = Hud_GetRui( scbe.element )
		RuiSetBool( rui, "isQuerying", !isReady )

		if ( isReady )
			RuiSetInt( rui, "count", GRXCurrency_GetPlayerBalance( GetUIPlayer(), scbe.currency ) )
	}
}


/*

























*/
