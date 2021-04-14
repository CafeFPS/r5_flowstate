global function InitArmoryPanel

struct
{
	var                    panel
	array<var>             buttons
	table<var, ItemFlavor> buttonToCategory
} file

void function InitArmoryPanel( var panel )
{
	file.panel = panel
	file.buttons = GetPanelElementsByClassname( panel, "WeaponCategoryButtonClass" )
	Assert( file.buttons.len() == 6 )

	SetPanelTabTitle( panel, "#ARMORY" )
	AddPanelEventHandler( panel, eUIEvent.PANEL_SHOW, ArmoryPanel_OnShow )
	AddPanelEventHandler( panel, eUIEvent.PANEL_HIDE, ArmoryPanel_OnHide )
	AddPanelEventHandler_FocusChanged( panel, ArmoryPanel_OnFocusChanged )

	foreach ( button in file.buttons )
	{
		Hud_AddEventHandler( button, UIE_GET_FOCUS, CategoryButton_OnGetFocus )
		Hud_AddEventHandler( button, UIE_CLICK, CategoryButton_OnActivate )
	}

	AddPanelFooterOption( panel, LEFT, BUTTON_B, true, "#B_BUTTON_BACK", "#B_BUTTON_BACK" )
	AddPanelFooterOption( panel, LEFT, BUTTON_A, false, "#A_BUTTON_CUSTOMIZE_WEAPON", "", null, IsCategoryButtonFocused )
}


bool function IsCategoryButtonFocused()
{
	if ( file.buttons.contains( GetFocus() ) )
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
}


void function ArmoryPanel_OnHide( var panel )
{
	file.buttonToCategory.clear()
}


void function ArmoryPanel_OnFocusChanged( var panel, var oldFocus, var newFocus )
{
	if ( !IsValid( panel ) ) // uiscript_reset
		return
	if ( GetParentMenu( panel ) != GetActiveMenu() )
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
