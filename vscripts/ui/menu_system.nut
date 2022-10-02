global function InitSystemMenu
global function InitSystemPanelMain
global function InitSystemPanel
global function UpdateSystemPanel

global function OpenSystemMenu

global function ShouldDisplayOptInOptions

struct ButtonData
{
	string             label
	void functionref() activateFunc
}

struct
{
	var                    menu

	table<var, array<var> >            buttons
	table<var, array<ButtonData> > buttonDatas

	table<var, ButtonData > settingsButtonData
	table<var, ButtonData > leaveMatchButtonData
	table<var, ButtonData > exitButtonData
	table<var, ButtonData > lobbyReturnButtonData
	table<var, ButtonData > nullButtonData
	table<var, ButtonData > leavePartyData
	table<var, ButtonData > abandonMissionButtonData
	table<var, ButtonData > changeCharacterButtonData
	table<var, ButtonData > friendlyFireButtonData
	table<var, ButtonData > thirdPersonButtonData
	table<var, ButtonData > ExitChallengeButtonData
	table<var, ButtonData > endmatchButtonData
	InputDef& qaFooter
} file

void function InitSystemMenu( var newMenuArg ) //
{
	var menu = GetMenu( "SystemMenu" )
	Hud_SetAboveBlur( menu, true )
	file.menu = menu

	AddMenuEventHandler( menu, eUIEvent.MENU_OPEN, OnSystemMenu_Open )
	AddMenuEventHandler( menu, eUIEvent.MENU_CLOSE, OnSystemMenu_Close )
	AddMenuEventHandler( menu, eUIEvent.MENU_NAVIGATE_BACK, OnSystemMenu_NavigateBack )
}

void function InitSystemPanelMain( var panel )
{
	InitSystemPanel( panel )

	AddPanelFooterOption( panel, LEFT, BUTTON_B, true, "#B_BUTTON_BACK", "#B_BUTTON_BACK" )
	AddPanelFooterOption( panel, LEFT, BUTTON_Y, true, "#Y_BUTTON_DEV_MENU", "#DEV_MENU", OpenDevMenu, ShouldShowDevMenu )

	if ( Dev_CommandLineHasParm( "-showoptinmenu" ) )
		file.qaFooter = AddPanelFooterOption( panel, LEFT, BUTTON_X, true, "#X_BUTTON_QA", "QA", ToggleOptIn, ShouldDisplayOptInOptions )

	#if CONSOLE_PROG
		AddPanelFooterOption( panel, RIGHT, BUTTON_BACK, false, "#BUTTON_RETURN_TO_MAIN", "", ReturnToMain_OnActivate )
	#endif
	AddPanelFooterOption( panel, RIGHT, BUTTON_STICK_RIGHT, true, "#BUTTON_VIEW_CINEMATIC", "#VIEW_CINEMATIC", ViewCinematic, IsLobby )
}

void function ViewCinematic( var button )
{
	CloseActiveMenu()
	thread PlayVideoMenu( false, "intro", "Apex_Opening_Movie", eVideoSkipRule.INSTANT )
}

void function TryChangeCharacters()
{
	RunClientScript( "UICallback_OpenCharacterSelectNewMenu" )
}

void function ToggleFriendlyFire()
{
	ClientCommand( "firingrange_toggle_friendlyfire" )
}

void function ToggleThirdPerson()
{
	ClientCommand( "ToggleThirdPerson" )
}

void function SignalExitChallenge()
{
	RunClientScript("ExitChallengeClient")
}

