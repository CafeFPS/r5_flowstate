global function OnWeaponPrimaryAttack_holopilot
global function OnWeaponChargeLevelIncreased_holopilot
global function PlayerCanUseDecoy

global const int DECOY_FADE_DISTANCE = 16000 //Really just an arbitrarily large number
global const float DECOY_DURATION = 15.0
const float ULTIMATE_DECOY_DURATION = 5.0

global const vector HOLOPILOT_ANGLE_SEGMENT = <0,60,0>
global function Decoy_Init

const DECOY_AR_MARKER = $"P_ar_ping_squad_CP"
const float DECOY_TRACE_DIST = 5000.0

#if SERVER
global function CodeCallback_PlayerDecoyDie
global function CodeCallback_PlayerDecoyDissolve
global function CodeCallback_PlayerDecoyRemove
global function CodeCallback_PlayerDecoyStateChange
global function CreateHoloPilotDecoys
global function SetupDecoy_Common

global function GetDecoyActiveCountForPlayer
#endif // SERVER

const DECOY_FLAG_FX = $"P_flag_fx_foe"
const HOLO_EMITTER_CHARGE_FX_1P = $"P_mirage_holo_emitter_glow_FP"
const HOLO_EMITTER_CHARGE_FX_3P = $"P_mirage_emitter_flash"
const asset DECOY_TRIGGERED_ICON = $"rui/hud/tactical_icons/tactical_mirage_in_world"

struct
{
	table<entity, int> playerToDecoysActiveTable //Mainly used to track stat for holopilot unlock
} file


void function Decoy_Init()
{
	#if SERVER
	RegisterSignal( "CleanupFXAndSoundsForDecoy" )
	RegisterSignal( "MirageSpotted" )
	PrecacheParticleSystem( HOLO_EMITTER_CHARGE_FX_1P )
	PrecacheParticleSystem( HOLO_EMITTER_CHARGE_FX_3P )
	#else
	PrecacheParticleSystem( DECOY_AR_MARKER )
	#endif
}

#if SERVER
void function CleanupExistingDecoy( entity decoy )
{
	if ( IsValid( decoy ) ) //This cleanup function is called from multiple places, so check that decoy is still valid before we try to clean it up again
	{
		decoy.Decoy_Dissolve()
		CleanupFXAndSoundsForDecoy( decoy )
	}
}

void function CleanupFXAndSoundsForDecoy( entity decoy )
{
	if ( !IsValid( decoy ) )
		return

	decoy.Signal( "CleanupFXAndSoundsForDecoy" )

	foreach ( fx in decoy.decoy.fxHandles )
	{
		if ( IsValid( fx ) )
		{
			fx.ClearParent()
			EffectStop( fx )
		}
	}

	decoy.decoy.fxHandles.clear() //probably not necessary since decoy is already being cleaned up, just for throughness.

	foreach ( loopingSound in decoy.decoy.loopingSounds )
	{
		StopSoundOnEntity( decoy, loopingSound )
	}

	decoy.decoy.loopingSounds.clear()
}

void function OnHoloPilotDestroyed( entity decoy )
{
	 entity bossPlayer = decoy.GetBossPlayer()
	if ( IsValid( bossPlayer ) )
	{
		EmitSoundAtPositionOnlyToPlayer( TEAM_ANY, decoy.GetOrigin(), bossPlayer, "Mirage_PsycheOut_Decoy_End_1P" )
		EmitSoundAtPositionExceptToPlayer( TEAM_ANY, decoy.GetOrigin(), bossPlayer, "Mirage_PsycheOut_Decoy_End_3P" )
	}

	CleanupFXAndSoundsForDecoy( decoy )
}

void function CodeCallback_PlayerDecoyDie( entity decoy, int currentState ) //All Die does is play the death animation. Eventually calls CodeCallback_PlayerDecoyDissolve too
{
	//PrintFunc()
	OnHoloPilotDestroyed( decoy )
}

