global function InitArenasBuyPanel1
global function returnWeaponButtons1
global function CleanAllButtons
global function DisableAllButtons
global function EnableAllButtons

struct
{
	var menu
    var header
    var text
	bool tabsInitialized = false

	array<var> weaponButtons
	
	//attachments box	
	vector screenPos
	float xstep
	float ystep
	float ancho
	var frame1
	var frame2
	var frame3
	var frame4
	var invisibleExitButton
	var closebutton
	var savebutton
	var opticsbutton
	var opticstext
	var barrelsbutton
	var barrelstext
	var stocksbutton
	var stockstext
	var boltstext
	var boltsbutton
	array<var> visibleAttachmentsBoxElements
	
	string desiredweapon
	string weapontype
	var desiredWeaponButtonToMark
	int desiredOptic = 0
	int desiredBarrel = 0
	int desiredStock = 0
	int desiredShotgunbolt = 0

	array<var> SMGOptics
	array<var> SMGBarrels
	array<var> SMGStocks
	array<var> ShotgunBolts
} file

void function InitArenasBuyPanel1( var panel )
{
	var menu = panel
	file.menu = menu

	//attachments box setup
	//background
	file.frame1 = Hud_GetChild( file.menu, "ScreenBlur" )
	file.frame2 = Hud_GetChild( file.menu, "SMGLootFrame" )
	file.frame3 = Hud_GetChild( file.menu, "SMGLootFrame2" )
	file.frame4 = Hud_GetChild( file.menu, "SMGLootFrame3" )	
	//footer
	file.invisibleExitButton = Hud_GetChild( file.menu, "InvisibleExitButton" )
	AddEventHandlerToButton( menu, "InvisibleExitButton", UIE_CLICK, CloseButtonAttachmentsBox )
	AddEventHandlerToButton( menu, "InvisibleExitButton", UIE_CLICKRIGHT, CloseButtonAttachmentsBox )
	file.closebutton = Hud_GetChild( file.menu, "CloseButton" )
	AddEventHandlerToButton( menu, "CloseButton", UIE_CLICK, CloseButtonAttachmentsBox )
	file.savebutton = Hud_GetChild( file.menu, "SaveButton" )
	AddEventHandlerToButton( menu, "SaveButton", UIE_CLICK, BuyWeaponWithAttachments )
	//header
	file.opticsbutton = Hud_GetChild( file.menu, "OpticsButton" )
	file.opticstext = Hud_GetChild( file.menu, "OpticsText" )
	file.barrelsbutton = Hud_GetChild( file.menu, "BarrelsButton" )
	file.boltsbutton = Hud_GetChild( file.menu, "BoltsButton" )
	file.barrelstext = Hud_GetChild( file.menu, "BarrelsText" )
	file.stocksbutton = Hud_GetChild( file.menu, "StocksButton" )
	file.stockstext = Hud_GetChild( file.menu, "StocksText" )
	file.boltstext = Hud_GetChild( file.menu, "BoltsText" )
	//buttons for header
	AddEventHandlerToButton( file.menu, "OpticsButton", UIE_CLICK, SMGOptics )
	AddEventHandlerToButton( file.menu, "BarrelsButton", UIE_CLICK, SMGBarrels )
	AddEventHandlerToButton( file.menu, "StocksButton", UIE_CLICK, SMGStocks )
	AddEventHandlerToButton( file.menu, "BoltsButton", UIE_CLICK, ShotgunBolts )
	//SMG Optics Loadout
	file.SMGOptics.append( Hud_GetChild( file.menu, "SMGOptics1" ) )
	file.SMGOptics.append( Hud_GetChild( file.menu, "SMGOptics2" ) )
	file.SMGOptics.append( Hud_GetChild( file.menu, "SMGOptics3" ) )
	file.SMGOptics.append( Hud_GetChild( file.menu, "SMGOptics4" ) )
	file.SMGOptics.append( Hud_GetChild( file.menu, "SMGOptics5" ) )
	//SMG Barrels
	file.SMGBarrels.append( Hud_GetChild( file.menu, "SMGBarrels1" ) )
	file.SMGBarrels.append( Hud_GetChild( file.menu, "SMGBarrels2" ) )
	file.SMGBarrels.append( Hud_GetChild( file.menu, "SMGBarrels3" ) )
	file.SMGBarrels.append( Hud_GetChild( file.menu, "SMGBarrels4" ) )
	//SMG Stocks
	file.SMGStocks.append( Hud_GetChild( file.menu, "SMGStocks1" ) )
	file.SMGStocks.append( Hud_GetChild( file.menu, "SMGStocks2" ) )
	file.SMGStocks.append( Hud_GetChild( file.menu, "SMGStocks3" ) )
	//Shotgun Bolts
	file.ShotgunBolts.append( Hud_GetChild( file.menu, "ShotgunBolt1" ) )
	file.ShotgunBolts.append( Hud_GetChild( file.menu, "ShotgunBolt2" ) )
	file.ShotgunBolts.append( Hud_GetChild( file.menu, "ShotgunBolt3" ) )
		
	//Optics default
	Hud_SetSelected( file.SMGOptics[0], true )
	Hud_SetSelected( file.SMGBarrels[0], true )
	Hud_SetSelected( file.SMGStocks[0], true )
	Hud_SetSelected( file.ShotgunBolts[0], true )
	
	//Optics buttons
	AddEventHandlerToButton( file.menu, "SMGOptics1", UIE_CLICK, SetSMGOpticsAttachmentSelected )	
	AddEventHandlerToButton( file.menu, "SMGOptics2", UIE_CLICK, SetSMGOpticsAttachmentSelected )	
	AddEventHandlerToButton( file.menu, "SMGOptics3", UIE_CLICK, SetSMGOpticsAttachmentSelected )	
	AddEventHandlerToButton( file.menu, "SMGOptics4", UIE_CLICK, SetSMGOpticsAttachmentSelected )	
	AddEventHandlerToButton( file.menu, "SMGOptics5", UIE_CLICK, SetSMGOpticsAttachmentSelected )
	
	AddEventHandlerToButton( file.menu, "SMGBarrels1", UIE_CLICK, SetSMGBarrelsAttachmentSelected )	
	AddEventHandlerToButton( file.menu, "SMGBarrels2", UIE_CLICK, SetSMGBarrelsAttachmentSelected )	
	AddEventHandlerToButton( file.menu, "SMGBarrels3", UIE_CLICK, SetSMGBarrelsAttachmentSelected )	
	AddEventHandlerToButton( file.menu, "SMGBarrels4", UIE_CLICK, SetSMGBarrelsAttachmentSelected )	
	
	AddEventHandlerToButton( file.menu, "SMGStocks1", UIE_CLICK, SetSMGStocksAttachmentSelected )	
	AddEventHandlerToButton( file.menu, "SMGStocks2", UIE_CLICK, SetSMGStocksAttachmentSelected )	
	AddEventHandlerToButton( file.menu, "SMGStocks3", UIE_CLICK, SetSMGStocksAttachmentSelected )	

	AddEventHandlerToButton( file.menu, "ShotgunBolt1", UIE_CLICK, SetShotgunBoltAttachmentSelected )	
	AddEventHandlerToButton( file.menu, "ShotgunBolt2", UIE_CLICK, SetShotgunBoltAttachmentSelected )	
	AddEventHandlerToButton( file.menu, "ShotgunBolt3", UIE_CLICK, SetShotgunBoltAttachmentSelected )
	
    AddPanelEventHandler( panel, eUIEvent.PANEL_SHOW, OnR5RSB_Show )
	AddPanelEventHandler( panel, eUIEvent.PANEL_HIDE, OnR5RSB_Hide )

	var p2020 = Hud_GetChild( menu, "P2020" )
	RuiSetImage( Hud_GetRui( p2020 ), "basicImage", $"rui/weapon_icons/r5/weapon_p2020" )
	AddEventHandlerToButton( menu, "P2020Button", UIE_CLICK, BuyP2020 )
	AddEventHandlerToButton( menu, "P2020Button", UIE_CLICKRIGHT, OpenAttachmentsBox )
	file.weaponButtons.append(Hud_GetChild( menu, "P2020Button" ))

	var mozam = Hud_GetChild( menu, "Mozambique" )
	RuiSetImage( Hud_GetRui( mozam ), "basicImage", $"rui/weapon_icons/r5/weapon_mozambique" )
	AddEventHandlerToButton( menu, "MozambiqueButton", UIE_CLICK, BuyMozam )
	AddEventHandlerToButton( menu, "MozambiqueButton", UIE_CLICKRIGHT, OpenAttachmentsBox )
	file.weaponButtons.append(Hud_GetChild( menu, "MozambiqueButton" ))

	var wingman = Hud_GetChild( menu, "Wingman" )
	RuiSetImage( Hud_GetRui( wingman ), "basicImage", $"rui/weapon_icons/r5/weapon_wingman" )
	AddEventHandlerToButton( menu, "WingmanButton", UIE_CLICK, BuyWingman )
	AddEventHandlerToButton( menu, "WingmanButton", UIE_CLICKRIGHT, OpenAttachmentsBox )
	file.weaponButtons.append(Hud_GetChild( menu, "WingmanButton" ))

	var re45 = Hud_GetChild( menu, "RE45" )
	RuiSetImage( Hud_GetRui( re45 ), "basicImage", $"rui/weapon_icons/r5/weapon_r45" )
	AddEventHandlerToButton( menu, "RE45Button", UIE_CLICK, BuyRE45 )
	AddEventHandlerToButton( menu, "RE45Button", UIE_CLICKRIGHT, OpenAttachmentsBox )
	file.weaponButtons.append(Hud_GetChild( menu, "RE45Button" ))

	var alternator = Hud_GetChild( menu, "Alternator" )
	RuiSetImage( Hud_GetRui( alternator ), "basicImage", $"rui/weapon_icons/r5/weapon_alternator" )
	AddEventHandlerToButton( menu, "AlternatorButton", UIE_CLICK, BuyAlternator )
	AddEventHandlerToButton( menu, "AlternatorButton", UIE_CLICKRIGHT, OpenAttachmentsBox )
	file.weaponButtons.append(Hud_GetChild( menu, "AlternatorButton" ))

	var r99 = Hud_GetChild( menu, "R99" )
	RuiSetImage( Hud_GetRui( r99 ), "basicImage", $"rui/weapon_icons/r5/weapon_r97" )
	AddEventHandlerToButton( menu, "R99Button", UIE_CLICK, BuyR99 )
	AddEventHandlerToButton( menu, "R99Button", UIE_CLICKRIGHT, OpenAttachmentsBox )
	file.weaponButtons.append(Hud_GetChild( menu, "R99Button" ))

	var eva8 = Hud_GetChild( menu, "EVA8" )
	RuiSetImage( Hud_GetRui( eva8 ), "basicImage", $"rui/weapon_icons/r5/weapon_eva8" )
	AddEventHandlerToButton( menu, "EVA8Button", UIE_CLICK, BuyEva8 )
	AddEventHandlerToButton( menu, "EVA8Button", UIE_CLICKRIGHT, OpenAttachmentsBox )
	file.weaponButtons.append(Hud_GetChild( menu, "EVA8Button" ))
	
	var mastiff = Hud_GetChild( menu, "Mastiff" )
	RuiSetImage( Hud_GetRui( mastiff ), "basicImage", $"rui/weapon_icons/r5/weapon_mastiff" )
	AddEventHandlerToButton( menu, "MastiffButton", UIE_CLICK, BuyMastiff )
	AddEventHandlerToButton( menu, "MastiffButton", UIE_CLICKRIGHT, OpenAttachmentsBox )
	file.weaponButtons.append(Hud_GetChild( menu, "MastiffButton" ))
	
	var peacekeeper = Hud_GetChild( menu, "Peacekeeper" )
	RuiSetImage( Hud_GetRui( peacekeeper ), "basicImage", $"rui/weapon_icons/r5/weapon_peacekeeper" )
	AddEventHandlerToButton( menu, "PeacekeeperButton", UIE_CLICK, BuyPeacekeeper )
	AddEventHandlerToButton( menu, "PeacekeeperButton", UIE_CLICKRIGHT, OpenAttachmentsBox )
	file.weaponButtons.append(Hud_GetChild( menu, "PeacekeeperButton" ))
	
	CleanAllButtons()
}

