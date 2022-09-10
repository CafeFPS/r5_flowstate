global function DamageTypes_Init
global function RegisterWeaponDamageSource
global function GetObitFromDamageSourceID
global function GetObitImageFromDamageSourceID
global function DamageSourceIDToString
global function DamageSourceIDHasString
global function GetRefFromDamageSourceID
global function PIN_GetDamageCause

struct
{
	table<int,string> damageSourceIDToName
	table<int,asset> damageSourceIDToImage
	table<int,string> damageSourceIDToString
} file

global enum eDamageSourceId
{
	invalid 	= -1  // used in code

	//---------------------------
	// defined in damageDef.txt. This will go away ( you can use damagedef_nuclear_core instead of eDamageSourceId.[enum id] and get rid of it from here )
	// once this list has only damagedef_*, then we can remove eDamageSourceId
	code_reserved  				// may be merged with invalid -1 above
	damagedef_unknown		   	// must start at 1 and order must match what's in damageDefs.txt
	damagedef_unknownBugIt
	damagedef_suicide
	damagedef_despawn
	damagedef_titan_step
	damagedef_crush
	damagedef_sonic_blast
	damagedef_nuclear_core
	damagedef_titan_fall
	damagedef_titan_hotdrop
	damagedef_reaper_fall
	damagedef_trip_wire
	damagedef_wrecking_ball
	damagedef_reaper_groundslam
	damagedef_reaper_nuke
	damagedef_frag_drone_explode
	damagedef_frag_drone_explode_FD
	damagedef_frag_drone_throwable_PLAYER
	damagedef_frag_drone_throwable_NPC
	damagedef_stalker_powersupply_explosion_small
	damagedef_stalker_powersupply_explosion_large
	damagedef_stalker_powersupply_explosion_large_at
	damagedef_shield_captain_arc_shield
	damagedef_fd_explosive_barrel
	damagedef_fd_tether_trap
	damagedef_pilot_slam
	damagedef_ticky_arc_blast
	damagedef_grenade_gas
	damagedef_gas_exposure
	damagedef_dirty_bomb_explosion
	damagedef_sonic_boom
	damagedef_bangalore_smoke_explosion
	damagedef_creeping_bombardment_detcord_explosion
	damagedef_defensive_bombardment

	//---------------------------

	// Pilot Weapons
	mp_weapon_hemlok
	mp_weapon_lmg
	mp_weapon_rspn101
	mp_weapon_vinson
	mp_weapon_lstar
	mp_weapon_g2
	mp_weapon_r97
	mp_weapon_dmr
	mp_weapon_wingman
	mp_weapon_wingmanelite
	mp_weapon_semipistol
	mp_weapon_autopistol
	mp_weapon_sniper
	mp_weapon_shotgun
	mp_weapon_mastiff
	mp_weapon_frag_grenade
	mp_weapon_grenade_emp
	mp_weapon_arc_blast
	mp_weapon_thermite_grenade
	mp_weapon_nuke_satchel
	mp_extreme_environment
	mp_weapon_shotgun_pistol
	mp_weapon_doubletake
	mp_weapon_alternator_smg
	mp_weapon_esaw
	mp_weapon_wrecking_ball
	mp_weapon_melee_survival
	mp_weapon_pdw
	mp_weapon_epg
	mp_weapon_energy_ar
	mp_weapon_volt_smg
	mp_weapon_defender
	mp_weapon_softball
	mp_weapon_warmachine
	//
	melee_pilot_emptyhanded
	melee_pilot_arena
	melee_pilot_sword
	melee_titan_punch
	melee_titan_punch_ion
	melee_titan_punch_tone
	melee_titan_punch_legion
	melee_titan_punch_scorch
	melee_titan_punch_northstar
	melee_titan_punch_fighter
	melee_titan_punch_vanguard
	melee_titan_punch_stealth
	melee_titan_punch_rocket
	melee_titan_punch_drone
	melee_titan_sword
	melee_titan_sword_aoe

	melee_wraith_kunai
	mp_weapon_wraith_kunai_primary

	melee_bloodhound_axe
	mp_weapon_bloodhound_axe_primary

	melee_lifeline_baton
	mp_weapon_lifeline_baton_primary

	melee_shadowsquad_hands
	melee_shadowroyale_hands
	mp_weapon_shadow_squad_hands_primary

	mp_weapon_tesla_trap

	// Turret Weapons
	mp_weapon_yh803
	mp_weapon_yh803_bullet
	mp_weapon_yh803_bullet_overcharged
	mp_weapon_mega_turret
	mp_weapon_mega_turret_aa
	mp_turretweapon_rockets
	mp_turretweapon_blaster
	mp_turretweapon_plasma
	mp_turretweapon_sentry

	//Character Abilities
	mp_weapon_defensive_bombardment_weapon
	mp_weapon_creeping_bombardment_weapon
	mp_ability_octane_stim
	mp_ability_crypto_drone_emp
	mp_ability_crypto_drone_emp_trap
	// AI only Weapons
	mp_weapon_super_spectre
	mp_weapon_dronebeam
	mp_weapon_dronerocket
	mp_weapon_droneplasma
	mp_weapon_turretplasma
	mp_weapon_turretrockets
	mp_weapon_turretplasma_mega
	mp_weapon_gunship_launcher
	mp_weapon_gunship_turret
	mp_weapon_gunship_missile

	// Misc
	rodeo
	rodeo_forced_titan_eject //For awarding points when you force a pilot to eject via rodeo
	rodeo_execution
	human_melee
	auto_titan_melee
	berserker_melee
	mind_crime
	charge_ball
	grunt_melee
	spectre_melee
	prowler_melee
	super_spectre_melee
	titan_execution
	human_execution
	eviscerate
	wall_smash
	ai_turret
	team_switch
	rocket
	titan_explosion
	flash_surge
	sticky_time_bomb
	vortex_grenade
	droppod_impact
	ai_turret_explosion
	rodeo_trap
	round_end
	bubble_shield
	evac_dropship_explosion
	sticky_explosive
	titan_grapple

	// streaks

	// Environmental
	fall
	splat
	crushed
	burn
	lasergrid
	outOfBounds
	deathField
	indoor_inferno
	submerged
	switchback_trap
	floor_is_lava
	suicideSpectreAoE
	titanEmpField
	stuck
	deadly_fog
	exploding_barrel
	electric_conduit
	turbine
	harvester_beam
	toxic_sludge

	mp_weapon_spectre_spawner

	// development
	weapon_cubemap

	// Prototype
	mp_weapon_zipline
	at_turret_override
	rodeo_battery_removal
	phase_shift
	gamemode_bomb_detonation
	nuclear_turret
	proto_viewmodel_test
	mp_titanweapon_heat_shield
	mp_titanweapon_sonar_pulse
	mp_titanability_slow_trap
	mp_titanability_gun_shield
	mp_titanability_power_shot
	mp_titanability_ammo_swap
	mp_titanability_sonar_pulse
	mp_titanability_rearm
	mp_titancore_upgrade
	mp_titanweapon_xo16_vanguard
	mp_weapon_arc_trap
	mp_weapon_arc_launcher
	core_overload
	mp_titanweapon_stasis
	mp_titanweapon_stealth_titan
	mp_titanweapon_rocket_titan
	mp_titanweapon_drone_titan
	mp_titanweapon_stealth_sword
	mp_ability_consumable

	bombardment
	bleedout
	mp_weapon_energy_shotgun
	fire
	//damageSourceId=eDamageSourceId.xxxxx
	//fireteam
	//marvin
	//rocketstrike
	//orbitallaser
	//explosion
}

