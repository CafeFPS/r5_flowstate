global function InitRankedInfoMenu
global function OpenRankedInfoPage
global function InitRankedScoreBarRui
global function InitRankedScoreBarRuiForDoubleBadge

#if R5DEV
global function TestScoreBar
#endif

struct
{
	var menu
} file

void function InitRankedInfoMenu( var newMenuArg ) //
{
	var menu = GetMenu( "RankedInfoMenu" )
	file.menu = menu

	AddMenuEventHandler( menu, eUIEvent.MENU_OPEN, OnRankedInfoMenu_Open )
	AddMenuEventHandler( menu, eUIEvent.MENU_CLOSE, OnRankedInfoMenu_Close )

	AddMenuEventHandler( menu, eUIEvent.MENU_SHOW, OnRankedInfoMenu_Show )
	AddMenuEventHandler( menu, eUIEvent.MENU_HIDE, OnRankedInfoMenu_Hide )

	AddMenuFooterOption( menu, LEFT, BUTTON_B, true, "#B_BUTTON_BACK", "#B_BUTTON_BACK" )
	AddMenuFooterOption( menu, LEFT, BUTTON_Y, true, "#Y_BUTTON_VIEW_REWARDS", "#VIEW_REWARDS", OnViewRewards, ShouldShowRewards )
}

void function OpenRankedInfoPage( var button )
{
	AdvanceMenu( file.menu )
}

void function OnRankedInfoMenu_Open()
{
	UI_SetPresentationType( ePresentationType.WEAPON_CATEGORY )

	int currentScore                   = GetPlayerRankScore( GetUIPlayer() )
	array<RankedTierData> divisions    = Ranked_GetTiers()
	RankedDivisionData currentRank     = GetCurrentRankedDivisionFromScore( currentScore )
	RankedTierData currentDivision     = currentRank.tier
	RankedTierData ornull nextDivision = Ranked_GetNextTierData( currentRank.tier )

	array< RankedDivisionData > divisionData = Ranked_GetRankedDivisionDataForTier( currentRank.tier )

	array<var> panels = GetElementsByClassname( file.menu, "RankedInfoPanel" )

	foreach ( panel in panels )
	{
		InitRankedInfoPanel( panel, divisions )
	}

	var mainRui = Hud_GetRui( Hud_GetChild( file.menu, "InfoMain" ) )
	RuiSetInt( mainRui, "divisionIdx", currentDivision.index )
	RuiSetInt( mainRui, "currentScore", currentScore )
	RuiSetBool( mainRui, "inSeason", IsRankedInSeason() )
	RuiSetString( mainRui, "currentRankString", currentRank.divisionName )


	var scoringRui = Hud_GetRui( Hud_GetChild( file.menu, "InfoScoring" ) )
	RuiSetFloat( scoringRui, "lineDisplayTime", 0.01 )
	RuiSetFloat( scoringRui, "startDelay", 0.0 )
	RuiSetGameTime( scoringRui, "startTime", 0 )
	RuiSetInt( scoringRui, "numLines", divisions.len() )
	for ( int i=0; i<divisions.len(); i++ )
	{
		int idx              = i+1
		RankedTierData d     = divisions[i]
		string scoringString = d.entryCost == 0 ? Localize( "#RANKED_FREE" ) : Localize( "#RANKED_COST", d.entryCost )
		RuiSetString( scoringRui, "line" + idx + "KeyString", d.name )
		RuiSetString( scoringRui, "line" + idx + "ValueString", scoringString )
		RuiSetColorAlpha( scoringRui, "line" + idx + "Color", <1,1,1>, 1 )

		RuiSetInt( mainRui, "entryFee" + i, d.entryCost )
	}

	var scoreBarRui = Hud_GetRui( Hud_GetChild( file.menu, "RankedProgressBar" ) )
	InitRankedScoreBarRui( scoreBarRui, currentScore, Ranked_GetDisplayNumberForRuiBadge( GetUIPlayer() ) )

	var rankedScoringTableRui = Hud_GetRui( Hud_GetChild( file.menu, "RankedScoringTable" ) )
	RuiSetInt( rankedScoringTableRui, "eleventhPlaceRP", Ranked_GetPointsForPlacement( 11 ) )
	RuiSetInt( rankedScoringTableRui, "tenthPlaceRP", Ranked_GetPointsForPlacement( 10 ) )
	RuiSetInt( rankedScoringTableRui, "eighthPlaceRP", Ranked_GetPointsForPlacement( 8 ) )
	RuiSetInt( rankedScoringTableRui, "sixthPlaceRP", Ranked_GetPointsForPlacement( 6 ) )
	RuiSetInt( rankedScoringTableRui, "fourthPlaceRP", Ranked_GetPointsForPlacement( 4 ) )
	RuiSetInt( rankedScoringTableRui, "secondPlaceRP", Ranked_GetPointsForPlacement( 2 ) )
	RuiSetInt( rankedScoringTableRui, "firstPlaceRP", Ranked_GetPointsForPlacement( 1 ) )

	RuiSetInt( rankedScoringTableRui, "eleventhPlaceKillAssistMultiplier", Ranked_GetPointsPerKillForPlacement( 11 ) )
	RuiSetInt( rankedScoringTableRui, "tenthPlaceKillAssistMultiplier", Ranked_GetPointsPerKillForPlacement( 10 ) )
	RuiSetInt( rankedScoringTableRui, "fifthPlaceKillAssistMultiplier", Ranked_GetPointsPerKillForPlacement( 5 ) )
	RuiSetInt( rankedScoringTableRui, "thirdPlaceKillAssistMultiplier", Ranked_GetPointsPerKillForPlacement( 3 ) )
	RuiSetInt( rankedScoringTableRui, "firstPlaceKillAssistMultiplier", Ranked_GetPointsPerKillForPlacement( 1 ) )

	int maxKills = Ranked_GetKillsAndAssistsPointCap( 1 ) / Ranked_GetPointsPerKillForPlacement( 1 )

	RuiSetInt( rankedScoringTableRui, "killAndAssistsCap", maxKills )

}

