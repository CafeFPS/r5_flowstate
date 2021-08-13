global function InitPlayPanel

global function IsPlayPanelCurrentlyTopLevel
global function PlayPanelUpdate
global function ClientToUI_PartyMemberJoinedOrLeft
global function GetModeSelectButton
global function GetLobbyChatBox

global function Lobby_GetPlaylists
global function Lobby_GetSelectedPlaylist
global function Lobby_IsPlaylistAvailable
global function Lobby_SetSelectedPlaylist
global function Lobby_OnGamemodeSelectV2Close
global function Lobby_UpdateLoadscreenFromPlaylist

global function Lobby_GetPlaylistState
global function Lobby_GetPlaylistStateString

global function Lobby_UpdatePlayPanelPlaylists

global function CanInvite

global function UpdateMiniPromoPinning
global function UpdateLootBoxButton
global function PartyHasEliteAccess
global function ForceElitePlaylist
global function ForceNonElitePlaylist

global function ShouldShowMatchmakingDelayDialog
global function ShowMatchmakingDelayDialog
global function ShouldShowLastGameRankedAbandonForgivenessDialog
global function ShowLastGameRankedAbandonForgivenessDialog
global function PulseModeButton

#if R5DEV
global function DEV_PrintPartyInfo
global function DEV_PrintUserInfo
global function Lobby_MovePopupMessage
global function Lobby_ShowBattlePassPopup
#endif

const string SOUND_BP_POPUP             = "UI_Menu_BattlePass_PopUp"

const string SOUND_START_MATCHMAKING_1P = "UI_Menu_ReadyUp_1P"
const string SOUND_STOP_MATCHMAKING_1P  = "UI_Menu_ReadyUp_Cancel_1P"
const string SOUND_START_MATCHMAKING_3P = "UI_Menu_ReadyUp_3P"
const string SOUND_STOP_MATCHMAKING_3P  = "UI_Menu_ReadyUp_Cancel_3P"

const float INVITE_LAST_TIMEOUT          = 15.0
const float INVITE_LAST_PANEL_EXPIRATION = 1 * MINUTES_PER_HOUR * SECONDS_PER_MINUTE
global enum ePlaylistState
{
	AVAILABLE,
	NO_PLAYLIST,
	TRAINING_REQUIRED,
	COMPLETED_TRAINING_REQUIRED,
	PARTY_SIZE_OVER,
	LOCKED,
	ELITE_ACCESS_REQUIRED,
	RANKED_LEVEL_REQUIRED,
	RANKED_MATCH_ABANDON_DELAY,
	_COUNT
}


const table< int, string > playlistStateMap = {
	[ ePlaylistState.NO_PLAYLIST ]                 = "#PLAYLIST_STATE_NO_PLAYLIST",
	[ ePlaylistState.TRAINING_REQUIRED ]           = "#PLAYLIST_STATE_TRAINING_REQUIRED",
	[ ePlaylistState.COMPLETED_TRAINING_REQUIRED ] = "#PLAYLIST_STATE_COMLETED_TRAINING_REQUIRED",
	[ ePlaylistState.AVAILABLE ]                   = "#PLAYLIST_STATE_AVAILABLE",
	[ ePlaylistState.PARTY_SIZE_OVER ]             = "#PLAYLIST_STATE_PARTY_SIZE_OVER",
	[ ePlaylistState.LOCKED ]                      = "#PLAYLIST_STATE_LOCKED",
	[ ePlaylistState.ELITE_ACCESS_REQUIRED ]       = "#PLAYLIST_STATE_ELITE_REQUIRED",
	[ ePlaylistState.RANKED_LEVEL_REQUIRED ]       = "#PLAYLIST_STATE_RANKED_LEVEL_REQUIRED",
	[ ePlaylistState.RANKED_MATCH_ABANDON_DELAY ]  = "#RANKED_ABANDON_PENALTY_PLAYLIST_STATE"
}

const string PLAYLIST_TRAINING = "survival_training"

struct
{
	var panel
	var chatBox
	var chatroomMenu
	var chatroomMenu_chatroomWidget

	var fillButton
	var modeButton
	var gamemodeSelectV2Button
	var readyButton
	var trainingButton
	var inviteFriendsButton0
	var inviteFriendsButton1
	var inviteLastPlayedHeader
	var inviteLastPlayedUnitFrame0
	var inviteLastPlayedUnitFrame1
	var friendButton0
	var friendButton1
	var selfButton
	var allChallengesButton

	var hdTextureProgress

	int lastExpireTime

	string lastVisiblePlaylistValue

	array<string> playlists
	string        selectedPlaylist

	bool personInLeftSpot = false
	bool personInRightSlot = false

	Friend& friendInLeftSpot
	Friend& friendInRightSpot

	string lastPlayedPlayerPlatformUid0 = ""
	string lastPlayedPlayerHardware0 = ""
	string lastPlayedPlayerPlatformUid1 = ""
	string lastPlayedPlayerHardware1 = ""
	int    lastPlayedPlayerPersistenceIndex0 = -1
	int    lastPlayedPlayerPersistenceIndex1 = -1
	float  lastPlayedPlayerInviteSentTimestamp0 = -1
	float  lastPlayedPlayerInviteSentTimestamp1 = -1


	bool leftWasReady = false
	bool rightWasReady = false

	bool fullInstallNotification = false

	bool wasReady = false

	bool  haveShownSelfMatchmakingDelay = false
	bool  haveShownPartyMemberMatchmakingDelay = false
	bool  haveShownLastGameRankedAbandonForgivenessDialog = false
	int   lobbyRankTier = -1
	bool  rankedInitialized = false
	float currentMaxMatchmakingDelayEndTime = -1

	string lastPlaylistDisplayed
} file

void function InitPlayPanel( var panel )
{
	file.panel = panel
	SetPanelTabTitle( panel, "#PLAY" )
	AddPanelEventHandler( panel, eUIEvent.PANEL_SHOW, PlayPanel_OnShow )
	AddPanelEventHandler( panel, eUIEvent.PANEL_HIDE, PlayPanel_OnHide )
	AddPanelEventHandler( panel, eUIEvent.PANEL_NAVBACK, PlayPanel_OnNavBack )

	SetPanelInputHandler( panel, BUTTON_Y, ReadyShortcut_OnActivate )

	file.fillButton = Hud_GetChild( panel, "FillButton" )
	Hud_AddEventHandler( file.fillButton, UIE_CLICK, FillButton_OnActivate )

	file.modeButton = Hud_GetChild( panel, "ModeButton" )
	Hud_AddEventHandler( file.modeButton, UIE_CLICK, ModeButton_OnActivate )

	file.gamemodeSelectV2Button = Hud_GetChild( panel, "GamemodeSelectV2Button" )
	Hud_AddEventHandler( file.gamemodeSelectV2Button, UIE_CLICK, GameModeSelectV2Button_OnActivate )
	Hud_AddEventHandler( file.gamemodeSelectV2Button, UIE_GET_FOCUS, GameModeSelectV2Button_OnGetFocus )
	Hud_AddEventHandler( file.gamemodeSelectV2Button, UIE_LOSE_FOCUS, GameModeSelectV2Button_OnLoseFocus )
	Hud_SetVisible( file.gamemodeSelectV2Button, false )

	file.readyButton = Hud_GetChild( panel, "ReadyButton" )
	Hud_AddEventHandler( file.readyButton, UIE_CLICK, ReadyButton_OnActivate )

	file.inviteFriendsButton0 = Hud_GetChild( panel, "InviteFriendsButton0" )
	Hud_AddEventHandler( file.inviteFriendsButton0, UIE_CLICK, InviteFriendsButton_OnActivate )

	file.inviteFriendsButton1 = Hud_GetChild( panel, "InviteFriendsButton1" )
	Hud_AddEventHandler( file.inviteFriendsButton1, UIE_CLICK, InviteFriendsButton_OnActivate )

	file.inviteLastPlayedHeader = Hud_GetChild( panel, "InviteLastSquadHeader" )
	Hud_Hide( file.inviteLastPlayedHeader )

	file.inviteLastPlayedUnitFrame0 = Hud_GetChild( panel, "InviteLastPlayedUnitframe0" )
	Hud_AddEventHandler( file.inviteLastPlayedUnitFrame0, UIE_CLICK, InviteLastPlayedButton_OnActivate )
	Hud_AddEventHandler( file.inviteLastPlayedUnitFrame0, UIE_CLICKRIGHT, InviteLastPlayedButton_OnRightClick )
	Hud_Hide( file.inviteLastPlayedUnitFrame0 )

	file.inviteLastPlayedUnitFrame1 = Hud_GetChild( panel, "InviteLastPlayedUnitframe1" )
	Hud_AddEventHandler( file.inviteLastPlayedUnitFrame1, UIE_CLICK, InviteLastPlayedButton_OnActivate )
	Hud_AddEventHandler( file.inviteLastPlayedUnitFrame1, UIE_CLICKRIGHT, InviteLastPlayedButton_OnRightClick )
	Hud_Hide( file.inviteLastPlayedUnitFrame1 )

	file.selfButton = Hud_GetChild( panel, "SelfButton" )
	Hud_AddEventHandler( file.selfButton, UIE_CLICK, FriendButton_OnActivate )

	file.friendButton0 = Hud_GetChild( panel, "FriendButton0" )
	Hud_AddEventHandler( file.friendButton0, UIE_CLICK, FriendButton_OnActivate )
	Hud_AddEventHandler( file.friendButton0, UIE_CLICKRIGHT, FriendButton_OnRightClick )

	file.friendButton1 = Hud_GetChild( panel, "FriendButton1" )
	Hud_AddEventHandler( file.friendButton1, UIE_CLICK, FriendButton_OnActivate )
	Hud_AddEventHandler( file.friendButton1, UIE_CLICKRIGHT, FriendButton_OnRightClick )

	file.allChallengesButton = Hud_GetChild( panel, "AllChallengesButton" )
	//Hud_SetVisible( file.allChallengesButton, true )
	//Hud_SetEnabled( file.allChallengesButton, true )
	HudElem_SetRuiArg( file.allChallengesButton, "buttonText", Localize( "#CHALLENGES_LOBBY_BUTTON" ) )
	Hud_AddEventHandler( file.allChallengesButton, UIE_CLICK, AllChallengesButton_OnActivate )

	Hud_AddEventHandler( Hud_GetChild( file.panel, "PopupMessage" ), UIE_CLICK, OnClickBPPopup )

	AddMenuVarChangeHandler( "isMatchmaking", UpdateLobbyButtons )

	file.chatBox = Hud_GetChild( panel, "ChatRoomTextChat" )
	file.hdTextureProgress = Hud_GetChild( panel, "HDTextureProgress" )

	var chatTextEntry = Hud_GetChild( Hud_GetChild( file.chatBox, "ChatInputLine" ), "ChatInputTextEntry" )
	Hud_SetNavUp( chatTextEntry, chatTextEntry )

	InitMiniPromo( Hud_GetChild( panel, "MiniPromo" ) )

	RegisterSignal( "UpdateFriendButtons" )
	RegisterSignal( "BP_PopupThink" )
	RegisterSignal( "Lobby_ShowBattlePassPopup" )

	var eliteBadge = Hud_GetChild( file.panel, "EliteBadge" )
	Hud_AddEventHandler( eliteBadge, UIE_CLICK, OpenEliteIntroMenuNonAnimated )

	var aboutButton = Hud_GetChild( file.panel, "AboutButton" )
	Hud_AddEventHandler( aboutButton, UIE_CLICK, OpenAboutGameModePage )

	var rankedBadge = Hud_GetChild( file.panel, "RankedBadge" )
	Hud_AddEventHandler( rankedBadge, UIE_CLICK, OpenRankedInfoPage )
	AddUICallback_OnLevelInit( Ranked_OnLevelInit )
	AddCallback_OnPartyMemberAdded( TryShowMatchmakingDelayDialog )
	AddCallback_OnPartyMemberRemoved( UpdateCurrentMaxMatchmakingDelayEndTime )
}


