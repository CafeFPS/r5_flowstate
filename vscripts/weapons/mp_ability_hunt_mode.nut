global function OnWeaponPrimaryAttack_hunt_mode
global function MpAbilityHuntModeWeapon_Init
global function MpAbilityHuntModeWeapon_OnWeaponTossPrep
global function OnWeaponDeactivate_hunt_mode

#if SERVER
global function BurnMeter_HuntMode
#endif //SERVER
#if DEVELOPER && CLIENT 
global function GetBloodhoundColorCorrectionID
#endif //

const float HUNT_MODE_DURATION = 30
const asset HUNT_MODE_ACTIVATION_SCREEN_FX = $"P_hunt_screen"
const asset HUNT_MODE_BODY_FX = $"P_hunt_body"

struct
{
	#if CLIENT
	int colorCorrection = -1
	#endif //CLIENT
} file

void function MpAbilityHuntModeWeapon_Init()
{
	#if SERVER
		PrecacheParticleSystem( HUNT_MODE_BODY_FX )

	#endif //SERVER

	RegisterSignal( "HuntMode_ForceAbilityStop" )
	AddCallback_GameStateEnter( eGameState.WinnerDetermined, StopHuntMode )

	#if CLIENT
		RegisterSignal( "HuntMode_StopColorCorrection" )
		RegisterSignal( "HuntMode_StopActivationScreenFX" )
		//file.colorCorrection = ColorCorrection_Register_WRAPPER( "materials/correction/hunt_mode.raw" )
		file.colorCorrection = ColorCorrection_Register( "materials/correction/ability_hunt_mode.raw_hdr" )
		PrecacheParticleSystem( HUNT_MODE_ACTIVATION_SCREEN_FX )
		StatusEffect_RegisterEnabledCallback( eStatusEffect.hunt_mode, HuntMode_StartEffect )
		StatusEffect_RegisterDisabledCallback( eStatusEffect.hunt_mode, HuntMode_StopEffect )
		StatusEffect_RegisterEnabledCallback( eStatusEffect.hunt_mode_visuals, HuntMode_StartVisualEffect )
		StatusEffect_RegisterDisabledCallback( eStatusEffect.hunt_mode_visuals, HuntMode_StopVisualEffect )
	#endif
}

void function MpAbilityHuntModeWeapon_OnWeaponTossPrep( entity weapon, WeaponTossPrepParams prepParams )
{
	entity weaponOwner = weapon.GetWeaponOwner()
	
	if( !IsValid( weaponOwner ) || !weaponOwner.IsPlayer() )
		return
	
	weapon.SetScriptTime0( 0.0 )

	#if SERVER
		ItemFlavor character = LoadoutSlot_GetItemFlavor( ToEHI( weaponOwner ), Loadout_CharacterClass() )
		string charRef = ItemFlavor_GetHumanReadableRef( character )

		if( charRef == "character_bloodhound")		
			thread PlayBattleChatterLineDelayedToSpeakerAndTeam( weaponOwner, "bc_super", 0.1 )

		Embark_Disallow( weaponOwner )
		DisableMantle( weaponOwner )
		LockWeaponsAndMelee( weaponOwner )

		// temp fix to stop the issue with wallclimb holstering weapons.
		const ACTIVATION_TIME = 2.1
		StatusEffect_AddTimed( weaponOwner, eStatusEffect.disable_wall_run_and_double_jump, 1.0, ACTIVATION_TIME, 0.0 )
	#endif
}

var function OnWeaponPrimaryAttack_hunt_mode( entity weapon, WeaponPrimaryAttackParams attackParams )
{
	entity weaponOwner = weapon.GetWeaponOwner()
	Assert ( weaponOwner.IsPlayer() )

	//Activate hunt mode
	#if SERVER
		thread HuntMode_Start( weaponOwner )
	#endif //SERVER

	#if CLIENT
		thread HuntMode_PlayActivationScreenFX( weaponOwner )
	#endif //CLIENT

	PlayerUsedOffhand( weaponOwner, weapon )

	return weapon.GetWeaponSettingInt( eWeaponVar.ammo_min_to_fire )
}

void function OnWeaponDeactivate_hunt_mode( entity weapon )
{
	entity weaponOwner = weapon.GetWeaponOwner()

	#if SERVER
		Embark_Allow( weaponOwner )
		EnableMantle(weaponOwner)
		UnlockWeaponsAndMelee( weaponOwner )
	#endif //SERVER
}

