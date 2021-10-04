global function InitConfirmPurchaseDialog

global function PurchaseDialog

global struct PurchaseDialogConfig
{
	ItemFlavor ornull     flav = null
	GRXScriptOffer ornull offer = null

	int           quantity = 1
	bool          markAsNew = true
	string ornull messageOverride = null
	string ornull purchaseSoundOverride = null

	void functionref()                     onPurchaseStartCallback = null
	void functionref( bool wasSuccessful ) onPurchaseResultCallback = null
}

global enum ePurchaseDialogStatus
{
	INACTIVE = 0,
	AWAITING_USER_CONFIRMATION = 1,
	WORKING = 2,
	FINISHED_SUCCESS = 3,
	FINISHED_FAILURE = 4,
}

const int MAX_PURCHASE_BUTTONS = 5

struct PurchaseDialogState
{
	PurchaseDialogConfig&                   cfg
	array<GRXScriptOffer>                   purchaseOfferList
	table<var, GRXScriptOffer>              purchaseButtonOfferMap
	table<var, ItemFlavorBag>               purchaseButtonPriceMap
	string                                  purchaseSoundOverride = ""
}

struct
{
	var menu
	var contentRui
	var buttonsPanel
	var processingButton

	var dialogFrame
	var dialogContent

	var        cancelButton
	array<var> purchaseButtonBottomToTopList

	int                  status = ePurchaseDialogStatus.INACTIVE
	PurchaseDialogState& state
} file

void function InitConfirmPurchaseDialog( var newMenuArg )
{
	var menu = GetMenu( "ConfirmPurchaseDialog" )
	file.menu = menu
	//file.contentRui = Hud_GetRui( Hud_GetChild( file.menu, "ContentRui" ) )
	//file.processingButton = Hud_GetChild( menu, "ProcessingButton" )
	//file.buttonsPanel = Hud_GetChild( menu, "FooterButtons" )

	file.cancelButton = Hud_GetChild( menu, "CancelButton" )
	HudElem_SetRuiArg( file.cancelButton, "buttonText", "#B_BUTTON_CANCEL" )
	Hud_AddEventHandler( file.cancelButton, UIE_CLICK, CancelButton_Activate )

	for ( int purchaseButtonIdx = 0; purchaseButtonIdx < MAX_PURCHASE_BUTTONS; purchaseButtonIdx++ )
	{
		var button = Hud_GetChild( menu, "PurchaseButton" + purchaseButtonIdx )

		Hud_AddEventHandler( button, UIE_CLICK, PurchaseButton_Activate )

		file.purchaseButtonBottomToTopList.append( button )
	}

	file.dialogFrame = Hud_GetChild( file.menu, "DialogFrame" )
	InitButtonRCP( file.dialogFrame )

	file.dialogContent = Hud_GetChild( file.menu, "DialogContent" )
	InitButtonRCP( file.dialogContent )

	SetDialog( menu, true )
	SetClearBlur( menu, false )
	//SetGamepadCursorEnabled( menu, false )

	AddMenuEventHandler( menu, eUIEvent.MENU_OPEN, ConfirmPurchaseDialog_OnOpen )
	AddMenuEventHandler( menu, eUIEvent.MENU_CLOSE, ConfirmPurchaseDialog_OnClose )
	AddMenuEventHandler( menu, eUIEvent.MENU_NAVIGATE_BACK, ConfirmPurchaseDialog_OnNavigateBack )

	//AddMenuFooterOption( menu, LEFT, BUTTON_A, true, "#A_BUTTON_PURCHASE", "#PURCHASE", ConfirmPurchase )
	//AddMenuFooterOption( menu, LEFT, BUTTON_B, true, "#B_BUTTON_CANCEL", "#CANCEL" )

	RegisterSignal( "ConfirmPurchaseClosed" )
}


