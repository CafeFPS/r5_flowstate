//Made by @CaféFPS

global function MpWeaponEmoteProjector_Init
global function OnWeaponTossReleaseAnimEvent_WeaponEmoteProjector
global function OnWeaponAttemptOffhandSwitch_WeaponEmoteProjector
global function OnWeaponTossPrep_WeaponEmoteProjector
global function OnProjectileCollision_holospray

#if CLIENT
global function HoloSpray_OnUse
global function GetEmotesTable
#endif

global const int HOLO_PROJECTOR_INDEX = 6

const asset LIGHT_PARTICLE_TEST = $"P_BT_eye_proj_holo"

const vector EMOTE_ICON_TEXT_OFFSET = <0,0,60>

const float HOLO_EMOTE_LIFETIME = 999.0
const string SOUND_HOLOGRAM_LOOP = "Survival_Emit_RespawnChamber"

global const asset HOLO_SPRAY_BASE = $"mdl/props/holo_spray/holo_spray_base.rmdl"

struct
{
	#if SERVER
	
	#endif
	#if CLIENT
		table<int, array<asset> > emotes = {}
	#endif

} file

void function MpWeaponEmoteProjector_Init()
{
	#if CLIENT || SERVER
		PrecacheModel( HOLO_SPRAY_BASE )
		PrecacheParticleSystem(LIGHT_PARTICLE_TEST)
	#endif

	#if CLIENT
		var dataTable = GetDataTable( $"datatable/emotescustom.rpak" )
		
		for ( int i = 0; i < GetDatatableRowCount( dataTable ); i++ )
		{
			int id = GetDataTableInt( dataTable, i, GetDataTableColumnByName( dataTable, "id" ) )
			string emote = GetDataTableString( dataTable, i, GetDataTableColumnByName( dataTable, "asset" ) )
			if(id in file.emotes)
				file.emotes[id].append(CastStringToAsset(emote))
			else
				file.emotes[id] <- [CastStringToAsset(emote)]
			
		}
	#endif
	
	#if SERVER
		AddClientCommandCallback( "HoloSpray_OnUse", ClientCommand_HoloSpray_OnUse )
		
		AddSpawnCallback_ScriptName( "flowstate_holo_spray", ShEHI_OnHoloSprayCreated )
	#endif

}

#if CLIENT
table<int, array<asset> > function GetEmotesTable()
{
	return file.emotes
}
#endif

void function OnProjectileCollision_holospray( entity projectile, vector pos, vector normal, entity hitEnt, int hitbox, bool isCritical )
{
	if( !IsValid(projectile) || !IsValid(projectile.GetOwner()) ) return
	entity player = projectile.GetOwner()
	
	if ( IsValid(hitEnt) && hitEnt.IsPlayer() )
		return
	
	table collisionParams =
	{
		pos = pos,
		normal = normal,
		hitEnt = hitEnt,
		hitbox = hitbox
	}

	bool result = PlantStickyEntityOnWorldThatBouncesOffWalls( projectile, collisionParams, 0.7 )
	
	printt( "collision, result: ", result )

	if(result && IsValid(projectile))
	{
		vector GoodAngles = AnglesOnSurface(normal, -AnglesToRight(player.EyeAngles()))	
		vector origin = projectile.GetOrigin()

		#if SERVER
		entity prop = CreatePropScript_NoDispatchSpawn( HOLO_SPRAY_BASE, origin, GoodAngles, 6 )

		if( projectile.GetParent() ) // Parent to moving ents like train
		{
			#if DEVELOPER
			printt( "Holo spray parented to moving ent" )
			#endif

			entity parentPoint = CreateEntity( "script_mover_lightweight" )
			parentPoint.kv.solid = 0
			parentPoint.SetValueForModelKey( prop.GetModelName() )
			parentPoint.kv.SpawnAsPhysicsMover = 0
			parentPoint.SetOrigin( origin )
			parentPoint.SetAngles( GoodAngles )
			DispatchSpawn( parentPoint )
			parentPoint.SetParent( projectile.GetParent() )
			parentPoint.Hide()
			prop.SetParent(parentPoint)
		}

		prop.SetScriptName( "flowstate_holo_spray" )
		
		entity fx = StartParticleEffectInWorld_ReturnEntity( GetParticleSystemIndex( LIGHT_PARTICLE_TEST ), origin, Vector(-90,0,0) )

		DispatchSpawn( prop )
		
		fx.SetParent( prop )

		prop.e.holoSpraysFX.append(fx)
		player.p.holoSpraysBase.append(prop)

		bool shouldDestroyFirstHolo = false
		
		if(player.p.holoSpraysBase.len() == 3)
			shouldDestroyFirstHolo = true

		if(shouldDestroyFirstHolo)
		{
			entity holoToDestroy = player.p.holoSpraysBase[0]
			player.p.holoSpraysBase.removebyvalue(holoToDestroy)
			
			if(IsValid(holoToDestroy))
			{
				foreach(Fx in holoToDestroy.e.holoSpraysFX)
					if(IsValid(Fx))
						Fx.Destroy()
				holoToDestroy.Destroy()
				
				if( IsValid( holoToDestroy.GetParent() ) )
					holoToDestroy.GetParent().Destroy()
			}
		}
		
		foreach ( sPlayer in GetPlayerArray() )
			Remote_CallFunction_NonReplay( sPlayer, "HoloSpray_OnUse", prop.GetEncodedEHandle(), player.p.holosprayChoice)

		projectile.Destroy()
		#endif
	}
}