bool function IsPlayPanelCurrentlyTopLevel()
{
	return GetActiveMenu() == GetMenu( "LobbyMenu" ) && IsPanelActive( file.panel )
}


void function UpdateLastPlayedPlayerInfo()
{
	array<string> curPartyMemberUids
	file.lastPlayedPlayerPlatformUid0 = ""
	file.lastPlayedPlayerHardware0 = ""
	file.lastPlayedPlayerPersistenceIndex0 = -1

	file.lastPlayedPlayerPlatformUid1 = ""
	file.lastPlayedPlayerHardware1 = ""
	file.lastPlayedPlayerPersistenceIndex1 = -1


	if ( !IsPersistenceAvailable() || !InviteLastPlayedPanelShouldBeVisible() )
	{
		return
	}

	int maxTrackedSquadMembers = PersistenceGetArrayCount( "lastGameSquadStats" )
	foreach ( index, member in GetParty().members )
	{
		curPartyMemberUids.append( member.uid )
	}

	for ( int i = 0; i < maxTrackedSquadMembers; i++ )
	{
		string lastPlayedPlayerUid      = expect string( GetPersistentVar( "lastGameSquadStats[" + i + "].platformUid" ) )
		string lastPlayedPlayerHardware = expect string( GetPersistentVar( "lastGameSquadStats[" + i + "].hardware" ) )

		if ( lastPlayedPlayerUid == "" || lastPlayedPlayerHardware == "" )
		{
			continue
		}

		if ( !curPartyMemberUids.contains( lastPlayedPlayerUid ) )
		{
			if ( file.lastPlayedPlayerPlatformUid0 == "" )
			{
				file.lastPlayedPlayerPlatformUid0 = lastPlayedPlayerUid
				file.lastPlayedPlayerHardware0 = lastPlayedPlayerHardware
				file.lastPlayedPlayerPersistenceIndex0 = i
			}
			else if ( file.lastPlayedPlayerPlatformUid1 == "" && lastPlayedPlayerUid != file.lastPlayedPlayerPlatformUid0 )
			{
				file.lastPlayedPlayerPlatformUid1 = lastPlayedPlayerUid
				file.lastPlayedPlayerHardware1 = lastPlayedPlayerHardware
				file.lastPlayedPlayerPersistenceIndex1 = i
			}
		}
	}
}


bool function InviteLastPlayedPanelShouldBeVisible()
{
	//if ( GetUnixTimestamp() - GetPersistentVarAsInt( "lastGameTime" ) > INVITE_LAST_PANEL_EXPIRATION )
	//	return false

	//if ( GetPersistentVarAsInt( "lastGamePlayers" ) == 0 && GetPersistentVarAsInt( "lastGameSquads" ) == 0 )
	//	return false

	return false
}


bool function PlayerIsInMatch( string playerPlatformUid, string playerHardware )
{
	CommunityUserInfo ornull userInfoOrNull = GetUserInfo( playerHardware, playerPlatformUid )
	if ( userInfoOrNull != null )
	{
		CommunityUserInfo userInfo = expect CommunityUserInfo(userInfoOrNull)
		return userInfo.charData[ePlayerStryderCharDataArraySlots.PLAYER_IN_MATCH] == 1
	}
	return false
}


var function GetModeSelectButton()
{
	return file.modeButton
}


var function GetLobbyChatBox()
{
	return file.chatBox
}


void function PlayPanel_OnShow( var panel )
{
	//UI_SetPresentationType( ePresentationType.PLAY )

	if ( IsFullyConnected() )
	{
		AccessibilityHint( eAccessibilityHint.LOBBY_CHAT )
		Lobby_UpdatePlayPanelPlaylists()
	}

	UpdateFillButtonVisibility()
	UpdateLobbyButtons()

	if ( file.chatroomMenu )
	{
		Hud_Hide( file.chatroomMenu )
		Hud_Hide( file.chatroomMenu_chatroomWidget )
	}
	AddCallbackAndCallNow_OnGRXInventoryStateChanged( UpdatePlayPanelGRXDependantElements )
	AddCallbackAndCallNow_OnGRXInventoryStateChanged( UpdateFriendButtons )
	AddCallbackAndCallNow_RemoteMatchInfoUpdated( OnRemoteMatchInfoUpdated )

	ClientCommand( "ViewingMainLobbyPage" )

	MiniPromo_Start()

	UI_SetPresentationType( ePresentationType.PLAY )

	thread TryPopupEliteMessage()

	bool newPlaylistSelect = GamemodeSelectV2_IsEnabled()
	if ( newPlaylistSelect )
	{
		Hud_SetNavUp( file.readyButton, file.gamemodeSelectV2Button )
	}
	else
	{
		Hud_SetNavUp( file.readyButton, file.modeButton )
	}

	thread TryRunDialogFlowThread()
	thread Lobby_ShowBattlePassPopup()
}



void function TryPopupEliteMessage()
{
}


void function UpdateLobbyButtons()
{
	if ( !IsConnected() )
		return

	UpdateFillButton()
	UpdateReadyButton()
	UpdateModeButton()
	UpdateFriendButtons()
	UpdateLastPlayedButtons()
	UpdatePlaylistBadges()
}


void function UpdateHDTextureProgress()
{
	// for some reason we can't do rui tracks in ui script?
	HudElem_SetRuiArg( file.hdTextureProgress, "hdTextureProgress", GetGameFullyInstalledProgress() )
	HudElem_SetRuiArg( file.hdTextureProgress, "hdTextureNeedsReboot", HasNonFullyInstalledAssetsLoaded() )

	if ( ShowDownloadCompleteDialog() )
	{
		ConfirmDialogData data
		data.headerText = "#TEXTURE_STREAM_REBOOT_HEADER"
		data.messageText = "#TEXTURE_STREAM_REBOOT_MESSAGE"
		data.yesText = ["#TEXTURE_STREAM_REBOOT", "#TEXTURE_STREAM_REBOOT_PC"]
		data.noText = ["#B_BUTTON_CANCEL", "#CANCEL"]

		data.resultCallback = void function ( int result ) : ()
		{
			if ( result == eDialogResult.YES )
			{
				// hd textured fully loaded, return to the main menu
				ClientCommand( "disconnect" )
			}

			return
		}

		OpenConfirmDialogFromData( data )
		file.fullInstallNotification = true
	}
}


void function UpdateFillButtonVisibility()
{
	if ( GetCurrentPlaylistVarBool( "enable_teamNoFill", false ) )
	{
		Hud_SetVisible( file.fillButton, true )
		Hud_SetNavUp( file.modeButton, file.fillButton )
		Hud_SetNavDown( file.inviteFriendsButton0, file.fillButton )
		Hud_SetNavLeft( file.inviteFriendsButton0, file.fillButton )
	}
	else
	{
		Hud_SetVisible( file.fillButton, false )
		Hud_SetNavUp( file.modeButton, file.inviteFriendsButton0 )

		var buttonToLink = file.modeButton
		if ( GamemodeSelectV2_IsEnabled() )
			buttonToLink = file.gamemodeSelectV2Button

		Hud_SetNavDown( file.inviteFriendsButton0, buttonToLink )
		Hud_SetNavLeft( file.inviteFriendsButton0, buttonToLink )
	}
}


void function UpdateLastSquadDpadNav()
{
	var buttonBeneathLastSquadPanel = file.modeButton

	if ( Hud_IsVisible( file.gamemodeSelectV2Button ) )
	{
		buttonBeneathLastSquadPanel = file.gamemodeSelectV2Button
	}

	if ( Hud_IsVisible( file.fillButton ) )
	{
		buttonBeneathLastSquadPanel = file.fillButton
	}

	bool isVisibleButton0 = Hud_IsVisible( file.inviteLastPlayedUnitFrame0 )
	bool isVisibleButton1 = Hud_IsVisible( file.inviteLastPlayedUnitFrame1 )

	if ( isVisibleButton0 )
	{
		Hud_SetNavDown( file.inviteLastPlayedUnitFrame0, buttonBeneathLastSquadPanel )
		Hud_SetNavUp( buttonBeneathLastSquadPanel, file.inviteLastPlayedUnitFrame0 )
		Hud_SetNavLeft( file.inviteFriendsButton0, file.inviteLastPlayedUnitFrame0 )
		Hud_SetNavRight( file.inviteLastPlayedUnitFrame0, file.inviteFriendsButton0 )

		if ( isVisibleButton1 )
		{
			Hud_SetNavDown( file.inviteLastPlayedUnitFrame1, buttonBeneathLastSquadPanel )
			Hud_SetNavUp( buttonBeneathLastSquadPanel, file.inviteLastPlayedUnitFrame1 )

			Hud_SetNavDown( file.inviteLastPlayedUnitFrame0, file.inviteLastPlayedUnitFrame1 )
		}
	}
	else
	{
		Hud_SetNavUp( buttonBeneathLastSquadPanel, file.inviteFriendsButton0 )
		Hud_SetNavDown( file.inviteFriendsButton0, buttonBeneathLastSquadPanel )
		Hud_SetNavLeft( file.inviteFriendsButton0, buttonBeneathLastSquadPanel )
		Hud_SetNavRight( buttonBeneathLastSquadPanel, file.inviteFriendsButton0 )
	}
}


bool function ShowDownloadCompleteDialog()
{
	if ( GetGameFullyInstalledProgress() != 1 )
		return false

	if ( !HasNonFullyInstalledAssetsLoaded() )
		return false

	if ( file.fullInstallNotification )
		return false

	if ( GetActiveMenu() != GetMenu( "LobbyMenu" ) )
		return false

	if ( GetPersistentVar( "showGameSummary" ) && IsPostGameMenuValid( true ) )
		return false

	return true
}


array<string> function Lobby_GetPlaylists()
{
	return file.playlists
}


string function Lobby_GetSelectedPlaylist()
{
	bool isLeader       = IsPartyLeader()
	string playlistName = isLeader ? file.selectedPlaylist : GetParty().playlistName
	return playlistName
}


bool function Lobby_IsPlaylistAvailable( string playlistName )
{
	return Lobby_GetPlaylistState( playlistName ) == ePlaylistState.AVAILABLE
}


void function Lobby_SetSelectedPlaylist( string playlistName )
{
	printt( "Lobby_SetSelectedPlaylist " + playlistName )
	file.selectedPlaylist = playlistName
	UpdateLobbyButtons()
	Lobby_UpdateLoadscreenFromPlaylist()

	if ( playlistName.len() > 0 )
		SetMatchmakingPlaylist( playlistName )
}


void function Lobby_UpdateLoadscreenFromPlaylist()
{
	if ( GetPlaylistVarBool( Lobby_GetSelectedPlaylist(), "force_level_loadscreen", false ) )
	{
		SetCustomLoadScreen( $"" )
	}
	else
	{
		thread Loadscreen_SetEquppedLoadscreenAsActive()
	}
}


