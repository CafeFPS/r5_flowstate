untyped

global const SCOREBOARD_LOCAL_PLAYER_COLOR = <LOCAL_R / 255.0, LOCAL_G / 255.0, LOCAL_B / 255.0>
global const SCOREBOARD_PARTY_COLOR = <PARTY_R / 255.0, PARTY_G / 255.0, PARTY_B / 255.0>
const SCOREBOARD_FRIENDLY_COLOR = <FRIENDLY_R / 255.0, FRIENDLY_G / 255.0, FRIENDLY_B / 255.0>
const SCOREBOARD_FRIENDLY_SELECTED_COLOR = <0.6640625,0.7578125,0.85546875>
const SCOREBOARD_ENEMY_COLOR = <ENEMY_R / 255.0, ENEMY_G / 255.0, ENEMY_B / 255.0>
const SCOREBOARD_ENEMY_SELECTED_COLOR = <1.0,0.7019,0.592>
const SCOREBOARD_DEAD_FONT_COLOR = <0.7,0.7,0.7>
const SCOREBOARD_FFA_COLOR = <0.5,0.5,0.5>
const SCOREBOARD_BG_ALPHA = 0.35
const SCOREBOARD_EMPTY_COLOR = <0,0,0>
const SCOREBOARD_EMPTY_BG_ALPHA = 0.35

const SCOREBOARD_TITLE_HEIGHT = 50
const SCOREBOARD_SUBTITLE_HEIGHT = 35
const SCOREBOARD_FOOTER_HEIGHT = 35
const SCOREBOARD_TEAM_LOGO_OFFSET = 24
const SCOREBOARD_TEAM_LOGO_HEIGHT = 64
const SCOREBOARD_PLAYER_ROW_OFFSET = 12
const SCOREBOARD_PLAYER_ROW_HEIGHT = 35
const SCOREBOARD_PLAYER_ROW_SPACING = 2

const int MAX_TEAM_SLOTS = 16

const int MIC_STATE_NO_MIC = 0
const int MIC_STATE_HAS_MIC = 1
const int MIC_STATE_TALKING = 2
const int MIC_STATE_PARTY_HAS_MIC = 3
const int MIC_STATE_PARTY_TALKING = 4
const int MIC_STATE_MUTED = 5

global function ClScoreboardMp_Init
//global function ClScoreboardMp_GetGameTypeDescElem
global function ScoreboardFocus
global function ScoreboardLoseFocus
global function ScoreboardSelectPrevPlayer
global function ScoreboardSelectNextPlayer
//global function GetScoreBoardFooterRui
//global function SetScoreboardUpdateCallback
global function AddScoreboardCallback_OnShowing
global function AddScoreboardCallback_OnHiding
global function ScoreboardToggleFocus
global function ForceScoreboardLoseFocus
global function ForceScoreboardFocus

struct {
	bool hasFocus = false
	entity selectedPlayer
	entity prevPlayer
	entity nextPlayer

	var scoreboardBg
	var scoreboard
	var background
	var backgroundCustom
	var titleCustom
	var hintCustom
	
	array<var> scoreboardOverlays
	array<var> scoreboardElems

	table header = {
		background = null
		gametypeAndMap = null
		gametypeDesc = null
		scoreHeader = null
	}

	var footer
	var pingText

	table teamElems

	table highlightColumns

	var nameEndColumn

	table playerElems

	var scoreboardRUI

	void functionref(entity,var) scoreboardUpdateCallback
	array <void functionref()> scoreboardCallbacks_OnShowing
	array <void functionref()> scoreboardCallbacks_OnHiding
	
	bool bResetScoreboardIgnore
	int max_teams
} file

const array<int> IGNORE_SCORE_BOARD_RESET = 
[
	eGamemodes.SURVIVAL,
	eGamemodes.fs_aimtrainer
]

void function ClScoreboardMp_Init()
{
	clGlobal.initScoreboardFunc = InitScoreboardMP
	clGlobal.showScoreboardFunc = ShowScoreboardMP
	clGlobal.hideScoreboardFunc = HideScoreboardMP
	clGlobal.scoreboardInputFunc = ScoreboardInputMP

	// RegisterConCommandTriggeredCallback( "+scriptCommand4", ScoreboardToggleFocus )
	RegisterConCommandTriggeredCallback( "scoreboard_toggle_focus", ScoreboardToggleFocus )
	RegisterSignal( "ShutDownScoreboardRefresh" )
	
	AddClientCallback_OnResolutionChanged( ReInitScoreboard )
	file.bResetScoreboardIgnore = IGNORE_SCORE_BOARD_RESET.contains( Gamemode() )
	file.max_teams = GetCurrentPlaylistVarInt( "max_teams", MAX_TEAM_SLOTS )
}

