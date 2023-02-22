global function InitR5RHomePanel
global function Play_SetupUI
global function R5RPlay_SetSelectedPlaylist

const MAX_PROMO_ITEMS = 5

struct ServerListing
{
	int	svServerID
	string svServerName
	string svMapName
	string svPlaylist
	string svDescription
	int svMaxPlayers
	int svCurrentPlayers
}

struct SelectedServerInfo
{
	int svServerID = -1
	string svServerName = ""
	string svMapName = ""
	string svPlaylist = ""
	string svDescription = ""
}

struct PromoItem
{
	asset promoImage
	string promoText1
	string promoText2
}

global enum JoinType
{
    TopServerJoin = 0,
    QuickPlay = 1,
    QuickServerJoin = 2,
    None = 3
}

struct
{
    int quickPlayType = JoinType.None
    string TopServerSelectedName = ""
    int TopServerSelectedID = -1
    string TopServerMapName = ""
} quickplay

struct
{
	var menu
	var panel
	var gamemodeSelectV2Button

	bool searching = false
	bool foundserver = false
	bool noservers = false
	bool usercancled = false
	bool firststart = false
	bool navInputCallbacksRegistered = false
	
	SelectedServerInfo m_vSelectedServer
	array<ServerListing> m_vServerList
	array<ServerListing> m_vFilteredServerList
} file

struct
{
	array<PromoItem> Items
	int pageCount = 3
	int currentPage = 0
	bool shouldAutoAdvance = true
	bool IsAutoAdvance = false
} promo

global table<int, string> SearchStages = {
	[ 0 ] = "Searching.",
	[ 1 ] = "Searching..",
	[ 2 ] = "Searching..."
}

global table<int, string> CreatingStages = {
	[ 0 ] = "Creating.",
	[ 1 ] = "Creating..",
	[ 2 ] = "Creating..."
}

global table<int, string> ConnectingStages = {
	[ 0 ] = "Connecting.",
	[ 1 ] = "Connecting..",
	[ 2 ] = "Connecting..."
}

void function InitR5RHomePanel( var panel )
{
	file.panel = panel
	file.menu = GetParentMenu( file.panel )

	var gameMenuButton = Hud_GetChild( panel, "GameMenuButton" )
	ToolTipData gameMenuToolTip
	gameMenuToolTip.descText = "#GAME_MENU"
	Hud_SetToolTipData( gameMenuButton, gameMenuToolTip )
	HudElem_SetRuiArg( gameMenuButton, "icon", $"rui/menu/lobby/settings_icon" )
	HudElem_SetRuiArg( gameMenuButton, "shortcutText", "%[START|ESCAPE]%" )
	Hud_AddEventHandler( gameMenuButton, UIE_CLICK, SettingsPressed )

	var playersButton = Hud_GetChild( panel, "PlayersButton" )
	HudElem_SetRuiArg( playersButton, "icon", $"rui/menu/lobby/friends_icon" )
	HudElem_SetRuiArg( playersButton, "buttonText", "" )

	var serversButton = Hud_GetChild( panel, "ServersButton" )
	HudElem_SetRuiArg( serversButton, "icon", $"rui/hud/gamestate/net_latency" )
	HudElem_SetRuiArg( serversButton, "buttonText", "" )

	var newsButton = Hud_GetChild( panel, "NewsButton" )
	ToolTipData newsToolTip
	newsToolTip.descText = "#NEWS"
	Hud_SetToolTipData( newsButton, newsToolTip )
	HudElem_SetRuiArg( newsButton, "icon", $"rui/menu/lobby/news_icon" )
	Hud_AddEventHandler( newsButton, UIE_CLICK, NewsPressed )

	file.gamemodeSelectV2Button = Hud_GetChild( panel, "GamemodeSelectV2Button" )
	RuiSetString( Hud_GetRui( file.gamemodeSelectV2Button ), "modeNameText", "Random" )
	RuiSetString( Hud_GetRui( file.gamemodeSelectV2Button ), "modeDescText", "Party not ready" )
	RuiSetBool( Hud_GetRui( file.gamemodeSelectV2Button ), "alwaysShowDesc", true )
	RuiSetImage( Hud_GetRui( file.gamemodeSelectV2Button ), "modeImage", $"rui/menu/gamemode/ranked_1" )
	Hud_AddEventHandler( file.gamemodeSelectV2Button, UIE_CLICK, GamemodeSelect_OnActivate )

	var readyButton = Hud_GetChild( panel, "ReadyButton" )
	Hud_AddEventHandler( readyButton, UIE_CLICK, ReadyButton_OnActivate )
	HudElem_SetRuiArg( readyButton, "isLeader", true ) // TEMP
	HudElem_SetRuiArg( readyButton, "isReady", false )
	HudElem_SetRuiArg( readyButton, "buttonText", Localize( "#READY" ) )

	var miniPromo = Hud_GetChild( file.panel, "MiniPromo" )
	Hud_AddEventHandler( miniPromo, UIE_GET_FOCUS, MiniPromoButton_OnGetFocus )
	Hud_AddEventHandler( miniPromo, UIE_LOSE_FOCUS, MiniPromoButton_OnLoseFocus )
}

