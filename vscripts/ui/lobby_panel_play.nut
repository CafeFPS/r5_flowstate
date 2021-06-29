global function InitPlayPanel

global function PlayPanelUpdate
global function ClientToUI_PartyMemberJoinedOrLeft
global function GetModeSelectButton
global function GetLobbyChatBox

global function Lobby_GetPlaylists
global function Lobby_GetSelectedPlaylist
global function Lobby_IsPlaylistAvailable
global function Lobby_SetSelectedPlaylist

global function Lobby_GetPlaylistState
global function Lobby_GetPlaylistStateString

global function Lobby_UpdatePlayPanelPlaylists

global function CanInvite

global function UpdateLootBoxButton

#if R5DEV
global function DEV_PrintPartyInfo
global function DEV_PrintUserInfo
#endif

const string SOUND_START_MATCHMAKING_1P = "UI_Menu_ReadyUp_1P"
const string SOUND_STOP_MATCHMAKING_1P = "UI_Menu_ReadyUp_Cancel_1P"
const string SOUND_START_MATCHMAKING_3P = "UI_Menu_ReadyUp_3P"
const string SOUND_STOP_MATCHMAKING_3P = "UI_Menu_ReadyUp_Cancel_3P"

global enum ePlaylistState
{
	AVAILABLE,
	NO_PLAYLIST,
	TRAINING_REQUIRED,
	PARTY_SIZE_OVER,
}


const table< int, string > playlistStateMap = {
	[ ePlaylistState.NO_PLAYLIST ] = "#PLAYLIST_STATE_NO_PLAYLIST",
	[ ePlaylistState.TRAINING_REQUIRED ] = "#PLAYLIST_STATE_TRAINING_REQUIRED",
	[ ePlaylistState.AVAILABLE ] = "#PLAYLIST_STATE_AVAILABLE",
	[ ePlaylistState.PARTY_SIZE_OVER ] = "#PLAYLIST_STATE_PARTY_SIZE_OVER",
}

const string PLAYLIST_TRAINING = "survival_training"

struct
{
	var chatBox
	var chatroomMenu
	var chatroomMenu_chatroomWidget

	var fillButton
	var modeButton
	var readyButton
	var trainingButton
	var inviteFriendsButton0
	var inviteFriendsButton1
	var friendButton0
	var friendButton1

	var selfButton

	var openLootBoxButton

	var hdTextureProgress

	array<string> playlists
	string        selectedPlaylist

	bool   personInLeftSpot = false
	bool   personInRightSlot = false

	Friend& friendInLeftSpot
	Friend& friendInRightSpot

	bool leftWasReady = false
	bool rightWasReady = false

	bool fullInstallNotification = false
} file