void function ReInitScoreboard( )
{
	file.hasFocus = false
	thread clGlobal.hideScoreboardFunc()
	clGlobal.initScoreboardFunc()
}

void function ScoreboardFocus( entity player )
{ 
	thread ShowScoreboardMP()
	file.hasFocus = true
}

void function ScoreboardLoseFocus( entity player )
{
	thread HideScoreboardMP()
	file.hasFocus = false
}

void function ForceScoreboardLoseFocus()
{
	thread HideScoreboardMP()
	file.hasFocus = false
}

void function ForceScoreboardFocus()
{
	thread ShowScoreboardMP()
	file.hasFocus = true
}

void function ScoreboardToggleFocus( entity player )
{
	if ( file.hasFocus )
		ScoreboardLoseFocus( player )
	else
		ScoreboardFocus( player )
}

int function GetEnemyScoreboardTeam()
{
	return GetEnemyTeam( GetLocalClientPlayer().GetTeam() )
}

int function GetNumPlayersToDisplayAsATeam()
{
	if ( UseOnlyMyTeamScoreboard() )
		return GetCurrentPlaylistVarInt( "max_team_size", 1 )

	if ( UseSingleTeamScoreboard() )
		return 12

	return GetCurrentPlaylistVarInt( "max_team_size", 1 )
}

bool function ScoreboardEnabled()
{
	return GetCurrentPlaylistVarInt( "scoreboard_enabled", 0 ) == 1
}

void function InitScoreboardMP()
{
	entity localPlayer = GetLocalClientPlayer()
	int myTeam = TEAM_MULTITEAM_FIRST //localPlayer.GetTeam()
	// if ( myTeam == TEAM_SPECTATOR ) //To handle demos
	// {
		// myTeam = GetDefaultNonSpectatorTeam()
	// }
	string mapName = GetMapDisplayName( GetMapName() )

	var scoreboard = HudElement( "Scoreboard" )
	file.scoreboard = scoreboard

	file.backgroundCustom = HudElement( "FS_DMScoreboard_Frame" )
	file.titleCustom = HudElement( "FS_DMScoreboard_Title" )
	file.hintCustom = HudElement( "FS_DMScoreboard_Hint" )
	
	string title = "SCOREBOARD"

	Hud_SetText( file.titleCustom, title)

	Hud_SetVisible( file.backgroundCustom, false )
	Hud_SetVisible( file.titleCustom, false )
	Hud_SetVisible( file.hintCustom, false )

	RuiSetImage( Hud_GetRui( file.backgroundCustom ), "basicImage", $"rui/flowstate_custom/scoreboard_bg" )

	file.header.gametypeAndMap = HudElement( "ScoreboardGametypeAndMap", scoreboard )
	RuiSetString( Hud_GetRui( file.header.gametypeAndMap ), "gameType", "" )
	RuiSetString( Hud_GetRui( file.header.gametypeAndMap ), "mapName", "" )
	file.header.gametypeDesc = HudElement( "ScoreboardHeaderGametypeDesc", scoreboard )
	RuiSetString( Hud_GetRui( file.header.gametypeDesc ), "desc", "" )
	file.header.scoreHeader = HudElement( "ScoreboardScoreHeader", scoreboard )

	file.footer = HudElement( "ScoreboardGamepadFooter", scoreboard )
	file.pingText = HudElement( "ScoreboardPingText", scoreboard )
	
	file.scoreboardElems.clear()
	file.scoreboardElems.append( file.header.gametypeAndMap )
	file.scoreboardElems.append( file.header.gametypeDesc )
	file.scoreboardElems.append( file.header.scoreHeader )
	file.scoreboardElems.append( file.footer )
	file.scoreboardElems.append( file.pingText )

	int maxPlayerDisplaySlots = GetNumPlayersToDisplayAsATeam()
	//string localPlayerFactionChoice = GetFactionChoice( localPlayer )

	//First init my team's stuff
	file.playerElems[ myTeam ] <- []
	file.teamElems[ myTeam ] <- {
		logo = HudElement( "ScoreboardMyTeamLogo", scoreboard )
		score = HudElement( "ScoreboardMyTeamScore", scoreboard )
		//factionChoice = localPlayerFactionChoice
	}

	file.scoreboardElems.append( file.teamElems[ myTeam ].logo )
	file.scoreboardElems.append( file.teamElems[ myTeam ].score )
	for ( int elem = 0; elem < maxPlayerDisplaySlots; elem++ )
	{
		string elemNum = string( elem )

		table rowElementTable
		rowElementTable.background <- HudElement( "ScoreboardTeammateBackground" + elemNum, scoreboard )
		rowElementTable.background.Show()

		file.scoreboardElems.append( rowElementTable.background )

		file.playerElems[ myTeam ].append( rowElementTable )
	}

	if ( !UseSingleTeamScoreboard() )
	{
		RuiSetImage( Hud_GetRui( file.teamElems[ myTeam ].logo ), "logo", $"" )
	}

	array<int> enemyTeams
	if ( !UseOnlyMyTeamScoreboard() )
	{
		enemyTeams = GetAllEnemyTeams( myTeam )
		for ( int teamNum = 1; teamNum <= enemyTeams.len(); ++teamNum )
		{
			string teamNumberPrefix
			if ( UseSingleTeamScoreboard() )
			{
				teamNumberPrefix = "Team1"
			}
			else
			{
				teamNumberPrefix = "Team" + minint( teamNum, 4 )
			}

			int currentEnemyTeam = enemyTeams[teamNum - 1]
			file.teamElems[currentEnemyTeam] <-
			{
				logo = HudElement( "ScoreboardEnemy" + teamNumberPrefix + "Logo", scoreboard )
				score = HudElement( "ScoreboardEnemy" + teamNumberPrefix + "Score", scoreboard )
			}

			file.scoreboardElems.append( file.teamElems[currentEnemyTeam].logo )
			file.scoreboardElems.append( file.teamElems[currentEnemyTeam].score )

			file.playerElems[currentEnemyTeam] <- []
			for ( int elem = 0; elem < maxPlayerDisplaySlots; elem++ )
			{
				table rowElementTable
				rowElementTable.background <- HudElement( "ScoreboardOpponent" + teamNumberPrefix + "Background" + string( elem ), scoreboard )

				rowElementTable.background.Show()

				file.scoreboardElems.append( rowElementTable.background )

				file.playerElems[currentEnemyTeam].append( rowElementTable )
			}
		}
	}

	{
		file.header.gametypeAndMap.Hide()
		file.header.gametypeDesc.Hide()
	}

	if ( UseOnlyMyTeamScoreboard() )
	{
		file.teamElems[myTeam].logo.Show()
		file.teamElems[myTeam].score.Show()
	}
	else if ( UseSingleTeamScoreboard() )
	{
		file.teamElems[ myTeam ].logo.Hide()
		file.teamElems[ myTeam ].score.Hide()

		foreach ( enemyTeam in enemyTeams )
		{
			file.teamElems[ enemyTeam ].logo.Hide()
			file.teamElems[ enemyTeam ].score.Hide()
		}
	}
	else
	{
		file.teamElems[myTeam].logo.Show()
		file.teamElems[myTeam].score.Show()

		foreach ( enemyTeam in enemyTeams )
		{
			file.teamElems[ enemyTeam ].logo.Show()
			file.teamElems[ enemyTeam ].score.Show()
		}
	}
}

