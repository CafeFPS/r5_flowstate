global function MpAbilityCryptoDroneEMP_Init
global function OnWeaponAttemptOffhandSwitch_ability_crypto_drone_emp
global function OnWeaponPrimaryAttack_ability_crypto_drone_emp
#if SERVER
global function DroneEMP
global function EMP_Destroy
global function EMP_HitDevices
global function EMP_ShouldAffectAlterTac
#endif
global const asset FX_EMP_BODY_HUMAN = $"P_emp_body_human"
global const asset FX_EMP_BODY_TITAN = $"P_emp_body_titan"

const asset EMP_CHARGE_UP_FX = $"P_emp_chargeup"
const CAMERA_EMP_EXPLOSION = "exp_drone_emp"
const asset FX_EMP_SUPPORT_FX = $"P_emp_explosion"
const asset EMP_WARNING_FX_SCREEN = $"P_emp_screen_player"
const asset EMP_WARNING_FX_3P = $"P_emp_body_human"
const asset EMP_WARNING_FX_GROUND = $"P_emp_body_human"
const asset EMP_RADIUS_FX = $"P_emp_charge_radius_MDL"


//Need to handle player swapping view, "1P probably needs to be 3p on the entity under the hood"
const string EMP_CHARGING_3P = "Char11_UltimateA_A_3p"
const string EMP_CHARGING_CRYPTO_3P = "Char11_UltimateA_A_3p"
const string EMP_CHARGING_1P = "Char11_UltimateA_A"

struct
{
	#if CLIENT
		int colorCorrection
		int screenFxHandle
	#endif //CLIENT
} file

void function MpAbilityCryptoDroneEMP_Init()
{
	PrecacheParticleSystem( EMP_CHARGE_UP_FX )
	PrecacheParticleSystem( FX_EMP_SUPPORT_FX )
	PrecacheImpactEffectTable( CAMERA_EMP_EXPLOSION )
	PrecacheParticleSystem( EMP_WARNING_FX_SCREEN )
	PrecacheParticleSystem( EMP_WARNING_FX_3P )
	PrecacheParticleSystem( EMP_RADIUS_FX )
	RegisterSignal( "Emp_Detonated" )
	RegisterSignal( "EMP_Destroy" )
	#if CLIENT
		RegisterSignal( "EndEMPWarningFX" )
		StatusEffect_RegisterEnabledCallback( eStatusEffect.crypto_emp_warning, EMPWarningVisualsEnabled )
		StatusEffect_RegisterDisabledCallback( eStatusEffect.crypto_emp_warning, EMPWarningVisualsDisabled )
	#endif
	RegisterNetworkedVariable( "isDoingEMPSequence", SNDC_PLAYER_EXCLUSIVE, SNVT_BOOL, false )
}


bool function OnWeaponAttemptOffhandSwitch_ability_crypto_drone_emp( entity weapon )
{
	entity player = weapon.GetWeaponOwner()
	if ( !IsValid( player ) )
		return false

                        
	if ( !(StatusEffect_GetSeverity( player, eStatusEffect.crypto_has_camera ) > 0 ))
	{
		#if CLIENT
			AddPlayerHint( 1.0, 0.25, $"rui/hud/tactical_icons/tactical_crypto", "#CRYPTO_ULTIMATE_CAMERA_NOT_READY" )
		#endif
		return false
	}
      

	if ( StatusEffect_GetSeverity( player, eStatusEffect.crypto_camera_is_recalling ) > 0 )
	{
		//Client explanation not necessary due to recall HUD
		return false
	}

	printt( "\t| Attempting offhand switch. Player net bool for emp sequence false?", player.GetPlayerNetBool( "isDoingEMPSequence" ) )
	if ( player.GetPlayerNetBool( "isDoingEMPSequence" ) )
		return false

	return true
}


