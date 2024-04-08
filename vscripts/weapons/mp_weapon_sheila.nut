untyped

global function OnWeaponDeactivate_weapon_sheila
global function OnWeaponStartZoomIn_weapon_sheila
global function OnWeaponStartZoomOut_weapon_sheila
global function OnWeaponPrimaryAttack_weapon_sheila
global function OnAnimEvent_weapon_sheila
global function OnWeaponZoomFOVToggle_weapon_sheila

#if SERVER
global function SheilaFixAnims
#endif

const string TURRET_BUTTON_PRESS_SOUND_1P = "weapon_sheilaturret_triggerpull"
const string TURRET_BUTTON_PRESS_SOUND_3P = "weapon_sheilaturret_triggerpull_3p"
const string TURRET_BARREL_SPIN_LOOP_1P = "weapon_sheilaturret_motorloop_1p"
const string TURRET_BARREL_SPIN_LOOP_3P = "Weapon_sheilaturret_MotorLoop_3P"
const string TURRET_WINDUP_1P = "weapon_sheilaturret_windup_1p"
const string TURRET_WINDUP_3P = "weapon_sheilaturret_windup_3p"
const string TURRET_WINDDOWN_1P = "weapon_sheilaturret_winddown_1P"
const string TURRET_WINDDOWN_3P = "weapon_sheilaturret_winddown_3P"
const string TURRET_RELOAD_3P = "weapon_sheilaturret_reload_generic_comp_3p"
const string TURRET_RELOAD_RAMPART_3P = "weapon_sheilaturret_reload_rampart_comp_3p"
const string TURRET_RELOAD = "weapon_sheilaturret_reload_rampart_null"
const string TURRET_FIRED_LAST_SHOT_1P = "weapon_sheilaturret_lastshot_1p"
const string TURRET_FIRED_LAST_SHOT_3P = "weapon_sheilaturret_lastshot_3p"
const string TURRET_DISMOUNT_1P = "weapon_sheilaturret_dismount_1p"
const string TURRET_SIGHT_FLIP_UP_1P = "weapon_sheilaturret_sightflipup"
const string TURRET_SIGHT_FLIP_DOWN_1P = "weapon_sheilaturret_sightflipdown"

const string TURRET_DRAWFIRST_1P = "weapon_sheilaturret_drawfirst_1p"
const string TURRET_DRAW_1P = "weapon_sheilaturret_draw_1p"

void function OnWeaponDeactivate_weapon_sheila( entity weapon )
{
	weapon.StopWeaponSound( TURRET_BARREL_SPIN_LOOP_1P )
	weapon.StopWeaponSound( TURRET_BARREL_SPIN_LOOP_3P )
	weapon.StopWeaponSound( TURRET_BUTTON_PRESS_SOUND_1P )
	weapon.StopWeaponSound( TURRET_BUTTON_PRESS_SOUND_3P )
	StopSoundOnEntity( weapon, TURRET_WINDUP_1P )
	StopSoundOnEntity( weapon, TURRET_WINDUP_3P )
	StopSoundOnEntity( weapon, TURRET_WINDDOWN_1P )
	StopSoundOnEntity( weapon, TURRET_RELOAD_3P )
	StopSoundOnEntity( weapon, TURRET_RELOAD_RAMPART_3P )

	#if SERVER
											
														 
									 
		 
																									   
		 
	#endif          

}

void function OnWeaponStartZoomIn_weapon_sheila( entity weapon )
{
	entity weaponOwner = weapon.GetWeaponOwner()

	if ( !IsValid( weaponOwner ) )
		return

	float zoomFrac = weaponOwner.GetZoomFrac()
	float zoomTimeIn = weapon.GetWeaponSettingFloat( eWeaponVar.zoom_time_in )

		// #if SERVER
		// thread function() : (weapon)
		// {
			// if(IsValid(weapon))
				// weapon.StartCustomActivity("ACT_VM_ADS_IN", 0)
			// WaitFrame()
			// if(!IsValid(weapon)) return
			// weapon.StopCustomActivity()
		// }()
		// #endif
	#if CLIENT
		if ( weaponOwner == GetLocalViewPlayer() )
		{
			EmitSoundOnEntityWithSeek( weapon, TURRET_WINDUP_1P, zoomFrac * zoomTimeIn )
		}
	#endif
}