array<var> function CreateScoreboardOverlays()
{
	array<var> overlays

	switch ( GAMETYPE )
	{
		default:
			break
	}

	return overlays
}

void function ScoreboardFadeIn()
{
	foreach ( elem in file.scoreboardElems )
	{
		RuiSetGameTime( Hud_GetRui( elem ), "fadeOutStartTime", RUI_BADGAMETIME )
		RuiSetGameTime( Hud_GetRui( elem ), "fadeInStartTime", RUI_BADGAMETIME )
	}

	if ( file.scoreboardBg != null )
	{
		RuiSetGameTime( file.scoreboardBg, "fadeOutStartTime", RUI_BADGAMETIME )
		RuiSetGameTime( file.scoreboardBg, "fadeInStartTime", Time() )
	}
}

void function ScoreboardFadeOut()
{
	foreach ( elem in file.scoreboardElems )
	{
		RuiSetGameTime( Hud_GetRui( elem ), "fadeInStartTime", RUI_BADGAMETIME )
		RuiSetGameTime( Hud_GetRui( elem ), "fadeOutStartTime", Time() )
	}

	if ( file.scoreboardBg != null )
	{
		RuiSetGameTime( file.scoreboardBg, "fadeInStartTime", RUI_BADGAMETIME )
		RuiSetGameTime( file.scoreboardBg, "fadeOutStartTime", Time() )
	}
}

