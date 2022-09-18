global function LeaveMatch
global function LeaveParty
global function LeaveMatchAndParty

global function IsSendOpenInviteTrue
global function SendOpenInvite

struct
{
	bool sendOpenInvite = false
} file

void function LeaveMatch()
{
	// IMPORTANT: It's very important to always leave the party view if you back out
	// otherwise you risk trashing the party view for remaining players and pointing
	// it back to your private lobby.
#if DURANGO_PROG
	Durango_LeaveParty()
#endif // #if DURANGO_PROG

	CancelMatchmaking()
	ClientCommand( "LeaveMatch" )

	//load new lobbyvm
	//ty amos for the idea of loading it on leave match
	thread LoadLobbyAfterLeave()
}

void function LoadLobbyAfterLeave()
{
	//Set the main menus blackscreen visibility to true
	SetMainMenuBlackScreenVisible(true)

	//Just incase the player leaving is the host of the game, we wana make sure the hostgame is shut down
	ShutdownHostGame()

	//wait until fully disconnected
	while(!g_isAtMainMenu) {
		WaitFrame()
	}

	//Create lobby server
	CreateServer("Lobby VM", "", "mp_lobby", "menufall", eServerVisibility.OFFLINE)

	//Refresh Server Browser
	ServerBrowser_RefreshServerListing()

	//No longer at main menu
	g_isAtMainMenu = false
}

void function LeaveParty()
{
	ClientCommand( "party_leave" )
	Signal( uiGlobal.signalDummy, "LeaveParty" )
}

void function LeaveMatchAndParty()
{
	LeaveParty()
	LeaveMatchWithDialog()
}

void function SendOpenInvite( bool state )
{
	file.sendOpenInvite = state
}

bool function IsSendOpenInviteTrue()
{
	return file.sendOpenInvite
}