//When adding new mods, they need to be added below and to persistent_player_data_version_N.pdef in r1/cfg/server.
//Then when updating that file, save a new one and increment N.

global enum eModSourceId
{
	accelerator
	afterburners
	arc_triple_threat
	aog
	burn_mod_autopistol
	burn_mod_car
	burn_mod_defender
	burn_mod_dmr
	burn_mod_emp_grenade
	burn_mod_frag_grenade
	burn_mod_grenade_electric_smoke
	burn_mod_grenade_gravity
	burn_mod_thermite_grenade
	burn_mod_g2
	burn_mod_hemlok
	burn_mod_lmg
	burn_mod_mgl
	burn_mod_r97
	burn_mod_rspn101
	burn_mod_satchel
	burn_mod_semipistol
    burn_mod_smart_pistol
	burn_mod_smr
	burn_mod_sniper
	burn_mod_rocket_launcher
	burn_mod_titan_40mm
	burn_mod_titan_arc_cannon
	burn_mod_titan_rocket_launcher
	burn_mod_titan_sniper
	burn_mod_titan_triple_threat
	burn_mod_titan_xo16
	burn_mod_titan_dumbfire_rockets
	burn_mod_titan_homing_rockets
	burn_mod_titan_salvo_rockets
	burn_mod_titan_shoulder_rockets
	burn_mod_titan_vortex_shield
	burn_mod_titan_smoke
	burn_mod_titan_particle_wall
	burst
	capacitor
	enhanced_targeting
	extended_ammo
	fast_lock
	fast_reload
	guided_missile
	instant_shot
	overcharge
	quick_shot
	rapid_fire_missiles
	burn_mod_shotgun
	silencer
	slammer
	spread_increase_ttt
	stabilizer
	titanhammer
	burn_mod_wingman
	burn_mod_lstar
	burn_mod_mastiff
	burn_mod_vinson
	ricochet
	ar_trajectory
	smart_lock
	pro_screen
}

