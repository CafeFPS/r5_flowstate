untyped

global function ComboButtons_Create
global function ComboButtons_Finalize
global function AddComboButtonHeader
global function AddComboButton

global function ComboButton_SetText

global function SetComboButtonHeaderTitle
global function ComboButton_SetNewMail
global function ComboButton_SetNew
global function ComboButton_SetHasPurchase

global function SetComboButtonHeaderTint

global function ComboButtons_ResetColumnFocus

#if(DEV)
global function DEV_GetComboStruct
#endif

global const int MAX_COMBO_BUTTON_ROWS = 10
global const int MAX_COMBO_BUTTON_COLS = 4

const float TRANSITION_ANIM_TIME = 0.016667 * 3


global struct ComboButtonData
{
	var button
	int rowIndex
	int colIndex
	string text
}

global struct ComboStruct
{
	var menu

	int collapsedHeight = 1
	int expandedHeight = 1

	bool sharedColumnFocus = false
	int numRows = 0

	//
	ComboButtonData[MAX_COMBO_BUTTON_COLS][MAX_COMBO_BUTTON_ROWS] comboButtonGrid
	var[MAX_COMBO_BUTTON_ROWS] rowHeaders
	int[MAX_COMBO_BUTTON_ROWS] defaultColumnIndex

	var navUpButton = null
	var navDownButton = null
	var navRightButton = null
	bool navUpButtonDisabled = false
	bool navDownButtonDisabled = false
}

struct
{
	table<string, ComboStruct> comboMenuData
} file

ComboStruct function ComboButtons_Create( var menu )
{
	ComboStruct comboStruct
	comboStruct.menu = menu

	string menuName = Hud_GetHudName( menu )
	file.comboMenuData[menuName] <- comboStruct

	comboStruct.sharedColumnFocus = false

	return comboStruct
}

void function ComboButtons_Finalize( ComboStruct comboStruct )
{
	float maxX = 0

	for ( int row = 0; row < MAX_COMBO_BUTTON_ROWS; row++ )
	{
		for ( int col = 0; col < MAX_COMBO_BUTTON_COLS; col++ )
		{
			if ( comboStruct.comboButtonGrid[row][col].button == null )
				continue

			if ( col > 0 )
			{
				float buttonX = float( Hud_GetAbsX( comboStruct.comboButtonGrid[row][col].button ) + Hud_GetWidth( comboStruct.comboButtonGrid[row][col].button ) )
				if ( buttonX > maxX )
				{
					maxX = buttonX
				}
			}
		}
	}

	UpdateButtonNav( comboStruct )

	for ( int row = 0; row < MAX_COMBO_BUTTON_ROWS; row++ )
	{
		for ( int col = 0; col < MAX_COMBO_BUTTON_COLS; col++ )
		{
			var button = comboStruct.comboButtonGrid[row][col].button

			if ( button == null )
				continue

			if ( col == 0 )
			{
				Hud_SetY( button, -(comboStruct.expandedHeight * row) )
			}

			//
			Hud_SetBaseSize( button, Hud_GetWidth( button ), Hud_GetHeight( button ) )

			if ( col == MAX_COMBO_BUTTON_COLS - 1 || comboStruct.comboButtonGrid[row][col+1].button == null )
			{
				float endX = float( Hud_GetAbsX( button ) + Hud_GetWidth( button ) )
				if ( endX < maxX )
				{
					float width = float( Hud_GetWidth( button ) )
					Hud_SetWidth( button, width + (maxX - endX) )
				}
			}
		}
	}

	if ( comboStruct.rowHeaders[0] == null )
		comboStruct.collapsedHeight = comboStruct.expandedHeight

	for ( int row = 0; row < MAX_COMBO_BUTTON_ROWS; row++ )
	{
		if ( comboStruct.rowHeaders[row] != null )
			Hud_SetHeight( comboStruct.rowHeaders[row], comboStruct.expandedHeight )
	}


	if ( comboStruct.sharedColumnFocus )
	{
		int minCol = -1
		int maxCol = 0
		for ( int row = 0; row < MAX_COMBO_BUTTON_ROWS; row++ )
		{
			for ( int col = 0; col < MAX_COMBO_BUTTON_COLS; col++ )
			{
				if ( comboStruct.comboButtonGrid[row][col].button == null )
					continue

				if ( minCol < 0 || col < minCol )
					minCol = col

				if ( col > maxCol )
					maxCol = col
			}
		}

//
	}

	array<var> elements = GetElementsByClassname( GetParentMenu( comboStruct.menu ), "ComboButtonAlways" )
	foreach ( element in elements )
	{
		var parentButton = Hud_GetParent( element )
		if ( !("alwaysChildren" in parentButton.s) ) //
			continue

		parentButton.s.alwaysChildren.append( element )
		if ( Hud_IsRuiPanel( element ) )
		{
			RuiSetString( Hud_GetRui( element ), "buttonText", parentButton.s.text )
		}
	}

	OnComboButtonGetFocus( comboStruct.comboButtonGrid[0][0].button )
}


