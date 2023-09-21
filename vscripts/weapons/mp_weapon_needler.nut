//Made by @CafeFPS

untyped

global function MpWeaponNeedler_Init
global function OnWeaponActivate_needler
global function OnWeaponDeactivate_needler
global function OnWeaponPrimaryAttack_needler
global function OnWeaponBulletHit_needler
// global function OnWeaponStartZoomIn_needler
// global function OnWeaponStartZoomOut_needler
global function OnProjectileCollision_needler
global function OnWeaponReload_Needler

//Basic weapon stats
const float NEEDLER_DAMAGE = 12
const float NEEDLER_TIMETOEXPLODE = 2

//Custom particles
const asset NEEDLER_CUSTOMTRAIL = $"P_skydive_trail_CP"
const asset NEEDLER_EFFECTONEXPLODE = $"P_impact_exp_xo_shield_med_CP"
const asset NEEDLER_EFFECTONEXPLODE2 = $"P_plasma_exp_SM"


const AXE_FX_ATTACK_SWIPE_FP = $"P_wpn_bhaxe_swipe_FP"
const AXE_FX_ATTACK_SWIPE_3P = $"P_wpn_bhaxe_swipe_3P"

const asset KUNAI_FX_GLOW_FP = $"P_kunai_idle_FP"
const asset KUNAI_FX_GLOW_3P = $"P_kunai_idle_3P"

function MpWeaponNeedler_Init()
{
	PrecacheParticleSystem( NEEDLER_EFFECTONEXPLODE )
	PrecacheParticleSystem( NEEDLER_CUSTOMTRAIL )
	PrecacheParticleSystem( NEEDLER_EFFECTONEXPLODE2 )
	
	PrecacheParticleSystem( AXE_FX_ATTACK_SWIPE_FP ) 
	PrecacheParticleSystem( AXE_FX_ATTACK_SWIPE_3P ) 
	PrecacheParticleSystem( KUNAI_FX_GLOW_FP ) 
	PrecacheParticleSystem( KUNAI_FX_GLOW_3P ) 
	
	PrecacheParticleSystem( $"P_smartpistol_lockon_FP" )
	//PrecacheParticleSystem( $"wpn_arc_cannon_electricity_fp" )
	//PrecacheParticleSystem( $"wpn_arc_cannon_electricity" )
	PrecacheParticleSystem( $"wpn_mflash_snp_hmn_smoke_side" )
	PrecacheParticleSystem( $"wpn_mflash_snp_hmn_smoke_side_FP" )
	PrecacheParticleSystem( $"xo_spark_med" )
	PrecacheParticleSystem( $"P_smartpistol_lockon" )
	PrecacheParticleSystem( $"P_wat_hand_elec_CP" )
	PrecacheModel($"mdl/currency/crafting/currency_crafting_epic.rmdl")
}


#if SERVER || CLIENT
struct {
	bool onetime = false
	entity weapon
	entity lastent
	entity owner
} file
#endif 

void function OnWeaponActivate_needler( entity weapon )
{
	if ( !IsValid ( weapon ) )
		return

	entity weaponOwner = weapon.GetWeaponOwner() 

	#if CLIENT
	if ( !weapon.ShouldPredictProjectiles() )
		return

	if( !IsValid( weaponOwner ) || weaponOwner != GetLocalClientPlayer() || !weaponOwner.IsPlayer() || !IsAlive( weaponOwner ) )
		return

	if ( !InPrediction() ) //Stopgap fix for Bug 146443
		return
	#endif
	
	#if SERVER
	if( !IsValid( weaponOwner ) || !IsAlive( weaponOwner ) )
		return
	#endif

	#if CLIENT
	weapon.StopWeaponEffect( $"P_wat_hand_elec_CP" , $"P_wat_hand_elec_CP" )
	try{
		weapon.PlayWeaponEffect( $"P_wat_hand_elec_CP" , $"P_wat_hand_elec_CP", "shell" )
	}catch( e420_69 )
	{
		printt( "!FIXME - Tried to play an effect on the viewmodel, but player's viewmodel has no model." )
	}
	#endif

	array<string> mods = weapon.GetMods()
	
	try{
		foreach(mod in mods)
		{
			array<string> Data = split(mod, "-")
			
			if(Data[0] != "needlesTest") continue
			
			weapon.RemoveMod(mod)
		}
	}catch(e42069){}
	
	int clipSize = weapon.GetWeaponSettingInt( eWeaponVar.ammo_clip_size ) 
	int currentAmmo = weapon.GetWeaponPrimaryClipCount()
	int visualNeedles = 18 
	
	float idealVisualNeedlesToShow = floor( float( visualNeedles * currentAmmo ) / float(clipSize) )
	
	string modToSet = "needlesTest-" + idealVisualNeedlesToShow.tostring()
	
	try{
	if( DoesModExist( weapon, modToSet) )
		weapon.AddMod( modToSet )
	}catch(e420){}
}

