global function InitPostGameRankedMenu
global function OpenRankedSummary

const string POSTGAME_LINE_ITEM = "UI_Menu_MatchSummary_Ranked_XPBreakdown"
const string POSTGAME_XP_INCREASE = "UI_Menu_MatchSummary_Ranked_XPBar_Increase"
//
const float PROGRESS_BAR_FILL_TIME = 5.0
const float PROGRESS_BAR_FILL_TIME_FAST = 2.0
const float LINE_DISPLAY_TIME = 0.75

struct
{
	var  menu
	var continueButton
	var menuHeaderRui
	bool showQuickVersion
	bool skippableWaitSkipped = false
	bool disableNavigateBack = true
	bool isFirstTime = false
	bool buttonsRegistered = false
} file

void function InitPostGameRankedMenu( var newMenuArg ) //
{
	var menu = GetMenu( "PostGameRankedMenu" )
	file.menu = menu

	AddMenuEventHandler( menu, eUIEvent.MENU_OPEN, OnPostGameRankedMenu_Open )
	AddMenuEventHandler( menu, eUIEvent.MENU_CLOSE, OnPostGameRankedMenu_Close )

	AddMenuEventHandler( menu, eUIEvent.MENU_SHOW, OnPostGameRankedMenu_Show )
	AddMenuEventHandler( menu, eUIEvent.MENU_HIDE, OnPostGameRankedMenu_Hide )

	AddMenuEventHandler( menu, eUIEvent.MENU_NAVIGATE_BACK, OnNavigateBack )

	file.continueButton = Hud_GetChild( menu, "ContinueButton" )

	Hud_AddEventHandler( file.continueButton, UIE_CLICK, OnContinue_Activate )
	AddMenuFooterOption( menu, LEFT, BUTTON_B, true, "#B_BUTTON_CLOSE", "#B_BUTTON_CLOSE", null, CanNavigateBack )
	AddMenuFooterOption( menu, LEFT, BUTTON_BACK, true, "", "", CloseRankedSummary, CanNavigateBack )

	RegisterSignal( "OnPostGameRankedMenu_Close" )


	file.menuHeaderRui = Hud_GetRui( Hud_GetChild( menu, "MenuHeader" ) )

	RuiSetString( file.menuHeaderRui, "menuName", "#MATCH_SUMMARY" )
}

void function OnPostGameRankedMenu_Open()
{
	Hud_Hide( Hud_GetChild( file.menu, "RewardDisplay" ) )
}

void function OnPostGameRankedMenu_Show()
{
	if ( !IsFullyConnected() )
		return

	bool isFirstTime = GetPersistentVarAsInt( "showGameSummary" ) != 0
	if ( isFirstTime && TryOpenSurvey( eSurveyType.POSTGAME ) )
	{
		while ( IsDialog( GetActiveMenu() ) )
			WaitFrame()
	}

	{

		var rui = Hud_GetRui( Hud_GetChild( file.menu, "SummaryBox" ) )
		RuiSetString( rui, "titleText", "#RANKED_TITLE" )

		ItemFlavor ornull rankedPeriod = GetActiveRankedPeriod( GetUnixTimestamp() )
		if ( rankedPeriod != null )
		{
			expect ItemFlavor( rankedPeriod )
			RuiSetString( rui, "subTitleText", ItemFlavor_GetShortName( rankedPeriod ) )
		}
		else
		{
			RuiSetString( rui, "subTitleText", "#RANKED_OFF_SEASON_SUBTITLE" )
		}
	}

	{
		var hudElem = Hud_GetChild( file.menu, "RankedProgressBar" )
		var barRui = Hud_GetRui( hudElem )
		RuiSetGameTime( barRui, "animStartTime", RUI_BADGAMETIME )
	}

	{
		var rui = Hud_GetRui( Hud_GetChild( file.menu, "XPEarned1" ) )
		RuiSetGameTime( rui, "startTime", Time() + 999999 )
	}

	if ( !file.buttonsRegistered )
	{
		RegisterButtonPressedCallback( BUTTON_A, OnContinue_Activate )
		RegisterButtonPressedCallback( KEY_SPACE, OnContinue_Activate )
		file.buttonsRegistered = true
	}

	UI_SetPresentationType( ePresentationType.WEAPON_CATEGORY )

	var matchRankRui = Hud_GetRui( Hud_GetChild( file.menu, "MatchRank" ) )

	RuiSetInt( matchRankRui, "squadRank", GetPersistentVarAsInt( "lastGameRank" ) )
	RuiSetInt( matchRankRui, "totalPlayers", GetPersistentVarAsInt( "lastGameSquads" ) )
	int elapsedTime = GetUnixTimestamp() - GetPersistentVarAsInt( "lastGameTime" )

	RuiSetString( matchRankRui, "lastPlayedText", Localize( "#EOG_LAST_PLAYED", GetFormattedIntByType( elapsedTime, eNumericDisplayType.TIME_MINUTES_LONG ) ) )

	thread AnimateXPBar( file.isFirstTime )
}

