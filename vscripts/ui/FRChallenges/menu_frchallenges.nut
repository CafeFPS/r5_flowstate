global function InitFRChallengesResultsMenu
global function OpenFRChallengesMenu
global function CloseFRChallengesMenu
global function UpdateFRChallengeResultsTimer
global function UpdateResultsData

struct
{
	var menu
} file

void function OpenFRChallengesMenu()
{
	CloseAllMenus()
	EmitUISound("UI_Menu_MatchSummary_Appear")
	AdvanceMenu( file.menu )
}

void function CloseFRChallengesMenu()
{
	CloseAllMenus()
}

void function InitFRChallengesResultsMenu( var newMenuArg )
{
	var menu = GetMenu( "FRChallengesMenu" )
	file.menu = menu

    AddMenuEventHandler( menu, eUIEvent.MENU_SHOW, OnR5RSB_Show )
	AddMenuEventHandler( menu, eUIEvent.MENU_OPEN, OnR5RSB_Open )
	AddMenuEventHandler( menu, eUIEvent.MENU_CLOSE, OnR5RSB_Close )
	AddMenuEventHandler( menu, eUIEvent.MENU_NAVIGATE_BACK, OnR5RSB_NavigateBack )
	
	AddEventHandlerToButton( file.menu, "SkipButton", UIE_CLICK, SkipButtonFunct )
	AddEventHandlerToButton( file.menu, "RestartButton", UIE_CLICK, RestartButtonFunct )
}

void function UpdateResultsData(string challengeName, int shothits, int dummieskilled, float accuracy, int damagedone, int criticalshots, int shotshitrecord, bool isNewRecord)
{
	string AccuracyShort = LocalizeAndShortenNumber_Float(accuracy, 1, 2)
	if(AccuracyShort == "-na,n(i,nd).-n" || AccuracyShort == "-nan(ind)" || AccuracyShort == "-na.n(i.nd),-n") AccuracyShort = "0"
	printt(AccuracyShort)
	Hud_SetText(Hud_GetChild( file.menu, "Title"), challengeName)
	Hud_SetText(Hud_GetChild( file.menu, "DummiesKilledResult"), dummieskilled.tostring())
	Hud_SetText(Hud_GetChild( file.menu, "AccuracyResult"), AccuracyShort)
	Hud_SetText(Hud_GetChild( file.menu, "ShotsHitResult"), shothits.tostring())
	Hud_SetText(Hud_GetChild( file.menu, "DamageDoneResult"), damagedone.tostring())
	Hud_SetText(Hud_GetChild( file.menu, "CriticalShotsResult"), criticalshots.tostring())
	Hud_SetText(Hud_GetChild( file.menu, "PersonalBestData"), "THIS SESSION BEST:  " + shotshitrecord.tostring())
	
	if(isNewRecord) 
	{
		Hud_SetText(Hud_GetChild( file.menu, "WasNotNewPersonalBest"), "")
		Hud_SetText(Hud_GetChild( file.menu, "WasNewPersonalBest"), "NEW BEST SCORE")
		Hud_SetText(Hud_GetChild( file.menu, "ShotsHitResultFinalWasNotNew"), "")
		Hud_SetText(Hud_GetChild( file.menu, "ShotsHitResultFinal"), shothits.tostring())
		Hud_SetText(Hud_GetChild( file.menu, "ShotsHitResultFinal2WasNotNew"), "")
		Hud_SetText(Hud_GetChild( file.menu, "ShotsHitResultFinal2"), "Hits")
	}
	else
	{
		Hud_SetText(Hud_GetChild( file.menu, "WasNotNewPersonalBest"), "TRY AGAIN!")
		Hud_SetText(Hud_GetChild( file.menu, "WasNewPersonalBest"), "")
		Hud_SetText(Hud_GetChild( file.menu, "ShotsHitResultFinalWasNotNew"), shothits.tostring())
		Hud_SetText(Hud_GetChild( file.menu, "ShotsHitResultFinal"), "")
		Hud_SetText(Hud_GetChild( file.menu, "ShotsHitResultFinal2WasNotNew"), "Hits")
		Hud_SetText(Hud_GetChild( file.menu, "ShotsHitResultFinal2"), "")
	}
}
	
void function UpdateFRChallengeResultsTimer(int timeleft)
{
	var rui = Hud_GetChild( file.menu, "TimerText" )
	Hud_SetText(rui, timeleft.tostring() + "s")
}

void function SkipButtonFunct(var button)
{
	EmitUISound("UI_Menu_SelectMode_Close")
	RunClientScript("SkipButtonResultsClient")
}

void function RestartButtonFunct(var button)
{
	EmitUISound("UI_Menu_SelectMode_Close")
	RunClientScript("RestartButtonResultsClient")
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
	EmitUISound("UI_Menu_SelectMode_Close")
	RunClientScript("SkipButtonResultsClient")
}