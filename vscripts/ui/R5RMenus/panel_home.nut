global function InitR5RHomePanel
global function SetUIVersion

struct
{
	var menu
	var panel
} file

void function InitR5RHomePanel( var panel )
{
	file.panel = panel
	file.menu = GetParentMenu( file.panel )

	//Set info box image
	RuiSetImage( Hud_GetRui( Hud_GetChild( file.panel, "R5RPicBox" ) ), "basicImage", $"rui/menu/home/bg" )
}

void function SetUIVersion()
{
	/*array<GladCardBadgeTierData> tierDataList

	try{
		tierDataList = GladiatorCardBadge_GetTierDataList( GetItemFlavorByHumanReadableRef( GetCurrentPlaylistVarString( "set_badge", "gcard_badge_account_dev_badge" ) ) )
	} catch(e0) {
		tierDataList = GladiatorCardBadge_GetTierDataList( GetItemFlavorByHumanReadableRef( "gcard_badge_account_dev_badge" ) )
	}*/

	//Set SDK version text
	Hud_SetText( Hud_GetChild( file.panel, "VersionNumber" ), "#BETA_BUILD_WATERMARK" )
	RuiSetString( Hud_GetRui( Hud_GetChild( file.panel, "SelfButton" ) ), "playerName", GetPlayerName() )
	RuiSetString( Hud_GetRui( Hud_GetChild( file.panel, "SelfButton" ) ), "accountLevel", GetAccountDisplayLevel( 100 ) )
	RuiSetImage( Hud_GetRui( Hud_GetChild( file.panel, "SelfButton" ) ), "accountBadge", $"rui/hud/custom_badges/r5r_badge" )
	RuiSetFloat( Hud_GetRui( Hud_GetChild( file.panel, "SelfButton" ) ), "accountXPFrac", 1.0 )
}