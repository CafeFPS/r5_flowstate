#if UI
global function ShPlayerStatCards_Init

global function StatCard_ConstructStatCardProgressBar
global function StatCard_ChangeCardDisplayType
global function StatCard_ConstructAccountProgressBar
global function StatCard_ConstructBattlePassLevelBadge
global function StatCard_ConstructRankedBadge
global function StatCard_UpdateAndDisplayStats
global function StatCard_ConstructTopLegendStatCard
global function StatCard_ConstructTopWeaponStatCard
global function StatCard_SetStatValueDisplay
global function StatCard_InitToolTipStringTables
global function StatCard_ClearToolTipStringTables
global function StatCard_AddStatToolTipString
global function StatCard_SetStatToolTip
global function StatsScreen_SetPanelRui

#endif // UI

global function StatCard_GetAvailableSeasons
global function StatCard_GetAvailableSeasonsAndRankedPeriods


global enum eStatCardType
{
	CAREER,
	SEASON,
	RANKEDPERIOD,
	WEAPON,
	LEGEND,
	GRAPHS,
}

global enum eStatDisplayType
{
	STATS,
	WEAPONS,
	LEGENDS,
	GRAPHS
}

enum eStatCardSection
{
	HEADER,
	HEADERTOOLTIP,
	BODY,
	BODYTOOLTIP,
	WEAPONS,
	LEGENDS,
}

enum eStatCalcMethod
{
	SIMPLE,
	CHARACTER_AGGREGATE,
	CHARACTER_HIGHEST,
	WEAPON_AGGREGATE,
	WEAPON_HIGHEST,
	MATH_ADD,
	MATH_SUB,
	MATH_MULTIPLY,
	MATH_DIVIDE,
	MATH_WINRATE,
}

struct StatCardEntry
{
	int    cardType
	int    section
	int    calcMethod
	string label
	string statRef
	string mathRef
}

struct StatCardStruct
{
	array<StatCardEntry> headerStats
	array<StatCardEntry> headerToolTipStats
	array<StatCardEntry> bodyStats
	array<StatCardEntry> bodyToolTipStats
}

struct LegendStatStruct
{
	string	   legendName
	asset	   portrait
	int        gamesPlayed
	float      winRate
	float      kdr
}

struct WeaponStatStruct
{
	string weaponName
	asset portrait
	int kills
	int damage
	float headshotRatio
	float accuracy
}

struct
{
	var statsRui
	StatCardStruct careerStatCard
	StatCardStruct seasonStatCard
	StatCardStruct rankedPeriodStatCard

	array< LegendStatStruct > bestLegendStats
	array< WeaponStatStruct > bestWeaponStats

	table<string, array<string> > toolTipStrings

	table<string, int> GUIDToSeasonNumber
} file

const string NO_DATA_REF = "000"

const STAT_TOOLTIP_HEADER_CAREER = "careerHeader"
const STAT_TOOLTIP_LCIRCLE_CAREER = "careerLeftCircle"
const STAT_TOOLTIP_RCIRCLE_CAREER = "careerRightCircle"
const STAT_TOOLTIP_COLUMNA_CAREER = "careerColumnA"
const STAT_TOOLTIP_COLUMNB_CAREER = "careerColumnB"
const STAT_TOOLTIP_HEADER_SEASON = "seasonHeader"
const STAT_TOOLTIP_LCIRCLE_SEASON = "seasonLeftCircle"
const STAT_TOOLTIP_RCIRCLE_SEASON = "seasonRightCircle"
const STAT_TOOLTIP_COLUMNA_SEASON = "seasonColumnA"
const STAT_TOOLTIP_COLUMNB_SEASON = "seasonColumnB"

#if UI
void function ShPlayerStatCards_Init()
{
	file.GUIDToSeasonNumber[ "SAID01769158912" ] <- 1
	file.GUIDToSeasonNumber[ "SAID01774506873" ] <- 2
	file.GUIDToSeasonNumber[ "SAID00724938940" ] <- 3

	//
	file.GUIDToSeasonNumber[ "SAID00747315762" ] <- 0
	file.GUIDToSeasonNumber[ "SAID00091805734" ] <- 0

	var dataTable = GetDataTable( $"datatable/player_stat_cards.rpak" )

	int numRows = GetDatatableRowCount( dataTable )
	for ( int i = 0; i < numRows; i++ )
	{
		StatCardEntry entry
		string cardTypeString = GetDataTableString( dataTable, i, GetDataTableColumnByName( dataTable, "cardType" ) )
		if ( cardTypeString.toupper() == "CAREER" )
		{
			entry.cardType = eStatCardType.CAREER
		}
		else if ( cardTypeString.toupper() == "SEASON" )
		{
			entry.cardType = eStatCardType.SEASON
		}
		else if ( cardTypeString.toupper() == "RANKEDPERIOD" )
		{
			entry.cardType = eStatCardType.RANKEDPERIOD
		}

		string cardSection = GetDataTableString( dataTable, i, GetDataTableColumnByName( dataTable, "section" ) )
		if ( cardSection.toupper() == "HEADER" )
		{
			entry.section = eStatCardSection.HEADER
		}
		else if ( cardSection.toupper() == "HEADERTOOLTIP" )
		{
			entry.section = eStatCardSection.HEADERTOOLTIP
		}
		else if ( cardSection.toupper() == "BODYTOOLTIP" )
		{
			entry.section = eStatCardSection.BODYTOOLTIP
		}
		else
		{
			entry.section = eStatCardSection.BODY
		}

		entry.calcMethod = SetStatCalcMethodFromDataTable( GetDataTableString( dataTable, i, GetDataTableColumnByName( dataTable, "calcMethod" ) ) )
		entry.label = GetDataTableString( dataTable, i, GetDataTableColumnByName( dataTable, "label" ) )
		entry.statRef = GetDataTableString( dataTable, i, GetDataTableColumnByName( dataTable, "statRef" ) )
		entry.mathRef = GetDataTableString( dataTable, i, GetDataTableColumnByName( dataTable, "mathRef" ) )

		if ( entry.label == "" )
		{
			entry.label = "UNNAMED STAT"
		}

		if ( entry.statRef == "" )
		{
			entry.statRef = NO_DATA_REF
		}

		if ( entry.cardType != eStatCardType.CAREER && entry.cardType != eStatCardType.SEASON && entry.cardType != eStatCardType.RANKEDPERIOD )
		{
			continue
		}
		else if ( entry.cardType == eStatCardType.CAREER )
		{
			if ( entry.section == eStatCardSection.HEADER )
				file.careerStatCard.headerStats.append( entry )
			else if ( entry.section == eStatCardSection.HEADERTOOLTIP )
				file.careerStatCard.headerToolTipStats.append( entry )
			else if ( entry.section == eStatCardSection.BODYTOOLTIP )
				file.careerStatCard.bodyToolTipStats.append( entry )
			else
				file.careerStatCard.bodyStats.append( entry )
		}
		else if ( entry.cardType == eStatCardType.SEASON )
		{
			if ( entry.section == eStatCardSection.HEADER )
				file.seasonStatCard.headerStats.append( entry )
			else if ( entry.section == eStatCardSection.HEADERTOOLTIP )
				file.seasonStatCard.headerToolTipStats.append( entry )
			else if ( entry.section == eStatCardSection.BODYTOOLTIP )
				file.seasonStatCard.bodyToolTipStats.append( entry )
			else
				file.seasonStatCard.bodyStats.append( entry )
		}
		else if ( entry.cardType == eStatCardType.RANKEDPERIOD )
		{
			if ( entry.section == eStatCardSection.HEADER )
				file.rankedPeriodStatCard.headerStats.append( entry )
			else if ( entry.section == eStatCardSection.HEADERTOOLTIP )
				file.rankedPeriodStatCard.headerToolTipStats.append( entry )
			else if ( entry.section == eStatCardSection.BODYTOOLTIP )
				file.rankedPeriodStatCard.bodyToolTipStats.append( entry )
			else
				file.rankedPeriodStatCard.bodyStats.append( entry )
		}
	}

	int totalCareerStats = file.careerStatCard.headerStats.len() + file.careerStatCard.bodyStats.len()
	int totalSeasonStats = file.seasonStatCard.headerStats.len() + file.seasonStatCard.bodyStats.len()
	int totalRankedPeriodStats = file.rankedPeriodStatCard.headerStats.len() + file.rankedPeriodStatCard.bodyStats.len()

	printf( "StatCardDebug: Stat Card Entry Table Completed with %i Career stats, %i Season Stats and %i Ranked Period Stats", totalCareerStats, totalSeasonStats, totalRankedPeriodStats )

	StatCard_InitToolTipStringTables()
}
#endif

