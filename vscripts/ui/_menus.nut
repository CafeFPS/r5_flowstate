untyped

global const bool EDIT_LOADOUT_SELECTS = true
global const string PURCHASE_SUCCESS_SOUND = "UI_Menu_Store_Purchase_Success"

global function UICodeCallback_RemoteMatchInfoUpdated
global function UICodeCallback_InboxUpdated
global function UICodeCallback_CloseAllMenus
global function UICodeCallback_ActivateMenus
global function UICodeCallback_LevelInit
global function UICodeCallback_LevelLoadingStarted
global function UICodeCallback_LevelLoadingFinished
global function UICodeCallback_LevelShutdown
global function UICodeCallback_OnConnected
global function UICodeCallback_OnFocusChanged
global function UICodeCallback_NavigateBack
global function UICodeCallback_ToggleInGameMenu
global function UICodeCallback_ToggleInventoryMenu
global function UICodeCallback_ToggleMap
global function UICodeCallback_TryCloseDialog
global function UICodeCallback_UpdateLoadingLevelName
global function UICodeCallback_ConsoleKeyboardClosed
global function UICodeCallback_ErrorDialog
global function UICodeCallback_AcceptInvite
global function UICodeCallback_OnDetenteDisplayed
global function UICodeCallback_OnSpLogDisplayed
global function UICodeCallback_KeyBindOverwritten
global function UICodeCallback_KeyBindSet
global function UICodeCallback_PartyUpdated
global function UICodeCallback_PartyMemberAdded
global function UICodeCallback_PartyMemberRemoved
global function AddCallback_OnPartyUpdated
global function RemoveCallback_OnPartyUpdated
global function AddCallback_OnTopLevelCustomizeContextChanged
global function RemoveCallback_OnTopLevelCustomizeContextChanged
global function AddUICallback_LevelLoadingFinished
global function AddUICallback_LevelShutdown
global function AddUICallback_OnResolutionChanged
global function UICodeCallback_UserInfoUpdated
global function UICodeCallback_UIScriptResetComplete

global function ShouldShowPremiumCurrencyDialog
global function ShowPremiumCurrencyDialog

global function AdvanceMenu
global function CloseActiveMenu
global function CloseActiveMenuNoParms
global function CloseAllMenus
global function CloseAllDialogs
global function CloseAllToTargetMenu
global function PrintMenuStack
global function CleanupInGameMenus
global function GetActiveMenu
global function IsMenuVisible
global function IsPanelActive
global function GetActiveMenuName
global function GetMenu
global function GetPanel
global function GetAllMenuPanels
global function GetMenuTabBodyPanels
global function InitGamepadConfigs
global function InitMenus
global function AdvanceMenuEventHandler
global function PCSwitchTeamsButton_Activate
global function PCToggleSpectateButton_Activate
global function AddMenuElementsByClassname
global function SetPanelDefaultFocus
global function PanelFocusDefault
global function AddMenuEventHandler
global function AddPanelEventHandler
global function AddPanelEventHandler_FocusChanged
global function SetPanelInputHandler
global function AddButtonEventHandler
global function AddEventHandlerToButton
global function AddEventHandlerToButtonClass
global function RemoveEventHandlerFromButtonClass
global function PlayContextualMenuMusic
global function PlayUIMusic
global function StopUIMusic
global function IsMenuInMenuStack
global function RemoveFromMenuStack
global function GetTopNonDialogMenu
global function SetDialog
global function SetClearBlur
global function IsDialog
global function IsDialogOnlyActiveMenu
global function SetNavUpDown
global function SetNavLeftRight
global function AddMenuThinkFunc
global function IsTopLevelCustomizeContextValid
global function GetTopLevelCustomizeContext
global function SetTopLevelCustomizeContext
global function SetGamepadCursorEnabled
global function IsGamepadCursorEnabled
global function IsCommsMenuOpen

global function ButtonClass_AddMenu

global function PCBackButton_Activate

global function RegisterMenuVarInt
global function GetMenuVarInt
global function SetMenuVarInt
global function RegisterMenuVarBool
global function GetMenuVarBool
global function SetMenuVarBool
global function RegisterMenuVarVar
global function GetMenuVarVar
global function SetMenuVarVar
global function AddMenuVarChangeHandler

global function ClientToUI_SetCommsMenuOpen

global function InviteFriends
global function OpenInGameMenu

global function HACK_DelayedSetFocus_BecauseWhy

global function InitButtonRCP

global function AddCallbackAndCallNow_UserInfoUpdated
global function RemoveCallback_UserInfoUpdated

global function AddCallbackAndCallNow_RemoteMatchInfoUpdated
global function RemoveCallback_RemoteMatchInfoUpdated

#if DURANGO_PROG
global function OpenXboxPartyApp
global function OpenXboxHelp
#endif // DURANGO_PROG

#if DEV
global function OpenDevMenu
#endif // DEV

struct
{
	array<void functionref()>                   partyUpdatedCallbacks
	table<var, array<void functionref( var )> > topLevelCustomizeContextChangedCallbacks
	array<void functionref()>                   levelLoadingFinishedCallbacks
	array<void functionref()>                   levelShutdownCallbacks

	array<void functionref( string, string )>   userInfoChangedCallbacks // TODO: move to shared file for client usage; sh_userinfo
	array<void functionref()>                   remoteMatchInfoChangedCallbacks // TODO: move to shared file for client usage; sh_userinfo
} file


void function UICodeCallback_InboxUpdated()
{
	//
}


void function UICodeCallback_CloseAllMenus()
{
	printt( "UICodeCallback_CloseAllMenus" )
	CloseAllMenus()
	// This is usually followed by a call to UICodeCallback_ActivateMenus().
}

// Bringing up the console will cause this, and it probably shouldn't
void function UICodeCallback_ActivateMenus()
{
	if ( IsConnected() )
		return

	printt( "UICodeCallback_ActivateMenus:", GetActiveMenu() && Hud_GetHudName( GetActiveMenu() ) != "" )
	if ( uiGlobal.menuStack.len() == 0 )
	{
		AdvanceMenu( GetMenu( "MainMenu" ) )
	}

	if ( GetActiveMenu() == GetMenu( "MainMenu" ) )
		Signal( uiGlobal.signalDummy, "OpenErrorDialog" )

	PlayContextualMenuMusic()

	#if DURANGO_PROG
		Durango_LeaveParty()
	#endif // DURANGO_PROG
}


void function UICodeCallback_ToggleInGameMenu()
{
	if ( !IsFullyConnected() )
		return

	var activeMenu = GetActiveMenu()
	bool isLobby   = IsLobby()

	if ( isLobby )
	{
		if ( activeMenu == null )
			AdvanceMenu( GetMenu( "LobbyMenu" ) )
		else if ( activeMenu == GetMenu( "SystemMenu" ) )
			CloseActiveMenu()
		return
	}

	var ingameMenu = GetMenu( "SystemMenu" )

	// Temp until lots of work goes into making other menus able to open on top of character select
	if ( IsMenuInMenuStack( GetMenu( "CharacterSelectMenuNew" ) ) )
		return

	if ( IsDialog( activeMenu ) )
	{
		// Do nothing if a dialog is showing
	}
	else if ( IsSurvivalMenuEnabled() )
	{
		if ( activeMenu == null || SURVIVAL_IsAnInventoryMenuOpened() )
		{
			thread ToggleInventoryOrOpenOptions()
		}
		else if ( InputIsButtonDown( KEY_ESCAPE ) && uiGlobal.menuData[ uiGlobal.activeMenu ].navBackFunc != null )
		{
			uiGlobal.menuData[ uiGlobal.activeMenu ].navBackFunc()
		}
		else
			CloseActiveMenu()
	}
	else if ( !isLobby )
	{
		if ( activeMenu == null )
			AdvanceMenu( ingameMenu )
		else
			CloseAllMenus()
	}
}


void function ToggleInventoryOrOpenOptions()
{
	float startTime = Time()
	float duration  = 0.3
	float endTIme   = startTime + duration

	while ( InputIsButtonDown( BUTTON_START ) && Time() < endTIme )
	{
		WaitFrame()
	}

	if ( GetActiveMenu() != null )
	{
		if ( IsDialog( GetActiveMenu() ) )
			return
	}

	if ( InputIsButtonDown( KEY_ESCAPE ) && IsCommsMenuOpen() )
	{
		RunClientScript( "CommsMenu_HandleKeyInput", KEY_ESCAPE ) // HACK; ESC is special and doesn't get passed to the inputContext on the client
		return
	}

	if ( (Time() >= endTIme && InputIsButtonDown( BUTTON_START )) || (InputIsButtonDown( KEY_ESCAPE ) && !SURVIVAL_IsAnInventoryMenuOpened()) )
	{
		if ( IsShowingMap() && InputIsButtonDown( KEY_ESCAPE ) )
		{
			RunClientScript( "ClientToUI_HideScoreboard" )
			return
		}

		OpenSystemMenu()
	}
	else
	{
		if ( IsFullyConnected() )
		{
			if ( IsShowingMap() )
				RunClientScript( "ClientToUI_HideScoreboard" )

			if ( SURVIVAL_IsAnInventoryMenuOpened() )
			{
				if ( uiGlobal.menuData[ uiGlobal.activeMenu ].navBackFunc != null )
				{
					uiGlobal.menuData[ uiGlobal.activeMenu ].navBackFunc()
				}
				else
				{
					CloseActiveMenu()
				}
			}
			else
			{
				RunClientScript( "OpenSurvivalMenu" )
			}
		}
	}
}


