global function InitChallengesHistory
global function OpenFRChallengesHistory
global function CloseFRChallengesHistory
global function HistoryUI_AddNewChallenge

struct
{
	var menu
	bool wpnselectorToggle = false
	
} file

//Struct for results data
struct ResultsHistory
{
	string ChallengeName
	int Kills
	int ShotsHit
	string ChallengeWeapon
	string ChallengeAccuracy
}

array<ResultsHistory> ChallengesHistory

void function OpenFRChallengesHistory(int dummiesKilled)
{
	//use dummies killed
	CloseAllMenus()
	EmitUISound("UI_Menu_SelectMode_Extend")
	AdvanceMenu( file.menu )

	if(ChallengesHistory.len() == 0)
		ShowNoChallengesPlayed(true)
	else
		ShowNoChallengesPlayed(false)

	for( int i=0; i < ChallengesHistory.len(); i++ )
	{	
		Hud_SetText( Hud_GetChild( file.menu, "ChallengeName" + i ), ChallengesHistory[i].ChallengeName )
		Hud_SetText( Hud_GetChild( file.menu, "Kills" + i ), ChallengesHistory[i].Kills.tostring() )
		Hud_SetText( Hud_GetChild( file.menu, "Score" + i ), ChallengesHistory[i].ShotsHit.tostring() )		
		Hud_SetText( Hud_GetChild( file.menu, "ChallengeWeapon" + i ), ChallengesHistory[i].ChallengeWeapon )
		Hud_SetText( Hud_GetChild( file.menu, "ChallengeAccuracy" + i ), ChallengesHistory[i].ChallengeAccuracy.tostring() )
	}	
}

void function CloseFRChallengesHistory()
{
	CloseAllMenus()
}

void function InitChallengesHistory( var newMenuArg )
{
	var menu = GetMenu( "FRChallengesHistory" )
	file.menu = menu
	
    AddMenuEventHandler( menu, eUIEvent.MENU_SHOW, OnR5RSB_Show )
	AddMenuEventHandler( menu, eUIEvent.MENU_OPEN, OnR5RSB_Open )
	AddMenuEventHandler( menu, eUIEvent.MENU_CLOSE, OnR5RSB_Close )	
	AddMenuEventHandler( menu, eUIEvent.MENU_NAVIGATE_BACK, OnR5RSB_NavigateBack )
	
	AddEventHandlerToButton( menu, "Challenges", UIE_CLICK, ChallengesButtonFunct )
	AddEventHandlerToButton( menu, "Settings", UIE_CLICK, SettingsButtonFunct )
	
	array<var> challengesRows = GetElementsByClassname( file.menu, "ChallengeBtn" )
	foreach ( var elem in challengesRows ) 
	{
		RuiSetString( Hud_GetRui( elem ), "buttonText", "")
		Hud_SetEnabled( elem, false )
	}
}

void function HistoryUI_AddNewChallenge(string Name, int ShotsHit, string Weapon, float Accuracy, int dummiesKilled, int Damage, bool wasNewScore)
{
	string AccuracyShort = LocalizeAndShortenNumber_Float(Accuracy, 1, 2)
	if(AccuracyShort == "-na,n(i,nd).-n" || AccuracyShort == "-nan(ind)" || AccuracyShort == "-na.n(i.nd),-n") AccuracyShort = "0"

	ResultsHistory newChallenge
	newChallenge.ChallengeName = Name
	newChallenge.Kills = dummiesKilled
	newChallenge.ShotsHit = ShotsHit
	newChallenge.ChallengeWeapon = GetWeaponNameForUI(Weapon).toupper()
	newChallenge.ChallengeAccuracy = AccuracyShort

	ChallengesHistory.push(newChallenge)
	ChallengesHistory.reverse()
}

void function ShowNoChallengesPlayed(bool show)
{
	//Set no servers found ui based on bool
	Hud_SetVisible(Hud_GetChild( file.menu, "NameLine" ), !show )
	Hud_SetVisible(Hud_GetChild( file.menu, "ScoreLine" ), !show )
	Hud_SetVisible(Hud_GetChild( file.menu, "WeaponLine" ), !show )
	Hud_SetVisible(Hud_GetChild( file.menu, "ShotshitLine" ), !show )
	Hud_SetVisible(Hud_GetChild( file.menu, "AccuracyLine" ), !show )
	Hud_SetVisible(Hud_GetChild( file.menu, "NoChallengesLbl" ), show )
}

void function ChallengesButtonFunct(var button)
{
	CloseAllMenus()
	RunClientScript("ServerCallback_OpenFRChallengesMainMenu", PlayerKillsForChallengesUI)
}

void function SettingsButtonFunct(var button)
{
	CloseAllMenus()
	EmitUISound("UI_Menu_SelectMode_Close")
	RunClientScript("ServerCallback_OpenFRChallengesSettings")
}

void function OnR5RSB_Show()
{
    //
}

void function OnR5RSB_Open()
{
	//
}


void function OnR5RSB_Close()
{
	//
}

void function OnR5RSB_NavigateBack()
{
	CloseAllMenus()
	RunClientScript("ServerCallback_OpenFRChallengesMainMenu", PlayerKillsForChallengesUI)	
}