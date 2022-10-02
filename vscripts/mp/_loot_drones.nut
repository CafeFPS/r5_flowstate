///////////////////////////////////////////////////////
//By Retículo Endoplasmático#5955 (CaféDeColombiaFPS)//
///////////////////////////////////////////////////////
global function InitLootDrones
global function InitLootDronePaths
global function SpawnLootDrones
global const string LOOT_DRONE_PATH_NODE_ENTNAME = "loot_drone_path_node"
global const float LOOT_DRONE_START_NODE_SELECTION_MIN_DISTANCE = 50
global const vector LOOT_DRONE_ROTATOR_OFFSET = <8,0,-45>
global const vector LOOT_DRONE_ROTATOR_DIR = <0,0,1>
global const float LOOT_DRONE_ROTATOR_SPEED = 60
global const float LOOT_DRONE_EXPLOSION_RADIUS = 128.0
global const float LOOT_DRONE_EXPLOSION_DAMAGE = 30.0
global const float LOOT_DRONE_EXPLOSION_DAMAGEID = eDamageSourceId.ai_turret_explosion

struct {
	array<array<entity> > dronePaths
	table<entity, LootDroneData> droneData
	array<LootDroneData> spawnedDronesorFlyers
	entity lastattacker
	array<LootData> ItemsTier1
	array<LootData> ItemsTier2
	array<LootData> ItemsTier3
	array<LootData> ItemsTier4
	int idk = 0
} file

void function InitLootDrones()
{
	RegisterSignal( SIGNAL_LOOT_DRONE_FALL_START )
	RegisterSignal( SIGNAL_LOOT_DRONE_STOP_PANIC )
	FlagInit( "DronePathsInitialized", false )
}

void function InitLootDronePaths()
{
	file.ItemsTier1 = SURVIVAL_Loot_GetByTier(1)
	file.ItemsTier2 = SURVIVAL_Loot_GetByTier(2)
	file.ItemsTier3 = SURVIVAL_Loot_GetByTier(3)
	file.ItemsTier4 = SURVIVAL_Loot_GetByTier(4)

	// No nodes on this map?
	if ( GetMapName() == "mp_rr_canyonlands_staging")
		return


	if(GetMapName() == "mp_rr_desertlands_64k_x_64k" && !GetCurrentPlaylistVarBool("flowstateFlyersOverride", false ) || GetMapName() == "mp_rr_desertlands_64k_x_64k_nx" && !GetCurrentPlaylistVarBool("flowstateFlyersOverride", false ))
	{
		// Get all drone path nodes (mixed)
		array<entity> dronePathNodes = GetEntArrayByScriptName( LOOT_DRONE_PATH_NODE_ENTNAME )

		// No nodes on this map?
		if ( dronePathNodes.len() == 0 || GetMapName() == "mp_rr_canyonlands_staging")
		{
			return
		}

		// Separate nodes into groups
		while ( dronePathNodes.len() > 0 )
		{
			// Get a random node
			entity node = dronePathNodes.getrandom()

			// Get all nodes associated with it
			array<entity> groupNodes = GetEntityLinkLoop( node )

			// Remove this group's nodes from the list
			foreach ( entity groupNode in groupNodes )
				dronePathNodes.fastremovebyvalue( groupNode )

			// Add the group to the path list
			file.dronePaths.append( groupNodes )
		}
		printf( "DronePaths: found %i paths", file.dronePaths.len() ) 
		FlagSet( "DronePathsInitialized" )
	} 
	else if (GetMapName() == "mp_rr_canyonlands_mu1" || GetMapName() == "mp_rr_canyonlands_mu1_night" || GetMapName() == "mp_rr_canyonlands_64k_x_64k" )
	{
		thread GeneratePathAndSpawnFlyers()
	}
}

