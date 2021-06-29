global function ThemedShopPanel_Init

struct {
	var        panel
	array<var> offerButtons
	var        itemGroup1Rui
	var        itemGroup2Rui

	ItemFlavor ornull          activeThemedShopEvent
	table<var, GRXScriptOffer> offerButtonToOfferMap
	var                        WORKAROUND_currentlyFocusedOfferButtonForFooters
} file

int NUM_OFFER_BUTTONS = 7

void function ThemedShopPanel_Init( var panel )
{
	file.panel = panel

	AddPanelEventHandler( panel, eUIEvent.PANEL_SHOW, ThemedShopPanel_OnShow )
	AddPanelEventHandler( panel, eUIEvent.PANEL_HIDE, ThemedShopPanel_OnHide )

	file.itemGroup1Rui = Hud_GetRui( Hud_GetChild( panel, "ItemGroup1" ) )
	file.itemGroup2Rui = Hud_GetRui( Hud_GetChild( panel, "ItemGroup2" ) )

	for ( int offerButtonIdx = 0; offerButtonIdx < NUM_OFFER_BUTTONS; offerButtonIdx++ )
	{
		var button = Hud_GetChild( file.panel, format( "OfferButton%d", offerButtonIdx + 1 ) )
		Hud_Show( button )
		Hud_AddEventHandler( button, UIE_GET_FOCUS, OfferButton_OnGetFocus )
		Hud_AddEventHandler( button, UIE_LOSE_FOCUS, OfferButton_OnLoseFocus )
		Hud_AddEventHandler( button, UIE_CLICK, OfferButton_OnActivate )
		Hud_AddEventHandler( button, UIE_CLICKRIGHT, OfferButton_OnAltActivate )
		file.offerButtons.append( button )
	}

	AddPanelFooterOption( panel, LEFT, BUTTON_B, true, "#B_BUTTON_BACK", "#B_BUTTON_BACK" )
	AddPanelFooterOption( panel, LEFT, BUTTON_A, false, "#A_BUTTON_INSPECT", "#A_BUTTON_INSPECT", null, IsFocusedItemInspectable )
	AddPanelFooterOption( panel, LEFT, BUTTON_X, false, "#X_BUTTON_EQUIP", "#X_BUTTON_EQUIP", null, IsFocusedItemEquippable )
}


void function ThemedShopPanel_OnShow( var panel )
{
	UI_SetPresentationType( ePresentationType.WEAPON_CATEGORY )

	AddCallbackAndCallNow_OnGRXInventoryStateChanged( ThemedShopPanel_UpdateGRXDependantElements )
	AddCallbackAndCallNow_OnGRXOffersRefreshed( ThemedShopPanel_UpdateGRXDependantElements )
}


void function ThemedShopPanel_OnHide( var panel )
{
	file.activeThemedShopEvent = null

	RunClientScript( "UIToClient_StopBattlePassScene" )

	RemoveCallback_OnGRXInventoryStateChanged( ThemedShopPanel_UpdateGRXDependantElements )
	RemoveCallback_OnGRXOffersRefreshed( ThemedShopPanel_UpdateGRXDependantElements )
}


