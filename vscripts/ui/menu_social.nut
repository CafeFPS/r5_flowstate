global function InitSocialMenu
global function InitInspectMenu
global function InspectFriend

const UPDATE_RATE = 1.0

enum ePageButtonType
{
	PAGE_INDEX
	PAGE_NEXT
	PAGE_PREV
}

struct PageButtonDef
{
	var button

	int pageButtonType
	int pageIndex
}

struct
{
	var                menu
	array<Friend>      friends
	table<var, Friend> buttonToFriend

	var myGridButton

	var leavePartyButton
	var addFriendButton
	var partyPrivacyButton
	var steamButton
	var gridSpinner

	FriendsData& friendsData
	Friend&      actionFriend
	var          actionButton

	int panePageIndex = 0
	int pagerPageIndex = 0

	var friendGrid
	var decorationRui
	var menuHeaderRui

	array<var> pageButtons

	array<PageButtonDef> pageButtonDefs

	float nextFriendsListUpdate

	table<var, float> nextInviteTimes
} s_socialFile

struct
{
	var menu
	var combinedCard
	var decorationRui
	var menuHeaderRui
} s_inspectFile


const int FRIEND_GRID_ROWS = 7
const int FRIEND_GRID_COLUMNS = 3

void function InitSocialMenu()
{
	RegisterSignal( "HaltPreviewFriendCosmetics" )

	var menu = GetMenu( "SocialMenu" )
	s_socialFile.menu = menu

	s_socialFile.myGridButton = Hud_GetChild( menu, "MyGridButton" )
	Hud_AddKeyPressHandler( s_socialFile.myGridButton, MyFriendButton_OnKeyPress )

	AddMenuEventHandler( menu, eUIEvent.MENU_OPEN, SocialMenu_OnOpen )
	AddMenuEventHandler( menu, eUIEvent.MENU_CLOSE, SocialMenu_OnClose )

	AddMenuEventHandler( menu, eUIEvent.MENU_SHOW, SocialMenu_OnShow )

	AddMenuThinkFunc( menu, SocialMenuThink )

	s_socialFile.gridSpinner = Hud_GetChild( menu, "FriendGridBackground" )

	s_socialFile.leavePartyButton = Hud_GetChild( menu, "LeavePartyButton" )
	HudElem_SetRuiArg( s_socialFile.leavePartyButton, "buttonText", "#LEAVE_PARTY" )
	HudElem_SetRuiArg( s_socialFile.leavePartyButton, "icon", $"rui/menu/common/leave_party" )
	Hud_AddEventHandler( s_socialFile.leavePartyButton, UIE_CLICK, OnLeavePartyButton_Activate )

	s_socialFile.addFriendButton = Hud_GetChild( menu, "AddFriendButton" )
	HudElem_SetRuiArg( s_socialFile.addFriendButton, "buttonText", "#ADD_FRIEND" )
	HudElem_SetRuiArg( s_socialFile.addFriendButton, "icon", $"rui/menu/common/add_friend" )
	Hud_SetEnabled( s_socialFile.addFriendButton, false )

	s_socialFile.partyPrivacyButton = Hud_GetChild( menu, "PartyPrivacyButton" )
	HudElem_SetRuiArg( s_socialFile.partyPrivacyButton, "icon", $"rui/menu/common/party_privacy" )
	Hud_AddEventHandler( s_socialFile.partyPrivacyButton, UIE_CLICK, OnPartyPrivacyButton_Activate )

	AddMenuFooterOption( menu, LEFT, BUTTON_B, true, "#B_BUTTON_BACK", "#B_BUTTON_BACK" )

	#if PC_PROG
		s_socialFile.steamButton = Hud_GetChild( s_socialFile.menu, "SteamLink" )
		HudElem_SetRuiArg( s_socialFile.steamButton, "icon", $"rui/menu/common/steam_link" )
		Hud_AddEventHandler( s_socialFile.steamButton, UIE_CLICK, OnSteamLinkButton_Activate )
	#endif
	s_socialFile.menuHeaderRui = Hud_GetRui( Hud_GetChild( s_socialFile.menu, "MenuHeader" ) )
	s_socialFile.decorationRui = Hud_GetRui( Hud_GetChild( s_socialFile.menu, "Decoration" ) )
	s_socialFile.friendGrid = Hud_GetChild( menu, "FriendGrid" )
	GridPanel_Init( s_socialFile.friendGrid, FRIEND_GRID_ROWS, FRIEND_GRID_COLUMNS, OnBindFriendGridFriend, GetFriendCount, FriendButtonInit )

	var buttonSizer = Hud_GetChild( s_socialFile.friendGrid, "GridButton0x0" )
	int baseWidth   = Hud_GetBaseWidth( buttonSizer )
	GridPanel_InitStatic( s_socialFile.friendGrid, baseWidth, int( baseWidth * 0.2 ) ) // TODO: * 0.2 because Hud_GetHeight is returning the same value as get width...

	GridPanel_SetButtonHandler( s_socialFile.friendGrid, UIE_CLICK, FriendButton_OnActivate )
	GridPanel_SetButtonHandler( s_socialFile.friendGrid, UIE_CLICKRIGHT, FriendButton_OnJoin )
	GridPanel_SetKeyPressHandler( s_socialFile.friendGrid, FriendButton_OnKeyPress )
	//GridPanel_SetButtonHandler( s_socialFile.friendGrid, UIE_CLICKRIGHT, FriendButton_OnInspect )
	GridPanel_SetButtonHandler( s_socialFile.friendGrid, UIE_GET_FOCUS, FriendButton_OnGetFocus )

	RuiSetString( s_socialFile.menuHeaderRui, "menuName", "#MENU_TITLE_FRIENDS" )

	s_socialFile.pageButtons = GetPanelElementsByClassname( menu, "PaginationButton" )
	s_socialFile.pageButtons.sort( SortByScriptId )
	foreach ( pageButton in s_socialFile.pageButtons )
	{
		Hud_SetVisible( pageButton, false )
		Hud_AddEventHandler( pageButton, UIE_CLICK, OnPageButton_Activate )

		PageButtonDef pageButtonDef
		pageButtonDef.button = pageButton
		s_socialFile.pageButtonDefs.append( pageButtonDef )
	}
}