void function CodeCallback_PlayerDecoyDissolve( entity decoy, int currentState )
{
	//PrintFunc()
	OnHoloPilotDestroyed( decoy )
}

void function CodeCallback_PlayerDecoyRemove( entity decoy, int currentState )
{
	//PrintFunc()
}

void function CodeCallback_PlayerDecoyStateChange( entity decoy, int previousState, int currentState )
{
	//PrintFunc()
}
#endif // SERVER


var function OnWeaponPrimaryAttack_holopilot( entity weapon, WeaponPrimaryAttackParams attackParams )
{
	entity weaponOwner = weapon.GetWeaponOwner()
	Assert( weaponOwner.IsPlayer() )

	if ( !PlayerCanUseDecoy( weaponOwner ) )
		return 0

	int chargeLevel = weapon.IsChargeWeapon() ? weapon.GetWeaponChargeLevel() : 1
	if ( weapon.GetWeaponChargeLevelMax() > 1 )
		chargeLevel *= 2 // We want to send  out 6, but the charge visual is tied to the level being 3
	//chargeLevel = int( min( chargeLevel, weapon.GetWeaponPrimaryClipCount() / weapon.GetWeaponSettingInt( eWeaponVar.ammo_min_to_fire ) ) )
#if SERVER
	CreateHoloPilotDecoys( weaponOwner, chargeLevel )
	if ( chargeLevel <= 1 )
	{
		thread PlayBattleChatterLineDelayedToSpeakerAndTeam( weaponOwner, "bc_tactical", 0.2 )
	}
#else
	if ( chargeLevel == 1 )
		CreateARIndicator( weaponOwner )
#endif

	PlayerUsedOffhand( weaponOwner, weapon )

	return weapon.GetWeaponSettingInt( eWeaponVar.ammo_min_to_fire ) //* chargeLevel
}

#if CLIENT
void function CreateARIndicator( entity player )
{
	vector eyePos = player.EyePosition()
	vector viewVector = player.GetViewVector()
	TraceResults trace = TraceLine( eyePos, eyePos + (viewVector * DECOY_TRACE_DIST), player, TRACE_MASK_SOLID_BRUSHONLY, TRACE_COLLISION_GROUP_NONE )
	if ( trace.fraction < 1.0 )
	{
		trace = TraceLine( trace.endPos, trace.endPos + <0,0,-2000 * trace.fraction >, player, TRACE_MASK_SOLID_BRUSHONLY, TRACE_COLLISION_GROUP_NONE )
		int arID = GetParticleSystemIndex( DECOY_AR_MARKER )
		int fxHandle = StartParticleEffectInWorldWithHandle( arID, trace.endPos, trace.surfaceNormal )
		EffectSetControlPointVector( fxHandle, 1, FRIENDLY_COLOR_FX )
		thread DestroyAfterTime( fxHandle, 1.0 )
	}
}

void function DestroyAfterTime( int fxHandle, float time )
{
	OnThreadEnd(
		function() : ( fxHandle )
		{
			if ( !EffectDoesExist( fxHandle ) )
				return

			EffectStop( fxHandle, true, true )
		}
	)
	wait( time )
}
#endif

