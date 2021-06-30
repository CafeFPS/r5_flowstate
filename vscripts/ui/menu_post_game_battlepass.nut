global function InitPostGameBattlePassMenu
global function OpenPostGameBattlePassMenu

struct
{
	var menu
	var summaryBox
	var continueButton
	var menuHeaderRui

	bool isFirstTime

	bool skippableWaitSkipped = false
	bool disableNavigateBack = true
	bool showingRewards = false

	int xpChallengeTier = -1
	int xpChallengeValue = -1

	bool buttonsRegistered = false
} file

struct PinnedXPAndStarsProgressBar
{
	var         rui
	ItemFlavor& progressBarFlavor
	int         tierStart
	int         startingPoints
	int         pointsToAddTotal
	int         challengesCompleted
	int         battlePassLevelsEarned
	int         challengeStarsAndXpEarned
	int         currentPassLevel
}


void function InitPostGameBattlePassMenu( var newMenuArg )
{
	file.menu = newMenuArg
	var menu = file.menu

	AddMenuEventHandler( menu, eUIEvent.MENU_OPEN, OnPostGameBattlePassMenu_Open )
	AddMenuEventHandler( menu, eUIEvent.MENU_CLOSE, OnPostGameBattlePassMenu_Close )

	AddMenuEventHandler( menu, eUIEvent.MENU_SHOW, OnPostGameBattlePassMenu_Show )
	AddMenuEventHandler( menu, eUIEvent.MENU_HIDE, OnPostGameBattlePassMenu_Hide )

	file.summaryBox = Hud_GetChild( menu, "SummaryBox" )

	RegisterSignal( "ShowBPSummary" )

	file.continueButton = Hud_GetChild( menu, "ContinueButton" )

	Hud_AddEventHandler( file.continueButton, UIE_CLICK, OnContinue_Activate )


	file.menuHeaderRui = Hud_GetRui( Hud_GetChild( menu, "MenuHeader" ) )

	RuiSetString( file.menuHeaderRui, "menuName", "#MATCH_SUMMARY" )
}

void function OpenPostGameBattlePassMenu( bool firstTime )
{
	bool forceFirstTime = false

	#if R5DEV
		forceFirstTime = GetBugReproNum() == 100
	#endif

	file.isFirstTime = firstTime || forceFirstTime
	AdvanceMenu( file.menu )
}

void function OnPostGameBattlePassMenu_Open()
{
	file.showingRewards = false
}

void function OnPostGameBattlePassMenu_Close()
{
	file.showingRewards = false
}

vector COLOR_BP_PREMIUM
vector COLOR_BP_PINNED_CHALLENGE
vector COLOR_BP_PINNED_CHALLENGE_TEXT

void function OnPostGameBattlePassMenu_Show()
{
	UI_SetPresentationType( ePresentationType.WEAPON_CATEGORY )

	if ( !file.buttonsRegistered )
	{
		RegisterButtonPressedCallback( BUTTON_A, OnContinue_Activate )
		RegisterButtonPressedCallback( KEY_SPACE, OnContinue_Activate )
		file.buttonsRegistered = true
	}

	COLOR_BP_PREMIUM               = SrgbToLinear( <255, 90, 40> / 255.0 )
	COLOR_BP_PINNED_CHALLENGE      = SrgbToLinear( <255, 215, 55> / 255.0 )
	COLOR_BP_PINNED_CHALLENGE_TEXT = SrgbToLinear( <254, 227, 113> / 255.0 )

	HudElem_SetRuiArg( file.summaryBox, "borderColor", COLOR_BP_PREMIUM )
	HudElem_SetRuiArg( file.summaryBox, "innerColor", COLOR_BP_PREMIUM * 1.5 )
	HudElem_SetRuiArg( file.summaryBox, "titleText", "#EOG_MATCH_BP" )

	ItemFlavor ornull pass = GetActiveBattlePass()

	if ( pass == null )
		return

	expect ItemFlavor( pass )

	string bpLongName = ItemFlavor_GetShortName( pass )

	HudElem_SetRuiArg( file.summaryBox, "subTitleText", bpLongName )

	var matchRankRui = Hud_GetRui( Hud_GetChild( file.menu, "MatchRank" ) )

	//
	//
	//

	RuiSetInt( matchRankRui, "squadRank", GetPersistentVarAsInt( "lastGameRank" ) )
	RuiSetInt( matchRankRui, "totalPlayers", GetPersistentVarAsInt( "lastGameSquads" ) )
	int elapsedTime = GetUnixTimestamp() - GetPersistentVarAsInt( "lastGameTime" )

	RuiSetString( matchRankRui, "lastPlayedText", Localize( "#EOG_LAST_PLAYED", GetFormattedIntByType( elapsedTime, eNumericDisplayType.TIME_MINUTES_LONG ) ) )

	thread ShowBPSummary( pass )
}