void function SocialMenuThink( var menu )
{
	UpdateFriendsList()
	UpdateMyFriendButton()

	if ( Time() > s_socialFile.nextFriendsListUpdate )
	{
		SocialMenu_Update()
		s_socialFile.nextFriendsListUpdate = Time() + 1.0
	}

	#if PC_PROG
		UpdateSteamButton()
	#endif

	if ( GetConVarString( "party_privacy" ) == "open" )
		HudElem_SetRuiArg( s_socialFile.partyPrivacyButton, "buttonText", Localize( "#PARTY_PRIVACY_N", Localize( "#SETTING_OPEN" ) ) )
	else
		HudElem_SetRuiArg( s_socialFile.partyPrivacyButton, "buttonText", Localize( "#PARTY_PRIVACY_N", Localize( "#SETTING_INVITE" ) ) )

	Hud_SetVisible( s_socialFile.leavePartyButton, AmIPartyMember() || (AmIPartyLeader() && GetPartySize() > 1) )
}


bool function CurrentlyInParty()
{
	return AmIPartyMember() || AmIPartyLeader() && GetPartySize() > 1
}


void function OnBindFriendGridFriend( var panel, var button, int index )
{
	int friendOffset = s_socialFile.panePageIndex * FRIEND_GRID_ROWS * FRIEND_GRID_COLUMNS
	FriendButton_Init( button, s_socialFile.friends[friendOffset + index] )
}


int function GetFriendCount( var panel )
{
	if ( !s_socialFile.friendsData.isValid )
		return 0

	int totalFriends = s_socialFile.friends.len()
	if ( totalFriends <= FRIEND_GRID_ROWS * FRIEND_GRID_COLUMNS )
		return totalFriends

	if ( (s_socialFile.panePageIndex + 1) * (FRIEND_GRID_ROWS * FRIEND_GRID_COLUMNS) > totalFriends )
		return minint( s_socialFile.friends.len() % (FRIEND_GRID_ROWS * FRIEND_GRID_COLUMNS), FRIEND_GRID_ROWS * FRIEND_GRID_COLUMNS )
	else
		return (FRIEND_GRID_ROWS * FRIEND_GRID_COLUMNS)

	unreachable
}


void function UpdateMyFriendButton()
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

	FriendButton_Init( s_socialFile.myGridButton, friend )
}


void function FriendButtonInit( var button )
{
}


void function SocialMenu_OnOpen()
{
	RuiSetGameTime( s_socialFile.decorationRui, "initTime", Time() )
}


void function SocialMenu_OnShow()
{
	UI_SetPresentationType( ePresentationType.WEAPON_CATEGORY )
}


