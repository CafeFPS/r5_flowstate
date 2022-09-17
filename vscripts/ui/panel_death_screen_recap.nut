global function InitDeathScreenRecapPanel
global function UI_UpdateRespawnStatus

struct
{
	var panel
	array<var> blockArray
} file

void function InitDeathScreenRecapPanel( var panel )
{
	file.panel = panel

	AddPanelEventHandler( panel, eUIEvent.PANEL_SHOW, OnOpenPanel )
	AddPanelEventHandler( panel, eUIEvent.PANEL_HIDE, OnClosePanel )

	file.blockArray.append( Hud_GetChild( panel, "MainDamageBlock" ) )
	file.blockArray.append( Hud_GetChild( panel, "Block1" ) )
	file.blockArray.append( Hud_GetChild( panel, "Block2" ) )
	file.blockArray.append( Hud_GetChild( panel, "Block3" ) )
	file.blockArray.append( Hud_GetChild( panel, "Block4" ) )
	file.blockArray.append( Hud_GetChild( panel, "Block5" ) )
	file.blockArray.append( Hud_GetChild( panel, "Block6" ) )
	file.blockArray.append( Hud_GetChild( panel, "Block7" ) )
	file.blockArray.append( Hud_GetChild( panel, "Block8" ) )
	file.blockArray.append( Hud_GetChild( panel, "Block9" ) )

	foreach( button in file.blockArray )
	{
		AddButtonEventHandler( button, UIE_CLICK, DamageBlockButtonClick )
		//
	}

	InitDeathScreenPanelFooter( panel, eDeathScreenPanel.DEATH_RECAP)
}

void function OnOpenPanel( var panel )
{
	//

	var menu = GetParentMenu( panel )
	var headerElement = Hud_GetChild( menu, "Header" )
	var recapElement = Hud_GetChild( panel, "DeathRecap" )

	RegisterButtonPressedCallback( MOUSE_WHEEL_DOWN, DeathScreenNextDamageLog )
	RegisterButtonPressedCallback( BUTTON_DPAD_DOWN, DeathScreenNextDamageLog )
	RegisterButtonPressedCallback( MOUSE_WHEEL_UP, DeathScreenPrevDamageLog )
	RegisterButtonPressedCallback( BUTTON_DPAD_UP, DeathScreenPrevDamageLog )
	//RegisterButtonPressedCallback( KEY_R, DeathScreenOnReportButtonClick )

	DeathScreenUpdateCursor()

	array<var> b = file.blockArray
	RunClientScript( "UICallback_ShowDeathRecap", headerElement, recapElement, b[0], b[1], b[2], b[3], b[4], b[5], b[6], b[7], b[8], b[9] )
}


void function OnClosePanel( var panel )
{
	//

	DeregisterButtonPressedCallback( MOUSE_WHEEL_DOWN, DeathScreenNextDamageLog )
	DeregisterButtonPressedCallback( BUTTON_DPAD_DOWN, DeathScreenNextDamageLog )
	DeregisterButtonPressedCallback( MOUSE_WHEEL_UP, DeathScreenPrevDamageLog )
	DeregisterButtonPressedCallback( BUTTON_DPAD_UP, DeathScreenPrevDamageLog )
	//DeregisterButtonPressedCallback( KEY_R, DeathScreenOnReportButtonClick )

	RunClientScript( "UICallback_CloseDeathRecap" )
}


void function UI_UpdateRespawnStatus( int respawnStatus )
{
	var menu = GetParentMenu( file.panel )
	var headerElement = Hud_GetChild( menu, "Header" )
	HudElem_SetRuiArg( headerElement, "respawnStatus", respawnStatus, eRuiArgType.INT )
}

void function DamageBlockButtonClick( var button )
{
	string scriptID = Hud_GetScriptID( button )
	//

	//
	RunClientScript( "UICallback_SelectRecapBlock", int( scriptID ) )
}

void function DeathScreenNextDamageLog( var button )
{
	//

	RunClientScript( "UICallback_NextRecapBlock" )
}

void function DeathScreenPrevDamageLog( var button  )
{
	//

	RunClientScript( "UICallback_PrevRecapBlock" )
}

bool isEnabled
void function OnDevButtonClick( var button )
{
	//
	var menu = Hud_GetParent( file.panel )
	TabData tabData = GetTabDataForPanel( menu )
	TabDef squadSummaryTab = Tab_GetTabDefByBodyName( tabData, "DeathScreenSquadSummary" )
	SetTabDefEnabled( squadSummaryTab, isEnabled )
	isEnabled = !isEnabled
}
