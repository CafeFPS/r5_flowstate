#if SERVER
untyped

global function OnWeaponNpcPrimaryAttack_weapon_zipline
#endif // #if SERVER

global function MpWeaponZipline_Init
global function OnWeaponPrimaryAttack_weapon_zipline
global function OnProjectileCollision_weapon_zipline
global function OnWeaponReadyToFire_weapon_zipline
global function OnWeaponRaise_weapon_zipline

#if CLIENT
global function OnCreateClientOnlyModel_weapon_zipline
#endif

const ZIPLINE_STATION_MODEL_VERTICAL = $"mdl/IMC_base/scaffold_tech_horz_rail_c.rmdl"
const ZIPLINE_STATION_MODEL_HORIZONTAL = $"mdl/industrial/zipline_arm.rmdl"
const ZIPLINE_TEMP_ZIPLINE_GUN_STATION_MODEL = $"mdl/props/pathfinder_zipline/pathfinder_zipline.rmdl"
const ZIPLINE_TEMP_ZIPLINE_GUN_STATION_WALL_MODEL = $"mdl/props/pathfinder_zipline/pathfinder_zipline.rmdl"
const float ZIPLINE_DIST_MIN = 350.0
const float ZIPLINE_DIST_MAX = 10000.0
const ZIPLINE_STATION_EXPLOSION = $"p_impact_exp_small_full"
const float ZIPLINE_REFUND_TIME = 3
const float ZIPLINE_AUTO_DETACH_DISTANCE = 100.0

struct
{
	table<int, entity> activeWeaponBolts
} file

void function MpWeaponZipline_Init()
{
	PrecacheModel( ZIPLINE_STATION_MODEL_VERTICAL )
	PrecacheModel( ZIPLINE_STATION_MODEL_HORIZONTAL )
	PrecacheModel( ZIPLINE_TEMP_ZIPLINE_GUN_STATION_MODEL )
	PrecacheModel( ZIPLINE_TEMP_ZIPLINE_GUN_STATION_WALL_MODEL )
	PrecacheParticleSystem( ZIPLINE_STATION_EXPLOSION )

	PrecacheMaterial( $"cable/zipline" )
	PrecacheModel( $"cable/zipline.vmt" )
}

#if SERVER
var function OnWeaponNpcPrimaryAttack_weapon_zipline( entity weapon, WeaponPrimaryAttackParams attackParams )
{
	return 0
}
#endif // #if SERVER

#if SERVER
void function OnZiplineGrenadeDestroyed( entity weapon, entity projectile )
{
	Assert( IsValid( weapon ) )
	Assert( IsValid( projectile ) )

	OnThreadEnd(
		function() : ( weapon )
		{
			if ( !IsValid( weapon ) )
			{
				return
			}

			if ( weapon.w.ziplineGrenadeCollided )
			{
				// The zipline grenade deployed, so no need to refund (it might still fail deployment, in which case
				// OnZiplineDestroyed() will handle giving the refund).
				return
			}

			// The grenade was destroyed without getting a chance to deploy. Refund the ultimate back to the player.
			weapon.SetWeaponPrimaryClipCount( weapon.GetWeaponPrimaryClipCountMax() )
		}
	)

	EndSignal( weapon, "OnDestroy" )
	EndSignal( projectile, "OnDestroy" )

	WaitForever()
}
#endif

