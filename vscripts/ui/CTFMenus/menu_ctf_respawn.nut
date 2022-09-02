global function InitCTFRespawnMenu
global function OpenCTFRespawnMenu
global function CloseCTFRespawnMenu
global function UpdateRespawnTimer
global function UpdateKillerName
global function UpdateObjectiveText
global function UpdateSelectedClass
global function DisableClassSelect
global function SetCTFScores
global function SetGameTimer
global function CTFUpdatePlayerLegend

struct
{
	var menu
	bool legendspanelopen = false
	bool defaultabilitys
	ItemFlavor& newcharacter
} file

struct Abilitys
{
    string name
    asset icon
}

void function SetGameTimer(string time)
{
	Hud_SetText(Hud_GetChild(file.menu, "GameTime"), time)
}

void function OpenCTFRespawnMenu(string classname1, string classname2, string classname3, string classname4, string classname5)
{
	CloseAllMenus()
	AdvanceMenu( file.menu )

	RuiSetString( Hud_GetRui( Hud_GetChild( file.menu, "Class1" )), "buttonText", classname1 )
	RuiSetString( Hud_GetRui( Hud_GetChild( file.menu, "Class2" )), "buttonText", classname2 )
	RuiSetString( Hud_GetRui( Hud_GetChild( file.menu, "Class3" )), "buttonText", classname3 )
	RuiSetString( Hud_GetRui( Hud_GetChild( file.menu, "Class4" )), "buttonText", classname4 )
	RuiSetString( Hud_GetRui( Hud_GetChild( file.menu, "Class5" )), "buttonText", classname5 )

	for(int i = 1; i < 6; i++ ) {
		Hud_SetEnabled( Hud_GetChild( file.menu, "Class" + i ), true )
	}

	entity player = GetLocalClientPlayer()

	ItemFlavor character = LoadoutSlot_WaitForItemFlavor( ToEHI( player ), Loadout_CharacterClass() )
	asset classIcon      = CharacterClass_GetGalleryPortrait( character )

	file.newcharacter = character

	RuiSetImage(Hud_GetRui(Hud_GetChild(file.menu, "PlayerImage")), "basicImage", classIcon)
	RuiSetString( Hud_GetRui( Hud_GetChild( file.menu, "ChangeLegend" )), "buttonText", "Change Legend" )

	array<ItemFlavor> characters = clone GetAllCharacters()

	characters.sort( int function( ItemFlavor a, ItemFlavor b ) {
			if ( Localize( ItemFlavor_GetLongName( a ) ) < Localize( ItemFlavor_GetLongName( b ) ) )
				return -1
			if ( Localize( ItemFlavor_GetLongName( a ) ) > Localize( ItemFlavor_GetLongName( b ) ) )
				return 1
			return 0
		} )

	for(int i = 0; i < 11; i++ ) {
		var buttonRui = Hud_GetRui( Hud_GetChild( file.menu, "CharButton" + i ))

		RuiSetImage( buttonRui, "portraitImage", CharacterClass_GetGalleryPortrait( characters[i] ) )
		RuiSetImage( buttonRui, "portraitBackground", CharacterClass_GetGalleryPortraitBackground( characters[i] ) )
		RuiSetString( buttonRui, "portraitName", Localize( ItemFlavor_GetLongName( characters[i] ) ) )
		RuiSetImage( buttonRui, "roleImage", CharacterClass_GetCharacterRoleImage( characters[i] ) )
	}

	AddLegendButtonsCallBacks(characters)
}

void function CloseCTFRespawnMenu()
{
	DeleteLegendButtonsCallBacks()
	ToggleLegendsUI(false)
	CloseAllMenus()
}

void function CTFUpdatePlayerLegend()
{
	try{RequestSetItemFlavorLoadoutSlot( LocalClientEHI(), Loadout_CharacterClass(), file.newcharacter )} catch(e0){}
}

void function ToggleLegendsUI(bool open)
{
	file.legendspanelopen = open
	for(int i = 0; i < 11; i++ ) {
		Hud_SetVisible(Hud_GetChild( file.menu, "CharButton" + i ), open)
	}
	Hud_SetVisible(Hud_GetChild( file.menu, "LegendsFrame" ), open)
	Hud_SetVisible(Hud_GetChild( file.menu, "LegendsFrameText" ), open)
	Hud_SetVisible(Hud_GetChild( file.menu, "LegendsText" ), open)
}

