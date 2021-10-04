//

global function InitRewardCeremonyMenu
global function ShowRewardCeremonyDialog

#if R5DEV
global function DEV_TestRewardCeremonyDialog
#endif


struct
{
	var menu
	var awardPanel
	var awardHeader
	var continueButton

	string                  headerText
	string                  titleText
	string                  descText
	array<BattlePassReward> displayAwards = []
	bool                    isForBattlePass

	table<var, BattlePassReward> buttonToItem

} file


void function InitRewardCeremonyMenu( var newMenuArg )
//
{
	var menu = GetMenu( "RewardCeremonyMenu" )
	file.menu = menu

	file.awardHeader = Hud_GetChild( menu, "Header" )
	file.awardPanel = Hud_GetChild( menu, "AwardsList" )

	AddMenuEventHandler( menu, eUIEvent.MENU_OPEN, PassAwardsDialog_OnOpen )
	AddMenuEventHandler( menu, eUIEvent.MENU_CLOSE, PassAwardsDialog_OnClose )

	file.continueButton = Hud_GetChild( menu, "ContinueButton" )
	Hud_AddEventHandler( file.continueButton, UIE_CLICK, ContinueButton_OnActivate )

	AddMenuFooterOption( menu, LEFT, BUTTON_B, true, "#B_BUTTON_BACK", "#B_BUTTON_BACK" )
}


void function ShowRewardCeremonyDialog( string headerText, string titleText, string descText, array<BattlePassReward> awards, bool isForBattlePass, bool playSound )
{
	file.headerText = headerText
	file.titleText = titleText
	file.descText = descText
	file.displayAwards = clone awards
	file.isForBattlePass = isForBattlePass
	AdvanceMenu( GetMenu( "RewardCeremonyMenu" ) )

	if ( playSound )
	{
		ItemFlavor ornull activeBattlePass = GetActiveBattlePass()
		if ( activeBattlePass != null )
		{
			expect ItemFlavor( activeBattlePass )
			EmitUISound( GetGlobalSettingsString( ItemFlavor_GetAsset( activeBattlePass ), "levelUpSound" ) )
		}
	}
}


#if R5DEV
void function DEV_TestRewardCeremonyDialog( string itemRef, string headerText = "HEADER", string titleText = "TITLE", string descText = "DESC" )
{
	BattlePassReward rewardInfo
	rewardInfo.level = -1
	rewardInfo.flav = GetItemFlavorByHumanReadableRef( itemRef )
	rewardInfo.quantity = 1
	ShowRewardCeremonyDialog(
		headerText,
		titleText,
		descText,
		[rewardInfo],
		false,
		true
	)
}
#endif


void function PassAwardsDialog_OnOpen()
{
	UI_SetPresentationType( ePresentationType.BATTLE_PASS )

	Assert( file.displayAwards.len() != 0 )

	if ( file.isForBattlePass )
	{
		ItemFlavor ornull bpFlav = GetPlayerLastActiveBattlePass( LocalClientEHI() )
		if ( bpFlav != null )
		{
			ClientCommand( format( "UpdateBattlePassLastEarnedXP %d", ItemFlavor_GetGUID( expect ItemFlavor(bpFlav) ) ) )
			ClientCommand( format( "UpdateBattlePassLastPurchasedXP %d", ItemFlavor_GetGUID( expect ItemFlavor(bpFlav) ) ) )
			ClientCommand( format( "UpdateBattlePassLastSeenPremium %d", ItemFlavor_GetGUID( expect ItemFlavor(bpFlav) ) ) )
		}
	}

	RegisterButtonPressedCallback( BUTTON_A, ContinueButton_OnActivate )
	RegisterButtonPressedCallback( KEY_SPACE, ContinueButton_OnActivate )

	PassAwardsDialog_UpdateAwards()
}


void function ContinueButton_OnActivate( var button )
{
	CloseActiveMenu()
}


void function PassAwardsDialog_OnClose()
{
	file.displayAwards = []

	DeregisterButtonPressedCallback( BUTTON_A, ContinueButton_OnActivate )
	DeregisterButtonPressedCallback( KEY_SPACE, ContinueButton_OnActivate )
}


void function PassAwardsDialog_UpdateAwards()
{
	HudElem_SetRuiArg( file.awardHeader, "headerText", file.headerText )
	HudElem_SetRuiArg( file.awardHeader, "titleText", file.titleText )
	HudElem_SetRuiArg( file.awardHeader, "descText", file.descText )

	var scrollPanel = Hud_GetChild( file.awardPanel, "ScrollPanel" )

	foreach ( button, _ in file.buttonToItem )
	{
		Hud_RemoveEventHandler( button, UIE_GET_FOCUS, PassAward_OnFocusAward )
	}
	file.buttonToItem.clear()

	int numAwards = file.displayAwards.len()

	bool showButtons = file.isForBattlePass
	if ( file.displayAwards.len() == 1 && ItemFlavor_GetType( file.displayAwards[0].flav ) == eItemType.account_currency )
		showButtons = true //

	int numButtons = numAwards
	if ( !showButtons )
	{
		numButtons = 0
		PresentItem( file.displayAwards[0].flav, file.displayAwards[0].level )
	}
	Hud_InitGridButtonsDetailed( file.awardPanel, numButtons, 1, maxint( 1, minint( numButtons, 8 ) ) )
	Hud_SetHeight( file.awardPanel, Hud_GetHeight( file.awardPanel ) * 1.3 )
	for ( int index = 0; index < numButtons; index++ )
	{
		var awardButton = Hud_GetChild( scrollPanel, "GridButton" + index )

		BattlePassReward bpReward = file.displayAwards[index]
		file.buttonToItem[awardButton] <- bpReward

		HudElem_SetRuiArg( awardButton, "isOwned", true )
		HudElem_SetRuiArg( awardButton, "isPremium", bpReward.isPremium )

		int rarity = ItemFlavor_HasQuality( bpReward.flav ) ? ItemFlavor_GetQuality( bpReward.flav ) : 0
		HudElem_SetRuiArg( awardButton, "itemCountString", "" )
		if ( bpReward.quantity > 1 || ItemFlavor_GetType( bpReward.flav ) == eItemType.account_currency )
		{
			rarity = 0
			HudElem_SetRuiArg( awardButton, "itemCountString", string( bpReward.quantity ) )
		}
		HudElem_SetRuiArg( awardButton, "rarity", rarity )
		RuiSetImage( Hud_GetRui( awardButton ), "buttonImage", CustomizeMenu_GetRewardButtonImage( bpReward.flav ) )

		if ( ItemFlavor_GetType( bpReward.flav ) == eItemType.account_pack )
			HudElem_SetRuiArg( awardButton, "isLootBox", true )

		BattlePass_PopulateRewardButton( bpReward, awardButton, true, false )

		Hud_AddEventHandler( awardButton, UIE_GET_FOCUS, PassAward_OnFocusAward )


		if ( index == 0 )
			PassAward_OnFocusAward( awardButton )
	}
}


void function PassAward_OnFocusAward( var button )
{
	ItemFlavor item = file.buttonToItem[button].flav
	int level       = file.buttonToItem[button].level
	PresentItem( item, level )
}


void function PresentItem( ItemFlavor item, int level )
{
	bool showLow = !file.isForBattlePass || Battlepass_ShouldShowLow( item )
	RunClientScript( "UIToClient_ItemPresentation", ItemFlavor_GetGUID( item ), level, 1.21, showLow, Hud_GetChild( file.menu, "LoadscreenImage" ), true, "battlepass_center_ref" )
}


