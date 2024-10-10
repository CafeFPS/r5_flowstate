//Flowstate Lightning Gun
//Made by @CafeFPS
//mkos - persistence (cafe is the goat)
//-- everyone else: advice

untyped 

global function OnWeaponPrimaryAttack_Clickweapon
global function OnWeaponActivate_Clickweapon
global function OnWeaponDeactivate_Clickweapon

global function Clickweapon_Init

#if CLIENT
	//for settings ui
	global function LGDuels_SetR
	global function LGDuels_SetG
	global function LGDuels_SetB
	
	global function LGDuels_SetSettingsMenuOpen
	global function LGDuels_SetModifyingLocalBeam
	global function LGDuels_SetPresetRed
	global function LGDuels_SetPresetGreen
	global function LGDuels_SetPresetYellow
	global function LGDuels_SetPresetBlue
	global function LGDuels_SetPresetPurple
	global function LGDuels_SetFromPersistence
	global function LGDuels_UpdateSettings
	global function LGDuels_SaveToServerPersistence

	global function ServerCallback_CreatesLaserFXFromServer
	
	#if DEVELOPER 
		global function DEV_PrintBeams
	#endif 

	int DesiredR = 89
	int DesiredG = 232
	int DesiredB = 37
	int DesiredEnemyR = 252
	int DesiredEnemyG = 3
	int DesiredEnemyB = 227
	vector chosenColor
	vector chosenEnemyColor
	float positionOffset = -30
	bool isSettingsMenuOpen = false
	bool modifyingLocalBeam = true
#endif //CLIENT

const asset TheBestAssetInTheGame 	= $"P_tesla_trap_link_CP"
const asset expAsset = $"P_plasma_exp_SM"
const asset railjumpAsset = $"P_plasma_exp_SM"
const float LG_SINGLE_FIRE_DEBOUNCE = 0.6 //Increased fire rate
const float LG_DRAG_TIME			= 0.45 //Increased the time the fx is alive 
const float LG_MAX_DISTANCE_RAILJUMP_TRACE = 400
const float LG_RAILJUMP_COOLDOWN = 1.0

struct BeamSettings 
{
	#if CLIENT 

		float offset = -30
		int R = 0
		int G = 0
		int B = 0

	#endif 
}

struct
{
	#if CLIENT
		table<entity, int> beamsFxs = {}
		table<entity, entity> handmover
		table<entity, entity> beammover
		table<string, BeamSettings > allBeamSettings = {} // string: local/enemy
	#endif
	
	bool isInstaGib
	
	#if SERVER || CLIENT
		bool isAimTrainer
	#endif // SERVER || CLIENT
} file

void function Clickweapon_Init()
{
	RegisterSignal( "EndLaser" )
	RegisterSignal( "EndNoAutoThread" )
	RegisterSignal( "PlayerStartShotingLightningGun" )
	RegisterSignal( "RestartAirborne" )
	PrecacheParticleSystem( expAsset )
	PrecacheParticleSystem( railjumpAsset )
	
	#if CLIENT
		AddCreateCallback( "player", FS_LG_OnPlayerCreated )
		AddDestroyCallback( "player", FS_LG_OnPlayerDestroyed )
		
		chosenColor = < DesiredR, DesiredG, DesiredB >
		
		SetConVarInt( "fs_lightning_gun_color_r", DesiredR )
		SetConVarInt( "fs_lightning_gun_color_g", DesiredG )
		SetConVarInt( "fs_lightning_gun_color_b", DesiredB )
		chosenEnemyColor = < DesiredEnemyR, DesiredEnemyG, DesiredEnemyB >
		
		RegisterConCommandTriggeredCallback( "+zoom", LGUN_TryRailJump ) //improve this by registering/deregistering properly in activate/deactivate. Cafe
	#endif
	
	#if SERVER
		AddCallback_OnWeaponAttack( FS_LG_PlayerStartShooting )
		AddClientCommandCallback("PlayerTryRailJump", ClientCommand_FS_LG_TryRailJump )
	#endif
	
	#if SERVER || CLIENT 
		file.isInstaGib 	= 	Playlist() == ePlaylists.fs_dm_fast_instagib
		file.isAimTrainer 	= 	Gamemode() == eGamemodes.fs_aimtrainer
	#endif
}

#if DEVELOPER && CLIENT
void function DEV_PrintBeams()
{
	foreach ( ent, i in file.beamsFxs )
	{
		printt( ent + " --- " + i )
	}
}
#endif //DEVELOPER && CLIENT

#if SERVER
bool function ClientCommand_FS_LG_TryRailJump(entity player, array<string> args )
{
	if( !LGUN_CanPlayerRailjump( player ) )
		return true

	return true
}


void function LGUN_Airborne( entity player )
{
	if ( !IsValid( player ) || !player.IsPlayer() )
		return

	Signal( player, "RestartAirborne" )
	EndSignal( player, "RestartAirborne" )
	EndSignal( player, "OnDeath" )
	
	player.SetOneHandedWeaponUsageOn()
	EmitSoundOnEntityExceptToPlayer( player, player, "boost_freefall_body_3p" )
	EmitSoundOnEntityExceptToPlayer( player, player, "JumpPad_Ascent_Windrush" )
	EmitSoundOnEntityOnlyToPlayer( player, player, "boost_freefall_body_1p" )

	array<entity> jumpJetFXs
	array<string> attachments = [ "vent_left", "vent_right" ]
	int team                  = player.GetTeam()
	foreach ( attachment in attachments )
	{
		int friendlyID    = GetParticleSystemIndex( TEAM_JUMPJET_DBL )
		entity friendlyFX = StartParticleEffectOnEntity_ReturnEntity( player, friendlyID, FX_PATTACH_POINT_FOLLOW, player.LookupAttachment( attachment ) )
		friendlyFX.SetOwner( player )
		SetTeam( friendlyFX, team )
		
		friendlyFX.RemoveFromAllRealms()
		friendlyFX.AddToOtherEntitysRealms( player )
		
		friendlyFX.kv.VisibilityFlags = (ENTITY_VISIBLE_TO_FRIENDLY | ENTITY_VISIBLE_TO_ENEMY)
		jumpJetFXs.append( friendlyFX )

		int enemyID    = GetParticleSystemIndex( ENEMY_JUMPJET_DBL )
		entity enemyFX = StartParticleEffectOnEntity_ReturnEntity( player, enemyID, FX_PATTACH_POINT_FOLLOW, player.LookupAttachment( attachment ) )
		enemyFX.SetOwner( player )
		SetTeam( enemyFX, team )
		enemyFX.kv.VisibilityFlags = (ENTITY_VISIBLE_TO_FRIENDLY | ENTITY_VISIBLE_TO_ENEMY)

		enemyFX.RemoveFromAllRealms()
		enemyFX.AddToOtherEntitysRealms( player )
		
		jumpJetFXs.append( enemyFX )
	}
	
	OnThreadEnd(
		function() : ( jumpJetFXs, player )
		{
			if ( IsValid( player ) )
			{
				StopSoundOnEntity( player, "JumpPad_Ascent_Windrush" )
				StopSoundOnEntity( player, "boost_freefall_body_3p" )
				StopSoundOnEntity( player, "boost_freefall_body_1p" )
				
				player.SetOneHandedWeaponUsageOff()
			}
			
			// if( IsValid( mover ) )
				// mover.Destroy()
			
			foreach ( fx in jumpJetFXs )
			{
				if ( IsValid( fx ) )
					fx.Destroy()
			}
		}
	)

	WaitFrame()
	wait 0.1
	
	while( IsValid(player) && !player.IsOnGround() )
	{
		WaitFrame()
	}
}
#endif