void function GeneratePathAndSpawnFlyers()
{
	array<vector> startPoints
	startPoints.append(<-18973.3047, 8534.12109, 4280.16602>)
	startPoints.append(<-18127.4082, -5528.96191, 2728.19434>)
	startPoints.append(<-4743.55029, -13367.792, 3561.34766>)
	startPoints.append(<11613.6396, -23869.5371, 2633.93628>)
	startPoints.append(<20152.5898, -17941.3672, 5617.63379>)
	startPoints.append(<30054.6602, -631.220337, 4734.79053>)
	startPoints.append(<26079.166, 20301.3418, 5569.29688>)
	startPoints.append(<6126.94336, 24811.9395, 5894.36377>)
	
	foreach(startPoint in startPoints)
	{
		array<entity> Amogus
		for(int i = 0; i < 50; i++)
		{
			float r = float(i) / float(50) * 2 * PI
			vector org = startPoint + 6000 * <sin( r ), cos( r ), 0.0>
				
			entity amogus = CreateEntity( "script_mover_train_node" )
			amogus.kv.solid = 0
			amogus.kv.fadedist = -1
			amogus.SetValueForModelKey( $"mdl/dev/empty_model.rmdl" )
			amogus.kv.SpawnAsPhysicsMover = 1
			amogus.SetOrigin( org + Vector(0,0,3000))
			amogus.SetAngles( Vector(0,0,0) )
			DispatchSpawn( amogus )
			
			Amogus.append( amogus )
		}
		
		file.dronePaths.append( Amogus )
	}
	
	FlagSet( "DronePathsInitialized" )
	
	SpawnFlyers(10)
	printt( "FlyersPaths: generated paths ", file.dronePaths.len() )
}

//////////////////////////
//////////////////////////
//// Global functions ////
//////////////////////////
//////////////////////////
array<LootDroneData> function SpawnLootDrones( int numToSpawn )
{
	array<LootDroneData> drones

	for ( int i = 0; i < numToSpawn; ++i )
	{
		drones.append( LootDrones_SpawnLootDroneAtRandomPath() )
		drones[i].id++
		WaitFrame()	
	}
	
	file.spawnedDronesorFlyers = drones
	return drones
}

array<LootDroneData> function SpawnFlyers( int numToSpawn )
{
	array<LootDroneData> drones

	for ( int i = 0; i < numToSpawn; ++i )
	{		
		drones.append( Flyers_SpawnFlyerAtRandomPath() )
		drones[i].id++		
		WaitFrame()		
	}
	
	file.spawnedDronesorFlyers = drones
	return drones
}
//////////////////////////
//////////////////////////
/// Internal functions ///
//////////////////////////
//////////////////////////
void function FlyerAnimation(entity flyer)
{
	if(IsValid(flyer))
		flyer.Anim_Play( "fl_flap_cycle" )
}

array<entity> function FlyersOrLootDrones_GetRandomPath()
{
	Assert( !Flag( "DronePathsInitialized" ), "Trying to get a random path while having uninitialized paths!" )
	
	return file.dronePaths.getrandom()
}

LootDroneData function Flyers_SpawnFlyerAtRandomPath()
{
	LootDroneData data
	array<entity> path = FlyersOrLootDrones_GetRandomPath()
	
	//find a starting point in the path and sort the array of locations
	int startpoint = Flyers_GetBestStartNodeFromPath( path )

	array<entity> newArray = path.slice(startpoint, path.len())
	newArray.extend(path.slice(0, startpoint))
	path = newArray

	entity startNode = path[0]

	// Set path from this start node.
	data.path = path
	foreach ( entity pathNode in data.path )
		data.pathVec.append( pathNode.GetOrigin() )

	//Getting rid of SetParent so we can have proper animation while moving. hack #2! //By Colombia
	entity model = CreateEntity( "script_mover" )
	model.kv.targetname = LOOT_DRONE_MOVER_SCRIPTNAME
	
	if (GetMapName() == "mp_rr_canyonlands_mu1" || GetMapName() == "mp_rr_canyonlands_mu1_night" || GetMapName() == "mp_rr_canyonlands_64k_x_64k")
	{
		model.SetValueForModelKey( FLYER_MODEL.tolower() ) 	
		model.SetMaxHealth( 100 )
		model.SetHealth( 100 )
		model.kv.modelscale = RandomFloatRange( 0.9, 1.1 )
		model.SetSkin(RandomInt(3))
	} else if ( GetMapName() == "mp_rr_canyonlands_mu1_night")
	{
		model.SetSkin(3)
		StartParticleEffectOnEntityWithPos_ReturnEntity( model, GetParticleSystemIndex( FX_FLYER_GLOW2 ), FX_PATTACH_ABSORIGIN_FOLLOW, model.LookupAttachment( "CHESTFOCUS" ), <0,0,0>, VectorToAngles( <0,0,-1> ) )
	}
	
	model.kv.SpawnAsPhysicsMover = 0
	model.SetOrigin( startNode.GetOrigin() )
	model.SetAngles( startNode.GetAngles() )
	model.kv.fadedist = 50000
	model.kv.rendercolor = "255 255 255"
	model.kv.solid = 6
	model.SetDamageNotifications( true )
	model.SetTakeDamageType( DAMAGE_YES )
	DispatchSpawn( model )

	// Set model entity in the struct.
	data.model = model
	data.mover = model

	if(!GetCurrentPlaylistVarBool("flowstatePROPHUNT", false )) data.roller = SpawnDeathbox_Parented(data.model)
	thread FlyerMove( data )

	file.droneData[ model ] <- data

	AddEntityCallback_OnDamaged( data.model, Flyers_OnDamaged) 	
	thread FlyerAnimation(data.model)
		
	return data
}

