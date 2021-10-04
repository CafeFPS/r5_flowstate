global function InitLowPopDialog
global function ShouldShowLowPopDialog

global function OpenLowPopDialog
global function OpenLowPopDialogFromButton

global function GetLowPopDatacenters
global function IsLowPopPlaylist

global function GetCurrentRankedMatchmakingDatacenterETA
global function GetCurrentMatchmakingDatacenterETA
global function LowPop_SetRankedDatacenter

global function ToRelativeTimeString

#if R5DEV
global function DisplayLowPopWarning

const bool DEBUG_LOW_POP = false
#endif

struct
{
	var menu

	var dialogFrame
	var dialogContent

	void functionref(int) onButtonClickCallback
	table<var, MatchmakingDatacenterETA> buttonToDatacenter

#if R5DEV
	array<MatchmakingDatacenterETA> fakeDatacenters
	int fakeHomeDatacenter = 0
	int fakeRankedDatacenter = 0
#endif
} file

void function InitLowPopDialog( var newMenuArg ) //
{
	file.menu = GetMenu( "LowPopDialog" )
	var menu = file.menu

	SetDialog( menu, true )
	Hud_Show( Hud_GetChild( menu, "DarkenBackground" ) )

	file.dialogFrame = Hud_GetChild( file.menu, "DialogFrame" )
	InitButtonRCP( file.dialogFrame )

	file.dialogContent = Hud_GetChild( file.menu, "DialogContent" )
	InitButtonRCP( file.dialogContent )

	array<var> buttons = GetElementsByClassname( menu, "DatacenterButton" )
	foreach ( b in buttons )
	{
		var rui = Hud_GetRui( b )
		RuiSetBool( rui, "isPrimary", false )
		RuiSetFloat( rui, "bottomBarHeight", 4 )
		RuiSetAsset( rui, "backgroundImage", $"dark_grey" )

		AddButtonEventHandler( b, UIE_CLICK, OnDatacenterButtonClick )
	}

	AddMenuEventHandler( menu, eUIEvent.MENU_OPEN, OnLowPopMenuOpen )
	AddMenuEventHandler( menu, eUIEvent.MENU_CLOSE, OnLowPopMenuClose )

	#if R5DEV
	GenerateFakeDatacenter( "australia", 150 , 300 )
	GenerateFakeDatacenter( "japan", 150 , 100 )
	GenerateFakeDatacenter( "west us", 200 , 50 )
	GenerateFakeDatacenter( "east us", 350 , 50 )
	GenerateFakeDatacenter( "europe", 500 , 90 )
	#endif
}

#if R5DEV
void function GenerateFakeDatacenter( string name, int latency, int etaSeconds )
{
	MatchmakingDatacenterETA fakeData
	fakeData.datacenterIdx = file.fakeDatacenters.len()
	fakeData.datacenterName = name
	fakeData.idealStartUTC = GetUnixTimestamp() + 15000
	fakeData.idealStartUTC = fakeData.idealStartUTC + 1200
	fakeData.latency = latency
	fakeData.etaSeconds = etaSeconds
	UpdateMatchmakingDatacenterETASeconds( fakeData )
	file.fakeDatacenters.append( fakeData )
}
#endif

void function GetLowPopDatacenters( string playlistName )
{
	printf( "Current datacenter:" )
	MatchmakingDatacenterETA currentDC = GetMatchmakingCurrentDatacenterETA( playlistName )
	printt( "datacenter[", currentDC.datacenterIdx, "]", currentDC.datacenterName )
	printt( "\tlatency", currentDC.latency, " packetLoss", currentDC.packetLoss )
	printt( "\tetaSeconds", currentDC.etaSeconds, " idealStartUTC", currentDC.idealStartUTC, "idealEndUTC", currentDC.idealEndUTC )

	printf( "Current ranked datacenter:" )
	MatchmakingDatacenterETA rankedDC = GetMatchmakingCurrentRankedDatacenterETA( playlistName )
	printt( "datacenter[", rankedDC.datacenterIdx, "]", rankedDC.datacenterName )
	printt( "\tlatency", rankedDC.latency, " packetLoss", rankedDC.packetLoss )
	printt( "\tetaSeconds", rankedDC.etaSeconds, " idealStartUTC", rankedDC.idealStartUTC, "idealEndUTC", rankedDC.idealEndUTC )

	printf( "All datacenters:" )
	array< MatchmakingDatacenterETA > matchmakingDatacenterETAs = GetMatchmakingDatacenterETAs( playlistName )
	foreach ( MatchmakingDatacenterETA dc in matchmakingDatacenterETAs )
	{
		printt( "datacenter[", dc.datacenterIdx, "]", dc.datacenterName )
		printt( "\tlatency", dc.latency, " packetLoss", dc.packetLoss )
		printt( "\tetaSeconds", dc.etaSeconds, " idealStartUTC", dc.idealStartUTC, "idealEndUTC", dc.idealEndUTC )
	}
}