void function ThemedShopPanel_UpdateGRXDependantElements()
{
	bool isInventoryReady                   = GRX_IsInventoryReady()
	ItemFlavor ornull activeThemedShopEvent = GetActiveThemedShopEvent( GetUnixTimestamp() )
	bool haveActiveThemedShopEvent          = (activeThemedShopEvent != null)
	bool menuIsUsable                       = isInventoryReady && haveActiveThemedShopEvent

	file.activeThemedShopEvent = activeThemedShopEvent
	file.offerButtonToOfferMap.clear()

	if ( menuIsUsable )
	{
		expect ItemFlavor( activeThemedShopEvent )

		RuiSetImage( file.itemGroup1Rui, "headerImage", ThemedShopEvent_GetItemGroupHeaderImage( activeThemedShopEvent, 1 ) )
		RuiSetString( file.itemGroup1Rui, "headerText", Localize( ThemedShopEvent_GetItemGroupHeaderText( activeThemedShopEvent, 1 ) ) )
		RuiSetColorAlpha( file.itemGroup1Rui, "headerTextColor", SrgbToLinear( ThemedShopEvent_GetItemGroupHeaderTextColor( activeThemedShopEvent, 1 ) ), 1.0 )
		RuiSetString( file.itemGroup1Rui, "bgImage", ThemedShopEvent_GetItemGroupBackgroundImage( activeThemedShopEvent, 1 ) )

		RuiSetImage( file.itemGroup2Rui, "headerImage", ThemedShopEvent_GetItemGroupHeaderImage( activeThemedShopEvent, 2 ) )
		RuiSetString( file.itemGroup2Rui, "headerText", Localize( ThemedShopEvent_GetItemGroupHeaderText( activeThemedShopEvent, 2 ) ) )
		RuiSetColorAlpha( file.itemGroup2Rui, "headerTextColor", SrgbToLinear( ThemedShopEvent_GetItemGroupHeaderTextColor( activeThemedShopEvent, 2 ) ), 1.0 )
		RuiSetString( file.itemGroup2Rui, "bgImage", ThemedShopEvent_GetItemGroupBackgroundImage( activeThemedShopEvent, 2 ) )

		string offerGRXLocation      = ThemedShopEvent_GetGRXOfferLocation( activeThemedShopEvent )
		array<GRXScriptOffer> offers = GRX_GetLocationOffers( offerGRXLocation )

		//
		//
		//
		//
		//
		//
		//
		//
		//
		//
		//
		//

		offers.sort( int function( GRXScriptOffer a, GRXScriptOffer b ) {
			int aSlot = ("slot" in a.attributes ? int(a.attributes["slot"]) : 99999)
			int bSlot = ("slot" in b.attributes ? int(b.attributes["slot"]) : 99999)
			if ( aSlot != bSlot )
				return aSlot - bSlot

			return ItemFlavor_GetGUID( ItemFlavorBag_GetSingleOutputItemFlavor_Assert( a.output ) ) - ItemFlavor_GetGUID( ItemFlavorBag_GetSingleOutputItemFlavor_Assert( b.output ) )
		} )

		if ( offers.len() != file.offerButtons.len() )
		{
			string details = ""
			foreach ( GRXScriptOffer offer in offers )
				details += format( "\n - %s", ItemFlavor_GetHumanReadableRef( ItemFlavorBag_GetSingleOutputItemFlavor_Assert( offer.output ) ) )
			Warning( "Themed shop expected %d offers with location '%s' but received %d: %s", file.offerButtons.len(), offerGRXLocation, offers.len(), details )
		}

		foreach ( int offerButtonIdx, var offerButton in file.offerButtons )
		{
			if ( offerButtonIdx >= offers.len() )
			{
				Hud_Hide( offerButton )
				continue
			}

			Hud_Show( offerButton )
			GRXScriptOffer offer = offers[offerButtonIdx]
			file.offerButtonToOfferMap[offerButton] <- offer
			ItemFlavor singleOutputFlav = ItemFlavorBag_GetSingleOutputItemFlavor_Assert( offer.output )
			int remainingTime           = offer.expireTime - GetUnixTimestamp()

			bool shouldHighlight = (offerButtonIdx < 4)

			Assert( offer.prices.len() == 1 )

			var rui = Hud_GetRui( offerButton )
			RuiSetImage( rui, "gradientBGImage", ThemedShopEvent_GetItemButtonBGImage( activeThemedShopEvent, shouldHighlight ) )
			RuiSetImage( rui, "frameImage", ThemedShopEvent_GetItemButtonFrameImage( activeThemedShopEvent, shouldHighlight ) )
			//
			//
			//

			//
			string itemName
			if ( singleOutputFlav == GetItemFlavorByAsset( $"settings/itemflav/musicpack/wraith.rpak" ) )
				itemName = "#WRAITH_MUSIC_PACK"
			//
			//
			else if ( singleOutputFlav == GetItemFlavorByAsset( $"settings/itemflav/gcard_frame/gibraltar/season02_event02_legendary_01.rpak" ) )
				itemName = "#GIBRALTAR_BANNER_FRAME"
			else
				itemName = ItemFlavor_GetLongName( singleOutputFlav )

			//
			//
			RuiSetString( rui, "itemName", itemName )
			//
			RuiSetInt( rui, "itemRarity", ItemFlavor_GetQuality( singleOutputFlav ) )
			RuiSetImage( rui, "itemImg", offer.image )

			PriceDisplayData priceData = GRX_GetPriceDisplayData( offer.prices[0] )
			RuiSetImage( rui, "priceSymbol", priceData.symbol )
			RuiSetString( rui, "priceAmount", priceData.amount )
			RuiSetGameTime( rui, "expireTime", remainingTime > 0 ? (Time() + remainingTime) : RUI_BADGAMETIME )
			//

			bool isOwned = false
			if ( ItemFlavor_GetGRXMode( singleOutputFlav ) == eItemFlavorGRXMode.REGULAR )
				isOwned = GRX_IsItemOwnedByPlayer_AllowOutOfDateData( singleOutputFlav )
			else if ( singleOutputFlav == TEMP_GetVoidwalkerBundle() )
				isOwned = GRX_IsItemOwnedByPlayer_AllowOutOfDateData( GetItemFlavorByAsset( $"settings/itemflav/character_skin/wraith/season02_event02_legendary_01.rpak" ) )
			RuiSetBool( rui, "isOwned", isOwned )

			RuiSetImage( rui, "sourceIcon", ItemFlavor_HasSourceTag( singleOutputFlav ) ? ItemFlavor_GetSourceIcon( singleOutputFlav ) : $"" )
			RuiSetImage( rui, "plusUpIcon", singleOutputFlav == GetItemFlavorByAsset( $"settings/itemflav/character_skin/wraith/season02_event02_legendary_01.rpak" ) ? $"rui/events/themed_shop_events/bonus_features_icon" : $"" )
		}
	}
	else
	{
		foreach ( var offerButton in file.offerButtons )
			Hud_SetEnabled( offerButton, false )
	}

	var focus = GetFocus()
	if ( !file.offerButtons.contains( GetFocus() ) )
		focus = null
	UpdateFocusStuff( focus )
}


