global function NotificationSystem_Init
global function ClearNotifications
global function NotificationThread

global function Gamemode1v1_NotifyPlayer
global function Gamemode1v1_NotifyPlayerOnce

global enum eNotify //non-zero
{
	ALL			= -1,
	WAITING 	= 1,
	MATCHING,
	CHALLENGE
}

struct 
{
	table<int, array<int> > playerActiveNotifications = {}

	#if DEVELOPER 
		table <string, int> notificationTypeMap = {}
		table <int, string>	notificationIdToNameMap = {}
	#endif 

} file 

void function NotificationSystem_Init()
{
	RegisterSignal( "NotificationChanged" )
	RegisterSignal( "ClearNotifications" )
	
	AddCallback_OnClientConnected( SetupPlayerNotificationTable )
	AddCallback_OnClientDisconnected( CleanupPlayerNotifications )
	
	#if DEVELOPER 
		DEV_InitEnumMap()
	#endif 
}


//scipters: add your own wrapper functions 


//////////////////////////////////
//			WRAPPERS			//
//////////////////////////////////

void function ClearNotifications( entity player, int panelID = -1 )
{
	if( IsValid( player ) )
		player.Signal( "ClearNotifications", { panelID = panelID, destroyAll = true } )
}

void function Gamemode1v1_NotifyPlayer( entity player = null, int panelID = -1, string subToken = "", string text = "" )
{
	if( player == null )
	{
		foreach( sPlayer in GetPlayerArray() )
		{
			__NotifyPlayer( player, "", subToken, "", text, panelID )	
		}
		
		return
	}
	else
	{
		__NotifyPlayer( player, "", subToken, "", text, panelID )		
	}
}

void function Gamemode1v1_NotifyPlayerOnce( entity player = null, int panelID = -1, string subToken = "", string text = "" )
{
	if( NotificationIsActive( player, panelID ) )
		return
	
	if( player == null )
	{
		foreach( sPlayer in GetPlayerArray() )
		{
			__NotifyPlayer( player, "", subToken, "", text, panelID )	
		}
		
		return
	}
	else
	{
		__NotifyPlayer( player, "", subToken, "", text, panelID )		
	}
}


//////////////////////////////////
//			INTERNAL			//
//////////////////////////////////


void function SetupPlayerNotificationTable( entity player )
{
	if( !( player.p.handle in file.playerActiveNotifications ) )
		file.playerActiveNotifications[ player.p.handle ] <- []
}

void function CleanupPlayerNotifications( entity player )
{
	if( !( player.p.handle in file.playerActiveNotifications ) )
		file.playerActiveNotifications[ player.p.handle ].clear()
} 

array<int> function GetPlayerActiveNotifications( entity player )
{
	if( player.p.handle in file.playerActiveNotifications )
		return file.playerActiveNotifications[ player.p.handle ]
		
	array<int> none = []	
	return none
}

bool function NotificationIsActive( entity player, int notificationID )
{
	if( GetPlayerActiveNotifications( player ).contains( notificationID) )
		return true
		
	return false
}

void function AppendNotificationID( entity player, int notificationID )
{
	array<int> playerNotifications = GetPlayerActiveNotifications( player )
	
	if( playerNotifications.contains( notificationID ) )
		return 
		
	playerNotifications.append( notificationID )
}

void function RemoveNotificationID( entity player, int notificationID )
{
	array<int> playerNotifications = GetPlayerActiveNotifications( player )
	
	if( playerNotifications.contains( notificationID ) )
		playerNotifications.fastremovebyvalue( notificationID )
}

void function __NotifyPlayer( entity player, string token = "", string subToken = "", string title = "", string text = "", int id = -1 )
{
	mAssert( id > 0 , "Invalid ID for notification" )
	
	table data = 
	{ 
		token 		= token,
		subToken 	= subToken,
		title 		= title,
		text 		= text,
		panelID 	= id,
		destroyAll	= false
	}
		
	player.Signal( "NotificationChanged", data )
}

void function NotificationThread( entity player )
{	
	if ( !IsValid( player ) )
		return
	
	EndSignal( player, "OnDisconnected", "OnDestroy" )
	
	for( ; ; )
	{	
		table results = WaitSignal( player, "NotificationChanged", "ClearNotifications" )
		
		if( !IsValid( player ) )
			return
		
		if( results.signal == "NotificationChanged" )
		{
			int panelID 		= expect int( results.panelID )
			
			if( panelID == -1 )
				continue
			
			string token 		= expect string( results.token )
			string subToken 	= expect string( results.subToken )
			string title 		= expect string( results.title )
			string text 		= expect string( results.text )
			
			thread __UpdateNotificationText( player, token, subToken, title, text, panelID )
		}
		else if( results.signal == "ClearNotifications" )
		{
			int dataPanelID = -1
			
			if( results.panelID != null )
			{
				dataPanelID = expect int( results.panelID )
			}
			
			if( dataPanelID == -1 )
				player.Signal( "NotificationChanged", { panelID = dataPanelID, destroyAll = true } )
			else
				player.Signal( "NotificationChanged", { panelID = dataPanelID, destroyAll = false } )
		}
	}
}

void function __UpdateNotificationText( entity player, string token, string subToken, string title, string text, int panelID )
{	
	#if DEVELOPER 
		Warning( format( "Spawning for id %d. eNum: %s, player: %s", panelID, DEV_GetEnumNameForNotification( panelID ), string( player ) ) )
	#endif 
	
	wait 0.2
		
	if( !IsValid( player ) )
		return
	
	EndSignal( player, "OnDisconnected", "OnDestroy" )
	
	AppendNotificationID( player, panelID )
	
	Remote_CallFunction_NonReplay( player, "ForceScoreboardLoseFocus" )
	
	CreatePanelText_Localized
	( 
		player,
		token,
		subToken,
		title,
		text,
		Gamemode1v1_FetchNotificationPanelCoordinates(),
		Gamemode1v1_FetchNotificationPanelAngles(),
		2,
		panelID
	)
	
	OnThreadEnd
	(
		function() : ( player, panelID )
		{
			if( IsValid( player ) )
			{
				DestroyNotification( player, panelID )
			}
		}
	)
	
	while( true )
	{
		table result = player.WaitSignal( "NotificationChanged" )
		
		if( result.panelID == panelID || result.destroyAll == true )
		{	
			printt( result.panelID, result.destroyAll ) 
			break
		}
	}
	
	#if DEVELOPER 
		Warning( format( "Thread for id %d ended. eNum: %s, player: %s", panelID, DEV_GetEnumNameForNotification( panelID ), string( player ) ) )
	#endif 
}

void function DestroyNotification( entity player, int notificationID )
{
	RemoveNotificationID( player, notificationID )
	RemovePanelText( player, notificationID )
}


//////////////////////////////
//		DEV FUNCTIONS		//
//////////////////////////////
#if DEVELOPER 

	void function DEV_InitEnumMap()
	{
		foreach( string name, int id in eNotify )
		{
			file.notificationTypeMap[ name ] <- id 
			file.notificationIdToNameMap[ id ] <- name
		}
	}
	
	string function DEV_GetEnumNameForNotification( int id = 0, string name = "" ) //non-zero struct
	{
		if( empty( name ) )
		{
			if( id in file.notificationIdToNameMap )
				return file.notificationIdToNameMap[ id ]
		}
		else
		{
			if( name in file.notificationTypeMap )
				return string( file.notificationTypeMap[ name ] )
		}
		
		return "not found"
	}
	
#endif // if DEVELOPER