void function Play_SetupUI()
{
	HudElem_SetRuiArg( Hud_GetChild( file.panel, "R5RVersionButton" ), "buttonText", Localize( "#BETA_BUILD_WATERMARK" ) )
	RuiSetString( Hud_GetRui( Hud_GetChild( file.panel, "SelfButton" ) ), "playerName", GetPlayerName() )
	RuiSetString( Hud_GetRui( Hud_GetChild( file.panel, "SelfButton" ) ), "accountLevel", GetAccountDisplayLevel( 100 ) )
	RuiSetImage( Hud_GetRui( Hud_GetChild( file.panel, "SelfButton" ) ), "accountBadge", $"rui/gladiator_cards/badges/account_t21" )
	RuiSetFloat( Hud_GetRui( Hud_GetChild( file.panel, "SelfButton" ) ), "accountXPFrac", 1.0 )

	var playersButton = Hud_GetChild( file.panel, "PlayersButton" )
	ToolTipData playersToolTip
	playersToolTip.titleText = "Players Online"
	playersToolTip.descText = MS_GetPlayerCount() + " Players Online"
	Hud_SetToolTipData( playersButton, playersToolTip )
	HudElem_SetRuiArg( playersButton, "buttonText", "" + MS_GetPlayerCount() )
	Hud_SetWidth( playersButton, Hud_GetBaseWidth( playersButton ) * 2 )

	var serversButton = Hud_GetChild( file.panel, "ServersButton" )
	ToolTipData serversToolTip
	serversToolTip.titleText = "Servers Running"
	serversToolTip.descText = MS_GetServerCount() + " Servers Running"
	Hud_SetToolTipData( serversButton, serversToolTip )
	HudElem_SetRuiArg( serversButton, "buttonText", "" + MS_GetServerCount() )
	Hud_SetWidth( serversButton, Hud_GetBaseWidth( serversButton ) * 2 )

	GetR5RPromos()
	SetPromoPage()
	if(!promo.IsAutoAdvance)
		thread AutoAdvancePages()

	if(!file.firststart)
	{
		g_SelectedPlaylist = "Random Server"
		R5RPlay_SetSelectedPlaylist(JoinType.QuickServerJoin)
		file.firststart = true
	}
}

void function SettingsPressed(var button)
{
	AdvanceMenu( GetMenu( "SystemMenu" ) )
}

void function NewsPressed(var button)
{
	AdvanceMenu( GetMenu( "R5RNews" ) )
}

// ====================================================================================================
// Quick Play
// ====================================================================================================

void function SetGamemodeButtonRUI(string modeNameText, string modeDescText, bool alwaysShowDesc, asset modeImage)
{
	RuiSetString( Hud_GetRui( file.gamemodeSelectV2Button ), "modeNameText", modeNameText )
	RuiSetString( Hud_GetRui( file.gamemodeSelectV2Button ), "modeDescText", modeDescText )
	RuiSetBool( Hud_GetRui( file.gamemodeSelectV2Button ), "alwaysShowDesc", alwaysShowDesc )
	RuiSetImage( Hud_GetRui( file.gamemodeSelectV2Button ), "modeImage", modeImage )
}

void function GamemodeSelect_OnActivate(var button)
{
	AdvanceMenu( GetMenu( "R5RGamemodeSelectV2Dialog" ) )
}