LootDroneData function LootDrones_SpawnLootDroneAtRandomPath()
{
	LootDroneData data
	array<entity> path = FlyersOrLootDrones_GetRandomPath()
	if ( path.len() == 0 )
	{
		Assert( 0, "Got a random path with no nodes!" )
		return data
	}

	// Get available start node
	entity ornull startNode = LootDrones_GetAvailableStartNodeFromPath( path )
	if ( startNode == null )
	{
		Assert( 0, "Got a random path with no available start node!" )
		return data
	}

	expect entity( startNode )

	// Set path from this start node.
	data.path = path
	foreach ( entity pathNode in data.path )
		data.pathVec.append( pathNode.GetOrigin() )

	//Getting rid of SetParent so we can have proper animation while moving. hack #2! //By Colombia
	entity model = CreateEntity( "script_mover" )
	model.kv.targetname = LOOT_DRONE_MOVER_SCRIPTNAME
	
	model.SetValueForModelKey( LOOT_DRONE_MODEL ) 
	model.SetMaxHealth( 10 )
	model.SetHealth( 10 )
	model.kv.modelscale = 1
	
	model.kv.SpawnAsPhysicsMover = 0
	model.SetOrigin( startNode.GetOrigin() )
	model.SetAngles( startNode.GetAngles() )
	model.kv.fadedist = 50000
	model.kv.rendercolor = "255 255 255"
	//model.kv.CollisionGroup = TRACE_COLLISION_GROUP_PLAYER
	model.kv.solid = 6
	model.SetDamageNotifications( true )
	model.SetTakeDamageType( DAMAGE_YES )
	//model.AllowMantle()
	DispatchSpawn( model )

	// Set model entity in the struct.
	data.model = model
	data.mover = model
	
	data.roller = SpawnLootRoller_Parented(data.model)
	data.roller.SetOrigin( data.model.GetOrigin() + LOOT_DRONE_ROTATOR_OFFSET )
	thread LootDroneSound(data.model)
	thread LootDroneState( data )
	thread LootDroneMove( data )

	file.droneData[ model ] <- data
	return data
}

void function serversideColorTiers(LootDroneData data)
{
	while (true)
	{
		string rgb = returnRgbColorInOrder(data)
		data.glow = CreateEntity( "env_sprite" )
		if(IsValid(data.glow) && IsValid(data.roller)){
		data.glow.kv.rendermode = 5
		data.glow.kv.origin = data.roller.GetOrigin()
		data.glow.kv.angles = data.roller.GetAngles()
		data.glow.kv.fadedist = 20000
		data.glow.kv.rendercolor = rgb
		data.glow.kv.renderamt = 255
		data.glow.kv.framerate = "10.0"
		data.glow.SetValueForModelKey( $"sprites/glow_05.vmt" )
		data.glow.kv.scale = string( 1.2 )
		data.glow.kv.spawnflags = 1
		data.glow.kv.GlowProxySize = 15.0
		data.glow.kv.HDRColorScale = 15.0
		DispatchSpawn( data.glow )
		data.glow.SetParent(data.roller)
		EntFireByHandle( data.glow, "ShowSprite", "", 0, null, null )
		}
		wait 1
		if(IsValid(data.glow)){
		data.glow.ClearParent()
		data.glow.Destroy()}
	}

}

