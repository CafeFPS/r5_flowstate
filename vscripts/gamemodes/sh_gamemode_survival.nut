//=========================================================
//	sh_gamemode_survival.nut
//=========================================================

#if SERVER || CLIENT
global function GamemodeSurvivalShared_Init

global function Survival_CanUseHealthPack
global function Survival_CanUseTitanItem
global function Survival_PlayerCanDrop

global function Sur_SetPlaneCenterEnt
global function Sur_SetPlaneEnt
global function Sur_GetPlaneCenterEnt
global function Sur_GetPlaneEnt
global function SetVictorySequencePlatformModel
global function GetVictorySequencePlatformModel
global function PredictHealthPackUse

global function Survival_GetCurrentRank
#if CLIENT || UI 
global function GetMusicForJump
#endif
global function CanWeaponInspect
global function PositionIsInMapBounds
global function Survival_IsPlayerHealing
#endif


//////////////////////
//////////////////////
//// Global Types ////
//////////////////////
//////////////////////
const float MAX_MAP_BOUNDS = 61000.0

global const string SURVIVAL_DEFAULT_TITAN_DEFENSE = "mp_titanability_arm_block"

global const float CHARACTER_SELECT_OPEN_TRANSITION_DURATION    = 3.0
global const float CHARACTER_SELECT_CLOSE_TRANSITION_DURATION   = 3.0
global const float CHARACTER_SELECT_CHARACTER_LOCK_DURATION     = 0.5
global const float CHARACTER_SELECT_FINISHED_HOLD_DURATION      = 2.5
global const float CHARACTER_SELECT_PRE_PICK_COUNTDOWN_DURATION = 4.0
global const float CHARACTER_SELECT_SCENE_ROTATE_DURATION       = 4.0

global const float SURVIVAL_MINIMAP_RING_SCALE                  = 65536
global const SMALL_HEALTH_USE_TIME                              = 4.0
global const MEDIUM_HEALTH_USE_TIME                             = 7.0
global const LARGE_HEALTH_USE_TIME                              = 12.0
global const SYRINGE_HEALTH_USE_TIME                            = 4.0

global const int SURVIVAL_MAP_GRIDSIZE = 7

global const SURVIVAL_PLANE_MODEL         = $"mdl/vehicles_r2/spacecraft/draconis/draconis_flying_small.rmdl"
global const SURVIVAL_SQUAD_SUMMARY_MODEL = $"mdl/levels_terrain/mp_lobby/mp_setting_menu.rmdl"

const int USEHEALTHPACK_DENY_NONE = -1
const int USEHEALTHPACK_ALLOW = 0
const int USEHEALTHPACK_DENY_ULT_FULL = 1
const int USEHEALTHPACK_DENY_HEALTH_FULL = 2
const int USEHEALTHPACK_DENY_SHIELD_FULL = 3
const int USEHEALTHPACK_DENY_NO_HEALTH_KITS = 4
const int USEHEALTHPACK_DENY_NO_SHIELD_KITS = 5
const int USEHEALTHPACK_DENY_NO_KITS = 6
const int USEHEALTHPACK_DENY_FULL = 7

enum eUseHealthKitResult
{
	ALLOW,
	DENY_NONE,
	DENY_ULT_FULL,
	DENY_ULT_NOTREADY,
	DENY_HEALTH_FULL,
	DENY_SHIELD_FULL,
	DENY_NO_HEALTH_KIT,
	DENY_NO_SHIELD_KIT,
	DENY_NO_KITS,
	DENY_NO_SHIELDS,
	DENY_FULL,
	DENY_SPRINTING,
}

