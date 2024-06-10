untyped

global function Gamemode1v1_NotifyThread
global function NotifyPlayer

global enum eNotify
{
	WAITING = 1,
	MATCHING,
	CHALLENGE
}


void function NotifyPlayer( entity player, string text = "", int id = 1 )
{
	Assert( id > 0 , "Invalid ID for notification" )
	
	bool bClearNotifications = text == "" ? true : false ;
	
	if( !bClearNotifications )
	{
		table data = { text = text, panelID = id }
		player.Signal( "NotificationChanged", data )
	}
	else if( bClearNotifications )
	{
		player.Signal( "ClearNotifications" )
	}
}

void function Gamemode1v1_NotifyThread( entity player )
{	
	if ( !IsValid( player ) )
		return
	
	EndSignal( player, "OnDisconnected", "OnDestroy" )
	
	for( ; ; )
	{		
		var results = WaitSignal( player, "NotificationChanged", "ClearNotifications" )
		
		if( !IsValid( player ) )
			return
		
		if( results.signal == "NotificationChanged" )
		{
			int panelID = expect int( results.panelID )
			string text = expect string( results.text )
			thread __UpdateNotificationText( player, text, panelID )
		}
		else if( results.signal == "ClearNotifications" )
		{
			player.Signal( "NotificationChanged", {} )
		}
	}
}

void function __UpdateNotificationText( entity player, string text, int panelID )
{	
	wait 0.2
		
	if( !IsValid( player ) )
		return
	
	EndSignal( player, "NotificationChanged", "OnDisconnected", "OnDestroy" )
	
	Remote_CallFunction_NonReplay( player, "ForceScoreboardLoseFocus" )
	
	CreatePanelText
	( 
		player, 
		"", 
		text, 
		Gamemode1v1_FetchNotificationPanelCoordinates(), 
		Gamemode1v1_FetchNotificationPanelAngles(), 
		false, 
		2, 
		panelID
	)
	
	OnThreadEnd( function() : ( player, panelID )
		{
			if( IsValid( player ) )
			{
				RemovePanelText( player, panelID )
			}
		}
	)
	
	WaitForever()
}