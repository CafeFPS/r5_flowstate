untyped
global function AntiAfkInit

enum eAntiAfkPlayerState
{
	ACTIVE
	SUSPICIOUS
    AFK
}

struct {
    table<entity, float> lastmoved = {}
} file

void function AntiAfkInit() {
    if ( GetCurrentPlaylistVarBool( "Flowstate_antiafk_Enabled", true )) {
        AddCallback_GameStateEnter( eGameState.Playing, Playing )
    }
}

// possibly todo: add convar/playlistvar for non-admin players to avoid afk kicks
bool function IsImmuneAfkKick( entity player ){
    if( !IsValid(player) ) return false
    return IsAdmin(player)
}

void function Playing(){
    AddCallback_OnClientConnected( AddPlayerCallbacks )
    AddCallback_OnClientDisconnected( DeletePlayerRecords )
    // What exactly is respawning? kill_self doesn't trigger this callback?
    // AddCallback_OnPlayerRespawned( Moved )

    foreach (entity player in GetPlayerArray()){
        AddPlayerCallbacks( player )
		Moved( player )
    }

    thread CheckAfkKickThread()
}

int function GetAfkState( entity player ){
    float localgrace = GetCurrentPlaylistVarFloat( "Flowstate_antiafk_grace", 180.0 )
    float warn = GetCurrentPlaylistVarFloat( "Flowstate_antiafk_warn", 120.0 )

    // different grace when dead
    if ( !IsAlive( player ) ){
        localgrace = GetCurrentPlaylistVarFloat( "Flowstate_antiafk_gracedead", 380.0 )
    }

    if ( player in file.lastmoved ){
        float lastmove = file.lastmoved[ player ]
        if (Time() > lastmove + ( localgrace - warn )){

            if ( Time() > lastmove + localgrace ){
                return eAntiAfkPlayerState.AFK
            }

            return eAntiAfkPlayerState.SUSPICIOUS
        }
    }
    return eAntiAfkPlayerState.ACTIVE
}

void function AfkWarning( entity player ){
        Message( player, "AFK WARNING", "\n You are AFK. You will be kicked unless you begin playing." )
}

void function CheckAfkKickThread(){
    while (true){
        if ( GetGameState() == eGameState.Playing ){
            foreach (entity player in GetPlayerArray()){

                // guard player missing
                if ( !player.IsPlayer() ){
                    DeletePlayerRecords( player )
                    return
                }

                if (IsImmuneAfkKick( player )){ 
                    return
                }

                int afkstate = GetAfkState( player )

                switch ( afkstate ){

                    case eAntiAfkPlayerState.SUSPICIOUS:
                        AfkWarning( player )
                        break

                    case eAntiAfkPlayerState.AFK:
					    ClientCommand( player, "disconnect" )
                        break
                }
            }
        }
        wait GetCurrentPlaylistVarFloat( "Flowstate_antiafk_interval", 5.0 )
    }
}

void function Moved( entity player ){
    file.lastmoved[ player ] <- Time()
}


void function AddPlayerCallbacks( entity player ){
	AddButtonPressedPlayerInputCallback( player, IN_ATTACK, Moved )
	AddButtonPressedPlayerInputCallback( player, IN_JUMP, Moved )
	AddButtonPressedPlayerInputCallback( player, IN_DUCK, Moved )
	AddButtonPressedPlayerInputCallback( player, IN_FORWARD, Moved )
	AddButtonPressedPlayerInputCallback( player, IN_BACK, Moved )
	AddButtonPressedPlayerInputCallback( player, IN_USE, Moved )

	// wtf is the difference between moveleft/left + moveright/right? Does this work with controller?
	AddButtonPressedPlayerInputCallback( player, IN_LEFT, Moved )
	AddButtonPressedPlayerInputCallback( player, IN_RIGHT, Moved )
	AddButtonPressedPlayerInputCallback( player, IN_MOVELEFT, Moved )
	AddButtonPressedPlayerInputCallback( player, IN_MOVERIGHT, Moved )
    Moved( player )
}

void function DeletePlayerRecords( entity player ){
    if ( player in file.lastmoved ){
        delete file.lastmoved[ player ]
    }
}