void function UICodeCallback_ToggleInventoryMenu()
{
	if ( !IsFullyConnected() )
		return

	var activeMenu = GetActiveMenu()
	bool isLobby   = IsLobby()

	if ( isLobby || IsDialog( activeMenu ) )
		return

	if ( !activeMenu )
		RunClientScript( "PROTO_OpenInventoryOrSpecifiedMenu", GetUIPlayer() )
	else
		CloseAllMenus()
}


void function UICodeCallback_ToggleMap()
{
	if ( !IsFullyConnected() )
		return

	if ( IsLobby() )
		return

	RunClientScript( "ClientToUI_ToggleScoreboard" )
}


void function OpenInGameMenu( var button )
{
	var ingameMenu = GetMenu( "SystemMenu" )

	AdvanceMenu( ingameMenu )
}

// Return true to show load screen, false to not show load screen.
// levelname can be "" because the level to load isn't always known when the load screen starts
bool function UICodeCallback_LevelLoadingStarted( string levelname )
{
	printt( "UICodeCallback_LevelLoadingStarted: " + levelname )

	CloseAllDialogs()
	Signal( uiGlobal.signalDummy, "EndFooterUpdateFuncs" )
	Signal( uiGlobal.signalDummy, "EndSearchForPartyServerTimeout" )

	uiGlobal.loadingLevel = levelname

	if ( uiGlobal.playingVideo )
		Signal( uiGlobal.signalDummy, "PlayVideoEnded" )

	if ( uiGlobal.playingCredits )
		Signal( uiGlobal.signalDummy, "PlayingCreditsDone" )

	// kill lingering postgame summary since persistent data may not be available at this point
	Signal( uiGlobal.signalDummy, "PGDisplay" )

	#if CONSOLE_PROG
		if ( !Console_IsSignedIn() )
			return false
	#endif

	return true
}

// Return true to show load screen, false to not show load screen.
bool function UICodeCallback_UpdateLoadingLevelName( string levelname )
{
	printt( "UICodeCallback_UpdateLoadingLevelName: " + levelname )

	#if CONSOLE_PROG
		if ( !Console_IsSignedIn() )
			return false
	#endif

	return true
}


void function UICodeCallback_LevelLoadingFinished( bool error )
{
	printt( "UICodeCallback_LevelLoadingFinished: " + uiGlobal.loadingLevel + " (" + error + ")" )

	if ( IsLobby() && uiGlobal.activeMusic == "MainMenu_Music" )
	{
		// music keeps playing
	}
	else if ( IsLobby() )
	{
		PlayContextualMenuMusic()
	}
	else
	{
		StopUIMusic()
	}

	if ( !IsLobby() )
		HudChat_ClearTextFromAllChatPanels()
	else
		uiGlobal.lobbyFromLoadingScreen = true

	uiGlobal.loadingLevel = ""
	Signal( uiGlobal.signalDummy, "LevelFinishedLoading" )

	foreach ( callback in file.levelLoadingFinishedCallbacks )
		callback()
}


void function UICodeCallback_LevelInit( string levelname )
{
	Assert( IsConnected() )

	StopVideos( eVideoPanelContext.ALL )

	uiGlobal.loadedLevel = levelname

	printt( "UICodeCallback_LevelInit: " + uiGlobal.loadedLevel )

	//if ( !uiGlobal.loadoutsInitialized )
	//{
	//	string gameModeString = GetConVarString( "mp_gamemode" )
	//	if ( gameModeString != "solo" )
	//	{
	//		InitStatsTables()
	//	}
	//}

	#if DEV
		ShDevUtility_Init()
	#endif
	ShDevWeapons_Init()
	ShEHI_LevelInit_Begin()
	ShPakRequests_LevelInit()
	ShPersistentData_LevelInit_Begin()
	ShItems_LevelInit_Begin()
	ShGRX_LevelInit()
	CustomizeCommon_Init()
	ShLoadouts_LevelInit_Begin()
	ShCharacters_LevelInit()
	ShCharacterAbilities_LevelInit()
	ShCharacterCosmetics_LevelInit()
	ShWeapons_LevelInit()
	ShWeaponCosmetics_LevelInit()
	ShGladiatorCards_LevelInit()
	MeleeShared_Init()
	MeleeSyncedShared_Init()
	ShItems_LevelInit_Finish()
	ShItemPerPlayerState_LevelInit()
	UserInfoPanels_LevelInit()
	ShLoadouts_LevelInit_Finish()
	UiNewnessQueries_LevelInit()
	ShStatsInternals_LevelInit()
	ShStats_LevelInit()
	ShPersistentData_LevelInit_Finish()
	ShEHI_LevelInit_End()

	//InitItems()

	SURVIVAL_Loot_All_InitShared()
	//ShWeaponXP_Init()
	//ShFactionXP_Init()

	#if DEV
		UpdatePrecachedSPWeapons()
	#endif


	if ( !uiGlobal.loadoutsInitialized )
	{
		string gameModeString = GetConVarString( "mp_gamemode" )
		if ( gameModeString != "solo" )
		{
			DeathHints_Init()
			//CreateChallenges()
			uiGlobal.loadoutsInitialized = true
		}
	}

	//thread UpdateCachedLoadouts()
	//thread UpdateCachedNewItems()
	//thread InitUISpawnLoadoutIndexes()

	if ( !uiGlobal.eventHandlersAdded )
	{
		uiGlobal.eventHandlersAdded = true
	}

	//UI_GetAllChallengesProgress()

	bool isLobby = IsLobbyMapName( levelname )

	string gameModeString = GetConVarString( "mp_gamemode" )
	if ( gameModeString == "" )
		gameModeString = "<null>"

	Assert( gameModeString == GetConVarString( "mp_gamemode" ) )
	Assert( gameModeString != "" )

	int gameModeId        = GameMode_GetGameModeId( gameModeString )
	int mapId             = -1
	int difficultyLevelId = 0
	int roundId           = 0
	if ( isLobby )
	{
		Durango_OnLobbySessionStart( gameModeId, difficultyLevelId )
	}
	else
	{
		Durango_OnMultiplayerRoundStart( gameModeId, mapId, difficultyLevelId, roundId, 0 )
	}

	foreach ( callbackFunc in uiGlobal.onLevelInitCallbacks )
	{
		callbackFunc()
	}
	thread UpdateMenusOnConnectThread( levelname )

	uiGlobal.previousLevel = uiGlobal.loadedLevel
	uiGlobal.previousPlaylist = GetCurrentPlaylistName()
	uiGlobal.isShowingMap = false
}


void function UICodeCallback_LevelShutdown()
{
	ShutdownAllPanels()
	CloseAllMenus()

	ShGladiatorCards_LevelShutdown()
	ShLoadouts_LevelShutdown()
	VideoChannelManager_OnLevelShutdown()
	ShGRX_LevelShutdown()

	Signal( uiGlobal.signalDummy, "LevelShutdown" )

	printt( "UICodeCallback_LevelShutdown: " + uiGlobal.loadedLevel )

	StopVideos( eVideoPanelContext.ALL )

	if ( uiGlobal.loadedLevel != "" )
		CleanupInGameMenus()

	uiGlobal.loadedLevel = ""

	foreach ( callbackFunc in file.levelShutdownCallbacks )
	{
		callbackFunc()
	}

	UiNewnessQueries_LevelShutdown()
}


void function UICodeCallback_NavigateBack()
{
	var activeMenu = GetActiveMenu()
	if ( activeMenu == null )
		return

	if ( IsDialog( activeMenu ) )
	{
		if ( uiGlobal.menuData[ activeMenu ].dialogData.noChoice ||
				uiGlobal.menuData[ activeMenu ].dialogData.forceChoice ||
						Time() < uiGlobal.dialogInputEnableTime )
			return
	}

	Assert( activeMenu in uiGlobal.menuData )
	if ( uiGlobal.menuData[ activeMenu ].navBackFunc != null )
	{
		if ( IsPanelTabbed( activeMenu ) )
			_OnTab_NavigateBack( null )

		uiGlobal.menuData[ activeMenu ].navBackFunc()
		return
	}

	CloseActiveMenu( true )
}

// Called when IsConnected() will start returning true.
void function UICodeCallback_OnConnected()
{
}


void function UICodeCallback_OnFocusChanged( var oldFocus, var newFocus )
{
	foreach ( panel in uiGlobal.activePanels )
	{
		foreach ( focusChangedFunc in uiGlobal.panelData[ panel ].focusChangedFuncs )
			focusChangedFunc( panel, oldFocus, newFocus )
	}
}

// Accepting an origin invite closes dialogs, or aborts if they can't be closed
bool function UICodeCallback_TryCloseDialog()
{
	var activeMenu = GetActiveMenu()

	if ( !IsDialog( activeMenu ) )
		return true

	if ( uiGlobal.menuData[ activeMenu ].dialogData.forceChoice )
		return false

	CloseAllDialogs()
	Assert( !IsDialog( GetActiveMenu() ) )
	return true
}


void function UICodeCallback_ConsoleKeyboardClosed()
{
	switch ( GetActiveMenu() )
	{
		//case GetMenu( "EditPilotLoadoutMenu" ):
		//	string oldName = GetPilotLoadoutName( GetCachedPilotLoadout( uiGlobal.editingLoadoutIndex ) )
		//	string newName = GetPilotLoadoutRenameText()
		//
		//	// strip doesn't work on UTF-8 strings
		//	// newName = strip( newName ) // Remove leading/trailing whitespace
		//	if ( newName == "" ) // If all whitespace entered reset to previous name
		//		newName = oldName
		//
		//	SetPilotLoadoutName( newName )
		//	SelectPilotLoadoutRenameText()
		//	if ( newName != oldName )
		//		EmitUISound( "Menu.Accept" ) // No callback when cancelled so for now assume name was changed
		//	break

		default:
			break
	}
}