void function ShowScoreboardMP()
{	
	clGlobal.levelEnt.Signal( "ShutDownScoreboardRefresh" )
	clGlobal.levelEnt.EndSignal( "ShutDownScoreboardRefresh" )
	
	if( file.bResetScoreboardIgnore ) 
		return

	#if DEVELOPER
		printf("[SB] %s - %s\n", FUNC_NAME(), GameRules_GetGameMode())
	#endif
	
	foreach( void functionref() callbackFunc in file.scoreboardCallbacks_OnShowing )
		callbackFunc()

	entity localPlayer = GetLocalClientPlayer()
	
	Hud_SetVisible( file.backgroundCustom, true )
	Hud_SetVisible( file.titleCustom, true )
	// if( IsAlive( GetLocalClientPlayer() ) && GetCurrentPlaylistName() == "fs_haloMod" || IsAlive( GetLocalClientPlayer() ) && GetCurrentPlaylistName() == "fs_haloMod_oddball" || IsAlive( GetLocalClientPlayer() ) && GetCurrentPlaylistName() == "fs_1v1" && GetCurrentPlaylistName() == "fs_lgduels_1v1" )
	// {
		// Hud_SetVisible( file.hintCustom, true )
	// }
	// else
		Hud_SetVisible( file.hintCustom, false )
	
	//file.scoreboardBg = RuiCreate( $"ui/scoreboard_background.rpak", clGlobal.topoFullScreen, RUI_DRAW_HUD, 0 )
	file.scoreboardOverlays = CreateScoreboardOverlays()

	int myTeam = TEAM_MULTITEAM_FIRST // localPlayer.GetTeam()

	array<int> enemyTeams = GetAllEnemyTeams( myTeam )

	RuiSetGameTime( Hud_GetRui( file.footer ), "startFadeTime", Time() )
	RuiSetString( Hud_GetRui( file.footer ), "footerText", Localize( "#RIGHT_SCOREBOARD_FOCUS" ) )


	// EndSignal( clGlobal.signalDummy, "OnHideScoreboard" )

	UISize screenSize = GetScreenSize()
	float resMultX = screenSize.width / 1920.0
	float resMultY = screenSize.height / 1080.0

	int numTeams = file.max_teams
	Assert( numTeams >= 1 )
	int numPlayersOnATeam = GetNumPlayersToDisplayAsATeam()
	int totalTeamLogoOffset

	totalTeamLogoOffset = SCOREBOARD_TEAM_LOGO_OFFSET
	numTeams = 1

	int teamHeight = SCOREBOARD_TEAM_LOGO_HEIGHT + SCOREBOARD_PLAYER_ROW_OFFSET + ( SCOREBOARD_PLAYER_ROW_HEIGHT + SCOREBOARD_PLAYER_ROW_SPACING ) * numPlayersOnATeam - SCOREBOARD_PLAYER_ROW_SPACING
	int scoreboardHeight = SCOREBOARD_TITLE_HEIGHT + SCOREBOARD_SUBTITLE_HEIGHT + ( teamHeight * numTeams ) + totalTeamLogoOffset  + SCOREBOARD_FOOTER_HEIGHT

	//printt( "team height: " + teamHeight + ", scoreboardHeight: " + scoreboardHeight )
	int scoreboardYOffset = -int( ( ( 1080 - scoreboardHeight ) / 2 - 48 ) * resMultY )
	if ( UseSingleTeamScoreboard() )
		scoreboardYOffset += int( 85 * resMultY )

	int winningTeamYOffset = int( ( SCOREBOARD_SUBTITLE_HEIGHT + SCOREBOARD_TEAM_LOGO_OFFSET ) * resMultY )
	int teamHeightMultiplied = int( teamHeight * resMultY )
	//Changing losingTeamYOffset to 0 to help with squeezing more players on screen for survival squads
	int losingTeamYOffset =  0 //int(  SCOREBOARD_TEAM_LOGO_OFFSET  * resMultY )

	int footerYOffset = int( ( scoreboardHeight - SCOREBOARD_TITLE_HEIGHT - SCOREBOARD_FOOTER_HEIGHT + 36 ) * resMultY )

	//printt( "scoreboardYOffset: " + scoreboardYOffset + ", winningTeamYOffset: " + winningTeamYOffset + ", losingTeamYOffset" + losingTeamYOffset + ", footerYOffset" + footerYOffset)

	int index
	var elemTable

	table<int, array<entity> > teamPlayers
	teamPlayers[myTeam] <- []
	foreach ( enemyTeam in enemyTeams )
	{
		teamPlayers[enemyTeam] <- []
	}

	array<int> teamsSortedByScore = [ myTeam ]
	teamsSortedByScore.extend( enemyTeams )

	int winningTeam
	IntFromEntityCompare compareFunc = GetScoreboardCompareFunc()

	file.scoreboard.Show()

	//WHY THE FUCK DID THIS BREAK THE SCOREBOARD - AyeZeeBB
	ScoreboardFadeIn()

	int maxPlayerDisplaySlots = GetNumPlayersToDisplayAsATeam()
	bool firstUpdate = true

	while( true ) //TODO : revisit
	{
		localPlayer = GetLocalClientPlayer()

		Assert( clGlobal.isScoreboardShown )

		//if( IsAlive( GetLocalClientPlayer() ) && GetCurrentPlaylistName() == "fs_haloMod_ctf" || IsAlive( GetLocalClientPlayer() ) && GetCurrentPlaylistName() == "fs_haloMod" || IsAlive( GetLocalClientPlayer() ) && GetCurrentPlaylistName() == "fs_haloMod_oddball" || IsAlive( GetLocalClientPlayer() ) && GetCurrentPlaylistName() == "fs_1v1" && GetCurrentPlaylistName() == "fs_lgduels_1v1" )
		if( IsAlive( GetLocalClientPlayer() ) && Playlist() == ePlaylists.fs_haloMod_ctf || IsAlive( GetLocalClientPlayer() ) && Playlist() == ePlaylists.fs_haloMod || IsAlive( GetLocalClientPlayer() ) && Playlist() == ePlaylists.fs_haloMod_oddball || IsAlive( GetLocalClientPlayer() ) && Playlist() == ePlaylists.fs_1v1 && Playlist() == ePlaylists.fs_lgduels_1v1 )
		{
			Hud_SetVisible( file.hintCustom, true )
		}
		else
			Hud_SetVisible( file.hintCustom, false )

		if ( UseOnlyMyTeamScoreboard() )
		{
			teamPlayers[myTeam] = GetSortedPlayers( compareFunc, myTeam )

			winningTeam = myTeam

			if ( teamPlayers[myTeam].len() > 0 )
				RuiSetBool( Hud_GetRui( file.header.scoreHeader ), "winningTeamIsFriendly", teamPlayers[myTeam][0] == GetLocalClientPlayer() )
		}
		else if ( UseSingleTeamScoreboard() )
		{
			teamPlayers[myTeam] = GetSortedPlayers_FFA( compareFunc )
			foreach ( enemyTeam in enemyTeams )
			{
				teamPlayers[enemyTeam] = []
			}

			winningTeam = myTeam

			if ( teamPlayers[myTeam].len() > 0 )
				RuiSetBool( Hud_GetRui( file.header.scoreHeader ), "winningTeamIsFriendly", teamPlayers[myTeam][ 0 ] == GetLocalClientPlayer() )
		}
		else
		{
			teamPlayers[myTeam] = GetSortedPlayers( compareFunc, myTeam )
			foreach ( enemyTeam in enemyTeams )
			{
				teamPlayers[enemyTeam] = GetSortedPlayers( compareFunc, enemyTeam )
			}

			teamsSortedByScore.sort( CompareTeamScore )
			Assert( teamsSortedByScore.len() > 0 )
			winningTeam = teamsSortedByScore[ 0 ]
			if ( teamsSortedByScore[ 0 ] == myTeam )
			{
				RuiSetBool( Hud_GetRui( file.header.scoreHeader ), "winningTeamIsFriendly", true )
			}
			else
			{
				RuiSetBool( Hud_GetRui( file.header.scoreHeader ), "winningTeamIsFriendly", false )
			}
		}

		if ( UseOnlyMyTeamScoreboard() || UseSingleTeamScoreboard() )
		{
			file.header.gametypeAndMap.SetY( scoreboardYOffset )
			if( winningTeam in file.teamElems )
				file.teamElems[winningTeam].logo.SetY( winningTeamYOffset )
			file.footer.SetY( footerYOffset )
		}
		else
		{
			RuiSetInt( Hud_GetRui( file.teamElems[ winningTeam ].score ), "score", GameRules_GetTeamScore( winningTeam ) )
			file.teamElems[ winningTeam ].logo.SetY( winningTeamYOffset )

			for ( int i = 1; i < teamsSortedByScore.len(); ++i )
			{
				int losingTeam = teamsSortedByScore[ i ]
				RuiSetInt( Hud_GetRui( file.teamElems[losingTeam].score ), "score", GameRules_GetTeamScore( losingTeam ) )
				int calculatedOffSet = winningTeamYOffset + ( i * teamHeightMultiplied ) + losingTeamYOffset
				file.teamElems[losingTeam].logo.SetY(  calculatedOffSet  )
			}

			file.header.gametypeAndMap.SetY( scoreboardYOffset )
			file.footer.SetY( footerYOffset )
		}

		array<entity> allPlayers = []
		int selectedPlayerIndex = 0

		foreach ( team, players in teamPlayers )
		{
			index = 0

			if ( UseOnlyMyTeamScoreboard() && (team != myTeam) )
				continue

			foreach ( entity player in players )
			{
				if ( !IsValid( player ) )
					continue

				elemTable = file.playerElems[team][index]
				// Hud_SetWidth( elemTable.background, Hud_GetBaseWidth( elemTable.background ) * 1.25 )
				var rui = Hud_GetRui( elemTable.background )

				if ( player == file.selectedPlayer )
				{
					RuiSetFloat3( rui, "bgColor", IsFriendlyTeam( player.GetTeam(), myTeam ) ? SCOREBOARD_FRIENDLY_SELECTED_COLOR : SCOREBOARD_ENEMY_SELECTED_COLOR )
					RuiSetFloat( rui, "selectedAlpha", 1.0 )
					selectedPlayerIndex = allPlayers.len()
				}
				else
				{
					RuiSetFloat3( rui, "bgColor", IsFriendlyTeam( player.GetTeam(), myTeam ) ? SCOREBOARD_FRIENDLY_COLOR : SCOREBOARD_ENEMY_COLOR )
					RuiSetFloat( rui, "selectedAlpha", 0.0 )
				}

				//Overwrite color if player is dead
				bool playerIsAlive = IsAlive( player )
				if ( !playerIsAlive )
					RuiSetFloat3( rui, "bgColor", <0.5,0.5,0.5> )


				allPlayers.append( player )

				// Update player name and color
				string name = player.GetPlayerName()
				// if ( player.HasBadReputation() )
					// name = "* " + name

				RuiSetString( rui, "playerName", name )
				
				ItemFlavor character = LoadoutSlot_WaitForItemFlavor( ToEHI( player ), Loadout_CharacterClass() )
				asset classIcon      = CharacterClass_GetGalleryPortrait( character )
				RuiSetImage( rui, "playerCard", classIcon )

				if ( playerIsAlive )
					RuiSetFloat3( rui, "textColor", <1,1,1> )
				else
					RuiSetFloat3( rui, "textColor", SCOREBOARD_DEAD_FONT_COLOR )


				RuiSetInt( rui, "micState", MIC_STATE_NO_MIC )

				UpdateScoreboardForGamemode( player, rui, Hud_GetRui( file.header.scoreHeader ) )

				if ( file.scoreboardUpdateCallback != null )
					file.scoreboardUpdateCallback( player, rui )

				index++

				if ( index >= maxPlayerDisplaySlots )
					break

				if ( !firstUpdate )
					WaitFrame() //Only update 1 player a frame; loop takes too long otherwise on consoles
			}

			int reservedCount
			int connectingCount
			int loadingCount
			if ( UseSingleTeamScoreboard() )
			{
				reservedCount = GetTotalPendingPlayersReserved()
				connectingCount = GetTotalPendingPlayersConnecting()
				loadingCount = GetTotalPendingPlayersLoading()
			}
			else
			{
				reservedCount = GetTeamPendingPlayersReserved( team )
				connectingCount = GetTeamPendingPlayersConnecting( team )
				loadingCount = GetTeamPendingPlayersLoading( team )
			}

			if ( team > TEAM_UNASSIGNED && ( !UseSingleTeamScoreboard() || team == TEAM_MILITIA ) ) // if you run this block for both teams, then it will show players "connecting" for both teams
			{
				int numDone = 0
				for ( int idx = 0; idx < (reservedCount + connectingCount + loadingCount); idx++ )
				{
					if ( index >= maxPlayerDisplaySlots )
						continue

					elemTable = file.playerElems[team][index]

					if ( numDone < loadingCount )
						RuiSetString( Hud_GetRui( elemTable.background ), "playerName", Localize( "#PENDING_PLAYER_STATUS_LOADING" ) )
					else if ( numDone < (loadingCount + connectingCount) )
						RuiSetString( Hud_GetRui( elemTable.background ), "playerName", Localize( "#PENDING_PLAYER_STATUS_CONNECTING" ) )
					else
						RuiSetString( Hud_GetRui( elemTable.background ), "playerName", Localize( "#PENDING_PLAYER_STATUS_CONNECTING" ) )

					numDone++
					index++
				}
			}

			while ( index < maxPlayerDisplaySlots )
			{
				elemTable = file.playerElems[team][index]
				//Hud_SetWidth( elemTable.background, Hud_GetBaseWidth( elemTable.background ) * 1.25 )

				var rui = Hud_GetRui( elemTable.background )
				RuiSetString( rui, "playerName", "" )
				RuiSetImage( rui, "playerStatus", $"" )
				for ( int i=0; i<6; i++ )
					RuiSetImage( rui, "extraIcon" + i, $"" )
				RuiSetFloat3( rui, "bgColor", SCOREBOARD_EMPTY_COLOR )
				RuiSetFloat( rui, "bgAlpha", SCOREBOARD_EMPTY_BG_ALPHA )
				if ( (UseSingleTeamScoreboard()) && team != myTeam )
					RuiSetFloat( rui, "bgAlpha", 0.0 )
				RuiSetImage( rui, "playerCard", $"" )
				RuiSetInt( rui, "numScoreColumns", 0 )

				index++
			}
		}

		RuiSetInt( Hud_GetRui( file.pingText ), "ping", MyPing() )

		if ( allPlayers.len() )
		{
			file.prevPlayer = allPlayers[ (selectedPlayerIndex + allPlayers.len() - 1) % allPlayers.len() ]
			file.nextPlayer = allPlayers[ (selectedPlayerIndex + 1) % allPlayers.len() ]
		}
		else
		{
			file.prevPlayer = file.selectedPlayer
			file.nextPlayer = file.selectedPlayer
		}

		teamPlayers[ myTeam ].clear()

		foreach ( enemyTeam in enemyTeams )
		{
			teamPlayers[enemyTeam].clear()
		}

		firstUpdate = false
		
		wait 0.1
	}
}

