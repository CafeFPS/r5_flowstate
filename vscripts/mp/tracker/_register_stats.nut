untyped
globalize_all_functions
#if TRACKER && HAS_TRACKER_DLL

struct {

	bool RegisterCoreStats = true
	bool bStatsIs1v1Type = false

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
	// GetPlayerStat%TYPE%( playerUID, "statname" )  %TYPE% = [int,bool,float,string]
	// Each stat will only load in if they get registered here.
	// AddCallback_PlayerDataFullyLoaded callbackFunc will get called when 
	// stats finish loading for player.
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
	
	Tracker_RegisterStat( "settings" )

	if( file.RegisterCoreStats )
	{
		Tracker_RegisterStat( "kills", null, Tracker_ReturnKills )
		Tracker_RegisterStat( "deaths", null, Tracker_ReturnDeaths )
		Tracker_RegisterStat( "superglides", null, Tracker_ReturnSuperglides )
		Tracker_RegisterStat( "total_time_played" )
		Tracker_RegisterStat( "total_matches" )
		Tracker_RegisterStat( "score" )
		Tracker_RegisterStat( "previous_champion", null, Tracker_ReturnChampion )
		
		AddCallback_PlayerDataFullyLoaded( Callback_CoreStatInit )
	}
	
	if( Playlist() == ePlaylists.fs_scenarios )//for demo
	{
		Tracker_RegisterStat( "scenarios_kills", Tracker_ScenariosKillsIn, TrackerStats_ScenariosKills )
		Tracker_RegisterStat( "scenarios_deaths", null, TrackerStats_ScenariosDeaths )
	}
}

////////////////////
// STAT FUNCTIONS //
////////////////////

void function Tracker_ScenariosKillsIn( entity player )
{
	printt( player, "Wow, this player has " + player.GetPlayerStatInt("scenarios_kills") )
}

void function Callback_CoreStatInit( entity player )
{
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

var function Tracker_ReturnChampion( string uid )
{
	return Tracker_StatsMetricsByUID( uid ).previous_champion
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
	
	if( file.bStatsIs1v1Type )
		Gamemode1v1_PlayerDataCallbacks()
		
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
	
	Pin_Query_Init()
	//CustomGamemodeQueries_Init()
	//Gamemode1v1Queries_Init()
	//etc...etc..
}


#endif //TRACKER && HAS_TRACKER_DLL