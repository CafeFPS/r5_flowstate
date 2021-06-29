#if SERVER
untyped
#endif

global function SonarGrenade_Init

#if CLIENT
global function ClSonarGrenade_Init
#endif

#if SERVER
global function SonarStartGrenade
global function SonarEndGrenadeGrenade
global function IncrementSonarPerTeamGrenade
global function DecrementSonarPerTeamGrenade
global function OnSonarTriggerLeaveInternalGrenade
global function AddSonarStartGrenadeCallback
#endif

global function OnProjectileCollision_weapon_grenade_sonar
global function OnProjectileIgnite_weapon_grenade_sonar

const asset FLASHEFFECT    = $"wpn_grenade_sonar_impact"

void function SonarGrenade_Init()
{
	PrecacheParticleSystem( $"wpn_grenade_sonar_impact" )
}

#if CLIENT
void function ClSonarGrenade_Init()
{
	PrecacheParticleSystem( $"wpn_grenade_sonar_impact" )
	StatusEffect_RegisterEnabledCallback( eStatusEffect.sonar_detected, EntitySonarDetectedEnabled )
	StatusEffect_RegisterDisabledCallback( eStatusEffect.sonar_detected, EntitySonarDetectedDisabled )

	StatusEffect_RegisterEnabledCallback( eStatusEffect.lockon_detected, EntitySonarDetectedEnabled )
	StatusEffect_RegisterDisabledCallback( eStatusEffect.lockon_detected, EntitySonarDetectedDisabled )

	RegisterSignal( "EntitySonarDetectedDisabled" )
}
#endif

void function OnProjectileCollision_weapon_grenade_sonar( entity projectile, vector pos, vector normal, entity hitEnt, int hitbox, bool isCritical )
{
	#if SERVER
	projectile.proj.onlyAllowSmartPistolDamage = false

	#endif
	if ( IsHumanSized( hitEnt ) )//Don't stick on Pilots/Grunts/Spectres. Causes pulse blade to fall into ground
		return

	bool didStick = PlantStickyGrenade( projectile, pos, normal, hitEnt, hitbox, 4.0, false )

	if ( !didStick )
		return

	if ( projectile.GrenadeHasIgnited() )
		return

	projectile.GrenadeIgnite()
}


void function OnProjectileIgnite_weapon_grenade_sonar( entity projectile )
{
	#if SERVER
		thread SonarGrenadeThink( projectile )
	#endif

	SetObjectCanBeMeleed( projectile, true )

	StartParticleEffectOnEntity( projectile, GetParticleSystemIndex( FLASHEFFECT ), FX_PATTACH_ABSORIGIN_FOLLOW, -1 )
	projectile.SetDoesExplode( false )
}


#if SERVER
struct
{
	table< entity, array<int> > entitySonarHandles
	table< int, int > teamSonarCount
	array< void functionref( entity, vector, int, entity ) > SonarStartGrenadeCallbacks = []
} file

void function AddSonarStartGrenadeCallback( void functionref( entity, vector, int, entity ) callback )
{
	file.SonarStartGrenadeCallbacks.append( callback )
}

