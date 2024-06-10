global function OnProjectileCollision_weapon_grenade_emp
global function OnProjectileCollision_weapon_grenade_decoy

bool AUDIO_DECOY_FIGHT = true

void function OnProjectileCollision_weapon_grenade_emp( entity projectile, vector pos, vector normal, entity hitEnt, int hitbox, bool isCritical )
{
	entity player = projectile.GetOwner()
	if ( hitEnt == player )
		return

	table collisionParams =
	{
		pos = pos,
		normal = normal,
		hitEnt = hitEnt,
		hitbox = hitbox
	}

	bool result = PlantStickyEntity( projectile, collisionParams )
	
	if ( projectile.GrenadeHasIgnited() )
		return
	
	projectile.GrenadeIgnite()

	#if SERVER
		thread ArcCookSound( projectile )
	#endif
}

void function OnProjectileCollision_weapon_grenade_decoy( entity projectile, vector pos, vector normal, entity hitEnt, int hitbox, bool isCritical )
{
	entity player = projectile.GetOwner()
	if ( hitEnt == player )
		return

	table collisionParams =
	{
		pos = pos,
		normal = normal,
		hitEnt = hitEnt,
		hitbox = hitbox
	}

	bool result = PlantStickyEntity( projectile, collisionParams )

	if ( projectile.GrenadeHasIgnited() )
		return

	#if SERVER
		#if DEVELOPER
			printt("------------AUDIO DECOY START-----------")
		#endif
		
		array<entity> weapons = SURVIVAL_GetPrimaryWeaponsSorted( player )

		entity activeWeapon //last weapon
		entity activeWeapon2 //the other weapon
		
		if ( weapons.len() == 0 )
		{
			#if DEVELOPER
				printt("error: no weapons to simulate.")
				printt("------------AUDIO DECOY END-----------")
			#endif 
			
			projectile.Destroy()
			return
		}
		
		if ( weapons.len() > 1 )
		{
			activeWeapon = weapons[0]
			activeWeapon2 = weapons[1]
		} 
		else
		{
			activeWeapon = weapons[0]
		}
		
		thread AudioDecoySound( projectile, player, activeWeapon)
		if(AUDIO_DECOY_FIGHT) thread AudioDecoySound( projectile, player, activeWeapon2, true)
	#endif
}

void function ArcCookSound( entity projectile )
{
	projectile.EndSignal( "OnDestroy" )

	string cookSound = expect string( projectile.ProjectileGetWeaponInfoFileKeyField( "sound_cook_warning" ) )
	float ignitionTime = expect float( projectile.ProjectileGetWeaponInfoFileKeyField( "grenade_ignition_time" ) )

	float stickTime = 0.2
	wait stickTime  // let it make a stick sound before alarm starts

	EmitSoundOnEntity( projectile, cookSound )
}