int function SetStatCalcMethodFromDataTable( string method )
{
	switch ( method.toupper() )
	{
		case "SIMPLE":
			return eStatCalcMethod.SIMPLE
		case "CHARACTER_AGGREGATE":
			return eStatCalcMethod.CHARACTER_AGGREGATE
		case "CHARACTER_HIGHEST":
			return eStatCalcMethod.CHARACTER_HIGHEST
		case "WEAPON_AGGREGATE":
			return eStatCalcMethod.WEAPON_AGGREGATE
		case "WEAPON_HIGHEST":
			return eStatCalcMethod.WEAPON_HIGHEST
		case "MATH_ADD":
			return eStatCalcMethod.MATH_ADD
		case "MATH_SUB":
			return eStatCalcMethod.MATH_SUB
		case "MATH_MULTIPLY":
			return eStatCalcMethod.MATH_MULTIPLY
		case "MATH_DIVIDE":
			return eStatCalcMethod.MATH_DIVIDE
		case "MATH_WINRATE":
			return eStatCalcMethod.MATH_WINRATE
		default:
			Assert( false, format("Stat Card: Unknown Stat Card Calc Type Provided (%s)", method) )
	}

	unreachable
}

#if UI
void function StatCard_UpdateAndDisplayStats( var panel, entity player, string seasonRef = "" )
{
	StatCard_ClearToolTipStringTables()

	StatCard_ConstructCareerStatsDisplay( panel, player )

	if ( seasonRef != "" )
		StatCard_ConstructSeasonOrRankedPeriodStatsDisplay( panel, player, seasonRef )
}
#endif // UI

const string STATCARD_VAR_FORMAT_HEADER_LABEL = "headerStatFieldLabel"
const string STATCARD_VAR_FORMAT_HEADER_DISPLAY = "headerStatFieldDisplay"
const string STATCARD_VAR_FORMAT_LABEL = "statFieldLabel"
const string STATCARD_VAR_FORMAT_DISPLAY = "statFieldDisplay"

const string STATCARD_VAR_FORMAT_HEADER_LABEL_SEASON = "seasonHeaderStatLabel"
const string STATCARD_VAR_FORMAT_HEADER_DISPLAY_SEASON = "seasonHeaderStatDisplay"

const string STATCARD_CAREER_STAT_LABEL = "careerStatLabel"
const string STATCARD_CAREER_STAT_DISPLAY = "careerStatDisplay"
const string STATCARD_SEASON_STAT_LABEL = "seasonStatLabel"
const string STATCARD_SEASON_STAT_DISPLAY = "seasonStatDisplay"

#if UI
void function StatCard_ConstructCareerStatsDisplay( var panel, entity player )
{
	var rui = Hud_GetRui( panel )

	array<StatCardEntry> statEntries
	string toolTipField

	statEntries = clone( file.careerStatCard.headerStats )

	if ( statEntries.len() > 0 )
	{
		for ( int i; i < statEntries.len(); i++ )
		{
			string headerIndex = format( "%02d", i )

			string headerLabelIDString = STATCARD_VAR_FORMAT_HEADER_LABEL + headerIndex
			string headerLabel = statEntries[i].label

			string headerDisplayIDString = STATCARD_VAR_FORMAT_HEADER_DISPLAY + headerIndex
			float headerDisplayFloat = GetDataForStat_Float( player, file.careerStatCard.headerStats[i].statRef, statEntries[i].mathRef, statEntries[i].calcMethod )


			RuiSetString( rui, (STATCARD_VAR_FORMAT_HEADER_LABEL + headerIndex), headerLabel )

			StatCard_SetStatValueDisplay( headerDisplayIDString, headerDisplayFloat )
			StatCard_AddStatToolTipString( STAT_TOOLTIP_HEADER_CAREER, statEntries[i].label, headerDisplayFloat, statEntries[i].calcMethod )
		}
	}

	statEntries.clear()
	statEntries = clone( file.careerStatCard.headerToolTipStats )

	if ( statEntries.len() > 0 )
	{
		for ( int i = 0; i < statEntries.len(); i++ )
		{
			float headerToolTipDisplayFloat = GetDataForStat_Float( player, statEntries[i].statRef, statEntries[i].mathRef, statEntries[i].calcMethod )
			StatCard_AddStatToolTipString( STAT_TOOLTIP_HEADER_CAREER, statEntries[i].label, headerToolTipDisplayFloat, statEntries[i].calcMethod, i )
		}
	}

	StatCard_SetStatToolTip( STAT_TOOLTIP_HEADER_CAREER )

	statEntries.clear()
	statEntries = clone( file.careerStatCard.bodyStats )

	if ( statEntries.len() > 0 )
	{
		for ( int i; i < statEntries.len(); i++ )
		{
			string bodyIndex = format( "%02d", i )

			string bodyLabelIDString = STATCARD_CAREER_STAT_LABEL + bodyIndex
			string bodyLabel = statEntries[i].label

			string bodyDisplayIDString = STATCARD_CAREER_STAT_DISPLAY + bodyIndex
			float bodyDisplayFloat = GetDataForStat_Float( player, statEntries[i].statRef, statEntries[i].mathRef, statEntries[i].calcMethod )

			toolTipField = StatCard_GetToolTipFieldFromIndex( i, eStatCardType.CAREER, eStatCardSection.BODY )

			RuiSetString( rui, bodyLabelIDString, bodyLabel )

			StatCard_SetStatValueDisplay( bodyDisplayIDString, bodyDisplayFloat, 7, 2 )
			StatCard_AddStatToolTipString( toolTipField, statEntries[i].label, bodyDisplayFloat, statEntries[i].calcMethod )
		}
	}

	StatCard_SetStatToolTip( STAT_TOOLTIP_LCIRCLE_CAREER )
	StatCard_SetStatToolTip( STAT_TOOLTIP_RCIRCLE_CAREER )
	StatCard_SetStatToolTip( STAT_TOOLTIP_COLUMNA_CAREER )
	StatCard_SetStatToolTip( STAT_TOOLTIP_COLUMNB_CAREER )
}