//Todo: create standalone version for each mode and init for the mode. 
void function UpdateScoreboardForGamemode( entity player, var rowRui, var scoreHeaderRui )
{
	array<string> headers = GameMode_GetScoreboardColumnTitles( GAMETYPE )
	array<int> playerGameStats = GameMode_GetScoreboardColumnScoreTypes( GAMETYPE )
	array<int> numDigits = GameMode_GetScoreboardColumnNumDigits( GAMETYPE )

	Assert( headers.len() > 0 && headers.len() == playerGameStats.len() && headers.len() == numDigits.len() )

	//int scoreboardWidth = 570
	int playerScore1 = 0
	int playerScore2 = 0
	int playerScore3 = 0
	int playerScore4 = 0
	int playerScore1NumDigits = 2
	int playerScore2NumDigits = 2
	int playerScore3NumDigits = 2
	int playerScore4NumDigits = 2
	string playerScore1Header
	string playerScore2Header
	string playerScore3Header
	string playerScore4Header

	int numScoreColumns = headers.len()

	switch ( numScoreColumns )
	{
		case 4:
			playerScore4Header = headers[ 3 ]
			if (IsValid( player ))
			{
				playerScore4 = player.GetPlayerNetInt( "latency" )
			}
			playerScore4NumDigits = numDigits[ 3 ]

		case 3:
			playerScore3Header = headers[ 2 ]
			if (IsValid( player ))
			{
				if( Playlist() == ePlaylists.fs_dm_oddball || Playlist() == ePlaylists.fs_haloMod_oddball )
					playerScore3 = player.GetPlayerNetInt( "oddball_ballHeldTime" )
				else if( Gamemode() == eGamemodes.fs_snd ) 
					playerScore3 = player.GetPlayerNetInt( "defused" )
				else if( Playlist() == ePlaylists.fs_scenarios )
					playerScore3 = player.GetPlayerNetInt( "FS_Scenarios_PlayerScore" )
				else
					playerScore3 = player.GetPlayerNetInt( "damage" )
			}
			playerScore3NumDigits = numDigits[ 2 ]

		case 2:
			playerScore2Header = headers[ 1 ]
			if (IsValid( player ))
			{
				if( Gamemode() == eGamemodes.CUSTOM_CTF )
					playerScore2 = player.GetPlayerNetInt( "returns" )
				else if( Playlist() == ePlaylists.fs_lgduels_1v1 )
					playerScore2 = player.GetPlayerNetInt( "accuracy" )
				else if( Gamemode() == eGamemodes.fs_snd ) 
					playerScore2 = player.GetPlayerNetInt( "planted" )
				else if( Playlist() == ePlaylists.fs_scenarios )
					playerScore2 = player.GetPlayerNetInt( "FS_Scenarios_MatchesWins")
				else
					playerScore2 = player.GetPlayerNetInt( "deaths" )
			}
			playerScore2NumDigits = numDigits[ 1 ]

		case 1:
			playerScore1Header = headers[ 0 ]
			if (IsValid( player ))
			{
				if( Gamemode() == eGamemodes.CUSTOM_CTF )
					playerScore1 = player.GetPlayerNetInt( "captures" )
				else if( Playlist() == ePlaylists.fs_scenarios )
					playerScore1 = player.GetPlayerNetInt( "kills" ) //?
				else
					playerScore1 = player.GetPlayerNetInt( "kills" )
			}
			playerScore1NumDigits = numDigits[ 0 ]
	}

	RuiSetInt( rowRui, "numScoreColumns", numScoreColumns )
	RuiSetInt( rowRui, "playerScore1", playerScore1 )
	RuiSetInt( rowRui, "playerScore2", playerScore2 )
	RuiSetInt( rowRui, "playerScore3", playerScore3 )
	RuiSetInt( rowRui, "playerScore4", playerScore4 )
	RuiSetInt( rowRui, "playerScore1NumDigits", playerScore1NumDigits )
	RuiSetInt( rowRui, "playerScore2NumDigits", playerScore2NumDigits )
	RuiSetInt( rowRui, "playerScore3NumDigits", playerScore3NumDigits )
	RuiSetInt( rowRui, "playerScore4NumDigits", playerScore4NumDigits )
	RuiSetInt( scoreHeaderRui, "numScoreColumns", numScoreColumns )
	RuiSetString( scoreHeaderRui, "playerScore1Header", playerScore1Header )
	RuiSetString( scoreHeaderRui, "playerScore2Header", playerScore2Header )
	RuiSetString( scoreHeaderRui, "playerScore3Header", playerScore3Header )
	RuiSetString( scoreHeaderRui, "playerScore4Header", playerScore4Header )
	RuiSetInt( scoreHeaderRui, "playerScore1NumDigits", playerScore1NumDigits )
	RuiSetInt( scoreHeaderRui, "playerScore2NumDigits", playerScore2NumDigits )
	RuiSetInt( scoreHeaderRui, "playerScore3NumDigits", playerScore3NumDigits )
	RuiSetInt( scoreHeaderRui, "playerScore4NumDigits", playerScore4NumDigits )
}

