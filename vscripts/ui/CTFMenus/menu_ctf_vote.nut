global function InitCTFVoteMenu
global function OpenCTFVoteMenu
global function CloseCTFVoteMenu
global function UpdateVoteTimer
global function UpdateVotesUI
global function UpdateMapsForVoting
global function UpdateVotedFor
global function UpdateVotedLocation
global function SetCTFVoteMenuNextRound
global function SetCTFVotingScreen
global function SetCTFTeamWonScreen
global function UpdateVotedLocationTied

struct
{
	var menu
} file

//Opens vote menu
void function OpenCTFVoteMenu()
{
	CloseAllMenus()
	AdvanceMenu( file.menu )
}

//Sets and updates the team won screen
void function SetCTFTeamWonScreen(string teamwon)
{
	SetVoteHudElems(false, false, false, false, false, false, false, true, true)

	Hud_SetText( Hud_GetChild( file.menu, "VotedForLbl" ), teamwon)

}

//Sets and updates the voting screen
void function SetCTFVotingScreen()
{
	SetVoteHudElems(true, true, true, true, true, true, true, false, false)

	for(int i = 1; i < 5; i++ ) {
		Hud_SetEnabled( Hud_GetChild( file.menu, "MapVote" + i ), true )
		RuiSetInt( Hud_GetRui( Hud_GetChild( file.menu, "MapVote" + i )), "status", eFriendStatus.ONLINE_INGAME )
		RuiSetString( Hud_GetRui( Hud_GetChild( file.menu, "MapVote" + i )), "statusText", "Votes: 0")
		RuiSetString( Hud_GetRui( Hud_GetChild( file.menu, "MapVote" + i )), "presenseText", "" )
	}
}

//Sets and updates the next round screen
void function SetCTFVoteMenuNextRound()
{
	SetVoteHudElems(false, false, false, false, false, false, false, true, true)

	Hud_SetText( Hud_GetChild( file.menu, "VotedForLbl" ), "Starting Next Round!")
}

//Update current maps up for vote
void function UpdateMapsForVoting(string map1, string map2, string map3, string map4)
{
	RuiSetString( Hud_GetRui( Hud_GetChild( file.menu, "MapVote1" )), "buttonText", "" + map1 )
	RuiSetString( Hud_GetRui( Hud_GetChild( file.menu, "MapVote2" )), "buttonText", "" + map2 )
	RuiSetString( Hud_GetRui( Hud_GetChild( file.menu, "MapVote3" )), "buttonText", "" + map3 )
	RuiSetString( Hud_GetRui( Hud_GetChild( file.menu, "MapVote4" )), "buttonText", "" + map4 )
}

//Closes the vote menu
void function CloseCTFVoteMenu()
{
	CloseAllMenus()
}

//Update vote time left
void function UpdateVoteTimer(int timeleft)
{
	Hud_SetText(Hud_GetChild( file.menu, "TimerText" ), timeleft.tostring())
}

//Update current votes for each map
void function UpdateVotesUI(int map1, int map2, int map3, int map4)
{
	RuiSetString( Hud_GetRui( Hud_GetChild( file.menu, "MapVote1" )), "statusText", "Votes: " + map1 )
	RuiSetString( Hud_GetRui( Hud_GetChild( file.menu, "MapVote2" )), "statusText", "Votes: " + map2 )
	RuiSetString( Hud_GetRui( Hud_GetChild( file.menu, "MapVote3" )), "statusText", "Votes: " + map3 )
	RuiSetString( Hud_GetRui( Hud_GetChild( file.menu, "MapVote4" )), "statusText", "Votes: " + map4 )
}

//Lock Buttons and update the map player voted for
void function UpdateVotedFor(int id)
{
	for(int i = 1; i < 5; i++ ) {
		RuiSetInt( Hud_GetRui( Hud_GetChild( file.menu, "MapVote" + i )), "status", eFriendStatus.OFFLINE )
		Hud_SetEnabled( Hud_GetChild( file.menu, "MapVote" + i ), false )
	}

	var rui = Hud_GetRui( Hud_GetChild( file.menu, "MapVote" + id ))
	RuiSetString( rui, "presenseText", "Voted!" )
	RuiSetInt( rui, "status", eFriendStatus.ONLINE_AWAY )
}

//Sets and updates selected location
void function UpdateVotedLocation(string map)
{
	SetVoteHudElems(false, false, false, false, false, false, false, true, true)

	Hud_SetText( Hud_GetChild( file.menu, "VotedForLbl" ), "Next Location: " + map)
}

//Sets and updates tied voting screen
void function UpdateVotedLocationTied(string map)
{
	SetVoteHudElems(false, true, true, true, false, false, false, true, true)

	Hud_SetText( Hud_GetChild( file.menu, "TimerText" ), "Picking a random location from tied locations")
	Hud_SetText( Hud_GetChild( file.menu, "TimerText2" ), "Votes Tied!")
	Hud_SetText( Hud_GetChild( file.menu, "VotedForLbl" ), map)
}

//Inits vote menu
void function InitCTFVoteMenu( var newMenuArg )
{
	var menu = GetMenu( "CTFVoteMenu" )
	file.menu = menu

	AddMenuEventHandler( menu, eUIEvent.MENU_NAVIGATE_BACK, OnCTF_NavigateBack )

	AddButtonEventHandler( Hud_GetChild( menu, "MapVote1" ), UIE_CLICK, OnClickMap )
	AddButtonEventHandler( Hud_GetChild( menu, "MapVote2" ), UIE_CLICK, OnClickMap )
	AddButtonEventHandler( Hud_GetChild( menu, "MapVote3" ), UIE_CLICK, OnClickMap )
	AddButtonEventHandler( Hud_GetChild( menu, "MapVote4" ), UIE_CLICK, OnClickMap )
}

void function SetVoteHudElems(bool MapVote, bool TimerFrame, bool TimerText2, bool TimerText, bool MapVoteFrame, bool CTFBottomFrame, bool ObjectiveText, bool MapVoteFrame2, bool VotedForLbl)
{
	for(int i = 1; i < 5; i++ ) {
		Hud_SetVisible( Hud_GetChild( file.menu, "MapVote" + i ), MapVote )
	}

	Hud_SetVisible(Hud_GetChild( file.menu, "TimerFrame"), TimerFrame)
	Hud_SetVisible(Hud_GetChild( file.menu, "TimerText2"), TimerText2)
	Hud_SetVisible(Hud_GetChild( file.menu, "TimerText" ), TimerText)

	Hud_SetVisible( Hud_GetChild( file.menu, "MapVoteFrame" ), MapVoteFrame )
	Hud_SetVisible( Hud_GetChild( file.menu, "CTFBottomFrame" ), CTFBottomFrame )
	Hud_SetVisible( Hud_GetChild( file.menu, "ObjectiveText" ), ObjectiveText )

	Hud_SetVisible( Hud_GetChild( file.menu, "MapVoteFrame2" ), MapVoteFrame2 )
	Hud_SetVisible( Hud_GetChild( file.menu, "VotedForLbl" ), VotedForLbl )
}

//Button event handlers
void function OnClickMap( var button )
{
	int buttonId = Hud_GetScriptID( button ).tointeger()
	RunClientScript("UI_To_Client_VoteForMap", buttonId )
}

void function OnCTF_NavigateBack()
{
	// gotta have NavigateBack blank so that you cant close the menu
}