void function OnWeaponStartZoomOut_weapon_sheila( entity weapon )
{
	weapon.StopWeaponSound( TURRET_BARREL_SPIN_LOOP_1P )
	weapon.StopWeaponSound( TURRET_BARREL_SPIN_LOOP_3P )
	weapon.StopWeaponSound( TURRET_BUTTON_PRESS_SOUND_1P )
	weapon.StopWeaponSound( TURRET_BUTTON_PRESS_SOUND_3P )
	StopSoundOnEntity( weapon, TURRET_WINDUP_1P )
	StopSoundOnEntity( weapon, TURRET_WINDUP_3P )

	entity weaponOwner = weapon.GetWeaponOwner()

	if ( !IsValid( weaponOwner ) )
		return

	float zoomFrac = weaponOwner.GetZoomFrac()
	float zoomOutTime = weapon.GetWeaponSettingFloat( eWeaponVar.zoom_time_out )

	if ( IsValid( weapon ) )
	{
		#if SERVER
		thread function() : (weapon)
		{
			if(IsValid(weapon))
				weapon.StartCustomActivity("ACT_VM_ADS_OUT", 0)
			// WaitFrame()
			// if(!IsValid(weapon)) return
			weapon.StopCustomActivity()
		}()
		#endif
		#if CLIENT
			if ( weaponOwner == GetLocalViewPlayer() )
				EmitSoundOnEntityWithSeek( weapon, TURRET_WINDDOWN_1P, (1 - zoomFrac) * zoomOutTime )
		#endif
	}

}

var function OnWeaponPrimaryAttack_weapon_sheila( entity weapon, WeaponPrimaryAttackParams attackParams )
{
	entity weaponOwner = weapon.GetOwner()

	if ( !IsValid( weaponOwner ) )
		return 0
	
	// #if SERVER
	// thread SheilaFixAnims(weapon)
	// #endif 
	
	// if ( weapon.IsWeaponInAds() && weaponOwner.GetZoomFrac() >= 1.0 )
	// {
		           
         

		        
		if ( weapon.GetWeaponPrimaryClipCount() == 1 )
		{
			#if SERVER
				                                                                                 
			#elseif CLIENT
				if ( weaponOwner == GetLocalViewPlayer() )
					EmitSoundOnEntity( weapon, TURRET_FIRED_LAST_SHOT_1P )
			#endif
		}

		         
		if ( weapon.GetWeaponPrimaryClipCount() == weapon.GetWeaponPrimaryClipCountMax() )
		{
			#if SERVER
				                                                                                    
				                                   
			#elseif CLIENT
				// entity turretEnt = GetPlaceableTurretEntForPlayer( weaponOwner )
				// if ( IsValid( turretEnt ) )
					// MountedTurretPlaceable_SetEligibleForRefund( GetPlaceableTurretEntForPlayer( weaponOwner ), false )
			#endif
		}

		  	                      
		#if SERVER
			                                                   
			                                    
			 
				                                                    
				                              
				 
					                                            
					                             
					 
						                                                      
					 
				 
			 
		#endif

		return OnWeaponPrimaryAttack_weapon_basic_bolt( weapon, attackParams )
	// }
	// else
	// {
		// return 0
	// }
}

#if SERVER
void function SheilaFixAnims(entity weapon)
{
	Signal(weapon, "EndFixAnimThread")
	EndSignal(weapon, "EndFixAnimThread")
	wait 0.3
	if(!IsValid(weapon)) return

	weapon.StartCustomActivity("ACT_VM_IDLE", 0)
	WaitFrame()
	if(!IsValid(weapon)) return
	weapon.StopCustomActivity()
}
#endif

void function OnAnimEvent_weapon_sheila( entity weapon, string eventName )
{
	switch ( eventName )
	{
		case "rampart_turret_button_press":
			weapon.EmitWeaponSound_1p3p( TURRET_BUTTON_PRESS_SOUND_1P, TURRET_BUTTON_PRESS_SOUND_3P )
			break
		case "rampart_turret_spin_up":
			weapon.EmitWeaponSound_1p3p( TURRET_BARREL_SPIN_LOOP_1P, TURRET_BARREL_SPIN_LOOP_3P )
			break
		default:
			return
	}
}

void function OnWeaponZoomFOVToggle_weapon_sheila( entity weapon, float targetFOV )
{
	#if CLIENT
	if ( weapon.GetOwner() != GetLocalViewPlayer() )
		return

	if ( targetFOV == weapon.GetWeaponSettingFloat( eWeaponVar.zoom_fov ) )             
	{
		EmitSoundOnEntity( weapon, TURRET_SIGHT_FLIP_DOWN_1P )
		StopSoundOnEntity( weapon, TURRET_SIGHT_FLIP_UP_1P )
	}
	else           
	{
		EmitSoundOnEntity( weapon, TURRET_SIGHT_FLIP_UP_1P )
		StopSoundOnEntity( weapon, TURRET_SIGHT_FLIP_DOWN_1P )
	}
	#endif
}
