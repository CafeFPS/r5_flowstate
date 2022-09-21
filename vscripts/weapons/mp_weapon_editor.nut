global function MpWeaponEditor_Init
global function OnWeaponAttemptOffhandSwitch_weapon_editor
global function OnWeaponActivate_weapon_editor
global function OnWeaponDeactivate_weapon_editor
global function OnWeaponOwnerChanged_weapon_editor
global function OnWeaponPrimaryAttack_weapon_editor
global function GetEditorModes

#if SERVER
global function ClientCommand_Compile 
global function ClientCommand_Load
#endif
#if CLIENT
global function UpdateRUI
global function ServerCallback_SetCurrentEditorMode
#endif

struct PropSaveInfo
{
    PropInfo& prop
    vector origin
    vector angles
}

struct
{
    // store the props here for saving and loading
    array<entity> allProps
    array<EditorMode> editorModes

    #if CLIENT
    var rui

    bool attemptSwitchToLastEditorMode = false
    float lastTimeOpenedEditorWheel
    #endif


} file

void function MpWeaponEditor_Init()
{
    RegisterEditorMode(EditorModePlace_Init())
    RegisterEditorMode(EditorModeDelete_Init())
    RegisterEditorMode(EditorModeToys_Init())



    AddCallback_OnPlayerAddWeaponMod(CycleWeaponMode)
    AddCallback_OnPlayerRemoveWeaponMod(CycleWeaponMode)

    #if CLIENT
    RegisterSignal("EndSetPresentationType")
    RegisterSignal("CloseModelRUI")
    ClMenuModels_Init()
    #elseif SERVER
    AddClientCommandCallback("SetEditorMode", ClientCommand_SetCurrentEditorMode)
    #endif
}

void function RegisterEditorMode(EditorMode mode)
{
    file.editorModes.append(mode)

}

array<EditorMode> function GetEditorModes()
{
    return file.editorModes
}

#if SERVER

bool function ClientCommand_SetCurrentEditorMode(entity player, array<string> args)
{
    if(!IsValid( player )) return false

    int idx = int( args[0] )
    if(idx >= GetEditorModes().len() || idx < 0) return false

    SetCurrentEditorMode(player, GetEditorModes()[idx])

    Remote_CallFunction_Replay(player, "ServerCallback_SetCurrentEditorMode", idx)
    return true
}
#endif

#if CLIENT
void function ServerCallback_SetCurrentEditorMode(int idx)
{
    SetCurrentEditorMode(GetLocalClientPlayer(), GetEditorModes()[idx])
    file.attemptSwitchToLastEditorMode = false
}
#endif

void function SetCurrentEditorMode(entity player, EditorMode mode)
{
    if(!IsValid( player )) return
    if(player.GetActiveWeapon( eActiveInventorySlot.mainHand ).GetWeaponClassName() != "mp_weapon_editor") 
        return   
    if( GetEditorModes().find(mode) == GetEditorModes().find(player.p.selectedEditorMode) )
        return

    if(player.p.selectedEditorMode.onDeactivationCallback != null)
    {
        player.p.lastEditorMode = player.p.selectedEditorMode
        player.p.selectedEditorMode.onDeactivationCallback(player)
    }
    player.p.selectedEditorMode = mode
    player.p.selectedEditorMode.onActivationCallback(player)

}

void function OnWeaponActivate_weapon_editor( entity weapon )
{
    #if CLIENT
    if (weapon.GetOwner() != GetLocalClientPlayer()) return
    entity player = GetLocalClientPlayer()

    
    RegisterConCommandTriggeredCallback("+use_alt", OpenEditorModeSelector)
    RegisterConCommandTriggeredCallback("-use_alt", CloseEditorModeSelector)


    thread MakeRUI()
    UpdateRUI(player)
    #elseif SERVER
    entity player = weapon.GetOwner()
    #endif

    player.p.selectedEditorMode = file.editorModes[0]
    player.p.selectedEditorMode.onActivationCallback(player)

}



#if CLIENT
void function OpenEditorModeSelector(entity player)
{
    CommsMenu_OpenMenuTo( player, eChatPage.EDITOR_MODES, eCommsMenuStyle.EDITOR_MODES_MENU )
    file.attemptSwitchToLastEditorMode = true
}

