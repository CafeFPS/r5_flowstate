untyped

global function InitFooterOptions
global function AddMenuFooterOption
global function AddPanelFooterOption
global function UpdateFooterOptions
global function UpdateFooterLabels
global function SetFooterText
global function ClearMenuFooterOptions

const int MAX_LEFT_FOOTERS = 8
const int MAX_RIGHT_FOOTERS = 8

void function InitFooterOptions()
{
	RegisterSignal( "EndFooterUpdateFuncs" )

	foreach ( menu in uiGlobal.allMenus )
	{
		array<var> sizerElems = GetElementsByClassname( menu, "LeftFooterSizerClass" )
		foreach ( elem in sizerElems )
			Hud_EnableKeyBindingIcons( elem )

		#if PC_PROG
			array<var> buttonElems = GetElementsByClassname( menu, "LeftRuiFooterButtonClass" )
			buttonElems.extend( GetElementsByClassname( menu, "RightRuiFooterButtonClass" ) )
			foreach ( elem in buttonElems )
				Hud_AddEventHandler( elem, UIE_CLICK, OnFooterOption_Activate )
		#endif // PC_PROG
	}

	thread UpdateFooterSizes()
}

InputDef function AddMenuFooterOption( var menu, int alignment, int input, bool clickable, string gamepadLabel, string mouseLabel = "", void functionref( var ) activateFunc = null, bool functionref() conditionCheckFunc = null, void functionref( InputDef ) updateFunc = null )
{
	//if ( input == BUTTON_A )
	//	Assert( activateFunc == null || mouseLabel != "", "Footer input BUTTON_A has a non-null activateFunc! It should always be null to avoid conflicting with code button event handlers." )

	if ( input == BUTTON_B )
	{
		if ( activateFunc == null )
		{
			//printt( "----------activateFunc is null----------" )
			activateFunc = PCBackButton_Activate
			//printt( "----------activateFunc is now----------", string(activateFunc) )
		}

		//Assert( activateFunc == PCBackButton_Activate, "Footer input BUTTON_B can only use PCBackButton_Activate() for activateFunc!" )
	}

	array<InputDef> footerData = uiGlobal.menuData[ menu ].footerData

	foreach ( entry in footerData )
	{
		// For mouse we need to execute a func even if just to call UICodeCallback_NavigateBack
		// Code automatically calls this in every other case

		if ( entry.input == input )
			Assert( entry.conditionCheckFunc != null, "Duplicate footer input found with no conditional! Duplicates require a conditional." )
	}

	InputDef data
	data.alignment = alignment
	data.input = input
	data.clickable = clickable
	data.gamepadLabel = gamepadLabel
	data.mouseLabel = mouseLabel
	data.activateFunc = activateFunc
	data.conditionCheckFunc = conditionCheckFunc
	data.updateFunc = updateFunc

	footerData.append( data )

	return data
}


void function ClearMenuFooterOptions( var menu )
{
	uiGlobal.menuData[ menu ].footerData.clear()
}

InputDef function AddPanelFooterOption( var panel, int alignment, int input, bool clickable, string gamepadLabel, string mouseLabel = "", void functionref( var ) activateFunc = null, bool functionref() conditionCheckFunc = null, void functionref( InputDef ) updateFunc = null )
{
	//if ( input == BUTTON_A )
	//	Assert( activateFunc == null || mouseLabel != "", "Footer input BUTTON_A has a non-null activateFunc! It should always be null to avoid conflicting with code button event handlers." )

	if ( input == BUTTON_B )
	{
		if ( activateFunc == null )
		{
			//printt( "----------activateFunc is null----------" )
			activateFunc = PCBackButton_Activate
			//printt( "----------activateFunc is now----------", string(activateFunc) )
		}

		Assert( activateFunc == PCBackButton_Activate, "Footer input BUTTON_B can only use PCBackButton_Activate() for activateFunc!" )
	}

	array<InputDef> footerData = uiGlobal.panelData[ panel ].footerData

	foreach ( entry in footerData )
	{
		// For mouse we need to execute a func even if just to call UICodeCallback_NavigateBack
		// Code automatically calls this in every other case

		if ( entry.input == input )
			Assert( entry.conditionCheckFunc != null, "Duplicate footer input found with no conditional! Duplicates require a conditional." )
	}

	InputDef data
	data.alignment = alignment
	data.input = input
	data.clickable = clickable
	data.gamepadLabel = gamepadLabel
	data.mouseLabel = mouseLabel
	data.activateFunc = activateFunc
	data.conditionCheckFunc = conditionCheckFunc
	data.updateFunc = updateFunc

	footerData.append( data )

	return data
}

