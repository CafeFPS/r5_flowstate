global function PlayerCloak_Init

global const CLOAK_FADE_IN = 1.5
global const CLOAK_FADE_OUT = 1.0

const asset CLOAK_EMITTER_FX = $"P_mirage_holo_emitter_cloaked"

global function EnableCloak
global function DisableCloak
global function EnableCloakForever
global function DisableCloakForever
global function GetLastCloakTime

//=========================================================
//	player_cloak
//
//=========================================================

struct CloakInfo
{
	array<string> ids
	array<entity> fxs
	entity prevWeapon
}

struct
{
	table<entity , CloakInfo > playerCloakInfo
} file

void function PlayerCloak_Init()
{
	RegisterSignal( "OnStartCloak" )
	RegisterSignal( "KillHandleCloakEnd" ) //Somewhat awkward, mainly to smooth out weird interactions with cloak ability and cloak execution

	AddCallback_OnPlayerKilled( AbilityCloak_OnDeath )
	AddSpawnCallback( "npc_titan", SetCannotCloak )

	PrecacheParticleSystem( CLOAK_EMITTER_FX )

	                     
		//if ( GetCurrentPlaylistVarBool( "mirage_rework_enabled", true ) )
		//{
		//	AddCallback_OnPlayerWeaponSwitched(DisableCloakOnWeaponSwap)
		//}
                            
}

void function SetCannotCloak( entity ent )
{
	ent.SetCanCloak( false )
}

void function PlayCloakSounds( entity player )
{
	if ( PlayerHasPassive( player, ePassives.PAS_MIRAGE ) )
	{
		EmitSoundOnEntityOnlyToPlayer( player, player, "MirageCloak_Activate_1P" )
		EmitSoundOnEntityExceptToPlayer( player, player, "MirageCloak_Activate_3P" )
		EmitSoundOnEntityOnlyToPlayer( player, player, "MirageCloak_Loop_1P" )
		EmitSoundOnEntityExceptToPlayer( player, player, "MirageCloak_Loop_3P" )
	}
	else if ( player.IsPlayer() )
	{
		EmitSoundOnEntityOnlyToPlayer( player, player, "cloak_on_1P" )
		EmitSoundOnEntityExceptToPlayer( player, player, "cloak_on_3P" )
		EmitSoundOnEntityOnlyToPlayer( player, player, "cloak_sustain_loop_1P" )
		EmitSoundOnEntityExceptToPlayer( player, player, "cloak_sustain_loop_3P" )
	}
	else
	{
		EmitSoundOnEntity( player, "cloak_on_3P" )
		EmitSoundOnEntity( player, "cloak_sustain_loop_3P" )
	}
}

void function EnableCloak( entity player, float duration, float fadeIn = CLOAK_FADE_IN )
{
	thread __EnableCloak( player, duration, fadeIn )
}

void function __EnableCloak( entity player, float duration, float fadeIn = CLOAK_FADE_IN )
{
	player.EndSignal( "OnDeath" )
	player.EndSignal( "OnDamaged" )

	string id = EnableCloakForever( player, fadeIn )

	thread HandleCloakEnd( player, duration )

	OnThreadEnd(
		function() : ( player, id )
		{
			if ( IsValid( player ) )
			{
				DisableCloakForever( player, id, CLOAK_FADE_OUT )
			}
		}
	)

	wait duration
}

