//Flowstate Aim Trainer my beloved
//Credits: 
//CaféDeColombiaFPS (Retículo Endoplasmático#5955 - @CafeFPS) -- dev
//Zee#6969 -- gave me weapons menu example
//Skeptation#4002 -- main advices and relevant feedback

global function  _ChallengesByColombia_Init
global function StartFRChallenges

const vector floorLocation = <35306.2344, -16956.5098, -27010.2539>
const vector floorCenterForPlayer = <floorLocation.x+3840, floorLocation.y+3840, floorLocation.z+200>
const vector floorCenterForButton = <floorLocation.x+3840+200, floorLocation.y+3840, floorLocation.z+18>
const vector shipLocationPos = <41334.5469, -21997.4844, -26820.8828>
const vector shipLocationAngs = <0, -3.29812288, 0>
const vector onGroundLocationPos = <33946,-6511,-28859>
const vector onGroundLocationAngs = <0,-90,0>

void function _ChallengesByColombia_Init()
{
	//so we can calculate stats
	AddCallback_OnWeaponAttack( OnWeaponAttackChallenges )
	
	//skip button callback
	AddClientCommandCallback("ChallengesSkipButton", CC_ChallengesSkipButton)
	
	//UI buttons callbacks
	//first column
	AddClientCommandCallback("CC_StartChallenge1", CC_StartChallenge1)
	AddClientCommandCallback("CC_StartChallenge2", CC_StartChallenge2)
	AddClientCommandCallback("CC_StartChallenge3", CC_StartChallenge3)
	AddClientCommandCallback("CC_StartChallenge4", CC_StartChallenge4)
	AddClientCommandCallback("CC_StartChallenge5", CC_StartChallenge5)
	AddClientCommandCallback("CC_StartChallenge6", CC_StartChallenge6)
	//second column
	AddClientCommandCallback("CC_StartChallenge1NewC", CC_StartChallenge1NewC)
	AddClientCommandCallback("CC_StartChallenge2NewC", CC_StartChallenge2NewC)
	AddClientCommandCallback("CC_StartChallenge3NewC", CC_StartChallenge3NewC)
	AddClientCommandCallback("CC_StartChallenge4NewC", CC_StartChallenge4NewC)
	AddClientCommandCallback("CC_StartChallenge5NewC", CC_StartChallenge5NewC)
	AddClientCommandCallback("CC_StartChallenge6NewC", CC_StartChallenge6NewC)
	
	//settings buttons
	AddClientCommandCallback("CC_Weapon_Selector_Open", CC_Weapon_Selector_Open)
	AddClientCommandCallback("CC_Weapon_Selector_Close", CC_Weapon_Selector_Close)
	AddClientCommandCallback("CC_ChangeChallengeDuration", CC_ChangeChallengeDuration)
	AddClientCommandCallback("CC_AimTrainer_AI_SHIELDS_LEVEL", CC_AimTrainer_AI_SHIELDS_LEVEL)
	AddClientCommandCallback("CC_RGB_HUD", CC_RGB_HUD)
	AddClientCommandCallback("CC_AimTrainer_INFINITE_CHALLENGE", CC_AimTrainer_INFINITE_CHALLENGE)
	AddClientCommandCallback("CC_AimTrainer_INFINITE_AMMO", CC_AimTrainer_INFINITE_AMMO)
	AddClientCommandCallback("CC_AimTrainer_INMORTAL_TARGETS", CC_AimTrainer_INMORTAL_TARGETS)
	AddClientCommandCallback("CC_AimTrainer_USER_WANNA_BE_A_DUMMY", CC_AimTrainer_USER_WANNA_BE_A_DUMMY)
	AddClientCommandCallback("CC_MenuGiveAimTrainerWeapon", CC_MenuGiveAimTrainerWeapon) 
	AddClientCommandCallback("CC_ExitChallenge", CC_ExitChallenge) 
	
	AddDamageCallbackSourceID( eDamageSourceId.damagedef_ticky_arc_blast, Arcstar_OnStick )
	AddDamageCallbackSourceID( eDamageSourceId.mp_weapon_grenade_emp, Arcstar_OnStick )
	PrecacheParticleSystem($"P_enemy_jump_jet_ON_trails")
	PrecacheModel($"mdl/imc_interior/imc_int_fusebox_01.rmdl")
}

struct{
	array<entity> floor
	array<entity> dummies
	array<entity> props
} ChallengesStruct

void function StartFRChallenges(entity player)
{
	if(!IsValid(player)) return

	Remote_CallFunction_NonReplay(player, "ServerCallback_SetDefaultMenuSettings")
	Survival_SetInventoryEnabled( player, false )
	
	player.FreezeControlsOnServer()
	TakeAllWeapons(player)
    player.GiveWeapon( "mp_weapon_melee_survival", WEAPON_INVENTORY_SLOT_PRIMARY_2, [] )
    player.GiveOffhandWeapon( "melee_data_knife", OFFHAND_MELEE, [] )
	
	player.GiveWeapon( "mp_weapon_wingman", WEAPON_INVENTORY_SLOT_PRIMARY_0, ["optic_cq_hcog_classic"] )
	player.SetActiveWeaponBySlot(eActiveInventorySlot.mainHand, WEAPON_INVENTORY_SLOT_PRIMARY_0)
	
	player.SetOrigin(AimTrainer_startPos)
	player.SetAngles(AimTrainer_startAngs)
	HolsterAndDisableWeapons(player)
	Remote_CallFunction_NonReplay(player, "ServerCallback_CoolCameraOnMenu")
	Remote_CallFunction_NonReplay(player, "ServerCallback_OpenFRChallengesMainMenu", 0)	
}

entity function CreateCancelChallengeButton()
{
	entity strafe = CreateFRButton(Vector(33816.3633, -6702.79883, -28886.3398), Vector(0,90,0), "Press %use% to exit challenge")
	AddCallback_OnUseEntity( strafe, void function(entity panel, entity user, int input) 
		{
			if(!user.IsPlayer()) return
			
			Signal(user, "ChallengeTimeOver")
			panel.SetSkin(1)
		})
	return strafe
}

void function ResetChallengeStats(entity player)
{
	if(!player.IsPlayer()) return
	
	ChallengesStruct.dummies = []
	ChallengesStruct.floor = []
	ChallengesStruct.props = []
	
	player.p.storedWeapons.clear()
	player.p.challengeName = 0
	player.p.straferDummyKilledCount = 0
	player.p.straferAccuracy = 0
	player.p.straferShotsHit = 0
	player.p.straferTotalShots = 0
	player.p.straferChallengeDamage = 0
	player.p.straferCriticalShots = 0
	player.p.isChallengeActivated = false
	player.p.isNewBestScore = false
}

//CHALLENGE "Strafing dummies"
void function StartStraferDummyChallenge(entity player)
{
	if(!IsValid(player)) return
	
	player.SetOrigin(onGroundLocationPos)
	player.SetAngles(onGroundLocationAngs)
	wait AimTrainer_PRE_START_TIME
	RemoveCinematicFlag( player, CE_FLAG_HIDE_MAIN_HUD_INSTANT )
	RemoveCinematicFlag( player, CE_FLAG_HIDE_PERMANENT_HUD)
	player.UnfreezeControlsOnServer()
	EndSignal(player, "ChallengeTimeOver")
	
	float endtime = Time() + AimTrainer_CHALLENGE_DURATION
	
	entity restart = CreateCancelChallengeButton()
	OnThreadEnd(
		function() : ( player, restart )
		{
			OnChallengeEnd(player, restart)
		}
	)
	
	thread ChallengeWatcherThread(endtime, player)

	while(true){
		if(!AimTrainer_INFINITE_CHALLENGE) 
			if(Time() > endtime) break
		entity dummy = CreateDummy( 99, Vector(33948, -6949, -28859), <0,90,0> )
		vector pos = dummy.GetOrigin()
		vector angles = dummy.GetAngles()
		StartParticleEffectInWorld( GetParticleSystemIndex( FIRINGRANGE_ITEM_RESPAWN_PARTICLE ), pos, angles )
		SetSpawnOption_AISettings( dummy, "npc_dummie_combat" )
		DispatchSpawn( dummy )	
		dummy.SetShieldHealthMax( ReturnShieldAmountForDesiredLevel() )
		dummy.SetShieldHealth( ReturnShieldAmountForDesiredLevel() )
		dummy.SetMaxHealth( 100 )
		dummy.SetHealth( 100 )
		dummy.SetTakeDamageType( DAMAGE_YES )
		dummy.SetDamageNotifications( true )
		dummy.SetDeathNotifications( true )
		dummy.SetValidHealthBarTarget( true )
		SetObjectCanBeMeleed( dummy, true )
		dummy.SetSkin(RandomIntRange(1,5))
		dummy.DisableHibernation()
		// SetTargetName(dummy, "straferDummy")
		
		AddEntityCallback_OnDamaged(dummy, OnStraferDummyDamaged)
		AddEntityCallback_OnKilled(dummy, OnDummyKilled)
		
		waitthread StrafeFunct(dummy, player)
		wait 0.5
	}
}

