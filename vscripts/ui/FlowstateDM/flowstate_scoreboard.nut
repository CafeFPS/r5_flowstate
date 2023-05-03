global function Init_FSDM_VoteMenu
global function Open_FSDM_VotingPhase
global function Close_FSDM_VoteMenu

global function Set_FSDM_VoteMenuNextRound
global function Set_FSDM_VotingScreen
global function Set_FSDM_TeamWonScreen
global function Set_FSDM_ScoreboardScreen

global function UpdateVoteTimer_FSDM
global function UpdateVotesUI_FSDM
global function UpdateMapsForVoting_FSDM
global function UpdateVotedFor_FSDM
global function UpdateVotedLocation_FSDM
global function UpdateVotedLocation_FSDMTied
global function SendScoreboardToUI
global function ClearScoreboardOnUI

global struct PlayerInfo
{
	string name
	int team
	int score
	int deaths
	float kd
	int damage
	int lastLatency
}

struct
{
	var menu
	var prophuntMenu
	array<PlayerInfo> FSDM_Scoreboard
} file

//Opens vote menu
void function Open_FSDM_VotingPhase()
{
	CloseAllMenus()
	AdvanceMenu( file.menu )
	
	Hud_SetVisible(Hud_GetChild( file.menu, "TextCredits2"), true)
	Hud_SetVisible(Hud_GetChild( file.menu, "TextCredits"), true)
	
	Hud_SetVisible( Hud_GetChild( file.menu, "VotingPhaseChatBox"), false )
	Hud_SetAboveBlur( Hud_GetChild( file.menu, "VotingPhaseChatBox"), false )
	Hud_SetEnabled( Hud_GetChild( Hud_GetChild( file.menu, "VotingPhaseChatBox"), "ChatInputLine" ), false)
}

//Sets and updates the team won screen
void function Set_FSDM_TeamWonScreen(string teamwon)
{
	SetVoteHudElems(false, true, false, false, false, false, false, false, false, false, false, false)

	// Hud_SetText( Hud_GetChild( file.menu, "WinnerLbl" ), teamwon)

}

void function SendScoreboardToUI(string name, int score, int deaths, float kd, int damage, int latency)
{
	PlayerInfo p
	p.name = name
	p.score = score
	p.deaths = deaths
	p.kd = kd
	p.damage = damage
	p.lastLatency = latency
	
	file.FSDM_Scoreboard.append(p)
}

void function ClearScoreboardOnUI()
{
	file.FSDM_Scoreboard.clear()
}

int function ComparePlayerInfo(PlayerInfo a, PlayerInfo b)
{
	if(a.score < b.score) return 1;
	else if(a.score > b.score) return -1;
	return 0;
}

//Sets and updates the team won screen
void function Set_FSDM_ScoreboardScreen()
{
	thread function() : ()	
	{
		SetVoteHudElems(false, true, false, false, false, false, false, false, false, false, false, true)

		if(GetCurrentPlaylistName() == "fs_prophunt")
			Hud_SetText( Hud_GetChild( file.menu, "ScoreboardText" ), "PROPHUNT SCOREBOARD")
		
		while(file.FSDM_Scoreboard.len() == 0) //defensive fix
			WaitFrame()
		
		file.FSDM_Scoreboard.sort(ComparePlayerInfo)
		
		for( int i=0; i < file.FSDM_Scoreboard.len() && i < 10; i++ )
		{	
			Hud_SetText( Hud_GetChild( file.menu, "PlayerName" + i ), file.FSDM_Scoreboard[i].name )
			Hud_SetText( Hud_GetChild( file.menu, "Kills" + i ), file.FSDM_Scoreboard[i].score.tostring() )
			Hud_SetText( Hud_GetChild( file.menu, "Deaths" + i ), file.FSDM_Scoreboard[i].deaths.tostring() )		
			Hud_SetText( Hud_GetChild( file.menu, "KD" + i ), file.FSDM_Scoreboard[i].kd.tostring() )
			Hud_SetText( Hud_GetChild( file.menu, "Damage" + i ), file.FSDM_Scoreboard[i].damage.tostring() )
			// Hud_SetText( Hud_GetChild( file.menu, "Latency" + i ), file.FSDM_Scoreboard[i].lastLatency.tostring() )
		}
	}()
}

//Sets and updates the voting screen
void function Set_FSDM_VotingScreen()
{
	try{
		RegisterButtonPressedCallback( KEY_ENTER, FocusChat )
	}catch(e420){}
	SetVoteHudElems(true, true, true, true, true, true, true, false, false, false, false, false)

	for(int i = 1; i < 5; i++ ) {
		Hud_SetEnabled( Hud_GetChild( file.menu, "MapVote" + i ), true )
	}
	
	Hud_SetVisible( Hud_GetChild( file.menu, "VotingPhaseChatBox"), true )
	Hud_SetAboveBlur( Hud_GetChild( file.menu, "VotingPhaseChatBox"), true )
	Hud_SetEnabled( Hud_GetChild( Hud_GetChild( file.menu, "VotingPhaseChatBox"), "ChatInputLine" ), false)
}

