global function ClientMusic_SharedInit
global function ClientMusic_RegisterNetworking
//
global function ClientMusic_DisableForClient
global function ClientMusic_EnableForClient
global function ClientMusic_PlayCustomTrackOnClient
global function ClientMusic_StopCustomTrackOnClient

#if CLIENT
global function ClientMusic_RequestStingerForNewZone
#if DEV
global function ClientMusic_PrintStatus
#endif // #if DEV
#endif // CLIENT

#if SERVER
global function ClientMusic_PlayCustomTrackToAll
global function ClientMusic_StopCustomTrackOnAll
#endif // SERVER

global enum eMusicTrack
{
	ZoneTransitionStingers,

	GeneralTeamWipe,
	GeneralCombat,
	GeneralCombatOver,
	GeneralWaitingForPlayers,

	//
	IntroTense,
	IntroMysterious,
	BigVictory,
	BossFight,
	BossFightVictory,
	Surprise,
	CrowRescue,
	CrowWon,
	Assault,
	GetItDone,
	LastStand,
	DaySaved,
	Goodbye,

	_count
}

const array<string> [eMusicTrack._count] s_TracksMap =
[
	/* ZoneTransitionStingers */			["music_beacon_12_spoke1fallensoldiers", "music_skyway_17_slonedies", "music_timeshift_16_explorepresent", "music_timeshift_22_panicburst", "music_wilds_14_timetoinstallbatterytwo"],

	/* GeneralTeamWipe */					["music_boomtown_20_abovethedome"],
	/* GeneralCombat */						["music_skyway_16_slonefight"],
	/* GeneralCombatOver*/					["music_skyway_17_slonedies"],
	/* GeneralWaitingForPlayers*/			["music_timeshift_elevator_bossanova"],

	//
	/* IntroTense */						["Music_CloudCity_04_SpottedBySoldiers"],
	/* IntroMysterious */					["music_timeshift_34_timestop"],
	/* BigVictory */						["music_cloudcity_05_turretsdestroyed"],
	/* BossFight */							["music_cloudcity_10_bossintroduction"],
	/* BossFightVictory */					["music_cloudcity_22_miragebossdefeated"],
	/* Surprise */							["music_s2s_03_jump2malta"],
	/* Crow Rescue */						["music_reclamation_04_firsttitanbattle"],
	/* Crow Won */							["music_s2s_13_btarrives"],
	/* Assault */							["music_cloudcity_16_enemytitansarrive"],
	/* GetItDone */							["music_s2s_04_maltabattle_alt"],
	/* LastStand */							["music_s2s_02_throw2blackbird64_land"],
	/* DaySaved */							["music_s2s_17_bossdead"],
	/* Goodbye */							["music_cloudcity_06_goodbyegibraltar"]
]

struct
{
} file


#if CLIENT

struct TrackPlayData
{
	int shufflePos = 999
	array<int> shuffledIndices

	int lastIndex = -1
}
TrackPlayData[eMusicTrack._count] s_TrackPlayDatas

int s_lastPlayedMuscTrackDEBUG = -1
string function GetNextShuffledTrackFor( int musicTrack )
{
	s_lastPlayedMuscTrackDEBUG = musicTrack
	Assert( (musicTrack >= 0) && (musicTrack < eMusicTrack._count) )
	if ( s_TracksMap[musicTrack].len() == 0 )
		return ""

	TrackPlayData tpd = s_TrackPlayDatas[musicTrack]
	array<int> indices = tpd.shuffledIndices

	++(tpd.shufflePos)
	if ( tpd.shufflePos >= indices.len() )
	{
		tpd.shufflePos = 0

		// Shuffle order:
		{

			int length = s_TracksMap[musicTrack].len()
			indices.resize( length )
			for ( int idx = 0; idx < length; ++idx )
				indices[idx] = idx
			indices.randomize()

			// no repeats:
			if ( (length > 1) && (indices[0] == tpd.lastIndex) )
				indices.reverse()
		}
	}

	tpd.lastIndex = indices[tpd.shufflePos]
	return s_TracksMap[musicTrack][tpd.lastIndex]
}