void function UICodeCallback_OnDetenteDisplayed()
{
	//	thread PlayDetentSound()
	//}
	//
	//void function PlayDetentSound()
	//{
	//	WaitFrame() // otherwise gets killed off by code pause
	//	WaitFrame() // otherwise gets killed off by code pause
	//	EmitUISound( "Pilot_Killed_Indicator" )
}


void function UICodeCallback_OnSpLogDisplayed()
{
}


void function UICodeCallback_ErrorDialog( string errorDetails )
{
	printt( "UICodeCallback_ErrorDialog: " + errorDetails )
	thread OpenErrorDialogThread( errorDetails )
}


void function UICodeCallback_AcceptInviteThread( string accesstoken, string from )
{
	printt( "UICodeCallback_AcceptInviteThread '" + accesstoken + "' from '" + from + "'" )

	#if PS4_PROG
		if ( !Ps4_PSN_Is_Loggedin() )
		{
			Ps4_LoginDialog_Schedule()
			while ( Ps4_LoginDialog_Running() )
				WaitFrame()

			if ( !Ps4_PSN_Is_Loggedin() )
				return
		}

/*
		if ( Ps4_CheckPlus_Schedule() )
		{
			while ( Ps4_CheckPlus_Running() )
				WaitFrame()

			if ( !Ps4_CheckPlus_Allowed() )
			{
				if ( Ps4_CheckPlus_GetLastRequestResults() != 0 )
				{
					return
				}

				if ( Ps4_ScreenPlusDialog_Schedule() )
				{
					while ( Ps4_ScreenPlusDialog_Running() )
						WaitFrame()

					if ( !Ps4_ScreenPlusDialog_Allowed() )
						return
				}
				else
				{
					return
				}
			}
		}
*/

	#endif // #if PS4_PROG

	SubscribeToChatroomPartyChannel( accesstoken, from )
}


void function UICodeCallback_AcceptInvite( string accesstoken, string fromxid )
{
	printt( "UICodeCallback_AcceptInvite '" + accesstoken + "' from '" + fromxid + "'" )
	thread    UICodeCallback_AcceptInviteThread( accesstoken, fromxid )
}


void function AdvanceMenu( var newMenu )
{
	//foreach ( index, menu in uiGlobal.menuStack )
	//{
	//	if ( menu != null )
	//		printt( "menu index " + index + " is named " + menu.GetDisplayName() )
	//}

	var currentMenu = GetActiveMenu()

	if ( currentMenu )
	{
		// Don't open the same menu again if it's already open
		if ( currentMenu == newMenu )
			return

		// Opening a normal menu while a dialog is open
		// TODO: temporary exception until we get rid of all the old dialog menus
		Assert( !IsDialog( currentMenu ), "Tried opening menu: " + Hud_GetHudName( newMenu ) + " when activeMenu was: " + Hud_GetHudName( currentMenu ) )
	}

	if ( currentMenu && !IsDialog( newMenu ) ) // Dialogs show on top so don't close existing menu when opening them
	{
		CloseMenu( currentMenu )
		ClearMenuBlur( currentMenu )

		if ( uiGlobal.menuData[ currentMenu ].hideFunc != null )
			uiGlobal.menuData[ currentMenu ].hideFunc()

		foreach ( var panel in GetAllMenuPanels( currentMenu ) )
		{
			PanelDef panelData = uiGlobal.panelData[panel]
			if ( panelData.isActive )
			{
				Assert( panelData.isCurrentlyShown )
				HidePanelInternal( panel )
			}
		}
	}

	if ( IsDialog( newMenu ) && currentMenu )
	{
		SetFooterPanelVisibility( currentMenu, false )
		if ( ShouldClearBlur( newMenu ) )
			ClearMenuBlur( currentMenu )
	}

	uiGlobal.menuStack.push( GetMenuDef( newMenu ) )
	uiGlobal.activeMenu = newMenu

	uiGlobal.lastMenuNavDirection = MENU_NAV_FORWARD

	if ( uiGlobal.activeMenu )
	{
		UpdateMenuBlur( uiGlobal.activeMenu )
		OpenMenuWrapper( uiGlobal.activeMenu, true )
	}

	Signal( uiGlobal.signalDummy, "ActiveMenuChanged" )
}


void function SetMenuBlur( var menu )
// TODO: Remove this and SetBlurEnabled() calls when blur is controlled in res/rui
{
	if ( menu == null )
		return

	MenuDef menuDef = GetMenuDef( menu )
	Hud_SetAboveBlur( menu, Hud_HasChild( menuDef.menu, "ScreenBlur" ) && IsConnected() )
	/*
		if ( IsDialog( menu ) ||
			 menu == GetMenu( "MiscMenu" ) ||
			 menu == GetMenu( "GamepadLayoutMenu" ) ||
			 menu == GetMenu( "ControlsAdvancedLookMenu" ) ||
			 menu == GetMenu( "PostGameMenu" ) ||
			 (!IsLobby() && !IsCharacterSelectMenu( menu )) ) // Force skip for CharacterSelectMenu for now
			SetBlurEnabled( true )
		else if ( IsLobby() )
			SetBlurEnabled( false )*/
}


void function UpdateMenuBlur( var menu )
{
	if ( !Hud_HasChild( menu, "ScreenBlur" ) || menu != GetActiveMenu() )
	{
		Hud_SetAboveBlur( menu, false )
		return
	}

	Hud_SetVisible( Hud_GetChild( menu, "ScreenBlur" ), IsConnected() )
	Hud_SetAboveBlur( menu, IsConnected() )
}


void function ClearMenuBlur( var menu )
{
	Hud_SetAboveBlur( menu, false )
}


bool function IsCharacterSelectMenu( var menu )
{
	if ( menu == GetMenu( "CharacterSelectMenuNew" ) )
		return true
	return false
}


void function SetFooterPanelVisibility( var menu, bool visible )
{
	if ( !Hud_HasChild( menu, "FooterButtons" ) )
		return

	var panel = Hud_GetChild( menu, "FooterButtons" )
	Hud_SetVisible( panel, visible )
}


void function CloseActiveMenuNoParms()
{
	CloseActiveMenu()
}


void function CloseActiveMenu( bool cancelled = false, bool openStackMenu = true )
{
	bool wasDialog = false

	var currentActiveMenu = uiGlobal.activeMenu
	var nextActiveMenu

	uiGlobal.menuStack.pop()
	if ( uiGlobal.menuStack.len() )
		nextActiveMenu = uiGlobal.menuStack.top().menu
	else
		nextActiveMenu = null

	uiGlobal.activeMenu = nextActiveMenu // (bm): assignment must happen before callbacks run

	if ( currentActiveMenu )
	{
		if ( IsDialog( currentActiveMenu ) )
		{
			wasDialog = true
			uiGlobal.dialogInputEnableTime = 0.0

			if ( uiGlobal.dialogCloseCallback )
			{
				uiGlobal.dialogCloseCallback( cancelled )
				uiGlobal.dialogCloseCallback = null
			}
		}

		CloseMenuWrapper( currentActiveMenu )
	}

	uiGlobal.lastMenuNavDirection = MENU_NAV_BACK

	if ( wasDialog )
	{
		if ( nextActiveMenu )
		{
			SetFooterPanelVisibility( nextActiveMenu, true )
			UpdateFooterOptions()
			UpdateMenuTabs()
		}

		if ( IsDialog( nextActiveMenu ) )
			openStackMenu = true
		else
			openStackMenu = false
	}

	if ( nextActiveMenu )
	{
		UpdateMenuBlur( nextActiveMenu )

		if ( openStackMenu )
		{
			OpenMenuWrapper( nextActiveMenu, false )
		}
	}

	Signal( uiGlobal.signalDummy, "ActiveMenuChanged" )
}


void function CloseAllMenus()
{
	while ( GetActiveMenu() )
		CloseActiveMenu( true, false )
}


void function CloseAllDialogs()
{
	while ( IsDialog( GetActiveMenu() ) )
		CloseActiveMenu( true )
}


void function CloseAllToTargetMenu( var targetMenu )
{
	while ( GetActiveMenu() != targetMenu )
		CloseActiveMenu( true, false )
}


void function PrintMenuStack()
{
	array<MenuDef> stack = clone uiGlobal.menuStack
	stack.reverse()

	printt( "MENU STACK:" )

	foreach ( menuDef in stack )
	{
		if ( menuDef.menu )
			printt( "   ", Hud_GetHudName( menuDef.menu ) )
		else
			printt( "    null" )
	}
}

// Happens on any level load
void function UpdateMenusOnConnectThread( string levelname )
{
	EndSignal( uiGlobal.signalDummy, "LevelShutdown" ) // HACK fix because UICodeCallback_LevelInit() incorrectly runs when disconnected by client error. Test with "script_error_client" while a level is loaded.

	CloseAllDialogs()

	var mainMenu = GetMenu( "MainMenu" )
	if ( IsMenuInMenuStack( mainMenu ) && !IsMenuInMenuStack( null ) )
		CloseAllToTargetMenu( mainMenu )

	Assert( GetActiveMenu() != null || uiGlobal.menuStack.len() == 0 )

	AdvanceMenu( null )

	bool isLobby = IsLobbyMapName( levelname )

	if ( isLobby )
	{
		AdvanceMenu( GetMenu( "LobbyMenu" ) )
		PlayContextualMenuMusic()

		if ( GetPersistentVar( "showGameSummary" ) && IsPostGameMenuValid( true ) )
			OpenPostGameMenu( null )
		else
			DialogFlow()
	}
}


