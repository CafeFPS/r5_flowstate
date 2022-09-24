
global function MpWeaponGrenadeCreepingBombardmentWeapon_Init
global function OnProjectileCollision_WeaponCreepingBombardmentWeapon

const asset CREEPING_BOMBARDMENT_WEAPON_SMOKESCREEN_FX = $"P_smokescreen_FD"
const asset CREEPING_BOMBARDMENT_SMOKE_FX = $"P_bBomb_smoke"

const float CREEPING_BOMBARDMENT_WEAPON_SMOKESCREEN_DURATION = 15.0

const float CREEPING_BOMBARDMENT_WEAPON_DETONATION_DELAY = 8.0

const asset CREEPING_BOMBARDMENT_WEAPON_BOMB_MODEL = $"mdl/weapons_r5/misc_bangalore_rockets/bangalore_rockets_projectile.rmdl"

const CREEPING_BOMBARDMENT_WEAPON_BOMB_IMPACT_TABLE = "exp_creeping_barrage_detonation"
global const CREEPING_BOMBARDMENT_TARGETNAME = "creeping_bombardment_projectile"

void function MpWeaponGrenadeCreepingBombardmentWeapon_Init()
{
	#if SERVER
		PrecacheImpactEffectTable( CREEPING_BOMBARDMENT_WEAPON_BOMB_IMPACT_TABLE )
	#endif //SERVER
	#if CLIENT
		AddTargetNameCreateCallback( CREEPING_BOMBARDMENT_TARGETNAME, AddThreatIndicator )
	#endif //CLIENT

	PrecacheParticleSystem( CREEPING_BOMBARDMENT_WEAPON_SMOKESCREEN_FX )
	PrecacheParticleSystem( CREEPING_BOMBARDMENT_SMOKE_FX )
	PrecacheModel( CREEPING_BOMBARDMENT_WEAPON_BOMB_MODEL )
}

void function OnProjectileCollision_WeaponCreepingBombardmentWeapon( entity projectile, vector pos, vector normal, entity hitEnt, int hitbox, bool isCritical )
{
	entity player = projectile.GetOwner()

	if ( !IsValid( player ) )
		return

	if ( hitEnt == player )
		return

	if ( !EntityShouldStick( projectile, hitEnt ) )
		return

	if ( hitEnt.IsProjectile() )
		return

	if ( !LegalOrigin( pos ) )
		return

	#if SERVER
		//JFS HACK!!!: We need this to hit loot tanks ( needs to be cleaned up to support other moving geo ).
		array<string> lootTankParts = [
			"_hover_tank_interior"
			"_hover_tank_mover"
		]

		bool isLootTank = lootTankParts.contains( hitEnt.GetScriptName() )

		if ( IsValid( hitEnt ) && ( hitEnt.IsWorld() || isLootTank ) )
		{
			thread CreepingBombardmentWeapon_Detonation( pos, -projectile.GetAngles(), normal, hitEnt, player, projectile )
		}
	#endif
}

#if SERVER
void function CreepingBombardmentWeapon_Detonation( vector origin, vector angles, vector normal, entity hitEnt, entity owner, entity projectile )
{
	owner.EndSignal( "OnDestroy" )

	entity bombModel = CreatePropDynamic( CREEPING_BOMBARDMENT_WEAPON_BOMB_MODEL, origin, angles, 0, 4096 )
	entity smokeFX = StartParticleEffectOnEntityWithPos_ReturnEntity( bombModel, GetParticleSystemIndex( CREEPING_BOMBARDMENT_SMOKE_FX ), FX_PATTACH_POINT_FOLLOW_NOROTATE, bombModel.LookupAttachment( "exhaust" ), <0,0,0>, <0,0,0> )

	bombModel.RemoveFromAllRealms()
	bombModel.AddToOtherEntitysRealms( projectile )

	bombModel.SetForwardVector( -normal )
	if ( !hitEnt.IsWorld() )
		bombModel.SetParent( hitEnt, "", true )

	SetTargetName( bombModel, CREEPING_BOMBARDMENT_TARGETNAME )

	OnThreadEnd(
		function() : ( bombModel, smokeFX )
		{
			if ( IsValid( bombModel ) )
				bombModel.Destroy()

			if ( IsValid( smokeFX ) )
				EffectStop( smokeFX )
		}
	)

	wait CREEPING_BOMBARDMENT_WEAPON_DETONATION_DELAY
	
	if( !IsValid(bombModel) || !IsValid(owner) ) return
	
	Explosion_DamageDefSimple( damagedef_creeping_bombardment_detcord_explosion, bombModel.GetOrigin(), owner, owner, bombModel.GetOrigin() )
	entity shake = CreateShake( origin, 5, 150, 1, 1028 )
	shake.RemoveFromAllRealms()
	shake.AddToOtherEntitysRealms( bombModel )
	shake.kv.spawnflags = 4 // SF_SHAKE_INAIR
}
#endif //SERVER

#if CLIENT
void function AddThreatIndicator( entity bomb )
{
	// is there a non dev way to get the radius of the damageDef
	entity player = GetLocalViewPlayer()
	ShowGrenadeArrow( player, bomb, 350, 0.0 )
}
#endif //CLIENT