void function PlayPanel_OnHide( var panel )
{
	Signal( uiGlobal.signalDummy, "UpdateFriendButtons" )
	RemoveCallback_OnGRXInventoryStateChanged( UpdatePlayPanelGRXDependantElements )
	RemoveCallback_OnGRXInventoryStateChanged( UpdateFriendButtons )
	RemoveCallback_RemoteMatchInfoUpdated( OnRemoteMatchInfoUpdated )

	MiniPromo_Stop()
}


void function UpdateFriendButton( var rui, PartyMember info, bool inMatch )
{
	Party party = GetParty()

	RuiSetString( rui, "playerName", info.name )
	RuiSetBool( rui, "isLeader", party.originatorUID == info.uid && GetPartySize() > 1 )
	RuiSetBool( rui, "isReady", info.ready )
	RuiSetBool( rui, "inMatch", inMatch )
	if ( inMatch )
	{
		RuiSetString( rui, "footerText", "#PROMPT_IN_MATCH" )
	}
	else
	{
		RuiSetString( rui, "footerText", "" )
	}

	thread KeepMicIconUpdated( info, rui )

	int rankScore      = 0
	int ladderPosition = 99999

	CommunityUserInfo ornull userInfo = GetUserInfo( info.hardware, info.uid )
	if ( userInfo == null )
	{
		RuiSetFloat( rui, "accountXPFrac", 0.0 )
		RuiSetString( rui, "accountLevel", "" )

		int accountLevel = 0
		if ( info.uid == GetPlayerUID() && IsPersistenceAvailable() )
			accountLevel = GetAccountLevelForXP( GetPersistentVarAsInt( "xp" ) )

		RuiSetString( rui, "accountLevel", GetAccountDisplayLevel( accountLevel ) )
		RuiSetImage( rui, "accountBadge", GetAccountDisplayBadge( accountLevel ) )

		if ( info.uid == GetPlayerUID() && IsPersistenceAvailable() )
			rankScore = GetPlayerRankScore( GetUIPlayer() )
	}
	else
	{
		expect CommunityUserInfo( userInfo )
		RuiSetFloat( rui, "accountXPFrac", userInfo.charData[ePlayerStryderCharDataArraySlots.ACCOUNT_PROGRESS_INT] / 100.0 )
		RuiSetString( rui, "accountLevel", GetAccountDisplayLevel( userInfo.charData[ePlayerStryderCharDataArraySlots.ACCOUNT_LEVEL] ) )
		RuiSetImage( rui, "accountBadge", GetAccountDisplayBadge( userInfo.charData[ePlayerStryderCharDataArraySlots.ACCOUNT_LEVEL] ) )

		rankScore = userInfo.rankScore
		ladderPosition = userInfo.rankedLadderPos
	}


	bool isRanked = IsRankedPlaylist( Lobby_GetSelectedPlaylist() )
	RuiSetBool( rui, "showRanked", isRanked )
	PopulateRuiWithRankedBadgeDetails( rui, rankScore, ladderPosition )
	if ( isRanked )
	{
		float frac = 0.0

		RankedDivisionData currentRank     = GetCurrentRankedDivisionFromScore( rankScore )
		RankedDivisionData ornull nextRank = GetNextRankedDivisionFromScore( rankScore )

		if ( nextRank != null )
		{
			expect RankedDivisionData( nextRank )
			if ( nextRank != currentRank )
			{
				frac = GraphCapped( float( rankScore ), currentRank.scoreMin, nextRank.scoreMin, 0.0, 1.0 )
			}
		}

		RuiSetFloat( rui, "accountXPFrac", frac )
	}
}


void function KeepMicIconUpdated( PartyMember info, var rui )
{
	EndSignal( uiGlobal.signalDummy, "UpdateFriendButtons" )

	while ( 1 )
	{
		RuiSetInt( rui, "micStatus", GetChatroomMicStatus( info.uid ) )
		WaitFrame()
	}
}


void function UpdateFriendButtons()
{
	Signal( uiGlobal.signalDummy, "UpdateFriendButtons" )

	Hud_SetVisible( file.inviteFriendsButton0, !file.personInLeftSpot )
	Hud_SetVisible( file.inviteFriendsButton1, !file.personInRightSlot )

	Hud_SetVisible( file.friendButton0, false )
	Hud_SetVisible( file.friendButton1, false )

	int count = GetInGameFriendCount( true )
	RuiSetInt( Hud_GetRui( file.inviteFriendsButton0 ), "onlineFriendCount", count )
	RuiSetInt( Hud_GetRui( file.inviteFriendsButton1 ), "onlineFriendCount", count )

	Party party = GetParty()
	foreach ( PartyMember partyMember in party.members )
	{
		if ( partyMember.uid == GetPlayerUID() )
		{
			ToolTipData toolTipData
			toolTipData.tooltipStyle = eTooltipStyle.BUTTON_PROMPT
			toolTipData.actionHint1 = "#A_BUTTON_INSPECT"
			Hud_SetToolTipData( file.selfButton, toolTipData )

			var friendRui = Hud_GetRui( file.selfButton )

			RuiSetBool( friendRui, "canViewStats", true )

			UpdateFriendButton( friendRui, partyMember, false )
		}
		else if ( partyMember.uid == file.friendInLeftSpot.id )
		{
			ToolTipData toolTipData
			toolTipData.tooltipStyle = eTooltipStyle.BUTTON_PROMPT
			toolTipData.actionHint1 = "#A_BUTTON_INSPECT"
			toolTipData.actionHint2 = IsPlayerVoiceMutedForUID( partyMember.uid ) ? "#X_BUTTON_UNMUTE" : "#X_BUTTON_MUTE"
			Hud_SetToolTipData( file.friendButton0, toolTipData )

			var friendRui = Hud_GetRui( file.friendButton0 )
			UpdateFriendButton( friendRui, partyMember, file.friendInLeftSpot.ingame )
			Hud_SetVisible( file.friendButton0, true )
			if ( file.leftWasReady != partyMember.ready )
				EmitUISound( partyMember.ready ? SOUND_START_MATCHMAKING_3P : SOUND_STOP_MATCHMAKING_3P )

			file.leftWasReady = partyMember.ready
		}
		else if ( partyMember.uid == file.friendInRightSpot.id )
		{
			ToolTipData toolTipData
			toolTipData.tooltipStyle = eTooltipStyle.BUTTON_PROMPT
			toolTipData.actionHint1 = "#A_BUTTON_INSPECT"
			toolTipData.actionHint2 = IsPlayerVoiceMutedForUID( partyMember.uid ) ? "#X_BUTTON_UNMUTE" : "#X_BUTTON_MUTE"
			Hud_SetToolTipData( file.friendButton1, toolTipData )

			var friendRui = Hud_GetRui( file.friendButton1 )
			UpdateFriendButton( friendRui, partyMember, file.friendInRightSpot.ingame )
			Hud_SetVisible( file.friendButton1, true )

			if ( file.rightWasReady != partyMember.ready )
				EmitUISound( partyMember.ready ? SOUND_START_MATCHMAKING_3P : SOUND_STOP_MATCHMAKING_3P )

			file.rightWasReady = partyMember.ready
		}
	}

	ToolTipData toolTipData
	toolTipData.titleText = "#INVITE"
	toolTipData.descText = "#INVITE_HINT"

	entity player = GetUIPlayer()
	if ( IsLocalClientEHIValid() && IsValid( player ) )
	{
		bool hasPremiumPass                = false
		ItemFlavor ornull activeBattlePass = GetPlayerActiveBattlePass( ToEHI( player ) )
		bool hasActiveBattlePass           = activeBattlePass != null
		if ( hasActiveBattlePass && GRX_IsInventoryReady() )
		{
			expect ItemFlavor( activeBattlePass )
			hasPremiumPass = DoesPlayerOwnBattlePass( player, activeBattlePass )
			if ( hasPremiumPass )
				toolTipData.descText = Localize( "#INVITE_HINT_BP" )
		}
	}

	#if PC_PROG
		if ( !Origin_IsOverlayAvailable() && !GetCurrentPlaylistVarBool( "social_menu_enabled", true ) )
		{
			toolTipData.descText = "#ORIGIN_INGAME_REQUIRED"
			Hud_SetLocked( file.inviteFriendsButton0, true )
			Hud_SetLocked( file.inviteFriendsButton1, true )
		}
	#endif //PC_PROG

	Hud_SetToolTipData( file.inviteFriendsButton0, toolTipData )
	Hud_SetToolTipData( file.inviteFriendsButton1, toolTipData )
}


void function UpdatePlaylistBadges()
{
	int currentStreak = 0

	bool newPlaylistSelect = GamemodeSelectV2_IsEnabled()

	bool showLTMAboutButton = GetPlaylistVarBool( Lobby_GetSelectedPlaylist(), "show_ltm_about_button", false )
	var aboutButton         = Hud_GetChild( file.panel, "AboutButton" )
	Hud_SetVisible( aboutButton, false )

	currentStreak = GetCurrentEliteStreak( GetUIPlayer() )
	bool shouldShowEliteBadge = IsElitePlaylist( Lobby_GetSelectedPlaylist() )

	bool shouldShowRankedBadge = IsRankedPlaylist( Lobby_GetSelectedPlaylist() )

	var rankedBadge = Hud_GetChild( file.panel, "RankedBadge" )
	Hud_SetVisible( rankedBadge, false )

	if ( newPlaylistSelect )
	{
		Hud_SetPinSibling( rankedBadge, Hud_GetHudName( file.gamemodeSelectV2Button ) )
		Hud_SetPinSibling( aboutButton, Hud_GetHudName( file.gamemodeSelectV2Button ) )
	}
	else
	{
		Hud_SetPinSibling( rankedBadge, Hud_GetHudName( file.modeButton ) )
		Hud_SetPinSibling( aboutButton, Hud_GetHudName( file.modeButton ) )
	}

	var eliteBadge = Hud_GetChild( file.panel, "EliteBadge" )
	Hud_SetVisible( eliteBadge, false )

	if ( newPlaylistSelect )
	{
		Hud_SetPinSibling( eliteBadge, Hud_GetHudName( file.gamemodeSelectV2Button ) )
	}
	else
	{
		Hud_SetPinSibling( eliteBadge, Hud_GetHudName( file.modeButton ) )
	}

	var msgLabel = Hud_GetChild( file.panel, "PlaylistNotificationMessage" )
	Hud_SetVisible( msgLabel, false )

	if ( newPlaylistSelect )
	{
		Hud_SetPinSibling( msgLabel, Hud_GetHudName( file.gamemodeSelectV2Button ) )
	}
	else
	{
		Hud_SetPinSibling( msgLabel, Hud_GetHudName( file.modeButton ) )
	}

	if ( shouldShowRankedBadge )
	{
		Hud_SetVisible( rankedBadge, shouldShowRankedBadge )

		var rui = Hud_GetRui( rankedBadge )

		int score               = GetPlayerRankScore( GetUIPlayer() )
		RankedDivisionData data = GetCurrentRankedDivisionFromScore( score )

		RuiSetInt( rui, "score", score )
		RuiSetInt( rui, "scoreMax", 0 )
		RuiSetFloat( rui, "scoreFrac", 1.0 )
		RuiSetString( rui, "rankName", data.divisionName )
		PopulateRuiWithRankedBadgeDetails( rui, score, Ranked_GetDisplayNumberForRuiBadge( GetUIPlayer() ) )
		RuiSetBool( rui, "inSeason", IsRankedInSeason() )

		if ( data.tier.index != file.lobbyRankTier )
		{
			RuiDestroyNestedIfAlive( rui, "rankedBadgeHandle" )
			CreateNestedRankedRui( rui, data.tier )
			file.lobbyRankTier = data.tier.index
		}

		ToolTipData tooltip
		tooltip.titleText = data.divisionName

		RankedDivisionData ornull nextData = GetNextRankedDivisionFromScore( score )

		if ( nextData != null )
		{
			expect RankedDivisionData( nextData )
			tooltip.descText = Localize( "#RANKED_TOOLTIP_NEXT", Localize( nextData.divisionName ).toupper(), (nextData.scoreMin - score) )

			RuiSetInt( rui, "scoreMax", nextData.scoreMin )
			RuiSetFloat( rui, "scoreFrac", float( score - data.scoreMin ) / float( nextData.scoreMin - data.scoreMin ) )
		}

		Hud_SetToolTipData( rankedBadge, tooltip )
		return
	}

	if ( shouldShowEliteBadge )
	{
		Hud_SetVisible( eliteBadge, shouldShowEliteBadge )

		var rui = Hud_GetRui( eliteBadge )

		RuiSetInt( rui, "streak", currentStreak )

		if ( IsFullyConnected() )
			RuiSetBool( rui, "eliteForgiveness", expect bool( GetPersistentVar( "hasEliteForgiveness" ) ) )

		int maxStreak = GetMaxEliteStreak( GetUIPlayer() )
		ToolTipData tooltip
		tooltip.titleText = Localize( "#ELITE_TOOLTIP_INFO", currentStreak )
		tooltip.descText = Localize( "#ELITE_TOOLTIP_INFO_2", maxStreak )
		Hud_SetToolTipData( eliteBadge, tooltip )
	}
	else if ( PartyHasEliteAccess() )
	{
		bool foundElitePlaylist = false

		foreach ( playlist in GetVisiblePlaylistNames() )
		{
			if ( IsElitePlaylist( playlist ) )
			{
				foundElitePlaylist = true
				break
			}
		}

		if ( foundElitePlaylist )
			Hud_SetVisible( msgLabel, true )
	}

	if ( showLTMAboutButton )
	{
		Hud_SetVisible( aboutButton, showLTMAboutButton )

		array<int> emblemColor = GetEmblemColor( GetSelectedPlaylist() )

		var rui = Hud_GetRui( aboutButton )
		RuiSetString( rui, "buttonText", "#ABOUT_GAMEMODE" )
		asset emblemImage = GetModeEmblemImage( GetSelectedPlaylist() )
		RuiSetImage( rui, "emblemImage", emblemImage )
		RuiSetColorAlpha( rui, "emblemColor", SrgbToLinear( <emblemColor[0], emblemColor[1], emblemColor[2]> / 255.0 ), emblemColor[3] / 255.0 )

		return
	}
}


