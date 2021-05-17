global function InitStorePanel
global function InitDummyPanel
global function InitStoreVCPanel
global function InitStoreCharactersPanel
global function InitLootPanel
global function InitOffersPanel
global function JumpToStoreCharacter

enum eStoreSection
{
	SHOP,
	LOOT,
	CHARACTERS,
	CURRECNY
}

const int MAX_FEATURED_OFFERS = 2
const int MAX_EXCLUSIVE_OFFERS = 2

struct
{
	var  storePanel
	bool tabsInitialized = false
	bool storeCacheValid = false
	var  tabBar
	bool openDLCStoreCallbackCalled = false
} file

struct
{
	var                    panel
	var                    characterSelectInfoPanel
	var                    characterSelectInfoRui
	array<var>             buttons
	table<var, ItemFlavor> buttonToCharacter

	var allLegendsPanel

	var buttonWithFocus

	var characterDetailsPanel
	var characterDetailsRui

} s_characters


const int STORE_VC_NUM_PACKS = 5
struct VCPackDef
{
	int    entitlementId
	string priceString
	string originalPriceString
	int    price
	int    base
	int    bonus
	int    total
	asset  image = $""

	bool valid = false
}

struct
{
	bool packsInitialized = false

	array<int>   vcPackEntitlements = [PREMIUM_CURRENCY_10, PREMIUM_CURRENCY_20, PREMIUM_CURRENCY_40, PREMIUM_CURRENCY_60, PREMIUM_CURRENCY_100]
	array<int>   vcPackBase = [1000, 2000, 4000, 6000, 10000]
	array<int>   vcPackBonus = [0, 150, 350, 700, 1500]
	array<asset> vcPackImage = [$"rui/menu/store/store_coins_t1", $"rui/menu/store/store_coins_t2", $"rui/menu/store/store_coins_t3", $"rui/menu/store/store_coins_t4", $"rui/menu/store/store_coins_t5"]

	VCPackDef[STORE_VC_NUM_PACKS] vcPacks
} s_vc

struct
{
	var lootPanel

	var lootButtonOpen

	var lootButtonPurchase
	var lootButtonPurchaseN
} s_loot


struct SeasonalStoreData
{
	string seasonTag = ""
	asset tallImage = $""
	asset squareImage = $""
	asset topImage = $""
	asset tallFrameOverlayImage = $""
	asset squareFrameOverlayImage = $""
}


struct
{
	var offersPanel

	array<var> fullOfferButtons
	array<var> topOfferButtons
	array<var> bottomOfferButtons

	var featuredHeader
	var exclusiveHeader

	array<var> shopButtons

	// meh.
	table< var, GRXScriptOffer > buttonToOfferData

	table< string, SeasonalStoreData > seasonalDataMap
} s_offers

void function InitDummyPanel( var panel )
{

}


void function InitStorePanel( var panel )
{
	file.storePanel = panel

	RegisterSignal( "OffersPanel_Think" )

	SetPanelTabTitle( panel, "#STORE" )
	SetTabRightSound( panel, "UI_Menu_StoreTab_Select" )
	SetTabLeftSound( panel, "UI_Menu_StoreTab_Select" )

	AddPanelEventHandler( panel, eUIEvent.PANEL_SHOW, OnStorePanel_Show )
	AddPanelEventHandler( panel, eUIEvent.PANEL_HIDE, OnStorePanel_Hide )

	int buttonNum = 0

	// Offers
	{
		var tabBody = Hud_GetChild( panel, "ECPanel" )
		AddTab( panel, tabBody, "#MENU_STORE_PANEL_SHOP" )
	}

	// Loot
	{
		var tabBody = Hud_GetChild( panel, "LootPanel" )
		AddTab( panel, tabBody, "#MENU_STORE_PANEL_LOOT" )
	}

	// Characters
	{
		var tabBody = Hud_GetChild( panel, "CharacterPanel" )
		AddTab( panel, tabBody, "#MENU_STORE_PANEL_CHARACTERS" )
	}

	// Virtual Currency
	{
		var tabBody = Hud_GetChild( panel, "VCPanel" )
		AddTab( panel, tabBody, "#MENU_STORE_PANEL_CURRENCY" )
	}
}


void function OnStorePanel_Show( var panel )
{
	TabData tabData = GetTabDataForPanel( panel )

	if ( !file.tabsInitialized )
	{
		SetTabNavigationEndCallback( tabData, eTabDirection.PREV, TabNavigateToLobby )
		file.tabsInitialized = true
	}

	// Start disabled, only enable when store updates are complete
	DeactivateTab( tabData )
	SetTabNavigationEnabled( file.storePanel, false )
	tabData.tabIndex = 0
	foreach ( tabDef in GetPanelTabs( file.storePanel ) )
	{
		SetTabDefEnabled( tabDef, false )
	}

	UI_SetPresentationType( ePresentationType.WEAPON_CATEGORY )

	file.storeCacheValid = false

	AddCallbackAndCallNow_OnGRXInventoryStateChanged( OnGRXStoreUpdate )
	AddCallbackAndCallNow_OnGRXOffersRefreshed( OnGRXStoreUpdate )

	thread AnimateTabBar( tabData )
	InitDLCStore()
}


void function AnimateTabBar( TabData tabData )
{
	Hud_SetY( tabData.tabPanel, Hud_GetHeight( tabData.tabPanel ) )
	Hud_ReturnToBasePosOverTime( tabData.tabPanel, 0.25, INTERPOLATOR_DEACCEL )
}


void function TabNavigateToLobby()
{
	TabData lobbyTabData = GetTabDataForPanel( GetMenu( "LobbyMenu" ) )

	//TODO: assert we're the active tab
	ActivateTabPrev( lobbyTabData )
}


void function OnStorePanel_Hide( var panel )
{
	TabData tabData = GetTabDataForPanel( panel )
	DeactivateTab( tabData )

	RemoveCallback_OnGRXInventoryStateChanged( OnGRXStoreUpdate )
	RemoveCallback_OnGRXOffersRefreshed( OnGRXStoreUpdate )

	file.storeCacheValid = false
}

void function CallDLCStoreCallback_Safe()
{
	if ( !file.openDLCStoreCallbackCalled )
	{
		file.openDLCStoreCallbackCalled = true
		OnOpenDLCStore()
	}
}