void function SonarGrenadeThink( entity projectile )
{
	projectile.EndSignal( "OnDestroy" )

	entity weaponOwner = projectile.GetOwner()

	int team = projectile.GetTeam()
	vector pulseOrigin = projectile.GetOrigin()
	array<entity> ents = []

	entity trigger = CreateTriggerRadiusMultiple( pulseOrigin, SONAR_GRENADE_RADIUS, ents, TRIG_FLAG_START_DISABLED | TRIG_FLAG_NO_PHASE_SHIFT )
	SetTeam( trigger, team )
	trigger.SetOwner( projectile.GetOwner() )

	IncrementSonarPerTeamGrenade( team )

	entity owner = projectile.GetThrower()
	if ( IsValid( owner ) && owner.IsPlayer() )
	{
		array<entity> offhandWeapons = owner.GetOffhandWeapons()
		foreach ( weapon in offhandWeapons )
		{
			//if ( weapon.GetWeaponClassName() == grenade.GetWeaponClassName() ) // function doesn't exist for grenade entities
			if ( weapon.GetWeaponClassName() == "mp_weapon_grenade_sonar" )
			{
				float duration = weapon.GetWeaponSettingFloat( eWeaponVar.grenade_ignition_time ) + 0.75 // buffer cause these don't line up
				StatusEffect_AddTimed( weapon, eStatusEffect.simple_timer, 1.0, duration, duration )
				break
			}
		}
	}


	OnThreadEnd(
		function() : ( projectile, trigger, team )
		{
			DecrementSonarPerTeamGrenade( team )
			trigger.Destroy()
			if ( IsValid( projectile ) )
				projectile.Destroy()
		}
	)

	AddCallback_ScriptTriggerEnter( trigger, OnSonarTriggerEnter )
	AddCallback_ScriptTriggerLeave( trigger, OnSonarTriggerLeave )

	ScriptTriggerSetEnabled( trigger, true )

	if ( IsValid( weaponOwner ) && weaponOwner.IsPlayer() )
	{
		EmitSoundOnEntityExceptToPlayer( projectile, weaponOwner, "Pilot_PulseBlade_Activated_3P" )
		EmitSoundOnEntityOnlyToPlayer( projectile, weaponOwner, "Pilot_PulseBlade_Activated_1P" )
	}
	else
	{
		EmitSoundOnEntity( projectile, "Pilot_PulseBlade_Activated_3P" )
	}

	while ( IsValid( projectile ) )
	{
		pulseOrigin = projectile.GetOrigin()
		trigger.SetOrigin( pulseOrigin )

		array<entity> players = GetPlayerArrayOfTeam( team )

		foreach ( player in players )
		{
			Remote_CallFunction_Replay( player, "ServerCallback_SonarPulseFromPosition", pulseOrigin.x, pulseOrigin.y, pulseOrigin.z, SONAR_GRENADE_RADIUS )
		}

		wait 1.3333
		if ( IsValid( projectile ) )
		{
			if ( IsValid( weaponOwner ) && weaponOwner.IsPlayer() )
			{
				EmitSoundOnEntityExceptToPlayer( projectile, weaponOwner, "Pilot_PulseBlade_Sonar_Pulse_3P" )
				EmitSoundOnEntityOnlyToPlayer( projectile, weaponOwner, "Pilot_PulseBlade_Sonar_Pulse_1P" )
			}
			else
			{
				EmitSoundOnEntity( projectile, "Pilot_PulseBlade_Sonar_Pulse_3P" )
			}
		}
	}
}

void function OnSonarTriggerEnter( entity trigger, entity ent )
{
	if ( !IsEnemyTeam( trigger.GetTeam(), ent.GetTeam() ) )
		return

	if ( ent.e.sonarTriggers.contains( trigger ) )
		return

	ent.e.sonarTriggers.append( trigger )
	SonarStartGrenade( ent, trigger.GetOrigin(), trigger.GetTeam(), trigger.GetOwner() )
}

void function OnSonarTriggerLeave( entity trigger, entity ent )
{
	int triggerTeam = trigger.GetTeam()
	if ( !IsEnemyTeam( triggerTeam, ent.GetTeam() ) )
		return

	OnSonarTriggerLeaveInternalGrenade( trigger, ent )
}

void function OnSonarTriggerLeaveInternalGrenade( entity trigger, entity ent )
{
	if ( !ent.e.sonarTriggers.contains( trigger ) )
		return

	ent.e.sonarTriggers.fastremovebyvalue( trigger )
	SonarEndGrenadeGrenade( ent, trigger.GetTeam() )
}

void function SonarStartGrenade( entity ent, vector position, int sonarTeam, entity sonarOwner )
{

	if ( !("inSonarTriggerCount" in ent.s) )
		ent.s.inSonarTriggerCount <- 0

	ent.s.inSonarTriggerCount++

	bool isVisible = true//!ent.IsPlayer() || ( ent.IsTitan() || !PlayerHasPassive( ent, ePassives.PAS_OFF_THE_GRID ) )

	if ( !(ent in file.entitySonarHandles) )
		file.entitySonarHandles[ent] <- []

	ent.HighlightEnableForTeam( sonarTeam )

	if ( ent.s.inSonarTriggerCount == 1 )
	{

		//Run callbacks for sonar pulse start
		foreach ( callback in file.SonarStartGrenadeCallbacks )
		{
			callback( ent, position, sonarTeam, sonarOwner )
		}

		if ( isVisible )
		{
			if ( !ent.IsPlayer() )
			{
				if ( StatusEffect_GetSeverity( ent, eStatusEffect.damage_received_multiplier ) > 0 )
					Highlight_SetSonarHighlightWithParam0( ent, "enemy_sonar", <1,0,0> )
				else
					Highlight_SetSonarHighlightWithParam1( ent, "enemy_sonar", position )
			}
			else
			{
				ent.SetCloakFlicker( 0.5, -1 )
			}

			Highlight_SetSonarHighlightOrigin( ent, position )
		}

		if ( isVisible )
		{
			int statusEffectHandle = StatusEffect_AddEndless( ent, eStatusEffect.sonar_detected, 1.0 )
			Assert( !file.entitySonarHandles[ent].contains( statusEffectHandle ) )
			file.entitySonarHandles[ent].append( statusEffectHandle )
		}
	}
}