bool s_zoneStingerRequested = false
float s_zoneStingerRequestedTime
void function ClientMusic_RequestStingerForNewZone( int zoneId )
{
	s_zoneStingerRequested = true
	s_zoneStingerRequestedTime = Time()
}

var s_lastPlayedHandle = null
string s_lastPlayedAliasDEBUG = ""
void function StartPlayingMusic( string musicAlias )
{
	if ( musicAlias == "" )
		return
	entity player = GetLocalViewPlayer()
	if ( !IsValid( player ) )
		return

	s_lastPlayedHandle = EmitSoundOnEntity( player, musicAlias )		// EmitSoundOnEntityWithSeek
	SetPlayThroughKillReplay( s_lastPlayedHandle )
	s_lastPlayedAliasDEBUG = musicAlias

	printf( "%s() - '%s'", FUNC_NAME(), musicAlias )
}
void function StopPlayingMusic()
{
	//FadeOutSoundOnEntity( s_lastPlayedEntity, s_lastPlayedAlias, 2.0 )		// StopSoundOnEntity

	if ( s_lastPlayedHandle != null )
		StopSound( s_lastPlayedHandle )

	s_lastPlayedHandle = null
}

enum eMusicLevel
{
	None,
	Ambient,
	EnemyNear,
	Combat,
	GameOver,
	WaitingForPlayers,

	CustomTrack,

	_count
}

bool s_musicSystemIsDisabled = false

int s_cachedAnswer = 0
float s_cachedAnswerTime = -999.0
float s_cachedAnswerTimeWasLastTrue = -999.0
int function CountEnemiesNearby()
{
	if ( (Time() - s_cachedAnswerTime) < 5.0 )
		return s_cachedAnswer

	entity player = GetLocalViewPlayer()
	if ( !IsValid( player ) )
		return 0

	array<entity> NPCs = GetNPCArrayEx( "any", TEAM_ANY, player.GetTeam(), player.GetOrigin(), 2000.0 )
	s_cachedAnswer = NPCs.len()
	s_cachedAnswerTime = Time()
	if ( s_cachedAnswer > 0 )
		s_cachedAnswerTimeWasLastTrue = Time()
	return s_cachedAnswer
}
float function CountEnemiesNearbyTimeSinceValid()
{
	return (Time() - s_cachedAnswerTimeWasLastTrue)
}

float function GetEffectiveDeltaSince( float timeThen )
{
	if ( timeThen <= 0.0001 )
		return 999999.0

	return (Time() - timeThen)
}

bool function CombatTriggeredCheck( entity player )
{
	if ( GetEffectiveDeltaSince( player.GetLastTimeDamagedByNPC() ) < 10.0 )
		return true
	if ( GetEffectiveDeltaSince( player.GetLastTimeDidDamageToNPC() ) < 10.0 )
		return true

	return false
}

const float NEARBY_FRIENDLY_RANGE = 3000.0
bool function AnyNearbyFriendlyIsCombatTriggered( entity player )
{
	array<entity> teamPlayers = GetPlayerArrayEx( "any", player.GetTeam(), TEAM_ANY, player.GetOrigin(), NEARBY_FRIENDLY_RANGE )
	foreach ( teamPlayer in teamPlayers )
	{
		if ( CombatTriggeredCheck( teamPlayer ) )
			return true
	}

	return false
}

bool function AnyNearbyFriendlyIsBleedingOut( entity player )
{
	array<entity> teamPlayers = GetPlayerArrayEx( "any", player.GetTeam(), TEAM_ANY, player.GetOrigin(), NEARBY_FRIENDLY_RANGE )
	foreach ( teamPlayer in teamPlayers )
	{
		if ( Bleedout_IsBleedingOut( teamPlayer ) )
			return true
	}

	return false
}

bool function MyTeamIsDeadMyWholeTeamIsDead( entity player )
{
	if ( !IsMultiTeamMission() )
	{
		array<entity> teamPlayers = GetPlayerArrayOfTeam_Alive( player.GetTeam() )
		if ( teamPlayers.len() == 0 )
			return true
	}

	return false
}