#if SERVER
void function AudioDecoySound( entity projectile, entity player, entity activeWeapon, bool randomness = false)
{
	projectile.EndSignal( "OnDestroy" )
	bool isAutoWeapon = false
	
	if( IsValid( activeWeapon ) )
	{
		#if DEVELOPER
			printt("weapon: " + activeWeapon.GetWeaponClassName())
		#endif
		
		string ornull loopingSounds = ""
		loopingSounds = expect string ornull(activeWeapon.GetWeaponInfoFileKeyField("looping_sounds"))
		
		string ornull weaponSound = ""
		weaponSound = expect string ornull(activeWeapon.GetWeaponInfoFileKeyField("fire_sound_2_player_3p"))
		if(weaponSound == "" || weaponSound == "large_shell_drop" || weaponSound == null || weaponSound == "Weapon_bulletCasings.Bounce")
			weaponSound = expect string ornull(activeWeapon.GetWeaponInfoFileKeyField("fire_sound_1_player_3p"))
		if(weaponSound == "Weapon_bulletCasings.Bounce" || weaponSound == null || weaponSound == "LMG_shell" || loopingSounds )
		{
			isAutoWeapon = true
			weaponSound = expect string ornull(activeWeapon.GetWeaponInfoFileKeyField("burst_or_looping_fire_sound_middle_3p"))
		}
		
		if(weaponSound == "weapon_prowler_burst_loop_3p")
		{
			isAutoWeapon = false
		}
		
		if(weaponSound == "" || weaponSound == null)
		{
			isAutoWeapon = false
			weaponSound = expect string ornull(activeWeapon.GetWeaponInfoFileKeyField("burst_or_looping_fire_sound_start_3p"))
		}
			
		string finalweaponSound = ""
		if(weaponSound != null)
			finalweaponSound = expect string (weaponSound)
		wait 1
		
		float fire_rate = activeWeapon.GetWeaponSettingFloat( eWeaponVar.fire_rate )
		int ammo_size = activeWeapon.GetWeaponSettingInt(eWeaponVar.ammo_clip_size)
		int sizebackup = ammo_size
		// if (loopingSounds != null) printt("loopingsounds?: " + expect string(loopingSounds))
		// printt("weaponsound: " + finalweaponSound)
		// printt("is auto weapon?: " + isAutoWeapon)
		// printt("firerate: " + fire_rate)
		// printt("ammo_size: " + ammo_size)
		float ornull rechamberTime
		rechamberTime = expect float ornull(activeWeapon.GetWeaponInfoFileKeyField("rechamber_time"))
		float aditionaltime
		float aditinalsubtract = 0
		bool ispwdorhml = false
		
		if(activeWeapon.GetWeaponClassName() == "mp_weapon_pdw")
		{
			aditionaltime = 0.24
			aditinalsubtract = 5
			ispwdorhml = true
			ammo_size = (ammo_size / aditinalsubtract).tointeger()
			sizebackup = ammo_size
			fire_rate = fire_rate * aditinalsubtract
		}
		else if (activeWeapon.GetWeaponClassName() == "mp_weapon_hemlok")
		{
			aditionaltime = 0.28
			aditinalsubtract = 3
			ispwdorhml = true
			ammo_size = (ammo_size / aditinalsubtract).tointeger()
			sizebackup = ammo_size
			fire_rate = fire_rate * aditinalsubtract
		}
			
		if(!isAutoWeapon)
		{
			while(ammo_size > 0)
			{
				EmitSoundOnEntity( projectile, finalweaponSound )
				ammo_size--

				float waittime
				if(rechamberTime == null) rechamberTime = float(0)
				
				if(expect float(rechamberTime) != 0 || rechamberTime != null)
					waittime = (1/fire_rate) + RandomFloatRange(0,0.1) + expect float(rechamberTime)
				else
					waittime = (1/fire_rate)
				
				if(randomness)
					waittime += RandomFloatRange(0,0.2)
				
				if(ispwdorhml)
						wait 0.12
					
				wait waittime
				//printt("[+] wait time: " + waittime)
				//printt("[+] this bullet: " + ammo_size)
				StopSoundOnEntity( projectile, finalweaponSound )
				
				if(ispwdorhml)
					wait 0.24
			}
			
			if( CoinFlip() )
			{
				float reloadtime = expect float(activeWeapon.GetWeaponInfoFileKeyField("reload_time")) + RandomFloatRange(0,0.1)
				wait reloadtime
				ammo_size = sizebackup
				while(ammo_size > 0){
					EmitSoundOnEntity( projectile, finalweaponSound )
					ammo_size--

					float waittime
					if(rechamberTime == null) rechamberTime = float(0)
					
					if(expect float(rechamberTime) != 0 || rechamberTime != null)
						waittime = (1/fire_rate) + RandomFloatRange(0,0.1) + expect float(rechamberTime)
					else
						waittime = (1/fire_rate)
					
					if(randomness)
						waittime += RandomFloatRange(0,0.2)
					
					if(ispwdorhml)
							wait 0.12
						
					wait waittime
					//printt("[+] wait time: " + waittime)
					//printt("[+] this bullet: " + ammo_size)
					StopSoundOnEntity( projectile, finalweaponSound )
					
					if(ispwdorhml)
						wait 0.24
				}
			}
				
				
		}
		else
		{
			EmitSoundOnEntity( projectile, finalweaponSound )
			float waittime = (1/fire_rate)*ammo_size
			wait waittime
			//printt("[+] wait time: " + waittime)
			StopSoundOnEntity( projectile, finalweaponSound )
			
			if( CoinFlip() )
			{
				float reloadtime = expect float(activeWeapon.GetWeaponInfoFileKeyField("reload_time")) + RandomFloatRange(0,0.1)
				wait reloadtime
				EmitSoundOnEntity( projectile, finalweaponSound )
				float waittime2 = (1/fire_rate)*ammo_size
				wait waittime2
				//printt("[+] wait time: " + waittime)
				StopSoundOnEntity( projectile, finalweaponSound )	
			}
		}
			
		#if DEVELOPER
			printt("------------AUDIO DECOY END-----------")
		#endif
		wait 2
		
		if( IsValid( projectile ) )	
			projectile.Destroy()
	} 
	else 
	{
		#if DEVELOPER
			printt("weapon: not valid or empty.")
			printt("------------AUDIO DECOY END-----------")
		#endif
	}
}
#endif