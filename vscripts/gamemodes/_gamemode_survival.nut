global function GamemodeSurvival_Init
global function RateSpawnpoints_Directional
global function Survival_SetFriendlyOwnerHighlight
global function SURVIVAL_AddSpawnPointGroup
global function SURVIVAL_IsCharacterClassLocked
global function SURVIVAL_IsValidCircleLocation
global function _GetSquadRank
global function JetwashFX
global function Survival_PlayerRespawnedTeammate
global function UpdateDeathBoxHighlight
global function HandleSquadElimination
// these probably doesn't belong here
//----------------------------------
global function Survival_GetMapFloorZ
global function SURVIVAL_GetClosestValidCircleEndLocation
global function SURVIVAL_CalculateAirdropPositions
global function SURVIVAL_AddLootBin
global function SURVIVAL_AddLootGroupRemapping
global function SURVIVAL_DebugLoot
global function Survival_AddCallback_OnAirdropLaunched
global function Survival_CleanupPlayerPermanents
global function Survival_SetCallback_Leviathan_ConsiderLookAtEnt
global function Survival_Leviathan_ConsiderLookAtEnt
global function CreateSurvivalDeathBoxForPlayer
global function OnDummieKilled
///CONFIGS
//Dummies horde
const bool DUMMIES_HORDE_DEBUG = false
const bool ENABLE_CHARACTERS_DUMMIES = false

struct
{
    void functionref( entity, float, float ) leviathanConsiderLookAtEntCallback = null
	int aliveDummies
	bool nodummiesyet = true
} file

void function GamemodeSurvival_Init()
{
	SurvivalFreefall_Init()
	Sh_ArenaDeathField_Init()
	SurvivalShip_Init()

	if ( GetMapName() == "mp_rr_ashs_redemption" )
	{
		//tdm map death wall
		CreateWallTrigger( <-20857, 5702, -25746> )
	}
	
	FlagInit( "SpawnInDropship", false )
	FlagInit( "PlaneDrop_Respawn_SetUseCallback", false )
	RegisterSignal("GetNewAnim")
	AddCallback_OnPlayerKilled( OnPlayerKilled )
	AddCallback_OnClientConnected( OnClientConnected )
	AddClientCommandCallback("say", ClientCommand_ClientMsg)
	AddClientCommandCallback("sayhistory", ClientCommand_DispayChatHistory)
	AddClientCommandCallback("teambal", ClientCommand_RebalanceTeams)
	AddClientCommandCallback("flowstatekick", ClientCommand_FlowstateKick)
	AddClientCommandCallback("latency", ClientCommand_ShowLatency)
	
	AddCallback_GameStateEnter( 
		eGameState.Playing,
		void function()
		{
			thread Sequence_Playing()
		}
	)

	thread SURVIVAL_RunArenaDeathField()
}

void function Survival_SetCallback_Leviathan_ConsiderLookAtEnt( void functionref( entity, float, float ) callback )
{
	file.leviathanConsiderLookAtEntCallback = callback
}

void function Survival_Leviathan_ConsiderLookAtEnt(entity ent)
{
    wait 1 //Wait until the ent has decided their direction
    if(file.leviathanConsiderLookAtEntCallback != null)
        file.leviathanConsiderLookAtEntCallback( ent, 10, 0.3 )
}

void function OnDummieKilled( entity npc, var damageInfo )
{
	entity attacker = DamageInfo_GetAttacker(damageInfo)
	// if(!attacker.IsPlayer() || !IsValid(attacker) || !npc.IsNPC()) return
	DamageInfo_AddCustomDamageType( damageInfo, DF_KILLSHOT )
	
	// if(IsValid(npc)) npc.Destroy()
	
	file.aliveDummies--
	thread EmitSoundOnEntityOnlyToPlayer( attacker, attacker, "flesh_bulletimpact_downedshot_1p_vs_3p" )
	attacker.SetPlayerNetInt( "kills", attacker.GetPlayerNetInt( "kills" ) + 1 )
	UpdatePlayerCounts()	
}

void function RespawnPlayerInDropship( entity player )
{
	const float POS_OFFSET = -500.0 // Offset from dropship's origin

	entity dropship = Sur_GetPlaneEnt()

	vector dropshipPlayerOrigin = dropship.GetOrigin()
	dropshipPlayerOrigin.z += POS_OFFSET

	DecideRespawnPlayer( player, false )

	player.SetParent( dropship )

	player.SetOrigin( dropshipPlayerOrigin )
	player.SetAngles( dropship.GetAngles() )

	player.UnfreezeControlsOnServer()
	
	player.ForceCrouch()
	player.Hide()

	player.SetPlayerNetBool( "isJumpingWithSquad", true )
	player.SetPlayerNetBool( "playerInPlane", true )

	PlayerMatchState_Set( player, ePlayerMatchState.SKYDIVE_PRELAUNCH )

	if ( Flag( "PlaneDrop_Respawn_SetUseCallback" ) )
		AddCallback_OnUseButtonPressed( player, Survival_DropPlayerFromPlane_UseCallback )

	array<entity> playerTeam = GetPlayerArrayOfTeam( player.GetTeam() )
	bool isAlone = playerTeam.len() <= 1

	if ( isAlone )
		player.SetPlayerNetBool( "isJumpmaster", true )

	AddCinematicFlag( player, CE_FLAG_HIDE_MAIN_HUD_INSTANT )
}