void function InitPlayPanel( var panel )
{
	SetPanelTabTitle( panel, "#PLAY" )
	AddPanelEventHandler( panel, eUIEvent.PANEL_SHOW, PlayPanel_OnShow )
	AddPanelEventHandler( panel, eUIEvent.PANEL_HIDE, PlayPanel_OnHide )
	AddPanelEventHandler( panel, eUIEvent.PANEL_NAVBACK, PlayPanel_OnNavBack )

	SetPanelInputHandler( panel, BUTTON_Y, ReadyShortcut_OnActivate )

	file.fillButton = Hud_GetChild( panel, "FillButton" )
	Hud_SetVisible( file.fillButton, GetCurrentPlaylistVarBool( "enable_teamNoFill", false ) )
	Hud_AddEventHandler( file.fillButton, UIE_CLICK, FillButton_OnActivate )

	file.modeButton = Hud_GetChild( panel, "ModeButton" )
	Hud_AddEventHandler( file.modeButton, UIE_CLICK, ModeButton_OnActivate )

	file.readyButton = Hud_GetChild( panel, "ReadyButton" )
	Hud_AddEventHandler( file.readyButton, UIE_CLICK, ReadyButton_OnActivate )

	file.inviteFriendsButton0 = Hud_GetChild( panel, "InviteFriendsButton0" )
	Hud_AddEventHandler( file.inviteFriendsButton0, UIE_CLICK, InviteFriendsButton_OnActivate )

	file.inviteFriendsButton1 = Hud_GetChild( panel, "InviteFriendsButton1" )
	Hud_AddEventHandler( file.inviteFriendsButton1, UIE_CLICK, InviteFriendsButton_OnActivate )

	file.selfButton = Hud_GetChild( panel, "SelfButton" )
	Hud_AddEventHandler( file.selfButton, UIE_CLICK, FriendButton_OnActivate )

	file.friendButton0 = Hud_GetChild( panel, "FriendButton0" )
	Hud_AddEventHandler( file.friendButton0, UIE_CLICK, FriendButton_OnActivate )
	Hud_AddEventHandler( file.friendButton0, UIE_CLICKRIGHT, FriendButton_OnRightClick )

	file.friendButton1 = Hud_GetChild( panel, "FriendButton1" )
	Hud_AddEventHandler( file.friendButton1, UIE_CLICK, FriendButton_OnActivate )
	Hud_AddEventHandler( file.friendButton1, UIE_CLICKRIGHT, FriendButton_OnRightClick )

	file.openLootBoxButton = Hud_GetChild( panel, "OpenLootBoxButton" )
	HudElem_SetRuiArg( file.openLootBoxButton, "buttonText", Localize( "#OPEN_LOOT" ) )
	Hud_AddEventHandler( file.openLootBoxButton, UIE_CLICK, OpenLootBoxButton_OnActivate )

	AddMenuVarChangeHandler( "isMatchmaking", UpdateLobbyButtons )

	file.chatBox = Hud_GetChild( panel, "ChatRoomTextChat" )
	file.hdTextureProgress = Hud_GetChild( panel, "HDTextureProgress" )

	RegisterSignal( "UpdateFriendButtons" )
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
	UI_SetPresentationType( ePresentationType.PLAY )

	if ( IsFullyConnected() )
	{
		AccessibilityHint( eAccessibilityHint.LOBBY_CHAT )
	}

	UpdateLobbyButtons()

	if ( file.chatroomMenu )
	{
		Hud_Hide( file.chatroomMenu )
		Hud_Hide( file.chatroomMenu_chatroomWidget )
	}
	AddCallbackAndCallNow_OnGRXInventoryStateChanged( UpdateLootBoxStatus )
	AddCallbackAndCallNow_RemoteMatchInfoUpdated( OnRemoteMatchInfoUpdated )

	ClientCommand( "ViewingMainLobbyPage" )
}