string function returnRgbColorInOrder(LootDroneData data)
{
	int index = data.rgbInt
	if (index == 0 && !data.stoploottier) {
		data.rgbId = "255, 255, 255"
		index++
		data.rgbInt = index
		if(IsValid(data.roller)) Highlight_SetFlyerDeathboxHighlight( data.roller, "survival_item_common_cargobot" )
	return data.rgbId}
	if (index == 1 && !data.stoploottier) {
		data.rgbId = "0, 0, 255"
		index++
		data.rgbInt = index
		if(IsValid(data.roller)) Highlight_SetFlyerDeathboxHighlight( data.roller, "survival_item_rare_cargobot" )
	return data.rgbId}
	if (index == 2 && !data.stoploottier) {
		data.rgbId = "200, 0, 255"
		index = 0
		data.rgbInt = index
		if(IsValid(data.roller)) Highlight_SetFlyerDeathboxHighlight( data.roller, "survival_item_epic_cargobot" )
	return data.rgbId}
	return data.rgbId
}

entity ornull function LootDrones_GetAvailableStartNodeFromPath( array<entity> path )
{
	foreach ( entity pathNode in path )
	{
		vector nodeOrigin = pathNode.GetOrigin()
		bool suitable = true
		foreach ( entity model, LootDroneData data in file.droneData )
		{
			// Too close?
			if ( Distance( nodeOrigin, model.GetOrigin() ) <= LOOT_DRONE_START_NODE_SELECTION_MIN_DISTANCE )
			{
				// Bail.
				suitable = false
				break
			}
		}
		if ( suitable )
			return pathNode
	}
	return null
}

int function Flyers_GetBestStartNodeFromPath( array<entity> path )
{
	table<entity, float> SpawnsAndNearestFlyer = {}

	foreach ( entity pathNode in path )
    {
		array<float> Distances
		foreach ( entity model, LootDroneData data in file.droneData )
			Distances.append(Distance(model.GetOrigin(), pathNode.GetOrigin()))
			
		if(Distances.len() == 0) return RandomInt(path.len())
			
		Distances.sort()
		SpawnsAndNearestFlyer[pathNode] <- Distances[0]
	}
	
	entity finalLoc
	float compareDis = -1
	foreach(loc, dis in SpawnsAndNearestFlyer)
	{
		if(dis > compareDis)
		{
			finalLoc = loc
			compareDis = dis
		}
	}
	
	for(int i = 0; i < path.len(); i++)
	{
		if(path[i] == finalLoc)
			return i
	}
	
    unreachable
}

