global function InitArmoryPanel

struct
{
	var                       panel
	array<var>                buttons
	table<var, ItemFlavor>    buttonToCategory

	var miscCustomizeButton
} file

void function InitArmoryPanel( var panel )
{
	file.panel = panel
	file.buttons = GetPanelElementsByClassname( panel, "WeaponCategoryButtonClass" )
	Assert( file.buttons.len() == 6 )

	SetPanelTabTitle( panel, "#ARMORY" )
	SetPanelTabTitle( panel, "#LOADOUT" )
	Hud_SetY( file.buttons[0], 120 )

	AddPanelEventHandler( panel, eUIEvent.PANEL_SHOW, ArmoryPanel_OnShow )
	AddPanelEventHandler( panel, eUIEvent.PANEL_HIDE, ArmoryPanel_OnHide )
	AddPanelEventHandler_FocusChanged( panel, ArmoryPanel_OnFocusChanged )

	foreach ( button in file.buttons )
	{
		Hud_AddEventHandler( button, UIE_GET_FOCUS, CategoryButton_OnGetFocus )
		Hud_AddEventHandler( button, UIE_CLICK, CategoryButton_OnActivate )
	}

	file.miscCustomizeButton = Hud_GetChild( panel, "MiscCustomizeButton" )
	Hud_AddEventHandler( file.miscCustomizeButton, UIE_CLICK, MiscCustomizeButton_OnActivate )
	Hud_SetVisible( file.miscCustomizeButton, true )

	AddPanelFooterOption( panel, LEFT, BUTTON_B, true, "#B_BUTTON_BACK", "#B_BUTTON_BACK" )
	AddPanelFooterOption( panel, LEFT, BUTTON_A, false, "#A_BUTTON_CUSTOMIZE_WEAPON", "", null, IsButtonFocused )
}


bool function IsButtonFocused()
{
	if ( file.buttons.contains( GetFocus() ) )
		return true

	if ( GetFocus() == file.miscCustomizeButton )
		return true

	return false
}


void function ArmoryPanel_OnShow( var panel )
{
	file.buttonToCategory.clear()

	UI_SetPresentationType( ePresentationType.WEAPON_CATEGORY )

	array<ItemFlavor> categories = GetAllWeaponCategories()

	foreach ( index, button in file.buttons )
		CategoryButton_Init( button, categories[index] )

	MiscCustomizeButton_Init( file.miscCustomizeButton )
}


void function ArmoryPanel_OnHide( var panel )
{
	file.buttonToCategory.clear()
}


void function ArmoryPanel_OnFocusChanged( var panel, var oldFocus, var newFocus )
{
	if ( !IsValid( panel ) ) // uiscript_reset
		return

	if ( !newFocus || GetParentMenu( panel ) != GetActiveMenu() )
		return

	UpdateFooterOptions()
}


void function CategoryButton_Init( var button, ItemFlavor category )
{
	bool isNew = (Newness_ReverseQuery_GetNewCount( NEWNESS_QUERIES.WeaponCategoryButton[category] ) > 0)
	Hud_SetNew( button, isNew )

	var rui = Hud_GetRui( button )
	RuiSetString( rui, "buttonText", Localize( ItemFlavor_GetLongName( category ) ).toupper() )
	RuiSetImage( rui, "buttonImage", ItemFlavor_GetIcon( category ) )
	RuiSetInt( rui, "numPips", GetWeaponsInCategory( category ).len() )

	file.buttonToCategory[button] <- category
}


void function MiscCustomizeButton_Init( var button )
{
	bool isNew = (Newness_ReverseQuery_GetNewCount( NEWNESS_QUERIES.GameCustomizationButton ) > 0)
	Hud_SetNew( button, isNew )

	var rui = Hud_GetRui( button )
	RuiSetString( rui, "buttonText", Localize( "#MISC_CUSTOMIZATION" ).toupper() )
	RuiSetInt( rui, "numPips", 3 )
}


void function CategoryButton_OnGetFocus( var button )
{
	ItemFlavor category = file.buttonToCategory[button]

	printt( ItemFlavor_GetHumanReadableRef( category ) )
}


void function CategoryButton_OnActivate( var button )
{
	ItemFlavor category = file.buttonToCategory[button]
	SetTopLevelCustomizeContext( category )

	AdvanceMenu( GetMenu( "CustomizeWeaponMenu" ) )
}


void function MiscCustomizeButton_OnActivate( var button )
{
	AdvanceMenu( GetMenu( "MiscCustomizeMenu" ) )
}