void function StatCard_ConstructSeasonOrRankedPeriodStatsDisplay( var panel, entity player, string seasonOrRankedPeriodRef )
{
	var rui = Hud_GetRui( panel )
	string toolTipField

	RuiSetInt( rui, "seasonColorHack", file.GUIDToSeasonNumber[seasonOrRankedPeriodRef] )

	array<StatCardEntry> statEntries = []

	int refGUID = ConvertItemFlavorGUIDStringToGUID( seasonOrRankedPeriodRef )
	ItemFlavor refFlavor = GetItemFlavorByGUID( refGUID )
	bool isSeasonStats = IsSeasonFlavor( refFlavor )

	if ( isSeasonStats )
		statEntries = clone( file.seasonStatCard.headerStats )
	else
		statEntries = clone( file.rankedPeriodStatCard.headerStats )

	if ( statEntries.len() > 0 )
	{
		for ( int i; i < statEntries.len(); i++ )
		{
			string headerIndex = format( "%02d", i )

			string headerLabelIDString = STATCARD_VAR_FORMAT_HEADER_LABEL_SEASON + headerIndex
			string headerLabel = statEntries[i].label

			string headerDisplayIDString = STATCARD_VAR_FORMAT_HEADER_DISPLAY_SEASON + headerIndex

			float headerDisplayFloat = GetDataForStat_Float( player, statEntries[i].statRef, statEntries[i].mathRef, statEntries[i].calcMethod, seasonOrRankedPeriodRef )

			RuiSetString( rui, headerLabelIDString, headerLabel )

			StatCard_SetStatValueDisplay( headerDisplayIDString, headerDisplayFloat )
			StatCard_AddStatToolTipString( STAT_TOOLTIP_HEADER_SEASON, statEntries[i].label, headerDisplayFloat, statEntries[i].calcMethod )
		}
	}

	statEntries.clear()
	if ( isSeasonStats )
		statEntries = clone( file.seasonStatCard.headerToolTipStats )
	else
		statEntries = clone( file.rankedPeriodStatCard.headerToolTipStats )

	if ( statEntries.len() > 0 )
	{
		for ( int i = 0; i < statEntries.len(); i++ )
		{
			float headerToolTipDisplayFloat = GetDataForStat_Float( player, statEntries[i].statRef, statEntries[i].mathRef, statEntries[i].calcMethod, seasonOrRankedPeriodRef )

			StatCard_AddStatToolTipString( STAT_TOOLTIP_HEADER_SEASON, statEntries[i].label, headerToolTipDisplayFloat, statEntries[i].calcMethod, i )
		}
	}

	StatCard_SetStatToolTip( STAT_TOOLTIP_HEADER_SEASON )

	statEntries.clear()
	if ( isSeasonStats )
		statEntries = clone( file.seasonStatCard.bodyStats )
	else
		statEntries = clone( file.rankedPeriodStatCard.bodyStats )

	if ( statEntries.len() > 0 )
	{

		for ( int i; i < statEntries.len(); i++ )
		{
			string bodyIndex = format( "%02d", i )

			string bodyLabelIDString = STATCARD_SEASON_STAT_LABEL + bodyIndex
			string bodyLabel = statEntries[i].label

			string bodyDisplayIDString = STATCARD_SEASON_STAT_DISPLAY + bodyIndex
			float bodyDisplayFloat = GetDataForStat_Float( player, statEntries[i].statRef, statEntries[i].mathRef, statEntries[i].calcMethod, seasonOrRankedPeriodRef )

			toolTipField = StatCard_GetToolTipFieldFromIndex( i, eStatCardType.SEASON, eStatCardSection.BODY )

			RuiSetString( rui, bodyLabelIDString, bodyLabel )
			StatCard_SetStatValueDisplay( bodyDisplayIDString, bodyDisplayFloat, 7, 2 )
			StatCard_AddStatToolTipString( toolTipField, statEntries[i].label, bodyDisplayFloat, statEntries[i].calcMethod )
		}
	}

	StatCard_SetStatToolTip( STAT_TOOLTIP_LCIRCLE_SEASON )
	StatCard_SetStatToolTip( STAT_TOOLTIP_RCIRCLE_SEASON )
	StatCard_SetStatToolTip( STAT_TOOLTIP_COLUMNA_SEASON )
	StatCard_SetStatToolTip( STAT_TOOLTIP_COLUMNB_SEASON )
}

void function StatCard_ConstructStatCardProgressBar( var panel, int totalXP, int start_accountLevel, float start_accountLevelFrac, int cardType, entity player = null )
{
	var rui = Hud_GetRui( panel )
	RuiDestroyNestedIfAlive( rui, "progressBarHandle" )
	var progressBarRui = CreateNestedProgressBar( rui, "progressBarHandle" )

	RuiSetColorAlpha( progressBarRui, "oldProgressColor", <196 / 255.0, 151 / 255.0, 41 / 255.0>, 1 )
	RuiSetColorAlpha( progressBarRui, "newProgressColor", <255 / 255.0, 182 / 255.0, 0 / 255.0>, 1 )
	RuiSetBool( progressBarRui, "largeFormat", true )
	RuiSetInt( progressBarRui, "startLevel", start_accountLevel )
	RuiSetFloat( progressBarRui, "startLevelFrac", start_accountLevelFrac )
	RuiSetInt( progressBarRui, "endLevel", start_accountLevel )
	RuiSetFloat( progressBarRui, "endLevelFrac", 1.0 )
	RuiSetGameTime( progressBarRui, "startTime", RUI_BADGAMETIME )
	RuiSetFloat( progressBarRui, "startDelay", 0.0 )
	RuiSetString( progressBarRui, "headerText", "#EOG_XP_HEADER_MATCH" )
	RuiSetFloat( progressBarRui, "progressBarFillTime", 2.0 )
	RuiSetInt( progressBarRui, format( "displayLevel1XP", start_accountLevel + 1 ), GetTotalXPToCompleteAccountLevel( start_accountLevel ) - GetTotalXPToCompleteAccountLevel( start_accountLevel - 1 ) )

	if ( cardType == eStatCardType.CAREER )
	{
		RuiSetString( progressBarRui, "currentDisplayLevel", GetAccountDisplayLevel( start_accountLevel ) )
		RuiSetString( progressBarRui, "nextDisplayLevel", GetAccountDisplayLevel( start_accountLevel + 1 ) )

		RuiSetImage( progressBarRui, "currentDisplayBadge", GetAccountDisplayBadge( start_accountLevel ) )
		RuiSetImage( progressBarRui, "nextDisplayBadge", GetAccountDisplayBadge( start_accountLevel + 1 ) )
	}

	if ( cardType == eStatCardType.SEASON )
	{
		RuiSetBool( progressBarRui, "battlePass", true )

		RuiSetString( progressBarRui, "currentDisplayLevel", "" )
		RuiSetString( progressBarRui, "nextDisplayLevel", "" )
		RuiSetImage( progressBarRui, "currentDisplayBadge", $"" )
		RuiSetImage( progressBarRui, "nextDisplayBadge", $"" )

		ItemFlavor ornull activeBattlePass
		activeBattlePass = GetPlayerActiveBattlePass( ToEHI( player ) )
		expect ItemFlavor( activeBattlePass )

		int currentBattlePassXP  = GetPlayerBattlePassXPProgress( ToEHI( player ), activeBattlePass, false )
		int ending_passLevel       = GetBattlePassLevelForXP( activeBattlePass, currentBattlePassXP )
		int ending_passXP          = GetTotalXPToCompletePassLevel( activeBattlePass, ending_passLevel - 1 )
		bool isMaxPassLevel 	   = ending_passLevel > GetBattlePassMaxLevelIndex( activeBattlePass )

		ItemFlavor dummy
		ItemFlavor bpLevelBadge = GetBattlePassProgressBadge( activeBattlePass )

		RuiDestroyNestedIfAlive( progressBarRui, "currentBadgeHandle" )
		CreateNestedGladiatorCardBadge( progressBarRui, "currentBadgeHandle", ToEHI( player ), bpLevelBadge, 0, dummy, start_accountLevel + 1 )

		RuiDestroyNestedIfAlive( progressBarRui, "nextBadgeHandle" )
		if ( !isMaxPassLevel )
			CreateNestedGladiatorCardBadge( progressBarRui, "nextBadgeHandle", ToEHI( player ), bpLevelBadge, 0, dummy, start_accountLevel + 2 )
	}
}

