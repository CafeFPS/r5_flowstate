global function Flowstate_Afk_Init
global function Flowstate_InitAFKThreadForPlayer
global function AfkThread_PlayerMoved

struct 
{
	float Flowstate_antiafk_warn
	float Flowstate_antiafk_grace
	float Flowstate_antiafk_interval
	
	bool flowstate_afk_kick_enable
	bool enable_afk_thread
	
} file

enum eAntiAfkPlayerState
{
	ACTIVE
	SUSPICIOUS
	AFK
}

void function Flowstate_Afk_Init()
{
	file.Flowstate_antiafk_warn 	= GetCurrentPlaylistVarFloat( "Flowstate_antiafk_warn", 15.0 )
	file.Flowstate_antiafk_grace 	= GetCurrentPlaylistVarFloat( "Flowstate_antiafk_grace", 120 )
	file.Flowstate_antiafk_interval = GetCurrentPlaylistVarFloat( "Flowstate_antiafk_interval", 10.0 )
	file.flowstate_afk_kick_enable 	= GetCurrentPlaylistVarBool( "flowstate_afk_kick_enable", true )
	file.enable_afk_thread 			= GetCurrentPlaylistVarBool( "enable_afk_thread", true )
}

void function Flowstate_InitAFKThreadForPlayer( entity player )
{
	#if DEVELOPER
		//return
	#endif

	if
	( 
		!IsValid( player ) || 
		 IsAdmin( player ) || 
		 !file.flowstate_afk_kick_enable || 
		 !file.enable_afk_thread 
	)
	return

	AfkThread_AddPlayerCallbacks( player ) //readded mkos
	//player.SetSendInputCallbacks( true ) //disabled internal call
	AfkThread_PlayerMoved( player )
	thread CheckAfkKickThread(player)
}

int function GetAfkState( entity player )
{
    float localgrace = file.Flowstate_antiafk_grace
    float warn = file.Flowstate_antiafk_warn

	float lastmove = player.p.lastmoved
	
	if( bAfkToRest() && !isPlayerInRestingList( player ) )
	{
		if ( Time() > lastmove + ( localgrace - warn ) )
		{
			if ( Time() > lastmove + localgrace )
				return eAntiAfkPlayerState.AFK

			return eAntiAfkPlayerState.SUSPICIOUS
		}
	}

    return eAntiAfkPlayerState.ACTIVE
}

void function AfkWarning( entity player )
{	
	if ( bAfkToRest() )
	{	
		LocalMsg( player, "#FS_AFK_ALERT", "#FS_AFK_REST_MSG", eMsgUI.DEFAULT, 10, "", string( file.Flowstate_antiafk_warn ) )		
	} 
	else
	{
		LocalMsg( player, "#FS_AFK_ALERT", "#FS_AFK_KICK_MSG", eMsgUI.DEFAULT, 10, "", string( file.Flowstate_antiafk_warn ) )
	}
}

void function CheckAfkKickThread(entity player)
{	
	//printt("Flowstate - AFK thread initialized for " + player.GetPlayerName() )	
	while( true )
	{
		wait file.Flowstate_antiafk_interval
		
		if( !IsValid( player ) )
			break
		
        if ( GetGameState() != eGameState.Playing )
			continue
		
		if ( !IsAlive( player ) )
			continue
		
		if ( player.p.isSpectating )
			continue
			
		if ( g_bRestEnabled() && IsCurrentState( player, e1v1State.RESTING ) )
			continue
		
		switch ( GetAfkState( player ) )
		{
			case eAntiAfkPlayerState.ACTIVE:
				break
		
			case eAntiAfkPlayerState.SUSPICIOUS:
				AfkWarning( player )
				break
			
			//mkos modificaiton, afk_to_rest = bAfkToRest()
			case eAntiAfkPlayerState.AFK:
				if ( bAfkToRest() )
				{		
					player.p.lastmoved = Time()
					
					if( g_bRestEnabled() )
						mkos_Force_Rest( player )
					else 
						mAssert( false, "Playlist has afk_to_rest enabled, but mode has rest disabled internally. Try using Gamemode1v1_SetRestEnabled()" )
						// We WANT to assert here, because this condition will always run with no effect. 
				}
				else 
				{	
					KickPlayerById( player.GetPlatformUID(), "You were AFK for too long" )		
				}
				break
				
			default:
				mAssert( false, "No valid afk rest state returned" )
				//Scripter issue.
				break
		}
		
		wait 1
		
    }
}

bool function AfkThread_PlayerMoved( entity player ) //callback is defined as bool return func...
{
	// if( !IsValid( player ) ) //is this needed? lets find out.
		// return false
	
    player.p.lastmoved = Time()
	return true
}

void function AfkThread_AddPlayerCallbacks( entity player )
{
	AddPlayerPressedForwardCallback( player, AfkThread_PlayerMoved, 1 )
	AddPlayerPressedBackCallback( player, AfkThread_PlayerMoved, 1 )
	AddPlayerPressedLeftCallback( player, AfkThread_PlayerMoved, 1 )
	AddPlayerPressedRightCallback( player, AfkThread_PlayerMoved, 1 )
	
	
	//disabled and reworked to above (fixed callback move inputs) -- mkos
	
	/*
	AddButtonPressedPlayerInputCallback( player, IN_ATTACK, AfkThread_PlayerMoved )
	AddButtonPressedPlayerInputCallback( player, IN_JUMP, AfkThread_PlayerMoved )
	AddButtonPressedPlayerInputCallback( player, IN_FORWARD, AfkThread_PlayerMoved )
	AddButtonPressedPlayerInputCallback( player, IN_BACK, AfkThread_PlayerMoved )
	AddButtonPressedPlayerInputCallback( player, IN_USE, AfkThread_PlayerMoved )
	AddButtonPressedPlayerInputCallback( player, IN_MOVELEFT, AfkThread_PlayerMoved )
	AddButtonPressedPlayerInputCallback( player, IN_MOVERIGHT, AfkThread_PlayerMoved )
	AddButtonPressedPlayerInputCallback( player, IN_LEFT, AfkThread_PlayerMoved )
	AddButtonPressedPlayerInputCallback( player, IN_RIGHT, AfkThread_PlayerMoved )
	*/
}