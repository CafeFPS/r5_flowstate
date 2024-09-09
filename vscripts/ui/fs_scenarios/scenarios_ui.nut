
global function InitScenariosMenu																			//mkos

global function UI_OpenScenariosStandingsMenu
global function UI_CloseScenariosStandingsMenu
global function UI_ScenariosTemplate_Init
global function UI_ScenariosStandings_Print

global function ServerCallback_SendScenariosStandings
global function ServerCallback_SignalScenariosStandings

global function Scenarios_ClientToUi_ScoreLeaders
global function Scenarios_SetScoreLeaders
global function Scenarios_ClearUiData


#if DEVELOPER
	global function DEV_SetData
#endif 

const int STANDINGS_GLOBAL	= 1
const int STANDINGS_ROUND 	= 2
const int MAX_SCORE_LEADERS	= 10

struct ClientRecapStruct
{
	int value 
	int count
}

//ui copy from: sh_gamemode_scenarios.nut
#if DEVELOPER 
	global enum FS_ScoreType 
	{ 
		PLAYERSCORE = -1,
		SURVIVAL_TIME, /* 0 */
		DOWNED, /* 1 */
		KILL, /* 2 */
		BONUS_DOUBLE_DOWNED, /* 3 */
		BONUS_TRIPLE_DOWNED, /* 4 */
		BONUS_TEAM_WIPE, /* 5 */
		TEAM_WIN, /* 6 */
		SOLO_WIN, /* 7 */
		PENALTY_DEATH, /* 8 */
		PENALTY_RING, /* 9 */
		PENALTY_DESERTER, /* 10 */
		BONUS_BECOMES_SOLO_PLAYER, /* 11 */
		BONUS_KILLED_SOLO_PLAYER, /* 12 */
	}
#endif

typedef StandingsTable table<int,ClientRecapStruct>

struct 
{
	var menu
	var footersPanel
	var scoreRecapsPanel
	var buttonPreviousRound
	var buttonAllRounds
	var scoreLeadersPanel
	
	table<int,string> scoreRuiFields
	table<int,string> totalsRuiFields
	
	table<int,var>	scoreRuiInstances
	table<int,var> totalsRuiInstances
	
	table<int,ClientRecapStruct> localPlayerGlobalStandings
	table<int,ClientRecapStruct> localPlayerRoundSettings
	
	table<int,var> playerNameRuis
	table<int,var> playerScoreRuis
	
	table<string,int> playerScoreLeaders
	
	bool isTransmitting
	bool bScoreLeadersUpdating

} file


void function InitScenariosMenu( var menu ) //need to add button events for controller
{	
	file.menu = menu
	
	file.scoreRecapsPanel 		= Hud_GetChild( menu, "ScoreRecapsPanel" )
	file.scoreLeadersPanel		= Hud_GetChild( menu, "ScoreLeadersPanel" )
	
	file.buttonPreviousRound 	= Hud_GetChild( file.scoreRecapsPanel, "PreviousRoundButton" )
	file.buttonAllRounds		= Hud_GetChild( file.scoreRecapsPanel, "AllRoundsButton" )
	
	AddButtonEventHandler( file.buttonPreviousRound, UIE_CLICK, PreviousRoundOnClick )
	AddButtonEventHandler( file.buttonAllRounds, UIE_CLICK, AllRoundsOnClick )
	
	SetMenuReceivesCommands( menu, false )
	SetGamepadCursorEnabled( menu, true )
	
	file.footersPanel = Hud_GetChild( menu, "FooterButtons" )
	
	AddMenuFooterOption( menu, LEFT, BUTTON_B, true, "#B_BUTTON_CLOSE", "#CLOSE", null )
	
	AddMenuEventHandler( menu, eUIEvent.MENU_OPEN, ScenariosStandingsMenuOnOpen )
	AddMenuEventHandler( menu, eUIEvent.MENU_CLOSE, ScenariosStandingsMenuOnClose )
	AddMenuEventHandler( menu, eUIEvent.MENU_NAVIGATE_BACK, ScenariosStandingsMenuOnNavBack )
	
	AddUICallback_LevelLoadingFinished( ReTransmitStandingsIfConnected ) //very important
}