void function StatCard_ConstructAccountProgressBar( var panel, int start_accountLevel, float start_accountLevelFrac )
{
	var rui = Hud_GetRui( panel )
	RuiDestroyNestedIfAlive( rui, "careerProgressBarHandle" )
	var progressBarRui = CreateNestedProgressBar( rui, "careerProgressBarHandle" )

	RuiSetColorAlpha( progressBarRui, "oldProgressColor", <196 / 255.0, 151 / 255.0, 41 / 255.0>, 1 )
	RuiSetColorAlpha( progressBarRui, "newProgressColor", <255 / 255.0, 182 / 255.0, 0 / 255.0>, 1 )
	RuiSetBool( progressBarRui, "largeFormat", true )
	RuiSetInt( progressBarRui, "startLevel", start_accountLevel )
	RuiSetFloat( progressBarRui, "startLevelFrac", start_accountLevelFrac )
	RuiSetInt( progressBarRui, "endLevel", start_accountLevel )
	RuiSetFloat( progressBarRui, "endLevelFrac", 1.0 )
	RuiSetGameTime( progressBarRui, "startTime", RUI_BADGAMETIME )
	RuiSetFloat( progressBarRui, "startDelay", 0.0 )
	RuiSetString( progressBarRui, "headerText", "#EOG_XP_HEADER_MATCH" )
	RuiSetFloat( progressBarRui, "progressBarFillTime", 2.0 )
	RuiSetInt( progressBarRui, format( "displayLevel1XP", start_accountLevel + 1 ), GetTotalXPToCompleteAccountLevel( start_accountLevel ) - GetTotalXPToCompleteAccountLevel( start_accountLevel - 1 ) )

	RuiSetString( progressBarRui, "currentDisplayLevel", GetAccountDisplayLevel( start_accountLevel ) )
	RuiSetString( progressBarRui, "nextDisplayLevel", GetAccountDisplayLevel( start_accountLevel + 1 ) )

	RuiSetImage( progressBarRui, "currentDisplayBadge", GetAccountDisplayBadge( start_accountLevel ) )
	RuiSetImage( progressBarRui, "nextDisplayBadge", GetAccountDisplayBadge( start_accountLevel + 1 ) )
}

void function StatCard_ConstructBattlePassLevelBadge( var panel, entity player, int battlePassLevel, string seasonRef )
{
	var rui = Hud_GetRui( panel )
	RuiDestroyNestedIfAlive( rui, "battlePassLevelBadge" )

	SettingsAssetGUID seasonGUID = ConvertItemFlavorGUIDStringToGUID( seasonRef )
	ItemFlavor season = GetItemFlavorByGUID( seasonGUID )
	ItemFlavor battlePass = Season_GetBattlePass( season )

	ItemFlavor dummy
	ItemFlavor bpLevelBadge = GetBattlePassProgressBadge( battlePass )

	CreateNestedGladiatorCardBadge( rui, "battlePassLevelBadge", ToEHI( player ), bpLevelBadge, 0, dummy, battlePassLevel + 1 )
}

void function StatCard_ConstructRankedBadge( var panel, entity player, string rankedPeriodRef )
{
	var rui = Hud_GetRui( panel )
	RuiDestroyNestedIfAlive( rui, "battlePassLevelBadge" )

	var badgeRui            = CreateNestedRankedBadge( rui, "battlePassLevelBadge" )
	int score               = Ranked_GetHistoricalRankScore( player, rankedPeriodRef )
	RankedDivisionData data = Ranked_GetHistoricalRankedDivisionFromScore( score, rankedPeriodRef )

	if ( rankedPeriodRef == GetCurrentStatRankedPeriodRefOrNull() )
		PopulateRuiWithRankedBadgeDetails( badgeRui, score, Ranked_GetDisplayNumberForRuiBadge( GetUIPlayer() ) )
	else
		PopulateRuiWithHistoricalRankedBadgeDetails( badgeRui, score, score, rankedPeriodRef  ) //

	RuiSetBool( badgeRui, "showScore", false )
	RuiSetInt( badgeRui, "score", score )
	RuiSetInt( badgeRui, "scoreMax", 0 )
	RuiSetFloat( badgeRui, "scoreFrac", 1.0 )
	RuiSetString( badgeRui, "rankName", data.divisionName )
}

void function StatCard_ChangeCardDisplayType( var panel, int displayType )
{
	var rui = Hud_GetRui( panel )
	RuiSetInt( rui, "displayType", displayType )
}
#endif // UI

string function GetDataForStat( entity player, string statRef, string mathRef, int calcMethod, string seasonRef = "" )
{
	if( statRef == NO_DATA_REF )
	{
		return statRef
	}
	else
	{
		StatTemplate stat = GetStatTemplateFromString( statRef )

		bool statComesFromAggregate = (calcMethod == eStatCalcMethod.CHARACTER_AGGREGATE) || (calcMethod == eStatCalcMethod.CHARACTER_HIGHEST) || (calcMethod == eStatCalcMethod.WEAPON_AGGREGATE) || (calcMethod == eStatCalcMethod.WEAPON_HIGHEST)
		bool statComesFromMath = (calcMethod == eStatCalcMethod.MATH_DIVIDE) || (calcMethod == eStatCalcMethod.MATH_MULTIPLY) || (calcMethod == eStatCalcMethod.MATH_SUB) || (calcMethod == eStatCalcMethod.MATH_ADD) || (calcMethod == eStatCalcMethod.MATH_WINRATE)

		int data
		if ( calcMethod == eStatCalcMethod.SIMPLE )
		{
			if ( seasonRef == "" )
				data = GetStat_Int( player, ResolveStatEntry( stat ), eStatGetWhen.CURRENT )
			else
				data = GetStat_Int( player, ResolveStatEntry( stat, seasonRef ), eStatGetWhen.CURRENT )
		}
		else if ( statComesFromAggregate )
		{
			data = AggregateStat( player, stat, calcMethod, seasonRef )
		}
		else if ( statComesFromMath )
		{
			Assert( (mathRef != ""), format( "Stat Cards: Attempted to calculate a stat value without providing two stats to calculate from (%s)", mathRef) )

			StatTemplate mathStat = GetStatTemplateFromString( mathRef )
			float calcData = CalculateStat( player, stat, mathStat, calcMethod, seasonRef, "" )
			float modValue = (calcData % 1) * 100.0

			string result
			if ( modValue != 0 )
				result = format( "%02d.%02d", calcData, modValue )
			else
				result = string( calcData )
			return result
		}

		return format( "%02d", data )
	}

	unreachable
}