void function PurchaseDialog( PurchaseDialogConfig cfg )
{
	Assert( GRX_IsInventoryReady() )
	Assert( file.status == ePurchaseDialogStatus.INACTIVE )

	PurchaseDialogState state
	file.state = state
	file.status = ePurchaseDialogStatus.AWAITING_USER_CONFIRMATION
	file.state.cfg = cfg

	if ( cfg.flav != null )
	{
		ItemFlavor flav = expect ItemFlavor(cfg.flav)
		printt( "PurchaseDialog", ItemFlavor_GetHumanReadableRef( flav ) )

		Assert( ItemFlavor_GetGRXMode( flav ) != GRX_ITEMFLAVORMODE_NONE )

		if ( ItemFlavor_GetGRXMode( flav ) == GRX_ITEMFLAVORMODE_REGULAR && GRX_IsItemOwnedByPlayer( flav ) )
		{
			Assert( false, "Called PurchaseDialog with an already-owned item: " + ItemFlavor_GetHumanReadableRef( flav ) )
			EmitUISound( "menu_deny" )
			return
		}

		ItemFlavorPurchasabilityInfo ifpi = GRX_GetItemPurchasabilityInfo( flav )
		Assert( ifpi.isPurchasableAtAll )

		if ( ifpi.craftingOfferOrNull != null )
			file.state.purchaseOfferList.append( expect GRXScriptOffer(ifpi.craftingOfferOrNull) )

		foreach ( string location, array<GRXScriptOffer> locationOfferList in ifpi.locationToDedicatedStoreOffersMap )
			foreach ( GRXScriptOffer locationOffer in locationOfferList )
				file.state.purchaseOfferList.append( locationOffer )
	}
	else if ( cfg.offer != null )
	{
		GRXScriptOffer offer = expect GRXScriptOffer(cfg.offer)
		printt( "PurchaseDialog", DEV_GRX_DescribeOffer( offer ) )
		if ( GRXOffer_IsFullyClaimed( offer ) )
		{
			Assert( false, "Called PurchaseDialog with an already-fully-claimed offer: " + DEV_GRX_DescribeOffer( offer ) )
			EmitUISound( "menu_deny" )
			return
		}
		file.state.purchaseOfferList.append( offer )
	}
	else
	{
		Assert( false, "Called PurchaseDialog with no flav or offer" )
		return
	}

	// todo(dw): locationToBundledStoreOffersMap

	EmitUISound( "UI_Menu_Cosmetic_Unlock" )
	AdvanceMenu( file.menu )
}


void function GotoPremiumStoreTab()
{
	Assert( IsLobby() )

	while ( GetActiveMenu() != GetMenu( "LobbyMenu" ) && GetActiveMenu() != null )
		CloseActiveMenu()

	if ( GetActiveMenu() == null )
		AdvanceMenu( GetMenu( "LobbyMenu" ) )

	TabData tabData = GetTabDataForPanel( GetMenu( "LobbyMenu" ) )
	ActivateTab( tabData, Tab_GetTabIndexByBodyName( tabData, "StorePanel" ) )
	TabDef tabDef        = Tab_GetTabDefByBodyName( tabData, "StorePanel" )
	TabData storeTabData = GetTabDataForPanel( tabDef.panel )
	ActivateTab( storeTabData, Tab_GetTabIndexByBodyName( storeTabData, "VCPanel" ) )
}