//Attachments intentionally left off. This prevents them from displaying in kill cards.
// modNameStrings should be defined when the mods are created, not in a separate table -Mackey
global const modNameStrings = {
	[ eModSourceId.accelerator ]						= "#MOD_ACCELERATOR_NAME",
	[ eModSourceId.afterburners ]						= "#MOD_AFTERBURNERS_NAME",
	[ eModSourceId.arc_triple_threat ] 					= "#MOD_ARC_TRIPLE_THREAT_NAME",
	[ eModSourceId.burn_mod_autopistol ] 				= "#BC_AUTOPISTOL_M2",
	[ eModSourceId.burn_mod_car ] 						= "#BC_CAR_M2",
	[ eModSourceId.burn_mod_defender ] 					= "#BC_DEFENDER_M2",
	[ eModSourceId.burn_mod_dmr ] 						= "#BC_DMR_M2",
	[ eModSourceId.burn_mod_emp_grenade ] 				= "#BC_EMP_GRENADE_M2",
	[ eModSourceId.burn_mod_frag_grenade ] 				= "#BC_FRAG_GRENADE_M2",
	[ eModSourceId.burn_mod_grenade_electric_smoke ] 	= "#BC_GRENADE_ELECTRIC_SMOKE_M2",
	[ eModSourceId.burn_mod_grenade_gravity ] 			= "#BC_GRENADE_ELECTRIC_SMOKE_M2",
	[ eModSourceId.burn_mod_thermite_grenade ] 			= "#BC_GRENADE_ELECTRIC_SMOKE_M2",
	[ eModSourceId.burn_mod_g2 ] 						= "#BC_G2_M2",
	[ eModSourceId.burn_mod_hemlok ] 					= "#BC_HEMLOK_M2",
	[ eModSourceId.burn_mod_lmg ] 						= "#BC_LMG_M2",
	[ eModSourceId.burn_mod_mgl ] 						= "#BC_MGL_M2",
	[ eModSourceId.burn_mod_r97 ] 						= "#BC_R97_M2",
	[ eModSourceId.burn_mod_rspn101 ] 					= "#BC_RSPN101_M2",
	[ eModSourceId.burn_mod_satchel ] 					= "#BC_SATCHEL_M2",
	[ eModSourceId.burn_mod_semipistol ] 				= "#BC_SEMIPISTOL_M2",
	[ eModSourceId.burn_mod_smr ] 						= "#BC_SMR_M2",
	[ eModSourceId.burn_mod_smart_pistol ] 				= "#BC_SMART_PISTOL_M2",
	[ eModSourceId.burn_mod_sniper ] 					= "#BC_SNIPER_M2",
	[ eModSourceId.burn_mod_rocket_launcher ] 			= "#BC_ROCKET_LAUNCHER_M2",
	[ eModSourceId.burn_mod_titan_40mm ] 				= "#BC_TITAN_40MM_M2",
	[ eModSourceId.burn_mod_titan_arc_cannon ] 			= "#BC_TITAN_ARC_CANNON_M2",
	[ eModSourceId.burn_mod_titan_rocket_launcher ] 	= "#BC_TITAN_ROCKET_LAUNCHER_M2",
	[ eModSourceId.burn_mod_titan_sniper ] 				= "#BC_TITAN_SNIPER_M2",
	[ eModSourceId.burn_mod_titan_triple_threat ] 		= "#BC_TITAN_TRIPLE_THREAT_M2",
	[ eModSourceId.burn_mod_titan_xo16 ]			 	= "#BC_TITAN_XO16_M2",
	[ eModSourceId.burn_mod_titan_dumbfire_rockets ] 	= "#BC_TITAN_DUMBFIRE_MISSILE_M2",
	[ eModSourceId.burn_mod_titan_homing_rockets ] 		= "#BC_TITAN_HOMING_ROCKETS_M2",
	[ eModSourceId.burn_mod_titan_salvo_rockets ] 		= "#BC_TITAN_SALVO_ROCKETS_M2",
	[ eModSourceId.burn_mod_titan_shoulder_rockets ] 	= "#BC_TITAN_SHOULDER_ROCKETS_M2",
	[ eModSourceId.burn_mod_titan_vortex_shield ] 		= "#BC_TITAN_VORTEX_SHIELD_M2",
	[ eModSourceId.burn_mod_titan_smoke ] 				= "#BC_TITAN_ELECTRIC_SMOKE_M2",
	[ eModSourceId.burn_mod_titan_particle_wall ] 		= "#BC_TITAN_SHIELD_WALL_M2",
	[ eModSourceId.burst ] 								= "#MOD_BURST_NAME",
	[ eModSourceId.capacitor ] 							= "#MOD_CAPACITOR_NAME",
	[ eModSourceId.enhanced_targeting ] 				= "#MOD_ENHANCED_TARGETING_NAME",
	[ eModSourceId.extended_ammo ] 						= "#MOD_EXTENDED_MAG_NAME",
	[ eModSourceId.fast_reload ] 						= "#MOD_FAST_RELOAD_NAME",
	[ eModSourceId.instant_shot ]						= "#MOD_INSTANT_SHOT_NAME",
	[ eModSourceId.overcharge ] 						= "#MOD_OVERCHARGE_NAME",
	[ eModSourceId.quick_shot ]							= "#MOD_QUICK_SHOT_NAME",
	[ eModSourceId.rapid_fire_missiles ] 				= "#MOD_RAPID_FIRE_MISSILES_NAME",
	[ eModSourceId.burn_mod_shotgun ] 					= "#BC_SHOTGUN_M2",
	[ eModSourceId.silencer ] 							= "#MOD_SILENCER_NAME",
	[ eModSourceId.slammer ] 							= "#MOD_SLAMMER_NAME",
	[ eModSourceId.spread_increase_ttt ]				= "#MOD_SPREAD_INCREASE_TTT_NAME",
	[ eModSourceId.stabilizer ]							= "#MOD_STABILIZER_NAME",
	[ eModSourceId.titanhammer ] 						= "#MOD_TITANHAMMER_NAME",
	[ eModSourceId.burn_mod_wingman ]					= "#BC_WINGMAN_M2",
	[ eModSourceId.burn_mod_lstar ]						= "#BC_LSTAR_M2",
	[ eModSourceId.burn_mod_mastiff ]					= "#BC_MASTIFF_M2",
	[ eModSourceId.burn_mod_vinson ]					= "#BC_VINSON_M2",
	[ eModSourceId.ricochet ]							= "Ricochet",
	[ eModSourceId.ar_trajectory ]						= "AR Trajectory",
	[ eModSourceId.smart_lock ]							= "Smart Lock",
	[ eModSourceId.pro_screen ]							= "Pro Screen",
}