#if SERVER
void function CreateHoloPilotDecoys( entity player, int numberOfDecoysToMake = 1, string animToPlay = "", vector offsetOrigin = <-1,-1,-1>, vector angleOverride = <-1,-1,-1> )
{
	Assert( numberOfDecoysToMake > 0 )
	Assert( player )

	float displacementDistance = 30.0

	bool setOriginAndAngles = numberOfDecoysToMake > 1 || angleOverride != <-1,-1,-1>

	asset modelName = $""
	ItemFlavor character = LoadoutSlot_GetItemFlavor( ToEHI( player ), Loadout_CharacterClass() )
	ItemFlavor skin = LoadoutSlot_GetItemFlavor( ToEHI( player ), Loadout_CharacterSkin( character ) )

	vector eyePos = player.EyePosition()
	vector viewVector = player.GetViewVector()
	for ( int i = 0; i < numberOfDecoysToMake; ++i )
	{
		entity decoy
		if ( setOriginAndAngles )
		{
			vector angleToAdd = angleOverride != <-1,-1,-1> ? angleOverride : CalculateAngleSegmentForDecoy( i, HOLOPILOT_ANGLE_SEGMENT )
			vector normalizedAngle = player.GetAngles() +  angleToAdd
			normalizedAngle.y = AngleNormalize( normalizedAngle.y ) //Only care about changing the yaw
			vector forwardVector = AnglesToForward( normalizedAngle )
 			TraceResults trace = TraceLine( eyePos, eyePos + (forwardVector * 100), player, TRACE_MASK_SOLID_BRUSHONLY, TRACE_COLLISION_GROUP_NONE )
 			decoy = CreateDecoy( trace.endPos, $"", modelName, player, skin, ULTIMATE_DECOY_DURATION )
			decoy.SetAngles( normalizedAngle )
			forwardVector *= displacementDistance
			vector baseOrigin = offsetOrigin != <-1,-1,-1> ? offsetOrigin + <0,0,25> : player.GetOrigin()
			decoy.SetOrigin( baseOrigin + forwardVector ) //Using player origin instead of decoy origin as defensive fix, see bug 223066
			PutEntityInSafeSpot( decoy, player, null, baseOrigin, decoy.GetOrigin() )
		}
		else if ( animToPlay != "" )
		{
 			decoy = player.CreateAnimatedPlayerDecoy( animToPlay )
			thread CleanUpPassiveDecoyIfExecuted( decoy, player )
		}
		else
		{
			//ValidDecoyDisguise vdd = SetNextDisguiseCharacter( player )
			//modelName = CharacterSkin_GetBodyModel( vdd.skin )
			//skin = vdd.skin
			asset characterSetFile = $""//CharacterClass_GetSetFile( vdd.character )
			TraceResults trace = TraceLine( eyePos, eyePos + (viewVector * DECOY_TRACE_DIST), player, TRACE_MASK_SOLID_BRUSHONLY, TRACE_COLLISION_GROUP_NONE )
 			decoy = CreateDecoy( trace.endPos, characterSetFile, modelName, player, skin, DECOY_DURATION )
		}

		bool ultimateDecoy = numberOfDecoysToMake > 1
		SetupDecoy_Common( player, decoy, ultimateDecoy )
		if ( animToPlay != "" )
		{
			decoy.SetMaxHealth( 2000 )
			decoy.SetHealth( 2000 )
			SetObjectCanBeMeleed( decoy, false )
			decoy.SetPlayerOneHits( false )
		}

		thread MonitorDecoyActiveForPlayer( decoy, player )
	}
}

void function CleanUpPassiveDecoyIfExecuted( entity decoy, entity player )
{
	player.EndSignal( "OnSyncedMeleeVictim" )
	decoy.EndSignal( "OnDestroy" )

	OnThreadEnd(
	function() : ( decoy, player )
		{
			if ( IsValid( player ) && IsCloaked( player ) )
				DisableCloak( player )
			CleanupExistingDecoy( decoy ) //Is valid check in function
		}
	)

	wait ULTIMATE_DECOY_DURATION
}

/*
ValidDecoyDisguise function SetNextDisguiseCharacter( entity player )
{
	ValidDecoyDisguise vdd
	vdd.character = expect ItemFlavor(GetRandomGoodItemFlavorForLoadoutSlot( EHI_null, Loadout_CharacterClass() ))
	vdd.skin = expect ItemFlavor(GetRandomGoodItemFlavorForLoadoutSlot( ToEHI( player ), Loadout_CharacterSkin( vdd.character ) ))
	return vdd
}
*/