void function DialogFlow()
{
	bool persistenceAvailable = IsPersistenceAvailable()
	if ( PlayerHasStarterPack( null ) && persistenceAvailable && !GetPersistentVarAsInt( "starterAcknowledged" ) )
	{
		ClientCommand( "starterAcknowledged" )
		ClientCommand( "lastSeenPremiumCurrency" )
		PromoDialog_OpenHijacked( "<p|starter|" + Localize( "#ORIGIN_ACCESS_STARTER" ) + "|" + Localize( "#STARTER_ENTITLEMENT_OWNED" ) + ">", DialogFlow )
	}
	else if ( PlayerHasFoundersPack( null ) && persistenceAvailable && !GetPersistentVarAsInt( "founderAcknowledged" ) )
	{
		ClientCommand( "founderAcknowledged" )
		ClientCommand( "lastSeenPremiumCurrency" )
		PromoDialog_OpenHijacked( "<p|founder|" + Localize( "#ORIGIN_ACCESS_FOUNDER" ) + "|" + Localize( "#FOUNDER_ENTITLEMENT_OWNED" ) + ">", DialogFlow )
	}
	else if ( PlayerHasTwitchPrimeRewards( GetUIPlayer() ) && persistenceAvailable && !GetPersistentVarAsInt( "twitchAcknowledged" ) )
	{
		ClientCommand( "twitchAcknowledged" )
		ClientCommand( "lastSeenPremiumCurrency" )
		PromoDialog_OpenHijacked( "<p|Twitch Promo|" + Localize( "#ORIGIN_ACCESS_TWITCH" ) + "|" + Localize( "#TWITCH_ENTITLEMENT_OWNED" ) + ">", DialogFlow )
	}
	else if ( Script_UserHasEAAccess() && persistenceAvailable && !GetPersistentVarAsInt( "accessAcknowledged" ) )
	{
		ClientCommand( "accessAcknowledged" )
		#if PC_PROG
			PromoDialog_OpenHijacked( "<p|access|" + Localize( "#ORIGIN_ACCESS" ) + "|" + Localize( "#ORIGIN_ACCESS_OWNED" ) + ">", DialogFlow )
		#else
			PromoDialog_OpenHijacked( "<p|Xbox EA Access|" + Localize( "#ORIGIN_ACCESS" ) + "|" + Localize( "#ORIGIN_ACCESS_OWNED" ) + ">", DialogFlow )
		#endif
	}
	#if PS4_PROG
	else if ( LocalPlayerHasEntitlement( PSPLUS_PACK ) && persistenceAvailable && GetPersistentVarAsInt( "plusAcknowledged" ) )
	{
		ClientCommand( "plusAcknowledged" )
		ClientCommand( "lastSeenPremiumCurrency" )
		PromoDialog_OpenHijacked( "<p|plus|" + Localize( "#PROMO_PS4_PLUS" ) + "|" + Localize( "#PROMO_PS4_PLUS_OWNED" ) + ">", DialogFlow )
	}
	#endif
	else if ( ShouldShowPremiumCurrencyDialog() )
	{
		ShowPremiumCurrencyDialog( true )
	}
	else
	{
		OpenPromoDialogIfNew()
	}
}


bool function ShouldShowPremiumCurrencyDialog()
{
	if ( !GRX_IsInventoryReady() )
		return false

	if ( IsDialog( GetActiveMenu() ) )
		return false

	int premiumBalance = GRXCurrency_GetPlayerBalance( GetUIPlayer(), GRX_CURRENCIES[GRX_CURRENCY_PREMIUM] )
	int lastSeenBalance = GetPersistentVarAsInt( "lastSeenPremiumCurrency" )
	if ( premiumBalance == lastSeenBalance )
		return false

	return premiumBalance > lastSeenBalance
}


void function ShowPremiumCurrencyDialog( bool dialogFlow )
{
	int premiumBalance = GRXCurrency_GetPlayerBalance( GetUIPlayer(), GRX_CURRENCIES[GRX_CURRENCY_PREMIUM] )
	int lastSeenBalance = GetPersistentVarAsInt( "lastSeenPremiumCurrency" )
	Assert( premiumBalance > lastSeenBalance )
	Assert( GRX_IsInventoryReady( ) )

	ItemFlavor currency = GRX_CURRENCIES[GRX_CURRENCY_PREMIUM]
	ConfirmDialogData dialogData
	dialogData.headerText = "#RECEIVED_PREMIUM_CURRENCY"
	dialogData.messageText = Localize( "#RECEIVED_PREMIUM_CURRENCY_DESC", ShortenNumber( string( premiumBalance - lastSeenBalance ) ), "%$" + ItemFlavor_GetIcon( currency ) + "%" )
	if ( dialogFlow )
	{
		dialogData.resultCallback = void function ( int result )
		{
			DialogFlow()
		}
	}

	ClientCommand( "lastSeenPremiumCurrency" )
	OpenOKDialogFromData( dialogData )
	EmitUISound( "UI_Menu_Purchase_Coins" )
}


bool function IsMenuInMenuStack( var searchMenu )
{
	foreach ( menuDef in uiGlobal.menuStack )
	{
		// loading a map pushes a null sentinel onto the menu stack
		if ( !menuDef.menu )
			continue

		if ( menuDef.menu == searchMenu )
			return true
	}

	return false
}


void function RemoveFromMenuStack( var searchMenu )
{
	for ( int i = uiGlobal.menuStack.len() - 1; i >= 0; i-- )
	{
		if ( searchMenu == uiGlobal.menuStack[i].menu )
			uiGlobal.menuStack.remove( i )
	}
}


var function GetTopNonDialogMenu()
{
	array<MenuDef> menuArray = clone uiGlobal.menuStack
	menuArray.reverse()

	foreach ( menuDef in menuArray )
	{
		if ( menuDef.menu == null || IsDialog( menuDef.menu ) )
			continue

		return menuDef.menu
	}

	return null
}


void function CleanupInGameMenus()
{
	Signal( uiGlobal.signalDummy, "CleanupInGameMenus" )

	CloseAllMenus()
	Assert( GetActiveMenu() == null )
	if ( uiGlobal.menuStack.len() )
	{
		if ( uiGlobal.loadingLevel == "" )
			CloseActiveMenu() // Disconnected. Remove stack null and open main menu.
		else
			CloseActiveMenu( true, false ) // Level to level transition. Remove stack null and DON'T open main menu.
	}
}


var function GetActiveMenu()
{
	return uiGlobal.activeMenu
}


bool function IsMenuVisible( var menu )
{
	return Hud_IsVisible( menu )
}


//var function GetActivePanel()
//{
//	if ( uiGlobal.activePanels.len() )
//		return uiGlobal.activePanels.top() // TODO: stack
//	else
//		return null
//}


var function IsPanelActive( var panel )
{
	return uiGlobal.activePanels.contains( panel )
}


string function GetActiveMenuName()
{
	return expect string( GetActiveMenu()._name )
}


var function GetMenu( string menuName )
{
	return uiGlobal.menus[ menuName ]
}


var function GetPanel( string panelName )
{
	return uiGlobal.panels[ panelName ]
}


array<var> function GetAllMenuPanels( var menu )
{
	array<var> menuPanels

	foreach ( panel in uiGlobal.allPanels )
	{
		if ( Hud_GetParent( panel ) == menu )
			menuPanels.append( panel )
	}

	return menuPanels
}


array<var> function GetMenuTabBodyPanels( var menu )
{
	array<var> panels

	foreach ( panel in uiGlobal.allPanels )
	{
		if ( Hud_GetParent( panel ) == menu )
			panels.append( panel )
	}

	return panels
}


void function InitGamepadConfigs()
{
	uiGlobal.buttonConfigs = [ { orthodox = "gamepad_button_layout_custom.cfg", southpaw = "gamepad_button_layout_custom.cfg" } ]

	uiGlobal.stickConfigs = []
	uiGlobal.stickConfigs.append( "gamepad_stick_layout_default.cfg" )
	uiGlobal.stickConfigs.append( "gamepad_stick_layout_southpaw.cfg" )
	uiGlobal.stickConfigs.append( "gamepad_stick_layout_legacy.cfg" )
	uiGlobal.stickConfigs.append( "gamepad_stick_layout_legacy_southpaw.cfg" )

	foreach ( key, val in uiGlobal.buttonConfigs )
	{
		VPKNotifyFile( "cfg/" + val.orthodox )
		VPKNotifyFile( "cfg/" + val.southpaw )
	}

	foreach ( key, val in uiGlobal.stickConfigs )
		VPKNotifyFile( "cfg/" + val )

	ExecCurrentGamepadButtonConfig()
	ExecCurrentGamepadStickConfig()

	SetStandardAbilityBindingsForPilot( GetLocalClientPlayer() )
}


