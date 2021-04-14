
global function InitTestMenu

struct
{
	array<var> buttons
} file

void function InitTestMenu()
{
	var menu = GetMenu( "TestMenu" )

	file.buttons = GetElementsByClassname( menu, "DevButtonClass" )
	foreach ( button in file.buttons )
	{
		//Hud_AddEventHandler( button, UIE_CLICK, OnDevButton_Activate )

		Hud_SetText( button, "" )
		Hud_SetEnabled( button, false )
	}
}