bool function LGUN_CanPlayerRailjump( entity player ) //Cafe
{
	if( !IsValid( player ) || !IsAlive( player ) || player.ContextAction_IsActive() )
		return false
	
	if( GetGameState() != eGameState.Playing )
		return false
	
	entity weapon = player.GetActiveWeapon( eActiveInventorySlot.mainHand )
	
	if( !IsValid( weapon ) || weapon.GetWeaponClassName() != "mp_weapon_lightninggun" )
		return false

	if( !file.isInstaGib ) //Fixme. Cafe
		return false
	
	if( Time() - player.p.lastTimeUsedRailjump < LG_RAILJUMP_COOLDOWN )
		return false
	
	vector viewVec = player.GetViewVector()
	viewVec.Normalize()
	
	if( viewVec.z > 0 )
		return false
	
	vector traceEnd = player.EyePosition() + ( player.GetViewVector() * 50000)
	TraceResults trace = TraceLineHighDetail( player.EyePosition(), traceEnd, [player], TRACE_MASK_SOLID, TRACE_COLLISION_GROUP_NONE )
	float traceDistance = Distance( player.EyePosition(), trace.endPos )
	
	
	if( traceDistance > LG_MAX_DISTANCE_RAILJUMP_TRACE )
		return false
	
	float distanceValue = min( traceDistance, LG_MAX_DISTANCE_RAILJUMP_TRACE )
	distanceValue = distanceValue / LG_MAX_DISTANCE_RAILJUMP_TRACE
	printw( "Distance to the endPos", traceDistance, distanceValue )
	
	if( distanceValue < 0.1 )
		return false

	player.p.lastTimeUsedRailjump = Time()
	
	weapon.StartCustomActivity("ACT_VM_DRAWFIRST", 0)
	player.KnockBack( player.GetViewVector() * -800 * ( 1 - distanceValue ) , 0.1 )
	
	StartParticleEffectInWorld( GetParticleSystemIndex( railjumpAsset ), trace.endPos, <0, 0, 0> ) //Explosion
	
	#if SERVER
	thread LGUN_Airborne( player )
	#endif
	
	return true
}

#if CLIENT
void function LGUN_TryRailJump( entity player )
{
	if( player != GetLocalClientPlayer() )
		return
	
	entity weapon = player.GetActiveWeapon( eActiveInventorySlot.mainHand )
	
	if( !IsValid( weapon ) || weapon.GetWeaponClassName() != "mp_weapon_lightninggun" )
		return

	if( !file.isInstaGib ) //Fixme. Cafe
		return
	
	if( !LGUN_CanPlayerRailjump( player ) )
		return
	
	//temp
	OnLocalPlayerShoot( player, player.EyePosition(), player.GetViewVector(), true )
			
	
	printw("railjump")
	player.ClientCommand("PlayerTryRailJump")
}

void function ServerCallback_CreatesLaserFXFromServer( entity fromPlayer, vector origin, vector direction )
{
	if( fromPlayer != GetLocalViewPlayer() )
	{
		OnEnemyPlayerShoot( fromPlayer, origin, direction ) //this method should ensure correct endpos for the laser (the actual hitscan weapon endpos and not a predicted one) Cafe
	}
}

void function OnLocalPlayerShoot( entity player, vector origin, vector direction, bool isRailjump = false )
{
	entity weapon = player.GetActiveWeapon( eActiveInventorySlot.mainHand )
	
	if( !IsValid( weapon ) || weapon.GetWeaponClassName() != "mp_weapon_lightninggun" )
		return

	if( !file.isInstaGib || player != GetLocalViewPlayer() )
		return

	vector traceEnd = origin + (direction * 50000)
	TraceResults trace = TraceLineHighDetail( origin, traceEnd, player, TRACE_MASK_SHOT, TRACE_COLLISION_GROUP_NONE )

	entity moverForLaserEnt = CreateClientsideScriptMover( $"mdl/dev/empty_model.rmdl", <0, 0, 0>, <0, 0, 0> )
	moverForLaserEnt.SetOrigin( ClampToWorldspace( trace.endPos ) )
	
	entity moverForHand = CreateClientsideScriptMover( $"mdl/dev/empty_model.rmdl", <0, 0, 0>, <0, 0, 0> )

	entity viewmodel = weapon.GetWeaponViewmodel()

	if( IsValid( viewmodel ) )
	{
		if( weapon.LookupViewModelAttachment( "CAFEWASHERE" ) > 0 )
			moverForHand.SetParent( viewmodel, "CAFEWASHERE" ) //I'm insane
	}
	
	if( player.IsThirdPersonShoulderModeOn() || !IsValid( viewmodel ) )
	{
		if( player.LookupAttachment( "R_HAND" ) > 0 )
			moverForHand.SetParent( player, "R_HAND" )
	}
	
	int fxIDTeam = GetParticleSystemIndex( TheBestAssetInTheGame )

	int localFx = StartParticleEffectOnEntityWithPos( moverForHand, fxIDTeam, FX_PATTACH_CUSTOMORIGIN_FOLLOW, -1, <0, 0, 0>, <0, 0, 0> )
	EffectSetDontKillForReplay( localFx )
	EffectAddTrackingForControlPoint( localFx, 1, moverForLaserEnt, FX_PATTACH_CUSTOMORIGIN_FOLLOW, -1, <0, 0, 0> )
	if( !isRailjump )
		EffectSetControlPointVector( localFx, 2, chosenColor )
	else
		EffectSetControlPointVector( localFx, 2, <255,255,255> )
	
	moverForHand.ClearParent() //to leave the fx alive for a moment
	
	if( !isRailjump )
		StartParticleEffectInWorldWithHandle( GetParticleSystemIndex( expAsset ), trace.endPos, <0, 0, 0> ) //Explosion
	// else
		// StartParticleEffectInWorldWithHandle( GetParticleSystemIndex( railjumpAsset ), trace.endPos, <0, 0, 0> ) //Explosion
	
	thread function () : ( localFx )
	{
		float endtime = Time() + LG_DRAG_TIME
		
		while( Time() < endtime )
			WaitFrame()
		
		EffectStop( localFx, false, true )
	}()
}