void function Sequence_Playing()
{
	SetServerVar( "minimapState", IsFiringRangeGameMode() ? eMinimapState.Hidden : eMinimapState.Default )

	if ( IsFiringRangeGameMode() )
	{
		SetGameState( eGameState.WaitingForPlayers )

		foreach ( player in GetPlayerArray() )
		{
			SetRandomStagingPositionForPlayer( player )
			DecideRespawnPlayer( player )
		}

		return
	}

	if ( !GetCurrentPlaylistVarBool( "jump_from_plane_enabled", true ) )
	{
		vector pos = GetEnt( "info_player_start" ).GetOrigin()
		pos.z += 5
	
		int i = 0
		foreach ( player in GetPlayerArray() )
		{
			// circle
			float r = float(i) / float(GetPlayerArray().len()) * 2 * PI
			

			if(GetCurrentPlaylistVarBool( "dummies_horde_enabled", false ))
			{
				
				DecideRespawnPlayer( player )
				thread CreateDummies(player, false, 5, 100, 1000)
			} else if (GetCurrentPlaylistVarBool( "dummies_survival_enabled", false )){
				DecideRespawnPlayer( player )
				thread CreateDummies(player, true, 150)	
			}
			else {
				player.SetOrigin( pos + 500.0 * <sin( r ), cos( r ), 0.0> )	
				DecideRespawnPlayer( player )
			}				
	
			i++
		}

		// Show the squad and player counter
		UpdatePlayerCounts()
	}
	else
	{
		float DROP_TOTAL_TIME = GetCurrentPlaylistVarFloat( "survival_plane_jump_duration", 45.0 )
		float DROP_WAIT_TIME = GetCurrentPlaylistVarFloat( "survival_plane_jump_delay", 5.0 )
		float DROP_TIMEOUT_TIME = GetCurrentPlaylistVarFloat( "survival_plane_jump_timeout", 5.0 )

		array<vector> foundFlightPath = Survival_GeneratePlaneFlightPath()

		vector shipStart = foundFlightPath[0]
		vector shipEnd = foundFlightPath[1]
		vector shipAngles = foundFlightPath[2]
		vector shipPathCenter = foundFlightPath[3]
	
		entity centerEnt = CreatePropScript_NoDispatchSpawn( $"mdl/dev/empty_model.rmdl", shipPathCenter, shipAngles )
		centerEnt.Minimap_AlwaysShow( 0, null )
		SetTargetName( centerEnt, "pathCenterEnt" )
		DispatchSpawn( centerEnt )

		entity dropship = Survival_CreatePlane( shipStart, shipAngles )

		Sur_SetPlaneEnt( dropship )

		entity minimapPlaneEnt = CreatePropScript_NoDispatchSpawn( $"mdl/dev/empty_model.rmdl", dropship.GetOrigin(), dropship.GetAngles() )
		minimapPlaneEnt.SetParent( dropship )
		minimapPlaneEnt.Minimap_AlwaysShow( 0, null )
		SetTargetName( minimapPlaneEnt, "planeEnt" )
		DispatchSpawn( minimapPlaneEnt )

		foreach ( team in GetTeamsForPlayers( GetPlayerArray() ) )
		{
			array<entity> teamMembers = GetPlayerArrayOfTeam( team )

			bool foundJumpmaster = false
			entity ornull jumpMaster = null

			for ( int idx = teamMembers.len() - 1; idx == 0; idx-- )
			{
				entity teamMember = teamMembers[idx]

				if ( Survival_IsPlayerEligibleForJumpmaster( teamMember ) )
				{
					foundJumpmaster = true
					jumpMaster = teamMember

					break
				}
			}

			if ( !foundJumpmaster ) // No eligible jumpmasters? Shouldn't happen, but just in case
				jumpMaster = teamMembers.getrandom()

			if ( jumpMaster != null )
			{
				expect entity( jumpMaster )
		
				jumpMaster.SetPlayerNetBool( "isJumpmaster", true )			
			}
		}

		FlagSet( "SpawnInDropship" )

		foreach ( player in GetPlayerArray() )
			RespawnPlayerInDropship( player )

		// Show the squad and player counter
		UpdatePlayerCounts()

		// Update the networked duration
		float timeDoorOpenWait = CharSelect_GetOutroTransitionDuration() + DROP_WAIT_TIME
		float timeDoorCloseWait = DROP_TOTAL_TIME

		float referenceTime = Time()
		SetGlobalNetTime( "PlaneDoorsOpenTime", referenceTime + timeDoorOpenWait )
		SetGlobalNetTime( "PlaneDoorsCloseTime", referenceTime + timeDoorOpenWait + timeDoorCloseWait )

		dropship.NonPhysicsMoveTo( shipEnd, DROP_TOTAL_TIME + DROP_WAIT_TIME + DROP_TIMEOUT_TIME, 0.0, 0.0 )

		wait CharSelect_GetOutroTransitionDuration()

		wait DROP_WAIT_TIME

		FlagSet( "PlaneDrop_Respawn_SetUseCallback" )

		foreach ( player in GetPlayerArray_AliveConnected() )
			AddCallback_OnUseButtonPressed( player, Survival_DropPlayerFromPlane_UseCallback )

		wait DROP_TOTAL_TIME

		FlagClear( "PlaneDrop_Respawn_SetUseCallback" )

		FlagClear( "SpawnInDropship" )

		foreach ( player in GetPlayerArray() )
		{
			if ( player.GetPlayerNetBool( "playerInPlane" ) )
				Survival_DropPlayerFromPlane_UseCallback( player )
		}

		wait DROP_TIMEOUT_TIME

		centerEnt.Destroy()
		minimapPlaneEnt.Destroy()
		dropship.Destroy()
	}

	wait 5.0

	if ( GetCurrentPlaylistVarBool( "survival_deathfield_enabled", true ) )
		FlagSet( "DeathCircleActive" )
	
	if(!GetCurrentPlaylistVarBool( "dummies_horde_enabled", false )) //By Colombia
	{
		if ( !GetCurrentPlaylistVarBool( "match_ending_enabled", true ) || GetConVarInt( "mp_enablematchending" ) < 1 )
			WaitForever() // match never ending

	while ( GetGameState() == eGameState.Playing )
	{
		if ( GetNumTeamsRemaining() <= 1 )
		{
			int winnerTeam = GetTeamsForPlayers( GetPlayerArray_AliveConnected() )[0]
			level.nv.winningTeam = winnerTeam

			SetGameState( eGameState.WinnerDetermined )
		}
		WaitFrame()
	}

		thread Sequence_WinnerDetermined()
	} else {
		while(file.nodummiesyet){
			WaitFrame()
		}
		while ( GetGameState() == eGameState.Playing )
		{
			if ( file.aliveDummies == 0 )
			{
				int winnerTeam = GetTeamsForPlayers( GetPlayerArray_AliveConnected() )[0]
				level.nv.winningTeam = winnerTeam
				SetGameState( eGameState.WinnerDetermined )
			}
			WaitFrame()
		}

		thread Sequence_WinnerDetermined()		
	}
}
entity function CreateWallTrigger(vector pos, float box_radius = 30000 )
{
    entity map_trigger = CreateEntity( "trigger_cylinder" )
    map_trigger.SetRadius( box_radius );map_trigger.SetAboveHeight( 350 );map_trigger.SetBelowHeight( 10 );
    map_trigger.SetOrigin( pos )
    DispatchSpawn( map_trigger )
    thread FRThrowPlayerBack( map_trigger )
    return map_trigger
}

