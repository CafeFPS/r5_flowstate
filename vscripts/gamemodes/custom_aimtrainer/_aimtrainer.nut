/*
Flowstate Aim Trainer v1.0 - Made by CaféDeColombiaFPS (server, client, ui)
Discord: Retículo Endoplasmático#5955 | Twitter: @CafeFPS
Support me: https://ko-fi.com/r5r_colombia

More credits:
- Skeptation#4002 -- beta tester and coworker https://www.youtube.com/c/Skeptation
- Amos#1368 & contributors -- sdk https://github.com/Mauler125/r5sdk/tree/indev
- rexx#1287 & contributors -- repak tool https://github.com/r-ex/RePak
- Zee#6969 -- weapons buy menu example, history ui pages
- Darkes#8647 -- beta tester
- Rego#2848 -- beta tester
- michae\l/#1125 -- beta tester
- James9950#5567 -- beta tester
- (--__GimmYnkia__--)#2995 -- beta tester
- oliver#1375 -- beta tester
- Rin 暗#5862 -- beta tester
*/

global function  _ChallengesByColombia_Init
global function StartFRChallenges

vector floorLocation
vector floorCenterForPlayer
vector floorCenterForButton
vector onGroundLocationPos
vector onGroundLocationAngs
vector onGroundDummyPos
vector AimTrainer_startPos
vector AimTrainer_startAngs

struct{
	array<entity> floor
	array<entity> dummies
	array<entity> props
} ChallengesEntities

table<int, array<ChallengeScore> > ChallengesData //implement this
table<int, int> ChallengesBestScores