var function OnWeaponPrimaryAttack_ability_crypto_drone_emp( entity weapon, WeaponPrimaryAttackParams attackParams )
{
	entity weaponOwner = weapon.GetWeaponOwner()

	if ( !(StatusEffect_GetSeverity( weaponOwner, eStatusEffect.crypto_has_camera ) > 0 ) ) //This should handle a case of the drone getting killed while the weapon is raising and hasn't fired yet.
	{
			return 0
        
	}
	else if ( StatusEffect_GetSeverity( weaponOwner, eStatusEffect.crypto_camera_is_recalling ) > 0 )
	{
		return 0
	}
	else
	{
		#if SERVER
			thread DroneEMP( weaponOwner )
		#endif
	}

	PlayerUsedOffhand( weaponOwner, weapon )

	int ammoReq = weapon.GetAmmoPerShot()
	return ammoReq
}

#if SERVER
void function DroneEMP( entity owner )
{
	entity camera = owner.p.cryptoActiveCamera
	Assert( IsValid( camera ), "shouldn't be able to hit this script with an inactive camera" )
	if ( !IsValid( camera ) ) //Apparently some playtests are using builds with asserts turned off.
		return

	string currentSequenceName = camera.GetCurrentSequenceName()
	if ( currentSequenceName == "animseq/props/crypto_drone/crypto_drone/drone_EMP.rseq" ) //Temp Workaround to prevent this from spamming
		return

	EndSignal( camera, "OnDestroy" )
	EndSignal( owner, "OnDestroy" )

	//Need to Handle 1P versus 3P sounds similar to propulsion sounds
	EmitSoundOnEntity( camera, EMP_CHARGING_3P )
	PlayBattleChatterLineToSpeakerAndTeam( owner, "bc_super" )

	int index               = GetParticleSystemIndex( EMP_CHARGE_UP_FX )
	int attachIndex         = camera.LookupAttachment( "handle" )
	entity chargeUpFx       = StartParticleEffectOnEntity_ReturnEntity( camera, index, FX_PATTACH_POINT_FOLLOW, attachIndex )
	entity chargeUpRadiusFx = StartParticleEffectOnEntity_ReturnEntity( camera, GetParticleSystemIndex( EMP_RADIUS_FX ), FX_PATTACH_POINT_FOLLOW, attachIndex )

	EffectSetControlPointVector( chargeUpRadiusFx, 5, <0.49, 0, 0> )

	camera.Anim_PlayOnly( "drone_EMP" )

	owner.SetPlayerNetBool( "isDoingEMPSequence", true )

	float waitDuration = 2.5
	StatusEffect_AddTimed( owner, eStatusEffect.crypto_camera_is_emp, 1.0, waitDuration, waitDuration )
	array<int> battleChatterEMPTeams
	thread EMP_WarningFX( camera, waitDuration, battleChatterEMPTeams )

	owner.p.completedEMP = false

	OnThreadEnd(
		function() : ( owner )
		{
			//Restore ultimate ammo if the camera is destroyed during the EMP
			if ( IsValid( owner ) && !owner.p.completedEMP )
			{
				entity offhandWeapon = owner.GetOffhandWeapon( OFFHAND_ULTIMATE )
				if ( IsValid( offhandWeapon ) )
				{
					offhandWeapon.SetWeaponPrimaryClipCount( offhandWeapon.GetWeaponPrimaryClipCountMax() )
				}
			}

			owner.SetPlayerNetBool( "isDoingEMPSequence", false )
		}
	)
	wait waitDuration

	owner.p.completedEMP = true
	camera.Signal( "Emp_Detonated" )
	StopSoundOnEntity( camera, EMP_CHARGING_3P )
	EffectStop( chargeUpRadiusFx )
	chargeUpRadiusFx.Destroy()
	EffectStop( chargeUpFx )
	chargeUpFx.Destroy()
	vector cameraOrigin = camera.GetOrigin()
	PlayImpactFXTable( cameraOrigin, camera, CAMERA_EMP_EXPLOSION )

	entity supportFx = StartParticleEffectInWorld_ReturnEntity( GetParticleSystemIndex( FX_EMP_SUPPORT_FX ), cameraOrigin, <0, 0, 0> )
	supportFx.RemoveFromAllRealms()
	supportFx.AddToOtherEntitysRealms( camera )

	int cameraTeam        = camera.GetTeam()
	int maxShieldDamage   = GetCurrentPlaylistVarInt( "crypto_emp_damage", 50 )
	array<entity> targets = CryptoDrone_GetNearbyTargetsForEMPRange( camera )
	foreach ( entity target in targets )
	{
		if ( StatusEffect_GetSeverity( target, eStatusEffect.immune_to_abilities ) > 0 )
			continue

		int targetTeam = target.GetTeam()
		if ( !GetCurrentPlaylistVarBool( "enable_emp_trap_friendly_fire", true ) )
		{
			// if friendly fire is off, skip everyone and everything from your own team except Crypto himself
			if ( IsFriendlyTeam( targetTeam, cameraTeam ) && (target != owner) )
				continue
		} else
		{
			// friendly fire is ON; it should only affect players, not traps, and it should
			// only slow them
			if ( IsFriendlyTeam( targetTeam, cameraTeam ) && (!target.IsPlayer() ) )
				continue
		}

		string tag = ""
		asset effect

                     
		// if ( EntIsHoverVehicle( target ) )
		// {
			// tag = "driver"
			// effect = FX_EMP_BODY_TITAN
		// }
		// else
      
		{
			tag = "CHESTFOCUS"
			effect = FX_EMP_BODY_HUMAN
		}

		//if ( !target.IsPlayerVehicle() )
		thread EMP_FX( effect, target, tag, 1.5 )

		if ( target.IsPlayer() )
		{
			if ( target.IsObserver() )
				continue

			if ( !target.ContextAction_IsInVehicle() )
				StatusEffect_AddTimed( target, eStatusEffect.turn_slow, 0.7, 2.0, 1.0 )
			StatusEffect_AddTimed( target, eStatusEffect.emp, 1.0, 2.0, 1.0 )
			StatusEffect_AddTimed( target, eStatusEffect.minimap_jammed, 1.0, 2.0, 0.0 )
			StatusEffect_AddTimed( target, eStatusEffect.move_slow, 0.35, 2.0, 1.0 )
		}
		else if ( target.IsNPC() ) //&& IsTrainingDummie( target ) )
		{
			StatusEffect_AddTimed( target, eStatusEffect.move_slow, 0.35, 2.0, 1.0 )
		}

		if ( GetCurrentPlaylistVarBool( "enable_emp_trap_friendly_fire", true ) )
		{
			if ( IsFriendlyTeam( targetTeam, cameraTeam ) && (target != owner) )
				continue
		}

		int targetShields = target.GetShieldHealth()
		               
		// if ( target.IsPlayer() )
		// {
			// int tempShields = target.GetTempshieldHealth()
			// targetShields += tempShields
		// }
        
		int shieldDamage  = int( min( maxShieldDamage, targetShields ) )

		if ( target.IsPlayer() && owner != target ) //Don't assist yourself
			AddAssistingPlayerToVictim( owner, target )

		if ( ( target.IsPlayer() || target.IsNPC() ) && shieldDamage > 0 ) //This should be the interaction, but we should hide the shield bar when in shadow form
		{
			target.SetShieldHealth( max( target.GetShieldHealth() - shieldDamage, 0 ) )
			// target.TakeDamage( shieldDamage, owner, camera, { damageSourceId = eDamageSourceId.mp_ability_crypto_drone_emp, scriptType = DF_EXPLOSION | DF_SHIELD_ONLY_DAMAGE } )
			// StatsHook_EMPShieldDamage( target, owner, shieldDamage )
		}

		if ( target.IsPlayer() && !battleChatterEMPTeams.contains( targetTeam ) )
		{
			PlayBattleChatterLineToSpeakerAndTeam( target, "bc_empHitby" )
			battleChatterEMPTeams.append( targetTeam )
		}

		if( target.IsNPC() && shieldDamage == 0 )
			target.TakeDamage( 0, owner, camera, { damageSourceId = eDamageSourceId.mp_ability_crypto_drone_emp, scriptType = DF_EXPLOSION } )
	}

	// if ( !GameModeVariant_IsActive( eGameModeVariants.SURVIVAL_FIRING_RANGE ) )
		CryptoDrone_DamageRecentlyDroppedArmorInEMPRange( owner, cameraOrigin, maxShieldDamage )

	if ( IsValid( owner ) && IsPlayerInCryptoDroneCameraView( owner ) )
		camera.Anim_PlayOnly( "drone_active_idle" )
	else
		camera.Anim_PlayOnly( "drone_active_twitch" )

	EMP_HitDevices( owner, camera, EMP_RANGE, eDamageSourceId.mp_ability_crypto_drone_emp_trap )

	wait 1.5

	if ( IsValid( supportFx ) )
		supportFx.Destroy()
}

