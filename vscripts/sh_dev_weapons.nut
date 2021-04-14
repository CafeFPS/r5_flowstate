//

global function ShDevWeapons_Init


//////////////////////////
#if SERVER || CLIENT || UI
void function ShDevWeapons_Init()
{
	#if SERVER || CLIENT
		// dev-only tools
		//PrecacheWeapon( "mp_weapon_cubemap" ) // (dw): precached in sh_weapons.gnut because it needs to be precached in non-DEV (to allow DEV clients to connect to non-DEV servers)
	#endif
}
#endif


