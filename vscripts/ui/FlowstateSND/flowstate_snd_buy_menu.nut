//team select menu
global function Init_FSSND_BuyMenu
global function Open_FSSND_BuyMenu
global function Close_FSSND_BuyMenu

global function SND_Disable_IMCButton
global function SND_Disable_MILITIAButton
global function SND_UpdateVotesForTeam

struct
{
	var menu
	int votesForIMC
	int votesForMILITIA
} file

void function Init_FSSND_BuyMenu( var newMenuArg )
{
	var menu = GetMenu( "FSSND_BuyMenu" )
	file.menu = menu

	AddButtonEventHandler( Hud_GetChild( menu, "TeamIMCButton"), UIE_CLICK, SND_SetTeam_IMC )
	AddButtonEventHandler( Hud_GetChild( menu, "TeamMILITIAButton"), UIE_CLICK, SND_SetTeam_MILITIA )
	AddMenuEventHandler( file.menu, eUIEvent.MENU_NAVIGATE_BACK, On_FSSND__NavigateBack )
	
	Hud_SetEnabled(Hud_GetChild( file.menu, "TeamMILITIAButton"), true)
	Hud_SetEnabled(Hud_GetChild( file.menu, "TeamIMCButton"), true)
	RuiSetInt( Hud_GetRui( Hud_GetChild( file.menu, "TeamIMCButton")), "status", eFriendStatus.ONLINE_AWAY )
	RuiSetInt( Hud_GetRui( Hud_GetChild( file.menu, "TeamMILITIAButton")), "status", eFriendStatus.ONLINE_AWAY )
}

void function Open_FSSND_BuyMenu( float
 endtime)
{
	CloseAllMenus()
	
	file.votesForIMC = 0
	file.votesForMILITIA = 0
	
	Hud_SetText( Hud_GetChild( file.menu, "MILITIAVotesText"), "Players: 0" )
	Hud_SetText( Hud_GetChild( file.menu, "IMCVotesText"), "Players: 0" )	
	
	EmitUISound( "UI_Menu_FriendInspect" )
	AdvanceMenu( file.menu )
	
	var MILITIATeamIcon = Hud_GetRui(Hud_GetChild( file.menu, "MILITIATeamIcon" ))
	RuiSetImage( MILITIATeamIcon, "basicImage", $"rui/flowstatecustom/militia" )
	
	var IMCTeamIcon = Hud_GetRui(Hud_GetChild( file.menu, "IMCTeamIcon" ))
	RuiSetImage( IMCTeamIcon, "basicImage", $"rui/flowstatecustom/imc" )
	
	Hud_SetSelected(Hud_GetChild( file.menu, "TeamMILITIAButton"), false)
	Hud_SetSelected(Hud_GetChild( file.menu, "TeamIMCButton"), false)
	
	Hud_SetLocked(Hud_GetChild( file.menu, "TeamMILITIAButton"), false)
	Hud_SetLocked(Hud_GetChild( file.menu, "TeamIMCButton"), false)

	Hud_SetEnabled(Hud_GetChild( file.menu, "TeamMILITIAButton"), true)
	Hud_SetEnabled(Hud_GetChild( file.menu, "TeamIMCButton"), true)
	
	RuiSetInt( Hud_GetRui( Hud_GetChild( file.menu, "TeamIMCButton")), "status", eFriendStatus.ONLINE_AWAY )
	RuiSetInt( Hud_GetRui( Hud_GetChild( file.menu, "TeamMILITIAButton")), "status", eFriendStatus.ONLINE_AWAY )
	
	thread ThreadTest_Timer(endtime)
}	