void function StrafeFunct(entity ai, entity player)
{
	ai.EndSignal("OnDeath")
	player.EndSignal("ChallengeTimeOver")
	
	OnThreadEnd(
		function() : ( ai )
		{
			if(IsValid(ai)) ai.Destroy()
			ChallengesStruct.dummies.removebyvalue(dummy)
		}
	)

	//ai.UseSequenceBounds( true )
	while(IsValid(ai))
	{
		int random = RandomIntRangeInclusive(1,9)
		if(random == 1 || random == 2 || random == 3 || random == 4){
		//a d strafe
			ai.Anim_ScriptedPlayActivityByName( "ACT_RUN_RIGHT", true, 0.1 ) //Ok this looks easy, but have you seen Activity modifiers being used this way in the code before? ;)
			wait RandomFloatRange(0.025,0.5)
			ai.Anim_ScriptedPlayActivityByName( "ACT_RUN_LEFT", true, 0.1 )
			wait RandomFloatRange(0.025,0.5)
		}
		else if(random == 5|| random == 6|| random == 7|| random == 8){
		//a d strafe
			ai.Anim_ScriptedPlayActivityByName( "ACT_SPRINT_RIGHT", true, 0.1 )
			wait RandomFloatRange(0.025,0.5)
			ai.Anim_ScriptedPlayActivityByName( "ACT_SPRINT_LEFT", true, 0.1 )
			wait RandomFloatRange(0.025,0.5)
		}
		else if (random == 9){
		//a d strafe
			ai.Anim_ScriptedPlayActivityByName( "ACT_STRAFE_TO_CROUCH_LEFT", true, 0.1 )
			wait RandomFloatRange(0.05,0.2)
			ai.Anim_ScriptedPlayActivityByName( "ACT_STRAFE_TO_CROUCH_RIGHT", true, 0.1 )
			wait RandomFloatRange(0.05,0.2)
		}

		// else if (random == 10){
		// //circle strafe?
			// ai.Anim_ScriptedPlayActivityByName( "ACT_RUN_RIGHT", true, 0.1 )
			// wait 0.1
			// ai.Anim_ScriptedPlayActivityByName( "ACT_RUN_BACKWARD", true, 0.1 )
			// wait 0.1
			// ai.Anim_ScriptedPlayActivityByName( "ACT_RUN_LEFT", true, 0.1 )
			// wait 0.1
			// ai.Anim_ScriptedPlayActivityByName( "ACT_RUN_FORWARD", true, 0.1 )
			// wait 0.1		
		// }
	}
}

//CHALLENGE "Switching targets"
void function StartSwapFocusDummyChallenge(entity player)
{
	if(!IsValid(player)) return
	
	player.SetOrigin(Vector(33946,-6511,-28859))
	player.SetAngles(Vector(0,-90,0))
	wait AimTrainer_PRE_START_TIME
	RemoveCinematicFlag( player, CE_FLAG_HIDE_MAIN_HUD_INSTANT )
	RemoveCinematicFlag( player, CE_FLAG_HIDE_PERMANENT_HUD)
	player.UnfreezeControlsOnServer()
	EndSignal(player, "ChallengeTimeOver")
	
	float endtime = Time() + AimTrainer_CHALLENGE_DURATION
	
	entity restart = CreateCancelChallengeButton()
	OnThreadEnd(
		function() : ( player, restart )
		{
			OnChallengeEnd(player, restart)
		}
	)
	
	thread ChallengeWatcherThread(endtime, player)

	while(true){
		if(!AimTrainer_INFINITE_CHALLENGE) 
			if(Time() > endtime) break		
		while(ChallengesStruct.dummies.len()<3){
			entity dummy = CreateDummy( 99, Vector(33948 + RandomInt(512), -6949 + RandomInt(256), -28859), <0,90,0> )
			vector pos = dummy.GetOrigin()
			vector angles = dummy.GetAngles()
			StartParticleEffectInWorld( GetParticleSystemIndex( FIRINGRANGE_ITEM_RESPAWN_PARTICLE ), pos, angles )
			SetSpawnOption_AISettings( dummy, "npc_dummie_combat" )
			DispatchSpawn( dummy )	
			dummy.SetShieldHealthMax( ReturnShieldAmountForDesiredLevel() )
			dummy.SetShieldHealth( ReturnShieldAmountForDesiredLevel() )
			dummy.SetMaxHealth( 30 )
			dummy.SetHealth( 30 )
			dummy.SetTakeDamageType( DAMAGE_YES )
			dummy.SetDamageNotifications( true )
			dummy.SetDeathNotifications( true )
			dummy.SetValidHealthBarTarget( true )
			SetObjectCanBeMeleed( dummy, true )
			dummy.SetSkin(RandomIntRange(1,5))
			dummy.DisableHibernation()
			ChallengesStruct.dummies.append(dummy)
			
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
			ChallengesStruct.dummies.removebyvalue(ai)
		}
	)
	
	while(IsValid(ai)) //WaitSignal(ai, "OnDeath")
    {
        int random = RandomIntRangeInclusive(1,6)
        if(random == 1 || random == 2 || random == 3 || random == 4){
        //a d strafe
            ai.Anim_ScriptedPlayActivityByName( "ACT_RUN_RIGHT", true, 0.1 )
            wait RandomFloatRange(0.2,0.9)
            ai.Anim_ScriptedPlayActivityByName( "ACT_RUN_LEFT", true, 0.1 )
            wait RandomFloatRange(0.2,0.9)
        }
        else if(random == 5){
        //a d strafe
            ai.Anim_ScriptedPlayActivityByName( "ACT_SPRINT_RIGHT", true, 0.1 )
            wait RandomFloatRange(0.15,0.7)
            ai.Anim_ScriptedPlayActivityByName( "ACT_SPRINT_LEFT", true, 0.1 )
            wait RandomFloatRange(0.15,0.7)
        }
        else if (random == 6){
        //a d strafe
            ai.Anim_ScriptedPlayActivityByName( "ACT_STRAFE_TO_CROUCH_LEFT", true, 0.1 )
            wait RandomFloatRange(0.15,0.3)
            ai.Anim_ScriptedPlayActivityByName( "ACT_STRAFE_TO_CROUCH_RIGHT", true, 0.1 )
            wait RandomFloatRange(0.15,0.3)
        }
    }
}

