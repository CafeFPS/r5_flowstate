global function InitAllChallengesMenu
global function AllChallengesMenu_UpdateCategories
global function AllChallengesMenu_GetLastGroupButton
global function AllChallengesMenu_SetLastGroupButton
global function AllChallengesMenu_ActivateLastGroupButton

const int MAX_CHALLENGE_CATEGORIES_PER_PAGE = 10
const int MAX_CHALLENGE_PER_PAGE = 9

struct
{
	var                            menu
	var                            decorationRui
	var                            titleRui
	var                            largeGroupButton0
	var                            largeGroupButton1
	var                            largeGroupButton2
	var                            groupListPanel
	var                            pinnedChallengeButton
	var                            challengesListPanel
	var 							lastClickedGroupButton
	table<var, ChallengeGroupData> buttonGroupMap
	ChallengeGroupData ornull      activeGroup = null
} file

void function InitAllChallengesMenu( var newMenuArg )
//
{
	var menu = GetMenu( "AllChallengesMenu" )
	file.menu = menu

	file.decorationRui = Hud_GetRui( Hud_GetChild( menu, "Decoration" ) )
	file.titleRui = Hud_GetRui( Hud_GetChild( menu, "Title" ) )
	file.groupListPanel = Hud_GetChild( menu, "CategoryList" )
	file.pinnedChallengeButton = Hud_GetChild( menu, "PinnedChallenge" )
	file.challengesListPanel = Hud_GetChild( menu, "ChallengesList" )
	file.largeGroupButton0 = Hud_GetChild( menu, "CategoryLargeButton0" )
	file.largeGroupButton1 = Hud_GetChild( menu, "CategoryLargeButton1" )
	file.largeGroupButton2 = Hud_GetChild( menu, "CategoryLargeButton2" )

	AddMenuEventHandler( menu, eUIEvent.MENU_OPEN, AllChallengesMenu_OnOpen )
	AddMenuEventHandler( menu, eUIEvent.MENU_SHOW, AllChallengesMenu_OnShow )
	AddMenuEventHandler( menu, eUIEvent.MENU_CLOSE, AllChallengesMenu_OnClose )
	AddMenuEventHandler( menu, eUIEvent.MENU_NAVIGATE_BACK, AllChallengesMenu_OnNavigateBack )

	AddMenuFooterOption( menu, LEFT, BUTTON_B, true, "#B_BUTTON_BACK", "#B_BUTTON_BACK" )
	AddMenuFooterOption( menu, LEFT, BUTTON_A, true, "#A_BUTTON_SELECT", "" )
}


void function AllChallengesMenu_OnOpen()
{
	RuiSetGameTime( file.decorationRui, "initTime", Time() )
	RuiSetString( file.titleRui, "title", Localize( "#CHALLENGE_FULL_MENU_TITLE" ).toupper() )
}


void function AllChallengesMenu_OnShow()
{
	UI_SetPresentationType( ePresentationType.CHARACTER_CARD )

	file.lastClickedGroupButton = null
	AllChallengesMenu_UpdateCategories( true )
}


void function AllChallengesMenu_OnClose()
{
	file.lastClickedGroupButton = null
	AllChallengesMenu_UpdateCategories( false )
	AllChallengesMenu_UpdateActiveGroup()
}


void function AllChallengesMenu_OnNavigateBack()
{
	Assert( GetActiveMenu() == file.menu )
	CloseActiveMenu()
}


