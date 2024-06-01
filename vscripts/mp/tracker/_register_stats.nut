untyped
globalize_all_functions
#if TRACKER && HAS_TRACKER_DLL

struct {

	bool RegisterCoreStats = true

} file

void function SetRegisterCoreStats( bool b )
{
	file.RegisterCoreStats = b
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
	// NULL_STATS_INBOUND & NULL_STATS_OUTBOUND can be used as substitutes.
	// GetPlayerStat%TYPE%( playerUID, "statname" )  %TYPE% = [int,bool,float,string]
	// Each stat will only load in if they get registered here.
	// AddCallback_PlayerDataFullyLoaded callbackFunc will get called when 
	// stats finish loading for player.
	//
	// Additionally, an api constant REGISTER_ALL will trigger the return of the entire 
	// script-registered live-table stats.
	//
	// There are limits in place.  int must not exceed 32bit int limit 
	//								string must not exceed 30char
	//								bool 0/1 true/false 
	//								float must not exceed 32bit 
	//								all numericals are signed. 
	//								
	//								There also exists api rate-limiting. 
	

	if( file.RegisterCoreStats )
	{
		Tracker_RegisterStat( "kills",	 			NULL_STATS_INBOUND, 	Tracker_ReturnKills )
		Tracker_RegisterStat( "deaths", 			NULL_STATS_INBOUND,		Tracker_ReturnDeaths )
		Tracker_RegisterStat( "superglides", 		NULL_STATS_INBOUND, 	Tracker_ReturnSuperglides )
		Tracker_RegisterStat( "total_time_played", 	NULL_STATS_INBOUND, 	NULL_STATS_OUTBOUND )
		Tracker_RegisterStat( "total_matches", 		NULL_STATS_INBOUND, 	NULL_STATS_OUTBOUND )
		Tracker_RegisterStat( "score", 				NULL_STATS_INBOUND, 	NULL_STATS_OUTBOUND )
		Tracker_RegisterStat( "settings", 			NULL_STATS_INBOUND, 	NULL_STATS_OUTBOUND )
		
		AddCallback_PlayerDataFullyLoaded( Callback_CoreStatInit )
	}
	
	if( Playlist() == ePlaylists.fs_scenarios )//for demo
	{
		Tracker_RegisterStat( "scenarios_kills", Tracker_ScenariosKillsIn, TrackerStats_ScenariosKills )
		Tracker_RegisterStat( "scenarios_deaths", NULL_STATS_INBOUND, TrackerStats_ScenariosDeaths )
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
	int player_season_kills = GetPlayerStatInt( player.p.UID, "kills" )
	player.p.season_kills = player_season_kills
	player.SetPlayerNetInt( "SeasonKills", player_season_kills )

	int player_season_deaths = GetPlayerStatInt( player.p.UID, "deaths" )
	player.p.season_deaths = player_season_deaths
	player.SetPlayerNetInt( "SeasonDeaths", player_season_deaths )

	int player_season_glides = GetPlayerStatInt( player.p.UID, "superglides" )
	player.p.season_glides = player_season_glides

	int player_season_playtime = GetPlayerStatInt( player.p.UID, "total_time_played" )	
	player.p.season_playtime = player_season_playtime
	player.SetPlayerNetInt( "SeasonPlaytime", player_season_playtime )

	int player_season_gamesplayed = GetPlayerStatInt( player.p.UID, "total_matches" )	
	player.p.season_gamesplayed = player_season_gamesplayed
	player.SetPlayerNetInt( "SeasonGamesplayed", player_season_gamesplayed )

	int player_season_score = GetPlayerStatInt( player.p.UID, "score" )	
	player.p.season_score = player_season_score
	player.SetPlayerNetInt( "SeasonScore", player_season_score )
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
	// AddCallback_PlayerData( "setting", func ) -- use NULL_PDATA() for no func.
	// void function func( entity player, string data )
	//
	// utility:
	//
	// Tracker_FetchPlayerData( uid, setting ) -- string|string
	// Tracker_SavePlayerData( uid, "settingname", value )  -- value: [bool|int|float|string]
	////////////////////////////////////////////////////////////////////
	
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