array<var> function returnWeaponButtons1()
{
	return file.weaponButtons
}

void function OnR5RSB_Hide(var panel)
{
}

void function OnR5RSB_Show(var panel)
{
}
void function CleanAllButtons()
{
	foreach(var rui in returnWeaponButtons1())
	{
		RuiSetInt( Hud_GetRui(rui), "status", eFriendStatus.OFFLINE )	
	}
	foreach(var rui in returnWeaponButtons2())
	{
		RuiSetInt( Hud_GetRui(rui), "status", eFriendStatus.OFFLINE )	
	}
	foreach(var rui in returnWeaponButtons3())
	{
		RuiSetInt( Hud_GetRui(rui), "status", eFriendStatus.OFFLINE )	
	}
	foreach(var rui in returnWeaponButtons4())
	{
		RuiSetInt( Hud_GetRui(rui), "status", eFriendStatus.OFFLINE )	
	}	
}

void function DisableAllButtons()
{
	foreach(var rui in returnWeaponButtons1())
	{
		Hud_SetEnabled( rui, false )
	}
	foreach(var rui in returnWeaponButtons2())
	{
		Hud_SetEnabled( rui, false )
	}
	foreach(var rui in returnWeaponButtons3())
	{
		Hud_SetEnabled( rui, false )
	}
	foreach(var rui in returnWeaponButtons4())
	{
		Hud_SetEnabled( rui, false )
	}	
}