int function EMP_HitDevices( entity owner, entity sourceEnt, float range , int damageSourceID )
{
	int numDevicesHit = 0
	int sourceTeam = sourceEnt.GetTeam()

	array<entity> destroyDevices = GetNearbyEMPDestroyDeviceArray( sourceEnt, range )
	foreach ( device in destroyDevices )
	{
		if ( IsFriendlyTeam( device.GetTeam(), sourceTeam ) )
			continue
		if( !device.DoesShareRealms( sourceEnt ) )
			continue

		device.Signal( "EMP_Destroy", { owner = owner, source = sourceEnt } )
		// StatsHook_EMPDevicesHit( device, owner )
		numDevicesHit++
	}

	array<entity> damageDevices = GetNearbyEMPDamageDeviceArray( sourceEnt, range )
	foreach ( device in damageDevices )
	{
		if ( IsFriendlyTeam( device.GetTeam(), sourceTeam ) )
			continue
		if( !device.DoesShareRealms( sourceEnt ) )
			continue

		device.TakeDamage( 100, owner, sourceEnt, { damageSourceId = damageSourceID } )
		// StatsHook_EMPDevicesHit( device, owner )
		numDevicesHit++
	}

	array<entity> disableDevices = GetNearbyEMPDisableDeviceArray( sourceEnt, range )
	foreach ( device in disableDevices )
	{
		bool isFriendly = IsFriendlyTeam( device.GetTeam(), sourceTeam )

		// if ( IsTurret( device ) )
		// {
			// if ( IsValid ( device.GetDriver() ) )
			// {
				// isFriendly = IsFriendlyTeam( device.GetDriver().GetTeam(), sourceTeam )
			// }
			// else
			// {
				// isFriendly = false
			// }
		// }


		if ( isFriendly)
			continue
		if( !device.DoesShareRealms( sourceEnt ) )
			continue

		EMPDeviceDisableCallback( device )
		// StatsHook_EMPDevicesHit( device, owner )
		numDevicesHit++
	}

	return numDevicesHit
}