void function OnEnemyPlayerShoot( entity player, vector origin, vector direction )
{
	entity weapon = player.GetActiveWeapon( eActiveInventorySlot.mainHand )
	
	if( !IsValid( weapon ) || weapon.GetWeaponClassName() != "mp_weapon_lightninggun" )
		return

	if( !file.isInstaGib ) //Fixme. Cafe
		return

	vector traceEnd = origin + (direction * 50000)

	TraceResults trace = TraceLineHighDetail( origin, traceEnd, player, TRACE_MASK_SHOT, TRACE_COLLISION_GROUP_NONE )

	entity mover = CreateClientsideScriptMover( $"mdl/dev/empty_model.rmdl", <0, 0, 0>, <0, 0, 0> )
	mover.SetOrigin( ClampToWorldspace( trace.endPos ) )
	
	entity handmover = CreateClientsideScriptMover( $"mdl/dev/empty_model.rmdl", <0, 0, 0>, <0, 0, 0> )
	handmover.SetOrigin( origin )

	int laserStoreMe = StartParticleEffectOnEntityWithPos( handmover, GetParticleSystemIndex( TheBestAssetInTheGame ), FX_PATTACH_ABSORIGIN_FOLLOW, -1, <0, 0, 0>, <0, 0, 0> )
	StartParticleEffectInWorldWithHandle( GetParticleSystemIndex( expAsset ), mover.GetOrigin(), <0, 0, 0> ) //Explosion
	
	thread function () : ( laserStoreMe, player, mover, handmover )
	{
		wait LG_DRAG_TIME
		if( EffectDoesExist( laserStoreMe ) )
			EffectStop( laserStoreMe, false, true )
		
		if( IsValid( mover ) )
			mover.Destroy()
		
		if( IsValid( handmover ) )
			handmover.Destroy()
	}()
	
	EffectSetDontKillForReplay( laserStoreMe )
	
	if( player.GetTeam() != GetLocalViewPlayer().GetTeam() )
		EffectSetControlPointVector( laserStoreMe, 2, chosenEnemyColor )
	else
		EffectSetControlPointVector( laserStoreMe, 2, chosenColor )

	EffectAddTrackingForControlPoint( laserStoreMe, 1, mover, FX_PATTACH_ABSORIGIN_FOLLOW, -1, <0, 0, 3> )

	#if DEVELOPER
	Warning( player + " 3p shot fx created" )
	#endif
}

void function LGDuels_UpdateSettings( bool isLocal = true, ... )
{
	CheckBeamSettingsExist() //maybe only init in playercreated
	
	// The following code assumes float is used for offset and passed to this function by itself
	// It also assumes RGB are passed as int arguments and in the correct order in passed parameters
	// as vargs 0, 1, 2
	
	for ( int i = 0; i <= vargc - 1; i++)
	{
		string typ = typeof( vargv[i] )
		
		switch( typ )
		{
			case "float":
			
				switch( isLocal )
				{
					case true: 
						file.allBeamSettings["local"].offset = expect float( vargv[i] )
						//printt("kewl offset was changed to ", vargv[i] )
						break
					case false: file.allBeamSettings["enemy"].offset = expect float( vargv[i] )
						break
				}
				
				break
				
			case "int":
				
				switch( i )
				{
					case 0:	
					
						switch( isLocal )
						{
							case true: file.allBeamSettings["local"].R = expect int( vargv[i] ); break
							case false: file.allBeamSettings["enemy"].R = expect int( vargv[i] ); break
						}
						
						break
						
					case 1:
					
						switch( isLocal )
						{
							case true: file.allBeamSettings["local"].G = expect int( vargv[i] ); break
							case false: file.allBeamSettings["enemy"].G = expect int( vargv[i] ); break
						}
						
						break
						
					case 2:
					
						switch( isLocal )
						{
							case true: file.allBeamSettings["local"].B = expect int( vargv[i] ); break
							case false: file.allBeamSettings["enemy"].B = expect int( vargv[i] ); break
						}
						
						break
				}
			
				default:
					break
				
		}
	}
}

void function CheckBeamSettingsExist()
{	
	if( !( "local" in file.allBeamSettings ) )
	{
		BeamSettings localSettings
	
		localSettings.offset = -30
		localSettings.R = 89
		localSettings.G = 232
		localSettings.B = 37
		
		file.allBeamSettings["local"] <- localSettings
	}
	
	if( !( "enemy" in file.allBeamSettings ) )
	{
		BeamSettings enemySettings
	
		enemySettings.offset = -30
		enemySettings.R = 252
		enemySettings.G = 3
		enemySettings.B = 227
		
		file.allBeamSettings["enemy"] <- enemySettings
	}
}
#endif