void function SocialMenu_Update()
{
	s_socialFile.friendsData = GetFriendsData( true )

	if ( s_socialFile.friendsData.friends.len() > 0 )
		Hud_Hide( s_socialFile.gridSpinner )
	else
		Hud_Show( s_socialFile.gridSpinner )

	if ( !s_socialFile.friendsData.isValid )
		return // TEMP HACK

	s_socialFile.friends.clear()
	s_socialFile.friends.extend( s_socialFile.friendsData.friends )

	int ingameCount = 0
	int onlineCount = 0
	for ( int index = 0; index < s_socialFile.friends.len(); index++ )
	{
		if ( s_socialFile.friends[index].status != eFriendStatus.OFFLINE )
			onlineCount++

		if ( s_socialFile.friends[index].status == eFriendStatus.ONLINE_INGAME )
			ingameCount++
	}

	RuiSetArg( s_socialFile.menuHeaderRui, "ingameCount", GetInGameFriendCount() )
	RuiSetArg( s_socialFile.menuHeaderRui, "onlineCount", GetOnlineFriendCount() )
	RuiSetArg( s_socialFile.menuHeaderRui, "totalCount", s_socialFile.friends.len() )

	BindPageButtons( GetNumPanePages(), s_socialFile.pagerPageIndex )
	GridPanel_Refresh( s_socialFile.friendGrid )
}


int function GetNumPanePages()
{
	int numFriends = s_socialFile.friends.len()
	int numPages   = int( ceil( numFriends / float(FRIEND_GRID_ROWS * FRIEND_GRID_COLUMNS) ) )

	return numPages
}


void function OnPageButton_Activate( var button )
{
	int buttonIndex             = int( Hud_GetScriptID( button ) )
	PageButtonDef pageButtonDef = s_socialFile.pageButtonDefs[buttonIndex]

	switch ( pageButtonDef.pageButtonType )
	{
		case ePageButtonType.PAGE_INDEX:
			printt( "index", pageButtonDef.pageIndex )
			s_socialFile.panePageIndex = pageButtonDef.pageIndex
			break

		case ePageButtonType.PAGE_PREV:
			s_socialFile.pagerPageIndex = maxint( 0, s_socialFile.pagerPageIndex - 1 )
			break

		case ePageButtonType.PAGE_NEXT:
			s_socialFile.pagerPageIndex = minint( GetNumPanePages() - 1, s_socialFile.pagerPageIndex + 1 )
			break
	}

	BindPageButtons( GetNumPanePages(), s_socialFile.pagerPageIndex )
	GridPanel_Refresh( s_socialFile.friendGrid )
}


void function BindPageButtons( int numItems, int currentPageIdx )
{
	int numButtons = s_socialFile.pageButtons.len()

	int numItemsForRegularPage = numButtons - 2
	// -2 buttons because most pages have the first and last button taken by arrows

	//numItems = 3 * numItemsForRegularPage + 2

	int pageCount = int(ceil( float(numItems - 1 - 1) / float(numItemsForRegularPage) ))
	// -1 item for first page being able to have an extra
	// -1 item for last page being able to have an extra

	int firstNonArrowButtonIdx
	int firstItemIdx
	int lastItemIdx
	if ( currentPageIdx == 0 )
	{
		firstNonArrowButtonIdx = 0
		firstItemIdx = currentPageIdx * numItemsForRegularPage
		lastItemIdx = firstItemIdx + numItemsForRegularPage + 1  // we can show an extra on first page
	}
	else if ( currentPageIdx == pageCount - 1 )
	{
		firstNonArrowButtonIdx = 1
		lastItemIdx = (numItems - 1)
		firstItemIdx = lastItemIdx - (numItemsForRegularPage)
	}
	else
	{
		firstNonArrowButtonIdx = 1
		firstItemIdx = currentPageIdx * numItemsForRegularPage + 1 // first page had an extra, account for that shift
		lastItemIdx = firstItemIdx + numItemsForRegularPage
	}

	int lastNonArrowButtonIdx = firstNonArrowButtonIdx + (lastItemIdx - firstItemIdx - 1)
	if ( currentPageIdx == pageCount - 1 )
		lastNonArrowButtonIdx += 1

	int buttonOffset = maxint( 0, lastItemIdx - (numItems - 1) )

	firstNonArrowButtonIdx += buttonOffset
	lastNonArrowButtonIdx += buttonOffset

	if ( s_socialFile.panePageIndex < firstItemIdx )
		s_socialFile.panePageIndex = firstItemIdx
	else if ( s_socialFile.panePageIndex > lastItemIdx - 1 )
		s_socialFile.panePageIndex = lastItemIdx - 1

	for ( int buttonIdx = 0; buttonIdx < numButtons; buttonIdx++ )
	{
		PageButtonDef pageButtonDef = s_socialFile.pageButtonDefs[buttonIdx]
		var pageButton              = pageButtonDef.button
		Assert( pageButton == s_socialFile.pageButtons[buttonIdx] )

		Hud_SetSelected( pageButton, false )
		if ( buttonIdx < firstNonArrowButtonIdx - (currentPageIdx == 0 ? 0 : 1) )
		{
			Hud_SetVisible( pageButton, false )
		}
		else if ( buttonIdx < firstNonArrowButtonIdx )
		{
			pageButtonDef.pageButtonType = ePageButtonType.PAGE_PREV
			Hud_SetVisible( pageButton, true )
			HudElem_SetRuiArg( pageButton, "buttonText", "<" )
		}
		else if ( buttonIdx > lastNonArrowButtonIdx )
		{
			pageButtonDef.pageButtonType = ePageButtonType.PAGE_NEXT
			Hud_SetVisible( pageButton, true )
			HudElem_SetRuiArg( pageButton, "buttonText", ">" )
		}
		else
		{
			int buttonItemIdx = firstItemIdx + buttonIdx - firstNonArrowButtonIdx

			if ( buttonItemIdx < numItems )
			{
				pageButtonDef.pageButtonType = ePageButtonType.PAGE_INDEX
				pageButtonDef.pageIndex = buttonItemIdx

				if ( buttonItemIdx == s_socialFile.panePageIndex )
					Hud_SetSelected( pageButton, true )

				Hud_SetVisible( pageButton, GetNumPanePages() > 1 )
				HudElem_SetRuiArg( pageButton, "buttonText", "" + (buttonItemIdx + 1) )
			}
			else
			{
				Hud_SetVisible( pageButton, false )
			}
		}
	}
}