void function UpdateLastPlayedButtons()
{
	UpdateLastPlayedPlayerInfo()

	bool isVisibleButton0 = file.lastPlayedPlayerPlatformUid0 != "" && !PlayerIsInMatch( file.lastPlayedPlayerHardware0, file.lastPlayedPlayerPlatformUid0 )
	bool isVisibleButton1 = file.lastPlayedPlayerPlatformUid1 != "" && !PlayerIsInMatch( file.lastPlayedPlayerHardware1, file.lastPlayedPlayerPlatformUid1 )

	bool shouldUpdateDpadNav = false

	if ( isVisibleButton0 != Hud_IsVisible( file.inviteLastPlayedUnitFrame0 ) || isVisibleButton1 != Hud_IsVisible( file.inviteLastPlayedUnitFrame1 ) )
	{
		shouldUpdateDpadNav = true
	}

	isVisibleButton0 = isVisibleButton0 && CanInvite()
	isVisibleButton1 = isVisibleButton1 && CanInvite()

	if ( isVisibleButton0 )
	{
		if ( file.lastPlayedPlayerPersistenceIndex0 == -1 )
			return

		string namePlayer0 = expect string( GetPersistentVar( "lastGameSquadStats[" + file.lastPlayedPlayerPersistenceIndex0 + "].playerName" ) )
		HudElem_SetRuiArg( file.inviteLastPlayedUnitFrame0, "name", namePlayer0 )

		string characterGUIDString = string( GetPersistentVar( "lastGameSquadStats[" + file.lastPlayedPlayerPersistenceIndex0 + "].character" ) )
		int characterGUID          = ConvertItemFlavorGUIDStringToGUID( characterGUIDString )
		if ( IsValidItemFlavorGUID( characterGUID ) )
		{
			ItemFlavor squadCharacterClass = GetItemFlavorByGUID( characterGUID )
			HudElem_SetRuiArg( file.inviteLastPlayedUnitFrame0, "icon", CharacterClass_GetGalleryPortrait( squadCharacterClass ), eRuiArgType.IMAGE )
		}

		if ( Time() - file.lastPlayedPlayerInviteSentTimestamp0 > INVITE_LAST_TIMEOUT )
		{
			HudElem_SetRuiArg( file.inviteLastPlayedUnitFrame0, "unitframeFooterText", "#INVITE_PLAYER_UNITFRAME" )
			Hud_SetLocked( file.inviteLastPlayedUnitFrame0, false )
		}
	}

	Hud_SetVisible( file.inviteLastPlayedUnitFrame0, isVisibleButton0 )


	if ( isVisibleButton1 )
	{
		if ( file.lastPlayedPlayerPersistenceIndex1 == -1 )
			return

		string namePlayer1 = expect string( GetPersistentVar( "lastGameSquadStats[" + file.lastPlayedPlayerPersistenceIndex1 + "].playerName" ) )
		HudElem_SetRuiArg( file.inviteLastPlayedUnitFrame1, "name", namePlayer1 )

		string characterGUIDString = string( GetPersistentVar( "lastGameSquadStats[" + file.lastPlayedPlayerPersistenceIndex1 + "].character" ) )
		int characterGUID          = ConvertItemFlavorGUIDStringToGUID( characterGUIDString )
		if ( IsValidItemFlavorGUID( characterGUID ) )
		{
			ItemFlavor squadCharacterClass = GetItemFlavorByGUID( characterGUID )
			HudElem_SetRuiArg( file.inviteLastPlayedUnitFrame1, "icon", CharacterClass_GetGalleryPortrait( squadCharacterClass ), eRuiArgType.IMAGE )
		}

		if ( Time() - file.lastPlayedPlayerInviteSentTimestamp1 > INVITE_LAST_TIMEOUT )
		{
			HudElem_SetRuiArg( file.inviteLastPlayedUnitFrame1, "unitframeFooterText", "#INVITE_PLAYER_UNITFRAME" )
			Hud_SetLocked( file.inviteLastPlayedUnitFrame1, false )
		}
	}

	Hud_SetVisible( file.inviteLastPlayedUnitFrame1, isVisibleButton1 )
	Hud_SetVisible( file.inviteLastPlayedHeader, isVisibleButton0 || isVisibleButton1 )

	if ( shouldUpdateDpadNav )
	{
		UpdateLastSquadDpadNav()
	}

	ToolTipData toolTipData0
	toolTipData0.tooltipStyle = eTooltipStyle.BUTTON_PROMPT

	ToolTipData toolTipData1
	toolTipData1.tooltipStyle = eTooltipStyle.BUTTON_PROMPT

	if ( Time() - file.lastPlayedPlayerInviteSentTimestamp0 > INVITE_LAST_TIMEOUT )
	{
		toolTipData0.actionHint1 = "#A_BUTTON_INVITE"
		toolTipData0.actionHint2 = "#X_BUTTON_INSPECT"
		Hud_SetToolTipData( file.inviteLastPlayedUnitFrame0, toolTipData0 )
	}
	else if ( Time() - file.lastPlayedPlayerInviteSentTimestamp0 <= INVITE_LAST_TIMEOUT )
	{
		toolTipData0.actionHint1 = "#X_BUTTON_INSPECT"
		Hud_SetToolTipData( file.inviteLastPlayedUnitFrame0, toolTipData0 )
	}

	if ( Time() - file.lastPlayedPlayerInviteSentTimestamp1 > INVITE_LAST_TIMEOUT )
	{
		toolTipData1.actionHint1 = "#A_BUTTON_INVITE"
		toolTipData1.actionHint2 = "#X_BUTTON_INSPECT"
		Hud_SetToolTipData( file.inviteLastPlayedUnitFrame1, toolTipData1 )
	}
	else if ( Time() - file.lastPlayedPlayerInviteSentTimestamp1 <= INVITE_LAST_TIMEOUT )
	{
		toolTipData1.actionHint1 = "#X_BUTTON_INSPECT"
		Hud_SetToolTipData( file.inviteLastPlayedUnitFrame1, toolTipData1 )
	}
}


void function ClientToUI_PartyMemberJoinedOrLeft( string leftSpotUID, string leftSpotHardware, string leftSpotName, bool leftSpotInMatch, string rightSpotUID, string rightSpotHardware, string rightSpotName, bool rightSpotInMatch )
{
	bool personInLeftSpot  = leftSpotUID.len() > 0
	bool persinInRightSpot = rightSpotUID.len() > 0

	file.friendInLeftSpot.id = leftSpotUID
	file.friendInLeftSpot.hardware = leftSpotHardware
	file.friendInLeftSpot.name = leftSpotName
	file.friendInLeftSpot.ingame = leftSpotInMatch

	file.friendInRightSpot.id = rightSpotUID
	file.friendInRightSpot.hardware = rightSpotHardware
	file.friendInRightSpot.name = rightSpotName
	file.friendInRightSpot.ingame = rightSpotInMatch

	file.personInLeftSpot = personInLeftSpot
	file.personInRightSlot = persinInRightSpot

	file.leftWasReady = file.leftWasReady && personInLeftSpot
	file.rightWasReady = file.rightWasReady && persinInRightSpot

	UpdateLobbyButtons()
}


bool function CanActivateReadyButton()
{
	if ( IsConnectingToMatch() )
		return false

	// just checking the if it's the lobby menu broke the progressive dowload dialog box.
	// It tries to run ReadyButtonActivate() from inside the callback of the ConfirmDialog... but it would fail since the active menu was still the dialog.
	if ( GetActiveMenu() == GetMenu( "ModeSelectDialog" ) )
		return false

	bool isReady = GetConVarBool( "party_readyToSearch" )

	// always allow unready
	if ( isReady )
		return true

	if ( !Lobby_IsPlaylistAvailable( GetSelectedPlaylist() ) )
		return false

	return true
}


string function GetSelectedPlaylist()
{
	return IsPartyLeader() ? file.selectedPlaylist : GetParty().playlistName
}


int function Lobby_GetPlaylistState( string playlistName )
{
	if ( playlistName == "" )
		return ePlaylistState.NO_PLAYLIST

	if ( playlistName != PLAYLIST_TRAINING && GetPartySize() == 1 && !IsExemptFromTraining() && !IsTrainingCompleted() )
	{
		if ( GetCurrentPlaylistVarBool( "full_training_required", true ) )
			return ePlaylistState.COMPLETED_TRAINING_REQUIRED
		else
			return ePlaylistState.TRAINING_REQUIRED
	}

	if ( file.currentMaxMatchmakingDelayEndTime > 0 )
		return ePlaylistState.RANKED_MATCH_ABANDON_DELAY

	if ( GetPartySize() > GetMaxTeamSizeForPlaylist( playlistName ) )
		return ePlaylistState.PARTY_SIZE_OVER

	if ( IsElitePlaylist( playlistName ) && !PartyHasEliteAccess() )
		return ePlaylistState.ELITE_ACCESS_REQUIRED

	if ( IsRankedPlaylist( playlistName ) )
	{
		if ( !PartyHasRankedAccess() )
			return ePlaylistState.RANKED_LEVEL_REQUIRED
	}

	return ePlaylistState.AVAILABLE
}


