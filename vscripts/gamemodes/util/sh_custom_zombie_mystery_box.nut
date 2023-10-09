//Made by Julefox#0050
//Fixes by @CafeFPS

global function ShZombieMysteryBox_Init
global function GetMysteryBox
global function GetMysteryBoxFromEnt
global function AddMysteryBox
global function SetMysteryBoxUsable
#if SERVER
global function CreateMysteryBox
global function DestroyWeaponByDeadline_Thread
global function MysteryBoxMapInit
global function RegisterMysteryBoxLocation
global function GetAvailablesLocations
global function OnUseProcessingMysteryBox
global function MysteryBox_CanUse
#endif // SERVER

#if CLIENT
global function MysteryBox_DisplayRui
global function ServerCallback_MysteryBoxPrinttObituary
global function ServerCallback_MysteryBoxIsUsable
global function ServerCallback_MysteryBoxChangeLocation_DoAnnouncement
#endif // CLIENT

int uniqueGradeIdx = 1000

#if SERVER
// Create new locations for mystery boxes
global struct MisteryBoxLocationData
{
	array < MisteryBoxLocationData > locationDataArray

	vector origin
	vector angles
	bool isUsed
	string targetName = ""
}
global MisteryBoxLocationData misteryBoxLocationData

// You can know if an instance of "MisteryBoxLocationData" is valid or null
typedef ornullMisteryBoxLocationData MisteryBoxLocationData ornull
#endif // SERVER

// Global struct for mystery box
global struct CustomZombieMysteryBox
{
	array < entity > mysteryBoxArray
	bool mysteryBoxIsUsable = true
	array < entity > weaponInMysteryBoxIsUsable = []
	entity mysteryBoxEnt
	entity mysteryBoxFx
	entity mysteryBoxWeapon
	entity mysteryBoxWeaponScriptMover
	int uniqueGradeIdx
	string targetName
	table < entity, CustomZombieMysteryBox > mysteryBox
	
	#if SERVER
	bool changeLocation
	int maxUseIdx
	int usedIdx
	#endif // SERVER
}

global CustomZombieMysteryBox customZombieMysteryBox

// Consts
const float  MYSTERY_BOX_ON_USE_DURATION        = 0.0
const float  MYSTERY_BOX_WEAPON_MOVE_TIME       = 5
//const int    MYSTERY_BOX_COST                   = 950
const int    MYSTERY_BOX_MAX_CAN_USE            = 15
const int    MYSTERY_BOX_MIN_CAN_USE            = 6
global const string MYSTERY_BOX_SCRIPT_NAME            = "MysteryBoxScriptName"
//const string MYSTERY_BOX_USE                    = "to open Mystery Box\nCost: %i $"
const string USE                                = "Press %use% to open Mystery Box"
const vector MYSTERY_BOX_WEAPON_ANGLES_OFFSET   = < 0, 90, 0 >
const vector MYSTERY_BOX_WEAPON_MOVE_TO         = < 0, 0, 30 >
const vector MYSTERY_BOX_WEAPON_ORIGIN_OFFSET   = < 0, 0, 20 >

#if SERVER
const asset MYSTERY_BOX_BEAM                    = $"P_ar_loot_drop_point_far"
const asset NESSY_MODEL                         = $"mdl/domestic/nessy_doll.rmdl"
#endif // SERVER

#if CLIENT
const asset MYSTERY_BOX_DISPLAYRUI = $"ui/extended_use_hint.rpak"
const string SCORE                            = "%i $"
const string MYSTERY_BOX_PLAYER_GIVE_WEAPON   = "%s gives his weapon in the mystery box"
const asset WEAPON_WALL_DISPLAYRUI = $"ui/extended_use_hint.rpak"
#endif // CLIENT

// Global weapon index
global enum eWeaponZombieIdx
{
	// Assault Rifles
	FLATLINE,
	RAYGUN,
	SCOUT,
	HAVOC,
	HEMLOK,
	R101,

	// // SMGs
	ALTERNATOR,
	// PROWLER,
	R97,
	VOLT,

	// //LMGs
	// DEVOTION,
	// LSTAR,
	SPITFIRE,

	// // Snipers
	// CHARGE,
	KRABER,
	// DMR,
	TRIPLETAKE,
	// //SENTINEL,

	// // Shotguns
	EVA,
	MASTIFF,
	MOZAMBIQUE,
	PEACEKEEPER,

	// // Pistols
	P2020,
	// ENERGYSWORD,
	RE45,
	WINGMAN
	//NEMESIS

	//COUNT
}

