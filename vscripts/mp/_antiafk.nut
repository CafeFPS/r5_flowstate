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

	if ( !IsValid(player) || IsAdmin(player) || !GetCurrentPlaylistVarBool( "flowstate_afk_kick_enable", true ) || !GetCurrentPlaylistVarBool("enable_afk_thread", true) )
		return

	AfkThread_AddPlayerCallbacks( player ) //readded mkos
	//player.SetSendInputCallbacks( true ) //disabled internal call
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
	if ( bAfkToRest() )
	{	
		Message( player, "Are you there?", "\n Sending to rest if you don't move in the next " + GetCurrentPlaylistVarFloat( "Flowstate_antiafk_warn", 15.0 ) + " seconds." )		
	} 
	else
	{
		Message( player, "AFK WARNING", "\n You're afk, server will kick you if you don't move in the next " + GetCurrentPlaylistVarFloat( "Flowstate_antiafk_warn", 15.0 ) + " seconds." )
	}
}

void function CheckAfkKickThread(entity player)
{	
	//printt("Flowstate - AFK thread initialized for " + player.GetPlayerName() )	
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
			
		if (!bAfkToRest())
			continue
		
		//another mkos mod
		if ( Flowstate_IsFS1v1() && isPlayerInRestingList( player ) && FlowState_RestMsg() )
		{	
			if ( player.p.messagetime == 0 || Time() >= player.p.messagetime + 30 )
			{	
				Message(player, "\n\n\n\n\n\n You are Resting", LineBreak("Type 'rest' in console to exit rest or press panel button to resume 1v1s \n\n Type 'wait' in console for info about your IBMM queue times \n\n Type 'show player #' in console replacing # with player's name/id for info about that player.",50), 30, "")
				player.p.messagetime = Time()
			}
			
			continue
		}
		
		switch ( GetAfkState( player ) )
		{	
			
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
				} 
				else 
				{	
					KickPlayerById( player.GetPlatformUID(), "You were AFK for too long" )		
				}
				break
		}
		
		wait 1
		
    }
}

bool function AfkThread_PlayerMoved( entity player )
{
	if(!IsValid(player))
		return false
	
    player.p.lastmoved = Time()
	return true
}

void function AfkThread_AddPlayerCallbacks( entity player )
{	
	
	AddPlayerPressedForwardCallback( player, AfkThread_PlayerMoved )
	AddPlayerPressedBackCallback( player, AfkThread_PlayerMoved )
	AddPlayerPressedLeftCallback( player, AfkThread_PlayerMoved )
	AddPlayerPressedRightCallback( player, AfkThread_PlayerMoved )
	
	
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