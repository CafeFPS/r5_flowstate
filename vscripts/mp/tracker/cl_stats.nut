global function Tracker_ClientStats_Init													//mkos

global function Tracker_SetPlayerStatBool
global function Tracker_SetPlayerStatInt
global function Tracker_SetPlayerStatFloat

global function Tracker_StatRequestFailed
global function Tracker_PreloadStatArray
global function Tracker_PreloadStat
global function Tracker_FetchStat
global function Tracker_StatExists

global const float MAX_PRELOAD_TIMEOUT = 5.0

typedef EntityStatStruct table < entity, table < string, var > >
const bool DEBUG_CL_STATS = true
const float MAX_FETCH_TIMEOUT = 5.0

struct StatData
{
	entity player
	string statname
}

struct
{
	EntityStatStruct playerStatTables
	array<StatData> statDataStack
	table< entity, table<string, bool> > lockTable
	array< string > preloadStats
	entity infoSignal
	
} file 

// In order to use this feature on the client, 
// stats need preloaded on the client before fetching.

// Use the entity of the player to lookup and the statname. 

// If you call Tracker_FetchStat on a stat not preloaded, it will return null and 
// preload the stat for you in the background via the stat stack thread. 
// Use Tracker_StatExists( player, "statname" ) to check 

// You can preload all of the stats you want from other connected players 
// by iterating with Tracker_PreloadStatArray( [ player1 ], [ "stat1","stat2" ] ) for example.
// This should only be done when a player is ready to be stat fetch requested. 
// The preloader waits for this by default foreach player if not done before called.
// Use Tracker_IsStatsReadyFor( player ) to get a bool of the status for that player.

void function Tracker_ClientStats_Init()
{
	RegisterSignal( "StatDataReceived" )
	RegisterSignal( "RequestStatFailed" )
	RegisterSignal( "PreloadStat" )
	
	file.infoSignal = CreateClientSidePointCamera( <0, 0, 0>, <0, 0, 0>, 50 )
	
	thread ClientStats_Think()
	
	#if DEBUG_CL_STATS
		printw( "NOTICE: DEBUG_CL_STATS is set to true in", FILE_NAME() )
	#endif
}

void function Tracker_SetPlayerStatBool( entity player, bool value )
{
	Signal( file.infoSignal, "StatDataReceived", { value = value } )
}

void function Tracker_SetPlayerStatInt( entity player, int value )
{
	Signal( file.infoSignal, "StatDataReceived", { value = value } )
}

void function Tracker_SetPlayerStatFloat( entity player, float value )
{
	Signal( file.infoSignal, "StatDataReceived", { value = value } )
}

void function ClientStats_Think()
{
	for( ; ; )
	{
		WaitSignal( file.infoSignal, "PreloadStat" )	

		while( StatStackHasItems() )
		{
			StatData statData 	= __PopStatStack()
			
			entity lookupPlayer = statData.player
			string stat 		= statData.statname
			
			if( !IsValid_ThisFrame( lookupPlayer ) )
				continue
			
			while( !Tracker_IsStatsReadyFor( lookupPlayer ) )
			{
				WaitFrames( 5 )
				
				if( !IsValid( lookupPlayer ) )
					break
			}
				
			if( !IsValid( lookupPlayer ) )
				continue
			
			var data = __FetchPlayerStatInThread( lookupPlayer, stat )
			
			#if DEVELOPER && DEBUG_CL_STATS
				printw( "stat", stat, "=", data, "was preloaded on the client for player ", lookupPlayer )
			#endif
		}
	}
}

bool function StatStackHasItems()
{
	return ( file.statDataStack.len() > 0 )
}

void function __StatStackRemoveDuplicates()
{
	array<StatData> returnStack = []
	table<string, bool> keyMap = {}
	
	foreach( StatData data in file.statDataStack )
	{	
		string key = ( string( data.player ) + data.statname )
		
		if( !( key in keyMap ) )
		{
			keyMap[ key ] <- true 
			returnStack.append( data )
		}
	}
	
	file.statDataStack = returnStack
}

var function Tracker_FetchStat( entity player, string stat )
{
	ValidatePlayerStatTable( player )
	
	if( !( stat in file.playerStatTables[ player ] ) )
	{
		#if DEVELOPER && DEBUG_CL_STATS
			printw( "Stat", stat, " was not fetched and is being preloaded now." )
		#endif 
		
		Tracker_PreloadStat( player, stat )
	}
	else 
	{
		return file.playerStatTables[ player ][ stat ]
	}
	
	return null
}