void function OnGRXStoreUpdate()
{
	TabData tabData = GetTabDataForPanel( file.storePanel )

	if ( !GRX_IsInventoryReady() || !GRX_AreOffersReady() )
	{
		DeactivateTab( tabData )
		SetTabNavigationEnabled( file.storePanel, false )

		foreach ( tabDef in GetPanelTabs( file.storePanel ) )
		{
			SetTabDefEnabled( tabDef, false )
		}

		Hud_SetVisible( Hud_GetChild( file.storePanel, "BusyPanel" ), true )
		OnCloseDLCStore()
	}
	else
	{
		SetTabNavigationEnabled( file.storePanel, true )

		int vcTabIndex = -1
		foreach ( tabDef in GetPanelTabs( file.storePanel ) )
		{
			if ( Hud_GetHudName( tabDef.panel ) == "LootPanel" )
				SetTabDefEnabled( tabDef, GetLootTickPurchaseOffer() != null )
			else
				SetTabDefEnabled( tabDef, true )
		}

		int activeIndex = tabData.tabIndex
		if ( !file.storeCacheValid && uiGlobal.lastMenuNavDirection == MENU_NAV_FORWARD )
			activeIndex = 0

		bool wasPanelActive = IsTabActive( tabData )
		bool isActiveIndexVCPanel = activeIndex == Tab_GetTabIndexByBodyName( tabData, "VCPanel" )
		if ( !isActiveIndexVCPanel || !wasPanelActive )
			ActivateTab( tabData, activeIndex )
		file.storeCacheValid = true

		UpdateLootTickTabNewness()

		Hud_SetVisible( Hud_GetChild( file.storePanel, "BusyPanel" ), false )
		if ( isActiveIndexVCPanel )
			CallDLCStoreCallback_Safe()
	}
}


void function UpdateLootTickTabNewness()
{
	if ( !GRX_IsInventoryReady() )
		return

	int packCount = GRX_GetTotalPackCount()
}

/*
██╗   ██╗██╗██████╗ ████████╗██╗   ██╗ █████╗ ██╗          ██████╗██╗   ██╗██████╗ ███████╗███╗   ██╗ ██████╗██╗   ██╗
██║   ██║██║██╔══██╗╚══██╔══╝██║   ██║██╔══██╗██║         ██╔════╝██║   ██║██╔══██╗██╔════╝████╗  ██║██╔════╝╚██╗ ██╔╝
██║   ██║██║██████╔╝   ██║   ██║   ██║███████║██║         ██║     ██║   ██║██████╔╝█████╗  ██╔██╗ ██║██║      ╚████╔╝ 
╚██╗ ██╔╝██║██╔══██╗   ██║   ██║   ██║██╔══██║██║         ██║     ██║   ██║██╔══██╗██╔══╝  ██║╚██╗██║██║       ╚██╔╝  
 ╚████╔╝ ██║██║  ██║   ██║   ╚██████╔╝██║  ██║███████╗    ╚██████╗╚██████╔╝██║  ██║███████╗██║ ╚████║╚██████╗   ██║   
  ╚═══╝  ╚═╝╚═╝  ╚═╝   ╚═╝    ╚═════╝ ╚═╝  ╚═╝╚══════╝     ╚═════╝ ╚═════╝ ╚═╝  ╚═╝╚══════╝╚═╝  ╚═══╝ ╚═════╝   ╚═╝ 
*/

void function InitStoreVCPanel( var panel )
{
	for ( int index = 0; index < STORE_VC_NUM_PACKS; index++ )
	{
		var vcButton = Hud_GetChild( panel, "VCButton" + (index + 1) )
		var vcRui    = Hud_GetRui( vcButton )

		RuiSetString( vcRui, "vcOriginalPrice", GetVCPackOriginalPriceString( index ) )
		RuiSetString( vcRui, "vcPrice", GetVCPackPriceString( index ) )
		RuiSetString( vcRui, "vcDesc", GetVCPackDesc( index ) )
		RuiSetString( vcRui, "totalValueDesc", "" )
		RuiSetString( vcRui, "baseValueDesc", "" )
		RuiSetString( vcRui, "bonusDesc", "" )

		RuiSetImage( vcRui, "vcImage", GetVCPackImage( index ) )

		Hud_AddEventHandler( vcButton, UIE_CLICK, OnVCButtonActivate )
	}

	AddPanelEventHandler( panel, eUIEvent.PANEL_SHOW, VCPanel_OnShow )
	AddPanelEventHandler( panel, eUIEvent.PANEL_HIDE, VCPanel_OnHide )

	AddPanelFooterOption( panel, LEFT, BUTTON_B, true, "#B_BUTTON_BACK", "#B_BUTTON_BACK" )
}


void function VCPanel_OnShow( var panel )
{
	UI_SetPresentationType( ePresentationType.WEAPON_CATEGORY )

	CallDLCStoreCallback_Safe()

	thread VCPanel_Think( panel )
}


void function VCPanel_OnHide( var panel )
{
	OnCloseDLCStore()
	file.openDLCStoreCallbackCalled = false
}


void function VCPanel_Think( var panel )
{
	var menu = GetParentMenu( panel )
	while ( uiGlobal.activeMenu == menu && uiGlobal.activePanels.contains( panel ) )
	{
		if ( IsDLCStoreInitialized() )
			InitVCPacks( panel )
		else
			InitDLCStore()

		var discountPanel = Hud_GetChild( panel, "DiscountPanel" )
		Hud_SetVisible( discountPanel, Script_UserHasEAAccess() )
		#if PC_PROG
			HudElem_SetRuiArg( discountPanel, "discountImage", $"rui/menu/common/ea_access_pc", eRuiArgType.IMAGE )
		#else
			HudElem_SetRuiArg( discountPanel, "discountImage", $"rui/menu/common/ea_access", eRuiArgType.IMAGE )
		#endif

		WaitFrame()
	}
}


void function InitVCPacks( var panel )
{
	if ( s_vc.packsInitialized )
		return

	s_vc.packsInitialized = true

	array<int> vcPriceInts       = GetEntitlementPricesAsInt( s_vc.vcPackEntitlements )
	array<string> vcPriceStrings = GetEntitlementPricesAsStr( s_vc.vcPackEntitlements )
	array<string> vcOriginalPriceStrings = GetEntitlementOriginalPricesAsStr( s_vc.vcPackEntitlements )

	for ( int vcPackIndex = 0; vcPackIndex < STORE_VC_NUM_PACKS; vcPackIndex++ )
	{
		VCPackDef vcPack = s_vc.vcPacks[vcPackIndex]

		vcPack.entitlementId = s_vc.vcPackEntitlements[vcPackIndex]
		vcPack.price = vcPriceInts[vcPackIndex]
		vcPack.priceString = vcPriceStrings[vcPackIndex]
		vcPack.originalPriceString = vcOriginalPriceStrings[vcPackIndex]
		vcPack.image = s_vc.vcPackImage[vcPackIndex]
		vcPack.base = s_vc.vcPackBase[vcPackIndex]
		vcPack.bonus = s_vc.vcPackBonus[vcPackIndex]
		vcPack.total = vcPack.base + vcPack.bonus

		vcPack.valid = vcPack.priceString != ""

		var vcButton = Hud_GetChild( panel, "VCButton" + (vcPackIndex + 1) )
		var vcRui    = Hud_GetRui( vcButton )

		RuiSetString( vcRui, "vcOriginalPrice", GetVCPackOriginalPriceString( vcPackIndex ) )
		RuiSetString( vcRui, "vcPrice", GetVCPackPriceString( vcPackIndex ) )
		RuiSetString( vcRui, "vcDesc", GetVCPackDesc( vcPackIndex ) )
		RuiSetString( vcRui, "totalValueDesc", GetVCPackTotalString( vcPackIndex ) )
		RuiSetString( vcRui, "baseValueDesc", GetVCPackBonusBaseString( vcPackIndex ) )
		RuiSetString( vcRui, "bonusDesc", GetVCPackBonusAddString( vcPackIndex ) )

		RuiSetImage( vcRui, "vcImage", GetVCPackImage( vcPackIndex ) )

		//Hud_SetEnabled( vcButton, vcPack.valid )
		//Hud_SetLocked( vcButton, !vcPack.valid )
		Hud_SetEnabled( vcButton, true )
		Hud_SetLocked( vcButton, false )
	}
}