string function EnableCloakForever( entity player, float fadeIn = CLOAK_FADE_IN )
{
	if (!( player in file.playerCloakInfo ))
	{
		CloakInfo info
		file.playerCloakInfo[ player ] <- info
	}

	string id = string( Time() )
	while ( file.playerCloakInfo[ player ].ids.contains( id ) )
	{
		id = id + "_"
	}

	file.playerCloakInfo[ player ].ids.append( id )

	if ( file.playerCloakInfo[ player ].ids.len() == 1 )
	{
		player.SetCloakDuration( fadeIn, -1, CLOAK_FADE_OUT )
		PlayCloakSounds( player )

		if ( GetCurrentPlaylistVarBool( "mirage_cloak_fx", true ) )
		{
			array<string> attachPoints = [
				"FX_EMITTER_L_01",
				"FX_EMITTER_L_02",
				"FX_EMITTER_L_03",
				"FX_EMITTER_L_04",
				"FX_EMITTER_L_05",
				"FX_EMITTER_R_01",
				"FX_EMITTER_R_02",
				"FX_EMITTER_R_03",
				"FX_EMITTER_R_04",
				"FX_EMITTER_R_05",
			]
			int pIdx = GetParticleSystemIndex( CLOAK_EMITTER_FX )

			foreach ( attach in attachPoints )
			{
				int attachPointIdx = player.LookupAttachment( attach )

				if ( attachPointIdx <= 0 )
					continue

				entity fx = StartParticleEffectOnEntity_ReturnEntity( player, pIdx, FX_PATTACH_POINT_FOLLOW, attachPointIdx )
				SetTeam( fx, player.GetTeam() )
				fx.kv.VisibilityFlags = ENTITY_VISIBLE_TO_FRIENDLY | ENTITY_VISIBLE_TO_ENEMY
				fx.RemoveFromAllRealms()
				fx.AddToOtherEntitysRealms( player )
				fx.SetOwner( player )
				file.playerCloakInfo[ player ].fxs.append( fx )
			}
		}

		                     
			if ( GetCurrentPlaylistVarBool( "mirage_rework_enabled", true ) )
			{
				file.playerCloakInfo[player].prevWeapon = player.GetActiveWeapon( eActiveInventorySlot.mainHand )
			}
        
	}

	return id
}

void function DisableCloakForever( entity player, string id, float fadeOut = CLOAK_FADE_OUT )
{
	if (!( player in file.playerCloakInfo ))
		return

	int idx = file.playerCloakInfo[ player ].ids.find( id )
	if ( idx == -1 )
		return

	file.playerCloakInfo[ player ].ids.remove( idx )

	if ( file.playerCloakInfo[ player ].ids.len() > 0 )
		return

	__DisableCloak( player, fadeOut )
}

void function DisableCloak( entity player, float fadeOut = CLOAK_FADE_OUT )
{
	if (!( player in file.playerCloakInfo ))
		return

	if ( file.playerCloakInfo[ player ].ids.len() == 0 )
		return

	file.playerCloakInfo[ player ].ids.clear()

	__DisableCloak( player, fadeOut )
}

