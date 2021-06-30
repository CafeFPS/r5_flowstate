#if(true)

global function InitCharacterEmotesPanel
global function SetEmotePropertyIndex
global function GetEmotePropertyIndex

struct SectionDef
{
	var button
	var panel
	int index
}

struct
{
	var panel
	var headerRui

	array<SectionDef> sections
	int               activeSectionIndex = 0
	int               propertyIndex = 0

	ItemFlavor ornull lastNewnessCharacter

	//
	//
	//
	//
} file

void function InitCharacterEmotesPanel( var panel )
{
	file.panel = panel
	file.headerRui = Hud_GetRui( Hud_GetChild( panel, "Header" ) )

	SetPanelTabTitle( panel, "#CHAT_WHEEL" )
	RuiSetString( file.headerRui, "title", "" )
	RuiSetString( file.headerRui, "collected", "" )

	AddPanelEventHandler( panel, eUIEvent.PANEL_SHOW, EmotesPanel_OnShow )
	AddPanelEventHandler( panel, eUIEvent.PANEL_HIDE, EmotesPanel_OnHide )

	AddCallback_OnTopLevelCustomizeContextChanged( panel, EmotesPanel_OnCustomizeContextChanged )

	int buttonNum = 0

	for ( int i=0; i<MAX_QUIPS_EQUIPPED; i++ )
	{
		SectionDef section
		section.button = Hud_GetChild( panel, "SectionButton" + buttonNum )
		Hud_SetEnabled( section.button, false )
		HudElem_SetRuiArg( section.button, "buttonText", Localize( "#QUIP_N", buttonNum+1 ) )
		section.panel = Hud_GetChild( panel, "QuipsPanel" )
		section.index = buttonNum
		file.sections.append( section )
		buttonNum++
	}

	foreach ( sectionDef in file.sections )
	{
		Hud_SetVisible( sectionDef.button, true )
		Hud_SetSelected( sectionDef.button, false )
		Hud_SetVisible( sectionDef.panel, false )
		Hud_AddEventHandler( sectionDef.button, UIE_CLICK, SectionButton_Activate )
	}

	Hud_EnableKeyBindingIcons( Hud_GetChild( file.panel, "HintMKB" ) )
	Hud_EnableKeyBindingIcons( Hud_GetChild( file.panel, "HintGamepad" ) )
	HudElem_SetRuiArg( Hud_GetChild( file.panel, "HintMKB" ), "textBreakWidth", 400.0 )
	HudElem_SetRuiArg( Hud_GetChild( file.panel, "HintGamepad" ), "textBreakWidth", 400.0 )
}

void function SectionButton_Activate( var button )
{
	//

	var panel

	foreach ( sectionIndex, sectionDef in file.sections )
	{
		bool isActivated = sectionDef.button == button
		if ( isActivated )
		{
			panel = sectionDef.panel
			file.activeSectionIndex = sectionIndex
			SetEmotePropertyIndex( sectionDef.index )
		}

		//
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


void function EmotesPanel_OnShow( var panel )
{
	UI_SetPresentationType( ePresentationType.CHARACTER_QUIPS )

	file.activeSectionIndex = 0

	CharacterEmotesPanel_Update()

	for ( int i=0; i<MAX_QUIPS_EQUIPPED; i++ )
		AddCallback_ItemFlavorLoadoutSlotDidChange_SpecificPlayer( LocalClientEHI(), Loadout_CharacterQuip( GetTopLevelCustomizeContext(), i ), OnEmoteChanged )

	RunClientScript( "SetHintTextOnHudElem", Hud_GetChild( panel, "HintMKB" ), "#HINT_QUIP_WHEEL_MKB" )
	RunClientScript( "SetHintTextOnHudElem", Hud_GetChild( panel, "HintGamepad" ), "#HINT_QUIP_WHEEL_GAMEPAD" )
}

void function OnEmoteChanged( EHI playerEHI, ItemFlavor flavor )
{
	UpdateSectionTitles()
}

void function UpdateSectionTitles()
{
	for ( int i=0; i<MAX_QUIPS_EQUIPPED; i++ )
	{
		var button = file.sections[i].button

		ItemFlavor character = GetTopLevelCustomizeContext()
		LoadoutEntry entry = Loadout_CharacterQuip( character, i )
		ItemFlavor flav = LoadoutSlot_GetItemFlavor( LocalClientEHI(), entry )

		if ( CharacterQuip_IsTheEmpty( flav ) )
		{
			HudElem_SetRuiArg( button, "buttonText", Localize( "#QUIP_N", i + 1 ) )
		}
		else
		{
			HudElem_SetRuiArg( button, "buttonText", Localize( "#QUIP_ITEM", Localize( ItemFlavor_GetLongName( flav ) ) ) )
		}
	}
}

void function EmotesPanel_OnCustomizeContextChanged( var panel )
{
	if ( !IsPanelActive( file.panel ) )
		return

	CharacterEmotesPanel_Update()
}


void function CharacterEmotesPanel_Update()
{
	SectionButton_Activate( file.sections[file.activeSectionIndex].button )
	UpdateNewnessCallbacks()
	UpdateSectionTitles()
	ItemFlavor character = GetTopLevelCustomizeContext()
	ItemFlavor characterSkin = LoadoutSlot_GetItemFlavor( LocalClientEHI(), Loadout_CharacterSkin( character ) )
	RunClientScript( "UIToClient_PreviewCharacterSkin", ItemFlavor_GetNetworkIndex_DEPRECATED( characterSkin ), ItemFlavor_GetNetworkIndex_DEPRECATED( character ) )
}


void function EmotesPanel_OnHide( var panel )
{
	ClearNewnessCallbacks()
	HideVisibleSectionPanels()

	for ( int i=0; i<MAX_QUIPS_EQUIPPED; i++ )
		RemoveCallback_ItemFlavorLoadoutSlotDidChange_SpecificPlayer( LocalClientEHI(), Loadout_CharacterQuip( GetTopLevelCustomizeContext(), i ), OnEmoteChanged )
}


void function SetEmotePropertyIndex( int propertyIndex )
{
	file.propertyIndex = propertyIndex
}


int function GetEmotePropertyIndex()
{
	return file.propertyIndex
}


void function UpdateNewnessCallbacks()
{
	if ( !IsTopLevelCustomizeContextValid() )
		return

	ClearNewnessCallbacks()

	ItemFlavor character = GetTopLevelCustomizeContext()
	//
	file.lastNewnessCharacter = character
}


void function ClearNewnessCallbacks()
{
	if ( file.lastNewnessCharacter == null )
		return

	//
	file.lastNewnessCharacter = null
}

#endif