float function GetDataForStat_Float( entity player, string statRef, string mathRef, int calcMethod, string ref = "" )
{
	if( statRef == NO_DATA_REF )
	{
		return -1
	}
	else
	{
		StatTemplate stat = GetStatTemplateFromString( statRef )

		bool statComesFromAggregate = (calcMethod == eStatCalcMethod.CHARACTER_AGGREGATE) || (calcMethod == eStatCalcMethod.CHARACTER_HIGHEST) || (calcMethod == eStatCalcMethod.WEAPON_AGGREGATE) || (calcMethod == eStatCalcMethod.WEAPON_HIGHEST)
		bool statComesFromMath = (calcMethod == eStatCalcMethod.MATH_DIVIDE) || (calcMethod == eStatCalcMethod.MATH_MULTIPLY) || (calcMethod == eStatCalcMethod.MATH_SUB) || (calcMethod == eStatCalcMethod.MATH_ADD) || (calcMethod == eStatCalcMethod.MATH_WINRATE)

		int data
		if ( calcMethod == eStatCalcMethod.SIMPLE )
		{
			if ( ref == "" )
				data = GetStat_Int( player, ResolveStatEntry( stat ), eStatGetWhen.CURRENT )
			else
				data = GetStat_Int( player, ResolveStatEntry( stat, ref ), eStatGetWhen.CURRENT )
		}
		else if ( statComesFromAggregate )
		{
			data = AggregateStat( player, stat, calcMethod, ref )
		}
		else if ( statComesFromMath )
		{
			Assert( (mathRef != ""), format( "Stat Cards: Attempted to calculate a stat value without providing two stats to calculate from (%s)", mathRef) )

			StatTemplate mathStat = GetStatTemplateFromString( mathRef )
			float calcData = CalculateStat( player, stat, mathStat, calcMethod, ref, "" )

			return calcData
		}

		return float( data )
	}

	unreachable
}

StatTemplate function GetStatTemplateFromString( string statRef )
{
	switch ( statRef )
	{
		case "CAREER_STATS.games_played":
			return CAREER_STATS.games_played
		case "CAREER_STATS.placements_win":
			return CAREER_STATS.placements_win
		case "CAREER_STATS.placements_top_3":
			return CAREER_STATS.placements_top_3
		case "CAREER_STATS.kills":
			return CAREER_STATS.kills
		case "CAREER_STATS.deaths":
			return CAREER_STATS.deaths
		case "CAREER_STATS.dooms":
			return CAREER_STATS.dooms
		case "CAREER_STATS.team_work_kill_count":
			return CAREER_STATS.team_work_kill_count
		case "CAREER_STATS.revived_ally":
			return CAREER_STATS.revived_ally
		case "CAREER_STATS.damage_done":
			return CAREER_STATS.damage_done
		case "CAREER_STATS.character_damage_done_max_single_game":
			return CAREER_STATS.character_damage_done_max_single_game
		case "CAREER_STATS.season_character_kills":
			return CAREER_STATS.season_character_kills
		case "CAREER_STATS.season_character_damage_done":
			return CAREER_STATS.season_character_damage_done
		case "CAREER_STATS.season_character_placements_win":
			return CAREER_STATS.season_character_placements_win
		case "CAREER_STATS.season_character_placements_top_5":
			return CAREER_STATS.season_character_placements_top_5
		case "CAREER_STATS.weapon_damage_done":
			return CAREER_STATS.weapon_damage_done
		case "CAREER_STATS.weapon_headshots":
			return CAREER_STATS.weapon_headshots
		case "CAREER_STATS.weapon_shots":
			return CAREER_STATS.weapon_shots
		case "CAREER_STATS.weapon_hits":
			return CAREER_STATS.weapon_hits
		case "CAREER_STATS.character_games_played":
			return CAREER_STATS.character_games_played
		case "CAREER_STATS.character_kills":
			return CAREER_STATS.character_kills
		case "CAREER_STATS.character_deaths":
			return CAREER_STATS.character_deaths
		case "CAREER_STATS.character_placements_win":
			return CAREER_STATS.character_placements_win
		case "CAREER_STATS.times_respawned_ally":
			return CAREER_STATS.times_respawned_ally
		case "CAREER_STATS.season_games_played":
			return CAREER_STATS.season_games_played
		case "CAREER_STATS.season_damage_done":
			return CAREER_STATS.season_damage_done
		case "CAREER_STATS.season_kills":
			return CAREER_STATS.season_kills
		case "CAREER_STATS.season_deaths":
			return CAREER_STATS.season_deaths
		case "CAREER_STATS.season_dooms":
			return CAREER_STATS.season_dooms
		case "CAREER_STATS.season_team_work_kill_count":
			return CAREER_STATS.season_team_work_kill_count
		case "CAREER_STATS.season_revived_ally":
			return CAREER_STATS.season_revived_ally
		case "CAREER_STATS.season_times_respawned_ally":
			return CAREER_STATS.season_times_respawned_ally
		case "CAREER_STATS.season_character_damage_done_max_single_game":
			return CAREER_STATS.season_character_damage_done_max_single_game
		case "CAREER_STATS.assists":
			return CAREER_STATS.assists
		case "CAREER_STATS.season_assists":
			return CAREER_STATS.season_assists
		case "CAREER_STATS.kills_max_single_game":
			return CAREER_STATS.kills_max_single_game
		case "CAREER_STATS.season_kills_max_single_game":
			return CAREER_STATS.season_kills_max_single_game
		case "CAREER_STATS.win_streak_longest":
			return CAREER_STATS.win_streak_longest
		case "CAREER_STATS.season_win_streak_longest":
			return CAREER_STATS.season_win_streak_longest
		case "CAREER_STATS.season_placements_win":
			return CAREER_STATS.season_placements_win
		case "CAREER_STATS.placements_top_5":
			return CAREER_STATS.placements_top_5
		case "CAREER_STATS.rankedperiod_assists":
			return CAREER_STATS.rankedperiod_assists
		case "CAREER_STATS.rankedperiod_character_damage_done_max_single_game":
			return CAREER_STATS.rankedperiod_character_damage_done_max_single_game
		case "CAREER_STATS.rankedperiod_damage_done":
			return CAREER_STATS.rankedperiod_damage_done
		case "CAREER_STATS.rankedperiod_deaths":
			return CAREER_STATS.rankedperiod_deaths
		case "CAREER_STATS.rankedperiod_dooms":
			return CAREER_STATS.rankedperiod_dooms
		case "CAREER_STATS.rankedperiod_games_played":
			return CAREER_STATS.rankedperiod_games_played
		case "CAREER_STATS.rankedperiod_kills":
			return CAREER_STATS.rankedperiod_kills
		case "CAREER_STATS.rankedperiod_kills_max_single_game":
			return CAREER_STATS.rankedperiod_kills_max_single_game
		case "CAREER_STATS.rankedperiod_placements_top_5":
			return CAREER_STATS.rankedperiod_placements_top_5
		case "CAREER_STATS.rankedperiod_placements_win":
			return CAREER_STATS.rankedperiod_placements_win
		case "CAREER_STATS.rankedperiod_revived_ally":
			return CAREER_STATS.rankedperiod_revived_ally
		case "CAREER_STATS.rankedperiod_times_respawned_ally":
			return CAREER_STATS.rankedperiod_times_respawned_ally
		case "CAREER_STATS.rankedperiod_win_streak_longest":
			return CAREER_STATS.rankedperiod_win_streak_longest
		default:
			Assert( false, format( "Stat Card attempted to look up an unknown StatTemplate: %s", statRef) )
	}

	unreachable
}