// Global weapon asset
// Get them by index
global table< int, asset > eWeaponZombieModel =
{
	[ eWeaponZombieIdx.FLATLINE ] = $"mdl/weapons/vinson/w_vinson.rmdl",
	[ eWeaponZombieIdx.RAYGUN ] = $"mdl/Weapons/w_raygun/w_raygun.rmdl",
	[ eWeaponZombieIdx.SCOUT ] = $"mdl/weapons/g2/w_g2a4.rmdl",
	[ eWeaponZombieIdx.HAVOC ] = $"mdl/weapons/beam_ar/w_beam_ar.rmdl",
	[ eWeaponZombieIdx.HEMLOK ] = $"mdl/weapons/m1a1_hemlok/w_hemlok.rmdl",
	[ eWeaponZombieIdx.R101 ] = $"mdl/weapons/rspn101/w_rspn101.rmdl",
	[ eWeaponZombieIdx.ALTERNATOR ] = $"mdl/weapons/alternator_smg/w_alternator_smg.rmdl",
	// [ eWeaponZombieIdx.PROWLER ] = $"mdl/weapons/prowler_smg/w_prowler_smg.rmdl",
	[ eWeaponZombieIdx.R97 ] = $"mdl/weapons/r97/w_r97.rmdl",
	[ eWeaponZombieIdx.VOLT ] = $"mdl/weapons/hemlok_smg/w_hemlok_smg.rmdl",
	// [ eWeaponZombieIdx.DEVOTION ] = $"mdl/weapons/hemlock_br/w_hemlock_br.rmdl",
	// [ eWeaponZombieIdx.LSTAR ] = $"mdl/weapons/lstar/w_lstar.rmdl",
	[ eWeaponZombieIdx.SPITFIRE ] = $"mdl/weapons/lmg_hemlok/w_lmg_hemlok.rmdl",
	// [ eWeaponZombieIdx.CHARGE ] = $"mdl/weapons/defender/w_defender.rmdl",
	[ eWeaponZombieIdx.KRABER ] = $"mdl/weapons/at_rifle/w_at_rifle.rmdl",
	// [ eWeaponZombieIdx.DMR ] = $"mdl/weapons/rspn101_dmr/w_rspn101_dmr.rmdl",
	[ eWeaponZombieIdx.TRIPLETAKE ] = $"mdl/weapons/doubletake/w_doubletake.rmdl",
	// //[ eWeaponZombieIdx.SENTINEL ] = $"mdl/Weapons/sentinel/w_sentinel.rmdl",
	[ eWeaponZombieIdx.EVA ] = $"mdl/weapons/w1128/w_w1128.rmdl",
	[ eWeaponZombieIdx.MASTIFF ] = $"mdl/weapons/mastiff_stgn/w_mastiff.rmdl",
	[ eWeaponZombieIdx.MOZAMBIQUE ] = $"mdl/weapons/pstl_sa3/w_pstl_sa3.rmdl",
	[ eWeaponZombieIdx.PEACEKEEPER ] = $"mdl/weapons/peacekeeper/w_peacekeeper.rmdl",
	[ eWeaponZombieIdx.P2020 ] = $"mdl/weapons/p2011/w_p2011.rmdl",
	// [ eWeaponZombieIdx.ENERGYSWORD ] = $"mdl/Weapons/w_energy_sword/w_energy_sword.rmdl",
	
	[ eWeaponZombieIdx.RE45 ] = $"mdl/weapons/p2011_auto/w_p2011_auto.rmdl",
	[ eWeaponZombieIdx.WINGMAN ] = $"mdl/weapons/b3wing/w_b3wing.rmdl"
	//[ eWeaponZombieIdx.NEMESIS ] = $"mdl/Weapons/nemesis/w_nemesis.rmdl"
}