//CHALLENGE "Floating target"
void function StartFloatingTargetChallenge(entity player)
{
	if(!IsValid(player)) return
	
	player.SetOrigin(floorCenterForPlayer)
	player.SetAngles(Vector(0,-90,0))
	ChallengesStruct.floor = CreateFloorAtOrigin(floorLocation, 30, 30)
	wait AimTrainer_PRE_START_TIME
	RemoveCinematicFlag( player, CE_FLAG_HIDE_MAIN_HUD_INSTANT )
	RemoveCinematicFlag( player, CE_FLAG_HIDE_PERMANENT_HUD)
	player.UnfreezeControlsOnServer()
	EndSignal(player, "ChallengeTimeOver")
	
	float endtime = Time() + AimTrainer_CHALLENGE_DURATION
	
	entity restart = CreateCancelChallengeButton()
	restart.SetOrigin(floorCenterForButton)
	restart.SetAngles(Vector(0,-90,0))
	
	OnThreadEnd(
		function() : ( player, restart )
		{
		OnChallengeEnd(player, restart)
		}
	)
	
	thread ChallengeWatcherThread(endtime, player)
	
	while(true){
		if(!AimTrainer_INFINITE_CHALLENGE) 
			if(Time() > endtime) break		
		entity dummy = CreateDummy(99, player.GetOrigin() + AnglesToForward(player.GetAngles())*300, Vector(0,90,0))
		vector pos = dummy.GetOrigin()
		vector angles = dummy.GetAngles()
		StartParticleEffectInWorld( GetParticleSystemIndex( FIRINGRANGE_ITEM_RESPAWN_PARTICLE ), pos, angles )
		SetSpawnOption_AISettings( dummy, "npc_dummie_combat" )
		DispatchSpawn( dummy )	
		dummy.SetShieldHealthMax( ReturnShieldAmountForDesiredLevel() )
		dummy.SetShieldHealth( ReturnShieldAmountForDesiredLevel() )
		dummy.SetMaxHealth( 100 )
		dummy.SetHealth( 100 )
		dummy.SetTakeDamageType( DAMAGE_YES )
		dummy.SetDamageNotifications( true )
		dummy.SetDeathNotifications( true )
		dummy.SetValidHealthBarTarget( true )
		SetObjectCanBeMeleed( dummy, true )
		dummy.SetSkin(RandomIntRange(1,5))
		dummy.DisableHibernation()
		// SetTargetName(dummy, "straferDummy")
		
		AddEntityCallback_OnDamaged(dummy, OnFloatingDummyDamaged)
		AddEntityCallback_OnKilled(dummy, OnDummyKilled)
		ChallengesStruct.dummies.append(dummy)
		
		array<string> attachments = [ "vent_left", "vent_right" ]
		foreach ( attachment in attachments )
			{
					int enemyID    = GetParticleSystemIndex( $"P_enemy_jump_jet_ON_trails" )
					entity enemyFX = StartParticleEffectOnEntity_ReturnEntity( dummy, enemyID, FX_PATTACH_POINT_FOLLOW, dummy.LookupAttachment( attachment ) )
			}
		
		WaitSignal(dummy, "OnDeath")
		wait 0.5
	}
}

//CHALLENGE "Popcorn targets"
void function StartPopcornChallenge(entity player)
{
	if(!IsValid(player)) return
	
	player.SetOrigin(floorCenterForPlayer)
	player.SetAngles(Vector(0,-90,0))
	ChallengesStruct.floor = CreateFloorAtOrigin(floorLocation, 30, 30)
	wait AimTrainer_PRE_START_TIME
	RemoveCinematicFlag( player, CE_FLAG_HIDE_MAIN_HUD_INSTANT )
	RemoveCinematicFlag( player, CE_FLAG_HIDE_PERMANENT_HUD)
	player.UnfreezeControlsOnServer()
	EndSignal(player, "ChallengeTimeOver")
	
	float endtime = Time() + AimTrainer_CHALLENGE_DURATION
	
	entity restart = CreateCancelChallengeButton()
	restart.SetOrigin(floorCenterForButton)
	restart.SetAngles(Vector(0,-90,0))
	OnThreadEnd(
		function() : ( player, restart)
		{
			OnChallengeEnd(player, restart)
		}
	)
	
	thread ChallengeWatcherThread(endtime, player)
	
	while(true){
		if(!AimTrainer_INFINITE_CHALLENGE) 
			if(Time() > endtime) break	
		while(ChallengesStruct.dummies.len()<4){
				thread CreateDummyPopcornChallenge(player)
			}
			WaitFrame()
	}
}

void function CreateDummyPopcornChallenge(entity player)
{
	float r = float(RandomInt(6)) / float(6) * 2 * PI
	vector origin2 = player.GetOrigin() + 300 * <sin( r ), cos( r ), 0.0>

	entity dummy = CreateDummy( 99, origin2, <0,90,0> )
	
	EndSignal(dummy, "OnDeath")
	
	vector pos = dummy.GetOrigin()
	vector angles = dummy.GetAngles()
	StartParticleEffectInWorld( GetParticleSystemIndex( FIRINGRANGE_ITEM_RESPAWN_PARTICLE ), pos, angles )
	SetSpawnOption_AISettings( dummy, "npc_dummie_combat" )
	DispatchSpawn( dummy )	
	dummy.SetShieldHealthMax( ReturnShieldAmountForDesiredLevel() )
	dummy.SetShieldHealth( ReturnShieldAmountForDesiredLevel() )
	dummy.SetMaxHealth( 100 )
	dummy.SetHealth( 100 )
	dummy.SetTakeDamageType( DAMAGE_YES )
	dummy.SetDamageNotifications( true )
	dummy.SetDeathNotifications( true )
	dummy.SetValidHealthBarTarget( true )
	SetObjectCanBeMeleed( dummy, true )
	dummy.SetSkin(RandomIntRange(1,5))
	dummy.DisableHibernation()
	AddEntityCallback_OnDamaged(dummy, OnStraferDummyDamaged)
	AddEntityCallback_OnKilled(dummy, OnDummyKilled)
	ChallengesStruct.dummies.append(dummy)
	
	int random					
	if(CoinFlip())
		random = 1
	else
		random = -1
	entity ai = dummy
				
	array<string> attachments = [ "vent_left", "vent_right" ]
	foreach ( attachment in attachments )
		{
				int enemyID    = GetParticleSystemIndex( $"P_enemy_jump_jet_ON_trails" )
				entity enemyFX = StartParticleEffectOnEntity_ReturnEntity( dummy, enemyID, FX_PATTACH_POINT_FOLLOW, dummy.LookupAttachment( attachment ) )
		}
	float distance 
	
	while(IsValid(ai)){		
		distance = ai.GetOrigin().z - floorLocation.z //Tracking the distance dummy is to the ground, forcing it jump instantly. IsOnGround check is trash and sometimes stops dummy and it's annoying
		// if( distance > 150 && distance < 200 && RandomIntRangeInclusive(1,4) == 4) //25% chance of tapstrafe
		// {
			// vector org1 = player.GetOrigin()
			// vector org2 = ai.GetOrigin()
			// vector vec2 = org1 - org2
			// vector angles2 = VectorToAngles( vec2 )
			// ai.SetAngles(angles2)
			
			// if(CoinFlip())
				// random = 1
			// else
				// random = -1

			// int random2 = RandomIntRangeInclusive(1,4)
			// if(random2 == 1 || random2 == 2 || random2 == 3) //75% prob jumping around the player randomly right or left
				// ai.SetVelocity((AnglesToRight( angles2 ) * RandomFloatRange(128,256) * random ) + AnglesToUp(angles2)*RandomFloatRange(512,1024))
			// else if(random2 == 4) //25% of chance going to player location and repositioning 
				// ai.SetVelocity((AnglesToForward( angles2 ) * RandomFloatRange(128,256)) + AnglesToUp(angles2)*RandomFloatRange(512,1024))
			
			// EmitSoundOnEntity( ai, "JumpPad_LaunchPlayer_3p" )
		// }
		if( distance < 50)
		{
			vector org1 = player.GetOrigin()
			vector org2 = ai.GetOrigin()
			vector vec2 = org1 - org2
			vector angles2 = VectorToAngles( vec2 )
			ai.SetAngles(angles2)
			
			if(CoinFlip())
				random = 1
			else
				random = -1

			int random2 = RandomIntRangeInclusive(1,4)
			if(random2 == 1 || random2 == 2 || random2 == 3) //75% prob jumping around the player randomly right or left
				ai.SetVelocity((AnglesToRight( angles2 ) * RandomFloatRange(128,256) * random ) + AnglesToUp(angles2)*RandomFloatRange(512,1024))
			else if(random2 == 4) //25% of chance going to player location and repositioning 
				ai.SetVelocity((AnglesToForward( angles2 ) * RandomFloatRange(128,256)) + AnglesToUp(angles2)*RandomFloatRange(512,1024))
			
			EmitSoundOnEntity( ai, "JumpPad_LaunchPlayer_3p" )

		}
		WaitFrame()
	}
}

