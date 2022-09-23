global function _LobbyVM_Init

array<entity> playerarray

array<string> PrivateMatchSettings = ["A R5Reloaded Server", "mp_rr_canyonlands_mu1", "custom_tdm", "2"]

void function _LobbyVM_Init()
{
    AddCallback_OnClientConnected( void function(entity player) { thread _OnPlayerConnected(player) } )

    AddClientCommandCallback("lobby_updateserversetting", ClientCommand_ChangedServerSetting)
    AddClientCommandCallback("lobby_updateclient", ClientCommand_UpdateClient)
    AddClientCommandCallback("lobby_kick", ClientCommand_KickPlayer)
    AddClientCommandCallback("lobby_ban", ClientCommand_BanPlayer)
    AddClientCommandCallback("lobby_startmatch", ClientCommand_StartMatch)
    AddClientCommandCallback("lobby_joinserver", ClientCommand_JoinServer)
    AddClientCommandCallback("lobby_refreshservers", ClientCommand_ResfreshServers)

    thread PlayerCheck()
}

/////////////////////////////////////////////
//                                         //
//             Client Commands             //
//                                         //
/////////////////////////////////////////////

bool function ClientCommand_ResfreshServers(entity player, array<string> args)
{
    if( !IsValid( player ) )
        return false

    if( GetPlayerArray()[0] != player)
        return false

    foreach( p in GetPlayerArray() ) {
        Remote_CallFunction_Replay( p, "ServerCallback_ServerBrowser_RefreshServers" )
    }

    return true
}

bool function ClientCommand_JoinServer(entity player, array<string> args)
{
    if( !IsValid( player ) )
        return false

    if( GetPlayerArray()[0] != player)
        return false

    if(args.len() < 1)
        return false

    foreach( p in GetPlayerArray() ) {
        if(p != player)
            Remote_CallFunction_Replay( p, "ServerCallback_ServerBrowser_JoinServer", args[0].tointeger() )
    }

    //Host joins last otherwise the vm will get shut down before everyone can join
    Remote_CallFunction_Replay( player, "ServerCallback_ServerBrowser_JoinServer", args[0].tointeger() )

    return true
}

bool function ClientCommand_StartMatch(entity player, array<string> args)
{
    if( !IsValid( player ) )
        return false

    if( GetPlayerArray()[0] != player)
        return false

    foreach( p in GetPlayerArray() ) {
        if( !IsValid( p ) )
            continue

        SetTeam(p, TEAM_SPECTATOR)
        Remote_CallFunction_Replay( p, "ServerCallback_LobbyVM_StartingMatch" )
    }

    return true
}

bool function ClientCommand_KickPlayer(entity player, array<string> args)
{
    if( !IsValid( player ) )
        return false

    if( GetPlayerArray()[0] != player)
        return false

    if(args.len() < 1)
        return false

    if(args[0] == ("[Host]"))
        return false

    string playertokick
    foreach(int i, arg in args)
    {
        playertokick += arg
    }

    ServerCommand( "sv_kick \"" + playertokick + "\"" )

    return true
}

bool function ClientCommand_BanPlayer(entity player, array<string> args)
{
    if( !IsValid( player ) )
        return false

    if( GetPlayerArray()[0] != player)
        return false

    if(args.len() < 1)
        return false

    if(args[0] == ("[Host]"))
        return false

    string playertoban
    foreach(int i, arg in args)
    {
        playertoban += arg
    }

    ServerCommand( "sv_ban \"" + playertoban + "\"" )

    return true
}

bool function ClientCommand_UpdateClient(entity player, array<string> args)
{
    if( !IsValid( player ) )
        return false

    UpdateServerSettings(player)

    Remote_CallFunction_Replay( player, "ServerCallback_LobbyVM_UpdateUI" )

    return true
}

bool function ClientCommand_ChangedServerSetting(entity player, array<string> args)
{
    if( !IsValid( player ) )
        return false

    if( GetPlayerArray()[0] != player)
        return false

    if(args.len() < 2)
        return false

    int type = args[0].tointeger()
    string text

    if(type == 0) {
        foreach(int i, arg in args) {
            if(i == 0)
                continue

            if(i == 1)
                text += arg
            else
                text += " " + arg
        }
    }
    else
        text = args[1]

    switch( type ) {
        case 0: //Name
            PrivateMatchSettings[0] = text;
            break;
        case 1: //Map
            PrivateMatchSettings[1] = text;
            break;
        case 2: //Playlist
            PrivateMatchSettings[2] = text;
            break;
        case 3: //Vis
            PrivateMatchSettings[3] = text;
            break;
    }

    //Update all players
    foreach( p in GetPlayerArray() ) {
        if( !IsValid( p ) )
            continue

        UpdateServerSettings(p)
    }

    return true
}

/////////////////////////////////////////////
//                                         //
//            General Functions            //
//                                         //
/////////////////////////////////////////////

void function PlayerCheck()
{
    //Kind of a hack way to check players, but onclientdisconnect was unreliable
    bool hasclientdisconnected = false
    while(true)
    {
        //Check to see if any player in the last array saved has become invalid
        foreach( p in playerarray ) {
            if( !IsValid( p ) ) {
                //if so set bool to true and update player array
                hasclientdisconnected = true
                playerarray = GetPlayerArray()
            }
        }

        //Player/Players have become invalid, update everyones UI
        if(hasclientdisconnected) {
            foreach( p in playerarray ) {
            if( IsValid( p ) )
                Remote_CallFunction_Replay( p, "ServerCallback_LobbyVM_UpdateUI" )
            }

            hasclientdisconnected = false
        }

        wait 1;
    }
}

void function UpdateServerSettings(entity player)
{
    foreach(int type, string text in PrivateMatchSettings)
    {
        for ( int i = 0; i < text.len(); i++ ) {
            Remote_CallFunction_NonReplay( player, "ServerCallback_LobbyVM_BuildClientString", text[i] )
        }
        Remote_CallFunction_NonReplay( player, "ServerCallback_LobbyVM_SelectionUpdated", type )
    }
}

void function _OnPlayerConnected(entity player)
{
    //Get current server settings and update players ui
    UpdateServerSettings(player)

    GameRules_EnableGlobalChat(true)

    SetTeam(player, TEAM_IMC)

    //Grab the latest player array
    playerarray = GetPlayerArray()

    //Update each players ui
    foreach( p in playerarray )
    {
        if( !IsValid( p ) )
            continue

        Remote_CallFunction_Replay( p, "ServerCallback_LobbyVM_UpdateUI" )
        Remote_CallFunction_Replay( p, "ServerCallback_ServerBrowser_RefreshServers" )
    }
}