void function EnableAllButtons()
{
	foreach(var rui in returnWeaponButtons1())
	{
		Hud_SetEnabled( rui, true )
	}
	foreach(var rui in returnWeaponButtons2())
	{
		Hud_SetEnabled( rui, true )
	}
	foreach(var rui in returnWeaponButtons3())
	{
		Hud_SetEnabled( rui, true )
	}
	foreach(var rui in returnWeaponButtons4())
	{
		Hud_SetEnabled( rui, true )
	}	
}

void function OpenAttachmentsBox( var button )
{
	//DisableBuyWeaponsMenuTabs()
	
	bool smg = false
	bool pistol = false
	bool shotgun = false
	bool ar = false
	bool sniper = false
	bool pistol2 = false
	
	if(button == Hud_GetChild( file.menu, "AlternatorButton" ))
	{	
		file.desiredWeaponButtonToMark = Hud_GetChild( file.menu, "AlternatorButton" )
		file.desiredweapon = "mp_weapon_alternator_smg"
		smg = true
		file.weapontype = "smg"
	}else if(button == Hud_GetChild( file.menu, "R99Button" ))
	{
		file.desiredWeaponButtonToMark = Hud_GetChild( file.menu, "R99Button" )
		file.desiredweapon = "mp_weapon_r97"
		smg = true
		file.weapontype = "smg"
	}else if(button == Hud_GetChild( file.menu, "P2020Button" ))
	{
		file.desiredWeaponButtonToMark = Hud_GetChild( file.menu, "P2020Button" )
		file.desiredweapon = "mp_weapon_semipistol"
		pistol2 = true
		file.weapontype = "pistol2"
	}else if(button == Hud_GetChild( file.menu, "MozambiqueButton" ))
	{
		file.desiredWeaponButtonToMark = Hud_GetChild( file.menu, "MozambiqueButton" )
		file.desiredweapon = "mp_weapon_shotgun_pistol"
		shotgun = true
		file.weapontype = "shotgun"
	}else if(button == Hud_GetChild( file.menu, "WingmanButton" ))
	{
		file.desiredWeaponButtonToMark = Hud_GetChild( file.menu, "WingmanButton" )
		file.desiredweapon = "mp_weapon_wingman"
		pistol2 = true
		file.weapontype = "pistol2"
	}else if(button == Hud_GetChild( file.menu, "RE45Button" ))
	{
		file.desiredWeaponButtonToMark = Hud_GetChild( file.menu, "RE45Button" )
		file.desiredweapon = "mp_weapon_autopistol"
		pistol = true
		file.weapontype = "pistol"
	}else if(button == Hud_GetChild( file.menu, "EVA8Button" ))
	{
		file.desiredWeaponButtonToMark = Hud_GetChild( file.menu, "EVA8Button" )
		file.desiredweapon = "mp_weapon_shotgun"
		shotgun = true
		file.weapontype = "shotgun"
	}else if(button == Hud_GetChild( file.menu, "MastiffButton" ))
	{
		file.desiredWeaponButtonToMark = Hud_GetChild( file.menu, "MastiffButton" )
		file.desiredweapon = "mp_weapon_mastiff"
		shotgun = true
		file.weapontype = "shotgun"
	}else if(button == Hud_GetChild( file.menu, "PeacekeeperButton" ))
	{
		file.desiredWeaponButtonToMark = Hud_GetChild( file.menu, "PeacekeeperButton" )
		file.desiredweapon = "mp_weapon_energy_shotgun"
		shotgun = true
		file.weapontype = "shotgun"
	}
	
	vector mousePos = GetCursorPosition()
	UISize screenSize = GetScreenSize()
	//don't try this at home
	
	file.screenPos = < mousePos.x * screenSize.width / 1920.0, mousePos.y * screenSize.height / 1080.0, 0.0 >
	file.xstep = 16.5 * (screenSize.width / 1920.0)
	file.ystep = 90 * (screenSize.height / 1080.0)
	file.ancho = 75 *  (screenSize.width / 1920.0) + file.xstep
	float attachmentsBoxancho = screenSize.width * 0.25
	float attachmentsBoxAlto = screenSize.height * 0.24
	float buttonsOffset = screenSize.width*0.125
	float buttonsOffsetTop = screenSize.width*0.0833
	float buttonsOnTopCenter = buttonsOffsetTop/2
	float TextButtonsOnTopOffset = 27 * (screenSize.width / 1920.0)
	
	int BottomButtonsHeight = Hud_GetHeight(file.closebutton)
	Hud_SetHeight(file.frame3, BottomButtonsHeight)
	Hud_SetHeight(file.frame4, BottomButtonsHeight)
	//DisableAllButtons()
	
	
	//MENU BASICS
	//visibility for background of the mini box
	Hud_SetVisible(file.frame1, true)
	file.visibleAttachmentsBoxElements.append(file.frame1)
	Hud_SetVisible(file.frame2, true)
	file.visibleAttachmentsBoxElements.append(file.frame2)
	Hud_SetVisible(file.frame3, true)
	file.visibleAttachmentsBoxElements.append(file.frame3)
	Hud_SetVisible(file.frame4, true)
	file.visibleAttachmentsBoxElements.append(file.frame4)

	//visibility for top

	Hud_SetVisible(file.opticsbutton, true)
	file.visibleAttachmentsBoxElements.append(file.opticsbutton)
	file.visibleAttachmentsBoxElements.append(file.opticstext)
	Hud_SetVisible(file.opticstext, true)	
	
	if(!pistol2 && !shotgun){
	Hud_SetVisible(file.barrelsbutton, true)
	file.visibleAttachmentsBoxElements.append(file.barrelsbutton)
	file.visibleAttachmentsBoxElements.append(file.barrelstext)
	Hud_SetVisible(file.barrelstext, true)
	}
	
	if(!pistol2 && !pistol && !shotgun){
	Hud_SetVisible(file.stocksbutton, true)
	file.visibleAttachmentsBoxElements.append(file.stocksbutton)	
	Hud_SetVisible(file.stockstext, true)
	file.visibleAttachmentsBoxElements.append(file.stockstext)
	}
	
	if(shotgun){
		Hud_SetVisible(file.boltsbutton, true)
		Hud_SetVisible(file.boltstext, true)
		file.visibleAttachmentsBoxElements.append(file.boltsbutton)
		file.visibleAttachmentsBoxElements.append(file.boltstext)
	}

	//visibility for bottom
	Hud_SetVisible(file.invisibleExitButton, true)
	file.visibleAttachmentsBoxElements.append(file.invisibleExitButton)	
	Hud_SetVisible(file.closebutton, true)
	file.visibleAttachmentsBoxElements.append(file.closebutton)
	Hud_SetVisible(file.savebutton, true)
	file.visibleAttachmentsBoxElements.append(file.savebutton)
	
	//Position Frames
	Hud_SetPos( file.frame1, file.screenPos.x, file.screenPos.y )	
	Hud_SetPos( file.frame2, file.screenPos.x, file.screenPos.y )
	Hud_SetPos( file.frame3, file.screenPos.x, file.screenPos.y+attachmentsBoxAlto-BottomButtonsHeight )
	Hud_SetPos( file.frame4, file.screenPos.x, file.screenPos.y )
	
	//bottom
	Hud_SetPos( file.closebutton, file.screenPos.x+buttonsOffset, file.screenPos.y+attachmentsBoxAlto-BottomButtonsHeight )
	SetButtonRuiText(file.closebutton, "Close" )
	Hud_SetPos( file.savebutton, file.screenPos.x, file.screenPos.y+attachmentsBoxAlto-BottomButtonsHeight )
	SetButtonRuiText( file.savebutton, "Get Loadout" )	
	
	//top
	Hud_SetPos( file.opticsbutton, file.screenPos.x, file.screenPos.y )	
	Hud_SetSelected( file.opticsbutton, true )
	SetButtonRuiText( file.opticsbutton, "" )
	Hud_SetPos( file.opticstext, file.screenPos.x+buttonsOnTopCenter-TextButtonsOnTopOffset, file.screenPos.y )	
	
	Hud_SetPos( file.barrelsbutton, file.screenPos.x+buttonsOffsetTop, file.screenPos.y )	
	SetButtonRuiText( file.barrelsbutton, "" )
	Hud_SetPos( file.barrelstext, file.screenPos.x+(buttonsOnTopCenter*3)-TextButtonsOnTopOffset-(10* (screenSize.width / 1920.0)), file.screenPos.y )//with additional offset
	
	Hud_SetPos( file.boltsbutton, file.screenPos.x+buttonsOffsetTop, file.screenPos.y )	
	SetButtonRuiText( file.boltsbutton, "" )
	Hud_SetPos( file.boltstext, file.screenPos.x+(buttonsOnTopCenter*3)-TextButtonsOnTopOffset-(10* (screenSize.width / 1920.0)), file.screenPos.y )//with additional offset
	
	Hud_SetPos( file.stocksbutton, file.screenPos.x+(buttonsOffsetTop*2), file.screenPos.y )	
	SetButtonRuiText( file.stocksbutton, "" )
	Hud_SetPos( file.stockstext, file.screenPos.x+(buttonsOnTopCenter*5)-TextButtonsOnTopOffset-(5* (screenSize.width / 1920.0)), file.screenPos.y )
	
	if(smg || pistol || shotgun || pistol2)
		SMGOptics(button)
}

