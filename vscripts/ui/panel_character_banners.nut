/*
global function InitCharacterCardsPanel
//global function CardFrameButton_UpdateRui
//global function CardPoseButton_UpdateRui
//global function CardBadgeButton_UpdateRui
//global function CardStatButton_UpdateRui
global function SetCardPropertyIndex
global function GetCardPropertyIndex

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

	array<SectionDef> cardSections
	int               activeSectionIndex = 0
	int               propertyIndex = 0
	var               combinedCard

	ItemFlavor ornull lastNewnessCharacter

	//var frameHeaderRui
	//var poseHeaderRui
	//var badgesHeaderRui
	//var statsHeaderRui
} file

void function InitCharacterCardsPanel( var panel )
{
	file.panel = panel
	file.headerRui = Hud_GetRui( Hud_GetChild( panel, "Header" ) )

	SetPanelTabTitle( panel, "#BANNER" )
	RuiSetString( file.headerRui, "title", Localize( "#BANNER" ).toupper() )
	RuiSetString( file.headerRui, "collected", "" )

	AddPanelEventHandler( panel, eUIEvent.PANEL_SHOW, CharacterCardsPanel_OnShow )
	AddPanelEventHandler( panel, eUIEvent.PANEL_HIDE, CharacterCardsPanel_OnHide )

	//AddPanelFooterOption( panel, LEFT, BUTTON_DPAD_LEFT, false, "#TRIGGERS_CHANGE_LEGEND", "", CustomizeCharacterMenu_PrevButton_OnActivate )
	//AddPanelFooterOption( panel, LEFT, BUTTON_DPAD_RIGHT, false, "", "", CustomizeCharacterMenu_NextButton_OnActivate )
	//AddPanelFooterOption( panel, LEFT, BUTTON_TRIGGER_LEFT, false, "", "", CustomizeCharacterMenu_PrevButton_OnActivate )
	//AddPanelFooterOption( panel, LEFT, BUTTON_TRIGGER_RIGHT, false, "", "", CustomizeCharacterMenu_NextButton_OnActivate )

	//file.frameHeaderRui = Hud_GetRui( Hud_GetChild( panel, "FrameHeader" ) )
	//RuiSetString( file.frameHeaderRui, "title", "FRAMES" )
	//
	//file.poseHeaderRui = Hud_GetRui( Hud_GetChild( panel, "PoseHeader" ) )
	//RuiSetString( file.poseHeaderRui, "title", "POSES" )

	//file.badgesHeaderRui = Hud_GetRui( Hud_GetChild( panel, "BadgesHeader" ) )
	//RuiSetString( file.badgesHeaderRui, "title", "BADGES" )

	//file.statsHeaderRui = Hud_GetRui( Hud_GetChild( panel, "StatsHeader" ) )
	//RuiSetString( file.statsHeaderRui, "title", "STATS" )

	file.combinedCard = Hud_GetChild( panel, "CombinedCard" )

	AddCallback_OnTopLevelCustomizeContextChanged( panel, CharacterCardsPanel_OnCustomizeContextChanged )

	int buttonNum = 0

	{
		SectionDef section
		section.button = Hud_GetChild( panel, "SectionButton" + buttonNum )
		HudElem_SetRuiArg( section.button, "buttonText", Localize( "#FRAME" ) )
		section.panel = Hud_GetChild( panel, "CardFramesPanel" )
		section.index = 0
		file.cardSections.append( section )
		buttonNum++
	}

	{
		SectionDef section
		section.button = Hud_GetChild( panel, "SectionButton" + buttonNum )
		HudElem_SetRuiArg( section.button, "buttonText", Localize( "#POSE" ) )
		section.panel = Hud_GetChild( panel, "CardPosesPanel" )
		section.index = 0
		file.cardSections.append( section )
		buttonNum++
	}

	{
		SectionDef section
		section.button = Hud_GetChild( panel, "SectionButton" + buttonNum )
		HudElem_SetRuiArg( section.button, "buttonText", Localize( "#BADGE_N", 1 ) )
		section.panel = Hud_GetChild( panel, "CardBadgesPanel" )
		section.index = 0
		file.cardSections.append( section )
		buttonNum++
	}

	{
		SectionDef section
		section.button = Hud_GetChild( panel, "SectionButton" + buttonNum )
		HudElem_SetRuiArg( section.button, "buttonText", Localize( "#BADGE_N", 2 ) )
		section.panel = Hud_GetChild( panel, "CardBadgesPanel" )
		section.index = 1
		file.cardSections.append( section )
		buttonNum++
	}

	{
		SectionDef section
		section.button = Hud_GetChild( panel, "SectionButton" + buttonNum )
		HudElem_SetRuiArg( section.button, "buttonText", Localize( "#BADGE_N", 3 ) )
		section.panel = Hud_GetChild( panel, "CardBadgesPanel" )
		section.index = 2
		file.cardSections.append( section )
		buttonNum++
	}

	{
		SectionDef section
		section.button = Hud_GetChild( panel, "SectionButton" + buttonNum )
		HudElem_SetRuiArg( section.button, "buttonText", Localize( "#TRACKER_N", 1 ) )
		section.panel = Hud_GetChild( panel, "CardTrackersPanel" )
		section.index = 0
		file.cardSections.append( section )
		buttonNum++
	}

	{
		SectionDef section
		section.button = Hud_GetChild( panel, "SectionButton" + buttonNum )
		HudElem_SetRuiArg( section.button, "buttonText", Localize( "#TRACKER_N", 2 ) )
		section.panel = Hud_GetChild( panel, "CardTrackersPanel" )
		section.index = 1
		file.cardSections.append( section )
		buttonNum++
	}

	{
		SectionDef section
		section.button = Hud_GetChild( panel, "SectionButton" + buttonNum )
		HudElem_SetRuiArg( section.button, "buttonText", Localize( "#TRACKER_N", 3 ) )
		section.panel = Hud_GetChild( panel, "CardTrackersPanel" )
		section.index = 2
		file.cardSections.append( section )
		buttonNum++
	}

	foreach ( sectionDef in file.cardSections )
	{
		Hud_SetVisible( sectionDef.button, true )
		Hud_SetSelected( sectionDef.button, false )
		Hud_SetVisible( sectionDef.panel, false )
		Hud_AddEventHandler( sectionDef.button, UIE_CLICK, CardSectionButton_Activate )
	}
}


void function CharacterCardsPanel_OnNavUp( var panel )
{
	int activeIndex = CardSections_GetActive()
	if ( activeIndex <= 0 )
		return

	CardSectionButton_Activate( file.cardSections[activeIndex - 1].button )
}


void function CharacterCardsPanel_OnNavDown( var panel )
{
	int activeIndex = CardSections_GetActive()
	if ( activeIndex < 0 || activeIndex == CardSections_GetCount() - 1 )
		return

	CardSectionButton_Activate( file.cardSections[activeIndex + 1].button )
}


int function CardSections_GetActive()
{
	foreach ( index, sectionDef in file.cardSections )
	{
		if ( Hud_IsSelected( sectionDef.button ) )
			return index
	}

	return -1
}


int function CardSections_GetCount()
{
	return file.cardSections.len()
}


void function CardSectionButton_Activate( var button )
{
	Hud_SetSelected( button, true )

	var panel

	foreach ( sectionIndex, sectionDef in file.cardSections )
	{
		bool isActivated = sectionDef.button == button
		if ( isActivated )
		{
			panel = sectionDef.panel
			file.activeSectionIndex = sectionIndex
			SetCardPropertyIndex( sectionDef.index )
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
	foreach ( sectionDef in file.cardSections )
		panels.append( sectionDef.panel )

	foreach ( panel in panels )
	{
		if ( Hud_IsVisible( panel ) )
			HidePanel( panel )
	}
}


void function CharacterCardsPanel_OnShow( var panel )
{
	UI_SetPresentationType( ePresentationType.CHARACTER_CARD )

	//int activeIndex = CardSections_GetActive()
	//if ( activeIndex < 0 )
	//	activeIndex = 0
	//
	//if ( uiGlobal.lastMenuNavDirection == MENU_NAV_FORWARD )
	//	activeIndex = 0
	//
	//CardSectionButton_Activate( file.cardSections[0].button )
	file.activeSectionIndex = 0

	CharacterCardsPanel_Update()
}


void function CharacterCardsPanel_OnCustomizeContextChanged( var panel )
{
	if ( !IsPanelActive( file.panel ) )
		return

	CharacterCardsPanel_Update()
}


void function CharacterCardsPanel_Update()
{
	//LoadoutEntry frameEntry = Loadout_GladiatorCardFrame( GetCustomizeContext() )
	//int ownedFrames = GetUnlockedItemFlavorsForLoadoutSlot( LocalClientEHI(), frameEntry ).len()
	//int totalFrames = GetValidItemFlavorsForLoadoutSlot( LocalClientEHI(), frameEntry ).len()
	//
	//LoadoutEntry poseEntry = Loadout_GladiatorCardStance( GetCustomizeContext() )
	//int ownedPoses = GetUnlockedItemFlavorsForLoadoutSlot( LocalClientEHI(), poseEntry ).len()
	//int totalPoses = GetValidItemFlavorsForLoadoutSlot( LocalClientEHI(), poseEntry ).len()
	//
	//LoadoutEntry badgeEntry = Loadout_GladiatorCardBadge( GetCustomizeContext(), 0 )
	//int ownedBadges = GetUnlockedItemFlavorsForLoadoutSlot( LocalClientEHI(), badgeEntry ).len()
	//int totalBadges = GetValidItemFlavorsForLoadoutSlot( LocalClientEHI(), badgeEntry ).len()
	//
	//RuiSetString( file.frameHeaderRui, "detail", ownedFrames + " / " + totalFrames )
	//RuiSetString( file.poseHeaderRui, "detail", ownedPoses + " / " + totalPoses )
	//RuiSetString( file.badgesHeaderRui, "detail", ownedBadges + " / " + totalBadges )
	//RuiSetString( file.statsHeaderRui, "detail", "? / ?" )

	SetupMenuGladCard( file.combinedCard, "card", true )
	SendMenuGladCardPreviewCommand( eGladCardPreviewCommandType.CHARACTER, 0, GetTopLevelCustomizeContext() )

	CardSectionButton_Activate( file.cardSections[file.activeSectionIndex].button )
	UpdateNewnessCallbacks()
}


void function CharacterCardsPanel_OnHide( var panel )
{
	ClearNewnessCallbacks()
	HideVisibleSectionPanels()

	SetupMenuGladCard( null, "", true )
}


void function SetCardPropertyIndex( int propertyIndex )
{
	file.propertyIndex = propertyIndex
}


int function GetCardPropertyIndex()
{
	return file.propertyIndex
}


void function UpdateNewnessCallbacks()
{
	if ( !IsTopLevelCustomizeContextValid() )
		return

	ClearNewnessCallbacks()

	ItemFlavor character = GetTopLevelCustomizeContext()
	Newness_AddCallbackAndCallNow_OnRerverseQueryUpdated( NEWNESS_QUERIES.GCardFramesSectionButton[character], OnNewnessQueryChangedUpdateButton, Hud_GetChild( file.panel, "SectionButton0" ) )
	Newness_AddCallbackAndCallNow_OnRerverseQueryUpdated( NEWNESS_QUERIES.GCardStancesSectionButton[character], OnNewnessQueryChangedUpdateButton, Hud_GetChild( file.panel, "SectionButton1" ) )
	//Newness_AddCallbackAndCallNow_OnRerverseQueryUpdated( NEWNESS_QUERIES.GCardBadgesSectionButton[character], OnNewnessQueryChangedUpdateButton, Hud_GetChild( file.panel, "SectionButton2" ) )
	//Newness_AddCallbackAndCallNow_OnRerverseQueryUpdated( NEWNESS_QUERIES.GCardBadgesSectionButton[character], OnNewnessQueryChangedUpdateButton, Hud_GetChild( file.panel, "SectionButton3" ) )
	//Newness_AddCallbackAndCallNow_OnRerverseQueryUpdated( NEWNESS_QUERIES.GCardBadgesSectionButton[character], OnNewnessQueryChangedUpdateButton, Hud_GetChild( file.panel, "SectionButton4" ) )
	Newness_AddCallbackAndCallNow_OnRerverseQueryUpdated( NEWNESS_QUERIES.GCardTrackersSectionButton[character], OnNewnessQueryChangedUpdateButton, Hud_GetChild( file.panel, "SectionButton5" ) )
	Newness_AddCallbackAndCallNow_OnRerverseQueryUpdated( NEWNESS_QUERIES.GCardTrackersSectionButton[character], OnNewnessQueryChangedUpdateButton, Hud_GetChild( file.panel, "SectionButton6" ) )
	Newness_AddCallbackAndCallNow_OnRerverseQueryUpdated( NEWNESS_QUERIES.GCardTrackersSectionButton[character], OnNewnessQueryChangedUpdateButton, Hud_GetChild( file.panel, "SectionButton7" ) )
	file.lastNewnessCharacter = character
}


void function ClearNewnessCallbacks()
{
	if ( file.lastNewnessCharacter == null )
		return

	Newness_RemoveCallback_OnRerverseQueryUpdated( NEWNESS_QUERIES.GCardFramesSectionButton[expect ItemFlavor( file.lastNewnessCharacter )], OnNewnessQueryChangedUpdateButton, Hud_GetChild( file.panel, "SectionButton0" ) )
	Newness_RemoveCallback_OnRerverseQueryUpdated( NEWNESS_QUERIES.GCardStancesSectionButton[expect ItemFlavor( file.lastNewnessCharacter )], OnNewnessQueryChangedUpdateButton, Hud_GetChild( file.panel, "SectionButton1" ) )
	//Newness_RemoveCallback_OnRerverseQueryUpdated( NEWNESS_QUERIES.GCardBadgesSectionButton[expect ItemFlavor( file.lastNewnessCharacter )], OnNewnessQueryChangedUpdateButton, Hud_GetChild( file.panel, "SectionButton2" ) )
	//Newness_RemoveCallback_OnRerverseQueryUpdated( NEWNESS_QUERIES.GCardBadgesSectionButton[expect ItemFlavor( file.lastNewnessCharacter )], OnNewnessQueryChangedUpdateButton, Hud_GetChild( file.panel, "SectionButton3" ) )
	//Newness_RemoveCallback_OnRerverseQueryUpdated( NEWNESS_QUERIES.GCardBadgesSectionButton[expect ItemFlavor( file.lastNewnessCharacter )], OnNewnessQueryChangedUpdateButton, Hud_GetChild( file.panel, "SectionButton4" ) )
	Newness_RemoveCallback_OnRerverseQueryUpdated( NEWNESS_QUERIES.GCardTrackersSectionButton[expect ItemFlavor( file.lastNewnessCharacter )], OnNewnessQueryChangedUpdateButton, Hud_GetChild( file.panel, "SectionButton5" ) )
	Newness_RemoveCallback_OnRerverseQueryUpdated( NEWNESS_QUERIES.GCardTrackersSectionButton[expect ItemFlavor( file.lastNewnessCharacter )], OnNewnessQueryChangedUpdateButton, Hud_GetChild( file.panel, "SectionButton6" ) )
	Newness_RemoveCallback_OnRerverseQueryUpdated( NEWNESS_QUERIES.GCardTrackersSectionButton[expect ItemFlavor( file.lastNewnessCharacter )], OnNewnessQueryChangedUpdateButton, Hud_GetChild( file.panel, "SectionButton7" ) )
	file.lastNewnessCharacter = null
}
*/