entity function CreateDecoy( vector endPosition, asset settingsName, asset modelName, entity player, ItemFlavor skin, float duration )
{
	entity decoy = player.CreateTargetedPlayerDecoy( endPosition, settingsName, modelName, 0, 0 )
	CharacterSkin_Apply( decoy, skin )
	decoy.SetMaxHealth( 50 )
	decoy.SetHealth( 50 )
	decoy.EnableAttackableByAI( 50, 0, AI_AP_FLAG_NONE )
	SetObjectCanBeMeleed( decoy, true )
	decoy.SetTimeout( duration )
	decoy.SetPlayerOneHits( true )

	StatsHook_HoloPiliot_OnDecoyCreated( player )
	AddEntityCallback_OnPostDamaged( decoy, void function( entity decoy, var damageInfo ) : ( player ) {
		if ( IsValid( player ) )
			HoloPiliot_OnDecoyDamaged( decoy, player, damageInfo )
	})
	return decoy
}

void function HoloPiliot_OnDecoyDamaged( entity decoy, entity owner, var damageInfo )
{
	entity attacker = DamageInfo_GetAttacker( damageInfo )
	if ( !IsValid( attacker ) || !attacker.IsPlayer() || !IsEnemyTeam( owner.GetTeam(), attacker.GetTeam() ) )
		return

	if ( decoy.e.attachedEnts.contains( attacker ) )
		return

	StatsHook_HoloPiliot_OnDecoyDamaged( decoy, owner, attacker, damageInfo )

	decoy.e.attachedEnts.append( attacker )

	PingForDecoyTriggered( owner, attacker )
}

entity function PingForDecoyTriggered( entity playerOwner, entity targetEnt )
{
	if ( playerOwner.IsPlayer() )
		EmitSoundOnEntityOnlyToPlayer( playerOwner, playerOwner, "ui_mapping_item_1p" )

	entity wp = CreateWaypoint_BasicPos( targetEnt.GetOrigin() + <0,0,96>, "", DECOY_TRIGGERED_ICON )
	wp.SetOwner( playerOwner )
	wp.SetOnlyTransmitToSingleTeam( playerOwner.GetTeam() )
	targetEnt.Signal( "MirageSpotted" )
	thread DelayedDestroyWP( wp, targetEnt )
	return wp
}

void function DelayedDestroyWP( entity wp, entity targetEnt )
{
	wp.EndSignal( "OnDestroy" )
	targetEnt.EndSignal( "MirageSpotted" )

	OnThreadEnd(
	function() : ( wp )
		{
			if ( IsValid( wp ) )
				wp.Destroy()
		}
	)

	wait 2.5
}