void function OnLowPopMenuOpen()
{
	array<var> buttons = GetElementsByClassname( file.menu, "DatacenterButton" )

	array<MatchmakingDatacenterETA> dcs = GetValidMatchmakingDatacenterETASorted( Lobby_GetSelectedPlaylist() )
	MatchmakingDatacenterETA currentDatacenter = GetCurrentRankedMatchmakingDatacenterETA( Lobby_GetSelectedPlaylist() )

	array<MatchmakingDatacenterETA> datacenters
	for ( int i=0; i<dcs.len() && i<buttons.len()-1; i++ )
	{
		datacenters.append( dcs[i] )
	}
	datacenters.append( currentDatacenter )

	PopulateMenuFromDatacenterList( datacenters )
}

void function PopulateMenuFromDatacenterList( array<MatchmakingDatacenterETA> datacenters )
{
	file.buttonToDatacenter.clear()
	array<var> buttons = GetElementsByClassname( file.menu, "DatacenterButton" )

	MatchmakingDatacenterETA currentDatacenter = GetCurrentRankedMatchmakingDatacenterETA( Lobby_GetSelectedPlaylist() )

	int maxButtons = buttons.len()
	int numValidDatacenters = datacenters.len()
	int margin = 30

	array<int> buttonOffsets

	HudElem_SetRuiArg( file.dialogContent, "headerText", "#LOWPOP_EST_MATCHMAKING_TIME" )
	HudElem_SetRuiArg( file.dialogContent, "messageText", ToRelativeTimeString( currentDatacenter.etaSeconds, 30 ) )
	HudElem_SetRuiArg( file.dialogContent, "reqsText", "#LOWPOP_CHANGE_DATACENTER" )

	for ( int i=0; i<buttons.len(); i++ )
	{
		var button = buttons[i]

		if ( i < numValidDatacenters )
		{
			int buttonOffset = minint( buttons.len(), numValidDatacenters )
			int offset = int( (-0.5*(Hud_GetWidth( button ) + margin)*buttonOffset) + ((Hud_GetWidth( button ) + margin)*(i + 0.5)) )

			Hud_SetX( button, offset )
			Hud_Show( button )
			var rui = Hud_GetRui( button )

			MatchmakingDatacenterETA info = datacenters[i]

			RuiSetString( rui, "name", info.datacenterName.toupper() )
			RuiSetString( rui, "etaString", ToRelativeTimeString( info.etaSeconds, 30 ) )
			RuiSetInt( rui, "ping", info.latency )

			if ( info.datacenterIdx != currentDatacenter.datacenterIdx )
			{
				RuiSetBool( rui, "isPrimary", false )
				RuiSetFloat( rui, "bottomBarHeight", 4 )
			}
			else
			{
				RuiSetBool( rui, "isPrimary", true )
				RuiSetFloat( rui, "bottomBarHeight", 8 )
			}

			file.buttonToDatacenter[ button ] <- info
		}
		else
		{
			Hud_Hide( button )
		}
	}
}

void function OnLowPopMenuClose()
{

}