void function InitSystemPanel( var panel )
{
	var menu = Hud_GetParent( panel )
	file.buttons[ panel ] <- GetElementsByClassname( menu, "SystemButtonClass" )
	file.buttonDatas[ panel ] <- []
	file.buttonDatas[ panel ].resize( file.buttons[ panel ].len() )

	ButtonData data

	file.nullButtonData[ panel ] <- clone data

	foreach ( index, button in file.buttons[ panel ] )
	{
		SetButtonData( panel, index, file.nullButtonData[ panel ] )
		Hud_AddEventHandler( button, UIE_CLICK, OnButton_Activate )
	}

	file.settingsButtonData[ panel ] <- clone data
	file.leaveMatchButtonData[ panel ] <- clone data
	file.exitButtonData[ panel ] <- clone data
	file.lobbyReturnButtonData[ panel ] <- clone data
	file.leavePartyData[ panel ] <- clone data
	file.abandonMissionButtonData[ panel ] <- clone data
	file.changeCharacterButtonData[ panel ] <- clone data
	file.friendlyFireButtonData[ panel ] <- clone data
	file.thirdPersonButtonData[ panel ] <- clone data
	file.endmatchButtonData[ panel ] <- clone data
	file.ExitChallengeButtonData[ panel ] <- clone data
	
	file.ExitChallengeButtonData[ panel ].label = "FINISH CHALLENGE"
	file.ExitChallengeButtonData[ panel ].activateFunc = SignalExitChallenge

	file.settingsButtonData[ panel ].label = "#SETTINGS"
	file.settingsButtonData[ panel ].activateFunc = OpenSettingsMenu
	
	file.leaveMatchButtonData[ panel ].label = "#LEAVE_MATCH"
	file.leaveMatchButtonData[ panel ].activateFunc = LeaveDialog

	file.exitButtonData[ panel ].label = "#EXIT_TO_DESKTOP"
	file.exitButtonData[ panel ].activateFunc = OpenConfirmExitToDesktopDialog

	file.lobbyReturnButtonData[ panel ].label = "#RETURN_TO_LOBBY"
	file.lobbyReturnButtonData[ panel ].activateFunc = LeaveDialog

	file.leavePartyData[ panel ].label = "#LEAVE_PARTY"
	file.leavePartyData[ panel ].activateFunc = LeavePartyDialog

	file.abandonMissionButtonData[ panel ].label = "#ABANDON_MISSION"
	file.abandonMissionButtonData[ panel ].activateFunc = LeaveDialog

	file.changeCharacterButtonData[ panel ].label = "#BUTTON_CHARACTER_CHANGE"
	file.changeCharacterButtonData[ panel ].activateFunc = TryChangeCharacters

	file.friendlyFireButtonData[ panel ].label = "#BUTTON_FRIENDLY_FIRE_TOGGLE"
	file.friendlyFireButtonData[ panel ].activateFunc = ToggleFriendlyFire
	
	file.thirdPersonButtonData[ panel ].label = "TOGGLE THIRD PERSON"
	file.thirdPersonButtonData[ panel ].activateFunc = ToggleThirdPerson

	file.endmatchButtonData[ panel ].label = "END GAME LOBBY"
	file.endmatchButtonData[ panel ].activateFunc = HostEndMatch

	AddPanelEventHandler( panel, eUIEvent.PANEL_SHOW, SystemPanelShow )
}

void function SystemPanelShow( var panel )
{
	UpdateSystemPanel( panel )
}

void function OnSystemMenu_Open()
{
	SetBlurEnabled( true )
	ShowPanel( Hud_GetChild( file.menu, "SystemPanel" ) )

	UpdateOptInFooter()
}


void function UpdateSystemPanel( var panel )
{
	//temp workaround, not the best place for this tbh
	if(IsConnected() && !GetCurrentPlaylistVarBool( "firingrange_aimtrainerbycolombia", false ))
		file.lobbyReturnButtonData[ panel ].label = "#RETURN_TO_LOBBY"
	else if(IsConnected() && GetCurrentPlaylistVarBool( "firingrange_aimtrainerbycolombia", false ))
		file.lobbyReturnButtonData[ panel ].label = "EXIT AIM TRAINER"
	file.lobbyReturnButtonData[ panel ].activateFunc = LeaveDialog

	foreach ( index, button in file.buttons[ panel ] )
		SetButtonData( panel, index, file.nullButtonData[ panel ] )

	int buttonIndex = 0
	if ( IsConnected() && !IsLobby() )
	{
		UISize screenSize = GetScreenSize()
		SetCursorPosition( <1920.0 * 0.5, 1080.0 * 0.5, 0> )

		SetButtonData( panel, buttonIndex++, file.settingsButtonData[ panel ] )
		if(!GetCurrentPlaylistVarBool( "firingrange_aimtrainerbycolombia", false ))
		{
			if ( IsSurvivalTraining() || IsFiringRangeGameMode() )
				SetButtonData( panel, buttonIndex++, file.lobbyReturnButtonData[ panel ] )
			else
				SetButtonData( panel, buttonIndex++, file.leaveMatchButtonData[ panel ] )
		} else
		{
			if(ISAIMTRAINER)
				SetButtonData( panel, buttonIndex++, file.lobbyReturnButtonData[ panel ] )
			else
				SetButtonData( panel, buttonIndex++, file.ExitChallengeButtonData[ panel ] )
		}
		if ( IsFiringRangeGameMode() && !GetCurrentPlaylistVarBool( "firingrange_aimtrainerbycolombia", false ))
		{
			//SetButtonData( panel, buttonIndex++, file.changeCharacterButtonData[ panel ] ) // !FIXME
			//SetButtonData( panel, buttonIndex++, file.thirdPersonButtonData[ panel ] )

			//if ( (GetTeamSize( GetTeam() ) > 1) && FiringRangeHasFriendlyFire() )
			//	SetButtonData( panel, buttonIndex++, file.friendlyFireButtonData[ panel ] )
		}
	}
	else
	{
		if ( AmIPartyMember() || AmIPartyLeader() && GetPartySize() > 1 )
			SetButtonData( panel, buttonIndex++, file.leavePartyData[ panel ] )
		SetButtonData( panel, buttonIndex++, file.settingsButtonData[ panel ] )
		#if PC_PROG
			SetButtonData( panel, buttonIndex++, file.exitButtonData[ panel ] )
		#endif
	}

	const int maxNumButtons = 4;
	for( int i = 0; i < maxNumButtons; i++ )
	{
		if( i > 0 && i < buttonIndex)
			Hud_SetNavUp( file.buttons[ panel ][i], file.buttons[ panel ][i - 1] )
		else
			Hud_SetNavUp( file.buttons[ panel ][i], null )

		if( i < (buttonIndex - 1) )
			Hud_SetNavDown( file.buttons[ panel ][i], file.buttons[ panel ][i + 1] )
		else
			Hud_SetNavDown( file.buttons[ panel ][i], null )
	}

	var dataCenterElem = Hud_GetChild( panel, "DataCenter" )
	if(GetCurrentPlaylistVarBool( "firingrange_aimtrainerbycolombia", false ))
		Hud_SetText( dataCenterElem, "Flowstate Aim Trainer by @CafeFPS")
	else
		Hud_SetText( dataCenterElem, "R5Reloaded Server: " + MyPing() + " ms.")
}

