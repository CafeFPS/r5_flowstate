global function InitChallengesHistory
global function OpenFRChallengesHistory
global function HistoryUI_AddNewChallenge

global const AIMTRAINER_HISTORYUI_SERVERS_PER_PAGE = 19

struct
{
	var menu
	bool wpnselectorToggle = false
} file

//Struct for page system
struct
{
	int pAmount
	int pCurrent
	int pOffset
	int pStart
	int pEnd
} m_vPages

//Struct for results data
struct ResultsHistory
{
	string ChallengeName
	int Kills
	int ShotsHit
	string ChallengeWeapon
	string ChallengeAccuracy
	int Damage
	int CriticalShots
	int TotalShots
	int RoundTime
}

array<ResultsHistory> ChallengesHistory

void function OpenFRChallengesHistory(int dummiesKilled)
{
	//use dummies killed
	CloseAllMenus()
	EmitUISound("UI_Menu_SelectMode_Extend")
	AdvanceMenu( file.menu )
	
	if(ChallengesHistory.len() == 0)
	{
		ShowNoChallengesPlayed(true)
		Hud_SetVisible( Hud_GetChild( file.menu, "BtnServerListRightArrow"), false )		
		Hud_SetVisible( Hud_GetChild( file.menu, "BtnServerListLeftArrow"), false )
		Hud_SetVisible( Hud_GetChild( file.menu, "Pages"), false )
		Hud_SetVisible( Hud_GetChild( file.menu, "PrintToConsole"), false )
		m_vPages.pAmount = 0
	}
	else
	{
		ChallengesHistory.reverse()
		m_vPages.pAmount = ChallengesHistory.len()/AIMTRAINER_HISTORYUI_SERVERS_PER_PAGE
		
		ShowNoChallengesPlayed(false)
		Hud_SetVisible( Hud_GetChild( file.menu, "BtnServerListRightArrow"), true )		
		Hud_SetVisible( Hud_GetChild( file.menu, "BtnServerListLeftArrow"), true )
		Hud_SetVisible( Hud_GetChild( file.menu, "Pages"), true )
		Hud_SetText (Hud_GetChild( file.menu, "Pages" ), "  Page: 1/" + (m_vPages.pAmount + 1) + "  ")
		Hud_SetVisible( Hud_GetChild( file.menu, "PrintToConsole"), true )
		
		for( int i=0; i < ChallengesHistory.len() && i < AIMTRAINER_HISTORYUI_SERVERS_PER_PAGE; i++ )
		{	
			Hud_SetText( Hud_GetChild( file.menu, "ChallengeName" + i ), ChallengesHistory[i].ChallengeName )
			Hud_SetText( Hud_GetChild( file.menu, "Kills" + i ), ChallengesHistory[i].Kills.tostring() )
			Hud_SetText( Hud_GetChild( file.menu, "Score" + i ), ChallengesHistory[i].ShotsHit.tostring() )		
			Hud_SetText( Hud_GetChild( file.menu, "ChallengeWeapon" + i ), ChallengesHistory[i].ChallengeWeapon )
			Hud_SetText( Hud_GetChild( file.menu, "ChallengeAccuracy" + i ), ChallengesHistory[i].ChallengeAccuracy.tostring() )
		}
	}
}