void function HideScoreboardMP()
{
	clGlobal.levelEnt.Signal( "ShutDownScoreboardRefresh" )

	foreach( void functionref() callbackFunc in file.scoreboardCallbacks_OnHiding )
		callbackFunc()

	//if ( file.hasFocus )
		//HudInput_PopContext()
	
	Hud_SetVisible( file.backgroundCustom, false )
	Hud_SetVisible( file.titleCustom, false )
	Hud_SetVisible( file.hintCustom, false )

	ScoreboardFadeOut()
	
	WaitFrame()

	file.hasFocus = false
	file.selectedPlayer = null

	file.scoreboard.Hide()
	if ( file.scoreboardBg != null )
	{
		RuiDestroy( file.scoreboardBg )
		file.scoreboardBg = null
	}
	foreach ( overlay in file.scoreboardOverlays )
	{
		RuiDestroy( overlay )
	}
	file.scoreboardOverlays = []

	entity localPlayer = GetLocalClientPlayer()
	int myTeam = localPlayer.GetTeam()
	int enemyTeam = GetEnemyScoreboardTeam()
}

bool function ScoreboardInputMP( int key )
{
	if ( !ScoreboardEnabled() )
		return true

	Assert( clGlobal.isScoreboardShown )

	entity player = GetLocalClientPlayer()

	switch ( key )
	{
		case BUTTON_DPAD_UP:
			ScoreboardSelectPrevPlayer( player )
			return true

		case BUTTON_DPAD_DOWN:
			ScoreboardSelectNextPlayer( player )
			return true

		case BUTTON_Y:
			ShowPlayerProfile( file.selectedPlayer )
			return true

		case BUTTON_X:
			TogglePlayerVoiceMute( file.selectedPlayer )
			return true

		case BUTTON_DPAD_LEFT:
			ScoreboardLoseFocus( player )
			return true

		case BUTTON_A:
		case BUTTON_B:
		case BUTTON_SHOULDER_LEFT:
		case BUTTON_SHOULDER_RIGHT:
		case BUTTON_STICK_LEFT:
		case BUTTON_STICK_RIGHT:
		case BUTTON_TRIGGER_LEFT_FULL:
		case BUTTON_TRIGGER_RIGHT_FULL:
			ScoreboardLoseFocus( player )
			return false

		default:
			return false
	}

	unreachable
}