//Sets and updates the next round screen
void function Set_FSDM_VoteMenuNextRound()
{
	SetVoteHudElems(false, false, false, false, false, false, false, true, true, false, false, false)

	Hud_SetText( Hud_GetChild( file.menu, "VotedForLbl" ), "Starting Next Round!")
}

//Update current maps up for vote
void function UpdateMapsForVoting_FSDM(string map1, asset map1asset, string map2, asset map2asset, string map3, asset map3asset, string map4, asset map4asset)
{
	Hud_SetText(Hud_GetChild( file.menu, "MapVoteLabelName1" ), map1 )
	Hud_SetText(Hud_GetChild( file.menu, "MapVoteLabelName2" ), map2 )
	Hud_SetText(Hud_GetChild( file.menu, "MapVoteLabelName3" ), map3 )
	Hud_SetText(Hud_GetChild( file.menu, "MapVoteLabelName4" ), map4 )
	
	RuiSetImage( Hud_GetRui( Hud_GetChild( file.menu, "MapVoteImage1" ) ), "basicImage", map1asset )
	RuiSetImage( Hud_GetRui( Hud_GetChild( file.menu, "MapVoteImage2" ) ), "basicImage", map2asset )
	RuiSetImage( Hud_GetRui( Hud_GetChild( file.menu, "MapVoteImage3" ) ), "basicImage", map3asset )
	RuiSetImage( Hud_GetRui( Hud_GetChild( file.menu, "MapVoteImage4" ) ), "basicImage", map4asset )
}

//Closes the vote menu
void function Close_FSDM_VoteMenu()
{
	try{
		DeregisterButtonPressedCallback( KEY_ENTER, FocusChat )
	}catch(e420){}
	CloseAllMenus()
}

//Update vote time left
void function UpdateVoteTimer_FSDM(int timeleft)
{
	Hud_SetText(Hud_GetChild( file.menu, "TimerText" ), timeleft.tostring())
}

//Update current votes for each map
void function UpdateVotesUI_FSDM(int map1, int map2, int map3, int map4)
{
	Hud_SetText(Hud_GetChild( file.menu, "MapVoteLabelVotes1" ), "Votes: " + map1 )
	Hud_SetText(Hud_GetChild( file.menu, "MapVoteLabelVotes2" ), "Votes: " + map2 )
	Hud_SetText(Hud_GetChild( file.menu, "MapVoteLabelVotes3" ), "Votes: " + map3 )
	Hud_SetText(Hud_GetChild( file.menu, "MapVoteLabelVotes4" ), "Votes: " + map4 )
}

//Lock Buttons and update the map player voted for
void function UpdateVotedFor_FSDM(int id)
{
	for(int i = 1; i < 5; i++ ) {
		// RuiSetInt( Hud_GetRui( Hud_GetChild( file.menu, "MapVote" + i )), "status", eFriendStatus.OFFLINE )
		Hud_SetEnabled( Hud_GetChild( file.menu, "MapVote" + i ), false )
	}
	Hud_SetVisible( Hud_GetChild( file.menu, "MapVoteLabelNameFrame" + id ), false )
	Hud_SetVisible( Hud_GetChild( file.menu, "MapVoteLabelNameFrameVoted" + id ), true )
}

//Sets and updates selected location
void function UpdateVotedLocation_FSDM(string map)
{
	SetVoteHudElems(false, false, false, false, false, false, false, true, true, false, false, false)

	Hud_SetText( Hud_GetChild( file.menu, "VotedForLbl" ), "Next Location: " + map)
}

//Sets and updates tied voting screen
void function UpdateVotedLocation_FSDMTied(string map)
{
	SetVoteHudElems(false, true, true, true, false, false, false, true, true, false, false, false)

	Hud_SetText( Hud_GetChild( file.menu, "TimerText" ), "Picking a random location from tied locations")
	Hud_SetText( Hud_GetChild( file.menu, "TimerText2" ), "Votes Tied!")
	Hud_SetText( Hud_GetChild( file.menu, "VotedForLbl" ), map)
}

//Inits vote menu
void function Init_FSDM_VoteMenu( var newMenuArg )
{
	var menu = GetMenu( "FSDMVoteMenu" )
	file.menu = menu

	AddMenuEventHandler( menu, eUIEvent.MENU_NAVIGATE_BACK, On_FSDM__NavigateBack )

	AddButtonEventHandler( Hud_GetChild( menu, "MapVote1" ), UIE_CLICK, OnClickMap )
	AddButtonEventHandler( Hud_GetChild( menu, "MapVote2" ), UIE_CLICK, OnClickMap )
	AddButtonEventHandler( Hud_GetChild( menu, "MapVote3" ), UIE_CLICK, OnClickMap )
	AddButtonEventHandler( Hud_GetChild( menu, "MapVote4" ), UIE_CLICK, OnClickMap )
	
	//Hide all scoreboard buttons
	array<var> serverbuttons = GetElementsByClassname( file.menu, "ScoreboardUIButton" )
	foreach ( var elem in serverbuttons )
	{
		Hud_SetVisible(elem, false)
	}
}