void function OnVCButtonActivate( var button )
{
	int vcPackIndex = int( Hud_GetScriptID( button ) )

	if ( Hud_IsLocked( button ) )
	{
		EmitUISound( "menu_deny" )
		return
	}

	#if PC_PROG
		if ( !Origin_IsOverlayAvailable() )
		{
			ConfirmDialogData dialogData
			dialogData.headerText = ""
			dialogData.messageText = "#ORIGIN_INGAME_REQUIRED"
			dialogData.contextImage = $"ui/menu/common/dialog_notice"

			OpenOKDialogFromData( dialogData )
			return
		}

		if ( !MeetsAgeRequirements() )
		{
			ConfirmDialogData dialogData
			dialogData.headerText = "#UNAVAILABLE"
			dialogData.messageText = "#ORIGIN_UNDERAGE_STORE"
			dialogData.contextImage = $"ui/menu/common/dialog_notice"

			OpenOKDialogFromData( dialogData )
			return
		}
	#endif

	PurchaseEntitlement( s_vc.vcPacks[vcPackIndex].entitlementId )
}


string function GetVCPackDesc( int vcPackIndex )
{
	if ( !s_vc.vcPacks[vcPackIndex].bonus )
		return Localize( "#STORE_VC_DESC", ShortenNumber( string( s_vc.vcPacks[vcPackIndex].base ) ) )

	return Localize( "#STORE_VC_DESC_BONUS", ShortenNumber( string( s_vc.vcPacks[vcPackIndex].base ) ), ShortenNumber( string( s_vc.vcPacks[vcPackIndex].bonus ) ) )
}


string function GetVCPackPriceString( int vcPackIndex )
{
	if ( s_vc.vcPacks[vcPackIndex].priceString == "" )
		return Localize( "#UNAVAILABLE" )

	return s_vc.vcPacks[vcPackIndex].priceString
}


string function GetVCPackOriginalPriceString( int vcPackIndex )
{
	return s_vc.vcPacks[vcPackIndex].originalPriceString
}


string function GetVCPackTotalString( int vcPackIndex )
{
	return GetFormattedValueForCurrency( s_vc.vcPacks[vcPackIndex].base + s_vc.vcPacks[vcPackIndex].bonus, GRX_CURRENCY_PREMIUM )
}


string function GetVCPackBonusBaseString( int vcPackIndex )
{
	//if ( !s_vc.vcPacks[vcPackIndex].bonus )
	//	return ""

	return Localize( "#STORE_VC_BONUS_BASE", ShortenNumber( string( s_vc.vcPacks[vcPackIndex].base ) ) )
}


string function GetVCPackBonusAddString( int vcPackIndex )
{
	if ( !s_vc.vcPacks[vcPackIndex].bonus )
		return ""

	return Localize( "#STORE_VC_BONUS_ADD", ShortenNumber( string( s_vc.vcPacks[vcPackIndex].bonus ) ) )
}


int function GetVCPackBase( int vcPackIndex )
{
	return s_vc.vcPacks[vcPackIndex].base
}


int function GetVCPackTotal( int vcPackIndex )
{
	return s_vc.vcPacks[vcPackIndex].base + s_vc.vcPacks[vcPackIndex].bonus
}


int function GetVCPackBonus( int vcPackIndex )
{
	return s_vc.vcPacks[vcPackIndex].bonus
}


int function GetVCPackPrice( int vcPackIndex )
{
	return s_vc.vcPacks[vcPackIndex].price
}


asset function GetVCPackImage( int vcPackIndex )
{
	return s_vc.vcPacks[vcPackIndex].image
}

/*
 ██████╗██╗  ██╗ █████╗ ██████╗  █████╗  ██████╗████████╗███████╗██████╗ 
██╔════╝██║  ██║██╔══██╗██╔══██╗██╔══██╗██╔════╝╚══██╔══╝██╔════╝██╔══██╗
██║     ███████║███████║██████╔╝███████║██║        ██║   █████╗  ██████╔╝
██║     ██╔══██║██╔══██║██╔══██╗██╔══██║██║        ██║   ██╔══╝  ██╔══██╗
╚██████╗██║  ██║██║  ██║██║  ██║██║  ██║╚██████╗   ██║   ███████╗██║  ██║
 ╚═════╝╚═╝  ╚═╝╚═╝  ╚═╝╚═╝  ╚═╝╚═╝  ╚═╝ ╚═════╝   ╚═╝   ╚══════╝╚═╝  ╚═╝
*/

void function InitStoreCharactersPanel( var panel )
{
	s_characters.panel = panel
	s_characters.characterSelectInfoPanel = Hud_GetChild( panel, "CharacterSelectInfo" )
	s_characters.characterSelectInfoRui = Hud_GetRui( Hud_GetChild( panel, "CharacterSelectInfo" ) )
	s_characters.buttons = GetPanelElementsByClassname( panel, "CharacterButtonClass" )
	s_characters.allLegendsPanel = Hud_GetChild( panel, "AllLegendsPanel" )

	AddPanelEventHandler( panel, eUIEvent.PANEL_SHOW, CharactersPanel_OnShow )
	AddPanelEventHandler( panel, eUIEvent.PANEL_HIDE, CharactersPanel_OnHide )

	foreach ( button in s_characters.buttons )
	{
		Hud_AddEventHandler( button, UIE_CLICK, CharacterButton_OnActivate )
		Hud_AddEventHandler( button, UIE_CLICKRIGHT, CharacterButton_OnRightClick )
		Hud_AddEventHandler( button, UIE_GET_FOCUS, CharacterButton_OnGetFocus )
	}

	AddPanelEventHandler_FocusChanged( panel, CharactersPanel_OnFocusChanged )
	AddPanelFooterOption( panel, LEFT, BUTTON_B, true, "#B_BUTTON_BACK", "#B_BUTTON_BACK" )
	AddPanelFooterOption( panel, LEFT, BUTTON_X, false, "#X_BUTTON_TOGGLE_LOADOUT", "#X_BUTTON_TOGGLE_LOADOUT", OpenFocusedCharacterSkillsDialog, AnyLegendsLocked )
}


void function OpenFocusedCharacterSkillsDialog( var button )
{
	var focus = GetFocus()

	if ( s_characters.buttons.contains( focus ) )
		OpenCharacterSkillsDialog( s_characters.buttonToCharacter[focus] )
}


