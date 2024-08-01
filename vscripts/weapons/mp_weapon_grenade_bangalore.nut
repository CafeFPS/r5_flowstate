
global function MpWeaponGrenadeBangalore_Init
global function OnWeaponActivate_weapon_grenade_bangalore
global function OnProjectileCollision_weapon_grenade_bangalore
global function OnProjectileIgnite_weapon_grenade_bangalore
global function OnWeaponTossReleaseAnimEvent_weapon_grenade_bangalore

#if CLIENT
global function OnClientAnimEvent_weapon_grenade_bangalore
#endif

global function BangSmoke_IsPlayerHighlighted //Shared version by Cafe

const float WEAPON_GAS_GRENADE_DURATION = 15.0
const vector WEAPON_GAS_GRENADE_OFFSET = <0,0,16>
global const string BANGALORE_SMOKESCREEN_SCRIPTNAME = "bangalore_smokescreen"

const asset FX_SMOKESCREEN_BANGALORE = $"P_smokescreen_FD"
const asset FX_SMOKEGRENADE_TRAIL = $"P_SmokeScreen_FD_trail"
const asset BANGALORE_SMOKE_MODEL = $"mdl/weapons/grenades/w_bangalore_canister_gas_projectile.rmdl"

const float BANGALORE_SMOKE_MAX_SAFE_SPAWN_PELLET_DISTANCE = 32.0
const float BANGALORE_SMOKE_DURATION = 8.6
const float BANGALORE_SMOKE_MIN_EXPLODE_DIST_SQR = 512 * 512
const float BANGALORE_SMOKE_DISPERSAL_TIME = 3.0
const float BANGALORE_TACTICAL_AGAIN_TIME = 4.0

const bool BANGALORE_SMOKE_EXPLOSIONS = true
const asset SMOKE_SCREEN_FX = $"P_screen_smoke_bangalore_FP"

const asset FX_MUZZLE_FLASH_FP = $"P_wpn_mflash_bang_rocket_FP"
const asset FX_MUZZLE_FLASH_3P = $"P_wpn_mflash_bang_rocket"

const string BANGALORE_SMOKE_FX_TABLE = "exp_creeping_barrage"
struct
{
	#if CLIENT
		int colorCorrectionGas
	#endif //CLIENT
	
	// Y aquí es cuando esto se vuelve shared lol
	table< entity, table<entity, bool> > highlightedPlayersInSmoke
	float highlightFalloffDistance = 10 * METERS_TO_INCHES
	float highlightDistance = 20 * METERS_TO_INCHES

	int smokeGasScreenFxId
} file

void function MpWeaponGrenadeBangalore_Init()
{
	PrecacheModel( BANGALORE_SMOKE_MODEL )
	PrecacheParticleSystem( FX_SMOKESCREEN_BANGALORE )
	PrecacheParticleSystem( FX_SMOKEGRENADE_TRAIL )
	PrecacheParticleSystem( FX_MUZZLE_FLASH_FP )
	PrecacheParticleSystem( FX_MUZZLE_FLASH_3P )
	PrecacheImpactEffectTable( BANGALORE_SMOKE_FX_TABLE )

	file.smokeGasScreenFxId = PrecacheParticleSystem( SMOKE_SCREEN_FX )

	RegisterSignal( "stop_smokescreen_screen_fx" )

	#if SERVER
		AddDamageCallbackSourceID( eDamageSourceId.damagedef_bangalore_smoke_explosion, Bangalore_DamagedTarget )
	#endif //SERVER

	#if CLIENT
		StatusEffect_RegisterEnabledCallback( eStatusEffect.smokescreen, BangaloreSmokescreenEffectEnabled )
		StatusEffect_RegisterDisabledCallback( eStatusEffect.smokescreen, BangaloreSmokescreenEffectDisabled )

		file.colorCorrectionGas = ColorCorrection_Register( "materials/correction/smoke_cloud.raw_hdr" )
	#endif
}

void function OnWeaponActivate_weapon_grenade_bangalore( entity weapon )
{
}

var function OnWeaponTossReleaseAnimEvent_weapon_grenade_bangalore( entity weapon, WeaponPrimaryAttackParams attackParams )
{
	#if SERVER
		entity owner = weapon.GetOwner()
		if ( Time() - weapon.w.lastFireTime > BANGALORE_TACTICAL_AGAIN_TIME )
			PlayBattleChatterLineToSpeakerAndTeam( owner, "bc_tactical" )
		else
			PlayBattleChatterLineToSpeakerAndTeam( owner, "bc_bangalore_tacticalAgain" )

		weapon.w.lastFireTime = Time()
	#endif // SERVER
	return Grenade_OnWeaponTossReleaseAnimEvent( weapon, attackParams )
}

