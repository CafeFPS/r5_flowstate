global function Flowstate_InitAFKThreadForPlayer
global function AfkThread_PlayerMoved

enum eAntiAfkPlayerState
{
	ACTIVE
	SUSPICIOUS
	AFK
}

void function Flowstate_InitAFKThreadForPlayer(entity player)
{
	#if DEVELOPER
	return
	#endif

	if ( !IsValid(player) || IsAdmin(player) || !GetCurrentPlaylistVarBool( "flowstate_afk_kick_enable", true ) )
		return

	//AfkThread_AddPlayerCallbacks( player )
	player.SetSendInputCallbacks( true )
	AfkThread_PlayerMoved( player )
	thread CheckAfkKickThread(player)
}

int function GetAfkState( entity player )
{
    float localgrace = GetCurrentPlaylistVarFloat( "Flowstate_antiafk_grace", 120 )
    float warn = GetCurrentPlaylistVarFloat( "Flowstate_antiafk_warn", 15.0 )

	float lastmove = player.p.lastmoved
	if ( Time() > lastmove + ( localgrace - warn ) )
	{
		if ( Time() > lastmove + localgrace ){
			return eAntiAfkPlayerState.AFK
		}

		return eAntiAfkPlayerState.SUSPICIOUS
	}

    return eAntiAfkPlayerState.ACTIVE
}

//lg_duel mkos modified
void function AfkWarning( entity player )
{	
	if ( GetCurrentPlaylistVarBool( "afk_to_rest_bool", false )){
		
		Message( player, "Are you there?", "\n Sending to rest if you don't move in the next " + GetCurrentPlaylistVarFloat( "Flowstate_antiafk_warn", 15.0 ) + " seconds." )
		
	} else {
		Message( player, "AFK WARNING", "\n You're afk, server will kick you if you don't move in the next " + GetCurrentPlaylistVarFloat( "Flowstate_antiafk_warn", 15.0 ) + " seconds." )
	}
}

void function CheckAfkKickThread(entity player)
{	


	printt("Flowstate - AFK thread initialized for " + player.GetPlayerName() )
	
	while( true )
	{
		wait GetCurrentPlaylistVarFloat( "Flowstate_antiafk_interval", 10.0 )
		
		if( !IsValid(player) )
			break
		
        if ( GetGameState() != eGameState.Playing )
			continue
		
		if ( !IsAlive(player) )
			continue
		
		if ( player.p.isSpectating )
			continue
			
		if (!afk_to_rest_enabled)
			continue
		
		//another mkos mod
		if ( GetCurrentPlaylistName() == "fs_1v1" && isPlayerInRestingList( player ) && GetCurrentPlaylistVarBool( "rest_msg", false) )
		{	
			if ( player.p.messagetime == 0 || Time() >= player.p.messagetime + 25 )
			{	
				Message(player, "\n\n\n\n\n\n You are Resting", "Type 'rest' in console to exit rest \n or press panel button to resume 1v1s \n\n\n\n  Type 'wait' in console for info \n about your IBMM queue times \n\n\n\n Type 'show input' in console for a list \n of players and their current inputs \n\n\n\n Type 'show stats' in console for a list \n of players and their current stats", 25, "")
				player.p.messagetime = Time()
			}
			
			continue
		}
		
		switch ( GetAfkState( player ) )
		{	
			
			case eAntiAfkPlayerState.SUSPICIOUS:
				AfkWarning( player )
				break
			
			//mkos modificaiton, afk_to_rest
			case eAntiAfkPlayerState.AFK:
				if ( GetCurrentPlaylistVarBool( "afk_to_rest_bool", false )){
				
					player.p.lastmoved = Time()
					mkos_Force_Rest( player, [] )
					
				} else {
				
					KickPlayerById( player.GetPlatformUID(), "You were AFK for too long" )
					
				}
				break
		}
		
		wait 1
		
    }
}

void function AfkThread_PlayerMoved( entity player )
{
    player.p.lastmoved = Time()
}

void function AfkThread_AddPlayerCallbacks( entity player )
{	
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