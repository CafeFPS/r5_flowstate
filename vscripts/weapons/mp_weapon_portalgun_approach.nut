global function OnWeaponPrimaryAttack_portalgun
global function OnProjectileCollision_portalgun
global function OnWeaponActivate_portalgun
global function OnWeaponDeactivate_portalgun
global function MpWeaponPortalGun_Init

#if SERVER
global function SpawnNessyAtCrosshair
#endif

bool VELOCITY_TYPE = false // false = normal - true = smoothed
bool MODIFY_ANGLES = true
float EXTRA_IMPULSE = 800.0

const float MINIMUM_FLOOR_PORTAL_EXIT_VELOCITY = 50.0
const float MINIMUM_FLOOR_PORTAL_EXIT_VELOCITY_PLAYER = 300.0
const float MAXIMUM_PORTAL_EXIT_VELOCITY = 800.0 //portal 2 value = 1000

struct
{
	entity weapon
} file

void function MpWeaponPortalGun_Init()
{
	RegisterSignal( "EndAdsThreadPls" )
	PrecacheParticleSystem( $"P_skydive_trail_CP" )
	PrecacheParticleSystem( $"P_ar_ping_ground_CP" )
	PrecacheParticleSystem( $"P_test_angles_loop" )
}

void function OnWeaponActivate_portalgun( entity weapon )
{
	printt("onweapon activate portal gun")
	file.weapon = weapon
	#if SERVER
	thread IsPlayerTryingToAds(weapon)
	#endif
}

void function OnWeaponDeactivate_portalgun( entity weapon )
{
	weapon.Signal( "EndAdsThreadPls" )
}

var function OnWeaponPrimaryAttack_portalgun(entity weapon, WeaponPrimaryAttackParams attackParams )
{
	#if SERVER
	int damageFlags = weapon.GetWeaponDamageFlags()
	WeaponFireBoltParams fireBoltParams
	fireBoltParams.pos = attackParams.pos
	fireBoltParams.dir = attackParams.dir
	fireBoltParams.speed = 1
	fireBoltParams.scriptTouchDamageType = damageFlags
	fireBoltParams.scriptExplosionDamageType = damageFlags
	fireBoltParams.clientPredicted = false
	fireBoltParams.additionalRandomSeed = 0
	entity bullet = weapon.FireWeaponBoltAndReturnEntity( fireBoltParams )
	
	bool issecondportal = file.weapon.w.issecondportalshot
	
	if(issecondportal){
	entity trailFXHandle = StartParticleEffectOnEntity_ReturnEntity(bullet, GetParticleSystemIndex( $"P_skydive_trail_CP" ), FX_PATTACH_ABSORIGIN_FOLLOW, -1)
	EffectSetControlPointVector( trailFXHandle, 1, <255, 171, 25>)
	EntFireByHandle( trailFXHandle, "Kill", "", 1, null, null )
	EntFireByHandle( trailFXHandle, "Stop", "", 1, null, null )	
	} else {
	entity trailFXHandle = StartParticleEffectOnEntity_ReturnEntity(bullet, GetParticleSystemIndex( $"P_skydive_trail_CP" ), FX_PATTACH_ABSORIGIN_FOLLOW, -1)
	EffectSetControlPointVector( trailFXHandle, 1, <25, 64, 255>)
	EntFireByHandle( trailFXHandle, "Kill", "", 1, null, null )
	EntFireByHandle( trailFXHandle, "Stop", "", 1, null, null )
	}
		
	#endif
	return 1
}