//CHALLENGE "Straight up"
void function StartStraightUpChallenge(entity player)
{
	if(!IsValid(player)) return
	
	player.SetOrigin(floorCenterForPlayer)
	player.SetAngles(Vector(0,-90,0))
	ChallengesStruct.floor = CreateFloorAtOrigin(floorLocation, 30, 30)
	wait AimTrainer_PRE_START_TIME
	RemoveCinematicFlag( player, CE_FLAG_HIDE_MAIN_HUD_INSTANT )
	RemoveCinematicFlag( player, CE_FLAG_HIDE_PERMANENT_HUD)
	player.UnfreezeControlsOnServer()
	EndSignal(player, "ChallengeTimeOver")
	
	float endtime = Time() + AimTrainer_CHALLENGE_DURATION
	
	entity restart = CreateCancelChallengeButton()
	restart.SetOrigin(floorCenterForButton)
	restart.SetAngles(Vector(0,-90,0))
	OnThreadEnd(
		function() : ( player, restart)
		{
			OnChallengeEnd(player, restart)
		}
	)
	entity shield = CreatePropDynamic( $"mdl/fx/bb_shield.rmdl", player.GetOrigin() + AnglesToForward(player.GetAngles())*400, Vector(0,0,0) )
	shield.kv.rendercolor = TEAM_COLOR_ENEMY
	ChallengesStruct.props.append(shield)
	
	thread ChallengeWatcherThread(endtime, player)
	
	while(true){
		if(!AimTrainer_INFINITE_CHALLENGE) 
			if(Time() > endtime) break	
		
		if(ChallengesStruct.dummies.len()<1){
				thread CreateDummyStraightUpChallenge(player, shield)
			}
			WaitFrame()
	}
}

void function CreateDummyStraightUpChallenge(entity player, entity shield)
{
	entity dummy = CreateDummy( 99, player.GetOrigin() + AnglesToForward(player.GetAngles())*400, Vector(0,90,0) )
	shield.SetOrigin(dummy.GetOrigin())
	dummy.SetOrigin(dummy.GetOrigin()+Vector(0,0,150))
	
	EndSignal(dummy, "OnDeath")
	EndSignal(player, "ChallengeTimeOver")
	
	OnThreadEnd(
		function() : ( dummy )
		{
			if(IsValid(dummy)) dummy.Destroy()
			ChallengesStruct.dummies.removebyvalue(dummy)
		}
	)
	
	vector pos = dummy.GetOrigin()
	vector angles = dummy.GetAngles()
	StartParticleEffectInWorld( GetParticleSystemIndex( FIRINGRANGE_ITEM_RESPAWN_PARTICLE ), pos, angles )
	SetSpawnOption_AISettings( dummy, "npc_dummie_combat" )
	DispatchSpawn( dummy )	
	dummy.SetShieldHealthMax( ReturnShieldAmountForDesiredLevel() )
	dummy.SetShieldHealth( ReturnShieldAmountForDesiredLevel() )
	dummy.SetMaxHealth( 100 )
	dummy.SetHealth( 100 )
	dummy.SetTakeDamageType( DAMAGE_YES )
	dummy.SetDamageNotifications( true )
	dummy.SetDeathNotifications( true )
	dummy.SetValidHealthBarTarget( true )
	SetObjectCanBeMeleed( dummy, true )
	dummy.SetSkin(RandomIntRange(1,5))
	dummy.DisableHibernation()
	AddEntityCallback_OnDamaged(dummy, OnStraferDummyDamaged)
	AddEntityCallback_OnKilled(dummy, OnDummyKilled)
	ChallengesStruct.dummies.append(dummy)
	
	int random					
	if(CoinFlip())
		random = 1
	else
		random = -1
	
	entity ai = dummy				
	array<string> attachments = [ "vent_left", "vent_right" ]
	foreach ( attachment in attachments )
		{
			int enemyID    = GetParticleSystemIndex( $"P_enemy_jump_jet_ON_trails" )
			entity enemyFX = StartParticleEffectOnEntity_ReturnEntity( dummy, enemyID, FX_PATTACH_POINT_FOLLOW, dummy.LookupAttachment( attachment ) )
		}
		
	int idk = 150 //from retail??
	float chargingTime = Time() + 2
	while( Time() <= chargingTime )
		{

			dummy.SetVelocity( <dummy.GetVelocity().x, dummy.GetVelocity().y, idk> )
			WaitFrame()
		}
	float flyingTime = Time() + 5
	while( Time() <= flyingTime )
		{
			dummy.SetVelocity( <dummy.GetVelocity().x, dummy.GetVelocity().y, idk*10> )
			WaitFrame()
		}
}
//CHALLENGE "Bubble Fight"
void function StartBubblefightChallenge(entity player)
{
	if(!IsValid(player)) return
	
	player.SetOrigin(Vector(33946,-6511,-28859))
	player.SetAngles(Vector(0,-90,0))
	wait AimTrainer_PRE_START_TIME
	RemoveCinematicFlag( player, CE_FLAG_HIDE_MAIN_HUD_INSTANT )
	RemoveCinematicFlag( player, CE_FLAG_HIDE_PERMANENT_HUD)
	player.UnfreezeControlsOnServer()
	EndSignal(player, "ChallengeTimeOver")
	
	float endtime = Time() + AimTrainer_CHALLENGE_DURATION
	
	entity restart = CreateCancelChallengeButton()
	OnThreadEnd(
		function() : ( player, restart )
		{
			OnChallengeEnd(player, restart)
		}
	)

	entity shield = CreateBubbleShieldWithSettings( player.GetTeam(), player.GetOrigin() + AnglesToForward(player.GetAngles())*500+Normalize(player.GetRightVector())*225, <0,90,0>, player, 999, false, BUBBLE_BUNKER_SHIELD_FX, BUBBLE_BUNKER_SHIELD_COLLISION_MODEL )
	shield.SetCollisionDetailHigh()
	shield.kv.rendercolor = TEAM_COLOR_ENEMY
	ChallengesStruct.props.append(shield)
		
	thread ChallengeWatcherThread(endtime, player)

	while(true){
		if(!AimTrainer_INFINITE_CHALLENGE) 
			if(Time() > endtime) break		
		if(ChallengesStruct.dummies.len()<1){
			entity dummy = CreateDummy( 99, shield.GetOrigin()+Normalize(shield.GetRightVector())*225, <0,90,0> )
			vector pos = dummy.GetOrigin()
			vector angles = dummy.GetAngles()
			StartParticleEffectInWorld( GetParticleSystemIndex( FIRINGRANGE_ITEM_RESPAWN_PARTICLE ), pos, angles )
			SetSpawnOption_AISettings( dummy, "npc_dummie_combat" )
			DispatchSpawn( dummy )	
			dummy.SetShieldHealthMax( ReturnShieldAmountForDesiredLevel() )
			dummy.SetShieldHealth( ReturnShieldAmountForDesiredLevel() )
			dummy.SetMaxHealth( 100 )
			dummy.SetHealth( 100 )
			dummy.SetTakeDamageType( DAMAGE_YES )
			dummy.SetDamageNotifications( true )
			dummy.SetDeathNotifications( true )
			dummy.SetValidHealthBarTarget( true )
			SetObjectCanBeMeleed( dummy, true )
			dummy.SetSkin(RandomIntRange(1,5))
			dummy.DisableHibernation()
			ChallengesStruct.dummies.append(dummy)
			AddEntityCallback_OnDamaged(dummy, OnStraferDummyDamaged)
			AddEntityCallback_OnKilled(dummy, OnDummyKilled)
			thread BubbleFightStrafe(dummy, player, shield)
			dummy.SetBehaviorSelector( "behavior_dummy_empty" )
			dummy.DisableNPCFlag( NPC_ALLOW_PATROL | NPC_ALLOW_INVESTIGATE | NPC_NEW_ENEMY_FROM_SOUND )
		
		}
		WaitFrame()
	}
}