void function R5RPlay_SetSelectedPlaylist(int quickPlayType)
{
	switch(quickPlayType)
	{
		case JoinType.TopServerJoin:
				quickplay.quickPlayType = JoinType.TopServerJoin
				string servername = g_SelectedTopServer.svServerName
				if(g_SelectedTopServer.svServerName.len() > 30)
					servername = g_SelectedTopServer.svServerName.slice(0, 30) + "..."

				SetGamemodeButtonRUI(servername, "Party not ready", true, GetUIMapAsset(g_SelectedTopServer.svMapName ))
			break;
		case JoinType.QuickServerJoin:
			quickplay.quickPlayType = JoinType.QuickServerJoin

			asset image = $"rui/menu/gamemode/play_apex"
			if(g_SelectedPlaylist == "Random Server")
				image = $"rui/menu/gamemode/ranked_1"

			SetGamemodeButtonRUI(g_SelectedPlaylist, "Party not ready", true, image)
			break;
		case JoinType.QuickPlay:
			quickplay.quickPlayType = JoinType.QuickPlay
			SetGamemodeButtonRUI(GetUIMapName(g_SelectedQuickPlayMap), "Party not ready", true, g_SelectedQuickPlayImage)
			break;
	}
}

void function ReadyButton_OnActivate(var button)
{
	if(file.searching) {
		file.usercancled = true
		file.searching = false
		return;
	}

	file.searching = true
	EmitUISound( "UI_Menu_ReadyUp_1P" )
	RuiSetBool( Hud_GetRui( Hud_GetChild( file.panel, "SelfButton" ) ), "isReady", true )

	switch(quickplay.quickPlayType)
	{
		case JoinType.TopServerJoin:
			thread JoinTopServer( button )
			break;
		case JoinType.QuickServerJoin:
			thread StartMatchFinding( button )
			break;
		case JoinType.QuickPlay:
			thread StartQuickPlay( button )
			break;
	}
}

void function StartQuickPlay(var button)
{
	HudElem_SetRuiArg( button, "buttonText", Localize( "#CANCEL" ) )

	bool found = false
	float timewaited = 0.0

	int i = 0;
	while(!found)
	{
		if(timewaited > 4.0)
		{
			found = true
			continue
		}

		if(file.usercancled) {
			found = true
			continue
		}

		RuiSetString( Hud_GetRui( file.gamemodeSelectV2Button ), "modeDescText", CreatingStages[i] )

		i++
		if(i > 2)
			i = 0
		
		wait 0.5
		timewaited += 0.5
	}

	if(!file.usercancled)
	{
		EmitUISound( "UI_Menu_Apex_Launch" )
		RuiSetString( Hud_GetRui( file.gamemodeSelectV2Button ), "modeDescText", "Starting Match" )
		wait 2
		CreateServer(GetUIMapName(g_SelectedQuickPlayMap), "", g_SelectedQuickPlayMap, g_SelectedQuickPlay, eServerVisibility.OFFLINE)
		RuiSetString( Hud_GetRui( file.gamemodeSelectV2Button ), "modeDescText", "Party not ready" )
		RuiSetBool( Hud_GetRui( Hud_GetChild( file.panel, "SelfButton" ) ), "isReady", false )
		HudElem_SetRuiArg( button, "buttonText", Localize( "#READY" ) )
		return
	}
	
	EmitUISound( "UI_Menu_Deny" )
	file.usercancled = false
	RuiSetString( Hud_GetRui( file.gamemodeSelectV2Button ), "modeDescText", "Party not ready" )
	RuiSetBool( Hud_GetRui( Hud_GetChild( file.panel, "SelfButton" ) ), "isReady", false )
	HudElem_SetRuiArg( button, "buttonText", Localize( "#READY" ) )
}

void function JoinTopServer(var button)
{
	HudElem_SetRuiArg( button, "buttonText", Localize( "#CANCEL" ) )

	bool found = false
	float timewaited = 0.0
	int i = 0;
	while(!found)
	{
		if(timewaited > 4.0)
		{
			found = true
			continue
		}

		if(file.usercancled) {
			found = true
			continue
		}

		RuiSetString( Hud_GetRui( file.gamemodeSelectV2Button ), "modeDescText", ConnectingStages[i] )

		i++
		if(i > 2)
			i = 0
		
		wait 0.5
		timewaited += 0.5
	}

	if(!file.usercancled)
	{
		EmitUISound( "UI_Menu_Apex_Launch" )
		RuiSetString( Hud_GetRui( file.gamemodeSelectV2Button ), "modeDescText", "Joining Match" )
		wait 2
		ConnectToListedServer(g_SelectedTopServer.svServerID)
		RuiSetString( Hud_GetRui( file.gamemodeSelectV2Button ), "modeDescText", "Party not ready" )
		RuiSetBool( Hud_GetRui( Hud_GetChild( file.panel, "SelfButton" ) ), "isReady", false )
		HudElem_SetRuiArg( button, "buttonText", Localize( "#READY" ) )
		return
	}

	EmitUISound( "UI_Menu_Deny" )
	file.usercancled = false
	RuiSetString( Hud_GetRui( file.gamemodeSelectV2Button ), "modeDescText", "Party not ready" )
	RuiSetBool( Hud_GetRui( Hud_GetChild( file.panel, "SelfButton" ) ), "isReady", false )
	HudElem_SetRuiArg( button, "buttonText", Localize( "#READY" ) )
}