void function ClearRegisteredInputs()
{
	foreach ( menu in uiGlobal.allMenus )
	{
		table<int, void functionref( var )> registeredInput = uiGlobal.menuData[ menu ].registeredInput
		array<int> deleteList

		foreach ( int input, void functionref( var ) func in registeredInput )
		{
			if ( input != BUTTON_B && input != -1 ) // Handled by code
			{
				//printt( "----------Deregistering input:", input, "func:", string( func ) )
				DeregisterButtonPressedCallback( input, func )
			}

			deleteList.append( input ) // Can't delete while iterating, so make a list and delete below
		}

		foreach ( input in deleteList )
			delete registeredInput[ input ]
	}

	foreach ( panel in uiGlobal.allPanels )
	{
		table<int, void functionref( var )> registeredInput = uiGlobal.panelData[ panel ].registeredInput
		array<int> deleteList

		foreach ( int input, void functionref( var ) func in registeredInput )
		{
			if ( input != BUTTON_B && input != -1 ) // Handled by code
			{
				//printt( "----------Deregistering input:", input, "func:", string( func ) )
				DeregisterButtonPressedCallback( input, func )
			}

			deleteList.append( input ) // Can't delete while iterating, so make a list and delete below
		}

		foreach ( input in deleteList )
			delete registeredInput[ input ]
	}
}

