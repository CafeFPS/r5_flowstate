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

	// Disconnect and load the lobby in a thread
	thread LoadLobbyAfterLeave()
}

void function LoadLobbyAfterLeave()
{
	#if LISTEN_SERVER
	// Wait a second for a smoother transition
	wait 1

	// Only execute these if we aren't running the listen server
	if ( !IsServerActive() )
	{
		CancelMatchmaking()
		ClientCommand( "disconnect" ) // also disconnect on client
		ClientCommand( "LeaveMatch" )
	}
	else
	{
		// Shutdown and wait a frame so the state machine could shut the
		// server down properly, else we crash in CClient::SendSnapshot.
		DestroyServer()
		WaitFrame()
	}

	// Set the main menus blackscreen visibility to true to cover it
	SetMainMenuBlackScreenVisible(true)

	// Create the lobby server
	CreateServer("Lobby VM", "", "mp_lobby", "menufall", eServerVisibility.OFFLINE)
	#else

	// !TODO: attempt to connect to a lobby dedi from here???

	#endif // LISTEN_SERVER
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