void function UI_ScenariosTemplate_Init( int count )
{
	ClientRecapStruct recap
	
	for( int i = -1; i <= count; i++ )
	{
		file.localPlayerGlobalStandings[ i ] <- recap
		file.localPlayerRoundSettings[ i ] <- recap
		
		file.scoreRuiFields[ i ] <- "ScoreRow" + string( i )
		file.totalsRuiFields[ i ] <- "TotalsRow" + string( i )
	}
	
	foreach( int scoreType, string field in file.scoreRuiFields )
	{
		if( Hud_HasChild( file.scoreRecapsPanel, field ) )
			file.scoreRuiInstances[ scoreType ] <- Hud_GetChild( file.scoreRecapsPanel, field )
	}
	
	foreach( int scoreType, string field in file.totalsRuiFields )
	{
		if( Hud_HasChild( file.scoreRecapsPanel, field ) )
			file.totalsRuiInstances[ scoreType ] <- Hud_GetChild( file.scoreRecapsPanel, field )
	}
	
	
	for( int j = 0; j < MAX_SCORE_LEADERS; j++ )
	{
		string field = "PlayerNameRow" + string( j )
		
		if( Hud_HasChild( file.scoreLeadersPanel, field ) )
			file.playerNameRuis[ j ] <- Hud_GetChild( file.scoreLeadersPanel, field )
	}
	
	for( int j = 0; j < MAX_SCORE_LEADERS; j++ )
	{
		string field = "PlayerScoreRow" + string( j )
		
		if( Hud_HasChild( file.scoreLeadersPanel, field ) )
			file.playerScoreRuis[ j ] <- Hud_GetChild( file.scoreLeadersPanel, field )
	}
	
	file.playerScoreLeaders.clear()
}

void function Scenarios_ClearUiData()
{
	RemoveUICallback_LevelLoadingFinished( ReTransmitStandingsIfConnected )
}

void function ReTransmitStandingsIfConnected()
{
	if( Playlist() != ePlaylists.fs_scenarios ) //Todo(dw): manage ui callbacks better for mode
		return
	
	if( !CheckSafeClientRun() )
		return
		
	RunClientScript( "UpdateStandingsScriptsFromClient", false )
}

void function PreviousRoundOnClick( var button )
{
	SetIsSelected( button, true )
	SetIsSelected( file.buttonAllRounds, false )
	
	HudElem_SetRuiArg( button, "solidBackground", true )
	HudElem_SetRuiArg( file.buttonAllRounds, "solidBackground", false )

	UpdateStandingsBoard( STANDINGS_ROUND )
}

void function AllRoundsOnClick( var button )
{
	SetIsSelected( button, true )
	SetIsSelected( file.buttonPreviousRound, false )
		
	HudElem_SetRuiArg( button, "solidBackground", true )
	HudElem_SetRuiArg( file.buttonPreviousRound, "solidBackground", false )
		
	UpdateStandingsBoard( STANDINGS_GLOBAL )
}

void function UI_OpenScenariosStandingsMenu()
{
	CloseAllMenus()
	ScoreLeadersOnOpen()
	AdvanceMenu( file.menu )
}

void function Scenarios_ClientToUi_ScoreLeaders( string name, int score )
{
	//this should have been cleared already in logic flow.
	file.playerScoreLeaders[ name ] <- score
}

void function Scenarios_SetScoreLeaders()
{
	int scoreLeadersTblLen = file.playerScoreLeaders.len()
	
	if( scoreLeadersTblLen < MAX_SCORE_LEADERS )
	{
		for( int i = scoreLeadersTblLen - 1; i < MAX_SCORE_LEADERS; i++ )
			file.playerScoreLeaders[ TableIndent( i ) ] <- 0
	}
	
	int j = 0
	foreach( string playerName, int score in file.playerScoreLeaders ) 
	{
		Hud_SetText( Scenarios_FetchNameRuiForPlacement( j ), playerName )
		
		string value
		if( playerName.find( " " ) != -1 || playerName == "" )
			value = " "
		else
			value = string( score )
			
		Hud_SetText( Scenarios_FetchScoreRuiForPlacement( j ), value )
		
		j++
		
		if( j == MAX_SCORE_LEADERS )
			break
	}
	
	file.playerScoreLeaders.clear()
	file.bScoreLeadersUpdating = false
}