void function InitMenus()
{
	InitGlobalMenuVars()
	//SpShWeaponsInit()

	var mainMenu = AddMenu( "MainMenu", $"resource/ui/menus/main.menu", InitMainMenu, "#MAIN" )
	AddPanel( mainMenu, "EstablishUserPanel", InitEstablishUserPanel )
	AddPanel( mainMenu, "MainMenuPanel", InitMainMenuPanel )

	AddMenu( "PlayVideoMenu", $"resource/ui/menus/play_video.menu", InitPlayVideoMenu )

	var lobbyMenu = AddMenu( "LobbyMenu", $"resource/ui/menus/lobby.menu", InitLobbyMenu )
	AddPanel( lobbyMenu, "PlayPanel", InitPlayPanel )
	AddPanel( lobbyMenu, "CharactersPanel", InitCharactersPanel )
	AddPanel( lobbyMenu, "ArmoryPanel", InitArmoryPanel )
	var storePanel = AddPanel( lobbyMenu, "StorePanel", InitStorePanel )
	AddPanel( storePanel, "LootPanel", InitLootPanel )
	AddPanel( storePanel, "ECPanel", InitOffersPanel )
	AddPanel( storePanel, "CharacterPanel", InitStoreCharactersPanel )
	AddPanel( storePanel, "VCPanel", InitStoreVCPanel )

	var systemMenu = AddMenu( "SystemMenu", $"resource/ui/menus/system.menu", InitSystemMenu )
	AddPanel( systemMenu, "SystemPanel", InitSystemPanelMain )

	var miscMenu      = AddMenu( "MiscMenu", $"resource/ui/menus/misc.menu", InitMiscMenu )
	var settingsPanel = AddPanel( miscMenu, "SettingsPanel", InitSettingsPanel )

	#if PC_PROG
		var controlsPCContainer = AddPanel( settingsPanel, "ControlsPCPanelContainer", InitControlsPCPanel )
		InitControlsPCPanelForCode( controlsPCContainer )
	#endif
	AddPanel( settingsPanel, "ControlsGamepadPanel", InitControlsGamepadPanel )

	var videoPanelContainer = AddPanel( settingsPanel, "VideoPanelContainer", InitVideoPanel )
	InitVideoPanelForCode( videoPanelContainer )
	AddPanel( settingsPanel, "SoundPanel", InitSoundPanel )
	AddPanel( settingsPanel, "HudOptionsPanel", InitHudOptionsPanel )

	var customizeCharacterMenu = AddMenu( "CustomizeCharacterMenu", $"resource/ui/menus/customize_character.menu", InitCustomizeCharacterMenu )
	AddPanel( customizeCharacterMenu, "CharacterSkinsPanel", InitCharacterSkinsPanel )
	var cardPanel = AddPanel( customizeCharacterMenu, "CharacterCardsPanel", InitCharacterCardsPanel )
	AddPanel( cardPanel, "CardFramesPanel", InitCardFramesPanel )
	AddPanel( cardPanel, "CardPosesPanel", InitCardPosesPanel )
	AddPanel( cardPanel, "CardBadgesPanel", InitCardBadgesPanel )
	AddPanel( cardPanel, "CardTrackersPanel", InitCardTrackersPanel )
	var quipsPanel = AddPanel( customizeCharacterMenu, "CharacterQuipsPanel", InitCharacterQuipsPanel )
	AddPanel( quipsPanel, "IntroQuipsPanel", InitIntroQuipsPanel )
	AddPanel( quipsPanel, "KillQuipsPanel", InitKillQuipsPanel )
	AddPanel( customizeCharacterMenu, "CharacterExecutionsPanel", InitCharacterExecutionsPanel )

	var customizeWeaponMenu = AddMenu( "CustomizeWeaponMenu", $"resource/ui/menus/customize_weapon.menu", InitCustomizeWeaponMenu )
	AddPanel( customizeWeaponMenu, "WeaponSkinsPanel0", InitWeaponSkinsPanel )
	AddPanel( customizeWeaponMenu, "WeaponSkinsPanel1", InitWeaponSkinsPanel )
	AddPanel( customizeWeaponMenu, "WeaponSkinsPanel2", InitWeaponSkinsPanel )
	AddPanel( customizeWeaponMenu, "WeaponSkinsPanel3", InitWeaponSkinsPanel )
	AddPanel( customizeWeaponMenu, "WeaponSkinsPanel4", InitWeaponSkinsPanel )

	AddMenu( "PassPurchasePremiumMenu", $"resource/ui/menus/passpurchasepremium.menu", InitDummyMenu )
	AddMenu( "PassPurchaseLevelMenu", $"resource/ui/menus/passpurchaselevel.menu", InitDummyMenu )

	AddMenu( "CharacterSelectMenuNew", $"resource/ui/menus/character_select_new.menu", UI_InitCharacterSelectNewMenu )

	var inventoryMenu = AddMenu( "SurvivalInventoryMenu", $"resource/ui/menus/survival_inventory.menu", InitSurvivalInventoryMenu )
	AddPanel( inventoryMenu, "SurvivalQuickInventoryPanel", InitSurvivalQuickInventoryPanel )
	AddPanel( inventoryMenu, "SquadPanel", InitSquadPanelInventory )
	AddPanel( inventoryMenu, "CharacterDetailsPanel", InitLegendPanelInventory )

	AddMenu( "SurvivalGroundListMenu", $"resource/ui/menus/survival_ground_list.menu", InitGroundListMenu )
	AddMenu( "SurvivalQuickSwapMenu", $"resource/ui/menus/survival_quick_swap.menu", InitQuickSwapMenu )

	AddMenu( "GammaMenu", $"resource/ui/menus/gamma.menu", InitGammaMenu, "#BRIGHTNESS" )

	AddMenu( "Notifications", $"resource/ui/menus/notifications.menu", InitNotificationsMenu )

	AddMenu( "InGameMPMenu", $"resource/ui/menus/ingame_mp.menu", InitInGameMPMenu )

	AddMenu( "PostGameMenu", $"resource/ui/menus/postgame.menu", InitPostGameMenu )

	AddMenu( "Dialog", $"resource/ui/menus/dialog.menu", InitDialogMenu )
	AddMenu( "PromoDialog", $"resource/ui/menus/dialogs/promo.menu", InitPromoDialog )
	AddMenu( "CharacterSkillsDialog", $"resource/ui/menus/dialogs/character_skills.menu", InitCharacterSkillsDialog )
	AddMenu( "ConfirmDialog", $"resource/ui/menus/dialogs/confirm_dialog.menu", InitConfirmDialog )
	AddMenu( "OKDialog", $"resource/ui/menus/dialogs/ok_dialog.menu", InitOKDialog )
	AddMenu( "ConfirmExitToDesktopDialog", $"resource/ui/menus/dialogs/confirm_dialog.menu", InitConfirmExitToDesktopDialog )
	AddMenu( "ConfirmLeaveMatchDialog", $"resource/ui/menus/dialogs/confirm_dialog.menu", InitConfirmLeaveMatchDialog )
	AddMenu( "ConfirmKeepVideoChangesDialog", $"resource/ui/menus/dialogs/confirm_dialog.menu", InitConfirmKeepVideoChangesDialog )
	AddMenu( "ConfirmPurchaseDialog", $"resource/ui/menus/dialogs/confirm_purchase.menu", InitConfirmPurchaseDialog )
	AddMenu( "ConfirmGrxErrorDialog", $"resource/ui/menus/dialogs/confirm_dialog.menu", InitConfirmGrxErrorDialog )
	AddMenu( "ConnectingDialog", $"resource/ui/menus/dialog_connecting.menu", InitConnectingDialog )
	AddMenu( "DataCenterDialog", $"resource/ui/menus/dialog_datacenter.menu", InitDataCenterDialogMenu )
	AddMenu( "EULADialog", $"resource/ui/menus/dialog_eula.menu", InitEULADialog )
	AddMenu( "ModeSelectDialog", $"resource/ui/menus/dialog_mode_select.menu", InitModeSelectDialog )
	AddMenu( "ErrorDialog", $"resource/ui/menus/dialogs/ok_dialog.menu", InitErrorDialog )
	AddMenu( "AccessibilityDialog", $"resource/ui/menus/dialogs/accessibility_dialog.menu", InitAccessibilityDialog )

	AddMenu( "ControlsAdvancedLookMenu", $"resource/ui/menus/controls_advanced_look.menu", InitControlsAdvancedLookMenu, "#CONTROLS_ADVANCED_LOOK" )
	AddMenu( "GamepadLayoutMenu", $"resource/ui/menus/gamepadlayout.menu", InitGamepadLayoutMenu )

	AddMenu( "LootBoxOpen", $"resource/ui/menus/loot_box.menu", InitLootBoxMenu )
	AddMenu( "InviteFriendsMenu", $"resource/ui/menus/invite_friends.menu", InitInviteFriendsMenu )
	AddMenu( "SocialMenu", $"resource/ui/menus/social.menu", InitSocialMenu )
	AddMenu( "InspectMenu", $"resource/ui/menus/inspect.menu", InitInspectMenu )

	AddMenu( "DevMenu", $"resource/ui/menus/dev.menu", InitDevMenu, "Dev" )

	InitTabs()

	foreach ( menu in uiGlobal.allMenus )
	{
		if ( uiGlobal.menuData[ menu ].initFunc != null )
			uiGlobal.menuData[ menu ].initFunc()

		array<var> elems = GetElementsByClassname( menu, "TabsCommonClass" )
		if ( elems.len() )
			uiGlobal.menuData[ menu ].hasTabs = true

		elems = GetElementsByClassname( menu, "EnableKeyBindingIcons" )
		foreach ( elem in elems )
			Hud_EnableKeyBindingIcons( elem )
	}

	foreach ( panel in uiGlobal.allPanels )
	{
		if ( uiGlobal.panelData[ panel ].initFunc != null )
			uiGlobal.panelData[ panel ].initFunc( panel )

		array<var> elems = GetPanelElementsByClassname( panel, "TabsPanelClass" )
		if ( elems.len() )
			uiGlobal.panelData[ panel ].hasTabs = true
	}

	// A little weird, but GetElementsByClassname() uses menu scope rather than parent scope.
	foreach ( menu in uiGlobal.allMenus )
	{
		array<var> buttons = GetElementsByClassname( menu, "DefaultFocus" )
		foreach ( button in buttons )
		{
			var panel = Hud_GetParent( button )

			//Assert( elems.len() == 1, "More than 1 panel element set as DefaultFocus!" )
			Assert( panel != null, "no parent panel found for button " + Hud_GetHudName( button ) )
			Assert( panel in uiGlobal.panelData, "panel " + Hud_GetHudName( panel ) + " isn't in uiGlobal.panelData, but button " + Hud_GetHudName( button ) + " has defaultFocus set!" )
			uiGlobal.panelData[ panel ].defaultFocus = button
			//printt( "Found DefaultFocus, button was:", Hud_GetHudName( button ), "panel was:", Hud_GetHudName( panel ) )
		}
	}

	InitFooterOptions()
	InitMatchmakingOverlay()

	RegisterTabNavigationInput()
	thread UpdateGamepadCursorEnabledThread()
}


