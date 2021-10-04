
global function InitInviteFriendsMenu

const UPDATE_RATE = 1.0


struct
{
	var menu
	var friendList
	array<Friend> friends
	table<var, Friend> buttonToFriend

	FriendsData& friendsData
} file


void function InitInviteFriendsMenu( var newMenuArg )
{
	var menu = GetMenu( "InviteFriendsMenu" )
	file.menu = menu
	file.friendList = Hud_GetChild( menu, "FriendList" )

	AddMenuEventHandler( menu, eUIEvent.MENU_OPEN, InviteFriendsMenu_OnOpen )
	AddMenuEventHandler( menu, eUIEvent.MENU_CLOSE, InviteFriendsMenu_OnClose )

	//AddMenuFooterOption( menu, LEFT, BUTTON_A, true, "#A_BUTTON_INVITE", "", null, OLD_IsOnlineFriendFocused )
	//AddMenuFooterOption( menu, LEFT, BUTTON_B, true, "#B_BUTTON_BACK", "#B_BUTTON_BACK" )
}

void function InviteFriendsMenu_OnOpen()
{
	UI_SetPresentationType( ePresentationType.NO_MODELS )

	InviteFriendsMenu_Update()

	//while ( GetTopNonDialogMenu() == file.menu )
	//{
	//	file.friendsData = GetFriendsData( true )
	//	OLD_UpdateDisplay()
	//
	//	wait UPDATE_RATE
	//}
}

void function InviteFriendsMenu_Update()
{
	file.friendsData = GetFriendsData( true )
	if ( !file.friendsData.isValid )
		return // TEMP HACK

	file.friends.clear()
	file.friends.extend( file.friendsData.friends )

	Hud_InitGridButtons( file.friendList, file.friends.len() )
	var scrollPanel = Hud_GetChild( file.friendList, "ScrollPanel" )
	for ( int i = 0; i < file.friends.len(); i++ )
		FriendButton_Init( Hud_GetChild( scrollPanel, "GridButton" + i ), file.friends[i] )
}

void function InviteFriendsMenu_OnClose()
{
	//foreach ( button in file.buttonToFriend )
	//{
	//	Hud_RemoveEventHandler( button, UIE_GET_FOCUS, FriendButton_OnGetFocus )
	//	Hud_RemoveEventHandler( button, UIE_CLICK, FriendButton_OnActivate )
	//}

	file.buttonToFriend.clear()
}

void function FriendButton_Init( var button, Friend friend )
{
	//Hud_AddEventHandler( button, UIE_GET_FOCUS, FriendButton_OnGetFocus )
	//Hud_AddEventHandler( button, UIE_CLICK, FriendButton_OnActivate )

	var rui = Hud_GetRui( button )
	RuiSetString( rui, "buttonText", friend.name )

	bool isOffline = friend.status == eFriendStatus.OFFLINE
	Hud_SetEnabled( button, !isOffline )

	file.buttonToFriend[button] <- friend
}

/*void function OLD_UpdateDisplay()
{
	var panel = Hud_GetChild( file.menu, "GridPanel" )

	if ( !file.friendsData.isValid )
	{
		printt( "Friend data is invalid!" )

		Hud_Hide( panel )
	}
	else
	{
		Hud_Show( panel )

		file.gridData.numElements = file.friendsData.friends.len()

		if ( !file.isGridInitialized )
		{
			GridMenuInit( file.menu, file.gridData )
			file.isGridInitialized = true
		}

		Grid_RegisterPageNavInputs( file.menu )
		Grid_InitPage( file.menu, file.gridData )
	}

	UpdateFooterOptions()
}

bool function OLD_IsOnlineFriendFocused()
{
	var focus = GetFocus()

	if ( focus != null && file.friendsData.isValid )
	{
		table<int, var> buttons = Grid_GetActivePageButtons( file.menu )

		foreach ( button in buttons )
		{
			if ( button == focus )
			{
				int elemNum = Grid_GetElemNumForButton( button )

				if ( file.friendsData.friends[ elemNum ].status == eFriendStatus.ONLINE_INVITABLE )
					return true
			}
		}
	}

	return false
}

bool function OLD_FriendButton_Init( var button, int elemNum )
{
	Friend friend = file.friendsData.friends[elemNum]

	//printt( "Button setup, Name:", friend.name, "ID:", friend.id, "Status:", Dev_GetEnumString( eFriendInvitableStatus, friend.status ) )

	var rui = Hud_GetRui( button )
	RuiSetString( rui, "buttonText", friend.name )

//	Hud_SetFocused( button )


	bool isOffline = false
	if ( friend.status == eFriendStatus.OFFLINE )
		isOffline = true
	Hud_SetLocked( button, isOffline )

	return true
}

void function OLD_FriendButton_Activate( var button, int elemNum )
{
	printt( "OLD_FriendButton_Activate() called for elemNum:", elemNum )

	if ( Hud_IsLocked( button ) )
		return

	Friend friend = file.friendsData.friends[elemNum]
	string name = friend.name
	string id = friend.id
	printt( "Invited friend, Name:", name, "id:", id ) // TODO: Actually invite
}

void function OLD_FriendButton_GetFocus( var button, int elemNum )
{
	printt( "OLD_FriendButton_GetFocus() called for elemNum:", elemNum )

	UpdateFooterOptions()
}*/