// #if CLIENT 
	// void function DEV_DebuggerThread( entity player, entity weapon )
	// {
		// EndSignal( player, "EndLaser" )
		
		// OnThreadEnd
		// (
			// void function()
			// {
				// Warning( "-- CHECKER IS DOWN -----------------------" )
			// }
		// )
		
		// float oldTime = weapon.GetNextAttackAllowedTime()
		
		// for( ; ; )
		// {
			// WaitFrame()
			
			// float newTime = weapon.GetNextAttackAllowedTime()
			
			// if( oldTime != newTime )
			// {
				// printw( "Time was changed! old=", oldTime, "new =", newTime )
				// oldTime = newTime
			// }
		// }
	// }
// #endif

void function OnWeaponCustomActivityStart_weapon_lightninggun( entity weapon )
{
	if ( !IsValid( weapon ) )
		return

	entity player = weapon.GetWeaponOwner()
	if ( !IsValid( player ) )
		return 

	printt( "OnWeaponCustomActivityStart_weapon_lightninggun" )
}

void function OnWeaponCustomActivityEnd_weapon_lightninggun( entity weapon )
{
	if ( !IsValid( weapon ) )
		return

	printt( "OnWeaponCustomActivityEnd_weapon_lightninggun" )
}

void function OnWeaponActivate_Clickweapon( entity weapon ) 
{
	#if CLIENT
		if ( InPrediction() && !IsFirstTimePredicted() )
			return

		entity player = GetLocalViewPlayer()

		if( !IsValid( weapon ) || weapon.GetWeaponClassName() != "mp_weapon_lightninggun" )
			return

		bool isAuto = !weapon.GetWeaponSettingBool( eWeaponVar.is_semi_auto ) //same ile.isInstaGibwhich will be replaced with no auto weapon.
		
		//This logic is only for the auto weapon
		thread function () : ( weapon, player, isAuto ) 
		{
			Signal( player, "EndLaser" )
			EndSignal( player, "EndLaser" )

			EndSignal( weapon, "OnDestroy" )
			EndSignal( player, "OnDeath" )
			EndSignal( player, "OnDestroy" )
				
			if( player.p.lightningGunReady == false ) //to sync effect from weapon swap.
			{
				while( !weapon.IsReadyToFire() )
					WaitFrame()
			}

			while( true )
			{
				if( weapon.IsReadyToFire() || player.p.lightningGunReady )
				{
					// Warning( "CHECK FOR ATTACK , allowed= " + currentAttackTime + " ,weaponnext= " + weapon.GetNextAttackAllowedTime() + " ,Time= " + Time() )
					// DEV_SetBreakPoint()
					
					if( player.IsInputCommandHeld( IN_ATTACK ) && isAuto || isSettingsMenuOpen && modifyingLocalBeam )
					{
						vector origin = ClampToWorldspace( player.GetCrosshairTraceEndPos() )
						
						entity moverForLaserEnt 
						
						if( !(player in file.beammover) || player in file.beammover && !IsValid( file.beammover[player] ) )
							file.beammover[player] <- CreateClientsideScriptMover( $"mdl/dev/empty_model.rmdl", <0, 0, 0>, <0, 0, 0> )

						moverForLaserEnt = file.beammover[ player ]
						moverForLaserEnt.SetOrigin( origin )
						
						entity moverForHand
						if( !(player in file.handmover) || player in file.handmover && !IsValid( file.handmover[player] ) )
							file.handmover[player] <- CreateClientsideScriptMover( $"mdl/dev/empty_model.rmdl", <0, 0, 0>, <0, 0, 0> )

						entity viewmodel = weapon.GetWeaponViewmodel()
						
						moverForHand = file.handmover[ player ]
						
						if( IsValid( viewmodel ) )
						{
							if( weapon.LookupViewModelAttachment( "CAFEWASHERE" ) > 0 )
								moverForHand.SetParent( viewmodel, "CAFEWASHERE" ) //I'm insane
						}
						
						if( player.IsThirdPersonShoulderModeOn() || !IsValid( viewmodel ) )
						{
							if( player.LookupAttachment( "R_HAND" ) > 0 )
								moverForHand.SetParent( player, "R_HAND" )
						}
						
						int fxIDTeam = GetParticleSystemIndex( TheBestAssetInTheGame )
						
						if( !EffectDoesExist( file.beamsFxs[ player ] ) || !isAuto && !isSettingsMenuOpen )
						{
							file.beamsFxs[ player ] = StartParticleEffectOnEntityWithPos( moverForHand, fxIDTeam, FX_PATTACH_CUSTOMORIGIN_FOLLOW, -1, <0, 0, 0>, <0, 0, 0> )
							EffectSetDontKillForReplay( file.beamsFxs[ player ] )
							EffectAddTrackingForControlPoint( file.beamsFxs[ player ], 1, moverForLaserEnt, FX_PATTACH_CUSTOMORIGIN_FOLLOW, -1, <0, 0, 0> )
							EffectSetControlPointVector( file.beamsFxs[ player ], 2, chosenColor )
							moverForHand.ClearParent() //to leave the fx alive for a moment
							
							if( !isAuto )
								StartParticleEffectInWorldWithHandle( GetParticleSystemIndex( expAsset ), origin, <0, 0, 0> ) //Explosion
						}
						else if( EffectDoesExist( file.beamsFxs[ player ] ) )
						{
							EffectAddTrackingForControlPoint( file.beamsFxs[ player ], 1, moverForLaserEnt, FX_PATTACH_CUSTOMORIGIN_FOLLOW, -1, <0, 0, 0> )
						}
						
						if( !isAuto ) //maintains visual for single activate.
						{
							player.p.lightningGunReady = false //for effect sync
							
							float endtime = Time() + LG_DRAG_TIME
							
							while( Time() < endtime )
								WaitFrame()
							
							continue //skips the end loop waitframe
						}
					} 
					else
					{
						StopEffectForPlayer( player )
					}
				}
				else 
				{
					StopEffectForPlayer( player )
				}

				WaitFrame()
			}
		}()
	#endif
}

#if CLIENT 

	void function StopEffectForPlayer( entity sPlayer )
	{
		if( sPlayer in file.beamsFxs && EffectDoesExist( file.beamsFxs[ sPlayer ] ) && sPlayer == GetLocalViewPlayer() )
		{
			EffectStop( file.beamsFxs[ sPlayer ], false, true )
		}
	}