void function DamageTypes_Init()
{
#if SERVER
	SvDemo_ConsistencyCheckString( "DamageTypes_Init()" )
#endif

	foreach ( name, number in eDamageSourceId )
	{
		file.damageSourceIDToString[ number ] <- name
	}

	PrecacheWeapon( $"mp_weapon_rspn101" ) // used by npc_soldier ><

#if R5DEV

	int numDamageDefs = DamageDef_GetCount()
	table damageSourceIdEnum = expect table( getconsttable().eDamageSourceId )
	foreach ( name, id in damageSourceIdEnum )
	{
		expect int( id )
		if ( id <= eDamageSourceId.code_reserved || id >= numDamageDefs )
			continue

		string damageDefName = DamageDef_GetName( id )
		Assert( damageDefName == name, "damage def (" + id + ") name: '" + damageDefName + "' doesn't match damage source id '" + name + "'" )
	}
#endif

	file.damageSourceIDToImage =
	{
		//
		//
		//
		//
		//
	}

		file.damageSourceIDToImage[eDamageSourceId.melee_shadowsquad_hands] <- $"rui/gamemodes/shadow_squad/shadow_icon_small"
		file.damageSourceIDToImage[eDamageSourceId.mp_weapon_volt_smg] <- $"rui/weapon_icons/r5/weapon_volt"

	file.damageSourceIDToName =
	{
		//mp
		[ eDamageSourceId.mp_extreme_environment ] 					= "#DAMAGE_EXTREME_ENVIRONMENT",

		[ eDamageSourceId.mp_weapon_yh803 ] 						= "#WPN_LIGHT_TURRET",
		[ eDamageSourceId.mp_weapon_yh803_bullet ]					= "#WPN_LIGHT_TURRET",
		[ eDamageSourceId.mp_weapon_yh803_bullet_overcharged ]		= "#WPN_LIGHT_TURRET",
		[ eDamageSourceId.mp_weapon_mega_turret ]					= "#WPN_MEGA_TURRET",
		[ eDamageSourceId.mp_weapon_mega_turret_aa ]				= "#WPN_MEGA_TURRET",
		[ eDamageSourceId.mp_turretweapon_rockets ]					= "#WPN_TURRET_ROCKETS",
		[ eDamageSourceId.mp_weapon_super_spectre ]					= "#WPN_SUPERSPECTRE_ROCKETS",
		[ eDamageSourceId.mp_weapon_dronebeam ] 					= "#WPN_DRONERBEAM",
		[ eDamageSourceId.mp_weapon_dronerocket ] 					= "#WPN_DRONEROCKET",
		[ eDamageSourceId.mp_weapon_droneplasma ] 					= "#WPN_DRONEPLASMA",
		[ eDamageSourceId.mp_weapon_turretplasma ] 					= "#WPN_TURRETPLASMA",
		[ eDamageSourceId.mp_weapon_turretrockets ] 				= "#WPN_TURRETROCKETS",
		[ eDamageSourceId.mp_weapon_turretplasma_mega ] 			= "#WPN_TURRETPLASMA_MEGA",
		[ eDamageSourceId.mp_weapon_gunship_launcher ] 				= "#WPN_GUNSHIP_LAUNCHER",
		[ eDamageSourceId.mp_weapon_gunship_turret ]				= "#WPN_GUNSHIP_TURRET",
		[ eDamageSourceId.mp_weapon_gunship_turret ]				= "#WPN_GUNSHIP_MISSILE",

		[ eDamageSourceId.mp_titanability_slow_trap ]				= "#DEATH_SLOW_TRAP",

		[ eDamageSourceId.rodeo ] 									= "#DEATH_TITAN_RODEO",
		[ eDamageSourceId.rodeo_forced_titan_eject ] 				= "#DEATH_TITAN_RODEO",
		[ eDamageSourceId.rodeo_execution ] 						= "#DEATH_RODEO_EXECUTION",
		[ eDamageSourceId.nuclear_turret ] 							= "#DEATH_NUCLEAR_TURRET",
		[ eDamageSourceId.berserker_melee ]							= "#DEATH_BERSERKER_MELEE",
		[ eDamageSourceId.human_melee ] 							= "#DEATH_HUMAN_MELEE",
		[ eDamageSourceId.auto_titan_melee ] 						= "#DEATH_AUTO_TITAN_MELEE",

		[ eDamageSourceId.prowler_melee ] 							= "#DEATH_PROWLER_MELEE",
		[ eDamageSourceId.super_spectre_melee ] 					= "#DEATH_SUPER_SPECTRE",
		[ eDamageSourceId.grunt_melee ] 							= "#DEATH_GRUNT_MELEE",
		[ eDamageSourceId.spectre_melee ] 							= "#DEATH_SPECTRE_MELEE",
		[ eDamageSourceId.eviscerate ]	 							= "#DEATH_EVISCERATE",
		[ eDamageSourceId.wall_smash ] 								= "#DEATH_WALL_SMASH",
		[ eDamageSourceId.ai_turret ] 								= "#DEATH_TURRET",
		[ eDamageSourceId.team_switch ] 							= "#DEATH_TEAM_CHANGE",
		[ eDamageSourceId.rocket ] 									= "#DEATH_ROCKET",
		[ eDamageSourceId.titan_explosion ] 						= "#DEATH_TITAN_EXPLOSION",
		[ eDamageSourceId.evac_dropship_explosion ] 				= "#DEATH_EVAC_DROPSHIP_EXPLOSION",
		[ eDamageSourceId.flash_surge ] 							= "#DEATH_FLASH_SURGE",
		[ eDamageSourceId.sticky_time_bomb ] 						= "#DEATH_STICKY_TIME_BOMB",
		[ eDamageSourceId.vortex_grenade ] 							= "#DEATH_VORTEX_GRENADE",
		[ eDamageSourceId.droppod_impact ] 							= "#DEATH_DROPPOD_CRUSH",
		[ eDamageSourceId.ai_turret_explosion ] 					= "#DEATH_TURRET_EXPLOSION",
		[ eDamageSourceId.rodeo_trap ] 								= "#DEATH_RODEO_TRAP",
		[ eDamageSourceId.round_end ] 								= "#DEATH_ROUND_END",
		[ eDamageSourceId.burn ]	 								= "#DEATH_BURN",
		[ eDamageSourceId.mind_crime ]								= "Mind Crime",
		[ eDamageSourceId.charge_ball ]								= "Charge Ball",
		[ eDamageSourceId.core_overload ]							= "#DEATH_CORE_OVERLOAD",
		[ eDamageSourceId.mp_weapon_arc_trap ]						= "#WPN_ARC_TRAP",

		[ eDamageSourceId.mp_turretweapon_sentry ] 					= "#WPN_SENTRY_TURRET",
		[ eDamageSourceId.mp_turretweapon_blaster ] 				= "#WPN_BLASTER_TURRET",
		[ eDamageSourceId.mp_turretweapon_rockets ] 				= "#WPN_ROCKET_TURRET",
		[ eDamageSourceId.mp_turretweapon_plasma ]	 				= "#WPN_PLASMA_TURRET",

		[ eDamageSourceId.bubble_shield ] 							= "#DEATH_BUBBLE_SHIELD",
		[ eDamageSourceId.sticky_explosive ] 						= "#DEATH_STICKY_EXPLOSIVE",
		[ eDamageSourceId.titan_grapple ] 							= "#DEATH_TITAN_GRAPPLE",

		// Instant death. Show no percentages on death recap.
		[ eDamageSourceId.fall ]		 							= "#DEATH_FALL",
		 //Todo: Rename eDamageSourceId.splat with a more appropriate name. This damage type was used for enviornmental damage, but it was for eject killing pilots if they were near a ceiling. I've changed the localized string to "Enviornment Damage", but this will cause confusion in the future.
		[ eDamageSourceId.splat ] 									= "#DEATH_SPLAT",
		[ eDamageSourceId.titan_execution ] 						= "#DEATH_TITAN_EXECUTION",
		[ eDamageSourceId.human_execution ] 						= "#DEATH_HUMAN_EXECUTION",
		[ eDamageSourceId.outOfBounds ] 							= "#DEATH_OUT_OF_BOUNDS",
		[ eDamageSourceId.indoor_inferno ]	 						= "#DEATH_INDOOR_INFERNO",
		[ eDamageSourceId.submerged ]								= "#DEATH_SUBMERGED",
		[ eDamageSourceId.switchback_trap ]							= "#DEATH_ELECTROCUTION", // Damages teammates and opposing team
		[ eDamageSourceId.floor_is_lava ]							= "#DEATH_ELECTROCUTION",
		[ eDamageSourceId.suicideSpectreAoE ]						= "#DEATH_SUICIDE_SPECTRE", // Used for distinguishing the initial spectre from allies.
		[ eDamageSourceId.titanEmpField ] 							= "#DEATH_TITAN_EMP_FIELD",
		[ eDamageSourceId.deadly_fog ] 								= "#DEATH_DEADLY_FOG",


		// Prototype
		[ eDamageSourceId.mp_weapon_zipline ]						= "Zipline",
		[ eDamageSourceId.at_turret_override ]						= "AT Turret",
		[ eDamageSourceId.phase_shift ]								= "#WPN_SHIFTER",
		[ eDamageSourceId.gamemode_bomb_detonation ]				= "Bomb Detonation",
		[ eDamageSourceId.bleedout ]								= "#DEATH_BLEEDOUT",
		[ eDamageSourceId.mp_weapon_energy_shotgun ]				= "Energy Shotgun",

		[ eDamageSourceId.damagedef_unknownBugIt ] 					= "#DEATH_GENERIC_KILLED",
		[ eDamageSourceId.damagedef_unknown ] 						= "#DEATH_GENERIC_KILLED",
		[ eDamageSourceId.weapon_cubemap ] 							= "#DEATH_GENERIC_KILLED",
		[ eDamageSourceId.stuck ]		 							= "#DEATH_GENERIC_KILLED",
		[ eDamageSourceId.rodeo_battery_removal ]					= "#DEATH_RODEO_BATTERY_REMOVAL",

		[ eDamageSourceId.melee_pilot_emptyhanded ] 				= "#DEATH_MELEE",
		[ eDamageSourceId.melee_pilot_arena ]		 				= "#DEATH_MELEE",
		[ eDamageSourceId.melee_pilot_sword ] 						= "#DEATH_SWORD",
		[ eDamageSourceId.melee_titan_punch ] 						= "#DEATH_TITAN_MELEE",
		[ eDamageSourceId.melee_titan_punch_ion ] 					= "#DEATH_TITAN_MELEE",
		[ eDamageSourceId.melee_titan_punch_tone ] 					= "#DEATH_TITAN_MELEE",
		[ eDamageSourceId.melee_titan_punch_northstar ] 			= "#DEATH_TITAN_MELEE",
		[ eDamageSourceId.melee_titan_punch_scorch ] 				= "#DEATH_TITAN_MELEE",
		[ eDamageSourceId.melee_titan_punch_legion ] 				= "#DEATH_TITAN_MELEE",
		[ eDamageSourceId.melee_titan_punch_fighter ]		 		= "#DEATH_TITAN_MELEE",
		[ eDamageSourceId.melee_titan_punch_vanguard ] 				= "#DEATH_TITAN_MELEE",
		[ eDamageSourceId.melee_titan_punch_stealth ] 				= "#DEATH_TITAN_MELEE",
		[ eDamageSourceId.melee_titan_punch_rocket ] 				= "#DEATH_TITAN_MELEE",
		[ eDamageSourceId.melee_titan_punch_drone ] 				= "#DEATH_TITAN_MELEE",
		[ eDamageSourceId.melee_titan_sword ]						= "#DEATH_TITAN_SWORD",
		[ eDamageSourceId.melee_titan_sword_aoe ]					= "#DEATH_TITAN_SWORD",
		[ eDamageSourceId.melee_wraith_kunai ] 						= "#DEATH_MELEE_WRAITH_KUNAI",
		[ eDamageSourceId.mp_weapon_wraith_kunai_primary ] 			= "#DEATH_MELEE_WRAITH_KUNAI",
		[ eDamageSourceId.mp_weapon_volt_smg ] 						= "#WPN_VOLT_SMG",
		[ eDamageSourceId.mp_ability_octane_stim ] 					= "#WPN_OCTANE_STIM_SHORT",

		[ eDamageSourceId.mp_weapon_tesla_trap ] 					= "#DEATH_TESLA_TRAP"

		,[ eDamageSourceId.mp_ability_crypto_drone_emp ]			= "#WPN_DRONE_EMP" //
		,[ eDamageSourceId.mp_ability_crypto_drone_emp_trap ]		= "#WPN_DRONE_EMP"

		,[ eDamageSourceId.melee_bloodhound_axe ] 				= "#DEATH_MELEE_BLOODHOUND_AXE"
		,[ eDamageSourceId.mp_weapon_bloodhound_axe_primary ] 	= "#DEATH_MELEE_BLOODHOUND_AXE"

		,[ eDamageSourceId.melee_lifeline_baton ]				= "#DEATH_MELEE_LIFELINE_BATON"
		,[ eDamageSourceId.mp_weapon_lifeline_baton_primary ]	= "#DEATH_MELEE_LIFELINE_BATON"
		,[ eDamageSourceId.melee_shadowsquad_hands ] 				= "#DEATH_MELEE_SHADOWSQUAD_HANDS"
		,[ eDamageSourceId.mp_weapon_shadow_squad_hands_primary ] 	= "#DEATH_MELEE_SHADOWSQUAD_HANDS"
	}

	#if R5DEV
		//development, with retail versions incase a rare bug happens we dont want to show developer text
		file.damageSourceIDToName[ eDamageSourceId.damagedef_unknownBugIt ] 			= "UNKNOWN! BUG IT!"
		file.damageSourceIDToName[ eDamageSourceId.damagedef_unknown ] 				= "Unknown"
		file.damageSourceIDToName[ eDamageSourceId.weapon_cubemap ] 					= "Cubemap"
		//file.damageSourceIDToName[ eDamageSourceId.invalid ] 						= "INVALID (BUG IT!)"
		file.damageSourceIDToName[ eDamageSourceId.stuck ]		 					= "NPC got Stuck (Don't Bug it!)"
	#endif
}

