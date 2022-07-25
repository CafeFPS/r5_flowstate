global function InitArenasBuyPanel3
global function returnWeaponButtons3

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
	var SniperStockstext
	var hopupsbutton//SniperStocksbutton
	array<var> visibleAttachmentsBoxElements
	
	string desiredweapon
	string weapontype
	var desiredWeaponButtonToMark
	int desiredOptic = 0
	int desiredBarrel = 0
	int desiredStock = 0
	int desiredSniperStock = 0

	array<var> SMGOptics
	array<var> SMGBarrels
	array<var> SMGStocks
	array<var> SniperStocks
	int relevantdata
	int relevantdata2
} file

void function InitArenasBuyPanel3( var panel )
{
	file.menu = panel
    var menu = panel
	
	//attachments box setup
	//background
	file.frame1 = Hud_GetChild( file.menu, "ScreenBlur" )
	file.frame2 = Hud_GetChild( file.menu, "SMGLootFrame" )
	file.frame3 = Hud_GetChild( file.menu, "SMGLootFrame2" )
	file.frame4 = Hud_GetChild( file.menu, "SMGLootFrame3" )

	file.relevantdata = Hud_GetWidth(file.frame1)
	file.relevantdata2 = Hud_GetHeight(file.frame1)
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
	file.hopupsbutton = Hud_GetChild( file.menu, "SniperStocksButton" )
	file.barrelstext = Hud_GetChild( file.menu, "BarrelsText" )
	file.stocksbutton = Hud_GetChild( file.menu, "StocksButton" )
	file.stockstext = Hud_GetChild( file.menu, "StocksText" )
	file.SniperStockstext = Hud_GetChild( file.menu, "SniperStocksText" )
	//buttons for header
	AddEventHandlerToButton( file.menu, "OpticsButton", UIE_CLICK, SMGOptics )
	AddEventHandlerToButton( file.menu, "BarrelsButton", UIE_CLICK, SMGBarrels )
	AddEventHandlerToButton( file.menu, "StocksButton", UIE_CLICK, SMGStocks )
	AddEventHandlerToButton( file.menu, "SniperStocksButton", UIE_CLICK, SniperStocks )
	//SMG Optics Loadout
	file.SMGOptics.append( Hud_GetChild( file.menu, "SMGOptics1" ) )
	file.SMGOptics.append( Hud_GetChild( file.menu, "SMGOptics2" ) )
	file.SMGOptics.append( Hud_GetChild( file.menu, "SMGOptics3" ) )
	file.SMGOptics.append( Hud_GetChild( file.menu, "SMGOptics4" ) )
	file.SMGOptics.append( Hud_GetChild( file.menu, "SMGOptics5" ) )
	file.SMGOptics.append( Hud_GetChild( file.menu, "SMGOptics6" ) )
	file.SMGOptics.append( Hud_GetChild( file.menu, "SMGOptics7" ) )
	file.SMGOptics.append( Hud_GetChild( file.menu, "SMGOptics8" ) )
	file.SMGOptics.append( Hud_GetChild( file.menu, "SMGOptics9" ) )
	
	//SMG Barrels
	file.SMGBarrels.append( Hud_GetChild( file.menu, "SMGBarrels1" ) )
	file.SMGBarrels.append( Hud_GetChild( file.menu, "SMGBarrels2" ) )
	file.SMGBarrels.append( Hud_GetChild( file.menu, "SMGBarrels3" ) )
	file.SMGBarrels.append( Hud_GetChild( file.menu, "SMGBarrels4" ) )
	//SMG Stocks
	file.SMGStocks.append( Hud_GetChild( file.menu, "SMGStocks1" ) )
	file.SMGStocks.append( Hud_GetChild( file.menu, "SMGStocks2" ) )
	file.SMGStocks.append( Hud_GetChild( file.menu, "SMGStocks3" ) )
	//SniperStocks
	file.SniperStocks.append( Hud_GetChild( file.menu, "SniperStock1" ) )
	file.SniperStocks.append( Hud_GetChild( file.menu, "SniperStock2" ) )
	file.SniperStocks.append( Hud_GetChild( file.menu, "SniperStock3" ) )
		
	//Optics default
	Hud_SetSelected( file.SMGOptics[0], true )
	Hud_SetSelected( file.SMGBarrels[0], true )
	Hud_SetSelected( file.SMGStocks[0], true )
	Hud_SetSelected( file.SniperStocks[0], true )
	
	//Optics buttons
	AddEventHandlerToButton( file.menu, "SMGOptics1", UIE_CLICK, SetSMGOpticsAttachmentSelected )	
	AddEventHandlerToButton( file.menu, "SMGOptics2", UIE_CLICK, SetSMGOpticsAttachmentSelected )	
	AddEventHandlerToButton( file.menu, "SMGOptics3", UIE_CLICK, SetSMGOpticsAttachmentSelected )	
	AddEventHandlerToButton( file.menu, "SMGOptics4", UIE_CLICK, SetSMGOpticsAttachmentSelected )	
	AddEventHandlerToButton( file.menu, "SMGOptics5", UIE_CLICK, SetSMGOpticsAttachmentSelected )
	AddEventHandlerToButton( file.menu, "SMGOptics6", UIE_CLICK, SetSMGOpticsAttachmentSelected )
	AddEventHandlerToButton( file.menu, "SMGOptics7", UIE_CLICK, SetSMGOpticsAttachmentSelected )
	AddEventHandlerToButton( file.menu, "SMGOptics8", UIE_CLICK, SetSMGOpticsAttachmentSelected )
	AddEventHandlerToButton( file.menu, "SMGOptics9", UIE_CLICK, SetSMGOpticsAttachmentSelected )
	
	AddEventHandlerToButton( file.menu, "SMGBarrels1", UIE_CLICK, SetSMGBarrelsAttachmentSelected )	
	AddEventHandlerToButton( file.menu, "SMGBarrels2", UIE_CLICK, SetSMGBarrelsAttachmentSelected )	
	AddEventHandlerToButton( file.menu, "SMGBarrels3", UIE_CLICK, SetSMGBarrelsAttachmentSelected )	
	AddEventHandlerToButton( file.menu, "SMGBarrels4", UIE_CLICK, SetSMGBarrelsAttachmentSelected )	
	
	AddEventHandlerToButton( file.menu, "SMGStocks1", UIE_CLICK, SetSMGStocksAttachmentSelected )	
	AddEventHandlerToButton( file.menu, "SMGStocks2", UIE_CLICK, SetSMGStocksAttachmentSelected )	
	AddEventHandlerToButton( file.menu, "SMGStocks3", UIE_CLICK, SetSMGStocksAttachmentSelected )	

	AddEventHandlerToButton( file.menu, "SniperStock1", UIE_CLICK, SetSniperStockAttachmentSelected )	
	AddEventHandlerToButton( file.menu, "SniperStock2", UIE_CLICK, SetSniperStockAttachmentSelected )
	
    AddPanelEventHandler( panel, eUIEvent.PANEL_SHOW, OnR5RSB_Show )
	AddPanelEventHandler( panel, eUIEvent.PANEL_HIDE, OnR5RSB_Hide )

	var g7 = Hud_GetChild( menu, "G7" )
	RuiSetImage( Hud_GetRui( g7 ), "basicImage", $"rui/weapon_icons/r5/weapon_g7" )
	AddEventHandlerToButton( menu, "G7Button", UIE_CLICK, BuyG7 )	
	AddEventHandlerToButton( menu, "G7Button", UIE_CLICKRIGHT, OpenAttachmentsBox )
	file.weaponButtons.append(Hud_GetChild( menu, "G7Button" ))

	var longbow = Hud_GetChild( menu, "Longbow" )
	RuiSetImage( Hud_GetRui( longbow ), "basicImage", $"rui/weapon_icons/r5/weapon_longbow" )
	AddEventHandlerToButton( menu, "LongbowButton", UIE_CLICK, BuyLongbow )	
	AddEventHandlerToButton( menu, "LongbowButton", UIE_CLICKRIGHT, OpenAttachmentsBox )
	file.weaponButtons.append(Hud_GetChild( menu, "LongbowButton" ))

	var tripletake = Hud_GetChild( menu, "TripleTake" )
	RuiSetImage( Hud_GetRui( tripletake ), "basicImage", $"rui/weapon_icons/r5/weapon_triple_take" )
	AddEventHandlerToButton( menu, "TripleTakeButton", UIE_CLICK, BuyTripleTake )	
	AddEventHandlerToButton( menu, "TripleTakeButton", UIE_CLICKRIGHT, OpenAttachmentsBox )
	file.weaponButtons.append(Hud_GetChild( menu, "TripleTakeButton" ))
	
	var chargerifle = Hud_GetChild( menu, "ChargeRifle" )
	RuiSetImage( Hud_GetRui( chargerifle ), "basicImage", $"rui/weapon_icons/r5/weapon_charge_rifle" )
	AddEventHandlerToButton( menu, "ChargeRifleButton", UIE_CLICK, BuyChargeRifle )	
	AddEventHandlerToButton( menu, "ChargeRifleButton", UIE_CLICKRIGHT, OpenAttachmentsBox )
	file.weaponButtons.append(Hud_GetChild( menu, "ChargeRifleButton" ))
	
	var kraber = Hud_GetChild( menu, "Kraber" )
	RuiSetImage( Hud_GetRui( kraber ), "basicImage", $"rui/weapon_icons/r5/weapon_sniper" )
	AddEventHandlerToButton( menu, "KraberButton", UIE_CLICK, BuyKraber )
	file.weaponButtons.append(Hud_GetChild( menu, "KraberButton" ))

	CleanAllButtons()
}