#endif //CLIENT

var function OnWeaponPrimaryAttack_Clickweapon( entity weapon, WeaponPrimaryAttackParams attackParams )
{
	/////////////////////////////////////////////////////////////////////
	#if CLIENT
		if ( InPrediction() && !IsFirstTimePredicted() )
			return
	#endif

	// if( !IsValid( weapon ) )
		// return
	
	bool bAuto = !weapon.GetWeaponSettingBool( eWeaponVar.is_semi_auto )
	entity player = weapon.GetWeaponOwner()
		
	if( file.isInstaGib || !bAuto )
	{
		weapon.OverrideNextAttackTime( Time() + LG_SINGLE_FIRE_DEBOUNCE )
	
		#if CLIENT 
			//Better place to create the local player fx
			if( player == GetLocalViewPlayer() )
				OnLocalPlayerShoot( GetLocalViewPlayer(), attackParams.pos, attackParams.dir )
			
			weapon.GetWeaponOwner().p.lightningGunReady = true //for effect sync
		#endif
		
		#if SERVER
		foreach( splayer in GetPlayerArray() )
			Remote_CallFunction_NonReplay( splayer, "ServerCallback_CreatesLaserFXFromServer", player, attackParams.pos, attackParams.dir ) //to send correct end laser pos to the client
		#endif
	}

	thread function () : ( weapon ) //Don't allow weapon activation while in cooldown. Cafe
	{
		EndSignal( weapon, "OnDestroy" )
		weapon.AllowUse( false )
		wait LG_SINGLE_FIRE_DEBOUNCE + 0.1
		weapon.AllowUse( true )
	}()
	
	return weapon.FireWeaponBullet( attackParams.pos, attackParams.dir, 1, weapon.GetWeaponDamageFlags() )
	
	/////////////////////////////////////////////////////////////////////
	
	#if SERVER
	
	//This should be moved to aimtrainer ondamaged callback
	if( !file.isAimTrainer ) //Gamemode() != eGamemodes.fs_aimtrainer ) 
		return

	if(!player.p.isChallengeActivated) 
		return

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
	#endif

	return 0
}

void function OnWeaponDeactivate_Clickweapon( entity weapon ) 
{
	entity player = weapon.GetWeaponOwner()
	
	if( !IsValid( player ) )
		return

	Signal( player, "EndLaser" )
	
	#if SERVER
	player.SetPlayerNetBool( "isPlayerShootingFlowstateLightningGun", false )
	#endif

	#if CLIENT
	if( player == GetLocalViewPlayer() && player in file.beamsFxs && EffectDoesExist( file.beamsFxs[ player ] ) )
	{
		EffectStop( file.beamsFxs[ player ], false, true )
	}
	#endif
}

#if SERVER
void function FS_LG_PlayerStartShooting( entity player, entity weapon, string weaponName, int ammoUsed, vector attackOrigin, vector attackDir )
{
	if ( !IsValid( player ) || !IsValid( weapon ) || weapon.GetWeaponClassName() != "mp_weapon_lightninggun" )
		return
		
	#if DEVELOPER
	printw( "LGUN - LASER CREATED", player, weapon, weaponName, ammoUsed, attackOrigin, attackDir )
	#endif

	thread FS_LG_PlayerStartShooting_Thread( player, weapon ) //change no auto to a remote funct to play fx, use attackDir instead. Cafe
}

void function FS_LG_PlayerStartShooting_Thread( entity player, entity weapon )
{
	player.SetPlayerNetBool( "isPlayerShootingFlowstateLightningGun", true )
	
	Signal( player, "PlayerStartShotingLightningGun" )
	EndSignal( player, "PlayerStartShotingLightningGun" )

	wait 0.25
	
	if( !IsValid( player ) )
		return

	player.SetPlayerNetBool( "isPlayerShootingFlowstateLightningGun", false )
}
#endif

#if CLIENT
void function FS_LG_OnPlayerCreated( entity player )
{
	if ( !IsValid( player ) ) 
		return

	if( !( player in file.beammover ) || player in file.beammover && !IsValid( file.beammover[player] ) )
	{
		file.beammover[player] <- CreateClientsideScriptMover( $"mdl/dev/empty_model.rmdl", <0, 0, 0>, <0, 0, 0> )
	}

	if( !( player in file.handmover ) || player in file.handmover && !IsValid( file.handmover[player] ) )
	{
		file.handmover[player] <- CreateClientsideScriptMover( $"mdl/dev/empty_model.rmdl", <0, 0, 0>, <0, 0, 0> )
	}

	if( !( player in file.beamsFxs ) )
	{
		file.beamsFxs[player] <- -1
	}

	player.p.lightningGunReady = true //for effect sync
	thread FS_LG_HandleLaserForPlayer( player )

	CheckBeamSettingsExist()
}