#if SERVER

void function BurnMeter_HuntMode( entity player )
{
	thread HuntMode_Start( player )
}

void function HuntMode_Start( entity player )
{
	Assert( IsNewThread(), "Must be threaded off." )
	player.EndSignal( "OnDeath" )
	//EmitSoundOnEntityOnlyToPlayer( player, player, "beastofthehunt_activate_1P" )
	EmitSoundOnEntityExceptToPlayer( player, player, "beastofthehunt_activate_3P" )

	StatusEffect_AddTimed( player, eStatusEffect.threat_vision, 1.0, HUNT_MODE_DURATION, 5.0 )
	StatusEffect_AddTimed( player, eStatusEffect.hunt_mode, 1.0, HUNT_MODE_DURATION, HUNT_MODE_DURATION )
	StatusEffect_AddTimed( player, eStatusEffect.hunt_mode_visuals, 1.0, HUNT_MODE_DURATION, 5.0 )
	StatusEffect_AddTimed( player, eStatusEffect.speed_boost, 0.15, HUNT_MODE_DURATION, 5.0 )

	thread HuntMode_PlayLoopingBodyFx( player )

	
	
	
	OnThreadEnd(
	function() : ( player )
		{
			if ( IsValid( player ) )
			{
				StatusEffect_StopAllOfType( player, eStatusEffect.threat_vision )
				StatusEffect_StopAllOfType( player, eStatusEffect.hunt_mode )
				StatusEffect_StopAllOfType( player, eStatusEffect.hunt_mode_visuals )
				StatusEffect_StopAllOfType( player, eStatusEffect.speed_boost )
			}
		}
	)

	wait HUNT_MODE_DURATION
}

void function HuntMode_PlayLoopingBodyFx( entity player )
{
	Assert ( IsNewThread(), "Must be threaded off." )
	
	player.EndSignal( "OnDeath" )
	player.EndSignal( "OnDestroy" )
	player.EndSignal( "HuntMode_ForceAbilityStop" )
	player.EndSignal( "BleedOut_OnStartDying" )

	int AttachmentID = player.LookupAttachment( "HEADSHOT" )
	int fxid = GetParticleSystemIndex( HUNT_MODE_BODY_FX )

	entity fxHandle = StartParticleEffectOnEntity_ReturnEntity( player, fxid, FX_PATTACH_POINT_FOLLOW, AttachmentID )

	EmitSoundOnEntityOnlyToPlayer( player, player, "beastofthehunt_loop_1P" )
	EmitSoundOnEntityExceptToPlayer( player, player, "beastofthehunt_loop_3P" )

	fxHandle.SetOwner( player )
	fxHandle.kv.VisibilityFlags = (ENTITY_VISIBLE_TO_FRIENDLY | ENTITY_VISIBLE_TO_ENEMY) // not owner only

	OnThreadEnd(
		function() : ( player, fxHandle )
		{
			if ( IsValid( fxHandle ) )
				EffectStop( fxHandle )

			if ( IsValid( player ) )
			{
				StopSoundOnEntity( player, "beastofthehunt_loop_1P" )
				StopSoundOnEntity( player, "beastofthehunt_loop_3P" )
			}
		}
	)

	const FADE_DURATION = 2.0
	wait HUNT_MODE_DURATION - FADE_DURATION

	StopSoundOnEntity( player, "beastofthehunt_loop_1P" )
	StopSoundOnEntity( player, "beastofthehunt_loop_3P" )

	EmitSoundOnEntityOnlyToPlayer( player, player, "BeastOfTheHunt_End_1p" )
	EmitSoundOnEntityExceptToPlayer( player, player, "BeastOfTheHunt_End_3p" )

	wait FADE_DURATION
}

#endif //SERVER