void function PrevPage(var button)
{
	//If Pages is 0 then return
	//or if is one the first page
	if(m_vPages.pAmount == 0 || m_vPages.pCurrent == 0)
		return

	// Reset Server Labels
	ResetChallengesLabels()

	// Set current page to prev page
	m_vPages.pCurrent--

	// If current page is less then first page set to first page
	if(m_vPages.pCurrent < 0)
		m_vPages.pCurrent = 0

	//Set Start ID / End ID / and ID Offset
	m_vPages.pStart = m_vPages.pCurrent * AIMTRAINER_HISTORYUI_SERVERS_PER_PAGE
	m_vPages.pEnd = m_vPages.pStart + AIMTRAINER_HISTORYUI_SERVERS_PER_PAGE
	m_vPages.pOffset = m_vPages.pCurrent * AIMTRAINER_HISTORYUI_SERVERS_PER_PAGE

	// Check if m_vPages.pEnd is greater then actual amount of servers
	if(m_vPages.pEnd > ChallengesHistory.len())
		m_vPages.pEnd = ChallengesHistory.len()

	// Set current page ui
	Hud_SetText(Hud_GetChild( file.menu, "Pages" ), "  Page:" + (m_vPages.pCurrent + 1) + "/" + (m_vPages.pAmount + 1) + "  ")

	// "id" is diffrent from "i" and is used for setting UI elements
	// "i" is used for server id
	int id = 0
	for( int i=m_vPages.pStart; i < m_vPages.pEnd; i++ ) {
		Hud_SetText( Hud_GetChild( file.menu, "ChallengeName" + id ), ChallengesHistory[i].ChallengeName )
		Hud_SetText( Hud_GetChild( file.menu, "Kills" + id ), ChallengesHistory[i].Kills.tostring() )
		Hud_SetText( Hud_GetChild( file.menu, "Score" + id ), ChallengesHistory[i].ShotsHit.tostring() )		
		Hud_SetText( Hud_GetChild( file.menu, "ChallengeWeapon" + id ), ChallengesHistory[i].ChallengeWeapon )
		Hud_SetText( Hud_GetChild( file.menu, "ChallengeAccuracy" + id ), ChallengesHistory[i].ChallengeAccuracy.tostring() )
		id++
	}
}

void function NextPage(var button)
{
	//If Pages is 0 then return
	//or if is on the last page
	if(m_vPages.pAmount == 0 || m_vPages.pCurrent == m_vPages.pAmount )
		return

	// Reset Server Labels
	ResetChallengesLabels()

	// Set current page to next page
	m_vPages.pCurrent++

	// If current page is greater then last page set to last page
	if(m_vPages.pCurrent > m_vPages.pAmount)
		m_vPages.pCurrent = m_vPages.pAmount

	//Set Start ID / End ID / and ID Offset
	m_vPages.pStart = m_vPages.pCurrent * AIMTRAINER_HISTORYUI_SERVERS_PER_PAGE
	m_vPages.pEnd = m_vPages.pStart + AIMTRAINER_HISTORYUI_SERVERS_PER_PAGE
	m_vPages.pOffset = m_vPages.pCurrent * AIMTRAINER_HISTORYUI_SERVERS_PER_PAGE

	// Check if m_vPages.pEnd is greater then actual amount of servers
	if(m_vPages.pEnd > ChallengesHistory.len())
		m_vPages.pEnd = ChallengesHistory.len()

	// Set current page ui
	Hud_SetText(Hud_GetChild( file.menu, "Pages" ), "  Page:" + (m_vPages.pCurrent + 1) + "/" + (m_vPages.pAmount + 1) + "  ")

	// "id" is diffrent from "i" and is used for setting UI elements
	// "i" is used for server id
	int id = 0
	for( int i=m_vPages.pStart; i < m_vPages.pEnd; i++ ) {
		Hud_SetText( Hud_GetChild( file.menu, "ChallengeName" + id ), ChallengesHistory[i].ChallengeName )
		Hud_SetText( Hud_GetChild( file.menu, "Kills" + id ), ChallengesHistory[i].Kills.tostring() )
		Hud_SetText( Hud_GetChild( file.menu, "Score" + id ), ChallengesHistory[i].ShotsHit.tostring() )		
		Hud_SetText( Hud_GetChild( file.menu, "ChallengeWeapon" + id ), ChallengesHistory[i].ChallengeWeapon )
		Hud_SetText( Hud_GetChild( file.menu, "ChallengeAccuracy" + id ), ChallengesHistory[i].ChallengeAccuracy.tostring() )
		id++
	}
}