void function _ChallengesByColombia_Init()
{
	//Todo: create only one cc for this
	//first challenges select menu column
	AddClientCommandCallback("CC_StartChallenge1", CC_StartChallenge1)
	AddClientCommandCallback("CC_StartChallenge2", CC_StartChallenge2)
	AddClientCommandCallback("CC_StartChallenge3", CC_StartChallenge3)
	AddClientCommandCallback("CC_StartChallenge4", CC_StartChallenge4)
	AddClientCommandCallback("CC_StartChallenge5", CC_StartChallenge5)
	AddClientCommandCallback("CC_StartChallenge6", CC_StartChallenge6)
	AddClientCommandCallback("CC_StartChallenge7", CC_StartChallenge7)
	AddClientCommandCallback("CC_StartChallenge8", CC_StartChallenge8)
	//second challenges select menu column
	AddClientCommandCallback("CC_StartChallenge1NewC", CC_StartChallenge1NewC)
	AddClientCommandCallback("CC_StartChallenge2NewC", CC_StartChallenge2NewC)
	AddClientCommandCallback("CC_StartChallenge3NewC", CC_StartChallenge3NewC)
	AddClientCommandCallback("CC_StartChallenge4NewC", CC_StartChallenge4NewC)
	AddClientCommandCallback("CC_StartChallenge5NewC", CC_StartChallenge5NewC)
	AddClientCommandCallback("CC_StartChallenge6NewC", CC_StartChallenge6NewC)
	AddClientCommandCallback("CC_StartChallenge7NewC", CC_StartChallenge7NewC)
	AddClientCommandCallback("CC_StartChallenge8NewC", CC_StartChallenge8NewC)
	
	//settings buttons
	AddClientCommandCallback("CC_Weapon_Selector_Open", CC_Weapon_Selector_Open)
	AddClientCommandCallback("CC_Weapon_Selector_Close", CC_Weapon_Selector_Close)
	AddClientCommandCallback("CC_ChangeChallengeDuration", CC_ChangeChallengeDuration)
	AddClientCommandCallback("CC_AimTrainer_AI_SHIELDS_LEVEL", CC_AimTrainer_AI_SHIELDS_LEVEL)
	AddClientCommandCallback("CC_AimTrainer_STRAFING_SPEED", CC_AimTrainer_STRAFING_SPEED)
	AddClientCommandCallback("CC_AimTrainer_SPAWN_DISTANCE", CC_AimTrainer_SPAWN_DISTANCE)
	AddClientCommandCallback("CC_AimTrainer_AI_HEALTH", CC_AimTrainer_AI_HEALTH)
	AddClientCommandCallback("CC_RGB_HUD", CC_RGB_HUD)
	AddClientCommandCallback("CC_AimTrainer_INFINITE_CHALLENGE", CC_AimTrainer_INFINITE_CHALLENGE)
	AddClientCommandCallback("CC_AimTrainer_INFINITE_AMMO", CC_AimTrainer_INFINITE_AMMO)
	AddClientCommandCallback("CC_AimTrainer_INFINITE_AMMO2", CC_AimTrainer_INFINITE_AMMO2)
	AddClientCommandCallback("CC_AimTrainer_INMORTAL_TARGETS", CC_AimTrainer_INMORTAL_TARGETS)
	AddClientCommandCallback("CC_AimTrainer_DUMMIES_COLOR", CC_AimTrainer_DUMMIES_COLOR)
	AddClientCommandCallback("CC_AimTrainer_USER_WANNA_BE_A_DUMMY", CC_AimTrainer_USER_WANNA_BE_A_DUMMY)
	AddClientCommandCallback("CC_MenuGiveAimTrainerWeapon", CC_MenuGiveAimTrainerWeapon) 
	AddClientCommandCallback("CC_ExitChallenge", CC_ExitChallenge)
	
	//results menu skip and restart button callback
	AddClientCommandCallback("ChallengesSkipButton", CC_ChallengesSkipButton)
	AddClientCommandCallback("CC_RestartChallenge", CC_RestartChallenge)
	
	//on weapon attack callback so we can calculate stats for live stats and results menu
	AddCallback_OnWeaponAttack( OnWeaponAttackChallenges )

	AddCallback_OnClientConnected( StartFRChallenges )
		
	//arc stars on damage callback for arc stars practice challenge
	AddDamageCallbackSourceID( eDamageSourceId.damagedef_ticky_arc_blast, Arcstar_OnStick )
	AddDamageCallbackSourceID( eDamageSourceId.mp_weapon_grenade_emp, Arcstar_OnStick )
	
	//required assets for different challenges
	PrecacheParticleSystem($"P_enemy_jump_jet_ON_trails")
	PrecacheParticleSystem( $"P_skydive_trail_CP" )
	PrecacheModel($"mdl/imc_interior/imc_int_fusebox_01.rmdl")
	PrecacheModel($"mdl/barriers/shooting_range_target_02.rmdl")
	PrecacheModel($"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl")
	PrecacheModel($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl")
	PrecacheModel( $"mdl/pipes/slum_pipe_large_yellow_256_02.rmdl" )
	
	//death callback for player because some challenges can kill player
	AddDeathCallback( "player", OnPlayerDeathCallback )
	
	//add basic aim trainer locations for maps //todo: move this to a datatable
	if (GetMapName() == "mp_rr_desertlands_64k_x_64k" || GetMapName() == "mp_rr_desertlands_64k_x_64k_nx" || GetMapName() == "mp_rr_desertlands_64k_x_64k_tt" )
	{
		floorLocation = <-10020.1543, -8643.02832, 5189.92578>
		onGroundLocationPos = <12891.2783, -2391.77124, -3121.60132>
		onGroundLocationAngs = <0, -157.629303, 0>
		AimTrainer_startPos = <10623.7773, 4953.48975, -4303.92041>
		AimTrainer_startAngs = <0, 143.031052, 0>			
	}
	else if(GetMapName() == "mp_rr_canyonlands_staging")
	{
		floorLocation = <35306.2344, -16956.5098, -27010.2539>
		onGroundLocationPos = <33946,-6511,-28859>
		onGroundLocationAngs = <0,-90,0>
		AimTrainer_startPos = <32645.04,-9575.77,-25911.94>
		AimTrainer_startAngs = <7.71,91.67,0.00>		
	}
	else if(GetMapName() == "mp_rr_canyonlands_mu1" || GetMapName() == "mp_rr_canyonlands_mu1_night" || GetMapName() == "mp_rr_canyonlands_64k_x_64k")
	{
		floorLocation = <-11964.7803, -8858.25098, 17252.25>
		onGroundLocationPos = <-14599.2178, -7073.89551, 2703.93286>
		onGroundLocationAngs = <0,90,0>
		AimTrainer_startPos = <-16613.873, -487.12088, 3312.10791>
		AimTrainer_startAngs = <0, 144.184357, 0>
	}
	floorCenterForPlayer = <floorLocation.x+3840, floorLocation.y+3840, floorLocation.z+200>
	floorCenterForButton = <floorLocation.x+3840+200, floorLocation.y+3840, floorLocation.z+18>
	
	for(int i = 0; i<20; i++)
	{
		ChallengesData[i] <- []
		ChallengesBestScores[i] <- 0
	}	
}

void function StartFRChallenges(entity player)
{
	while( !IsValid( player ) )
		WaitFrame()

	Remote_CallFunction_NonReplay(player, "ServerCallback_SetDefaultMenuSettings")
	Survival_SetInventoryEnabled( player, false )
	
	player.FreezeControlsOnServer()
	TakeAllWeapons(player)
	Inventory_SetPlayerEquipment(player, "armor_pickup_lv1", "armor")

	player.GiveWeapon( "mp_weapon_wingman", WEAPON_INVENTORY_SLOT_PRIMARY_0, ["optic_cq_hcog_classic"] )
	player.SetActiveWeaponBySlot(eActiveInventorySlot.mainHand, WEAPON_INVENTORY_SLOT_PRIMARY_0)
	
	player.SetOrigin(AimTrainer_startPos)
	player.SetAngles(AimTrainer_startAngs)
	HolsterAndDisableWeapons(player)
	Remote_CallFunction_NonReplay(player, "ServerCallback_CoolCameraOnMenu")
	Remote_CallFunction_NonReplay(player, "ServerCallback_OpenFRChallengesMainMenu", 0)	
}

void function ResetChallengeStats(entity player)
{
	if(!player.IsPlayer()) return
	
	ChallengesEntities.dummies = []
	ChallengesEntities.floor = []
	ChallengesEntities.props = []
	
	player.p.storedWeapons.clear()
	if(!player.p.isRestartingLevel)
		player.p.challengeName = 0
	player.p.straferDummyKilledCount = 0
	player.p.straferShotsHit = 0
	player.p.straferTotalShots = 0
	player.p.straferChallengeDamage = 0
	player.p.straferCriticalShots = 0
	player.p.isChallengeActivated = false
	Remote_CallFunction_NonReplay(player, "ServerCallback_SetChallengeActivated", false)
	player.p.isNewBestScore = false
}

void function SetCommonDummyLines(entity dummy)
{
	dummy.SetTakeDamageType( DAMAGE_YES )
	dummy.SetDamageNotifications( true )
	dummy.SetDeathNotifications( true )
	dummy.SetValidHealthBarTarget( true )
	SetObjectCanBeMeleed( dummy, true )
	if(AimTrainer_AI_COLOR == 5)
		dummy.SetSkin(RandomIntRangeInclusive(1,4))
	else
		dummy.SetSkin(AimTrainer_AI_COLOR)
	dummy.DisableHibernation()
}

vector function AimTrainerOriginToGround( vector origin )
{
	vector endOrigin         = <origin.x, origin.y, -MAX_WORLD_COORD_BUFFER >
	TraceResults traceResult = TraceLine( origin, endOrigin, [], TRACE_MASK_NPCWORLDSTATIC, TRACE_COLLISION_GROUP_NONE )

	return traceResult.endPos
}

//CHALLENGE "Strafing dummies"
void function StartStraferDummyChallenge(entity player)
{
	if(!IsValid(player)) return
	player.SetOrigin(onGroundLocationPos)
	player.SetAngles(onGroundLocationAngs)
	
	EndSignal(player, "ChallengeTimeOver")
	OnThreadEnd(
		function() : ( player)
		{
			OnChallengeEnd(player)
		}
	)
	
	wait AimTrainer_PRE_START_TIME
	RemoveCinematicFlag( player, CE_FLAG_HIDE_MAIN_HUD_INSTANT )
	RemoveCinematicFlag( player, CE_FLAG_HIDE_PERMANENT_HUD)
	player.UnfreezeControlsOnServer()
	float endtime = Time() + AimTrainer_CHALLENGE_DURATION
	thread ChallengeWatcherThread(endtime, player)

	while(true){
		if(!AimTrainer_INFINITE_CHALLENGE && Time() > endtime) break
		vector dummypos = player.GetOrigin() + AnglesToForward(onGroundLocationAngs)*100*AimTrainer_SPAWN_DISTANCE
		entity dummy = CreateDummy( 99, AimTrainerOriginToGround( dummypos + Vector(0,0,10000)), Vector(0,0,0) )
		vector pos = dummy.GetOrigin()
		vector angles = dummy.GetAngles()
		StartParticleEffectInWorld( GetParticleSystemIndex( FIRINGRANGE_ITEM_RESPAWN_PARTICLE ), pos, angles )
		SetSpawnOption_AISettings( dummy, "npc_dummie_combat_trainer" )
		DispatchSpawn( dummy )
		dummy.SetOrigin(dummy.GetOrigin() + Vector(0,0,1))
		
		//PutEntityInSafeSpot( dummy, null, null, dummy.GetOrigin() + dummy.GetUpVector()*2048 + dummy.GetForwardVector()*2048 , dummy.GetOrigin() )
		
		dummy.SetShieldHealthMax( ReturnShieldAmountForDesiredLevel() )
		dummy.SetShieldHealth( ReturnShieldAmountForDesiredLevel() )
		dummy.SetMaxHealth( AimTrainer_AI_HEALTH )
		dummy.SetHealth( AimTrainer_AI_HEALTH )
		SetCommonDummyLines(dummy)
		AddEntityCallback_OnDamaged(dummy, OnStraferDummyDamaged)
		AddEntityCallback_OnKilled(dummy, OnDummyKilled)
		
		waitthread StrafeMovement(dummy, player)
		wait 0.2
	}
}

void function StrafeMovement(entity ai, entity player)
{
	ai.EndSignal("OnDeath")
	player.EndSignal("ChallengeTimeOver")
	
	OnThreadEnd(
		function() : ( ai )
		{
			if(IsValid(ai)) ai.Destroy()
			ChallengesEntities.dummies.removebyvalue(dummy)
		}
	)

	while(IsValid(ai))
	{
		ai.SetAngles(VectorToAngles( player.GetOrigin() - ai.GetOrigin()))
			
		int random = RandomIntRangeInclusive(1,10)
		if (random == 9 || random == 10){
			ai.Anim_ScriptedPlayActivityByName( "ACT_STAND", true, 0.1 )
			ai.Anim_SetPlaybackRate(AimTrainer_STRAFING_SPEED)
			wait RandomFloatRange(0.05,0.25)*(1/AimTrainer_STRAFING_SPEED_WAITTIME)
		}
		else
		{
			ai.Anim_ScriptedPlayActivityByName( "ACT_RUN_RIGHT", true, 0.1 )
			ai.Anim_SetPlaybackRate(AimTrainer_STRAFING_SPEED)
			wait RandomFloatRange(0.05,0.5)*(1/AimTrainer_STRAFING_SPEED_WAITTIME)
			ai.Anim_ScriptedPlayActivityByName( "ACT_RUN_LEFT", true, 0.1 )
			ai.Anim_SetPlaybackRate(AimTrainer_STRAFING_SPEED)
			wait RandomFloatRange(0.05,0.5)*(1/AimTrainer_STRAFING_SPEED_WAITTIME)
		}
	}
}

//CHALLENGE "Switching targets"
void function StartSwapFocusDummyChallenge(entity player)
{
	if(!IsValid(player)) return
	
	player.SetOrigin(onGroundLocationPos)
	player.SetAngles(onGroundLocationAngs)
	EndSignal(player, "ChallengeTimeOver")
	
	OnThreadEnd(
		function() : ( player)
		{
			OnChallengeEnd(player)
		}
	)
	
	array<vector> circleLocations

	wait AimTrainer_PRE_START_TIME
	RemoveCinematicFlag( player, CE_FLAG_HIDE_MAIN_HUD_INSTANT )
	RemoveCinematicFlag( player, CE_FLAG_HIDE_PERMANENT_HUD)
	player.UnfreezeControlsOnServer()
	float endtime = Time() + AimTrainer_CHALLENGE_DURATION
	thread ChallengeWatcherThread(endtime, player)

	while(true){
		circleLocations.clear()
		for(int i = 0; i < 20; i ++)
			{
				float r = float(i) / float(20) * 2 * PI
				vector origin2 = Vector(0,0,0) + player.GetOrigin() + 100 * AimTrainer_SPAWN_DISTANCE * <sin( r ), cos( r ), 0.0>
				circleLocations.append(origin2)
				
				foreach(dummy in GetNPCArray())
				{
					float distance = Distance(dummy.GetOrigin(), origin2)
					if(distance < 200)
						circleLocations.removebyvalue(origin2)
				}		
			}
		if(circleLocations.len() == 0) //fix for rare case
		{
			for(int i = 0; i < 20; i ++)
				{
					float r = float(i) / float(20) * 2 * PI
					vector origin2 = Vector(0,0,0) + player.GetOrigin() + 100 * AimTrainer_SPAWN_DISTANCE * <sin( r ), cos( r ), 0.0>
					circleLocations.append(origin2)
				}
		}
		circleLocations.randomize()
		
		if(!AimTrainer_INFINITE_CHALLENGE && Time() > endtime) break		
		if(ChallengesEntities.dummies.len()<5){

			vector circleoriginfordummy = circleLocations.getrandom()
			entity dummy = CreateDummy( 99, AimTrainerOriginToGround(circleoriginfordummy + <0, 0, 10000> ) , onGroundLocationAngs*-1 )
			vector pos = dummy.GetOrigin()
			vector angles = dummy.GetAngles()
			StartParticleEffectInWorld( GetParticleSystemIndex( FIRINGRANGE_ITEM_RESPAWN_PARTICLE ), pos, angles )
			SetSpawnOption_AISettings( dummy, "npc_dummie_combat_trainer" )
			DispatchSpawn( dummy )	
			dummy.SetOrigin(dummy.GetOrigin() + Vector(0,0,5))
			
			//PutEntityInSafeSpot( dummy, null, null, dummy.GetOrigin() + dummy.GetUpVector()*2048 + dummy.GetForwardVector()*2048 , dummy.GetOrigin() )
	
			dummy.SetShieldHealthMax( ReturnShieldAmountForDesiredLevel() )
			dummy.SetShieldHealth( ReturnShieldAmountForDesiredLevel() )
			dummy.SetMaxHealth( AimTrainer_AI_HEALTH )
			dummy.SetHealth( AimTrainer_AI_HEALTH )
			SetCommonDummyLines(dummy)
			ChallengesEntities.dummies.append(dummy)
			
			AddEntityCallback_OnDamaged(dummy, OnStraferDummyDamaged)
			AddEntityCallback_OnKilled(dummy, OnDummyKilled)

			thread TargetSwitcthingWatcher(dummy, player)
		}
		WaitFrame()
	}
}

void function TargetSwitcthingWatcher(entity ai, entity player)
{
	ai.EndSignal("OnDeath")
	player.EndSignal("ChallengeTimeOver")
	
	OnThreadEnd(
		function() : ( ai )
		{
			if(IsValid(ai)) ai.Destroy()
			ChallengesEntities.dummies.removebyvalue(ai)
		}
	)
	
	while(IsValid(ai))
    {
		ai.SetAngles(VectorToAngles( player.GetOrigin() - ai.GetOrigin()))
		
        int random = RandomIntRangeInclusive(1,6)
        if(random == 1 || random == 2 || random == 3){
        //w s strafe
            ai.Anim_ScriptedPlayActivityByName( "ACT_SPRINT_RIGHT", true, 0.1 )
			ai.Anim_SetPlaybackRate(AimTrainer_STRAFING_SPEED)
            wait 0.4*(1/AimTrainer_STRAFING_SPEED_WAITTIME)
            ai.Anim_ScriptedPlayActivityByName( "ACT_SPRINT_LEFT", true, 0.1 )
			ai.Anim_SetPlaybackRate(AimTrainer_STRAFING_SPEED)
            wait 0.4*(1/AimTrainer_STRAFING_SPEED_WAITTIME)
        }
        else if(random == 4 || random == 5){
        //a d strafe
            ai.Anim_ScriptedPlayActivityByName( "ACT_SPRINT_FORWARD", true, 0.1 )
			ai.Anim_SetPlaybackRate(AimTrainer_STRAFING_SPEED)
            wait 0.4*(1/AimTrainer_STRAFING_SPEED_WAITTIME)
            ai.Anim_ScriptedPlayActivityByName( "ACT_SPRINT_BACKWARD", true, 0.1 )
			ai.Anim_SetPlaybackRate(AimTrainer_STRAFING_SPEED)
            wait 0.4*(1/AimTrainer_STRAFING_SPEED_WAITTIME)
        }
        else if (random == 6){
        //a d small crouch strafe
            ai.Anim_ScriptedPlayActivityByName( "ACT_STRAFE_TO_CROUCH_LEFT", true, 0.1 )
			ai.Anim_SetPlaybackRate(AimTrainer_STRAFING_SPEED)
            wait 0.4*(1/AimTrainer_STRAFING_SPEED_WAITTIME)
            ai.Anim_ScriptedPlayActivityByName( "ACT_STRAFE_TO_CROUCH_RIGHT", true, 0.1 )
			ai.Anim_SetPlaybackRate(AimTrainer_STRAFING_SPEED)
            wait 0.4*(1/AimTrainer_STRAFING_SPEED_WAITTIME)
        }
    }
}

//CHALLENGE "Floating target"
void function StartFloatingTargetChallenge(entity player)
{
	if(!IsValid(player)) return

	player.SetOrigin(floorCenterForPlayer)
	player.SetAngles(Vector(0,-90,0))
	EndSignal(player, "ChallengeTimeOver")
	ChallengesEntities.floor = CreateFloorAtOrigin(floorLocation, 30, 30)
	
	OnThreadEnd(
		function() : ( player)
		{
		OnChallengeEnd(player)
		}
	)
	
	wait AimTrainer_PRE_START_TIME
	RemoveCinematicFlag( player, CE_FLAG_HIDE_MAIN_HUD_INSTANT )
	RemoveCinematicFlag( player, CE_FLAG_HIDE_PERMANENT_HUD)
	player.UnfreezeControlsOnServer()
	float endtime = Time() + AimTrainer_CHALLENGE_DURATION	
	thread ChallengeWatcherThread(endtime, player)

	while(true){
		if(!AimTrainer_INFINITE_CHALLENGE && Time() > endtime) break	
		entity dummy = CreateDummy(99, player.GetOrigin() + AnglesToForward(player.GetAngles())* 100 * AimTrainer_SPAWN_DISTANCE, Vector(0,90,0))
		vector pos = dummy.GetOrigin()
		vector angles = dummy.GetAngles()
		StartParticleEffectInWorld( GetParticleSystemIndex( FIRINGRANGE_ITEM_RESPAWN_PARTICLE ), pos, angles )
		SetSpawnOption_AISettings( dummy, "npc_dummie_combat_trainer" )
		DispatchSpawn( dummy )	
		dummy.SetShieldHealthMax( ReturnShieldAmountForDesiredLevel() )
		dummy.SetShieldHealth( ReturnShieldAmountForDesiredLevel() )
		dummy.SetMaxHealth( AimTrainer_AI_HEALTH )
		dummy.SetHealth( AimTrainer_AI_HEALTH )
		SetCommonDummyLines(dummy)
		AddEntityCallback_OnDamaged(dummy, OnFloatingDummyDamaged)
		AddEntityCallback_OnKilled(dummy, OnDummyKilled)
		ChallengesEntities.dummies.append(dummy)
		
		array<string> attachments = [ "vent_left", "vent_right" ]
		foreach ( attachment in attachments )
			{
					int enemyID    = GetParticleSystemIndex( $"P_enemy_jump_jet_ON_trails" )
					entity enemyFX = StartParticleEffectOnEntity_ReturnEntity( dummy, enemyID, FX_PATTACH_POINT_FOLLOW, dummy.LookupAttachment( attachment ) )
			}
		
		WaitSignal(dummy, "OnDeath") //pero es inmortal
		wait 0.5
	}
}

//CHALLENGE "Popcorn targets"
void function StartPopcornChallenge(entity player)
{
	if(!IsValid(player)) return
	
	player.SetOrigin(floorCenterForPlayer)
	player.SetAngles(Vector(0,-90,0))
	ChallengesEntities.floor = CreateFloorAtOrigin(floorLocation, 30, 30)
	EndSignal(player, "ChallengeTimeOver")
	
	OnThreadEnd(
		function() : ( player)
		{
			OnChallengeEnd(player)
		}
	)
	
	wait AimTrainer_PRE_START_TIME
	RemoveCinematicFlag( player, CE_FLAG_HIDE_MAIN_HUD_INSTANT )
	RemoveCinematicFlag( player, CE_FLAG_HIDE_PERMANENT_HUD)
	player.UnfreezeControlsOnServer()
	float endtime = Time() + AimTrainer_CHALLENGE_DURATION
	thread ChallengeWatcherThread(endtime, player)
	
	while(true){
		if(!AimTrainer_INFINITE_CHALLENGE && Time() > endtime) break
		if(ChallengesEntities.dummies.len()<4)
				thread CreateDummyPopcornChallenge(player)
		WaitFrame()
	}
}

void function CreateDummyPopcornChallenge(entity player)
{
	float r = float(RandomInt(6)) / float(6) * 2 * PI
	entity dummy = CreateDummy( 99, player.GetOrigin() + 100 * AimTrainer_SPAWN_DISTANCE * <sin( r ), cos( r ), 0.0>, <0,90,0> )
	EndSignal(dummy, "OnDeath")

	StartParticleEffectInWorld( GetParticleSystemIndex( FIRINGRANGE_ITEM_RESPAWN_PARTICLE ), dummy.GetOrigin(), dummy.GetAngles() )
	SetSpawnOption_AISettings( dummy, "npc_dummie_combat_trainer" )
	DispatchSpawn( dummy )	
	dummy.SetShieldHealthMax( ReturnShieldAmountForDesiredLevel() )
	dummy.SetShieldHealth( ReturnShieldAmountForDesiredLevel() )
	dummy.SetMaxHealth( AimTrainer_AI_HEALTH )
	dummy.SetHealth( AimTrainer_AI_HEALTH )
	SetCommonDummyLines(dummy)
	AddEntityCallback_OnDamaged(dummy, OnStraferDummyDamaged)
	AddEntityCallback_OnKilled(dummy, OnDummyKilled)
	ChallengesEntities.dummies.append(dummy)
	
	int random = 1				
	if(CoinFlip()) random = -1
	entity ai = dummy //im lazy to change the copy paste from below ok
				
	array<string> attachments = [ "vent_left", "vent_right" ]
	foreach ( attachment in attachments )
		{
				int enemyID    = GetParticleSystemIndex( $"P_enemy_jump_jet_ON_trails" )
				entity enemyFX = StartParticleEffectOnEntity_ReturnEntity( dummy, enemyID, FX_PATTACH_POINT_FOLLOW, dummy.LookupAttachment( attachment ) )
		}

	while(IsValid(ai)){		
		if( ai.GetOrigin().z - floorLocation.z < 50)
		{
			vector angles2 = VectorToAngles( player.GetOrigin() - ai.GetOrigin())
			ai.SetAngles(angles2)
			
			if(CoinFlip())
				random = 1
			else
				random = -1

			int random2 = RandomIntRangeInclusive(1,5)
			if(random2 == 5)
				ai.SetVelocity(AnglesToForward( angles2 ) * 128 + AnglesToUp(angles2)*RandomFloatRange(512,1024))
			else
				ai.SetVelocity((AnglesToRight( angles2 ) * RandomFloatRange(128,256) * random ) + AnglesToUp(angles2)*RandomFloatRange(512,1024))
				
			EmitSoundOnEntity( ai, "JumpPad_LaunchPlayer_3p" )
		}
		WaitFrame()
	}
}

//CHALLENGE "Shooting Valk's ult"
void function StartStraightUpChallenge(entity player)
{
	if(!IsValid(player)) return
	
	ChallengesEntities.floor = CreateFloorAtOrigin(floorLocation, 30, 30)
	player.SetOrigin(floorCenterForPlayer)
	player.SetAngles(Vector(0,180,0))
	EndSignal(player, "ChallengeTimeOver")
	
	OnThreadEnd(
		function() : ( player)
		{
			OnChallengeEnd(player)
		}
	)
	
	wait AimTrainer_PRE_START_TIME
	RemoveCinematicFlag( player, CE_FLAG_HIDE_MAIN_HUD_INSTANT )
	RemoveCinematicFlag( player, CE_FLAG_HIDE_PERMANENT_HUD)
	player.UnfreezeControlsOnServer()
	float endtime = Time() + AimTrainer_CHALLENGE_DURATION	
	thread ChallengeWatcherThread(endtime, player)
	
	while(true){
		if(!AimTrainer_INFINITE_CHALLENGE && Time() > endtime) break
		
		if(ChallengesEntities.dummies.len()<4){
				thread CreateDummyStraightUpChallenge(player)
				wait 2.5
			}
			WaitFrame()
	}
}

void function CreateDummyStraightUpChallenge(entity player)
{
	int random = 1
	if(CoinFlip()) random = -1
	
	int random2 = 1
	if(CoinFlip()) random2 = -1	
	
	entity dummy = CreateDummy( 99, player.GetOrigin() + AnglesToForward(player.GetAngles()) * RandomIntRange(100,500)* random * AimTrainer_SPAWN_DISTANCE + AnglesToRight(player.GetAngles())*RandomIntRange(100,900)*random2, Vector(0,180,0) )
	EndSignal(dummy, "OnDeath")
	EndSignal(player, "ChallengeTimeOver")
	
	OnThreadEnd(
		function() : ( dummy )
		{
			if(IsValid(dummy)) dummy.Destroy()
			ChallengesEntities.dummies.removebyvalue(dummy)
		}
	)
	
	StartParticleEffectInWorld( GetParticleSystemIndex( FIRINGRANGE_ITEM_RESPAWN_PARTICLE ), dummy.GetOrigin(), dummy.GetAngles())
	SetSpawnOption_AISettings( dummy, "npc_dummie_combat_trainer" )
	DispatchSpawn( dummy )	
	dummy.SetShieldHealthMax( ReturnShieldAmountForDesiredLevel() )
	dummy.SetShieldHealth( ReturnShieldAmountForDesiredLevel() )
	dummy.SetMaxHealth( AimTrainer_AI_HEALTH )
	dummy.SetHealth( AimTrainer_AI_HEALTH )
	SetCommonDummyLines(dummy)
	AddEntityCallback_OnDamaged(dummy, OnStraferDummyDamaged)
	AddEntityCallback_OnKilled(dummy, OnDummyKilled)
	ChallengesEntities.dummies.append(dummy)
	
	entity ai = dummy				
	array<string> attachments = [ "vent_left", "vent_right" ]
	foreach ( attachment in attachments )
		{
			int enemyID    = GetParticleSystemIndex( $"P_enemy_jump_jet_ON_trails" )
			entity enemyFX = StartParticleEffectOnEntity_ReturnEntity( dummy, enemyID, FX_PATTACH_POINT_FOLLOW, dummy.LookupAttachment( attachment ) )
		}
	EmitSoundOnEntity(dummy, "jumpjet_freefall_body_3p_enemy_OLD")
	
	int idk = 1348 //from retail
	float flyingTime = Time() + 5.0 //from retail
	while( Time() <= flyingTime )
	{
		dummy.SetVelocity( <dummy.GetVelocity().x, dummy.GetVelocity().y, idk> )
		WaitFrame()
	}
}

//CHALLENGE "Arcstars practice"
void function StartArcstarsChallenge(entity player)
{
	if(!IsValid(player)) return
	
	player.SetOrigin(onGroundLocationPos)
	player.SetAngles(onGroundLocationAngs)
	EndSignal(player, "ChallengeTimeOver")
	TakeAllWeapons(player)
	player.GiveWeapon( "mp_weapon_grenade_emp", WEAPON_INVENTORY_SLOT_PRIMARY_0, ["challenges_infinite_arcstars"] )
	player.SetActiveWeaponBySlot(eActiveInventorySlot.mainHand, WEAPON_INVENTORY_SLOT_PRIMARY_0)

	OnThreadEnd(
		function() : ( player)
		{
			TakeAllWeapons(player)
			GiveWeaponsFromStoredArray(player, player.p.storedWeapons)
			OnChallengeEnd(player)
		}
	)
	
	wait AimTrainer_PRE_START_TIME
	RemoveCinematicFlag( player, CE_FLAG_HIDE_MAIN_HUD_INSTANT )
	RemoveCinematicFlag( player, CE_FLAG_HIDE_PERMANENT_HUD)
	player.UnfreezeControlsOnServer()
	float endtime = Time() + AimTrainer_CHALLENGE_DURATION
	thread ChallengeWatcherThread(endtime, player)
	array<vector> circleLocations

	while(true){
		circleLocations.clear()
		for(int i = 0; i < 15; i ++)
			{
				float r = float(i) / float(15) * 2 * PI
				vector origin2 = Vector(0,0,0) + player.GetOrigin() + 100 * AimTrainer_SPAWN_DISTANCE * <sin( r ), cos( r ), 0.0>
				circleLocations.append(origin2)
			}
			
		if(!AimTrainer_INFINITE_CHALLENGE && Time() > endtime) break
		if(ChallengesEntities.dummies.len()<5){
			vector circleoriginfordummy = circleLocations.getrandom()
			entity dummy = CreateDummy( 99, AimTrainerOriginToGround( <circleoriginfordummy.x, circleoriginfordummy.y, 10000> ), onGroundLocationAngs*-1)
			StartParticleEffectInWorld( GetParticleSystemIndex( FIRINGRANGE_ITEM_RESPAWN_PARTICLE ), dummy.GetOrigin(), dummy.GetAngles() )
			SetSpawnOption_AISettings( dummy, "npc_dummie_combat_trainer" )
			DispatchSpawn( dummy )
			
			//PutEntityInSafeSpot( dummy, null, null, dummy.GetOrigin() + dummy.GetUpVector()*2048 + dummy.GetForwardVector()*2048 , dummy.GetOrigin() )

			dummy.SetMaxHealth( AimTrainer_AI_HEALTH )
			dummy.SetHealth( AimTrainer_AI_HEALTH )
			SetCommonDummyLines(dummy)
			SetTargetName(dummy, "arcstarChallengeDummy")
			ChallengesEntities.dummies.append(dummy)
			AddEntityCallback_OnDamaged(dummy, OnStraferDummyDamaged)
			thread ArcstarsChallengeMovementThink(dummy, player)
		}
		WaitFrame()
	}
}

void function ArcstarsChallengeMovementThink(entity ai, entity player)
{
	if(!IsValid(ai)) return
	if(!IsValid(player )) return
	
	ai.EndSignal("OnDeath")
	player.EndSignal("ChallengeTimeOver")
	
	OnThreadEnd(
		function() : ( ai )
		{
			if(IsValid(ai)) ai.Destroy()
			ChallengesEntities.dummies.removebyvalue(ai)
		}
	)
	
	int randomangle = RandomIntRange(-45,45)
	if(CoinFlip()) randomangle = RandomIntRange(-90,90)
	ai.SetAngles(ai.GetAngles() + Vector(0,randomangle,0))
	
	int random = RandomIntRangeInclusive(1,10)
	if(random == 1)
	{
		if(CoinFlip())
		{
			ai.Anim_ScriptedPlayActivityByName( "ACT_SPRINT_LEFT", true, 0.1 )
			ai.Anim_SetPlaybackRate(AimTrainer_STRAFING_SPEED)
		}
		else 
		{
			ai.Anim_ScriptedPlayActivityByName( "ACT_SPRINT_RIGHT", true, 0.1 )
			ai.Anim_SetPlaybackRate(AimTrainer_STRAFING_SPEED)
		}
	}
	else
	{
		random = RandomIntRangeInclusive(1,10)
		if(random == 1)
		{
			ai.Anim_ScriptedPlayActivityByName( "ACT_SPRINT_BACKWARD", true, 0.1 )
			ai.Anim_SetPlaybackRate(AimTrainer_STRAFING_SPEED)
		}
		else //this will happen most likely
		{
			ai.Anim_ScriptedPlayActivityByName( "ACT_SPRINT_FORWARD", true, 0.1 )
			ai.Anim_SetPlaybackRate(AimTrainer_STRAFING_SPEED)
			thread ArcstarDummyChangeAngles(ai, player)
		}
	}
	thread ClippingAIWorkaround(ai)
	wait 4
	if(!IsValid(ai)) return
	int smokeAttachID = ai.LookupAttachment( "CHESTFOCUS" )
	entity smokeTrailFX = StartParticleEffectOnEntityWithPos_ReturnEntity( ai, GetParticleSystemIndex( $"P_grenade_thermite_trail"), FX_PATTACH_ABSORIGIN_FOLLOW, smokeAttachID, <0,0,0>, VectorToAngles( <0,0,-1> ) )
	entity smokeTrailFX2 = StartParticleEffectOnEntityWithPos_ReturnEntity( ai, GetParticleSystemIndex( $"P_grenade_thermite_trail"), FX_PATTACH_ABSORIGIN_FOLLOW, smokeAttachID, <0,0,0>, VectorToAngles( <0,0,-1> ) )
	wait 2
	if(IsValid(smokeTrailFX)) smokeTrailFX.Destroy()
	if(IsValid(smokeTrailFX2)) smokeTrailFX2.Destroy()
}

void function ArcstarDummyChangeAngles(entity ai, entity player)
{
	while(IsValid(ai)){
		if(RandomFloatRange(0,10) <= 0.5) //5% chance of changing angles while running
		{
			int randomangle = RandomIntRange(-45,45)
			if(CoinFlip()) randomangle = RandomIntRange(-90,90)
			vector angles = ai.GetAngles() + Vector(0,randomangle,0)
			ai.SetAngles(Vector(0,angles.y,0) )
		}
		WaitFrame()
	}
}


//CHALLENGE "Vertical Grenades practice"
void function StartVerticalGrenadesChallenge(entity player)
{
	if(!IsValid(player)) return
	
	ChallengesEntities.floor = CreateFloorAtOrigin(floorLocation, 30, 30)
	player.SetOrigin(floorCenterForPlayer)
	player.SetAngles(Vector(0,180,0))
	EndSignal(player, "ChallengeTimeOver")
	TakeAllWeapons(player)
	player.GiveWeapon( "mp_weapon_frag_grenade", WEAPON_INVENTORY_SLOT_PRIMARY_0, ["challenges_infinite_grenades"] )
	player.SetActiveWeaponBySlot(eActiveInventorySlot.mainHand, WEAPON_INVENTORY_SLOT_PRIMARY_0)

	OnThreadEnd(
		function() : ( player)
		{
			player.MovementEnable()
			player.ClearInvulnerable()
			TakeAllWeapons(player)
			GiveWeaponsFromStoredArray(player, player.p.storedWeapons)
			OnChallengeEnd(player)
		}
	)
	
	wait AimTrainer_PRE_START_TIME
	RemoveCinematicFlag( player, CE_FLAG_HIDE_MAIN_HUD_INSTANT )
	RemoveCinematicFlag( player, CE_FLAG_HIDE_PERMANENT_HUD)
	player.MovementDisable()
	player.UnfreezeControlsOnServer()
	player.SetInvulnerable()
	float endtime = Time() + AimTrainer_CHALLENGE_DURATION
	thread ChallengeWatcherThread(endtime, player)
	array<vector> circleLocations
	circleLocations.clear()
	
	for(int i = 0; i < 15; i ++)
		{
			float r = float(i) / float(15) * 2 * PI
			vector origin2 = Vector(0,0,0) + player.GetOrigin() + 600 * <sin( r ), cos( r ), 0.0>
			circleLocations.append(origin2)
		}
	circleLocations.randomize()
	int i = 0
	
	while(true){
		if(!AimTrainer_INFINITE_CHALLENGE && Time() > endtime) break
		if(i == circleLocations.len()){
			circleLocations.randomize()
			i = 0
		}
		if(ChallengesEntities.dummies.len()<4){
			vector circlelocation = circleLocations[i]	
			entity dummy = CreateDummy( 99, circlelocation, onGroundLocationAngs*-1)
			StartParticleEffectInWorld( GetParticleSystemIndex( FIRINGRANGE_ITEM_RESPAWN_PARTICLE ), dummy.GetOrigin(), dummy.GetAngles() )
			SetSpawnOption_AISettings( dummy, "npc_dummie_combat_trainer" )
			DispatchSpawn( dummy )
			dummy.SetOrigin(dummy.GetOrigin() - dummy.GetForwardVector()*RandomIntRange(400,700))
			vector vec2 = player.GetOrigin() - dummy.GetOrigin()
			vector angles2 = VectorToAngles( vec2 )
			dummy.SetAngles(angles2)
			i++
			// entity pipe = CreatePropDynamic($"mdl/pipes/slum_pipe_large_yellow_256_02.rmdl", dummy.GetOrigin()-Vector(0,0,190), Vector(0,0,0), 6, -1)
			// pipe.kv.rendermode = 4
			// pipe.kv.renderamt = 150
			// pipe.SetParent(dummy)
			dummy.SetBehaviorSelector( "behavior_dummy_empty" )
			dummy.DisableNPCFlag( NPC_ALLOW_PATROL | NPC_ALLOW_INVESTIGATE | NPC_NEW_ENEMY_FROM_SOUND )
			//dummy.SetShieldHealthMax( ReturnShieldAmountForDesiredLevel() )
			//dummy.SetShieldHealth( ReturnShieldAmountForDesiredLevel() )
			dummy.SetMaxHealth( AimTrainer_AI_HEALTH )
			dummy.SetHealth( AimTrainer_AI_HEALTH )
			SetCommonDummyLines(dummy)
			SetTargetName(dummy, "GrenadesChallengeDummy")
			Remote_CallFunction_NonReplay(player, "ServerCallback_CreateDistanceMarkerForGrenadesChallengeDummies", dummy, player)
			ChallengesEntities.dummies.append(dummy)
			AddEntityCallback_OnDamaged(dummy, OnStraferDummyDamaged)
			AddEntityCallback_OnKilled(dummy, OnDummyKilled)
		}
		WaitFrame()
	}
}

//CHALLENGE "Lift up practice"
void function StartLiftUpChallenge(entity player)
{
	if(!IsValid(player)) return
	player.SetVelocity(Vector(0,0,0))
	player.SetOrigin(onGroundLocationPos)
	player.SetAngles(onGroundLocationAngs)
	EndSignal(player, "ChallengeTimeOver")

	entity weapon = player.GetNormalWeapon( WEAPON_INVENTORY_SLOT_PRIMARY_0 )
	array<string> mods = weapon.GetMods()
	mods.append( "elevator_shooter" )
	try{weapon.SetMods( mods )} catch(e42069){printt(weapon.GetWeaponClassName() + " failed to put elevator_shooter mod. DEBUG THIS.")}
	
	OnThreadEnd(
		function() : ( player, mods, weapon)
		{
			SetConVarToDefault( "sv_gravity" ) //hack
			mods.removebyvalue("elevator_shooter")
			try{weapon.SetMods( mods )} catch(e42069){printt(weapon.GetWeaponClassName() + " failed to remove elevator_shooter mod. DEBUG THIS.")}
			OnChallengeEnd(player)
		}
	)
	wait AimTrainer_PRE_START_TIME
	array<vector> circleLocations = NavMesh_GetNeighborPositions( player.GetOrigin(), HULL_HUMAN, 40)
	RemoveCinematicFlag( player, CE_FLAG_HIDE_MAIN_HUD_INSTANT )
	RemoveCinematicFlag( player, CE_FLAG_HIDE_PERMANENT_HUD)
	float endtime = Time() + AimTrainer_CHALLENGE_DURATION	
	thread ChallengeWatcherThread(endtime, player)
	CreateLiftForChallenge(player.GetOrigin(), player)
	player.UnfreezeControlsOnServer()
	wait 0.05
	player.SetOrigin(player.GetOrigin() + player.GetForwardVector()*0.01) //workaround, so we execute onentertrigger callback instantly
	
	while(true){
		if(!AimTrainer_INFINITE_CHALLENGE && Time() > endtime) break	
		if(ChallengesEntities.dummies.len()<6){
			vector circleoriginfordummy = circleLocations.getrandom()
			entity dummy = CreateDummy( 99, AimTrainerOriginToGround( <circleoriginfordummy.x, circleoriginfordummy.y, 10000> ), onGroundLocationAngs*-1 )
			StartParticleEffectInWorld( GetParticleSystemIndex( FIRINGRANGE_ITEM_RESPAWN_PARTICLE ), dummy.GetOrigin(), dummy.GetAngles() )
			SetSpawnOption_AISettings( dummy, "npc_dummie_combat_trainer" )
			DispatchSpawn( dummy )
			dummy.UseSequenceBounds( false )
			dummy.SetShieldHealthMax( ReturnShieldAmountForDesiredLevel() )
			dummy.SetShieldHealth( ReturnShieldAmountForDesiredLevel() )
			dummy.SetMaxHealth( AimTrainer_AI_HEALTH )
			dummy.SetHealth( AimTrainer_AI_HEALTH )
			SetCommonDummyLines(dummy)
			ChallengesEntities.dummies.append(dummy)
			AddEntityCallback_OnDamaged(dummy, OnStraferDummyDamaged)
			AddEntityCallback_OnKilled(dummy, OnDummyKilled)
			thread LiftUpDummyMovementThink(dummy, player)
			thread ClippingAIWorkaround(dummy)
		}
		WaitFrame()
	}
}

void function LiftUpDummyMovementThink(entity ai, entity player)
{
	if(!IsValid(ai)) return
	if(!IsValid(player )) return
	
	ai.EndSignal("OnDeath")
	player.EndSignal("ChallengeTimeOver")
	
	OnThreadEnd(
		function() : ( ai )
		{
			if(!IsValid(ai)) return
			ai.Destroy()
			ChallengesEntities.dummies.removebyvalue(ai)
		}
	)
	
	ai.Anim_ScriptedPlayActivityByName( "ACT_SPRINT_FORWARD", true, 0.1 )
	ai.Anim_SetPlaybackRate(AimTrainer_STRAFING_SPEED)
	wait 0.5
	while(IsValid(ai)){
		if(RandomIntRangeInclusive(1,10) == 1) //10% chance of changing angles while running
		{
			int randomangle = RandomIntRange(-45,45)
			if(CoinFlip()) randomangle = RandomIntRange(-90,90)
			vector angles = ai.GetAngles() + Vector(0,randomangle,0)
			ai.SetAngles(Vector(0,angles.y,0) )
		}
		WaitFrame()
	}
}

void function CreateLiftForChallenge(vector pos, entity player)
{
	entity bottom = CreateEntity( "trigger_cylinder" )
	bottom.SetRadius( 70 )
	bottom.SetAboveHeight( 1200 )
	bottom.SetBelowHeight( 10 )
	bottom.SetOrigin( pos )
	bottom.SetLeaveCallback( BottomTriggerLeave )
	DispatchSpawn( bottom )

	entity top = CreateEntity( "trigger_cylinder" )
	top.SetRadius( 70 )
	top.SetAboveHeight( 250 )
	top.SetBelowHeight( 0 )
	top.SetOrigin( pos + <0, 0, 1200> )
	DispatchSpawn( top )
	
	ChallengesEntities.props.append(bottom)
	ChallengesEntities.props.append(top)
	
	thread LiftPlayerUp(bottom, top, pos, player)
	thread liftVisualsCreator(pos)
	//DebugDrawCylinder( pos, Vector(-90,0,0), 70, 1200, 100, 0, 0, true, float(AimTrainer_CHALLENGE_DURATION) )
}

void function liftVisualsCreator(vector pos)
{
	//Circle on ground FX
	entity circle = CreateEntity( "prop_script" )
	circle.SetValueForModelKey( $"mdl/weapons_r5/weapon_tesla_trap/mp_weapon_tesla_trap_ar_trigger_radius.rmdl" )
	circle.kv.fadedist = 30000
	circle.kv.renderamt = 0
	circle.kv.rendercolor = "240, 19, 19"
	circle.kv.modelscale = 0.27
	circle.kv.solid = 0
	circle.SetOrigin( pos + <0.0, 0.0, -25>)
	circle.SetAngles( <0, 0, 0> )
	circle.NotSolid()
	DispatchSpawn(circle)
	
	ChallengesEntities.props.append(circle)
}

void function BottomTriggerLeave( entity trigger, entity ent )
{
	if ( !ent.IsPlayer() || ent.IsPlayer() && ent.p.isRestartingLevel )
		return
	SetConVarToDefault( "sv_gravity" ) //hack
	vector forward = AnglesToForward( ent.GetAngles() )
	vector up = AnglesToUp( ent.GetAngles() )
	vector velocity = ent.GetVelocity()
	velocity += (forward * 400) + (up*450)
	ent.SetVelocity( velocity )
}

void function ForceToBeInLiftForChallenge( entity player )
{
	if(!player.IsPlayer()) return
	EndSignal(player, "ChallengeTimeOver")
	while(IsValid(player) && !player.p.isRestartingLevel)
	{
		player.SetVelocity(Vector(0,0,0))
		wait 5.5
		foreach(entity dummy in ChallengesEntities.dummies)
			if(IsValid(dummy)) dummy.Destroy()
		ChallengesEntities.dummies.clear()
		WaitFrame()
		player.p.touchingTopTrigger = false
		if(player.p.isRestartingLevel) break
		if(IsValid(player))
		{
			player.SetVelocity(Vector(0,0,0))
			player.SetOrigin(onGroundLocationPos)
		}
	}
}

void function LiftPlayerUp( entity bottom, entity top, vector pos, entity player)
{
	EndSignal(player, "ChallengeTimeOver")

	thread ForceToBeInLiftForChallenge(player)
	float PULL_RANGE = 300
	float PULL_STRENGTH_MAX = 50
	float UPVELOCITY
	float HORIZ_SPEED = 170
	
	while( true )
	{
		vector newVelocity
		if(top.IsTouching(player))
		{
			player.p.touchingTopTrigger = true
			SetConVarFloat( "sv_gravity", 0.01 ) //hack	
			UPVELOCITY = 25
			if(player.IsInputCommandHeld( IN_MOVERIGHT )) 
			{
				printt("lift top move right")
				newVelocity = AnglesToRight(player.GetAngles())*HORIZ_SPEED
				newVelocity.z = UPVELOCITY
			} else if(player.IsInputCommandHeld( IN_MOVELEFT ))
			{
				printt("lift top move left")
				newVelocity = AnglesToRight(player.GetAngles())*-HORIZ_SPEED
				newVelocity.z = UPVELOCITY
			} else if(player.IsInputCommandHeld( IN_FORWARD ))
			{
				printt("lift top move forward")
				newVelocity = AnglesToForward(player.GetAngles())*HORIZ_SPEED
				newVelocity.z = UPVELOCITY					
			} else if(player.IsInputCommandHeld( IN_BACK ))
			{
				printt("lift top move backward")
				newVelocity = AnglesToForward(player.GetAngles())*-HORIZ_SPEED
				newVelocity.z = UPVELOCITY					
			} else {
			vector enemyOrigin = player.GetOrigin()
			vector dir = Normalize( pos - player.GetOrigin() )
			float dist = Distance( enemyOrigin, pos )
			newVelocity = dir * GraphCapped( dist, 50, PULL_RANGE, 0, PULL_STRENGTH_MAX )
			newVelocity.z = UPVELOCITY
			}
			player.SetVelocity( newVelocity )
		}
		else if(bottom.IsTouching(player) && !player.p.touchingTopTrigger)
		{
			SetConVarFloat( "sv_gravity", 0.01 ) //hack
			UPVELOCITY = 340
			if(player.IsInputCommandHeld( IN_MOVERIGHT )) 
			{
				printt("lift move right")
				newVelocity = AnglesToRight(player.GetAngles())*HORIZ_SPEED
				newVelocity.z = UPVELOCITY
			} else if(player.IsInputCommandHeld( IN_MOVELEFT ))
			{
				printt("lift move left")
				newVelocity = AnglesToRight(player.GetAngles())*-HORIZ_SPEED
				newVelocity.z = UPVELOCITY
			} else if(player.IsInputCommandHeld( IN_FORWARD ))
			{
				printt("lift move forward")
				newVelocity = AnglesToForward(player.GetAngles())*HORIZ_SPEED
				newVelocity.z = UPVELOCITY					
			} else if(player.IsInputCommandHeld( IN_BACK ))
			{
				printt("lift move backward")
				newVelocity = AnglesToForward(player.GetAngles())*-HORIZ_SPEED
				newVelocity.z = UPVELOCITY					
			} else {
			vector enemyOrigin = player.GetOrigin()
			vector dir = Normalize( pos - player.GetOrigin() )
			float dist = Distance( enemyOrigin, pos )
			newVelocity = dir * GraphCapped( dist, 50, PULL_RANGE, 0, PULL_STRENGTH_MAX )
			newVelocity.z = UPVELOCITY
			}
			player.SetVelocity( newVelocity )
		}
		WaitFrame()
	}
}

//CHALLENGE "Tile Frenzy"
void function StartTileFrenzyChallenge(entity player)
{
	if(!IsValid(player)) return
	player.SetOrigin(floorCenterForPlayer)
	player.SetAngles(Vector(0,0,0))
	EndSignal(player, "ChallengeTimeOver")
	WaitFrame()
	ChallengesEntities.floor = CreateFloorAtOrigin(floorLocation, 30, 30)
	array<entity> Wall = CreateWallAtOrigin(player.GetOrigin()-Vector(0,0,200) + AnglesToForward(player.GetAngles())*580 + AnglesToRight(player.GetAngles())*1180, 9, 5, 90)
	foreach(entity wallprop in Wall)
		ChallengesEntities.floor.append(wallprop)
	
	//5x5?
	int ancho = 5
	int alto = 5
	vector pos = player.GetOrigin() + AnglesToForward(player.GetAngles())*400 + AnglesToRight(player.GetAngles())*100

	int x = int(pos.x)
	int y = int(pos.y)
	int z = int(pos.z+50)
	float modelscale = 0.2
	int offset = 0
	int step = int((offset+300)*modelscale)
	array<vector> locationsForTiles

	for(int i = y; i < y + (ancho * step); i += step)
	{
		for(int j = z; j < z + (alto * step); j += step)
		{
		locationsForTiles.append(<x, i, j>)
		}
	}
	WaitFrame()
	player.SetOrigin(player.GetOrigin() + Vector(0,0,100))
	ChallengesEntities.props.append(CreateFRProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", player.GetOrigin(), <0,0,0>) )
	PutEntityInSafeSpot( player, null, null, player.GetOrigin() + player.GetUpVector()*128, player.GetOrigin() )
	locationsForTiles.randomize()
	
	OnThreadEnd(
		function() : ( player)
		{
			if(!IsValid(player)) return
			player.MovementEnable()
			OnChallengeEnd(player)
		}
	)
	
	wait AimTrainer_PRE_START_TIME
	if(!IsValid(player)) return
	RemoveCinematicFlag( player, CE_FLAG_HIDE_MAIN_HUD_INSTANT )
	RemoveCinematicFlag( player, CE_FLAG_HIDE_PERMANENT_HUD)
	player.MovementDisable()
	player.UnfreezeControlsOnServer()
	float endtime = Time() + AimTrainer_CHALLENGE_DURATION
	thread ChallengeWatcherThread(endtime, player)
	int locationindex = 1
	while(true){
		if(!AimTrainer_INFINITE_CHALLENGE && Time() > endtime) break

		if(locationindex == locationsForTiles.len()){
			locationsForTiles.randomize()
			locationindex = 1
		}			
		if(ChallengesEntities.props.len() < 4){
					
				entity target = CreateEntity( "script_mover" )
				target.kv.solid = 6
				target.SetValueForModelKey( FIRINGRANGE_FLICK_TARGET_ASSET )
				target.kv.SpawnAsPhysicsMover = 0
				target.SetOrigin( locationsForTiles[locationindex] )				
				vector vec2 = player.GetOrigin() -  locationsForTiles[locationindex]
				locationindex++
				vector angles2 = VectorToAngles( vec2 )	
				target.SetAngles( angles2 )
				DispatchSpawn( target )
				target.Hide()
				target.SetDamageNotifications( true )
				
				entity visual = CreatePropDynamic(FIRINGRANGE_BLUE_TARGET_ASSET, target.GetOrigin(), target.GetAngles(), 6, -1)
				visual.SetParent(target)
				visual.SetModelScale(0.45)
				visual.NotSolid()
				
				AddEntityCallback_OnDamaged(target, OnTilePropDamaged)
				ChallengesEntities.props.append(target)
		}
		WaitFrame()
	}
}

//Close fast strafes CHALLENGE
void function StartCloseFastStrafesChallenge(entity player)
{
	if(!IsValid(player)) return
	player.SetOrigin(floorCenterForPlayer)
	player.SetAngles(Vector(0,90,0))
	ChallengesEntities.floor = CreateFloorAtOrigin(floorLocation, 30, 30)
	onGroundDummyPos = player.GetOrigin() + AnglesToForward(onGroundLocationAngs)*100*AimTrainer_SPAWN_DISTANCE

	EndSignal(player, "ChallengeTimeOver")
	
	OnThreadEnd(
		function() : ( player)
		{
			OnChallengeEnd(player)
		}
	)
	wait AimTrainer_PRE_START_TIME
	RemoveCinematicFlag( player, CE_FLAG_HIDE_MAIN_HUD_INSTANT )
	RemoveCinematicFlag( player, CE_FLAG_HIDE_PERMANENT_HUD)
	player.UnfreezeControlsOnServer()

	float endtime = Time() + AimTrainer_CHALLENGE_DURATION
	thread ChallengeWatcherThread(endtime, player)

	while(true){
		if(!AimTrainer_INFINITE_CHALLENGE && Time() > endtime) break
		
		entity dummy = CreateDummy( 99, onGroundDummyPos, onGroundLocationAngs*-1 )
		StartParticleEffectInWorld( GetParticleSystemIndex( FIRINGRANGE_ITEM_RESPAWN_PARTICLE ), dummy.GetOrigin(), dummy.GetAngles() )
		SetSpawnOption_AISettings( dummy, "npc_dummie_combat_trainer" )
		DispatchSpawn( dummy )	
		dummy.SetBehaviorSelector( "behavior_dummy_empty" )
		dummy.SetShieldHealthMax( ReturnShieldAmountForDesiredLevel() )
		dummy.SetShieldHealth( ReturnShieldAmountForDesiredLevel() )
		dummy.SetMaxHealth( AimTrainer_AI_HEALTH )
		dummy.SetHealth( AimTrainer_AI_HEALTH )
		SetCommonDummyLines(dummy)
		
		AddEntityCallback_OnDamaged(dummy, OnStraferDummyDamaged)
		AddEntityCallback_OnKilled(dummy, OnDummyKilled)
		
		waitthread DummyFastCloseStrafeMovement(dummy, player)
		wait 0.5
	}
}

void function DummyFastCloseStrafeMovement(entity dummy, entity player)
{
	EndSignal(dummy, "OnDeath")

	vector angles2 = VectorToAngles( player.GetOrigin() - dummy.GetOrigin() )

	dummy.SetOrigin(player.GetOrigin() + AnglesToForward(player.GetAngles())*100*AimTrainer_SPAWN_DISTANCE)

	entity script_mover = CreateEntity( "script_mover" )
	script_mover.kv.solid = 0
	script_mover.SetValueForModelKey( $"mdl/dev/empty_model.rmdl" )
	script_mover.kv.SpawnAsPhysicsMover = 0	
	script_mover.SetOrigin( dummy.GetOrigin() )
	script_mover.SetAngles( dummy.GetAngles() )
	DispatchSpawn( script_mover )
	dummy.SetParent(script_mover)
	
	OnThreadEnd(
		function() : ( dummy, script_mover )
		{
			dummy.ClearParent()
			if(IsValid(script_mover)) script_mover.Destroy()
			if(IsValid(dummy)) dummy.Destroy()
			ChallengesEntities.dummies.removebyvalue(dummy)			
		}
	)	
	
	while(IsValid(dummy))
	{
		angles2 = VectorToAngles( player.GetOrigin() - dummy.GetOrigin() )
		
		int morerandomness = 1
		if(CoinFlip()) morerandomness = -1
		
		script_mover.NonPhysicsMoveTo( player.GetOrigin() + Normalize(player.GetRightVector())*RandomIntRange(50,80)*morerandomness*AimTrainer_SPAWN_DISTANCE + Normalize(player.GetForwardVector())*RandomIntRange(20,150)*AimTrainer_SPAWN_DISTANCE, 0.6*AimTrainer_SPAWN_DISTANCE, 0.0, 0.0 )
		script_mover.SetAngles(angles2)
		dummy.SetAngles(angles2)
		wait 0.25
	}
}

//Close fast jumps strafes CHALLENGE
void function StartTapyDuckStrafesChallenge(entity player)
{
	if(!IsValid(player)) return
	player.SetOrigin(floorCenterForPlayer)
	player.SetAngles(Vector(0,90,0))
	ChallengesEntities.floor = CreateFloorAtOrigin(floorLocation, 30, 30)
	onGroundDummyPos = player.GetOrigin() + AnglesToForward(Vector(0,-90,0))*400

	EndSignal(player, "ChallengeTimeOver")
	
	OnThreadEnd(
		function() : ( player)
		{
			OnChallengeEnd(player)
		}
	)
	wait AimTrainer_PRE_START_TIME
	RemoveCinematicFlag( player, CE_FLAG_HIDE_MAIN_HUD_INSTANT )
	RemoveCinematicFlag( player, CE_FLAG_HIDE_PERMANENT_HUD)
	player.UnfreezeControlsOnServer()	

	float endtime = Time() + AimTrainer_CHALLENGE_DURATION
	thread ChallengeWatcherThread(endtime, player)

	while(true){
		if(!AimTrainer_INFINITE_CHALLENGE && Time() > endtime) break
		
		entity dummy = CreateDummy( 99, onGroundDummyPos, onGroundLocationAngs )
		vector pos = dummy.GetOrigin()
		vector angles = dummy.GetAngles()
		StartParticleEffectInWorld( GetParticleSystemIndex( FIRINGRANGE_ITEM_RESPAWN_PARTICLE ), pos, angles )
		SetSpawnOption_AISettings( dummy, "npc_dummie_combat_trainer" )
		DispatchSpawn( dummy )
		dummy.SetBehaviorSelector( "behavior_dummy_empty" )
		dummy.SetShieldHealthMax( ReturnShieldAmountForDesiredLevel() )
		dummy.SetShieldHealth( ReturnShieldAmountForDesiredLevel() )
		dummy.SetMaxHealth( AimTrainer_AI_HEALTH )
		dummy.SetHealth( AimTrainer_AI_HEALTH )
		SetCommonDummyLines(dummy)
		
		AddEntityCallback_OnDamaged(dummy, OnStraferDummyDamaged)
		AddEntityCallback_OnKilled(dummy, OnDummyKilled)
		
		waitthread DummyTapyDuckStrafeMovement(dummy, player)
		wait 0.5
	}
}

void function DummyTapyDuckStrafeMovement(entity dummy, entity player)
{
	EndSignal(dummy, "OnDeath")

	vector angles2 = VectorToAngles( player.GetOrigin() - dummy.GetOrigin() )

	array<vector> circleLocations

	for(int i = 0; i < 100; i ++)
	{
		float r = float(i) / float(100) * 2 * PI
		vector origin2 = player.GetOrigin() + 300 * <sin( r ), cos( r ), 0.0>
		circleLocations.append(origin2)
	}

	int locationindex = 0	
	dummy.SetOrigin(circleLocations[locationindex])

	entity script_mover = CreateEntity( "script_mover" )
	script_mover.kv.solid = 0
	script_mover.SetValueForModelKey( $"mdl/dev/empty_model.rmdl" )
	script_mover.kv.SpawnAsPhysicsMover = 0	
	script_mover.SetOrigin( dummy.GetOrigin() )
	script_mover.SetAngles( dummy.GetAngles() )
	DispatchSpawn( script_mover )
	dummy.SetParent(script_mover)
	
	OnThreadEnd(
		function() : ( dummy, script_mover, circleLocations )
		{
			dummy.ClearParent()
			if(IsValid(script_mover)) script_mover.Destroy()
			if(IsValid(dummy)) dummy.Destroy()
			circleLocations.clear()
			ChallengesEntities.dummies.removebyvalue(dummy)			
		}
	)	
	
	int oldLocationindex = 0
	while(true){		
		if(!IsValid(dummy)) break
		dummy.Anim_Stop()
		int morerandomness = 1
		if(CoinFlip()) morerandomness = -1

		int morerandomness3 = RandomIntRangeInclusive(1,10)
		int morerandomness4 = RandomIntRangeInclusive(1,5)
		vector dummyoldorigin = dummy.GetOrigin()
		if(morerandomness3 >= 1 && morerandomness3 <= 9) //75% chance
		{
			if(morerandomness4 == 5) //25% chance
			{
				dummy.Anim_Stop()
				script_mover.NonPhysicsStop()						
				dummy.Anim_ScriptedPlayActivityByName( "ACT_STAND", true, 0.1 )
				wait 0.15
			}
			else if(morerandomness4 >= 1 && morerandomness3 <= 4)//75% chance
			{
				oldLocationindex = locationindex
		
				if(CoinFlip())
					locationindex++
				else 
					locationindex--

				if(locationindex < 0)
					locationindex =	circleLocations.len() + locationindex
				else if(locationindex >= circleLocations.len())
					locationindex =	locationindex - (circleLocations.len()-1)

				script_mover.NonPhysicsMoveTo( circleLocations[locationindex], 0.15, 0.0, 0.0 )
				if(oldLocationindex >= locationindex) dummy.Anim_PlayOnly( "ACT_RUN_RIGHT")
				else if(oldLocationindex < locationindex) dummy.Anim_PlayOnly( "ACT_RUN_LEFT")
				dummy.Anim_DisableUpdatePosition()
				wait 0.12
				dummy.Anim_Stop()
				script_mover.NonPhysicsStop()
			}
		}
		else if (morerandomness3 == 10)
		{
			int morerandomness2 = 1
			if(CoinFlip()) morerandomness2 = -1
						
			// printt("Ras strafing??")
			thread DummyJumpAnimThreaded(dummy)
			float startTime = Time()
			float endTime = startTime + 0.28
			vector moveTo = dummyoldorigin + Normalize(dummy.GetRightVector())*10*morerandomness + Normalize(dummy.GetForwardVector())*-10 + Normalize(dummy.GetUpVector())*20
			int randomnessRasStrafe = 1
			if(CoinFlip()) randomnessRasStrafe = -1
			int curvedamount = 50
			float moveXFrom = moveTo.x+curvedamount*randomnessRasStrafe
			float moveZFrom = moveTo.z+30
			while(true)
			{
				if(endTime-Time() <= 0) 
				{
					script_mover.NonPhysicsStop()
					startTime = Time()
					endTime = startTime + 0.28
					moveTo = circleLocations[locationindex]
					moveXFrom = moveTo.x+curvedamount*-randomnessRasStrafe	
					moveZFrom = moveTo.z				
					while(endTime-Time() > 0)
					{
						script_mover.NonPhysicsMoveTo( Vector(GraphCapped( Time(), startTime, endTime, moveXFrom, moveTo.x ), moveTo.y, GraphCapped( Time(), startTime, endTime, moveZFrom, moveTo.z )), endTime-Time(), 0.0, 0.0 )
						WaitFrame()
					}
					script_mover.NonPhysicsStop()
					break
				}
				script_mover.NonPhysicsMoveTo( Vector(GraphCapped( Time(), startTime, endTime, moveXFrom, moveTo.x ), moveTo.y, GraphCapped( Time(), startTime, endTime, moveZFrom, moveTo.z )), endTime-Time(), 0.0, 0.0 )
				WaitFrame()
			}				
			script_mover.NonPhysicsStop()
			// printt("Ras strafing?? END")
		}
		angles2 = VectorToAngles( player.GetOrigin() - dummy.GetOrigin() )
		script_mover.SetAngles(angles2)
		dummy.SetAngles(angles2)
	}
}

void function DummyJumpAnimThreaded(entity dummy)
{
	if(IsValid(dummy))
		dummy.Anim_ScriptedPlayActivityByName( "ACT_MP_JUMP_START", true, 0.1 )
	wait 0.2
	if(IsValid(dummy))
		dummy.Anim_ScriptedPlayActivityByName( "ACT_MP_JUMP_FLOAT", true, 0.1 )
	wait 0.1
	if(IsValid(dummy))
		dummy.Anim_ScriptedPlayActivityByName( "ACT_MP_JUMP_LAND", true, 0.1 )					
}

//Smoothbot CHALLENGE
void function StartSmoothbotChallenge(entity player)
{
	if(!IsValid(player)) return
	player.SetOrigin(floorCenterForPlayer)
	player.SetAngles(Vector(-25,90,0))
	ChallengesEntities.floor = CreateFloorAtOrigin(floorLocation, 30, 30)
	onGroundDummyPos = player.GetOrigin() + AnglesToForward(onGroundLocationAngs)*400

	EndSignal(player, "ChallengeTimeOver")

	OnThreadEnd(
		function() : ( player)
		{
			OnChallengeEnd(player)
		}
	)
	wait AimTrainer_PRE_START_TIME
	RemoveCinematicFlag( player, CE_FLAG_HIDE_MAIN_HUD_INSTANT )
	RemoveCinematicFlag( player, CE_FLAG_HIDE_PERMANENT_HUD)
	player.UnfreezeControlsOnServer()
	
	float endtime = Time() + AimTrainer_CHALLENGE_DURATION
	thread ChallengeWatcherThread(endtime, player)

	while(true){
		if(!AimTrainer_INFINITE_CHALLENGE && Time() > endtime) break
		
		entity dummy = CreateDummy( 99, onGroundDummyPos, onGroundLocationAngs*-1 )
		vector pos = dummy.GetOrigin()
		vector angles = dummy.GetAngles()
		StartParticleEffectInWorld( GetParticleSystemIndex( FIRINGRANGE_ITEM_RESPAWN_PARTICLE ), pos, angles )
		SetSpawnOption_AISettings( dummy, "npc_dummie_combat_trainer" )
		DispatchSpawn( dummy )
		dummy.SetBehaviorSelector( "behavior_dummy_empty" )
		// dummy.SetShieldHealthMax( ReturnShieldAmountForDesiredLevel() )
		// dummy.SetShieldHealth( ReturnShieldAmountForDesiredLevel() )
		dummy.SetMaxHealth( AimTrainer_AI_HEALTH )
		dummy.SetHealth( AimTrainer_AI_HEALTH )
		SetCommonDummyLines(dummy)
		SetTargetName(dummy, "CloseFastDummy")
		
		AddEntityCallback_OnDamaged(dummy, OnStraferDummyDamaged)
		AddEntityCallback_OnKilled(dummy, OnDummyKilled)
		
		waitthread DummySmoothbotMovement(dummy, player)
		wait 0.5
	}
}

void function DummySmoothbotMovement(entity dummy, entity player)
{
	EndSignal(dummy, "OnDeath")

	array<vector> circleLocations
	array<vector> circleLocations2
	
	for(int i = 0; i < 100; i ++)
	{
		float r = float(i) / float(100) * 2 * PI
		vector origin2 = Vector(0,0,500) + player.GetOrigin() + 1000 * <sin( r ), cos( r ), 0.0>
		circleLocations.append(origin2)
	}
	
	for(int i = 0; i < 100; i ++)
	{
		float r = float(i) / float(100) * 2 * PI
		vector origin2 = Vector(0,0,0) + player.GetOrigin() + 500 * <sin( r ), cos( r ), 0.0>
		circleLocations2.append(origin2)
	}

	int locationindex = 0	
	dummy.SetOrigin(circleLocations[locationindex])

	entity script_mover = CreateEntity( "script_mover" )
	script_mover.kv.solid = 0
	script_mover.SetValueForModelKey( $"mdl/dev/empty_model.rmdl" )
	script_mover.kv.SpawnAsPhysicsMover = 0	
	script_mover.SetOrigin( dummy.GetOrigin() )
	script_mover.SetAngles( dummy.GetAngles() )
	DispatchSpawn( script_mover )
	dummy.SetParent(script_mover)
	
	OnThreadEnd(
		function() : ( dummy, script_mover, circleLocations, circleLocations2 )
		{
			dummy.ClearParent()
			if(IsValid(script_mover)) script_mover.Destroy()
			if(IsValid(dummy)) dummy.Destroy()
			circleLocations.clear()
			circleLocations2.clear()
			ChallengesEntities.dummies.removebyvalue(dummy)			
		}
	)	

	bool viniendodeavance
	bool lowerpasses
	int nottoorandom = 1
	if(CoinFlip()) nottoorandom = -1
	int togroundcounter = 0
	while(true)
	{
		dummy.Anim_Stop()

		int morerandomness = 1
		if(CoinFlip()) morerandomness = -1
		
		if(nottoorandom == 1) nottoorandom = -1	
		else if(nottoorandom == -1) nottoorandom = 1
		
		if(viniendodeavance)
		{
			if(CoinFlip() || togroundcounter == 1)
			{
				lowerpasses = false
				waitthread CoolScriptMoverMovement(player, script_mover, circleLocations[locationindex], nottoorandom, viniendodeavance, lowerpasses) //to sky
				togroundcounter = 0
			}
			else 
			{
				togroundcounter++
				lowerpasses = true
				waitthread CoolScriptMoverMovement(player, script_mover, circleLocations2[locationindex], nottoorandom, viniendodeavance, lowerpasses) //to ground
			}
			
			viniendodeavance = false			
			locationindex += RandomIntRange(1,5)*morerandomness
			
			if(locationindex < 0)
				locationindex =	(circleLocations.len()-1) + locationindex
			else if(locationindex >= circleLocations.len())
				locationindex =	locationindex - (circleLocations.len()-1)
			
			printt(locationindex)
		}
		else
		{
			waitthread CoolScriptMoverMovement(player, script_mover, circleLocations[locationindex], nottoorandom, viniendodeavance, lowerpasses)
			viniendodeavance = true
			lowerpasses = false
		}
	}
}

void function CoolScriptMoverMovement(entity player, entity script_mover, vector endLocation, int nottoorandom, bool viniendodeavance, bool lowerpasses)
{
	script_mover.EndSignal("OnDestroy")
	
	int morerandomness2 = 1
	if(CoinFlip()) morerandomness2 = -1		
	
	float startTime = Time()
	float endTime = startTime + 3
	vector moveTo = player.GetOrigin() + player.GetForwardVector()*100 + player.GetRightVector()*RandomInt(150)*morerandomness2 + player.GetUpVector()*RandomInt(50)
	if(viniendodeavance)
		moveTo = endLocation
	
	float moveXFrom = moveTo.x+RandomFloatRange(200,500)*nottoorandom
	float moveZFrom = moveTo.z
	if(!lowerpasses && viniendodeavance) moveZFrom += 300
	while(Time() < endTime)
	{	
		vector angles2 = VectorToAngles( player.GetOrigin() - script_mover.GetOrigin() )
		script_mover.SetAngles(Vector(script_mover.GetAngles().x, angles2.y, script_mover.GetAngles().z))
		vector moveToFinal = Vector(GraphCapped( Time(), startTime, endTime, moveXFrom, moveTo.x ), moveTo.y, GraphCapped( Time(), startTime, endTime, moveZFrom, moveTo.z ))
		script_mover.NonPhysicsMoveTo( moveToFinal, endTime-Time(), 0.0, 0.0 )
		vector vel = script_mover.GetVelocity()
		if(Distance(script_mover.GetOrigin(), moveTo) < 150.0) { //avoid to speed up too much
			script_mover.NonPhysicsStop()
			break
		}
		WaitFrame()
	}
}

//Skydiving targets CHALLENGE
void function StartSkyDiveChallenge(entity player)
{
	if(!IsValid(player)) return
	player.SetOrigin(floorCenterForPlayer)
	player.SetAngles(Vector(0,90,0))
	ChallengesEntities.floor = CreateFloorAtOrigin(floorLocation, 30, 30)
	onGroundDummyPos = player.GetOrigin() + AnglesToForward(Vector(0,-90,0))*100*AimTrainer_SPAWN_DISTANCE 

	EndSignal(player, "ChallengeTimeOver")
		
	OnThreadEnd(
		function() : ( player)
		{
			OnChallengeEnd(player)
		}
	)
	wait AimTrainer_PRE_START_TIME
	RemoveCinematicFlag( player, CE_FLAG_HIDE_MAIN_HUD_INSTANT )
	RemoveCinematicFlag( player, CE_FLAG_HIDE_PERMANENT_HUD)
	player.UnfreezeControlsOnServer()	

	float endtime = Time() + AimTrainer_CHALLENGE_DURATION
	thread ChallengeWatcherThread(endtime, player)

	while(true){
		if(!AimTrainer_INFINITE_CHALLENGE && Time() > endtime) break
		
		if(ChallengesEntities.dummies.len()<4){	
			entity dummy = CreateDummy( 99, onGroundDummyPos, onGroundLocationAngs )
			SetSpawnOption_AISettings( dummy, "npc_training_dummy_trainer" )
			DispatchSpawn( dummy )	
			dummy.SetShieldHealthMax( ReturnShieldAmountForDesiredLevel() )
			dummy.SetShieldHealth( ReturnShieldAmountForDesiredLevel() )
			dummy.SetMaxHealth( AimTrainer_AI_HEALTH )
			dummy.SetHealth( AimTrainer_AI_HEALTH )
			SetCommonDummyLines(dummy)
			dummy.DisableNPCFlag( NPC_ALLOW_PATROL | NPC_ALLOW_INVESTIGATE | NPC_NEW_ENEMY_FROM_SOUND )
			ChallengesEntities.dummies.append(dummy)
			array<string> attachments = [ "vent_left", "vent_right" ]
			
			foreach ( attachment in attachments )
				{
					int enemyID    = GetParticleSystemIndex( $"P_enemy_jump_jet_ON_trails" )
					entity enemyFX = StartParticleEffectOnEntity_ReturnEntity( dummy, enemyID, FX_PATTACH_POINT_FOLLOW, dummy.LookupAttachment( attachment ) )
				}
			//Skydive fx, visual clutter?
			// const array<vector> skydiveSmokeColors = [ <178,184,244>, <143,222,95>, <255,134,26>, <255,251,130>, <255,202,254> ]	
			// entity skydiveFx = StartParticleEffectOnEntity_ReturnEntity( dummy, GetParticleSystemIndex( $"P_skydive_trail_CP" ), FX_PATTACH_POINT_FOLLOW, player.LookupAttachment( "CHESTFOCUS" ) )
			// EffectSetControlPointVector( skydiveFx, 1, skydiveSmokeColors.getrandom())
			// ChallengesEntities.props.append(skydiveFx)
			
			AddEntityCallback_OnDamaged(dummy, OnStraferDummyDamaged)
			AddEntityCallback_OnKilled(dummy, OnDummyKilled)
			
			thread DummySkyDiveMovement(dummy, player)
		}
		WaitFrame()
	}
}

void function DummySkyDiveMovement(entity dummy, entity player)
{
	EndSignal(dummy, "OnDeath")
	EndSignal(dummy, "OnDestroy")

	array<vector> circleLocations
	array<vector> circleLocationsOnGround
	
	for(int i = 0; i < 50; i ++)
	{
		float r = float(i) / float(50) * 2 * PI
		vector origin2 = Vector(0,0,3000) + player.GetOrigin() + 200 * AimTrainer_SPAWN_DISTANCE  * <sin( r ), cos( r ), 0.0>
		circleLocations.append(origin2)
	}
	for(int i = 0; i < 50; i ++)
	{
		float r = float(i) / float(50) * 2 * PI
		vector origin2 = player.GetOrigin() + 400*AimTrainer_SPAWN_DISTANCE  * <sin( r ), cos( r ), 0.0>
		circleLocationsOnGround.append(origin2)
	}
	int locationindex = RandomInt(circleLocations.len())
	dummy.SetOrigin(circleLocations[locationindex])
	vector org1 = circleLocations[locationindex]
	vector org2 = dummy.GetOrigin()
	vector vec2 = org1 - org2
	vector angles2 = VectorToAngles( vec2 )
	dummy.SetAngles(angles2)
	
	StartParticleEffectInWorld( GetParticleSystemIndex( FIRINGRANGE_ITEM_RESPAWN_PARTICLE ), dummy.GetOrigin(), dummy.GetAngles())
	entity script_mover = CreateEntity( "script_mover" )
	script_mover.kv.solid = 0
	script_mover.SetValueForModelKey( $"mdl/dev/empty_model.rmdl" )
	script_mover.kv.SpawnAsPhysicsMover = 0	
	script_mover.SetOrigin( dummy.GetOrigin() )
	script_mover.SetAngles( dummy.GetAngles() )
	DispatchSpawn( script_mover )
	dummy.SetParent(script_mover)
	
	OnThreadEnd(
		function() : ( dummy, script_mover, circleLocations )
		{
			dummy.ClearParent()
			if(IsValid(script_mover)) script_mover.Destroy()
			if(IsValid(dummy)) dummy.Destroy()
			circleLocations.clear()
			ChallengesEntities.dummies.removebyvalue(dummy)			
		}
	)
	
	int oldLocationindex
	bool comingfromjump = false	
	EmitSoundOnEntity(dummy, "Survival_InGameFlight_Travel_3P")
	while(IsValid(dummy))
	{
		
		locationindex = RandomInt(circleLocationsOnGround.len())
		
		thread PlaySkyDiveAnims(dummy, circleLocationsOnGround, locationindex, script_mover)
		
		org1 = circleLocationsOnGround[locationindex]
		org2 = dummy.GetOrigin()
		vec2 = org1 - org2
		angles2 = VectorToAngles( vec2 )
			
		script_mover.SetAngles(angles2)
		dummy.SetAngles(angles2)
			
		script_mover.NonPhysicsMoveTo( circleLocationsOnGround[locationindex], 4.6, 0.0, 0.0 )	

		WaitForever()
		wait RandomFloatRange(0.2,1.0)
	}
}

void function PlaySkyDiveAnims(entity dummy, array<vector> ground, int locationindex , entity script_mover)
{
	float startingTime = Time()
	float movingTime = startingTime + 4.5
	vector locationEnd = ground[locationindex]
	
	while(IsValid(dummy))
	{
		dummy.Anim_PlayOnly( "animseq/humans/class/medium/pilot_medium_bloodhound/mp_pilot_freefall_dive.rseq")
		
		float distance = dummy.GetOrigin().z - locationEnd.z //Tracking the distance dummy is to the ground

		if( distance > 500 && distance <= 750)
		{		
			dummy.Anim_ScriptedPlayActivityByName( "ACT_MP_FREEFALL_TRANSITION_TO_ANTICIPATE", true, 0.1 )
			StopSoundOnEntity(dummy, "Survival_InGameFlight_Travel_3P")
			EmitSoundOnEntity(dummy, "Survival_InGameFlight_Land_Stop_3P")
		}
		else if( distance > 50 && distance <= 500)
		{
			dummy.Anim_ScriptedPlayActivityByName( "ACT_MP_FREEFALL_ANTICIPATE", true, 0.1 )
		}
		else if( distance <= 50)
		{
			StartParticleEffectInWorld( GetParticleSystemIndex( FIRINGRANGE_ITEM_RESPAWN_PARTICLE ), dummy.GetOrigin(), dummy.GetAngles() )
			if(IsValid(dummy))
				dummy.Destroy()
		}
		WaitFrame()	
	}
}
//CHALLENGE "Long Range Practice"
void function StartRunningTargetsChallenge(entity player)
{
	if(!IsValid(player)) return
	player.SetOrigin(onGroundLocationPos)
	player.SetAngles(onGroundLocationAngs)
	EndSignal(player, "ChallengeTimeOver")

	OnThreadEnd(
		function() : ( player)
		{
			OnChallengeEnd(player)
		}
	)
	wait AimTrainer_PRE_START_TIME
	RemoveCinematicFlag( player, CE_FLAG_HIDE_MAIN_HUD_INSTANT )
	RemoveCinematicFlag( player, CE_FLAG_HIDE_PERMANENT_HUD)
	player.UnfreezeControlsOnServer()
	
	array<vector> circleLocations = NavMesh_RandomPositions( player.GetOrigin(), HULL_HUMAN, 40, 200*AimTrainer_SPAWN_DISTANCE, 300*AimTrainer_SPAWN_DISTANCE  )

	float endtime = Time() + AimTrainer_CHALLENGE_DURATION
	thread ChallengeWatcherThread(endtime, player)

	WaitFrame()
	while(true){
		array<vector> NewcircleLocations = NavMesh_RandomPositions( AimTrainerOriginToGround( <player.GetOrigin().x, player.GetOrigin().y, 10000> ), HULL_HUMAN, 40, 200*AimTrainer_SPAWN_DISTANCE, 300*AimTrainer_SPAWN_DISTANCE  )
		if(NewcircleLocations.len() > 0 ) 
		{
			circleLocations.clear()
			circleLocations = NewcircleLocations
		}
		if(!AimTrainer_INFINITE_CHALLENGE && Time() > endtime) break	
		if(ChallengesEntities.dummies.len()<25){
			vector org1 = player.GetOrigin()
			int locationindex = RandomInt(circleLocations.len())
			vector org2 = circleLocations[locationindex]
			vector vec2 = org1 - org2
			int random = 1
			if(CoinFlip()) random = -1
			vector angles2 = AnglesToRight(VectorToAngles(vec2))*90*random
			vector circleoriginfordummy = circleLocations[locationindex]
			entity dummy = CreateDummy( 99, AimTrainerOriginToGround( <circleoriginfordummy.x, circleoriginfordummy.y, 10000> ), Vector(0,angles2.y,0) )
			SetSpawnOption_AISettings( dummy, "npc_dummie_combat_trainer" )
			DispatchSpawn( dummy )
			
			// PutEntityInSafeSpot( dummy, null, null, dummy.GetOrigin() + dummy.GetUpVector()*2048 + dummy.GetForwardVector()*2048 , dummy.GetOrigin() )
		
			dummy.SetShieldHealthMax( ReturnShieldAmountForDesiredLevel() )
			dummy.SetShieldHealth( ReturnShieldAmountForDesiredLevel() )
			dummy.SetMaxHealth( AimTrainer_AI_HEALTH )
			dummy.SetHealth( AimTrainer_AI_HEALTH )
			SetCommonDummyLines(dummy)
			ChallengesEntities.dummies.append(dummy)
			AddEntityCallback_OnDamaged(dummy, OnStraferDummyDamaged)
			AddEntityCallback_OnKilled(dummy, OnDummyKilled)
			
			thread DummyRunningTargetsMovement(dummy, player)
			thread ClippingAIWorkaround(dummy)
			wait 0.2
		}
		WaitFrame()
	}
}

void function DummyRunningTargetsMovement(entity ai, entity player)
{
	if(!IsValid(ai)) return
	if(!IsValid(player )) return
	
	ai.EndSignal("OnDeath")
	player.EndSignal("ChallengeTimeOver")
	
	OnThreadEnd(
		function() : ( ai )
		{
			if(IsValid(ai)) ai.Destroy()
			ChallengesEntities.dummies.removebyvalue(ai)
		}
	)

	ai.Anim_ScriptedPlayActivityByName( "ACT_SPRINT_FORWARD", true, 0.1 )
	ai.Anim_SetPlaybackRate(AimTrainer_STRAFING_SPEED)
	wait 0.5
	while(IsValid(ai)){
		float distance = Distance(ai.GetOrigin(), player.GetOrigin()) //Tracking the distance dummy is to the player
		int random = RandomIntRangeInclusive(1,10)
		if(random == 1 && distance >= 500 || random == 2 && distance >= 500 || random == 3 && distance >= 500)
		{
			int randomangle = RandomIntRange(-45,45)
			if(CoinFlip()) randomangle = RandomIntRange(-90,90)
			vector angles = ai.GetAngles() + Vector(0,randomangle,0)
			ai.SetAngles(Vector(0,angles.y,0) )
		}
		if(distance <= 100*AimTrainer_SPAWN_DISTANCE) //avoid being too close to player
		{ 
			vector vec = player.GetOrigin() - ai.GetOrigin()
			vector angles2 = VectorToAngles( vec )
			ai.SetAngles(Vector(0,angles2.y*-1,0) )
			wait 0.5
		}
		else if(distance >= 3000)
		{ 
			if(IsValid(ai)) ai.Destroy()
		}
		WaitFrame()
	}
}

//Challenges related end functions
void function OnChallengeEnd(entity player)
{
	if(!IsValid(player)) return
	
	player.p.isChallengeActivated = false
	Remote_CallFunction_NonReplay(player, "ServerCallback_SetChallengeActivated", false)
	
	ChallengeScore ThisChallengeData
	ThisChallengeData.straferDummyKilledCount = player.p.straferDummyKilledCount
	ThisChallengeData.straferChallengeDamage = player.p.straferChallengeDamage
	ThisChallengeData.straferCriticalShots = player.p.straferCriticalShots
	ThisChallengeData.straferShotsHit = player.p.straferShotsHit
	ThisChallengeData.straferTotalShots = player.p.straferTotalShots
	ThisChallengeData.straferAccuracy = float(player.p.straferShotsHit) / float(player.p.straferTotalShots)
	ChallengesData[player.p.challengeName].append(ThisChallengeData)

	printt("===========================================")
	printt("FLOWSTATE AIM TRAINER CHALLENGE RESULTS:")
	printt(" -Killed dummies: " + ThisChallengeData.straferDummyKilledCount)
	printt(" -Accuracy: " + ThisChallengeData.straferAccuracy)
	printt(" -Shots hit: " + ThisChallengeData.straferShotsHit)
	printt(" -Damage done: " + ThisChallengeData.straferChallengeDamage)
	printt(" -Crit. shots: " + ThisChallengeData.straferCriticalShots)
	printt("===========================================")
	
	if(ThisChallengeData.straferShotsHit > ChallengesBestScores[player.p.challengeName]) 
	{		
		ChallengesBestScores[player.p.challengeName] = ThisChallengeData.straferShotsHit
		player.p.isNewBestScore = true
	} else
		player.p.isNewBestScore = false
		
	if(!player.p.isRestartingLevel)
		Remote_CallFunction_NonReplay(player, "ServerCallback_OpenFRChallengesMenu", player.p.challengeName, ThisChallengeData.straferShotsHit, ThisChallengeData.straferDummyKilledCount, ThisChallengeData.straferAccuracy, ThisChallengeData.straferChallengeDamage, ThisChallengeData.straferCriticalShots,ChallengesBestScores[player.p.challengeName], player.p.isNewBestScore)
	
	Remote_CallFunction_NonReplay(player, "ServerCallback_HistoryUIAddNewChallenge", player.p.challengeName, ThisChallengeData.straferShotsHit, player.GetNormalWeapon( WEAPON_INVENTORY_SLOT_PRIMARY_0 ), ThisChallengeData.straferAccuracy, ThisChallengeData.straferDummyKilledCount, ThisChallengeData.straferChallengeDamage, ThisChallengeData.straferTotalShots, ThisChallengeData.straferCriticalShots)
	thread ChallengesStartAgain(player)
}

void function ChallengesStartAgain(entity player)
{
	EndSignal(player, "ForceResultsEnd_SkipButton")
	
	OnThreadEnd(
		function() : ( player )
		{
			if(IsValid(player))
			{
				player.FreezeControlsOnServer()
				player.SetVelocity(Vector(0,0,0))
				if(!player.p.isRestartingLevel)
					player.SetOrigin(AimTrainer_startPos)
				player.SetVelocity(Vector(0,0,0))
				if(!player.p.isRestartingLevel)
					player.SetAngles(AimTrainer_startAngs)
				HolsterAndDisableWeapons(player)
				
				//entities cleanup
				foreach(entity floor in ChallengesEntities.floor)
					if(IsValid(floor))
						floor.Destroy()
					
				foreach(entity dummie in ChallengesEntities.dummies)
					if(IsValid(dummie))
						dummie.Destroy()
				
				foreach(entity prop2 in ChallengesEntities.props)
					if(IsValid(prop2))			
						prop2.Destroy()
				
				player.p.dummieKilled += player.p.straferDummyKilledCount
				
				ResetChallengeStats(player)
				
				Remote_CallFunction_NonReplay(player, "ServerCallback_ResetLiveStatsUI")
				
				if(!player.p.isRestartingLevel)
				{
					Remote_CallFunction_NonReplay(player, "ServerCallback_CoolCameraOnMenu")
					Remote_CallFunction_NonReplay(player, "ServerCallback_OpenFRChallengesMainMenu", player.p.dummieKilled)
				} else				
					Remote_CallFunction_NonReplay(player, "ServerCallback_CloseFRChallengesResults")
				
				//give shield again
				Inventory_SetPlayerEquipment(player, "armor_pickup_lv1", "armor")
				player.SetShieldHealthMax(50)
				player.SetShieldHealth(50)
				
				//reload
				entity weapon = player.GetNormalWeapon( WEAPON_INVENTORY_SLOT_PRIMARY_0 )
				if (weapon.UsesClipsForAmmo() && IsValid(weapon) && weapon.GetWeaponClassName() != "mp_weapon_melee_survival")
					weapon.SetWeaponPrimaryClipCount(weapon.GetWeaponPrimaryClipCountMax())
				
				if(player.p.isRestartingLevel)
				{
					player.p.isRestartingLevel = false
					Remote_CallFunction_NonReplay(player, "ServerCallback_RestartChallenge", player.p.challengeName)
				}
			}
		}
	)
	//wait AimTrainer_RESULTS_TIME //should be the same as the while loop in CreateTimerRUI in cl file.
	if(!player.p.isRestartingLevel){
		WaitForever()
	}
}

void function ChallengeWatcherThread(float endtime, entity player)
{
	EndSignal(player, "ForceResultsEnd_SkipButton")
	EndSignal(player, "ChallengeTimeOver")
	
	OnThreadEnd(
		function() : ( player )
		{
			Signal(player, "ChallengeTimeOver")
		}
	)
	
	while(true){
		if(!AimTrainer_INFINITE_CHALLENGE) 
			if(Time() > endtime) break
		WaitFrame()
	}
}

//Callbacks functions
void function OnStraferDummyDamaged( entity dummy, var damageInfo )
{
	entity ent = dummy	
	entity attacker = DamageInfo_GetAttacker(damageInfo)
	if(!attacker.IsPlayer()) return
	
	if(dummy.GetTargetName() == "GrenadesChallengeDummy" )
	{
		// Damage from the grenade explosion does not register as a weapon, so we can assume this damage should not be registered
		if(DamageInfo_GetWeapon(damageInfo) != null)
		{
			return
		}
	}

	float damage = DamageInfo_GetDamage( damageInfo )
	
	//fake helmet
	float headshotMultiplier = GetHeadshotDamageMultiplierFromDamageInfo(damageInfo)
	float basedamage = DamageInfo_GetDamage(damageInfo)/headshotMultiplier
	
	if(IsValidHeadShot( damageInfo, dummy ))
	{
		int headshot = int(basedamage*(GetCurrentPlaylistVarFloat( "helmet_lv4", 0.65 )+(1-GetCurrentPlaylistVarFloat( "helmet_lv4", 0.65 ))*headshotMultiplier))
		DamageInfo_SetDamage( damageInfo, headshot)
		if(headshot > dummy.GetHealth() + dummy.GetShieldHealth()) 
		{
			printt(dummy.GetHealth() + " " + headshot)
			OnDummyKilled(dummy, damageInfo)
			attacker.p.straferDummyKilledCount++
			Remote_CallFunction_NonReplay(attacker, "ServerCallback_LiveStatsUIDummiesKilled", attacker.p.straferDummyKilledCount)
			ChallengesEntities.dummies.removebyvalue(ent)
		}
	} else if (damage > dummy.GetHealth() + dummy.GetShieldHealth() && dummy.GetShieldHealth() > 0)
	{
		attacker.p.straferDummyKilledCount++
		Remote_CallFunction_NonReplay(attacker, "ServerCallback_LiveStatsUIDummiesKilled", attacker.p.straferDummyKilledCount)
		ChallengesEntities.dummies.removebyvalue(ent)		
	}
	
	if(!attacker.IsPlayer() ) return
	
	//add the damage
	attacker.p.straferChallengeDamage += int(damage)
	Remote_CallFunction_NonReplay(attacker, "ServerCallback_LiveStatsUIDamageViaDummieDamaged", int(damage))
	Remote_CallFunction_NonReplay(attacker, "ServerCallback_LiveStatsUIAccuracyViaShotsHits")
	
	//infinite ammo
	if(AimTrainer_INFINITE_AMMO) attacker.RefillAllAmmo()
		
	//Inmortal target
	if(AimTrainer_INMORTAL_TARGETS || dummy.GetTargetName() == "CloseFastDummy") 
	{
		dummy.SetShieldHealth(dummy.GetShieldHealthMax())
		dummy.SetHealth(dummy.GetMaxHealth())
	}
	//add 1 hit
	attacker.p.straferShotsHit++
	if(attacker.p.straferShotsHit > attacker.p.straferShotsHitRecord) 
	{
		attacker.p.straferShotsHitRecord = attacker.p.straferShotsHit
		attacker.p.isNewBestScore = true
	}

	//was critical?
	bool isValidHeadShot = IsValidHeadShot( damageInfo, dummy )
	if(isValidHeadShot) 
	{
		attacker.p.straferCriticalShots++
		Remote_CallFunction_NonReplay(attacker, "ServerCallback_LiveStatsUIHeadshot", attacker.p.straferCriticalShots)
	}
	
	if(dummy.GetTargetName() == "arcstarChallengeDummy" ) OnDummyKilled(dummy, damageInfo)
}

void function OnFloatingDummyDamaged( entity dummy, var damageInfo )
{
	//fake helmet
	float headshotMultiplier = GetHeadshotDamageMultiplierFromDamageInfo(damageInfo)
	float basedamage = DamageInfo_GetDamage(damageInfo)/headshotMultiplier
	if(IsValidHeadShot( damageInfo, dummy )) DamageInfo_SetDamage( damageInfo, basedamage*(GetCurrentPlaylistVarFloat( "helmet_lv4", 0.65 )+(1-GetCurrentPlaylistVarFloat( "helmet_lv4", 0.65 ))*headshotMultiplier))
	
	entity player = DamageInfo_GetAttacker(damageInfo)
	float damage = DamageInfo_GetDamage( damageInfo )
	
	if (!IsValid(player)) return
	//add the damage
	player.p.straferChallengeDamage += int(damage)
	Remote_CallFunction_NonReplay(player, "ServerCallback_LiveStatsUIDamageViaDummieDamaged", int(damage))
	Remote_CallFunction_NonReplay(player, "ServerCallback_LiveStatsUIAccuracyViaShotsHits")
	//was critical?
	bool isValidHeadShot = IsValidHeadShot( damageInfo, dummy )
	if(isValidHeadShot) 
	{
		player.p.straferCriticalShots++
		Remote_CallFunction_NonReplay(player, "ServerCallback_LiveStatsUIHeadshot", player.p.straferCriticalShots)
	}
	
	if (!dummy.IsOnGround()) player.p.straferShotsHit++
	// else player.p.straferShotsHit = 1 //revisit this
	
	if(player.p.straferShotsHit > player.p.straferShotsHitRecord) 
	{
		player.p.straferShotsHitRecord = player.p.straferShotsHit
		player.p.isNewBestScore = true
	}
	//Infinite ammo
	if(AimTrainer_INFINITE_AMMO) player.RefillAllAmmo()
	
	//Inmortal target
	//if(AimTrainer_INMORTAL_TARGETS) //they should be always inmortal
		dummy.SetHealth(dummy.GetMaxHealth())

	// Move target in a random direction
	int side = 1
	if(CoinFlip()) side = -1
	
	vector org1 = player.GetOrigin()
	vector org2 = dummy.GetOrigin()
	vector vec2 = org1 - org2
	vector angles2 = VectorToAngles( vec2 )

	int random2 = RandomIntRangeInclusive(1,5)
	if(random2 == 1 || random2 == 2 || random2 == 3)
		dummy.SetVelocity((AnglesToRight(angles2 ) * RandomFloatRange(128,425) * side ) + <0, 0, RandomFloatRange(250,425) + DamageInfo_GetDamage(damageInfo) * 3>)
	else
		dummy.SetVelocity((AnglesToForward(angles2) * RandomFloatRange(128,256)) + <0, 0, RandomFloatRange(250,425) + DamageInfo_GetDamage(damageInfo) * 3>)

	// dummy.SetAngles(angles2)
}

//Callbacks functions
void function OnTilePropDamaged( entity dummy, var damageInfo )
{
	entity ent = dummy

	entity attacker = DamageInfo_GetAttacker(damageInfo)
	float damage = DamageInfo_GetDamage( damageInfo )

	EmitSoundOnEntityOnlyToPlayer( attacker, attacker, FIRINGRANGE_FLICK_TARGET_SOUND )

	if(!attacker.IsPlayer() ) return
		
	//add the damage
	attacker.p.straferChallengeDamage += int(damage)
	Remote_CallFunction_NonReplay(attacker, "ServerCallback_LiveStatsUIDamageViaDummieDamaged", int(damage))
	Remote_CallFunction_NonReplay(attacker, "ServerCallback_LiveStatsUIAccuracyViaShotsHits")
	
	//infinite ammo
	if(AimTrainer_INFINITE_AMMO) attacker.RefillAllAmmo()

	//add 1 hit
	attacker.p.straferShotsHit++
	if(attacker.p.straferShotsHit > attacker.p.straferShotsHitRecord) 
	{
		attacker.p.straferShotsHitRecord = attacker.p.straferShotsHit
		attacker.p.isNewBestScore = true
	}
	
	attacker.p.straferDummyKilledCount++
	Remote_CallFunction_NonReplay(attacker, "ServerCallback_LiveStatsUIDummiesKilled", attacker.p.straferDummyKilledCount)
	ChallengesEntities.dummies.removebyvalue(ent)

	ent.Destroy()
	ChallengesEntities.props.removebyvalue(ent)
}

void function OnDummyKilled(entity ent, var damageInfo)
{
	entity attacker = DamageInfo_GetAttacker(damageInfo)
	if(!attacker.IsPlayer() ) return
	if(AimTrainer_INFINITE_AMMO2) attacker.RefillAllAmmo()
	if ( IsValidHeadShot( damageInfo, ent )) return
	if(ent.GetTargetName() == "BubbleFightDummy") 
	{
		entity player = attacker
		if(player.GetHealth() < player.GetMaxHealth() && IsValid(player))
			player.SetHealth(min(player.GetHealth() + 10, player.GetMaxHealth()))
		else if(player.GetShieldHealth() < player.GetShieldHealthMax() && player.GetHealth() == player.GetMaxHealth() && IsValid(player))
			player.SetShieldHealth(min(player.GetShieldHealthMax(),player.GetShieldHealth()+10))
		
	}
	attacker.p.straferDummyKilledCount++
	Remote_CallFunction_NonReplay(attacker, "ServerCallback_LiveStatsUIDummiesKilled", attacker.p.straferDummyKilledCount)
	ChallengesEntities.dummies.removebyvalue(ent)
}

void function OnWeaponAttackChallenges( entity player, entity weapon, string weaponName, int ammoUsed, vector attackOrigin, vector attackDir )
{
	if(weapon.GetWeaponClassName() == "mp_weapon_clickweapon") return
	if(!player.p.isChallengeActivated) return
	int basedamage = weapon.GetWeaponSettingInt( eWeaponVar.damage_near_value )
	int ornull projectilespershot = weapon.GetWeaponSettingInt( eWeaponVar.projectiles_per_shot )
	int pellets = 1
	if(projectilespershot != null)
	{
		pellets = expect int(projectilespershot)
		player.p.totalPossibleDamage += (basedamage * pellets)
	}
	else 
		player.p.totalPossibleDamage += basedamage
	
	//add 1 hit to total hits
	player.p.straferTotalShots += (1*pellets)
	
	Remote_CallFunction_NonReplay(player, "ServerCallback_LiveStatsUIDamageViaWeaponAttack", basedamage, basedamage * pellets)
	Remote_CallFunction_NonReplay(player, "ServerCallback_LiveStatsUIAccuracyViaTotalShots", pellets)
}

void function Arcstar_OnStick( entity ent, var damageInfo )
{
	thread Arcstar_OnStick2(ent, damageInfo)
}
void function Arcstar_OnStick2( entity ent, var damageInfo )
{
	entity player = DamageInfo_GetAttacker( damageInfo )
	if(!IsValid(player)) return
	printt("Stick! +1 point.")
	EmitSoundOnEntity(player, "UI_PostGame_TitanPointIncrease")
	ChallengesEntities.dummies.removebyvalue(ent)
	WaitFrame()
	if(IsValid(ent)) ent.Destroy()
}
//UTILITY
void function OnPlayerDeathCallback(entity player, var damageInfo)
{
thread OnPlayerDeathCallbackThread(player)
}

void function OnPlayerDeathCallbackThread(entity player)
{
	entity weapon = player.GetNormalWeapon(WEAPON_INVENTORY_SLOT_PRIMARY_0)
	array<string> mods
	string weaponname
	if( IsValid( weapon ) )
	{
		mods = weapon.GetMods()
		weaponname = weapon.GetWeaponClassName()
	} else {
		weaponname = "mp_weapon_wingman"
	}

	wait 1

	Signal(player, "ChallengeTimeOver")
	vector lastPos = player.GetOrigin()
	vector lastAng = player.GetAngles()
	player.SetOrigin(lastPos)
	player.SetAngles(lastAng)
	DecideRespawnPlayer( player )
	TakeAllWeapons(player)
    player.GiveWeapon( "mp_weapon_bolo_sword_primary", WEAPON_INVENTORY_SLOT_PRIMARY_2, [] )
    player.GiveOffhandWeapon( "melee_bolo_sword", OFFHAND_MELEE, [] )
	player.GiveWeapon( weaponname, WEAPON_INVENTORY_SLOT_PRIMARY_0, mods )
	player.SetActiveWeaponBySlot(eActiveInventorySlot.mainHand, WEAPON_INVENTORY_SLOT_PRIMARY_0)
}

int function ReturnShieldAmountForDesiredLevel()
{
	switch(AimTrainer_AI_SHIELDS_LEVEL){
		case 0:
			return 0
		case 1:
			return 50
		case 2:
			return 75
		case 3:
			return 100
		case 4:
			return 125
	}
	unreachable
}

array<entity> function CreateFloorAtOrigin(vector origin, int width, int length)
//By michae\l/#1125 incredibly optimized. i am speed
{
	int x = int(origin.x)
	int y = int(origin.y)
	int z = int(origin.z)
	int i
	int j
	array<entity> arr
	for(i = y; i <= y + (length * 256); i += 256)
	{
		for(j = x; j <= x + (width * 256); j += 256)
		{
			arr.append( CreateFRProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <j, i, z>, <0,0,0>) )
		}
    }
	return arr
}

array<entity> function CreateWallAtOrigin(vector origin, int length, int height, int angle)
//By michae\l/#1125 incredibly optimized. i am speed
{
	int x = int(origin.x)
	int y = int(origin.y)
	int z = int(origin.z)
    int i;
    int j;
	array<entity> arr
    // angle MUST be 0 or 90
    // assert(angle == 90 | angle == 0)

    int start = (angle == 90) ? y : x
    int end = start + (length * 256)
    for(i = start; i <= end; i += 256)
    {
        for(j = z; j <= z + (height * 256); j += 256)
        {
            if(angle == 90) arr.append(CreateFRProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <x, i, j>, <0,90,0>))
            else if (angle == 0) arr.append(CreateFRProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <i, y, j>, <0,0,0>))
        }
	}
	return arr
}

