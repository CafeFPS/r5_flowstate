global function InitCharactersPanel

const int MAX_ROWS = 4
const int MAX_COLUMNS = 5

struct
{
	var                    panel
	var                    characterSelectInfoRui
	array<var>             buttons
	table<var, ItemFlavor> buttonToCharacter
	ItemFlavor ornull	   presentedCharacter
	//var                    actionButton
	var					   actionLabel
} file

void function InitCharactersPanel( var panel )
{
	file.panel = panel
	file.characterSelectInfoRui = Hud_GetRui( Hud_GetChild( file.panel, "CharacterSelectInfo" ) )
	file.buttons = GetPanelElementsByClassname( panel, "CharacterButtonClass" )

	SetPanelTabTitle( panel, "#LEGENDS" )
	AddPanelEventHandler( panel, eUIEvent.PANEL_SHOW, CharactersPanel_OnShow )
	AddPanelEventHandler( panel, eUIEvent.PANEL_HIDE, CharactersPanel_OnHide )
	AddPanelEventHandler_FocusChanged( panel, CharactersPanel_OnFocusChanged )

	foreach ( button in file.buttons )
	{
		Hud_AddEventHandler( button, UIE_CLICK, CharacterButton_OnActivate )
		Hud_AddEventHandler( button, UIE_CLICKRIGHT, CharacterButton_OnRightClick )
		Hud_AddEventHandler( button, UIE_MIDDLECLICK, CharacterButton_OnMiddleClick )
		//
		//ToolTipData toolTipData
		//toolTipData.tooltipStyle = eTooltipStyle.BUTTON_PROMPT
		//toolTipData.actionHint1 = "#X_BUTTON_TOGGLE_LOADOUT"
		//Hud_SetToolTipData( button, toolTipData )
	}

	AddPanelFooterOption( panel, LEFT, BUTTON_B, true, "#B_BUTTON_BACK", "#B_BUTTON_BACK" )
	AddPanelFooterOption( panel, LEFT, BUTTON_A, false, "#A_BUTTON_SELECT", "", null, IsCharacterButtonFocused )
	//AddPanelFooterOption( panel, LEFT, BUTTON_X, false, "#X_BUTTON_TOGGLE_LOADOUT", "#X_BUTTON_TOGGLE_LOADOUT", OpenFocusedCharacterSkillsDialog, IsCharacterButtonFocused )
	AddPanelFooterOption( panel, LEFT, BUTTON_Y, false, "#Y_BUTTON_UNLOCK", "#Y_BUTTON_UNLOCK", JumpToStoreCharacterFromFocus, IsReadyAndFocusedCharacterLocked )
	AddPanelFooterOption( panel, LEFT, BUTTON_Y, false, "#Y_BUTTON_SET_FEATURED", "#Y_BUTTON_SET_FEATURED", SetFeaturedCharacterFromFocus, IsReadyAndNonfeaturedCharacterButtonFocused )
	//AddPanelFooterOption( panel, LEFT, MOUSE_RIGHT, false, "", "#X_BUTTON_TOGGLE_LOADOUT", ToggleCharacterDetails ) // mouse

	//file.actionButton = Hud_GetChild( panel, "ActionButton" )
	//HudElem_SetRuiArg( file.actionButton, "bigText", "" )
	//HudElem_SetRuiArg( file.actionButton, "buttonText", "" )
	//HudElem_SetRuiArg( file.actionButton, "descText", "" )
	//HudElem_SetRuiArg( file.actionButton, "centerText", "#X_BUTTON_TOGGLE_LOADOUT" )
	//Hud_AddEventHandler( file.actionButton, UIE_CLICK, OpenFocusedCharacterSkillsDialog )

	file.actionLabel = Hud_GetChild( panel, "ActionLabel" )
	Hud_SetText( file.actionLabel, "#X_BUTTON_TOGGLE_LOADOUT" )
}


bool function IsReadyAndFocusedCharacterLocked()
{
	if ( !GRX_IsInventoryReady() )
		return false

	var focus = GetFocus()

	if ( focus in file.buttonToCharacter )
		return !GRX_IsItemOwnedByPlayer( file.buttonToCharacter[focus] )

	return false
}


bool function IsReadyAndNonfeaturedCharacterButtonFocused()
{
	if ( !GRX_IsInventoryReady() )
		return false

	var focus = GetFocus()

	if ( focus in file.buttonToCharacter )
		return file.buttonToCharacter[focus] != LoadoutSlot_GetItemFlavor( LocalClientEHI(), Loadout_CharacterClass() )

	return false
}


