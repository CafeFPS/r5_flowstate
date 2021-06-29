
global function MpWeaponGrenadeCreepingBombardment_Init
global function OnProjectileCollision_WeaponCreepingBombardment
global function OnWeaponReadyToFire_WeaponCreepingBombardment
global function OnWeaponTossReleaseAnimEvent_WeaponCreepingBombardment
global function OnWeaponDeactivate_WeaponCreepingBombardment

#if SERVER
global function CreepingBombardmentSmoke
#endif

//Bangalore Ult
const string CREEPING_BOMBARDMENT_MISSILE_WEAPON = "mp_weapon_creeping_bombardment_weapon"
const SFX_BOMBARDMENT_EXPLOSION_BANGALORE = "skyway_scripted_titanhill_mortar_explode"

const float CREEPING_BOMBARDMENT_WIDTH 		 	= 2750 //The width of the bombardment line is 4098
const float CREEPING_BOMBARDMENT_BOMBS_PER_STEP = 6
const int 	CREEPING_BOMBARDMENT_STEP_COUNT		= 6//16 //The bombardment will advance a total of 10 steps before it ends.
const float CREEPING_BOMBARDMENT_STEP_INTERVAL 	= 0.75//1.0 //The bombardment will advance 1 step every 2.5 seconds.
const float CREEPING_BOMBARDMENT_DELAY 			= 2.0 //The bombardment will wait 2.0 seconds before firing the first shell.

const float CREEPING_BOMBARDMENT_SHELLSHOCK_DURATION = 8.0

const asset FX_CREEPING_BOMBARDMENT_FLARE = $"P_bFlare"
const asset FX_CREEPING_BOMBARDMENT_GLOW_FP = $"P_bFlare_glow_FP"
const asset FX_CREEPING_BOMBARDMENT_GLOW_3P = $"P_bFlare_glow_3P"

const string CREEPING_BOMBARDMENT_FLARE_SOUND 	= "Bangalore_Ultimate_Flare_Hiss"

void function MpWeaponGrenadeCreepingBombardment_Init()
{
	PrecacheWeapon( CREEPING_BOMBARDMENT_MISSILE_WEAPON )

	PrecacheParticleSystem( FX_CREEPING_BOMBARDMENT_FLARE )
	PrecacheParticleSystem( FX_CREEPING_BOMBARDMENT_GLOW_FP )
	PrecacheParticleSystem( FX_CREEPING_BOMBARDMENT_GLOW_3P )

	#if SERVER
		//AddDamageCallbackSourceID( eDamageSourceId.mp_weapon_creeping_bombardment_weapon, CreepingBombardment_DamagedTarget )
		AddDamageCallbackSourceID( eDamageSourceId.damagedef_creeping_bombardment_detcord_explosion, CreepingBombardment_DamagedTarget )
	#endif //SERVER

}

void function OnWeaponReadyToFire_WeaponCreepingBombardment( entity weapon )
{
	weapon.PlayWeaponEffect( FX_CREEPING_BOMBARDMENT_GLOW_FP, FX_CREEPING_BOMBARDMENT_GLOW_3P, "FX_TRAIL" )
}

void function OnWeaponDeactivate_WeaponCreepingBombardment( entity weapon )
{
	weapon.StopWeaponEffect( FX_CREEPING_BOMBARDMENT_GLOW_FP, FX_CREEPING_BOMBARDMENT_GLOW_3P )
	Grenade_OnWeaponDeactivate( weapon )
}

var function OnWeaponTossReleaseAnimEvent_WeaponCreepingBombardment( entity weapon, WeaponPrimaryAttackParams attackParams )
{
	Grenade_OnWeaponTossReleaseAnimEvent( weapon, attackParams )

	weapon.StopWeaponEffect( FX_CREEPING_BOMBARDMENT_GLOW_FP, FX_CREEPING_BOMBARDMENT_GLOW_3P )

	entity weaponOwner = weapon.GetWeaponOwner()
	Assert( weaponOwner.IsPlayer() )

	#if SERVER
		entity bombardmentWeapon = weaponOwner.GetOffhandWeapon( OFFHAND_RIGHT )
		if ( !IsValid( bombardmentWeapon ) )
			weaponOwner.GiveOffhandWeapon( CREEPING_BOMBARDMENT_MISSILE_WEAPON, OFFHAND_RIGHT, [] )
		PlayBattleChatterLineToSpeakerAndTeam( weaponOwner, "bc_super" )
	#endif

	return weapon.GetWeaponSettingInt( eWeaponVar.ammo_per_shot )
}