void function AllChallengesMenu_UpdateCategories( bool isShown )
{
	foreach ( var button, ChallengeGroupData group in file.buttonGroupMap )
	{
		//
		Hud_RemoveEventHandler( button, UIE_CLICK, GroupButton_OnClick )
	}
	file.buttonGroupMap.clear()
	file.activeGroup = null

	if ( isShown )
	{
		array<ChallengeGroupData> groupData = GetPlayerChallengeGroupData( GetUIPlayer() )

		var groupScrollPanel = Hud_GetChild( file.groupListPanel, "ScrollPanel" )
		//
		//

		ItemFlavor currentSeason = GetLatestSeason( GetUnixTimestamp() )
		int seasonStartUnixTime  = CalEvent_GetStartUnixTime( currentSeason )
		int seasonEndUnixTime    = CalEvent_GetFinishUnixTime( currentSeason )
		int weekCount            = (seasonEndUnixTime - seasonStartUnixTime) / SECONDS_PER_WEEK
		int currentWeek          = GetCurrentBattlePassWeek()
		Hud_InitGridButtonsDetailed( file.groupListPanel, weekCount, MAX_CHALLENGE_CATEGORIES_PER_PAGE, 1 )

		AllChallengesMenu_UpdateDpadNav()

		array<var> usedButtons

		var dailyButton             = null
		var weeklyRecurringButton   = null
		var eventButton             = null
		ItemFlavor ornull eventFlav = null
		int listButtonIdx           = 0
		foreach( int groupIdx, ChallengeGroupData group in groupData )
		{
			var button
			if ( group.timeSpanKind == eChallengeTimeSpanKind.DAILY )
			{
				button = file.largeGroupButton0
				dailyButton = button
				int remainingDuration = 1628341013 - Daily_GetCurrentTime()
				RuiSetGameTime( Hud_GetRui( button ), "expireTime", remainingDuration > 0 ? Time() + remainingDuration : RUI_BADGAMETIME )
			}
			else if ( group.timeSpanKind == eChallengeTimeSpanKind.SEASON_WEEKLY_RECURRING )
			{
				button = file.largeGroupButton1
				weeklyRecurringButton = button
				int remainingDuration = GetCurrentBattlePassWeekExpirationTime() - GetUnixTimestamp()
				RuiSetGameTime( Hud_GetRui( button ), "expireTime", remainingDuration > 0 ? Time() + remainingDuration : RUI_BADGAMETIME )
			}
			else if ( group.timeSpanKind == eChallengeTimeSpanKind.EVENT )
			{
				button = file.largeGroupButton2
				eventButton = button
				int remainingDuration = 0
				if ( group.challenges.len() > 0 )
				{
					eventFlav = Challenge_GetSource( group.challenges[0] )
					expect ItemFlavor(eventFlav)
					Assert( ItemFlavor_GetType( eventFlav ) == eItemType.calevent_collection || ItemFlavor_GetType( eventFlav ) == eItemType.calevent_themedshop  )
					remainingDuration = CalEvent_GetFinishUnixTime( eventFlav ) - GetUnixTimestamp()
					group.groupName = Localize( ItemFlavor_GetShortName( eventFlav ) )
				}
				RuiSetGameTime( Hud_GetRui( button ), "expireTime", remainingDuration > 0 ? Time() + remainingDuration : RUI_BADGAMETIME )
			}
			else
			{
				button = Hud_GetChild( groupScrollPanel, "GridButton" + listButtonIdx )
				Hud_SetEnabled( button, true )
				listButtonIdx++
			}

			Hud_SetSelected( button, false )
			Hud_AddEventHandler( button, UIE_CLICK, GroupButton_OnClick )
			file.buttonGroupMap[ button ] <- group

			HudElem_SetRuiArg( button, "categoryName", group.groupName )
			HudElem_SetRuiArg( button, "challengeTotalNum", group.challenges.len() )
			HudElem_SetRuiArg( button, "challengeCompleteNum", group.completedChallenges )

			bool isAnyChallengeNew = false
			foreach ( ItemFlavor challenge in group.challenges )
			{
				if ( Newness_IsItemFlavorNew( challenge ) )
					isAnyChallengeNew = true
			}
			Hud_SetNew( button, isAnyChallengeNew )

			usedButtons.append( button )
			//
		}

		int weekOffsetIndex = 0
		for ( int i = listButtonIdx ; i < weekCount ; i++ )
		{
			var button = Hud_GetChild( groupScrollPanel, "GridButton" + i )
			if ( usedButtons.contains( button ) )
				continue

			int revealDuration = (GetCurrentBattlePassWeekExpirationTime() - GetUnixTimestamp()) + (SECONDS_PER_WEEK * weekOffsetIndex)
			weekOffsetIndex++

			Hud_SetEnabled( button, false )
			HudElem_SetRuiArg( button, "categoryName", Localize( "#CHALLENGE_GROUP_WEEKLY", i + 1 ) )
			RuiSetGameTime( Hud_GetRui( button ), "revealTime", revealDuration > 0 ? Time() + revealDuration : RUI_BADGAMETIME )
		}

		if ( eventButton != null )
		{
			Hud_SetEnabled( eventButton, eventFlav != null )
		}

		if ( dailyButton != null && eventFlav != null )
		{
			GroupButton_OnClick( dailyButton )
		}
		else if ( weeklyRecurringButton != null )
		{
			GroupButton_OnClick( weeklyRecurringButton )
		}
	}
}


void function GroupButton_OnClick( var button )
{
	//

	Assert( button in file.buttonGroupMap )
	file.activeGroup = file.buttonGroupMap[ button ]
	file.lastClickedGroupButton = button
	AllChallengesMenu_UpdateActiveGroup()
	Hud_SetNew( button, false )
}