void function OnPostGameBattlePassMenu_Hide()
{
	if ( file.buttonsRegistered )
	{
		DeregisterButtonPressedCallback( BUTTON_A, OnContinue_Activate )
		DeregisterButtonPressedCallback( KEY_SPACE, OnContinue_Activate )
		file.buttonsRegistered = false
	}

	if ( !file.showingRewards )
		Signal( uiGlobal.signalDummy, "ShowBPSummary" )
}

const PROGRESS_BAR_FILL_TIME = 2.0
const REWARD_AWARD_TIME = 2
const string POSTGAME_LINE_ITEM = "ui_menu_matchsummary_xpbreakdown"
const float CHALLENGE_FILL_DURATION = 1.5
const float CHALLENGE_POST_FILL_DELAY = 0.75

void function ShowBPSummary( ItemFlavor activeBattlePass ) // TODO: IMPLEMENT
{
	// if ( !file.showingRewards )
	// 	Signal( uiGlobal.signalDummy, "ShowBPSummary" )
	// else
	// 	return

	// EndSignal( uiGlobal.signalDummy, "ShowBPSummary" )

	// bool isFirstTime = file.isFirstTime
	// bool showRankedSummary = GetPersistentVarAsInt( "showRankedSummary" ) != 0
	// if ( showRankedSummary )
	// {
	// 	WaitFrame() //
	// 	while( GetActiveMenu() != file.menu  )
	// 		WaitFrame()
	// }

	// if ( !showRankedSummary && isFirstTime && TryOpenSurvey( eSurveyType.POSTGAME ) )
	// {
	// 	while ( IsDialog( GetActiveMenu() ) )
	// 		WaitFrame()
	// }

	// Hud_SetVisible( Hud_GetChild( file.menu, "XPEarned3" ), false )
	// Hud_SetVisible( Hud_GetChild( file.menu, "PinnedChallenge0" ), false )
	// Hud_SetVisible( Hud_GetChild( file.menu, "PinnedChallenge1" ), false )
	// Hud_SetVisible( Hud_GetChild( file.menu, "XPProgressBarBattlePass" ), false )
	// Hud_SetVisible( Hud_GetChild( file.menu, "ContinueButton" ), false )

	// entity player = GetUIPlayer()
	// while ( !GRX_IsInventoryReady( player ) )
	// 	WaitFrame()

	// float baseDelay = file.isFirstTime ? 1.0 : 0.0
	// file.disableNavigateBack = file.isFirstTime

	// bool hasPremiumPass                = false
	// int battlePassLevel                = 0
	// hasPremiumPass = DoesPlayerOwnBattlePass( GetUIPlayer(), activeBattlePass )
	// battlePassLevel = GetPlayerBattlePassLevel( GetUIPlayer(), activeBattlePass, false )

	// ResetSkippableWait()

	// OnThreadEnd(
	// 	function () : ()
	// 	{
	// 		file.disableNavigateBack = false
	// 		UpdateFooterOptions()
	// 	}
	// )

	// array< int > xpDisplayGroups = [
	// 	XP_TYPE.TOTAL_MATCH,
	// 	XP_TYPE.BONUS_FRIEND_BOOST,
	// 	XP_TYPE.BONUS_FIRST_KILL_AS,
	// 	XP_TYPE.BONUS_FIRST_TOP_FIVE,
	// 	XP_TYPE.CHALLENGE_COMPLETED,
	// ]

	// const float LINE_DISPLAY_TIME = 0.25

	// ItemFlavor progressBarChallengeFlav = expect ItemFlavor( GetBattlePassRecurringStarChallenge( activeBattlePass ) )

	// while ( !DoesPlayerHaveChallenge( player, progressBarChallengeFlav ) )
	// 	WaitFrame()

	// Hud_SetVisible( file.continueButton, true )


	// int previousBattlePassXP = GetPlayerBattlePassXPProgress( ToEHI( player ), activeBattlePass, true )
	// int currentBattlePassXP  = GetPlayerBattlePassXPProgress( ToEHI( player ), activeBattlePass, false )
	// int totalBattlePassXP    = currentBattlePassXP - previousBattlePassXP

	// //
	// int start_passLevel = GetBattlePassLevelForXP( activeBattlePass, previousBattlePassXP )
	// Assert( start_passLevel >= 0 )
	// int start_passXP = GetTotalXPToCompletePassLevel( activeBattlePass, start_passLevel - 1 )

	// int start_nextPassLevelXP
	// if ( start_passLevel > GetBattlePassMaxLevelIndex( activeBattlePass ) )
	// 	start_nextPassLevelXP = start_passXP
	// else
	// 	start_nextPassLevelXP = GetTotalXPToCompletePassLevel( activeBattlePass, start_passLevel )

	// Assert( previousBattlePassXP >= start_passXP )
	// Assert( previousBattlePassXP <= start_nextPassLevelXP )

	// float start_passLevelFrac = GraphCapped( previousBattlePassXP, start_passXP, start_nextPassLevelXP, 0.0, 1.0 )

	// //
	// int ending_passLevel = GetBattlePassLevelForXP( activeBattlePass, currentBattlePassXP )
	// int ending_passXP    = GetTotalXPToCompletePassLevel( activeBattlePass, ending_passLevel - 1 )
	// bool isMaxPassLevel  = ending_passLevel > GetBattlePassMaxLevelIndex( activeBattlePass )

	// int ending_nextPassLevelXP
	// if ( isMaxPassLevel )
	// 	ending_nextPassLevelXP = ending_passXP
	// else
	// 	ending_nextPassLevelXP = GetTotalXPToCompletePassLevel( activeBattlePass, ending_passLevel )

	// Assert( currentBattlePassXP >= ending_passXP )
	// Assert( currentBattlePassXP <= ending_nextPassLevelXP )
	// float ending_passLevelFrac = GraphCapped( currentBattlePassXP, ending_passXP, ending_nextPassLevelXP, 0.0, 1.0 )


	// var xpEarned3Rui = Hud_GetRui( Hud_GetChild( file.menu, "XPEarned3" ) )
	// var passProgressRUI = Hud_GetRui( Hud_GetChild( file.menu, "XPProgressBarBattlePass" ) )

	// ItemFlavor dummy
	// ItemFlavor bpLevelBadge = GetBattlePassProgressBadge( activeBattlePass )


	// PinnedXPAndStarsProgressBar xpChallengeData
	// xpChallengeData.challengesCompleted = 0
	// xpChallengeData.battlePassLevelsEarned = 0
	// xpChallengeData.challengeStarsAndXpEarned = 0
	// xpChallengeData.currentPassLevel = start_passLevel





	// //
	// //
	// //

	// //
	// RuiSetBool( passProgressRUI, "battlePass", true )
	// RuiSetAsset( passProgressRUI, "emptyRewardImage", $"rui/menu/buttons/battlepass/button_bg" )

	// RuiSetString( passProgressRUI, "displayName", GetPlayerName() )
	// RuiSetColorAlpha( passProgressRUI, "oldProgressColor", <196 / 255.0, 151 / 255.0, 41 / 255.0>, 1 )
	// RuiSetColorAlpha( passProgressRUI, "newProgressColor", <255 / 255.0, 182 / 255.0, 0 / 255.0>, 1 )
	// RuiSetString( passProgressRUI, "totalEarnedXPText", ShortenNumber( string( totalBattlePassXP ) ) )
	// RuiSetBool( passProgressRUI, "largeFormat", true )
	// RuiSetInt( passProgressRUI, "startLevel", start_passLevel )
	// RuiSetFloat( passProgressRUI, "startLevelFrac", start_passLevelFrac )
	// RuiSetInt( passProgressRUI, "endLevel", start_passLevel )
	// RuiSetFloat( passProgressRUI, "endLevelFrac", 1.0 )
	// RuiSetGameTime( passProgressRUI, "startTime", RUI_BADGAMETIME )
	// RuiSetFloat( passProgressRUI, "startDelay", 0.0 )
	// RuiSetString( passProgressRUI, "headerText", "#EOG_XP_HEADER_MATCH" )
	// RuiSetFloat( passProgressRUI, "progressBarFillTime", PROGRESS_BAR_FILL_TIME )
	// if ( isMaxPassLevel )
	// 	RuiSetInt( passProgressRUI, "displayLevel1XP", 0 )
	// else
	// 	RuiSetInt( passProgressRUI, "displayLevel1XP", GetTotalXPToCompletePassLevel( activeBattlePass, start_passLevel ) - GetTotalXPToCompletePassLevel( activeBattlePass, start_passLevel - 1 ) )

	// RuiSetString( passProgressRUI, "currentDisplayLevel", "" )
	// RuiSetString( passProgressRUI, "nextDisplayLevel", "" )
	// RuiSetImage( passProgressRUI, "currentDisplayBadge", $"" )
	// RuiSetImage( passProgressRUI, "nextDisplayBadge", $"" )

	// RuiDestroyNestedIfAlive( passProgressRUI, "currentBadgeHandle" )
	// CreateNestedGladiatorCardBadge( passProgressRUI, "currentBadgeHandle", ToEHI( player ), bpLevelBadge, 0, dummy, start_passLevel + 1 )

	// RuiDestroyNestedIfAlive( passProgressRUI, "nextBadgeHandle" )
	// //
	// //

	// array<BattlePassReward> passRewardArray = GetBattlePassLevelRewards( activeBattlePass, start_passLevel + 1 )
	// RuiSetImage( passProgressRUI, "rewardImage1", passRewardArray.len() >= 1 ? CustomizeMenu_GetRewardButtonImage( passRewardArray[0].flav ) : $"" )
	// RuiSetImage( passProgressRUI, "rewardImage2", passRewardArray.len() >= 2 ? CustomizeMenu_GetRewardButtonImage( passRewardArray[1].flav ) : $"" )
	// RuiSetString( passProgressRUI, "reward1Value", passRewardArray.len() >= 1 ? ItemFlavor_GetType( passRewardArray[0].flav ) == eItemType.account_currency ? string( passRewardArray[0].quantity ) : " " : "" )
	// RuiSetString( passProgressRUI, "reward2Value", passRewardArray.len() >= 2 ? ItemFlavor_GetType( passRewardArray[1].flav ) == eItemType.account_currency ? string( passRewardArray[1].quantity ) : " " : "" )
	// RuiSetBool( passProgressRUI, "reward1Premium", passRewardArray.len() >= 1 ? passRewardArray[0].isPremium : false )
	// RuiSetBool( passProgressRUI, "reward2Premium", passRewardArray.len() >= 2 ? passRewardArray[1].isPremium : false )

	// RuiDestroyNestedIfAlive( passProgressRUI, "reward1Handle" )
	// if ( passRewardArray.len() >= 1 )
	// {
	// 	var reward1NestedRui = RuiCreateNested( passProgressRUI, "reward1Handle", $"ui/battle_pass_reward_button_v2.rpak" )
	// 	RuiSetBool( reward1NestedRui, "isRewardBar", true )

	// 	bool isOwned = (!passRewardArray[0].isPremium || hasPremiumPass) && passRewardArray[0].level < battlePassLevel
	// 	BattlePass_PopulateRewardButton( passRewardArray[0], null, isOwned, false, reward1NestedRui )
	// }

	// RuiDestroyNestedIfAlive( passProgressRUI, "reward2Handle" )
	// if ( passRewardArray.len() >= 2 )
	// {
	// 	var reward2NestedRui = RuiCreateNested( passProgressRUI, "reward2Handle", $"ui/battle_pass_reward_button_v2.rpak" )
	// 	RuiSetBool( reward2NestedRui, "isRewardBar", true )
	// 	bool isOwned = (!passRewardArray[1].isPremium || hasPremiumPass) && passRewardArray[1].level < battlePassLevel
	// 	BattlePass_PopulateRewardButton( passRewardArray[1], null, isOwned, false, reward2NestedRui )
	// }

	// Hud_SetVisible( Hud_GetChild( file.menu, "XPProgressBarBattlePass" ), true )










	// var challengeRui1 = Hud_GetRui( Hud_GetChild( file.menu, "PinnedChallenge1" ) )
	// RuiDestroyNestedIfAlive( passProgressRUI, "currentBadgeHandle" )
	// CreateNestedGladiatorCardBadge( passProgressRUI, "currentBadgeHandle", ToEHI( player ), bpLevelBadge, 0, dummy, xpChallengeData.currentPassLevel + 1 )

	// //
	// Hud_SetVisible( Hud_GetChild( file.menu, "PinnedChallenge0" ), true )
	// xpChallengeData.rui = Hud_GetRui( Hud_GetChild( file.menu, "PinnedChallenge0" ) )
	// xpChallengeData.progressBarFlavor = progressBarChallengeFlav
	// xpChallengeData.tierStart = player.GetPersistentVarAsInt( "postgameGrindStartTier" )
	// xpChallengeData.startingPoints = player.GetPersistentVarAsInt( "postgameGrindStartValue" )

	// int grindStatStart = GetStat_Int( player, ResolveStatEntry( CAREER_STATS.challenge_xp_earned ), eStatGetWhen.START_OF_PREVIOUS_MATCH )
	// int grindStatEnd   = GetStat_Int( player, ResolveStatEntry( CAREER_STATS.challenge_xp_earned ), eStatGetWhen.CURRENT )

	// xpChallengeData.pointsToAddTotal = grindStatEnd - grindStatStart
	// for ( int i = 0 ; i < PersistenceGetArrayCount( "postGameChallenges" ) ; i++ )
	// {
	// 	int guid = player.GetPersistentVarAsInt( "postGameChallenges[" + i + "].guid" )
	// 	if ( guid > 0 )
	// 	{
	// 		ItemFlavor ornull challenge = GetItemFlavorOrNullByGUID( guid, eItemType.challenge )
	// 		if ( challenge == null )
	// 			continue
	// 		int completedTier = player.GetPersistentVarAsInt( "postGameChallenges[" + i + "].completedTier" )
	// 		xpChallengeData.pointsToAddTotal -= Challenge_GetXPReward( expect ItemFlavor( challenge ), completedTier )
	// 	}
	// }

	// xpChallengeData.challengeStarsAndXpEarned += xpChallengeData.pointsToAddTotal

	// file.xpChallengeTier = xpChallengeData.tierStart
	// file.xpChallengeValue = xpChallengeData.startingPoints

	// printt( "[CHALLENGES] xpChallengeTier:", Challenge_GetCurrentTier( GetUIPlayer(), xpChallengeData.progressBarFlavor ) )
	// printt( "[CHALLENGES] grindStartTier:", xpChallengeData.tierStart )
	// printt( "[CHALLENGES] grindStartValue:", xpChallengeData.startingPoints )
	// printt( "[CHALLENGES] grindStatStart:", grindStatStart )
	// printt( "[CHALLENGES] grindStatEnd:", grindStatEnd )
	// printt( "[CHALLENGES] grindXPFromMatch:", xpChallengeData.pointsToAddTotal )




	// Hud_SetVisible( Hud_GetChild( file.menu, "XPEarned3" ), true )

	// bool isFreePlayer = GRX_IsInventoryReady() && DoesPlayerOwnBattlePass( GetUIPlayer(), activeBattlePass )
	// RuiSetFloat( xpEarned3Rui, "startDelay", 0.0 )
	// //

	// RuiSetString( xpEarned3Rui, "headerText", "" )
	// RuiSetString( xpEarned3Rui, "subHeaderText", "" )

	// RuiSetFloat( xpEarned3Rui, "lineDisplayTime", LINE_DISPLAY_TIME )

	// RuiSetGameTime( xpEarned3Rui, "startTime", Time() - 500.0 )


	// RuiSetString( xpEarned3Rui, "line1KeyString", "#EOG_CHALLENGE_STARS_EARNED" )
	// RuiSetString( xpEarned3Rui, "line1ValueString", string(xpChallengeData.challengeStarsAndXpEarned) )
	// RuiSetColorAlpha( xpEarned3Rui, "line1Color", COLOR_BP_PINNED_CHALLENGE_TEXT, 1.0 )
	// RuiSetColorAlpha( xpEarned3Rui, "line1ColorBg", COLOR_BP_PINNED_CHALLENGE, 1.0 )

	// RuiSetString( xpEarned3Rui, "line2KeyString", "#EOG_CHALLENGES_COMPLETED" )
	// RuiSetString( xpEarned3Rui, "line2ValueString", string(xpChallengeData.challengesCompleted) )
	// RuiSetColorAlpha( xpEarned3Rui, "line2Color", COLOR_BP_PREMIUM, 1.0 )

	// RuiSetString( xpEarned3Rui, "line3KeyString", "#EOG_BATTLE_PASS_LEVELS_EARNED" )
	// RuiSetString( xpEarned3Rui, "line3ValueString", string(xpChallengeData.battlePassLevelsEarned) )
	// RuiSetColorAlpha( xpEarned3Rui, "line3Color", <1.0, 1.0, 1.0>, 1.0 )

	// RuiSetInt( xpEarned3Rui, "numLines", 3 )

	// //
	// //
	// //
	// //
	// //
	// //
	// //
	// //










	// //
	// UpdateXPAndStarsProgress( player, activeBattlePass, passProgressRUI, bpLevelBadge, xpEarned3Rui, dummy, xpChallengeData, false )















	// int numChallengesCompleted = PersistenceGetArrayCount( "postGameChallenges" )
	// for ( int i = 0 ; i < numChallengesCompleted ; i++ )
	// {
	// 	int guid = player.GetPersistentVarAsInt( "postGameChallenges[" + i + "].guid" )
	// 	if ( guid > 0 )
	// 	{
	// 		ItemFlavor ornull challenge = GetItemFlavorOrNullByGUID( guid, eItemType.challenge )
	// 		if ( challenge == null )
	// 			continue
	// 		expect ItemFlavor( challenge )

	// 		int completedTier        = player.GetPersistentVarAsInt( "postGameChallenges[" + i + "].completedTier" )

	// 		bool isStarChallenge = false
	// 		//
	// 		array<string> statRefs = Challenge_GetStatRefs( challenge, completedTier )
	// 		foreach ( statRef in statRefs )
	// 		{
	// 			if ( statRef == "stats.challenge_xp_earned" )
	// 			{
	// 				isStarChallenge = true
	// 				break
	// 			}
	// 		}

	// 		if ( isStarChallenge )
	// 			continue

	// 		Hud_SetVisible( Hud_GetChild( file.menu, "PinnedChallenge1" ), true )

	// 		int statMarkerMatchStart = int( max( 0, player.GetPersistentVarAsInt( "postGameChallenges[" + i + "].statMarkerMatchStart" ) ) )
	// 		int rewardBPLevels       = Challenge_GetBattlepassLevelsReward( challenge, completedTier )
	// 		int rewardXP             = Challenge_GetXPReward( challenge, completedTier )
	// 		int goalValue            = Challenge_GetGoalVal( challenge, completedTier )
	// 		float fillDuration       = ((float(goalValue) - float(statMarkerMatchStart)) / float(goalValue)) * CHALLENGE_FILL_DURATION

	// 		RuiSetString( challengeRui1, "challengeText", Challenge_GetDescription( challenge, completedTier ) )
	// 		RuiSetInt( challengeRui1, "challengeProgressStart", statMarkerMatchStart )
	// 		RuiSetInt( challengeRui1, "challengeProgressEnd", goalValue )
	// 		RuiSetInt( challengeRui1, "challengeGoal", goalValue )
	// 		RuiSetInt( challengeRui1, "bpLevelsAwarded", rewardBPLevels )
	// 		RuiSetInt( challengeRui1, "challengePointsAwarded", rewardXP )
	// 		RuiSetInt( challengeRui1, "tierCount", Challenge_GetTierCount( challenge ) )
	// 		RuiSetInt( challengeRui1, "activeTier", completedTier+1 )
	// 		RuiSetBool( challengeRui1, "isInfinite", Challenge_LastTierIsInfinite( challenge ) )
	// 		RuiSetBool( challengeRui1, "altColor", false )
	// 		RuiSetGameTime( challengeRui1, "fillStartTime", Time() )
	// 		RuiSetGameTime( challengeRui1, "fillEndTime", Time() + fillDuration )

	// 		SkippableWait( fillDuration, "UI_Menu_MatchSummary_XPBar" )
	// 		StopUISoundByName( "UI_Menu_MatchSummary_XPBar" )

	// 		xpChallengeData.challengesCompleted++
	// 		xpChallengeData.battlePassLevelsEarned += rewardBPLevels
	// 		xpChallengeData.challengeStarsAndXpEarned += rewardXP

	// 		if ( rewardBPLevels > 0 )
	// 		{
	// 			SkippableWait( CHALLENGE_POST_FILL_DELAY )

	// 			xpChallengeData.currentPassLevel += rewardBPLevels

	// 			RuiDestroyNestedIfAlive( passProgressRUI, "currentBadgeHandle" )
	// 			CreateNestedGladiatorCardBadge( passProgressRUI, "currentBadgeHandle", ToEHI( player ), bpLevelBadge, 0, dummy, xpChallengeData.currentPassLevel + 1 )

	// 			array<BattlePassReward> nextPassRewardArray = GetBattlePassLevelRewards( activeBattlePass, xpChallengeData.currentPassLevel )
	// 			RuiDestroyNestedIfAlive( passProgressRUI, "reward1Handle" )
	// 			if ( nextPassRewardArray.len() >= 1 )
	// 			{
	// 				var reward1NestedRui = RuiCreateNested( passProgressRUI, "reward1Handle", $"ui/battle_pass_reward_button_v2.rpak" )
	// 				RuiSetBool( reward1NestedRui, "isRewardBar", true )
	// 				RuiSetBool( reward1NestedRui, "isFocused", false )

	// 				bool isOwned = (!nextPassRewardArray[0].isPremium || hasPremiumPass) && nextPassRewardArray[0].level < battlePassLevel
	// 				BattlePass_PopulateRewardButton( nextPassRewardArray[0], null, isOwned, false, reward1NestedRui )
	// 			}

	// 			RuiDestroyNestedIfAlive( passProgressRUI, "reward2Handle" )
	// 			if ( nextPassRewardArray.len() >= 2 )
	// 			{
	// 				var reward2NestedRui = RuiCreateNested( passProgressRUI, "reward2Handle", $"ui/battle_pass_reward_button_v2.rpak" )
	// 				RuiSetBool( reward2NestedRui, "isRewardBar", true )
	// 				bool isOwned = (!nextPassRewardArray[1].isPremium || hasPremiumPass) && nextPassRewardArray[1].level < battlePassLevel
	// 				BattlePass_PopulateRewardButton( nextPassRewardArray[1], null, isOwned, false, reward2NestedRui )
	// 			}
	// 			RuiSetGameTime( passProgressRUI, "badgePulseStartTime", Time() )

	// 			if ( file.isFirstTime && !IsSkippableWaitSkipped() )
	// 				EmitUISound( GetGlobalSettingsString( ItemFlavor_GetAsset( activeBattlePass ), "levelUpSound" ) )
	// 		}

	// 		RuiSetString( xpEarned3Rui, "line2ValueString", string(xpChallengeData.challengesCompleted) )

	// 		//
	// 		if ( xpChallengeData.currentPassLevel <= GetBattlePassMaxLevelIndex( activeBattlePass ) + 1 )
	// 			RuiSetString( xpEarned3Rui, "line3ValueString", string(xpChallengeData.battlePassLevelsEarned) )
	// 		//

	// 		SkippableWait( CHALLENGE_POST_FILL_DELAY )

	// 		//
	// 		if ( rewardXP > 0 )
	// 		{
	// 			xpChallengeData.pointsToAddTotal = rewardXP
	// 			UpdateXPAndStarsProgress( player, activeBattlePass, passProgressRUI, bpLevelBadge, xpEarned3Rui, dummy, xpChallengeData, true )
	// 		}
	// 	}
	// }




	// RuiDestroyNestedIfAlive( passProgressRUI, "currentBadgeHandle" )
	// CreateNestedGladiatorCardBadge( passProgressRUI, "currentBadgeHandle", ToEHI( player ), bpLevelBadge, 0, dummy, xpChallengeData.currentPassLevel + 1 )

	// ClientCommand( "ViewedGameSummary" ) //

	// SkippableWait( baseDelay )

	// file.showingRewards = true

	// if ( file.isFirstTime )
	// {
	// 	thread TryDisplayBattlePassAwards()
	// }

	// Hud_SetVisible( file.continueButton, true )
	// SkippableWait( baseDelay )
}