void function OnWeaponDeactivate_needler( entity weapon )
{
	#if CLIENT
	if ( !weapon.ShouldPredictProjectiles() )
		return

	if( !IsValid( weapon.GetWeaponOwner() ) || weapon.GetWeaponOwner() != GetLocalClientPlayer() || !weapon.GetWeaponOwner().IsPlayer( ) )
		return

	if ( !InPrediction() ) //Stopgap fix for Bug 146443
		return
	#endif

	#if CLIENT
	weapon.StopWeaponEffect( $"P_wat_hand_elec_CP" , $"P_wat_hand_elec_CP" )
	#endif

	array<string> mods = weapon.GetMods()
	
	try{
		foreach(mod in mods) //check only for needles
		{
			array<string> Data = split(mod, "-")
			
			if(Data[0] != "needlesTest") continue
			
			weapon.RemoveMod(mod)
		}
	}catch(e420){}
}

var function OnWeaponPrimaryAttack_needler( entity weapon, WeaponPrimaryAttackParams attackParams )
{
	entity player = weapon.GetWeaponOwner()
	if ( !IsValid( player ) )
		return 0
	
	#if CLIENT
		if ( !weapon.ShouldPredictProjectiles() )
			return 1
	#endif // #if CLIENT
	
	int damageFlags = weapon.GetWeaponDamageFlags()
	file.weapon = weapon
	
	// #if SERVER
	array<string> mods = weapon.GetMods()
	
	try{
		foreach(mod in mods)
		{
			array<string> Data = split(mod, "-")
			
			if(Data[0] != "needlesTest") continue
			
			weapon.RemoveMod(mod)
		}
	}catch(e42069){}

	int clipSize = weapon.GetWeaponSettingInt( eWeaponVar.ammo_clip_size ) 
	int currentAmmo = weapon.GetWeaponPrimaryClipCount()
	int visualNeedles = 18 
	
	float idealVisualNeedlesToShow = floor( float( visualNeedles * currentAmmo ) / float(clipSize) )

	string modToSet = "needlesTest-" + idealVisualNeedlesToShow.tostring()
	
	try{
		if( DoesModExist( weapon, modToSet) )
			weapon.AddMod( modToSet )
	}catch(e420){}
	// #endif
	
	return SmartAmmo_FireNeedler( weapon, attackParams, damageFlags, damageFlags )
}

void function OnWeaponBulletHit_needler( entity weapon, WeaponBulletHitParams hitParams )
{
	#if SERVER
	entity hitEnt = hitParams.hitEnt
	
    #endif
}