//
array<MatchmakingDatacenterETA> function GetValidMatchmakingDatacenterETASorted( string playlistName, bool compareETAtoCurrent = true )
{
	array< MatchmakingDatacenterETA > datas = GetMatchmakingDatacenterETAs( playlistName )

	#if R5DEV
		if ( DEBUG_LOW_POP )
		{
			datas = clone file.fakeDatacenters
			datas.sort( SortMatchmakingDatacenterETAByPing )
		}
	#endif

	MatchmakingDatacenterETA currentDatacenter = GetCurrentRankedMatchmakingDatacenterETA( playlistName )

	array< MatchmakingDatacenterETA > results

	int maxPingAllowed = GetConVarInt( "match_rankedMaxPing" )

	foreach ( data in datas )
	{
		if ( data.datacenterIdx == currentDatacenter.datacenterIdx )
			continue

		UpdateMatchmakingDatacenterETASeconds( data )

		if ( data.latency > maxPingAllowed )
			continue

		if ( compareETAtoCurrent )
		{
			if ( data.etaSeconds >= currentDatacenter.etaSeconds )
				continue
		}

		results.append( data )
	}

	return results
}

MatchmakingDatacenterETA function GetCurrentRankedMatchmakingDatacenterETA( string playlistName )
{
	#if R5DEV
		if ( DEBUG_LOW_POP )
		{
			return file.fakeDatacenters[ file.fakeRankedDatacenter ]
		}
	#endif

	MatchmakingDatacenterETA data = GetMatchmakingCurrentRankedDatacenterETA( playlistName )

	UpdateMatchmakingDatacenterETASeconds( data )

	return data
}

MatchmakingDatacenterETA function GetCurrentMatchmakingDatacenterETA( string playlistName )
{
	#if R5DEV
		if ( DEBUG_LOW_POP )
		{
			return file.fakeDatacenters[ file.fakeHomeDatacenter ]
		}
	#endif

	MatchmakingDatacenterETA data = GetMatchmakingCurrentDatacenterETA( playlistName )

	UpdateMatchmakingDatacenterETASeconds( data )

	return data
}

void function UpdateMatchmakingDatacenterETASeconds( MatchmakingDatacenterETA data )
{
	if ( data.etaSeconds <= 0 )
	{
		data.etaSeconds = 60 * 60 //
	}
}

bool function ShouldShowLowPopDialog( string playlist )
{
	if ( !IsLowPopPlaylist( playlist ) )
		return false

	bool tooLong = IsCurrentDatacenterPastGoodETA()
	return tooLong
}

bool function IsLowPopPlaylist( string playlist )
{
	if ( IsElitePlaylist( playlist ) )
		return true

	if ( IsRankedPlaylist( playlist ) )
		return true

	return false
}

void function OpenLowPopDialogFromButton( var button )
{
	file.onButtonClickCallback = LowPop_SetRankedDatacenter
	AdvanceMenu( file.menu )

	string playlistName = Lobby_GetSelectedPlaylist()
	array<MatchmakingDatacenterETA> dcs = GetValidMatchmakingDatacenterETASorted( playlistName, false )
	MatchmakingDatacenterETA homeDC = GetCurrentMatchmakingDatacenterETA( playlistName )
	UpdateMatchmakingDatacenterETASeconds( homeDC )
	MatchmakingDatacenterETA rankedDC = GetCurrentRankedMatchmakingDatacenterETA( playlistName )
	UpdateMatchmakingDatacenterETASeconds( rankedDC )

	array<var> buttons = GetElementsByClassname( file.menu, "DatacenterButton" )
	array<MatchmakingDatacenterETA> datacenters
	bool hasHomeDC = false
	for ( int i=0; i<dcs.len() && i<buttons.len()-1; i++ )
	{
		if ( dcs[i].datacenterIdx == homeDC.datacenterIdx )
			hasHomeDC = true

		datacenters.append( dcs[i] )
	}

	if ( !hasHomeDC && datacenters.len() < buttons.len() - 1 )
		datacenters.append( homeDC )

	datacenters.append( rankedDC )

	PopulateMenuFromDatacenterList( datacenters )

	HudElem_SetRuiArg( file.dialogContent, "headerText", "#LOWPOP_YOUR_CURRENT_DATACENTER" )
	HudElem_SetRuiArg( file.dialogContent, "messageText", rankedDC.datacenterName.toupper() )
	HudElem_SetRuiArg( file.dialogContent, "reqsText", "#LOWPOP_CHANGE_DATACENTER" )
}

void function OpenLowPopDialog( void functionref(int) onButtonClickCallback )
{
	bool hasOtherOptions = GetValidMatchmakingDatacenterETASorted( Lobby_GetSelectedPlaylist() ).len() > 0

	if ( hasOtherOptions )
	{
		file.onButtonClickCallback = onButtonClickCallback
		AdvanceMenu( file.menu )
	}
	else
	{
		MatchmakingDatacenterETA currentDatacenter = GetCurrentRankedMatchmakingDatacenterETA( Lobby_GetSelectedPlaylist() )

		onButtonClickCallback( currentDatacenter.datacenterIdx )

		DisplayLowPopWarning()
	}
}