ComboStruct function ComboButton_GetComboStruct( var button )
{
	string parentMenuName = expect string( button.s.parentMenuName )
	ComboStruct comboStruct = file.comboMenuData[parentMenuName]

	return comboStruct
}


float function ComboButtons_GetMaxX( ComboStruct comboStruct )
{
	float maxX = 0
	for ( int row = 0; row < MAX_COMBO_BUTTON_ROWS; row++ )
	{
		for ( int col = 0; col < MAX_COMBO_BUTTON_COLS; col++ )
		{
			if ( comboStruct.comboButtonGrid[row][col].button == null )
				continue

			if ( col > 0 )
			{
				float buttonX = float( Hud_GetAbsX( comboStruct.comboButtonGrid[row][col].button ) + Hud_GetWidth( comboStruct.comboButtonGrid[row][col].button ) )
				if ( buttonX > maxX )
				{
					maxX = buttonX
				}
			}
		}
	}

	return maxX
}


void function ComboButton_RefreshWidth( var comboButton )
{
	ComboStruct comboStruct = ComboButton_GetComboStruct( comboButton )
	float maxX = ComboButtons_GetMaxX( comboStruct )

	for ( int row = 0; row < MAX_COMBO_BUTTON_ROWS; row++ )
	{
		for ( int col = 0; col < MAX_COMBO_BUTTON_COLS; col++ )
		{
			var button = comboStruct.comboButtonGrid[row][col].button

			if ( button != comboButton )
				continue

			if ( col == MAX_COMBO_BUTTON_COLS - 1 || comboStruct.comboButtonGrid[row][col+1].button == null )
			{
				float endX = float( Hud_GetAbsX( button ) + Hud_GetWidth( button ) )
				if ( endX < maxX )
				{
					float width = float( Hud_GetWidth( button ) )
					Hud_SetWidth( button, width + (maxX - endX) )
				}
			}
		}
	}
}


void function ComboButton_SetText( var button, string buttonText )
{
	if ( Hud_IsLabel( button ) )
		Hud_SetText( button, buttonText )

	if ( "alwaysChildren" in button.s )
	{
		foreach ( var element in button.s.alwaysChildren )
		{
			if ( !Hud_IsRuiPanel( element ) )
				continue

			RuiSetString( Hud_GetRui( element ), "buttonText", buttonText )
		}
	}

	ComboButton_RefreshWidth( button )
}

void function ComboButton_SetNewMail( var button, bool newMessages )
{
	if ( "alwaysChildren" in button.s )
	{
		foreach ( var element in button.s.alwaysChildren )
		{
			if ( !Hud_IsRuiPanel( element ) )
				continue

			RuiSetBool( Hud_GetRui( element ), "isNewMail", newMessages )
		}
	}
}

void function ComboButton_SetNew( var button, bool isNew )
{
	if ( "alwaysChildren" in button.s )
	{
		foreach ( var element in button.s.alwaysChildren )
		{
			if ( !Hud_IsRuiPanel( element ) )
				continue

			RuiSetBool( Hud_GetRui( element ), "isNew", isNew )
		}
	}
}

void function ComboButton_SetHasPurchase( var button, bool hasPurchase )
{
	if ( "alwaysChildren" in button.s )
	{
		foreach ( var element in button.s.alwaysChildren )
		{
			if ( !Hud_IsRuiPanel( element ) )
				continue

			RuiSetBool( Hud_GetRui( element ), "hasPurchase", hasPurchase )
		}
	}
}


void function SetComboButtonHeaderTitle( var menu, int rowIndex, string titleText )
{
	string menuName = Hud_GetHudName( menu )
	Assert( menuName in file.comboMenuData )

	ComboStruct comboStruct = file.comboMenuData[menuName]

	if ( !Hud_IsRuiPanel( comboStruct.rowHeaders[rowIndex] ) )
		return

	var rui = Hud_GetRui( comboStruct.rowHeaders[rowIndex] )
	RuiSetString( rui, "titleText", titleText )
}

void function SetComboButtonHeaderTint( var menu, int rowIndex, bool state )
{
	string menuName = Hud_GetHudName( menu )
	Assert( menuName in file.comboMenuData )

	ComboStruct comboStruct = file.comboMenuData[menuName]

	if ( !Hud_IsRuiPanel( comboStruct.rowHeaders[rowIndex] ) )
		return

	var rui = Hud_GetRui( comboStruct.rowHeaders[rowIndex] )
	RuiSetBool( rui, "isTitleTint", state )
}


