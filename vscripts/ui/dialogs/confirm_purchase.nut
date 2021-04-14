global function InitConfirmPurchaseDialog

global function PurchaseDialog

global enum ePurchaseDialogStatus
{
	INACTIVE = 0,
	AWAITING_USER_CONFIRMATION = 1,
	WORKING = 2,
	FINISHED_SUCCESS = 3,
	FINISHED_FAILURE = 4,
}

const int MAX_PURCHASE_BUTTONS = 5

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

	int                                    purchaseStatus = ePurchaseDialogStatus.INACTIVE
	ItemFlavor ornull                      purchaseItemFlavOrNull
	int                                    purchaseQuantity
	bool                                   purchaseMarkAsNew
	array<GRXScriptOffer>                  purchaseOfferList
	table<var, ItemFlavorBag>              purchaseButtonPriceMap
	void functionref()                     onPurchaseStartCallback
	void functionref( bool wasSuccessful ) onPurchaseResultCallback
} file

void function InitConfirmPurchaseDialog()
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


void function PurchaseDialog( ItemFlavor flav, int quantity, bool markAsNew,
		void functionref() onPurchaseStartCallback,
		void functionref( bool wasSuccessful ) onPurchaseResultCallback )
{
	Assert( GRX_IsInventoryReady() )
	Assert( file.purchaseStatus == ePurchaseDialogStatus.INACTIVE )
	Assert( ItemFlavor_GetGRXMode( flav ) != GRX_ITEMFLAVORMODE_NONE )

	if ( ItemFlavor_GetGRXMode( flav ) == GRX_ITEMFLAVORMODE_REGULAR && GRX_IsItemOwnedByPlayer( flav ) )
	{
		Assert( false, "Called PurchaseDialog with an already-owned item: " + ItemFlavor_GetHumanReadableRef( flav ) )
		EmitUISound( "menu_deny" )
		return
	}

	Assert( file.purchaseItemFlavOrNull == null )
	Assert( file.purchaseQuantity == 0 )
	Assert( file.purchaseOfferList.len() == 0 )
	Assert( file.purchaseButtonPriceMap.len() == 0 )
	Assert( file.onPurchaseResultCallback == null )

	file.purchaseStatus = ePurchaseDialogStatus.AWAITING_USER_CONFIRMATION
	file.purchaseItemFlavOrNull = flav
	file.purchaseQuantity = quantity
	file.purchaseMarkAsNew = markAsNew
	file.onPurchaseStartCallback = onPurchaseStartCallback
	file.onPurchaseResultCallback = onPurchaseResultCallback

	ItemFlavorPurchasabilityInfo ifpi = GRX_GetItemPurchasabilityInfo( flav )
	Assert( ifpi.isPurchasableAtAll )

	if ( ifpi.craftingOfferOrNull != null )
		file.purchaseOfferList.append( expect GRXScriptOffer(ifpi.craftingOfferOrNull) )

	foreach ( string location, array<GRXScriptOffer> locationOfferList in ifpi.locationToDedicatedStoreOffersMap )
		foreach ( GRXScriptOffer locationOffer in locationOfferList )
			file.purchaseOfferList.append( locationOffer )

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
	TabDef tabDef = Tab_GetTabDefByBodyName( tabData, "StorePanel" )
	TabData storeTabData = GetTabDataForPanel( tabDef.panel )
	ActivateTab( storeTabData, Tab_GetTabIndexByBodyName( storeTabData, "VCPanel" ) )
}