void function BubbleFightStrafe(entity ai, entity player, entity shield)
{
	ai.EndSignal("OnDeath")
	player.EndSignal("ChallengeTimeOver")
	
	OnThreadEnd(
		function() : ( ai )
		{
			if(IsValid(ai)) ai.Destroy()
			ChallengesStruct.dummies.removebyvalue(ai)
		}
	)
				
	array<string> weapons = ["mp_weapon_vinson", "mp_weapon_lstar"]
	string randomWeapon = weapons[RandomInt(weapons.len())]
	entity weapon = ai.GiveWeapon(randomWeapon, WEAPON_INVENTORY_SLOT_ANY)
	
			
	//So distance is not 0 and we can start the while loop
	if(CoinFlip())
		ai.Anim_ScriptedPlayActivityByName( "ACT_RUN_RIGHT", true, 0.1 )
	else
		ai.Anim_ScriptedPlayActivityByName( "ACT_RUN_LEFT", true, 0.1 )
	wait RandomFloatRange(0.2,0.25)
	
	if(!IsValid(ai)) return
	
	while(true)
	{
		float distance = (ai.GetOrigin() - (shield.GetOrigin()+Normalize(shield.GetRightVector())*225 )).x //Tracking the distance dummy is to the border of the bubble, forcing it to move that way
		
		int random = RandomIntRangeInclusive(1,4)

		if(random == 1 || random == 2 || random == 3){			
			if(distance< -5){
				ai.Anim_ScriptedPlayActivityByName( "ACT_RUN_RIGHT", true, 0.1 )
				wait RandomFloatRange(0.2,0.25)
				weapon.FireWeapon_Default( player.GetOrigin()+Vector(0,0,60)+(Normalize(player.GetRightVector())*30), ai.GetOrigin()+Vector(0,0,50), 1.0, 1.0, false )}
			if(distance> 5){
				ai.Anim_ScriptedPlayActivityByName( "ACT_RUN_LEFT", true, 0.1 )
				wait RandomFloatRange(0.18,0.22)
				weapon.FireWeapon_Default( player.GetOrigin()+Vector(0,0,60)+(Normalize(player.GetRightVector())*30), ai.GetOrigin()+Vector(0,0,50), 1.0, 1.0, false )
				}
		} else if( random == 4 && distance > 22 || random == 4 && distance < -15  )
		{
			ai.Anim_Stop()
			wait RandomFloatRange(0.15,0.3)
			weapon.FireWeapon_Default(player.GetOrigin()+Vector(0,0,60)+(Normalize(player.GetRightVector())*30), ai.GetOrigin()+Vector(0,0,50), 1.0, 1.0, false )
		}
		WaitFrame()
	}
}

//CHALLENGE "Arcstars practice"
void function StartArcstarsChallenge(entity player)
{
	if(!IsValid(player)) return
	player.SetOrigin(Vector(33946,-6511,-28859))
	player.SetAngles(Vector(0,-90,0))
	EndSignal(player, "ChallengeTimeOver")
	TakeAllWeapons(player)
	player.GiveWeapon( "mp_weapon_grenade_emp", WEAPON_INVENTORY_SLOT_PRIMARY_0, ["challenges_infinite_arcstars"] )
	player.SetActiveWeaponBySlot(eActiveInventorySlot.mainHand, WEAPON_INVENTORY_SLOT_PRIMARY_0)
	wait AimTrainer_PRE_START_TIME
	RemoveCinematicFlag( player, CE_FLAG_HIDE_MAIN_HUD_INSTANT )
	RemoveCinematicFlag( player, CE_FLAG_HIDE_PERMANENT_HUD)
	player.UnfreezeControlsOnServer()
	
	float endtime = Time() + AimTrainer_CHALLENGE_DURATION
	
	entity restart = CreateCancelChallengeButton()
	OnThreadEnd(
		function() : ( player, restart)
		{
			TakeAllWeapons(player)
			GiveWeaponsFromStoredArray(player, player.p.storedWeapons)
			OnChallengeEnd(player, restart)	
		}
	)

	thread ChallengeWatcherThread(endtime, player)

	while(true){
		if(!AimTrainer_INFINITE_CHALLENGE) 
			if(Time() > endtime) break		
		if(ChallengesStruct.dummies.len()<2){
			entity dummy = CreateDummy( 99, Vector(33948, -6949, -28859), <0,90,0> )
			vector pos = dummy.GetOrigin()
			vector angles = dummy.GetAngles()
			StartParticleEffectInWorld( GetParticleSystemIndex( FIRINGRANGE_ITEM_RESPAWN_PARTICLE ), pos, angles )
			SetSpawnOption_AISettings( dummy, "npc_dummie_combat" )
			DispatchSpawn( dummy )	
			//dummy.SetShieldHealthMax( ReturnShieldAmountForDesiredLevel() )
			//dummy.SetShieldHealth( ReturnShieldAmountForDesiredLevel() )
			dummy.SetMaxHealth( 100 )
			dummy.SetHealth( 100 )
			dummy.SetTakeDamageType( DAMAGE_YES )
			dummy.SetDamageNotifications( true )
			dummy.SetDeathNotifications( true )
			dummy.SetValidHealthBarTarget( true )
			SetObjectCanBeMeleed( dummy, true )
			dummy.SetSkin(RandomIntRange(1,5))
			dummy.DisableHibernation()
			SetTargetName(dummy, "arcstarChallengeDummy")
			ChallengesStruct.dummies.append(dummy)
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
			ChallengesStruct.dummies.removebyvalue(ai)
		}
	)
	ai.SetAngles(Vector(ai.GetAngles().x,RandomIntRangeInclusive(-90,90), ai.GetAngles().z))
	if(CoinFlip())
		if(CoinFlip())
			ai.Anim_ScriptedPlayActivityByName( "ACT_SPRINT_BACKWARD", true, 0.1 )
		else 
			ai.Anim_ScriptedPlayActivityByName( "ACT_SPRINT_FORWARD", true, 0.1 )
	else
		if(CoinFlip())
			ai.Anim_ScriptedPlayActivityByName( "ACT_SPRINT_LEFT", true, 0.1 )
		else 
			ai.Anim_ScriptedPlayActivityByName( "ACT_SPRINT_RIGHT", true, 0.1 )
	wait 4
	
	if(!IsValid(ai)) return
}