void function OnProjectileCollision_portalgun( entity projectile, vector pos, vector normal, entity hitEnt, int hitbox, bool isCritical )
{
	// #if CLIENT
	// // entity camera = CreateClientSidePointCamera( projectile.GetOrigin(), <0, 0, 0>, 100 )
		
	// #endif
	
	#if SERVER
	bool issecondportal = file.weapon.w.issecondportalshot
	entity player = projectile.GetOwner()

	table collisionParams =
	{
		pos = pos,
		normal = normal,
		hitEnt = hitEnt,
		hitbox = hitbox
	}

	// Stick with perfect angles
	vector GoodAngles = AnglesOnSurface(normal, -AnglesToRight(player.EyeAngles())) //this is hacky by Colombia
	//printt("AnglestoRight(GoodAnglsCalc): " + AnglesToRight(player.EyeAngles()))
	vector fixedPos = projectile.GetOrigin() + (Normalize(normal) * 2)	
	entity root = CreateScriptMover( fixedPos, GoodAngles )
	
	// Cool glow fx
	int fxid2 = GetParticleSystemIndex( $"P_ar_ping_ground_CP" )
	entity portalFX2	= StartParticleEffectInWorld_ReturnEntity( fxid2, root.GetOrigin(), root.GetAngles() )
	portalFX2.SetParent(root)
	
	if(!file.weapon.w.issecondportalshot){
		if(IsValid(file.weapon.w.portal1root)) file.weapon.w.portal1root.Destroy()
		file.weapon.w.portal1savedNormalAngle = VectorToAngles(normal)
		file.weapon.w.portal1savedNormal = normal
		file.weapon.w.portal1savedSurfaceAngle = GoodAngles
		file.weapon.w.portal1root = root
		file.weapon.w.startpos = fixedPos
		EffectSetControlPointVector( portalFX2, 1, <25, 64, 255> )
	} else if(file.weapon.w.issecondportalshot){
		if(IsValid(file.weapon.w.portal2root)) file.weapon.w.portal2root.Destroy()
		file.weapon.w.portal2root = root
		file.weapon.w.portal2savedNormalAngle = VectorToAngles(normal)
		file.weapon.w.portal2savedNormal = normal
		file.weapon.w.portal2savedSurfaceAngle = GoodAngles
		file.weapon.w.endpos = fixedPos
		EffectSetControlPointVector( portalFX2, 1, <255, 171, 25> )
		file.weapon.w.issecondportalshot = false
	}
	
	//Wraith portal fx
	int fxid = GetParticleSystemIndex( $"P_phasegate_portal" )
	entity portalFX	= StartParticleEffectInWorld_ReturnEntity( fxid,  <root.GetOrigin().x, root.GetOrigin().y, root.GetOrigin().z> , root.GetAngles() )
	portalFX.SetParent(root)

	//ref entity
	entity ref = CreateEntity( "prop_dynamic" )
	ref.SetValueForModelKey( $"mdl/dev/empty_model.rmdl" )
	ref.kv.solid = 0
	ref.Hide()
	ref.NotSolid()
	ref.SetOrigin( root.GetOrigin() + normal*50 )
	ref.SetAngles( root.GetAngles() )
	DispatchSpawn( ref )


	//ref angles calc?
	vector org1 = root.GetOrigin()
	vector org2 = ref.GetOrigin()
	vector vec1 = org2 - org1
	vector refAngles = VectorToAngles( vec1 )
	refAngles.x = 0
		
	printt("REF ANGLES" + refAngles)
	printt("NORMAL ANGLE" + normal)
	printt("SURFACE ANGLE" + GoodAngles)

	//Create the trigger
	entity portaltrigger = CreateEntity( "trigger_cylinder" )
	portaltrigger.SetRadius( 50 )
	portaltrigger.SetAboveHeight( 3 )
	portaltrigger.SetBelowHeight( 1 )
	portaltrigger.SetOrigin( root.GetOrigin() )
	portaltrigger.SetAngles( VectorToAngles(normal) )
	DispatchSpawn( portaltrigger )
	portaltrigger.SetParent(root)
	portaltrigger.SetOwner( player )
	
	// DebugDrawCircle( root.GetOrigin(), VectorToAngles(normal), 50, 255, 200, 0, true, 60 )
	
	// DebugDrawText(root.GetOrigin(),"test", true, 60)
	
	// check for two placed portals, if two potals are on floor then reduce radius, if not idk
	
	// vector triggerForward = portaltrigger.GetForwardVector()
	// if( triggerForward.z > 0.90 ) //floor
	// {
	// portaltrigger.SetRadius( 5 )	
	// }
	
	if(issecondportal)
	{
		SetTargetName(portaltrigger, "portal2")
		file.weapon.w.trigger2 = portaltrigger
		file.weapon.w.portal2RefAngles = refAngles
		portaltrigger.SetEnterCallback( SecondToFirstPortalMoveThread )
		portaltrigger.SearchForNewTouchingEntity()		
	} else {
		SetTargetName(portaltrigger, "portal1")	
		file.weapon.w.trigger1 = portaltrigger
		file.weapon.w.portal1RefAngles = refAngles
		portaltrigger.SetEnterCallback( FirstToSecondPortalMoveThread )
		portaltrigger.SearchForNewTouchingEntity()		
	}
	
	//Bouncy portals look bettter
	printt(CheckTwoPortalsState(player))
	if(CheckTwoPortalsState(player) && IsBouncyPortalAkaTwoOnPortalsFloorStruct(player)){
		file.weapon.w.trigger1.SetRadius( 5 )
		file.weapon.w.trigger2.SetRadius( 5 )
		
		DebugDrawCircle( portaltrigger.GetOrigin(), portaltrigger.GetAngles(), 5, 255, 200, 0, true, 60 )
	} else if(CheckTwoPortalsState(player) && IsInfinityPortalStruct(player)){
		// file.weapon.w.trigger1.SetRadius( 5 )
		// file.weapon.w.trigger2.SetRadius( 5 )
		vector forward1 = file.weapon.w.trigger1.GetForwardVector()
		vector forward2 = file.weapon.w.trigger2.GetForwardVector()
		
		if( forward1.z > 0.90 )
			file.weapon.w.trigger1.SetRadius( 50 )
		else if( forward2.z > 0.90 )
			file.weapon.w.trigger2.SetRadius( 50 )
		
		DebugDrawCircle( portaltrigger.GetOrigin(), portaltrigger.GetAngles(), 50, 255, 200, 0, true, 60 )		
	} else {
		
		DebugDrawCircle( portaltrigger.GetOrigin(), portaltrigger.GetAngles(), 50, 255, 200, 0, true, 60 )
	}
	#endif
}

