global function InitEliteIntroMenu
global function OpenEliteIntroMenu
global function OpenEliteIntroMenuNonAnimated

#if R5DEV
global function TestEliteIntroMenu
#endif

struct
{
	var   menu
	int   menuState
	float nextClickAllowTime = -1
} file

enum eEliteMenuState
{
	START,
	TITLE1,
	BODY1,
	TITLE2,
	BODY2,
	BODY3,
	SHOW_BUTTONS,
	CLOSE,
	TITLE3,
}

void function InitEliteIntroMenu( var newMenuArg ) //
{
	var menu = GetMenu( "EliteIntroMenu" )
	file.menu = menu

	RegisterSignal( "SkipWait" )
	RegisterSignal( "BeginEliteIntro" )

	AddMenuEventHandler( menu, eUIEvent.MENU_OPEN, OnEliteIntroMenu_Open )
	AddMenuEventHandler( menu, eUIEvent.MENU_CLOSE, OnEliteIntroMenu_Close )

	AddMenuEventHandler( menu, eUIEvent.MENU_SHOW, OnEliteIntroMenu_Show )
	AddMenuEventHandler( menu, eUIEvent.MENU_HIDE, OnEliteIntroMenu_Hide )

	AddMenuEventHandler( menu, eUIEvent.MENU_NAVIGATE_BACK, OnNavBack )

	{
		var button = Hud_GetChild( menu, "ClickOverlay" )
		AddButtonEventHandler( button, UIE_CLICK, OnOverlayClick )
	}

	{
		var button = Hud_GetChild( menu, "EquipButton" )
		HudElem_SetRuiArg( button, "isPrimary", true )
		AddButtonEventHandler( button, UIE_CLICK, OnEquipClick )
	}

	{
		var button = Hud_GetChild( menu, "CloseButton" )
		HudElem_SetRuiArg( button, "isPrimary", false )
		AddButtonEventHandler( button, UIE_CLICK, OnCloseClick )
	}
}

void function OpenEliteIntroMenuNonAnimated( var button )
{
	if ( !GetCurrentPlaylistVarBool( "elite_enabled", false ) )
		return

	OpenEliteIntroMenu( true )

	{
		var rui = Hud_GetRui( Hud_GetChild( file.menu, "Text1" ) )
		RuiSetGameTime( rui, "startTimeTitle", 0 )
		RuiSetGameTime( rui, "startTimeBody", 0 )
	}
	{
		var rui = Hud_GetRui( Hud_GetChild( file.menu, "Text2" ) )
		RuiSetGameTime( rui, "startTimeTitle", 0 )
		RuiSetGameTime( rui, "startTimeBody", 0 )
	}
	{
		var rui = Hud_GetRui( Hud_GetChild( file.menu, "Text3" ) )
		RuiSetGameTime( rui, "startTimeTitle", 0 )
		RuiSetGameTime( rui, "startTimeBody", 0 )
	}

	{
		var rui = Hud_GetRui( Hud_GetChild( file.menu, "EliteBadge" ) )
		//
		//
	}

	Hud_Show( Hud_GetChild( file.menu, "EquipButton" ) )
	Hud_Show( Hud_GetChild( file.menu, "CloseButton" ) )

	Hud_SetEnabled( Hud_GetChild( file.menu, "ClickOverlay" ), false )
}

void function OpenEliteIntroMenu( bool skipAnimation = false )
{
	if ( !GetCurrentPlaylistVarBool( "elite_enabled", false ) )
		return

	if ( skipAnimation )
	{
		file.menuState = eEliteMenuState.SHOW_BUTTONS
	}
	else
	{
		file.menuState = eEliteMenuState.START
	}

	AdvanceMenu( file.menu )
}

void function OnEliteIntroMenu_Open()
{
	if ( IsFullyConnected() )
		UI_SetPresentationType( ePresentationType.PLAY )

	if ( file.menuState == eEliteMenuState.START )
	{
		{
			var rui = Hud_GetRui( Hud_GetChild( file.menu, "Text1" ) )
			RuiSetGameTime( rui, "startTimeTitle", RUI_BADGAMETIME )
			RuiSetGameTime( rui, "startTimeBody", RUI_BADGAMETIME )
		}
		{
			var rui = Hud_GetRui( Hud_GetChild( file.menu, "Text2" ) )
			RuiSetGameTime( rui, "startTimeTitle", RUI_BADGAMETIME )
			RuiSetGameTime( rui, "startTimeBody", RUI_BADGAMETIME )
		}
		{
			var rui = Hud_GetRui( Hud_GetChild( file.menu, "Text3" ) )
			RuiSetGameTime( rui, "startTimeTitle", RUI_BADGAMETIME )
			RuiSetGameTime( rui, "startTimeBody", RUI_BADGAMETIME )
		}

		{
			var rui = Hud_GetRui( Hud_GetChild( file.menu, "EliteBadge" ) )
			RuiSetGameTime( rui, "startTime", Time() )
			//
		}

		Hud_Hide( Hud_GetChild( file.menu, "EquipButton" ) )
		Hud_Hide( Hud_GetChild( file.menu, "CloseButton" ) )
	}

}