//CHALLENGE "Lift up practice"
void function StartLiftUpChallenge(entity player)
{
	if(!IsValid(player)) return
	player.SetOrigin(Vector(33946,-6511,-28859))
	player.SetAngles(Vector(0,-90,0))
	EndSignal(player, "ChallengeTimeOver")
	wait AimTrainer_PRE_START_TIME
	RemoveCinematicFlag( player, CE_FLAG_HIDE_MAIN_HUD_INSTANT )
	RemoveCinematicFlag( player, CE_FLAG_HIDE_PERMANENT_HUD)
	player.UnfreezeControlsOnServer()
	
	float endtime = Time() + AimTrainer_CHALLENGE_DURATION
	
	entity weapon = player.GetNormalWeapon( WEAPON_INVENTORY_SLOT_PRIMARY_0 )

	array<string> mods = weapon.GetMods()
	mods.append( "elevator_shooter" )
	try{weapon.SetMods( mods )} catch(e42069){printt(weapon.GetWeaponClassName() + " failed to put elevator_shooter mod. DEBUG THIS.")}
	
	entity restart = CreateCancelChallengeButton()
	OnThreadEnd(
		function() : ( player, restart, mods, weapon)
		{
			mods.removebyvalue("elevator_shooter")
			try{weapon.SetMods( mods )} catch(e42069){printt(weapon.GetWeaponClassName() + " failed to remove elevator_shooter mod. DEBUG THIS.")}
			OnChallengeEnd(player, restart)
		}
	)

	thread ChallengeWatcherThread(endtime, player)
	CreateLiftForChallenge(player.GetOrigin(), player)
	player.SetOrigin(player.GetOrigin()+Normalize(player.GetForwardVector())*0.01) //workaround, so we execute onentertrigger callback instantly
	while(true){
		if(!AimTrainer_INFINITE_CHALLENGE) 
			if(Time() > endtime) break		
		if(ChallengesStruct.dummies.len()<2){
			entity dummy = CreateDummy( 99, Vector(33948, -6949, -28859), <0,90,0> )
			vector pos = dummy.GetOrigin()
			vector angles = dummy.GetAngles()
			StartParticleEffectInWorld( GetParticleSystemIndex( FIRINGRANGE_ITEM_RESPAWN_PARTICLE ), pos, angles )
			SetSpawnOption_AISettings( dummy, "npc_dummie_combat" )
			DispatchSpawn( dummy )	
			dummy.SetShieldHealthMax( ReturnShieldAmountForDesiredLevel() )
			dummy.SetShieldHealth( ReturnShieldAmountForDesiredLevel() )
			dummy.SetMaxHealth( 100 )
			dummy.SetHealth( 100 )
			dummy.SetTakeDamageType( DAMAGE_YES )
			dummy.SetDamageNotifications( true )
			dummy.SetDeathNotifications( true )
			dummy.SetValidHealthBarTarget( true )
			SetObjectCanBeMeleed( dummy, true )
			dummy.SetSkin(RandomIntRange(1,5))
			dummy.DisableHibernation()
			ChallengesStruct.dummies.append(dummy)
			AddEntityCallback_OnDamaged(dummy, OnStraferDummyDamaged)
			AddEntityCallback_OnKilled(dummy, OnDummyKilled)
			thread LiftUpDummyMovementThink(dummy, player)
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
			if(IsValid(ai)) ai.Destroy()
			ChallengesStruct.dummies.removebyvalue(ai)
		}
	)
	ai.SetAngles(Vector(ai.GetAngles().x,RandomIntRangeInclusive(-90,90), ai.GetAngles().z))
	if(CoinFlip())
		if(CoinFlip())
			ai.Anim_ScriptedPlayActivityByName( "ACT_SPRINT_BACKWARD", true, 0.1 )
		else 
			ai.Anim_ScriptedPlayActivityByName( "ACT_SPRINT_FORWARD", true, 0.1 )
	else
		if(CoinFlip())
			ai.Anim_ScriptedPlayActivityByName( "ACT_SPRINT_LEFT", true, 0.1 )
		else 
			ai.Anim_ScriptedPlayActivityByName( "ACT_SPRINT_RIGHT", true, 0.1 )
	wait 4
	
	if(!IsValid(ai)) return
}

void function CreateLiftForChallenge(vector pos, entity player){

	entity bottom = CreateEntity( "trigger_cylinder" )
	bottom.SetRadius( 25 )
	bottom.SetAboveHeight( 1200 )
	bottom.SetBelowHeight( 10 )
	bottom.SetOrigin( pos )
	bottom.SetLeaveCallback( BottomTriggerLeave )
	DispatchSpawn( bottom )

	entity top = CreateEntity( "trigger_cylinder" )
	top.SetRadius( 30 )
	top.SetAboveHeight( 1 )
	top.SetBelowHeight( 24 )
	top.SetOrigin( pos + <0, 0, 1200> )
	DispatchSpawn( top )

	thread liftplayerup(bottom, top, pos, player)
	thread liftVisualsCreator(pos)
	
	ChallengesStruct.props.append(bottom)
	ChallengesStruct.props.append(top)
}

void function liftVisualsCreator(vector pos)
{
	//Circle on ground FX
	entity circle = CreateEntity( "prop_script" )
	circle.SetValueForModelKey( $"mdl/weapons_r5/weapon_tesla_trap/mp_weapon_tesla_trap_ar_trigger_radius.rmdl" )
	circle.kv.fadedist = 30000
	circle.kv.renderamt = 0
	circle.kv.rendercolor = "240, 19, 19"
	circle.kv.modelscale = 0.15
	circle.kv.solid = 0
	circle.SetOrigin( pos + <0.0, 0.0, -25>)
	circle.SetAngles( <0, 0, 0> )
	circle.NotSolid()
	DispatchSpawn(circle)
	
	ChallengesStruct.props.append(circle)
}

void function BottomTriggerLeave( entity trigger, entity ent )
{
	if ( !ent.IsPlayer() )
		return
		
	vector forward = AnglesToForward( ent.GetAngles() )
	vector up = AnglesToUp( ent.GetAngles() )
	vector velocity = ent.GetVelocity()
	velocity += (forward * 400) + (up*450)
	ent.SetVelocity( velocity )
}

void function ForceToBeInLiftForChallenge( entity player )
{
	EndSignal(player, "ChallengeTimeOver")
	if(!player.IsPlayer()) return
	while(IsValid(player))
	{
		wait 4
		player.SetVelocity(Vector(0,0,0))
		player.SetOrigin(Vector(33946,-6511,-28859))
	}
}