void function EMP_Explosion_Common( entity owner, entity source, array<int> chatterTeams )
{
	vector sourceOrigin = source.GetOrigin()
	PlayImpactFXTable( sourceOrigin, owner, CAMERA_EMP_EXPLOSION )

	entity supportFx = StartParticleEffectInWorld_ReturnEntity( GetParticleSystemIndex( FX_EMP_SUPPORT_FX ), sourceOrigin, <0, 0, 0> )
	supportFx.RemoveFromAllRealms()
	supportFx.AddToOtherEntitysRealms( owner )

	int cameraTeam        = owner.GetTeam()
	int maxShieldDamage   = GetCurrentPlaylistVarInt( "crypto_emp_damage", 50 )
	array<entity> targets = CryptoDrone_GetNearbyTargetsForEMPRange( owner )
	foreach ( entity target in targets )
	{
		if ( target.IsPhaseShifted() )
			continue

		if ( StatusEffect_GetSeverity( target, eStatusEffect.immune_to_abilities ) > 0 )
			continue

		int targetTeam = target.GetTeam()
		if ( !GetCurrentPlaylistVarBool( "enable_emp_trap_friendly_fire", true ) )
		{
			// if friendly fire is off, skip everyone and everything from your own team except Crypto himself
			if ( IsFriendlyTeam( targetTeam, cameraTeam ) && (target != owner) )
				continue
		} else
		{
			// friendly fire is ON; it should only affect players, not traps, and it should
			// only slow them
			if ( IsFriendlyTeam( targetTeam, cameraTeam ) && ( !target.IsPlayer() ) )
				continue
		}

		string tag = ""
		asset effect

                     
		// if ( EntIsHoverVehicle( target ) )
		// {
			// tag = "driver"
			// effect = FX_EMP_BODY_TITAN
		// }
		// else
      
		{
			tag = "CHESTFOCUS"
			effect = FX_EMP_BODY_HUMAN
		}

		//if ( !target.IsPlayerVehicle() )
		thread EMP_FX( effect, target, tag, 1.5 )

		if ( target.IsPlayer() )
		{
			if ( !target.ContextAction_IsInVehicle() )
				StatusEffect_AddTimed( target, eStatusEffect.turn_slow, 0.7, 2.0, 1.0 )
			StatusEffect_AddTimed( target, eStatusEffect.emp, 1.0, 2.0, 1.0 )
			StatusEffect_AddTimed( target, eStatusEffect.minimap_jammed, 1.0, 2.0, 0.0 )
			StatusEffect_AddTimed( target, eStatusEffect.move_slow, 0.35, 2.0, 1.0 )
		}

		if ( GetCurrentPlaylistVarBool( "enable_emp_trap_friendly_fire", true ) )
		{
			if ( IsFriendlyTeam( targetTeam, cameraTeam ) && (target != owner) )
				continue
		}

		int targetShields = target.GetShieldHealth()
		int shieldDamage  = int( min( maxShieldDamage, targetShields ) )

		if ( target.IsPlayer() && owner != target ) //Don't assist yourself
			AddAssistingPlayerToVictim( owner, target )

		if ( ( target.IsPlayer() || target.IsNPC() ) && shieldDamage > 0 ) //This should be the interaction, but we should hide the shield bar when in shadow form
		{
			target.SetShieldHealth( max( target.GetShieldHealth() - shieldDamage, 0 ) )
			// target.TakeDamage( shieldDamage, owner, source, { damageSourceId = eDamageSourceId.mp_ability_crypto_drone_emp, scriptType = DF_EXPLOSION | DF_SHIELD_ONLY_DAMAGE } )
			// StatsHook_EMPShieldDamage( target, source, shieldDamage )
		}

		if ( target.IsPlayer() && !chatterTeams.contains( targetTeam ) )
		{
			PlayBattleChatterLineToSpeakerAndTeam( target, "bc_empHitby" )
			chatterTeams.append( targetTeam )
		}

		if( target.IsNPC() && shieldDamage == 0 )
			target.TakeDamage( 0, owner, source, { damageSourceId = eDamageSourceId.mp_ability_crypto_drone_emp, scriptType = DF_EXPLOSION } )
	}

	// if ( !GameModeVariant_IsActive( eGameModeVariants.SURVIVAL_FIRING_RANGE ) )
		CryptoDrone_DamageRecentlyDroppedArmorInEMPRange( owner, sourceOrigin, maxShieldDamage )

	EMP_HitDevices( owner, source, EMP_RANGE, eDamageSourceId.mp_ability_crypto_drone_emp_trap )

	wait 1.5

	if ( IsValid( supportFx ) )
		supportFx.Destroy()
}