void function OnProjectileCollision_needler( entity projectile, vector pos, vector normal, entity hitEnt, int hitbox, bool isCritical )
//By Retículo Endoplasmático#5955 (CafeFPS)
{
	#if SERVER
	if(hitEnt.IsNPC()){
		hitEnt.ai.needles++
		//printt("saving needle for ai - Total needles: " + hitEnt.ai.needles)
		
		if(CoinFlip()){
		entity model = CreatePropDynamic( $"mdl/currency/crafting/currency_crafting_epic.rmdl", hitEnt.GetOrigin(), <RandomIntRangeInclusive(-180,180), RandomIntRangeInclusive(-180,180), RandomIntRangeInclusive(-180,180)> )
		
		model.SetParent(hitEnt, "CHESTFOCUS")
		model.kv.modelscale = RandomFloatRange(0.6,0.8)
		model.SetOrigin(model.GetOrigin() + <RandomIntRangeInclusive(-5,5), RandomIntRangeInclusive(-5,5), RandomIntRangeInclusive(-20,10)>)
		hitEnt.ai.proplist.append(model)}
		
	} else if (hitEnt.IsPlayer())
	{
		hitEnt.p.needles++
		//printt("saving needle for player - Total needles: " + hitEnt.p.needles)	
		if(CoinFlip()){
		entity model = CreatePropDynamic( $"mdl/currency/crafting/currency_crafting_epic.rmdl", hitEnt.GetOrigin(), <RandomIntRangeInclusive(-180,180), RandomIntRangeInclusive(-180,180), RandomIntRangeInclusive(-180,180)> )
		
		model.SetParent(hitEnt, "CHESTFOCUS")
		model.kv.modelscale = RandomFloatRange(0.6,0.8)
		model.SetOrigin(model.GetOrigin() + <RandomIntRangeInclusive(-5,5), RandomIntRangeInclusive(-5,5), RandomIntRangeInclusive(-20,10)>)
		hitEnt.p.proplist.append(model)}
	}
	#endif
	
	#if CLIENT
	if(hitEnt.IsNPC()){
		hitEnt.ai.needles++
		//printt("saving needle for ai - Total needles: " + hitEnt.ai.needles)
	} else if (hitEnt.IsPlayer())
	{
		hitEnt.p.needles++
		//printt("saving needle for player - Total needles: " + hitEnt.p.needles)	
	}
	#endif
	
	#if SERVER || CLIENT
	entity weapon = projectile.GetWeaponSource()
	thread delayeddamage( weapon, hitEnt)	
	#endif

}

void function OnWeaponReload_Needler( entity weapon, int milestoneIndex )
{
	#if SERVER
	thread function() : (weapon)
	{
		WaitFrame()
		
		while(IsValid(weapon) && weapon.IsReloading())
			WaitFrame()
		
		if(!IsValid(weapon)) return
		
		entity weaponOwner = weapon.GetWeaponOwner()
		if ( !IsAlive( weaponOwner ) )
			return

		if ( !weaponOwner.IsPlayer() )
			return

		array<string> mods = weapon.GetMods()
		
		foreach(mod in mods) //check only for needles
			weapon.RemoveMod(mod)

		string modToSet = "needlesTest-18"
		
		weapon.AddMod( modToSet )
	}()
	#endif
}