void function CreateFlowStateDeathBoxForPlayer2( entity victim, vector origin, vector angles, string lootTier)
{
		entity deathBox = FlowState_CreateDeathBox2( victim, true , origin, angles)
		StartParticleEffectOnEntityWithPos_ReturnEntity( deathBox, GetParticleSystemIndex( DEATHBOX_DROP_FX ), FX_PATTACH_ABSORIGIN_FOLLOW, deathBox.LookupAttachment( "CHESTFOCUS" ), <0,0,0>, VectorToAngles( <0,0,-1> ) )
		int j
		switch( lootTier )
		{
			case "survival_item_common":
					for ( j = 0; j < 6; ++j ){
					LootData data = file.ItemsTier1[RandomIntRangeInclusive(0,file.ItemsTier1.len()-1)]
					entity loot = SpawnGenericLoot( data.ref, deathBox.GetOrigin(), deathBox.GetAngles(), 1 )
					AddToDeathBox( loot, deathBox )}
				break
			case "survival_item_rare":
				LootData data = file.ItemsTier2[RandomIntRangeInclusive(0,file.ItemsTier2.len()-1)]
				entity loot = SpawnGenericLoot( data.ref, deathBox.GetOrigin(), deathBox.GetAngles(), 1 )
				AddToDeathBox( loot, deathBox )					
					for ( j = 0; j < 5; ++j ){
					LootData data1 = file.ItemsTier1[RandomIntRangeInclusive(0,file.ItemsTier1.len()-1)]
					entity loot1 = SpawnGenericLoot( data1.ref, deathBox.GetOrigin(), deathBox.GetAngles(), 1 )
					AddToDeathBox( loot1, deathBox )}
				break
			case "survival_item_epic":
				LootData data = file.ItemsTier3[RandomIntRangeInclusive(0,file.ItemsTier3.len()-1)]
				entity loot = SpawnGenericLoot( data.ref, deathBox.GetOrigin(), deathBox.GetAngles(), 1 )
				AddToDeathBox( loot, deathBox )					
					for ( j = 0; j < 3; ++j ){
					LootData data2 = file.ItemsTier2[RandomIntRangeInclusive(0,file.ItemsTier2.len()-1)]
					entity loot2 = SpawnGenericLoot( data2.ref, deathBox.GetOrigin(), deathBox.GetAngles(), 1 )
					AddToDeathBox( loot2, deathBox )}
					
					for ( j = 0; j < 3; ++j ){
					LootData data3 = file.ItemsTier1[RandomIntRangeInclusive(0,file.ItemsTier1.len()-1)]
					entity loot3 = SpawnGenericLoot( data3.ref, deathBox.GetOrigin(), deathBox.GetAngles(), 1 )
					AddToDeathBox( loot3, deathBox )}
				break
			case "survival_item_legendary":
				LootData data = file.ItemsTier4[RandomIntRangeInclusive(0,file.ItemsTier4.len()-1)]
				entity loot = SpawnGenericLoot( data.ref, deathBox.GetOrigin(), deathBox.GetAngles(), 1 )
				AddToDeathBox( loot, deathBox )					
					for ( j = 0; j < 2; ++j ){
					LootData data2 = file.ItemsTier3[RandomIntRangeInclusive(0,file.ItemsTier3.len()-1)]
					entity loot2 = SpawnGenericLoot( data2.ref, deathBox.GetOrigin(), deathBox.GetAngles(), 1 )
					AddToDeathBox( loot2, deathBox )}
					
					for ( j = 0; j < 2; ++j ){
					LootData data3 = file.ItemsTier2[RandomIntRangeInclusive(0,file.ItemsTier2.len()-1)]
					entity loot3 = SpawnGenericLoot( data3.ref, deathBox.GetOrigin(), deathBox.GetAngles(), 1 )
					AddToDeathBox( loot3, deathBox )}
					
					for ( j = 0; j < 3; ++j ){
					LootData data4 = file.ItemsTier1[RandomIntRangeInclusive(0,file.ItemsTier1.len()-1)]
					entity loot4 = SpawnGenericLoot( data4.ref, deathBox.GetOrigin(), deathBox.GetAngles(), 1 )
					AddToDeathBox( loot4, deathBox )}
				break
			case "survival_item_heirloom": //TODO add vault key and test red glow Colombia
				break
		}

		UpdateDeathBoxHighlight( deathBox )

		// Go straight down
		entity mover = CreateScriptMover( origin, angles, 0 )
		deathBox.SetParent( mover, "", true )
		TraceResults result = TraceLine
		( 
			deathBox.GetOrigin(), 
			deathBox.GetOrigin() - <0,0,LOOT_DRONE_FALL_TRACE_DIST*6>, 
			deathBox, 
			TRACE_MASK_NPCSOLID, 
			TRACE_COLLISION_GROUP_NONE 
		)
		float distance = Distance(deathBox.GetOrigin(), result.endPos)
		float t = distance / ( LOOT_DRONE_FALLING_SPEED_MAX )
		if(t>0){ //crash fix
		mover.NonPhysicsMoveTo( result.endPos, t, 0, 0	)}
}