string function Lobby_GetPlaylistStateString( int playlistState )
{
	return playlistStateMap[playlistState]
}


void function UpdateReadyButton()
{
	bool isLeader = IsPartyLeader()

	bool isReady               = GetConVarBool( "party_readyToSearch" )
	string buttonText
	string buttonDescText
	float buttonDescFontHeight = 0.0

		float timeRemaining = 0
		if ( file.currentMaxMatchmakingDelayEndTime > 0 )
			timeRemaining = file.currentMaxMatchmakingDelayEndTime - Time()

		if ( timeRemaining > 0 )
		{
			buttonText = "#RANKED_ABANDON_PENALTY_PLAY_BUTTON_LABEL"
			HudElem_SetRuiArg( file.readyButton, "expireTime", Time() + timeRemaining, eRuiArgType.GAMETIME )
		}
		else
		{
			file.currentMaxMatchmakingDelayEndTime = 0
			if ( isReady )
			{
				buttonText = IsControllerModeActive() ? "#B_BUTTON_CANCEL" : "#CANCEL"
			}
			else
			{
				buttonText = IsControllerModeActive() ? "#Y_BUTTON_READY" : "#READY"
			}

			if ( Dev_CommandLineHasParm( "-auto_ezlaunch" ) )
			{
				buttonDescText = "-auto_ezlaunch"
				buttonDescFontHeight = 24
			}

			HudElem_SetRuiArg( file.readyButton, "expireTime", RUI_BADGAMETIME, eRuiArgType.GAMETIME )
		}

	HudElem_SetRuiArg( file.readyButton, "isLeader", isLeader ) // TEMP
	HudElem_SetRuiArg( file.readyButton, "isReady", isReady )
	HudElem_SetRuiArg( file.readyButton, "buttonText", Localize( buttonText ) )
	HudElem_SetRuiArg( file.readyButton, "buttonDescText", buttonDescText )
	HudElem_SetRuiArg( file.readyButton, "buttonDescFontHeight", buttonDescFontHeight )

	Hud_SetLocked( file.readyButton, !CanActivateReadyButton() )

	if ( !CanActivateReadyButton() )
	{
		ToolTipData toolTipData
		toolTipData.titleText = IsConnectingToMatch() ? "#UNAVAILABLE" : "#READY_UNAVAILABLE"
		toolTipData.descText = IsConnectingToMatch() ? "#LOADINGPROGRESS_CONNECTING" : Lobby_GetPlaylistStateString( Lobby_GetPlaylistState( GetSelectedPlaylist() ) )

		Hud_SetToolTipData( file.readyButton, toolTipData )
	}
	else
	{
		Hud_ClearToolTipData( file.readyButton )
	}
}


bool function CanActivateModeButton()
{
	bool isReady  = GetConVarBool( "party_readyToSearch" )
	bool isLeader = IsPartyLeader()

	return !isReady && isLeader
}


void function UpdateModeButton()
{
	if ( !IsConnected() )
		return

	string visiblePlaylistValue = GetConVarString( "match_visiblePlaylists" )
	if ( visiblePlaylistValue != file.lastVisiblePlaylistValue )
	{
		Lobby_UpdatePlayPanelPlaylists()
		file.lastVisiblePlaylistValue = visiblePlaylistValue
	}

	Hud_SetLocked( file.modeButton, !CanActivateModeButton() )

	bool isReady = GetConVarBool( "party_readyToSearch" )
	Hud_SetEnabled( file.modeButton, !isReady && CanActivateModeButton() )
	HudElem_SetRuiArg( file.modeButton, "isReady", isReady )
	HudElem_SetRuiArg( file.gamemodeSelectV2Button, "isReady", isReady )

	bool hasNewModes = false

//if ( IsFullyConnected() )
	//	hasNewModes = GetCurrentPlaylistVarInt( "gamemodeVersion", 0 ) > GetPersistentVarAsInt( "newModeVersion" )

	Hud_SetNew( file.gamemodeSelectV2Button, hasNewModes && (IsTrainingCompleted() || IsExemptFromTraining()) )

	if ( file.wasReady != isReady )
	{
		UISize screenSize = GetScreenSize()

		int maxDist = int( screenSize.height * 0.08 )

		int x = Hud_GetX( file.modeButton )
		int y = isReady ? Hud_GetBaseY( file.modeButton ) + maxDist : Hud_GetBaseY( file.modeButton )

		int currentY = Hud_GetY( file.modeButton )
		int diff     = abs( currentY - y )

		float duration = 0.15 * (float( diff ) / float( maxDist ))

		Hud_MoveOverTime( file.modeButton, x, y, 0.15 )

		file.wasReady = isReady
	}

	bool isLeader = IsPartyLeader()

	string playlistName        = isLeader ? file.selectedPlaylist : GetParty().playlistName
	string invalidPlaylistText = isLeader ? "#SELECT_PLAYLIST" : "#PARTY_LEADER_CHOICE"

	string name = GetPlaylistVarString( playlistName, "name", invalidPlaylistText )
	HudElem_SetRuiArg( file.modeButton, "buttonText", Localize( name ) )

	bool useGamemodeSelectV2 = GamemodeSelectV2_IsEnabled() && !(ShouldDisplayOptInOptions() && uiGlobal.isOptInEnabled)
	Hud_SetVisible( file.modeButton, !useGamemodeSelectV2 )
	Hud_SetVisible( file.gamemodeSelectV2Button, useGamemodeSelectV2 )
	RuiSetBool( Hud_GetRui( file.readyButton ), "showReadyFrame", !useGamemodeSelectV2 )
	if ( useGamemodeSelectV2 )
	{
		GamemodeSelectV2_UpdateSelectButton( file.gamemodeSelectV2Button, playlistName )
		HudElem_SetRuiArg( file.gamemodeSelectV2Button, "alwaysShowDesc", true )
		HudElem_SetRuiArg( file.gamemodeSelectV2Button, "isPartyLeader", isLeader )

		HudElem_SetRuiArg( file.gamemodeSelectV2Button, "modeLockedReason", "" )
		Hud_SetLocked( file.gamemodeSelectV2Button, !CanActivateModeButton() )
	}

	if ( file.lastPlaylistDisplayed != playlistName )
	{
		Lobby_UpdateLoadscreenFromPlaylist()
	}

	file.lastPlaylistDisplayed = playlistName
}


void function UpdateFillButton()
{
	if ( !IsConnected() )
		return

	bool supportsNoFill = DoesPlaylistSupportNoFillTeams( Lobby_GetSelectedPlaylist() )

	if ( GetConVarBool( "match_teamNoFill" ) && !supportsNoFill )
		SetConVarBool( "match_teamNoFill", false )

	bool isNoFill = GetConVarBool( "match_teamNoFill" )
	if ( isNoFill )
		HudElem_SetRuiArg( file.fillButton, "buttonText", Localize( "#MATCH_TEAM_NO_FILL" ) )
	else
		HudElem_SetRuiArg( file.fillButton, "buttonText", Localize( "#MATCH_TEAM_FILL" ) )

	Hud_SetLocked( file.fillButton, !IsPartyLeader() || AreWeMatchmaking() || !supportsNoFill )
}


void function FillButton_OnActivate( var button )
{
	if ( Hud_IsLocked( button ) )
		return

	if ( GetConVarBool( "match_teamNoFill" ) )
		ClientCommand( "match_teamNoFill 0" )
	else
		ClientCommand( "match_teamNoFill 1" )
}


void function ModeButton_OnActivate( var button )
{
	if ( Hud_IsLocked( button ) || !CanActivateModeButton() )
		return

	ClientCommand( "ViewedModes" )

	AdvanceMenu( GetMenu( "ModeSelectDialog" ) )
}


void function GameModeSelectV2Button_OnActivate( var button )
{
	if ( Hud_IsLocked( button ) || !CanActivateModeButton() )
		return

	Hud_SetVisible( file.gamemodeSelectV2Button, false )
	Hud_SetVisible( file.readyButton, false )

	ClientCommand( "ViewedModes" )

	AdvanceMenu( GetMenu( "GamemodeSelectV2Dialog" ) )
}


void function GameModeSelectV2Button_OnGetFocus( var button )
{
	GamemodeSelectV2_PlayVideo( button, file.selectedPlaylist )
}


void function GameModeSelectV2Button_OnLoseFocus( var button )
{
	//
}


void function Lobby_OnGamemodeSelectV2Close()
{
	Hud_SetVisible( file.gamemodeSelectV2Button, true )
	Hud_SetVisible( file.readyButton, true )
}


void function PlayPanel_OnNavBack( var panel )
{
	if ( !IsControllerModeActive() )
		return

	bool isReady = GetConVarBool( "party_readyToSearch" )
	if ( !AreWeMatchmaking() && !isReady )
		return

	CancelMatchmaking()
	ClientCommand( "CancelMatchSearch" )
}


void function ReadyShortcut_OnActivate( var panel )
{
	if ( AreWeMatchmaking() )
		return

	ReadyButton_OnActivate( file.readyButton )
}


void function ReadyButton_OnActivate( var button )
{
	if ( Hud_IsLocked( file.readyButton ) || !CanActivateReadyButton() )
		return

	bool isReady                   = GetConVarBool( "party_readyToSearch" )
	bool requireConsensusForSearch = GetConVarBool( "party_requireConsensusForSearch" )

	if ( AreWeMatchmaking() || isReady )
	{
		CancelMatchmaking()
		ClientCommand( "CancelMatchSearch" )
		EmitUISound( SOUND_STOP_MATCHMAKING_1P )
	}
	else
	{
		if ( !IsGameFullyInstalled() || HasNonFullyInstalledAssetsLoaded() )
		{
			ConfirmDialogData data
			data.headerText = "#TEXTURE_STREAM_HEADER"
			data.messageText = Localize( "#TEXTURE_STREAM_MESSAGE", floor( GetGameFullyInstalledProgress() * 100 ) )
			data.yesText = ["#TEXTURE_STREAM_PLAY", "#TEXTURE_STREAM_PLAY_PC"]
			data.noText = ["#TEXTURE_STREAM_WAIT", "#TEXTURE_STREAM_WAIT_PC"]
			if ( GetGameFullyInstalledProgress() >= 1 && HasNonFullyInstalledAssetsLoaded() )
			{
				// hd textured fully loaded, requires disconnect to use
				data.headerText = "#TEXTURE_STREAM_REBOOT_HEADER"
				data.messageText = "#TEXTURE_STREAM_REBOOT_MESSAGE"
				data.yesText = ["#TEXTURE_STREAM_REBOOT", "#TEXTURE_STREAM_REBOOT_PC"]
				data.noText = ["#TEXTURE_STREAM_PLAY_ON_NO", "#TEXTURE_STREAM_PLAY_PC"]
			}

			data.resultCallback = void function ( int result ) : ()
			{
				if ( GetGameFullyInstalledProgress() >= 1 && HasNonFullyInstalledAssetsLoaded() )
				{
					// hd textured fully loaded, should we return to the main menu?
					if ( result == eDialogResult.YES )
					{
						// hd textured fully loaded, return to the main menu
						ClientCommand( "disconnect" )
						return
					}
				}
				else if ( result != eDialogResult.YES )
				{
					// still downloading HD textures, elected to wait.
					return

				}

				// play without HD textures
				ReadyButtonActivate()
			}

			if ( !IsDialog( GetActiveMenu() ) )
				OpenConfirmDialogFromData( data )
			return
		}

		bool isLeader = IsPartyLeader()

		if ( isLeader && ShouldShowLowPopDialog( file.selectedPlaylist ) )
		{
			OpenLowPopDialog( ReadyButtonActivateForDataCenter )
		}
		else
		{
			ReadyButtonActivate()
		}
	}
}