void function UpdateLobbyButtons()
{
	if ( !IsConnected() )
		return

	UpdateFillButton()
	UpdateReadyButton()
	UpdateModeButton()
	UpdateFriendButtons()
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

bool function ShowDownloadCompleteDialog()
{
	if ( GetGameFullyInstalledProgress() != 1 )
		return false

	if ( !HasNonFullyInstalledAssetsLoaded() )
		return false

	if  ( file.fullInstallNotification )
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
	return file.selectedPlaylist
}


bool function Lobby_IsPlaylistAvailable( string playlistName )
{
	return Lobby_GetPlaylistState( playlistName ) == ePlaylistState.AVAILABLE
}


int function GetPlaylistIndexForName( string playlist )
{
	int count = GetPlaylistCount()
	for ( int idx = 0; idx < count; ++idx )
	{
		string ornull thisPlaylist = GetPlaylistName( idx )
		if ( thisPlaylist == playlist )
			return idx
	}

	return -1
}


void function Lobby_SetSelectedPlaylist( string playlistName )
{
	file.selectedPlaylist = playlistName
	UpdateLobbyButtons()

	if ( playlistName.len() > 0 )
		SetMatchmakingPlaylist( playlistName )
}


void function PlayPanel_OnHide( var panel )
{
	Signal( uiGlobal.signalDummy, "UpdateFriendButtons" )
	RemoveCallback_OnGRXInventoryStateChanged( UpdateLootBoxStatus )
	RemoveCallback_RemoteMatchInfoUpdated( OnRemoteMatchInfoUpdated )
}


void function UpdateFriendButton( var rui, PartyMember info, bool inMatch )
{
	Party party = GetParty()

	RuiSetString( rui, "playerName", info.name )
	RuiSetBool( rui, "isLeader", party.originatorUID == info.uid && GetPartySize() > 1 )
	RuiSetBool( rui, "isReady", info.ready )
	RuiSetBool( rui, "inMatch", inMatch )
	thread KeepMicIconUpdated( info, rui )

	CommunityUserInfo ornull userInfo = GetCommunityUserInfo( info.hardware, info.uid )
	if ( userInfo == null )
	{
		RuiSetFloat( rui, "accountXPFrac", 0.0 )
		RuiSetString( rui, "accountLevel", "" )

		int accountLevel = 0
		if ( info.uid == GetPlayerUID() && IsPersistenceAvailable() )
			accountLevel = GetAccountLevelForXP( GetPersistentVarAsInt( "xp" ) )

		RuiSetString( rui, "accountLevel", GetAccountDisplayLevel( accountLevel ) )
		RuiSetImage( rui, "accountBadge", GetAccountDisplayBadge( accountLevel ) )
	}
	else
	{
		expect CommunityUserInfo( userInfo )
		RuiSetFloat( rui, "accountXPFrac", userInfo.charData[ePlayerStryderCharDataArraySlots.ACCOUNT_PROGRESS_INT] / 100.0 )
		RuiSetString( rui, "accountLevel", GetAccountDisplayLevel( userInfo.charData[ePlayerStryderCharDataArraySlots.ACCOUNT_LEVEL] ) )
		RuiSetImage( rui, "accountBadge", GetAccountDisplayBadge( userInfo.charData[ePlayerStryderCharDataArraySlots.ACCOUNT_LEVEL] ) )
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

	#if PC_PROG
		if ( !Origin_IsOverlayAvailable() && !GetCurrentPlaylistVarBool( "social_menu_enabled", true ) )
		{
			toolTipData.descText = "#ORIGIN_INGAME_REQUIRED"
			Hud_SetLocked( file.inviteFriendsButton0, true )
			Hud_SetLocked( file.inviteFriendsButton1, true )
		}
	#endif // PC_PROG

	Hud_SetToolTipData( file.inviteFriendsButton0, toolTipData )
	Hud_SetToolTipData( file.inviteFriendsButton1, toolTipData )
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

	if ( !CompletedTraining() && playlistName != PLAYLIST_TRAINING && GetPartySize() == 1 )
		return ePlaylistState.TRAINING_REQUIRED

	if ( GetPartySize() > GetMaxTeamSizeForPlaylist( playlistName ) )
		return ePlaylistState.PARTY_SIZE_OVER

	return ePlaylistState.AVAILABLE
}


string function Lobby_GetPlaylistStateString( int playlistState )
{
	return playlistStateMap[playlistState]
}


void function UpdateReadyButton()
{
	bool isLeader = IsPartyLeader()

	bool isReady = GetConVarBool( "party_readyToSearch" )

	string buttonText
	if ( isReady )
		buttonText = IsControllerModeActive() ? "#B_BUTTON_CANCEL" : "#CANCEL"
	else
		buttonText = IsControllerModeActive() ? "#Y_BUTTON_READY" : "#READY"

	HudElem_SetRuiArg( file.readyButton, "isLeader", isLeader ) // TEMP
	HudElem_SetRuiArg( file.readyButton, "isReady", isReady )
	HudElem_SetRuiArg( file.readyButton, "buttonText", Localize( buttonText ) )

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

	Hud_SetLocked( file.modeButton, !CanActivateModeButton() )

	bool isReady = GetConVarBool( "party_readyToSearch" )
	Hud_SetEnabled( file.modeButton, !isReady && CanActivateModeButton() )
	HudElem_SetRuiArg( file.modeButton, "isReady", isReady )

	bool isLeader = IsPartyLeader()

	string playlistName        = isLeader ? file.selectedPlaylist : GetParty().playlistName
	string invalidPlaylistText = isLeader ? "#SELECT_PLAYLIST" : "#PARTY_LEADER_CHOICE"

	string name = GetPlaylistVarOrUseValue( playlistName, "name", invalidPlaylistText )
	HudElem_SetRuiArg( file.modeButton, "buttonText", Localize( name ) )
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

	AdvanceMenu( GetMenu( "ModeSelectDialog" ) )
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

		ReadyButtonActivate()
	}
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
			dialogData.headerText = "#UNAVAILABLE"
			dialogData.messageText = "#ORIGIN_UNDERAGE_ONLINE"
			dialogData.contextImage = $"ui/menu/common/dialog_notice"

			OpenOKDialogFromData( dialogData )
			return
		}
	#endif

	thread CreatePartyAndInviteFriends()
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


void function UpdateLootBoxStatus()
{
	bool isReady = GRX_IsInventoryReady()

	int lootBoxCount = 0
	if ( isReady )
		lootBoxCount = GRX_GetTotalPackCount()

	Hud_SetVisible( file.openLootBoxButton, lootBoxCount > 0 )

	UpdateLootBoxButton( file.openLootBoxButton )
}


void function UpdateLootBoxButton( var button )
{
	string buttonText
	string descText
	int lootBoxCount

	if ( GRX_IsInventoryReady() )
	{
		lootBoxCount = GRX_GetTotalPackCount()
		buttonText = lootBoxCount == 1 ? "#LOOT_BOX" : "#LOOT_BOXES"
		descText = "#LOOT_REMAINING"
	}
	else
	{
		lootBoxCount = 0
		buttonText = "#LOOT_BOXES"
		descText = "#UNAVAILABLE"
	}

	HudElem_SetRuiArg( button, "bigText", string( lootBoxCount ) )
	HudElem_SetRuiArg( button, "buttonText", buttonText )
	HudElem_SetRuiArg( button, "descText", descText )
	HudElem_SetRuiArg( button, "lootBoxCount", lootBoxCount )
	HudElem_SetRuiArg( button, "badLuckProtectionActive", GRX_IsBadLuckProtectionActive() )

	Hud_SetLocked( button, lootBoxCount == 0 )
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
	if ( Player_NextAvailableMatchmakingTime( GetUIPlayer() ) > 0 )
		return false

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


bool function CompletedTraining()
{
	if ( !IsFullyConnected() || !IsPersistenceAvailable() )
		return false

	if ( !GetVisiblePlaylists().contains( PLAYLIST_TRAINING ) )
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
	printt( prefix + "userInfo.lastCharIdx", userInfo.lastCharIdx )
	printt( prefix + "userInfo.isLivestreaming", userInfo.isLivestreaming )
	printt( prefix + "userInfo.isOnline", userInfo.isOnline )
	printt( prefix + "userInfo.isJoinable", userInfo.isJoinable )
	printt( prefix + "userInfo.privacySetting", userInfo.privacySetting )

	foreach ( int index, data in userInfo.charData )
	{
		printt( prefix + "\tuserInfo.charData[" + index + "]", data, "\t" + DEV_GetEnumStringSafe( "ePlayerStryderCharDataArraySlots", index ) )
	}
}
#endif

void function Lobby_UpdatePlayPanelPlaylists()
{
	file.playlists = GetVisiblePlaylists()
	Assert( file.playlists.len() > 0 )
	//if ( !file.playlists.contains( file.selectedPlaylist ) )

	if ( IsFullyConnected() )
	{
		if ( !AreWeMatchmaking() )
		{
			if ( !CompletedTraining() && IsPartyLeader() && GetPartySize() == 1 )
			{
				Lobby_SetSelectedPlaylist( PLAYLIST_TRAINING )
				SetMatchmakingPlaylist( PLAYLIST_TRAINING ) // to preload the map
			}
			else if ( !file.playlists.contains( file.selectedPlaylist ) || file.selectedPlaylist == PLAYLIST_TRAINING )
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
	}

}