entity function FlowState_CreateDeathBox2( entity player, bool hasCard, vector origin, vector angles)
{
	entity box = CreatePropDeathBox_NoDispatchSpawn( DEATH_BOX, origin, angles, 6 )
	
	if ( hasCard )
		SetTargetName( box, DEATH_BOX_TARGETNAME )

	DispatchSpawn( box )
	box.kv.fadedist = 50000
	box.RemoveFromAllRealms()
	box.AddToOtherEntitysRealms( player )
	box.Solid()
	box.SetUsable()
	box.SetUsableValue( USABLE_BY_ALL | USABLE_CUSTOM_HINTS )
	box.SetOwner( player )
	box.SetNetInt( "ownerEHI", player.GetEncodedEHandle() )

	if ( hasCard )
	{
		box.SetNetBool( "overrideRUI", false )
		box.SetCustomOwnerName( player.GetPlayerName() )
		EHI playerEHI = ToEHI( player )
		LoadoutEntry characterLoadoutEntry = Loadout_CharacterClass()
		ItemFlavor character = LoadoutSlot_GetItemFlavor( playerEHI, characterLoadoutEntry )
		box.SetNetInt( "characterIndex", ConvertItemFlavorToLoadoutSlotContentsIndex( characterLoadoutEntry, character ) )
		Highlight_SetNeutralHighlight( box, "sp_objective_entity" )
		Highlight_ClearNeutralHighlight( box )
	}
	return box
}

void function updateDeathbox(LootDroneData data)
{
	entity player = file.lastattacker 
	
	if(!IsValid(player)) return
	
	printt("Flyers DEBUG - Last attacker: ", player)
	int highestTier = 0
	foreach ( item in data.roller.GetLinkEntArray() )
	{
		LootData dataref = SURVIVAL_Loot_GetLootDataByIndex( item.GetSurvivalInt() )
		if ( dataref.ref == "" )
			continue

		if ( dataref.tier > highestTier )
			highestTier = dataref.tier
	}
	vector lastpos = data.roller.GetOrigin()
	vector lastang = data.roller.GetAngles()
	string tierloot = data.roller.e.enemyHighlight
	CreateFlowStateDeathBoxForPlayer2(player, lastpos, lastang, tierloot)
	data.roller.Destroy()
}

void function FlyerMove( LootDroneData data )
{
	Assert( IsNewThread(), "Must be threaded off" )
	Assert( data.path.len() > 0, "Path must have at least one node" )
	data.model.EndSignal( "OnDestroy" )
	data.model.EndSignal( SIGNAL_LOOT_DRONE_FALL_START )
	OnThreadEnd( 
		function() : ( data )
		{
			if( IsValid( data.roller ) )
			{
			data.roller.ClearParent()
			if(!GetCurrentPlaylistVarBool("flowstatePROPHUNT", false )) updateDeathbox(data)
			}
		}
	)
	array< entity > path = data.path
	
	while(true)
	{
		
		foreach(node in path)
		{
			data.mover.NonPhysicsMoveTo( node.GetOrigin(), 3.5, 0, 0 )
			data.mover.NonPhysicsRotateTo( VectorToAngles(  node.GetOrigin() -  data.mover.GetOrigin() ), 1.2, 0, 0 )

			wait 3.5
		}
		path.reverse()
	}
}

void function PlayDyingFlyerAnimAndReleaseDeathbox(entity flyer)
{
	if(IsValid(flyer)){
		flyer.Anim_Play( "fl_fly_death" )
		flyer.Signal("OnDestroy")
		flyer.Signal(SIGNAL_LOOT_DRONE_FALL_START)
		}
	wait 2
	if(IsValid(flyer)){
		flyer.Anim_Stop()
		flyer.Destroy()
		}
}