void function OnProjectileCollision_weapon_grenade_bangalore( entity projectile, vector pos, vector normal, entity hitEnt, int hitbox, bool isCritical )
{
	entity player = projectile.GetOwner()
	if ( hitEnt == player )
		return

	if ( projectile.GrenadeHasIgnited() )
		return

	#if SERVER
		projectile.proj.savedAngles = VectorToAngles( projectile.GetVelocity() )
	#endif //SERVER

	if ( LengthSqr( normal ) < 0.01 ) // collision normal will be <0, 0, 0> if the projectile is somehow INSIDE the hitEnt
		normal = AnglesToForward( VectorToAngles( projectile.GetVelocity() ) )

	#if SERVER
		projectile.proj.savedSurfaceNormal = normal
	#endif //SERVER

	table collisionParams =
	{
		pos = pos,
		normal = normal,
		hitEnt = hitEnt,
		hitbox = hitbox
	}

	projectile.SetModel( $"mdl/dev/empty_model.rmdl" )
	bool result = PlantStickyEntity( projectile, collisionParams, normal )

	projectile.GrenadeIgnite()
	projectile.SetDoesExplode( false )
}

void function OnProjectileIgnite_weapon_grenade_bangalore( entity projectile )
{
	#if SERVER
		const THROW_ANGLE = 65

		entity owner = projectile.GetOwner()
		if ( !IsValid( owner ) )
			return

		if ( projectile.IsMarkedForDeletion() )
			return

		if ( !projectile.proj.isPlanted )
		{
			projectile.SetVelocity( <0, 0, 0> )
			projectile.StopPhysics()
		}

	entity inflictorHelper = CreateDamageInflictorHelper( 1.0 )
	inflictorHelper.RemoveFromAllRealms()
	inflictorHelper.AddToOtherEntitysRealms( projectile )

	vector origin = projectile.GetOrigin()
	vector normal = projectile.proj.savedSurfaceNormal

	//Clamp Velocity Angles to the surface normal.
	vector projectileForward = AnglesToForward( projectile.proj.savedAngles )
	//DebugDrawLine( origin, origin + ( projectileForward * 128.0 ), 0, 255, 255, true, 2 )

	vector projectileRight = AnglesToRight( projectile.proj.savedAngles )
	//DebugDrawLine( origin, origin + ( projectileRight * 128.0 ), 255, 255, 0, true, 2 )

	vector projectileForwardOnSurf = CrossProduct( projectileRight, normal )
	if ( LengthSqr( projectileForwardOnSurf ) < 0.1 * 0.1 ) // Projectile right may be very similar to surface normal
	{
		// use projectile up instead (because it WILL be very different if projectile right is similar)
		vector projectileUp = AnglesToUp( projectile.proj.savedAngles )
		projectileForwardOnSurf = CrossProduct( projectileUp, normal )
		Assert( LengthSqr( projectileForwardOnSurf ) > 0.1 * 0.1 )
	}
	projectileForwardOnSurf = Normalize( projectileForwardOnSurf )
	//DebugDrawLine( origin, origin + ( projectileForwardOnSurf * 128.0 ), 0, 128, 128, true, 2 )

	vector projectileRightOnSurf = CrossProduct( projectileForwardOnSurf, normal )
	Assert( IsNormalized( projectileRightOnSurf )  ) // Because the two args are normalized and perpendicular, this should return a normalized value
	//DebugDrawLine( origin, origin + ( projectileRightOnSurf * 128.0 ), 128, 128, 0, true, 2 )

	vector normalAngles = VectorToAngles( normal )

	array<vector> throwAnglesArray = [ normalAngles, RotateAnglesAboutAxis( normalAngles, projectileForwardOnSurf, THROW_ANGLE ), RotateAnglesAboutAxis( normalAngles, projectileForwardOnSurf, -THROW_ANGLE ) ]
	//array<vector> colorArray = [ <255,0,0>, <0,255,0>, <0,0,255> ]
	foreach( index, throwAngles in throwAnglesArray )
	{
		vector throwVector = AnglesToForward( throwAngles )
		//DebugDrawArrow( origin, origin + throwVector * 128, 16, int( colorArray[index].x ), int( colorArray[index].y ), int( colorArray[index].z ), true, 5.0 )

		entity smokeGrenade = Bangalore_CreateSmokeGrenade( origin, normal )
		smokeGrenade.RemoveFromAllRealms()
		smokeGrenade.AddToOtherEntitysRealms( projectile )

		float throwSpeed = 530
		if ( index == 0 )
			throwSpeed = 256

		smokeGrenade.SetVelocity( throwVector * throwSpeed )

		thread Bangalore_DetonateSmokeGrenade( smokeGrenade, owner, inflictorHelper )
	}

	projectile.Destroy()

#endif //SERVER
}