#if SERVER
bool function CheckTwoPortalsState(entity player)
{
	if(file.weapon.w.trigger2 != null && file.weapon.w.trigger1 != null)
		return true
	else
		return false
	unreachable
}

bool function IsInfinityPortalStruct(entity player)
{
	vector forward1 = file.weapon.w.trigger1.GetForwardVector()
	vector forward2 = file.weapon.w.trigger2.GetForwardVector()
	
	if( forward1.z > 0.90 && forward2.z < -0.98)
		return true
	else if( forward2.z > 0.90 && forward1.z < -0.98) 
		return true
	else
		return false
	
	unreachable
}

bool function IsBouncyPortalAkaTwoOnPortalsFloorStruct(entity player)
{
	vector forward1 = file.weapon.w.trigger1.GetForwardVector()
	vector forward2 = file.weapon.w.trigger2.GetForwardVector()
	
	if( forward1.z > 0.90 && forward2.z > 0.90)
		return true
	else
		return false
	
	unreachable	
}

void function FirstToSecondPortalMoveThread( entity trigger, entity ent )
{
	if(ent.e.isplayercomingfromportal2) return ////ignoring ent this frame
	FirstToSecondPortalMove(trigger, ent)
}

void function SecondToFirstPortalMoveThread( entity trigger, entity ent )
//By Retículo Endoplasmático#5955 (CaféDeColombiaFPS)
{
	if(ent.e.isplayercomingfromportal1) return //ignoring ent this frame
	SecondToFirstPortalMove(trigger, ent)
}