void function AllChallengesMenu_UpdateActiveGroup()
{
	//
	foreach( var button, ChallengeGroupData buttonGroup in file.buttonGroupMap )
		Hud_SetSelected( button, buttonGroup == file.activeGroup )

	if ( file.activeGroup == null )
		return

	ChallengeGroupData group = expect ChallengeGroupData(file.activeGroup)

	var challengesScrollPanel  = Hud_GetChild( file.challengesListPanel, "ScrollPanel" )
	int numChallengesToDisplay = 0
	foreach( ItemFlavor challenge in group.challenges )
	{
		if ( !Challenge_IsPinned( challenge ) )
			numChallengesToDisplay++
	}
	Hud_InitGridButtonsDetailed( file.challengesListPanel, numChallengesToDisplay, MAX_CHALLENGE_PER_PAGE, 1 )

	array<ItemFlavor> pinnedChallenges = GetPinnedChallenges()
	Hud_SetVisible( file.pinnedChallengeButton, pinnedChallenges.len() > 0 )
	if ( pinnedChallenges.len() > 0 )
		PutChallengeOnFullChallengeWidget( file.pinnedChallengeButton, pinnedChallenges[0], true )

	int buttonIndex = 0
	foreach( ItemFlavor challenge in group.challenges )
	{
		Newness_IfNecessaryMarkItemFlavorAsNoLongerNewAndInformServer( challenge )

		if ( Challenge_IsPinned( challenge ) )
			continue

		var listItem = Hud_GetChild( challengesScrollPanel, "GridButton" + buttonIndex )
		PutChallengeOnFullChallengeWidget( listItem, challenge, false )
		buttonIndex++
	}
}

void function AllChallengesMenu_UpdateDpadNav()
{
	var categoryScrollPanel = Hud_GetChild( file.groupListPanel, "ScrollPanel" )
	Hud_SetNavUp( Hud_GetChild( categoryScrollPanel, "GridButton0" ), file.largeGroupButton1 )
}

void function PutChallengeOnFullChallengeWidget( var button, ItemFlavor challenge, bool useAltColor )
{
	Hud_ClearToolTipData( button )

	int displayTier = Challenge_GetCurrentTier( GetUIPlayer(), challenge )
	if ( Challenge_IsComplete( GetUIPlayer(), challenge ) )
		displayTier -= 1
	int challengeGoal     = Challenge_GetGoalVal( challenge, displayTier )
	int challengeProgress = Challenge_GetProgressValue( GetUIPlayer(), challenge, displayTier )

	int rewardBPLevels        = 0
	int rewardXP              = 0
	bool rewardsForActiveTier = true
	for ( int tier = displayTier ; tier < Challenge_GetTierCount( challenge ) ; tier++ )
	{
		rewardBPLevels = Challenge_GetBattlepassLevelsReward( challenge, tier )
		rewardXP = Challenge_GetXPReward( challenge, tier )
		if ( rewardBPLevels > 0 || rewardXP > 0 )
		{
			rewardsForActiveTier = (tier == displayTier)
			break
		}
	}

	HudElem_SetRuiArg( button, "challengeText", Challenge_GetDescription( challenge, displayTier ) )
	HudElem_SetRuiArg( button, "challengeProgressStart", challengeProgress )
	HudElem_SetRuiArg( button, "challengeProgressEnd", challengeProgress )
	HudElem_SetRuiArg( button, "challengeGoal", challengeGoal )
	HudElem_SetRuiArg( button, "tempHasWeirdReward", (rewardXP == 0 && rewardBPLevels == 0) )
	HudElem_SetRuiArg( button, "bpLevelsAwarded", rewardBPLevels )
	HudElem_SetRuiArg( button, "challengePointsAwarded", rewardXP )
	HudElem_SetRuiArg( button, "tierCount", Challenge_GetTierCount( challenge ) )
	HudElem_SetRuiArg( button, "activeTier", displayTier )
	HudElem_SetRuiArg( button, "isInfinite", Challenge_LastTierIsInfinite( challenge ) )
	HudElem_SetRuiArg( button, "altColor", useAltColor )
	HudElem_SetRuiArg( button, "canClickToReroll", false )
	//

	RemoveChallengeClickEventToButton( button )

	if ( Challenge_GetTimeSpan( challenge ) == eChallengeTimeSpanKind.DAILY && !Challenge_IsComplete( GetUIPlayer(), challenge ) )
	{
		HudElem_SetRuiArg( button, "canClickToReroll", true )
		AddChallengeClickEventToButton( null,button, challenge, displayTier )
	}
}

void function AllChallengesMenu_ActivateLastGroupButton()
{
	if ( file.lastClickedGroupButton != null )
		GroupButton_OnClick( file.lastClickedGroupButton )
}

var function AllChallengesMenu_GetLastGroupButton()
{
	return file.lastClickedGroupButton
}

void function AllChallengesMenu_SetLastGroupButton( var button )
{
	file.lastClickedGroupButton = button
}