void function InitRankedScoreBarRuiForDoubleBadge( var rui, int score, int ladderPosition )
{
	for ( int i=0; i<5; i++ )
	{
		RuiDestroyNestedIfAlive( rui, "rankedBadgeHandle" + i )
	}

	RuiSetBool( rui, "forceDoubleBadge", true )

	RankedDivisionData currentRank = GetCurrentRankedDivisionFromScore( score )
	RankedTierData currentDivision = currentRank.tier

	RuiSetGameTime( rui, "animStartTime", RUI_BADGAMETIME )
	RuiSetInt( rui, "currentDivisionIdx", currentDivision.index )
	RuiFillInRankedLadderPos( rui, ladderPosition )

	//
	RuiSetImage( rui, "icon0" , currentDivision.icon )
	RuiSetString( rui, "badgeString0" , currentRank.iconString )
	RuiSetInt( rui, "badgeScore0", score )
	CreateNestedRankedRui( rui, currentRank.tier, "rankedBadgeHandle0" )

	RuiSetImage( rui, "icon3" , currentDivision.icon )
	RuiSetString( rui, "badgeString3" , currentRank.iconString )
	RuiSetInt( rui, "badgeScore3", currentRank.scoreMin )
	CreateNestedRankedRui( rui, currentRank.tier, "rankedBadgeHandle3" )

	RuiSetInt( rui, "currentScore" , score )
	RuiSetInt( rui, "startScore" , currentRank.scoreMin )

	RankedDivisionData ornull nextRank = GetNextRankedDivisionFromScore( score )

	RuiSetBool( rui, "showSingleBadge", nextRank == null )

	if ( nextRank != null )
	{
		expect RankedDivisionData( nextRank )
		RankedTierData nextDivision = nextRank.tier

		RuiSetBool( rui, "showSingleBadge", nextRank == currentRank )

		RuiSetInt( rui, "endScore" , nextRank.scoreMin )
		RuiSetString( rui, "badgeString4" , nextRank.iconString  )
		RuiSetInt( rui, "badgeScore4", nextRank.scoreMin )
		RuiSetImage( rui, "icon4", nextDivision.icon )
		RuiSetInt( rui, "forcedNextDivisionIdx", nextDivision.index )
		CreateNestedRankedRui( rui, nextRank.tier, "rankedBadgeHandle4" )
	}
}