void function liftplayerup( entity bottom, entity top, vector pos, entity player)
{
	EndSignal(player, "ChallengeTimeOver")

	thread ForceToBeInLiftForChallenge(player)
	float testtime = Time()

	while( true )
	{
			if(top.IsTouching(player))
			{
				vector enemyOrigin = player.GetOrigin()
				vector dir = Normalize( pos - player.GetOrigin() )
				float dist = Distance( enemyOrigin, pos )
				vector newVelocity = player.GetVelocity() * GraphCapped( dist, 25, 300.0, 0, 1 ) + dir * GraphCapped( dist, 25, 300.0, 0, 100.0 )// + < 0, 0, GraphCapped( 100, -25, 0, 100, 0 )>
				newVelocity.z = 25
				player.SetVelocity( newVelocity )
			}
			else if(bottom.IsTouching(player))
			{
				vector enemyOrigin = player.GetOrigin()
				vector dir = Normalize( pos - player.GetOrigin() )
				float dist = Distance( enemyOrigin, pos )
				vector newVelocity = player.GetVelocity() * GraphCapped( dist, 25, 300.0, 0, 1 ) + dir * GraphCapped( dist, 25, 300.0, 0, 100.0 )// + < 0, 0, GraphCapped( 100, -25, 0, 100, 0 )>
				newVelocity.z = 360
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
	player.SetAngles(Vector(0,-90,0))
	ChallengesStruct.floor = CreateFloorAtOrigin(floorLocation, 30, 30)
	EndSignal(player, "ChallengeTimeOver")
	wait AimTrainer_PRE_START_TIME
	if(!IsValid(player)) return
	RemoveCinematicFlag( player, CE_FLAG_HIDE_MAIN_HUD_INSTANT )
	RemoveCinematicFlag( player, CE_FLAG_HIDE_PERMANENT_HUD)
	player.UnfreezeControlsOnServer()
	
	float endtime = Time() + AimTrainer_CHALLENGE_DURATION
	
	TakeAllWeapons(player)
	player.GiveWeapon( "mp_weapon_clickweapon", WEAPON_INVENTORY_SLOT_PRIMARY_0, [] )
	player.SetActiveWeaponBySlot(eActiveInventorySlot.mainHand, WEAPON_INVENTORY_SLOT_PRIMARY_0)

	entity restart = CreateCancelChallengeButton()
	OnThreadEnd(
		function() : ( player, restart)//, mods, weapon)
		{
			TakeAllWeapons(player)
			GiveWeaponsFromStoredArray(player, player.p.storedWeapons)
			OnChallengeEnd(player, restart)
		}
	)

	thread ChallengeWatcherThread(endtime, player)

	//5x5?
	int ancho = 5
	int alto = 5
	vector pos = player.GetOrigin() + AnglesToForward(player.GetAngles())*400
	int x = int(pos.x)
	int y = int(pos.y)
	int z = int(pos.z+200)
	float modelscale = 0.2
	int offset = 0
	int step = int((offset+256)*modelscale)
	array<vector> locationsForTiles
	
	for(int i = z; i < z + (ancho * step); i += step)
	{
		for(int j = x; j < x + (alto * step); j += step)
		{
		locationsForTiles.append(Vector(j, y, i))
		}
	}
	
	locationsForTiles.randomize() //shuffle array
	int locationindex = 1
	while(true){
		if(!AimTrainer_INFINITE_CHALLENGE) 
			if(Time() > endtime) break

		if(locationindex == locationsForTiles.len()){
			locationsForTiles.randomize()
			locationindex = 1
		}			
		if(ChallengesStruct.props.len() < 3){
				
				entity target = CreateEntity( "script_mover" )
				target.kv.solid = 6
				target.SetValueForModelKey( FIRINGRANGE_FLICK_TARGET_ASSET )
				target.kv.SpawnAsPhysicsMover = 0
				target.SetOrigin( locationsForTiles[locationindex] )
				locationindex++
				target.SetAngles( Vector(0,90,0) )
				DispatchSpawn( target )
				target.Hide()
				target.SetDamageNotifications( true )

				entity visual = CreatePropDynamic(FIRINGRANGE_BLUE_TARGET_ASSET, target.GetOrigin(), target.GetAngles(), 6, -1)
				visual.SetParent(target)
				visual.SetModelScale(0.45)
				visual.NotSolid()
				
				AddEntityCallback_OnDamaged(target, OnTilePropDamaged)
				ChallengesStruct.props.append(target)
		}
		WaitFrame()
	}
}

//Challenges related end functions
void function OnChallengeEnd(entity player, entity restart)
{
	if(!IsValid(player)) return
	
	player.p.isChallengeActivated = false
	player.p.straferAccuracy = float(player.p.straferShotsHit) / float(player.p.straferTotalShots)
	
	if(player.p.straferShotsHit > player.p.straferShotsHitRecord) 
	{
		player.p.straferShotsHitRecord = player.p.straferShotsHit
		player.p.isNewBestScore = true
	}

		printt("---------------------------------------")
		printt("CHALLENGE RESULTS:")
		printt("Killed dummies: " + player.p.straferDummyKilledCount)
		printt("Accuracy: " + player.p.straferAccuracy)
		printt("Shots hit: " + player.p.straferShotsHit)
		printt("Damage done: " + player.p.straferChallengeDamage)
		printt("Crit. shots: " + player.p.straferCriticalShots)
		printt("---------------------------------------")

	if(IsValid(restart)) restart.Destroy()
	Remote_CallFunction_NonReplay(player, "ServerCallback_OpenFRChallengesMenu", player.p.challengeName, player.p.straferShotsHit,player.p.straferDummyKilledCount,player.p.straferAccuracy,player.p.straferChallengeDamage,player.p.straferCriticalShots,player.p.straferShotsHitRecord,player.p.isNewBestScore)
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
				player.SetOrigin(AimTrainer_startPos)
				player.SetAngles(AimTrainer_startAngs)
				HolsterAndDisableWeapons(player)
				
				foreach(entity floor in ChallengesStruct.floor)
					if(IsValid(floor))
						floor.Destroy()
					
				foreach(entity dummie in ChallengesStruct.dummies)
					if(IsValid(dummie))
						dummie.Destroy()
				
				foreach(entity prop2 in ChallengesStruct.props)
					if(IsValid(prop2))			
						prop2.Destroy()
				
				ResetChallengeStats(player)
				
				Remote_CallFunction_NonReplay(player, "ServerCallback_ResetLiveStatsUI")
				Remote_CallFunction_NonReplay(player, "ServerCallback_CoolCameraOnMenu")
				Remote_CallFunction_NonReplay(player, "ServerCallback_OpenFRChallengesMainMenu", player.GetPlayerNetInt( "kills" ))
			}
		}
	)

	wait AimTrainer_RESULTS_TIME
}

void function ChallengeWatcherThread(float endtime, entity player)
{
	EndSignal(player, "ForceResultsEnd_SkipButton")
	EndSignal(player, "ChallengeTimeOver")
	
	OnThreadEnd(
		function() : ( player )
		{
			Signal(player, "ChallengeTimeOver") // idk
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
	float damage = DamageInfo_GetDamage( damageInfo )
	
	//let's put dummies a fake helmet
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
			ChallengesStruct.dummies.removebyvalue(ent)
		}
	} else if (damage > dummy.GetHealth() + dummy.GetShieldHealth() && dummy.GetShieldHealth() > 0)
	{
		attacker.p.straferDummyKilledCount++
		Remote_CallFunction_NonReplay(attacker, "ServerCallback_LiveStatsUIDummiesKilled", attacker.p.straferDummyKilledCount)
		ChallengesStruct.dummies.removebyvalue(ent)		
	}
	
	if(!attacker.IsPlayer() ) return
	
	//add the damage
	attacker.p.straferChallengeDamage += int(damage)
	Remote_CallFunction_NonReplay(attacker, "ServerCallback_LiveStatsUIDamageViaDummieDamaged", int(damage))
	Remote_CallFunction_NonReplay(attacker, "ServerCallback_LiveStatsUIAccuracyViaShotsHits")
	
	//infinite ammo
	if(AimTrainer_INFINITE_AMMO) attacker.RefillAllAmmo()
		
	//Inmortal target
	if(AimTrainer_INMORTAL_TARGETS) dummy.SetHealth(dummy.GetMaxHealth())

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
	
	if(dummy.GetTargetName() == "arcstarChallengeDummy") OnDummyKilled(dummy, damageInfo)
}

void function OnFloatingDummyDamaged( entity dummy, var damageInfo )
{
	//let's put dummies a fake helmet
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
	int side
	
	if(CoinFlip())
		side = 1
	else
		side = -1
	
	vector org1 = player.GetOrigin()
	vector org2 = dummy.GetOrigin()
	vector vec2 = org1 - org2
	vector angles2 = VectorToAngles( vec2 )

	int random2 = RandomIntRangeInclusive(1,4)
	if(random2 == 1 || random2 == 2 || random2 == 3)
		dummy.SetVelocity((AnglesToRight(angles2 ) * RandomFloatRange(128,425) * side ) + <0, 0, RandomFloatRange(250,425) + DamageInfo_GetDamage(damageInfo) * 3>)
	else if(random2 == 4)
		dummy.SetVelocity((AnglesToForward(angles2) * RandomFloatRange(128,256)) + <0, 0, RandomFloatRange(250,425) + DamageInfo_GetDamage(damageInfo) * 3>)

	// dummy.SetAngles(angles2)
}