void function ClippingAIWorkaround(entity dummy)
{
	dummy.EndSignal("OnDeath")
	
	while(IsValid(dummy))
	{
		vector traceStart = dummy.EyePosition()
		vector traceDir   = dummy.GetForwardVector()
		vector traceEnd   = traceStart + (traceDir * 50000)
		TraceResults results = TraceLine( traceStart, traceEnd, dummy )
		
		if(Distance(dummy.GetOrigin(), results.endPos) <= 150)
			dummy.SetAngles(Vector(dummy.GetAngles().x, dummy.GetAngles().y*-1, dummy.GetAngles().z) )
		
		WaitFrame()
	}	
}

//CLIENT COMMANDS
void function PreChallengeStart(entity player, int challenge)
{
	player.p.storedWeapons = StoreWeapons(player)
	AddCinematicFlag( player, CE_FLAG_HIDE_MAIN_HUD_INSTANT )
	AddCinematicFlag( player, CE_FLAG_HIDE_PERMANENT_HUD)
	player.p.challengeName = challenge

	player.p.isChallengeActivated = true
	Remote_CallFunction_NonReplay(player, "ServerCallback_SetChallengeActivated", true)
	DeployAndEnableWeapons(player)
	entity weapon = player.GetNormalWeapon( WEAPON_INVENTORY_SLOT_PRIMARY_0 )
    if(weapon.IsInCustomActivity())
		weapon.StopCustomActivity()
}

