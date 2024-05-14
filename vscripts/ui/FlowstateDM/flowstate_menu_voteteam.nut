//Made by @CafeFPS

global function Init_FS_VoteTeamMenu

global function Open_FS_VoteTeam
global function Close_FS_VoteTeam

global function AddPlayerNameToTeamArray
global function RemovePlayerNameFromTeamArray

global function VoteTeamTimerSetText

struct
{
	var menu
	var teamOrchidList
	var teamCondorList
	array<string> orchidTeamPlayersNames
	array<string> condorTeamPlayersNames
} file

// //Opens vote menu
void function Open_FS_VoteTeam()
{
	CloseAllMenus()
	file.orchidTeamPlayersNames.clear()
	file.condorTeamPlayersNames.clear()
	AdvanceMenu( file.menu )

	RuiSetImage( Hud_GetRui( Hud_GetChild( file.menu, "TimerFrame") ), "basicImage", $"rui/flowstate_custom/voteteam_titlebg" )

	Hud_SetText( Hud_GetChild( file.menu, "ChooseTeamTimerText" ), "%$rui/menu/store/feature_timer% 30")

	Hud_SetVisible( Hud_GetChild( file.menu, "VotingPhaseChatBox"), false )
	Hud_SetAboveBlur( Hud_GetChild( file.menu, "VotingPhaseChatBox"), false )
	Hud_SetEnabled( Hud_GetChild( Hud_GetChild( file.menu, "VotingPhaseChatBox"), "ChatInputLine" ), false)

	Hud_SetVisible( Hud_GetChild( file.menu, "TeamPropsButton" ), true )
	Hud_SetEnabled( Hud_GetChild( file.menu, "TeamPropsButton" ), true )
	
	Hud_SetVisible( Hud_GetChild( file.menu, "TeamSeekersButton" ), true )
	Hud_SetEnabled( Hud_GetChild( file.menu, "TeamSeekersButton" ), true )

	RefreshOrchidTeamList()
	RefreshCondorTeamList()
}

void function RefreshOrchidTeamList()
{
	Hud_InitGridButtons( file.teamOrchidList, file.orchidTeamPlayersNames.len() )
	var scrollPanel = Hud_GetChild( file.teamOrchidList, "ScrollPanel" )
	foreach ( int id, string name in file.orchidTeamPlayersNames )
	{
		var button = Hud_GetChild( scrollPanel, "GridButton" + id )
        var rui = Hud_GetRui( button )
	    RuiSetString( rui, "buttonText", name )
	}

	if( file.orchidTeamPlayersNames.len() == 0 )
	{
		Hud_SetText( Hud_GetChild( file.menu, "TeamOrchidListText" ), "0 players on the Team Orchid")
		return
	}
	
	Hud_SetText( Hud_GetChild( file.menu, "TeamOrchidListText" ), file.orchidTeamPlayersNames.len().tostring() + (file.orchidTeamPlayersNames.len() == 1 ? " Player on the Team Orchid" : " Players on the Team Orchid"))
}

void function RefreshCondorTeamList()
{
	var scrollPanel = Hud_GetChild( file.teamCondorList, "ScrollPanel" )
	Hud_InitGridButtons( file.teamCondorList, file.condorTeamPlayersNames.len() )
	foreach ( int id, string name in file.condorTeamPlayersNames )
	{
		var button = Hud_GetChild( scrollPanel, "GridButton" + id )
        var rui = Hud_GetRui( button )
	    RuiSetString( rui, "buttonText", name )
	}
	
	if( file.condorTeamPlayersNames.len() == 0 )
	{
		Hud_SetText( Hud_GetChild( file.menu, "TeamCondorListText" ), "0 players on the Team Condor")
		return
	}
	
	Hud_SetText( Hud_GetChild( file.menu, "TeamCondorListText" ), file.condorTeamPlayersNames.len().tostring() + (file.condorTeamPlayersNames.len() == 1 ? " Player on the Team Condor" : " Players on the Team Condor"))
}