void function FRThrowPlayerBack(entity proxy, float speed = 1)
{ bool active = true
    while (active)
    {
        if(IsValid(proxy))
        {
            foreach(player in GetPlayerArray())
            {
                if (player.GetPhysics() != MOVETYPE_NOCLIP)//won't affect noclip player
                {
                    if(proxy.IsTouching(player))
						{
							player.Zipline_Stop()
							vector target_origin = player.GetOrigin()
							vector proxy_origin = proxy.GetOrigin()
							vector target_angles = player.GetAngles()
							vector proxy_angles = proxy.GetAngles()

							vector velocity = target_origin - proxy_origin
							velocity = velocity * speed

							vector angles = target_angles - proxy_angles

							velocity = velocity + angles
							player.SetVelocity(velocity)
						}
                }
            }
        } else {active = false ; break}
        wait 0.01
    } 
}

void function CreateDummies(entity player, bool isDummiesSurvival, int randomCount, float minRange = 1, float maxRange = 100)
//By Colombia
{
	file.nodummiesyet = true
	array<entity> respawnBeacons = GetEntArrayByScriptName( "script_survival_revival_chamber" )
	entity random = respawnBeacons.getrandom()
	if(!IsValid(random)) return
	vector pos = random.GetOrigin()
				
	if(!DUMMIES_HORDE_DEBUG){
	thread RespawnPlayersInDropshipAtPoint2(player, pos, player.GetAngles())
	wait 18
		while( !player.IsOnGround() )
		{
			WaitFrame()
		}
	} else {
	player.SetOrigin(<pos.x+200, pos.y, pos.z+200>)
	wait 1
	}
	
	if(!IsValid(player)) return
	
	player.p.playerDamageDealt = 0.0
	player.SetPlayerNetInt("kills", 0)
	
	SURVIVAL_AddToPlayerInventory( player, "health_pickup_health_large", 3 )
	SURVIVAL_AddToPlayerInventory( player, "health_pickup_combo_large", 3 )
	SURVIVAL_AddToPlayerInventory( player, "health_pickup_combo_small", 6 )
	SURVIVAL_AddToPlayerInventory( player, "health_pickup_combo_full", 1)
	SURVIVAL_AddToPlayerInventory( player, "health_pickup_health_small", 6)
	Inventory_SetPlayerEquipment(player, "armor_pickup_lv3", "armor")
	Inventory_SetPlayerEquipment(player, "helmet_pickup_lv3", "helmet")
	Inventory_SetPlayerEquipment(player, "backpack_pickup_lv3", "backpack")
	Inventory_SetPlayerEquipment(player, "incapshield_pickup_lv3", "incapshield")
	SURVIVAL_AddToPlayerInventory( player, "mp_weapon_frag_grenade", 6) //Todo: fix this, update ordenances
	
	player.SetShieldHealthMax( 130 )
	player.SetShieldHealth( 130 )
	player.SetHealth( 100 )
	
	if(DUMMIES_HORDE_DEBUG)
		player.SetInvulnerable()
	
	if(!isDummiesSurvival)
	entity weapon = player.GiveWeapon("mp_weapon_vinson", WEAPON_INVENTORY_SLOT_PRIMARY_0, ["optic_cq_hcog_bruiser"])
	
	// weapon.SetSkin(RandomInt(10))
	// weapon.SetCamo(RandomInt(10))
	
	player.SetActiveWeaponBySlot(eActiveInventorySlot.mainHand, WEAPON_INVENTORY_SLOT_PRIMARY_0)
	
	vector origin = player.GetOrigin()
	
	array< vector > randomSpots
	
	if(isDummiesSurvival)
	randomSpots = NavMesh_RandomPositions_LargeArea( pos, HULL_MEDIUM, randomCount, 2000, 60000 )
	else
	randomSpots = NavMesh_RandomPositions(pos, HULL_MEDIUM, randomCount, minRange, maxRange )
	
	array<string> weapons = ["mp_weapon_vinson", "mp_weapon_mastiff", "mp_weapon_energy_shotgun", "mp_weapon_lstar", "mp_weapon_wingman", "mp_weapon_hemlok"] 
	entity dummie
	foreach( spot in randomSpots )
	 {
		dummie = CreateDummy(99, spot, <0, 0, 0>)

		SetSpawnOption_AISettings( dummie, "npc_dummie_combat" )
		DispatchSpawn( dummie )
		int randomShield
	
		switch(RandomIntRangeInclusive(1,4)){
			case 1:
				randomShield = 50
				break
			case 2:
				randomShield = 75	
				break
			case 3:
				randomShield = 100	
				break
			case 4:
				randomShield = 130
				break
		}
	
		dummie.kv.fadedist = 10000
		dummie.SetShieldHealthMax( randomShield )
		dummie.SetShieldHealth( randomShield )
		dummie.SetMaxHealth( 100 )
		dummie.SetHealth( 100 )
		dummie.SetTakeDamageType( DAMAGE_YES )
		dummie.SetDamageNotifications( true )
		dummie.SetDeathNotifications( true )
		
		dummie.SetSkin(RandomInt(6))
		vector ornull clampedPos = NavMesh_ClampPointForHullWithExtents( spot, HULL_MEDIUM, < 100, 100, 300 > )

		if ( clampedPos != null )
			dummie.SetOrigin(expect vector(clampedPos))		

		SetSpawnOption_Alert(dummie)
		

		entity root = CreateScriptMover( dummie.GetOrigin(), dummie.GetAngles())
		root.SetParent(dummie)
		entity model
		if(ENABLE_CHARACTERS_DUMMIES){
		model = CreateEntity( "prop_dynamic" )
		model.SetValueForModelKey( $"mdl/humans/class/light/pilot_light_wraith.rmdl" )
		model.kv.fadedist = 10000
		model.kv.renderamt = 255
		model.kv.rendercolor = "255 255 255"
		model.SetOrigin( dummie.GetOrigin() )
		model.SetAngles( dummie.GetAngles() )
		model.kv.solid = 8
		DispatchSpawn( model )
		model.SetOrigin( dummie.GetOrigin())// + dummie.GetForwardVector()*50)
		model.SetAngles( dummie.GetAngles() )
		model.kv.CollisionGroup = TRACE_COLLISION_GROUP_PLAYER
		model.SetDamageNotifications( true )
		model.SetTakeDamageType( DAMAGE_YES )
		model.AllowMantle()
		model.SetCanBeMeleed( true )
		model.SetShieldHealthMax( 100 )
		model.SetShieldHealth( 100 )
		model.SetMaxHealth( 100 )
		model.SetHealth( 100 )
		
		model.SetParent(root)
		SetObjectCanBeMeleed( model, true )
		
		AddEntityCallback_OnDamaged(model, OnPropDamaged)
	 }
		// dummie.Minimap_SetCustomState( eMinimapObject_prop_script.DIRTY_BOMB )
		// dummie.Minimap_AlwaysShow( player.GetTeam(), null )
		// dummie.Minimap_SetAlignUpright( true )
		// dummie.Minimap_SetZOrder( MINIMAP_Z_OBJECT-1 )
		
		dummie.kv.alwaysAlert = 1
		dummie.EnableNPCFlag( NPC_NEW_ENEMY_FROM_SOUND )
		// dummie.DisableNPCFlag( NPC_ALLOW_PATROL | NPC_ALLOW_INVESTIGATE )
		// dummie.SetThinkEveryFrame(true)

		EmitSoundOnEntity(dummie, "PhaseGate_Enter_3p")
		entity weaponAi = dummie.GiveWeapon(weapons[RandomInt(weapons.len())], WEAPON_INVENTORY_SLOT_ANY)
		
		
		if(ENABLE_CHARACTERS_DUMMIES)
		{
			weaponAi.ClearParent()
			weaponAi.SetParent(model, "r_hand")
			weaponAi.SetAngles(model.GetAngles())
			dummie.kv.solid = 0
			dummie.Hide()
		}
		
		if(IsValid(dummie))
		{
			file.aliveDummies++
		}
		
		printt(spot)
		
		if(ENABLE_CHARACTERS_DUMMIES)
			thread GetNPCStateAndPlayAnimsOnProp(dummie, model, root)
		
		WaitFrame()
	 }
	 
	 Message(player, "Dummies horde", "valid dummies: " + file.aliveDummies, 5)
	 file.nodummiesyet = false
}