//these should always return a valid placement rui with correct logic flow.
var function Scenarios_FetchNameRuiForPlacement( int placement )
{
	return file.playerNameRuis[ placement ]
}

var function Scenarios_FetchScoreRuiForPlacement( int placement )
{
	return file.playerScoreRuis[ placement ]
}

void function ScoreLeadersOnOpen()
{
	if( !CheckSafeClientRun() )
		return 
	
	file.bScoreLeadersUpdating = true
	file.playerScoreLeaders.clear()
	
	RunClientScript( "Scenarios_SendPlayerScoreLeaders" )
}

void function UI_CloseScenariosStandingsMenu()
{
	CloseAllMenus()
}

void function ScenariosStandingsMenuOnOpen()
{
	
}

void function ScenariosStandingsMenuOnClose()
{
}

void function ScenariosStandingsMenuOnNavBack()
{
	UI_CloseScenariosStandingsMenu()
}

void function ServerCallback_SendScenariosStandings( int standingType, int scoreType, int value, int count )
{
	if( !file.isTransmitting )
		file.isTransmitting = true
		
	ClientRecapStruct recap
	
	recap.value = value
	recap.count = count //probably should just calculate on client
	
	switch( standingType )
	{
		case STANDINGS_GLOBAL:
			file.localPlayerGlobalStandings[ scoreType ] = recap
			break
			
		case STANDINGS_ROUND:
			file.localPlayerRoundSettings[ scoreType ] = recap
			break 
			
		default:
			mAssert( false, "Server specified an incorrect standings type during recap transmission" )
	}
}

ClientRecapStruct function Scenarios_GetLocalStanding( int standingType, int scoreType )
{
	ClientRecapStruct inval
	
	switch( standingType )
	{
		case STANDINGS_GLOBAL:
			return file.localPlayerGlobalStandings[ scoreType ]			
			break 
			
		case STANDINGS_ROUND:
			return file.localPlayerRoundSettings[ scoreType ]
			break
			
		default:
			mAssert( false, "Server specified an incorrect standings type during recap transmission" )
			break
	}
	
	return inval
}

void function UI_ScenariosStandings_Print()
{
	#if DEVELOPER
		foreach( int scoreType, ClientRecapStruct data in file.localPlayerGlobalStandings )
			printt( "GLOBAL scoreType =", GetEnumString( "FS_ScoreType", scoreType ), "-- score:", data.value, "--Totals:", data.count )
			
		foreach( int scoreType, ClientRecapStruct data in file.localPlayerRoundSettings )
			printt( "ROUND scoreType =", GetEnumString( "FS_ScoreType", scoreType ), "-- score:", data.value, "--Totals:", data.count )
	#endif
}

void function ServerCallback_SignalScenariosStandings()
{
	file.isTransmitting = false		
	//entity player = GetLocalClientPlayer()	
	
	#if DEVELOPER
		UI_ScenariosStandings_Print()
	#endif
	
	UpdateStandingsBoard( STANDINGS_ROUND )
}

void function UpdateStandingsBoard( int type )
{
	if( file.isTransmitting )
		return
		
	foreach( int scoreType, var instance in file.scoreRuiInstances )
		Hud_SetText( instance, string( Scenarios_GetLocalStanding( type, scoreType ).value ) )
	
	foreach( int scoreType, var instance in file.totalsRuiInstances )
		Hud_SetText( instance, string( Scenarios_GetLocalStanding( type, scoreType ).count ) )
}

void function SetIsSelected( var button, bool enabled )
{
	if ( !IsValid( button ) )
		return

	Hud_SetSelected( button, enabled )
}

bool function CheckSafeClientRun()
{
	if( IsLobby() )
		return false
		
	if( !IsFullyConnected() )
		return false
	
	if( !CanRunClientScript() )
		return false 
		
	return true
}

#if DEVELOPER 

	void function DEV_SetData()
	{
		foreach( int scoreType, ClientRecapStruct recap in file.localPlayerRoundSettings )
		{
			ClientRecapStruct mockRecap
			
			mockRecap.value = RandomIntRange( 1, 500 )
			mockRecap.count = RandomIntRange( 1, 500 )

			file.localPlayerRoundSettings[ scoreType ] = mockRecap
			
			printt( "set scoreType of \"" + scoreType + "\" to value =", mockRecap.value, "count=", mockRecap.count )
		}
	}

#endif 