// Global weapon name
// Get them by index
global table< int, array< string > > eWeaponZombieName =
{
	[ eWeaponZombieIdx.FLATLINE ] = [ "mp_weapon_vinson", "Flatline" ],
	[ eWeaponZombieIdx.RAYGUN ] = [ "mp_weapon_raygun", "Ray Gun" ],
	[ eWeaponZombieIdx.SCOUT ] = [ "mp_weapon_g2", "G7 Scout" ],
	[ eWeaponZombieIdx.HAVOC ] = [ "mp_weapon_energy_ar", "Havoc" ],
	[ eWeaponZombieIdx.HEMLOK ] = [ "mp_weapon_hemlok", "Hemlok" ],
	[ eWeaponZombieIdx.R101 ] = [ "mp_weapon_rspn101", "R-301" ],
	[ eWeaponZombieIdx.ALTERNATOR ] = [ "mp_weapon_alternator_smg", "Alternator" ],
	// [ eWeaponZombieIdx.PROWLER ] = [ "mp_weapon_pdw", "Prowler" ],
	[ eWeaponZombieIdx.R97 ] = [ "mp_weapon_r97", "R-99" ],
	[ eWeaponZombieIdx.VOLT ] = [ "mp_weapon_volt_smg", "Volt" ],
	// [ eWeaponZombieIdx.DEVOTION ] = [ "mp_weapon_esaw", "Devotion" ],
	// [ eWeaponZombieIdx.LSTAR ] = [ "mp_weapon_lstar", "L-Star" ],
	[ eWeaponZombieIdx.SPITFIRE ] = [ "mp_weapon_lmg", "Spitfire" ],
	// [ eWeaponZombieIdx.CHARGE ] = [ "mp_weapon_defender", "Charge Rifle" ],
	[ eWeaponZombieIdx.KRABER ] = [ "mp_weapon_sniper", "Kraber" ],
	// [ eWeaponZombieIdx.DMR ] = [ "mp_weapon_dmr", "Longbow" ],
	[ eWeaponZombieIdx.TRIPLETAKE ] = [ "mp_weapon_doubletake", "Triple Take" ],
	// //[ eWeaponZombieIdx.SENTINEL ] = [ "mp_weapon_sentinel", "Sentinel" ],
	[ eWeaponZombieIdx.EVA ] = [ "mp_weapon_shotgun", "EVA-8" ],
	[ eWeaponZombieIdx.MASTIFF ] = [ "mp_weapon_mastiff", "Mastiff" ],
	[ eWeaponZombieIdx.MOZAMBIQUE ] = [ "mp_weapon_shotgun_pistol", "Mozambique" ],
	[ eWeaponZombieIdx.PEACEKEEPER ] = [ "mp_weapon_energy_shotgun", "Peacekeeper" ],
	[ eWeaponZombieIdx.P2020 ] = [ "mp_weapon_semipistol", "P2020" ],
	// [ eWeaponZombieIdx.ENERGYSWORD ] = [ "mp_weapon_energysword", "Energy Sword" ],
	[ eWeaponZombieIdx.RE45 ] = [ "mp_weapon_autopistol", "RE-45" ],
	[ eWeaponZombieIdx.WINGMAN ] = [ "mp_weapon_wingman", "Wingman" ]
	//[ eWeaponZombieIdx.NEMESIS ] = [ "mp_weapon_nemesis", "Nemesis" ]
}

// Init
void function ShZombieMysteryBox_Init()
{
	// Init weapon in mystery box file
	ShZombieMysteryBoxWeapon_Init()

	#if SERVER
	PrecacheParticleSystem( MYSTERY_BOX_BEAM )
	#endif // SERVER

	#if SERVER
	AddSpawnCallback( "prop_dynamic", MysteryBoxInit )
	#endif // SERVER

	#if CLIENT
	AddCreateCallback( "prop_dynamic", MysteryBoxInit )
	#endif // CLIENT

}

// SERVER && CLIENT Callback
void function MysteryBoxInit( entity mysteryBox )
{
	if ( !IsValidMysteryBox( mysteryBox ) )
		return

	AddMysteryBox( mysteryBox )
	SetMysteryBoxUsable( mysteryBox )
	SetMysteryBoxFx( mysteryBox )
}