bool function CC_StartChallenge1( entity player, array<string> args )
{
	PreChallengeStart(player, 1)
	thread StartStraferDummyChallenge(player)
	return false
}

bool function CC_StartChallenge2( entity player, array<string> args )
{
	PreChallengeStart(player, 2)
	thread StartSwapFocusDummyChallenge(player)
	return false
}

bool function CC_StartChallenge3( entity player, array<string> args )
{
	PreChallengeStart(player, 3)
	thread StartFloatingTargetChallenge(player)
	return false
}

bool function CC_StartChallenge4( entity player, array<string> args )
{
	PreChallengeStart(player, 4)
	thread StartPopcornChallenge(player)
	return false
}

bool function CC_StartChallenge5( entity player, array<string> args )
{
	PreChallengeStart(player, 10)
	thread StartTileFrenzyChallenge(player)
	return false
}

bool function CC_StartChallenge6( entity player, array<string> args )
{
	PreChallengeStart(player, 11)
	thread StartCloseFastStrafesChallenge(player)
	return false
}

bool function CC_StartChallenge7( entity player, array<string> args )
{
	PreChallengeStart(player, 12)
	thread StartSmoothbotChallenge(player)
	return false
}

bool function CC_StartChallenge8( entity player, array<string> args )
{
	PreChallengeStart(player, 13)
	// thread StartTapyDuckStrafesChallenge(player)
	return false
}
bool function CC_StartChallenge1NewC( entity player, array<string> args )
{
	PreChallengeStart(player, 6)
	thread StartTapyDuckStrafesChallenge(player)
	return false
}

