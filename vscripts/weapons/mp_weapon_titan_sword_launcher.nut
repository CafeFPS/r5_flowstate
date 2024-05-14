//By @CafeFPS and Respawn

global function MpWeaponTitanSword_Launcher_Init
global function TitanSword_Launcher_OnWeaponActivate
global function TitanSword_Launcher_ClearMods
global function TitanSword_Launcher_TryLauncher
global function TitanSword_Launcher_VictimHitOverride
global function TitanSword_Launcher_TryLauncherAnimEvent

global const string TITAN_SWORD_LAUNCHER_MOD = "launcher"

const asset VFX_TITAN_SWORD_LAUNCHER_JETS = $"P_pilot_dash_launch_thruster"
const string VFX_TITAN_SWORD_LAUNCHER_TAKEOFF_IMPACT = "pilot_bodyslam"
const TITAN_SWORD_FX_LAUNCH_ATK_FP = $"P_pilot_sword_swipe_launch_FP"
const TITAN_SWORD_FX_LAUNCH_ATK_3P = $"P_pilot_sword_swipe_launch_3P"
const string SFX_TITAN_SWORD_LAUNCH_1P = "Survival_DropSequence_Launch_1P"
const string SFX_TITAN_SWORD_LAUNCH_3P = "Survival_DropSequence_Launch_3P"
const float TITANSWORD_MELEE_KNOCKBACK_SCALE = 150.0
const float TITANSWORD_LAUNCHER_MELEE_KNOCKBACK_SCALE = 50.0

struct
{
	
}file

void function MpWeaponTitanSword_Launcher_Init()	
{
	PrecacheParticleSystem( VFX_TITAN_SWORD_LAUNCHER_JETS )

	PrecacheParticleSystem( TITAN_SWORD_FX_LAUNCH_ATK_FP )
	PrecacheParticleSystem( TITAN_SWORD_FX_LAUNCH_ATK_3P )
}

void function TitanSword_Launcher_OnWeaponActivate( entity player, entity weapon )
{

}

void function TitanSword_Launcher_StartVFX( entity weapon )
{
	// weapon.PlayWeaponEffect( TITAN_SWORD_FX_LAUNCH_ATK_FP, TITAN_SWORD_FX_LAUNCH_ATK_3P, "blade_mid" )
}

void function TitanSword_Launcher_ClearMods( entity weapon )
{
	weapon.RemoveMod( TITAN_SWORD_LAUNCHER_MOD )
}

bool function TitanSword_Launcher_TryLauncher( entity player, entity weapon )
{
	#if CLIENT
		if ( !InPrediction() || !IsFirstTimePredicted() )
			return false
	#endif

	if ( !player.IsOnGround() )
		return false

	if( !IsValid( player ) )
		return false

	if ( !TitanSword_TryUseFuel( player ) )
		return false

	printt( "TRYING LAUNCHER" )
	player.p.launcherStarted = true
	entity melee = GetPlayerMeleeOffhandWeapon( player )

	TitanSword_SafelyAddAttackMod( weapon, TITAN_SWORD_LAUNCHER_MOD )

	if( IsValid( melee ) )
	{
		TitanSword_SafelyAddAttackMod( melee, TITAN_SWORD_LAUNCHER_MOD )
	}

	// TitanSword_Launcher_StartVFX( weapon )

	thread Launcher_Thread( player, weapon )
	return true
}

void function Launcher_Thread( entity player, entity weapon )
{
	player.EndSignal( "OnDeath" )
	player.EndSignal( "OnDestroy" )
	weapon.EndSignal( "OnDestroy" )
	// weapon.EndSignal( SIG_TITAN_SWORD_DEACTIVATE )

	#if CLIENT
	if ( TitanSword_ClientPredictCheck( "launcher" ) )
	{
		EmitSoundOnEntity( player, SFX_TITAN_SWORD_LAUNCH_1P )
	}
	#endif

	OnThreadEnd(
		function() : ( player, weapon )
		{
			if( !IsValid( player ) || !IsValid( weapon ) )
				return

			player.Lunge_ClearTarget()
			player.kv.airSpeed = player.GetPlayerSettingFloat( "airSpeed" )
			player.kv.airAcceleration = player.GetPlayerSettingFloat( "airAcceleration" )
			TitanSword_Launcher_TryLauncherAnimEvent( player, weapon )
			printt( "Launcher_Thread_OnThreadEnd" )
		}
	)

	TitanSword_Launcher_AirControl( player )
	wait 0.35
	printt( "LAUNCHER - AFTER 0.35 NO SIGNALED" )

}

