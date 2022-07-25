global function InitSMGOptics 
global function OpenSMGOptics 
global function CloseSMGOptics 

struct
{
	var menu
} file

void function OpenSMGOptics()
{
	// printt("test")
	// CloseAllMenus()
	EmitUISound("UI_Menu_MatchSummary_Appear")
	AdvanceMenu( file.menu )
	vector screenPos = ConvertCursorToScreenPos()
	Hud_SetPos( file.menu, screenPos.x, screenPos.y )
}

void function CloseSMGOptics()
{
	CloseAllMenus()
}

void function InitSMGOptics( var newMenuArg )
{
	var menu = GetMenu( "FRChallengesOpticsSMG" )
	file.menu = menu
	//Hud_SetPos( file.menu, 10, 10 )

    // AddMenuEventHandler( menu, eUIEvent.MENU_SHOW, OnR5RSB_Show )
	// AddMenuEventHandler( menu, eUIEvent.MENU_OPEN, OnR5RSB_Open )
	// AddMenuEventHandler( menu, eUIEvent.MENU_CLOSE, OnR5RSB_Close )
	// AddMenuEventHandler( menu, eUIEvent.MENU_NAVIGATE_BACK, OnR5RSB_NavigateBack )
	
	//AddEventHandlerToButton( file.menu, "SkipButton", UIE_CLICK, SkipButtonFunct )
}
	
void function SkipButtonFunct(var button)
{
}

void function OnR5RSB_Show()
{
}

void function OnR5RSB_Open()
{
}

void function OnR5RSB_Close()
{
}

void function OnR5RSB_NavigateBack()
{
}