array<var> function returnWeaponButtons3()
{
	return file.weaponButtons
}

void function OnR5RSB_Hide(var panel)
{
}

void function OnR5RSB_Show(var panel)
{
}

void function OpenAttachmentsBox( var button )
{
	// DisableBuyWeaponsMenuTabs()
	
	bool smg = false
	bool pistol = false
	bool shotgun = false
	bool sniper = false
	bool pistol2 = false
	bool ar = false
	bool lmg = false
	bool ar2 = false
	bool lmg2 = false
	bool marksman = false

	if(button == Hud_GetChild( file.menu, "G7Button" ))
	{	
		file.desiredWeaponButtonToMark = Hud_GetChild( file.menu, "G7Button" )
		file.desiredweapon = "mp_weapon_g2"
		marksman = true
		file.weapontype = "marksman"
	}else if(button == Hud_GetChild( file.menu, "LongbowButton" ))
	{
		file.desiredWeaponButtonToMark = Hud_GetChild( file.menu, "LongbowButton" )
		file.desiredweapon = "mp_weapon_dmr"
		sniper = true
		file.weapontype = "sniper"
	}else if(button == Hud_GetChild( file.menu, "TripleTakeButton" ))
	{
		file.desiredWeaponButtonToMark = Hud_GetChild( file.menu, "TripleTakeButton" )
		file.desiredweapon = "mp_weapon_doubletake"
		marksman = true
		file.weapontype = "marksman2"
	}else if(button == Hud_GetChild( file.menu, "ChargeRifleButton" ))
	{
		file.desiredWeaponButtonToMark = Hud_GetChild( file.menu, "ChargeRifleButton" )
		file.desiredweapon = "mp_weapon_defender"
		sniper = true
		file.weapontype = "sniper2"
	}else if(button == Hud_GetChild( file.menu, "KraberButton" ))
	{
		file.desiredWeaponButtonToMark = Hud_GetChild( file.menu, "KraberButton" )
		file.desiredweapon = "mp_weapon_sniper"
		sniper = true
		file.weapontype = "sniper3"
	}
	
	vector mousePos = GetCursorPosition()
	UISize screenSize = GetScreenSize()
	//don't try this at home
	file.screenPos = < mousePos.x * screenSize.width / 1920.0, mousePos.y * screenSize.height / 1080.0, 0.0 >
	file.xstep = 16.5 * (screenSize.width / 1920.0)
	file.ystep = 90 * (screenSize.height / 1080.0)
	file.ancho = 75 *  (screenSize.width / 1920.0) + file.xstep
	float attachmentsBoxancho = (screenSize.width * 0.25)*1.2
	float attachmentsBoxAlto = screenSize.height * 0.24
	float buttonsOffset = (screenSize.width*0.125)*1.2
	float buttonsOffsetTop = (screenSize.width*0.0833)*1.2
	float buttonsOnTopCenter = buttonsOffsetTop/2
	float TextButtonsOnTopOffset = 27 * (screenSize.width / 1920.0)
	float buttonsDesiredWidth = (file.relevantdata*1.2)/2 //bottom buttons btw
	float buttonsDesiredWidthTop = (file.relevantdata*1.2)/3 //Top buttons btw
	int BottomButtonsHeight = Hud_GetHeight(file.closebutton)
		
	if(file.desiredweapon == "mp_weapon_g2")
	{
		buttonsDesiredWidthTop = (file.relevantdata*1.2)/4
	}
	
	Hud_SetWidth(file.frame1, file.relevantdata*1.2)
	Hud_SetWidth(file.frame2, file.relevantdata*1.2)
	Hud_SetWidth(file.frame3, file.relevantdata*1.2)
	Hud_SetWidth(file.frame4, file.relevantdata*1.2)
	if(file.desiredweapon == "mp_weapon_defender" || file.desiredweapon == "mp_weapon_dmr") 
	{
		attachmentsBoxAlto = (screenSize.height * 0.24)*1.25
		Hud_SetHeight(file.frame1, file.relevantdata2*1.25)
		Hud_SetHeight(file.frame2, file.relevantdata2*1.25)
		Hud_SetHeight(file.frame3, file.relevantdata2*1.25)
		Hud_SetHeight(file.frame4, file.relevantdata2*1.25)
	} else {
		Hud_SetHeight(file.frame1, file.relevantdata2)
		Hud_SetHeight(file.frame2, file.relevantdata2)
		Hud_SetHeight(file.frame3, file.relevantdata2)
		Hud_SetHeight(file.frame4, file.relevantdata2)	
	}
	
	Hud_SetWidth(file.closebutton, buttonsDesiredWidth)
	Hud_SetWidth(file.savebutton, buttonsDesiredWidth)
	
	Hud_SetWidth(file.closebutton, buttonsDesiredWidth)
	Hud_SetWidth(file.savebutton, buttonsDesiredWidth)
	
	Hud_SetWidth(file.opticsbutton, buttonsDesiredWidthTop)
	Hud_SetWidth(file.hopupsbutton, buttonsDesiredWidthTop)
	Hud_SetWidth(file.stocksbutton, buttonsDesiredWidthTop)
	Hud_SetWidth(file.barrelsbutton, buttonsDesiredWidthTop)
	
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
	
	if(ar || lmg2 || file.desiredweapon == "mp_weapon_g2" || file.desiredweapon == "mp_weapon_dmr"){
		Hud_SetVisible(file.barrelsbutton, true)
		file.visibleAttachmentsBoxElements.append(file.barrelsbutton)
		file.visibleAttachmentsBoxElements.append(file.barrelstext)
		Hud_SetVisible(file.barrelstext, true)
	}

	Hud_SetVisible(file.stocksbutton, true)
	file.visibleAttachmentsBoxElements.append(file.stocksbutton)	
	Hud_SetVisible(file.stockstext, true)
	file.visibleAttachmentsBoxElements.append(file.stockstext)

	if(file.desiredweapon == "mp_weapon_doubletake" || file.desiredweapon == "mp_weapon_g2"){
		Hud_SetVisible(file.hopupsbutton, true)
		Hud_SetVisible(file.SniperStockstext, true)
		file.visibleAttachmentsBoxElements.append(file.hopupsbutton)
		file.visibleAttachmentsBoxElements.append(file.SniperStockstext)
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
	
	Hud_SetPos( file.hopupsbutton, file.screenPos.x+buttonsOffsetTop, file.screenPos.y )	
	SetButtonRuiText( file.hopupsbutton, "" )
	Hud_SetPos( file.SniperStockstext, file.screenPos.x+(buttonsOnTopCenter*3)-TextButtonsOnTopOffset-(5* (screenSize.width / 1920.0)), file.screenPos.y )//with additional offset
	
	if(file.desiredweapon == "mp_weapon_defender")
	{
		Hud_SetPos( file.stocksbutton, file.screenPos.x+buttonsOffsetTop, file.screenPos.y )
		SetButtonRuiText( file.stocksbutton, "" )
		Hud_SetPos( file.stockstext, file.screenPos.x+(buttonsOnTopCenter*3)-TextButtonsOnTopOffset-(10* (screenSize.width / 1920.0)), file.screenPos.y )
	}
	else
	{
		Hud_SetPos( file.stocksbutton, file.screenPos.x+(buttonsOffsetTop*2), file.screenPos.y )	
		SetButtonRuiText( file.stocksbutton, "" )
		Hud_SetPos( file.stockstext, file.screenPos.x+(buttonsOnTopCenter*5)-TextButtonsOnTopOffset-(5* (screenSize.width / 1920.0)), file.screenPos.y )
	}
	
	if(file.desiredweapon == "mp_weapon_g2" )
	{
		TextButtonsOnTopOffset = 35 * (screenSize.width / 1920.0)
		Hud_SetPos( file.opticsbutton, file.screenPos.x, file.screenPos.y )
		Hud_SetPos( file.opticstext, file.screenPos.x+TextButtonsOnTopOffset, file.screenPos.y )	
		
		Hud_SetPos( file.barrelsbutton, file.screenPos.x+Hud_GetWidth(file.opticsbutton), file.screenPos.y )
		Hud_SetPos( file.barrelstext, file.screenPos.x+buttonsDesiredWidthTop+TextButtonsOnTopOffset, file.screenPos.y )//with additional offset
		
		Hud_SetPos( file.hopupsbutton, file.screenPos.x+Hud_GetWidth(file.opticsbutton)*2, file.screenPos.y )	
		Hud_SetPos( file.SniperStockstext, file.screenPos.x+(buttonsDesiredWidthTop*2)+TextButtonsOnTopOffset, file.screenPos.y )//with additional offset
		
		Hud_SetPos( file.stocksbutton, file.screenPos.x+Hud_GetWidth(file.opticsbutton)*3, file.screenPos.y )
		Hud_SetPos( file.stockstext, file.screenPos.x+(buttonsDesiredWidthTop*3)+TextButtonsOnTopOffset, file.screenPos.y )
	}
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

void function SetSniperStockAttachmentSelected(var button)
{
	for(int i=0; i<file.SniperStocks.len(); i++){
		var element = file.SniperStocks[i]
		if(element != button)
			Hud_SetSelected(element, false)
		else
			file.desiredSniperStock = i
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
	Hud_SetSelected(file.hopupsbutton, false)
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
	foreach(var element in file.SniperStocks)
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
	Hud_SetPos( file.SMGOptics[0], file.xstep+file.screenPos.x, file.screenPos.y+file.ystep-10 )
	RuiSetImage( Hud_GetRui(file.SMGOptics[0]), "iconImage", $"rui/weapon_icons/attachments/hcog" )
	RuiSetInt( Hud_GetRui(file.SMGOptics[0]), "lootTier", 1 )
	file.visibleAttachmentsBoxElements.append(file.SMGOptics[0])
	
	Hud_SetVisible(file.SMGOptics[1], true)
	Hud_SetPos( file.SMGOptics[1], file.xstep+file.screenPos.x+file.ancho, file.screenPos.y+file.ystep-10 )
	RuiSetImage( Hud_GetRui(file.SMGOptics[1]), "iconImage", $"rui/weapon_icons/attachments/holosight" )
	RuiSetInt( Hud_GetRui(file.SMGOptics[1]), "lootTier", 1 )
	file.visibleAttachmentsBoxElements.append(file.SMGOptics[1])
	
	Hud_SetVisible(file.SMGOptics[2], true)
	Hud_SetPos( file.SMGOptics[2], file.xstep+file.screenPos.x+(file.ancho*2), file.screenPos.y+file.ystep-10 )
	RuiSetImage( Hud_GetRui(file.SMGOptics[2]), "iconImage", $"rui/weapon_icons/attachments/1x_2x_variable_holosight" )	
	RuiSetInt( Hud_GetRui(file.SMGOptics[2]), "lootTier", 2 )
	file.visibleAttachmentsBoxElements.append(file.SMGOptics[2])
	
	Hud_SetVisible(file.SMGOptics[3], true)
	Hud_SetPos( file.SMGOptics[3], file.xstep+file.screenPos.x+(file.ancho*3), file.screenPos.y+file.ystep-10 )
	RuiSetImage( Hud_GetRui(file.SMGOptics[3]), "iconImage", $"rui/weapon_icons/attachments/hcog_bruiser")	
	RuiSetInt( Hud_GetRui(file.SMGOptics[3]), "lootTier", 2 )
	file.visibleAttachmentsBoxElements.append(file.SMGOptics[3])
	
	Hud_SetVisible(file.SMGOptics[4], true)
	Hud_SetPos( file.SMGOptics[4], file.xstep+file.screenPos.x+(file.ancho*4), file.screenPos.y+file.ystep-10 )
	RuiSetImage( Hud_GetRui(file.SMGOptics[4]), "iconImage", $"rui/weapon_icons/attachments/hcog_ranged" )
	RuiSetInt( Hud_GetRui(file.SMGOptics[4]), "lootTier", 3 )
	file.visibleAttachmentsBoxElements.append(file.SMGOptics[4])

	Hud_SetVisible(file.SMGOptics[5], true)
	Hud_SetPos( file.SMGOptics[5], file.xstep+file.screenPos.x+(file.ancho*5), file.screenPos.y+file.ystep-10 )
	RuiSetImage( Hud_GetRui(file.SMGOptics[5]), "iconImage", $"rui/weapon_icons/attachments/2x_4x_variable_aog" )
	RuiSetInt( Hud_GetRui(file.SMGOptics[5]), "lootTier", 3 )
	file.visibleAttachmentsBoxElements.append(file.SMGOptics[5])

	if(file.desiredweapon == "mp_weapon_defender" || file.desiredweapon == "mp_weapon_dmr") 
	{
		Hud_SetVisible(file.SMGOptics[6], true)
		Hud_SetPos( file.SMGOptics[6], file.xstep+file.screenPos.x+file.ancho+(file.ancho/2), file.screenPos.y+file.ystep+75 )
		RuiSetImage( Hud_GetRui(file.SMGOptics[6]), "iconImage", $"rui/weapon_icons/attachments/4x_sniper" )
		RuiSetInt( Hud_GetRui(file.SMGOptics[6]), "lootTier", 3 )
		file.visibleAttachmentsBoxElements.append(file.SMGOptics[6])
		
		Hud_SetVisible(file.SMGOptics[7], true)
		Hud_SetPos( file.SMGOptics[7], file.xstep+file.screenPos.x+file.ancho*2+(file.ancho/2), file.screenPos.y+file.ystep+75 )
		RuiSetImage( Hud_GetRui(file.SMGOptics[7]), "iconImage", $"rui/weapon_icons/attachments/4x_8x_variable_sniper" )
		RuiSetInt( Hud_GetRui(file.SMGOptics[7]), "lootTier", 3 )
		file.visibleAttachmentsBoxElements.append(file.SMGOptics[7])

		Hud_SetVisible(file.SMGOptics[8], true)
		Hud_SetPos( file.SMGOptics[8], file.xstep+file.screenPos.x+file.ancho*3+(file.ancho/2), file.screenPos.y+file.ystep+75 )
		RuiSetImage( Hud_GetRui(file.SMGOptics[8]), "iconImage", $"rui/weapon_icons/attachments/8x_threat_sniper" )
		RuiSetInt( Hud_GetRui(file.SMGOptics[8]), "lootTier", 4 )
		file.visibleAttachmentsBoxElements.append(file.SMGOptics[8])
	}
}

void function SMGBarrels(var button)
{
	SetOtherTabsContentInvisible()
	SetButtonsOnTopUnselected()
	Hud_SetSelected(file.barrelsbutton, true)
	
	Hud_SetVisible(file.SMGBarrels[0], true)
	Hud_SetPos( file.SMGBarrels[0], file.xstep+file.screenPos.x+file.ancho+(file.ancho/2), file.screenPos.y+file.ystep )
	RuiSetImage( Hud_GetRui(file.SMGBarrels[0]), "iconImage", $"rui/pilot_loadout/mods/barrel_stabilizer" )
	RuiSetInt( Hud_GetRui(file.SMGBarrels[0]), "lootTier", 1 )
	file.visibleAttachmentsBoxElements.append(file.SMGBarrels[0])
	
	Hud_SetVisible(file.SMGBarrels[1], true)
	Hud_SetPos( file.SMGBarrels[1], file.xstep+file.screenPos.x+(file.ancho*2)+(file.ancho/2), file.screenPos.y+file.ystep )
	RuiSetImage( Hud_GetRui(file.SMGBarrels[1]), "iconImage", $"rui/pilot_loadout/mods/barrel_stabilizer" )
	RuiSetInt( Hud_GetRui(file.SMGBarrels[1]), "lootTier", 2 )
	file.visibleAttachmentsBoxElements.append(file.SMGBarrels[1])
	
	Hud_SetVisible(file.SMGBarrels[2], true)
	Hud_SetPos( file.SMGBarrels[2], file.xstep+file.screenPos.x+(file.ancho*3)+(file.ancho/2), file.screenPos.y+file.ystep )
	RuiSetImage( Hud_GetRui(file.SMGBarrels[2]), "iconImage", $"rui/pilot_loadout/mods/barrel_stabilizer" )	
	RuiSetInt( Hud_GetRui(file.SMGBarrels[2]), "lootTier", 3 )
	file.visibleAttachmentsBoxElements.append(file.SMGBarrels[2])
	if(file.desiredweapon == "mp_weapon_dmr") 
	{
		Hud_SetPos( file.SMGBarrels[0], file.xstep+file.screenPos.x+file.ancho+(file.ancho/2), file.screenPos.y+file.ystep+17 )
		Hud_SetPos( file.SMGBarrels[1], file.xstep+file.screenPos.x+(file.ancho*2)+(file.ancho/2), file.screenPos.y+file.ystep+17 )
		Hud_SetPos( file.SMGBarrels[2], file.xstep+file.screenPos.x+(file.ancho*3)+(file.ancho/2), file.screenPos.y+file.ystep+17 )
	}
}

void function SniperStocks(var button)
{
	SetOtherTabsContentInvisible()
	SetButtonsOnTopUnselected()
	Hud_SetSelected(file.hopupsbutton, true)
	
	Hud_SetVisible(file.SniperStocks[0], true)
	Hud_SetPos( file.SniperStocks[0], file.xstep+file.screenPos.x+(file.ancho*2), file.screenPos.y+file.ystep )
	if(file.desiredweapon == "mp_weapon_g2")
		RuiSetImage( Hud_GetRui(file.SniperStocks[0]), "iconImage", $"rui/pilot_loadout/mods/empty_hopup_doubletap" )
	else if (file.desiredweapon == "mp_weapon_doubletake")
		RuiSetImage( Hud_GetRui(file.SniperStocks[0]), "iconImage", $"rui/pilot_loadout/mods/empty_hopup_em_choke" )
	RuiSetInt( Hud_GetRui(file.SniperStocks[0]), "lootTier", 1 )
	file.visibleAttachmentsBoxElements.append(file.SniperStocks[0])
	
	Hud_SetVisible(file.SniperStocks[1], true)
	Hud_SetPos( file.SniperStocks[1], file.xstep+file.screenPos.x+(file.ancho*3), file.screenPos.y+file.ystep )
	if(file.desiredweapon == "mp_weapon_g2")
		RuiSetImage( Hud_GetRui(file.SniperStocks[1]), "iconImage", $"rui/pilot_loadout/mods/hopup_doubletap" )
	else if (file.desiredweapon == "mp_weapon_doubletake")
		RuiSetImage( Hud_GetRui(file.SniperStocks[1]), "iconImage", $"rui/pilot_loadout/mods/hopup_em_choke" )
	RuiSetInt( Hud_GetRui(file.SniperStocks[1]), "lootTier", 4 )
	file.visibleAttachmentsBoxElements.append(file.SniperStocks[1])
}

void function SMGStocks(var button)
{
	SetOtherTabsContentInvisible()
	SetButtonsOnTopUnselected()
	Hud_SetSelected(file.stocksbutton, true)
	
	Hud_SetVisible(file.SMGStocks[0], true)
	Hud_SetPos( file.SMGStocks[0], file.xstep+file.screenPos.x+file.ancho+(file.ancho/2), file.screenPos.y+file.ystep )
	RuiSetImage( Hud_GetRui(file.SMGStocks[0]), "iconImage", $"rui/pilot_loadout/mods/sniper_stock" )
	RuiSetInt( Hud_GetRui(file.SMGStocks[0]), "lootTier", 1 )
	file.visibleAttachmentsBoxElements.append(file.SMGStocks[0])
	
	Hud_SetVisible(file.SMGStocks[1], true)
	Hud_SetPos( file.SMGStocks[1], file.xstep+file.screenPos.x+(file.ancho*2)+(file.ancho/2), file.screenPos.y+file.ystep )
	RuiSetImage( Hud_GetRui(file.SMGStocks[1]), "iconImage", $"rui/pilot_loadout/mods/sniper_stock" )
	RuiSetInt( Hud_GetRui(file.SMGStocks[1]), "lootTier", 2 )
	file.visibleAttachmentsBoxElements.append(file.SMGStocks[1])
	
	Hud_SetVisible(file.SMGStocks[2], true)
	Hud_SetPos( file.SMGStocks[2], file.xstep+file.screenPos.x+(file.ancho*3)+(file.ancho/2), file.screenPos.y+file.ystep )
	RuiSetImage( Hud_GetRui(file.SMGStocks[2]), "iconImage", $"rui/pilot_loadout/mods/sniper_stock" )	
	RuiSetInt( Hud_GetRui(file.SMGStocks[2]), "lootTier", 3 )
	file.visibleAttachmentsBoxElements.append(file.SMGStocks[2])
	
	if(file.desiredweapon == "mp_weapon_defender" || file.desiredweapon == "mp_weapon_dmr") 
	{
	Hud_SetPos( file.SMGStocks[0], file.xstep+file.screenPos.x+file.ancho+(file.ancho/2), file.screenPos.y+file.ystep+17 )	
	Hud_SetPos( file.SMGStocks[1], file.xstep+file.screenPos.x+(file.ancho*2)+(file.ancho/2), file.screenPos.y+file.ystep+17 )
	Hud_SetPos( file.SMGStocks[2], file.xstep+file.screenPos.x+(file.ancho*3)+(file.ancho/2), file.screenPos.y+file.ystep+17 )
	}
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
	RunClientScript( "UIToClient_MenuGiveWeaponWithAttachments", file.desiredweapon, file.desiredOptic, file.desiredBarrel, file.desiredStock, file.desiredSniperStock, file.weapontype )
}

void function BuyG7(var button)
{
	CleanAllButtons()	
	RuiSetInt( Hud_GetRui( button ), "status", eFriendStatus.ONLINE_INGAME )
	RunClientScript( "UIToClient_MenuGiveWeapon", "mp_weapon_g2" )
}

void function BuyLongbow(var button)
{
	CleanAllButtons()	
	RuiSetInt( Hud_GetRui( button ), "status", eFriendStatus.ONLINE_INGAME )
	RunClientScript( "UIToClient_MenuGiveWeapon", "mp_weapon_dmr" )
}

void function BuyTripleTake(var button)
{
	CleanAllButtons()	
	RuiSetInt( Hud_GetRui( button ), "status", eFriendStatus.ONLINE_INGAME )
	RunClientScript( "UIToClient_MenuGiveWeapon", "mp_weapon_doubletake" )
}

void function BuyChargeRifle(var button)
{
	CleanAllButtons()	
	RuiSetInt( Hud_GetRui( button ), "status", eFriendStatus.ONLINE_INGAME )
	RunClientScript( "UIToClient_MenuGiveWeapon", "mp_weapon_defender" )
}

void function BuyKraber(var button)
{
	CleanAllButtons()	
	RuiSetInt( Hud_GetRui( button ), "status", eFriendStatus.ONLINE_INGAME )
	RunClientScript( "UIToClient_MenuGiveWeapon", "mp_weapon_sniper" )
}