int function AggregateStat( entity player, StatTemplate stat, int calcMethod, string seasonRef = "" )
{
	int total

	if ( calcMethod == eStatCalcMethod.CHARACTER_HIGHEST || calcMethod == eStatCalcMethod.CHARACTER_AGGREGATE )
	{
		foreach( ItemFlavor character in GetAllCharacters() )
		{
			string characterRef = ItemFlavor_GetGUIDString( character )
			int statValue
			if ( seasonRef == "" )
				statValue = GetStat_Int( player, ResolveStatEntry( stat, characterRef ), eStatGetWhen.CURRENT )
			else
				statValue = GetStat_Int( player, ResolveStatEntry( stat, seasonRef, characterRef ), eStatGetWhen.CURRENT )

			if ( (calcMethod == eStatCalcMethod.CHARACTER_HIGHEST) && (statValue > total) )
				total = statValue
			if ( calcMethod == eStatCalcMethod.CHARACTER_AGGREGATE )
				total += statValue
		}
	}

	if ( calcMethod == eStatCalcMethod.WEAPON_HIGHEST || calcMethod == eStatCalcMethod.WEAPON_AGGREGATE )
	{
		foreach( ItemFlavor weapon in GetAllWeaponItemFlavors() )
		{
			string weaponRef = ItemFlavor_GetGUIDString( weapon )
			int statValue
			if ( seasonRef == "" )
				statValue = GetStat_Int( player, ResolveStatEntry( stat, weaponRef ), eStatGetWhen.CURRENT )
			else
				statValue = GetStat_Int( player, ResolveStatEntry( stat, seasonRef, weaponRef ), eStatGetWhen.CURRENT )

			if ( (calcMethod == eStatCalcMethod.WEAPON_HIGHEST) && (statValue > total) )
				total = statValue
			if ( calcMethod == eStatCalcMethod.WEAPON_AGGREGATE )
				total += statValue
		}
	}

	return total
}

float function CalculateStat( entity player, StatTemplate stat1, StatTemplate stat2, int calcMethod, string seasonRef = "", string ref = "" )
{
	int stat1Int
	int stat2Int

	if ( seasonRef == "" )
	{
		stat1Int = GetStat_Int( player, ResolveStatEntry( stat1 ), eStatGetWhen.CURRENT )
		stat2Int = GetStat_Int( player, ResolveStatEntry( stat2 ), eStatGetWhen.CURRENT )
	}
	else if ( ref != "" )
	{
		stat1Int = GetStat_Int( player, ResolveStatEntry( stat1, ref ), eStatGetWhen.CURRENT )
		stat2Int = GetStat_Int( player, ResolveStatEntry( stat2, ref ), eStatGetWhen.CURRENT )
	}
	else
	{
		stat1Int = GetStat_Int( player, ResolveStatEntry( stat1, seasonRef ), eStatGetWhen.CURRENT )
		stat2Int = GetStat_Int( player, ResolveStatEntry( stat2, seasonRef ), eStatGetWhen.CURRENT )
	}

	switch ( calcMethod )
	{
		case eStatCalcMethod.MATH_ADD:
			return float( stat1Int + stat2Int )
		case eStatCalcMethod.MATH_SUB:
			return float( stat1Int - stat2Int )
		case eStatCalcMethod.MATH_MULTIPLY:
			return float( stat1Int * stat2Int )
	}

	if ( calcMethod == eStatCalcMethod.MATH_DIVIDE )
	{
		if ( stat2Int != 0 )
			printf( "StatMathDebug: %i / %i = %f", stat1Int, stat2Int, (float(stat1Int)/float(stat2Int)) )

		if ( stat2Int != 0 )
			return float( stat1Int ) / float( stat2Int )
		else
			return float( stat1Int )
	}

	if ( calcMethod == eStatCalcMethod.MATH_WINRATE )
	{
		if ( stat2Int != 0 )
			return (float( stat1Int ) / float( stat2Int )) * 100.0
		else
			return 0
	}

	unreachable
}

const string STATCARD_LEGENDSTAT_NAME = "legendName"
const string STATCARD_LEGENDSTAT_PORTRAIT = "legendPortrait"
const string STATCARD_LEGENDSTAT_GAMESPLAYED = "legendGamesPlayed"
const string STATCARD_LEGENDSTAT_WINRATE = "legendWinRate"
const string STATCARD_LEGENDSTAT_KDR = "legendKDR"

#if UI
void function StatCard_ConstructTopLegendStatCard( var panel, entity player )
{
	//

	ConstructLegendStatStructArray( player )

	var rui = Hud_GetRui( panel )
	RuiSetInt( rui, "displayType", 3 )

	for( int i = 0; i < file.bestLegendStats.len(); i++ )
	{
		string legendIndex = format( "%02d", i )

		string legendName = STATCARD_LEGENDSTAT_NAME + legendIndex
		string legendPortrait = STATCARD_LEGENDSTAT_PORTRAIT + legendIndex
		string legendGamesPlayed = STATCARD_LEGENDSTAT_GAMESPLAYED + legendIndex
		string legendGamesWinRate = STATCARD_LEGENDSTAT_WINRATE + legendIndex
		string legendGamesKDR = STATCARD_LEGENDSTAT_KDR + legendIndex

		//

		RuiSetString( rui, legendName, file.bestLegendStats[i].legendName )
		RuiSetImage( rui, legendPortrait, file.bestLegendStats[i].portrait )
		RuiSetInt( rui, legendGamesPlayed, file.bestLegendStats[i].gamesPlayed )
		RuiSetFloat( rui, legendGamesWinRate, file.bestLegendStats[i].winRate )
		RuiSetFloat( rui, legendGamesKDR, file.bestLegendStats[i].kdr )
	}
}

void function ConstructLegendStatStructArray( entity player )
{
	if ( file.bestLegendStats.len() == 5 )
		return

	array< LegendStatStruct > legendsArray

	foreach( ItemFlavor character in GetAllCharacters() )
	{
		string characterRef = ItemFlavor_GetGUIDString( character )
		LegendStatStruct newLegend

		newLegend.legendName = ItemFlavor_GetLongName( character )
		newLegend.portrait = CharacterClass_GetGalleryPortrait( character )
		newLegend.gamesPlayed = GetStat_Int( player, ResolveStatEntry( CAREER_STATS.character_games_played, characterRef ), eStatGetWhen.CURRENT )
		newLegend.winRate = CalculateStat( player, CAREER_STATS.character_placements_win, CAREER_STATS.character_games_played, eStatCalcMethod.MATH_WINRATE, "", characterRef )
		newLegend.kdr = CalculateStat( player, CAREER_STATS.character_kills, CAREER_STATS.character_deaths, eStatCalcMethod.MATH_DIVIDE, "", characterRef )

		legendsArray.append( newLegend )
	}

	legendsArray.sort( SortTopLegends )
	legendsArray.resize( 5 )

	file.bestLegendStats.extend( legendsArray )

	if ( file.bestLegendStats.len() > 5 )
		file.bestLegendStats.resize( 5 )
}
#endif