void function OnPropDamaged( entity ent, var damageInfo )
//By Colombia
{
	if(ent.GetClassName() != "prop_dynamic") return
	
	entity attacker = DamageInfo_GetAttacker(damageInfo)
	float damage = DamageInfo_GetDamage( damageInfo )
	
	entity mover = ent.GetParent()
	entity dummy = mover.GetParent()
	
	if(!attacker.IsPlayer() ) return
	
	attacker.p.playerDamageDealt = attacker.p.playerDamageDealt + DamageInfo_GetDamage( damageInfo )
	
	float NextShieldHealth = dummy.GetShieldHealth() - DamageInfo_GetDamage( damageInfo )
	float NextHealth = dummy.GetHealth() - DamageInfo_GetDamage( damageInfo )
	float shieldHealth = float( ent.GetShieldHealth() )
	
	if (dummy.GetShieldHealth() > 0 && IsValid(dummy)){
		DamageInfo_AddCustomDamageType( damageInfo, DF_SHIELD_DAMAGE )
		
		dummy.SetShieldHealth( maxint( 0, int( NextShieldHealth ) ) )
		if ( shieldHealth && NextShieldHealth <= 0 )
			{	
			DamageInfo_AddCustomDamageType( damageInfo, DF_SHIELD_BREAK )	
			if( IsValid( attacker ) )
				thread EmitSoundOnEntityOnlyToPlayer( attacker, attacker, "humanshield_break_1p_vs_3p" )
			}
	}
	else if (NextHealth > 0 && IsValid(dummy)){
		dummy.SetHealth(NextHealth)
	}

	//PilotShieldHealthUpdate( dummy, damageInfo)
	
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
	
	if (NextHealth < 0 && IsValid(dummy)){
		OnDummieKilled(dummy, damageInfo)
	}
}
void function LookAtEnemy(entity npc, entity mover)
{
	entity enemy = npc.GetEnemy()
	vector entityPos    = mover.GetOrigin()
	vector distance     = enemy.GetOrigin() - entityPos

	float rotY = atan(distance.y / distance.x) * 180.0 / PI
	float rotX = -atan(distance.z / sqrt(distance.y*distance.y + distance.x*distance.x)) * 180.0 / PI

	if (distance.x < 0 ) rotY = rotY + 180.0
	
	mover.NonPhysicsRotateTo( < 0, rotY, 0 > , 0.0001, 0, 0 ) 
}