void function Flyers_OnDamaged(entity ent, var damageInfo)
{
	entity attacker = DamageInfo_GetAttacker(damageInfo)
	if(!attacker.IsPlayer()) return
		
	if(ent != attacker.p.ParentedFlyer)
	{
		float damage = DamageInfo_GetDamage( damageInfo )
		attacker.NotifyDidDamage
		(
			ent,
			DamageInfo_GetHitBox( damageInfo ),
			DamageInfo_GetDamagePosition( damageInfo ), 
			DamageInfo_GetCustomDamageType( damageInfo ),
			DamageInfo_GetDamage( damageInfo ),
			DamageInfo_GetDamageFlags( damageInfo ), 
			DamageInfo_GetHitGroup( damageInfo ),
			DamageInfo_GetWeapon( damageInfo ), 
			DamageInfo_GetDistFromAttackOrigin( damageInfo )
		)
		
		float flyerNextHealth = ent.GetHealth() - DamageInfo_GetDamage( damageInfo )
		if (flyerNextHealth > 0 && IsValid(ent)){
			ent.SetHealth(flyerNextHealth)
			
			if(IsValid(attacker) && IsAlive(attacker)){
				file.lastattacker = attacker
			}
			if(flyerNextHealth < 80){
				ent.Signal(SIGNAL_LOOT_DRONE_FALL_START)	
			}
		} else if (IsValid(ent)){

		thread PlayDyingFlyerAnimAndReleaseDeathbox(ent)
		
		ent.SetTakeDamageType( DAMAGE_NO )
		ent.kv.solid = 0
		ent.SetOwner( attacker )
		ent.kv.teamnumber = attacker.GetTeam()
		}
	}	
}

void function LootDroneState( LootDroneData data )
{
	Assert( IsNewThread(), "Must be threaded off" )

	data.model.EndSignal( "OnDestroy" )
	data.model.EndSignal( "OnDeath" )
	thread serversideColorTiers( data )
	// TODO: Find why idle sound isn't playing, only when spammed and close
	// Doesn't seem to loop either, might be related to a specific entity behavior
	// Could be PVS too.. clientsided? no clue yet.
	//
	// https://developer.valvesoftware.com/wiki/PVS
	//
	// Train works fine, look into how the train works

	OnThreadEnd(
		function() : ( data )
		{
			data.stoploottier = true
			// if ( IsValid( data.soundEntity ) )
				// StopSoundOnEntity( data.soundEntity, LOOT_DRONE_LIVING_SOUND )


			if( IsValid( data.roller ) )
			{
				data.roller.ClearParent()
				// Fix the physics
				EntFireByHandle(data.roller, "DisableMotion", "", 0, null, null)
				EntFireByHandle(data.roller, "EnableMotion", "", 0.2, null, null)

				// prop_physics don't have a velocity and won't react to basevelocity, 
				// this is handled by havoc instead
				/*
				vector throwSpeed = <RandomFloatRange(-1,1),RandomFloatRange(-1,1),1>
				throwSpeed *= RandomFloatRange(LOOT_DRONE_RAND_TOSS_MIN,LOOT_DRONE_RAND_TOSS_MAX)
				data.roller.SetVelocity( throwSpeed )
				*/
			}
		}
	)
	WaitForever()
}