void function SetVoteHudElems(bool MapVote, bool TimerFrame, bool TimerText2, bool TimerText, bool MapVoteFrame, bool _FSDM_BottomFrame, bool ObjectiveText, bool MapVoteFrame2, bool VotedForLbl, bool WinnerLbl, bool WinnerFrame, bool Scoreboard)
{
	for(int i = 1; i < 5; i++ ) {
		Hud_SetVisible( Hud_GetChild( file.menu, "MapVote" + i ), MapVote )
		Hud_SetVisible( Hud_GetChild( file.menu, "MapVoteImage" + i ), MapVote )
		Hud_SetVisible( Hud_GetChild( file.menu, "MapVoteLabelVotes" + i ), MapVote )
		Hud_SetVisible( Hud_GetChild( file.menu, "MapVoteLabelVotesFrame" + i ), MapVote )
		Hud_SetVisible( Hud_GetChild( file.menu, "MapVoteLabelName" + i ), MapVote )
		Hud_SetVisible( Hud_GetChild( file.menu, "MapVoteLabelNameFrame" + i ), MapVote )
	}
	
	array<var> ScoreboardUI = GetElementsByClassname( file.menu, "ScoreboardUI" )
	foreach ( var elem in ScoreboardUI )
	{
		Hud_SetVisible(elem, Scoreboard)
	}
	Hud_SetVisible(Hud_GetChild( file.menu, "ScoreboardText"), Scoreboard)
	
	if(!MapVote)
		for(int i = 1; i < 5; i++ ) {
			Hud_SetVisible( Hud_GetChild( file.menu, "MapVoteLabelNameFrameVoted" + i ), MapVote )
		}

	Hud_SetVisible(Hud_GetChild( file.menu, "TimerFrame"), TimerFrame)
	Hud_SetVisible(Hud_GetChild( file.menu, "TimerText2"), TimerText2)
	Hud_SetVisible(Hud_GetChild( file.menu, "TimerText" ), TimerText)

	Hud_SetVisible( Hud_GetChild( file.menu, "MapVoteFrame" ), MapVoteFrame )
	Hud_SetVisible( Hud_GetChild( file.menu, "_FSDM_BottomFrame" ), _FSDM_BottomFrame )
	Hud_SetVisible( Hud_GetChild( file.menu, "ObjectiveText" ), ObjectiveText )

	Hud_SetVisible( Hud_GetChild( file.menu, "MapVoteFrame2" ), MapVoteFrame2 )
	Hud_SetVisible( Hud_GetChild( file.menu, "VotedForLbl" ), VotedForLbl )
	if(VotedForLbl)
	{
		Hud_SetVisible(Hud_GetChild( file.menu, "TextCredits2"), false)
		Hud_SetVisible(Hud_GetChild( file.menu, "TextCredits"), false)
		Hud_SetVisible(Hud_GetChild( file.menu, "VotingPhaseChatBox"), false)
	}
	
	Hud_SetVisible(Hud_GetChild( file.menu, "WinnerLbl"), WinnerLbl)
	Hud_SetVisible(Hud_GetChild( file.menu, "WinnerFrame"), WinnerFrame)
}

//Button event handlers
void function OnClickMap( var button )
{
	int buttonId = Hud_GetScriptID( button ).tointeger()
	
	RunClientScript("UI_To_Client_VoteForMap_FSDM", buttonId )
}

void function OnGetFocusMap( var button )
{
	int buttonId = Hud_GetScriptID( button ).tointeger()
	
	Hud_SetVisible( Hud_GetChild( file.menu, "MapVoteImageFocused" + buttonId ), true )
	RuiSetFloat( Hud_GetRui( Hud_GetChild( file.menu, "MapVoteImageFocused" + buttonId ) ), "basicImageAlpha", 0.5)
}

void function OnLoseFocusMap( var button )
{
	int buttonId = Hud_GetScriptID( button ).tointeger()
	Hud_SetVisible( Hud_GetChild( file.menu, "MapVoteImageFocused1" ), false )
}

void function FocusChat( var panel )
{
	if(!Hud_IsFocused( Hud_GetChild( Hud_GetChild( file.menu, "VotingPhaseChatBox"), "ChatInputLine" ) ))
	{
		Hud_StartMessageMode( Hud_GetChild( file.menu, "VotingPhaseChatBox") )
		Hud_SetEnabled( Hud_GetChild( Hud_GetChild( file.menu, "VotingPhaseChatBox"), "ChatInputLine" ), true)
		Hud_SetVisible( Hud_GetChild( Hud_GetChild( file.menu, "VotingPhaseChatBox"), "ChatInputLine" ), true )
		Hud_SetFocused( Hud_GetChild( Hud_GetChild( file.menu, "VotingPhaseChatBox"), "ChatInputLine" ) )
	} 
}

void function On_FSDM__NavigateBack()
{
	// gotta have NavigateBack blank so that you cant close the menu
}