void function PurchaseButton_Activate( var button )
{
	Assert( file.purchaseStatus == ePurchaseDialogStatus.AWAITING_USER_CONFIRMATION )

	if ( Hud_IsLocked( button ) )
		return

	ItemFlavorBag price = file.purchaseButtonPriceMap[button]

	bool isPremiumOnly = GRX_IsPremiumPrice( price )
	bool canAfford = GRX_CanAfford( price, file.purchaseQuantity )
	if ( isPremiumOnly && !canAfford )
	{
		GotoPremiumStoreTab()
		return
	}

	Assert( canAfford )

	file.purchaseStatus = ePurchaseDialogStatus.WORKING

	ScriptGRXOperationInfo operation
	if ( GRX_IsCraftingPrice( price ) )
	{
		operation.expectedQueryGoal = GRX_HTTPQUERYGOAL_CRAFT_ITEM
		operation.doOperationFunc = (void function( int opID )
		{
			GRX_CraftItem( opID, ItemFlavor_GetGRXIndex( expect ItemFlavor(file.purchaseItemFlavOrNull) ) )
		})
	}
	else
	{
		int itemType  = ItemFlavor_GetType( expect ItemFlavor(file.purchaseItemFlavOrNull) )
		int queryGoal = GRX_HTTPQUERYGOAL_PURCHASE_ITEM
		if ( itemType == eItemType.character )
			queryGoal = GRX_HTTPQUERYGOAL_PURCHASE_CHARACTER
		else if ( itemType == eItemType.account_pack )
			queryGoal = GRX_HTTPQUERYGOAL_PURCHASE_PACK

		operation.expectedQueryGoal = queryGoal
		operation.doOperationFunc = (void function( int opID ) : ( queryGoal, price )
		{
			GRX_PurchaseItem( opID, queryGoal, file.purchaseQuantity, ItemFlavor_GetGRXIndex( expect ItemFlavor(file.purchaseItemFlavOrNull) ), GRX_GetCurrencyArrayFromBag( price ) )
		})
	}
	operation.onDoneCallback = (void function( int status ) : ( price )
	{
		OnPurchaseOperationFinished( status, price )
	})

	if ( file.onPurchaseStartCallback != null )
	{
		file.onPurchaseStartCallback()
		file.onPurchaseStartCallback = null
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
	bool isWorking = (file.purchaseStatus == ePurchaseDialogStatus.WORKING)

	//Hud_Hide( file.buttonsPanel )
	//Hud_Show( file.processingButton )
	Hud_SetEnabled( file.cancelButton, !isWorking )
	HudElem_SetRuiArg( file.cancelButton, "isProcessing", isWorking )
	HudElem_SetRuiArg( file.cancelButton, "processingState", file.purchaseStatus )

	foreach ( button in file.purchaseButtonBottomToTopList )
	{
		Hud_SetEnabled( button, !isWorking )
		HudElem_SetRuiArg( button, "isProcessing", false )
	}
}


void function OnPurchaseOperationFinished( int status, ItemFlavorBag price )
{
	Assert( file.purchaseStatus == ePurchaseDialogStatus.WORKING )

	bool wasSuccessful = (status == eScriptGRXOperationStatus.DONE_SUCCESS)

	file.purchaseStatus = (wasSuccessful ? ePurchaseDialogStatus.FINISHED_SUCCESS : ePurchaseDialogStatus.FINISHED_FAILURE)
	bool wasPremium = false
	bool wasCredits = false
	bool wasCraft = false
	foreach ( int costIndex, ItemFlavor costFlav in price.flavors )
	{
		if ( costFlav ==  GRX_CURRENCIES[GRX_CURRENCY_PREMIUM] )
			wasPremium = true
		else if ( costFlav == GRX_CURRENCIES[GRX_CURRENCY_CREDITS] )
			wasCredits = true
		else if ( costFlav == GRX_CURRENCIES[GRX_CURRENCY_CRAFTING] )
			wasCraft = true
	}
	if ( wasSuccessful )
	{
		if ( wasPremium )
			EmitUISound( "UI_Menu_Purchase_Coins" )
		else if ( wasCredits )
			EmitUISound( "UI_Menu_Purchase_Tokens" )
		else if ( wasCraft  )
			EmitUISound( "UI_Menu_Purchase_Crafting" )

		ClientCommand( "lastSeenPremiumCurrency" )
	}
	else
	{
		EmitUISound( "menu_deny" )
	}

	if ( file.purchaseMarkAsNew )
		Newness_TEMP_MarkItemAsNewAndInformServer( expect ItemFlavor(file.purchaseItemFlavOrNull) )

	if ( file.onPurchaseResultCallback != null )
	{
		file.onPurchaseResultCallback( wasSuccessful )
		file.onPurchaseResultCallback = null
	}

	thread ReportStatusAndClose( file.purchaseStatus )
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
	Assert( file.purchaseStatus == ePurchaseDialogStatus.AWAITING_USER_CONFIRMATION )

	AddCallbackAndCallNow_OnGRXInventoryStateChanged( UpdatePurchaseDialog )
}


void function UpdatePurchaseDialog()
{
	if ( file.purchaseStatus != ePurchaseDialogStatus.AWAITING_USER_CONFIRMATION )
		return

	Assert( file.purchaseItemFlavOrNull != null )

	ItemFlavor purchaseItem = expect ItemFlavor(file.purchaseItemFlavOrNull)
	string purchaseItemName = Localize( ItemFlavor_GetLongName( purchaseItem ) )
	int quality             = ItemFlavor_GetQuality( purchaseItem )

	string messageText
	switch ( ItemFlavor_GetType( purchaseItem ) )
	{
		case eItemType.gladiator_card_intro_quip:
		case eItemType.gladiator_card_kill_quip:
			messageText = Localize( "#QUOTE_STRING", purchaseItemName )
			break

		case eItemType.character:
			messageText = purchaseItemName
			break

		default:
			if ( file.purchaseQuantity > 1 )
			{
				messageText = Localize( "#STORE_ITEM_X_N", purchaseItemName, file.purchaseQuantity ) + "\n`1" + Localize( ItemFlavor_GetQualityName( purchaseItem ) )
			}
			else
			{
				messageText = purchaseItemName + "\n`1" + Localize( ItemFlavor_GetQualityName( purchaseItem ) )
			}
			break
	}

	UpdateProcessingElements()

	int purchaseButtonIdx = 0
	file.purchaseButtonPriceMap.clear()

	array<GRXScriptOffer> offerList = clone file.purchaseOfferList
	offerList.reverse() // reverse because the purchase buttons are set up from bottom to top
	foreach ( GRXScriptOffer offer in offerList )
	{
		array<ItemFlavorBag> priceList = clone offer.prices
		priceList.reverse() // same thing
		foreach ( ItemFlavorBag price in priceList )
		{
			Assert( purchaseButtonIdx < file.purchaseButtonBottomToTopList.len(), format( "Item %s had more than %d prices, failed to show purchase dialog", ItemFlavor_GetHumanReadableRef( purchaseItem ), file.purchaseButtonBottomToTopList.len() ) )
			if ( purchaseButtonIdx >= file.purchaseButtonBottomToTopList.len() )
				break

			var button = file.purchaseButtonBottomToTopList[purchaseButtonIdx]

			file.purchaseButtonPriceMap[button] <- price

			Hud_Show( button )
			HudElem_SetRuiArg( button, "buttonText", offer.isCraftingOffer ? "#CONFIRM_CRAFT_WITH" : "#CONFIRM_PURCHASE_WITH" )
			HudElem_SetRuiArg( button, "priceText", GRX_GetFormattedPrice( price, file.purchaseQuantity ) )
			HudElem_SetRuiArg( button, "isProcessing", false )

			bool isLoadingPrice = false
			if ( GRX_IsInventoryReady() )
			{
				bool isPremiumOnly = GRX_IsPremiumPrice( price )
				bool canAfford = GRX_CanAfford( price, file.purchaseQuantity )

				isLoadingPrice = false
				Hud_SetEnabled( button, true )
				Hud_SetLocked( button, !canAfford && !isPremiumOnly )

				Hud_ClearToolTipData( button )
				if ( isPremiumOnly && !canAfford )
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

					toolTipData.descText = Localize( "#CANNOT_AFFORD_DESC", GRX_CanAffordDelta( price, file.purchaseQuantity ), Localize( currencyName ) )
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

	printt( purchaseItemName + " quality " + quality )

	HudElem_SetRuiArg( file.dialogContent, "quality", quality )
	HudElem_SetRuiArg( file.dialogContent, "quantity", file.purchaseQuantity )
	HudElem_SetRuiArg( file.dialogContent, "headerText", "#CONFIRM_PURCHASE_HEADER" )
	HudElem_SetRuiArg( file.dialogContent, "messageText", messageText )

	for ( int unusedPurchaseButtonIdx = purchaseButtonIdx; unusedPurchaseButtonIdx < file.purchaseButtonBottomToTopList.len(); unusedPurchaseButtonIdx++ )
		Hud_Hide( file.purchaseButtonBottomToTopList[unusedPurchaseButtonIdx] )

	int buttonHeight  = Hud_GetHeight( file.purchaseButtonBottomToTopList[0] )
	int buttonPadding = Hud_GetY( file.purchaseButtonBottomToTopList[0] )
	Hud_SetHeight( file.dialogFrame, Hud_GetBaseHeight( file.dialogFrame ) + usedPurchaseButtonCount * (buttonHeight + buttonPadding) )
}


void function ConfirmPurchaseDialog_OnClose()
{
	RemoveCallback_OnGRXInventoryStateChanged( UpdatePurchaseDialog )

	file.purchaseStatus = ePurchaseDialogStatus.INACTIVE
	file.purchaseItemFlavOrNull = null
	file.purchaseQuantity = 0
	file.purchaseOfferList.clear()
	file.purchaseButtonPriceMap.clear()
	file.onPurchaseStartCallback = null
	file.onPurchaseResultCallback = null
	UpdateProcessingElements()

	Signal( uiGlobal.signalDummy, "ConfirmPurchaseClosed" )
}


void function ConfirmPurchaseDialog_OnNavigateBack()
{
	if ( file.purchaseStatus == ePurchaseDialogStatus.INACTIVE || file.purchaseStatus == ePurchaseDialogStatus.WORKING )
		return

	CloseActiveMenu()
}