void function CharactersPanel_OnShow( var panel )
{
	UI_SetPresentationType( ePresentationType.WEAPON_CATEGORY )

	ItemFlavor character = LoadoutSlot_GetItemFlavor( LocalClientEHI(), Loadout_CharacterClass() )
	SetTopLevelCustomizeContext( character )

	AddCallbackAndCallNow_OnGRXInventoryStateChanged( UpdateCharacterButtons )
	AddCallbackAndCallNow_OnGRXOffersRefreshed( UpdateCharacterButtons )
}


void function CharactersPanel_OnHide( var panel )
{
	SetTopLevelCustomizeContext( null )
	RunMenuClientFunction( "ClearAllCharacterPreview" )

	RemoveCallback_OnGRXInventoryStateChanged( UpdateCharacterButtons )
	RemoveCallback_OnGRXOffersRefreshed( UpdateCharacterButtons )

	s_characters.buttonWithFocus = null
}


void function UpdateCharacterButtons()
{
	bool grxReady = GRX_IsInventoryReady() && GRX_AreOffersReady()

	s_characters.buttonToCharacter.clear()

	array<ItemFlavor> unownedCharacters
	foreach ( ItemFlavor character in GetAllCharacters() )
	{
		bool isAvailable = IsItemFlavorUnlockedForLoadoutSlot( LocalClientEHI(), Loadout_CharacterClass(), character )
		if ( !isAvailable )
		{
			if ( !ItemFlavor_ShouldBeVisible( character, GetUIPlayer() ) )
				continue
		}

		if ( !GRX_IsItemOwnedByPlayer_AllowOutOfDateData( character, null ) )
			unownedCharacters.append( character )
	}

	foreach ( index, button in s_characters.buttons )
	{
		if ( index < unownedCharacters.len() )
		{
			ItemFlavor character = unownedCharacters[index]
			s_characters.buttonToCharacter[button] <- character

			Hud_SetVisible( button, true )
			Hud_SetSelected( button, false )

			if ( !grxReady )
			{
				Hud_SetEnabled( button, false )
			}
			else
			{
				array<GRXScriptOffer> offers = GRX_GetItemDedicatedStoreOffers( character, "character" )

				Hud_SetEnabled( button, true )
				RuiSetBool( Hud_GetRui( button ), "isPurchasable", offers.len() > 0 )
				Hud_SetLocked( button, offers.len() == 0 )
			}
			RuiSetString( Hud_GetRui( button ), "purchasePriceEC", ShortenNumber( string( 25000 ) ) )
			RuiSetString( Hud_GetRui( button ), "purchasePriceVC", ShortenNumber( string( 350 ) ) )

			RuiSetString( Hud_GetRui( button ), "buttonText", Localize( ItemFlavor_GetLongName( character ) ) )
			RuiSetImage( Hud_GetRui( button ), "buttonImage", CharacterClass_GetGalleryPortrait( character ) )
			RuiSetImage( Hud_GetRui( button ), "bgImage", CharacterClass_GetGalleryPortraitBackground( character ) )
			RuiSetImage( Hud_GetRui( button ), "roleImage", CharacterClass_GetCharacterRoleImage( character ) )

			if ( s_characters.buttonWithFocus == null )
				CharacterButton_OnGetFocus( button )
		}
		else
		{
			Hud_SetVisible( button, false )
		}
	}

	if ( unownedCharacters.len() == 0 )
	{
		Hud_SetVisible( s_characters.allLegendsPanel, true )
		Hud_SetVisible( s_characters.characterSelectInfoPanel, false )
	}
	else
	{
		Hud_SetVisible( s_characters.allLegendsPanel, false )
		Hud_SetVisible( s_characters.characterSelectInfoPanel, true )
	}
}


bool function AnyLegendsLocked()
{
	if ( !GRX_IsInventoryReady() )
		return false

	var focus = GetFocus()

	if ( focus in s_characters.buttonToCharacter )
		return s_characters.buttonToCharacter[focus] != LoadoutSlot_GetItemFlavor( LocalClientEHI(), Loadout_CharacterClass() )

	return false
}


void function CharacterButton_OnActivate( var button )
{
	if ( Hud_IsLocked( button ) )
	{
		EmitUISound( "menu_deny" )
		return
	}

	ItemFlavor character = s_characters.buttonToCharacter[button]
	//array<GRXScriptOffer> offers = GRX_GetItemDedicatedStoreOffers( character, "character" )
	//Assert( offers.len() == 1 )
	PurchaseDialog( character, 1, true, null, null )
}


void function CharacterButton_OnRightClick( var button )
{
	OpenCharacterSkillsDialog( s_characters.buttonToCharacter[button] )
}


void function CharacterButton_OnGetFocus( var button )
{
	if ( !(button in s_characters.buttonToCharacter) )
		return

	UI_SetPresentationType( ePresentationType.CHARACTER_SELECT )

	foreach ( characterButton in s_characters.buttons )
		Hud_SetSelected( characterButton, false )

	//Hud_SetSelected( button, true )

	bool grxReady = GRX_IsInventoryReady() && GRX_AreOffersReady()

	ItemFlavor character     = s_characters.buttonToCharacter[button]
	ItemFlavor characterSkin = LoadoutSlot_GetItemFlavor( LocalClientEHI(), Loadout_CharacterSkin( character ) )

	//RuiSetBool( s_characters.characterSelectInfoRui, "showInfo", true )
	RuiSetString( s_characters.characterSelectInfoRui, "nameText", Localize( ItemFlavor_GetLongName( character ) ).toupper() )
	RuiSetString( s_characters.characterSelectInfoRui, "subtitleText", Localize( CharacterClass_GetCharacterSelectSubtitle( character ) ) )
	//RuiSetString( s_characters.characterSelectInfoRui, "descText", Localize( ItemFlavor_GetShortDescription( character ) ) )
	if ( s_characters.buttonWithFocus != button )
		RuiSetGameTime( s_characters.characterSelectInfoRui, "initTime", Time() )
	//RuiSetImage( s_characters.characterSelectInfoRui, "roleImage", CharacterClass_GetCharacterRoleImage( character ) )

	s_characters.buttonWithFocus = button

	string priceText
	if ( !grxReady )
	{
		priceText = "#STORE_CHARACTER_LOADING"
	}
	else
	{
		array<GRXScriptOffer> offers = GRX_GetItemDedicatedStoreOffers( character, "character" )

		bool isOwned                    = GRX_IsItemOwnedByPlayer( character )
		bool isPurchasableAtAll         = (offers.len() > 0)
		bool isPurchasableByLocalPlayer = !isOwned && isPurchasableAtAll

		if ( isPurchasableByLocalPlayer )
		{
			Assert( offers.len() == 1 )
			GRXScriptOffer offer = offers[0]

			array<string> formattedPrices
			foreach ( ItemFlavorBag price in offer.prices )
			{
				formattedPrices.append( GRX_GetFormattedPrice( price, 1 ) )
			}

			if ( formattedPrices.len() == 0 )
				priceText = "#STORE_CHARACTER_UNAVAILALBE"
			else if ( formattedPrices.len() == 1 )
				priceText = Localize( "#STORE_CHARACTER_PRICE_N", formattedPrices[0] )
			else if ( formattedPrices.len() == 2 )
				priceText = Localize( "#STORE_CHARACTER_PRICE_N_N", formattedPrices[0], formattedPrices[1] )
		}
		else if ( isOwned )
		{
			priceText = "#STORE_CHARACTER_OWNED"
		}
		else
		{
			priceText = "#STORE_CHARACTER_COMING_SOON"
		}
	}

	RuiSetString( s_characters.characterSelectInfoRui, "priceText", priceText )

	RunClientScript( "UIToClient_PreviewCharacterSkin", ItemFlavor_GetNetworkIndex_DEPRECATED( characterSkin ), ItemFlavor_GetNetworkIndex_DEPRECATED( character ) )
}

