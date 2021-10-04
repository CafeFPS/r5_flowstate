
global function MpAbilityGibraltarShield_Init

global function OnWeaponActivate_ability_gibraltar_shield
global function OnWeaponDeactivate_ability_gibraltar_shield
global function OnWeaponAttemptOffhandSwitch_ability_gibraltar_shield
global function OnWeaponPrimaryAttack_ability_gibraltar_shield
global function OnWeaponChargeBegin_ability_gibraltar_shield
global function OnWeaponChargeEnd_ability_gibraltar_shield
global function OnWeaponOwnerChanged_ability_gibraltar_shield

global function GibraltarShield_RegisterNetworkFunctions

const vector SHIELD_ANGLE_OFFSET = <0,-90,0>
const asset FX_GUN_SHIELD_WALL = $"P_gun_shield_gibraltar_3P"
const asset FX_GUN_SHIELD_BREAK = $"P_gun_shield_gibraltar_break_CP_3P"
const asset FX_GUN_SHIELD_BREAK_FP = $"P_gun_shield_gibraltar_break_CP_FP"
const asset FX_GUN_SHIELD_SHIELD_COL = $"mdl/fx/gibralter_gun_shield.rmdl"

const string SOUND_PILOT_GUN_SHIELD_3P = "Gibraltar_GunShield_Sustain_3P"
const string SOUND_PILOT_GUN_SHIELD_1P = "Gibraltar_GunShield_Sustain_1P"
const string SOUND_PILOT_GUN_SHIELD_BREAK_1P = "Gibraltar_GunShield_Destroyed_1P"
const string SOUND_PILOT_GUN_SHIELD_BREAK_3P = "Gibraltar_GunShield_Destroyed_3P"

const bool PILOT_GUN_SHIELD_DRAIN_AMMO = false
const float PILOT_GUN_SHIELD_DRAIN_AMMO_RATE = 1.0

const PLAYER_GUN_SHIELD_WALL_RADIUS = 18
const PLAYER_GUN_SHIELD_WALL_HEIGHT = 32
const PLAYER_GUN_SHIELD_WALL_FOV = 85

const int PILOT_SHIELD_OFFHAND_INDEX = OFFHAND_EQUIPMENT

struct
{
	var shieldRegenRui
} file

void function MpAbilityGibraltarShield_Init()
{
	PrecacheWeapon( "mp_ability_gibraltar_shield" )

	PrecacheModel( FX_GUN_SHIELD_SHIELD_COL )

	PrecacheParticleSystem( FX_GUN_SHIELD_WALL )
	PrecacheParticleSystem( FX_GUN_SHIELD_BREAK_FP )
	PrecacheParticleSystem( FX_GUN_SHIELD_BREAK )

	RegisterSignal( "ShieldWeaponThink" )
	RegisterSignal( "DestroyPlayerShield" )

	#if CLIENT
	RegisterConCommandTriggeredCallback( "+scriptCommand5", GunShieldTogglePressed )
	#endif

	#if SERVER
	AddClientCommandCallback( "ToggleGibraltarShield", ClientCommand_ToggleGibraltarShield )
	AddCallback_OnPassiveChanged( ePassives.PAS_ADS_SHIELD, PilotShield_OnPassiveChanged )
	#endif
}

bool function OnWeaponChargeBegin_ability_gibraltar_shield( entity weapon )
{
	entity player = weapon.GetWeaponOwner()
	if ( player.IsPlayer() )
	{
		#if SERVER
		CreateGibraltarShield( player, weapon )
		#elseif CLIENT
		if ( file.shieldRegenRui == null )
		{
			CreateShieldRegenRui( weapon )
		}
		if ( InPrediction() && IsFirstTimePredicted() )
		{
			if ( player.GetSharedEnergyCount() > 0 )
			{
				weapon.EmitWeaponSound_1p3p( SOUND_PILOT_GUN_SHIELD_1P, SOUND_PILOT_GUN_SHIELD_3P )
			}
		}
		//TrackFirstPersonGunShield( weapon, FX_GUN_SHIELD_WALL_FP, "muzzle_flash" )
		#endif

	}
	return true
}