//var function ClScoreboardMp_GetGameTypeDescElem()
//{
//	return file.header.gametypeDesc
//}

bool function UseSingleTeamScoreboard()
{
	return true
}

bool function UseOnlyMyTeamScoreboard()
{
	// bool scoreboard_onlyMyTeam = bool( GetCurrentPlaylistVarInt( "scoreboard_onlyMyTeam", 0 ) )
	// if ( scoreboard_onlyMyTeam )
		// return true

	return false
}

void function ScoreboardSelectNextPlayer( entity player )
{
	if ( !file.hasFocus )
		return

	EmitSoundOnEntity( player, "menu_click" )
	file.selectedPlayer = file.nextPlayer
}

void function ScoreboardSelectPrevPlayer( entity player )
{
	if ( !file.hasFocus )
		return

	EmitSoundOnEntity( player, "menu_click" )
	file.selectedPlayer = file.prevPlayer
}

//var function GetScoreBoardFooterRui()
//{
//	return Hud_GetRui( file.footer )
//}

//void function SetScoreboardUpdateCallback( void functionref( entity, var ) func )
//{
//	file.scoreboardUpdateCallback = func
//}

void function AddScoreboardCallback_OnShowing( void functionref() func )
{
	file.scoreboardCallbacks_OnShowing.append( func )
}

void function AddScoreboardCallback_OnHiding( void functionref() func )
{
	file.scoreboardCallbacks_OnHiding.append( func )
}


void function ScoreboardProfile( entity player )
{
	if ( !file.hasFocus )
		return

	ShowPlayerProfile( file.selectedPlayer )
}

void function ScoreboardMute( entity player )
{
	if ( !file.hasFocus )
		return

	TogglePlayerVoiceMute( file.selectedPlayer )
}