table< int, string > healthKitResultStrings =
{
	[eUseHealthKitResult.ALLOW] = "",
	[eUseHealthKitResult.DENY_NONE] = "",
	[eUseHealthKitResult.DENY_ULT_FULL] = "#DENY_ULT_FULL",
	[eUseHealthKitResult.DENY_ULT_NOTREADY ] = "#DENY_ULT_NOTREADY",
	[eUseHealthKitResult.DENY_HEALTH_FULL] = "#DENY_HEALTH_FULL",
	[eUseHealthKitResult.DENY_SHIELD_FULL] = "#DENY_SHIELD_FULL",
	[eUseHealthKitResult.DENY_NO_HEALTH_KIT] = "#DENY_NO_HEALTH_KIT",
	[eUseHealthKitResult.DENY_NO_SHIELD_KIT] = "#DENY_NO_SHIELD_KIT",
	[eUseHealthKitResult.DENY_NO_KITS] = "#DENY_NO_KITS",
	[eUseHealthKitResult.DENY_NO_SHIELDS] = "#DENY_NO_SHIELDS",
	[eUseHealthKitResult.DENY_FULL] = "#DENY_FULL",
	[eUseHealthKitResult.DENY_SPRINTING] = "#DENY_SPRINTING",
}

global struct TargetKitHealthAmounts
{
	float targetHealth
	float targetShields
}

global enum eSurvivalHints
{
	EQUIP,
	ORDNANCE
}

global struct VictoryPlatformModelData
{
	bool   isSet = false
	asset  modelAsset
	vector originOffset
	vector modelAngles
}

struct
{
	entity                     planeCenterEnt
	entity                     planeEnt
	VictoryPlatformModelData & victorySequencePlatforData
} file

/////////////////////////
/////////////////////////
//// Internals       ////
/////////////////////////
/////////////////////////
//

/////////////////////////
/////////////////////////
//// Initialiszation ////
/////////////////////////
/////////////////////////

#if SERVER || CLIENT
void function GamemodeSurvivalShared_Init()
{
	
	printt("GamemodeSurvivalShared_Init")
	RegisterSignal("GameStateChanged")
	
	#if SERVER || CLIENT
		BleedoutShared_Init()
		ShApexScreens_Init()
		Sh_RespawnBeacon_Init()
		Sh_Airdrops_Init()

		PrecacheImpactEffectTable( "dropship_dust" )
		PrecacheModel( SURVIVAL_PLANE_MODEL )
		PrecacheModel( SURVIVAL_SQUAD_SUMMARY_MODEL )

		AddCallback_PlayerCanUseZipline( Sur_CanUseZipline )
		MapZones_SharedInit()
		ClientMusic_SharedInit()

		

		AddCallback_CanStartCustomWeaponActivity( ACT_VM_WEAPON_INSPECT, CanWeaponInspect )
	#endif

	#if SERVER
	//printt("Setting Game State")
	//SetGameState(eGameState.PickLoadout)
	#elseif CLIENT
		AddCreateCallback( "prop_dynamic", OnPropDynamicCreated )
	#endif

}
#endif

#if SERVER || CLIENT
bool function Survival_CanUseTitanItem( entity player )
{
	#if CLIENT
		if ( IsWatchingReplay() )
			return false

		if ( player != GetLocalClientPlayer() )
			return false

		if ( player != GetLocalViewPlayer() )
			return false

		if ( IsWatchingReplay() )
			return false
	#endif

	if ( !IsAlive( player ) )
		return false

	if ( !player.IsTitan() )
		return false

	if ( player.ContextAction_IsActive() )
		return false

	if ( player.GetWeaponDisableFlags() == WEAPON_DISABLE_FLAGS_ALL )
		return false

	entity soul = player.GetTitanSoul()

	if ( !IsValid( soul ) )
		return false

	if ( soul.IsEjecting() )
		return false

	return true
}

bool function Survival_PlayerCanDrop( entity player )
{
	if ( !IsAlive( player ) )
		return false

	//if ( !GamePlaying() )
	//	return false

	if ( player.ContextAction_IsActive() && !player.ContextAction_IsRodeo() )
		return false

	if ( Bleedout_IsBleedingOut( player ) )
		return false

	if ( player.IsPhaseShifted() )
		return false

	return true
}