void function AddPlayerNameToTeamArray( int team, string name )
{
	if( team == 0 )
	{
		if( !file.condorTeamPlayersNames.contains( name ) )
		{
			file.condorTeamPlayersNames.append( name )
			RefreshCondorTeamList()
		}
	} else if( team == 1 )
	{
		if( !file.orchidTeamPlayersNames.contains( name ) )
		{
			file.orchidTeamPlayersNames.append( name )
			RefreshOrchidTeamList()
		}
	}
}

void function RemovePlayerNameFromTeamArray( int team, string name )
{
	if( team == 0 )
	{
		file.condorTeamPlayersNames.fastremovebyvalue( name )
		RefreshCondorTeamList()
	} else if( team == 1 )
	{
		file.orchidTeamPlayersNames.fastremovebyvalue( name )
		RefreshOrchidTeamList()
	}
}

//Closes the vote menu
void function Close_FS_VoteTeam()
{
	CloseAllMenus()
}

void function Init_FS_VoteTeamMenu( var newMenuArg )
{
	var menu = GetMenu( "FSVoteTeamMenu" )
	file.menu = menu

	AddMenuEventHandler( menu, eUIEvent.MENU_NAVIGATE_BACK, On_FSDM__NavigateBack )

	AddButtonEventHandler( Hud_GetChild( menu, "TeamSeekersButton"), UIE_CLICK, SetTeam_IMC1 )
	Hud_AddEventHandler( Hud_GetChild( menu, "TeamSeekersButton"), UIE_GET_FOCUS, OnIMCButtonHover )
	Hud_AddEventHandler( Hud_GetChild( menu, "TeamSeekersButton"), UIE_LOSE_FOCUS, OnIMCButtonUnHover )

	AddButtonEventHandler( Hud_GetChild( menu, "TeamPropsButton"), UIE_CLICK, SetTeam_MILITIA1 )
	Hud_AddEventHandler( Hud_GetChild( menu, "TeamPropsButton"), UIE_GET_FOCUS, OnMILButtonHover )
	Hud_AddEventHandler( Hud_GetChild( menu, "TeamPropsButton"), UIE_LOSE_FOCUS, OnMILButtonUnHover )

	file.teamCondorList = Hud_GetChild( file.menu, "TeamCondorList" )
	file.teamOrchidList = Hud_GetChild( file.menu, "TeamOrchidList" )
}

void function OnIMCButtonHover( var button )
{
	printt( "ui imc button hover" )
	if ( CanRunClientScript() )
		RunClientScript( "HoverTeamButton", 1 )
}

void function OnIMCButtonUnHover( var button )
{
	printt( "ui imc button unhover" )
	if ( CanRunClientScript() )
		RunClientScript( "VoteTeam_EndFocusModel", 1 )
}

void function OnMILButtonHover( var button )
{
	printt( "ui mil button hover" )
	if ( CanRunClientScript() )
		RunClientScript( "HoverTeamButton", 0 )
}

void function OnMILButtonUnHover( var button )
{
	printt( "ui mil button unhover" )
	if ( CanRunClientScript() )
		RunClientScript( "VoteTeam_EndFocusModel", 0 )
}

void function SetTeam_IMC1(var button)
{
	printt( "ui mil button clicked" )
	if ( CanRunClientScript() )
	{
		RunClientScript("VoteTeam_ClientAskedForTeam", 1)
	}
	Hud_SetSelected(Hud_GetChild( file.menu, "TeamPropsButton"), false)
}

void function SetTeam_MILITIA1(var button)
{
	printt( "ui mil button clicked" )
	if ( CanRunClientScript() )
	{
		RunClientScript("VoteTeam_ClientAskedForTeam", 0)
	}
	Hud_SetSelected(Hud_GetChild( file.menu, "TeamSeekersButton"), false)
}

void function On_FSDM__NavigateBack()
{
	// gotta have NavigateBack blank so that you cant close the menu
}

void function VoteTeamTimerSetText( string text )
{
	Hud_SetText( Hud_GetChild( file.menu, "ChooseTeamTimerText" ), text )
}