void function PurchaseButton_Activate( var button )
{
	Assert( file.status == ePurchaseDialogStatus.AWAITING_USER_CONFIRMATION )

	if ( Hud_IsLocked( button ) )
		return

	GRXScriptOffer offer = file.state.purchaseButtonOfferMap[button]
	ItemFlavorBag price  = file.state.purchaseButtonPriceMap[button]

	bool isPremiumOnly = GRX_IsPremiumPrice( price )
	int quantity       = file.state.cfg.quantity
	bool canAfford     = GRX_CanAfford( price, quantity )
	if ( isPremiumOnly && !canAfford )
	{
		GotoPremiumStoreTab()
		return
	}

	Assert( canAfford )

	file.status = ePurchaseDialogStatus.WORKING


	int queryGoal
	if ( offer.isCraftingOffer )
	{
		queryGoal = GRX_HTTPQUERYGOAL_CRAFT_ITEM
	}
	else
	{
		queryGoal = GRX_HTTPQUERYGOAL_PURCHASE_STORE_OFFER

		if ( file.state.cfg.flav != null )
		{
			int itemType = ItemFlavor_GetType( expect ItemFlavor(file.state.cfg.flav) )
			if ( itemType == eItemType.character )
				queryGoal = GRX_HTTPQUERYGOAL_PURCHASE_CHARACTER
			else if ( itemType == eItemType.account_pack )
				queryGoal = GRX_HTTPQUERYGOAL_PURCHASE_PACK
		}
	}

	ScriptGRXOperationInfo operation
	operation.expectedQueryGoal = queryGoal
	operation.doOperationFunc = (void function( int opId ) : (queryGoal, offer, price, quantity) {
		GRX_PurchaseOffer( opId, queryGoal, offer, price, quantity )
	})
	operation.onDoneCallback = (void function( int status ) : ( offer, price )
	{
		OnPurchaseOperationFinished( status, offer, price )
	})

	if ( file.state.cfg.onPurchaseStartCallback != null )
	{
		file.state.cfg.onPurchaseStartCallback()
		file.state.cfg.onPurchaseStartCallback = null
	}

	QueueGRXOperation( GetUIPlayer(), operation )

	UpdateProcessingElements()
	HudElem_SetRuiArg( button, "isProcessing", true )
}


void function CancelButton_Activate( var button )
{
	UICodeCallback_NavigateBack()
}


void function UpdateProcessingElements()
{
	bool isWorking = (file.status == ePurchaseDialogStatus.WORKING)

	//Hud_Hide( file.buttonsPanel )
	//Hud_Show( file.processingButton )
	Hud_SetEnabled( file.cancelButton, !isWorking )
	HudElem_SetRuiArg( file.cancelButton, "isProcessing", isWorking )
	HudElem_SetRuiArg( file.cancelButton, "processingState", file.status )

	foreach ( button in file.purchaseButtonBottomToTopList )
	{
		Hud_SetEnabled( button, !isWorking )
		HudElem_SetRuiArg( button, "isProcessing", false )
	}
}


void function OnPurchaseOperationFinished( int status, GRXScriptOffer offer, ItemFlavorBag price )
{
	Assert( file.status == ePurchaseDialogStatus.WORKING )

	bool wasSuccessful = (status == eScriptGRXOperationStatus.DONE_SUCCESS)

	file.status = (wasSuccessful ? ePurchaseDialogStatus.FINISHED_SUCCESS : ePurchaseDialogStatus.FINISHED_FAILURE)

	if ( wasSuccessful )
	{
		ClientCommand( "lastSeenPremiumCurrency" )

		string purchaseSound
		if ( file.state.cfg.purchaseSoundOverride != null )
		{
			purchaseSound = expect string(file.state.cfg.purchaseSoundOverride)
		}
		else
		{
			int lowestCurrencyIndex = GRX_CURRENCY_COUNT
			foreach ( int costIndex, ItemFlavor costFlav in price.flavors )
			{
				if ( GRXCurrency_GetCurrencyIndex( costFlav ) < lowestCurrencyIndex )
					lowestCurrencyIndex = GRXCurrency_GetCurrencyIndex( costFlav )
			}

			if ( lowestCurrencyIndex != GRX_CURRENCY_COUNT )
				purchaseSound = GRXCurrency_GetPurchaseSound( GRX_CURRENCIES[lowestCurrencyIndex] )
		}
		if ( purchaseSound != "" )
			EmitUISound( purchaseSound )
	}
	else
	{
		EmitUISound( "menu_deny" )
	}

	if ( file.state.cfg.markAsNew )
	{
		foreach ( ItemFlavor outputFlav in offer.output.flavors )
			Newness_TEMP_MarkItemAsNewAndInformServer( outputFlav )
	}

	if ( file.state.cfg.onPurchaseResultCallback != null )
	{
		file.state.cfg.onPurchaseResultCallback( wasSuccessful )
		file.state.cfg.onPurchaseResultCallback = null
	}

	thread ReportStatusAndClose( file.status )
}


void function ReportStatusAndClose( int processingState )
{
	EndSignal( uiGlobal.signalDummy, "CleanupInGameMenus" )
	EndSignal( uiGlobal.signalDummy, "ConfirmPurchaseClosed" )

	HudElem_SetRuiArg( file.cancelButton, "processingState", processingState )

	wait 1.6

	if ( GetActiveMenu() == file.menu )
		thread CloseActiveMenu()
}