void function OfferButton_OnGetFocus( var btn )
{
	UpdateFocusStuff( btn )
}


void function OfferButton_OnLoseFocus( var btn )
{
	UpdateFocusStuff( null )
}


void function OfferButton_OnActivate( var btn )
{
	if ( !Hud_IsEnabled( btn ) )
		return

	GRXScriptOffer offer = file.offerButtonToOfferMap[btn]
	ItemFlavor offerFlav = ItemFlavorBag_GetSingleOutputItemFlavor_Assert( offer.output )
	if ( !IsItemFlavorInspectable( offerFlav ) )
	{
		PurchaseDialogConfig pdc
		pdc.flav = offerFlav
		pdc.quantity = 1
		PurchaseDialog( pdc )
		return
	}
	SetStoreItemPresentationModeActive( offer )
}


void function OfferButton_OnAltActivate( var btn )
{
	if ( !Hud_IsEnabled( btn ) )
		return

	GRXScriptOffer offer = file.offerButtonToOfferMap[btn]
	ItemFlavor offerFlav = ItemFlavorBag_GetSingleOutputItemFlavor_Assert( offer.output )
	if ( !IsItemFlavorEquippable( offerFlav ) )
		return

	EmitUISound( "UI_Menu_Equip_Generic" )
	EquipItemFlavorInAppropriateLoadoutSlot( offerFlav )
}


bool function IsFocusedItemInspectable()
{
	var focus = file.WORKAROUND_currentlyFocusedOfferButtonForFooters //
	if ( focus in file.offerButtonToOfferMap )
	{
		GRXScriptOffer offer = file.offerButtonToOfferMap[focus]
		ItemFlavor offerFlav = ItemFlavorBag_GetSingleOutputItemFlavor_Assert( offer.output )
		return IsItemFlavorInspectable( offerFlav )
	}

	return false
}


bool function IsFocusedItemEquippable()
{
	var focus = file.WORKAROUND_currentlyFocusedOfferButtonForFooters //
	if ( focus in file.offerButtonToOfferMap )
	{
		GRXScriptOffer offer = file.offerButtonToOfferMap[focus]
		ItemFlavor offerFlav = ItemFlavorBag_GetSingleOutputItemFlavor_Assert( offer.output )
		return IsItemFlavorEquippable( offerFlav )
	}

	return false
}


void function UpdateFocusStuff( var focusedOfferButtonOrNull )
{
	file.WORKAROUND_currentlyFocusedOfferButtonForFooters = focusedOfferButtonOrNull

	UpdateFooterOptions() //
}


