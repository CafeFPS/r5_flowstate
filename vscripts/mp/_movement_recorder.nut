//Made by @CafeFPS
global function StartMovementRecorder
global function DestroyDummys

struct{
	array<var> recordingAnims
}file

array<entity> dummyList;
bool continueLoop = true;

void function AssignCharacter( entity player, int index )
{
	ItemFlavor PersonajeEscogido = GetAllCharacters()[index]
	CharacterSelect_AssignCharacter( ToEHI( player ), PersonajeEscogido )		
	
	ItemFlavor playerCharacter = LoadoutSlot_GetItemFlavor( ToEHI( player ), Loadout_CharacterClass() )
	asset characterSetFile = CharacterClass_GetSetFile( playerCharacter )
	player.SetPlayerSettingsWithMods( characterSetFile, [] )
}

void function StartMovementRecorder(entity player, float length = 10, int character = 0, int shield = 1, float animRate = 1.0 )
{
	if( character < 0 ) return
	
	if( character > 2 ) 
		character = 0
	
	vector initialpos = player.GetOrigin()
	vector initialang = player.GetAngles()
	
	string msg1
	string aiFileToUse 
	
	array<string> coolDevs = [
		"CafeFPS",
		"DEAFPS",
		"AyeZee",
		"Makimakima",
		"Endergreen12",
		"Zer0Bytes",
		"Julefox",
		"amos_x64",
		"rexx_x64",
		"IcePixelx", 
		"KralRindo",
		"sal"
	]
	
	switch(character)
	{
		case 0:
			msg1 = "RECORDING MOVEMENT AS WRAITH"
			aiFileToUse = "npc_dummie_wraith"
			AssignCharacter(player, 8)
		break
		
		case 1:
			msg1 = "RECORDING MOVEMENT AS PATHFINDER"
			aiFileToUse = "npc_dummie_pathfinder"
			AssignCharacter(player, 7)
		break
		
		case 2:
			msg1 = "RECORDING MOVEMENT AS BANGALORE"
			aiFileToUse = "npc_dummie_bangalore"
			AssignCharacter(player, 0)
		break
		
		default:
			msg1 = "RECORDING MOVEMENT"
			aiFileToUse = "npc_dummie_wraith"
			AssignCharacter(player, 0)
		break
	}
	
	Message(player, msg1, "Made by @CafeFPS", 1.5)
	
	asset playermodel = player.GetModelName()
	player.StartRecordingAnimation(initialpos, initialang)
	
	wait length
	
	file.recordingAnims.append( player.StopRecordingAnimation() )
	var anim = file.recordingAnims[file.recordingAnims.len()-1]
	
	WaitFrame()
	if(!IsValid(player)) return
	
	Message(player, "PLAYING MOVEMENT", "", 1.5)
	
	#if DEVELOPER
		printt(anim) //userdata
	#endif
	
	continueLoop = true
	while( IsValid(player) && continueLoop )
	{
		entity dummy = CreateDummy( 99, initialpos, initialang )
		vector pos = dummy.GetOrigin()
		vector angles = dummy.GetAngles()
		StartParticleEffectInWorld( GetParticleSystemIndex( FIRINGRANGE_ITEM_RESPAWN_PARTICLE ), pos, angles )
		SetSpawnOption_AISettings( dummy, aiFileToUse )
		dummy.Hide()
		DispatchSpawn( dummy )
		dummy.SetTitle( coolDevs.getrandom() )
		SetDummyProperties(dummy, shield)
		
		WaitFrame()
		
		dummy.PlayRecordedAnimation( anim, initialpos, initialang, 0.5 )
		dummy.SetRecordedAnimationPlaybackRate( animRate )
		dummy.Show()
		
		waitthread function () : (anim, dummy, animRate)
		{
			EndSignal(dummy, "OnDeath")
			EndSignal(dummy, "OnDestroy")
			
			dummyList.append(dummy)
			
			wait GetRecordedAnimationDuration( anim ) * animRate
			
			if(!IsValid(dummy)) return
			
			if(dummyList.contains(dummy))
				dummyList.removebyvalue(dummy)
			
			dummy.Destroy()
		}()
	}
}

int function ReturnShieldAmountForDesiredLevel(int shield)
{
	switch(shield){
		case 0:
			return 0
		case 1:
			return 50
		case 2:
			return 75
		case 3:
			return 100
		case 4:
			return 125
			
		default:
			return 50
	}
	unreachable
}

void function SetDummyProperties(entity dummy, int shield)
{
	dummy.SetShieldHealthMax( ReturnShieldAmountForDesiredLevel(shield) )
	dummy.SetShieldHealth( ReturnShieldAmountForDesiredLevel(shield) )
	dummy.SetMaxHealth( 100 )
	dummy.SetHealth( 100 )
	dummy.SetDamageNotifications( true )
	dummy.SetTakeDamageType( DAMAGE_YES )
	dummy.SetCanBeMeleed( true )
	AddEntityCallback_OnDamaged( dummy, RecordingAnimationDummy_OnDamaged) 
}
void function RecordingAnimationDummy_OnDamaged( entity dummy, var damageInfo )
{
	entity ent = dummy	
	entity attacker = DamageInfo_GetAttacker(damageInfo)
	if(!attacker.IsPlayer()) return

	float damage = DamageInfo_GetDamage( damageInfo )
	
	//fake helmet
	float headshotMultiplier = GetHeadshotDamageMultiplierFromDamageInfo(damageInfo)
	float basedamage = DamageInfo_GetDamage(damageInfo)/headshotMultiplier
	
	if(IsValidHeadShot( damageInfo, dummy ))
	{
		int headshot = int(basedamage*(GetCurrentPlaylistVarFloat( "helmet_lv4", 0.65 )+(1-GetCurrentPlaylistVarFloat( "helmet_lv4", 0.65 ))*headshotMultiplier))
		DamageInfo_SetDamage( damageInfo, headshot)
	}

	// if(!attacker.IsPlayer() ) return
	// attacker.RefillAllAmmo()
}

void function DestroyDummys()
{
    continueLoop = false

    while (dummyList.len() > 0)
    {
        entity dummy = dummyList.pop()
        if (IsValid(dummy))
            dummy.Destroy()
    }
}