void function GetNPCStateAndPlayAnimsOnProp(entity npc, entity model, entity mover)
{
//By Colombia	
	npc.EndSignal( "OnStateChange" )
	npc.EndSignal( "GetNewAnim" )
	npc.EndSignal( "OnDestroy" )
	
	OnThreadEnd(
	function() : ( npc, model, mover )
		{
			if ( IsValid( npc ) && IsValid(model))
			{
				model.Anim_Stop()
				thread GetNPCStateAndPlayAnimsOnProp(npc, model, mover)
			}
		}
	)
	
	float Duration
	string AnimToPlay
	while(IsValid(npc))
	{
		if ( !IsValid( npc ) || !IsValid(model)) break
		
		// npc.DisableNPCFlag( NPC_ALLOW_FLEE | NPC_ALLOW_HAND_SIGNALS )

		// npc.AssaultPoint( gp()[0].GetOrigin() )
		// npc.AssaultSetGoalRadius( 50 )
		// npc.AssaultSetGoalHeight( 50 )
		
		// if(npc.GetEnemy() != null)
		// {
			// dummy.SetAngles(model.GetAngles())
 			// thread LookAtEnemy(npc, mover)
		// }
		float npcVelocity = npc.GetNPCVelocity().Length()
		
		//Force mf run/walk, sometimes AI starts walking/running without this being reported to schedules!
		if(npcVelocity > 0 && npcVelocity<= 160)
		{
			AnimToPlay = "wraith_run_rifle_F" //
			model.Anim_PlayOnly( AnimToPlay )
			waitthread SendRunEndAnimSignal(npc, false)
		}
		else if(npcVelocity > 160)
		{
			AnimToPlay = "wraith_sprint_rifle"
			model.Anim_PlayOnly( AnimToPlay )
			waitthread SendRunEndAnimSignal(npc, true)
		} else if(npc.GetCurScheduleName() != npc.ai.lastSchedule) //Doing this because GetPrevScheduleName() doesn't work as expected idk Colombia
			{
			npc.ai.lastSchedule = npc.GetCurScheduleName()
				switch(npc.GetCurScheduleName()){
					case "SCHED_NONE":
					case "SCHED_REACT_SURPRISED":
					case "SCHED_REACT_JUMPED_OVER":
						AnimToPlay = "wraith_idle_pistol_ADS"
						Duration = model.GetSequenceDuration( AnimToPlay )
						model.Anim_PlayOnly( AnimToPlay )
						waitthread SendEndAnimSignal(npc)
						break
					case "SCHED_INVESTIGATE_SOUND":
						AnimToPlay = "wraith_walk_rifle_F"
						model.Anim_PlayOnly( AnimToPlay )
						waitthread SendEndAnimSignal(npc)
						break
					case "SCHED_ESTABLISH_LINE_OF_FIRE":
						AnimToPlay = "wraith_idle_rifle_ADS"
						model.Anim_PlayOnly( AnimToPlay )
						waitthread SendEndAnimSignal(npc)
						break
					case "SCHED_PATROL_PATH":
						AnimToPlay = "wraith_walk_rifle_F"
						model.Anim_PlayOnly( AnimToPlay )
						waitthread SendEndAnimSignal(npc)
						break
					case "SCHED_COMBAT_FACE":
						AnimToPlay = "wraith_idle_pistol_ADS"
						model.Anim_PlayOnly( AnimToPlay )
						waitthread SendEndAnimSignal(npc)
						break
					case "SCHED_RANGE_ATTACK1":
						AnimToPlay = "wraith_idle_pistol_ADS"
						SendEndAnimSignal(npc)
						model.Anim_PlayOnly( AnimToPlay )
						waitthread SendEndAnimSignal(npc)
						break
					case "SCHED_RANGE_ATTACK_WAIT":
						AnimToPlay = "wraith_idle_rifle_ADS"
						model.Anim_PlayOnly( AnimToPlay )
						waitthread SendEndAnimSignal(npc)
						break
					case "SCHED_MOVE_TO_ENGAGEMENT_RANGE":
						AnimToPlay = "wraith_sprint_rifle"
						Duration = model.GetSequenceDuration( AnimToPlay )
						model.Anim_PlayOnly( AnimToPlay )
						waitthread SendEndAnimSignal(npc)
						break
					case "SCHED_CHASE_ENEMY":
						if(CoinFlip())
							AnimToPlay = "wraith_run_rifle_ADS_F"
						else AnimToPlay = "wraith_run_rifle_F"
						model.Anim_PlayOnly( AnimToPlay )
						waitthread SendEndAnimSignal(npc)
						break
					case "SCHED_DIE":
						AnimToPlay = "wraith_idle_rifle"
						Duration = model.GetSequenceDuration( AnimToPlay )
						model.Anim_PlayOnly( AnimToPlay )
						waitthread SendEndAnimSignal(npc)
						break
					case "SCHED_MELEE_ATTACK1":
						AnimToPlay = "wraith_melee_kunai_punch"
						Duration = model.GetSequenceDuration( AnimToPlay )
						model.Anim_PlayOnly( AnimToPlay )
						waitthread SendEndAnimSignal(npc)
						break
					default:
						printt("New schedule detected: " + npc.GetCurScheduleName())
				 }
			}
		WaitFrame()
	}
WaitFrame()
}

void function SendRunEndAnimSignal(entity npc, bool isRunning = false){ //send signal if velocity changes
//By Colombia
	OnThreadEnd(
		function() : ( npc )
			{
				if ( IsValid( npc ) )
				{
					Signal(npc, "GetNewAnim")
				}
			}
		)

	WaitFrame()	
	while(IsValid(npc))
		{
			float npcVelocity = npc.GetNPCVelocity().Length()
			if(!IsValid(npc)) break
			if(npcVelocity <= 1) break
			if(!isRunning && npcVelocity > 160) break
			if(isRunning && npcVelocity <= 160) break
			WaitFrame()
		}
}