void function InitDummyMenu()
{

}


void functionref( var ) function AdvanceMenuEventHandler( var menu )
{
	return void function( var item ) : ( menu )
	{
		if ( Hud_IsLocked( item ) )
			return

		AdvanceMenu( menu )
	}
}


void function PCBackButton_Activate( var button )
{
	UICodeCallback_NavigateBack()
}


void function PCSwitchTeamsButton_Activate( var button )
{
	ClientCommand( "PrivateMatchSwitchTeams" )
}


void function PCToggleSpectateButton_Activate( var button )
{
	ClientCommand( "PrivateMatchToggleSpectate" )
}


void function AddMenuElementsByClassname( var menu, string classname )
{
	array<var> elements = GetElementsByClassname( menu, classname )

	if ( !(classname in menu.classElements) )
		menu.classElements[classname] <- []

	menu.classElements[classname].extend( elements )
}


void function SetPanelDefaultFocus( var panel, var button )
{
	uiGlobal.panelData[ panel ].defaultFocus = button
}


void function PanelFocusDefault( var panel )
{
	//printt( "PanelFocusDefault called" )
	if ( uiGlobal.panelData[ panel ].defaultFocus )
	{
		Hud_SetFocused( uiGlobal.panelData[ panel ].defaultFocus )
		//printt( "PanelFocusDefault if passed,", Hud_GetHudName( uiGlobal.panelData[ panel ].defaultFocus ), "focused" )
	}
}


void function AddMenuThinkFunc( var menu, void functionref( var ) func )
{
	uiGlobal.menuData[ menu ].thinkFuncs.append( func )
}


void function AddMenuEventHandler( var menu, int event, void functionref() func )
{
	if ( event == eUIEvent.MENU_OPEN )
	{
		Assert( uiGlobal.menuData[ menu ].openFunc == null )
		uiGlobal.menuData[ menu ].openFunc = func
	}
	else if ( event == eUIEvent.MENU_CLOSE )
	{
		Assert( uiGlobal.menuData[ menu ].closeFunc == null )
		uiGlobal.menuData[ menu ].closeFunc = func
	}
	else if ( event == eUIEvent.MENU_SHOW )
	{
		Assert( uiGlobal.menuData[ menu ].showFunc == null )
		uiGlobal.menuData[ menu ].showFunc = func
	}
	else if ( event == eUIEvent.MENU_HIDE )
	{
		Assert( uiGlobal.menuData[ menu ].hideFunc == null )
		uiGlobal.menuData[ menu ].hideFunc = func
	}
	else if ( event == eUIEvent.MENU_NAVIGATE_BACK )
	{
		Assert( uiGlobal.menuData[ menu ].navBackFunc == null )
		uiGlobal.menuData[ menu ].navBackFunc = func
	}
	//else if ( event == eUIEvent.MENU_TAB_CHANGED )
	//{
	//	Assert( uiGlobal.menuData[ menu ].tabChangedFunc == null )
	//	uiGlobal.menuData[ menu ].tabChangedFunc = func
	//}
	else if ( event == eUIEvent.MENU_INPUT_MODE_CHANGED )
	{
		Assert( uiGlobal.menuData[ menu ].inputModeChangedFunc == null )
		uiGlobal.menuData[ menu ].inputModeChangedFunc = func
	}
}


void function AddPanelEventHandler( var panel, int event, void functionref( var panel ) func )
{
	if ( event == eUIEvent.PANEL_SHOW )
		uiGlobal.panelData[ panel ].showFuncs.append( func )
	else if ( event == eUIEvent.PANEL_HIDE )
		uiGlobal.panelData[ panel ].hideFuncs.append( func )
	else if ( event == eUIEvent.PANEL_NAVUP )
		uiGlobal.panelData[ panel ].navUpFunc = func
	else if ( event == eUIEvent.PANEL_NAVDOWN )
		uiGlobal.panelData[ panel ].navDownFunc = func
	else if ( event == eUIEvent.PANEL_NAVBACK )
		uiGlobal.panelData[ panel ].navBackFunc = func
}


void function AddPanelEventHandler_FocusChanged( var panel, void functionref( var panel, var oldFocus, var newFocus ) func )
{
	 uiGlobal.panelData[ panel ].focusChangedFuncs.append( func )
}


void function SetPanelInputHandler( var panel, int inputID, void functionref( var panel ) func )
{
	Assert( !(inputID in uiGlobal.panelData[ panel ].panelInputs), "Panels may only register a single handler for button input" )
	uiGlobal.panelData[ panel ].panelInputs[ inputID ] <- func
}


// TODO: Get a real on open event from code?
void function OpenMenuWrapper( var menu, bool isFirstOpen )
{
	OpenMenu( menu )
	printt( Hud_GetHudName( menu ), "menu opened" )

	Assert( menu in uiGlobal.menuData )

	if ( isFirstOpen )
	{
		if ( uiGlobal.menuData[ menu ].openFunc != null )
		{
			uiGlobal.menuData[ menu ].openFunc()
			//printt( "Called openFunc for:", menu.GetHudName() )
		}
		FocusDefaultMenuItem( menu )
	}

	if ( uiGlobal.menuData[ menu ].showFunc != null )
	{
		uiGlobal.menuData[ menu ].showFunc()
		//printt( "Called showFunc for:", menu.GetHudName() )
	}
	uiGlobal.menuData[ menu ].enterTime = Time()

	foreach ( var panel in GetAllMenuPanels( menu ) )
	{
		PanelDef panelData = uiGlobal.panelData[panel]
		if ( panelData.isActive && !panelData.isCurrentlyShown )
			ShowPanelInternal( panel )
	}

	#if HAS_TOOLTIPS
		ToolTips_MenuOpened( menu )
	#endif

	UpdateFooterOptions()
	UpdateMenuTabs()
}


void function CloseMenuWrapper( var menu )
{
	bool wasVisible = Hud_IsVisible( menu )
	CloseMenu( menu )
	ClearMenuBlur( menu )
	printt( Hud_GetHudName( menu ), "menu closed" )

	#if HAS_TOOLTIPS
		ToolTips_MenuClosed( menu )
	#endif

	if ( wasVisible )
	{
		if ( uiGlobal.menuData[ menu ].hideFunc != null )
			uiGlobal.menuData[ menu ].hideFunc()

		PIN_PageView( Hud_GetHudName( menu ), Time() - uiGlobal.menuData[ menu ].enterTime, uiGlobal.pin_lastMenuId, IsDialog( menu ) )
		uiGlobal.pin_lastMenuId = Hud_GetHudName( menu )

		foreach ( var panel in GetAllMenuPanels( menu ) )
		{
			PanelDef panelData = uiGlobal.panelData[panel]
			if ( panelData.isActive )
			{
				Assert( panelData.isCurrentlyShown )
				HidePanelInternal( panel )
			}
		}
	}

	Assert( menu in uiGlobal.menuData )
	if ( uiGlobal.menuData[ menu ].closeFunc != null )
	{
		uiGlobal.menuData[ menu ].closeFunc()
		//printt( "Called closeFunc for:", Hud_GetHudName( menu ) )
	}
}


void function AddButtonEventHandler( var button, int event, void functionref( var ) func )
{
	Hud_AddEventHandler( button, event, func )
}


void function AddEventHandlerToButton( var menu, string buttonName, int event, void functionref( var ) func )
{
	var button = Hud_GetChild( menu, buttonName )
	Hud_AddEventHandler( button, event, func )
}


void function AddEventHandlerToButtonClass( var menu, string classname, int event, void functionref( var ) func )
{
	array<var> buttons = GetElementsByClassname( menu, classname )

	foreach ( button in buttons )
	{
		//printt( "button name:", Hud_GetHudName( button ) )
		Hud_AddEventHandler( button, event, func )
	}
}


void function RemoveEventHandlerFromButtonClass( var menu, string classname, int event, void functionref( var ) func )
{
	array<var> buttons = GetElementsByClassname( menu, classname )

	foreach ( button in buttons )
	{
		//printt( "button name:", Hud_GetHudName( button ) )
		Hud_RemoveEventHandler( button, event, func )
	}
}


void function PlayContextualMenuMusic()
{
	if ( !IsConnected() )
		PlayUIMusic( "MainMenu_Music" )
	else if ( IsLobby() && uiGlobal.activeMusic != "MainMenu_Music" )
		PlayUIMusic( "Music_Lobby" )
}


void function PlayUIMusic( string music )
{
	if ( uiGlobal.activeMusic == music )
		return

	if ( uiGlobal.playingVideo )
		return

	StopUIMusic()
	EmitUISound( music )
	uiGlobal.activeMusic = music
}