/*
██╗      ██████╗  ██████╗ ████████╗    ████████╗██╗ ██████╗██╗  ██╗
██║     ██╔═══██╗██╔═══██╗╚══██╔══╝    ╚══██╔══╝██║██╔════╝██║ ██╔╝
██║     ██║   ██║██║   ██║   ██║          ██║   ██║██║     █████╔╝ 
██║     ██║   ██║██║   ██║   ██║          ██║   ██║██║     ██╔═██╗ 
███████╗╚██████╔╝╚██████╔╝   ██║          ██║   ██║╚██████╗██║  ██╗
╚══════╝ ╚═════╝  ╚═════╝    ╚═╝          ╚═╝   ╚═╝ ╚═════╝╚═╝  ╚═╝
*/

void function InitLootPanel( var panel )
{
	var lootPanelA = Hud_GetChild( panel, "LootPanelA" )
	//	var rui = Hud_GetRui( Hud_GetChild( lootPanelA, "LootFrame" ) )
	//	RuiSetImage( rui, "basicImage", $"rui/menu/store/loot_tick_temp" )
	//HudElem_SetRuiArg( Hud_GetChild( lootPanelA, "LootFrame" ), "lootImage", $"rui/menu/store/loot_tick_temp" )

	s_loot.lootPanel = Hud_GetChild( lootPanelA, "PanelContent" )
	HudElem_SetRuiArg( s_loot.lootPanel, "titleText", Localize( "#RARE_LOOT_TICK" ) )
	HudElem_SetRuiArg( s_loot.lootPanel, "descText", Localize( "#CONTAINS_3_ITEMS" ) )

	HudElem_SetRuiArg( s_loot.lootPanel, "bulletText1", Localize( "#LOOT_CATEGORY_1" ) )
	HudElem_SetRuiArg( s_loot.lootPanel, "bulletText2", Localize( "#LOOT_CATEGORY_2" ) )
	HudElem_SetRuiArg( s_loot.lootPanel, "bulletText3", Localize( "#LOOT_CATEGORY_3" ) )
	HudElem_SetRuiArg( s_loot.lootPanel, "bulletText4", Localize( "#LOOT_CATEGORY_4" ) )
	HudElem_SetRuiArg( s_loot.lootPanel, "bulletText5", Localize( "#LOOT_CATEGORY_5" ) )
	HudElem_SetRuiArg( s_loot.lootPanel, "bulletText6", Localize( "#LOOT_CATEGORY_6" ) )
	HudElem_SetRuiArg( s_loot.lootPanel, "bulletText7", Localize( "#LOOT_CATEGORY_7" ) )
	HudElem_SetRuiArg( s_loot.lootPanel, "bulletText8", Localize( "#LOOT_CATEGORY_8" ) )
	HudElem_SetRuiArg( s_loot.lootPanel, "bulletText9", Localize( "#LOOT_CATEGORY_9" ) )
	HudElem_SetRuiArg( s_loot.lootPanel, "bulletText10", Localize( "#LOOT_CATEGORY_10" ) )
	HudElem_SetRuiArg( s_loot.lootPanel, "bulletText11", Localize( "#LOOT_CATEGORY_11" ) )
	HudElem_SetRuiArg( s_loot.lootPanel, "bulletText12", Localize( "#LOOT_CATEGORY_12" ) )

	HudElem_SetRuiArg( s_loot.lootPanel, "rarityBulletText1", Localize( "#LOOT_RARITY_CHANCE_1" ) )
	HudElem_SetRuiArg( s_loot.lootPanel, "rarityBulletText2", Localize( "#LOOT_RARITY_CHANCE_2" ) )
	HudElem_SetRuiArg( s_loot.lootPanel, "rarityBulletText3", Localize( "#LOOT_RARITY_CHANCE_3" ) )
	HudElem_SetRuiArg( s_loot.lootPanel, "rarityPercentText1", Localize( "#LOOT_RARITY_PERCENT_1" ) )
	HudElem_SetRuiArg( s_loot.lootPanel, "rarityPercentText2", Localize( "#LOOT_RARITY_PERCENT_2" ) )
	HudElem_SetRuiArg( s_loot.lootPanel, "rarityPercentText3", Localize( "#LOOT_RARITY_PERCENT_3" ) )

	HudElem_SetRuiArg( s_loot.lootPanel, "featureBulletText1", Localize( "#LOOT_FEATURE_1" ) )
	HudElem_SetRuiArg( s_loot.lootPanel, "featureBulletText2", Localize( "#LOOT_FEATURE_2" ) )
	HudElem_SetRuiArg( s_loot.lootPanel, "featureBulletText3", Localize( "#LOOT_FEATURE_3" ) )
	HudElem_SetRuiArg( s_loot.lootPanel, "featureBulletText4", Localize( "#LOOT_FEATURE_4" ) )
	HudElem_SetRuiArg( s_loot.lootPanel, "featureBulletText5", Localize( "#LOOT_FEATURE_5" ) )

	s_loot.lootButtonOpen = Hud_GetChild( panel, "OpenOwnedButton" )
	HudElem_SetRuiArg( s_loot.lootButtonOpen, "buttonText", "#ACTIVATE_LOOT_BOX" )
	HudElem_SetRuiArg( s_loot.lootButtonOpen, "descText", "" )

	s_loot.lootButtonPurchase = Hud_GetChild( lootPanelA, "PurchaseButton" )
	s_loot.lootButtonPurchaseN = Hud_GetChild( lootPanelA, "PurchaseButtonN" )

	AddPanelEventHandler( panel, eUIEvent.PANEL_SHOW, LootPanel_OnShow )
	AddPanelEventHandler( panel, eUIEvent.PANEL_HIDE, LootPanel_OnHide )

	Hud_AddEventHandler( s_loot.lootButtonOpen, UIE_CLICK, OpenLootBoxButton_OnActivate )

	Hud_AddEventHandler( s_loot.lootButtonPurchase, UIE_CLICK, LootTickPurchaseButton_Activate )
	Hud_AddEventHandler( s_loot.lootButtonPurchaseN, UIE_CLICK, LootTickPurchaseButton_Activate )

	AddPanelFooterOption( panel, LEFT, BUTTON_B, true, "#B_BUTTON_BACK", "#B_BUTTON_BACK" )
}