void function GibraltarShield_RegisterNetworkFunctions()
{
}


void function OnWeaponOwnerChanged_ability_gibraltar_shield( entity weapon, WeaponOwnerChangedParams changeParams )
{
	#if CLIENT
		if ( file.shieldRegenRui == null && changeParams.newOwner == GetLocalViewPlayer() )
		{
			CreateShieldRegenRui( weapon )
		}
		else if ( changeParams.newOwner != GetLocalViewPlayer() )
		{
			if ( file.shieldRegenRui != null )
			{
				RuiDestroy( file.shieldRegenRui )
				file.shieldRegenRui = null
			}
		}
	#endif
}

#if CLIENT
void function CreateShieldRegenRui( entity weapon )
{
	file.shieldRegenRui = CreateCockpitRui( $"ui/gibraltar_shield_regen.rpak" )
	RuiTrackBool( file.shieldRegenRui, "weaponIsDisabled", weapon, RUI_TRACK_WEAPON_IS_DISABLED )

	thread TrackPrimaryWeapon()
}

void function TrackPrimaryWeapon()
{
	entity oldPrimary
	bool oldPlayerUsePrompts

	while ( file.shieldRegenRui != null )
	{
		entity player = GetLocalViewPlayer()

		if ( IsAlive( player ) )
		{
			entity newPrimary = player.GetActiveWeapon( eActiveInventorySlot.mainHand )
			bool newPlayerUsePrompts = GetConVarBool( "disable_player_use_prompts" )

			if ( newPrimary != oldPrimary )
			{
				oldPrimary = newPrimary
				RuiSetBool( file.shieldRegenRui, "weaponAllowedToUseShield", WeaponAllowsShield( newPrimary ) )
			}

			if ( oldPlayerUsePrompts != newPlayerUsePrompts )
			{
				oldPlayerUsePrompts = newPlayerUsePrompts
				printt( newPlayerUsePrompts )
				RuiSetBool( file.shieldRegenRui, "showPlayerHints", !newPlayerUsePrompts )
			}
		}

		WaitFrame()
	}
}
#endif

void function OnWeaponChargeEnd_ability_gibraltar_shield( entity weapon )
{
	weapon.Signal( "OnChargeEnd" )

	weapon.StopWeaponSound( SOUND_PILOT_GUN_SHIELD_1P )
	weapon.StopWeaponSound( SOUND_PILOT_GUN_SHIELD_3P )
}

void function OnWeaponActivate_ability_gibraltar_shield( entity weapon )
{

}

void function OnWeaponDeactivate_ability_gibraltar_shield( entity weapon )
{

}

bool function OnWeaponAttemptOffhandSwitch_ability_gibraltar_shield( entity weapon )
{
	entity player = weapon.GetWeaponOwner()

	if ( !IsValid( player ) )
		return false

	if ( !player.IsPlayer() )
		return false

	if ( player.IsZiplining() )
		return false

	entity mainWeapon = player.GetActiveWeapon( eActiveInventorySlot.mainHand )
	if ( !WeaponAllowsShield( mainWeapon ) )
		return false

	return PlayerHasPassive( player, ePassives.PAS_ADS_SHIELD )
}

var function OnWeaponPrimaryAttack_ability_gibraltar_shield( entity weapon, WeaponPrimaryAttackParams attackParams )
{
	return 0
}

#if SERVER
void function CreateGibraltarShield( entity player, entity weapon )
{
	thread ShieldWeaponThink( player, weapon )
}


