global function InitCharacterQuipsPanel

struct SectionDef
{
	var button
	var panel
}

struct
{
	var panel
	var headerRui

	array<SectionDef> sections
	int activeSectionIndex = 0

	ItemFlavor ornull lastNewnessCharacter
} file

void function InitCharacterQuipsPanel( var panel )
{
	file.panel = panel
	file.headerRui = Hud_GetRui( Hud_GetChild( panel, "Header" ) )

	SetPanelTabTitle( panel, "#QUIPS" )
	RuiSetString( file.headerRui, "title", "" )
	RuiSetString( file.headerRui, "collected", "" )

	AddPanelEventHandler( panel, eUIEvent.PANEL_SHOW, CharacterQuipsPanel_OnShow )
	AddPanelEventHandler( panel, eUIEvent.PANEL_HIDE, CharacterQuipsPanel_OnHide )

	//AddPanelFooterOption( panel, LEFT, BUTTON_DPAD_LEFT, false, "#TRIGGERS_CHANGE_LEGEND", "", CustomizeCharacterMenu_PrevButton_OnActivate )
	//AddPanelFooterOption( panel, LEFT, BUTTON_DPAD_RIGHT, false, "", "", CustomizeCharacterMenu_NextButton_OnActivate )
	//AddPanelFooterOption( panel, LEFT, BUTTON_TRIGGER_LEFT, false, "", "", CustomizeCharacterMenu_PrevButton_OnActivate )
	//AddPanelFooterOption( panel, LEFT, BUTTON_TRIGGER_RIGHT, false, "", "", CustomizeCharacterMenu_NextButton_OnActivate )

	AddCallback_OnTopLevelCustomizeContextChanged( panel, CharacterQuipsPanel_OnCustomizeContextChanged )

	int buttonNum = 0

	{
		SectionDef section
		section.button = Hud_GetChild( panel, "SectionButton" + buttonNum )
		HudElem_SetRuiArg( section.button, "buttonText", Localize( "#INTRO" ) )
		section.panel = Hud_GetChild( panel, "IntroQuipsPanel" )
		file.sections.append( section )
		buttonNum++
	}

	{
		SectionDef section
		section.button = Hud_GetChild( panel, "SectionButton" + buttonNum )
		HudElem_SetRuiArg( section.button, "buttonText", Localize( "#KILL" ) )
		section.panel = Hud_GetChild( panel, "KillQuipsPanel" )
		file.sections.append( section )
		buttonNum++
	}

	foreach ( sectionDef in file.sections )
	{
		Hud_SetVisible( sectionDef.button, true )
		Hud_SetSelected( sectionDef.button, false )
		Hud_SetVisible( sectionDef.panel, false )
		Hud_AddEventHandler( sectionDef.button, UIE_CLICK, QuipSectionButton_Activate )
	}
}

void function CharacterQuipsPanel_OnNavUp( var panel )
{
	int activeIndex = QuipSections_GetActive()
	if ( activeIndex <= 0 )
		return

	QuipSectionButton_Activate( file.sections[activeIndex - 1].button )
}

void function CharacterQuipsPanel_OnNavDown( var panel )
{
	int activeIndex = QuipSections_GetActive()
	if ( activeIndex < 0 || activeIndex == QuipSections_GetCount() - 1 )
		return

	QuipSectionButton_Activate( file.sections[activeIndex + 1].button )
}

int function QuipSections_GetActive()
{
	foreach ( index, sectionDef in file.sections )
	{
		if ( Hud_IsSelected( sectionDef.button ) )
			return index
	}

	return -1
}

int function QuipSections_GetCount()
{
	return file.sections.len()
}

void function QuipSectionButton_Activate( var button )
{
	Hud_SetSelected( button, true )

	var panel

	foreach ( sectionIndex, sectionDef in file.sections )
	{
		bool isActivated = sectionDef.button == button
		if ( isActivated )
		{
			panel = sectionDef.panel
			file.activeSectionIndex = sectionIndex
		}

		Hud_SetSelected( sectionDef.button, isActivated )
	}

	ActivatePanel( panel )
}

void function ActivatePanel( var panel )
{
	HideVisibleSectionPanels()

	if ( panel )
		ShowPanel( panel )
}

void function HideVisibleSectionPanels()
{
	array<var> panels
	foreach ( sectionDef in file.sections )
		panels.append( sectionDef.panel )

	foreach ( panel in panels )
	{
		if ( Hud_IsVisible( panel ) )
			HidePanel( panel )
	}
}

void function CharacterQuipsPanel_OnShow( var panel )
{
	UI_SetPresentationType( ePresentationType.CHARACTER_QUIPS )

	file.activeSectionIndex = 0

	CharacterQuipsPanel_Update()
}

void function CharacterQuipsPanel_OnCustomizeContextChanged( var panel )
{
	CharacterQuipsPanel_Update()
}

void function CharacterQuipsPanel_Update()
{
	QuipSectionButton_Activate( file.sections[file.activeSectionIndex].button )
	UpdateNewnessCallbacks()

	ItemFlavor character = GetTopLevelCustomizeContext()
	ItemFlavor characterSkin = LoadoutSlot_GetItemFlavor( LocalClientEHI(), Loadout_CharacterSkin( character ) )
	RunClientScript( "UIToClient_PreviewCharacterSkin", ItemFlavor_GetNetworkIndex_DEPRECATED( characterSkin ), ItemFlavor_GetNetworkIndex_DEPRECATED( character ) )
}

void function CharacterQuipsPanel_OnHide( var panel )
{
	ClearNewnessCallbacks()
	HideVisibleSectionPanels()
}

void function UpdateNewnessCallbacks()
{
	if ( !IsTopLevelCustomizeContextValid() )
		return

	ClearNewnessCallbacks()

	ItemFlavor character = GetTopLevelCustomizeContext()
	Newness_AddCallbackAndCallNow_OnRerverseQueryUpdated( NEWNESS_QUERIES.CharacterIntroQuipSectionButton[character], OnNewnessQueryChangedUpdateButton, Hud_GetChild( file.panel, "SectionButton0" ) )
	Newness_AddCallbackAndCallNow_OnRerverseQueryUpdated( NEWNESS_QUERIES.CharacterKillQuipSectionButton[character], OnNewnessQueryChangedUpdateButton, Hud_GetChild( file.panel, "SectionButton1" ) )
	file.lastNewnessCharacter = character
}

void function ClearNewnessCallbacks()
{
	if ( file.lastNewnessCharacter == null )
		return

	Newness_RemoveCallback_OnRerverseQueryUpdated( NEWNESS_QUERIES.CharacterIntroQuipSectionButton[expect ItemFlavor( file.lastNewnessCharacter )], OnNewnessQueryChangedUpdateButton, Hud_GetChild( file.panel, "SectionButton0" ) )
	Newness_RemoveCallback_OnRerverseQueryUpdated( NEWNESS_QUERIES.CharacterKillQuipSectionButton[expect ItemFlavor( file.lastNewnessCharacter )], OnNewnessQueryChangedUpdateButton, Hud_GetChild( file.panel, "SectionButton1" ) )
	file.lastNewnessCharacter = null
}