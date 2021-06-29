
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


void function InitInviteFriendsMenu( var newMenuArg ) //
{
	var menu = GetMenu( "InviteFriendsMenu" )
	file.menu = menu
	file.friendList = Hud_GetChild( menu, "FriendList" )

	AddMenuEventHandler( menu, eUIEvent.MENU_OPEN, InviteFriendsMenu_OnOpen )
	AddMenuEventHandler( menu, eUIEvent.MENU_CLOSE, InviteFriendsMenu_OnClose )

	//
	//
}

void function InviteFriendsMenu_OnOpen()
{
	UI_SetPresentationType( ePresentationType.NO_MODELS )

	InviteFriendsMenu_Update()

	//
	//
	//
	//
	//
	//
	//
}

void function InviteFriendsMenu_Update()
{
	file.friendsData = GetFriendsData( true )
	if ( !file.friendsData.isValid )
		return //

	file.friends.clear()
	file.friends.extend( file.friendsData.friends )

	Hud_InitGridButtons( file.friendList, file.friends.len() )
	var scrollPanel = Hud_GetChild( file.friendList, "ScrollPanel" )
	for ( int i = 0; i < file.friends.len(); i++ )
		FriendButton_Init( Hud_GetChild( scrollPanel, "GridButton" + i ), file.friends[i] )
}

void function InviteFriendsMenu_OnClose()
{
	//
	//
	//
	//
	//

	file.buttonToFriend.clear()
}

void function FriendButton_Init( var button, Friend friend )
{
	//
	//

	var rui = Hud_GetRui( button )
	RuiSetString( rui, "buttonText", friend.name )

	bool isOffline = friend.status == eFriendStatus.OFFLINE
	Hud_SetEnabled( button, !isOffline )

	file.buttonToFriend[button] <- friend
}

/*

























































































*/