void function DisplayLowPopWarning()
{
	bool isInPeakTime = IsInCurrentDatacenterPeakTime()

	MatchmakingDatacenterETA currentDatacenter = GetCurrentRankedMatchmakingDatacenterETA( Lobby_GetSelectedPlaylist() )
	string timeString = ToRelativeTimeString( currentDatacenter.etaSeconds, 30 )

	ConfirmDialogData dialogData
	dialogData.headerText = "#LOWPOP_CURRENT_MATCHMAKING_TIME"

	if ( isInPeakTime || currentDatacenter.idealStartUTC < GetUnixTimestamp() || currentDatacenter.idealStartUTC <= 0 )
	{
		//
		return //
	}
	else
	{
		string peakTimeString = ToRelativeTimeString( (currentDatacenter.idealStartUTC - GetUnixTimestamp()) )
		dialogData.messageText = Localize( "#LOWPOP_EST_MATCHMAKING_TIME_WARNING_W_PEAK", timeString, peakTimeString )
	}

	OpenOKDialogFromData( dialogData )
}

void function OnDatacenterButtonClick( var button )
{
	if (!( button in file.buttonToDatacenter ))
		return

	MatchmakingDatacenterETA data = file.buttonToDatacenter[ button ]

	if ( file.onButtonClickCallback != null )
		file.onButtonClickCallback( data.datacenterIdx )

	CloseActiveMenu()
}
bool function IsCurrentDatacenterPastGoodETA()
{
	string playlist = Lobby_GetSelectedPlaylist()
	MatchmakingDatacenterETA data = GetCurrentRankedMatchmakingDatacenterETA( playlist )
	return data.etaSeconds > GetMaxGoodETA( playlist ) || data.etaSeconds <= 0
}

bool function IsInCurrentDatacenterPeakTime()
{
	string playlist = Lobby_GetSelectedPlaylist()
	MatchmakingDatacenterETA data = GetCurrentRankedMatchmakingDatacenterETA( playlist )
	int currentTime = GetUnixTimestamp()
	return currentTime > data.idealStartUTC && currentTime < data.idealEndUTC
}

int function GetMaxGoodETA( string playlist )
{
	return GetConVarInt( "match_rankedSwitchETA" )
}

string function ToRelativeTimeString( int timestamp, int minsCap = 0 )
{
	int mins = timestamp/60
	int hours = mins/60
	int minsAfterHours = mins - (60*hours)

	string timeString

	if ( minsCap > 0 && mins > minsCap )
	{
		timeString = Localize( "#ETA_MINUTES_MORE_THAN_DISPLAY", minsCap )
	}
	else if ( hours > 1 )
	{
		timeString = Localize( "#ETA_HOURS_MINUTES_DISPLAY", hours, minsAfterHours )
	}
	else if ( hours == 1 && minsAfterHours == 1 )
	{
		timeString = Localize( "#ETA_HOUR_MINUTES_DISPLAY", hours, minsAfterHours )
	}
	else if ( mins == 1 )
	{
		timeString = Localize( "#ETA_MINUTE_DISPLAY", mins )
	}
	else if ( mins > 0 )
	{
		timeString = Localize( "#ETA_MINUTES_DISPLAY", mins )
	}
	else
	{
		timeString = Localize( "#ETA_SECONDS_DISPLAY", timestamp )
	}


	return timeString
}

void function LowPop_SetRankedDatacenter( int datacenterIdx )
{
	SetRankedDatacenter( datacenterIdx )
	#if R5DEV
		file.fakeRankedDatacenter = datacenterIdx
	#endif
}

int function SortMatchmakingDatacenterETAByPing( MatchmakingDatacenterETA a, MatchmakingDatacenterETA b )
{
	if ( a.latency < b.latency )
		return 1

	if ( a.latency > b.latency )
		return -1

	if ( a.etaSeconds < b.etaSeconds )
		return 1

	if ( a.etaSeconds > b.etaSeconds )
		return -1

	return 0
}