void function CloseButtonAttachmentsBox(var button)
{
	EnableBuyWeaponsMenuTabs()
	
	foreach(var element in file.visibleAttachmentsBoxElements)
		Hud_SetVisible(element, false)
		
	EnableAllButtons()
}

void function SetSMGOpticsAttachmentSelected(var button)
{
	for(int i=0; i<file.SMGOptics.len(); i++){
		var element = file.SMGOptics[i]
		if(element != button)
			Hud_SetSelected(element, false)
		else
			file.desiredOptic = i
	}
	Hud_SetSelected(button, true)
}

void function SetShotgunBoltAttachmentSelected(var button)
{
	for(int i=0; i<file.ShotgunBolts.len(); i++){
		var element = file.ShotgunBolts[i]
		if(element != button)
			Hud_SetSelected(element, false)
		else
			file.desiredShotgunbolt = i
	}
	Hud_SetSelected(button, true)
}

void function SetSMGBarrelsAttachmentSelected(var button)
{
	for(int i=0; i<file.SMGBarrels.len(); i++){
		var element = file.SMGBarrels[i]
		if(element != button)
			Hud_SetSelected(element, false)
		else
			file.desiredBarrel = i
	}
	Hud_SetSelected(button, true)
}

void function SetSMGStocksAttachmentSelected(var button)
{
	for(int i=0; i<file.SMGStocks.len(); i++){
		var element = file.SMGStocks[i]
		if(element != button)
			Hud_SetSelected(element, false)
		else
			file.desiredStock = i
	}
	Hud_SetSelected(button, true)
}