// Check by script name if it is a mystery box.
bool function IsValidMysteryBox( entity ent )
{
	if ( ent.GetScriptName() == MYSTERY_BOX_SCRIPT_NAME )
		return true

	return false
}


// Create a new instance for a mystery box
CustomZombieMysteryBox function AddMysteryBox( entity mysteryBox )
{
	CustomZombieMysteryBox newMysteryBox

	newMysteryBox.mysteryBoxEnt = mysteryBox
	newMysteryBox.uniqueGradeIdx = uniqueGradeIdx++
	newMysteryBox.targetName = mysteryBox.GetTargetName()

	#if SERVER
	newMysteryBox.maxUseIdx = RandomIntRange( MYSTERY_BOX_MIN_CAN_USE, MYSTERY_BOX_MAX_CAN_USE )
	#endif // SERVER

	customZombieMysteryBox.mysteryBoxArray.append( mysteryBox )
	customZombieMysteryBox.mysteryBox[ mysteryBox ] <- newMysteryBox

	return customZombieMysteryBox.mysteryBox[ mysteryBox ]
}


// Set mystery box usable
void function SetMysteryBoxUsable( entity mysteryBox )
{
	#if SERVER
	mysteryBox.SetUsable()
	mysteryBox.SetUsableByGroup( "pilot" )
	mysteryBox.SetUsableValue( USABLE_BY_ALL | USABLE_CUSTOM_HINTS )
	mysteryBox.SetUsablePriority( USABLE_PRIORITY_MEDIUM )
	mysteryBox.SetSkin(2)
	#endif // SERVER

	SetCallback_CanUseEntityCallback( mysteryBox, MysteryBox_CanUse )
	AddCallback_OnUseEntity( mysteryBox, OnUseProcessingMysteryBox )

	#if CLIENT
	AddEntityCallback_GetUseEntOverrideText( mysteryBox, MysteryBox_TextOverride )
	#endif // CLIENT
}


// Create a fx on the mystery box
void function SetMysteryBoxFx( entity mysteryBox )
{
	#if SERVER
		GetMysteryBox( mysteryBox ).mysteryBoxFx = StartParticleEffectInWorld_ReturnEntity( GetParticleSystemIndex( MYSTERY_BOX_BEAM ), mysteryBox.GetOrigin(), < 0, 0, 0 > )
	#endif // SERVER
}


// If is usable
bool function MysteryBox_CanUse( entity player, entity mysteryBox )
{
	if( player.IsShadowForm() )
		return false
	
	if ( !SURVIVAL_PlayerCanUse_AnimatedInteraction( player, mysteryBox ) )
		return false

	if ( !GetMysteryBox( mysteryBox ).mysteryBoxIsUsable )
		return false

	return true
}


// Callback if the mystery box is used
void function OnUseProcessingMysteryBox( entity mysteryBox, entity playerUser, int useInputFlags )
{
	if ( !( useInputFlags & USE_INPUT_LONG ) )
		return

	ExtendedUseSettings settings
	settings.duration       = MYSTERY_BOX_ON_USE_DURATION
	settings.useInputFlag   = IN_USE_LONG
	settings.successFunc    = MysteryBoxUseSuccess

	#if CLIENT
	settings.hint               = "Processing Mystery box..."
	settings.displayRui         = MYSTERY_BOX_DISPLAYRUI
	settings.displayRuiFunc     = MysteryBox_DisplayRui
	#endif // CLIENT

	thread ExtendedUse( mysteryBox, playerUser, settings )
}