bool function Survival_CanUseHealthPack( entity player, int itemType, bool checkInventory = false, bool printReason = false )
{
	if ( itemType == eHealthPickupType.INVALID )
		return false

	int canUseResult = Survival_TryUseHealthPack( player, itemType )
	if ( canUseResult == eUseHealthKitResult.ALLOW )
	{
		if ( checkInventory )
		{
			if ( SURVIVAL_CountItemsInInventory( player, SURVIVAL_Loot_GetHealthPickupRefFromType( itemType ) ) > 0 )
				return true

			bool needHeal = GetHealthFrac( player ) < 1.0
			bool needShield = GetShieldHealthFrac( player ) < 1.0

			if ( needHeal && needShield )
				canUseResult = eUseHealthKitResult.DENY_NO_KITS
			else if ( needShield )
				canUseResult = eUseHealthKitResult.DENY_NO_SHIELD_KIT
			else
				canUseResult = eUseHealthKitResult.DENY_NO_HEALTH_KIT
		}
		else
		{
			return true
		}
	}

#if CLIENT
		if ( printReason )
		{
			switch( canUseResult )
			{
				case eUseHealthKitResult.DENY_NONE:
					//
					break

				case eUseHealthKitResult.DENY_NO_HEALTH_KIT:
				case eUseHealthKitResult.DENY_NO_KITS:
				case eUseHealthKitResult.DENY_NO_SHIELD_KIT:
					player.ClientCommand( "ClientCommand_Quickchat " + eCommsAction.INVENTORY_NEED_HEALTH )
					//

				default:
					AnnouncementMessageRight( player, healthKitResultStrings[canUseResult] )
					break
			}
		}
	#endif

	return false

	/*
	#if CLIENT
		if ( player != GetLocalClientPlayer() )
			return false

		if ( player != GetLocalViewPlayer() )
			return false

		if ( IsWatchingReplay() )
			return false
	#elseif SERVER
		if ( Bleedout_IsPlayerGivingFirstAid( player ) )
			return false
	#endif

	if ( player.ContextAction_IsActive() && !player.ContextAction_IsRodeo() )
		return false

	if ( Bleedout_IsBleedingOut( player ) )
		return false

	if ( !IsAlive( player ) )
		return false

	if ( player.IsPhaseShifted() )
		return false

	if ( StatusEffect_GetSeverity( player, eStatusEffect.placing_phase_tunnel ) )
		return false

	if ( player.GetWeaponDisableFlags() == WEAPON_DISABLE_FLAGS_ALL )
		return false

	if ( player.IsTitan() )
		return false

	if ( itemType == eHealthPickupType.ULTIMATE )
	{
		entity ultimateAbility = player.GetOffhandWeapon( OFFHAND_INVENTORY )
		int ammo = ultimateAbility.GetWeaponPrimaryClipCount()
		int maxAmmo = ultimateAbility.GetWeaponPrimaryClipCountMax()

		if( ammo >= maxAmmo )
			return false
	}
	else if ( GetCurrentPlaylistVarInt( "survival_shields", 1 ) > 0 )
	{
		int currentHealth = player.GetHealth()
		int currentShields = player.GetShieldHealth()
		bool canHeal = false
		bool canShield = false

		HealthPickup pickup = SURVIVAL_Loot_GetHealthKitDataFromStruct( itemType )

		if ( pickup.healAmount > 0 && currentHealth < pickup.healCap )
			canHeal = true

		if ( pickup.healAmount > 0 && pickup.healTime > 0 )
			canHeal = true

		if ( pickup.shieldAmount > 0 && currentShields < player.GetShieldHealthMax() )
			canShield = true

		if ( pickup.healAmount > 0 && pickup.healCap > 100 )
		{
			int targetHealth = int( currentHealth + pickup.healAmount )
			int overHeal = targetHealth - player.GetMaxHealth()
			if ( overHeal && currentShields < player.GetShieldHealthMax() )
				canShield = true
		}

		if ( !canHeal && !canShield )
			return false
	}
	else
	{
		HealthPickup pickup = SURVIVAL_Loot_GetHealthKitDataFromStruct( itemType )
		if ( GetCurrentPlaylistVarInt( "survival_shields", 1 ) && pickup.shieldAmount > 0 )
		{
			if ( player.GetShieldHealthMax() > 0.0 && GetHealthFrac( player ) >= 1.0 && GetShieldHealthFrac( player ) >= 1.0 )
				return false
			else if ( GetHealthFrac( player ) >= 1.0 )
				return false
		}
		else
		{
			if ( GetHealthFrac( player ) >= 1.0 )
				return false
		}
	}

	return true
	*/
}