void function SetButtonsOnTopUnselected()
{
	Hud_SetSelected(file.opticsbutton, false)
	Hud_SetSelected(file.barrelsbutton, false)
	Hud_SetSelected(file.boltsbutton, false)
	Hud_SetSelected(file.stocksbutton, false)
}

void function SetOtherTabsContentInvisible()
{
	foreach(var element in file.SMGOptics)
	{
		Hud_SetVisible(element, false)
		file.visibleAttachmentsBoxElements.removebyvalue(element)
	}
	foreach(var element in file.SMGBarrels)
	{
		Hud_SetVisible(element, false)
		file.visibleAttachmentsBoxElements.removebyvalue(element)
	}
	foreach(var element in file.ShotgunBolts)
	{
		Hud_SetVisible(element, false)
		file.visibleAttachmentsBoxElements.removebyvalue(element)
	}
	foreach(var element in file.SMGStocks)
	{
		Hud_SetVisible(element, false)
		file.visibleAttachmentsBoxElements.removebyvalue(element)
	}
}

void function SMGOptics(var button)
{
	SetOtherTabsContentInvisible()
	SetButtonsOnTopUnselected()
	Hud_SetSelected(file.opticsbutton, true)
	
	Hud_SetVisible(file.SMGOptics[0], true)
	Hud_SetPos( file.SMGOptics[0], file.xstep+file.screenPos.x, file.screenPos.y+file.ystep )
	RuiSetImage( Hud_GetRui(file.SMGOptics[0]), "iconImage", $"rui/weapon_icons/attachments/hcog" )
	RuiSetInt( Hud_GetRui(file.SMGOptics[0]), "lootTier", 1 )
	file.visibleAttachmentsBoxElements.append(file.SMGOptics[0])
	
	Hud_SetVisible(file.SMGOptics[1], true)
	Hud_SetPos( file.SMGOptics[1], file.xstep+file.screenPos.x+file.ancho, file.screenPos.y+file.ystep )
	RuiSetImage( Hud_GetRui(file.SMGOptics[1]), "iconImage", $"rui/weapon_icons/attachments/holosight" )
	RuiSetInt( Hud_GetRui(file.SMGOptics[1]), "lootTier", 1 )
	file.visibleAttachmentsBoxElements.append(file.SMGOptics[1])
	
	Hud_SetVisible(file.SMGOptics[2], true)
	Hud_SetPos( file.SMGOptics[2], file.xstep+file.screenPos.x+(file.ancho*2), file.screenPos.y+file.ystep )
	RuiSetImage( Hud_GetRui(file.SMGOptics[2]), "iconImage", $"rui/weapon_icons/attachments/threat_scope" )	
	RuiSetInt( Hud_GetRui(file.SMGOptics[2]), "lootTier", 4 )
	file.visibleAttachmentsBoxElements.append(file.SMGOptics[2])
	
	Hud_SetVisible(file.SMGOptics[3], true)
	Hud_SetPos( file.SMGOptics[3], file.xstep+file.screenPos.x+(file.ancho*3), file.screenPos.y+file.ystep )
	RuiSetImage( Hud_GetRui(file.SMGOptics[3]), "iconImage", $"rui/weapon_icons/attachments/1x_2x_variable_holosight")	
	RuiSetInt( Hud_GetRui(file.SMGOptics[3]), "lootTier", 2 )
	file.visibleAttachmentsBoxElements.append(file.SMGOptics[3])
	
	Hud_SetVisible(file.SMGOptics[4], true)
	Hud_SetPos( file.SMGOptics[4], file.xstep+file.screenPos.x+(file.ancho*4), file.screenPos.y+file.ystep )
	RuiSetImage( Hud_GetRui(file.SMGOptics[4]), "iconImage", $"rui/weapon_icons/attachments/hcog_bruiser" )
	RuiSetInt( Hud_GetRui(file.SMGOptics[4]), "lootTier", 2 )
	file.visibleAttachmentsBoxElements.append(file.SMGOptics[4])
}