// This is pretty hacky since it's polling every frame
void function ShieldWeaponThink( entity player, entity vortexWeapon )
{
	vortexWeapon.EndSignal( "OnDestroy" )
	vortexWeapon.EndSignal( "OnChargeEnd" )

	bool firstTime = true

	while ( true )
	{
		entity vortexSphere = vortexWeapon.GetWeaponUtilityEntity()
		if ( vortexWeapon.GetScriptTime0() < Time() )
		{
			int numToAdd = player.GetSharedEnergyTotal() - player.GetSharedEnergyCount()
			player.AddSharedEnergy( numToAdd )

			if ( IsValid( vortexSphere ) )
			{
				vortexSphere.SetHealth( player.GetSharedEnergyCount() )
				float frac = float( player.GetSharedEnergyCount() ) / float( player.GetSharedEnergyTotal() )
				UpdateShieldWallColorFX( vortexSphere, frac )
			}
		}

		if ( player.GetSharedEnergyCount() > 0 )
		{
			// does it already have a shield
			if ( !IsValid( vortexSphere ) )
			{
				thread ShieldThread( player, vortexWeapon, firstTime )
			}
		}

		WaitFrame()

		firstTime = false
	}
}

void function ShieldThread( entity player, entity weapon, bool firstTime )
{
	player.EndSignal( "OnDeath" )
	weapon.EndSignal( "OnDestroy" )
	weapon.EndSignal( "OnChargeEnd" )

	entity vortexSphere = CreatePlayerShield( player, weapon )

	if ( vortexSphere == null )
		return

	vortexSphere.SetHealth( player.GetSharedEnergyCount() )
	vortexSphere.EndSignal( "OnDestroy" )
	weapon.SetWeaponUtilityEntity( vortexSphere )
	float frac = float( player.GetSharedEnergyCount() ) / float( player.GetSharedEnergyTotal() )
	UpdateShieldWallColorFX( vortexSphere, frac )

	EmitSoundOnEntityExceptToPlayer( player, player, SOUND_PILOT_GUN_SHIELD_3P )

	if ( !firstTime )
		EmitSoundOnEntityOnlyToPlayer( player, player, SOUND_PILOT_GUN_SHIELD_1P )

	OnThreadEnd(
		function () : ( vortexSphere, weapon, player )
		{
			if ( IsValid( player ) )
			{
				StopSoundOnEntity( player, SOUND_PILOT_GUN_SHIELD_3P )
				StopSoundOnEntity( player, SOUND_PILOT_GUN_SHIELD_1P )
			}

			if ( IsValid( vortexSphere ) )
			{
				if ( IsValid( vortexSphere.e.shieldWallFX ) )
					EffectStop( vortexSphere.e.shieldWallFX )
				foreach ( fx in vortexSphere.e.fxControlPoints )
					EffectStop( fx )
				vortexSphere.Destroy()
			}
			else
			{

			}

			weapon.SetWeaponUtilityEntity( null )
		}
	)

	AddEntityCallback_OnPostDamaged( vortexSphere, GibraltarShield_OnDamaged )

	WaitForever()
}