bool function EMP_ShouldAffectAlterTac()
{
	return GetCurrentPlaylistVarBool( "crypto_emp_hits_alter_tac", true )
}

void function FS_ArrayRemoveItemsThatArentArmorsNearby( array<entity> ents, vector origin, float maxrange )
{
	for ( int i = ents.len() - 1; i >= 0; i-- )
	{
		if( !IsValid( ents[ i ] ) )
		{
			ents.remove( i )
			continue
		}
		
		LootData lootData = SURVIVAL_Loot_GetLootDataByIndex( ents[i].GetSurvivalInt() )
		if ( lootData.lootType != eLootType.ARMOR || Distance( ents[i].GetOrigin(), origin ) > maxrange )
			ents.remove( i )
	}
}

void function CryptoDrone_DamageRecentlyDroppedArmorInEMPRange( entity owner, vector cameraOrigin, int maxShieldDamage )
{
	//why this shit doesn't work? (GetSurvivalLootNearbyPos). Cafe
	//array<entity> nearbyLoot = GetSurvivalLootNearbyPos( cameraOrigin, EMP_RANGE, false, false ) //, false, owner )
	
	//expensive method? Cafe
	array<entity> nearbyLoot = GetEntArrayByClass_Expensive( "prop_survival" )
	FS_ArrayRemoveItemsThatArentArmorsNearby( nearbyLoot, cameraOrigin, EMP_RANGE )
	
	printt( "CryptoDrone_DamageRecentlyDroppedArmorInEMPRange ", cameraOrigin , nearbyLoot.len() )
	
	foreach ( item in nearbyLoot )
	{
		if ( !owner.DoesShareRealms( item ) ) // Fix for the Firing Range
			continue

		if ( item.GetTimeSinceSpawning() > 15.0 )
			continue

		int shieldHealth = item.GetSurvivalProperty() //GetPropSurvivalMainPropertyFromEnt( item )
		int shieldDamage = int( min( maxShieldDamage, shieldHealth ) )
		int newHealth    = shieldHealth - shieldDamage
		item.SetSurvivalProperty( newHealth )
		#if DEVELOPER
		Warning( "Changing armor health on ground " + item + " to " + newHealth )
		#endif
		// SetPropSurvivalMainPropertyOnEnt( item, newHealth )
	}
}