bool function OnWeaponAttemptOffhandSwitch_WeaponEmoteProjector( entity weapon )
{
	return true
}

var function OnWeaponTossReleaseAnimEvent_WeaponEmoteProjector( entity weapon, WeaponPrimaryAttackParams attackParams )
{
	#if CLIENT
	if ( !weapon.ShouldPredictProjectiles() )
		return 0
	#endif

	int ammoReq = weapon.GetAmmoPerShot()
	weapon.EmitWeaponSound_1p3p( GetGrenadeThrowSound_1p( weapon ), GetGrenadeThrowSound_3p( weapon ) )
	
	entity player = weapon.GetWeaponOwner()
	int damageFlags = weapon.GetWeaponDamageFlags()
	WeaponFireBoltParams fireBoltParams
	fireBoltParams.pos = attackParams.pos
	fireBoltParams.dir = attackParams.dir
	fireBoltParams.speed = 500
	fireBoltParams.scriptTouchDamageType = damageFlags
	fireBoltParams.scriptExplosionDamageType = damageFlags
	fireBoltParams.clientPredicted = false
	fireBoltParams.additionalRandomSeed = 0
	entity bullet = weapon.FireWeaponBoltAndReturnEntity( fireBoltParams )

	return ammoReq
}

void function OnWeaponTossPrep_WeaponEmoteProjector( entity weapon, WeaponTossPrepParams prepParams )
{
	weapon.EmitWeaponSound_1p3p( GetGrenadeDeploySound_1p( weapon ), GetGrenadeDeploySound_3p( weapon ) )
}

#if CLIENT
void function HoloSpray_OnUse( int propEhandle, int choice )
{
	thread function () : ( propEhandle, choice )
	{
		while ( !EHIHasValidScriptStruct( propEhandle ) )
			WaitFrame()
		
		while( !IsValid( GetEntityFromEncodedEHandle( propEhandle ) ) )
			WaitFrame()

		entity prop = GetEntityFromEncodedEHandle( propEhandle )
		
		vector origin = prop.GetOrigin()
		vector angles =  VectorToAngles( prop.GetOrigin() - GetLocalClientPlayer().GetOrigin() )
		float width = 40
		float height = 40
		
		origin += (AnglesToUp( angles )*-1) * (height*0.5)
		origin.z += 110
		
		var topo = CreateRUITopology_Worldspace( origin, Vector(0,angles.y,0), width, height )
		var rui = RuiCreate( $"ui/basic_image.rpak", topo, RUI_DRAW_WORLD, 32767 )
		
		RuiSetFloat(rui, "basicImageAlpha", 0.8)

		thread EmotePlayAsset( prop, rui, choice )
		thread EmoteSetAngles( prop, topo, origin )
	}()
}

void function EmotePlayAsset( entity prop, var rui, int index )
{
	array<asset> assetsToPlay = file.emotes[index]
	
	if( assetsToPlay.len() == 1 ) //is static
	{
		RuiSetImage( rui, "basicImage", assetsToPlay[0])
		thread PlayAnimatedEmote(prop, rui, assetsToPlay, true)
	}
	else if( assetsToPlay.len() > 1 ) //is gif?
		thread PlayAnimatedEmote(prop, rui, assetsToPlay)
}

void function PlayAnimatedEmote( entity prop, var rui, array<asset> assetsToPlay, bool watchNotAnimated = false )
{
	OnThreadEnd(
		function() : ( rui ) {
			if( rui != null )
				RuiDestroyIfAlive(rui)
		}
	)
	
	if( watchNotAnimated )
	{
		WaitSignal(prop, "OnDestroy")
	} else 
	{
		while( IsValid(prop) )
		{
			foreach(Asset in assetsToPlay)
			{
				if( !IsValid(prop) ) break
				RuiSetImage( rui, "basicImage", Asset)
				wait 0.05
			}
			WaitFrame()
		}
	}
}

void function EmoteSetAngles(entity prop, var topo, vector origin)
{
	vector angles
	
	OnThreadEnd(
		function() : ( topo ) {
			if(topo != null)
				RuiTopology_Destroy( topo )
		}
	)
	
	while( IsValid(prop) )
	{
		WaitFrame()
		
		if( !IsValid( prop ) )
			break

		entity player = GetLocalViewPlayer()
		vector camPos = player.CameraPosition()
		vector camAng = player.CameraAngles()
		vector closestPoint    = GetClosestPointOnLine( camPos, camPos + (AnglesToRight( camAng ) * 100.0), origin )		
		angles = VectorToAngles( origin - closestPoint )
		
		float width = 40
		float height = 40
		
		origin = prop.GetOrigin() + (AnglesToUp( angles )*-1) * (height*0.5)
		origin.z += 110
	
		if (  player.GetAdsFraction() > 0.99 ) //player adsing? hide it
		{
			UpdateOrientedTopologyPos(topo, origin, Vector( 90 * ( player.GetAdsFraction() - 0.1), angles.y, 0), 60, 60)
			continue
		}
		
		UpdateOrientedTopologyPos(topo, origin, Vector(0,angles.y,0), 60, 60)
	}
}
#endif

#if SERVER

bool function ClientCommand_HoloSpray_OnUse( entity player, array<string> args )
{
	if ( !IsValid( player ) || !IsAlive( player ) )
		return true

	if ( args.len() < 1 )
		return true

	player.Signal( "PhaseTunnel_EndPlacement" )
	player.p.holosprayChoice = int( args[0] )

	return true
}

#endif