void function OnEliteIntroMenu_Close()
{
	ClientCommand( "MarkEliteIntroAsSeen" )
}


void function OnEliteIntroMenu_Show()
{
	var rui = Hud_GetRui( Hud_GetChild( file.menu, "EliteBadge" ) )

	UISize size = GetScreenSize()

	RuiSetFloat2( rui, "actualRes", < size.width, size.height, 0 > )

	if ( IsFullyConnected() )
	{
		var equipButton = Hud_GetChild( file.menu, "EquipButton" )
		int maxStreak = GetStat_Int( GetUIPlayer(), ResolveStatEntry( CAREER_STATS.season_elite_max_streak, "SAID01769158912" ) )
		RuiSetInt( Hud_GetRui( equipButton ), "maxStreak", maxStreak )
	}

	thread EliteIntroThread()
}


void function OnEliteIntroMenu_Hide()
{

}


void function OnNavBack()
{
	OnOverlayClick( null )
	return
}


void function OnOverlayClick( var button )
{
	if ( Time() < file.nextClickAllowTime )
		return

	SkipToNextState()
}


void function OnEquipClick( var button )
{
	if ( Hud_IsLocked( button ) )
	{
		return
	}

	asset badgeAsset  = $"settings/itemflav/gcard_badge/account/elite_max_streak.rpak"
	ItemFlavor flavor = GetItemFlavorByAsset( badgeAsset )
	int itemType      = ItemFlavor_GetType( flavor )

	foreach ( character in GetAllCharacters() )
	{
		bool isUnlocked = IsItemFlavorUnlockedForLoadoutSlot( LocalClientEHI(), Loadout_CharacterClass(), character, false )

		if ( isUnlocked )
		{
			bool foundBadge = false
			bool foundEmptySlot = false
			int equipIndex = 0

			for ( int i=0; i<GLADIATOR_CARDS_NUM_BADGES; i++ )
			{
				LoadoutEntry entry = Loadout_GladiatorCardBadge( character, i )
				ItemFlavor ornull badgeOrNull = LoadoutSlot_GetItemFlavor( LocalClientEHI(), entry )

				if ( badgeOrNull != null )
				{
					expect ItemFlavor( badgeOrNull )

					if ( badgeOrNull == flavor )
					{
						foundBadge = true
					}
					else if ( GladiatorCardBadge_IsTheEmpty( badgeOrNull ) &&  !foundEmptySlot )
					{
						equipIndex = i
						foundEmptySlot = true
					}
				}
				else if ( !foundEmptySlot )
				{
					equipIndex = i
					foundEmptySlot = true
				}
			}

			if ( !foundBadge )
			{
				LoadoutEntry entry = Loadout_GladiatorCardBadge( character, equipIndex )
				RequestSetItemFlavorLoadoutSlot( LocalClientEHI(), entry, flavor )
			}
		}
	}

	EmitUISound( "UI_Menu_Top5_Equip_Badge" )

	Hud_SetLocked( button, true )
	var rui = Hud_GetRui( button )
	RuiSetString( rui, "buttonText", "#EQUIPPED_LOOT_REWARD" )
}


void function OnCloseClick( var button )
{
	if ( PartyHasEliteAccess() )
	{
		ForceElitePlaylist()
		PulseModeButton()
	}

	CloseActiveMenu()
}


void function EliteIntroThread()
{
	Signal( uiGlobal.signalDummy, "BeginEliteIntro" )
	EndSignal( uiGlobal.signalDummy, "BeginEliteIntro" )

	WaitFrame()

	if ( GetActiveMenu() == file.menu )
	{
		Hud_SetEnabled( Hud_GetChild( file.menu, "ClickOverlay" ), true )

		if ( file.menuState == eEliteMenuState.START )
		{
			var rui = Hud_GetRui( Hud_GetChild( file.menu, "EliteBadge" ) )
			RuiSetGameTime( rui, "startTime", Time() )
			EmitUISound( "UI_Menu_MatchSummary_Top5_Splash" )
			file.nextClickAllowTime = Time() + 2.5
		}
	}

	while ( GetActiveMenu() == file.menu )
	{
		if ( file.menuState + 1 >= eEliteMenuState.CLOSE )
			break

		float delay = 1.5
		if ( file.menuState == eEliteMenuState.START )
			delay = 2.5

		waitthread DelayedMoveToNextState( delay )
	}
}