#if CLIENT
void function HuntMode_UpdatePlayerScreenColorCorrection( entity player )
{
	Assert ( IsNewThread(), "Must be threaded off." )
	Assert ( player == GetLocalViewPlayer() )

	player.EndSignal( "OnDeath" )
	player.EndSignal( "OnDestroy" )
	player.EndSignal( "HuntMode_ForceAbilityStop" )
	player.EndSignal( "HuntMode_StopColorCorrection" )
	player.EndSignal( "BleedOut_OnStartDying" )

	OnThreadEnd(
	function() : ( player )
		{
			ColorCorrection_SetWeight( file.colorCorrection, 0.0 )
			ColorCorrection_SetExclusive( file.colorCorrection, false )
		}
	)

	ColorCorrection_SetExclusive( file.colorCorrection, true )
	ColorCorrection_SetWeight( file.colorCorrection, 1.0 )

	const FOV_SCALE = 1.00
	const LERP_IN_TIME = 0.0125	// hack! because statusEffect doesn't seem to have a lerp in feature?
	float startTime = Time()

	while ( true )
	{
		float weight = StatusEffect_GetSeverity( player, eStatusEffect.hunt_mode_visuals )
		//printt( weight )
		weight = GraphCapped( Time() - startTime, 0, LERP_IN_TIME, 0, weight )

		ColorCorrection_SetWeight( file.colorCorrection, weight )

		float fovScale = GraphCapped( weight, 0, 1, 1, FOV_SCALE )
		player.SetFOVScale( fovScale, 1 )	// adding a lerp time here increases the total lerp I think

		WaitFrame()
	}
}

void function HuntMode_StartEffect( entity ent, int statusEffect, bool actuallyChanged )
{
	if ( !actuallyChanged && GetLocalViewPlayer() == GetLocalClientPlayer() )
		return

	if ( ent != GetLocalViewPlayer() )
		return
}

void function HuntMode_StopEffect( entity ent, int statusEffect, bool actuallyChanged )
{
	if ( !actuallyChanged && GetLocalViewPlayer() == GetLocalClientPlayer() )
		return

	if ( ent != GetLocalViewPlayer() )
		return
}

void function HuntMode_StartVisualEffect( entity ent, int statusEffect, bool actuallyChanged )
{
	if ( !actuallyChanged && GetLocalViewPlayer() == GetLocalClientPlayer() )
		return

	if ( ent != GetLocalViewPlayer() )
		return

	GfxDesaturate( true )
	Chroma_StartHuntMode()
	thread HuntMode_UpdatePlayerScreenColorCorrection( ent )
	thread HuntMode_PlayActivationScreenFX( ent )
}

void function HuntMode_StopVisualEffect( entity ent, int statusEffect, bool actuallyChanged )
{
	if ( !actuallyChanged && GetLocalViewPlayer() == GetLocalClientPlayer() )
		return

	if ( ent != GetLocalViewPlayer() )
		return

	GfxDesaturate( false )
	Chroma_EndHuntMode()
	ent.Signal( "HuntMode_StopColorCorrection" )
	ent.Signal( "HuntMode_StopActivationScreenFX" )
}

void function HuntMode_PlayActivationScreenFX( entity clientPlayer )
{
	Assert ( IsNewThread(), "Must be threaded off." )
	clientPlayer.EndSignal( "OnDeath" )
	clientPlayer.EndSignal( "OnDestroy" )
	clientPlayer.EndSignal( "HuntMode_ForceAbilityStop" )
	clientPlayer.EndSignal( "BleedOut_OnStartDying" )

	entity viewPlayer = GetLocalViewPlayer()
	int fxid        = GetParticleSystemIndex( HUNT_MODE_ACTIVATION_SCREEN_FX )

	int fxHandle = StartParticleEffectOnEntity( viewPlayer, fxid, FX_PATTACH_ABSORIGIN_FOLLOW, -1 )
	EffectSetIsWithCockpit( fxHandle, true )
	Effects_SetParticleFlag( fxHandle, PARTICLE_SCRIPT_FLAG_NO_DESATURATE, true )


	OnThreadEnd(
		function() : ( clientPlayer, fxHandle )
		{
			if ( IsValid( clientPlayer ) && IsAlive( clientPlayer ) )
			{
				if ( EffectDoesExist( fxHandle ) )
					EffectStop( fxHandle, false, true )
			}
		}
	)

	clientPlayer.WaitSignal( "HuntMode_StopActivationScreenFX" )
}

#endif //CLIENT

void function ForceStopBlackAndWhiteScreenPls()
{
		foreach ( player in GetPlayerArray() ){
		player.Signal( "HuntMode_ForceAbilityStop" )}
}

void function StopHuntMode()
{
	#if CLIENT
		entity player = GetLocalViewPlayer()
		player.Signal( "HuntMode_ForceAbilityStop" )
	#else
		array<entity> playerArray = GetPlayerArray()
		foreach ( player in playerArray )
			player.Signal( "HuntMode_ForceAbilityStop" )
	#endif
}

#if DEVELOPER && CLIENT 
int function GetBloodhoundColorCorrectionID()
{
	return file.colorCorrection
}
#endif //