#if SERVER
entity function Bangalore_CreateSmokeGrenade( vector origin, vector normal )
{
	entity prop_physics = CreateEntity( "prop_physics" )
	prop_physics.SetValueForModelKey( BANGALORE_SMOKE_MODEL )
	prop_physics.kv.spawnflags = 4 // 4 = SF_PHYSPROP_DEBRIS
	prop_physics.kv.fadedist = 2000
	prop_physics.kv.renderamt = 255
	prop_physics.kv.rendercolor = "255 255 255"
	prop_physics.kv.CollisionGroup = TRACE_COLLISION_GROUP_DEBRIS

	prop_physics.kv.minhealthdmg = 9999
	prop_physics.kv.nodamageforces = 1
	prop_physics.kv.inertiaScale = 1.0
	prop_physics.SetIgnorePredictedTriggerTypes( TT_JUMP_PAD ) //| TT_GRAVITY_LIFT | TT_BLACKHOLE  )

	vector maxSafeSpot = origin + normal * BANGALORE_SMOKE_MAX_SAFE_SPAWN_PELLET_DISTANCE
	TraceResults result = TraceLineHighDetail( origin, maxSafeSpot, null, TRACE_MASK_GRENADE, TRACE_COLLISION_GROUP_PROJECTILE )
	vector safeSpot = result.endPos
	//DebugDrawLine( safeSpot, origin, COLOR_BLUE, false, 25.0 )

	PutEntityInSafeSpot( prop_physics, null, null, safeSpot, origin )
	DispatchSpawn( prop_physics )
	prop_physics.SetModel( BANGALORE_SMOKE_MODEL )

	entity fx = PlayFXOnEntity( FX_SMOKEGRENADE_TRAIL, prop_physics )
	prop_physics.e.fxArray.append( fx )

	return prop_physics
}

void function Bangalore_DetonateSmokeGrenade( entity smokeGrenade, entity owner, entity inflictorHelper )
{
	const FUSE_TIME = 0.75

	EndSignal( owner, "OnDestroy" )
	EndSignal( owner, "CleanUpPlayerAbilities" )
	EndSignal( smokeGrenade, "OnDestroy" )

	OnThreadEnd(
		function() : ( smokeGrenade )
		{
			if ( IsValid( smokeGrenade ) )
				smokeGrenade.Destroy()
		}
	)

	wait FUSE_TIME

	if( GetCurrentPlaylistVarBool( "lsm_mod12", false ) )
	{
		entity dummyCloudSource = CreateScriptMover( smokeGrenade.GetOrigin() )
		dummyCloudSource.SetOwner( owner )
		if(owner)
		{
			dummyCloudSource.RemoveFromAllRealms()
			dummyCloudSource.AddToOtherEntitysRealms( owner )
		}


		CreateGasCloudLarge( dummyCloudSource, WEAPON_GAS_GRENADE_DURATION, WEAPON_GAS_GRENADE_OFFSET )
		return
	}

	vector origin = smokeGrenade.GetOrigin()

	float dist2D = DistanceSqr( owner.GetOrigin(), origin )
	bool shouldExplode = ( dist2D > BANGALORE_SMOKE_MIN_EXPLODE_DIST_SQR && BANGALORE_SMOKE_EXPLOSIONS )

	SmokescreenStruct smokescreen

	smokescreen.smokescreenFX = FX_SMOKESCREEN_BANGALORE
	smokescreen.origin = origin
	smokescreen.angles = <0,0,0>
	smokescreen.fxOffsets = [ <0.0, 0.0, 0.0> ]
	smokescreen.traceBlockerTeam = owner.GetTeam()
	smokescreen.traceBlockerScriptName = BANGALORE_SMOKESCREEN_SCRIPTNAME

	smokescreen.isElectric = false
	smokescreen.shouldHibernate = false
	smokescreen.lifetime = BANGALORE_SMOKE_DURATION
	smokescreen.ownerTeam = TEAM_UNASSIGNED
	smokescreen.attacker = owner
	smokescreen.inflictor = owner
	smokescreen.blockLOS = true
	smokescreen.weaponOrProjectile = null
	smokescreen.damageInnerRadius = 320.0
	smokescreen.damageOuterRadius = 350.0
	smokescreen.damageDelay = 1.5
	smokescreen.dpsPilot = 0
	smokescreen.dpsTitan = 0
	smokescreen.deploySound1p = "bangalore_smoke_screen_3p"
	smokescreen.deploySound3p = "bangalore_smoke_screen_3p"
	smokescreen.stopSound1p = "bangalore_smoke_screen_stop_3p"
	smokescreen.stopSound3p = "bangalore_smoke_screen_stop_3p"

	Smokescreen( smokescreen, owner )

	thread CreateSmokeTrigger( smokescreen, smokeGrenade )

	EmitSoundAtPosition( TEAM_UNASSIGNED, origin, "bangalore_smoke_grenade_explosion_3p", owner )

	if ( shouldExplode )
	{
		Explosion_DamageDefSimple( damagedef_bangalore_smoke_explosion, origin + <0,0,4>, owner, inflictorHelper, origin )
		entity shake = CreateShake( origin, 5, 150, 1, 1028 )
		shake.RemoveFromAllRealms()
		shake.kv.spawnflags = 4 // SF_SHAKE_INAIR
		shake.AddToOtherEntitysRealms( smokeGrenade )
	}

	TrackingVision_CreatePOI( eTrackingVisionNetworkedPOITypes.PLAYER_ABILITIES_SMOKE, owner, origin, owner.GetTeam(), owner )
}