void function SetupDecoy_Common( entity player, entity decoy, bool ultimateDecoy = false ) //functioned out mainly so holopilot execution can call this as well
{
	decoy.SetDeathNotifications( true )
	decoy.SetPassThroughThickness( 0 )
	decoy.SetNameVisibleToOwner( true )
	decoy.SetNameVisibleToFriendly( true )
	decoy.SetNameVisibleToEnemy( true )
	decoy.SetDecoyRandomPulseRateMax( 0.5 ) //pulse amount per second
	decoy.SetFadeDistance( DECOY_FADE_DISTANCE )
	decoy.SetBossPlayer( player )

	int friendlyTeam = decoy.GetTeam()
	if ( ultimateDecoy )
	{
		EmitSoundOnEntityToTeam( decoy, "Mirage_Vanish_Decoy_Sustain", friendlyTeam ) //loopingSound
		EmitSoundOnEntityToEnemies( decoy, "Mirage_Vanish_Decoy_Sustain_Enemy", friendlyTeam ) ///loopingSound
		decoy.decoy.loopingSounds = [ "Mirage_Vanish_Decoy_Sustain", "Mirage_Vanish_Decoy_Sustain_Enemy" ]
	}
	else
	{
		EmitSoundOnEntityToTeam( decoy, "Mirage_PsycheOut_Decoy_Sustain", friendlyTeam ) //loopingSound
		EmitSoundOnEntityToEnemies( decoy, "Mirage_PsycheOut_Decoy_Sustain_Enemy", friendlyTeam ) ///loopingSound
		decoy.decoy.loopingSounds = [ "Mirage_PsycheOut_Decoy_Sustain", "Mirage_PsycheOut_Decoy_Sustain_Enemy" ]
	}

	Highlight_SetFriendlyHighlight( decoy, "friendly_player_decoy" )
	Highlight_SetOwnedHighlight( decoy, "friendly_player_decoy" )
	decoy.e.hasDefaultEnemyHighlight = player.e.hasDefaultEnemyHighlight
	SetDefaultMPEnemyHighlight( decoy )

	int attachID = decoy.LookupAttachment( "CHESTFOCUS" )

	var childEnt = player.FirstMoveChild()
	while ( childEnt != null )
	{
		expect entity( childEnt )

		bool isBattery = false
		bool createHologram = false
		switch ( childEnt.GetClassName() )
		{
			case "item_titan_battery":
			{
				isBattery = true
				createHologram = true
				break
			}

			case "item_flag":
			{
				createHologram = true
				break
			}
		}

		asset modelName = childEnt.GetModelName()
		if ( createHologram && modelName != $"" && childEnt.GetParentAttachment() != "" )
		{
			entity decoyChildEnt = CreatePropDynamic( modelName, <0,0,0>, <0,0,0>, 0 )
			decoyChildEnt.Highlight_SetInheritHighlight( true )
			decoyChildEnt.SetParent( decoy, childEnt.GetParentAttachment() )

			if ( isBattery )
				thread Decoy_BatteryFX( decoy, decoyChildEnt )
			else
				thread Decoy_FlagFX( decoy, decoyChildEnt )
		}

		childEnt = childEnt.NextMovePeer()
	}

	entity holoPilotTrailFX = StartParticleEffectOnEntity_ReturnEntity( decoy, HOLO_PILOT_TRAIL_FX, FX_PATTACH_POINT_FOLLOW, attachID )
	SetTeam( holoPilotTrailFX, friendlyTeam )
	holoPilotTrailFX.kv.VisibilityFlags = ENTITY_VISIBLE_TO_FRIENDLY

	decoy.decoy.fxHandles.append( holoPilotTrailFX )
	decoy.SetFriendlyFire( false )
	decoy.SetKillOnCollision( false )
}

vector function CalculateAngleSegmentForDecoy( int loopIteration, vector angleSegment )
{
	if ( loopIteration == 0 )
		return <0,0,0>

	if ( loopIteration % 2 == 0 )
		return ( loopIteration / 2 ) * angleSegment * -1
	else
		return ( ( loopIteration / 2 ) + 1 ) * angleSegment

	unreachable
}

void function Decoy_BatteryFX( entity decoy, entity decoyChildEnt )
{
	decoy.EndSignal( "OnDeath" )
	decoy.EndSignal( "CleanupFXAndSoundsForDecoy" )

	OnThreadEnd(
		function() : ( decoyChildEnt )
		{
			if ( IsValid( decoyChildEnt ) )
				decoyChildEnt.Destroy()
		}
	)

	WaitForever()
}

void function Decoy_FlagFX( entity decoy, entity decoyChildEnt )
{
	decoy.EndSignal( "OnDeath" )
	decoy.EndSignal( "CleanupFXAndSoundsForDecoy" )

	SetTeam( decoyChildEnt, decoy.GetTeam() )
	entity flagTrailFX = StartParticleEffectOnEntity_ReturnEntity( decoyChildEnt, GetParticleSystemIndex( DECOY_FLAG_FX ), FX_PATTACH_POINT_FOLLOW, decoyChildEnt.LookupAttachment( "fx_end" ) )
	flagTrailFX.kv.VisibilityFlags = ENTITY_VISIBLE_TO_ENEMY

	OnThreadEnd(
		function() : ( flagTrailFX, decoyChildEnt )
		{
			if ( IsValid( flagTrailFX ) )
				flagTrailFX.Destroy()

			if ( IsValid( decoyChildEnt ) )
				decoyChildEnt.Destroy()
		}
	)

	WaitForever()
}

