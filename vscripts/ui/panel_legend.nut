global function InitLegendPanel

void function InitLegendPanel( var panel )
{
	AddPanelEventHandler( panel, eUIEvent.PANEL_SHOW, OnShowLegendPage )
	AddPanelEventHandler( panel, eUIEvent.PANEL_HIDE, OnHideLegendPage )
}

void function OnShowLegendPage( var panel )
{
	SurvivalInventory_SetBGVisible( true )

	var elem = Hud_GetChild( panel, "GCard" )
	RunClientScript( "UICallback_PopulateClientGladCard", panel, elem, null, null, null, null, null, null, null, 0, Time(), eGladCardPresentation.FRONT_CLEAN )

	ItemFlavor ornull character = null

	if ( LoadoutSlot_IsReady( ToEHI( GetUIPlayer() ), Loadout_CharacterClass() ) )
	{
		character = LoadoutSlot_GetItemFlavor( ToEHI( GetUIPlayer() ), Loadout_CharacterClass() )
	}

	if ( character == null )
		return

	expect ItemFlavor( character )

	var characterSelectInfoRui = Hud_GetRui( Hud_GetChild( panel, "CharacterSelectInfo" ) )

	RuiSetString( characterSelectInfoRui, "nameText", Localize( ItemFlavor_GetLongName( character ) ).toupper() )
	RuiSetString( characterSelectInfoRui, "subtitleText", Localize( CharacterClass_GetCharacterSelectSubtitle( character ) ) )
	RuiSetGameTime( characterSelectInfoRui, "initTime", Time() )

	PopulateSkillElem( Hud_GetChild( panel, "Ultimate" ) , character )
	PopulateSkillElem( Hud_GetChild( panel, "Passive" ) , character )
	PopulateSkillElem( Hud_GetChild( panel, "Tactical" ) , character )
	PopulateSkillElem( Hud_GetChild( panel, "SpecialPerk" ) , character )
}

void function OnHideLegendPage( var panel )
{
	var elem = Hud_GetChild( panel, "GCard" )
	RunClientScript( "UICallback_DestroyClientGladCardData", elem )
}

void function PopulateSkillElem( var elem, ItemFlavor character )
{
	string skillType = Hud_GetScriptID( elem )
	var rui = Hud_GetRui( elem )

	switch ( skillType )
	{
		case "passive":
			RuiSetImage( rui, "skillIcon", ItemFlavor_GetIcon( CharacterClass_GetPassiveAbility( character ) ) )
			RuiSetString( rui, "skillName", Localize( ItemFlavor_GetLongName( CharacterClass_GetPassiveAbility( character ) ) ) )
			RuiSetString( rui, "skillDesc", Localize( ItemFlavor_GetLongDescription( CharacterClass_GetPassiveAbility( character ) ) ) )
			RuiSetString( rui, "skillType", Localize( "#PASSIVE" ) )
			RuiSetColorAlpha( rui, "tintColor", <1,1,1>, 1 )
			RuiSetColorAlpha( rui, "tintColorHighlight", <1,1,1>, 1 )
			break
		case "tactical":
			RuiSetImage( rui, "skillIcon", ItemFlavor_GetIcon( CharacterClass_GetTacticalAbility( character ) ) )
			RuiSetString( rui, "skillName", Localize( ItemFlavor_GetLongName( CharacterClass_GetTacticalAbility( character ) ) ) )
			RuiSetString( rui, "skillDesc", Localize( ItemFlavor_GetLongDescription( CharacterClass_GetTacticalAbility( character ) ) ) )
			RuiSetString( rui, "skillType", Localize( "#TACTICAL" ) )
			RuiSetColorAlpha( rui, "tintColor", <1,1,1>, 1 )
			RuiSetColorAlpha( rui, "tintColorHighlight", <1,1,1>, 1 )
			break
		case "ultimate":
			RuiSetImage( rui, "skillIcon", ItemFlavor_GetIcon( CharacterClass_GetUltimateAbility( character ) ) )
			RuiSetString( rui, "skillName", Localize( ItemFlavor_GetLongName( CharacterClass_GetUltimateAbility( character ) ) ) )
			RuiSetString( rui, "skillDesc", Localize( ItemFlavor_GetLongDescription( CharacterClass_GetUltimateAbility( character ) ) ) )
			RuiSetString( rui, "skillType", Localize( "#ULTIMATE" ) )
			CharacterHudUltimateColorData colorData = CharacterClass_GetHudUltimateColorData( character )
			RuiSetColorAlpha( rui, "tintColor", SrgbToLinear( colorData.ultimateColor ), 1 )
			RuiSetColorAlpha( rui, "tintColorHighlight", SrgbToLinear( colorData.ultimateColorHighlight ), 1 )
			break
		case "specialPerk":
			float damageScale = CharacterClass_GetDamageScale( character )

			if ( damageScale != 1.0 )
			{
				int percent = 0
				string name = ""
				string desc = ""
				asset icon = $""
				ItemFlavor passiveFlav

				if ( damageScale < 1.0 )
				{
					passiveFlav = PAS_FORTIFIED_FLAV
					percent = int( ((1.0 - damageScale)*100) + 0.5 )
					name = ItemFlavor_GetShortName( PAS_FORTIFIED_FLAV )
					desc = ItemFlavor_GetLongDescription( PAS_FORTIFIED_FLAV )
					icon = ItemFlavor_GetIcon( PAS_FORTIFIED_FLAV )
				}
				else if ( damageScale > 1.0 )
				{
					passiveFlav = PAS_LOW_PROFILE_FLAV
					percent = int( (fabs( 1.0 - damageScale ) * 100) + 0.5 )
					name = ItemFlavor_GetShortName( PAS_LOW_PROFILE_FLAV )
					desc = ItemFlavor_GetLongDescription( PAS_LOW_PROFILE_FLAV )
					icon = ItemFlavor_GetIcon( PAS_LOW_PROFILE_FLAV )
				}

				string finalString = Localize( "#SPECIAL_PERK_N_N", Localize( name ), Localize( desc, percent ) )
				RuiSetString( rui, "desc", finalString )
				RuiSetImage( rui, "icon", icon )
			}
			else
			{
				RuiSetImage( rui, "icon", $"" )
				RuiSetString( rui, "desc", "" )
			}
			RuiSetGameTime( rui, "initTime", Time() )
			return
	}

	RuiSetBool( rui, "isUltimate", skillType == "ultimate" )
	RuiSetGameTime( rui, "initTime", Time() )
}