void function SocialMenu_OnClose()
{
	RunMenuClientFunction( "ClearAllCharacterPreview" )
}


void function FriendButton_Init( var button, Friend friend )
{
	var rui = Hud_GetRui( button )
	RuiSetString( rui, "buttonText", friend.name )

	switch ( friend.status )
	{
		case eFriendStatus.ONLINE_INGAME:
			RuiSetString( rui, "statusText", "#PRESENSE_PLAYING" )
			break

		case eFriendStatus.ONLINE:
			RuiSetString( rui, "statusText", "#PRESENSE_ONLINE" )
			break

		case eFriendStatus.ONLINE_AWAY:
			RuiSetString( rui, "statusText", "#PRESENSE_AWAY" )
			break

		case eFriendStatus.OFFLINE:
			RuiSetString( rui, "statusText", "#PRESENSE_OFFLINE" )
			break
	}

	RuiSetString( rui, "presenseText", friend.presence )
	RuiSetBool( rui, "isInGame", friend.ingame )
	RuiSetBool( rui, "isPartyMember", friend.inparty )
	RuiSetInt( rui, "status", friend.status )

	bool isOffline = friend.status == eFriendStatus.OFFLINE
	Hud_SetLocked( button, !isOffline )

	ToolTipData toolTipData
	toolTipData.tooltipStyle = eTooltipStyle.BUTTON_PROMPT
	toolTipData.actionHint1 = "#Y_BUTTON_INSPECT"

	if ( !isOffline )
	{
		bool canInvite = !friend.inparty && GetParty().numFreeSlots > 0

		toolTipData.actionHint2 = canInvite ? "#A_BUTTON_INVITE" : ""

		if ( friend.ingame && friend.hardware != "" && !friend.inparty )
		{
			CommunityUserInfo ornull userInfo = GetCommunityUserInfo( friend.hardware, friend.id )
			if ( userInfo != null )
			{
				expect CommunityUserInfo( userInfo )
				toolTipData.actionHint3 = userInfo.isJoinable ? "X_BUTTON_JOIN" : ""
			}
		}
	}

	Hud_SetToolTipData( button, toolTipData )
}


void function FriendButton_OnActivate( var panel, var button, int index )
{
	int friendOffset = s_socialFile.panePageIndex * FRIEND_GRID_ROWS * FRIEND_GRID_COLUMNS
	Friend friend    = s_socialFile.friends[friendOffset + index]
	s_socialFile.actionFriend = friend
	s_socialFile.actionButton = button

	if ( friend.inparty || friend.status == eFriendStatus.OFFLINE )
	{
		printt( "Not inviting Friend is inparty or offline " + friend.id )
		return
	}

	if ( !CanInvite() )
		return


	if ( !CanPlayerInviteDebounce( button ) )
		return

	HudElem_SetRuiArg( button, "actionSendTime", Time(), eRuiArgType.GAMETIME )
	HudElem_SetRuiArg( button, "actionString", "#INVITE_SENT" )
	InviteFriend( friend )
}



bool function CanPlayerInviteDebounce( var button )
{
	if ( !(button in s_socialFile.nextInviteTimes) )
		s_socialFile.nextInviteTimes[button] <- 0.0

	float lastInviteTime = s_socialFile.nextInviteTimes[button]

	if ( Time() - lastInviteTime < 2.0 )
	{
		s_socialFile.nextInviteTimes[button] = Time() - 1.0;
		return false
	}

	s_socialFile.nextInviteTimes[button] = Time();
	return true
}