//Callbacks functions
void function OnTilePropDamaged( entity dummy, var damageInfo )
{
	entity ent = dummy
	
	// //let's put dummies a fake helmet
	// float headshotMultiplier = GetHeadshotDamageMultiplierFromDamageInfo(damageInfo)
	// float basedamage = DamageInfo_GetDamage(damageInfo)/headshotMultiplier
	// if(IsValidHeadShot( damageInfo, ent )) DamageInfo_SetDamage( damageInfo, basedamage*(GetCurrentPlaylistVarFloat( "helmet_lv4", 0.65 )+(1-GetCurrentPlaylistVarFloat( "helmet_lv4", 0.65 ))*headshotMultiplier))
	
	entity attacker = DamageInfo_GetAttacker(damageInfo)
	float damage = DamageInfo_GetDamage( damageInfo )
	
	if (IsValid(attacker) && attacker.IsPlayer())
	{
		EmitSoundOnEntityOnlyToPlayer( attacker, attacker, FIRINGRANGE_FLICK_TARGET_SOUND )

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
	}

	if(!attacker.IsPlayer() ) return
		
	//add the damage
	attacker.p.straferChallengeDamage += int(damage)
	Remote_CallFunction_NonReplay(attacker, "ServerCallback_LiveStatsUIDamageViaDummieDamaged", int(damage))
	Remote_CallFunction_NonReplay(attacker, "ServerCallback_LiveStatsUIAccuracyViaShotsHits")
	
	//infinite ammo
	if(AimTrainer_INFINITE_AMMO) attacker.RefillAllAmmo()
		
	// //Inmortal target
	// if(AimTrainer_INMORTAL_TARGETS) dummy.SetHealth(dummy.GetMaxHealth())

	//add 1 hit
	attacker.p.straferShotsHit++
	if(attacker.p.straferShotsHit > attacker.p.straferShotsHitRecord) 
	{
		attacker.p.straferShotsHitRecord = attacker.p.straferShotsHit
		attacker.p.isNewBestScore = true
	}
	
	attacker.p.straferDummyKilledCount++
	Remote_CallFunction_NonReplay(attacker, "ServerCallback_LiveStatsUIDummiesKilled", attacker.p.straferDummyKilledCount)
	ChallengesStruct.dummies.removebyvalue(ent)
	
	// //was critical?
	// bool isValidHeadShot = IsValidHeadShot( damageInfo, dummy )
	// if(isValidHeadShot) 
	// {
		// attacker.p.straferCriticalShots++
		// Remote_CallFunction_NonReplay(attacker, "ServerCallback_LiveStatsUIHeadshot", attacker.p.straferCriticalShots)
	// }
	
	ent.Destroy()
	ChallengesStruct.props.removebyvalue(ent)
}

void function OnDummyKilled(entity ent, var damageInfo)
{
	entity attacker = DamageInfo_GetAttacker(damageInfo)
	if ( IsValidHeadShot( damageInfo, ent )) return
	if(!attacker.IsPlayer() ) return
	attacker.p.straferDummyKilledCount++
	Remote_CallFunction_NonReplay(attacker, "ServerCallback_LiveStatsUIDummiesKilled", attacker.p.straferDummyKilledCount)
	ChallengesStruct.dummies.removebyvalue(ent)
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
	ChallengesStruct.dummies.removebyvalue(ent)
	WaitFrame()
	if(IsValid(ent)) ent.Destroy()
}
//UTILITY
int function ReturnShieldAmountForDesiredLevel()
{
	switch(AimTrainer_AI_SHIELDS_LEVEL){
		case 0:
			return 50
		case 1:
			return 75
		case 2:
			return 100
		case 3:
			return 125
	}
	unreachable
}

array<entity> function CreateFloorAtOrigin(vector origin, int width, int length)
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

//CLIENT COMMANDS
void function PreChallengeStart(entity player, int challenge)
{
	player.p.storedWeapons = StoreWeapons(player)
	AddCinematicFlag( player, CE_FLAG_HIDE_MAIN_HUD_INSTANT )
	AddCinematicFlag( player, CE_FLAG_HIDE_PERMANENT_HUD)
	player.p.challengeName = challenge
	player.p.isChallengeActivated = true
	DeployAndEnableWeapons(player)
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
	PreChallengeStart(player, 99)
	//thread StartPopcornChallenge(player)
	return false
}
bool function CC_StartChallenge1NewC( entity player, array<string> args )
{
	PreChallengeStart(player, 6)
	thread StartBubblefightChallenge(player)
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
	PreChallengeStart(player, 99)
	// thread StartStraightUpChallenge(player)
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
	AddCinematicFlag( player, CE_FLAG_HIDE_MAIN_HUD_INSTANT )
	AddCinematicFlag( player, CE_FLAG_HIDE_PERMANENT_HUD)
	//player.p.challengeName = 10
	player.p.isChallengeActivated = true
	DeployAndEnableWeapons(player)
	// thread StartStraightUpChallenge(player)
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

bool function CC_MenuGiveAimTrainerWeapon( entity player, array<string> args )
{
	if(!IsValid(player)) return false
	
	string weapon = args[0]
    entity primary = player.GetNormalWeapon( WEAPON_INVENTORY_SLOT_PRIMARY_0 )
    
	if (primary != null)
		player.TakeWeaponByEntNow( primary )
	
	if (args.len() > 1) //from attachments buy box
		{
			//printt("DEBUG: " + args[1], args[2], args[3], args[4], args[5])
			switch(args[5])
			{
				case "smg":
					player.GiveWeapon( weapon, WEAPON_INVENTORY_SLOT_PRIMARY_0, [args[1], args[2], args[3]] )
					break
				case "pistol":
					player.GiveWeapon( weapon, WEAPON_INVENTORY_SLOT_PRIMARY_0, [args[1], args[2]])
					break
				case "pistol2":
					player.GiveWeapon( weapon, WEAPON_INVENTORY_SLOT_PRIMARY_0, [args[1]])
					break
				case "shotgun":
					player.GiveWeapon( weapon, WEAPON_INVENTORY_SLOT_PRIMARY_0, [args[1], args[4]])
					break
				case "lmg2":
				case "ar":
					if(weapon == "mp_weapon_esaw" && args[4] != ".")
						player.GiveWeapon( weapon, WEAPON_INVENTORY_SLOT_PRIMARY_0, [args[1], args[2], args[3], args[4]])
					else			
						player.GiveWeapon( weapon, WEAPON_INVENTORY_SLOT_PRIMARY_0, [args[1], args[2], args[3]])
					break
				case "ar2":
					if(weapon == "mp_weapon_energy_ar" && args[4] != ".")
						player.GiveWeapon( weapon, WEAPON_INVENTORY_SLOT_PRIMARY_0, [args[1], args[3], args[4]])	
					else
						player.GiveWeapon( weapon, WEAPON_INVENTORY_SLOT_PRIMARY_0, [args[1], args[3]])					
					break
				case "marksman":
					if(args[4] != ".")
						player.GiveWeapon( weapon, WEAPON_INVENTORY_SLOT_PRIMARY_0, [args[1], args[2], args[3], args[4]] )
					else
						player.GiveWeapon( weapon, WEAPON_INVENTORY_SLOT_PRIMARY_0, [args[1], args[2], args[3]])
					break
				case "marksman2":
					if(args[4] != ".")
						player.GiveWeapon( weapon, WEAPON_INVENTORY_SLOT_PRIMARY_0, [args[1], args[3], args[4]] )
					else
						player.GiveWeapon( weapon, WEAPON_INVENTORY_SLOT_PRIMARY_0, [args[1], args[3]])
					break
				case "sniper":
					player.GiveWeapon( weapon, WEAPON_INVENTORY_SLOT_PRIMARY_0, [args[1], args[2], args[3]] )
					break
				case "sniper2":
					player.GiveWeapon( weapon, WEAPON_INVENTORY_SLOT_PRIMARY_0, [args[1], args[3]] )
					break
				case "sniper3":
					player.GiveWeapon( weapon, WEAPON_INVENTORY_SLOT_PRIMARY_0 )
					break
			}
		}
	else
		player.GiveWeapon( weapon, WEAPON_INVENTORY_SLOT_PRIMARY_0 )
	
    player.SetActiveWeaponBySlot(eActiveInventorySlot.mainHand, WEAPON_INVENTORY_SLOT_PRIMARY_0)
	return false
}
bool function CC_Weapon_Selector_Open( entity player, array<string> args )
{
	DeployAndEnableWeapons(player)
	player.SetActiveWeaponBySlot(eActiveInventorySlot.mainHand, WEAPON_INVENTORY_SLOT_PRIMARY_0)
	return false
}
bool function CC_Weapon_Selector_Close( entity player, array<string> args )
{
	HolsterAndDisableWeapons(player)
	return false
}

bool function CC_ExitChallenge( entity player, array<string> args )
{
	Signal(player, "ChallengeTimeOver")
	return false
}