void function ResetSkippableWait()
{
	file.skippableWaitSkipped = false
}

bool function IsSkippableWaitSkipped()
{
	return file.skippableWaitSkipped || !file.disableNavigateBack
}

bool function SkippableWait( float waitTime, string uiSound = "" )
{
	if ( IsSkippableWaitSkipped() )
		return false

	if ( uiSound != "" )
		EmitUISound( uiSound )

	float startTime = Time()
	while ( Time() - startTime < waitTime )
	{
		if ( IsSkippableWaitSkipped() )
			return false

		WaitFrame()
	}

	return true
}


bool function CanNavigateBack()
{
	return file.disableNavigateBack != true
}

void function UpdateXPAndStarsProgress( entity player, ItemFlavor activeBattlePass, var passProgressRUI, ItemFlavor bpLevelBadge, var xpEarned3Rui, ItemFlavor dummy, PinnedXPAndStarsProgressBar xpChallengeData, bool isUpdatingStars )
{
	int progressEndValue        = 0
	int currentTier             = xpChallengeData.tierStart
	int pointsToAddByStep       = xpChallengeData.pointsToAddTotal
	int startingPointsByStep    = xpChallengeData.startingPoints
	bool needsReset             = false
	bool progressComplete       = false
	float challengeFillDuration = isUpdatingStars ? CHALLENGE_FILL_DURATION * 0.5 : CHALLENGE_FILL_DURATION

	//
	while( true )
	{
		progressEndValue = startingPointsByStep + pointsToAddByStep
		int currentGoalValue      = Challenge_GetGoalVal( xpChallengeData.progressBarFlavor, currentTier )
		float currentFillDuration = (float(pointsToAddByStep) / float(xpChallengeData.pointsToAddTotal)) * challengeFillDuration

		if ( pointsToAddByStep == 0 )
			currentFillDuration = 0.1

		if ( progressEndValue > currentGoalValue )
		{
			progressEndValue = currentGoalValue
			needsReset = true
			currentFillDuration = ((float(currentGoalValue) - float(startingPointsByStep)) / float(xpChallengeData.pointsToAddTotal)) * challengeFillDuration
		}

		RuiSetString( xpChallengeData.rui, "challengeText", Challenge_GetDescription( xpChallengeData.progressBarFlavor, currentTier ) )
		RuiSetInt( xpChallengeData.rui, "challengeProgressStart", startingPointsByStep )
		RuiSetInt( xpChallengeData.rui, "challengeProgressEnd", progressEndValue )
		RuiSetInt( xpChallengeData.rui, "challengeGoal", currentGoalValue )
		RuiSetInt( xpChallengeData.rui, "bpLevelsAwarded", Challenge_GetBattlepassLevelsReward( xpChallengeData.progressBarFlavor, currentTier ) )
		RuiSetInt( xpChallengeData.rui, "challengePointsAwarded", Challenge_GetXPReward( xpChallengeData.progressBarFlavor, currentTier ) )
		RuiSetInt( xpChallengeData.rui, "tierCount", Challenge_GetTierCount( xpChallengeData.progressBarFlavor ) )
		RuiSetInt( xpChallengeData.rui, "activeTier", currentTier )
		RuiSetInt( xpChallengeData.rui, "starsOrXPIncrement", xpChallengeData.pointsToAddTotal )
		RuiSetBool( xpChallengeData.rui, "isInfinite", Challenge_LastTierIsInfinite( xpChallengeData.progressBarFlavor ) )
		RuiSetBool( xpChallengeData.rui, "altColor", true )
		RuiSetBool( xpChallengeData.rui, "displayStarsIncrement", isUpdatingStars )
		RuiSetBool( xpChallengeData.rui, "displayXPIncrement", !isUpdatingStars )
		RuiSetGameTime( xpChallengeData.rui, "fillStartTime", Time() )
		RuiSetGameTime( xpChallengeData.rui, "fillEndTime", Time() + currentFillDuration )

		RuiSetString( xpEarned3Rui, "line1ValueString", string(xpChallengeData.challengeStarsAndXpEarned) )

		if ( needsReset )
		{
			pointsToAddByStep -= currentGoalValue - startingPointsByStep
			startingPointsByStep = 0
		}
		else
		{
			progressComplete = true
		}

		SkippableWait( currentFillDuration, "UI_Menu_MatchSummary_XPBar" )
		StopUISoundByName( "UI_Menu_MatchSummary_XPBar" )

		if ( needsReset || progressEndValue == currentGoalValue )
		{
			if ( file.isFirstTime && !IsSkippableWaitSkipped() )
				EmitUISound( GetGlobalSettingsString( ItemFlavor_GetAsset( activeBattlePass ), "levelUpSound" ) )

			xpChallengeData.challengesCompleted++
			xpChallengeData.battlePassLevelsEarned++
			xpChallengeData.currentPassLevel++

			//
			RuiDestroyNestedIfAlive( passProgressRUI, "currentBadgeHandle" )
			CreateNestedGladiatorCardBadge( passProgressRUI, "currentBadgeHandle", ToEHI( player ), bpLevelBadge, 0, dummy, xpChallengeData.currentPassLevel + 1 )

			//
			array<BattlePassReward> nextPassRewardArray = GetBattlePassLevelRewards( activeBattlePass, xpChallengeData.currentPassLevel )
			RuiDestroyNestedIfAlive( passProgressRUI, "reward1Handle" )
			if ( nextPassRewardArray.len() >= 1 )
			{
				var reward1NestedRui = RuiCreateNested( passProgressRUI, "reward1Handle", $"ui/battle_pass_reward_button.rpak" )
				RuiSetBool( reward1NestedRui, "isRewardBar", true )
				InitBattlePassRewardButtonRui( reward1NestedRui, nextPassRewardArray[0] )
			}

			RuiDestroyNestedIfAlive( passProgressRUI, "reward2Handle" )
			if ( nextPassRewardArray.len() >= 2 )
			{
				var reward2NestedRui = RuiCreateNested( passProgressRUI, "reward2Handle", $"ui/battle_pass_reward_button.rpak" )
				RuiSetBool( reward2NestedRui, "isRewardBar", true )
				InitBattlePassRewardButtonRui( reward2NestedRui, nextPassRewardArray[1] )
			}

			//
			RuiSetGameTime( passProgressRUI, "badgePulseStartTime", Time() )

			//
			RuiSetString( xpEarned3Rui, "line1ValueString", string(xpChallengeData.challengesCompleted) )

			//
			if ( xpChallengeData.currentPassLevel <= GetBattlePassMaxLevelIndex( activeBattlePass ) + 1 )
				RuiSetString( xpEarned3Rui, "line2ValueString", string(xpChallengeData.battlePassLevelsEarned) )
		}

		SkippableWait( CHALLENGE_POST_FILL_DELAY )

		RuiSetBool( xpChallengeData.rui, "displayStarsIncrement", false )
		RuiSetBool( xpChallengeData.rui, "displayXPIncrement", false )

		if ( progressComplete )
			break

		if ( currentTier < Challenge_GetTierCount( xpChallengeData.progressBarFlavor ) - 1 )
			currentTier++

		needsReset = false
	}

	xpChallengeData.tierStart = currentTier
	xpChallengeData.startingPoints = progressEndValue
	xpChallengeData.pointsToAddTotal = 0
}

void function OnContinue_Activate( var button )
{
	file.skippableWaitSkipped = true

	if ( CanNavigateBack() && GetActiveMenu() == file.menu )
		CloseActiveMenu()
}

void function OnNavigateBack()
{
	if ( !CanNavigateBack() )
		return

	OnContinue_Activate( null )
}