void function LootPanel_OnShow( var panel )
{
	AddCallbackAndCallNow_OnGRXInventoryStateChanged( UpdateLootTickButtons )

	UI_SetPresentationType( ePresentationType.WEAPON_CATEGORY )
}


void function LootPanel_OnHide( var panel )
{
	RemoveCallback_OnGRXInventoryStateChanged( UpdateLootTickButtons )
}


void function OpenLootBoxButton_OnActivate( var button )
{
	if ( Hud_IsLocked( button ) )
		return

	AdvanceMenu( GetMenu( "LootBoxOpen" ) )
}


GRXScriptOffer ornull function GetLootTickPurchaseOffer()
{
	ItemFlavor lootTick          = GetItemFlavorByAsset( $"settings/itemflav/pack/cosmetic_rare.rpak" )
	array<GRXScriptOffer> offers = GRX_GetItemDedicatedStoreOffers( lootTick, "loot" )
	return offers.len() > 0 ? offers[0] : null
}


void function UpdateLootTickButtons()
{
	UpdateLootTickButton( s_loot.lootButtonPurchase, 1 )
	UpdateLootTickButton( s_loot.lootButtonPurchaseN, GetCurrentPlaylistVarInt( "loot_tick_purchase_max", 10 ) )

	UpdateLootBoxButton( s_loot.lootButtonOpen )
}


void function UpdateLootTickButton( var button, int quantity )
{
	HudElem_SetRuiArg( button, "buttonText", "#PURCHASE" )

	bool purchaseLock   = false
	string purchaseDesc = ""
	if ( GRX_IsInventoryReady() && GRX_AreOffersReady() )
	{
		GRXScriptOffer ornull offer = GetLootTickPurchaseOffer()
		if ( offer != null )
		{
			expect GRXScriptOffer( offer )
			purchaseDesc = Localize( "#STORE_PURCHASE_N_FOR_N", quantity, GRX_GetFormattedPrice( offer.prices[0], quantity ) )
			ItemFlavor lootTickFlavor = offer.output.flavors[0] // this is kind of silly

			purchaseLock = false//!GRX_CanAfford( offer.prices[0], quantity )
		}
		else
		{
			purchaseLock = true
		}
	}
	else
	{
		purchaseLock = true
	}

	Hud_SetLocked( button, purchaseLock )
	HudElem_SetRuiArg( button, "descText", purchaseDesc )
}


void function LootTickPurchaseButton_Activate( var button )
{
	if ( Hud_IsLocked( button ) )
		return

	ItemFlavor lootTick = GetItemFlavorByAsset( $"settings/itemflav/pack/cosmetic_rare.rpak" )

	int quantity = 1
	if ( int( Hud_GetScriptID( button ) ) != 0 )
	{
		ItemFlavorPurchasabilityInfo ifpi = GRX_GetItemPurchasabilityInfo( lootTick )
		Assert( ifpi.isPurchasableAtAll )

		foreach ( string location, array<GRXScriptOffer> locationOfferList in ifpi.locationToDedicatedStoreOffersMap )
		{
			foreach ( GRXScriptOffer locationOffer in locationOfferList )
			{
				// TODO; quantity becomes what a player can afford, and this gets moved to sh_grx
			}
		}

		quantity = GetCurrentPlaylistVarInt( "loot_tick_purchase_max", 10 )
	}

	PurchaseDialog( lootTick, quantity, false, null, OnLootTickPurchaseResult )
}


void function OnLootTickPurchaseResult( bool wasSuccessful )
{
	if ( wasSuccessful )
	{
		UpdateLootTickButtons()
	}
}

/*
███████╗ ██████╗    ███████╗██╗  ██╗ ██████╗ ██████╗ 
██╔════╝██╔════╝    ██╔════╝██║  ██║██╔═══██╗██╔══██╗
█████╗  ██║         ███████╗███████║██║   ██║██████╔╝
██╔══╝  ██║         ╚════██║██╔══██║██║   ██║██╔═══╝ 
███████╗╚██████╗    ███████║██║  ██║╚██████╔╝██║     
╚══════╝ ╚═════╝    ╚══════╝╚═╝  ╚═╝ ╚═════╝ ╚═╝    
*/

void function InitOffersPanel( var panel )
{
	s_offers.offersPanel = panel

	s_offers.featuredHeader = Hud_GetChild( panel, "LeftHeader" )
	s_offers.exclusiveHeader = Hud_GetChild( panel, "RightHeader" )

	s_offers.fullOfferButtons = GetPanelElementsByClassname( panel, "FullOfferButton" )
	s_offers.topOfferButtons = GetPanelElementsByClassname( panel, "TopOfferButton" )
	s_offers.bottomOfferButtons = GetPanelElementsByClassname( panel, "BottomOfferButton" )

	s_offers.shopButtons.extend( s_offers.fullOfferButtons )
	s_offers.shopButtons.extend( s_offers.topOfferButtons )
	s_offers.shopButtons.extend( s_offers.bottomOfferButtons )

	for ( int index = 0; index < s_offers.shopButtons.len(); index++ )
	{
		Hud_AddEventHandler( s_offers.shopButtons[index], UIE_CLICK, OfferButton_Activate )
		Hud_SetEnabled( s_offers.shopButtons[index], false )
	}

	RuiSetString( Hud_GetRui( Hud_GetChild( panel, "LeftHeader" ) ), "titleText", "#MENU_STORE_FEATURED" )
	RuiSetString( Hud_GetRui( Hud_GetChild( panel, "RightHeader" ) ), "titleText", "#MENU_STORE_EXCLUSIVE" )

	AddPanelEventHandler( panel, eUIEvent.PANEL_SHOW, OffersPanel_OnShow )
	AddPanelEventHandler( panel, eUIEvent.PANEL_HIDE, OffersPanel_OnHide )

	AddPanelFooterOption( panel, LEFT, BUTTON_B, true, "#B_BUTTON_BACK", "#B_BUTTON_BACK" )
}


void function OffersPanel_OnShow( var panel )
{
	UI_SetPresentationType( ePresentationType.WEAPON_CATEGORY )

	AddCallbackAndCallNow_OnGRXInventoryStateChanged( UpdateOffersPanel )
	AddCallbackAndCallNow_OnGRXOffersRefreshed( UpdateOffersPanel )

	thread OffersPanel_Think( panel )
}


void function OffersPanel_OnHide( var panel )
{
	RemoveCallback_OnGRXInventoryStateChanged( UpdateOffersPanel )
	RemoveCallback_OnGRXOffersRefreshed( UpdateOffersPanel )
}


void function UpdateOffersPanel()
{
	if ( GRX_IsInventoryReady() )
	{
		if ( GRX_AreOffersReady() )
			InitOffers()
		else
			ClearOffers()
	}
	else
	{
		foreach ( var button in s_offers.shopButtons )
		{
			Hud_SetEnabled( button, false )
			Hud_SetVisible( button, false )
		}
	}
}