void function delayeddamage( entity weapon, entity hitEnt)
//By Retículo Endoplasmático#5955 (CafeFPS)
{
	float damagetodeal

	if( !IsValid( weapon ) && IsValid( hitEnt ) )
	{
		if(hitEnt.IsNPC()){
			#if SERVER 
			if(IsValid(hitEnt.ai.particleonbody)) hitEnt.ai.particleonbody.Destroy()
			
			foreach(needle in hitEnt.ai.proplist){
					if(IsValid(needle))needle.Destroy()}
			
			#endif

			hitEnt.ai.needles = 0
			hitEnt.ai.ongoingneedlesexplode = false
		} else if (hitEnt.IsPlayer())
		{
			#if SERVER 
			if(IsValid(hitEnt.p.particleonbody)) hitEnt.p.particleonbody.Destroy()
			
			foreach(needle in hitEnt.p.proplist){
					if(IsValid(needle))needle.Destroy()}
			
			#endif

			hitEnt.p.needles = 0
			hitEnt.p.ongoingneedlesexplode = false
		}

		return
	}

	entity attacker = weapon.GetWeaponOwner()

	if(hitEnt.IsNPC() && hitEnt.ai.ongoingneedlesexplode){
		return
	} else if (hitEnt.IsPlayer() && hitEnt.p.ongoingneedlesexplode)
	{
		return
	}

	if(hitEnt.IsNPC()){
		hitEnt.ai.ongoingneedlesexplode = true
			#if SERVER 
			// local colorVec = Vector( 238, 255, 0 )
			// entity cpoint = CreateEntity( "info_placement_helper" )
			// SetTargetName( cpoint, UniqueString( "pickup_controlpoint" ) )
			// DispatchSpawn( cpoint )
			// cpoint.SetOrigin( colorVec )
			// entity glowFX = PlayFXWithControlPoint( $"P_ar_titan_droppoint", hitEnt.GetOrigin(), cpoint, -1, null, null, C_PLAYFX_LOOP )
			
			entity env_sprite = CreateEntity( "env_sprite" )
			env_sprite.SetScriptName( UniqueString( "molotov_sprite" ) )
			env_sprite.kv.rendermode = 5
			env_sprite.kv.origin = hitEnt.GetOrigin()
			env_sprite.kv.angles = <0, 0, 0>
			env_sprite.kv.fadedist = -1
			env_sprite.kv.rendercolor = "97 50 168"
			env_sprite.kv.renderamt = 255
			env_sprite.kv.framerate = "10.0"
			env_sprite.SetValueForModelKey( $"sprites/glow_05.vmt" )
			env_sprite.kv.scale = string( 0.5 )
			env_sprite.kv.spawnflags = 1
			env_sprite.kv.GlowProxySize = 15.0
			env_sprite.kv.HDRColorScale = 15.0
			DispatchSpawn( env_sprite )
			
			env_sprite.SetParent(hitEnt, "CHESTFOCUS")
			hitEnt.ai.particleonbody = env_sprite
			#endif
			
	} else if (hitEnt.IsPlayer())
	{
		hitEnt.p.ongoingneedlesexplode = true
			#if SERVER 
			entity env_sprite = CreateEntity( "env_sprite" )
			env_sprite.SetScriptName( UniqueString( "molotov_sprite" ) )
			env_sprite.kv.rendermode = 5
			env_sprite.kv.origin = hitEnt.GetOrigin()
			env_sprite.kv.angles = <0, 0, 0>
			env_sprite.kv.fadedist = -1
			env_sprite.kv.rendercolor = "97 50 168"
			env_sprite.kv.renderamt = 255
			env_sprite.kv.framerate = "10.0"
			env_sprite.SetValueForModelKey( $"sprites/glow_05.vmt" )
			env_sprite.kv.scale = string( 0.17 )
			env_sprite.kv.spawnflags = 1
			env_sprite.kv.GlowProxySize = 15.0
			env_sprite.kv.HDRColorScale = 15.0
			DispatchSpawn( env_sprite )
			
			env_sprite.SetParent(hitEnt, "CHESTFOCUS")
			hitEnt.p.particleonbody = env_sprite
			#endif
	}
	
	wait NEEDLER_TIMETOEXPLODE
	
	if( !IsValid( hitEnt ) )
		return

	if( IsValid( hitEnt ) && !IsAlive( hitEnt ) || !IsValid( attacker ) || !IsAlive( attacker ) )
	{
		if(hitEnt.IsNPC()){
			#if SERVER 
			if(IsValid(hitEnt.ai.particleonbody)) hitEnt.ai.particleonbody.Destroy()
			
			foreach(needle in hitEnt.ai.proplist){
					if(IsValid(needle))needle.Destroy()}
			
			#endif
			hitEnt.ai.needles = 0
			
			hitEnt.ai.ongoingneedlesexplode = false
		} else if (hitEnt.IsPlayer())
		{
			#if SERVER 
			if(IsValid(hitEnt.p.particleonbody)) hitEnt.p.particleonbody.Destroy()
			
			foreach(needle in hitEnt.p.proplist){
					if(IsValid(needle))needle.Destroy()}
			
			#endif
			hitEnt.p.needles = 0
			
			hitEnt.p.ongoingneedlesexplode = false
		}

		return
	}

	if(hitEnt.IsNPC()){
		damagetodeal = hitEnt.ai.needles*NEEDLER_DAMAGE

		#if SERVER 
		EmitSoundOnEntity( hitEnt, "spectre_arm_explode" )

		hitEnt.TakeDamage( damagetodeal, attacker, null, { scriptType = DF_BYPASS_SHIELD | DF_DOOMED_HEALTH_LOSS, damageSourceId = eDamageSourceId.deathField } )

		entity trailFXHandle = StartParticleEffectInWorld_ReturnEntity(GetParticleSystemIndex( NEEDLER_EFFECTONEXPLODE ), hitEnt.GetOrigin(), <RandomIntRangeInclusive(-180,180), RandomIntRangeInclusive(-180,180), RandomIntRangeInclusive(-180,180)>)
		trailFXHandle.SetParent(hitEnt, "CHESTFOCUS")
		trailFXHandle.SetOrigin(trailFXHandle.GetOrigin() + <RandomIntRangeInclusive(-5,5), RandomIntRangeInclusive(-5,5), RandomIntRangeInclusive(-20,10)>)
		trailFXHandle.SetAngles(<RandomIntRangeInclusive(-180,180), RandomIntRangeInclusive(-180,180), RandomIntRangeInclusive(-180,180)>)
		EffectSetControlPointVector( trailFXHandle, 1, <97, 50, 168> )
		
		entity trailFXHandle2 = StartParticleEffectInWorld_ReturnEntity(GetParticleSystemIndex( NEEDLER_EFFECTONEXPLODE2 ), hitEnt.GetOrigin(), <RandomIntRangeInclusive(-180,180), RandomIntRangeInclusive(-180,180), RandomIntRangeInclusive(-180,180)>)
		trailFXHandle2.SetParent(hitEnt, "CHESTFOCUS")
		trailFXHandle2.SetOrigin(trailFXHandle.GetOrigin() + <RandomIntRangeInclusive(-5,5), RandomIntRangeInclusive(-5,5), RandomIntRangeInclusive(-20,10)>)
		trailFXHandle2.SetAngles(<RandomIntRangeInclusive(-180,180), RandomIntRangeInclusive(-180,180), RandomIntRangeInclusive(-180,180)>)
		EffectSetControlPointVector( trailFXHandle2, 1, <97, 50, 168> )

		if(IsValid(hitEnt.ai.particleonbody)) hitEnt.ai.particleonbody.Destroy()
		
		foreach(needle in hitEnt.ai.proplist){
				if(IsValid(needle))needle.Destroy()}
		
		#endif
		//printt("dealing delayed damage ai - Total damage: " + damagetodeal)
		hitEnt.ai.needles = 0
		

	} else if (hitEnt.IsPlayer())
	{
		damagetodeal = hitEnt.p.needles*NEEDLER_DAMAGE

		#if SERVER 
		EmitSoundOnEntity( hitEnt, "spectre_arm_explode" )

		hitEnt.TakeDamage( damagetodeal, attacker, null, { scriptType = DF_BYPASS_SHIELD | DF_DOOMED_HEALTH_LOSS, damageSourceId = eDamageSourceId.deathField } )

		entity trailFXHandle = StartParticleEffectInWorld_ReturnEntity(GetParticleSystemIndex( NEEDLER_EFFECTONEXPLODE ), hitEnt.GetOrigin(), <RandomIntRangeInclusive(-180,180), RandomIntRangeInclusive(-180,180), RandomIntRangeInclusive(-180,180)>)
		trailFXHandle.SetParent(hitEnt, "CHESTFOCUS")
		trailFXHandle.SetOrigin(trailFXHandle.GetOrigin() + <RandomIntRangeInclusive(-5,5), RandomIntRangeInclusive(-5,5), RandomIntRangeInclusive(-20,10)>)
		trailFXHandle.SetAngles(<RandomIntRangeInclusive(-180,180), RandomIntRangeInclusive(-180,180), RandomIntRangeInclusive(-180,180)>)
		EffectSetControlPointVector( trailFXHandle, 1, <97, 50, 168> )
		
		entity trailFXHandle2 = StartParticleEffectInWorld_ReturnEntity(GetParticleSystemIndex( NEEDLER_EFFECTONEXPLODE2 ), hitEnt.GetOrigin(), <RandomIntRangeInclusive(-180,180), RandomIntRangeInclusive(-180,180), RandomIntRangeInclusive(-180,180)>)
		trailFXHandle2.SetParent(hitEnt, "CHESTFOCUS")
		trailFXHandle2.SetOrigin(trailFXHandle.GetOrigin() + <RandomIntRangeInclusive(-5,5), RandomIntRangeInclusive(-5,5), RandomIntRangeInclusive(-20,10)>)
		trailFXHandle2.SetAngles(<RandomIntRangeInclusive(-180,180), RandomIntRangeInclusive(-180,180), RandomIntRangeInclusive(-180,180)>)
		EffectSetControlPointVector( trailFXHandle2, 1, <97, 50, 168> )
		
		if(IsValid(hitEnt.p.particleonbody)) hitEnt.p.particleonbody.Destroy()
		
		foreach(needle in hitEnt.p.proplist){
				if(IsValid(needle))needle.Destroy()}
		
		#endif
		//printt("dealing delayed damage player - Total damage: " + damagetodeal)
		hitEnt.p.needles = 0
	}
	

	if(hitEnt.IsNPC()){
		hitEnt.ai.ongoingneedlesexplode = false
	} else if (hitEnt.IsPlayer())
	{
		hitEnt.p.ongoingneedlesexplode = false
	}
}