const string STATCARD_WEAPONSTAT_NAME = "weaponName"
const string STATCARD_WEAPONSTAT_PORTRAIT = "weaponPortrait"
const string STATCARD_WEAPONSTAT_KILLS = "weaponKills"
const string STATCARD_WEAPONSTAT_ACCURACY = "weaponAccuracy"
const string STATCARD_WEAPONSTAT_HEADSHOTS = "weaponHeadshots"

#if UI
void function StatCard_ConstructTopWeaponStatCard( var panel, entity player )
{
	//

	ConstructWeaponStatStructArray( player )

	var rui = Hud_GetRui( panel )
	RuiSetInt( rui, "displayType", 2 )

	for( int i = 0; i < file.bestWeaponStats.len(); i++ )
	{

		string wpnIdx = format( "%02d", i )

		string weaponName      = STATCARD_WEAPONSTAT_NAME + wpnIdx
		string weaponPortrait  = STATCARD_WEAPONSTAT_PORTRAIT + wpnIdx
		string weaponKills     = STATCARD_WEAPONSTAT_KILLS + wpnIdx
		string weaponAccuracy  = STATCARD_WEAPONSTAT_ACCURACY + wpnIdx
		string weaponHeadshots = STATCARD_WEAPONSTAT_HEADSHOTS + wpnIdx

		//

		RuiSetString( rui, weaponName, file.bestWeaponStats[i].weaponName )
		RuiSetImage( rui, weaponPortrait, file.bestWeaponStats[i].portrait )
		RuiSetInt( rui, weaponKills, file.bestWeaponStats[i].kills )
		RuiSetFloat( rui, weaponAccuracy, file.bestWeaponStats[i].accuracy )
		RuiSetFloat( rui, weaponHeadshots, file.bestWeaponStats[i].headshotRatio )
	}
}

void function ConstructWeaponStatStructArray( entity player )
{
	if ( file.bestWeaponStats.len() == 5 )
		return

	array< WeaponStatStruct  > weaponsArray

	foreach( ItemFlavor weapon in GetAllWeaponItemFlavors() )
	{
		string weaponRef = ItemFlavor_GetGUIDString( weapon )
		WeaponStatStruct newWeapon

		printf( "WeaponAssetName: %s", WeaponItemFlavor_GetClassname( weapon ) )

		newWeapon.weaponName = ItemFlavor_GetShortName( weapon )
		newWeapon.portrait = GetWeaponHudIcon( weapon )
		newWeapon.kills = GetStat_Int( player, ResolveStatEntry( CAREER_STATS.weapon_kills, weaponRef ), eStatGetWhen.CURRENT )
		newWeapon.accuracy = CalculateStat( player, CAREER_STATS.weapon_hits, CAREER_STATS.weapon_shots, eStatCalcMethod.MATH_DIVIDE, "", weaponRef ) * 100
		newWeapon.headshotRatio = CalculateStat( player, CAREER_STATS.weapon_headshots, CAREER_STATS.weapon_hits, eStatCalcMethod.MATH_DIVIDE, "", weaponRef ) * 100
		newWeapon.damage = GetStat_Int( player, ResolveStatEntry( CAREER_STATS.weapon_damage_done, weaponRef ), eStatGetWhen.CURRENT )

		weaponsArray.append( newWeapon )
	}

	weaponsArray.sort( SortTopWeapons )
	weaponsArray.resize( 5 )

	file.bestWeaponStats.extend( weaponsArray )
}

asset function GetWeaponHudIcon( ItemFlavor weapon )
{
	string weaponName = WeaponItemFlavor_GetClassname( weapon )

	return GetWeaponInfoFileKeyFieldAsset_Global( weaponName, "hud_icon" )

}
#endif //

array< ItemFlavor > function StatCard_GetAvailableSeasons()
{
	array< ItemFlavor > seasons = GetAllSeasonFlavors()

	foreach( ItemFlavor season in seasons )
	{
		if ( !CalEvent_IsRevealed( season, GetUnixTimestamp() ) )
			seasons.removebyvalue( season )
	}

	return seasons
}

array< ItemFlavor > function StatCard_GetAvailableSeasonsAndRankedPeriods()
{
	array< ItemFlavor > seasons = GetAllSeasonFlavors()

	foreach( ItemFlavor season in seasons )
	{
		if ( !CalEvent_IsRevealed( season, GetUnixTimestamp() ) )
			seasons.removebyvalue( season )
	}

	array< ItemFlavor > rankedPeriods = GetAllRankedPeriodFlavors()
	foreach( ItemFlavor period in rankedPeriods )
	{
		if ( !CalEvent_IsRevealed( period, GetUnixTimestamp() ) )
			rankedPeriods.removebyvalue( period )
	}

	array< ItemFlavor > seasonsAndPeriods = []
	seasonsAndPeriods.extend( seasons )
	seasonsAndPeriods.extend( rankedPeriods )
	seasonsAndPeriods.sort( SortSeasonAndRankedStats )
	return seasonsAndPeriods
}

int function SortSeasonAndRankedStats( ItemFlavor a, ItemFlavor b )
{
	int aTime = CalEvent_GetStartUnixTime( a )
	int bTime = CalEvent_GetStartUnixTime( b )

	if ( aTime < bTime )
		return -1
	else if ( aTime > bTime )
		return 1
	else if ( IsSeasonFlavor( a ) )
		return -1
	else if ( !IsSeasonFlavor( a ) )
		return 1
	else
		return 0

	unreachable
}

int function SortTopLegends( LegendStatStruct legendA, LegendStatStruct legendB )
{
	if ( legendA.gamesPlayed > legendB.gamesPlayed )
		return -1
	else if ( legendA.gamesPlayed < legendB.gamesPlayed )
		return 1
	else if ( legendA.winRate > legendB.winRate )
		return -1
	else if ( legendA.winRate < legendB.winRate )
		return 1
	else if ( legendA.kdr > legendB.kdr )
		return -1
	else if ( legendA.kdr < legendB.kdr )
		return 1
	else
		return 0

	unreachable
}

int function SortTopWeapons( WeaponStatStruct weaponA, WeaponStatStruct weaponB )
{
	if ( weaponA.kills > weaponB.kills )
		return -1
	else if ( weaponA.kills < weaponB.kills )
		return 1
	else if ( weaponA.accuracy > weaponB.accuracy )
		return -1
	else if ( weaponA.accuracy < weaponB.accuracy )
		return 1
	else if ( weaponA.headshotRatio > weaponB.headshotRatio )
		return -1
	else if ( weaponA.headshotRatio < weaponB.headshotRatio )
		return 1
	else
		return 0

	unreachable
}