void function FS_LG_HandleLaserForPlayer( entity player )
{
	FlagWait( "EntitiesDidLoad" ) // for dev

	if( !IsValid( player ) || player == GetLocalViewPlayer() ) 
		return

	entity mover = file.beammover[player]
	entity handmover = file.handmover[player]

	int fx = file.beamsFxs[ player ]

	bool wasPlayerShooting = false
	
	bool isAuto //todo we should def make a new weapon for the no auto one xd. Cafe

	while( IsValid( player ) )
	{
		isAuto = !file.isInstaGib // Playlist() != ePlaylists.fs_dm_fast_instagib //todo (dw) aaaaaaaaaaaaaaaaaaa //we should def make a new weapon for the no auto one xd. Cafe
		
		if( !(player in file.handmover) || player in file.handmover && !IsValid( file.handmover[player] ) )
			file.handmover[player] <- CreateClientsideScriptMover( $"mdl/dev/empty_model.rmdl", <0, 0, 0>, <0, 0, 0> )
		if( !(player in file.beammover) || player in file.beammover && !IsValid( file.beammover[player] ) )
			file.beammover[player] <- CreateClientsideScriptMover( $"mdl/dev/empty_model.rmdl", <0, 0, 0>, <0, 0, 0> )
		
		mover = file.beammover[player]
		handmover = file.handmover[player]
		
		try
		{
			if( player.LookupAttachment( "R_HAND" ) != -1 )
				handmover.SetParent( player, "R_HAND" )
			else
				handmover.SetParent( player )
		}catch(e420)
		{
			printt("skipped set hand mover parented, 2 early")
		}
		
		if( !EffectDoesExist( file.beamsFxs[ player ] ) && player.GetPlayerNetBool( "isPlayerShootingFlowstateLightningGun" ) && !wasPlayerShooting && isAuto )
		{
			file.beamsFxs[ player ] = StartParticleEffectOnEntityWithPos( handmover, GetParticleSystemIndex( TheBestAssetInTheGame ), FX_PATTACH_ABSORIGIN_FOLLOW, -1, <0, 0, 0>, <0, 0, 0> )

			EffectSetDontKillForReplay( file.beamsFxs[ player ] )

			if( player.GetPlatformUID() == "1011657326453" ) //proto
			{
				thread function () : ( player )
				{
					EndSignal( player, "OnDestroy" )
					while( player in file.beamsFxs && EffectDoesExist( file.beamsFxs[ player ] ) )
					{
						EffectSetControlPointVector( file.beamsFxs[ player ], 2, <RandomInt( 255 ), RandomInt( 255 ), RandomInt( 255 )> )
						wait 0.1
					}
				}()
			} 
			else if( player.GetTeam() != GetLocalViewPlayer().GetTeam() )
				EffectSetControlPointVector( file.beamsFxs[ player ], 2, chosenEnemyColor )
			else
				EffectSetControlPointVector( file.beamsFxs[ player ], 2, chosenColor )

			EffectAddTrackingForControlPoint( file.beamsFxs[ player ], 1, mover, FX_PATTACH_ABSORIGIN_FOLLOW, -1, <0, 0, 3> )
			
			wait 0.01
			continue
		}

		if( EffectDoesExist( file.beamsFxs[ player ] ) && isAuto )
		{
			if( !player.GetPlayerNetBool( "isPlayerShootingFlowstateLightningGun" ) && wasPlayerShooting || 
			!player.DoesShareRealms( GetLocalViewPlayer() ) || 
			!IsAlive( player ) || 
			GetGameState() != eGameState.Playing )
				EffectStop( file.beamsFxs[ player ], false, false )
		}
		
		wasPlayerShooting = player.GetPlayerNetBool( "isPlayerShootingFlowstateLightningGun" )
		mover.NonPhysicsMoveTo( EyeTraceVec( player ), 0.01, 0, 0 ) //min wait value is 0.01 so it does not affect other movers? Cafe	
		WaitFrame()
	}
}

void function FS_LG_OnPlayerDestroyed( entity player )
{
	if ( !IsValid( player ) )
		return

	if( player in file.beammover )
	{
		if( IsValid( file.beammover[player] ) )
			file.beammover[ player ].Destroy()
		delete file.beammover[player]
	}

	if( player in file.handmover )
	{
		if( IsValid( file.handmover[player] ) )
			file.handmover[ player ].Destroy()
		delete file.handmover[player]
	}

	if( player in file.beamsFxs )
	{
		if( EffectDoesExist( file.beamsFxs[ player ] ) )
			EffectStop( file.beamsFxs[ player ], false, true )
		delete file.beamsFxs[player]
	}
}
//Settings
void function LGDuels_SetPresetRed( bool isLocalChosen )
{
	if( isLocalChosen )
	{
		DesiredR = 255
		DesiredG = 0
		DesiredB = 0
		
		LGDuels_UpdateSettings( true, DesiredR, DesiredG, DesiredB )

		SetConVarInt( "fs_lightning_gun_color_r", DesiredR )
		SetConVarInt( "fs_lightning_gun_color_g", DesiredG )
		SetConVarInt( "fs_lightning_gun_color_b", DesiredB )

		chosenColor = < DesiredR, DesiredG, DesiredB >

		entity sPlayer = GetLocalViewPlayer()

		if( sPlayer in file.beamsFxs && EffectDoesExist( file.beamsFxs[ sPlayer ] ) )
		{
			EffectSetControlPointVector( file.beamsFxs[ sPlayer ], 2, chosenColor )
		}
	} 
	else 
	{
		DesiredEnemyR = 255
		DesiredEnemyG = 0
		DesiredEnemyB = 0
		
		LGDuels_UpdateSettings( false, DesiredEnemyR, DesiredEnemyG, DesiredEnemyB )

		SetConVarInt( "fs_lightning_gun_color_r", DesiredEnemyR )
		SetConVarInt( "fs_lightning_gun_color_g", DesiredEnemyG )
		SetConVarInt( "fs_lightning_gun_color_b", DesiredEnemyB )

		chosenEnemyColor = < DesiredEnemyR, DesiredEnemyG, DesiredEnemyB >

		foreach( player in GetPlayerArray() )
			if( player.GetTeam() != GetLocalViewPlayer().GetTeam() && player != GetLocalViewPlayer() && player in file.beamsFxs && EffectDoesExist( file.beamsFxs[ player ] ) )
				EffectSetControlPointVector( file.beamsFxs[ player ], 2, chosenEnemyColor )
	}
}

void function LGDuels_SetPresetBlue( bool isLocalChosen )
{
	if( isLocalChosen )
	{
		DesiredR = 0
		DesiredG = 0
		DesiredB = 255
		
		LGDuels_UpdateSettings( true, DesiredR, DesiredG, DesiredB )
		
		SetConVarInt( "fs_lightning_gun_color_r", DesiredR )
		SetConVarInt( "fs_lightning_gun_color_g", DesiredG )
		SetConVarInt( "fs_lightning_gun_color_b", DesiredB )

		chosenColor = < DesiredR, DesiredG, DesiredB >

		entity sPlayer = GetLocalViewPlayer()

		if( sPlayer in file.beamsFxs && EffectDoesExist( file.beamsFxs[ sPlayer ] ) )
		{
			EffectSetControlPointVector( file.beamsFxs[ sPlayer ], 2, chosenColor )
		}
	} 
	else 
	{
		DesiredEnemyR = 0
		DesiredEnemyG = 0
		DesiredEnemyB = 255

		LGDuels_UpdateSettings( false, DesiredEnemyR, DesiredEnemyG, DesiredEnemyB )
		
		SetConVarInt( "fs_lightning_gun_color_r", DesiredEnemyR )
		SetConVarInt( "fs_lightning_gun_color_g", DesiredEnemyG )
		SetConVarInt( "fs_lightning_gun_color_b", DesiredEnemyB )

		chosenEnemyColor = < DesiredEnemyR, DesiredEnemyG, DesiredEnemyB >

		foreach( player in GetPlayerArray() )
			if( player.GetTeam() != GetLocalViewPlayer().GetTeam() && player != GetLocalViewPlayer() && player in file.beamsFxs && EffectDoesExist( file.beamsFxs[ player ] ) )
				EffectSetControlPointVector( file.beamsFxs[ player ], 2, chosenEnemyColor )
	}
}