var function OnWeaponPrimaryAttack_weapon_zipline( entity weapon, WeaponPrimaryAttackParams attackParams )
{
	if ( !weapon.ZiplineGrenadeHasValidSpot() )
	{
		weapon.DoDryfire()
		return 0
	}

	#if SERVER
		if ( IsValid( weapon.w.lastProjectileFired ) )
		{
			// There is a zipline grenade already in flight. Don't fire another one.
			weapon.DoDryfire()
			return 0
		}
	#endif

	weapon.EmitWeaponNpcSound( LOUD_WEAPON_AI_SOUND_RADIUS_MP, 0.2 )
	entity weaponOwner = weapon.GetWeaponOwner()
	
	if( !IsValid( weaponOwner ) || !weaponOwner.IsPlayer() )
				return
			
	bool shouldCreateProjectile = false
	if ( IsServer() || weapon.ShouldPredictProjectiles() )
		shouldCreateProjectile = true

	if ( shouldCreateProjectile )
	{
		WeaponFireGrenadeParams fireGrenadeParams
		fireGrenadeParams.pos = attackParams.pos
		fireGrenadeParams.vel = attackParams.dir
		fireGrenadeParams.angVel = <0, 0, 0>
		fireGrenadeParams.fuseTime = 0.0
		fireGrenadeParams.scriptTouchDamageType = 0
		fireGrenadeParams.scriptExplosionDamageType = 0
		fireGrenadeParams.clientPredicted = true
		fireGrenadeParams.lagCompensated = true
		fireGrenadeParams.useScriptOnDamage = true
		fireGrenadeParams.isZiplineGrenade = true

		entity projectile = weapon.FireWeaponGrenade( fireGrenadeParams )

		#if SERVER
			weapon.w.lastProjectileFired = projectile
			weapon.w.ziplineGrenadeCollided = false
			SetTeam( projectile, weaponOwner.GetTeam() )
			projectile.s.weapon <- weapon
			thread WeaponMakesZipline( weapon, projectile )
			thread OnZiplineGrenadeDestroyed( weapon, projectile )

			PlayerUsedOffhand( weaponOwner, weapon, true, projectile )

			ItemFlavor character = LoadoutSlot_GetItemFlavor( ToEHI( weaponOwner ), Loadout_CharacterClass() )
			string charRef = ItemFlavor_GetHumanReadableRef( character )

			if( charRef == "character_pathfinder")
				PlayBattleChatterLineToSpeakerAndTeam( weaponOwner, "bc_super" )
		#else
			PlayerUsedOffhand( weaponOwner, weapon )
		#endif // SERVER

	}

	return weapon.GetWeaponSettingInt( eWeaponVar.ammo_min_to_fire )
}

#if SERVER
void function OnZiplineDestroyed( entity weapon, entity startModel, entity endModel, entity ziplineStart, entity ziplineEnd )
{
	Assert( IsValid( startModel ) || IsValid( endModel ) || IsValid( ziplineStart ) || IsValid( ziplineEnd ) )

	// Need to put this into a table so it gets passed to OnThreadEnd as a reference
	table refundZipline = { value = true }

	OnThreadEnd(
		function () : ( weapon, startModel, endModel, ziplineStart, ziplineEnd, refundZipline )
		{
			if ( IsValid( startModel ) )
			{
				PlayFX( ZIPLINE_STATION_EXPLOSION, startModel.GetOrigin() )
				CreatePhysExplosion( startModel.GetOrigin(), 50, PHYS_EXPLOSION_LARGE, 11 )
				entity shake = CreateShake( startModel.GetOrigin(), 5, 150, 1, 200 )
				shake.kv.spawnflags = 4 // SF_SHAKE_INAIR
				startModel.Destroy()
			}

			if ( IsValid( endModel ) )
			{
				PlayFX( ZIPLINE_STATION_EXPLOSION, endModel.GetOrigin() )
				CreatePhysExplosion( endModel.GetOrigin(), 50, PHYS_EXPLOSION_LARGE, 11 )
				entity shake = CreateShake( endModel.GetOrigin(), 5, 150, 1, 200 )
				shake.kv.spawnflags = 4 // SF_SHAKE_INAIR
				endModel.Destroy()
			}

			if ( IsValid( ziplineStart ) )
			{
				ziplineStart.Destroy()
			}

			if ( IsValid( ziplineEnd ) )
			{
				ziplineEnd.Destroy()
			}

			if ( IsValid( weapon ) )
			{
				if ( refundZipline.value )
				{
					int clipSize = weapon.GetWeaponSettingInt( eWeaponVar.ammo_min_to_fire )
					weapon.SetWeaponPrimaryClipCount( clipSize )
				}
			}
		}
	)

	if ( IsValid( startModel ) )
	{
		EndSignal( startModel, "OnDestroy" )
	}

	if ( IsValid( endModel ) )
	{
		EndSignal( endModel, "OnDestroy" )
	}

	if ( IsValid( ziplineStart ) )
	{
		EndSignal( ziplineStart, "OnDestroy" )
	}

	if ( IsValid( ziplineEnd ) )
	{
		EndSignal( ziplineEnd, "OnDestroy" )
	}

	wait ZIPLINE_REFUND_TIME

	refundZipline.value = false

	WaitForever()
}