void function AnimateXPBar( bool isFirstTime ) // TODO: IMPLEMENT
{
	// EndSignal( uiGlobal.signalDummy, "OnPostGameRankedMenu_Close" )

	// entity player                   = GetUIPlayer()
	// int score                       = GetPlayerRankScore( player )
	// RankedDivisionData currentRank  = GetCurrentRankedDivisionFromScore( score )
	// int previousScore               = expect int( GetRankedPersistenceData( player, "previousRankedScore" ) )
	// RankedDivisionData previousRank = GetCurrentRankedDivisionFromScore( previousScore )

	// bool previousGameWasAbandonded = expect bool( GetRankedPersistenceData( player, "lastGameRankedAbandon" ) )

	// bool wasNetDecreaseInRankedScore = previousScore >= score
	// bool quick                       = !isFirstTime
	// file.disableNavigateBack = !quick
	// file.showQuickVersion = quick

	// Hud_Show( file.continueButton )

	// var rui = Hud_GetRui( Hud_GetChild( file.menu, "XPEarned1" ) )
	// if ( IsRankedInSeason()  )
	// 	RuiSetString( rui, "headerText", "#RANKED_TITLE_SCORE_REPORT" )
	// else
	// 	RuiSetString( rui, "headerText", "#RANKED_OFF_SEASON_TITLE_SCORE_REPORT" )

	// if ( previousGameWasAbandonded )
	// 	RuiSetString( rui, "headerText", "#RANKED_TITLE_ABANDON" )

	// int entryCost = expect int ( GetRankedPersistenceData( player, "lastGameEntryCost" ) )
	// RuiSetString( rui, "line1KeyString", Localize( "#RANKED_ENTRY_COST", Localize( previousRank.tier.name ) ) )
	// RuiSetString( rui, "line1ValueString", string(entryCost) )
	// RuiSetColorAlpha( rui, "line1Color", <1,1,1>, 1 )

	// int placement                 = GetPersistentVarAsInt( "lastGameRank" )
	// int numKills                  = GetXPEventCount( player, XP_TYPE.KILL )
	// int numAssists                = expect int ( GetRankedPersistenceData( player, "lastGameAssistCount" ) )
	// int pointsPerKillForPlacement = Ranked_GetPointsPerKillForPlacement( placement )
	// RuiSetString( rui, "line2KeyString", Localize( "#RANKED_KILL_SCORE", numKills, numAssists, pointsPerKillForPlacement ) )
	// RuiSetString( rui, "line2ValueString", string ( GetRankedPersistenceData( player, "lastGameKillScore" )  ) )
	// RuiSetColorAlpha( rui, "line2Color", <1,1,1>, 1 )

	// int placementScore = expect int( GetRankedPersistenceData( player, "lastGamePlacementScore" ) )
	// RuiSetString( rui, "line3KeyString", Localize( "#RANKED_MATCH_PLACEMENT" , placement ) )
	// string placementScoreString = previousGameWasAbandonded ? Localize( "#RANKED_SCORE_ABANDON", placementScore ) : string ( placementScore )
	// RuiSetString( rui, "line3ValueString", placementScoreString )
	// RuiSetColorAlpha( rui, "line3Color", <1,1,1>, 1 )

	// int numLines = 3
	// bool rankForgiveness = expect bool( GetRankedPersistenceData( player, "lastGameRankedForgiveness" ) )
	// Assert( !( previousGameWasAbandonded &&  rankForgiveness )  ) //

	// int lastGameLossProtectionAdjustment = expect int ( GetRankedPersistenceData( player, "lastGameLossProtectionAdjustment" ) )
	// if ( rankForgiveness && lastGameLossProtectionAdjustment != 0  )
	// {
	// 	RuiSetString( rui, "line4KeyString", "#RANKED_FORGIVENESS" )
	// 	RuiSetString( rui, "line4ValueString", string( lastGameLossProtectionAdjustment ) )
	// 	RuiSetColorAlpha( rui, "line4Color", <1,1,1>, 1 )
	// 	numLines = 4
	// }
	// else if ( previousGameWasAbandonded  )
	// {
	// 	int abandonPenalty = expect int( GetRankedPersistenceData( player, "lastGamePenaltyPointsForAbandoning" ) )
	// 	RuiSetString( rui, "line4KeyString", "#RANKED_ABANDON_PENALTY" )
	// 	RuiSetString( rui, "line4ValueString", Localize( "#RANKED_SCORE_ABANDON", abandonPenalty ) )
	// 	RuiSetColorAlpha( rui, "line4Color", <1,1,1>, 1 )
	// 	numLines = 4
	// }

	// int tierDerankingProtectionAdjustment = expect int (GetRankedPersistenceData( player, "lastGameTierDerankingProtectionAdjustment" ) )
	// if ( tierDerankingProtectionAdjustment > 0 ) //
	// {
	// 	if ( previousGameWasAbandonded  )
	// 	{
	// 		RuiSetString( rui, "line5KeyString", "#RANKED_TIER_DERANKING_PROTECTION" )
	// 		RuiSetString( rui, "line5ValueString", string( tierDerankingProtectionAdjustment) )
	// 		RuiSetColorAlpha( rui, "line5Color", <1,1,1>, 1 )
	// 		numLines = 5
	// 	}
	// 	else
	// 	{
	// 		RuiSetString( rui, "line4KeyString", "#RANKED_TIER_DERANKING_PROTECTION" )
	// 		RuiSetString( rui, "line4ValueString", string( tierDerankingProtectionAdjustment ) )
	// 		RuiSetColorAlpha( rui, "line4Color", <1,1,1>, 1 )
	// 		numLines = 4
	// 	}
	// }

	// RuiSetFloat( rui, "lineDisplayTime", LINE_DISPLAY_TIME )
	// RuiSetFloat( rui, "startDelay", 0.0 )
	// RuiSetGameTime( rui, "startTime", Time() + 0.5 )
	// RuiSetInt( rui, "numLines", numLines )

	// var scoreAdjustElem = Hud_GetChild( file.menu, "RankedScoreAdjustment" )
	// var scoreAdjustRui = Hud_GetRui( scoreAdjustElem )
	// var hudElem = Hud_GetChild( file.menu, "RankedProgressBar" )
	// var barRui = Hud_GetRui( hudElem )
	// RuiSetBool( barRui, "showPointsProgress", true )
	// RuiSetGameTime( barRui, "animStartTime", RUI_BADGAMETIME )

	// int adjust = 0
	// if ( numLines == 4 )
	// 	adjust = 15
	// else if ( numLines == 5 )
	// 	adjust = 30

	// Hud_SetY( scoreAdjustElem, Hud_GetBaseY( scoreAdjustElem ) + adjust )

	// int scoreAdjust = score-previousScore
	// RuiSetInt( scoreAdjustRui, "scoreAdjustment", scoreAdjust )
	// RuiSetBool( scoreAdjustRui, "demoted", currentRank.index < previousRank.index )
	// RuiSetBool( scoreAdjustRui, "inSeason", IsRankedInSeason() )

	// if ( currentRank.index < previousRank.index )
	// {
	// 	RuiSetString( scoreAdjustRui, "demotedRank", currentRank.divisionName )
	// }

	// int ladderPosition = Ranked_GetLadderPosition( GetUIPlayer() )

	// if ( quick || wasNetDecreaseInRankedScore )
	// 	InitRankedScoreBarRuiForDoubleBadge( barRui, score, ladderPosition )
	// else
	// 	InitRankedScoreBarRuiForDoubleBadge( barRui, previousScore, ladderPosition )

	// Hud_Hide( hudElem )
	// Hud_Hide( scoreAdjustElem )

	// OnThreadEnd(
	// 	function () : ( hudElem )
	// 	{
	// 		Hud_Hide( Hud_GetChild( file.menu, "RewardDisplay" ) )
	// 		Hud_Hide( Hud_GetChild( file.menu, "MovingBoxBG" ) )
	// 		Hud_Show( hudElem )
	// 		file.disableNavigateBack = false
	// 		UpdateFooterOptions()
	// 		StopUISoundByName( POSTGAME_XP_INCREASE )
	// 	}
	// )

	// ResetSkippableWait()

	// for ( int lineIndex = 0; lineIndex < numLines; lineIndex++ )
	// {
	// 	if ( IsSkippableWaitSkipped() )
	// 		continue

	// 	waitthread SkippableWait( LINE_DISPLAY_TIME, POSTGAME_LINE_ITEM )
	// }

	// RuiSetFloat( rui, "startDelay", -50.0 )
	// RuiSetGameTime( rui, "startTime", Time() - 9999.0 )

	// Hud_Show( scoreAdjustElem )

	// ResetSkippableWait()
	// waitthread SkippableWait( LINE_DISPLAY_TIME, "UI_Menu_MatchSummary_Ranked_XPTotal" )

	// Hud_Show( hudElem )
	// int ranksToPopulate = ( currentRank.index - previousRank.index ) + 1

	// int scoreStart = previousScore

	// if  (!quick && !wasNetDecreaseInRankedScore ) //
	// {
	// 	InitRankedScoreBarRuiForDoubleBadge( barRui, scoreStart, ladderPosition )
	// 	float delay = 0.25
	// 	wait delay

	// 	for ( int index = 0; index < ranksToPopulate; index++ )
	// 	{
	// 		RankedDivisionData rd_start = GetCurrentRankedDivisionFromScore( scoreStart )
	// 		RankedTierData rdiv_current = rd_start.tier
	// 		RankedDivisionData ornull rd_next

	// 		rd_next = GetNextRankedDivisionFromScore( scoreStart )

	// 		int scoreEnd = scoreStart

	// 		if ( rd_next != null )
	// 		{
	// 			InitRankedScoreBarRuiForDoubleBadge( barRui, scoreStart, ladderPosition )

	// 			expect RankedDivisionData( rd_next )
	// 			RankedTierData rdiv_next = rd_next.tier

	// 			scoreEnd = minint( score, rd_next.scoreMin )

	// 			float frac = float( abs( scoreEnd - scoreStart ) ) / float( abs( rd_next.scoreMin - rd_start.scoreMin ) )
	// 			printt( frac )
	// 			float animDuration = 2.0 * frac

	// 			RuiSetGameTime( barRui, "animStartTime", Time() + delay )
	// 			RuiSetFloat( barRui, "animDuration", animDuration )
	// 			RuiSetInt( barRui, "currentScore", scoreEnd )
	// 			RuiSetInt( barRui, "animStartScore", scoreStart )

	// 			waitthread SkippableWait( animDuration + 0.1, POSTGAME_XP_INCREASE )
	// 			StopUISoundByName( POSTGAME_XP_INCREASE )

	// 			if ( (index < ranksToPopulate-1) && isFirstTime )
	// 			{
	// 				wait 0.1

	// 				Hud_Show( Hud_GetChild( file.menu, "MovingBoxBG" ) )
	// 				Hud_Show( Hud_GetChild( file.menu, "RewardDisplay" ) )
	// 				var rewardDisplayRui = Hud_GetRui( Hud_GetChild( file.menu, "RewardDisplay" ) )
	// 				RuiDestroyNestedIfAlive( rewardDisplayRui, "levelUpAnimHandle" )

	// 				float RANK_UP_TIME = 3.5

	// 				if ( rdiv_current != rdiv_next )
	// 				{
	// 					var nestedRuiHandle = RuiCreateNested( rewardDisplayRui, "levelUpAnimHandle", rdiv_current.levelUpRuiAsset )
	// 					RuiSetGameTime( nestedRuiHandle, "startTime", Time() )

	// 					string sound = "UI_Menu_MatchSummary_Ranked_Promotion"
	// 					if ( rdiv_next.index == 5 )
	// 						sound = "UI_Menu_MatchSummary_Ranked_PromotionApex"

	// 					if ( rdiv_next.promotionAnnouncement != "" )
	// 						Ranked_PlayRankedLobbyCharacterDialogue(  rdiv_next.promotionAnnouncement, 1.6  )

	// 					EmitUISound( sound ) //
	// 				}
	// 				else
	// 				{
	// 					RANK_UP_TIME = 3.5
	// 					var nestedRuiHandle = RuiCreateNested( rewardDisplayRui, "levelUpAnimHandle", $"ui/rank_division_up_anim.rpak" )
	// 					RuiSetGameTime( nestedRuiHandle, "startTime", Time() )
	// 					RuiSetString( nestedRuiHandle, "oldDivision", Localize(rd_start.emblemText))
	// 					RuiSetString( nestedRuiHandle, "newDivision", Localize(rd_next.emblemText))
	// 					RuiSetImage( nestedRuiHandle, "rankEmblemImg", rdiv_current.icon )
	// 					//
	// 					EmitUISound( "UI_Menu_MatchSummary_Ranked_RankUp" )

	// 					Ranked_PlayRankedLobbyCharacterDialogue( "glad_rankUp", 1.6  )
	// 				}

	// 				wait RANK_UP_TIME + 0.1

	// 				Hud_Hide( Hud_GetChild( file.menu, "MovingBoxBG" ) )
	// 				Hud_Hide( Hud_GetChild( file.menu, "RewardDisplay" ) )
	// 			}

	// 			scoreStart = scoreEnd
	// 		}

	// 		InitRankedScoreBarRuiForDoubleBadge( barRui, scoreEnd, ladderPosition )
	// 	}

	// 	InitRankedScoreBarRuiForDoubleBadge( barRui, score, ladderPosition )
	// }

	// if ( !quick && wasNetDecreaseInRankedScore && currentRank.index < previousRank.index )
	// {
	// 	Ranked_PlayRankedLobbyCharacterDialogue( "glad_rankDown"  )
	// }

}

void function OnPostGameRankedMenu_Close()
{
}

void function OnContinue_Activate( var button )
{
	file.skippableWaitSkipped = true

	//
	{
		if ( !file.disableNavigateBack )
			CloseRankedSummary( null )
	}
}

void function OnPostGameRankedMenu_Hide()
{
	Signal( uiGlobal.signalDummy, "OnPostGameRankedMenu_Close" )

	if ( file.buttonsRegistered )
	{
		DeregisterButtonPressedCallback( BUTTON_A, OnContinue_Activate )
		DeregisterButtonPressedCallback( KEY_SPACE, OnContinue_Activate )
		file.buttonsRegistered = false
	}
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


void function OnNavigateBack()
{
	if ( !CanNavigateBack() )
		return

	CloseRankedSummary( null )
}

void function CloseRankedSummary( var button )
{
	if ( GetActiveMenu() == file.menu )
		thread CloseActiveMenu()
}

void function OpenRankedSummary( bool firstTime )
{
	file.isFirstTime = firstTime
	AdvanceMenu( file.menu )
}