bool function IsCharacterButtonFocused()
{
	if ( file.buttons.contains( GetFocus() ) )
		return true

	return false
}


void function SetFeaturedCharacter( ItemFlavor character )
{
	if ( !GRX_IsItemOwnedByPlayer( character ) )
		return

	foreach ( button in file.buttons )
	{
		if ( button in file.buttonToCharacter )
			Hud_SetSelected( button, file.buttonToCharacter[button] == character )
	}

	Newness_IfNecessaryMarkItemFlavorAsNoLongerNewAndInformServer( character )
	RequestSetItemFlavorLoadoutSlot( LocalClientEHI(), Loadout_CharacterClass(), character )

	EmitUISound( "UI_Menu_Legend_SetFeatured" )
}


void function JumpToStoreCharacterFromFocus( var button )
{
	var focus = GetFocus()

	JumpToStoreCharacterFromButton( focus )
}

void function JumpToStoreCharacterFromButton( var button )
{
	if ( button in file.buttonToCharacter )
		JumpToStoreCharacter( file.buttonToCharacter[button] )

	EmitUISound( "menu_accept" )
}

void function SetFeaturedCharacterFromButton( var button )
{
	if ( button in file.buttonToCharacter )
		SetFeaturedCharacter( file.buttonToCharacter[button] )
}

void function SetFeaturedCharacterFromFocus( var button )
{
	var focus = GetFocus()

	SetFeaturedCharacterFromButton( focus )
}


void function OpenFocusedCharacterSkillsDialog( var button )
{
	var focus = GetFocus()

	if ( file.buttons.contains( focus ) )
		OpenCharacterSkillsDialog( file.buttonToCharacter[focus] )
}


void function InitCharacterButtons()
{
	file.buttonToCharacter.clear()

	array<ItemFlavor> shippingCharacters
	array<ItemFlavor> devCharacters
	array<ItemFlavor> allCharacters
	foreach ( ItemFlavor itemFlav in GetAllCharacters() )
	{
		bool isAvailable = IsItemFlavorUnlockedForLoadoutSlot( LocalClientEHI(), Loadout_CharacterClass(), itemFlav )
		if ( !isAvailable )
		{
			if ( !ItemFlavor_ShouldBeVisible( itemFlav, GetUIPlayer() ) )
				continue
		}

		allCharacters.append( itemFlav )
	}

	foreach ( button in file.buttons )
		Hud_SetVisible( button, false )

	table<int,ItemFlavor> mappingTable = GetCharacterButtonMapping( allCharacters, file.buttons.len() )
	foreach ( int buttonIndex, ItemFlavor itemFlav in mappingTable )
	{
		CharacterButton_Init( file.buttons[ buttonIndex ], itemFlav )
		Hud_SetVisible( file.buttons[ buttonIndex ], true )
	}

	array<int> rowSizes = GetCharacterButtonRowSizes( allCharacters.len() )
	array< array<var> > buttonRows

	int buttonIndex = 0
	foreach ( rowSize in rowSizes )
	{
		array<var> buttons
		int last = buttonIndex + rowSize

		while ( buttonIndex < last )
		{
			buttons.append( file.buttons[buttonIndex] )
			buttonIndex++
		}

		buttonRows.append( buttons )
	}
	LayoutCharacterButtons( buttonRows )
}


void function CharacterButton_Init( var button, ItemFlavor character )
{
	file.buttonToCharacter[button] <- character

	//bool isNew = (Newness_ReverseQuery_GetNewCount( NEWNESS_QUERIES.CharacterButton[character] ) > 0)
	// todo(jpg): make new and locked mutually exclusive
	bool isLocked   = IsItemFlavorUnlockedForLoadoutSlot( LocalClientEHI(), Loadout_CharacterClass(), character )
	bool isSelected = LoadoutSlot_GetItemFlavor( LocalClientEHI(), Loadout_CharacterClass() ) == character

	Hud_SetVisible( button, true )
	//Hud_SetNew( button, isNew )
	Hud_SetLocked( button, !IsItemFlavorUnlockedForLoadoutSlot( LocalClientEHI(), Loadout_CharacterClass(), character ) )
	Hud_SetSelected( button, isSelected )

	RuiSetString( Hud_GetRui( button ), "buttonText", Localize( ItemFlavor_GetLongName( character ) ).toupper() )
	RuiSetImage( Hud_GetRui( button ), "buttonImage", CharacterClass_GetGalleryPortrait( character ) )
	RuiSetImage( Hud_GetRui( button ), "bgImage", CharacterClass_GetGalleryPortraitBackground( character ) )
	RuiSetImage( Hud_GetRui( button ), "roleImage", CharacterClass_GetCharacterRoleImage( character ) )
	//RuiSetInt( Hud_GetRui( button ), "characterLevel", GetCharacterLevel( character ) )

	Newness_AddCallbackAndCallNow_OnRerverseQueryUpdated( NEWNESS_QUERIES.CharacterButton[character], OnNewnessQueryChangedUpdateButton, button )
}