void function ReadyButtonActivateForDataCenter( int datacenterIndex )
{
	LowPop_SetRankedDatacenter( datacenterIndex )
	ReadyButtonActivate()
}


void function ReadyButtonActivate()
{
	if ( Hud_IsLocked( file.readyButton ) || !CanActivateReadyButton() )
		return

	else
	{
		EmitUISound( SOUND_START_MATCHMAKING_1P )

		if ( GetConVarBool( "match_teamNoFill" ) && DoesPlaylistSupportNoFillTeams( file.selectedPlaylist ) )
			StartMatchmakingWithNoFillTeams( file.selectedPlaylist )
		else
			StartMatchmakingStandard( file.selectedPlaylist )
	}
}


void function InviteFriendsButton_OnActivate( var button )
{
	if ( Hud_IsLocked( button ) )
		return

	#if PC_PROG
		if ( !MeetsAgeRequirements() )
		{
			ConfirmDialogData dialogData
			dialogData.headerText   = "#UNAVAILABLE"
			dialogData.messageText  = "#ORIGIN_UNDERAGE_ONLINE"
			dialogData.contextImage = $"ui/menu/common/dialog_notice"

			OpenOKDialogFromData( dialogData )
			return
		}
	#endif

	thread CreatePartyAndInviteFriends()
}


void function InviteLastPlayedButton_OnActivate( var button )
{
	if ( Hud_IsLocked( button ) )
		return

	int scriptID = int( Hud_GetScriptID( button ) )

	#if(PC_PROG)
		if ( !MeetsAgeRequirements() )
		{
			ConfirmDialogData dialogData
			dialogData.headerText   = "#UNAVAILABLE"
			dialogData.messageText  = "#ORIGIN_UNDERAGE_ONLINE"
			dialogData.contextImage = $"ui/menu/common/dialog_notice"

			OpenOKDialogFromData( dialogData )
			return
		}
	#endif


	if ( scriptID == 0 )
	{
		InvitePlayerByUID ( file.lastPlayedPlayerPlatformUid0 )
		file.lastPlayedPlayerInviteSentTimestamp0 = Time()
		HudElem_SetRuiArg( button, "unitframeFooterText", "#INVITE_PLAYER_INVITED" )
		Hud_SetLocked( button, true )
	}
	else if ( scriptID == 1 )
	{
		InvitePlayerByUID ( file.lastPlayedPlayerPlatformUid1 )
		file.lastPlayedPlayerInviteSentTimestamp1 = Time()
		HudElem_SetRuiArg( button, "unitframeFooterText", "#INVITE_PLAYER_INVITED" )
		Hud_SetLocked( button, true )
	}
}


void function InviteLastPlayedButton_OnRightClick( var button )
{
	int scriptID = int( Hud_GetScriptID( button ) )

	Friend friend

	if ( scriptID == 0 )
	{
		friend.name = expect string( GetPersistentVar( "lastGameSquadStats[" + file.lastPlayedPlayerPersistenceIndex0 + "].playerName" ) )
		friend.hardware = file.lastPlayedPlayerHardware0
		friend.id = file.lastPlayedPlayerPlatformUid0
	}

	if ( scriptID == 1 )
	{
		friend.name = expect string( GetPersistentVar( "lastGameSquadStats[" + file.lastPlayedPlayerPersistenceIndex1 + "].playerName" ) )
		friend.hardware = file.lastPlayedPlayerHardware1
		friend.id = file.lastPlayedPlayerPlatformUid1
	}

	if ( friend.id == "" )
		return

	InspectFriend( friend )
}


void function InvitePlayerByUID( string platformUID )
{
	array<string> ids
	ids.append( platformUID )

	printt( " InviteFriend id:", ids[0] )
	DoInviteToParty( ids )
}


void function FriendButton_OnActivate( var button )
{
	int scriptID = int( Hud_GetScriptID( button ) )
	if ( scriptID == -1 )
	{
		Friend friend
		friend.status = eFriendStatus.ONLINE_INGAME
		friend.name = GetPlayerName()
		friend.hardware = ""
		friend.ingame = true
		friend.id = GetPlayerUID()

		Party party = GetParty()
		friend.presence = Localize( "#PARTY_N_N", party.numClaimedSlots, party.numSlots )
		friend.inparty = party.numClaimedSlots > 0

		InspectFriend( friend )
	}
	else
	{
		InspectFriend( scriptID == 0 ? file.friendInLeftSpot : file.friendInRightSpot )
	}
}


void function FriendButton_OnRightClick( var button )
{
	int scriptID = int( Hud_GetScriptID( button ) )

	if ( scriptID == 0 )
		TogglePlayerVoiceMutedForUID( file.friendInLeftSpot.id )
	else
		TogglePlayerVoiceMutedForUID( file.friendInRightSpot.id )
}


void function CreatePartyAndInviteFriends()
{
	if ( CanInvite() )
	{
		while ( !PartyHasMembers() && !AmIPartyLeader() )
		{
			printt( "creating a party in CreatePartyAndInviteFriends" )
			ClientCommand( "createparty" )
			WaitFrameOrUntilLevelLoaded()
		}

		InviteFriends()
	}
	else
	{
		printt( "Not inviting friends - CanInvite() returned false" )
	}
}


void function InviteRoomButton_OnActivate( var button )
{
	if ( Hud_IsLocked( button ) )
		return

	entity player = GetUIPlayer()

	if ( !DoesCurrentCommunitySupportInvites() )
	{
		//OnBrowseNetworksButton_Activate( button )
		return
	}

	SendOpenInvite( true )
}


void function OpenLootBoxButton_OnActivate( var button )
{
	if ( Hud_IsLocked( button ) )
		return

	OnLobbyOpenLootBoxMenu_ButtonPress()
}


void function UpdatePlayPanelGRXDependantElements()
{
	if ( GRX_IsInventoryReady() )
		UpdateLobbyChallengeMenu()

	UpdateMiniPromoPinning()
}


void function UpdateMiniPromoPinning()
{
	var miniPromoButton = Hud_GetChild( file.panel, "MiniPromo" )

	array<var> pinCandidates
	pinCandidates.append( Hud_GetChild( file.panel, "AllChallengesButton" ) )
	array<var> challengeButtons = GetLobbyChallengeButtons()
	challengeButtons.reverse()
	pinCandidates.extend( challengeButtons )
	pinCandidates.append( Hud_GetChild( file.panel, "TopRightContentAnchor" ) )

	var anchor = Hud_GetChild( file.panel, "TopRightContentAnchor" )

	foreach ( pinCandidate in pinCandidates )
	{
		if ( !Hud_IsVisible( pinCandidate ) )
			continue

		printt( "Pinning to:", Hud_GetHudName( pinCandidate ) )
		Hud_SetPinSibling( miniPromoButton, Hud_GetHudName( pinCandidate ) )

		int vOffset = pinCandidate == anchor ? 0 : ContentScaledYAsInt( 24 )
		Hud_SetY( miniPromoButton, vOffset )
		break
	}
}


void function UpdateLootBoxButton( var button, array<ItemFlavor> specificPackFlavs = [] )
{
	ItemFlavor ornull packFlav
	int lootBoxCount    = 0
	string buttonText   = "#LOOT_BOXES"
	string descText     = "#UNAVAILABLE"
	int nextRarity      = -1
	asset rarityIcon    = $""
	vector themeCol     = <1, 1, 1>
	vector countTextCol = SrgbToLinear( <255, 78, 29> * 1.0 / 255.0 )

	if ( GRX_IsInventoryReady() )
	{
		if ( specificPackFlavs.len() > 0 )
		{
			foreach ( ItemFlavor specificPackFlav in specificPackFlavs )
			{
				int count = GRX_GetPackCount( ItemFlavor_GetGRXIndex( specificPackFlav ) )
				if ( packFlav == null || (lootBoxCount == 0 && count > 0) )
				{
					packFlav = specificPackFlav
					buttonText = ItemFlavor_GetShortName( specificPackFlav )
				}
				lootBoxCount += count
			}
			descText = (lootBoxCount == 1 ? "#EVENT_PACK" : "#EVENT_PACKS")
		}
		else
		{
			lootBoxCount = GRX_GetTotalPackCount()
			if ( lootBoxCount > 0 )
			{
				packFlav = GetNextLootBox()
				expect ItemFlavor( packFlav )
				nextRarity = ItemFlavor_GetQuality( packFlav )
			}

			buttonText = (lootBoxCount == 1 ? "#LOOT_BOX" : "#LOOT_BOXES")
			descText = "#LOOT_REMAINING"
		}
	}

	if ( packFlav != null )
	{
		expect ItemFlavor( packFlav )
		nextRarity = ItemFlavor_GetQuality( packFlav )
		rarityIcon = GRXPack_GetOpenButtonIcon( packFlav )

		vector ornull customCol0 = GRXPack_GetCustomColor( packFlav, 0 )
		if ( customCol0 != null )
			themeCol = SrgbToLinear( expect vector(customCol0) )
		else if ( nextRarity >= 2 )
			themeCol = SrgbToLinear( GetKeyColor( COLORID_TEXT_LOOT_TIER0, nextRarity + 1 ) / 255.0 )

		vector ornull customCountTextCol = GRXPack_GetCustomCountTextCol( packFlav )
		if ( customCountTextCol != null )
			countTextCol = SrgbToLinear( expect vector(customCountTextCol) )
	}

	HudElem_SetRuiArg( button, "bigText", string( lootBoxCount ) )
	HudElem_SetRuiArg( button, "buttonText", buttonText )
	HudElem_SetRuiArg( button, "descText", descText )
	HudElem_SetRuiArg( button, "descTextRarity", nextRarity )
	HudElem_SetRuiArg( button, "rarityIcon", rarityIcon, eRuiArgType.ASSET )
	RuiSetColorAlpha( Hud_GetRui( button ), "themeCol", themeCol, 1.0 )
	RuiSetColorAlpha( Hud_GetRui( button ), "countTextCol", countTextCol, 1.0 )

	Hud_SetLocked( button, lootBoxCount == 0 )

	Hud_SetEnabled( button, lootBoxCount > 0 )
}


void function PlayPanelUpdate()
{
	UpdateLobbyButtons()
	UpdateHDTextureProgress()
}


bool function ChatroomIsVisibleAndNotFocused()
{
	if ( !file.chatroomMenu )
		return false

	return Hud_IsVisible( file.chatroomMenu ) && !Hud_IsFocused( file.chatroomMenu_chatroomWidget )
}