void function Tracker_PreloadStat( entity player, string stat )
{
	__AddToStatStack( player, stat )
	Signal( file.infoSignal, "PreloadStat" )
}

void function Tracker_PreloadStatArray( array<entity> players, array<string> stats )
{
	foreach( player in players )
	{
		foreach( statname in stats )
			__AddToStatStack( player, statname )
	}
		
	Signal( file.infoSignal, "PreloadStat" )
}

void function __AddToStatStack( entity player, string stat )
{
	StatData data
	
	data.player = player 
	data.statname = stat 
	
	file.statDataStack.append( data )
}

StatData function __PopStatStack()
{
	__StatStackRemoveDuplicates()
	return file.statDataStack.pop()
}

bool function IsLocked( entity player, string stat )
{
	CheckPlayerForLock( player )
	return ( stat in file.lockTable[ player ] )
}

void function LockStat( entity player, string stat )
{
	CheckPlayerForLock( player )
	file.lockTable[ player ][ stat ] <- true
}

void function UnlockStat( entity player, string stat )
{
	CheckPlayerForLock( player )
	
	if( stat in file.lockTable[ player ] )
		delete file.lockTable[ player ][ stat ]
}

void function CheckPlayerForLock( entity player )
{
	if( !( player in file.lockTable ) )
		file.lockTable[ player ] <- {}
}

var function __FetchPlayerStatInThread( entity player, string stat )
{
	float startTime = Time()
	while( !Tracker_IsStatsReadyFor( player ) )
	{
		#if DEVELOPER && DEBUG_CL_STATS
			printw( "Waiting for player stats to load for lookup: \"" + stat + "\" Player:", player )
		#endif 
		
		WaitFrames( 5 )
		
		if( Time() > startTime + MAX_FETCH_TIMEOUT )
		{
			#if DEVELOPER && DEBUG_CL_STATS
				printw( "Timeout during fetch for stat:", stat, "on player:", player )
			#endif
			
			return null
		}
	}
		
	ValidatePlayerStatTable( player )
	
	if( !( stat in file.playerStatTables[ player ] ) )
	{
		__RequestPlayerStat( player, stat )
		WaitFrame()
	}
	
	if( ( stat in file.playerStatTables[ player ] ) )
		return file.playerStatTables[ player ][ stat ]
		
	return null
}

void function ValidatePlayerStatTable( entity player )
{
	if( !PlayerStatTableExists( player ) )
		file.playerStatTables[ player ] <- {}	
}

bool function PlayerStatTableExists( entity player )
{
	return( player in file.playerStatTables )	
}

void function __RequestPlayerStat( entity player, string stat )
{
	player.EndSignal( "OnDestroy" )
	EndSignal( file.infoSignal, "RequestStatFailed" )
	
	ValidatePlayerStatTable( player )
	
	entity localPlayer = GetLocalClientPlayer()
	if( !IsValid( localPlayer ) )
		return 
		
	if( IsLocked( player, stat ) )
	{
		printw( "stat \"" + stat + "\" is locked." )
		return
	}
	
	LockStat( player, stat )
	localPlayer.ClientCommand( "requestStat " + string( player.GetEncodedEHandle() ) + " " + stat )
	table statData = WaitSignal( file.infoSignal, "StatDataReceived" )
	
	SetStat( player, stat, statData.value )
	UnlockStat( player, stat )
	
	#if DEVELOPER && DEBUG_CL_STATS
		printw( "Stat set for player: ", player, stat, "=", statData.value )
	#endif
}

void function SetStat( entity player, string stat, var value )
{
	if( stat in file.playerStatTables[ player ] )
		file.playerStatTables[ player ][ stat ] = value
	else 
		file.playerStatTables[ player ][ stat ] <- value
}

void function Tracker_StatRequestFailed()
{
	#if DEVELOPER && DEBUG_CL_STATS
		printw( "Stat request failed" )
	#endif
	
	Signal( file.infoSignal, "RequestStatFailed" )
}

bool function Tracker_StatExists( entity player, string statname )
{
	if( !( player in file.playerStatTables ) )
		return false 
	
	return ( statname in file.playerStatTables[ player ] )
}