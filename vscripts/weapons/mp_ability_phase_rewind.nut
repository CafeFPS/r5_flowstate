//Implemented by Retículo Endoplasmático#5955 (CaféDeColombiaFPS)
global function OnWeaponPrimaryAttack_ability_phase_rewind

#if SERVER
global function RecordPositions
#endif
///CONFIGS///
const int PHASE_REWIND_MAX_SNAPSHOTS = 30
const asset FX = $"P_ar_holopilot_trail"
/////////////

float timetest

var function OnWeaponPrimaryAttack_ability_phase_rewind( entity weapon, WeaponPrimaryAttackParams attackParams )
{
	timetest = Time()
	entity player = weapon.GetWeaponOwner()
	#if SERVER
	thread RewindPlayer(player)
	#endif
	
	return weapon.GetWeaponSettingInt( eWeaponVar.ammo_per_shot )
}

#if SERVER
void function RewindPlayer( entity player )
{
	if(!IsValid(player) || !IsAlive(player)) return
	
	player.EndSignal( "OnDestroy" )
	player.EndSignal( "OnDeath" )
	
	
	player.SetPredictionEnabled( false )
	HolsterAndDisableWeapons( player )
	
	entity mover = CreateScriptMover( player.GetOrigin(), player.GetAngles() )
	player.SetParent( mover, "REF" )
	PhaseRewindData rewindData
	rewindData.origin = player.GetOrigin()
	rewindData.angles = player.GetAngles()
	rewindData.wasInContextAction = player.ContextAction_IsActive()
	rewindData.wasCrouched = player.IsCrouched()

	vector originAtStart = player.GetOrigin()
	vector anglesAtStart = player.GetAngles()
	
	OnThreadEnd( function() : ( player, mover, rewindData, originAtStart, anglesAtStart )
	{
		player.SetPredictionEnabled( true )
		CancelPhaseShift( player )
		DeployAndEnableWeapons( player )
		player.ClearParent()
		ViewConeFree( player )
		
		player.p.burnCardPhaseRewindStruct.phaseRetreatSavedPositions.clear()
		player.p.burnCardPhaseRewindStruct.phaseRetreatShouldSave = true
		
		PutEntityInSafeSpot( player, null, null, player.GetOrigin(), player.GetOrigin() )
		player.SetVelocity( <0, 0, 10> )
		player.SetAngles(anglesAtStart)
		if ( rewindData.wasInContextAction && !PutEntityInSafeSpot( player, null, null, originAtStart, player.GetOrigin() ) )
		//Only do PutEntityInSafeSpot check() if the last saved position they were in a context action, since context actions can put you in normally illegal spots, e.g. behind geo. If you do the PutEntityInSafeSpot() check all the time you get false positives if you always use start position as safe starting spot
			{
				player.TakeDamage( player.GetHealth() + 1, player, player, { damageSourceId = eDamageSourceId.phase_shift, scriptType = DF_GIB | DF_BYPASS_SHIELD | DF_SKIPS_DOOMED_STATE } )
			}
				
		if ( IsValid( mover ) )
				mover.Destroy()
	})
	player.p.burnCardPhaseRewindStruct.phaseRetreatShouldSave = false

	EmitSoundOnEntityOnlyToPlayer( player, player, "pilot_phaserewind_1p" )
	EmitSoundOnEntityExceptToPlayer( player, player, "pilot_phaserewind_3p" )

	player.SetParent( mover, "REF", false )
	ViewConeZeroInstant( player )
	
	array<PhaseRewindData> positions = clone player.p.burnCardPhaseRewindStruct.phaseRetreatSavedPositions
	
	PhaseShift( player, 0, 10 )
	
	StartParticleEffectInWorld( GetParticleSystemIndex( $"P_impact_shieldbreaker_sparks" ), player.GetOrigin(), player.GetAngles() )
	
	for ( int i = positions.len() - 1; i >= 0; i=i-3 )
	{
		mover.NonPhysicsMoveTo( positions[ i ].origin, 0.1, 0, 0 )
		rewindData.origin = positions[i].origin
		rewindData.angles = positions[i].angles
		rewindData.velocity = positions[i].velocity
		rewindData.wasInContextAction = positions[i].wasInContextAction
		rewindData.wasCrouched = positions[i].wasCrouched
		
		if(rewindData.wasCrouched)
			thread PhaseRewindCrouchPlayer( player )
		
		WaitFrame()
	}
	Signal( player, "ForceStopPhaseShift" )
}

void function RecordPositions( entity player )
{
	player.EndSignal( "OnDestroy" )
	
	OnThreadEnd(
		function() : ( player )
		{
			if ( IsValid( player ) )
			{
				player.p.burnCardPhaseRewindStruct.phaseRetreatSavedPositions.clear()
			}
		}
	)

	int maxSaves = PHASE_REWIND_MAX_SNAPSHOTS

	while ( IsValid(player) )
	{
		if(!IsAlive(player))
		{
			WaitFrame()
			continue
		}
		
		if(!IsValid(player.GetOffhandWeapon( OFFHAND_TACTICAL ))) 
		{
			WaitFrame()
			continue
		}
		else if(IsValid(player.GetOffhandWeapon( OFFHAND_TACTICAL )) &&	player.GetOffhandWeapon( OFFHAND_TACTICAL ).GetWeaponClassName() != "mp_ability_phase_rewind") 
		{
			WaitFrame()
			continue
		}
		
		vector playervelocity = player.GetVelocity()
		float velLenght = playervelocity.Length()
		if ( player.p.burnCardPhaseRewindStruct.phaseRetreatShouldSave && velLenght > 0)
		{
			vector origin = player.GetOriginOutOfTraversal()
			vector angles = player.GetAngles()

			PhaseRewindData data
			data.origin = origin
			data.angles = angles
			data.velocity = player.GetVelocity()
			data.wasInContextAction = player.ContextAction_IsActive()
			data.wasCrouched = player.IsCrouched()
			data.time = Time()

			player.p.burnCardPhaseRewindStruct.phaseRetreatSavedPositions.append( data )
			if ( player.p.burnCardPhaseRewindStruct.phaseRetreatSavedPositions.len() > maxSaves )
				player.p.burnCardPhaseRewindStruct.phaseRetreatSavedPositions.remove( 0 )
		}
		WaitFrame()
	}
}

void function PhaseRewindCrouchPlayer( entity player )
{
	Signal( player, "PhaseRewindCrouchPlayer" )
	EndSignal( player, "OnDeath" )
	EndSignal( player, "PhaseRewindCrouchPlayer" )
	player.ForceCrouch()
	OnThreadEnd(
		function() : ( player )
		{
			if ( IsValid( player ) )
			{
				player.UnforceCrouch()
				PutEntityInSafeSpot( player, null, null, player.GetOrigin(), player.GetOrigin() )
			}
		}
	)
	WaitFrame()
}
#endif