int function Survival_TryUseHealthPack( entity player, int itemType )
{
	#if CLIENT
		if ( player != GetLocalClientPlayer() )
			return eUseHealthKitResult.DENY_NONE

		if ( player != GetLocalViewPlayer() )
			return eUseHealthKitResult.DENY_NONE

		if ( IsWatchingReplay() )
			return eUseHealthKitResult.DENY_NONE
	#elseif SERVER
		if ( Bleedout_IsPlayerGivingFirstAid( player ) )
			return eUseHealthKitResult.DENY_NONE
	#endif

	if ( player.ContextAction_IsActive() && !player.ContextAction_IsRodeo() )
		return eUseHealthKitResult.DENY_NONE

	if ( Bleedout_IsBleedingOut( player ) )
		return eUseHealthKitResult.DENY_NONE

	if ( !IsAlive( player ) )
		return eUseHealthKitResult.DENY_NONE

	if ( player.IsPhaseShifted() )
		return eUseHealthKitResult.DENY_NONE

	if ( StatusEffect_GetSeverity( player, eStatusEffect.placing_phase_tunnel ) )
		return eUseHealthKitResult.DENY_NONE

	if ( player.GetWeaponDisableFlags() == WEAPON_DISABLE_FLAGS_ALL )
		return eUseHealthKitResult.DENY_NONE

	if ( player.IsTitan() )
		return eUseHealthKitResult.DENY_NONE

	if ( itemType == eHealthPickupType.ULTIMATE )
	{
		entity ultimateAbility = player.GetOffhandWeapon( OFFHAND_INVENTORY )
		int ammo = ultimateAbility.GetWeaponPrimaryClipCount()
		int maxAmmo = ultimateAbility.GetWeaponPrimaryClipCountMax()

		if ( ammo >= maxAmmo )
			return eUseHealthKitResult.DENY_ULT_FULL
		if ( !ultimateAbility.IsReadyToFire() )
			return eUseHealthKitResult.DENY_ULT_NOTREADY
	}
	else if ( GetCurrentPlaylistVarInt( "survival_shields", 1 ) > 0 )
	{
		int currentHealth = player.GetHealth()
		int currentShields = player.GetShieldHealth()
		bool canHeal = false
		bool canShield = false
		bool needHeal = currentHealth < player.GetMaxHealth()
		bool needShield = currentShields < player.GetShieldHealthMax()

		HealthPickup pickup = SURVIVAL_Loot_GetHealthKitDataFromStruct( itemType )

		if ( pickup.healAmount && !pickup.shieldAmount && pickup.healCap <= 100 )
		{
			if ( !needHeal )
				return eUseHealthKitResult.DENY_HEALTH_FULL
		}
		else if ( pickup.shieldAmount && !pickup.healAmount )
		{
			if ( !needShield )
				return player.GetShieldHealthMax() > 0 ? eUseHealthKitResult.DENY_SHIELD_FULL : eUseHealthKitResult.DENY_NO_SHIELDS
		}
		else
		{
			if ( pickup.healAmount > 0 && currentHealth < pickup.healCap )
				canHeal = true

			if ( pickup.healAmount > 0 && pickup.healTime > 0 )
				canHeal = true

			if ( pickup.shieldAmount > 0 && needShield )
				canShield = true

			if ( pickup.healAmount > 0 && pickup.healCap > 100 )
			{
				int targetHealth = int( currentHealth + pickup.healAmount )
				int overHeal = targetHealth - player.GetMaxHealth()
				if ( overHeal && currentShields < player.GetShieldHealthMax() )
					canShield = true
			}

			if ( !canHeal && !canShield )
			{
				if ( currentHealth == player.GetMaxHealth() && currentShields == player.GetShieldHealthMax() )
					return eUseHealthKitResult.DENY_FULL

				return eUseHealthKitResult.DENY_NO_KITS
			}
		}
	}
	else
	{
		HealthPickup pickup = SURVIVAL_Loot_GetHealthKitDataFromStruct( itemType )
		if ( GetCurrentPlaylistVarInt( "survival_shields", 1 ) && pickup.shieldAmount > 0 )
		{
			if ( player.GetShieldHealthMax() > 0.0 && GetHealthFrac( player ) >= 1.0 && GetShieldHealthFrac( player ) >= 1.0 )
				return eUseHealthKitResult.DENY_SHIELD_FULL
			else if ( GetHealthFrac( player ) >= 1.0 )
				return eUseHealthKitResult.DENY_HEALTH_FULL
		}
		else
		{
			if ( GetHealthFrac( player ) >= 1.0 )
				return eUseHealthKitResult.DENY_HEALTH_FULL
		}
	}

	if ( GetCurrentPlaylistVarBool( "survival_healthkits_limit_movement", true ) == false && player.IsSprinting() )
	{
		return eUseHealthKitResult.DENY_SPRINTING
	}

	return eUseHealthKitResult.ALLOW
}
#endif