void function SMGBarrels(var button)
{
	SetOtherTabsContentInvisible()
	SetButtonsOnTopUnselected()
	Hud_SetSelected(file.barrelsbutton, true)
	
	Hud_SetVisible(file.SMGBarrels[0], true)
	Hud_SetPos( file.SMGBarrels[0], file.xstep+file.screenPos.x+file.ancho, file.screenPos.y+file.ystep )
	RuiSetImage( Hud_GetRui(file.SMGBarrels[0]), "iconImage", $"rui/pilot_loadout/mods/barrel_stabilizer" )
	RuiSetInt( Hud_GetRui(file.SMGBarrels[0]), "lootTier", 1 )
	file.visibleAttachmentsBoxElements.append(file.SMGBarrels[0])
	
	Hud_SetVisible(file.SMGBarrels[1], true)
	Hud_SetPos( file.SMGBarrels[1], file.xstep+file.screenPos.x+(file.ancho*2), file.screenPos.y+file.ystep )
	RuiSetImage( Hud_GetRui(file.SMGBarrels[1]), "iconImage", $"rui/pilot_loadout/mods/barrel_stabilizer" )
	RuiSetInt( Hud_GetRui(file.SMGBarrels[1]), "lootTier", 2 )
	file.visibleAttachmentsBoxElements.append(file.SMGBarrels[1])
	
	Hud_SetVisible(file.SMGBarrels[2], true)
	Hud_SetPos( file.SMGBarrels[2], file.xstep+file.screenPos.x+(file.ancho*3), file.screenPos.y+file.ystep )
	RuiSetImage( Hud_GetRui(file.SMGBarrels[2]), "iconImage", $"rui/pilot_loadout/mods/barrel_stabilizer" )	
	RuiSetInt( Hud_GetRui(file.SMGBarrels[2]), "lootTier", 3 )
	file.visibleAttachmentsBoxElements.append(file.SMGBarrels[2])
}