void function FirstToSecondPortalMove( entity trigger, entity ent )
//By Retículo Endoplasmático#5955 (CaféDeColombiaFPS)
{
	if(trigger.GetTargetName() != "portal1") return
	if(!IsValid(file.weapon.w.portal2root)) return
	if(!IsValid(file.weapon.w.trigger1)) return
	if(!IsValid(file.weapon.w.trigger2)) return
	
	printt("----------FIRST TO SECOND PORTAL MOVE THREAD----------")
	//TODO: Implement FixByPitchReorientation
	//Source: https://github.com/VSES/SourceEngine2007/blob/master/se2007/game/server/portal/prop_portal.cpp
	// Sometimes reorienting by pitch is more desirable than by roll depending on the portals' orientations and the relative player facing direction
	vector forwardPortal1 =  file.weapon.w.trigger1.GetForwardVector()
	vector upPortal1 = file.weapon.w.trigger1.GetUpVector()
	vector forwardPortal2 =  file.weapon.w.trigger2.GetForwardVector()
	vector upPortal2 = file.weapon.w.trigger2.GetUpVector()
	vector vPlayerForward = ent.GetForwardVector()
	float fPlayerForwardZ = vPlayerForward.z
	vPlayerForward.z = 0.0
	float fForwardLength = vPlayerForward.Length()
	if ( fForwardLength > 0.0 )
	{
		vPlayerForward = Normalize( vPlayerForward )
	}
	bool FixByPitchReorientation
	float fPlayerFaceDotPortalFace = DotProduct(forwardPortal1, vPlayerForward )
	float fPlayerFaceDotPortalUp = DotProduct(upPortal1, vPlayerForward )

	if ( upPortal1.z > 0.99 && // entering wall portal
			  ( fForwardLength == 0.0 ||			// facing strait up or down
				fPlayerFaceDotPortalFace > 0.5 ||	// facing mostly away from portal
				fPlayerFaceDotPortalFace < -0.5 )	// facing mostly toward portal
			)
	{
		FixByPitchReorientation = true
		printt("First to Second: should fix by pitch")
	}
	else if ( ( forwardPortal1.z > 0.99 || forwardPortal1.z < -0.99 ) &&	// entering floor or ceiling portal
			  ( forwardPortal2.z > 0.99 || forwardPortal2.z < -0.99 ) && // exiting floor or ceiling portal 
			  (	fPlayerForwardZ < -0.5 || fPlayerForwardZ > 0.5 )		// facing mustly up or down
			)
	{
		FixByPitchReorientation = true
		printt("First to Second: should fix by pitch")
	}
	else if ( ( forwardPortal2.z > 0.75 && forwardPortal2.z <= 0.99 ) && // exiting wedge portal
			  ( fPlayerFaceDotPortalUp > 0.0 ) // facing toward the top of the portal
			)
	{
		FixByPitchReorientation = true
		printt("First to Second: should fix by pitch")
	}
	else
	{
		FixByPitchReorientation = false
		printt("First to Second: should fix by roll")
	}
	//Save velocity before tp
	vector velocity1
	if(VELOCITY_TYPE) velocity1 = ent.GetSmoothedVelocity()
		else velocity1 = ent.GetVelocity()

	float movementSpeed = velocity1.Length()

	//Tp and set bool to avoid trigger on remote portal
	ent.e.isplayercomingfromportal1 = true
	
	bool isfloororceilPortal = false
	bool isActuallyCeil = false
	float velocity1Lenght = velocity1.Length()
		
	//Implemented by Colombia
	//Source: https://github.com/VSES/SourceEngine2007/blob/master/se2007/game/server/portal/prop_portal.cpp
	//Minimum floor exit velocity if both portals are on the floor or the player is coming out of the floor
	if( forwardPortal2.z > 0.90 ) //floor
	{
		isfloororceilPortal = true
		isActuallyCeil = false
		ent.SetAbsOrigin(file.weapon.w.endpos + Normalize(file.weapon.w.portal2savedNormal)* 2)
		if( velocity1.z < MINIMUM_FLOOR_PORTAL_EXIT_VELOCITY_PLAYER ){
			velocity1.z = MINIMUM_FLOOR_PORTAL_EXIT_VELOCITY_PLAYER			
		}
		
		ent.SetVelocity(<velocity1.x, velocity1.y, velocity1.z>)
		printt("Portal2 is on floor - Executing velocity hack #1 - Not setting angles this time.")
	} else if( forwardPortal2.z < -0.98){ //ceil
		isfloororceilPortal = false
		isActuallyCeil = true
		ent.SetAbsOrigin(file.weapon.w.endpos + Normalize(file.weapon.w.portal2savedNormal)* 100)
		if ( velocity1.LengthSqr() > (MAXIMUM_PORTAL_EXIT_VELOCITY * MAXIMUM_PORTAL_EXIT_VELOCITY)  )
		{
			velocity1 *= (MAXIMUM_PORTAL_EXIT_VELOCITY / velocity1.Length())
			printt("Velocity is higher than max allowed - Executing velocity hack #4 - Limiting velocity to 800 units.")
		}
		velocity1.x = 0
		velocity1.y = 0
		ent.SetVelocity(<velocity1.x, velocity1.y, velocity1.z>)
		// if(MODIFY_ANGLES) 
		// {
		// ent.SnapEyeAngles(file.weapon.w.portal2RefAngles)
		// }

		
		
		// if( velocity1.z < MAXIMUM_PORTAL_EXIT_VELOCITY ){			
			// velocity1.z = -MAXIMUM_PORTAL_EXIT_VELOCITY
		// }
		printt("Portal2 is on ceil - Executing velocity hack #2 - Limiting velocity Pitch and Yaw to 0 - Not setting angles this time.")
	} else {
		isfloororceilPortal = false
		isActuallyCeil = false
		// vector horizonVec = AnglesToForward( FlattenAngles( ent.GetAngles() ) )
		// vector rightVec = AnglesToRight( FlattenAngles( ent.GetAngles() ) )
		ent.SetAbsOrigin(file.weapon.w.endpos + Normalize(file.weapon.w.portal2savedNormal)* 100)
		if(MODIFY_ANGLES) 
		{
		ent.SetAngles(file.weapon.w.portal2RefAngles)
		}

		// vector velNorm           = velocity1 
		// vector endPortalAngles   = file.weapon.w.portal2RefAngles
		// vector relativeAngles = CalcRelativeAngles( endPortalAngles, -file.weapon.w.portal1RefAngles )
		
		vector newDir = RotateVector( -velocity1, file.weapon.w.portal2RefAngles )
		ent.SetVelocity( Normalize(newDir) * movementSpeed )
	
		// if(velocity1.LengthSqr() < (MINIMUM_FLOOR_PORTAL_EXIT_VELOCITY * MINIMUM_FLOOR_PORTAL_EXIT_VELOCITY) && velocity1.LengthSqr() > 0)
		// {
			// velocity1 *= (MINIMUM_FLOOR_PORTAL_EXIT_VELOCITY / velocity1.Length())
			// printt("Velocity is less than min allowed - Executing velocity hack #3 - Setting velocity to 50 unit.")
		// }
	}
	PutEntityInSafeSpot( ent, null, null, ent.GetOrigin(), ent.GetOrigin())
	thread DelayedSetFalse(ent, 1)
	printt("Velocity PORTAL 1 TO 2: " + ent.GetVelocity())
}