bool function MyFriendButton_OnKeyPress( var button, int keyId, bool isDown )
{
	if ( !isDown )
		return false

	if ( keyId != KEY_F && keyId != BUTTON_Y )
		return false

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

	return true
}


bool function FriendButton_OnKeyPress( var panel, var button, int index, int keyId, bool isDown )
{
	if ( !isDown )
		return false

	if ( keyId != KEY_F && keyId != BUTTON_Y )
		return false

	int friendOffset = s_socialFile.panePageIndex * FRIEND_GRID_ROWS * FRIEND_GRID_COLUMNS
	Friend friend    = s_socialFile.friends[friendOffset + index]

	s_socialFile.actionButton = button
	InspectFriend( friend )
	return true
}


void function InspectFriend( Friend friend )
{
	s_socialFile.actionFriend = friend

	printt( "Inspect", friend.name, friend.id, friend.hardware )
	EmitUISound( "UI_Menu_FriendInspect" )
	AdvanceMenu( GetMenu( "InspectMenu" ) )
}


void function FriendButton_OnJoin( var panel, var button, int index )
{
	int friendOffset = s_socialFile.panePageIndex * FRIEND_GRID_ROWS * FRIEND_GRID_COLUMNS
	Friend friend    = s_socialFile.friends[friendOffset + index]
	s_socialFile.actionFriend = friend
	s_socialFile.actionButton = button

	if ( !friend.ingame || friend.inparty || friend.status == eFriendStatus.OFFLINE )
		return

	CommunityUserInfo ornull userInfo = GetCommunityUserInfo( friend.hardware, friend.id )
	if ( userInfo != null )
	{
		expect CommunityUserInfo( userInfo )
		if ( !userInfo.isJoinable )
			return
	}

	if ( CurrentlyInParty() )
	{
		if ( GetParty().numFreeSlots == 0 )
		{
			ConfirmDialogData data
			data.headerText = "#LEAVE_PARTY"
			data.messageText = "#LEAVE_PARTY_DESC"
			data.resultCallback = OnLeavePartyDialogResult

			OpenConfirmDialogFromData( data )
			AdvanceMenu( GetMenu( "ConfirmDialog" ) )
		}
		else
		{
			ConfirmDialogData data
			data.headerText = Localize( "#BRING_PARTY", friend.name )
			data.messageText = Localize( "#BRING_PARTY_DESC", friend.name )
			data.resultCallback = OnBringPartyDialogResult
			data.contextImage = $"ui/menu/common/dialog_notice"
			data.noText = ["#B_BUTTON_NO", "#NO"]

			OpenConfirmDialogFromData( data )
			AdvanceMenu( GetMenu( "ConfirmDialog" ) )
		}
	}
	else
	{
		ConfirmDialogData data
		data.headerText = "#JOIN_USER"
		data.messageText = Localize( "#JOIN_USER_DESC", friend.name )
		data.resultCallback = OnJoinUserDialogResult

		OpenConfirmDialogFromData( data )
		AdvanceMenu( GetMenu( "ConfirmDialog" ) )
	}

	EmitUISound( "menu_accept" )
}


void function OnJoinUserDialogResult( int result )
{
	switch ( result )
	{
		case eDialogResult.YES:
			if ( JoinUserParty( s_socialFile.actionFriend.hardware, s_socialFile.actionFriend.id, false ) )
			{
				HudElem_SetRuiArg( s_socialFile.actionButton, "actionString", "#JOIN_SUCCESS" )
				CloseActiveMenuNoParms()
			}
			else
			{
				HudElem_SetRuiArg( s_socialFile.actionButton, "actionString", "#JOIN_FAIL" )
			}
	}
}


void function OnLeavePartyDialogResult( int result )
{
	switch ( result )
	{
		case eDialogResult.YES:
		{
			if ( IsInParty( s_socialFile.actionFriend.id ) )
				return

			HudElem_SetRuiArg( s_socialFile.actionButton, "actionSendTime", Time(), eRuiArgType.GAMETIME )
			if ( JoinUserParty( s_socialFile.actionFriend.hardware, s_socialFile.actionFriend.id, false ) )
			{
				HudElem_SetRuiArg( s_socialFile.actionButton, "actionString", "#JOIN_SUCCESS" )
				CloseActiveMenuNoParms()
			}
			else
			{
				HudElem_SetRuiArg( s_socialFile.actionButton, "actionString", "#JOIN_FAIL" )
			}

			break
		}
	}
}


