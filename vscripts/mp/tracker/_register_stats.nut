//untyped
globalize_all_functions
#if TRACKER && HAS_TRACKER_DLL

struct {

	bool RegisterCoreStats 	= true
	bool bStatsIs1v1Type 	= false

} file

void function SetRegisterCoreStats( bool b )
{
	file.RegisterCoreStats = b
}

void function Tracker_Init()
{
	file.bStatsIs1v1Type = g_is1v1GameType()
	
	bool bRegisterCoreStats = !GetCurrentPlaylistVarBool( "disable_core_stats", false )
	SetRegisterCoreStats( bRegisterCoreStats )
}

//////////////////////////////////////////////////
// These stats are global stats registered in 	//
//	api backend. 								//
//											  	//
// For server-instance settings, register a   	//
// setting with AddCallback_PlayerData()		//
//												//
// Those settings will be unique to each server //
// for each player.								//
//					Player-persistence settings //	
//					can be fetched with 		//
//					Tracker_FetchPlayerData()	//
//					and saved with				//
//					Tracker_SavePlayerData()	//
//										   ~mkos//
//////////////////////////////////////////////////
void function Script_RegisterAllStats()
{
	// void function Tracker_RegisterStat( string statname, void functionref( entity ) inboundCallbackFunc, var functionref( string ) outboundCallbackFunc )
	//
	// Tracker_RegisterStat( "backend-name", data_in_callback, data_out_callback)
	// null can be used as substitutes if specific in/out is not needed.
	// Stats don't need an in function to be fetched with the getter functions.
	// They can all be fetched when stats for a player loads,
	// see: AddCallback_PlayerDataFullyLoaded below.
	//
	// GetPlayerStat%TYPE%( playerUID, "statname" )  %TYPE% = [Int,Bool,Float,String]
	// Each stat will only load in if they get registered here.
	// AddCallback_PlayerDataFullyLoaded callbackFunc will get called when 
	// stats finish loading for a player.
	//
	// Additionally, an api constant REGISTER_ALL will trigger the return of the entire 
	// script-registered live-table stats.
	//
	// There are limits in place:   - int must not exceed 32bit int limit 
	//								- string must not exceed 30char
	//								- bool 0/1 true/false 
	//								- float must not exceed 32bit 
	//								- all numericals are signed. 
	//								
	//								There also exists api rate-limiting. 
	//
	//	Stats registerd under 'recent_match_data' group in the backend do NOT aggregate.
	//	These stats should be prefixed with 'previous_' for clarity.
	
	
	//Script required stats
	Tracker_RegisterStat( "settings" )
	Tracker_RegisterStat( "isDev" )
	
	//Global mute ( helper controlled set via web panel/mod api only & actions logged )
	if( Chat_GlobalMuteEnabled() )
		Tracker_RegisterStat( "globally_muted", Chat_CheckGlobalMute )

	//Core stats - can disable for gamemode purposes.
	if( file.RegisterCoreStats )
	{
		Tracker_RegisterStat( "kills", null, Tracker_ReturnKills )
		Tracker_RegisterStat( "deaths", null, Tracker_ReturnDeaths )
		Tracker_RegisterStat( "superglides", null, Tracker_ReturnSuperglides )
		Tracker_RegisterStat( "total_time_played" )
		Tracker_RegisterStat( "total_matches" )
		Tracker_RegisterStat( "score" )
		Tracker_RegisterStat( "previous_champion", null, Tracker_ReturnChampion )
		Tracker_RegisterStat( "previous_kills", null, Tracker_RecentKills )
		Tracker_RegisterStat( "previous_damage", null, Tracker_RecentDamage )
		//Tracker_RegisterStat( "previous_survival_time", null,  )
		
		AddCallback_PlayerDataFullyLoaded( Callback_CoreStatInit )
	}
	
	if( Playlist() == ePlaylists.fs_scenarios )
	{
		Tracker_RegisterStat( "scenarios_kills", null, TrackerStats_ScenariosKills )
		Tracker_RegisterStat( "scenarios_deaths", null, TrackerStats_ScenariosDeaths )
		Tracker_RegisterStat( "scenarios_score", null, TrackerStats_ScenariosScore )
		Tracker_RegisterStat( "scenarios_downs", null, TrackerStats_ScenariosDowns )
		Tracker_RegisterStat( "scenarios_team_wipe", null, TrackerStats_ScenariosTeamWipe )
		Tracker_RegisterStat( "scenarios_team_wins", null, TrackerStats_ScenariosTeamWins )
		Tracker_RegisterStat( "scenarios_solo_wins", null, TrackerStats_ScenariosSoloWins )
		Tracker_RegisterStat( "previous_score", null, TrackerStats_ScenariosRecentScore )

		AddCallback_PlayerDataFullyLoaded( Callback_HandleScenariosStats )
	}
}