void function StopUIMusic()
{
	//if ( uiGlobal.activeMusic != "" )
	//	StopUISoundByName( uiGlobal.activeMusic )

	// TEMP (stop all potentially playing sounds until we have a code fix for calling StopUISoundByName() in ui shutdown callback)
	StopUISoundByName( "MainMenu_Music" )
	StopUISoundByName( "Music_Lobby" )
	StopUISoundByName( LOOT_CEREMONY_MUSIC_P1 )
	StopUISoundByName( LOOT_CEREMONY_MUSIC_P2 )

	uiGlobal.activeMusic = ""
}


void function RegisterMenuVarInt( string varName, int value )
{
	table<string, int> intVars = uiGlobal.intVars

	Assert( !(varName in intVars) )

	intVars[varName] <- value
}


void function RegisterMenuVarBool( string varName, bool value )
{
	table<string, bool> boolVars = uiGlobal.boolVars

	Assert( !(varName in boolVars) )

	boolVars[varName] <- value
}


void function RegisterMenuVarVar( string varName, var value )
{
	table<string, var> varVars = uiGlobal.varVars

	Assert( !(varName in varVars) )

	varVars[varName] <- value
}


int function GetMenuVarInt( string varName )
{
	table<string, int> intVars = uiGlobal.intVars

	Assert( varName in intVars )

	return intVars[varName]
}


bool function GetMenuVarBool( string varName )
{
	table<string, bool> boolVars = uiGlobal.boolVars

	Assert( varName in boolVars )

	return boolVars[varName]
}


var function GetMenuVarVar( string varName )
{
	table<string, var> varVars = uiGlobal.varVars

	Assert( varName in varVars )

	return varVars[varName]
}


void function SetMenuVarInt( string varName, int value )
{
	table<string, int> intVars = uiGlobal.intVars

	Assert( varName in intVars )

	if ( intVars[varName] == value )
		return

	intVars[varName] = value

	table<string, array<void functionref()> > varChangeFuncs = uiGlobal.varChangeFuncs

	if ( varName in varChangeFuncs )
	{
		foreach ( func in varChangeFuncs[varName] )
		{
			//printt( varName, "changed, calling changeFunc:", string( func ) )
			func()
		}
	}
}


void function SetMenuVarBool( string varName, bool value )
{
	table<string, bool> boolVars = uiGlobal.boolVars

	Assert( varName in boolVars )

	if ( boolVars[varName] == value )
		return

	boolVars[varName] = value

	table<string, array<void functionref()> > varChangeFuncs = uiGlobal.varChangeFuncs

	if ( varName in varChangeFuncs )
	{
		foreach ( func in varChangeFuncs[varName] )
		{
			//printt( varName, "changed, calling changeFunc:", string( func ) )
			func()
		}
	}
}


void function SetMenuVarVar( string varName, var value )
{
	table<string, var> varVars = uiGlobal.varVars

	Assert( varName in varVars )

	if ( varVars[varName] == value )
		return

	varVars[varName] = value

	table<string, array<void functionref()> > varChangeFuncs = uiGlobal.varChangeFuncs

	if ( varName in varChangeFuncs )
	{
		foreach ( func in varChangeFuncs[varName] )
		{
			//printt( varName, "changed, calling changeFunc:", string( func ) )
			func()
		}
	}
}


void function AddMenuVarChangeHandler( string varName, void functionref() func )
{
	table<string, array<void functionref()> > varChangeFuncs = uiGlobal.varChangeFuncs

	if ( !(varName in varChangeFuncs) )
		varChangeFuncs[varName] <- []

	// TODO: Verify we're not duplicating an existing func
	varChangeFuncs[varName].append( func )
}

// These are common menu statuses that trigger menu logic any time they change
// They should become code callbacks, so script doesn't poll
void function InitGlobalMenuVars()
{
	RegisterMenuVarBool( "isFullyConnected", false )
	RegisterMenuVarBool( "isPartyLeader", false )
	RegisterMenuVarBool( "isGamepadActive", IsControllerModeActive() )
	RegisterMenuVarBool( "isMatchmaking", false )

	#if CONSOLE_PROG
		RegisterMenuVarBool( "CONSOLE_isSignedIn", false )
	#endif // CONSOLE_PROG

	#if DURANGO_PROG
		RegisterMenuVarBool( "DURANGO_canInviteFriends", false )
		RegisterMenuVarBool( "DURANGO_isJoinable", false )
	#elseif PS4_PROG
		RegisterMenuVarBool( "PS4_canInviteFriends", false )
	#elseif PC_PROG
		RegisterMenuVarBool( "ORIGIN_isEnabled", false )
		RegisterMenuVarBool( "ORIGIN_isJoinable", false )
	#endif

	thread UpdateIsFullyConnected()
	thread UpdateAmIPartyLeader()
	thread UpdateActiveMenuThink()
	thread UpdateIsMatchmaking()

	#if CONSOLE_PROG
		thread UpdateConsole_IsSignedIn()
	#endif // CONSOLE_PROG

	#if DURANGO_PROG
		thread UpdateDurango_CanInviteFriends()
		thread UpdateDurango_IsJoinable()
	#elseif PS4_PROG
		thread UpdatePS4_CanInviteFriends()
	#elseif PC_PROG
		thread UpdateOrigin_IsEnabled()
		thread UpdateOrigin_IsJoinable()
		thread UpdateIsGamepadActive()
	#endif
}


void function UpdateActiveMenuThink()
{
	OnThreadEnd(
		function() : ()
		{
			Assert( false, "This thread should not have ended" )
		}
	)

	while ( true )
	{
		var menu = GetActiveMenu()
		if ( menu )
		{
			Assert( menu in uiGlobal.menuData )
			foreach ( func in uiGlobal.menuData[ menu ].thinkFuncs )
				func( menu )
		}

		WaitFrame()
	}
}


void function UpdateIsFullyConnected()
{
	while ( true )
	{
		SetMenuVarBool( "isFullyConnected", IsFullyConnected() )
		WaitFrame()
	}
}


void function UpdateAmIPartyLeader()
{
	while ( true )
	{
		SetMenuVarBool( "isPartyLeader", AmIPartyLeader() )
		WaitFrame()
	}
}


void function UpdateIsMatchmaking()
{
	while ( true )
	{
		SetMenuVarBool( "isMatchmaking", (IsConnected() && AreWeMatchmaking()) )
		WaitFrame()
	}
}

#if CONSOLE_PROG
void function UpdateConsole_IsSignedIn()
{
	while ( true )
	{
		SetMenuVarBool( "CONSOLE_isSignedIn", Console_IsSignedIn() )
		WaitFrame()
	}
}
#endif // CONSOLE_PROG


#if PS4_PROG
void function UpdatePS4_CanInviteFriends()
{
	while ( true )
	{
		SetMenuVarBool( "PS4_canInviteFriends", PS4_canInviteFriends() )
		WaitFrame()
	}
}
#endif // PS4_PROG



#if DURANGO_PROG
void function UpdateDurango_CanInviteFriends()
{
	while ( true )
	{
		SetMenuVarBool( "DURANGO_canInviteFriends", Durango_CanInviteFriends() )
		WaitFrame()
	}
}

void function UpdateDurango_IsJoinable()
{
	while ( true )
	{
		SetMenuVarBool( "DURANGO_isJoinable", Durango_IsJoinable() )
		WaitFrame()
	}
}
#endif // DURANGO_PROG

#if PC_PROG
void function UpdateOrigin_IsEnabled()
{
	while ( true )
	{
		SetMenuVarBool( "ORIGIN_isEnabled", Origin_IsEnabled() )
		WaitFrame()
	}
}

void function UpdateOrigin_IsJoinable()
{
	while ( true )
	{
		SetMenuVarBool( "ORIGIN_isJoinable", Origin_IsJoinable() )
		WaitFrame()
	}
}

void function UpdateIsGamepadActive()
{
	while ( true )
	{
		SetMenuVarBool( "isGamepadActive", IsControllerModeActive() )
		WaitFrame()
	}
}
#endif // PC_PROG

void function InviteFriends()
{
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

	AdvanceMenu( GetMenu( "SocialMenu" ) )
}

#if DURANGO_PROG
void function OpenXboxPartyApp( var button )
{
	Durango_OpenPartyApp()
}

void function OpenXboxHelp( var button )
{
	Durango_ShowHelpWindow()
}
#endif // DURANGO_PROG

#if DEV
void function OpenDevMenu( var button )
{
	AdvanceMenu( GetMenu( "DevMenu" ) )
}
#endif // DEV

void function SetDialog( var menu, bool val )
{
	uiGlobal.menuData[ menu ].isDialog = val
}


void function SetClearBlur( var menu, bool val )
{
	uiGlobal.menuData[ menu ].clearBlur = val
}


bool function IsDialog( var menu )
{
	if ( menu == null )
		return false

	return uiGlobal.menuData[ menu ].isDialog
}


bool function ShouldClearBlur( var menu )
{
	if ( menu == null )
		return true

	return uiGlobal.menuData[ menu ].clearBlur
}


void function SetGamepadCursorEnabled( var menu, bool val )
{
	uiGlobal.menuData[ menu ].gamepadCursorEnabled = val
}


bool function IsGamepadCursorEnabled( var menu )
{
	if ( menu == null )
		return false

	return uiGlobal.menuData[ menu ].gamepadCursorEnabled
}


void function UpdateGamepadCursorEnabledThread()
{
	for ( ; ; )
	{
		WaitSignal( uiGlobal.signalDummy, "ActiveMenuChanged" )

		if ( IsGamepadCursorEnabled( GetActiveMenu() ) )
			ShowGameCursor()
		else
			HideGameCursor()
	}
}