void function SonarEndGrenadeGrenade( entity ent, int team )
{
	if ( !IsValid( ent ) )
		return

	ent.s.inSonarTriggerCount--

	if ( (ent.s.inSonarTriggerCount < file.teamSonarCount[team]) || (ent.s.inSonarTriggerCount <= 0) || (file.teamSonarCount[team] <= 0) )
		ent.HighlightDisableForTeam( team )

	if ( ent.s.inSonarTriggerCount < 1 )
	{
		Assert ( ent in file.entitySonarHandles )
		if ( file.entitySonarHandles[ent].len() )
		{
			int statusEffectHandle = file.entitySonarHandles[ent][0]
			StatusEffect_Stop( ent, statusEffectHandle )
			file.entitySonarHandles[ent].fastremovebyvalue( statusEffectHandle )
		}
		ent.HighlightSetTeamBitField( 0 )

		if ( ent.IsPlayer() )
			ent.SetCloakFlicker( 0, 0 )
	}
}

void function IncrementSonarPerTeamGrenade( int team )
{
	if ( !(team in file.teamSonarCount) )
		file.teamSonarCount[team] <- 0
	file.teamSonarCount[team]++
}

void function DecrementSonarPerTeamGrenade( int team )
{
	if ( team in file.teamSonarCount )
	{
		file.teamSonarCount[team]--

		if ( file.teamSonarCount[team] <= 0 )
			file.teamSonarCount[team] = 0
	}
}
#endif

#if CLIENT


void function EntitySonarDetectedEnabled( entity ent, int statusEffect, bool actuallyChanged )
{
	if ( ent == GetLocalViewPlayer() )
	{
		// player is already lockon highlighted
		if ( statusEffect == eStatusEffect.sonar_detected && StatusEffect_GetSeverity( ent, eStatusEffect.lockon_detected ) )
			return

		entity viewModelEntity = ent.GetViewModelEntity()
		entity firstPersonProxy = ent.GetFirstPersonProxy()
		entity predictedFirstPersonProxy = ent.GetPredictedFirstPersonProxy()

		vector highlightColor = statusEffect == eStatusEffect.sonar_detected ? HIGHLIGHT_COLOR_ENEMY : <1, 0, 0>

		if ( IsValid( viewModelEntity ) )
			SonarViewModelHighlight( viewModelEntity, highlightColor )

		if ( IsValid( firstPersonProxy ) )
			SonarViewModelHighlight( firstPersonProxy, highlightColor )

		if ( IsValid( predictedFirstPersonProxy ) )
			SonarViewModelHighlight( predictedFirstPersonProxy, highlightColor )

		thread PlayLoopingSonarSound( ent )
	}
	else
	{
		ClInitHighlight( ent )
	}
}

void function EntitySonarDetectedDisabled( entity ent, int statusEffect, bool actuallyChanged )
{
	if ( ent == GetLocalViewPlayer() )
	{
		// player should have lockon highlighted
		if ( statusEffect == eStatusEffect.sonar_detected && StatusEffect_GetSeverity( ent, eStatusEffect.lockon_detected ) )
		{
			return
		}
		else if ( statusEffect == eStatusEffect.lockon_detected && StatusEffect_GetSeverity( ent, eStatusEffect.sonar_detected ) )
		{
			// restore sonar after lockon wears off
			EntitySonarDetectedEnabled( ent, eStatusEffect.sonar_detected, true )
			return
		}

		entity viewModelEntity = ent.GetViewModelEntity()
		entity firstPersonProxy = ent.GetFirstPersonProxy()
		entity predictedFirstPersonProxy = ent.GetPredictedFirstPersonProxy()

		if ( IsValid( viewModelEntity ) )
			SonarViewModelClearHighlight( viewModelEntity )

		if ( IsValid( firstPersonProxy ) )
			SonarViewModelClearHighlight( firstPersonProxy )

		if ( IsValid( predictedFirstPersonProxy ) )
			SonarViewModelClearHighlight( predictedFirstPersonProxy )

		ent.Signal( "EntitySonarDetectedDisabled" )
	}
	else
	{
		ClInitHighlight( ent )
	}
}

void function PlayLoopingSonarSound( entity ent )
{
	EmitSoundOnEntity( ent, "HUD_MP_EnemySonarTag_Activated_1P" )

	ent.EndSignal( "EntitySonarDetectedDisabled" )
	ent.EndSignal( "OnDeath" )

	while( true )
	{
		wait 1.5
		EmitSoundOnEntity( ent, "HUD_MP_EnemySonarTag_Flashed_1P" )
	}

}
#endif