bool function CanInvite()
{
	if ( GetParty().amIInThis == false )
		return false

	if ( GetParty().numFreeSlots == 0 )
		return false

	#if DURANGO_PROG
		return (GetMenuVarBool( "isFullyConnected" ) && GetMenuVarBool( "DURANGO_canInviteFriends" ) && GetMenuVarBool( "DURANGO_isJoinable" ))
	#elseif PS4_PROG
		return GetMenuVarBool( "PS4_canInviteFriends" )
	#elseif PC_PROG
		return (GetMenuVarBool( "isFullyConnected" ) && GetMenuVarBool( "ORIGIN_isEnabled" ) && GetMenuVarBool( "ORIGIN_isJoinable" ))
	#endif
}


bool function IsExemptFromTraining()
{
	if ( !IsFullyConnected() || !IsPersistenceAvailable() )
		return false

	return GetAccountLevelForXP( GetPersistentVarAsInt( "xp" ) ) >= 14 //
}


bool function IsTrainingCompleted()
{
	if ( !IsFullyConnected() || !IsPersistenceAvailable() )
		return false

	if ( !GetVisiblePlaylistNames().contains( PLAYLIST_TRAINING ) )
		return true

	if ( GetCurrentPlaylistVarBool( "require_training", true ) )
		return GetPersistentVarAsInt( "trainingCompleted" ) > 0

	return true
}


void function OnRemoteMatchInfoUpdated()
{
	RemoteMatchInfo matchInfo = GetRemoteMatchInfo()
	if ( matchInfo.playlist == "" )
		return

	//Party party = GetParty()
	//foreach ( partyMember in party.members )
	//{
	//	var button = GetPartyMemberButton( partyMember.uid )
	//	if ( button == null )
	//		continue
	//
	//	bool memberInMatch = false
	//	foreach ( clientInfo in matchInfo.clients )
	//	{
	//		if ( clientInfo.name == partyMember.name ) // TODO: UID or something better... but that doesn't exist in the matchInfo data
	//			memberInMatch = true
	//	}
	//
	//	var rui = Hud_GetRui( button )
	//	RuiSetBool( rui, "inMatch", memberInMatch )
	//}
}


var function GetPartyMemberButton( string uid )
{
	if ( uid == GetPlayerUID() )
		return file.selfButton
	else if ( uid == file.friendInLeftSpot.id )
		return file.friendButton0
	else if ( uid == file.friendInRightSpot.id )
		return file.friendButton1

	return null
}

#if R5DEV
void function DEV_PrintPartyInfo()
{
	Party party = GetParty()
	printt( "party.partyType", party.partyType )
	printt( "party.playlistName", party.playlistName )
	printt( "party.originatorName", party.originatorName )
	printt( "party.originatorUID", party.originatorUID )
	printt( "party.numSlots", party.numSlots )
	printt( "party.numClaimedSlots", party.numClaimedSlots )
	printt( "party.numFreeSlots", party.numFreeSlots )
	printt( "party.timeLeft", party.timeLeft )
	printt( "party.amIInThis", party.amIInThis )
	printt( "party.amILeader", party.amILeader )
	printt( "party.searching", party.searching )

	foreach ( member in party.members )
	{
		printt( "\tmember.name", member.name )
		printt( "\tmember.uid", member.uid )
		printt( "\tmember.hardware", member.hardware )
		printt( "\tmember.ready", member.ready )

		CommunityUserInfo ornull userInfo = GetUserInfo( member.hardware, member.uid )
		if ( userInfo == null )
			continue

		expect CommunityUserInfo( userInfo )

		DEV_PrintUserInfo( userInfo, "\t\t" )
	}
}

void function DEV_PrintUserInfo( CommunityUserInfo userInfo, string prefix = "" )
{
	printt( prefix + "userInfo.hardware", userInfo.hardware )
	printt( prefix + "userInfo.uid", userInfo.uid )
	printt( prefix + "userInfo.name", userInfo.name )
	printt( prefix + "userInfo.kills", userInfo.kills )
	printt( prefix + "userInfo.wins", userInfo.wins )
	printt( prefix + "userInfo.matches", userInfo.matches )
	printt( prefix + "userInfo.banReason", userInfo.banReason, "(see MATCHBANREASON_)" )
	printt( prefix + "userInfo.banSeconds", userInfo.banSeconds )
	printt( prefix + "userInfo.eliteStreak", userInfo.eliteStreak )
	printt( prefix + "userInfo.rankScore", userInfo.rankScore )
	printt( prefix + "userInfo.lastCharIdx", userInfo.lastCharIdx )
	printt( prefix + "userInfo.isLivestreaming", userInfo.isLivestreaming )
	printt( prefix + "userInfo.isOnline", userInfo.isOnline )
	printt( prefix + "userInfo.isJoinable", userInfo.isJoinable )
	printt( prefix + "userInfo.privacySetting", userInfo.privacySetting )
	printt( prefix + "userInfo.partyFull", userInfo.partyFull )
	printt( prefix + "userInfo.partyInMatch", userInfo.partyInMatch )
	printt( prefix + "userInfo.lastServerChangeTime", userInfo.lastServerChangeTime )

	foreach ( int index, data in userInfo.charData )
	{
		printt( prefix + "\tuserInfo.charData[" + index + "]", data, "\t" + DEV_GetEnumStringSafe( "ePlayerStryderCharDataArraySlots", index ) )
	}
}
#endif


void function AllChallengesButton_OnActivate( var button )
{
	if ( IsDialog( GetActiveMenu() ) )
		return

	if ( !IsTabPanelActive( GetPanel( "PlayPanel" ) ) )
		return

	AdvanceMenu( GetMenu( "AllChallengesMenu" ) )
}


void function Lobby_UpdatePlayPanelPlaylists()
{
	file.playlists = GetVisiblePlaylistNames()
	Assert( file.playlists.len() > 0 )

	if ( !IsFullyConnected() )
		return

	if ( AreWeMatchmaking() )
		return

	//if ( !file.playlists.contains( file.selectedPlaylist ) )
	string compareString = "#MATCHMAKING_LOADING"
	string mmStatus     = GetMyMatchmakingStatus()
	if ( mmStatus.len() >= compareString.len() && mmStatus.slice( 0, compareString.len() ) == compareString )
		return

	if ( IsPartyLeader() && GetPartySize() == 1 && !IsExemptFromTraining() && !IsTrainingCompleted() )
	{
		Lobby_SetSelectedPlaylist( PLAYLIST_TRAINING )
		SetMatchmakingPlaylist( PLAYLIST_TRAINING ) //
	}
	else if ( !file.playlists.contains( file.selectedPlaylist ) || (file.selectedPlaylist == PLAYLIST_TRAINING) )
	{
		bool foundDefault = false
		foreach ( playlist in file.playlists )
		{
			if ( GamemodeSelectV2_PlaylistIsDefaultSlot( playlist ) )
			{
				Lobby_SetSelectedPlaylist( playlist )
				foundDefault = true
				break
			}
		}

		if ( !foundDefault )
		{
			foreach ( playlist in file.playlists )
			{
				if ( playlist == PLAYLIST_TRAINING )
					continue

				Lobby_SetSelectedPlaylist( playlist )
				break
			}
		}
	}

	if ( PartyHasEliteAccess() )
	{
		if ( GetPersistentVar( "shouldForceElitePlaylist" ) )
			ForceElitePlaylist()
	}
	else if ( IsElitePlaylist( file.selectedPlaylist ) )
	{
		ForceNonElitePlaylist()
	}
}


void function ForceElitePlaylist()
{
	printt( "ForceElitePlaylist" )
	foreach ( playlist in file.playlists )
	{
		if ( !IsElitePlaylist( playlist ) )
			continue

		Lobby_SetSelectedPlaylist( playlist )
		break
	}
}


void function ForceNonElitePlaylist()
{
	printt( "ForceNonElitePlaylist" )
	foreach ( playlist in file.playlists )
	{
		if ( IsElitePlaylist( playlist ) )
			continue

		Lobby_SetSelectedPlaylist( playlist )
		break
	}
}


bool function HasEliteAccess()
{
	//if ( !IsFullyConnected() )
		return false

	//return GetPersistentVarAsInt( "hasEliteAccess" ) > 0
}


bool function PartyHasEliteAccess()
{
	if ( !IsFullyConnected() )
		return false

	if ( HasEliteAccess() )
		return true

	if ( GetCurrentPlaylistVarBool( "elite_dev_playtest", false ) )
		return true

	Party party = GetParty()
	foreach ( member in party.members )
	{
		CommunityUserInfo ornull userInfoOrNull = GetUserInfo( member.hardware, member.uid )

		if ( userInfoOrNull != null )
		{
			CommunityUserInfo userInfo = expect CommunityUserInfo(userInfoOrNull)

			if ( userInfo.eliteStreak > 0 )
				return true
		}
	}

	return false
}

bool function PartyHasRankedAccess()
{
	if ( !IsFullyConnected() )
		return false

	if ( GetCurrentPlaylistVarBool( "ranked_dev_playtest", false ) )
		return true

	Party party = GetParty()
	if ( party.members.len() == 0 )
	{
		if ( IsPersistenceAvailable() )
			return GetAccountLevelForXP( GetPersistentVarAsInt( "xp" ) ) >= RANKED_LEVEL_REQUIREMENT
		else
			return false
	}

	bool allPartyMembersMeetRankedLevelRequirement = true
	bool allPartyMembersHaveNoMatchmakingDelay     = true //


	foreach ( member in party.members )
	{
		CommunityUserInfo ornull userInfoOrNull = GetUserInfo( member.hardware, member.uid )

		if ( userInfoOrNull != null )
		{
			CommunityUserInfo userInfo = expect CommunityUserInfo(userInfoOrNull)

			if ( userInfo.charData[ePlayerStryderCharDataArraySlots.ACCOUNT_LEVEL] < RANKED_LEVEL_REQUIREMENT )
			{
				allPartyMembersMeetRankedLevelRequirement = false
				break
			}

			if ( Ranked_GetMatchmakingDelayFromCommunityUserInfo( userInfo ) > 0 )
			{
				allPartyMembersHaveNoMatchmakingDelay = false
				break
			}
		}
		else
		{
			allPartyMembersMeetRankedLevelRequirement = false
			break
		}
	}

	return allPartyMembersMeetRankedLevelRequirement //
}


void function PulseModeButton()
{
	var rui = Hud_GetRui( file.modeButton )
	RuiSetGameTime( rui, "startPulseTime", Time() )
}


void function Ranked_OnPartyMemberAdded()
{
	file.haveShownPartyMemberMatchmakingDelay = false
	TryShowMatchmakingDelayDialog()
}


void function UpdateCurrentMaxMatchmakingDelayEndTime()
{
	file.currentMaxMatchmakingDelayEndTime = Ranked_GetMaxPartyMatchmakingDelay() + Time()
}


void function TryShowMatchmakingDelayDialog()
{
	if ( !ShouldShowMatchmakingDelayDialog() )
		return

	DialogFlow()
}


bool function ShouldShowMatchmakingDelayDialog()
{
	if ( !IsLobby() )
		return false

	if ( !IsFullyConnected() )
		return false

	if ( GetActiveMenu() != GetMenu( "LobbyMenu" ) )
		return false

	if ( !IsTabPanelActive( GetPanel( "PlayPanel" ) ) )
		return false

	bool amIbanned = false

	array< PartyMember > bannedPartyMembers
	foreach ( index, member in GetParty().members )
	{
		CommunityUserInfo ornull userInfoOrNull = GetUserInfo( member.hardware, member.uid )
		if ( userInfoOrNull != null )
		{
			CommunityUserInfo userInfo = expect CommunityUserInfo( userInfoOrNull )
			int matchMakingDelay       = Ranked_GetMatchmakingDelayFromCommunityUserInfo( userInfo )
			if ( matchMakingDelay > 0 )
			{
				bannedPartyMembers.append( member )

				if ( GetPlayerUID() == userInfo.uid )//
				{
					amIbanned = true
				}
			}
		}
	}

	if ( bannedPartyMembers.len() == 0 )
		return false

	if ( amIbanned && bannedPartyMembers.len() == 1 && file.haveShownSelfMatchmakingDelay )
		return false

	return !(file.haveShownPartyMemberMatchmakingDelay)
}