// If the callback is a success
void function MysteryBoxUseSuccess( entity mysteryBox, entity player, ExtendedUseSettings settings )
{
	CustomZombieMysteryBox mysteryBoxStruct = GetMysteryBox( mysteryBox )
	
	// if ( !PlayerHasEnoughScore( player, MYSTERY_BOX_COST ) )
		// return

	mysteryBoxStruct.mysteryBoxIsUsable = false

	// RemoveScoreToPlayer( player, MYSTERY_BOX_COST )

	#if SERVER
	//mysteryBoxStruct.changeLocation = false
	//mysteryBoxStruct.usedIdx++
	foreach ( players in GetPlayerArray() )
		Remote_CallFunction_NonReplay( players, "ServerCallback_MysteryBoxIsUsable", mysteryBox, false )
	// if ( mysteryBoxStruct.usedIdx >= mysteryBoxStruct.maxUseIdx )
	// {
		// mysteryBoxStruct.changeLocation = true
	// }
	
	thread MysteryBox_Init( mysteryBox, player )
	#endif // SERVER

	#if SERVER// && NIGHTMARE_DEV
		//printt( format( "Number of times used before swap: %i / %i", mysteryBoxStruct.usedIdx, mysteryBoxStruct.maxUseIdx ) )
	#endif // SERVER && NIGHTMARE_DEV
}


#if CLIENT
// Text override
string function MysteryBox_TextOverride( entity mysteryBox )
{
	return USE
}

// RUI Function
void function MysteryBox_DisplayRui( entity ent, entity player, var rui, ExtendedUseSettings settings )
{
	RuiSetString( rui, "holdButtonHint", settings.holdHint )
	RuiSetString( rui, "hintText", settings.hint )
	RuiSetGameTime( rui, "startTime", Time() )
	RuiSetGameTime( rui, "endTime", Time() + settings.duration )
}
#endif // CLIENT


//////////////////////////////////////////////
//    _____ _                        _      //
//   |_   _| |__  _ __ ___  __ _  __| |     //
//     | | | '_ \| '__/ _ \/ _` |/ _` |     //
//     | | | | | | | |  __/ (_| | (_| |     //
//     |_| |_| |_|_|  \___|\__,_|\__,_|     //
//////////////////////////////////////////////

#if SERVER            
// Thread init
void function MysteryBox_Init( entity mysteryBox, entity player )
{
	mysteryBox.SetOwner(player)
	thread MysteryBox_PlayOpenSequence( mysteryBox, player )
	
	wait mysteryBox.GetSequenceDuration("loot_bin_01_open") - 1
	
	thread MysteryBox_Thread( mysteryBox, player )
}