////////////////////
// STAT FUNCTIONS //
////////////////////

void function Callback_CoreStatInit( entity player )
{
	// setting frequently computed stats in player struct is cheaper than using 
	// type matching/casting stat fetchers getting vars from untyped table.
	// net ints also used in match making / stat display features.
	
	string uid = player.p.UID
	
	int player_season_kills = GetPlayerStatInt( uid, "kills" )
	player.p.season_kills = player_season_kills
	player.SetPlayerNetInt( "SeasonKills", player_season_kills )

	int player_season_deaths = GetPlayerStatInt( uid, "deaths" )
	player.p.season_deaths = player_season_deaths
	player.SetPlayerNetInt( "SeasonDeaths", player_season_deaths )

	player.p.season_glides = GetPlayerStatInt( uid, "superglides" )

	int player_season_playtime = GetPlayerStatInt( uid, "total_time_played" )	
	player.p.season_playtime = player_season_playtime
	player.SetPlayerNetInt( "SeasonPlaytime", player_season_playtime )

	int player_season_gamesplayed = GetPlayerStatInt( uid, "total_matches" )	
	player.p.season_gamesplayed = player_season_gamesplayed
	player.SetPlayerNetInt( "SeasonGamesplayed", player_season_gamesplayed )

	int player_season_score = GetPlayerStatInt( uid, "score" )
	player.p.season_score = player_season_score
	player.SetPlayerNetInt( "SeasonScore", player_season_score )
}

void function Callback_HandleScenariosStats( entity player )
{
	string uid = player.p.UID
		
	const string strSlice = "scenarios_"
	foreach( string statKey, var statValue in Stats__GetPlayerStatsTable( uid ) ) //Todo: register by script name group
	{
		#if DEVELOPER
			printw( "found statKey =", statKey, "statValue =", statValue )
		#endif 
		
		if( statKey.find( strSlice ) != -1 )
			ScenariosPersistence_SetUpOnlineData( player, statKey, statValue )
	}
}

var function Tracker_ReturnChampion( string uid )
{
	return Tracker_StatsMetricsByUID( uid ).previous_champion
}

var function Tracker_RecentKills( string uid )
{
	return Tracker_StatsMetricsByUID( uid ).kills
}

var function Tracker_RecentDamage( string uid )
{
	return Tracker_StatsMetricsByUID( uid ).damage
}

//////////////////////////////////////////////////////////
//														//
//	Any player settings that do not get registered 		//
//	will not be loaded in. To load all settings 		//
//	you can use RegisterAllSettings()					//
//	however, you do not need to register settings		//
//	manually, they will be registered when you add		//
//	a callback via AddCallback_PlayerData()				//
//														//
//////////////////////////////////////////////////////////

void function Script_RegisterAllPlayerDataCallbacks()
{
	////////////////////////////////////////////////////////////////////
	//
	// Add a callback to register a setting to be loaded.
	// Must be in the tracker backend.
	//
	// AddCallback_PlayerData( string setting, void functionref( entity player, string data ) callbackFunc )
	// AddCallback_PlayerData( "setting", func ) -- omit second param or use null for no func. AddCallback_PlayerData( "setting" )
	// void function func( entity player, string data )
	//
	// utility:
	//
	// Tracker_FetchPlayerData( uid, setting ) -- string|string
	// Tracker_SavePlayerData( uid, "settingname", value )  -- value: [bool|int|float|string]
	////////////////////////////////////////////////////////////////////
	
	Chat_RegisterPlayerData()
	
	if( file.bStatsIs1v1Type )
		Gamemode1v1_PlayerDataCallbacks()
		
	switch( Playlist() )
	{
		case ePlaylists.fs_scenarios:
			Scenarios_PlayerDataCallbacks()
		break
		
		default:
			break
	}
		
	//func
}

///////////////////////////// QUERIES ////////////////////////////////////////////
// usage=   AddCallback_QueryString("category:query", resultHandleFunction )	//
// 			see r5r.dev/info for details about available categories.		 	//
// 			verfified hosts: Add custom queries from host cp				 	//
//																				//
//			EX: restricted_rank:500   returns minimum player score for var "500"//
//////////////////////////////////////////////////////////////////////////////////

void function Script_RegisterAllQueries()
{
	////// INIT FUNCTIONS FOR GAMEMODES //////
	
	Tracker_QueryInit()
	//CustomGamemodeQueries_Init()
	//Gamemode1v1Queries_Init()
	//etc...etc..
}
#endif //TRACKER && HAS_TRACKER_DLL