global function InitCTFRespawnMenu
global function OpenCTFRespawnMenu
global function CloseCTFRespawnMenu
global function UpdateRespawnTimer
global function UpdateKillerName
global function UpdateKillerDamage
global function UpdateDamageGiven
global function SetEnemyScore
global function SetTeamScore
global function UpdateObjectiveText

struct
{
	var menu
} file

void function OpenCTFRespawnMenu()
{
	CloseAllMenus()
	AdvanceMenu( file.menu )
}

void function CloseCTFRespawnMenu()
{
	CloseAllMenus()
}

void function UpdateObjectiveText(int score)
{
	var rui = Hud_GetChild( file.menu, "ObjectiveText" )
	Hud_SetText(rui, "Capture " + score.tostring() + " Flags To Win!")
}

void function UpdateRespawnTimer(int timeleft)
{
	var rui = Hud_GetChild( file.menu, "TimerText" )
	Hud_SetText(rui, timeleft.tostring())
}

void function UpdateKillerName(string name)
{
	var rui = Hud_GetChild( file.menu, "KilledByText" )
	Hud_SetText(rui, name)
}

void function UpdateKillerDamage(float damage)
{
	var rui = Hud_GetChild( file.menu, "KilledByDamageText" )
	Hud_SetText(rui, damage.tostring())
}

void function UpdateDamageGiven(float damage)
{
	var rui = Hud_GetChild( file.menu, "GivenDamageText" )
	Hud_SetText(rui, damage.tostring())
}

void function SetEnemyScore(int score)
{
	var rui = Hud_GetChild( file.menu, "EnemyScoreText" )
	Hud_SetText(rui, score.tostring() + " Captures")
}

void function SetTeamScore(int score)
{
	var rui = Hud_GetChild( file.menu, "TeamScoreText" )
	Hud_SetText(rui, score.tostring() + " Captures")
}

void function InitCTFRespawnMenu( var newMenuArg )
{
	var menu = GetMenu( "CTFRespawnMenu" )
	file.menu = menu

    AddMenuEventHandler( menu, eUIEvent.MENU_SHOW, OnR5RSB_Show )
	AddMenuEventHandler( menu, eUIEvent.MENU_OPEN, OnR5RSB_Open )
	AddMenuEventHandler( menu, eUIEvent.MENU_CLOSE, OnR5RSB_Close )
	AddMenuEventHandler( menu, eUIEvent.MENU_NAVIGATE_BACK, OnR5RSB_NavigateBack )

    var SelectLegend = Hud_GetChild( menu, "SelectLegend" )
	RuiSetImage( Hud_GetRui( SelectLegend ), "iconImage", $"rui/menu/common/last_squad" )
	RuiSetInt( Hud_GetRui( SelectLegend ), "lootTier", 4 )
	AddEventHandlerToButton( menu, "SelectLegend", UIE_CLICK, ChangeLegend )
}

void function ChangeLegend(var button)
{
    RunClientScript("OpenCharacterSelectNewMenu", true)
}

void function OnR5RSB_Show()
{
    //
}

void function OnR5RSB_Open()
{
	//
}


void function OnR5RSB_Close()
{
	//
}

void function OnR5RSB_NavigateBack()
{
    //
}