void function UpdateFooter_Internal( bool shouldUpdateInputCallbacks )
{
	var menu = GetActiveMenu()
	if ( menu == null )
		return

	var panel
	if ( uiGlobal.activePanels.len() > 0 )
	{
		var topActivePanel = uiGlobal.activePanels.top()
		var parentMenu = GetParentMenu( topActivePanel )
		if ( parentMenu == menu )
			panel = topActivePanel
	}

	// Clear all existing registered input
	if ( shouldUpdateInputCallbacks )
	{
		ClearRegisteredInputs()
		Signal( uiGlobal.signalDummy, "EndFooterUpdateFuncs" )
	}

	if ( !Hud_HasChild( menu, "FooterButtons" ) ) //
		return

	array<InputDef> footerData
	table<int, void functionref( var )> registeredInput
	if ( panel != null )
	{
		footerData = uiGlobal.panelData[ panel ].footerData
		//printt( Hud_GetHudName( panel ), footerData.len() )
		registeredInput = uiGlobal.panelData[ panel ].registeredInput
	}
	else
	{
		footerData = uiGlobal.menuData[ menu ].footerData
		registeredInput = uiGlobal.menuData[ menu ].registeredInput
	}

	array<int> leftGamepadInfo
	array<int> leftMouseInfo
	array<int> rightGamepadInfo
	array<int> rightMouseInfo
	int lastValidInput = -1

	for ( int i = 0; i < footerData.len(); i++ )
	{
		int input = footerData[i].input
		if ( input == lastValidInput )
			continue

		bool isValid = true
		if ( footerData[i].conditionCheckFunc != null )
			isValid = footerData[i].conditionCheckFunc()

		footerData[i].lastConditionCheckResult = isValid

		if ( isValid )
		{
			if ( shouldUpdateInputCallbacks )
			{
				if ( input in registeredInput ) // TODO: May always be empty, double-check and remove if so
				{
					if ( input != BUTTON_B && input != -1 ) // Handled by code
					{
						DeregisterButtonPressedCallback( input, registeredInput[ input ] )
						//printt( "----------DeregisterButtonPressedCallback(", input, ",", string( registeredInput[ input ] ), ")" )
					}

					delete registeredInput[ input ]
				}

				void functionref( var ) activateFunc = footerData[i].activateFunc
				if ( activateFunc != null )
				{
					if ( input != BUTTON_B && input != -1 ) // Handled by code
					{
						RegisterButtonPressedCallback( input, activateFunc )
						//printt( "----------RegisterButtonPressedCallback(", input, ",", string( activateFunc ), ")" )
					}

					registeredInput[ input ] <- activateFunc
				}
			}

			//printt( "Setting up menu", menu.GetHudName(), footerData[i].gamepadLabel, footerData[i].mouseLabel )

			Assert( footerData[i].alignment == LEFT || footerData[i].alignment == RIGHT )

			if ( footerData[i].gamepadLabel != "" ) // Allow mouse only display. Ex: On PC we sometimes need to show instructions which do not have a gamepad equivalent.
			{
				if ( footerData[i].alignment == LEFT )
				{
					leftGamepadInfo.append( i )
					Assert( leftGamepadInfo.len() <= MAX_LEFT_FOOTERS, "More than MAX_LEFT_FOOTERS (" + MAX_LEFT_FOOTERS + ") gamepad options added to menu: " + Hud_GetHudName( menu ) )
				}
				else
				{
					rightGamepadInfo.append( i )
					Assert( rightGamepadInfo.len() <= MAX_RIGHT_FOOTERS, "More than MAX_RIGHT_FOOTERS (" + MAX_RIGHT_FOOTERS + ") gamepad options added to menu: " + Hud_GetHudName( menu ) )
				}
			}

			if ( footerData[i].mouseLabel != "" ) // Allow gamepad only display. Ex: Don't want to show "(Mouse 1) Select" on all menus as the equivalent of "(A) Select"
			{
				if ( footerData[i].alignment == LEFT )
				{
					leftMouseInfo.append( i )
					Assert( leftMouseInfo.len() <= MAX_LEFT_FOOTERS, "More than MAX_LEFT_FOOTERS (" + MAX_LEFT_FOOTERS + ") mouse options added to menu: " + Hud_GetHudName( menu ) )
				}
				else
				{
					rightMouseInfo.append( i )
					Assert( rightMouseInfo.len() <= MAX_RIGHT_FOOTERS, "More than MAX_RIGHT_FOOTERS (" + MAX_RIGHT_FOOTERS + ") mouse options added to menu: " + Hud_GetHudName( menu ) )
				}
			}

			lastValidInput = input
		}
	}

	array<var> leftElems = GetElementsByClassname( menu, "LeftRuiFooterButtonClass" )
	UpdateFooterElems( menu, leftElems, footerData, leftGamepadInfo, leftMouseInfo )

	array<var> rightElems = GetElementsByClassname( menu, "RightRuiFooterButtonClass" )
	UpdateFooterElems( menu, rightElems, footerData, rightGamepadInfo, rightMouseInfo )
}

void function UpdateFooterOptions()
{
	UpdateFooter_Internal( true )
}

void function UpdateFooterLabels()
{
	UpdateFooter_Internal( false )
}