void function SendEndAnimSignal(entity npc){ //send signal if schedule changes
//By Colombia
	OnThreadEnd(
		function() : ( npc )
			{
				if ( IsValid( npc ) )
				{
					Signal(npc, "GetNewAnim")
				}
			}
		)

	WaitFrame()	
	while(IsValid(npc) && npc.GetCurScheduleName() == npc.ai.lastSchedule)
		{
			if(!IsValid(npc)) break
			if(npc.GetNPCVelocity().Length() >= 1) break
			WaitFrame()
		}
}

void function Sequence_WinnerDetermined()
{
	FlagSet( "DeathFieldPaused" )

	foreach ( player in GetPlayerArray() )
	{
		Remote_CallFunction_NonReplay( player, "ServerCallback_PlayMatchEndMusic" )
		Remote_CallFunction_NonReplay( player, "ServerCallback_MatchEndAnnouncement", player.GetTeam() == GetWinningTeam(), GetWinningTeam() )
	}

	wait 15.0

	thread Sequence_Epilogue()
}

void function Sequence_Epilogue()
{
	SetGameState( eGameState.Epilogue )

	UpdateMatchSummaryPersistentVars( GetWinningTeam() )

	foreach ( player in GetPlayerArray() )
	{
		player.FreezeControlsOnServer()

		// Clear all residue data
		Remote_CallFunction_NonReplay( player, "ServerCallback_AddWinningSquadData", -1, -1, 0, 0, 0, 0, 0 )

		foreach ( int i, entity champion in GetPlayerArrayOfTeam( GetWinningTeam() ) )
		{
			GameSummarySquadData gameSummaryData = GameSummary_GetPlayerData( champion )

			Remote_CallFunction_NonReplay( 
				player, 
				"ServerCallback_AddWinningSquadData", 
				i, // Champion index
				champion.GetEncodedEHandle(), // Champion EEH
				gameSummaryData.kills,
				gameSummaryData.damageDealt,
				gameSummaryData.survivalTime,
				gameSummaryData.revivesGiven,
				gameSummaryData.respawnsGiven
			)
		}

		Remote_CallFunction_NonReplay( player, "ServerCallback_ShowWinningSquadSequence" )
	}

	WaitForever()
}

void function UpdateMatchSummaryPersistentVars( int team )
{
	array<entity> squadMembers = GetPlayerArrayOfTeam( team )
	int maxTrackedSquadMembers = PersistenceGetArrayCount( "lastGameSquadStats" )

	foreach ( teamMember in squadMembers )
	{
		teamMember.SetPersistentVar( "lastGameRank", Survival_GetCurrentRank( teamMember ) )

		for ( int i = 0; i < squadMembers.len(); i++ )
		{
			if ( i >= maxTrackedSquadMembers )
				continue
			
			entity statMember = squadMembers[i]
			GameSummarySquadData statSummaryData = GameSummary_GetPlayerData( statMember )

			teamMember.SetPersistentVar( "lastGameSquadStats[" + i + "].eHandle", statMember.GetEncodedEHandle() )
			teamMember.SetPersistentVar( "lastGameSquadStats[" + i + "].kills", statSummaryData.kills )
			teamMember.SetPersistentVar( "lastGameSquadStats[" + i + "].damageDealt", statSummaryData.damageDealt )
			teamMember.SetPersistentVar( "lastGameSquadStats[" + i + "].survivalTime", statSummaryData.survivalTime )
			teamMember.SetPersistentVar( "lastGameSquadStats[" + i + "].revivesGiven", statSummaryData.revivesGiven )
			teamMember.SetPersistentVar( "lastGameSquadStats[" + i + "].respawnsGiven", statSummaryData.respawnsGiven )
		}
	}
}

void function HandleSquadElimination( int team )
{
	RespawnBeacons_OnSquadEliminated( team )
	StatsHook_SquadEliminated( GetPlayerArrayOfTeam_Connected( team ) )

	UpdateMatchSummaryPersistentVars( team )

	foreach ( player in GetPlayerArray() )
		Remote_CallFunction_NonReplay( player, "ServerCallback_SquadEliminated", team )
}

// Fully doomed, no chance to respawn, game over
void function PlayerFullyDoomed( entity player )
{
	player.p.respawnChanceExpiryTime = Time()
	player.p.squadRank = Survival_GetCurrentRank( player )

	StatsHook_RecordPlacementStats( player )
}

void function OnPlayerDamaged( entity victim, var damageInfo )
{
	if ( !IsValid( victim ) || !victim.IsPlayer() || Bleedout_IsBleedingOut( victim ) )
		return

	int sourceId = DamageInfo_GetDamageSourceIdentifier( damageInfo )
	if ( sourceId == eDamageSourceId.bleedout || sourceId == eDamageSourceId.human_execution )
		return

	float damage = DamageInfo_GetDamage( damageInfo )

	
	int currentHealth = victim.GetHealth()
	if ( !( DamageInfo_GetCustomDamageType( damageInfo ) & DF_BYPASS_SHIELD ) )
		currentHealth += victim.GetShieldHealth()

	if ( currentHealth - damage <= 0 && PlayerRevivingEnabled() && !IsInstantDeath(damageInfo) )
	{
		entity attacker = DamageInfo_GetAttacker( damageInfo )

		// Supposed to be bleeding
		Bleedout_StartPlayerBleedout( victim, DamageInfo_GetAttacker( damageInfo ) )

		// Add the cool splashy blood and big red crosshair hitmarker
		DamageInfo_AddCustomDamageType( damageInfo, DF_KILLSHOT )

		// Notify the player of the damage (even though it's *technically* canceled and we're hijacking the damage in order to not make an alive 100hp player instantly dead with a well placed kraber shot)
		if( attacker.IsPlayer() && !IsWorldSpawn(attacker) )
		{
			// Notify the player of the damage (even though it's *technically* canceled and we're hijacking the damage in order to not make an alive 100hp player instantly dead with a well placed kraber shot)
			attacker.NotifyDidDamage( victim, DamageInfo_GetHitBox( damageInfo ), DamageInfo_GetDamagePosition( damageInfo ), DamageInfo_GetCustomDamageType( damageInfo ), DamageInfo_GetDamage( damageInfo ), DamageInfo_GetDamageFlags( damageInfo ), DamageInfo_GetHitGroup( damageInfo ), DamageInfo_GetWeapon( damageInfo ), DamageInfo_GetDistFromAttackOrigin( damageInfo ) )
		}
		// Cancel the damage
		// Setting damage to 0 cancels all knockback, setting it to 1 doesn't
		// There might be a better way to do this, but this works well enough
		DamageInfo_SetDamage( damageInfo, 1 )

		// Delete any shield health remaining
		victim.SetShieldHealth( 0 )

		// Run client callback
		int scriptDamageType = DamageInfo_GetCustomDamageType( damageInfo )

		foreach ( cbPlayer in GetPlayerArray() )
			Remote_CallFunction_Replay( cbPlayer, "ServerCallback_OnEnemyDowned", attacker, victim, scriptDamageType, sourceId )
	}
}