// Thread mid
void function MysteryBox_Thread( entity mysteryBox, entity player )
{
	vector mysteryBoxOrigin = mysteryBox.GetOrigin()
	vector mysteryBoxAngles = mysteryBox.GetAngles()

	CustomZombieMysteryBox mysteryBoxStruct = GetMysteryBox( mysteryBox )

	entity weapon = CreateWeaponInMysteryBox( 0, mysteryBoxOrigin + MYSTERY_BOX_WEAPON_ORIGIN_OFFSET, mysteryBoxAngles + MYSTERY_BOX_WEAPON_ANGLES_OFFSET, mysteryBoxStruct.targetName)
	
	EndSignal(weapon, "OnDestroy")
	
	entity script_mover = CreateScriptMover( mysteryBoxOrigin + MYSTERY_BOX_WEAPON_ORIGIN_OFFSET, mysteryBoxAngles + MYSTERY_BOX_WEAPON_ANGLES_OFFSET )
	
	mysteryBoxStruct.mysteryBoxWeapon = weapon
	mysteryBoxStruct.mysteryBoxWeaponScriptMover = script_mover
	
	weapon.SetParent( script_mover )

	script_mover.SetParent(mysteryBox)
	
	OnThreadEnd(
		function() : ( player, mysteryBox )
		{
			thread DestroyWeaponByDeadline_Thread( player, mysteryBox )
			mysteryBox.ClearBossPlayer()
		})

	float startTime = Time()
	float endTime = Time() + MYSTERY_BOX_WEAPON_MOVE_TIME
	float timePercentage
	float waitVar
	int weaponVisual

	if ( IsValid( script_mover ) ) script_mover.NonPhysicsMoveTo( weapon.GetOrigin() + MYSTERY_BOX_WEAPON_MOVE_TO, MYSTERY_BOX_WEAPON_MOVE_TIME, 0, MYSTERY_BOX_WEAPON_MOVE_TIME )
	vector originalAngles = weapon.GetAngles()

	array< asset > ModelsArrayShuffled
	
	for(int i = 0; i < eWeaponZombieIdx.len(); i++)
	{
		ModelsArrayShuffled.append( eWeaponZombieModel[ i ] )
	}
	
	ModelsArrayShuffled.randomize() //necesitamos shufflear, de otra manera puede que el siguiente modelo sea el mismo que ya tiene y se vea un efecto de "lag" al demorar otro frame en cambiar de modelo de verdad
	
	int i = 0 
	
	while ( Time() < endTime - 0.15 )
	{	
		
		if ( IsValid( weapon ) ) 
		{
			weapon.SetModel( ModelsArrayShuffled[i] )
			ClearSurvivalPropHighlight( weapon )
			SetHighlightForMysteryBoxWeapon(weapon, eWeaponZombieName[GetWeaponIdx(weapon)][0])
			i++
			
			if( i == eWeaponZombieIdx.len() )
			{
				i = 0
				ModelsArrayShuffled.randomize() 
				
				if( ModelsArrayShuffled[0] == weapon.GetModelName() ) //garantizar que no se repita el anterior
				{
					asset assetToMove = ModelsArrayShuffled[0]
					
					ModelsArrayShuffled[0] = ModelsArrayShuffled[ModelsArrayShuffled.len()-1]
					ModelsArrayShuffled[ModelsArrayShuffled.len()-1] = assetToMove
				}
			}
		}
		
		timePercentage = (Time() - startTime) / ((endTime+5) - Time())	
		waitVar = min(LerpFloat(0, 1, timePercentage), 1)
		
		if(Time() + waitVar > endTime - 0.15 )
			break
		
		wait waitVar
	}
	
	SetWeaponMysteryBoxUsable( weapon )
	foreach(players in GetPlayerArray())
		Remote_CallFunction_NonReplay( players, "ServerCallback_SetWeaponMysteryBoxUsable", weapon )

	if ( IsValid( script_mover ) && IsValid( weapon ) ) script_mover.NonPhysicsMoveTo( weapon.GetOrigin() - MYSTERY_BOX_WEAPON_MOVE_TO, ( MYSTERY_BOX_WEAPON_MOVE_TIME * 2 ), ( MYSTERY_BOX_WEAPON_MOVE_TIME * 2 ), 0)

	wait ( MYSTERY_BOX_WEAPON_MOVE_TIME * 2 ) - 0.15 
}

void function SetHighlightForMysteryBoxWeapon( entity prop, string weaponname )
{
	LootData data = SURVIVAL_Loot_GetLootDataByRef( weaponname )
	string ref = data.ref
	int lootType = data.lootType
	int lootTier = data.tier

	string highlight = SURVIVAL_GetHighlightForTier( lootTier )
	
	//printt("Debug LootData: " + weaponname + ref + lootType + lootTier)
	
	SetSurvivalPropHighlight( prop, highlight, false )
}

// Thread end
void function DestroyWeaponByDeadline_Thread( entity player, entity mysteryBox )
{
	CustomZombieMysteryBox mysteryBoxStruct = GetMysteryBox( mysteryBox )

	entity weapon = mysteryBoxStruct.mysteryBoxWeapon
	entity script_mover = mysteryBoxStruct.mysteryBoxWeaponScriptMover

	if ( IsValid( weapon ) ) weapon.Destroy()
	if ( IsValid( script_mover ) ) script_mover.Destroy()

	waitthread MysteryBox_PlayCloseSequence( mysteryBox )

	wait 0.1

	mysteryBoxStruct.mysteryBoxIsUsable = true

	foreach ( players in GetPlayerArray() )
		Remote_CallFunction_NonReplay( players, "ServerCallback_MysteryBoxIsUsable", mysteryBox, true )
}

// Destroy mystery box
void function DestroyMysteryBox_Thread( entity player, entity mysteryBox )
{
	CustomZombieMysteryBox mysteryBoxStruct = GetMysteryBox( mysteryBox )

	entity weapon = mysteryBoxStruct.mysteryBoxWeapon
	entity script_mover = mysteryBoxStruct.mysteryBoxWeaponScriptMover
	entity mysteryBoxFx = mysteryBoxStruct.mysteryBoxFx
	entity toDissolve = mysteryBoxStruct.mysteryBoxEnt

	if ( IsValid( weapon ) ) weapon.Destroy()
	if ( IsValid( script_mover ) ) script_mover.Destroy()
	if ( IsValid( mysteryBoxFx ) ) mysteryBoxFx.Destroy()

	waitthread MysteryBox_PlayCloseSequence( mysteryBox )

	WaitFrame()

	if ( IsValid( toDissolve ) ) toDissolve.Dissolve( ENTITY_DISSOLVE_CORE, < 0, 0, 0 >, 1000 )
}