void function EMP_WarningFX( entity sourceEnt, float waitDuration, array<int> battleChatterEMPTeams )
{
	EndSignal( sourceEnt, "Emp_Detonated", "OnDestroy" )

	array<entity> warningFXPlayers
	table<entity, entity> thirdPersonFXs
	int effectIndex = GetParticleSystemIndex( EMP_WARNING_FX_3P )
	OnThreadEnd(
		function() : ( warningFXPlayers, thirdPersonFXs )
		{
			foreach ( player in warningFXPlayers )
			{
				if ( !IsValid( player ) )
					continue
				StatusEffect_StopAllOfType( player, eStatusEffect.crypto_emp_warning )
				if ( IsValid( thirdPersonFXs[player] ) )
					thirdPersonFXs[player].Destroy()
			}
		}
	)

	float battleChatterWarningTime = (Time() + waitDuration - 1.0) //Don't play the warning BC if there is less than a second before the EMP goes off.
	while( true )
	{
		array<entity> nearbyTargets = CryptoDrone_GetNearbyTargetsForEMPRange( sourceEnt )
		bool hideFX = false
                        
                                     
       

		ArrayRemoveInvalid( warningFXPlayers )
		
		//R5RDEV-1
		// foreach ( player in warningFXPlayers )
		// {
			// if ( nearbyTargets.contains( player ) )
				// continue

			// StatusEffect_StopAllOfType( player, eStatusEffect.crypto_emp_warning )
			// warningFXPlayers.fastremovebyvalue( player )
			// thirdPersonFXs[player].Destroy()
		// }
		
		int maxIter = warningFXPlayers.len() - 1
		
		for( int i = maxIter; i >= 0; i-- )
		{
			entity warnPlayer = warningFXPlayers[ i ]

			if ( nearbyTargets.contains( warnPlayer ) )
				continue 
			
			{
				StatusEffect_StopAllOfType( warnPlayer, eStatusEffect.crypto_emp_warning )		
				warningFXPlayers.remove( i )		
				thirdPersonFXs[ warnPlayer ].Destroy()
			}
		}

		foreach ( target in nearbyTargets )
		{
			if ( !target.IsPlayer() )
				continue
			entity player = target

			if ( warningFXPlayers.contains( player ) )
			{
				if ( hideFX )
					thirdPersonFXs[player].SetVisibilityFlags( ENTITY_VISIBLE_TO_NOBODY )
				else
					thirdPersonFXs[player].SetVisibilityFlags( ENTITY_VISIBLE_TO_FRIENDLY | ENTITY_VISIBLE_TO_ENEMY )

				continue
			}

			warningFXPlayers.append( player )

			StatusEffect_AddEndless( player, eStatusEffect.crypto_emp_warning, 1.0 )
			int playerTeam = player.GetTeam()
			if ( (playerTeam != sourceEnt.GetTeam()) && (Time() < battleChatterWarningTime) )
			{
				if ( !battleChatterEMPTeams.contains( playerTeam ) )
				{
					PlayBattleChatterLineToSpeakerAndTeam( player, "bc_empWarning" )
					battleChatterEMPTeams.append( playerTeam )
				}
			}

			entity empEffect3p = StartParticleEffectOnEntity_ReturnEntity( player, effectIndex, FX_PATTACH_POINT_FOLLOW, player.LookupAttachment( "CHESTFOCUS" ) )
			empEffect3p.SetOwner( player )
			if ( hideFX )
				empEffect3p.kv.VisibilityFlags = ENTITY_VISIBLE_TO_NOBODY
			else
				empEffect3p.kv.VisibilityFlags = (ENTITY_VISIBLE_TO_FRIENDLY | ENTITY_VISIBLE_TO_ENEMY)

			if ( player in thirdPersonFXs )
				thirdPersonFXs[player] = empEffect3p
			else
				thirdPersonFXs[player] <- empEffect3p

		}

		WaitFrame()
	}
}
#endif

