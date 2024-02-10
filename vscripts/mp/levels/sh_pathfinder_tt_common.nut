//Made by @CafeFPS

global function PathTT_Init
global function IsPathTTEnabled

#if SERVER && DEVELOPER
global function TpToPathTT
#endif

const string PLAYER_PASS_THROUGH_RING_SHIELD_SOUND = "Player_Enter_Ring_v1"

struct{
	entity trigger
}file

void function PathTT_Init()
{
	AddCallback_EntitiesDidLoad( EntitiesDidLoad )

	RegisterSignal( "OnStartTouch" )
	RegisterSignal( "OnEndTouch" )
}

bool function IsPathTTEnabled()	
{
	// if ( GetCurrentPlaylistVarBool( "path_tt_enabled", true ) )
	// {
		// return HasEntWithScriptName( "path_tt_jumbo_screen_ko" )
	// }

	return GetCurrentPlaylistVarBool( "path_tt_enabled", true ) //false
}

void function EntitiesDidLoad()
{
	if ( !IsPathTTEnabled() )
		return

	PrecacheWeapon( $"mp_weapon_melee_boxing_ring" )
	PrecacheWeapon( $"melee_boxing_ring" )

	// InitPathTTBoxingRing()
	InitPathTTBoxingRingEntities()
}

void function InitPathTTBoxingRingEntities()
{
	array<entity> enterTrigArr = GetEntArrayByScriptName( "path_tt_ring_trig" )
	if ( enterTrigArr.len() == 1 )
	{
		#if SERVER
			PathTT_SetupManTrigger( enterTrigArr[ 0 ] )
		#elseif CLIENT
			thread Cl_PathTT_MonitorIsPlayerInBoxingRing( enterTrigArr[ 0 ] )
		#endif
		file.trigger = enterTrigArr[ 0 ]
	}
}

#if SERVER
void function PathTT_SetupManTrigger( entity trigger )
{
	trigger.kv.triggerFilterUseNew = 1
	trigger.kv.triggerFilterPlayer = "all"
	trigger.kv.triggerFilterPhaseShift = "any"
	trigger.kv.triggerFilterNpc = "none"
	trigger.kv.triggerFilterNonCharacter = 0
	trigger.kv.triggerFilterTeamMilitia = 1
	trigger.kv.triggerFilterTeamIMC = 1
	trigger.kv.triggerFilterTeamNeutral = 1
	trigger.kv.triggerFilterTeamBeast = 1
	trigger.kv.triggerFilterTeamOther = 1
	trigger.ConnectOutput( "OnStartTouch", PathTT_OnMainTriggerStartTouch )
	trigger.ConnectOutput( "OnEndTouch", PathTT_OnMainTriggerEndTouch )
}

void function PathTT_OnMainTriggerStartTouch( entity trigger, entity player, entity caller, var value )
{
	printt( "entered pathtt trigger" )
	PathTT_GiveBoxingHandsAndSaveWeapons( player )
}

void function PathTT_OnMainTriggerEndTouch( entity trigger, entity player, entity caller, var value )
{
	printt( "out of pathtt trigger" )
	PathTT_ReturnWeapons( player )
}

void function PathTT_GiveBoxingHandsAndSaveWeapons( entity player )
{
	StorePilotWeapons( player )
	player.TakeOffhandWeapon(OFFHAND_MELEE)
	player.TakeNormalWeaponByIndexNow( WEAPON_INVENTORY_SLOT_PRIMARY_2 )
	player.GiveWeapon( "mp_weapon_melee_boxing_ring", WEAPON_INVENTORY_SLOT_PRIMARY_2 )
	player.GiveOffhandWeapon( "melee_boxing_ring", OFFHAND_MELEE )
}

void function PathTT_ReturnWeapons( entity player )
{
	RetrievePilotWeapons( player )
}

#if DEVELOPER
void function TpToPathTT()
{
	gp()[0].SetOrigin( <-15581.3467, 22193.5137, -6671.96875> )
	gp()[0].SetAngles( <0, -147.998596, 0> )
}
#endif

#endif

#if CLIENT
void function Cl_PathTT_MonitorIsPlayerInBoxingRing( entity trigger )
{
	entity player = GetLocalViewPlayer()
	if ( !IsValid( player ) )
		return

	EndSignal( player, "OnDestroy" )

	while ( true )
	{
		WaitSignal( trigger, "OnStartTouch", "OnEndTouch" )
		printt( "Passed through trigger" )

		if ( IsAlive( player ) )
			PathTT_PlayerPassThroughRingShieldCeremony( player )
	}

}

void function PathTT_PlayerPassThroughRingShieldCeremony( entity player )
{
	vector org = player.GetOrigin()





		// Signal( player, "DeployableBreachChargePlacement_End" )
		EmitSoundAtPosition( TEAM_UNASSIGNED, org, PLAYER_PASS_THROUGH_RING_SHIELD_SOUND )

}
#endif