table<var, void functionref(var)> WORKAROUND_LegendButtonToClickHandlerMap = {}
void function AddLegendButtonsCallBacks(array<ItemFlavor> characters)
{
	int i = 0
	foreach( ItemFlavor character in characters )
	{
		var button = Hud_GetChild( file.menu, "CharButton" + i )

		void functionref(var) clickHandler = (void function( var button ) : ( character ) {
			ClientCommand( "Sur_UpdateCharacterLock 0" )
			file.newcharacter = character
			ToggleLegendsUI(false)
			RuiSetImage(Hud_GetRui(Hud_GetChild(file.menu, "PlayerImage")), "basicImage", CharacterClass_GetGalleryPortrait( character ))

			if (file.defaultabilitys)
			{
				//Could sometimes cause a very rare index out of range crash, i couldnt find out why so try catch will save the day
				try {
					ItemFlavor ultiamteAbility = CharacterClass_GetUltimateAbility( character )
        			ItemFlavor tacticalAbility = CharacterClass_GetTacticalAbility( character )
					RuiSetImage(Hud_GetRui(Hud_GetChild(file.menu, "Ability1Img")), "basicImage", GetWeaponInfoFileKeyFieldAsset_Global(CharacterAbility_GetWeaponClassname(tacticalAbility), "hud_icon"))
					RuiSetImage(Hud_GetRui(Hud_GetChild(file.menu, "Ability2Img")), "basicImage", GetWeaponInfoFileKeyFieldAsset_Global(CharacterAbility_GetWeaponClassname(ultiamteAbility), "hud_icon"))
					Hud_SetText(Hud_GetChild(file.menu, "Ability2Text"), GetWeaponInfoFileKeyField_GlobalString(CharacterAbility_GetWeaponClassname(tacticalAbility), "shortprintname"))
					Hud_SetText(Hud_GetChild(file.menu, "Ability1Text"), GetWeaponInfoFileKeyField_GlobalString(CharacterAbility_GetWeaponClassname(ultiamteAbility), "shortprintname"))
				} catch (exception){ }
			}
		})

		Hud_AddEventHandler( button, UIE_CLICK, clickHandler )
		WORKAROUND_LegendButtonToClickHandlerMap[button] <- clickHandler

		i++
	}
}