#if CLIENT
void function EMPWarningVisualsEnabled( entity ent, int statusEffect, bool actuallyChanged )
{
	if ( ent != GetLocalViewPlayer() )
		return

	entity player = ent

	entity cockpit = player.GetCockpit()
	if ( !IsValid( cockpit ) )
		return

	thread EMPWarningFXThink( player, cockpit )
}

void function EMPWarningVisualsDisabled( entity ent, int statusEffect, bool actuallyChanged )
{
	if ( ent != GetLocalViewPlayer() )
		return

	ent.Signal( "EndEMPWarningFX" )
}

void function EMPWarningFXThink( entity player, entity cockpit )
{
	player.EndSignal( "OnDeath" )
	cockpit.EndSignal( "OnDestroy" )

	int fxHandle = StartParticleEffectOnEntity( cockpit, GetParticleSystemIndex( EMP_WARNING_FX_SCREEN ), FX_PATTACH_ABSORIGIN_FOLLOW, -1 )
	EffectSetIsWithCockpit( fxHandle, true )
	EmitSoundOnEntity( player, "Wattson_Ultimate_G" )
	vector controlPoint = <1, 1, 1>
	EffectSetControlPointVector( fxHandle, 1, controlPoint )

	//Depending on the size of the FX, might need facing limitations to not make it feel incorrect at the edge of the radius looking outward.
	int fxHandleGround = StartParticleEffectOnEntity( player, GetParticleSystemIndex( EMP_WARNING_FX_GROUND ), FX_PATTACH_ABSORIGIN_FOLLOW, -1 )

	player.WaitSignal( "EndEMPWarningFX" )

	if ( EffectDoesExist( fxHandle ) )
		EffectStop( fxHandle, true, false )

	if ( EffectDoesExist( fxHandleGround ) )
		EffectStop( fxHandleGround, true, false )
}
#endif //#if CLIENT


#if SERVER
void function EMP_Destroy( entity device, int destroyType = eEmpDestroyType.EMP_DESTROY_DISSOLVE )
{
	device.EndSignal( "OnDestroy" )

	table empData = device.WaitSignal( "EMP_Destroy" )

	switch( destroyType )
	{
		case eEmpDestroyType.EMP_DESTROY_DAMAGE:
			entity owner = expect entity( empData.owner )
			entity source = expect entity( empData.source )
			device.TakeDamage( device.GetMaxHealth(), owner, source, { damageSourceId=eDamageSourceId.mp_ability_crypto_drone_emp_trap } )
			break
		case eEmpDestroyType.EMP_DESTROY_DISSOLVE:
		default:
			EmitSoundAtPosition( TEAM_UNASSIGNED, device.GetOrigin(), "Lifeline_Drone_Dissolve", device )
			device.ClearParent()
			device.Dissolve( ENTITY_DISSOLVE_CORE, <0,0,0>, 1000 )
			break
	}
}
#endif