void function GibraltarShield_OnDamaged( entity ent, var damageInfo )
{
	float damage = DamageInfo_GetDamage( damageInfo )
	entity attacker = DamageInfo_GetAttacker( damageInfo )
	vector damageOrigin = DamageInfo_GetDamagePosition( damageInfo )
	if ( damage > 0 )
	{
		if ( IsFriendlyTeam( attacker.GetTeam(), ent.GetTeam() ) )
			DamageInfo_SetDamage( damageInfo, 0 )
	}

	damage = DamageInfo_GetDamage( damageInfo )

	if ( damage > 0 )
	{
		entity owner = ent.GetOwner()

		if ( IsValid( attacker ) && attacker.IsPlayer() )
		{
			attacker.NotifyDidDamage( ent, 0, damageOrigin, 0, damage, DF_NO_HITBEEP | DAMAGEFLAG_VICTIM_HAS_VORTEX, 0, null, 0 )
			StatsHook_GibraltarGunShield_OnDamageAbsorbed( owner, attacker, int(damage) ) // todo(dw): should damage be treated as a float or int?
		}

		if ( IsValid( owner ) )
		{
			owner.TakeSharedEnergy( minint( int( damage ) , owner.GetSharedEnergyCount() ) )
			entity weapon = owner.GetOffhandWeapon( PILOT_SHIELD_OFFHAND_INDEX )
			float delay = weapon.GetWeaponSettingFloat( eWeaponVar.fire_duration )
			weapon.SetScriptTime0( Time() + delay )
			float frac = float( owner.GetSharedEnergyCount() ) / float( owner.GetSharedEnergyTotal() )
			UpdateShieldWallColorFX( ent, frac )
		}

		ent.SetHealth( maxint( 1, ent.GetHealth()-int( damage ) ) )

		entity weapon = ent.e.ownerWeapon

		if ( IsValid( owner ) )
		{
			if ( owner.GetSharedEnergyCount() <= 0 )
			{
				int attachmentIndex = owner.LookupAttachment( "L_FOREARM_SHIELD" )
				vector attachmentOrigin = owner.GetAttachmentOrigin( attachmentIndex )
				vector attachmentAngles = owner.GetAttachmentAngles( attachmentIndex )

				entity fx = StartParticleEffectInWorld_ReturnEntity( GetParticleSystemIndex( FX_GUN_SHIELD_BREAK ), attachmentOrigin, attachmentAngles )
				SetTeam( fx, owner.GetTeam() )
				fx.SetOwner( owner )
				fx.kv.VisibilityFlags = ENTITY_VISIBLE_TO_ENEMY
				EffectSetControlPointVector( fx, 2, ENEMY_COLOR_FX )

				fx = StartParticleEffectInWorld_ReturnEntity( GetParticleSystemIndex( FX_GUN_SHIELD_BREAK ), attachmentOrigin, attachmentAngles )
				SetTeam( fx, owner.GetTeam() )
				fx.SetOwner( owner )
				fx.kv.VisibilityFlags = ENTITY_VISIBLE_TO_FRIENDLY
				EffectSetControlPointVector( fx, 2, FRIENDLY_COLOR_FX )

				vector fwd = owner.GetViewVector()
				fx = StartParticleEffectInWorld_ReturnEntity( GetParticleSystemIndex( FX_GUN_SHIELD_BREAK_FP ), owner.CameraPosition() + fwd*50, owner.CameraAngles() )
				SetTeam( fx, owner.GetTeam() )
				fx.SetOwner( owner )
				fx.SetParent( owner )
				fx.kv.VisibilityFlags = ENTITY_VISIBLE_TO_OWNER | ENTITY_VISIBLE_ONLY_PARENT_PLAYER
				EffectSetControlPointVector( fx, 2, FRIENDLY_COLOR_FX )
				fx.RenderWithViewModels( true )
				SetForceDrawWhileParented( fx, true )

				EmitSoundOnEntityExceptToPlayer( owner, owner, SOUND_PILOT_GUN_SHIELD_BREAK_3P )
				EmitSoundOnEntityOnlyToPlayer( owner, owner, SOUND_PILOT_GUN_SHIELD_BREAK_1P )

				ent.Destroy()
			}
		}
	}
}

bool function ClientCommand_ToggleGibraltarShield( entity player, array<string> args )
{
	if ( !IsAlive( player ) )
		return true

	entity weapon = player.GetOffhandWeapon( PILOT_SHIELD_OFFHAND_INDEX )

	if ( !IsValid( weapon ) )
		return true

	if ( weapon.GetWeaponClassName() != "mp_ability_gibraltar_shield" )
		return true

	array<string> mods = weapon.GetMods()

	if ( mods.contains( "disabled" ) )
		mods.fastremovebyvalue( "disabled" )
	else
		mods.append( "disabled" )

	weapon.SetMods( mods )

	return true
}

void function PilotShield_OnPassiveChanged( entity player, int passive, bool didHave, bool nowHas )
{
	if ( didHave )
	{
		entity weapon = player.GetOffhandWeapon( PILOT_SHIELD_OFFHAND_INDEX )
		player.TakeOffhandWeapon( PILOT_SHIELD_OFFHAND_INDEX )
	}
	if ( nowHas )
	{
		player.GiveOffhandWeapon( "mp_ability_gibraltar_shield", PILOT_SHIELD_OFFHAND_INDEX, [] )
	}
}