var function AddComboButtonHeader( ComboStruct comboStruct, int rowIndex, string titleText = "" )
{
	comboStruct.rowHeaders[rowIndex] = Hud_GetChild( comboStruct.menu, "TitleRow" + rowIndex )
	Hud_SetVisible( comboStruct.rowHeaders[rowIndex], true )

	var rui = Hud_GetRui( comboStruct.rowHeaders[rowIndex] )
	RuiSetString( rui, "titleText", titleText )

	comboStruct.collapsedHeight = Hud_GetHeight( comboStruct.rowHeaders[rowIndex] )

	return comboStruct.rowHeaders[rowIndex]
}


var function AddComboButton( ComboStruct comboStruct, int rowIndex, int colIndex, string text = "" )
{
	ComboButtonData comboButtonData
	var button = Hud_GetChild( comboStruct.menu, "ButtonRow" + rowIndex + "x" + colIndex )

	Hud_SetVisible( button, true )

	button.s.rowIndex <- rowIndex
	button.s.colIndex <- colIndex
	button.s.text <- text
	button.s.parentMenuName <- Hud_GetHudName( comboStruct.menu )
	button.s.alwaysChildren <- []

	comboStruct.comboButtonGrid[rowIndex][colIndex].button = button
	comboStruct.comboButtonGrid[rowIndex][colIndex].rowIndex = rowIndex
	comboStruct.comboButtonGrid[rowIndex][colIndex].colIndex = colIndex

	if ( colIndex > 0 )
	{
		comboStruct.comboButtonGrid[rowIndex][colIndex].button.SetNavLeft( comboStruct.comboButtonGrid[rowIndex][colIndex-1].button )
		comboStruct.comboButtonGrid[rowIndex][colIndex-1].button.SetNavRight( comboStruct.comboButtonGrid[rowIndex][colIndex].button )
	}

	Hud_AddEventHandler( button, UIE_GET_FOCUS, OnComboButtonGetFocus )
	Hud_AddEventHandler( button, UIE_LOSE_FOCUS, OnComboButtonLoseFocus )

	if ( rowIndex + 1 > comboStruct.numRows )
		comboStruct.numRows = rowIndex + 1

	Hud_SetColor( button, 0, 0, 0, 0 )
	Hud_SetAlpha( button, 0 )
	Hud_SetPanelAlpha( button, 0 )

	if ( text != "" )
	{
		Hud_SetText( button, text )
	}

	comboStruct.expandedHeight = Hud_GetHeight( button )

	return button
}

#if(DEV)
ComboStruct function DEV_GetComboStruct( string menuName )
{
	ComboStruct comboStruct = file.comboMenuData[menuName]

	return comboStruct
}
#endif

void function OnComboButtonGetFocus( var button )
{
	int rowIndex = expect int( button.s.rowIndex )
	int colIndex = expect int( button.s.colIndex )

	string parentMenuName = expect string( button.s.parentMenuName )
	ComboStruct comboStruct = file.comboMenuData[parentMenuName]

	for ( int row = 0; row < MAX_COMBO_BUTTON_ROWS; row++ )
	{
		if ( comboStruct.rowHeaders[row] != null )
		{
			var rui = Hud_GetRui( comboStruct.rowHeaders[row] )
			RuiSetBool( rui, "isFocused", row == rowIndex )

			if ( rowIndex == row )
				comboStruct.rowHeaders[row].SetColor( 192, 192, 192, 255 )
			else
				comboStruct.rowHeaders[row].SetColor( 160, 160, 160, 160 )
		}

		for ( int col = 0; col < MAX_COMBO_BUTTON_COLS; col++ )
		{
			if ( comboStruct.comboButtonGrid[row][col].button == null )
				continue

			var gridbutton = comboStruct.comboButtonGrid[row][col].button

			if ( col == 0 )
			{
				float yOffset = 0.0
				if ( row <= rowIndex )
					yOffset = float( -(comboStruct.collapsedHeight * row) )
				else if ( row > rowIndex )
					 yOffset = float( -(comboStruct.collapsedHeight * row + (comboStruct.expandedHeight - comboStruct.collapsedHeight)) )

				Hud_SetYOverTime( gridbutton, yOffset, TRANSITION_ANIM_TIME, INTERPOLATOR_DEACCEL )
			}

			//
			//
			if ( rowIndex == row )
			{
				gridbutton.SetHeight( comboStruct.expandedHeight )
				foreach ( var childElement in gridbutton.s.alwaysChildren )
				{
					childElement.SetHeight( comboStruct.expandedHeight )
					if ( Hud_IsRuiPanel( childElement ) )
					{
						var rui = Hud_GetRui( childElement )
						RuiSetBool( rui, "isExpanded", true )
					}
				}
			}
			else
			{
				gridbutton.SetHeight( comboStruct.collapsedHeight )
				foreach ( var childElement in gridbutton.s.alwaysChildren )
				{
					childElement.SetHeight( comboStruct.collapsedHeight )
					if ( Hud_IsRuiPanel( childElement ) )
					{
						var rui = Hud_GetRui( childElement )
						RuiSetBool( rui, "isExpanded", false )
					}
				}
			}
		}
	}

	if ( comboStruct.sharedColumnFocus )
	{
		foreach ( row, defaultIndex in comboStruct.defaultColumnIndex )
		{
			comboStruct.defaultColumnIndex[row] = colIndex
		}
	}

	UpdateButtonNav( comboStruct )
}
/*
































*/