void function MonitorDecoyActiveForPlayer( entity decoy, entity player )
{
	if ( player in file.playerToDecoysActiveTable )
		++file.playerToDecoysActiveTable[ player ]
	else
		file.playerToDecoysActiveTable[ player ] <- 1

	decoy.EndSignal( "OnDestroy" ) //Note that we do this OnDestroy instead of the inbuilt OnHoloPilotDestroyed() etc functions so there is a bit of leeway after the holopilot starts to die/is fully invisible before being destroyed
	player.EndSignal( "OnDestroy" )
	player.EndSignal( "CleanupPlayerPermanents" )

	OnThreadEnd(
	function() : ( player )
		{
			if ( IsValid( player ) )
			{
				Assert( player in file.playerToDecoysActiveTable )
				--file.playerToDecoysActiveTable[ player ]
			}
		}
	)

	//WaitForever()
}

int function GetDecoyActiveCountForPlayer( entity player )
{
	if ( !(player in file.playerToDecoysActiveTable ))
		return 0

	return file.playerToDecoysActiveTable[player ]
}


#endif // SERVER

bool function PlayerCanUseDecoy( entity ownerPlayer ) //For holopilot and HoloPilot Nova. No better place to put this for now
{
	if ( !ownerPlayer.IsZiplining() )
	{
		if ( ownerPlayer.IsTraversing() )
			return false

		if ( ownerPlayer.ContextAction_IsActive() ) //Stops every single context action from letting decoy happen, including rodeo, melee, embarking etc
			return false
	}

	float angleCheckParam = GetCurrentPlaylistVarFloat( "mirageabilitycheck", 0.99 )

	if ( ownerPlayer.GetViewVector().Dot( <0, 0, -1> ) > angleCheckParam )
		return false

	//Do we need to check isPhaseShifted here? Re-examine when it's possible to get both Phase and Decoy (maybe through burn cards?)

	return true
}

bool function OnWeaponChargeLevelIncreased_holopilot( entity weapon )
{
	#if CLIENT
		if ( InPrediction() && !IsFirstTimePredicted() )
			return true
	#endif

	int level = weapon.GetWeaponChargeLevel()
	int maxLevel = weapon.GetWeaponChargeLevelMax()

	if ( level == maxLevel )
	{
		if ( weapon.HasMod( "disguise" ) )
		{
		//	weapon.EmitWeaponSound_1p3p( "weapon_peacekeeper_leveltick_final", "weapon_peacekeeper_leveltick_final_3p" )
		//	weapon.PlayWeaponEffect( HOLO_EMITTER_CHARGE_FX_1P, HOLO_EMITTER_CHARGE_FX_3P, "FX_EMITTER_L_03" )
		}
		else
		{
		//	weapon.EmitWeaponSound_1p3p( "weapon_peacekeeper_leveltick_final", "weapon_peacekeeper_leveltick_final_3p" )
			weapon.PlayWeaponEffect( HOLO_EMITTER_CHARGE_FX_1P, HOLO_EMITTER_CHARGE_FX_3P, "FX_EMITTER_L_01" )

		}
	}
	else
	{
		switch ( level )
		{
			case 1:
			//	weapon.PlayWeaponEffect( HOLO_EMITTER_CHARGE_FX_1P, HOLO_EMITTER_CHARGE_FX_3P, "FX_EMITTER_L_01" )
			//	weapon.EmitWeaponSound_1p3p( "weapon_peacekeeper_leveltick_1", "weapon_peacekeeper_leveltick_1_3p" )
			//	break

			case 2:
			//	weapon.PlayWeaponEffect( HOLO_EMITTER_CHARGE_FX_1P, HOLO_EMITTER_CHARGE_FX_3P, "FX_EMITTER_L_02" )
			//	weapon.EmitWeaponSound_1p3p( "weapon_peacekeeper_leveltick_2", "weapon_peacekeeper_leveltick_2_3p" )
			//	break
		}
	}

	return true
}