void function OnBringPartyDialogResult( int result )
{
	switch ( result )
	{
		case eDialogResult.YES:
			if ( IsInParty( s_socialFile.actionFriend.id ) )
				return

			HudElem_SetRuiArg( s_socialFile.actionButton, "actionSendTime", Time(), eRuiArgType.GAMETIME )
			if ( JoinUserParty( s_socialFile.actionFriend.hardware, s_socialFile.actionFriend.id, true ) )
			{
				HudElem_SetRuiArg( s_socialFile.actionButton, "actionString", "#JOIN_SUCCESS" )
				CloseActiveMenuNoParms()
			}
			else
			{
				HudElem_SetRuiArg( s_socialFile.actionButton, "actionString", "#JOIN_FAIL" )
			}
			break

		case eDialogResult.NO:
			ConfirmDialogData data
			data.headerText = "#LEAVE_PARTY"
			data.messageText = "#LEAVE_PARTY_TO_JOIN"
			data.resultCallback = OnLeavePartyDialogResult

			OpenConfirmDialogFromData( data )
			AdvanceMenu( GetMenu( "ConfirmDialog" ) )
			break
	}
}


void function FriendButton_OnInspect( var panel, var button, int index )
{
	s_socialFile.actionFriend = s_socialFile.friends[index]
	AdvanceMenu( GetMenu( "InspectMenu" ) )
}


void function FriendButton_OnGetFocus( var panel, var button, int index )
{
	Friend friend = s_socialFile.friends[index]
	if ( friend.hardware != "" && friend.id != "" )
		CommunityUserInfo ornull userInfo = GetUserInfo( friend.hardware, friend.id )
}


void function OnLeavePartyButton_Activate( var button )
{
	LeavePartyDialog()
}


void function OnPartyPrivacyButton_Activate( var button )
{
	if ( Hud_IsLocked( button ) )
		return

	if ( GetConVarString( "party_privacy" ) == "open" )
	{
		//HudElem_SetRuiArg( s_socialFile.partyPrivacyButton, "buttonText", Localize( "#PARTY_PRIVACY_N", Localize( "#SETTING_INVITE") ) )
		ClientCommand( "party_privacy invite" )
	}
	else
	{
		//HudElem_SetRuiArg( s_socialFile.partyPrivacyButton, "buttonText", Localize( "#PARTY_PRIVACY_N", Localize( "#SETTING_OPEN") ) )
		ClientCommand( "party_privacy open" )
	}
}


#if PC_PROG
void function UpdateSteamButton()
{
	var button = s_socialFile.steamButton
	Hud_Show( button )

	int linkStatus = GetSteamAccountStatus();
	if ( linkStatus == -1 )
	{
		Hud_SetLocked( button, true )
		Hud_Hide( button )
		HudElem_SetRuiArg( s_socialFile.steamButton, "buttonText", "" )
	}
	else if ( linkStatus == 0 )
	{
		// printt( "account unlinked - prompting to log in!" )
		Hud_SetLocked( button, false )
		Hud_Show( button )
		HudElem_SetRuiArg( s_socialFile.steamButton, "buttonText", "LINK_STEAM_BUTTON" )
	}
	else if ( linkStatus == 1 )
	{
		// printt( "account linked - prompting to log out! setting button text to " + GetConVarString( "steam_name" ) )
		Hud_SetLocked( button, false )
		Hud_Show( button )
		HudElem_SetRuiArg( s_socialFile.steamButton, "buttonText", Localize( "#STEAM_ACCOUNT_LINKED", GetConVarString( "steam_name" ) ) )
	}
}
#endif

#if PC_PROG
void function OnSteamLinkButton_Activate( var button )
{
	int linkStatus = GetSteamAccountStatus();
	if ( linkStatus == -1 )
	{
	}
	else if ( linkStatus == 0 )
	{
		LinkSteamAccount()
	}
	else if ( linkStatus == 1 )
	{
		ConfirmDialogData data
		data.headerText = "#UNLINK_STEAM_HEADER"
		data.messageText = "#UNLINK_STEAM_MESSAGE"
		data.contextImage = $"ui/menu/common/dialog_notice"
		data.resultCallback = OnUnlinkSteamAccountResult
		data.noText = ["#B_BUTTON_NO", "#NO"]

		OpenConfirmDialogFromData( data )
		AdvanceMenu( GetMenu( "ConfirmDialog" ) )
	}
}

void function OnUnlinkSteamAccountResult( int result )
{
	if ( result != eDialogResult.YES )
		return

	UnlinkSteamAccount()
}

#endif

