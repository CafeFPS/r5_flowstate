global function ShWeaponRack_Init

#if SERVER
global function CreateWeaponRack
global function SpawnWeaponOnRack
global function GetWeaponFromRack
#endif

const asset WEAPONRACKMODEL = $"mdl/industrial/gun_rack_arm_down.rmdl"
const string WEAPONRACK_SCRIPTNAME = "weaponrack_spawned"
const vector WEAPONRACK_ORIGIN_OFFSET = <0,0,45>
const vector WEAPONRACK_ANGLES_OFFSET = <-90,180,0>


void function ShWeaponRack_Init()
{
#if SERVER
//	AddCallback_EntitiesDidLoad( testRack )
#endif
}

#if SERVER
/*
void function testRack()
{
	entity rack = CreateWeaponRack(<-534,502,-3050>, <0,90,0>, "mp_weapon_vinson")
	wait 12
	printl(GetWeaponFromRack(rack))
}
*/

entity function CreateWeaponRack(vector origin, vector angles, string weaponName = "")
{
	entity rack = CreateEntity( "prop_dynamic" )
	rack.SetScriptName( WEAPONRACK_SCRIPTNAME )
	rack.SetValueForModelKey( WEAPONRACKMODEL )
	rack.SetOrigin( origin )
	rack.SetAngles( angles )
	rack.kv.solid = SOLID_VPHYSICS
	rack.AllowMantle()
	DispatchSpawn( rack )
	
	SpawnWeaponOnRack(rack, weaponName)
	
	return rack
}

entity function SpawnWeaponOnRack(entity rack, string weaponName)
{	
	if(weaponName.len() == 0)
		return null

	if(rack.e.cpoint1 != null && IsValid(rack.e.cpoint1) && rack.e.cpoint1.GetParent() == rack)
		return null
	
	entity loot = SpawnGenericLoot( weaponName, rack.GetOrigin()+WEAPONRACK_ORIGIN_OFFSET, rack.GetAngles()+WEAPONRACK_ANGLES_OFFSET, 1 )
	loot.SetParent( rack )
	rack.e.cpoint1 = loot
	
	return loot
}

entity function GetWeaponFromRack(entity rack)
{
	return (rack.e.cpoint1 != null && IsValid(rack.e.cpoint1)) ? rack.e.cpoint1 : null
}
#endif
