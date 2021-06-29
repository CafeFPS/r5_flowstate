global function InitSelectSlotDialog
global function OpenSelectSlotDialog

const int MAX_PURCHASE_BUTTONS = 8

struct
{
	var menu
	array<var> buttonList
	var cancelButton
	var displayItem
	var swapIcon

	bool badgeMode

	ItemFlavor& 	item
	ItemFlavor ornull 	character
	array< LoadoutEntry > loadoutEntries
	void functionref( int ) equipFunc

} file

void function InitSelectSlotDialog( var newMenuArg )
{
	var menu = newMenuArg
	file.menu = menu

	for ( int purchaseButtonIdx = 0; purchaseButtonIdx < MAX_PURCHASE_BUTTONS; purchaseButtonIdx++ )
	{
		var button = Hud_GetChild( menu, "PurchaseButton" + purchaseButtonIdx )

		Hud_AddEventHandler( button, UIE_CLICK, PurchaseButton_Activate )
		Hud_AddEventHandler( button, UIE_CLICKRIGHT, PurchaseButton_Activate )
		Hud_AddEventHandler( button, UIE_GET_FOCUS, PurchaseButton_OnFocus )
		Hud_AddEventHandler( button, UIE_LOSE_FOCUS, PurchaseButton_LoseFocus )

		file.buttonList.append( button )
	}

	SetDialog( menu, true )
	SetClearBlur( menu, false )

	AddMenuEventHandler( menu, eUIEvent.MENU_OPEN, SelectSlotDialog_OnOpen )
	AddMenuEventHandler( menu, eUIEvent.MENU_CLOSE, SelectSlotDialog_OnClose )

	AddMenuFooterOption( menu, LEFT, BUTTON_A, true, "#A_BUTTON_SELECT" )
	AddMenuFooterOption( menu, LEFT, BUTTON_B, true, "#B_BUTTON_CLOSE", "#CLOSE" )

	file.cancelButton = Hud_GetChild( menu, "DarkenBackground" )
	Hud_AddEventHandler( file.cancelButton, UIE_CLICK, CancelButton_Activate )

	file.displayItem = Hud_GetChild( menu, "DisplayItem" )

	file.swapIcon = Hud_GetChild( menu, "SwapIcon" )
	RuiSetImage( Hud_GetRui( file.swapIcon ), "basicImage", $"rui/hud/loot/loot_swap_icon" )

	RegisterSignal( "TryOpenSelectSlotDialog" )
}

void function OpenSelectSlotDialog( array<LoadoutEntry> loadoutEntries, ItemFlavor item, ItemFlavor ornull character, void functionref( int ) equipFunc )
{
	file.item = item
	file.loadoutEntries = loadoutEntries
	file.equipFunc = equipFunc
	file.character = character

	thread __TryOpenSelectSlotDialog()
}

void function __TryOpenSelectSlotDialog()
{
	Signal( uiGlobal.signalDummy, "TryOpenSelectSlotDialog" )
	EndSignal( uiGlobal.signalDummy, "TryOpenSelectSlotDialog" )

	bool waited = false

	while ( IsDialog( GetActiveMenu() ) )
	{
		if ( GetActiveMenu() == file.menu )
			return

		WaitFrame()

		waited = true
	}

	vector cp = GetCursorPosition()

	if ( waited )
	{
		cp = < 1920.0 / 2.0 , 1080.0 / 2.0, 0 >
	}

	AdvanceMenu( file.menu )

	var bg        = Hud_GetChild( file.menu, "DarkenBackground" )
	UISize screen = GetScreenSize()

	float xScale       = screen.width / 1920.0
	float yScale       = screen.height / 1080.0
	float heightAdjust = (( Hud_GetHeight( file.buttonList[ 0 ] ) + Hud_GetY( file.buttonList[ 1 ] ) ) * float( file.loadoutEntries.len() ) * 0.5) - ( Hud_GetHeight( file.buttonList[ 0 ] ) * 0.5 )

	float xMargin = (Hud_GetWidth( file.buttonList[ 0 ] ) * 1.2) / xScale
	float yMargin = (Hud_GetHeight( file.buttonList[ 0 ] ) * float( file.loadoutEntries.len() ) * 0.5 * 1.2) / yScale

	vector cpAdjusted = <
	Clamp( cp.x, xMargin, 1920.0 - xMargin ),
	Clamp( cp.y, yMargin, 1080.0 - yMargin ),
	0
	>

	int xp = int(-xScale * cpAdjusted.x)
	int yp = int(-yScale * cpAdjusted.y)

	Hud_SetX( file.buttonList[ 0 ], xp - 0.0 - Hud_GetWidth( file.swapIcon ) )
	Hud_SetY( file.buttonList[ 0 ], yp + int( heightAdjust ) )

	Hud_SetX( file.displayItem, xp + 0.0 + Hud_GetWidth( file.swapIcon ) )
	Hud_SetY( file.displayItem, yp )

	Hud_SetX( file.swapIcon, xp )
	Hud_SetY( file.swapIcon, yp )

	//
	//
	//
	//
	//
	//
	//
	//
}