void function PreviewFriendCosmetics( bool isForLocalPlayer, CommunityUserInfo ornull userInfoOrNull )
{
	Signal( uiGlobal.signalDummy, "HaltPreviewFriendCosmetics" )
	EndSignal( uiGlobal.signalDummy, "HaltPreviewFriendCosmetics" )

	SetupMenuGladCard( s_inspectFile.combinedCard, "card", isForLocalPlayer )

	string introQuipSoundEventName = ""

	if ( isForLocalPlayer )
	{
		if ( LoadoutSlot_IsReady( LocalClientEHI(), Loadout_CharacterClass() ) )
		{
			ItemFlavor character = LoadoutSlot_GetItemFlavor( LocalClientEHI(), Loadout_CharacterClass() )
			if ( LoadoutSlot_IsReady( LocalClientEHI(), Loadout_CharacterIntroQuip( character ) ) )
			{
				ItemFlavor introQuip = LoadoutSlot_GetItemFlavor( LocalClientEHI(), Loadout_CharacterIntroQuip( character ) )
				introQuipSoundEventName = CharacterIntroQuip_GetVoiceSoundEvent( introQuip )
			}
		}
	}
	else
	{
		CommunityUserInfo userInfo = expect CommunityUserInfo(userInfoOrNull)
		#if DEV
			DEV_PrintUserInfo( userInfo )
		#endif

		SendMenuGladCardPreviewString( eGladCardPreviewCommandType.NAME, 0, userInfo.name )

		ItemFlavor ornull character = GetItemFlavorOrNullByGUID( userInfo.charData[ePlayerStryderCharDataArraySlots.CHARACTER], eItemType.character )
		if ( character == null )
			character = GetDefaultItemFlavorForLoadoutSlot( EHI_null, Loadout_CharacterClass() )
		expect ItemFlavor( character )
		SendMenuGladCardPreviewCommand( eGladCardPreviewCommandType.CHARACTER, 0, character )

		ItemFlavor ornull skin = GetItemFlavorOrNullByGUID( userInfo.charData[ePlayerStryderCharDataArraySlots.CHARACTER_SKIN], eItemType.character_skin )
		if ( skin == null )
			skin = GetDefaultItemFlavorForLoadoutSlot( EHI_null, Loadout_CharacterSkin( character ) )
		expect ItemFlavor(skin)
		SendMenuGladCardPreviewCommand( eGladCardPreviewCommandType.SKIN, 0, skin )

		RunClientScript( "UIToClient_PreviewCharacterSkin", ItemFlavor_GetNetworkIndex_DEPRECATED( skin ), ItemFlavor_GetNetworkIndex_DEPRECATED( character ) )

		ItemFlavor ornull frame = GetItemFlavorOrNullByGUID( userInfo.charData[ePlayerStryderCharDataArraySlots.BANNER_FRAME], eItemType.gladiator_card_frame )
		if ( frame == null )
			frame = GetDefaultItemFlavorForLoadoutSlot( EHI_null, Loadout_GladiatorCardFrame( character ) )
		SendMenuGladCardPreviewCommand( eGladCardPreviewCommandType.FRAME, 0, expect ItemFlavor(frame) )

		ItemFlavor ornull stance = GetItemFlavorOrNullByGUID( userInfo.charData[ePlayerStryderCharDataArraySlots.BANNER_STANCE], eItemType.gladiator_card_stance )
		if ( stance == null )
			stance = GetDefaultItemFlavorForLoadoutSlot( EHI_null, Loadout_GladiatorCardStance( character ) )
		SendMenuGladCardPreviewCommand( eGladCardPreviewCommandType.STANCE, 0, expect ItemFlavor(stance) )

		for ( int badgeIndex = 0; badgeIndex < GLADIATOR_CARDS_NUM_BADGES; badgeIndex++ )
		{
			ItemFlavor ornull badge = GetItemFlavorOrNullByGUID( userInfo.charData[ePlayerStryderCharDataArraySlots.BANNER_BADGE1 + 2 * badgeIndex], eItemType.gladiator_card_badge )
			if ( badge == null )
				badge = GetDefaultItemFlavorForLoadoutSlot( EHI_null, Loadout_GladiatorCardBadge( character, badgeIndex ) )
			int dataInteger = maxint( 0, userInfo.charData[ePlayerStryderCharDataArraySlots.BANNER_BADGE1_TIER + 2 * badgeIndex] - 2 ) // todo(dw): fix
			SendMenuGladCardPreviewCommand( eGladCardPreviewCommandType.BADGE, badgeIndex, expect ItemFlavor( badge ), dataInteger )
		}

		for ( int trackerIndex = 0; trackerIndex < GLADIATOR_CARDS_NUM_TRACKERS; trackerIndex++ )
		{
			ItemFlavor ornull tracker = GetItemFlavorOrNullByGUID( userInfo.charData[ePlayerStryderCharDataArraySlots.BANNER_TRACKER1 + 2 * trackerIndex], eItemType.gladiator_card_stat_tracker )
			if ( tracker == null )
				tracker = GetDefaultItemFlavorForLoadoutSlot( EHI_null, Loadout_GladiatorCardStatTracker( character, trackerIndex ) )
			int dataInteger = maxint( 0, userInfo.charData[ePlayerStryderCharDataArraySlots.BANNER_TRACKER1_VALUE + 2 * trackerIndex] - 2 ) // todo(dw): fix
			SendMenuGladCardPreviewCommand( eGladCardPreviewCommandType.TRACKER, trackerIndex, expect ItemFlavor( tracker ) )
		}

		ItemFlavor ornull introQuip = GetItemFlavorOrNullByGUID( userInfo.charData[ePlayerStryderCharDataArraySlots.CHARACTER_INTRO_QUIP], eItemType.gladiator_card_intro_quip )
		if ( introQuip == null )
			introQuip = GetDefaultItemFlavorForLoadoutSlot( EHI_null, Loadout_CharacterIntroQuip( character ) )
		introQuipSoundEventName = CharacterIntroQuip_GetVoiceSoundEvent( expect ItemFlavor(introQuip) )
	}

	OnThreadEnd( void function() : ( introQuipSoundEventName ) {
		SetupMenuGladCard( null, "", false )

		if ( introQuipSoundEventName != "" )
			StopUISoundByName( introQuipSoundEventName )
	} )


	if ( introQuipSoundEventName != "" )
	{
		wait 0.7
		EmitUISound( introQuipSoundEventName )
	}

	WaitForever()
}