bool function IsDialogOnlyActiveMenu()
{
	if ( !IsDialog( GetActiveMenu() ) )
		return false

	int stackLen = uiGlobal.menuStack.len()
	if ( stackLen < 1 )
		return false

	if ( uiGlobal.menuStack[stackLen - 1].menu != GetActiveMenu() )
		return false

	if ( stackLen == 1 )
		return true

	if ( uiGlobal.menuStack[stackLen - 2].menu == null )
		return true

	return false
}


void function SetNavUpDown( array<var> buttons )
{
	Assert( buttons.len() > 0 )

	var first = buttons[0]
	var last  = buttons[buttons.len() - 1]
	var prev
	var next
	var button

	for ( int i = 0; i < buttons.len(); i++ )
	{
		button = buttons[i]

		if ( button == first )
			prev = last
		else
			prev = buttons[i - 1]

		if ( button == last )
			next = first
		else
			next = buttons[i + 1]

		button.SetNavUp( prev )
		button.SetNavDown( next )

		//printt( "SetNavUP for:", Hud_GetHudName( button ), "to:", Hud_GetHudName( prev ) )
		//printt( "SetNavDown for:", Hud_GetHudName( button ), "to:", Hud_GetHudName( next ) )
	}
}


void function SetNavLeftRight( array<var> buttons )
{
	Assert( buttons.len() > 0 )

	var first = buttons[0]
	var last  = buttons[buttons.len() - 1]
	var prev
	var next
	var button

	for ( int i = 0; i < buttons.len(); i++ )
	{
		button = buttons[i]

		if ( button == first )
			prev = last
		else
			prev = buttons[i - 1]

		if ( button == last )
			next = first
		else
			next = buttons[i + 1]

		button.SetNavLeft( prev )
		button.SetNavRight( next )

		//printt( "SetNavUP for:", Hud_GetHudName( button ), "to:", Hud_GetHudName( prev ) )
		//printt( "SetNavDown for:", Hud_GetHudName( button ), "to:", Hud_GetHudName( next ) )
	}
}


void function AddCallback_OnPartyUpdated( void functionref() callbackFunc )
{
	Assert( !file.partyUpdatedCallbacks.contains( callbackFunc ), "Already added " + string( callbackFunc ) + " with AddCallback_OnPartyUpdated" )
	file.partyUpdatedCallbacks.append( callbackFunc )
}


void function RemoveCallback_OnPartyUpdated( void functionref() callbackFunc )
{
	Assert( file.partyUpdatedCallbacks.contains( callbackFunc ), "Callback " + string( callbackFunc ) + " doesn't exist" )
	file.partyUpdatedCallbacks.fastremovebyvalue( callbackFunc )
}


void function UICodeCallback_PartyUpdated()
{
	foreach ( callbackFunc in file.partyUpdatedCallbacks )
		callbackFunc()

	ShowNotification()

	if ( AmIPartyLeader() )
	{
		string activeSearchingPlaylist = GetActiveSearchingPlaylist()
		if ( activeSearchingPlaylist != "" && !CanPlaylistFitMyParty( activeSearchingPlaylist ) )
			CancelMatchSearch()
	}
}


void function UICodeCallback_PartyMemberAdded()
{
	//printt( "UICodeCallback_PartyMemberAdded" )
}


void function UICodeCallback_PartyMemberRemoved()
{
	//printt( "UICodeCallback_PartyMemberRemoved" )
}


void function UICodeCallback_UserInfoUpdated( string hardware, string uid )
{
	//printt( "UICodeCallback_UserInfoUpdated( " + hardware + ", " + uid + ")" )
	foreach ( callbackFunc in file.userInfoChangedCallbacks )
	{
		callbackFunc( hardware, uid )
	}
}

void function UICodeCallback_UIScriptResetComplete()
{
	Msg( "UICodeCallback_UIScriptResetComplete()\n" )
	ShGRX_UIScriptResetComplete()
}


void function AddCallbackAndCallNow_UserInfoUpdated( void functionref( string, string ) callbackFunc )
{
	Assert( !file.userInfoChangedCallbacks.contains( callbackFunc ) )
	file.userInfoChangedCallbacks.append( callbackFunc )

	callbackFunc( "", "" )
}


void function RemoveCallback_UserInfoUpdated( void functionref( string, string ) callbackFunc )
{
	Assert( file.userInfoChangedCallbacks.contains( callbackFunc ) )
	file.userInfoChangedCallbacks.fastremovebyvalue( callbackFunc )
}


// STOP USING THIS! If focus wont set, it's most likely because your menu elements have tabPosition set somewhere in them which tells code what the focus should be
void function HACK_DelayedSetFocus_BecauseWhy( var item )
{
	wait 0.1
	if ( IsValid( item ) )
		Hud_SetFocused( item )
}


void function UICodeCallback_KeyBindOverwritten( string key, string oldBinding, string newBinding )
{
	AddKeyBindEvent( key, newBinding, oldBinding )
	//SetKeyBindMessage( Localize( "#KEY_UNBOUND", Localize( oldbinding ) ) )
}


void function UICodeCallback_KeyBindSet( string key, string newBinding )
{
	foreach ( callbackFunc in uiGlobal.keyBindSetCallbacks )
	{
		callbackFunc( key, newBinding )
	}

	AddKeyBindEvent( key, newBinding )
}


void function AddUICallback_OnResolutionChanged( void functionref() callbackFunc )
{
	Assert( !uiGlobal.resolutionChangedCallbacks.contains( callbackFunc ) )
	uiGlobal.resolutionChangedCallbacks.append( callbackFunc )
}


void function AddCallback_OnTopLevelCustomizeContextChanged( var panel, void functionref( var ) callbackFunc )
{
	if ( !(panel in file.topLevelCustomizeContextChangedCallbacks) )
	{
		file.topLevelCustomizeContextChangedCallbacks[ panel ] <- [ callbackFunc ]
		return
	}
	else
	{
		Assert( !file.topLevelCustomizeContextChangedCallbacks[ panel ].contains( callbackFunc ), "Already added " + string( callbackFunc ) + " with AddCallback_OnCustomizeContextChanged for panel " + Hud_GetHudName( panel ) )
		file.topLevelCustomizeContextChangedCallbacks[ panel ].append( callbackFunc )
	}
}


void function RemoveCallback_OnTopLevelCustomizeContextChanged( var panel, void functionref( var ) callbackFunc )
{
	Assert( panel in file.topLevelCustomizeContextChangedCallbacks )
	Assert( file.topLevelCustomizeContextChangedCallbacks[ panel ].contains( callbackFunc ), "Callback " + string( callbackFunc ) + " for panel " + Hud_GetHudName( panel ) + " doesn't exist" )
	file.topLevelCustomizeContextChangedCallbacks[ panel ].fastremovebyvalue( callbackFunc )
}


bool function IsTopLevelCustomizeContextValid()
{
	return (uiGlobal.topLevelCustomizeContext != null)
}


ItemFlavor function GetTopLevelCustomizeContext()
{
	Assert( uiGlobal.topLevelCustomizeContext != null, "Tried using GetCustomizeContext() when it wasn't set to a valid value." )

	return expect ItemFlavor( uiGlobal.topLevelCustomizeContext )
}


void function SetTopLevelCustomizeContext( ItemFlavor ornull item )
{
	uiGlobal.topLevelCustomizeContext = item

	array<var> panels = []
	var activeMenu    = GetActiveMenu()
	if ( activeMenu != null )
		panels.append( activeMenu )
	panels.extend( uiGlobal.activePanels )

	foreach ( panel in panels )
	{
		if ( !(panel in file.topLevelCustomizeContextChangedCallbacks) )
			continue

		foreach ( callbackFunc in file.topLevelCustomizeContextChangedCallbacks[ panel ] )
			callbackFunc( panel )
	}
}


void function AddUICallback_LevelLoadingFinished( void functionref() callback )
{
	file.levelLoadingFinishedCallbacks.append( callback )
}


void function AddUICallback_LevelShutdown( void functionref() callback )
{
	file.levelShutdownCallbacks.append( callback )
}


void function ButtonClass_AddMenu( var menu )
{
	array<var> buttons = GetElementsByClassname( menu, "MenuButton" )
	foreach ( button in buttons )
	{
		InitButtonRCP( button )
	}
}


void function InitButtonRCP( var button )
{
	int width  = int( Hud_GetWidth( button ) / GetContentScaleFactor( GetMenu( "MainMenu" ) ).x )//ContentScaledXAsInt( Hud_GetWidth( button ) )
	int height = int( Hud_GetHeight( button ) / GetContentScaleFactor( GetMenu( "MainMenu" ) ).y )//ContentScaledYAsInt( Hud_GetHeight( button ) )
	RuiSetFloat2( Hud_GetRui( button ), "actualRes", <width, height, 0> )
}


void function ClientToUI_SetCommsMenuOpen( bool state )
{
	uiGlobal.commsMenuOpen = state
}


bool function IsCommsMenuOpen()
{
	return uiGlobal.commsMenuOpen
}


void function AddCallbackAndCallNow_RemoteMatchInfoUpdated( void functionref() callbackFunc )
{
	Assert( !file.remoteMatchInfoChangedCallbacks.contains( callbackFunc ) )
	file.remoteMatchInfoChangedCallbacks.append( callbackFunc )

	callbackFunc()
}


void function RemoveCallback_RemoteMatchInfoUpdated( void functionref() callbackFunc )
{
	Assert( file.remoteMatchInfoChangedCallbacks.contains( callbackFunc ) )
	file.remoteMatchInfoChangedCallbacks.fastremovebyvalue( callbackFunc )
}


void function UICodeCallback_RemoteMatchInfoUpdated()
{
	foreach ( callbackFunc in file.remoteMatchInfoChangedCallbacks )
	{
		callbackFunc()
	}
}