void function CloseEditorModeSelector(entity player)
{
    if(file.attemptSwitchToLastEditorMode)
    {
        file.attemptSwitchToLastEditorMode = false
        if(player.p.lastEditorMode != null)
        {
            player.ClientCommand(
                "SetEditorMode " + GetEditorModes().find( expect EditorMode(player.p.lastEditorMode) )
            )
        }
    }
    CommsMenu_Shutdown( true )
}

#endif

void function OnWeaponDeactivate_weapon_editor( entity weapon )
{
    #if CLIENT
    if (weapon.GetOwner() != GetLocalClientPlayer()) return
    entity player = GetLocalClientPlayer()
    clGlobal.levelEnt.Signal("CloseModelRUI")
    DeregisterConCommandTriggeredCallback("+use_alt", OpenEditorModeSelector)
    DeregisterConCommandTriggeredCallback("-use_alt", CloseEditorModeSelector)
    #elseif SERVER
    entity player = weapon.GetOwner()
    #endif

    //player.p.selectedEditorMode = file.editorModes[0]
    player.p.selectedEditorMode.onDeactivationCallback(player)
}

var function OnWeaponPrimaryAttack_weapon_editor( entity weapon, WeaponPrimaryAttackParams attackParams )
{
    #if CLIENT
    if (weapon.GetOwner() != GetLocalClientPlayer()) return
    entity player = GetLocalClientPlayer()
    #elseif SERVER
    entity player = weapon.GetOwner()
    #endif
    
    //player.p.selectedEditorMode = file.editorModes[0]
    player.p.selectedEditorMode.onAttackCallback(player)
}

void function OnWeaponOwnerChanged_weapon_editor( entity weapon, WeaponOwnerChangedParams changeParams )
{
	
}

void function CycleWeaponMode( entity player, entity weapon, string mod )
{
    if (weapon.GetWeaponClassName() != "mp_weapon_editor") return; 
    EditorMode curMode = player.p.selectedEditorMode
    int modeIndex = file.editorModes.find(curMode)
    if (modeIndex == -1) return
    int nextIndex = modeIndex + 1
    if (nextIndex >= file.editorModes.len()) nextIndex = 0
    player.p.selectedEditorMode = file.editorModes[nextIndex]
    #if CLIENT
        AnnouncementMessageRight( player, "Editor Mode: " + file.editorModes[nextIndex].displayName, "", <1, 1, 1>, $"", 3.0 )
    #elseif SERVER
        if (player.p.selectedEditorMode.crosshairActive)
        {
            if (!weapon.HasMod("crosshair_active")) weapon.AddMod("crosshair_active")
        }
        else 
        {
            if (weapon.HasMod("crosshair_active")) weapon.RemoveMod("crosshair_active")
        }
    #endif
    curMode.onDeactivationCallback(player)
    player.p.selectedEditorMode.onActivationCallback(player)
}

bool function OnWeaponAttemptOffhandSwitch_weapon_editor( entity weapon )
{
    int ammoReq  = weapon.GetAmmoPerShot()
    int currAmmo = weapon.GetWeaponPrimaryClipCount()

    return true //currAmmo >= ammoReq
}





// CODE FROM THE OTHER VERSION OF THE MODEL TOOL
// Most of this was written by Pebbers (@Vysteria on Github)



string function serialize() {
    // Model Serializer
    
    string serialized = ""
    
    int index = 0
    bool isNext = false // file.spawnPoints.len() != 0
    foreach (model in file.allProps) {
        string origin = serializeVector(model.GetOrigin())
        string angles = serializeVector(model.GetAngles())
        string name = model.GetModelName()

        serialized += "m:" + name + ";" + origin + ";" + angles
        if (isNext || index != (file.allProps.len() - 1)) {
            serialized += "|"
        }
        index++
    }
    index = 0
    // foreach(position in file.spawnPoints) {
    //     vector origin = position.origin 
    //     vector angles = position.angles

    //     string oSer = origin.x + "," + origin.y + "," + origin.z
    //     string aSer = angles.x + "," + angles.y + "," + angles.z
    //     serialized += "s:" + oSer + ";" + aSer

    //     if (index != (file.spawnPoints.len() - 1)) {
    //         serialized += "|"
    //     }
    //     index++
    // }

    printl("Serialization: " + serialized)
    
    return serialized
}

