//

global function ShDevWeapons_Init


//////////////////////////
#if SERVER || CLIENT || UI
void function ShDevWeapons_Init()
{
	#if SERVER || CLIENT
		PrecacheWeapon( "mp_weapon_defender_sustained" )
		PrecacheWeapon( "melee_bloodhound_axe" )
		PrecacheWeapon( "mp_weapon_bloodhound_axe_primary" )

		PrecacheWeapon( "melee_lifeline_baton" )
		PrecacheWeapon( "mp_weapon_lifeline_baton_primary" )

		PrecacheWeapon( "melee_shadowsquad_hands" )
		PrecacheWeapon( "mp_weapon_shadow_squad_hands_primary" )	
	#endif

}
#endif