string function StatCard_GetToolTipFieldFromIndex( int index, int statCardType, int statCardSection )
{
	if ( statCardType == eStatCardType.CAREER )
	{
		if ( statCardSection == eStatCardSection.HEADER )
		{
			return STAT_TOOLTIP_HEADER_CAREER
		}
		else
		{
			if ( index <= 2 )
				return STAT_TOOLTIP_LCIRCLE_CAREER
			else if ( index <= 5 )
				return STAT_TOOLTIP_RCIRCLE_CAREER
			else if ( index <= 8 )
				return STAT_TOOLTIP_COLUMNA_CAREER
			else
				return STAT_TOOLTIP_COLUMNB_CAREER
		}
	}
	else
	{
		if ( statCardSection == eStatCardSection.HEADER )
		{
			return STAT_TOOLTIP_HEADER_SEASON
		}
		else
		{
			if ( index <= 2 )
				return STAT_TOOLTIP_LCIRCLE_SEASON
			else if ( index <= 5 )
				return STAT_TOOLTIP_RCIRCLE_SEASON
			else if ( index <= 8 )
				return STAT_TOOLTIP_COLUMNA_SEASON
			else
				return STAT_TOOLTIP_COLUMNB_SEASON
		}
	}

	return ""
}

#if UI
void function StatsScreen_SetPanelRui()
{
	var menu = GetMenu( "InspectMenu" )
	var menuPanel = Hud_GetChild( menu, "StatsSummaryPanel" )
	var ruiPanel = Hud_GetChild( menuPanel, "LifetimeAndSeasonalStats" )
	file.statsRui = Hud_GetRui( ruiPanel )
}

void function StatCard_SetStatValueDisplay( string argName, float value, int maxIntegers = 3, int maxDecimals = 0 )
{
	if ( file.statsRui == null )
		StatsScreen_SetPanelRui()

	string valueString = ""

	if( value != -1 )
		valueString = LocalizeAndShortenNumber_Float( value, maxIntegers, maxDecimals )
	else
		valueString = NO_DATA_REF

	RuiSetString( file.statsRui, argName, valueString )
}

void function StatCard_InitToolTipStringTables()
{
	file.toolTipStrings[ "careerHeader" ] <- []
	file.toolTipStrings[ "careerLeftCircle" ] <- []
	file.toolTipStrings[ "careerRightCircle" ] <- []
	file.toolTipStrings[ "careerColumnA" ] <- []
	file.toolTipStrings[ "careerColumnB" ] <- []

	file.toolTipStrings[ "seasonHeader" ] <- []
	file.toolTipStrings[ "seasonLeftCircle" ] <- []
	file.toolTipStrings[ "seasonRightCircle" ] <- []
	file.toolTipStrings[ "seasonColumnA" ] <- []
	file.toolTipStrings[ "seasonColumnB" ] <- []
}

void function StatCard_ClearToolTipStringTables()
{
	file.toolTipStrings[ "careerHeader" ].clear()
	file.toolTipStrings[ "careerLeftCircle" ].clear()
	file.toolTipStrings[ "careerRightCircle" ].clear()
	file.toolTipStrings[ "careerColumnA" ].clear()
	file.toolTipStrings[ "careerColumnB" ].clear()

	file.toolTipStrings[ "seasonHeader" ].clear()
	file.toolTipStrings[ "seasonLeftCircle" ].clear()
	file.toolTipStrings[ "seasonRightCircle" ].clear()
	file.toolTipStrings[ "seasonColumnA" ].clear()
	file.toolTipStrings[ "seasonColumnB" ].clear()
}

void function StatCard_AddStatToolTipString( string category, string label, float value, int calcMethod, int forcePos = -1 )
{
	string valueString = LocalizeAndShortenNumber_Float( value, 9, 2 )

	if ( calcMethod == eStatCalcMethod.MATH_WINRATE )
		valueString += Localize( "#STATS_VALUE_PERCENT" )

	string toolTipString = label
	if ( toolTipString.find( "_TOOLTIP" ) == -1 )
		toolTipString += "_TOOLTIP"
	toolTipString = Localize( toolTipString )
	toolTipString += valueString

	if ( forcePos > -1 )
		file.toolTipStrings[ category ].insert( forcePos, toolTipString )
	else
		file.toolTipStrings[ category ].append( toolTipString )
}

void function StatCard_SetStatToolTip( string category )
{
	var menu = GetMenu( "InspectMenu" )
	var menuPanel = Hud_GetChild( menu, "StatsSummaryPanel" )

	string toolTipString = ""
	for( int i = 0; i < file.toolTipStrings[ category ].len(); i++ )
	{
		toolTipString += file.toolTipStrings[ category ][i]

		if( i != file.toolTipStrings[ category ].len() - 1 )
			toolTipString += "\n"
	}

	var toolTipField = GetToolTipField( menuPanel, category )
	ToolTipData toolTipData
	toolTipData.descText = toolTipString
	Hud_SetToolTipData( toolTipField, toolTipData )
}

var function GetToolTipField( var menuPanel, string category )
{
	if ( category == STAT_TOOLTIP_HEADER_CAREER )
	{
		return Hud_GetChild( menuPanel, "StatsCardToolTipField_Summary_Header"  )
	}
	else if ( category == STAT_TOOLTIP_LCIRCLE_CAREER )
	{
		return Hud_GetChild( menuPanel, "StatsCardToolTipField_Summary_LeftCircle"  )
	}
	else if ( category == STAT_TOOLTIP_RCIRCLE_CAREER )
	{
		return Hud_GetChild( menuPanel, "StatsCardToolTipField_Summary_RightCircle"  )
	}
	else if ( category == STAT_TOOLTIP_COLUMNA_CAREER )
	{
		return Hud_GetChild( menuPanel, "StatsCardToolTipField_Summary_ColumnA"  )
	}
	else if ( category == STAT_TOOLTIP_COLUMNB_CAREER )
	{
		return Hud_GetChild( menuPanel, "StatsCardToolTipField_Summary_ColumnB"  )
	}
	else if ( category == STAT_TOOLTIP_HEADER_SEASON )
	{
		return Hud_GetChild( menuPanel, "StatsCardToolTipField_Season_Header"  )
	}
	else if ( category == STAT_TOOLTIP_LCIRCLE_SEASON )
	{
		return Hud_GetChild( menuPanel, "StatsCardToolTipField_Season_LeftCircle"  )
	}
	else if ( category == STAT_TOOLTIP_RCIRCLE_SEASON )
	{
		return Hud_GetChild( menuPanel, "StatsCardToolTipField_Season_RightCircle"  )
	}
	else if ( category == STAT_TOOLTIP_COLUMNA_SEASON )
	{
		return Hud_GetChild( menuPanel, "StatsCardToolTipField_Season_ColumnA"  )
	}
	else
	{
		return Hud_GetChild( menuPanel, "StatsCardToolTipField_Season_ColumnB"  )
	}
}

var function CreateNestedProgressBar( var parentRui, string argName )
{
	var nestedRui = RuiCreateNested( parentRui, argName, $"ui/xp_progress_bars_stats_card.rpak" )

	return nestedRui
}

var function CreateNestedRankedBadge( var parentRui, string argName )
{
	var nestedRui = RuiCreateNested( parentRui, argName, $"ui/ranked_badge.rpak" )

	return nestedRui
}
#endif // UI