void function OnComboButtonLoseFocus( var button )
{
	int rowIndex = expect int( button.s.rowIndex )
	int colIndex = expect int( button.s.colIndex )

	string parentMenuName = expect string( button.s.parentMenuName )
	ComboStruct comboStruct = file.comboMenuData[parentMenuName]

	comboStruct.defaultColumnIndex[rowIndex] = colIndex

	UpdateButtonNav( comboStruct )
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
}


void function ComboButtons_ResetColumnFocus( ComboStruct comboStruct )
{
	foreach ( row, defaultIndex in comboStruct.defaultColumnIndex )
	{
		comboStruct.defaultColumnIndex[row] = 0
	}
}


void function UpdateButtonNav( ComboStruct comboStruct )
{
	for ( int row = 0; row < MAX_COMBO_BUTTON_ROWS; row++ )
	{
		for ( int col = 0; col < MAX_COMBO_BUTTON_COLS; col++ )
		{
			if ( comboStruct.comboButtonGrid[row][col].button == null )
				continue

			if ( row == MAX_COMBO_BUTTON_ROWS - 1 || comboStruct.comboButtonGrid[row+1][0].button == null )
			{
				if ( comboStruct.navDownButtonDisabled )
				{
					//
				}
				else if ( comboStruct.navDownButton != null )
				{
					comboStruct.comboButtonGrid[row][col].button.SetNavDown( comboStruct.navDownButton )

					int navUpColumnIndex = comboStruct.defaultColumnIndex[comboStruct.numRows-1]
					comboStruct.navDownButton.SetNavUp( comboStruct.comboButtonGrid[row][navUpColumnIndex].button )
				}
				else
				{
					int navDownColumnIndex = comboStruct.defaultColumnIndex[0]
					comboStruct.comboButtonGrid[row][col].button.SetNavDown( comboStruct.comboButtonGrid[0][navDownColumnIndex].button )
				}
			}
			else
			{
				int navDownColumnIndex = comboStruct.defaultColumnIndex[row+1]
				comboStruct.comboButtonGrid[row][col].button.SetNavDown( comboStruct.comboButtonGrid[row+1][navDownColumnIndex].button )
			}

			if ( row == 0 )
			{
				if ( comboStruct.navUpButtonDisabled )
				{
					//
				}
				else if ( comboStruct.navUpButton != null )
				{
					comboStruct.comboButtonGrid[row][col].button.SetNavUp( comboStruct.navUpButton )

					int navDownColumnIndex = comboStruct.defaultColumnIndex[0]
					comboStruct.navUpButton.SetNavDown( comboStruct.comboButtonGrid[row][navDownColumnIndex].button )
				}
				else
				{
					int navUpColumnIndex = comboStruct.defaultColumnIndex[comboStruct.numRows-1]
					comboStruct.comboButtonGrid[row][col].button.SetNavUp( comboStruct.comboButtonGrid[comboStruct.numRows-1][navUpColumnIndex].button )
				}
			}
			else
			{
				int navUpColumnIndex = comboStruct.defaultColumnIndex[row-1]
				comboStruct.comboButtonGrid[row][col].button.SetNavUp( comboStruct.comboButtonGrid[row-1][navUpColumnIndex].button )
			}

			if ( col == MAX_COMBO_BUTTON_COLS - 1 || comboStruct.comboButtonGrid[row][col+1].button == null )
			{
				if ( comboStruct.navRightButton != null )
				{
					comboStruct.comboButtonGrid[row][col].button.SetNavRight( comboStruct.navRightButton )

					//
					//
				}
			}
		}
	}
}