// Respawn a mystery box at a random position
void function RespawnMysteryBox( string targetName )
{

	ornullMisteryBoxLocationData ornullLocation = FindUsedMysteryBoxLocation( targetName )

		if ( ornullLocation == null )
			return

		MisteryBoxLocationData location = expect MisteryBoxLocationData( ornullLocation )


	ornullMisteryBoxLocationData ornullNewLocation = FindUnusedMysteryBoxLocation()

		if ( ornullNewLocation == null )
		{
			location.targetName = ""
			location.isUsed = false
			return
		}

		MisteryBoxLocationData newLocation = expect MisteryBoxLocationData( ornullNewLocation )

		entity mysteryBox = CreateMysteryBox( newLocation.origin, newLocation.angles )

		newLocation.targetName = mysteryBox.GetTargetName()
		newLocation.isUsed = true


	location.targetName = ""
	location.isUsed = false
}

// Open mystery box
void function MysteryBox_PlayOpenSequence( entity mysteryBox, entity player )
{
	mysteryBox.EndSignal( "OnDestroy" )
	
	if ( !mysteryBox.e.hasBeenOpened )
	{
		mysteryBox.e.hasBeenOpened = true

		StopSoundOnEntity( mysteryBox, SOUND_LOOT_BIN_IDLE )
	}
	
	GradeFlagsSet( mysteryBox, eGradeFlags.IS_BUSY )
	
	EmitSoundOnEntity( mysteryBox, SOUND_LOOT_BIN_OPEN )

	waitthread PlayAnim( mysteryBox, "loot_bin_01_open" )
	
	GradeFlagsSet( mysteryBox, eGradeFlags.IS_OPEN )
}

// Close mystery box
void function MysteryBox_PlayCloseSequence( entity mysteryBox )
{
	mysteryBox.EndSignal( "OnDestroy" )
	
	GradeFlagsSet( mysteryBox, eGradeFlags.IS_BUSY )
	GradeFlagsClear( mysteryBox, eGradeFlags.IS_OPEN )
	
	waitthread PlayAnim( mysteryBox, "loot_bin_01_close" )
	
	GradeFlagsClear( mysteryBox, eGradeFlags.IS_BUSY )
}
#endif // SERVER

#if SERVER
// Init the number of boxes you want in the game
void function MysteryBoxMapInit( int num )
{

	// #if NIGHTMARE_DEV && SPAWN_MYSTERYBOX_ON_ALL_LOCATIONS
		num = GetAvailablesLocations()
	// #endif // NIGHTMARE_DEV && SPAWN_MYSTERYBOX_ON_ALL_LOCATIONS

	for ( int i = 0 ; i < num ; i++ )
	{
		ornullMisteryBoxLocationData ornullLocation = FindUnusedMysteryBoxLocation()

		if ( ornullLocation == null )
			return

		MisteryBoxLocationData location = expect MisteryBoxLocationData( ornullLocation )

		entity mysteryBox = CreateMysteryBox( location.origin, location.angles )

		location.targetName = mysteryBox.GetTargetName()

		location.isUsed = true
		printt("created mystery box")
	}

}

// Create mystery box
entity function CreateMysteryBox( vector origin, vector angles )
{
	entity mysteryBox = CreateEntity( "prop_dynamic" )
	mysteryBox.SetScriptName( MYSTERY_BOX_SCRIPT_NAME )
	mysteryBox.SetValueForModelKey( LOOT_BIN_MODEL )
	mysteryBox.SetOrigin( origin )
	mysteryBox.SetAngles( angles )
	mysteryBox.kv.solid = SOLID_VPHYSICS
	SetTargetName( mysteryBox, UniqueMysteryBoxString( "MysteryBox" ) )
	mysteryBox.SetSkin(2)
	DispatchSpawn( mysteryBox )

	return mysteryBox
}
#endif // SERVER