bool s_customTrackIsPlaying = false
void function StartPlayingCustomTrack( int musicTrack )
{
	StopPlayingCustomTrack()
	EndSignal( clGlobal.levelEnt, "ClientMusic_CustomTrackStop" )

	string alias = GetNextShuffledTrackFor( musicTrack )
	if ( alias == "" )
		return

	StartPlayingMusic( alias )
	s_customTrackIsPlaying = true

	OnThreadEnd(
		function() : ()
		{
			s_customTrackIsPlaying = false
		}
	)

	if ( s_lastPlayedHandle != null )
		WaitSignal( s_lastPlayedHandle, "OnSoundFinished" )
}

void function StopPlayingCustomTrack()
{
	Signal( clGlobal.levelEnt, "ClientMusic_CustomTrackStop" )
	Assert( s_customTrackIsPlaying == false )
}

int s_queuedCustomTrack = -1
int function GetDesiredMusicLevel( int currentMusicLevel )
{
	//if ( s_musicSystemIsDisabled )
	//	return eMusicLevel.None

	return eMusicLevel.None
}

int s_musicLevel = eMusicLevel.None
void function ClientMusicFRAME()
{
	int newMusicLevel = GetDesiredMusicLevel( s_musicLevel )
	if ( (newMusicLevel != s_musicLevel) || ((newMusicLevel == eMusicLevel.CustomTrack) && (s_queuedCustomTrack > 0)) )
	{
		StopPlayingMusic()
		if ( newMusicLevel == eMusicLevel.CustomTrack )
		{
			thread StartPlayingCustomTrack( s_queuedCustomTrack )
			s_queuedCustomTrack = -1
		}
		else if ( newMusicLevel == eMusicLevel.EnemyNear )
		{
			//
		}
		else if ( newMusicLevel == eMusicLevel.Combat )
		{
			StartPlayingMusic( GetNextShuffledTrackFor( eMusicTrack.GeneralCombat ) )
		}
		else if ( newMusicLevel == eMusicLevel.GameOver )
		{
			StartPlayingMusic( GetNextShuffledTrackFor( eMusicTrack.GeneralTeamWipe ) )
		}
		else if ( newMusicLevel == eMusicLevel.WaitingForPlayers )
		{
			StartPlayingMusic( GetNextShuffledTrackFor( eMusicTrack.GeneralWaitingForPlayers ) )
		}
		else if ( newMusicLevel == eMusicLevel.Ambient )
		{
			if ( s_musicLevel == eMusicLevel.Combat )
				StartPlayingMusic( GetNextShuffledTrackFor( eMusicTrack.GeneralCombatOver ) )
		}

		s_musicLevel = newMusicLevel
	}

	if ( s_zoneStingerRequested && (s_musicLevel == eMusicLevel.Ambient || s_musicLevel == eMusicLevel.None) )
	{
		float timeSinceRequest = (Time() - s_zoneStingerRequestedTime)
		if ( timeSinceRequest < 10.0 )
		{
			StartPlayingMusic( "music_skyway_17_slonedies" )
		}

		s_zoneStingerRequested = false
	}
}

bool s_isRunning = false
bool s_inFrame = false
bool s_inLoopWaitFrame = false
float s_startTime = -999.0
float s_lastFrameTime = 0
void function ClientMusicFrameThread()
{
	Assert( !s_isRunning )
	s_isRunning = true
	s_startTime = Time()

	while ( true )
	{
#if DEV
		float preFrameTime = Time()
#endif // DEV

		s_inFrame = true
		s_lastFrameTime = Time()
		ClientMusicFRAME()
		s_inFrame = false

#if DEV
		float postFrameTime = Time()
		Assert( preFrameTime == postFrameTime, format( "ClientMusicFRAME() stalled for %.2f seconds. Should have no waits.", (postFrameTime - preFrameTime) ) )
#endif // DEV

		s_inLoopWaitFrame = true
		WaitFrame()
		s_inLoopWaitFrame = false
	}
}

#if DEV
void function ClientMusic_PrintStatus()
{
	printf( "running: %s, mid-frame: %s, in-waitframe: %s, startTime: %.2f, lastFrameTime: %.2f, timeNow: %.2f", (s_isRunning ? "yes" : "no"), (s_inFrame ? "yes" : "no"), (s_inLoopWaitFrame ? "yes" : "no"), s_startTime, s_lastFrameTime, Time() )
	printf( "status: %s", GetClientMusicStatusLine() )
}
#endif // #if DEV