array<ConsumableInventoryItem> function GetAllDroppableItems( entity player )
{
	array<ConsumableInventoryItem> final = []

	// Consumable inventory
	final.extend( SURVIVAL_GetPlayerInventory( player ) )

	// Weapon related items
	foreach ( weapon in SURVIVAL_GetPrimaryWeapons( player ) )
	{
		LootData data = SURVIVAL_GetLootDataFromWeapon( weapon )
		if ( data.ref == "" )
			continue

		// Add the weapon
		ConsumableInventoryItem item
		
		item.type = data.index
		item.count = weapon.GetWeaponPrimaryClipCount()

		final.append( item )

		foreach ( esRef, mod in GetAllWeaponAttachments( weapon ) )
		{
			if ( !SURVIVAL_Loot_IsRefValid( mod ) )
				continue
			
			if ( data.baseMods.contains( mod ) )
				continue

			LootData attachmentData = SURVIVAL_Loot_GetLootDataByRef( mod )

			// Add the attachment
			ConsumableInventoryItem attachmentItem
			
			attachmentItem.type = attachmentData.index
			attachmentItem.count = 1

			final.append( attachmentItem )
		}
	}

	// Non-weapon equipment slots
	foreach ( string ref, EquipmentSlot es in EquipmentSlot_GetAllEquipmentSlots() )
	{
		if ( EquipmentSlot_IsMainWeaponSlot( ref ) || EquipmentSlot_IsAttachmentSlot( ref ) )
			continue

		LootData data = EquipmentSlot_GetEquippedLootDataForSlot( player, ref )
		if ( data.ref == "" )
			continue

		// Add the equipped loot
		ConsumableInventoryItem equippedItem

		equippedItem.type = data.index
		equippedItem.count = 1

		final.append( equippedItem )
	}

	return final
}

void function CreateSurvivalDeathBoxForPlayer( entity victim, entity attacker, var damageInfo )
{
	entity deathBox = SURVIVAL_CreateDeathBox( victim, true )

	foreach ( invItem in GetAllDroppableItems( victim ) )
	{
		LootData data = SURVIVAL_Loot_GetLootDataByIndex( invItem.type )

		entity loot = SpawnGenericLoot( data.ref, deathBox.GetOrigin(), deathBox.GetAngles(), invItem.count )
		AddToDeathBox( loot, deathBox )
	}

	UpdateDeathBoxHighlight( deathBox )

	foreach ( func in svGlobal.onDeathBoxSpawnedCallbacks )
		func( deathBox, attacker, damageInfo != null ? DamageInfo_GetDamageSourceIdentifier( damageInfo ) : 0 )
}

void function OnPlayerKilled( entity victim, entity attacker, var damageInfo )
{
	if ( !IsValid( victim ) || !IsValid( attacker ) || !victim.IsPlayer() )
		return

	if ( IsFiringRangeGameMode() )
	{
		thread function() : ( victim )
		{
			wait 5.0

			SetRandomStagingPositionForPlayer( victim )
			DecideRespawnPlayer( victim )
		}()

		return
	}

	SetPlayerEliminated( victim )
	PlayerStartSpectating( victim, attacker )

	int victimTeamNumber = victim.GetTeam()
	array<entity> victimTeam = GetPlayerArrayOfTeam_Alive( victimTeamNumber )
	bool teamEliminated = victimTeam.len() == 0

	bool canPlayerBeRespawned = PlayerRespawnEnabled() && !teamEliminated

	// PlayerFullyDoomed MUST be called before HandleSquadElimination
	// HandleSquadElimination accesses player.p.respawnChanceExpiryTime which is set by PlayerFullyDoomed
	// if it isn't called in this order, the survivalTime will be 0
	if ( !canPlayerBeRespawned )
		PlayerFullyDoomed( victim )
	
	if ( teamEliminated )
		HandleSquadElimination( victim.GetTeam() )

	int droppableItems = GetAllDroppableItems( victim ).len()

	if ( canPlayerBeRespawned || droppableItems > 0 )
		CreateSurvivalDeathBoxForPlayer( victim, attacker, damageInfo )
		
	if( RandomInt( 100 ) >= 50 )
		thread PlayBattleChatterLineDelayedToSpeakerAndTeam( attacker, "bc_iKilledAnEnemy", 2.0 )
}