void function ShotgunBolts(var button)
{
	SetOtherTabsContentInvisible()
	SetButtonsOnTopUnselected()
	Hud_SetSelected(file.barrelsbutton, true)
	
	Hud_SetVisible(file.ShotgunBolts[0], true)
	Hud_SetPos( file.ShotgunBolts[0], file.xstep+file.screenPos.x+file.ancho, file.screenPos.y+file.ystep )
	RuiSetImage( Hud_GetRui(file.ShotgunBolts[0]), "iconImage", $"rui/pilot_loadout/mods/shotgun_mag" )
	RuiSetInt( Hud_GetRui(file.ShotgunBolts[0]), "lootTier", 1 )
	file.visibleAttachmentsBoxElements.append(file.ShotgunBolts[0])
	
	Hud_SetVisible(file.ShotgunBolts[1], true)
	Hud_SetPos( file.ShotgunBolts[1], file.xstep+file.screenPos.x+(file.ancho*2), file.screenPos.y+file.ystep )
	RuiSetImage( Hud_GetRui(file.ShotgunBolts[1]), "iconImage", $"rui/pilot_loadout/mods/shotgun_mag" )
	RuiSetInt( Hud_GetRui(file.ShotgunBolts[1]), "lootTier", 2 )
	file.visibleAttachmentsBoxElements.append(file.ShotgunBolts[1])
	
	Hud_SetVisible(file.ShotgunBolts[2], true)
	Hud_SetPos( file.ShotgunBolts[2], file.xstep+file.screenPos.x+(file.ancho*3), file.screenPos.y+file.ystep )
	RuiSetImage( Hud_GetRui(file.ShotgunBolts[2]), "iconImage", $"rui/pilot_loadout/mods/shotgun_mag" )	
	RuiSetInt( Hud_GetRui(file.ShotgunBolts[2]), "lootTier", 3 )
	file.visibleAttachmentsBoxElements.append(file.ShotgunBolts[2])
}