void function LootDroneMove( LootDroneData data )
{
	Assert( IsNewThread(), "Must be threaded off" )
	Assert( data.path.len() > 0, "Path must have at least one node" )

	data.model.EndSignal( "OnDestroy" )
	data.model.EndSignal( SIGNAL_LOOT_DRONE_FALL_START )

	// Go straight down and crash bellow
	OnThreadEnd( 
		function() : ( data )
		{
			data.stoploottier = true
			if ( IsValid( data.mover ) ) data.mover.Train_StopImmediately()
			TraceResults result = TraceLine
			( 
				data.mover.GetOrigin(), 
				data.mover.GetOrigin() - <0,0,LOOT_DRONE_FALL_TRACE_DIST*3>, // 1024 is so low.. make it double. 
				data.mover, 
				TRACE_MASK_NPCSOLID, 
				TRACE_COLLISION_GROUP_NONE 
			)

			// TEMP
			// TODO: Implement gravity + acceleration, perhaps use the Train_ funcs with signals
			float distance = Distance(data.mover.GetOrigin(), result.endPos)
			float t = distance / (LOOT_DRONE_FALLING_SPEED_MAX*0.8)

			data.mover.NonPhysicsMoveTo( result.endPos, t, 0, 0	)
			data.mover.NonPhysicsRotateTo( data.mover.GetAngles() + <0,0,180>, 1, 0, 0 )

			// TEMP
			thread( 
				void function() : (data, t)
				{
					wait t

					entity effect = StartParticleEffectInWorld_ReturnEntity
					( 
						GetParticleSystemIndex( LOOT_DRONE_FX_EXPLOSION ), 
						data.mover.GetOrigin(), 
						<0,0,0>
					)
					EmitSoundOnEntity( effect, LOOT_DRONE_CRASHED_SOUND )

					// Kill the particles after a few secs, entity stays in the map indefinitely it seems
					EntFireByHandle( effect, "Kill", "", 2, null, null )

					// TODO: Find the right damage values and damageid
					RadiusDamage
					(
						data.mover.GetOrigin(),													// center
						data.model.GetOwner(),													// attacker
						data.mover,																// inflictor
						LOOT_DRONE_EXPLOSION_DAMAGE,											// damage
						LOOT_DRONE_EXPLOSION_DAMAGE,											// damageHeavyArmor
						LOOT_DRONE_EXPLOSION_RADIUS,											// innerRadius
						LOOT_DRONE_EXPLOSION_RADIUS,											// outerRadius
						SF_ENVEXPLOSION_MASK_BRUSHONLY,											// flags
						0.0,																	// distanceFromAttacker
						LOOT_DRONE_EXPLOSION_DAMAGE,											// explosionForce
						DF_EXPLOSION | DF_GIB | DF_KNOCK_BACK,									// scriptDamageFlags
						LOOT_DRONE_EXPLOSION_DAMAGEID 											// scriptDamageSourceIdentifier
					)

					data.mover.Destroy()
				}
			)()
		}
	)

	// Make the drone roll on turns
	// (rollStrengh, rollMax, lookAheadDist) ? nothing in shared consts, values seem fine just like this.
	// Start the movement using the shared constants
	data.mover.Train_MoveToTrainNodeEx( data.path[0], 0, LOOT_DRONE_FLIGHT_SPEED_MAX, LOOT_DRONE_FLIGHT_SPEED_MAX, LOOT_DRONE_FLIGHT_ACCEL )
	data.mover.Train_AutoRoll( 5.0, 45.0, 1024.0 )
	
	WaitForever()
}

void function LootDroneSound( entity model )
{

}

void function LootDrones_OnDamaged(entity ent, var damageInfo)
{
	entity attacker = DamageInfo_GetAttacker(damageInfo);
	
	if( !IsValid( attacker ) || !attacker.IsPlayer() )
		return
	
	attacker.NotifyDidDamage
	(
		ent,
		DamageInfo_GetHitBox( damageInfo ),
		DamageInfo_GetDamagePosition( damageInfo ), 
		DamageInfo_GetCustomDamageType( damageInfo ),
		DamageInfo_GetDamage( damageInfo ),
		DamageInfo_GetDamageFlags( damageInfo ), 
		DamageInfo_GetHitGroup( damageInfo ),
		DamageInfo_GetWeapon( damageInfo ), 
		DamageInfo_GetDistFromAttackOrigin( damageInfo )
	)

	// Handle damage, props get destroyed on death, we don't want that.
	// Not really needed since it has 1 HP, but we do it anyway.
	float nextHealth = ent.GetHealth() - DamageInfo_GetDamage( damageInfo )
	if( nextHealth > 0 )
	{
		ent.SetHealth(nextHealth)
		return
	}

	// Drone ""died""
	// Don't take damage anymore
	ent.SetTakeDamageType( DAMAGE_NO )
	ent.kv.solid = 0

	ent.Signal( SIGNAL_LOOT_DRONE_FALL_START )

	ent.SetOwner( attacker )
	ent.kv.teamnumber = attacker.GetTeam()

	EmitSoundOnEntity( ent, LOOT_DRONE_DEATH_SOUND )
	EmitSoundOnEntity( ent, LOOT_DRONE_CRASHING_SOUND )
	
	PlayBattleChatterLineToSpeakerAndTeam( attacker, "bc_cargoBotDamaged" )

	entity effect = StartParticleEffectOnEntity_ReturnEntity
	( 
		ent, 
		GetParticleSystemIndex( LOOT_DRONE_FX_FALL_EXPLOSION ), 
		FX_PATTACH_ABSORIGIN_FOLLOW, 0 
	)
	// Kill the particles after a few secs, entity stays in the map indefinitely it seems
	EntFireByHandle( effect, "Kill", "", 2, null, null )

	ent.Signal("OnDeath")
}