void function LGDuels_SetPresetYellow( bool isLocalChosen )
{
	if( isLocalChosen )
	{
		DesiredR = 255
		DesiredG = 255
		DesiredB = 0

		LGDuels_UpdateSettings( true, DesiredR, DesiredG, DesiredB )
					
		SetConVarInt( "fs_lightning_gun_color_r", DesiredR )
		SetConVarInt( "fs_lightning_gun_color_g", DesiredG )
		SetConVarInt( "fs_lightning_gun_color_b", DesiredB )

		chosenColor = < DesiredR, DesiredG, DesiredB >

		entity sPlayer = GetLocalViewPlayer()

		if( sPlayer in file.beamsFxs && EffectDoesExist( file.beamsFxs[ sPlayer ] ) )
		{
			EffectSetControlPointVector( file.beamsFxs[ sPlayer ], 2, chosenColor )
		}
	} 
	else 
	{
		DesiredEnemyR = 255
		DesiredEnemyG = 255
		DesiredEnemyB = 0
		
		LGDuels_UpdateSettings( false, DesiredEnemyR, DesiredEnemyG, DesiredEnemyB )

		SetConVarInt( "fs_lightning_gun_color_r", DesiredEnemyR )
		SetConVarInt( "fs_lightning_gun_color_g", DesiredEnemyG )
		SetConVarInt( "fs_lightning_gun_color_b", DesiredEnemyB )

		chosenEnemyColor = < DesiredEnemyR, DesiredEnemyG, DesiredEnemyB >

		foreach( player in GetPlayerArray() )
			if( player.GetTeam() != GetLocalViewPlayer().GetTeam() && player != GetLocalViewPlayer() && player in file.beamsFxs && EffectDoesExist( file.beamsFxs[ player ] ) )
				EffectSetControlPointVector( file.beamsFxs[ player ], 2, chosenEnemyColor )
	}
}

void function LGDuels_SetPresetGreen( bool isLocalChosen )
{
	if( isLocalChosen )
	{
		DesiredR = 0
		DesiredG = 255
		DesiredB = 0

		LGDuels_UpdateSettings( true, DesiredR, DesiredG, DesiredB )
		
		SetConVarInt( "fs_lightning_gun_color_r", DesiredR )
		SetConVarInt( "fs_lightning_gun_color_g", DesiredG )
		SetConVarInt( "fs_lightning_gun_color_b", DesiredB )

		chosenColor = < DesiredR, DesiredG, DesiredB >

		entity sPlayer = GetLocalViewPlayer()

		if( sPlayer in file.beamsFxs && EffectDoesExist( file.beamsFxs[ sPlayer ] ) )
		{
			EffectSetControlPointVector( file.beamsFxs[ sPlayer ], 2, chosenColor )
		}
	} 
	else 
	{
		DesiredEnemyR = 0
		DesiredEnemyG = 255
		DesiredEnemyB = 0
		
		LGDuels_UpdateSettings( false, DesiredEnemyR, DesiredEnemyG, DesiredEnemyB )

		SetConVarInt( "fs_lightning_gun_color_r", DesiredEnemyR )
		SetConVarInt( "fs_lightning_gun_color_g", DesiredEnemyG )
		SetConVarInt( "fs_lightning_gun_color_b", DesiredEnemyB )

		chosenEnemyColor = < DesiredEnemyR, DesiredEnemyG, DesiredEnemyB >

		foreach( player in GetPlayerArray() )
			if( player.GetTeam() != GetLocalViewPlayer().GetTeam() && player != GetLocalViewPlayer() && player in file.beamsFxs && EffectDoesExist( file.beamsFxs[ player ] ) )
				EffectSetControlPointVector( file.beamsFxs[ player ], 2, chosenEnemyColor )
	}
}

void function LGDuels_SetPresetPurple( bool isLocalChosen )
{
	if( isLocalChosen )
	{
		DesiredR = 255
		DesiredG = 0
		DesiredB = 255
	
		LGDuels_UpdateSettings( true, DesiredR, DesiredG, DesiredB )
					
		SetConVarInt( "fs_lightning_gun_color_r", DesiredR )
		SetConVarInt( "fs_lightning_gun_color_g", DesiredG )
		SetConVarInt( "fs_lightning_gun_color_b", DesiredB )

		chosenColor = < DesiredR, DesiredG, DesiredB >

		entity sPlayer = GetLocalViewPlayer()

		if( sPlayer in file.beamsFxs && EffectDoesExist( file.beamsFxs[ sPlayer ] ) )
		{
			EffectSetControlPointVector( file.beamsFxs[ sPlayer ], 2, chosenColor )
		}
	} 
	else 
	{
		DesiredEnemyR = 255
		DesiredEnemyG = 0
		DesiredEnemyB = 255
		
		LGDuels_UpdateSettings( false, DesiredEnemyR, DesiredEnemyG, DesiredEnemyB )

		SetConVarInt( "fs_lightning_gun_color_r", DesiredEnemyR )
		SetConVarInt( "fs_lightning_gun_color_g", DesiredEnemyG )
		SetConVarInt( "fs_lightning_gun_color_b", DesiredEnemyB )

		chosenEnemyColor = < DesiredEnemyR, DesiredEnemyG, DesiredEnemyB >

		foreach( player in GetPlayerArray() )
			if( player.GetTeam() != GetLocalViewPlayer().GetTeam() && player != GetLocalViewPlayer() && player in file.beamsFxs && EffectDoesExist( file.beamsFxs[ player ] ) )
				EffectSetControlPointVector( file.beamsFxs[ player ], 2, chosenEnemyColor )
	}
}