void function StartMatchFinding(var button)
{
	HudElem_SetRuiArg( button, "buttonText", Localize( "#CANCEL" ) )

	thread FindServer()

	int i = 0;
	while(!file.foundserver)
	{
		if(file.usercancled) {
			file.foundserver = true
			file.noservers = true
			continue
		}

		RuiSetString( Hud_GetRui( file.gamemodeSelectV2Button ), "modeDescText", SearchStages[i] )

		i++
		if(i > 2)
			i = 0
		
		wait 0.5
	}
	
	UpdateQuickJoinButtons(button)
}

void function UpdateQuickJoinButtons(var button)
{
	float waittime = 2

	if(file.usercancled)
	{
		EmitUISound( "UI_Menu_Deny" )
		file.noservers = true
		RuiSetString( Hud_GetRui( file.gamemodeSelectV2Button ), "modeDescText", "Party not ready" )
		waittime = 0
	}
	else if(file.noservers)
	{
		EmitUISound( "UI_Menu_Deny" )
		RuiSetString( Hud_GetRui( file.gamemodeSelectV2Button ), "modeDescText", "No servers found" )
	}
	else if(!file.noservers)
	{
		EmitUISound( "UI_Menu_Apex_Launch" )
		RuiSetString( Hud_GetRui( file.gamemodeSelectV2Button ), "modeDescText", "Joining Match" )
	}

	wait waittime

	if(!file.noservers) {
		ConnectToListedServer(file.m_vSelectedServer.svServerID)
	}

	RuiSetString( Hud_GetRui( file.gamemodeSelectV2Button ), "modeDescText", "Party not ready" )
	HudElem_SetRuiArg( button, "buttonText", Localize( "#READY" ) )
	RuiSetBool( Hud_GetRui( Hud_GetChild( file.panel, "SelfButton" ) ), "isReady", false )

	file.searching = false
	file.noservers = false
	file.foundserver = false
	file.usercancled = false
}

void function FindServer(bool refresh = false)
{
	wait 0.5

	if(!file.searching)
		return

	if(refresh)
		RefreshServerList()

	file.m_vServerList.clear()
	if(GetServerCount() == 0) {
		file.noservers = true
		file.foundserver = true
		return
	}

	// Add each server to the array
	for (int i=0, j=GetServerCount(); i < j; i++) {
		ServerListing Server
		Server.svServerID = i
		Server.svServerName = GetServerName(i)
		Server.svPlaylist = GetServerPlaylist(i)
		Server.svMapName = GetServerMap(i)
		Server.svDescription = GetServerDescription(i)
		Server.svMaxPlayers = GetServerMaxPlayers(i)
		Server.svCurrentPlayers = GetServerCurrentPlayers(i)
		file.m_vServerList.append(Server)
	}

	//First try non empty or full servers
	file.m_vFilteredServerList.clear()
	for ( int i = 0, j = file.m_vServerList.len(); i < j; i++ )
	{
		// Filters
		if ( file.m_vServerList[i].svCurrentPlayers == 0 )
			continue;

		if ( file.m_vServerList[i].svCurrentPlayers == file.m_vServerList[i].svMaxPlayers )
			continue;

		if(file.m_vServerList[i].svPlaylist != g_SelectedPlaylist && g_SelectedPlaylist != "Random Server")
			continue;

		// Server fits our requirements, add it to the list
		file.m_vFilteredServerList.append(file.m_vServerList[i])
	}

	if(file.m_vFilteredServerList.len() == 0) {
		//if non are found, include empty servers
		file.m_vFilteredServerList.clear()
		for ( int i = 0, j = file.m_vServerList.len(); i < j; i++ )
		{
			if ( file.m_vServerList[i].svCurrentPlayers == file.m_vServerList[i].svMaxPlayers )
				continue;

			if(file.m_vServerList[i].svPlaylist != g_SelectedPlaylist && g_SelectedPlaylist != "Random Server")
				continue;

			// Server fits our requirements, add it to the list
			file.m_vFilteredServerList.append(file.m_vServerList[i])
		}
	}

	if(file.m_vFilteredServerList.len() == 0) {
		file.noservers = true
		file.foundserver = true
		return
	}

	int randomserver = RandomIntRange( 0, file.m_vFilteredServerList.len() - 1 )
	file.m_vSelectedServer.svServerID = file.m_vFilteredServerList[randomserver].svServerID
	file.m_vSelectedServer.svServerName = file.m_vFilteredServerList[randomserver].svServerName
	file.m_vSelectedServer.svMapName = file.m_vFilteredServerList[randomserver].svMapName
	file.m_vSelectedServer.svPlaylist = file.m_vFilteredServerList[randomserver].svPlaylist
	file.m_vSelectedServer.svDescription = file.m_vFilteredServerList[randomserver].svDescription

	for(int i = 0; i < 4; i++)
	{
		wait 1

		if(!file.searching)
			return
	}

	file.foundserver = true
}