void function OnProjectileCollision_WeaponCreepingBombardment( entity projectile, vector pos, vector normal, entity hitEnt, int hitbox, bool isCritical )
{
	entity player = projectile.GetOwner()
	if ( hitEnt == player )
		return

	if ( projectile.GrenadeHasIgnited() )
		return

	table collisionParams =
	{
		pos = pos,
		normal = normal,
		hitEnt = hitEnt,
		hitbox = hitbox
	}

	bool result = PlantStickyEntityOnWorldThatBouncesOffWalls( projectile, collisionParams, 0.7 )

#if SERVER
	if ( !result )
	{
		return
	}
	else if ( IsValid( hitEnt ) && ( hitEnt.IsPlayer() || hitEnt.IsTitan() || hitEnt.IsNPC() ) )
	{
		thread CreepingBombardmentSmoke( projectile, FX_CREEPING_BOMBARDMENT_FLARE )
	}
	else
	{
		thread CreepingBombardmentSmoke( projectile, FX_CREEPING_BOMBARDMENT_FLARE )
	}
#endif
	projectile.GrenadeIgnite()
	projectile.SetDoesExplode( false )
}

#if SERVER
void function CreepingBombardment_DamagedTarget( entity victim, var damageInfo )
{
	// Seems like we need this since the invulnerability from phase shift has not kicked in at this point yet
	if ( victim.IsPhaseShifted() )
		return

	//if the attacker is a valid friendly set damage do zero.
	//Note: We need the FF so we can trigger the shellshock effect.
	entity attacker = DamageInfo_GetAttacker( damageInfo )
	if ( IsValid( attacker ) )
	{
		if ( IsFriendlyTeam( attacker.GetTeam(), victim.GetTeam() ) && (attacker != victim) )
			DamageInfo_ScaleDamage( damageInfo, 0 )
		else if ( DamageInfo_GetDamage( damageInfo ) > 0 )
			StatsHook_CreepingBarrageDamage( attacker, int( DamageInfo_GetDamage( damageInfo ) ) )
	}

	if ( victim.IsPlayer() )
		ShellShock_ApplyForDuration( victim, CREEPING_BOMBARDMENT_SHELLSHOCK_DURATION )
}

void function CreepingBombardmentSmoke( entity projectile, asset fx )
{
	entity owner = projectile.GetThrower()

	if ( !IsValid( owner ) )
		return

	entity bombardmentWeapon = VerifyBombardmentWeapon( owner, CREEPING_BOMBARDMENT_MISSILE_WEAPON )
	if ( !IsValid( bombardmentWeapon ) )
		return

	vector origin = projectile.GetOrigin()

	int fxid = GetParticleSystemIndex( fx )
	entity signalFX = StartParticleEffectOnEntityWithPos_ReturnEntity( projectile, fxid, FX_PATTACH_POINT_FOLLOW_NOROTATE, projectile.LookupAttachment( "FX_TRAIL" ), <0,0,0>, <0,0,0> )
	vector dir = Normalize ( FlattenVector ( projectile.GetOrigin() - owner.GetOrigin() ) )
	//float explosionRadius = bombardmentWeapon.GetWeaponSettingFloat( eWeaponVar.explosionradius )

	EmitSoundOnEntity( projectile, CREEPING_BOMBARDMENT_FLARE_SOUND )

	thread Bombardment_MortarBarrageDetCord( bombardmentWeapon, $"", dir, origin + <0,0,10000>, projectile.GetOrigin(),
		CREEPING_BOMBARDMENT_WIDTH,
		CREEPING_BOMBARDMENT_WIDTH / CREEPING_BOMBARDMENT_BOMBS_PER_STEP,
		CREEPING_BOMBARDMENT_STEP_COUNT,
		CREEPING_BOMBARDMENT_STEP_INTERVAL,
		CREEPING_BOMBARDMENT_DELAY )

	float duration = CREEPING_BOMBARDMENT_STEP_COUNT * CREEPING_BOMBARDMENT_STEP_INTERVAL
	wait duration + CREEPING_BOMBARDMENT_DELAY

	if ( IsValid( signalFX ) )
		EffectStop( signalFX )
}
#endif