void function SMGStocks(var button)
{
	SetOtherTabsContentInvisible()
	SetButtonsOnTopUnselected()
	Hud_SetSelected(file.stocksbutton, true)
	
	Hud_SetVisible(file.SMGStocks[0], true)
	Hud_SetPos( file.SMGStocks[0], file.xstep+file.screenPos.x+file.ancho, file.screenPos.y+file.ystep )
	RuiSetImage( Hud_GetRui(file.SMGStocks[0]), "iconImage", $"rui/pilot_loadout/mods/tactical_stock" )
	RuiSetInt( Hud_GetRui(file.SMGStocks[0]), "lootTier", 1 )
	file.visibleAttachmentsBoxElements.append(file.SMGStocks[0])
	
	Hud_SetVisible(file.SMGStocks[1], true)
	Hud_SetPos( file.SMGStocks[1], file.xstep+file.screenPos.x+(file.ancho*2), file.screenPos.y+file.ystep )
	RuiSetImage( Hud_GetRui(file.SMGStocks[1]), "iconImage", $"rui/pilot_loadout/mods/tactical_stock" )
	RuiSetInt( Hud_GetRui(file.SMGStocks[1]), "lootTier", 2 )
	file.visibleAttachmentsBoxElements.append(file.SMGStocks[1])
	
	Hud_SetVisible(file.SMGStocks[2], true)
	Hud_SetPos( file.SMGStocks[2], file.xstep+file.screenPos.x+(file.ancho*3), file.screenPos.y+file.ystep )
	RuiSetImage( Hud_GetRui(file.SMGStocks[2]), "iconImage", $"rui/pilot_loadout/mods/tactical_stock" )	
	RuiSetInt( Hud_GetRui(file.SMGStocks[2]), "lootTier", 3 )
	file.visibleAttachmentsBoxElements.append(file.SMGStocks[2])
}

void function BuyWeaponWithAttachments(var button)
{
	CleanAllButtons()
	EnableBuyWeaponsMenuTabs()
	RuiSetInt( Hud_GetRui( file.desiredWeaponButtonToMark ), "status", eFriendStatus.ONLINE_INGAME )
	foreach(var element in file.visibleAttachmentsBoxElements)
		Hud_SetVisible(element, false)
	EnableAllButtons()
	printt("DEBUG: desiredOptic: " + file.desiredOptic, " desiredBarrel: " + file.desiredBarrel, " desiredStock: " + file.desiredStock, " weapon type: " + file.weapontype)
	RunClientScript( "UIToClient_MenuGiveWeaponWithAttachments", file.desiredweapon, file.desiredOptic, file.desiredBarrel, file.desiredStock, file.desiredShotgunbolt, file.weapontype )
}

void function BuyP2020(var button)
{
	CleanAllButtons()
	RuiSetInt( Hud_GetRui( button ), "status", eFriendStatus.ONLINE_INGAME )
	RunClientScript( "UIToClient_MenuGiveWeapon", "mp_weapon_semipistol" )
}

void function BuyMozam(var button)
{
	CleanAllButtons()
	RuiSetInt( Hud_GetRui( button ), "status", eFriendStatus.ONLINE_INGAME )
	RunClientScript( "UIToClient_MenuGiveWeapon", "mp_weapon_shotgun_pistol" )
}

void function BuyWingman(var button)
{
	CleanAllButtons()	
	RuiSetInt( Hud_GetRui( button ), "status", eFriendStatus.ONLINE_INGAME )
	RunClientScript( "UIToClient_MenuGiveWeapon", "mp_weapon_wingman" )
}

void function BuyRE45(var button)
{
	CleanAllButtons()	
	RuiSetInt( Hud_GetRui( button ), "status", eFriendStatus.ONLINE_INGAME )
	RunClientScript( "UIToClient_MenuGiveWeapon", "mp_weapon_autopistol" )
}

void function BuyAlternator(var button)
{
	CleanAllButtons()	
	RuiSetInt( Hud_GetRui( button ), "status", eFriendStatus.ONLINE_INGAME )
	RunClientScript( "UIToClient_MenuGiveWeapon", "mp_weapon_alternator_smg" )
}

void function BuyR99(var button)
{
	CleanAllButtons()	
	RuiSetInt( Hud_GetRui( button ), "status", eFriendStatus.ONLINE_INGAME )
	RunClientScript( "UIToClient_MenuGiveWeapon", "mp_weapon_r97" )
}

void function BuyEva8(var button)
{
	CleanAllButtons()	
	RuiSetInt( Hud_GetRui( button ), "status", eFriendStatus.ONLINE_INGAME )
	RunClientScript( "UIToClient_MenuGiveWeapon", "mp_weapon_shotgun" )
}

void function BuyMastiff(var button)
{
	CleanAllButtons()	
	RuiSetInt( Hud_GetRui( button ), "status", eFriendStatus.ONLINE_INGAME )
	RunClientScript( "UIToClient_MenuGiveWeapon", "mp_weapon_mastiff" )
}

void function BuyPeacekeeper(var button)
{
	CleanAllButtons()	
	RuiSetInt( Hud_GetRui( button ), "status", eFriendStatus.ONLINE_INGAME )
	RunClientScript( "UIToClient_MenuGiveWeapon", "mp_weapon_energy_shotgun" )
}