#if SERVER || CLIENT
bool function Sur_CanUseZipline( entity player, entity zipline, vector ziplineClosestPoint )
{
	if ( player.IsGrapplingZipline() )
		return true

	if ( player.GetWeaponDisableFlags() == WEAPON_DISABLE_FLAGS_ALL )
		return false

	//if ( IsValid( player.GetActiveWeapon( eActiveInventorySlot.mainHand ) ) && player.GetActiveWeapon( eActiveInventorySlot.mainHand ).IsWeaponOffhand() )
	//	return false

	if ( Bleedout_IsBleedingOut( player ) )
		return false

	return true
}
#endif

#if SERVER || CLIENT
void function Sur_SetPlaneCenterEnt( entity ent )
{
	file.planeCenterEnt = ent
}
#endif

#if SERVER || CLIENT
void function Sur_SetPlaneEnt( entity ent )
{
	file.planeEnt = ent
}
#endif

#if SERVER || CLIENT
entity function Sur_GetPlaneCenterEnt()
{
	return file.planeCenterEnt
}
#endif

#if SERVER || CLIENT
entity function Sur_GetPlaneEnt()
{
	return file.planeEnt
}
#endif

#if !UI
void function OnPropDynamicCreated( entity prop )
{
	#if SERVER
		if ( prop.GetScriptName() == "VaultPanel" )
			VaultPanelInit( prop )
	#endif
}

#if(true)
void function VaultPanelInit( entity panel )
{
	thread Delayed_VaultPanelInit( panel )
}
void function Delayed_VaultPanelInit( entity panel )
{
	panel.EndSignal( "OnDestroy" )
	WaitEndFrame() //
	ClearCallback_CanUseEntityCallback( panel )
	SetCallback_CanUseEntityCallback( panel, VaultPanel_CanUseFunction )

	#if(false)

#endif
}
bool function VaultPanel_CanUseFunction( entity playerUser, entity controlPanel )
{
	if ( !playerUser.GetPlayerNetBool( "hasDataKnife" ) )
		return false

	return ControlPanel_CanUseFunction( playerUser, controlPanel )
}
#endif


