global function ServerCallback_OpenSurvivalExitMenu
global function OpenLeaveDialogFromSpectate

void function ServerCallback_OpenSurvivalExitMenu( bool showSummary )
{
	if ( IsDialog( GetActiveMenu() ) )
		return

	if ( GetActiveMenu() != null )
		return

	AdvanceMenu( GetMenu( "SystemMenu" ) )
}


void function OpenLeaveDialogFromSpectate()
{
	if ( GetActiveMenu() != null )
		return

	LeaveDialog()
}