void function CancelButton_Activate( var button )
{
	UICodeCallback_NavigateBack()
}

void function PurchaseButton_Activate( var button )
{
	int index = int(Hud_GetScriptID( button ))
	file.equipFunc( index )
	CloseActiveMenu()
}

void function SelectSlotDialog_OnOpen()
{
	file.badgeMode = false

	bool useShortButtons = false
	if ( file.loadoutEntries.len() > 0 )
	{
		ItemFlavor flavor = LoadoutSlot_GetItemFlavor( LocalClientEHI(), file.loadoutEntries[ 0 ] )

		int type = ItemFlavor_GetType( flavor )

		if ( type == eItemType.gladiator_card_badge )
			file.badgeMode = true
		else if ( type == eItemType.gladiator_card_kill_quip || type == eItemType.gladiator_card_intro_quip )
			useShortButtons = true
	}

	foreach ( button in file.buttonList )
	{
		if ( file.badgeMode )
			Hud_SetWidth( button, Hud_GetHeight( button ) )
		else
		{
			Hud_SetWidth( button, Hud_GetBaseWidth( button ) )

			if ( useShortButtons )
				Hud_SetHeight( button, Hud_GetBaseHeight( button ) * 0.7 )
			else
				Hud_SetHeight( button, Hud_GetBaseHeight( button ) )
		}
	}

	if ( file.badgeMode )
	{
		Hud_SetWidth( file.displayItem, Hud_GetBaseHeight( file.displayItem ) * 2 )
		Hud_SetHeight( file.displayItem, Hud_GetBaseHeight( file.displayItem ) * 2 )
	}
	else
	{
		Hud_SetWidth( file.displayItem, Hud_GetBaseWidth( file.displayItem ) )

		if ( useShortButtons )
			Hud_SetHeight( file.displayItem, Hud_GetBaseHeight( file.displayItem ) * 0.7 )
		else
			Hud_SetHeight( file.displayItem, Hud_GetBaseHeight( file.displayItem ) )
	}

	for ( int i=0; i<file.buttonList.len(); i++ )
	{
		var button = file.buttonList[ i ]
		UpdateFocusButton( button )
	}

	RuiDestroyNestedIfAlive( Hud_GetRui( file.displayItem ), "badgeUIHandle" )

	ApplyItemToButton( file.displayItem, file.item )

	HudElem_SetRuiArg( file.displayItem, "bgVisible", !file.badgeMode )
}

void function SelectSlotDialog_OnClose()
{

}

void function PurchaseButton_OnFocus( var button )
{
	ApplyItemToButton( button, file.item )

	int index = int(Hud_GetScriptID( button ))
	ItemFlavor itemInButton = LoadoutSlot_GetItemFlavor( LocalClientEHI(), file.loadoutEntries[ index ] )

	for ( int i=0; i<file.loadoutEntries.len(); i++ )
	{
		var bt = file.buttonList[ i ]
		if ( bt == button )
			continue

		ItemFlavor flav = LoadoutSlot_GetItemFlavor( LocalClientEHI(), file.loadoutEntries[i] )
		if ( flav == file.item )
		{
			ApplyItemToButton( bt, itemInButton )
		}
	}
}

void function PurchaseButton_LoseFocus( var button )
{
	foreach ( bt in file.buttonList )
	{
		UpdateFocusButton( bt )
	}
}

void function UpdateFocusButton( var button )
{
	int index = int(Hud_GetScriptID( button ))

	if ( index < file.loadoutEntries.len() )
	{
		Hud_Show( button )

		ItemFlavor flavor = LoadoutSlot_GetItemFlavor( LocalClientEHI(), file.loadoutEntries[ index ] )

		ApplyItemToButton( button, flavor )
	}
	else
	{
		Hud_Hide( button )
	}
}

void function ApplyItemToButton( var button, ItemFlavor flavor )
{
	int index = int(Hud_GetScriptID( button ))

	RuiDestroyNestedIfAlive( Hud_GetRui( button ), "badgeUIHandle" )

	if ( file.badgeMode )
	{
		ItemFlavor character = expect ItemFlavor( file.character )
		HudElem_SetRuiArg( button, "buttonText", "" )
		CreateNestedGladiatorCardBadge( Hud_GetRui( button ), "badgeUIHandle", LocalClientEHI(), flavor, index, character )
	}
	else
	{
		string name = ItemFlavor_GetShortName( flavor )
		int type = ItemFlavor_GetType( flavor )
		if ( type == eItemType.gladiator_card_kill_quip || type == eItemType.gladiator_card_intro_quip )
			name  = ItemFlavor_GetLongName( flavor )

		HudElem_SetRuiArg( button, "buttonText", name )
	}
}