void function Bangalore_DamagedTarget( entity victim, var damageInfo )
{
	//if the attacker is a valid friendly set damage do zero.
	//Note: We need the FF so we can trigger the shellshock effect.
	entity attacker = DamageInfo_GetAttacker( damageInfo )
	if ( IsValid( attacker ) )
	{
		if ( IsFriendlyTeam( attacker.GetTeam(), victim.GetTeam() ) && (attacker != victim) )
			DamageInfo_ScaleDamage( damageInfo, 0 )
	}
}

void function CreateSmokeTrigger( SmokescreenStruct smokescreen, entity smokeGrenade )
{
	vector origin = smokescreen.origin
	int radius = int( smokescreen.damageOuterRadius / 1.5 )
	int aboveHeight = radius / 2
	int belowHeight = 0


	entity trigger = CreateEntity( "trigger_cylinder" )
	trigger.SetRadius( radius )
	trigger.SetAboveHeight( aboveHeight )
	trigger.SetBelowHeight( belowHeight )
	trigger.SetOrigin( origin )
	trigger.kv.triggerFilterNonCharacter = "0"
	trigger.RemoveFromAllRealms()
	trigger.AddToOtherEntitysRealms( smokescreen.inflictor )
	DispatchSpawn( trigger )

	trigger.SetEnterCallback( BangaloreSmokeGrenadeTriggerEnter )
	trigger.SearchForNewTouchingEntity()  // set this to catch an entity in the trigger right away

	#if DEVELOPER
	DrawAngledBox( origin, smokeGrenade.GetAngles(), <-20, -20, -16>, <200, 280, 150>, 255, 0, 0, true, 15 )
	#endif

	EndSignal( trigger, "OnDestroy" )
	EndSignal( trigger, "CleanUpPlayerAbilities" )

	OnThreadEnd(
		function () : ( trigger)
		{
			if ( IsValid( trigger ) )
				trigger.Destroy()
		}
	)

	float timeToWait = smokescreen.lifetime + BANGALORE_SMOKE_DISPERSAL_TIME

	wait timeToWait
}

void function BangaloreSmokeGrenadeTriggerEnter( entity trigger, entity ent )
{
	thread BangaloreSmokeGrenadeTriggerTouchingThread( trigger, ent )
}