void function DeleteLegendButtonsCallBacks()
{
	for(int i = 0; i < 11; ++i)
    {
		var button = Hud_GetChild( file.menu, "CharButton" + i )
		if ( button in WORKAROUND_LegendButtonToClickHandlerMap )
		{
			Hud_RemoveEventHandler( button, UIE_CLICK, WORKAROUND_LegendButtonToClickHandlerMap[button] )
			delete WORKAROUND_LegendButtonToClickHandlerMap[button]
		}
	}
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

void function SetCTFScores(int imc, int mil, int maxscore)
{
	int widthpiece = 400 / maxscore
	int imcscorewidth = widthpiece * imc
	int milscorewidth = widthpiece * mil

	Hud_SetWidth( Hud_GetChild( file.menu, "IMCScoreBar" ), imcscorewidth )
	Hud_SetWidth( Hud_GetChild( file.menu, "MilScoreBar" ), milscorewidth )

	Hud_SetText(Hud_GetChild( file.menu, "IMCScoreInt" ), imc + " Captures")
	Hud_SetText(Hud_GetChild( file.menu, "MilScoreInt" ), mil + " Captures")
}

void function InitCTFRespawnMenu( var newMenuArg )
{
	var menu = GetMenu( "CTFRespawnMenu" )
	file.menu = menu

	AddMenuEventHandler( menu, eUIEvent.MENU_NAVIGATE_BACK, OnR5RSB_NavigateBack )

	AddButtonEventHandler( Hud_GetChild( menu, "Class1" ), UIE_CLICK, OnClickClass )
	AddButtonEventHandler( Hud_GetChild( menu, "Class2" ), UIE_CLICK, OnClickClass )
	AddButtonEventHandler( Hud_GetChild( menu, "Class3" ), UIE_CLICK, OnClickClass )
	AddButtonEventHandler( Hud_GetChild( menu, "Class4" ), UIE_CLICK, OnClickClass )
	AddButtonEventHandler( Hud_GetChild( menu, "Class5" ), UIE_CLICK, OnClickClass )
	AddButtonEventHandler( Hud_GetChild( menu, "ChangeLegend" ), UIE_CLICK, LegendPanel )
}

//Button event handlers
void function OnClickClass( var button )
{
	for(int i = 1; i < 6; i++ ) {
		RuiSetInt( Hud_GetRui( Hud_GetChild( file.menu, "Class" + i )), "status", eFriendStatus.OFFLINE )
	}

	RuiSetInt( Hud_GetRui( button ), "status", eFriendStatus.ONLINE_INGAME )

	int buttonId = Hud_GetScriptID( button ).tointeger()
	RunClientScript("UI_To_Client_UpdateSelectedClass", buttonId )
}

void function LegendPanel( var button )
{
	if (!file.legendspanelopen)
		ToggleLegendsUI(true)
	else
		ToggleLegendsUI(false)
}

void function UpdateSelectedClass(int classid, string primary, string secondary, string tactical, string ult, bool defaultabilitys)
{
	file.defaultabilitys = defaultabilitys

	for(int i = 1; i < 6; i++ ) {
		RuiSetInt( Hud_GetRui( Hud_GetChild( file.menu, "Class" + i )), "status", eFriendStatus.OFFLINE )
	}

	int finalclassid = classid + 1

	RuiSetInt( Hud_GetRui( Hud_GetChild( file.menu, "Class" + finalclassid )), "status", eFriendStatus.ONLINE_INGAME )

	Set_CTF_Class(primary, secondary, tactical, ult, defaultabilitys)
}

void function DisableClassSelect()
{
	for(int i = 1; i < 6; i++ ) {
		Hud_SetEnabled( Hud_GetChild( file.menu, "Class" + i ), false )
	}
}

void function Set_CTF_Class(string primary, string secondary, string tactical, string ult, bool defaultabilitys )
{
	LootData primaryData = SURVIVAL_Loot_GetLootDataByRef( primary )
	LootData secondaryData = SURVIVAL_Loot_GetLootDataByRef( secondary )

	RuiSetImage(Hud_GetRui(Hud_GetChild(file.menu, "Weapon1Img")), "basicImage", primaryData.hudIcon)
	RuiSetImage(Hud_GetRui(Hud_GetChild( file.menu, "Weapon2Img" )), "basicImage", secondaryData.hudIcon)

	if(defaultabilitys)
	{
		//Could sometimes cause a very rare index out of range crash, i couldnt find out why so try catch will save the day
		//again this is a very rare crash and try catching it wont cause any adverse side effects
		try {
		entity player = GetLocalClientPlayer()
		ItemFlavor character = LoadoutSlot_WaitForItemFlavor( ToEHI( player ), Loadout_CharacterClass() )
	    ItemFlavor ultiamteAbility = CharacterClass_GetUltimateAbility( character )
        ItemFlavor tacticalAbility = CharacterClass_GetTacticalAbility( character )
		RuiSetImage(Hud_GetRui(Hud_GetChild(file.menu, "Ability1Img")), "basicImage", GetWeaponInfoFileKeyFieldAsset_Global(CharacterAbility_GetWeaponClassname(tacticalAbility), "hud_icon"))
		RuiSetImage(Hud_GetRui(Hud_GetChild(file.menu, "Ability2Img")), "basicImage", GetWeaponInfoFileKeyFieldAsset_Global(CharacterAbility_GetWeaponClassname(ultiamteAbility), "hud_icon"))
		Hud_SetText(Hud_GetChild(file.menu, "Ability2Text"), GetWeaponInfoFileKeyField_GlobalString(CharacterAbility_GetWeaponClassname(tacticalAbility), "shortprintname"))
		Hud_SetText(Hud_GetChild(file.menu, "Ability1Text"), GetWeaponInfoFileKeyField_GlobalString(CharacterAbility_GetWeaponClassname(ultiamteAbility), "shortprintname"))
		} catch(e) {}
	}
	else
	{
		RuiSetImage(Hud_GetRui(Hud_GetChild(file.menu, "Ability1Img")), "basicImage", GetWeaponInfoFileKeyFieldAsset_Global(tactical, "hud_icon"))
		RuiSetImage(Hud_GetRui(Hud_GetChild(file.menu, "Ability2Img")), "basicImage", GetWeaponInfoFileKeyFieldAsset_Global(ult, "hud_icon"))
		Hud_SetText(Hud_GetChild(file.menu, "Ability2Text"), GetWeaponInfoFileKeyField_GlobalString(ult, "shortprintname"))
		Hud_SetText(Hud_GetChild(file.menu, "Ability1Text"), GetWeaponInfoFileKeyField_GlobalString(tactical, "shortprintname"))
	}

	Hud_SetText(Hud_GetChild(file.menu, "Weapon1Text"), GetWeaponInfoFileKeyField_GlobalString(primaryData.baseWeapon, "shortprintname"))
	Hud_SetText(Hud_GetChild(file.menu, "Weapon2Text"), GetWeaponInfoFileKeyField_GlobalString(secondaryData.baseWeapon, "shortprintname"))
}

void function OnR5RSB_NavigateBack()
{
	//
}