bool function CC_StartChallenge2NewC( entity player, array<string> args )
{
	PreChallengeStart(player, 7)
	thread StartArcstarsChallenge(player)
	return false
}

bool function CC_StartChallenge3NewC( entity player, array<string> args )
{
	PreChallengeStart(player, 14)
	thread StartVerticalGrenadesChallenge(player)
	return false
}

bool function CC_StartChallenge4NewC( entity player, array<string> args )
{
	PreChallengeStart(player, 9)
	thread StartStraightUpChallenge(player)
	return false
}

bool function CC_StartChallenge5NewC( entity player, array<string> args )
{
	PreChallengeStart(player, 8)
	thread StartLiftUpChallenge(player)
	return false
}

bool function CC_StartChallenge6NewC( entity player, array<string> args )
{
	PreChallengeStart(player, 15)
	thread StartSkyDiveChallenge(player)
	return false
}

bool function CC_StartChallenge7NewC( entity player, array<string> args )
{
	PreChallengeStart(player, 16)
	thread StartRunningTargetsChallenge(player)
	return false
}

bool function CC_StartChallenge8NewC( entity player, array<string> args )
{
	PreChallengeStart(player, 17)
	// thread StartTapyDuckStrafesChallenge(player)
	return false
}

bool function CC_ChallengesSkipButton( entity player, array<string> args )
{
	Signal(player, "ForceResultsEnd_SkipButton")
	return false
}