void function InviteFriend( Friend friend )
{
	array<string> ids
	ids.append( friend.id )

	printt( " InviteFriend id:", ids[0] )
	DoInviteToParty( ids )
}


void function InitInspectMenu()
{
	var menu = GetMenu( "InspectMenu" )

	s_inspectFile.menu = menu
	s_inspectFile.combinedCard = Hud_GetChild( menu, "CombinedCard" )
	s_inspectFile.menuHeaderRui = Hud_GetRui( Hud_GetChild( menu, "MenuHeader" ) )
	s_inspectFile.decorationRui = Hud_GetRui( Hud_GetChild( menu, "Decoration" ) )

	AddMenuEventHandler( menu, eUIEvent.MENU_OPEN, InspectMenu_OnOpen )
	AddMenuEventHandler( menu, eUIEvent.MENU_CLOSE, InspectMenu_OnClose )

	AddMenuFooterOption( menu, LEFT, BUTTON_B, true, "#B_BUTTON_BACK", "#B_BUTTON_BACK" )
	AddMenuFooterOption( menu, LEFT, BUTTON_Y, true, "#Y_BUTTON_VIEW_PROFILE", "#VIEW_PROFILE", OnViewProfile )
}


void function InspectMenu_OnOpen()
{
	UI_SetPresentationType( ePresentationType.CHARACTER_SELECT )

	RuiSetString( s_inspectFile.menuHeaderRui, "menuName", s_socialFile.actionFriend.name )
	RuiSetGameTime( s_inspectFile.decorationRui, "initTime", Time() )

	AddCallbackAndCallNow_UserInfoUpdated( OnUserInfoUpdated )

	EmitUISound( "ui_menu_friendinspect" )
}


void function OnUserInfoUpdated( string hardware, string id )
{
	bool isForLocalPlayer = (s_socialFile.actionFriend.id == GetPlayerUID())

	if ( (s_socialFile.actionFriend.hardware == "" && !isForLocalPlayer) || s_socialFile.actionFriend.id == "" )
		return

	CommunityUserInfo ornull userInfoOrNull
	if ( !isForLocalPlayer )
	{
		userInfoOrNull = GetCommunityUserInfo( s_socialFile.actionFriend.hardware, s_socialFile.actionFriend.id )
		if ( userInfoOrNull == null )
			return // todo(bm): display spinner
	}

	thread PreviewFriendCosmetics( isForLocalPlayer, userInfoOrNull )
}


void function InspectMenu_OnClose()
{
	Signal( uiGlobal.signalDummy, "HaltPreviewFriendCosmetics" )

	RunMenuClientFunction( "ClearAllCharacterPreview" )

	RemoveCallback_UserInfoUpdated( OnUserInfoUpdated )
}


void function OnViewProfile( var button )
{
	#if PC_PROG
		if ( !Origin_IsOverlayAvailable() )
		{
			ConfirmDialogData dialogData
			dialogData.headerText = ""
			dialogData.messageText = "#ORIGIN_INGAME_REQUIRED"
			dialogData.contextImage = $"ui/menu/common/dialog_notice"

			OpenOKDialogFromData( dialogData )
			return
		}
	#endif

	ShowPlayerProfileCardForUID( s_socialFile.actionFriend.id )
}