string function GetDebugNameForMusicLevel( int musicLevel )
{
	foreach( string key, int val in eMusicLevel )
	{
		if ( val == musicLevel )
			return key
	}
	return ""
}

string function GetDebugNameForMusicTrack( int musicTrack )
{
	foreach( string key, int val in eMusicTrack )
	{
		if ( val == musicTrack )
			return key
	}
	return ""
}

#if DEV
string function GetClientMusicStatusLine()
{
	//	 = musicTrack
	return format( "'%s',   latest - %s::'%s'", GetDebugNameForMusicLevel( s_musicLevel ), GetDebugNameForMusicTrack( s_lastPlayedMuscTrackDEBUG ), s_lastPlayedAliasDEBUG )
}
#endif // #if DEV
#endif // CLIENT

const string FUNCNAME_CLIENTMUSICDISABLE = "ClientMusic_DisableForClient"
const string FUNCNAME_CLIENTMUSICENABLE = "ClientMusic_EnableForClient"
const string FUNCNAME_PLAYCUSTOMTRACKONCLIENT = "ClientMusic_PlayCustomTrackOnClient"
const string FUNCNAME_STOPCUSTOMTRACKONCLIENT = "ClientMusic_StopCustomTrackOnClient"
void function ClientMusic_RegisterNetworking()
{
	Remote_RegisterClientFunction( FUNCNAME_CLIENTMUSICDISABLE, "entity" )
	Remote_RegisterClientFunction( FUNCNAME_CLIENTMUSICENABLE, "entity" )
	Remote_RegisterClientFunction( FUNCNAME_PLAYCUSTOMTRACKONCLIENT, "entity", "int", -1, eMusicTrack._count )
	Remote_RegisterClientFunction( FUNCNAME_STOPCUSTOMTRACKONCLIENT, "entity" )
}

void function ClientMusic_DisableForClient( entity player )
{
#if SERVER
	Remote_CallFunction_NonReplay( player, FUNCNAME_CLIENTMUSICDISABLE, player )
#else
	s_musicSystemIsDisabled = true
#endif
}

void function ClientMusic_EnableForClient( entity player )
{
#if SERVER
	Remote_CallFunction_NonReplay( player, FUNCNAME_CLIENTMUSICENABLE, player )
#else
	s_musicSystemIsDisabled = false
#endif
}

void function ClientMusic_PlayCustomTrackOnClient( entity player, int musicTrack )
{
	Assert( (musicTrack >= 0) && (musicTrack < eMusicTrack._count) )

#if SERVER
	//printf( "%s() - sending musicTrack:%d to '%s'", FUNC_NAME(), musicTrack, string( player ) )
	Remote_CallFunction_NonReplay( player, FUNCNAME_PLAYCUSTOMTRACKONCLIENT, player, musicTrack )
#else
	printf( "%s() - recieved for musicTrack:%d", FUNC_NAME(), musicTrack )
	s_queuedCustomTrack = musicTrack
#endif
}

void function ClientMusic_StopCustomTrackOnClient( entity player )
{
#if SERVER
	Remote_CallFunction_NonReplay( player, FUNCNAME_STOPCUSTOMTRACKONCLIENT, player )
#else
	printf( "%s() - received.", FUNC_NAME() )
	StopPlayingCustomTrack()
#endif
}

void function ClientMusic_SharedInit()
{
#if SERVER
#else
	RegisterSignal( "ClientMusic_CustomTrackStop" )
	thread ClientMusicFrameThread()
#endif // CLIENT
}



#if SERVER
void function ClientMusic_PlayCustomTrackToAll( int musicTrack )
{
	array<entity> players = GetPlayerArray()
	foreach ( player in players )
		ClientMusic_PlayCustomTrackOnClient( player, musicTrack )
}

void function ClientMusic_StopCustomTrackOnAll()
{
	array<entity> players = GetPlayerArray()
	foreach ( player in players )
		ClientMusic_StopCustomTrackOnClient( player )
}
#endif // SERVER