TargetKitHealthAmounts function PredictHealthPackUse( entity player, HealthPickup itemData )
{
	int currentHealth = player.GetHealth()
	int currentShields = player.GetShieldHealth()
	int shieldHealthMax = player.GetShieldHealthMax()

	int resourceHealthRemaining = 0
	int virtualHealth = minint( currentHealth + resourceHealthRemaining, 100 )
	int missingHealth = 100 - virtualHealth
	int missingShields = shieldHealthMax - currentShields

	TargetKitHealthAmounts targetValues

	if ( itemData.healAmount > 0 )
	{
		int healthToApply = minint( int( itemData.healAmount ), missingHealth )
		Assert( virtualHealth + healthToApply <= 100, "Bad math: " + virtualHealth + " + " + healthToApply + " > 100 " )

		int remainingHealth = int( itemData.healAmount - healthToApply )

		int shieldsToApply = 0
		if ( itemData.healCap > 100 && remainingHealth > 0 )
		{
			shieldsToApply = minint( remainingHealth, missingShields )
		}

		Assert( currentShields + shieldsToApply <= shieldHealthMax, "Bad math: " + currentShields + " + " + shieldsToApply + " > " + shieldHealthMax )

		if ( healthToApply || itemData.healTime > 0 ) // healTime items can exceed the cap
			targetValues.targetHealth = (currentHealth + healthToApply + resourceHealthRemaining) / 100.0

		if ( shieldsToApply && shieldHealthMax > 0 )
			targetValues.targetShields = (currentShields + shieldsToApply) / float( shieldHealthMax )
	}

	if ( itemData.shieldAmount > 0 && shieldHealthMax > 0 )
		targetValues.targetShields = minint(player.GetShieldHealth() + int( itemData.shieldAmount ), shieldHealthMax) / float( shieldHealthMax )

	return targetValues
}


#endif
#if SERVER || CLIENT
bool function CanWeaponInspect( entity player, int activity )
{
	if ( Bleedout_IsBleedingOut( player ) )
		return false

	return GetCurrentPlaylistVarBool( "enable_weapon_inspect", true )
}


int function Survival_GetCurrentRank( entity player )
{
	int team = player.GetTeam()
	int numLivingSquadMembers = GetPlayerArrayOfTeam_AliveConnected( team ).len()
	if ( numLivingSquadMembers <= 0 )
	{
		#if SERVER
			int squadRank = _GetSquadRank( player )
			if ( squadRank == 0 )
				squadRank = GetNumTeamsRemaining() + 1 //player disconnected before his squad was eliminated.
			return squadRank
		#else
			return player.GetPersistentVarAsInt( "lastGameRank" )
		#endif
	}
	return GetNumTeamsRemaining()
}

void function SetVictorySequencePlatformModel( asset model, vector originOffset, vector modelAngles )
{
	VictoryPlatformModelData data
	data.isSet = true
	data.modelAsset = model
	data.originOffset = originOffset
	data.modelAngles = modelAngles
	file.victorySequencePlatforData = data

	PrecacheModel( model )
}

VictoryPlatformModelData function GetVictorySequencePlatformModel()
{
	return file.victorySequencePlatforData

}
#if CLIENT || UI 
string function GetMusicForJump( entity player )
{
	return MusicPack_GetSkydiveMusic( GetMusicPackForPlayer( player ) )
}
#endif
bool function PositionIsInMapBounds( vector pos )
{
	return ( fabs( pos.x ) < MAX_MAP_BOUNDS && fabs( pos.y ) < MAX_MAP_BOUNDS && fabs( pos.z ) < MAX_MAP_BOUNDS )
}

bool function Survival_IsPlayerHealing( entity player )
{
	return player.GetPlayerNetBool( "isHealing" )
}
#endif