untyped

global function InitMatchmakingOverlay
global function GetActiveSearchingPlaylist
global function IsConnectingToMatch

global function UpdateMatchmakingStatus

global function MatchmakingOverlay_InitForHubLevelConnect

const string MATCHMAKING_AUDIO_CONNECTING = "ui_menu_apex_launch"

struct
{
	struct {
		string playlistName = ""
		int mapIdx = -1
		int modeIdx = -1
	} preCacheInfo

	array<var> matchStatusRuis

	float timeToRestartMatchMaking = 0
	float matchmakingStartTime = 0.0
	string lastMixtapeMatchmakingStatus

	bool putPlayerInMatchmakingAfterDelay = false
	float matchmakingDelayOverride = -1
} file

void function InitMatchmakingOverlay()
{
	RegisterUIVarChangeCallback( "gameStartTime", GameStartTime_Changed )

	file.matchStatusRuis = GetElementsByClassnameForMenus( "MatchmakingStatusRui", uiGlobal.allMenus )
	foreach ( var el in file.matchStatusRuis )
		printt( "matchStatusRuis ", GetParentMenu( el ).GetHudName() )

	RegisterSignal( "UpdateMatchmakingStatus" )
	RegisterSignal( "BypassWaitBeforeRestartingMatchmaking" )
	RegisterSignal( "PutPlayerInMatchmakingAfterDelay" )
	RegisterSignal( "CancelRestartingMatchmaking" )
	RegisterSignal( "LeaveParty" )
}

function GameStartTime_Changed()
{
	UpdateGameStartTimeCounter()
}

void function UpdateGameStartTimeCounter()
{
	if ( level.ui.gameStartTime == null )
		return

	MatchmakingSetSearchText( "#STARTING_IN_LOBBY" )
	MatchmakingSetCountdownTimer( expect float( level.ui.gameStartTime + 0.0 ), true )

	HideMatchmakingStatusIcons()
}

bool function MatchmakingStatusShouldShowAsActiveSearch( string matchmakingStatus )
{
	if ( matchmakingStatus == "#MATCHMAKING_QUEUED" )
		return true
	if ( matchmakingStatus == "#MATCHMAKING_ALLOCATING_SERVER" )
		return true
	if ( matchmakingStatus == "#MATCHMAKING_MATCH_CONNECTING" )
		return true

	return false
}

string function GetActiveSearchingPlaylist()
{
	if ( !IsConnected() )
		return ""
	if ( !AreWeMatchmaking() )
		return ""

	string matchmakingStatus = GetMyMatchmakingStatus()
	if ( !MatchmakingStatusShouldShowAsActiveSearch( matchmakingStatus ) )
		return ""

	string param1 = GetMyMatchmakingStatusParam( 1 )
	return param1
}

float function CalcMatchmakingWaitTime()
{
	float result = ((file.matchmakingStartTime > 0.01) ? (Time() - file.matchmakingStartTime) : 0.0)
	return result
}

void function UpdateTimeToRestartMatchmaking( float time )//
{
	file.timeToRestartMatchMaking  = time

	if ( time > 0 )
	{
		UpdateRestartMatchmakingStatus( time )
		ShowMatchmakingStatusIcons()
	}
	else
	{
		MatchmakingSetSearchText( "" )
		MatchmakingSetCountdownTimer( 0.0, true )
		HideMatchmakingStatusIcons()
	}
}

void function UpdateRestartMatchmakingStatus( float time )
{
	if ( AmIPartyMember() )
	{
		MatchmakingSetSearchText( "#MATCHMAKING_WAIT_ON_PARTY_LEADER_RESTARTING_MATCHMAKING" )
	}
	else
	{
		MatchmakingSetSearchText( "#MATCHMAKING_WAIT_BEFORE_RESTARTING_MATCHMAKING" )
		MatchmakingSetCountdownTimer( time, false )
	}
}

void function MatchmakingOverlay_InitForHubLevelConnect()
{
	thread UpdateMatchmakingStatus()
}


bool function IsConnectingToMatch()
{
	string matchmakingStatus = GetMyMatchmakingStatus()
	bool isConnectingToMatch = matchmakingStatus == "#MATCHMAKING_MATCH_CONNECTING"

	return isConnectingToMatch
}