bool function CC_ChangeChallengeDuration( entity player, array<string> args )
{
	if(args.len() == 0 ) return false

	int desiredTime = int(args[0])
	AimTrainer_CHALLENGE_DURATION = desiredTime
	return false
}

bool function CC_AimTrainer_AI_SHIELDS_LEVEL( entity player, array<string> args )
{
	int desiredShieldLevel = int(args[0])
	AimTrainer_AI_SHIELDS_LEVEL = desiredShieldLevel
	return false
}

bool function CC_AimTrainer_STRAFING_SPEED( entity player, array<string> args )
{
	float desiredSpeed = float(args[0])
	AimTrainer_STRAFING_SPEED = desiredSpeed
	return false
}

bool function CC_AimTrainer_SPAWN_DISTANCE( entity player, array<string> args )
{
	float desiredDistance = float(args[0])
	AimTrainer_SPAWN_DISTANCE = desiredDistance
	return false
}

bool function CC_AimTrainer_AI_HEALTH( entity player, array<string> args )
{
	int desiredHealth = int(args[0])
	AimTrainer_AI_HEALTH = desiredHealth
	return false
}

bool function CC_RGB_HUD( entity player, array<string> args )
{
	if(args[0] == "0")
		RGB_HUD = false
	else if(args[0] == "1")
		RGB_HUD = true
	
	return false
}