void function CreateGunZipline( entity weapon, vector startPos, vector endPos, vector startBasePos, vector endBasePos, entity startModel, entity endModel )
{
	vector delta     = startPos - endPos
	vector direction = Normalize( delta )
	float steepness  = fabs( direction.z )
	bool isSteep     = steepness > 0.7 ? true : false

	entity zipline_start = CreateEntity( "zipline" )
	zipline_start.RemoveFromAllRealms()
	zipline_start.AddToOtherEntitysRealms( weapon )
	zipline_start.kv.Material = "cable/zipline"
	zipline_start.kv.ZiplineAutoDetachDistance = ZIPLINE_AUTO_DETACH_DISTANCE
	zipline_start.kv._zipline_rest_point_0 = startPos.x + " " + startPos.y + " " + startPos.z
	zipline_start.kv._zipline_rest_point_1 = endPos.x + " " + endPos.y + " " + endPos.z
	zipline_start.kv.ZiplineBreakable = 1
	zipline_start.kv.ZiplineBreakableBasePosition = startBasePos.x + " " + startBasePos.y + " " + startBasePos.z
	zipline_start.kv.ZiplineVertical = isSteep
	zipline_start.kv.ZiplinePreserveVelocity = isSteep

	zipline_start.SetParent( startModel, "ATTACH_TOP_ROPE", false, 0.0 )

	entity owner = weapon.GetWeaponOwner()
	if ( IsValid( owner ) )
		zipline_start.SetOwner( owner )

	entity zipline_end = CreateEntity( "zipline_end" )
	zipline_end.RemoveFromAllRealms()
	zipline_end.AddToOtherEntitysRealms( weapon )
	zipline_end.kv.ZiplineAutoDetachDistance = ZIPLINE_AUTO_DETACH_DISTANCE
	zipline_end.kv.ZiplineBreakableBasePosition = endBasePos.x + " " + endBasePos.y + " " + endBasePos.z
	zipline_end.SetParent( endModel, "ATTACH_TOP_ROPE", false, 0.0 )

	zipline_start.LinkToEnt( zipline_end )
	zipline_start.Zipline_WakeUp()

	DispatchSpawn( zipline_start )
	DispatchSpawn( zipline_end )

	thread OnZiplineDestroyed( weapon, startModel, endModel, zipline_start, zipline_end )
}

#endif

bool function CanTetherEntities( entity startEnt, entity endEnt )
{
	TraceResults traceResult = TraceLine( startEnt.GetOrigin(), endEnt.GetOrigin(), [], TRACE_MASK_NPCWORLDSTATIC, TRACE_COLLISION_GROUP_NONE )
	if ( traceResult.fraction < 1 )
		return false

	return true
}


void function OnProjectileCollision_weapon_zipline( entity projectile, vector pos, vector normal, entity hitEnt, int hitbox, bool isCritical )
{
	#if SERVER
		bool ziplineStationSuccessfullyDeployed = false
		entity weapon

		entity owner = projectile.GetOwner()
		if ( IsValid( owner ) )
		{
			if ( owner.IsPlayer() )
			{
				if ( "weapon" in projectile.s )
				{
					weapon = expect entity( projectile.s.weapon )
					if ( IsValid( weapon ) )
					{
						entity ziplineStartModel = weapon.w.ziplineStartModel
						if ( IsValid( ziplineStartModel ) )
						{
							ziplineStartModel.RemoveFromAllRealms()
							ziplineStartModel.AddToOtherEntitysRealms( owner )
							if ( IsValid( weapon.w.ziplineStartPos ) )
							{
								ZiplineStationSpots ornull spotsOrNull = Zipline_FindZiplineStationSpotsForProjectile( projectile, hitEnt, normal, ziplineStartModel.GetOrigin(), ziplineStartModel.GetAngles() )
								if ( spotsOrNull )
								{
									ZiplineStationSpots spots = expect ZiplineStationSpots( spotsOrNull )
									vector startPos           = expect vector( weapon.w.ziplineStartPos )

									// Create anchor model and zipline
									entity ziplineEndModel = CreatePropDynamic( spots.endStationModel, spots.endStationOrigin, spots.endStationAngles )
									ziplineEndModel.RemoveFromAllRealms()
									ziplineEndModel.AddToOtherEntitysRealms( owner )
									ziplineEndModel.SetParent( spots.endStationMoveParent, "", true, 0.0 )
									ziplineEndModel.RemoveOnMovement() // This will make the station destroy itself if it is moved (i.e., its parent moved)
									CreateGunZipline( weapon, spots.beginZiplineOrigin, spots.endZiplineOrigin, spots.beginStationOrigin, spots.endStationOrigin, ziplineStartModel, ziplineEndModel )
									if ( spots.endStationAnimation.len() > 0 )
									{
										ziplineEndModel.Anim_PlayOnly( spots.endStationAnimation )
										EmitSoundOnEntity( ziplineEndModel, "pathfinder_zipline_expand" )
									}
									weapon.w.ziplineStartPos = null

									ziplineStationSuccessfullyDeployed = true
								}
							}
						}
					}
				}
			}
		}

		if ( !ziplineStationSuccessfullyDeployed )
		{
			if ( IsValid( weapon ) )
			{
				weapon.SetWeaponPrimaryClipCount( weapon.GetWeaponPrimaryClipCountMax() )
			}

			foreach( groupEnt in projectile.proj.projectileGroup )
			{
				if ( IsValid( groupEnt ) )
				{
					groupEnt.Destroy()
				}
			}
		}

		if ( IsValid( weapon ) )
		{
			weapon.w.ziplineGrenadeCollided = true
		}
		projectile.Destroy()
	#endif
}