void function SecondToFirstPortalMove( entity trigger, entity ent )
{
	if(trigger.GetTargetName() != "portal2") return
	if(!IsValid(file.weapon.w.portal1root)) return
	if(!IsValid(file.weapon.w.trigger1)) return
	if(!IsValid(file.weapon.w.trigger2)) return
	
	printt("----------SECOND TO FIRST PORTAL MOVE THREAD----------")
	//TODO: Implement FixByPitchReorientation
	//Source: https://github.com/VSES/SourceEngine2007/blob/master/se2007/game/server/portal/prop_portal.cpp
	// Sometimes reorienting by pitch is more desirable than by roll depending on the portals' orientations and the relative player facing direction
	vector forwardPortal1 =  file.weapon.w.trigger1.GetForwardVector()
	vector upPortal1 = file.weapon.w.trigger1.GetUpVector()
	vector forwardPortal2 =  file.weapon.w.trigger2.GetForwardVector()
	vector upPortal2 = file.weapon.w.trigger2.GetUpVector()
	vector vPlayerForward = ent.GetForwardVector()
	float fPlayerForwardZ = vPlayerForward.z
	vPlayerForward.z = 0.0
	float fForwardLength = vPlayerForward.Length()
	if ( fForwardLength > 0.0 )
	{
		vPlayerForward = Normalize( vPlayerForward )
	}
	bool FixByPitchReorientation
	float fPlayerFaceDotPortalFace = DotProduct(forwardPortal2, vPlayerForward )
	float fPlayerFaceDotPortalUp = DotProduct(upPortal2, vPlayerForward )
	if ( upPortal2.z > 0.99 && // entering wall portal
			  ( fForwardLength == 0.0 ||			// facing strait up or down
				fPlayerFaceDotPortalFace > 0.5 ||	// facing mostly away from portal
				fPlayerFaceDotPortalFace < -0.5 )	// facing mostly toward portal
			)
	{
		FixByPitchReorientation = true
		printt("Second to First: should fix by pitch")
	}
	else if ( ( forwardPortal2.z > 0.99 || forwardPortal2.z < -0.99 ) &&	// entering floor or ceiling portal
			  ( forwardPortal1.z > 0.99 || forwardPortal1.z < -0.99 ) && // exiting floor or ceiling portal 
			  (	fPlayerForwardZ < -0.5 || fPlayerForwardZ > 0.5 )		// facing mustly up or down
			)
	{
		FixByPitchReorientation = true
		printt("Second to First: should fix by pitch")
	}
	else if ( ( forwardPortal1.z > 0.75 && forwardPortal1.z <= 0.99 ) && // exiting wedge portal
			  ( fPlayerFaceDotPortalUp > 0.0 ) // facing toward the top of the portal
			)
	{
		FixByPitchReorientation = true
		printt("Second to First: should fix by pitch")
	}
	else
	{
		FixByPitchReorientation = false	
		printt("Second to First: should fix by roll")
	}
	
	//Save velocity before tp
	vector velocity1
	if(VELOCITY_TYPE) velocity1 = ent.GetSmoothedVelocity()
		else velocity1 = ent.GetVelocity()
	
	float movementSpeed = velocity1.Length()

	//Tp and set bool to avoid trigger on remote portal
	ent.e.isplayercomingfromportal2 = true
	
	bool isfloororceilPortal = false
	bool isActuallyCeil = false
	
	//Implemented by Colombia
	//Source: https://github.com/VSES/SourceEngine2007/blob/master/se2007/game/server/portal/prop_portal.cpp
	//Minimum floor exit velocity if both portals are on the floor or the player is coming out of the floor
	if( forwardPortal1.z > 0.90 )
	{
		isfloororceilPortal = true
		isActuallyCeil = false
		ent.SetAbsOrigin(file.weapon.w.startpos + Normalize(file.weapon.w.portal1savedNormal) *2)
		if( velocity1.z < MINIMUM_FLOOR_PORTAL_EXIT_VELOCITY_PLAYER ) {			
			velocity1.z = MINIMUM_FLOOR_PORTAL_EXIT_VELOCITY_PLAYER
		}
		ent.SetVelocity(<velocity1.x, velocity1.y, velocity1.z>)
		printt("Portal1 is on floor - Executing velocity hack #1 - Not setting angles this time.")
	} else if( forwardPortal1.z < -0.98){
		isfloororceilPortal = false
		isActuallyCeil = true
		ent.SetAbsOrigin(file.weapon.w.startpos + Normalize(file.weapon.w.portal1savedNormal) *100)
		if ( velocity1.LengthSqr() > (MAXIMUM_PORTAL_EXIT_VELOCITY * MAXIMUM_PORTAL_EXIT_VELOCITY)  )
		{
			velocity1 *= (MAXIMUM_PORTAL_EXIT_VELOCITY / velocity1.Length())
			printt("Velocity is higher than max allowed - Executing velocity hack #4 - Limiting velocity to 800 units.")
		}
		// if(MODIFY_ANGLES) 
		// {
		// ent.SnapEyeAngles(file.weapon.w.portal1RefAngles)
		// }

		velocity1.x = 0
		velocity1.y = 0
		
		ent.SetVelocity(<velocity1.x, velocity1.y, velocity1.z>)
		// if( velocity1.z < MAXIMUM_PORTAL_EXIT_VELOCITY ){			
			// velocity1.z = -MAXIMUM_PORTAL_EXIT_VELOCITY
		// }
		printt("Portal1 is on ceil - Executing velocity hack #2 - Limiting velocity Pitch and Yaw to 0 - Not setting angles this time.")
	} else {
		ent.SetAbsOrigin(file.weapon.w.startpos + Normalize(file.weapon.w.portal1savedNormal) *100)
		isfloororceilPortal = false
		isActuallyCeil = false
		
		// vector horizonVec = AnglesToForward( FlattenAngles( ent.GetAngles() ) )
		// vector rightVec = AnglesToRight( FlattenAngles( ent.GetAngles() ) )
		
		if(MODIFY_ANGLES) 
		{
		ent.SetAngles(file.weapon.w.portal1RefAngles)
		}
		
		// vector velNorm           =  velocity1 
		// vector endPortalAngles   = file.weapon.w.portal1RefAngles
		// vector relativeAngles = CalcRelativeAngles( endPortalAngles, -file.weapon.w.portal2RefAngles )
		
		vector newDir = RotateVector( -velocity1, file.weapon.w.portal1RefAngles )
		ent.SetVelocity( Normalize(newDir) * movementSpeed )
		
		//vector newDir       = RotateVector( velNorm, file.weapon.w.trigger1.GetForwardVector() )

	
		// if(velocity1.LengthSqr() < (MINIMUM_FLOOR_PORTAL_EXIT_VELOCITY * MINIMUM_FLOOR_PORTAL_EXIT_VELOCITY) && velocity1.LengthSqr() > 0)
		// {
			// velocity1 *= (MINIMUM_FLOOR_PORTAL_EXIT_VELOCITY / velocity1.Length())
			// printt("Velocity is less than min allowed - Executing velocity hack #3 - Setting velocity to 50 unit.")
		// }
	}
	PutEntityInSafeSpot( ent, null, null, ent.GetOrigin(), ent.GetOrigin())
	thread DelayedSetFalse(ent, 2)
	printt("Velocity PORTAL 2 TO 1: " + ent.GetVelocity())
}