void function SetButtonData( var panel, int buttonIndex, ButtonData buttonData )
{
	file.buttonDatas[ panel ][buttonIndex] = buttonData

	var rui = Hud_GetRui( file.buttons[ panel ][buttonIndex] )
	RHud_SetText( file.buttons[ panel ][buttonIndex], buttonData.label )

	if ( buttonData.label == "" )
		Hud_SetVisible( file.buttons[ panel ][buttonIndex], false )
	else
		Hud_SetVisible( file.buttons[ panel ][buttonIndex], true )
}


void function OnSystemMenu_Close()
{
	if(ISAIMTRAINER && IsConnected() && GetCurrentPlaylistVarBool( "firingrange_aimtrainerbycolombia", false )){
		CloseAllMenus()
		RunClientScript("ServerCallback_OpenFRChallengesMainMenu", PlayerKillsForChallengesUI)
	}
}


void function OnSystemMenu_NavigateBack()
{
	Assert( GetActiveMenu() == file.menu )
	CloseActiveMenu()
	if(ISAIMTRAINER && IsConnected() && GetCurrentPlaylistVarBool( "firingrange_aimtrainerbycolombia", false )){
		CloseAllMenus()
		RunClientScript("ServerCallback_OpenFRChallengesMainMenu", PlayerKillsForChallengesUI)
	}
}


void function OnButton_Activate( var button )
{
	if ( GetActiveMenu() == file.menu )
		CloseActiveMenu()

	var panel = Hud_GetParent( button )

	int buttonIndex = int( Hud_GetScriptID( button ) )

	file.buttonDatas[ panel ][buttonIndex].activateFunc()
}

void function OpenSystemMenu()
{
	AdvanceMenu( file.menu )
}

void function OpenSettingsMenu()
{
	AdvanceMenu( GetMenu( "MiscMenu" ) )
}

void function HostEndMatch()
{
	CreateServer( GetPlayerName() + " Lobby", "", "mp_lobby", "menufall", eServerVisibility.OFFLINE)
}

#if CONSOLE_PROG
void function ReturnToMain_OnActivate( var button )
{
	ConfirmDialogData data
	data.headerText = "#EXIT_TO_MAIN"
	data.messageText = ""
	data.resultCallback = OnReturnToMainMenu
	//data.yesText = ["YES_RETURN_TO_TITLE_MENU", "#YES_RETURN_TO_TITLE_MENU"]

	OpenConfirmDialogFromData( data )
	AdvanceMenu( GetMenu( "ConfirmDialog" ) )
}

void function OnReturnToMainMenu( int result )
{
	if ( result == eDialogResult.YES )
		ClientCommand( "disconnect" )
}
#endif


void function ToggleOptIn( var button )
{
	uiGlobal.isOptInEnabled = !uiGlobal.isOptInEnabled

	if ( GetActiveMenu() == file.menu )
		CloseActiveMenu()
}


bool function ShouldDisplayOptInOptions()
{
	if ( !IsFullyConnected() )
		return false

	// if ( GRX_IsInventoryReady() && (GRX_HasItem( GRX_DEV_ITEM ) || GRX_HasItem( GRX_QA_ITEM )) )
		return true

	return GetGlobalNetBool( "isOptInServer" )
}


void function UpdateOptInFooter()
{
	if ( uiGlobal.isOptInEnabled )
	{
		file.qaFooter.gamepadLabel = "#X_BUTTON_HIDE_OPT_IN"
		file.qaFooter.mouseLabel = "#HIDE_OPT_IN"
	}
	else
	{
		file.qaFooter.gamepadLabel = "#X_BUTTON_SHOW_OPT_IN"
		file.qaFooter.mouseLabel = "#SHOW_OPT_IN"
	}

	UpdateFooterOptions()
}

bool function ShouldShowDevMenu()
{
	if(IsLobby())
		return false
	
	return true
}


