global function MpAbility3Dash_Init

global function OnWeaponActivate_ability_3dash
global function OnWeaponPrimaryAttack_ability_3dash
global function OnWeaponChargeBegin_ability_3dash
global function OnWeaponChargeEnd_ability_3dash
#if SERVER
global function CycleRealms
#endif

const float PHASE_WALK_PRE_TELL_TIME = 1.5
const asset PHASE_WALK_APPEAR_PRE_FX = $"P_phase_dash_pre_end_mdl"
const array<int> realmCycle = [0, 1]
struct
{
	table<entity, int> playerRealmIndexes
} file

void function MpAbility3Dash_Init()
{
	PrecacheParticleSystem( PHASE_WALK_APPEAR_PRE_FX )
}


void function OnWeaponActivate_ability_3dash( entity weapon )
{
	#if SERVER
		entity player = weapon.GetWeaponOwner()
		EmitSoundOnEntityExceptToPlayer(player, player, "Wraith_PhaseGate_Portal_Open")

		if ( player.GetActiveWeapon( eActiveInventorySlot.mainHand ) != player.GetOffhandWeapon( OFFHAND_INVENTORY ) )
			PlayBattleChatterLineToSpeakerAndTeam( player, "bc_skydive" )
	#endif
}


var function OnWeaponPrimaryAttack_ability_3dash( entity weapon, WeaponPrimaryAttackParams attackParams )
{
	entity player = weapon.GetWeaponOwner()
	return weapon.GetWeaponSettingInt( eWeaponVar.ammo_per_shot )
}

bool function OnWeaponChargeBegin_ability_3dash( entity weapon )
{
	entity player = weapon.GetWeaponOwner()
	float chargeTime = weapon.GetWeaponSettingFloat( eWeaponVar.charge_time )
	#if SERVER
		player.p.last3dashtime = Time()
		if (weapon.HasMod("phase_travel"))
		{
			CycleRealms(player)
			foreach (entity p in GetPlayerArray_Alive())
			{
				CycleRealms(p, file.playerRealmIndexes[player])
			}
		}
		else thread DashPlayer(player, chargeTime)
		PlayerUsedOffhand( player, weapon )
	#endif
	return true
}

#if SERVER

void function CycleRealms(entity player, int index = -1)
{
	printl(player)
	if (!(player in file.playerRealmIndexes))
		file.playerRealmIndexes[player] <- file.playerRealmIndexes.len()
	
	if (index != -1)
	{
		player.RemoveFromAllRealms()
		player.AddToRealm(realmCycle[index])
		player.AddToRealm(realmCycle[index] + 2)
		file.playerRealmIndexes[player] <- index
	}
	else
	{
		int nextRealmIndex = file.playerRealmIndexes[player] + 1
		int curRealmIndex = file.playerRealmIndexes[player]
		if (nextRealmIndex >= realmCycle.len()) nextRealmIndex = 0

		player.RemoveFromAllRealms()
		player.AddToRealm(realmCycle[nextRealmIndex])
		player.AddToRealm(realmCycle[nextRealmIndex] + 2)
		file.playerRealmIndexes[player] = nextRealmIndex
	}
}

void function DashPlayer(entity player, float chargeTime)
{
	if ( GetMapName() == "mp_rr_ashs_redemption" ) return
	player.Zipline_Stop()
	vector yes
	if(player.GetInputAxisForward() || player.GetInputAxisRight()) yes = Normalize(player.GetInputAxisForward() * player.GetViewForward() + player.GetInputAxisRight() * player.GetViewRight())
	else yes = Normalize(player.GetVelocity())

	TraceResults result = TraceLine(player.GetOrigin(), player.GetOrigin() + 320 * yes, [player], TRACE_MASK_SHOT, TRACE_COLLISION_GROUP_PLAYER)
	vector originalPos = player.GetOrigin()

	player.SetOrigin(result.endPos)
	if(PutEntityInSafeSpot( player, null, null, player.GetOrigin(), player.GetOrigin() ))
	{
		player.SetVelocity(player.GetVelocity() + 400 * yes)
	}
	else
	{
		player.SetOrigin(originalPos)
	}
}

#endif
void function OnWeaponChargeEnd_ability_3dash( entity weapon )
{
	entity player = weapon.GetWeaponOwner()
	#if SERVER
		foreach ( effect in weapon.w.statusEffects )
		{
			StatusEffect_Stop( player, effect )
		}
		if ( player.IsMantling() || player.IsWallRunning() || player.p.isSkydiving )
			weapon.SetWeaponPrimaryClipCount( 0 ) //Defensive fix for the fact that primary fire isn't triggered when climbing.

	#endif
}