void function LGDuels_SetModifyingLocalBeam( bool modifyingLocalBeam )
{
	modifyingLocalBeam = modifyingLocalBeam
}

void function LGDuels_SetSettingsMenuOpen( bool open )
{
	isSettingsMenuOpen = open
	if( open )
	{
		ForceHide1v1Scoreboard( )
	} else {
		ForceShow1v1Scoreboard( )
	}
}

void function LGDuels_SetR( int R, bool isLocalChosen )
{
	if( isLocalChosen )
	{
		DesiredR = R
		
		LGDuels_UpdateSettings( true, DesiredR )
		chosenColor = < DesiredR, DesiredG, DesiredB >

		entity sPlayer = GetLocalViewPlayer()

		if( sPlayer in file.beamsFxs && EffectDoesExist( file.beamsFxs[ sPlayer ] ) )
		{
			EffectSetControlPointVector( file.beamsFxs[ sPlayer ], 2, chosenColor )
		}
	} 
	else 
	{
		DesiredEnemyR = R
		
		LGDuels_UpdateSettings( false, DesiredEnemyR )
		chosenEnemyColor = < DesiredEnemyR, DesiredEnemyG, DesiredEnemyB >

		foreach( player in GetPlayerArray() )
			if( player.GetTeam() != GetLocalViewPlayer().GetTeam() && player != GetLocalViewPlayer() && player in file.beamsFxs && EffectDoesExist( file.beamsFxs[ player ] ) )
				EffectSetControlPointVector( file.beamsFxs[ player ], 2, chosenEnemyColor )
	}
}

void function LGDuels_SetG( int G, bool isLocalChosen )
{
	if( isLocalChosen )
	{
		DesiredG = G
		
		LGDuels_UpdateSettings( true, null, DesiredG )	
		chosenColor = < DesiredR, DesiredG, DesiredB >

		entity sPlayer = GetLocalViewPlayer()

		if( sPlayer in file.beamsFxs && EffectDoesExist( file.beamsFxs[ sPlayer ] ) )
		{
			EffectSetControlPointVector( file.beamsFxs[ sPlayer ], 2, chosenColor )
		}
	} 
	else 
	{
		DesiredEnemyG = G
		
		LGDuels_UpdateSettings( false, null, DesiredEnemyG )
		chosenEnemyColor = < DesiredEnemyR, DesiredEnemyG, DesiredEnemyB >

		foreach( player in GetPlayerArray() )
			if( player.GetTeam() != GetLocalViewPlayer().GetTeam() && player != GetLocalViewPlayer() && player in file.beamsFxs && EffectDoesExist( file.beamsFxs[ player ] ) )
				EffectSetControlPointVector( file.beamsFxs[ player ], 2, chosenEnemyColor )
	}
}

void function LGDuels_SetB( int B, bool isLocalChosen )
{
	if( isLocalChosen )
	{
		DesiredB = B
		
		LGDuels_UpdateSettings( true, null, null, DesiredB )
		chosenColor = < DesiredR, DesiredG, DesiredB >

		entity sPlayer = GetLocalViewPlayer()

		if( sPlayer in file.beamsFxs && EffectDoesExist( file.beamsFxs[ sPlayer ] ) )
		{
			EffectSetControlPointVector( file.beamsFxs[ sPlayer ], 2, chosenColor )
		}
	} 
	else 
	{
		DesiredEnemyB = B
		
		LGDuels_UpdateSettings( false, null, null, DesiredEnemyB )
		chosenEnemyColor = < DesiredEnemyR, DesiredEnemyG, DesiredEnemyB >

		foreach( player in GetPlayerArray() )
			if( player.GetTeam() != GetLocalViewPlayer().GetTeam() && player != GetLocalViewPlayer() && player in file.beamsFxs && EffectDoesExist( file.beamsFxs[ player ] ) )
				EffectSetControlPointVector( file.beamsFxs[ player ], 2, chosenEnemyColor )
	}
}
#endif

#if CLIENT
void function LGDuels_SetFromPersistence( float s1, int s2, int s3, int s4, float s5, int s6, int s7, int s8 )
{
	// LGDuels_SetPositionOffset( s1 )
	
	SetConVarInt( "fs_lightning_gun_color_r", s2 )
	SetConVarInt( "fs_lightning_gun_color_g", s3 )
	SetConVarInt( "fs_lightning_gun_color_b", s4 )

	chosenColor = < s2, s3, s4 > //uses global script var

	entity sPlayer = GetLocalViewPlayer()

	if( sPlayer in file.beamsFxs && EffectDoesExist( file.beamsFxs[ sPlayer ] ) )
	{
		EffectSetControlPointVector( file.beamsFxs[ sPlayer ], 2, chosenColor )
	}
	
	chosenEnemyColor = < s6, s7, s8 > //uses global script var
	
	foreach( player in GetPlayerArray() )
		if( player.GetTeam() != GetLocalViewPlayer().GetTeam() && player != GetLocalViewPlayer() && player in file.beamsFxs && EffectDoesExist( file.beamsFxs[ player ] ) )
			EffectSetControlPointVector( file.beamsFxs[ player ], 2, chosenEnemyColor )
}

void function LGDuels_SaveToServerPersistence()
{
	entity player = GetLocalViewPlayer()
	
	if( !IsValid( player ) )
		return
	
	string settings = GenerateSettingsString()
	player.ClientCommand( format( "SaveLgSettings %s", settings ) ) 
}

string function GenerateSettingsString()
{	
	CheckBeamSettingsExist()
	
	string returnString = format( "%f|%d|%d|%d|%f|%d|%d|%d", 
		file.allBeamSettings["local"].offset,
		file.allBeamSettings["local"].R,
		file.allBeamSettings["local"].G,
		file.allBeamSettings["local"].B,
		file.allBeamSettings["enemy"].offset,
		file.allBeamSettings["enemy"].R,
		file.allBeamSettings["enemy"].G,
		file.allBeamSettings["enemy"].B
	)

	return returnString
} 
#endif