void function InitRankedScoreBarRui( var rui, int score, int ladderPosition )
{
	array<RankedTierData> divisions = Ranked_GetTiers()
	RankedDivisionData currentRank  = GetCurrentRankedDivisionFromScore( score )
	RankedTierData currentTier      = currentRank.tier
	RankedTierData ornull nextTier  = Ranked_GetNextTierData( currentRank.tier )

	array< RankedDivisionData > divisionData = Ranked_GetRankedDivisionDataForTier( currentRank.tier )

	RuiSetGameTime( rui, "animStartTime", RUI_BADGAMETIME )
	RuiSetInt( rui, "currentDivisionIdx", currentTier.index )
	RuiFillInRankedLadderPos( rui, ladderPosition )

	for ( int i=0; i<5; i++ )
	{
		RuiDestroyNestedIfAlive( rui, "rankedBadgeHandle" + i )
	}

	for ( int i=0; i<divisionData.len(); i++ )
	{
		RankedDivisionData data = divisionData[ i ]
		RuiSetImage( rui, "icon" + i , currentTier.icon )
		RuiSetString( rui, "badgeString" + i , data.iconString )
		RuiSetInt( rui, "badgeScore" + i, data.scoreMin )
		var nestedRuiHandle = CreateNestedRankedRui( rui, data.tier, "rankedBadgeHandle" + i )
	}

	RuiSetInt( rui, "currentScore" , score )
	RuiSetInt( rui, "startScore" , divisionData[0].scoreMin )

	if ( nextTier != null )
	{
		expect RankedTierData( nextTier )
		RankedDivisionData firstRank = Ranked_GetRankedDivisionDataForTier( nextTier )[0]

		RuiSetInt( rui, "endScore" , firstRank.scoreMin  )
		RuiSetString( rui, "badgeString4" , firstRank.iconString  )
		RuiSetInt( rui, "badgeScore4", firstRank.scoreMin )
		RuiSetImage( rui, "icon4", nextTier.icon )
		var nestedRuiHandle = CreateNestedRankedRui( rui, firstRank.tier, "rankedBadgeHandle4" )
	}

	RuiSetString( rui, "currentRankString", currentRank.divisionName )

	RuiSetBool( rui, "showSingleBadge", divisionData.len() == 1 )
}

void function InitRankedInfoPanel( var panel, array<RankedTierData> tiers )
{
	int scriptID = int( Hud_GetScriptID( panel ) )
	if ( scriptID >= tiers.len() )
	{
		Hud_Hide( panel )
		return
	}

	Hud_Show( panel )

	RankedTierData d = tiers[scriptID]
	var rui          = Hud_GetRui( panel )

	RankedDivisionData currentRank = GetCurrentRankedDivisionFromScore( GetPlayerRankScore( GetUIPlayer() ) )

	RuiSetString( rui, "name", d.name )
	RuiSetInt( rui, "minScore", d.scoreMin )
	RuiSetInt( rui, "rankTier", scriptID )
	RuiSetImage( rui, "bgImage", d.bgImage )
	RuiSetBool( rui, "isLocked", d.index > currentRank.tier.index )

	RuiSetBool( rui, "isCurrent", currentRank.tier == d )

	var myParent = Hud_GetParent( panel )

	for ( int i=0; i<d.rewards.len(); i++ )
	{
		RankedReward reward = d.rewards[i]
		var button = Hud_GetChild( myParent, "RewardButton" + scriptID + "_" + i )

		var btRui = Hud_GetRui( button )
		RuiSetImage( btRui, "buttonImage", reward.previewIcon )
		RuiSetInt( btRui, "tier", scriptID )
		RuiSetBool( btRui, "showBox", reward.previewIconShowBox )
		RuiSetBool( btRui, "isLocked", d.index > currentRank.tier.index )

		ToolTipData ttd
		ttd.titleText = reward.previewName
		ttd.descText = "#RANKED_REWARD"
		Hud_SetToolTipData( button, ttd )

		if ( GetCurrentPlaylistVarBool( "ranked_reward_show_button", true ) )
			Hud_Show( button )
		else
			Hud_Hide( button )

		int idx = (i+1)

		if ( GetCurrentPlaylistVarBool( "ranked_reward_show_text", false ) )
		{
			string tierName = string( d.index )
			string rewardString = GetCurrentPlaylistVarString( "ranked_reward_override_" + tierName + "_" + idx, reward.previewName )
			RuiSetString( rui, "rewardString" + idx, rewardString )
		}
		else
			RuiSetString( rui, "rewardString" + idx, "" )
	}
}

void function OnRankedInfoMenu_Close()
{

}

void function OnRankedInfoMenu_Show()
{

}

void function OnRankedInfoMenu_Hide()
{

}

void function TestScoreBar( int startScore = 370, int endScore = 450  )
{
	var scoreBarRui = Hud_GetRui( Hud_GetChild( file.menu, "RankedProgressBar" ) )
	RuiSetGameTime( scoreBarRui, "animStartTime", Time() )
	RuiSetInt( scoreBarRui, "animStartScore", startScore )
	RuiSetInt( scoreBarRui, "currentScore", endScore )

}

void function OnViewRewards( var button )
{
	string creditsURL = Localize( GetCurrentPlaylistVarString( "show_ranked_rewards_link", "https://www.ea.com/games/apex-legends" ) )
	LaunchExternalWebBrowser( creditsURL, WEBBROWSER_FLAG_NONE )
}

bool function ShouldShowRewards()
{
	return GetCurrentPlaylistVarString( "show_ranked_rewards_link", "" ) != ""
}