void function RegisterWeaponDamageSource( string weaponRef )
{
	int sourceID = eDamageSourceId[weaponRef]
	file.damageSourceIDToName[ sourceID ] <- GetWeaponInfoFileKeyField_GlobalString( weaponRef, "shortprintname" )
	file.damageSourceIDToImage[ sourceID ] <- GetWeaponInfoFileKeyFieldAsset_Global( weaponRef, "hud_icon" )
	file.damageSourceIDToString[ sourceID ] <- weaponRef
}

bool function DamageSourceIDHasString( int index )
{
	return (index in file.damageSourceIDToString)
}

string function DamageSourceIDToString( int index )
{
	return file.damageSourceIDToString[ index ]
}

string function GetObitFromDamageSourceID( int damageSourceID )
{
	if ( damageSourceID > 0 && damageSourceID < DamageDef_GetCount() )
	{
		return DamageDef_GetObituary( damageSourceID )
	}

	if ( damageSourceID in file.damageSourceIDToName )
		return file.damageSourceIDToName[ damageSourceID ]

	table damageSourceIdEnum = expect table( getconsttable().eDamageSourceId )
	foreach ( name, id in damageSourceIdEnum )
	{
		if ( id == damageSourceID )
			return expect string( name )
	}

	return ""
}

asset function GetObitImageFromDamageSourceID( int damageSourceID )
{
	if ( damageSourceID in file.damageSourceIDToImage )
		return file.damageSourceIDToImage[ damageSourceID ]

	return $""
}

string function GetRefFromDamageSourceID( int damageSourceID )
{
	return file.damageSourceIDToString[damageSourceID]
}

string function PIN_GetDamageCause( var damageInfo )
{
	/*
	headshot
	ability
	weapon
	melee
	item
	env
	self
	bleedout
	player_stuck
	*/

	//int id = DamageInfo_GetDamageSourceIdentifier( damageInfo )

	return ""
}