void function UpdateMatchmakingStatus()
{
	Signal( uiGlobal.signalDummy, "UpdateMatchmakingStatus" )
	EndSignal( uiGlobal.signalDummy, "CleanupInGameMenus" )
	EndSignal( uiGlobal.signalDummy, "UpdateMatchmakingStatus" )

	printf( "%s() - Started", FUNC_NAME() )
	OnThreadEnd(
		function() : ()
		{
			printf( "%s() - Hiding all matchmaking elems due to thread ending", FUNC_NAME() )

			HideMatchmakingStatusIcons()

			MatchmakingSetSearchText( "" )
			MatchmakingSetCountdownTimer( 0.0, true )

			MatchmakingSetSearchVisible( false )
			MatchmakingSetCountdownVisible( false )
		}
	)

	MatchmakingSetSearchVisible( true )
	MatchmakingSetCountdownVisible( true )

	string lastActiveSearchingPlaylist
	file.matchmakingStartTime = 0.0
	file.lastMixtapeMatchmakingStatus = ""

	while ( true )
	{
		string matchmakingStatus = GetMyMatchmakingStatus()
		bool isConnectingToMatch = matchmakingStatus == "#MATCHMAKING_MATCH_CONNECTING"

		string activeSearchingPlaylist = GetActiveSearchingPlaylist()
		if ( lastActiveSearchingPlaylist != activeSearchingPlaylist )
		{
			if ( activeSearchingPlaylist.len() > 0 )
			{
				lastActiveSearchingPlaylist = activeSearchingPlaylist
				file.matchmakingStartTime = Time()
			}
			else
			{
				lastActiveSearchingPlaylist = ""
				file.matchmakingStartTime = 0.0
			}
		}

		if ( isConnectingToMatch && (matchmakingStatus != file.lastMixtapeMatchmakingStatus) )
		{
			EmitUISound( MATCHMAKING_AUDIO_CONNECTING )
		}

		file.lastMixtapeMatchmakingStatus = matchmakingStatus

		if ( GetTimeToRestartMatchMaking() > 0 )
		{
			UpdateRestartMatchmakingStatus( GetTimeToRestartMatchMaking() )
		}
		else
		{
			MatchmakingSetCountdownTimer( 0.0, true )
			MatchmakingSetSearchText( "" )
			HideMatchmakingStatusIcons()

			if ( IsConnected() )
			{
				string playlistName = GetMyMatchmakingStatusParam( 1 )
				int numQueued = int( GetMyMatchmakingStatusParam( 2 ) )
				int mapIdx = int( GetMyMatchmakingStatusParam( 3 ) )
				int modeIdx = int( GetMyMatchmakingStatusParam( 4 ) )
				string playlistList = GetMyMatchmakingStatusParam( 5 )

				if ( mapIdx > -1 && modeIdx > -1 )
				{
					if ( file.preCacheInfo.playlistName != playlistName || file.preCacheInfo.mapIdx != mapIdx || file.preCacheInfo.modeIdx != modeIdx )
					{
						file.preCacheInfo.playlistName = playlistName
						file.preCacheInfo.mapIdx = mapIdx
						file.preCacheInfo.modeIdx = modeIdx
					}
				}

				string numQueuedStatus = ""
				if ( matchmakingStatus == "" && AreWeMatchmaking() )
				{
					matchmakingStatus = "#MATCHMAKING_SEARCHING_FOR_MATCH"
				}
				else if ( numQueued > 0 )
				{
					numQueuedStatus = Localize( "#MATCHMAKING_NUM_QUEUED", numQueued )
				}

				if ( matchmakingStatus != "" && matchmakingStatus != "#MATCHMAKING_PARTYNOTREADY" )
					ShowMatchmakingStatusIcons()

				MatchmakingSetSearchText( matchmakingStatus, numQueuedStatus )
			}
		}

		WaitFrameOrUntilLevelLoaded()
	}
}

float function GetTimeToRestartMatchMaking()
{
	return file.timeToRestartMatchMaking
}

void function HideMatchmakingStatusIcons()
{
	foreach ( element in file.matchStatusRuis )
		MMStatusRui_HideIcons( Hud_GetRui( element ) )

	MMStatusOnHUD_HideIcons()
}

void function ShowMatchmakingStatusIcons()
{
	if (GetActiveMenu() == GetMenu( "LobbyMenu" ) )
	{
		Hud_SetVisible( Hud_GetChild( GetMenu( "LobbyMenu" ), "MatchmakingStatus" ),  GetMenuActiveTabIndex( GetMenu( "LobbyMenu" ) ) != 0 )
	}

	foreach ( element in file.matchStatusRuis )
		MMStatusRui_ShowIcons( Hud_GetRui( element ) )

	MMStatusOnHUD_ShowIcons()
}

void function MatchmakingSetSearchVisible( bool state )
{
	foreach ( element in file.matchStatusRuis )
		MMStatusRui_SetSearchVisible( Hud_GetRui( element ), state )

	MMStatusOnHUD_SetSearchVisible( state )
}

void function MatchmakingSetSearchText( string searchText, var param1 = "", var param2 = "", var param3 = "", var param4 = "" )
{
	foreach ( element in file.matchStatusRuis )
		MMStatusRui_SetSearchText( Hud_GetRui( element ), searchText, param1, param2, param3, param4 )

	MMStatusOnHUD_SetSearchText( searchText, param1, param2, param3, param4 )
}

void function MatchmakingSetCountdownVisible( bool state )
{
	foreach ( element in file.matchStatusRuis )
		MMStatusRui_SetCountdownVisible( Hud_GetRui( element ), state )

	MMStatusOnHUD_SetCountdownVisible( state )
}

void function MatchmakingSetCountdownTimer( float time, bool useServerTime = true ) //
{
	foreach ( element in file.matchStatusRuis )
		MMStatusRui_SetCountdownTimer( Hud_GetRui( element ), time, useServerTime )

	MMStatusOnHUD_SetCountdownTimer( time, useServerTime )
}