bool function CC_AimTrainer_INFINITE_CHALLENGE( entity player, array<string> args )
{
	if(args[0] == "0")
		AimTrainer_INFINITE_CHALLENGE = false
	else if(args[0] == "1")
		AimTrainer_INFINITE_CHALLENGE = true

	return false
}

bool function CC_AimTrainer_INFINITE_AMMO( entity player, array<string> args )
{
	if(args[0] == "0")
		AimTrainer_INFINITE_AMMO = false
	else if(args[0] == "1")
		AimTrainer_INFINITE_AMMO = true

	return false
}

bool function CC_AimTrainer_INFINITE_AMMO2( entity player, array<string> args )
{
	if(args[0] == "0")
		AimTrainer_INFINITE_AMMO2 = false
	else if(args[0] == "1")
		AimTrainer_INFINITE_AMMO2 = true

	return false
}

bool function CC_AimTrainer_INMORTAL_TARGETS( entity player, array<string> args )
{
	if(args[0] == "0")
		AimTrainer_INMORTAL_TARGETS = false
	else if(args[0] == "1")
		AimTrainer_INMORTAL_TARGETS = true

	return false
}

bool function CC_AimTrainer_USER_WANNA_BE_A_DUMMY( entity player, array<string> args )
{
	if(args[0] == "2")
	{
		AimTrainer_USER_WANNA_BE_A_DUMMY = false
		player.SetBodyModelOverride( $"" )
		player.SetArmsModelOverride( $"" )
	}
	else if(args[0] == "3")
	{
		AimTrainer_USER_WANNA_BE_A_DUMMY = true
		player.SetBodyModelOverride( $"mdl/humans/class/medium/pilot_medium_generic.rmdl" )
		player.SetArmsModelOverride( $"mdl/humans/class/medium/pilot_medium_generic.rmdl" )
		player.SetSkin(RandomIntRange(1,5))
	}
	return false
}