void function BangaloreSmokeGrenadeTriggerTouchingThread( entity trigger, entity ent )
{
	EndSignal( trigger, "OnDestroy" )
	EndSignal( ent, "OnDestroy" )
	EndSignal( ent, "OnDeath" )

	if ( !ent.IsPlayer() && !ent.IsPlayerDecoy() )
		return

	if ( !ent.DoesShareRealms( trigger ) )
		return

	OnThreadEnd(
		function() : ( ent )
		{
			float severity = StatusEffect_GetSeverity( ent, eStatusEffect.smokescreen )
			StatusEffect_StopAllOfType( ent, eStatusEffect.smokescreen )
			StatusEffect_AddTimed( ent, eStatusEffect.smokescreen, severity, 1.0, 1.0 )
			ent.Signal( "stop_smokescreen_screen_fx" )
		}
	)

	float radius = trigger.GetRadius()
	float radiusSqr = radius * radius
	int lastStatusEffectId = -1

	//Cafe was here. Server side implementation for bangs highlight
	if ( BangSmokeHighlightsEnabled() )
	{
		thread SmokeHighlight_Thread( ent )
	}	//SERVER

	while( trigger.IsTouching( ent ) )
	{
		float distance = DistanceSqr( trigger.GetOrigin(), ent.GetOrigin() )
		float severity = GraphCapped( distance, 0, radiusSqr, 1, 0.25 )	// close to the center the more screen fx

		if ( lastStatusEffectId != -1 )
			StatusEffect_Stop( ent, lastStatusEffectId )
		lastStatusEffectId = StatusEffect_AddEndless( ent, eStatusEffect.smokescreen, severity )

		WaitFrame()
	}
}

#endif //SERVER

bool function BangSmokeHighlightsEnabled()
{
	return GetCurrentPlaylistVarBool( "bangalore_smoke_highlight", true )
}

void function SmokeHighlight_Thread( entity player )
{
	EndSignal( player, "OnDestroy", "OnDeath", "stop_smokescreen_screen_fx" )

	table< entity, bool > highlightedPlayers
	file.highlightedPlayersInSmoke[player] <- highlightedPlayers

	OnThreadEnd(
		function() : ( player, highlightedPlayers )
		{
			if( player in file.highlightedPlayersInSmoke )
				delete file.highlightedPlayersInSmoke[player]

			#if CLIENT
			foreach ( entity otherPlayer, bool isHightlighted in highlightedPlayers )
			{
				ManageHighlightEntity( otherPlayer )
			}
			#endif
		}
	)

	const float effectMin = 0.6
	const float effectMax = 0.2
	int contextId = HIGHLIGHT_CHARACTER_SPECIAL_HIGHLIGHT // :nerd:

	while(true)
	{
		array< entity > playersToHighlight
		array< entity > playersToNotHighlight

		float effectStrength = StatusEffect_GetSeverity( player, eStatusEffect.smokescreen )
		float alphaFromStatusEffect = GraphCapped( effectStrength, effectMin, effectMax, 1.0, 0.0 )

		#if SERVER
		player.Highlight_SetCurrentContext( contextId )
		#endif
	
		BangSmoke_GetPlayersToHighlight( player, playersToHighlight, playersToNotHighlight )

		foreach( entity otherPlayer in playersToHighlight )
		{
			if ( !( otherPlayer in highlightedPlayers ) )
			{
				highlightedPlayers[ otherPlayer ] <- false
			}

			if ( highlightedPlayers[otherPlayer] )
			{
				continue
			}

			highlightedPlayers[otherPlayer] = true

			// printt( "smoke highlight should start", otherPlayer, "for player", player )// Cafe
			#if SERVER
			Highlight_SetSpecialHighlight( otherPlayer, "smoke_highlight_blockscan" )
			#endif

			#if CLIENT
			ManageHighlightEntity( otherPlayer )
			#endif
		}

		foreach( entity otherPlayer in playersToNotHighlight )
		{
			if ( otherPlayer in highlightedPlayers )
			{
				if ( !highlightedPlayers[otherPlayer] )
					continue

				highlightedPlayers[otherPlayer] = false

				#if SERVER
				// printt( "highlight should remove" )
				otherPlayer.Highlight_SetFunctions( contextId, 0, true, 0, 2, 0, false ) //remove special highlight. Cafe
				#endif

				#if CLIENT
				ManageHighlightEntity( otherPlayer )
				#endif
			}
		}

		WaitFrame()
	}

}


