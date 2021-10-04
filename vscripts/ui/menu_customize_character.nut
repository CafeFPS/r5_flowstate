global function InitCustomizeCharacterMenu
global function CustomizeCharacterMenu_NextButton_OnActivate
global function CustomizeCharacterMenu_PrevButton_OnActivate

global function CustomizeCharacterMenu_SetCharacter

struct
{
	var menu
	var titleRui
	var decorationRui

	var prevButton
	var nextButton

	bool tabsInitialized = false

	ItemFlavor ornull characterOrNull = null
} file

const bool NEXT = true
const bool PREV = false

void function InitCustomizeCharacterMenu( var newMenuArg )
{
	var menu = GetMenu( "CustomizeCharacterMenu" )
	file.menu = menu

	SetTabRightSound( menu, "UI_Menu_LegendTab_Select" )
	SetTabLeftSound( menu, "UI_Menu_LegendTab_Select" )

	file.titleRui = Hud_GetRui( Hud_GetChild( menu, "Title" ) )
	file.decorationRui = Hud_GetRui( Hud_GetChild( menu, "Decoration" ) )

	file.prevButton = Hud_GetChild( menu, "PrevButton" )
	HudElem_SetRuiArg( file.prevButton, "flipHorizontal", true )
	Hud_AddEventHandler( file.prevButton, UIE_CLICK, CustomizeCharacterMenu_PrevButton_OnActivate )

	file.nextButton = Hud_GetChild( menu, "NextButton" )
	Hud_AddEventHandler( file.nextButton, UIE_CLICK, CustomizeCharacterMenu_NextButton_OnActivate )

	AddMenuEventHandler( menu, eUIEvent.MENU_OPEN, CustomizeCharacterMenu_OnOpen )
	AddMenuEventHandler( menu, eUIEvent.MENU_CLOSE, CustomizeCharacterMenu_OnClose )
	AddMenuEventHandler( menu, eUIEvent.MENU_NAVIGATE_BACK, CustomizeCharacterMenu_OnNavigateBack )
}


void function CustomizeCharacterMenu_SetCharacter( ItemFlavor character )
{
	file.characterOrNull = character
}


void function CustomizeCharacterMenu_OnOpen()
{
	if ( !file.tabsInitialized )
	{
		array<var> panels = GetMenuTabBodyPanels( file.menu )
		foreach ( panel in panels )
			AddTab( file.menu, panel, GetPanelTabTitle( panel ) )

		file.tabsInitialized = true
	}

	Assert( file.characterOrNull != null, "CustomizeCharacterMenu_SetCharacter must be called before advancing to " + Hud_GetHudName( file.menu ) )
	ItemFlavor character = expect ItemFlavor( file.characterOrNull )
	SetTopLevelCustomizeContext( character )

	if ( uiGlobal.lastMenuNavDirection == MENU_NAV_FORWARD )
	{
		TabData tabData = GetTabDataForPanel( file.menu )
		ActivateTab( tabData, 0 )
	}
	//else
	//	ActivateTab( file.menu, GetMenuActiveTabIndex( file.menu ) )

	RuiSetString( file.titleRui, "title", Localize( ItemFlavor_GetLongName( character ) ).toupper() )
	RuiSetGameTime( file.decorationRui, "initTime", Time() )

	RegisterNewnessCallbacks( character )

}


void function CustomizeCharacterMenu_OnClose()
{
	ItemFlavor character = expect ItemFlavor( file.characterOrNull )
	DeregisterNewnessCallbacks( character )

	file.characterOrNull = null
	SetTopLevelCustomizeContext( null )

	RunMenuClientFunction( "ClearAllCharacterPreview" )
}


void function RegisterNewnessCallbacks( ItemFlavor character )
{
	string cardPanelString = "CharacterCardsPanelV2"
	Newness_AddCallbackAndCallNow_OnRerverseQueryUpdated( NEWNESS_QUERIES.CharacterSkinsTab[character], OnNewnessQueryChangedUpdatePanelTab, GetPanel( "CharacterSkinsPanel" ) )
	Newness_AddCallbackAndCallNow_OnRerverseQueryUpdated( NEWNESS_QUERIES.CharacterCardTab[character], OnNewnessQueryChangedUpdatePanelTab, GetPanel( cardPanelString ) )
	//Newness_AddCallbackAndCallNow_OnRerverseQueryUpdated( NEWNESS_QUERIES.CharacterQuipsTab[character], OnNewnessQueryChangedUpdatePanelTab, GetPanel( "CharacterQuipsPanel" ) )
	Newness_AddCallbackAndCallNow_OnRerverseQueryUpdated( NEWNESS_QUERIES.CharacterFinishersTab[character], OnNewnessQueryChangedUpdatePanelTab, GetPanel( "CharacterExecutionsPanel" ) )
}


void function DeregisterNewnessCallbacks( ItemFlavor character )
{
	string cardPanelString = "CharacterCardsPanelV2"
	Newness_RemoveCallback_OnRerverseQueryUpdated( NEWNESS_QUERIES.CharacterSkinsTab[character], OnNewnessQueryChangedUpdatePanelTab, GetPanel( "CharacterSkinsPanel" ) )
	Newness_RemoveCallback_OnRerverseQueryUpdated( NEWNESS_QUERIES.CharacterCardTab[character], OnNewnessQueryChangedUpdatePanelTab, GetPanel( cardPanelString ) )
	//Newness_RemoveCallback_OnRerverseQueryUpdated( NEWNESS_QUERIES.CharacterQuipsTab[character], OnNewnessQueryChangedUpdatePanelTab, GetPanel( "CharacterQuipsPanel" ) )
	Newness_RemoveCallback_OnRerverseQueryUpdated( NEWNESS_QUERIES.CharacterFinishersTab[character], OnNewnessQueryChangedUpdatePanelTab, GetPanel( "CharacterExecutionsPanel" ) )
}


void function CustomizeCharacterMenu_OnNavigateBack()
{
	Assert( GetActiveMenu() == file.menu )

	CloseActiveMenu()
}


void function CustomizeCharacterMenu_PrevButton_OnActivate( var button )
{
	SwitchCharacters( PREV )
}


void function CustomizeCharacterMenu_NextButton_OnActivate( var button )
{
	SwitchCharacters( NEXT )
}


void function SwitchCharacters( bool direction )
{
	Assert( direction == NEXT || direction == PREV )
	Assert( file.characterOrNull != null )
	ItemFlavor currentCharacter = expect ItemFlavor(file.characterOrNull)
	DeregisterNewnessCallbacks( currentCharacter )

	array<ItemFlavor> allCharacters = GetAllCharacters()
	int index = allCharacters.find( currentCharacter )
	ItemFlavor nextCharacter

	if ( direction == NEXT )
	{
		if ( index + 1 < allCharacters.len() )
			nextCharacter = allCharacters[index + 1]
		else
			nextCharacter = allCharacters[0]
	}
	else
	{
		if ( index - 1 >= 0 )
			nextCharacter = allCharacters[index - 1]
		else
			nextCharacter = allCharacters[allCharacters.len() - 1]
	}

	RegisterNewnessCallbacks( nextCharacter )
	file.characterOrNull = nextCharacter
	SetTopLevelCustomizeContext( nextCharacter )
	RuiSetString( file.titleRui, "title", Localize( ItemFlavor_GetLongName( nextCharacter ) ).toupper() )
}