bool function CC_AimTrainer_DUMMIES_COLOR( entity player, array<string> args )
{
	int desiredColor = int(args[0])
	AimTrainer_AI_COLOR = desiredColor
	return false
}

bool function CC_MenuGiveAimTrainerWeapon( entity player, array<string> args )
{
	if(!IsValid(player)) return false
	
	string weapon = args[0]
    entity primary = player.GetNormalWeapon( WEAPON_INVENTORY_SLOT_PRIMARY_0 )
    
	if (IsValid(primary))
		player.TakeWeaponByEntNow( primary )
	
	entity weaponent
	bool shouldPutLaser = false
	if (args.len() > 1) //from attachments buy box
		{
			printt("DEBUG: " + args[1], args[2], args[3], args[4], args[5], args[6])
			array<string> finalargs

			switch(args[5])
			{
				case "smg":
			
					if(args[1] != "none") finalargs.append(args[1])
					if(args[2] != "none") 
					{
						finalargs.append(args[2])						
						if(args[2] == "barrel_stabilizer_l1" || args[2] == "barrel_stabilizer_l2" || args[2] == "barrel_stabilizer_l3" )
							shouldPutLaser = true
					}
					if(args[3] != "none") finalargs.append(args[3])
					if(args[6] != "none") finalargs.append(args[6])	
						
					weaponent = player.GiveWeapon( weapon, WEAPON_INVENTORY_SLOT_PRIMARY_0, finalargs)
				
					if(shouldPutLaser)
						Remote_CallFunction_NonReplay(player, "ServerCallback_SetLaserSightsOnSMGWeapon", weaponent)
					else
						Remote_CallFunction_NonReplay(player, "ServerCallback_StopLaserSightsOnSMGWeapon", weaponent)
					
					break
				case "pistol":
					if(args[1] != "none") finalargs.append(args[1])
					if(args[2] != "none") 
					{
						finalargs.append(args[2])						
						if(weapon == "mp_weapon_autopistol")
							shouldPutLaser = true
					}
					if(args[6] != "none") finalargs.append(args[6])
						
					weaponent = player.GiveWeapon( weapon, WEAPON_INVENTORY_SLOT_PRIMARY_0, finalargs)
					
					if(shouldPutLaser)
						Remote_CallFunction_NonReplay(player, "ServerCallback_SetLaserSightsOnSMGWeapon", weaponent)
					else
						Remote_CallFunction_NonReplay(player, "ServerCallback_StopLaserSightsOnSMGWeapon", weaponent)
					
					break
				case "pistol2":
					if(args[1] != "none") finalargs.append(args[1])
					if(args[6] != "none") finalargs.append(args[6])
					weaponent = player.GiveWeapon( weapon, WEAPON_INVENTORY_SLOT_PRIMARY_0, finalargs)
					break
				case "shotgun":
					if(args[1] != "none") finalargs.append(args[1])
					if(args[4] != "none") finalargs.append(args[4])
					weaponent = player.GiveWeapon( weapon, WEAPON_INVENTORY_SLOT_PRIMARY_0, finalargs)
					break
				case "lmg2":
				case "ar":
					if(args[1] != "none") finalargs.append(args[1])
					if(args[2] != "none") finalargs.append(args[2])
					if(args[3] != "none") finalargs.append(args[3])
					if(args[4] != "." && weapon == "mp_weapon_esaw") finalargs.append(args[4])
					if(args[6] != "none") finalargs.append(args[6])
						
					weaponent = player.GiveWeapon( weapon, WEAPON_INVENTORY_SLOT_PRIMARY_0, finalargs)
					break
				case "ar2":
					if(args[1] != "none") finalargs.append(args[1])
					if(args[3] != "none") finalargs.append(args[3])
					if(args[4] != "." && weapon == "mp_weapon_energy_ar") finalargs.append(args[4])
					if(args[6] != "none") finalargs.append(args[6])
					
					weaponent = player.GiveWeapon( weapon, WEAPON_INVENTORY_SLOT_PRIMARY_0, finalargs)					
					break
				case "marksman":
					if(args[1] != "none") finalargs.append(args[1])
					if(args[2] != "none") finalargs.append(args[2])
					if(args[3] != "none") finalargs.append(args[3])
					if(args[4] != "." ) finalargs.append(args[4])
					if(args[6] != "none") finalargs.append(args[6])
					
					weaponent = player.GiveWeapon( weapon, WEAPON_INVENTORY_SLOT_PRIMARY_0, finalargs)
					break
				case "marksman2":
					if(args[1] != "none") finalargs.append(args[1])
					if(args[3] != "none") finalargs.append(args[3])
					if(args[4] != "." ) finalargs.append(args[4])
					if(args[6] != "none") finalargs.append(args[6])
						
					weaponent = player.GiveWeapon( weapon, WEAPON_INVENTORY_SLOT_PRIMARY_0, finalargs)
					break
				case "marksman3":
					if(args[1] != "none") finalargs.append(args[1])
					if(args[3] != "none") finalargs.append(args[3])
					if(args[6] != "none") finalargs.append(args[6])	
					
					weaponent = player.GiveWeapon( weapon, WEAPON_INVENTORY_SLOT_PRIMARY_0, finalargs)
					break
				case "sniper":
					if(args[1] != "none") finalargs.append(args[1])
					if(args[2] != "none") finalargs.append(args[2])
					if(args[3] != "none") finalargs.append(args[3])
					if(args[6] != "none") finalargs.append(args[6])
						
					weaponent = player.GiveWeapon( weapon, WEAPON_INVENTORY_SLOT_PRIMARY_0, finalargs)
					break
				case "sniper2":
					if(args[1] != "none") finalargs.append(args[1])
					if(args[3] != "none") finalargs.append(args[3])
					
					weaponent = player.GiveWeapon( weapon, WEAPON_INVENTORY_SLOT_PRIMARY_0, finalargs)
					break
				case "sniper3":
					weaponent = player.GiveWeapon( weapon, WEAPON_INVENTORY_SLOT_PRIMARY_0 )
					break
			}
		}
	else
	{
		weaponent = player.GiveWeapon( weapon, WEAPON_INVENTORY_SLOT_PRIMARY_0 )
		Remote_CallFunction_NonReplay(player, "ServerCallback_StopLaserSightsOnSMGWeapon", weaponent)
	}
	if ( weapon == "mp_weapon_clickweapon" || weapon == "mp_weapon_clickweaponauto" )
		Remote_CallFunction_NonReplay(player, "ServerCallback_ToggleDotForHitscanWeapons", true)
	else
		Remote_CallFunction_NonReplay(player, "ServerCallback_ToggleDotForHitscanWeapons", false)
	
	if(!IsValid(weaponent)) return false
	
	thread PlayAnimsOnGiveWeapon(weaponent, player)
	
	if(!GetCurrentPlaylistVarBool( "aimtrainer_enableSkins", false )) return false

	if(weaponent.GetWeaponClassName() == "mp_weapon_car")
		weaponent.SetSkin( weaponent.GetSkinIndexByName( "charm_preview_black" ) )
	else if(weaponent.GetWeaponClassName() == "mp_weapon_wingman")
	{
		weaponent.SetLegendaryModelIndex(2)
		weaponent.SetSkin(RandomInt(weaponent.GetSkinCount()))
	}
	else if(weaponent.GetWeaponClassName() == "mp_weapon_r97")
	{
		weaponent.SetLegendaryModelIndex(2)
		weaponent.SetSkin(RandomInt(weaponent.GetSkinCount()))
	}
	// else
	// {
		// if(CoinFlip())
			// weaponent.SetLegendaryModelIndex(RandomInt(4))
		// weaponent.SetSkin(RandomInt(weaponent.GetSkinCount()))
	// }
	// printt("Skin codename: " + weaponent.GetSkinNameByIndex(weaponent.GetSkin()))
	
	return false
}

void function PlayAnimsOnGiveWeapon(entity weaponent, entity player)
{
	if (IsValid(weaponent) && weaponent.Anim_HasActivity( "ACT_VM_RELOADEMPTY" ) )
	{
		float duration = weaponent.GetSequenceDuration( "ACT_VM_RELOADEMPTY" )
		weaponent.StartCustomActivity("ACT_VM_RELOADEMPTY", 0)
		wait duration			
	}
	if(IsValid(weaponent) && weaponent.Anim_HasActivity( "ACT_VM_WEAPON_INSPECT" ) && !player.p.isChallengeActivated )
		weaponent.StartCustomActivity("ACT_VM_WEAPON_INSPECT", 0)
}

bool function CC_Weapon_Selector_Open( entity player, array<string> args )
{
	DeployAndEnableWeapons(player)
	player.SetActiveWeaponBySlot(eActiveInventorySlot.mainHand, WEAPON_INVENTORY_SLOT_PRIMARY_0)
	return false
}
bool function CC_Weapon_Selector_Close( entity player, array<string> args )
{
	entity weapon = player.GetNormalWeapon( WEAPON_INVENTORY_SLOT_PRIMARY_0 )
    if(weapon.IsInCustomActivity())
		weapon.StopCustomActivity()
	HolsterAndDisableWeapons(player)
	return false
}

bool function CC_ExitChallenge( entity player, array<string> args )
{
	Signal(player, "ChallengeTimeOver")
	return false
}

bool function CC_RestartChallenge( entity player, array<string> args )
{
	player.p.isRestartingLevel = true
	OnChallengeEnd(player)
	return false
}