/*
array<entity> function deserialize(string serialized, bool dummies) {
    array<string> sections = split(serialized, "|")
    array<entity> entities = []
    int index = 0
    foreach(section in sections) {
        index++
        bool isModelSection = section.find("m:") != -1
        bool isPositionSection = section.find("s:") != -1
        
        if (isModelSection) {
            string payload = StringReplace(section, "m:", "")
            array<string> payloadSections = split(payload, ";")
            if (payloadSections.len() < 3) {
                printl("Problem with loading model: Less than 3 payloadSections ")
                foreach(psec in payloadSections) {
                    printl(psec)
                }
                continue
            }
            string modelName = payloadSections[0]
            vector origin = deserializeVector(payloadSections[1], "origin")
            vector angles = deserializeVector(payloadSections[2], "angles")
            
            entities.append(CreateFRProp(CastStringToAsset(modelName), origin, angles))
            printl("Loading model: " + modelName + " at " + origin + " with angle " + angles)
        } else if (isPositionSection) { 
            string payload = StringReplace(section, "s:", "")
            array<string> payloadSections = split(payload, ";")
            if (payloadSections.len() < 2) {
                printl("Problem with loading model: Less than 2 payloadSections ")
                foreach(psec in payloadSections) {
                    printl(psec)
                }
                continue
            }
            vector origin = deserializeVector(payloadSections[0], "origin")
            vector angles = deserializeVector(payloadSections[1], "angles")
            
            if (dummies) {
                entities.append(SpawnDummyAtPosition(origin, angles))
            }
            printl("Loading player position at " + origin + " with angle " + angles)
        } else {
            printl("Problem with section number " + index.tostring())
        }
    } 
    return entities
}
*/


vector function deserializeVector(string serialized, string type) {
    array<string> axis = split(serialized, ",")

    try {
        float x = axis[0].tofloat()
        float y = axis[1].tofloat()
        float z = axis[2].tofloat()
        return <x, y, z>
    } catch(error) {
        printl("Failed to serialize vector " + type + " " + serialized)
        printl(error)
        return <0, 0, 0>
    }
}

string function serializeVector(vector vec) {
    return vec.x + "," + vec.y + "," + vec.z
}

#if SERVER
bool function ClientCommand_Compile(entity player, array<string> args) {
    printl("SERIALIZED: " + serialize())
    return true
}
#endif

bool function ClientCommand_Load(entity player, array<string> args) {
    // if (args.len() == 0) {
    //     printl("USAGE: load \"<serialized code>\"")
    //     return false
    // }

    // string serializedCode = args[0]
    // file.entityModifications = deserialize(serializedCode, true)
    return true
}

#if CLIENT
void function MakeRUI()
{
    if ( file.rui != null)
    {
        RuiSetString( file.rui, "messageText", "0/0 | None" )
        return
    }

    clGlobal.levelEnt.EndSignal( "CloseModelRUI" )

    UISize screenSize = GetScreenSize()
    var screenAlignmentTopo = RuiTopology_CreatePlane( <(screenSize.width * -0.3),( screenSize.height * -0.52 ), 0>, <float( screenSize.width ), 0, 0>, <0, float( screenSize.height ), 0>, false )
    var rui = RuiCreate( $"ui/announcement_quick_right.rpak", screenAlignmentTopo, RUI_DRAW_HUD, RUI_SORT_SCREENFADE + 1 )
    
    RuiSetGameTime( rui, "startTime", Time() )
    RuiSetString( rui, "messageText", "0/0 | None" )
    RuiSetString( rui, "messageSubText", "Text 2")
    RuiSetFloat( rui, "duration", 9999999 )
    RuiSetFloat3( rui, "eventColor", SrgbToLinear( <128, 188, 255> ) )
	
    file.rui = rui
    
    OnThreadEnd(
		function() : ( rui )
		{
			RuiDestroy( rui )
			file.rui = null
		}
	)
    
    WaitForever()
}

void function UpdateRUI(entity player) {
    string section = "mdl/base_models"
    int index = 0

    if (player.p.selectedProp.section != "") {
        section = player.p.selectedProp.section
        index = player.p.selectedProp.index
    }

    string currentAsset = GetAssets()[section][index]
    int max = GetAssets()[section].len()
    int currIndex = index + 1

    RuiSetString( file.rui,"messageText", currIndex + "/" + max + " | " + currentAsset);
}
#endif