void function BangSmoke_GetPlayersToHighlight( entity player, array<entity> outPlayersToHighlight, array<entity> outPlayersToNotHighlight )
{
	int playerTeam = player.GetTeam()

	vector visibilityCheckPoint = player.EyePosition()
	float maxSqrDist = file.highlightDistance * file.highlightDistance

	array<entity> allTargets = GetPlayerArray_Alive()
	allTargets.extend( GetEntArrayByScriptName( DECOY_SCRIPTNAME ) )
	allTargets.extend( GetEntArrayByScriptName( CONTROLLED_DECOY_SCRIPTNAME ) )

	TraceResults results
	foreach ( entity otherPlayer in allTargets )
	{
		if ( otherPlayer == player )
			continue

		if( !otherPlayer.DoesShareRealms( player ) ) // missing check. Cafe
			continue
		
		if ( !IsEnemyTeam( playerTeam, otherPlayer.GetTeam() ) )
			continue

		if ( StatusEffect_GetSeverity( otherPlayer, eStatusEffect.smokescreen ) >= 0.2 )
		{
			vector otherPlayerEyePos = otherPlayer.EyePosition()

			if ( DistanceSqr( visibilityCheckPoint, otherPlayerEyePos ) < maxSqrDist )
			{
				results = TraceLine( visibilityCheckPoint, otherPlayerEyePos, [player, otherPlayer], TRACE_MASK_SOLID, TRACE_COLLISION_GROUP_NONE )
				if ( results.fraction == 1.0 )
				{
					outPlayersToHighlight.append( otherPlayer )
					continue
				}
			}
		}

		outPlayersToNotHighlight.append( otherPlayer )
	}
}

bool function BangSmoke_IsPlayerHighlighted( entity player, entity otherPlayer )
{
	if ( !BangSmokeHighlightsEnabled() )
		return false

	if ( !(player in file.highlightedPlayersInSmoke) )
		return false

	if ( !(otherPlayer in file.highlightedPlayersInSmoke[player]) )
		return false

	if ( !file.highlightedPlayersInSmoke[player][otherPlayer] )
		return false

	return true
}

#if CLIENT
void function OnClientAnimEvent_weapon_grenade_bangalore( entity weapon, string name )
{
	GlobalClientEventHandler( weapon, name )

	if ( name == "muzzle_flash" )
	{
		weapon.PlayWeaponEffect( FX_MUZZLE_FLASH_FP, FX_MUZZLE_FLASH_3P, "muzzle_flash" )
	}

}

void function BangaloreSmokescreenEffectDisabled( entity ent, int statusEffect, bool actuallyChanged )
{
	if ( ent != GetLocalViewPlayer() )
		return

	ent.Signal( "GasCloud_StopColorCorrection" )
	ent.Signal( "stop_smokescreen_screen_fx" )

	Chroma_EndSmokescreenEffect()
}

void function BangaloreSmokescreenEffectEnabled( entity ent, int statusEffect, bool actuallyChanged )
{
	if ( ent != GetLocalViewPlayer() )
		return

	entity viewPlayer = ent
	viewPlayer.Signal( "stop_smokescreen_screen_fx" )

	thread UpdatePlayerScreenColorCorrection( viewPlayer, statusEffect, file.colorCorrectionGas )

	//Cafe was here. This is chad part of my implementation
	if ( BangSmokeHighlightsEnabled() )
	{
		thread SmokeHighlight_Thread( ent )
	}	//CLIENT

	if ( !viewPlayer.IsTitan() )
	{
		int fxHandle = StartParticleEffectOnEntityWithPos( viewPlayer, file.smokeGasScreenFxId, FX_PATTACH_ABSORIGIN_FOLLOW, -1, viewPlayer.EyePosition(), <0,0,0> )
		EffectSetIsWithCockpit( fxHandle, true )

		Chroma_StartSmokescreenEffect()

		thread BangaloreSmokescreenEffectThread( viewPlayer, fxHandle, statusEffect )
	}
}

void function BangaloreSmokescreenEffectThread( entity ent, int fxHandle, int statusEffect )
{
	EndSignal( ent, "OnDeath" )
	EndSignal( ent, "stop_smokescreen_screen_fx" )

	OnThreadEnd(
		function() : ( fxHandle )
		{
			if ( !EffectDoesExist( fxHandle ) )
				return

			EffectStop( fxHandle, false, true )
		}
	)

	while( true )
	{
		float severity = StatusEffect_GetSeverity( ent, statusEffect )
		//DebugScreenText( 0.5, 0.25, "severity: " + severity )

		if ( !EffectDoesExist( fxHandle ) )
			break

		EffectSetControlPointVector( fxHandle, 1, <severity,999,0> )
		WaitFrame()
	}
}
#endif // CLIENT