#if SERVER
// Register a new location for mystery boxes
MisteryBoxLocationData function RegisterMysteryBoxLocation( vector origin, vector angles )
{
	MisteryBoxLocationData location
	location.origin = origin
	location.angles = angles
	location.isUsed = false

	misteryBoxLocationData.locationDataArray.append( location )

	return location
}

// Return all mystery boxes locations
array < MisteryBoxLocationData > function GetAllMysteryBoxLocations()
{
	return misteryBoxLocationData.locationDataArray
}

// Try to find an unused location otherwise returns null
MisteryBoxLocationData ornull function FindUnusedMysteryBoxLocation()
{
	GetAllMysteryBoxLocations().randomize()

	foreach ( locations in GetAllMysteryBoxLocations() )
	{
		if ( locations.isUsed )
			continue
		else
			return locations
	}

	return null
}

// Tries to find a location via its "target name" otherwise returns null
MisteryBoxLocationData ornull function FindUsedMysteryBoxLocation( string targetName )
{
	foreach ( locations in GetAllMysteryBoxLocations() )
	{
		if ( locations.targetName == targetName )
			return locations
	}

	return null
}

// Returns the number of available slots
int function GetAvailablesLocations()
{
	int i = 0
	foreach ( locations in GetAllMysteryBoxLocations() )
	{
		if ( !locations.isUsed )
			i++
	}

	return i
}
#endif // SERVER

//////////////////////////////////////
//    _   _ _   _ _ _ _             //
//   | | | | |_(_) (_) |_ _   _     //
//   | | | | __| | | | __| | | |    //
//   | |_| | |_| | | | |_| |_| |    //
//    \___/ \__|_|_|_|\__|\__, |    //
//                        |___/     //
//////////////////////////////////////

// Get a specific mystery box
CustomZombieMysteryBox function GetMysteryBox( entity mysteryBox )
{
	return customZombieMysteryBox.mysteryBox[ mysteryBox ]
}

// Get a specific mystery box with an other ent using the same target name
CustomZombieMysteryBox function GetMysteryBoxFromEnt( entity ent )
{
	string targetName = ent.GetTargetName() ; entity mysteryBox

	foreach ( mysteryBoxs in GetAllMysteryBox() )
	{   if ( GetMysteryBox( mysteryBoxs ).targetName == targetName )
		{   mysteryBox = mysteryBoxs }
	}

	return customZombieMysteryBox.mysteryBox[ mysteryBox ] 
}

// Get all mystery boxes
array< entity > function GetAllMysteryBox()
{
	return customZombieMysteryBox.mysteryBoxArray
}

// Create a unique string foreach mystery boxes
int uniqueMysteryBoxIdx = 0
string function UniqueMysteryBoxString( string str = "" )
{
	return str + "_idx" + uniqueMysteryBoxIdx++
}

#if SERVER
// Refunds the player
void function MysteryBoxRefundPlayer( entity player )
{
   // AddScoreToPlayer( player, MYSTERY_BOX_COST )
}
#endif // SERVER

#if CLIENT
void function ServerCallback_MysteryBoxPrinttObituary( entity player )
{
	if(!IsValid(player)) return
	
	Obituary_Print_Localized( format( MYSTERY_BOX_PLAYER_GIVE_WEAPON, player.GetPlayerName() ), GetChatTitleColorForPlayer( GetLocalClientPlayer() ), BURN_COLOR )
}

void function ServerCallback_MysteryBoxIsUsable( entity mysteryBox, bool isUsable )
{
	GetMysteryBox( mysteryBox ).mysteryBoxIsUsable = isUsable
}

void function ServerCallback_MysteryBoxChangeLocation_DoAnnouncement()
{
	foreach( player in GetPlayerArray() )
	{
		if(!IsValid(player)) continue
		
		AnnouncementData announcement = Announcement_Create( "" )
		Announcement_SetSoundAlias( announcement, "survival_circle_close_alarm_01" )
		AnnouncementFromClass( player, announcement )
	}
}
#endif