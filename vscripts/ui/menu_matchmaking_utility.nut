global function LeaveMatch
#if(false)

#endif
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
	//
	//
	//
	#if(DURANGO_PROG)
		Durango_LeaveParty()
	#endif //

	CancelMatchmaking()
	ClientCommand( "LeaveMatch" )
}

#if(false)




//







#endif

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