void function DelayedSetFalse(entity ent, int portalId)
{
	WaitFrame()
	if(portalId == 1){
		ent.e.isplayercomingfromportal1 = false}
	else if(portalId == 2){
		ent.e.isplayercomingfromportal2 = false
	}
}

void function SpawnNessyAtCrosshair()
{
	entity player = GetPlayerArray()[ 0 ]
	vector origin = GetPlayerCrosshairOrigin( player )
	vector angles = player.GetAngles()*-1
	entity prop_physics = CreateEntity( "prop_physics" )
	prop_physics.SetValueForModelKey( $"mdl/domestic/nessy_doll.rmdl" )
	prop_physics.kv.spawnflags = 0
	prop_physics.kv.modelscale = 1
	prop_physics.kv.fadedist = -1
	prop_physics.kv.physdamagescale = 0.1
	prop_physics.kv.inertiaScale = 1.0
	prop_physics.kv.renderamt = 255
	prop_physics.kv.rendercolor = "255 255 255"
	SetTeam( prop_physics, TEAM_BOTH )
	prop_physics.SetOrigin( origin + <0, 0, 100> )
	prop_physics.SetAngles( angles )
	DispatchSpawn( prop_physics )
}

void function IsPlayerTryingToAds(entity weapon)
{
	weapon.EndSignal("EndAdsThreadPls")
	entity player = weapon.GetOwner()
	bool onlyonetime = false
	bool isinads = false
	
	printt("ads thread started")
	OnThreadEnd(
		function() : ( )
		{
			printt("ads thread killed")
		}
	)
	while(IsValid(weapon)){
		isinads = player.IsInputCommandHeld( IN_ZOOM | IN_ZOOM_TOGGLE )
		if(isinads && !onlyonetime) {
			if(!IsValid(player)) return
			onlyonetime = true
				if(IsValid(file.weapon)){
					file.weapon.w.issecondportalshot = true
					ClientCommand( player, "+attack" )
					ClientCommand( player, "-attack" )
				}
			} else if (!isinads && onlyonetime) {
			onlyonetime = false
			}
		WaitFrame()
	}
}
#endif