void function __DisableCloak( entity player, float fadeOut = CLOAK_FADE_OUT )
{
	player.Signal( "KillHandleCloakEnd")

	StopSoundOnEntity( player, "MirageCloak_Loop_1P" ) //Mirage Loop Sounds
	StopSoundOnEntity( player, "MirageCloak_Loop_3P" ) //Mirage Loop Sounds
	StopSoundOnEntity( player, "cloak_sustain_loop_1P" )
	StopSoundOnEntity( player, "cloak_sustain_loop_3P" )

	StopSoundOnEntity( player, "MirageCloak_WarningToEnd_1P" )
	StopSoundOnEntity( player, "MirageCloak_WarningToEnd_3P" )
	StopSoundOnEntity( player, "cloak_warningtoend_1P" )
	StopSoundOnEntity( player, "cloak_warningtoend_3P" )

	if ( fadeOut < CLOAK_FADE_OUT )
	{
		if ( PlayerHasPassive( player, ePassives.PAS_MIRAGE ) )
		{
			EmitSoundOnEntityOnlyToPlayer( player, player, "MirageCloak_Interruptend_1P" )
			EmitSoundOnEntityExceptToPlayer( player, player, "MirageCloak_Interruptend_3P" )
		}
		else
		{
			EmitSoundOnEntityOnlyToPlayer( player, player, "cloak_interruptend_1P" )
			EmitSoundOnEntityExceptToPlayer( player, player, "cloak_interruptend_3P" )
		}
	}

	foreach ( fx in file.playerCloakInfo[ player ].fxs )
	{
		EffectStop( fx )
	}
	file.playerCloakInfo[ player ].fxs.clear()

	                     
		if ( GetCurrentPlaylistVarBool( "mirage_rework_enabled", true ) )
		{
			entity weapon = player.GetActiveWeapon( eActiveInventorySlot.mainHand )
			if( IsValid( weapon ) )
			{
				if ( weapon.GetWeaponClassName() == "mp_weapon_melee_survival" )
				{
					int lastActiveSlot  = WEAPON_INVENTORY_SLOT_PRIMARY_0
					entity activeWeapon = file.playerCloakInfo[player].prevWeapon

					if ( IsValid( activeWeapon ) )
					{
						array<int> slots = [ WEAPON_INVENTORY_SLOT_PRIMARY_0,
							WEAPON_INVENTORY_SLOT_PRIMARY_1,
							WEAPON_INVENTORY_SLOT_PRIMARY_2,
							WEAPON_INVENTORY_SLOT_ANTI_TITAN
						]

						foreach ( slot in slots )
						{
							entity baseWeapon = player.GetNormalWeapon( slot )

							if ( baseWeapon == activeWeapon )
							{
								lastActiveSlot = slot
								break
							}
						}
					}

					player.SetActiveWeaponBySlot( eActiveInventorySlot.mainHand, lastActiveSlot )
				}
			}
		}
       

	if ( player.IsPlayer() )
		player.p.lastCloakTime = Time()
	player.SetCloakDuration( 0, 0, fadeOut )
}

void function HandleCloakEnd( entity player, float duration )
{
	player.EndSignal( "OnDeath" )
	player.EndSignal( "OnEMPPilotHit" )
	player.Signal( "OnStartCloak" )
	player.EndSignal( "OnStartCloak" )
	player.EndSignal( "KillHandleCloakEnd")

	OnThreadEnd(
		function() : ( player )
		{
			if ( !IsValid( player ) )
				return
		}
	)

	float soundBufferTime = 3.45

	if ( duration > soundBufferTime )
	{
		wait ( duration - soundBufferTime )

		if ( !player.IsCloaked( true ) )
			return

		if ( PlayerHasPassive( player, ePassives.PAS_MIRAGE ) )
		{
			EmitSoundOnEntityOnlyToPlayer( player, player, "MirageCloak_WarningToEnd_1P" )
			EmitSoundOnEntityExceptToPlayer( player, player, "MirageCloak_WarningToEnd_3P" )
		}
		else
		{
			EmitSoundOnEntityOnlyToPlayer( player, player, "cloak_warningtoend_1P" )
			EmitSoundOnEntityExceptToPlayer( player, player, "cloak_warningtoend_3P" )
		}

		wait soundBufferTime
	}
	else
	{
		wait duration
	}
}

void function AbilityCloak_OnDeath( entity player, entity attacker, var damageInfo )
{
	if ( !player.IsCloaked( true ) )
		return

	DisableCloak( player, 0 )
}

float function GetLastCloakTime( entity player )
{
	if ( player.IsCloaked( true ) )
		return Time()

	return player.p.lastCloakTime
}

                     
void function DisableCloakOnWeaponSwap(entity player, entity newWeapon, entity oldWeapon)
{
	if( !IsValid( player ) || !player.IsPlayer() )
		return

	if( !IsValid(oldWeapon) )
		return

	// Only disable cloak if swapping away from unarmed
	if ( ( oldWeapon.GetWeaponClassName() == "mp_weapon_melee_survival" ) || ( oldWeapon.GetWeaponType() == WPT_MELEE ))
	{
		DisableCloak( player )
	}
}
                           