void function ResetChallengesLabels()
{
	//Hide all server buttons
	array<var> serverbuttons = GetElementsByClassname( file.menu, "ChallengeBtn" )
	foreach ( var elem in serverbuttons )
	{
		Hud_SetVisible(elem, false)
	}

	//Clear all server labels
	array<var> serverlabels = GetElementsByClassname( file.menu, "ServerLabels" )
	foreach ( var elem in serverlabels )
	{
		Hud_SetText(elem, "")
	}
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
	
	//Setup Page Nav Buttons
	Hud_AddEventHandler( Hud_GetChild( file.menu, "BtnServerListRightArrow" ), UIE_CLICK, NextPage )
	Hud_AddEventHandler( Hud_GetChild( file.menu, "BtnServerListLeftArrow" ), UIE_CLICK, PrevPage )
	Hud_AddEventHandler( Hud_GetChild( file.menu, "PrintToConsole" ), UIE_CLICK, PrintToConsole )
	
	var gameMenuButton = Hud_GetChild( menu, "GameMenuButton" )
	ToolTipData gameMenuToolTip
	gameMenuToolTip.descText = "Global Settings"
	Hud_SetToolTipData( gameMenuButton, gameMenuToolTip )
	HudElem_SetRuiArg( gameMenuButton, "icon", $"rui/menu/lobby/settings_icon" )
	HudElem_SetRuiArg( gameMenuButton, "shortcutText", "Global Settings" )
	Hud_AddEventHandler( gameMenuButton, UIE_CLICK, OpenGlobalSettings )
	
	array<var> challengesRows = GetElementsByClassname( file.menu, "ChallengeBtn" )
	foreach ( var elem in challengesRows ) 
	{
		RuiSetString( Hud_GetRui( elem ), "buttonText", "")
		Hud_SetEnabled( elem, false )
	}
}

void function HistoryUI_AddNewChallenge(string Name, int ShotsHit, string Weapon, float Accuracy, int dummiesKilled, int Damage, int totalshots, int criticalshots, int roundtime)
{
	string AccuracyShort = LocalizeAndShortenNumber_Float(Accuracy, 1, 2)
	if(AccuracyShort == "-na,n(i,nd).-n" || AccuracyShort == "-nan(ind)" || AccuracyShort == "-na.n(i.nd),-n") AccuracyShort = "0"

	ResultsHistory newChallenge
	newChallenge.ChallengeName = Name
	newChallenge.Kills = dummiesKilled
	newChallenge.ShotsHit = ShotsHit
	newChallenge.ChallengeWeapon = GetWeaponNameForUI(Weapon)//.toupper()
	newChallenge.ChallengeAccuracy = AccuracyShort
	newChallenge.Damage = Damage
	newChallenge.CriticalShots = criticalshots
	newChallenge.TotalShots = totalshots
	newChallenge.RoundTime = roundtime
	
	ChallengesHistory.push(newChallenge)
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

void function PrintToConsole(var button)
{
	DevTextBufferClear()
	DevTextBufferWrite("=== Aim Trainer v1.0 CSV Results Dump - Made by CaféDeColombiaFPS @CafeFPS === \n\n")
	DevTextBufferWrite("ChallengeName, ShotsHit, Kills, Weapon, Accuracy, Damage, CriticalShots, TotalShots, Roundtime \n")

	foreach(challenge in ChallengesHistory)
			DevTextBufferWrite( challenge.ChallengeName
					+", "+challenge.ShotsHit
					+", "+challenge.Kills
					+", "+challenge.ChallengeWeapon
					+", "+challenge.ChallengeAccuracy
					+", "+challenge.Damage
					+", "+challenge.CriticalShots
					+", "+challenge.TotalShots
					+", "+challenge.RoundTime + "\n")
					
	DevP4Checkout( "AimTrainer_Results_" + GetUnixTimestamp() + ".txt" )
	DevTextBufferDumpToFile( "AimTrainer_Results_" + GetUnixTimestamp() + ".txt" )
	
	Warning("[!] CSV RESULTS SAVED IN /r5reloaded/r2/ === ")
}

void function ChallengesButtonFunct(var button)
{
	CloseAllMenus()
	ChallengesHistory.reverse()
	RunClientScript("ServerCallback_OpenFRChallengesMainMenu", PlayerKillsForChallengesUI)
}

void function SettingsButtonFunct(var button)
{
	CloseAllMenus()
	ChallengesHistory.reverse()
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
	ChallengesHistory.reverse()
	RunClientScript("ServerCallback_OpenFRChallengesMainMenu", PlayerKillsForChallengesUI)
}

void function OpenGlobalSettings(var button)
{
    CloseAllMenus()
	ChallengesHistory.reverse()
	AdvanceMenu( GetMenu( "SystemMenu" ) )	
}