void function OffersPanel_Think( var panel )
{
	Signal( uiGlobal.signalDummy, "OffersPanel_Think" )
	EndSignal( uiGlobal.signalDummy, "OffersPanel_Think" )

	var menu = GetParentMenu( panel )
	while ( uiGlobal.activeMenu == menu && uiGlobal.activePanels.contains( panel ) )
	{
		UpdateOffersPanel()

		wait 1.0
	}
}


void function InitOffers()
{
	int totalWidth    = 0
	int featuredWidth = 0

	int exclusiveWidth = 0
	int exclusiveX


	var dataTable = GetDataTable( $"datatable/seasonal_store_data.rpak" )
	for ( int i = 0; i < GetDatatableRowCount( dataTable ); i++ )
	{
		string seasonTag = GetDataTableString( dataTable, i, GetDataTableColumnByName( dataTable, "seasonTag" ) ).tolower()
		asset tallImage = GetDataTableAsset( dataTable, i, GetDataTableColumnByName( dataTable, "tallImage" ) )
		asset squareImage = GetDataTableAsset( dataTable, i, GetDataTableColumnByName( dataTable, "squareImage" ) )
		asset tallFrameOverlayImage = GetDataTableAsset( dataTable, i, GetDataTableColumnByName( dataTable, "tallFrameOverlay" ) )
		asset squareFrameOverlayImage = GetDataTableAsset( dataTable, i, GetDataTableColumnByName( dataTable, "squareFrameOverlay" ) )
		asset topImage = GetDataTableAsset( dataTable, i, GetDataTableColumnByName( dataTable, "topImage" ) )

		SeasonalStoreData seasonalStoreData
		seasonalStoreData.seasonTag = seasonTag
		seasonalStoreData.tallImage = tallImage
		seasonalStoreData.squareImage = squareImage
		seasonalStoreData.tallFrameOverlayImage = tallFrameOverlayImage
		seasonalStoreData.squareFrameOverlayImage = squareFrameOverlayImage
		seasonalStoreData.topImage = topImage

		s_offers.seasonalDataMap[seasonTag] <- seasonalStoreData
	}
	//array<int> fakeOfferCounts = [2, 1, 0, 2, 2]

	for ( int col = 0; col < 5; col++ )
	{
		//array<GRXScriptOffer> fakeOffers
		//fakeOffers.resize( fakeOfferCounts[col] )
		//array<GRXScriptOffer> columnOffers = fakeOffers//GRX_GetStoreOfferColumn( col )

		array<GRXScriptOffer> columnOffers = GRX_GetStoreOfferColumn( col )

		HudElem_SetRuiArg( s_offers.fullOfferButtons[col], "isSpacer", false )
		HudElem_SetRuiArg( s_offers.topOfferButtons[col], "isSpacer", false )
		HudElem_SetRuiArg( s_offers.bottomOfferButtons[col], "isSpacer", false )
		Hud_SetVisible( s_offers.fullOfferButtons[col], false )
		Hud_SetVisible( s_offers.topOfferButtons[col], false )
		Hud_SetVisible( s_offers.bottomOfferButtons[col], false )
		Hud_SetLocked( s_offers.fullOfferButtons[col], false )
		Hud_SetLocked( s_offers.topOfferButtons[col], false )
		Hud_SetLocked( s_offers.bottomOfferButtons[col], false )

		if ( columnOffers.len() == 0 )
		{
			if ( featuredWidth != 0 )
				exclusiveWidth = (totalWidth - exclusiveX)

			if ( featuredWidth == 0 )
				featuredWidth = totalWidth

			Hud_SetWidth( s_offers.fullOfferButtons[col], Hud_GetBaseWidth( s_offers.fullOfferButtons[col] ) / 2 )
			Hud_SetWidth( s_offers.topOfferButtons[col], Hud_GetBaseWidth( s_offers.topOfferButtons[col] ) / 2 )
			Hud_SetWidth( s_offers.bottomOfferButtons[col], Hud_GetBaseWidth( s_offers.bottomOfferButtons[col] ) / 2 )
		}
		else if ( columnOffers.len() == 1 )
		{
			if ( featuredWidth != 0 && exclusiveX == 0 )
			{
				exclusiveX = totalWidth + Hud_GetX( s_offers.fullOfferButtons[col] )
			}

			Hud_ReturnToBaseSize( s_offers.fullOfferButtons[col] )
			Hud_ReturnToBaseSize( s_offers.topOfferButtons[col] )
			Hud_ReturnToBaseSize( s_offers.bottomOfferButtons[col] )

			Hud_SetVisible( s_offers.fullOfferButtons[col], true )
			Hud_SetVisible( s_offers.topOfferButtons[col], false )
			Hud_SetVisible( s_offers.bottomOfferButtons[col], false )

			InitOfferButton( s_offers.fullOfferButtons[col], columnOffers[0], true )

			if ( columnOffers[0].prereq != null && col > 0  )
				InitSpacerButton( s_offers.fullOfferButtons[col - 1], columnOffers[0] )
		}
		else if ( columnOffers.len() == 2 )
		{
			if ( featuredWidth != 0 && exclusiveX == 0 )
			{
				exclusiveX = totalWidth + Hud_GetX( s_offers.fullOfferButtons[col] )
			}

			Hud_ReturnToBaseSize( s_offers.fullOfferButtons[col] )
			Hud_ReturnToBaseSize( s_offers.topOfferButtons[col] )
			Hud_ReturnToBaseSize( s_offers.bottomOfferButtons[col] )

			Hud_SetVisible( s_offers.fullOfferButtons[col], false )
			Hud_SetVisible( s_offers.topOfferButtons[col], true )
			Hud_SetVisible( s_offers.bottomOfferButtons[col], true )

			InitOfferButton( s_offers.topOfferButtons[col], columnOffers[0], false )
			InitOfferButton( s_offers.bottomOfferButtons[col], columnOffers[1], false )

			if ( columnOffers[0].prereq != null && col > 0 )
				InitSpacerButton( s_offers.topOfferButtons[col - 1], columnOffers[0] )
			if ( columnOffers[1].prereq != null && col > 0  )
				InitSpacerButton( s_offers.bottomOfferButtons[col - 1], columnOffers[1] )
		}

		totalWidth += Hud_GetX( s_offers.fullOfferButtons[col] ) + Hud_GetWidth( s_offers.fullOfferButtons[col] )
	}

	Hud_SetWidth( s_offers.offersPanel, totalWidth )
	Hud_SetWidth( s_offers.featuredHeader, featuredWidth > 0 ? featuredWidth : totalWidth )

	Hud_SetX( s_offers.exclusiveHeader, exclusiveX )
	Hud_SetWidth( s_offers.exclusiveHeader, exclusiveWidth > 0 ? exclusiveWidth : totalWidth - exclusiveX )
}