void function UpdateFooterElems( var menu, array<var> elems, array<InputDef> footerData, array<int> gamepadInfo, array<int> mouseInfo )
{
	bool isControllerModeActive = IsControllerModeActive()

	array<int> info
	if ( isControllerModeActive )
		info = gamepadInfo
	else
		info = mouseInfo

	InputDef footerDataEntry
	int lookUpIndex = 0

	foreach ( index, elem in elems )
	{
		if ( index < info.len() )
		{
			footerDataEntry = footerData[ info[ lookUpIndex ] ]

			if ( footerDataEntry.lastConditionCheckResult && footerDataEntry.updateFunc != null )
			{
				footerDataEntry.vguiElem = elem
				thread footerDataEntry.updateFunc( footerDataEntry )
			}
			else
			{
				string text
				if ( isControllerModeActive )
					text = footerDataEntry.gamepadLabel
				else
					text = footerDataEntry.mouseLabel

				SetFooterText( menu, footerDataEntry.alignment, index, Localize( text ) )
			}

			// TEMPHACK: .s is bad
			elem.s.input <- footerDataEntry.input

			if ( isControllerModeActive || !footerDataEntry.clickable )
				Hud_SetEnabled( elem, false )
			else
				Hud_SetEnabled( elem, true )

			lookUpIndex++
		}
		else
		{
			Hud_Hide( elem )

			if ( "input" in elem.s )
				delete elem.s.input
		}
	}
}


void function SetFooterText( var menu, int alignment, int index, string text )
{
	Assert( alignment == LEFT || alignment == RIGHT )

	array<var> vguiElems

	if ( alignment == LEFT )
	{
		array<var> sizerElems = GetElementsByClassname( menu, "LeftFooterSizerClass" ) // TODO: Remove when old dialogs are gone
		if ( index < sizerElems.len() )
			Hud_SetText( sizerElems[index], text )

		vguiElems = GetElementsByClassname( menu, "LeftRuiFooterButtonClass" )
	}
	else
	{
		vguiElems = GetElementsByClassname( menu, "RightRuiFooterButtonClass" )
	}

	var vguiButton = vguiElems[index]
	Hud_SetText( vguiButton, text )
	Hud_Show( vguiButton )
}

void function UpdateFooterSizes()
{
	while ( true )
	{
		var activeMenu = GetActiveMenu()

		if ( activeMenu != null )
		{
			if ( Hud_HasChild( activeMenu, "FooterButtons" ) )
			{
				var panel = Hud_GetChild( activeMenu, "FooterButtons" )
				InitButtonRCP( Hud_GetChild( panel, "LeftRuiFooterButton0" ) )
				InitButtonRCP( Hud_GetChild( panel, "LeftRuiFooterButton1" ) )
			}
			else if ( Hud_HasChild( activeMenu, "DialogFooterButtons" ) ) // Old R2 style dialog footers which are being deprecated
			{
				var panel = Hud_GetChild( activeMenu, "DialogFooterButtons" )
				Hud_SetWidth( Hud_GetChild( panel, "LeftRuiFooterButton0" ), Hud_GetWidth( Hud_GetChild( panel, "LeftFooterSizer0" ) ) )
				Hud_SetWidth( Hud_GetChild( panel, "LeftRuiFooterButton1" ), Hud_GetWidth( Hud_GetChild( panel, "LeftFooterSizer1" ) ) )
			}
		}

		WaitFrame()
	}
}

void function OnFooterOption_Activate( var button )
{
	// TEMPHACK: .s is bad
	if ( "input" in button.s )
	{
		int input = expect int( button.s.input )
		var menu = GetParentMenu( button )

		void functionref( var ) activateFunc = null

		foreach ( var panel in uiGlobal.activePanels )
		{
			if ( GetParentMenu( panel ) != menu )
				continue

			if ( input in uiGlobal.panelData[ panel ].registeredInput )
			{
				Assert( activateFunc == null, "Footer conflict" )
				activateFunc = uiGlobal.panelData[ panel ].registeredInput[ input ]
			}
		}

		if ( input in uiGlobal.menuData[ menu ].registeredInput )
		{
			Assert( activateFunc == null, "Footer conflict" )
			activateFunc = uiGlobal.menuData[ menu ].registeredInput[ input ]
		}

		if ( activateFunc != null )
		{
			//printt( "activateFunc: " + string( activateFunc ) )
			activateFunc( button )
		}
	}
}


