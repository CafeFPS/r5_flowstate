global function Cl_LobbyVM_Init

global function ServerCallback_LobbyVM_UpdateUI
global function ServerCallback_LobbyVM_SelectionUpdated
global function ServerCallback_LobbyVM_BuildClientString
global function ServerCallback_LobbyVM_StartingMatch
global function ServerCallback_ServerBrowser_JoinServer
global function ServerCallback_ServerBrowser_RefreshServers

global function UICodeCallback_UpdateServerInfo
global function UICodeCallback_KickOrBanPlayer
global function UICallback_CheckForHost
global function UICallback_StartMatch
global function UICallback_ServerBrowserJoinServer
global function UICallback_RefreshServer
global function UICallback_SetHostName

string tempstring = ""

void function Cl_LobbyVM_Init()
{
    AddClientCallback_OnResolutionChanged( OnResolutionChanged_UpdateClientUI )
}

void function OnResolutionChanged_UpdateClientUI()
{
    GetLocalClientPlayer().ClientCommand("lobby_updateclient")
}

////////////////////////////////////////////////
//
//    UI CallBacks
//
////////////////////////////////////////////////

void function UICallback_SetHostName(string name)
{
    if(GetLocalClientPlayer() == GetPlayerArray()[0])
        GetLocalClientPlayer().ClientCommand("hostname " + name)
}

void function UICallback_RefreshServer()
{
    if(GetLocalClientPlayer() == GetPlayerArray()[0])
        GetLocalClientPlayer().ClientCommand("lobby_refreshservers")
}

void function UICallback_StartMatch()
{
    if(GetLocalClientPlayer() == GetPlayerArray()[0])
        GetLocalClientPlayer().ClientCommand("lobby_startmatch")
}

void function UICallback_CheckForHost()
{
    if(GetLocalClientPlayer() == GetPlayerArray()[0])
        RunUIScript( "EnableCreateMatchUI" )
}

void function UICodeCallback_UpdateServerInfo(int type, string text)
{
    if(GetLocalClientPlayer() == GetPlayerArray()[0])
        GetLocalClientPlayer().ClientCommand("lobby_updateserversetting " + type + " " + text)
}

void function UICodeCallback_KickOrBanPlayer(int type, string player)
{
    if(GetLocalClientPlayer() != GetPlayerArray()[0])
        return
    
    switch (type)
    {
        case 0:
            GetLocalClientPlayer().ClientCommand("lobby_kick " + player)
            break;
        case 1:
            GetLocalClientPlayer().ClientCommand("lobby_ban " + player)
            break;
    }
}

void function UICallback_ServerBrowserJoinServer(int id)
{
    if(GetLocalClientPlayer() == GetPlayerArray()[0])
        GetLocalClientPlayer().ClientCommand("lobby_joinserver " + id)
}

////////////////////////////////////////////////
//
//    Server CallBacks
//
////////////////////////////////////////////////

void function ServerCallback_ServerBrowser_RefreshServers()
{
    RunUIScript( "ServerBrowser_RefreshServerListing")
}

void function ServerCallback_ServerBrowser_JoinServer(int id)
{
    RunUIScript( "ServerBrowser_JoinServer", id)
}

void function ServerCallback_LobbyVM_StartingMatch()
{
    RunUIScript( "ShowMatchStartingScreen")
}

void function ServerCallback_LobbyVM_UpdateUI()
{
    array<string> playernames

    RunUIScript( "ClearPlayerUIArray" )

    foreach( player in GetPlayerArray() )
    {
        if(!IsValid(player))
            continue

        string playername = player.GetPlayerName()

        if(GetPlayerArray()[0] == player)
        {
            playername = "[Host] " + player.GetPlayerName()
        }

        RunUIScript( "AddPlayerToUIArray", playername )
    }

    RunUIScript( "UpdateHostName", GetPlayerArray()[0].GetPlayerName() )

    RunUIScript( "UpdatePlayersList" )

    RunUIScript( "ServerBrowser_EnableRefreshButton", GetPlayerArray()[0] == GetLocalClientPlayer() )

    RunUIScript( "InPlayersLobby" , GetPlayerArray()[0] != GetLocalClientPlayer() && GetPlayerArray().len() > 1, GetPlayerArray()[0].GetPlayerName())
}

void function ServerCallback_LobbyVM_SelectionUpdated(int type)
{
    RunUIScript("UI_SetServerInfo", type, tempstring)
    tempstring = ""
}

void function ServerCallback_LobbyVM_BuildClientString( ... )
{
	for ( int i = 0; i < vargc; i++ )
		tempstring += format("%c", vargv[i] )
}