void function TitanSword_Launcher_TryLauncherAnimEvent( entity player, entity weapon )
{
	#if CLIENT
		if ( !InPrediction() || !IsFirstTimePredicted() )
			return
	#endif

	if ( !IsValid( weapon ) || !IsValid( player ) ) //|| !weapon.HasMod( TITAN_SWORD_LAUNCHER_MOD )  )
		return

	player.p.targetsForAoeDamage.clear()
	player.EnableSlowMo()
	
	#if SERVER
	float  knockbackMagnitude = TITANSWORD_LAUNCHER_MELEE_KNOCKBACK_SCALE
	vector currentVel = player.GetVelocity()
	vector lookDirection    = player.GetViewForward()
	vector playerKnockBackVelocity	= knockbackMagnitude * lookDirection

	const float GroundOffset = 10
	playerKnockBackVelocity.z = 0.0
	playerKnockBackVelocity *= 0.5
	float currentVelDotInKnockbackDir = -1.0

	if ( LengthSqr( playerKnockBackVelocity ) > 0.0 )
	{
		currentVelDotInKnockbackDir = DotProduct(Normalize(playerKnockBackVelocity), Normalize(currentVel))
		if( currentVelDotInKnockbackDir <= 0.0  ) 
		{
			// player.KnockBack( playerKnockBackVelocity, 0.25 )
		}
	}
	float velZ = GetWeaponInfoFileKeyField_GlobalFloat( TITAN_SWORD_WEAPON_REF, "launcher_vel_z" )

	
	TitanSword_LaunchEntity( player, <currentVel.x, currentVel.y, velZ> )
	// weapon.Raise()
	// TitanSword_Launcher_AirControl( player )

	printt( "--------------- PLAYER SENT TO AIR", Time() )
	player.GrappleDetach()
	

	// play launcher victim sound here
	EmitSoundOnEntityExceptToPlayer( player, player, SFX_TITAN_SWORD_LAUNCH_3P )
	EmitSoundOnEntityOnlyToPlayer( player, player, SFX_TITAN_SWORD_LAUNCH_1P )
	#endif
}

bool function TitanSword_Launcher_VictimHitOverride( entity weapon, entity attacker, entity victim, vector endpos ) //vector velocity )
{
	#if SERVER
	if ( attacker.p.launcherStarted )
	{
		if ( !IsFriendlyTeam( attacker.GetTeam(), victim.GetTeam() ) )
		{
			float velZ = GetWeaponInfoFileKeyField_GlobalFloat( TITAN_SWORD_WEAPON_REF, "launcher_vel_z" )
			TitanSword_LaunchEntity( victim, <0, 0, velZ> )

			int damageAmount     = weapon.GetDamageAmountForArmorType( victim.GetArmorType() )
			string weaponName = weapon.GetWeaponClassName()
			int damageScriptType = weapon.GetWeaponDamageFlags()
			int damageType       = DMG_MELEE_ATTACK
			int damageSourceId   = (weaponName in eDamageSourceId ? eDamageSourceId[weaponName] : eDamageSourceId.damagedef_unknownBugIt)
			vector damageForce   = <0,0,0>
			vector startPos = attacker.GetOrigin()
			array<entity> ignoreEnts = [ attacker, weapon ]
			vector damageOrigin  = startPos

			table damageTable = {
				scriptType = weapon.GetWeaponDamageFlags(),
				damageType = damageType,
				damageSourceId = damageSourceId,
				origin = damageOrigin,
				force = damageForce
			}
			vector startPosition = attacker.GetOrigin()
			vector endPosition = victim.GetOrigin()

			if( victim.LookupAttachment( "CHESTFOCUS" ) != 0 )
				endPosition = victim.GetAttachmentOrigin( victim.LookupAttachment( "CHESTFOCUS" ) )
			vector hitNormal      = Normalize( startPosition - endPosition )

			attacker.DispatchImpactEffects( victim, attacker.GetOrigin(), endPosition, hitNormal, -1, -1, -1, weapon.GetImpactTableIndex(),	attacker, -1 )

			if( !IsValid( attacker.PlayerMelee_GetAttackHitEntity() ) )
				attacker.PlayerMelee_SetAttackHitEntity( victim )

			victim.TakeDamage( damageAmount, attacker, attacker, damageTable )
			bool targetIsEnemy  = IsEnemyTeam( attacker.GetTeam(), victim.GetTeam() )
			float severityScale = ( targetIsEnemy ? 1.0 : 0.5 )
			weapon.DoMeleeHitConfirmation( severityScale )

			printt( "--------------- VICTIM SENT TO AIR", Time() )
			attacker.p.launcherStarted = false
			return true
		}
	}
	#endif

	attacker.p.launcherStarted = false

	printt( "LAUNCHER ATTACK ENDED" )
	return false
}

void function TitanSword_Launcher_AirControl( entity player )
{
	if ( !IsValid( player ) )
		return

	player.kv.airSpeed = 300
	player.kv.airAcceleration = 1000
	
	#if SERVER
	AddPlayerMovementEventCallback( player, ePlayerMovementEvents.TOUCH_GROUND, OnPlayerTouchGround )
	#endif
}

#if SERVER
void function OnPlayerTouchGround( entity player )
{
	if( !IsValid(player) ) 
		return
	
	StopSoundOnEntity( player, SFX_TITAN_SWORD_LAUNCH_1P )
	RemovePlayerMovementEventCallback( player, ePlayerMovementEvents.TOUCH_GROUND, OnPlayerTouchGround )
	// player.kv.airSpeed = player.GetPlayerSettingFloat( "airSpeed" )
	// player.kv.airAcceleration = player.GetPlayerSettingFloat( "airAcceleration" )
}
#endif