void function ShowMatchmakingDelayDialog()
{
	bool amIbanned = false

	array< PartyMember > bannedPartyMembers
	int maxDelayTime = -1
	foreach ( index, member in GetParty().members )
	{
		CommunityUserInfo ornull userInfoOrNull = GetUserInfo( member.hardware, member.uid )
		if ( userInfoOrNull != null )
		{
			CommunityUserInfo userInfo = expect CommunityUserInfo( userInfoOrNull )
			int matchMakingDelay       = Ranked_GetMatchmakingDelayFromCommunityUserInfo( userInfo )
			if ( matchMakingDelay > 0 )
			{
				bannedPartyMembers.append( member )

				if ( GetPlayerUID() == userInfo.uid )
				{
					amIbanned = true
				}

				if ( matchMakingDelay > maxDelayTime )
					maxDelayTime = matchMakingDelay
			}
		}
	}

	Assert( bannedPartyMembers.len() > 0 )
	ConfirmDialogData dialogData
	dialogData.resultCallback = void function ( int result )
	{
		DialogFlow()
	}

	if ( amIbanned && bannedPartyMembers.len() == 1 )
	{
		if ( !file.haveShownSelfMatchmakingDelay )
		{
			dialogData.headerText = "#RANKED_ABANDON_PENALTY_HEADER"
			dialogData.messageText = "#RANKED_ABANDON_PENALTY_MESSAGE"
			file.haveShownSelfMatchmakingDelay = true
		}
	}
	else
	{
		file.haveShownPartyMemberMatchmakingDelay = true
		switch( bannedPartyMembers.len() )
		{
			case 1:
				dialogData.headerText = "#RANKED_ONE_PARTY_MEMBER_ABANDON_PENALTY_HEADER"
				dialogData.messageText = Localize( "#RANKED_ONE_PARTY_MEMBER_ABANDON_PENALTY_MESSAGE", bannedPartyMembers[ 0 ].name )
				break

			case 2:
				dialogData.headerText = "#RANKED_TWO_PARTY_MEMBER_ABANDON_PENALTY_HEADER"
				dialogData.messageText = Localize( "#RANKED_TWO_PARTY_MEMBER_ABANDON_PENALTY_MESSAGE", bannedPartyMembers[ 0 ].name, bannedPartyMembers[ 1 ].name )
				break

			case 3:
				dialogData.headerText = "#RANKED_ALL_PARTY_MEMBERS_ABANDON_PENALTY_HEADER"
				dialogData.messageText = Localize( "#RANKED_ALL_PARTY_MEMBERS_ABANDON_PENALTY_MESSAGE", bannedPartyMembers[ 0 ].name, bannedPartyMembers[ 1 ].name, bannedPartyMembers[ 2 ].name )
				break

			default:
				unreachable
		}
	}

	dialogData.contextImage = $"ui/menu/common/dialog_notice"
	dialogData.timerEndTime = Time() + maxDelayTime

	OpenOKDialogFromData( dialogData )
}


bool function ShouldShowLastGameRankedAbandonForgivenessDialog()
{
	if ( !IsLobby() )
		return false

	if ( !IsFullyConnected() )
		return false

	if ( GetActiveMenu() != GetMenu( "LobbyMenu" ) )
		return false

	if ( !IsTabPanelActive( GetPanel( "PlayPanel" ) ) )
		return false

	if ( file.haveShownLastGameRankedAbandonForgivenessDialog )
		return false

	var lastGameAbandonForgiveness = GetRankedPersistenceData( GetUIPlayer(), "lastGameAbandonForgiveness" )

	if ( lastGameAbandonForgiveness == null )
		return false

	return expect bool ( lastGameAbandonForgiveness  )
}


void function ShowLastGameRankedAbandonForgivenessDialog()
{
	ConfirmDialogData dialogData
	dialogData.resultCallback = void function ( int result )
	{
		DialogFlow()
	}

	int numUsedForgivenessAbandons = expect int ( GetRankedPersistenceData( GetUIPlayer(), "numUsedForgivenessAbandons" ) )

	if ( numUsedForgivenessAbandons == GetCurrentPlaylistVarInt( "ranked_num_abandon_forgiveness_games", RANKED_NUM_ABANDON_FORGIVENESS_GAMES ) )
	{
		dialogData.headerText = "#RANKED_ABANDON_FORGIVENESS_LAST_CHANCE_HEADER"
		dialogData.messageText = "#RANKED_ABANDON_FORGIVENESS_LAST_CHANCE_MESSAGE"
	}
	else
	{
		dialogData.headerText = "#RANKED_ABANDON_FORGIVENESS_HEADER"
		dialogData.messageText = "#RANKED_ABANDON_FORGIVENESS_MESSAGE"
	}

	dialogData.contextImage = $"ui/menu/common/dialog_notice"

	file.haveShownLastGameRankedAbandonForgivenessDialog = true

	OpenOKDialogFromData( dialogData )
}


void function Ranked_OnLevelInit()
{
	if ( !IsLobby() )
		return

	file.haveShownSelfMatchmakingDelay = false
	file.haveShownLastGameRankedAbandonForgivenessDialog = false
	file.haveShownPartyMemberMatchmakingDelay = false
	file.currentMaxMatchmakingDelayEndTime = -1

	if ( !file.rankedInitialized )
	{
		AddCallbackAndCallNow_UserInfoUpdated( Ranked_OnUserInfoUpdated )
		file.rankedInitialized = true
	}

	TryShowMatchmakingDelayDialog()
}


void function Ranked_OnUserInfoUpdated( string hardware, string id )
{
	if ( !IsConnected() )
		return

	if ( !IsLobby() )
		return

	if ( hardware == "" && id == "" )
		return

	CommunityUserInfo ornull cui = GetUserInfo( hardware, id )

	if ( cui == null )
		return

	expect CommunityUserInfo( cui )

	bool foundPartyMember = false

	foreach ( index, member in GetParty().members )
	{
		if ( cui.hardware != member.hardware && cui.uid != member.uid )
			continue

		foundPartyMember = true
		break
	}

	if ( !foundPartyMember )
		return

	int matchMakingDelay = Ranked_GetMaxPartyMatchmakingDelay()

	if ( matchMakingDelay > 0 )
	{
		file.currentMaxMatchmakingDelayEndTime = matchMakingDelay + Time()
		TryShowMatchmakingDelayDialog()
	}
}

array<int> POPUP_LEVEL_MARKERS = [ 25, 53, 77, 100 ]

void function Lobby_ShowBattlePassPopup( bool forceShow = false )
{
	Signal( uiGlobal.signalDummy, "Lobby_ShowBattlePassPopup" )
	EndSignal( uiGlobal.signalDummy, "Lobby_ShowBattlePassPopup" )

	TabData lobbyTabData = GetTabDataForPanel( GetMenu( "LobbyMenu" ) )
	int idx = Tab_GetTabIndexByBodyName( lobbyTabData, "PassPanelV2" )

	while ( !GRX_IsInventoryReady() )
		WaitFrame()

	ItemFlavor ornull activeBattlePass = GetActiveBattlePass()

	if ( activeBattlePass == null )
		return

	expect ItemFlavor( activeBattlePass )

	entity player = GetUIPlayer()

	if ( DoesPlayerOwnBattlePass( player, activeBattlePass ) && !forceShow )
		return

	int currentXPProgress = GetPlayerBattlePassXPProgress( ToEHI( player ), activeBattlePass, false )
	int bpLevel = GetBattlePassLevelForXP( activeBattlePass, currentXPProgress )

	BattlePassReward ornull rewardToShow = null

	int markerLevel = 0

	foreach ( level in POPUP_LEVEL_MARKERS )
	{
		if ( level-1 <= bpLevel )
			markerLevel=level-1
	}

	if ( markerLevel <= 0 && !forceShow )
		return

	string bpString = ItemFlavor_GetGUIDString( activeBattlePass )

	if ( markerLevel <= player.GetPersistentVar( format( "battlePasses[%s].lastPopupLevel", bpString ) ) && !forceShow )
		return

	array<BattlePassReward> rewards = GetBattlePassLevelRewards( activeBattlePass, markerLevel )

	foreach ( reward in rewards )
	{
		if ( !reward.isPremium )
			continue

		rewardToShow = reward
		break
	}

	if ( rewardToShow == null )
		return

	expect BattlePassReward( rewardToShow )

	var popup = Hud_GetChild( file.panel, "PopupMessage" )
	Lobby_MovePopupMessage( idx )
	RuiSetImage( Hud_GetRui( popup ), "buttonImage", CustomizeMenu_GetRewardButtonImage( rewardToShow.flav ) )
	int rarity = ItemFlavor_HasQuality( rewardToShow.flav ) ? ItemFlavor_GetQuality( rewardToShow.flav ) : 0
	RuiSetInt( Hud_GetRui( popup ), "rarity", rarity )
	RuiSetInt( Hud_GetRui( popup ), "level", bpLevel+1 )
	BattlePass_SetTallButtonSettings( rewardToShow.flav, Hud_GetRui( popup ), null, false )
	BattlePass_SetUnlockedString( popup, bpLevel+1 )

	wait 0.2

	while ( GetActiveMenu() != GetMenu( "LobbyMenu" ) || !IsPanelActive( file.panel ) )
		WaitFrame()

	RuiSetGameTime( Hud_GetRui( popup ), "animStartTime", Time() )
	ClientCommand( "MarkBattlePassPopupAsSeen " + bpString + " " + markerLevel )
	EmitUISound( SOUND_BP_POPUP )
	thread BP_PopupThink( popup )
}

void function BP_PopupThink( var popup )
{
	Signal( uiGlobal.signalDummy, "BP_PopupThink" )
	EndSignal( uiGlobal.signalDummy, "BP_PopupThink" )

	OnThreadEnd(
		function() : ( popup )
		{
			Hud_Hide( popup )
		}
	)

	Hud_Show( popup )

	wait 10.0

	while ( GetFocus() == popup )
		wait 1.0
}

void function OnClickBPPopup( var button )
{
	TabData tabData = GetTabDataForPanel( Hud_GetParent( file.panel ) )
	AdvanceMenu( GetMenu( "PassPurchaseMenu" ) )
	Hud_Hide( button )
}

void function Lobby_MovePopupMessage( int tabIndex )
{
	var button = Hud_GetChild( file.panel, "PopupMessage" )

	var lobbyTabs = Hud_GetChild( GetMenu( "LobbyMenu" ), "TabsCommon" )

	var tabButton = Hud_GetChild( lobbyTabs, "Tab0" )

	int offset = 0
	if ( tabIndex==0 )
	{
		offset += Hud_GetX( tabButton )
	}
	else
	{
		for ( int i=0; i<tabIndex; i++ )
		{
			var bt = Hud_GetChild( lobbyTabs, "Tab"+i )
			offset += Hud_GetWidth( bt )
			offset += Hud_GetX( bt )
		}
	}

	Hud_SetX( button, offset )
}