// =================================================================================================
// Promos
// =================================================================================================
void function MiniPromoButton_OnGetFocus( var button )
{
	if ( file.navInputCallbacksRegistered )
		return

	AddCallback_OnMouseWheelUp( ChangePromoPageToLeft )
	AddCallback_OnMouseWheelDown( ChangePromoPageToRight )
	file.navInputCallbacksRegistered = true
	promo.shouldAutoAdvance = false
}


void function MiniPromoButton_OnLoseFocus( var button )
{
	if ( !file.navInputCallbacksRegistered )
		return
	
	RemoveCallback_OnMouseWheelUp( ChangePromoPageToLeft )
	RemoveCallback_OnMouseWheelDown( ChangePromoPageToRight )
	file.navInputCallbacksRegistered = false
	promo.shouldAutoAdvance = true

	if(!promo.IsAutoAdvance)
		thread AutoAdvancePages()
}

void function ChangePromoPageToLeft()
{
	promo.currentPage--
	if(promo.currentPage < 0)
		promo.currentPage = promo.Items.len() - 1
	
	SetPromoPage()
}

void function ChangePromoPageToRight()
{
	promo.currentPage++
	if(promo.currentPage > promo.Items.len() - 1)
		promo.currentPage = 0
	
	SetPromoPage()
}

void function AutoAdvancePages()
{
	promo.IsAutoAdvance = true
	int i = 0
	while(promo.shouldAutoAdvance)
	{
		wait 1

		if(!promo.shouldAutoAdvance)
			continue
		
		if(i >= 10) {
			i = 0
			ChangePromoPageToRight()
		}

		i++
	}

	promo.IsAutoAdvance = false
}

void function SetPromoPage()
{
	if(promo.Items.len() == 0) {
		var miniPromo = Hud_GetChild( file.panel, "MiniPromo" )
		Hud_Hide( miniPromo)
		return
	}

	var miniPromo = Hud_GetChild( file.panel, "MiniPromo" )
	Hud_Show( miniPromo)
	RuiSetString( Hud_GetRui( miniPromo ), "lastText1", promo.Items[promo.currentPage].promoText1 )
	RuiSetString( Hud_GetRui( miniPromo ), "lastText2", promo.Items[promo.currentPage].promoText2 )
	RuiSetImage( Hud_GetRui( miniPromo ), "lastImageAsset", promo.Items[promo.currentPage].promoImage )
	RuiSetBool( Hud_GetRui( miniPromo ), "lastFormat", true )
	RuiSetInt( Hud_GetRui( miniPromo ), "activePageIndex", promo.currentPage )
}

void function GetR5RPromos()
{
	//INFO FOR LATER
    //MAX PAGES = 5

	//TEMPORARY PROMO DATA
	//WILL BE REPLACED WITH A CALL TO THE PROMO ENDPOINT
	promo.Items.clear()

	for(int i = 0; i < MAX_PROMO_ITEMS; i++)
	{
		PromoItem item
		item.promoText1 = "Temp Promo " + (i + 1)
		item.promoText2 = "Temp Promo " + (i + 1)
		item.promoImage = GetAssetFromString( $"rui/promo/S3_General_" + (i + 1).tostring() )
		promo.Items.append(item)
	}

	RuiSetInt( Hud_GetRui( Hud_GetChild( file.panel, "MiniPromo" ) ), "pageCount", promo.Items.len() )
}