void function InitSpacerButton( var button, GRXScriptOffer offerData )
{
	ItemFlavor prereqFlav = expect ItemFlavor( offerData.prereq )
	Hud_SetVisible( button, true )
	Hud_SetLocked( button, !GRX_IsItemOwnedByPlayer( prereqFlav ) )
	HudElem_SetRuiArg( button, "isSpacer", true )
}


void function ClearOffers()
{
	foreach( button in s_offers.shopButtons )
	{
		var rui = Hud_GetRui( button )

		RuiSetImage( rui, "ecImage", $"" )
		RuiSetString( rui, "ecTitle", "" )
		RuiSetString( rui, "ecDesc", "" )
		RuiSetString( rui, "ecReqs", "" )
		RuiSetString( rui, "tagText", "" )

		RuiSetImage( rui, "ecContainerImage", $"rui/menu/store/feature_price_container" )
		RuiSetString( rui, "ecPrice", "#UNAVAILABLE" )
		RuiSetGameTime( rui, "expireTime", RUI_BADGAMETIME )

		Hud_SetEnabled( button, false )
	}
}


void function OfferButton_Activate( var button )
{
	GRXScriptOffer offer = s_offers.buttonToOfferData[button]
	Assert( offer.output.flavors.len() == 1 )
	ItemFlavor flav = s_offers.buttonToOfferData[button].output.flavors[0]

	if ( StoreItemTypePresentationSupported( flav ) )
		SetStoreItemPresentationModeActive( offer )
	else
		PurchaseDialog( flav, 1, true, null, null )
}


void function InitOfferButton( var button, GRXScriptOffer offerData, bool isTall )
{
	var rui = Hud_GetRui( button )

	RuiSetImage( rui, "ecImage", offerData.image )
	RuiSetString( rui, "ecTitle", offerData.titleText )
	RuiSetString( rui, "ecDesc", ""/*offerData.descText*/ )
	RuiSetString( rui, "tagText", offerData.tagText )

	asset topImage
	asset backgroundImage
	asset frameOverlayImage
	string seasonTag = offerData.seasonTag in s_offers.seasonalDataMap ? offerData.seasonTag : "default"

	topImage = s_offers.seasonalDataMap[seasonTag].topImage
	backgroundImage = isTall ? s_offers.seasonalDataMap[seasonTag].tallImage : s_offers.seasonalDataMap[seasonTag].squareImage
	frameOverlayImage = isTall ? s_offers.seasonalDataMap[seasonTag].tallFrameOverlayImage : s_offers.seasonalDataMap[seasonTag].squareFrameOverlayImage

	RuiSetImage( rui, "topSlotImg", topImage )
	RuiSetImage( rui, "backgroundImg", backgroundImage )
	RuiSetImage( rui, "frameOverlayImg", frameOverlayImage )

	bool isPurchasableByLocalPlayer = false
	string priceText                = ""

	Assert( offerData.output.flavors.len() == 1 )

	ItemFlavor itemFlav               = offerData.output.flavors[0]
	ItemFlavorPurchasabilityInfo ifpi = GRX_GetItemPurchasabilityInfo( itemFlav )

	float vertAlign = 0.0
	switch ( ItemFlavor_GetType( itemFlav ) )
	{
		case eItemType.weapon_skin:
			vertAlign = -0.6
			break

		default:
			vertAlign = -0.1
			break
	}
	RuiSetFloat( rui, "vertAlign", vertAlign )
	//printt( ItemFlavor_GetHumanReadableRef( itemFlav ) )

	asset containerImage = $""
	if ( GRX_IsItemOwnedByPlayer( itemFlav ) )
	{
		priceText = "#OWNED"
	}
	else if ( offerData.prices.len() > 0 )
	{
		isPurchasableByLocalPlayer = true
		priceText = GRX_GetFormattedPrice( offerData.prices[0] )
		if ( offerData.prices.len() == 1 )
		{
			array<int> priceArray = GRX_GetCurrencyArrayFromBag( offerData.prices[0] )
			foreach ( currencyIndex, price in priceArray )
			{
				if ( price == 0 )
					continue

				containerImage = GRX_CURRENCY_CONTAINERS[currencyIndex]
				break
			}
		}
	}
	else
	{
		Warning( "Offer has no price: %s", ItemFlavor_GetHumanReadableRef( itemFlav ) )
		priceText = "#UNAVAILABLE"
	}

	RuiSetImage( rui, "ecContainerImage", containerImage )
	RuiSetString( rui, "ecPrice", priceText )
	RuiSetInt( rui, "rarity", ItemFlavor_GetQuality( itemFlav ) )
	RuiSetString( rui, "rarityName", ItemFlavor_GetQualityName( itemFlav ) )
	//RuiSetString( rui, "rarityName", "" )
	RuiSetString( rui, "ecDesc", "" )

	int remainingTime = offerData.expireTime - GetUnixTimestamp()
	if ( remainingTime > 0 )
		RuiSetGameTime( rui, "expireTime", Time() + remainingTime )
	else
		RuiSetGameTime( rui, "expireTime", RUI_BADGAMETIME )

	//Hud_SetEnabled( button, isPurchasableByLocalPlayer )
	Hud_SetEnabled( button, true )

	if ( offerData.prereq != null )
	{
		ItemFlavor prereqFlav = expect ItemFlavor( offerData.prereq )
		if ( GRX_IsItemOwnedByPlayer( prereqFlav ) )
			RuiSetString( rui, "ecReqs", Localize( "#STORE_REQUIRES_OWNED", Localize( ItemFlavor_GetLongName( prereqFlav ) ) ) )
		else
			RuiSetString( rui, "ecReqs", Localize( "#STORE_REQUIRES_LOCKED", Localize( ItemFlavor_GetLongName( prereqFlav ) ) ) )
	}

	s_offers.buttonToOfferData[button] <- offerData
}


void function JumpToStoreCharacter( ItemFlavor character )
{
	while ( GetActiveMenu() != GetMenu( "LobbyMenu" ) )
		CloseActiveMenu( true, true )

	//printt( "Jumping to:", ItemFlavor_GetHumanReadableRef( character ) )
	TabData lobbyTabData = GetTabDataForPanel( GetMenu( "LobbyMenu" ) )
	ActivateTab( lobbyTabData, Tab_GetTabIndexByBodyName( lobbyTabData, "StorePanel" ) )

	TabData legendsTabData = GetTabDataForPanel( file.storePanel )
	ActivateTab( legendsTabData, Tab_GetTabIndexByBodyName( legendsTabData, "CharacterPanel" ) )

	foreach ( button in s_characters.buttons )
	{
		if ( s_characters.buttonToCharacter[button] == character )
		{
			Hud_SetFocused( button )
			return
		}
	}
}


void function CharactersPanel_OnFocusChanged( var panel, var oldFocus, var newFocus )
{
	if ( !IsValid( panel ) ) // uiscript_reset
		return
	if ( GetParentMenu( panel ) != GetActiveMenu() )
		return

	UpdateFooterOptions()
}