void function ConfirmPurchaseDialog_OnOpen()
{
	Assert( file.status == ePurchaseDialogStatus.AWAITING_USER_CONFIRMATION )

	AddCallbackAndCallNow_OnGRXInventoryStateChanged( UpdatePurchaseDialog )
}


void function UpdatePurchaseDialog()
{
	if ( file.status != ePurchaseDialogStatus.AWAITING_USER_CONFIRMATION )
		return

	int quality        = eQuality.COMMON
	string messageText = "#PURCHASE"
	string devDesc

	if ( file.state.cfg.messageOverride != null )
	{
		messageText = expect string(file.state.cfg.messageOverride)
	}
	else if ( file.state.cfg.flav != null )
	{
		ItemFlavor flav = expect ItemFlavor(file.state.cfg.flav)
		devDesc = ItemFlavor_GetHumanReadableRef( flav )

		string flavName = Localize( ItemFlavor_GetLongName( flav ) )
		quality = ItemFlavor_HasQuality( flav ) ? ItemFlavor_GetQuality( flav ) : 0

		switch ( ItemFlavor_GetType( flav ) )
		{
			case eItemType.gladiator_card_intro_quip:
			case eItemType.gladiator_card_kill_quip:
				messageText = Localize( "#QUOTE_STRING", flavName )
				break

			case eItemType.character:
				messageText = flavName
				break

			case eItemType.battlepass_purchased_xp:
				if ( file.state.cfg.quantity > 1 )
					messageText = Localize( "#STORE_ITEM_X_N", flavName, file.state.cfg.quantity )
				else
					messageText = flavName
				break

			default:
				if ( file.state.cfg.quantity > 1 )
					messageText = Localize( "#STORE_ITEM_X_N", flavName, file.state.cfg.quantity ) + "\n`1" + Localize( ItemFlavor_GetQualityName( flav ) )
				else
					messageText = flavName + "\n`1" + Localize( ItemFlavor_GetQualityName( flav ) )
				break
		}
	}
	else if ( file.state.cfg.offer != null )
	{
		GRXScriptOffer offer = expect GRXScriptOffer(file.state.cfg.offer)
		devDesc = DEV_GRX_DescribeOffer( offer )

		messageText = offer.titleText

		quality = eQuality.COMMON
		foreach ( ItemFlavor outputFlav in offer.output.flavors )
			quality = maxint( quality, ItemFlavor_GetQuality( outputFlav ) )
	}

	printt( "UpdatePurchaseDialog", devDesc )

	HudElem_SetRuiArg( file.dialogContent, "quality", quality )
	HudElem_SetRuiArg( file.dialogContent, "quantity", file.state.cfg.quantity )
	HudElem_SetRuiArg( file.dialogContent, "headerText", "#CONFIRM_PURCHASE_HEADER" )
	HudElem_SetRuiArg( file.dialogContent, "messageText", messageText )

	UpdateProcessingElements()

	int purchaseButtonIdx = 0
	file.state.purchaseButtonOfferMap.clear()
	file.state.purchaseButtonPriceMap.clear()

	array<GRXScriptOffer> offerList = clone file.state.purchaseOfferList
	offerList.reverse() // reverse because the purchase buttons are set up from bottom to top
	foreach ( GRXScriptOffer offer in offerList )
	{
		array<ItemFlavorBag> priceList = clone offer.prices
		priceList.sort( int function( ItemFlavorBag a, ItemFlavorBag b ) {
			if ( GRXCurrency_GetCurrencyIndex( a.flavors[0] ) > GRXCurrency_GetCurrencyIndex( b.flavors[0] ) )
				return 1

			if ( GRXCurrency_GetCurrencyIndex( a.flavors[0] ) < GRXCurrency_GetCurrencyIndex( b.flavors[0] ) )
				return -1

			return 0
		} )
		// same thing
		foreach ( ItemFlavorBag price in priceList )
		{
			Assert( purchaseButtonIdx < file.purchaseButtonBottomToTopList.len(), format( "Item %s had more than %d prices, failed to show purchase dialog", devDesc, file.purchaseButtonBottomToTopList.len() ) )
			if ( purchaseButtonIdx >= file.purchaseButtonBottomToTopList.len() )
				break

			var button = file.purchaseButtonBottomToTopList[purchaseButtonIdx]

			file.state.purchaseButtonOfferMap[button] <- offer
			file.state.purchaseButtonPriceMap[button] <- price

			Hud_Show( button )
			HudElem_SetRuiArg( button, "buttonText", offer.isCraftingOffer ? "#CONFIRM_CRAFT_WITH" : "#CONFIRM_PURCHASE_WITH" )
			HudElem_SetRuiArg( button, "priceText", GRX_GetFormattedPrice( price, file.state.cfg.quantity ) )
			HudElem_SetRuiArg( button, "isProcessing", false )

			bool isLoadingPrice = false
			if ( GRX_IsInventoryReady() )
			{
				bool isPremiumOnly = GRX_IsPremiumPrice( price )
				bool canAfford     = GRX_CanAfford( price, file.state.cfg.quantity )

				isLoadingPrice = false
				Hud_SetEnabled( button, true )
				Hud_SetLocked( button, offer.isAvailable && !canAfford && !isPremiumOnly )

				Hud_ClearToolTipData( button )
				if ( !offer.isAvailable )
				{
					HudElem_SetRuiArg( button, "buttonText", "#UNAVAILABLE" )//
				}
				else if ( isPremiumOnly && !canAfford )
				{
					HudElem_SetRuiArg( button, "buttonText", "#CONFIRM_GET_PREMIUM" )
				}
				else if ( !canAfford )
				{
					ToolTipData toolTipData
					toolTipData.titleText = "#CANNOT_AFFORD"
					toolTipData.tooltipFlags = toolTipData.tooltipFlags | eToolTipFlag.SOLID

					string currencyName
					array<int> priceArray = GRX_GetCurrencyArrayFromBag( price )
					foreach ( currencyIndex, priceInt in priceArray )
					{
						if ( priceInt == 0 )
							continue

						ItemFlavor currency = GRX_CURRENCIES[currencyIndex]
						currencyName = ItemFlavor_GetShortName( currency )
						break
					}

					toolTipData.descText = Localize( "#CANNOT_AFFORD_DESC", GRX_CanAffordDelta( price, file.state.cfg.quantity ), Localize( currencyName ) )
					Hud_SetToolTipData( button, toolTipData )
				}
			}
			else
			{
				isLoadingPrice = true
				Hud_SetEnabled( button, false )
			}
			HudElem_SetRuiArg( button, "isLoadingPrice", isLoadingPrice )

			purchaseButtonIdx++
		}
	}
	int usedPurchaseButtonCount = purchaseButtonIdx

	for ( int unusedPurchaseButtonIdx = purchaseButtonIdx; unusedPurchaseButtonIdx < file.purchaseButtonBottomToTopList.len(); unusedPurchaseButtonIdx++ )
		Hud_Hide( file.purchaseButtonBottomToTopList[unusedPurchaseButtonIdx] )

	int buttonHeight  = Hud_GetHeight( file.purchaseButtonBottomToTopList[0] )
	int buttonPadding = Hud_GetY( file.purchaseButtonBottomToTopList[0] )
	Hud_SetHeight( file.dialogFrame, Hud_GetBaseHeight( file.dialogFrame ) + usedPurchaseButtonCount * (buttonHeight + buttonPadding) )
}


void function ConfirmPurchaseDialog_OnClose()
{
	RemoveCallback_OnGRXInventoryStateChanged( UpdatePurchaseDialog )

	file.status = ePurchaseDialogStatus.INACTIVE
	PurchaseDialogState state
	file.state = state

	UpdateProcessingElements()

	Signal( uiGlobal.signalDummy, "ConfirmPurchaseClosed" )
}


void function ConfirmPurchaseDialog_OnNavigateBack()
{
	if ( file.status == ePurchaseDialogStatus.INACTIVE || file.status == ePurchaseDialogStatus.WORKING )
		return

	CloseActiveMenu()
}