void function DelayedMoveToNextState( float delay )
{
	EndSignal( uiGlobal.signalDummy, "SkipWait" )

	wait delay

	if ( GetActiveMenu() == file.menu )
		thread SkipToNextState()
}


void function SkipToNextState()
{
	Signal( uiGlobal.signalDummy, "SkipWait" )
	file.menuState += 1
	file.nextClickAllowTime = Time() + 0.5

	switch ( file.menuState )
	{
		case eEliteMenuState.TITLE1:
			var rui = Hud_GetRui( Hud_GetChild( file.menu, "Text1" ) )
			RuiSetGameTime( rui, "startTimeTitle", Time() )
			EmitUISound( "UI_Menu_MatchSummary_Top5_Text" )
			break

		case eEliteMenuState.BODY1:
			var rui = Hud_GetRui( Hud_GetChild( file.menu, "Text1" ) )
			RuiSetGameTime( rui, "startTimeBody", Time() )
			EmitUISound( "UI_Menu_MatchSummary_Top5_Text" )
			break

		case eEliteMenuState.TITLE2:
			var rui = Hud_GetRui( Hud_GetChild( file.menu, "Text2" ) )
			RuiSetGameTime( rui, "startTimeTitle", Time() )
			EmitUISound( "UI_Menu_MatchSummary_Top5_Text" )
			break

		case eEliteMenuState.BODY2:
			var rui = Hud_GetRui( Hud_GetChild( file.menu, "Text2" ) )
			RuiSetGameTime( rui, "startTimeBody", Time() )
			EmitUISound( "UI_Menu_MatchSummary_Top5_Text" )
			break

		case eEliteMenuState.TITLE3:
			var rui = Hud_GetRui( Hud_GetChild( file.menu, "Text3" ) )
			RuiSetGameTime( rui, "startTimeTitle", Time() )
			EmitUISound( "UI_Menu_MatchSummary_Top5_Text" )
			break

		case eEliteMenuState.BODY3:
			var rui = Hud_GetRui( Hud_GetChild( file.menu, "Text3" ) )
			RuiSetGameTime( rui, "startTimeBody", Time() )
			EmitUISound( "UI_Menu_MatchSummary_Top5_Text" )
			break

		case eEliteMenuState.SHOW_BUTTONS:
			Hud_Show( Hud_GetChild( file.menu, "EquipButton" ) )
			Hud_Show( Hud_GetChild( file.menu, "CloseButton" ) )
			Hud_SetEnabled( Hud_GetChild( file.menu, "ClickOverlay" ), false )
			//
			break

		case eEliteMenuState.CLOSE:
			OnCloseClick( null )
			break
	}
}

void function TestEliteIntroMenu()
{
	{
		var rui = Hud_GetRui( Hud_GetChild( file.menu, "Text1" ) )
		RuiSetGameTime( rui, "startTimeTitle", RUI_BADGAMETIME )
		RuiSetGameTime( rui, "startTimeBody", RUI_BADGAMETIME )
	}
	{
		var rui = Hud_GetRui( Hud_GetChild( file.menu, "Text2" ) )
		RuiSetGameTime( rui, "startTimeTitle", RUI_BADGAMETIME )
		RuiSetGameTime( rui, "startTimeBody", RUI_BADGAMETIME )
	}
	{
		var rui = Hud_GetRui( Hud_GetChild( file.menu, "Text3" ) )
		RuiSetGameTime( rui, "startTimeTitle", RUI_BADGAMETIME )
		RuiSetGameTime( rui, "startTimeBody", RUI_BADGAMETIME )
	}

	{
		var rui = Hud_GetRui( Hud_GetChild( file.menu, "EliteBadge" ) )
		RuiSetGameTime( rui, "startTime", Time() )
		//
	}

	Hud_Hide( Hud_GetChild( file.menu, "EquipButton" ) )
	Hud_Hide( Hud_GetChild( file.menu, "CloseButton" ) )

	file.menuState = eEliteMenuState.START
	thread EliteIntroThread()
}