void function OnClientConnected( entity player )
{
	array<entity> playerTeam = GetPlayerArrayOfTeam( player.GetTeam() )
	bool isAlone = playerTeam.len() <= 1

	playerTeam.fastremovebyvalue( player )

	player.p.squadRank = 0

	AddEntityCallback_OnDamaged( player, OnPlayerDamaged )

	switch ( GetGameState() )
	{
		case eGameState.Prematch:
			if ( IsValid( Sur_GetPlaneEnt() ) )
				RespawnPlayerInDropship( player )

			break
		case eGameState.Playing:
			if ( !player.GetPlayerNetBool( "hasLockedInCharacter" ) )
				// Joined too late, assign a random legend so everything runs fine
				CharacterSelect_TryAssignCharacterCandidatesToPlayer( player, [] )

			if ( IsFiringRangeGameMode() )
			{
				PlayerMatchState_Set( player, ePlayerMatchState.STAGING_AREA )

				SetRandomStagingPositionForPlayer( player )
				DecideRespawnPlayer( player )
			}
			else if ( Flag( "SpawnInDropship" ) )
				RespawnPlayerInDropship( player )
			else
			{
				PlayerMatchState_Set( player, ePlayerMatchState.NORMAL )

				if ( IsPlayerEliminated( player ) )
					PlayerStartSpectating( player, null )
				else
				{
					array<entity> respawnCandidates = isAlone ? GetPlayerArray_AliveConnected() : playerTeam
					respawnCandidates.fastremovebyvalue( player )

					if ( respawnCandidates.len() == 0 )
						break

					vector origin = respawnCandidates.getrandom().GetOrigin()

					DecideRespawnPlayer( player )

					player.SetOrigin( origin )
				}
			}

			break
	}
}

void function Survival_SetFriendlyOwnerHighlight( entity player, entity characterModel )
{

}

void function SURVIVAL_AddSpawnPointGroup( string ref )
{

}

void function RateSpawnpoints_Directional( int checkClass, array<entity> spawnpoints, int team, entity player )
{

}

bool function SURVIVAL_IsCharacterClassLocked( entity player )
{
	return player.GetPlayerNetBool( "hasLockedInCharacter" ) || player.GetPlayerNetInt( "characterSelectLockstepPlayerIndex" ) != GetGlobalNetInt( "characterSelectLockstepIndex" )
}

bool function SURVIVAL_IsValidCircleLocation( vector origin )
{
	return false
}

int function _GetSquadRank( entity player )
{
	return player.p.squadRank
}

void function JetwashFX( entity dropship )
{

}

void function Survival_PlayerRespawnedTeammate( entity playerWhoRespawned, entity respawnedPlayer )
{
	playerWhoRespawned.p.respawnsGiven++

	respawnedPlayer.p.respawnChanceExpiryTime = 0.0
	ClearPlayerEliminated( respawnedPlayer )

	StatsHook_PlayerRespawnedTeammate( playerWhoRespawned, respawnedPlayer )
}

void function UpdateDeathBoxHighlight( entity box )
{
	int highestTier = 0

	foreach ( item in box.GetLinkEntArray() )
	{
		LootData data = SURVIVAL_Loot_GetLootDataByIndex( item.GetSurvivalInt() )
		if ( data.ref == "" )
			continue

		if ( data.tier > highestTier )
			highestTier = data.tier
	}

	box.SetNetInt( "lootRarity", highestTier )
	Highlight_SetNeutralHighlight( box, SURVIVAL_GetHighlightForTier( highestTier ) )

	foreach ( player in GetPlayerArray() )
		Remote_CallFunction_Replay( player, "ServerCallback_RefreshDeathBoxHighlight" )
}

float function Survival_GetMapFloorZ( vector field )
{
	field.z = SURVIVAL_GetPlaneHeight()
	vector endOrigin = field - < 0, 0, 50000 >
	TraceResults traceResult = TraceLine( field, endOrigin, [], TRACE_MASK_NPCWORLDSTATIC, TRACE_COLLISION_GROUP_NONE )
	vector endPos = traceResult.endPos
	return endPos.z
}

vector function SURVIVAL_GetClosestValidCircleEndLocation( vector origin )
{
	return origin
}

void function SURVIVAL_CalculateAirdropPositions()
{
    calculatedAirdropData.clear()
    
    array<vector> previousAirdrops
    
    array<DeathFieldStageData> deathFieldData = SURVIVAL_GetDeathFieldStages()
    
    for ( int i = deathFieldData.len() - 1; i >= 0; i-- )
    {
        string airdropPlaylistData = GetCurrentPlaylistVarString( "airdrop_data_round_" + i, "" )
        
        if (airdropPlaylistData.len() == 0) //if no airdrop data for this ring, continue to next
            continue;
            
        //Split the PlaylistVar that we can parse it
        array<string> dataArr = split(airdropPlaylistData, ":" )
        if(dataArr.len() < 5)
            return;
         
        //First part of the playlist string is the number of airdrops for this round.
        int numAirdropsForThisRound = dataArr[0].tointeger()
        
        //Create our AirdropData entry now.
        AirdropData airdropData;
        airdropData.dropCircle = i
        airdropData.dropCount = numAirdropsForThisRound
        airdropData.preWait = dataArr[1].tofloat()

        //Get the deathfield data.
        DeathFieldStageData data = deathFieldData[i]
       
        vector center = data.endPos
        float radius = data.endRadius
        for (int j = 0; j < numAirdropsForThisRound; j++)
        {
            Point airdropPoint = FindRandomAirdropDropPoint(AIRDROP_ANGLE_DEVIATION, center, radius, previousAirdrops)
            
            if(!VerifyAirdropPoint( airdropPoint.origin, airdropPoint.angles.y ))
            {
                //force this to loop again if we didn't verify our airdropPoint
                j--;
            }
            else
            {
                previousAirdrops.push(airdropPoint.origin)
                printt("Added airdrop with origin ", airdropPoint.origin, " to the array")
                airdropData.originArray.append(airdropPoint.origin)
                airdropData.anglesArray.append(airdropPoint.angles)
                
                //Should impl contents here.
                airdropData.contents.append([dataArr[2], dataArr[3], dataArr[4]])
            }  
        }
        calculatedAirdropData.append(airdropData)
    }
    thread AirdropSpawnThink()
}

void function SURVIVAL_AddLootBin( entity lootbin )
{
	// InitLootBin( lootbin )
}

void function SURVIVAL_AddLootGroupRemapping( string hovertank, string supplyship )
{
	
}

void function SURVIVAL_DebugLoot( string lootBinsLootInside, vector origin )
{

}

void function Survival_AddCallback_OnAirdropLaunched( void functionref( entity dropPod, vector origin ) callbackFunc )
{

}

void function Survival_CleanupPlayerPermanents( entity player )
{
	
}