entity function CreatePlayerShield( entity player, entity vortexWeapon )
{
	vector dir = player.EyeAngles()
	vector forward = AnglesToForward( dir )

	GunShieldSettings gs
	gs.invulnerable = false
	gs.maxHealth = float( player.GetSharedEnergyTotal() )
	gs.spawnflags = SF_ABSORB_BULLETS
	gs.bulletFOV = PLAYER_GUN_SHIELD_WALL_FOV
	gs.sphereRadius = PLAYER_GUN_SHIELD_WALL_RADIUS
	gs.sphereHeight = PLAYER_GUN_SHIELD_WALL_HEIGHT
	gs.ownerWeapon = vortexWeapon
	gs.owner = player
	gs.shieldFX = FX_GUN_SHIELD_WALL
	gs.parentEnt = player
	gs.parentAttachment = "L_FOREARM_SHIELD"
	gs.gunVortexAttachment = "L_HAND"
	gs.localVortexAngles = AnglesCompose( forward, < 0, -25, 0> )
	gs.bulletHitRules = GunShield_VortexBulletHitRules
	gs.projectileHitRules = GunShield_VortexProjectileHitRules
	gs.useFriendlyEnemyFx = true
	gs.model = FX_GUN_SHIELD_SHIELD_COL
	gs.modelOverrideAngles = SHIELD_ANGLE_OFFSET

	entity vortexSphere = CreateGunAttachedShield( gs )

	return vortexSphere
}

void function GunShield_VortexBulletHitRules( entity vortexSphere, var damageInfo )
{
	entity attacker = DamageInfo_GetAttacker( damageInfo )

	if ( !IsValid( attacker ) )
		return

	ResolveVortexAttackForOwner( vortexSphere, attacker )
}

bool function GunShield_VortexProjectileHitRules( entity vortexSphere, entity attacker, bool takesDamageByDefault )
{
	if ( !IsValid( attacker ) )
		return false
	if ( !IsValid( vortexSphere ) )
		return false

	ResolveVortexAttackForOwner( vortexSphere, attacker )

	return takesDamageByDefault
}

void function ResolveVortexAttackForOwner( entity vortexSphere, entity attacker )
{
	entity vortexOwner = vortexSphere.GetOwner()
	if ( IsValid( vortexOwner ) )
	{
		vector attackerOrigin = attacker.GetOrigin()

		vortexOwner.ViewPunch( attackerOrigin, 1, 1, 3 )
	}
}

void function UpdateShieldWallColorFX( entity ent, float frac )
{
	UpdateShieldWallFX( ent, GraphCapped( frac, 0.0, 1.0, 0.3, 1.0 ) )
	EffectSetControlPointVector( ent.e.fxControlPoints[0], 2, GetFriendlyEnemyTriLerpColor( frac, true ) )
	EffectSetControlPointVector( ent.e.fxControlPoints[1], 2, GetFriendlyEnemyTriLerpColor( frac, false ) )
}

vector function GetFriendlyEnemyTriLerpColor( float frac, bool isFriendly )
{
	vector color3

	if ( isFriendly )
	{
		color3 = TEAM_COLOR_FRIENDLY
	}
	else
	{
		color3 = TEAM_COLOR_ENEMY
	}

	return GetTriLerpColor( frac, <255, 255, 255>, LerpVector( color3, <255, 255, 255>, 0.5 ), color3, 0.55, 0.10 )
}
#endif

#if CLIENT
void function GunShieldTogglePressed( entity player )
{
	if ( player != GetLocalViewPlayer() || player != GetLocalClientPlayer() )
		return

	entity activeWeapon = player.GetActiveWeapon( eActiveInventorySlot.mainHand )
	if ( !IsValid( activeWeapon ) )
		return

	if ( activeWeapon.IsWeaponAdsButtonPressed() || activeWeapon.IsWeaponInAds() )
		player.ClientCommand( "ToggleGibraltarShield" )
}
#endif

bool function WeaponAllowsShield( entity weapon )
{
	if ( !IsValid( weapon ) )
		return false

	// default allow, need to add k/v to exempt
	var allowShield = weapon.GetWeaponInfoFileKeyField( "allow_gibraltar_shield" )
	if ( allowShield != null && allowShield == 0 )
		return false

	return true
}