void function OnWeaponReadyToFire_weapon_zipline( entity weapon )
{
	#if SERVER
		PIN_PlayerAbilityReady( weapon.GetWeaponOwner(), ABILITY_TYPE.ULTIMATE )
	#endif
}

#if CLIENT
void function OnCreateClientOnlyModel_weapon_zipline( entity weapon, entity model, bool validHighlight )
{
	if ( validHighlight )
	{
		DeployableModelHighlight( model )
	}
	else
	{
		DeployableModelInvalidHighlight( model )
	}
}
#endif

#if SERVER
void function WeaponMakesZipline( entity weapon, entity grenade )
{
	// Only if the player is on the ground and the grenade is valid

	//Temp fix for a script error. The weapon will be overhauled and this variable will no longer be necessary.
	//Assert( weapon.w.ziplineStartPos == null )
	if ( weapon.w.ziplineStartPos != null )
		weapon.w.ziplineStartPos = null
	entity player = weapon.GetWeaponOwner()
	if ( !IsValid( grenade ) )
		return
	if ( !player.IsOnGround() && !player.IsWallRunning() && !player.IsWallHanging() )
		return

	entity groundEntity = player.GetGroundEntity()
	if ( !IsValid( groundEntity ) )
		return

	if ( groundEntity.GetClassName() == "entity_blocker" )
		return

	if ( !IsAllowedToAttachZiplines( groundEntity ) )
		return

	// Create the base of the zip line at the player position
	vector beginStationOrigin = weapon.GetBeginStationOriginForZiplineGrenade( player )
	vector beginStationAngles = weapon.GetBeginStationAnglesForZiplineGrenade( player )
	entity beginStation = CreateZipLineStation( weapon, player, beginStationOrigin, beginStationAngles, grenade )
	beginStation.RemoveFromAllRealms()
	beginStation.AddToOtherEntitysRealms( grenade )
	beginStation.SetParent( groundEntity, "", true, 0.0 )
	beginStation.RemoveOnMovement() // This will make the station destroy itself if it is moved (i.e., its parent moved)
	beginStation.Anim_PlayOnly( "prop_pathfinder_zipline_release" )
	EmitSoundOnEntity( beginStation, "pathfinder_zipline_expand" )
	int beginStationRopeIndex = beginStation.LookupAttachment( "ATTACH_TOP_ROPE" )
	vector startPos           = beginStation.GetAttachmentOrigin( beginStationRopeIndex )

	weapon.w.ziplineStartPos = startPos
	weapon.w.ziplineStartModel = beginStation
	player.Zipline_SetBeginStation( beginStation, beginStationRopeIndex ) // Tells code to attach the other end of the temporary rope on the grenade to this station
}

entity function CreateZipLineStation( entity weapon, entity player, vector origin, vector angles, entity projectile )
{
	if ( player.IsWallRunning() || player.IsWallHanging() )
	{
		// If we are on a wall we make an anchor on the wall
		entity model = CreatePropDynamic( ZIPLINE_TEMP_ZIPLINE_GUN_STATION_WALL_MODEL, origin, angles, 0 )
		projectile.proj.projectileGroup.append( model )
		return model
	}

	// If we are on the ground we make a pole station
	entity model = CreatePropDynamic( ZIPLINE_TEMP_ZIPLINE_GUN_STATION_MODEL, origin, angles, 0 )
	projectile.proj.projectileGroup.append( model )
	return model
}
#endif

void function OnWeaponRaise_weapon_zipline( entity weapon )
{
	weapon.EmitWeaponSound_1p3p( "pathfinder_zipline_predeploy", "pathfinder_zipline_predeploy" )
}