void function CharactersPanel_OnShow( var panel )
{
	UI_SetPresentationType( ePresentationType.CHARACTER_SELECT )

	ItemFlavor character = LoadoutSlot_GetItemFlavor( LocalClientEHI(), Loadout_CharacterClass() )
	SetTopLevelCustomizeContext( character )
	PresentCharacter( character )

	InitCharacterButtons()
}


void function CharactersPanel_OnHide( var panel )
{
	if ( NEWNESS_QUERIES.isValid )
		foreach ( var button, ItemFlavor character in file.buttonToCharacter )
			if ( character in NEWNESS_QUERIES.CharacterButton ) // todo(dw): aaarggggghhhhh
				Newness_RemoveCallback_OnRerverseQueryUpdated( NEWNESS_QUERIES.CharacterButton[character], OnNewnessQueryChangedUpdateButton, button )

	SetTopLevelCustomizeContext( null )
	RunMenuClientFunction( "ClearAllCharacterPreview" )

	file.buttonToCharacter.clear()
}


void function CharactersPanel_OnFocusChanged( var panel, var oldFocus, var newFocus )
{
	if ( !IsValid( panel ) ) // uiscript_reset
		return

	if ( !newFocus || GetParentMenu( panel ) != GetActiveMenu() )
		return

	UpdateFooterOptions()

	ItemFlavor character
	if ( file.buttons.contains( newFocus ) )
		character = file.buttonToCharacter[newFocus]
	else
		character = LoadoutSlot_GetItemFlavor( LocalClientEHI(), Loadout_CharacterClass() )


	//Hud_SetVisible( file.actionButton, IsCharacterButtonFocused() )
	Hud_SetVisible( file.actionLabel, IsCharacterButtonFocused() )

	printt( ItemFlavor_GetHumanReadableRef( character ) )
	PresentCharacter( character )
}


void function CharacterButton_OnActivate( var button )
{
	ItemFlavor character = file.buttonToCharacter[button]
	SetTopLevelCustomizeContext( character )
	CustomizeCharacterMenu_SetCharacter( character )
	if ( GRX_IsItemOwnedByPlayer( character ) )
		RequestSetItemFlavorLoadoutSlot( LocalClientEHI(), Loadout_CharacterClass(), character ) // TEMP, Some menu state is broken without this. Need Declan to look at why RefreshLoadoutSlotInternal doesn't run when editing a loadout that isn't the featured one before removing this.
	Newness_IfNecessaryMarkItemFlavorAsNoLongerNewAndInformServer( character )
	EmitUISound( "UI_Menu_Legend_Select" )
	AdvanceMenu( GetMenu( "CustomizeCharacterMenu" ) )
}


void function CharacterButton_OnRightClick( var button )
{
	OpenCharacterSkillsDialog( file.buttonToCharacter[button] )
}


void function CharacterButton_OnMiddleClick( var button )
{
	if ( Hud_IsLocked( button ) )
		JumpToStoreCharacterFromButton( button )
	else
		SetFeaturedCharacterFromButton( button )
}


void function PresentCharacter( ItemFlavor character )
{
	if ( file.presentedCharacter == character )
		return

	RuiSetString( file.characterSelectInfoRui, "nameText", Localize( ItemFlavor_GetLongName( character ) ).toupper() )
	RuiSetString( file.characterSelectInfoRui, "subtitleText", Localize( CharacterClass_GetCharacterSelectSubtitle( character ) ) )
	RuiSetGameTime( file.characterSelectInfoRui, "initTime", Time() )

	ItemFlavor characterSkin = LoadoutSlot_GetItemFlavor( LocalClientEHI(), Loadout_CharacterSkin( character ) )
	RunClientScript( "UIToClient_PreviewCharacterSkin", ItemFlavor_GetNetworkIndex_DEPRECATED( characterSkin ), ItemFlavor_GetNetworkIndex_DEPRECATED( character ) )

	file.presentedCharacter = character
}