void function Close_FSSND_BuyMenu()
{
	Hud_SetSelected(Hud_GetChild( file.menu, "TeamMILITIAButton"), false)
	Hud_SetSelected(Hud_GetChild( file.menu, "TeamIMCButton"), false)
	
	Hud_SetLocked(Hud_GetChild( file.menu, "TeamMILITIAButton"), false)
	Hud_SetLocked(Hud_GetChild( file.menu, "TeamIMCButton"), false)

	Hud_SetEnabled(Hud_GetChild( file.menu, "TeamMILITIAButton"), true)
	Hud_SetEnabled(Hud_GetChild( file.menu, "TeamIMCButton"), true)
	
	RuiSetInt( Hud_GetRui( Hud_GetChild( file.menu, "TeamIMCButton")), "status", eFriendStatus.ONLINE_AWAY )
	RuiSetInt( Hud_GetRui( Hud_GetChild( file.menu, "TeamMILITIAButton")), "status", eFriendStatus.ONLINE_AWAY )
	
	CloseAllMenus()
}

void function ThreadTest_Timer( float endtime )
{
	endtime = Time() + 10
	while ( Time() <= endtime )
	{
		if(endtime == 0) break
		
		int elapsedtime = fabs( endtime - Time() ).tointeger()

		//DisplayTime dt = SecondsToDHMS( elapsedtime )
		Hud_SetText( Hud_GetChild( file.menu, "RemainingTimeToSelectTeamText"), elapsedtime.tostring() )
		
		wait 1
		// printt("should update timer")
	}	
}

void function SND_UpdateVotesForTeam(int team, int votes)
{
	if(team == 0)	
	{
		Hud_SetText( Hud_GetChild( file.menu, "IMCVotesText"), "Players: " + votes )	
	} else if(team == 1)
	{
		Hud_SetText( Hud_GetChild( file.menu, "MILITIAVotesText"), "Players: " + votes )
	}
}

void function SND_SetTeam_IMC(var button)
{
	RuiSetInt( Hud_GetRui( Hud_GetChild( file.menu, "TeamIMCButton")), "status", eFriendStatus.ONLINE )
	RuiSetInt( Hud_GetRui( Hud_GetChild( file.menu, "TeamMILITIAButton")), "status", eFriendStatus.OFFLINE )
	RunClientScript("SND_ClientAskedForTeam", 0)
	Hud_SetEnabled(Hud_GetChild( file.menu, "TeamMILITIAButton"), false)
}

void function SND_SetTeam_MILITIA(var button)
{
	RuiSetInt( Hud_GetRui( Hud_GetChild( file.menu, "TeamIMCButton")), "status", eFriendStatus.OFFLINE )
	RuiSetInt( Hud_GetRui( Hud_GetChild( file.menu, "TeamMILITIAButton")), "status", eFriendStatus.ONLINE )
	RunClientScript("SND_ClientAskedForTeam", 1)
	Hud_SetEnabled(Hud_GetChild( file.menu, "TeamIMCButton"), false)
}

void function SND_Disable_MILITIAButton()
{
	RuiSetInt( Hud_GetRui( Hud_GetChild( file.menu, "TeamMILITIAButton")), "status", eFriendStatus.OFFLINE )
	Hud_SetEnabled(Hud_GetChild( file.menu, "TeamMILITIAButton"), false)
	
	RuiSetInt( Hud_GetRui( Hud_GetChild( file.menu, "TeamIMCButton")), "status", eFriendStatus.ONLINE )
	Hud_SetEnabled(Hud_GetChild( file.menu, "TeamIMCButton"), false)
}

void function SND_Disable_IMCButton()
{
	RuiSetInt( Hud_GetRui( Hud_GetChild( file.menu, "TeamIMCButton")), "status", eFriendStatus.OFFLINE )
	Hud_SetEnabled(Hud_GetChild( file.menu, "TeamIMCButton"), false)
	
	RuiSetInt( Hud_GetRui( Hud_GetChild( file.menu, "TeamMILITIAButton")), "status", eFriendStatus.ONLINE )
	Hud_SetEnabled(Hud_GetChild( file.menu, "TeamMILITIAButton"), false)
}

void function On_FSSND__NavigateBack()
{
	// gotta have NavigateBack blank so that you cant close the menu
}