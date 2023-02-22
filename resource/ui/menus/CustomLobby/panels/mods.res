scripts/resource/ui/menus/CustomLobby/panels/mods.res
{
	"DarkenBackground"
	{
		"ControlName"			"Label"
		"xpos"					"0"
		"ypos"					"0"
		"wide"					"%100"
		"tall"					"%100"
		"labelText"				""
		"bgcolor_override"		"0 0 0 0"
		"visible"				"1"
		"paintbackground"		"1"
	}

	BrowseModsButton
    {
        ControlName				RuiButton
        classname               "MenuButton"
        wide					280
        tall					120
        ypos                    -150
        xpos                    0
        zpos                    10
        rui                     "ui/gamemode_select_v2_lobby_button.rpak"
        labelText               ""
        visible					1
        tabPosition             1
        cursorVelocityModifier  0.7
        sound_accept            "UI_Menu_GameMode_Select"
        scriptID					"1"

        ruiArgs
        {
            lockIconEnabled 0
            modeNameText "Browse Mods"
            modeDescText ""
            modeImage "rui/menu/store/feature_background_square"
        }

        pin_to_sibling			DarkenBackground
        pin_corner_to_sibling	BOTTOM
        pin_to_sibling_corner	BOTTOM
    }

	InstalledModsButton
    {
        ControlName				RuiButton
        classname               "MenuButton"
        wide					280
        tall					120
        ypos                    0
        xpos                    15
        zpos                    10
        rui                     "ui/gamemode_select_v2_lobby_button.rpak"
        labelText               ""
        visible					1
        tabPosition             1
        cursorVelocityModifier  0.7
        sound_accept            "UI_Menu_GameMode_Select"
        scriptID					"0"

        ruiArgs
        {
            lockIconEnabled 0
            modeNameText "Installed Mods"
            modeDescText ""
            modeImage "rui/menu/store/feature_background_square"
        }

        pin_to_sibling			BrowseModsButton
        pin_corner_to_sibling	LEFT
        pin_to_sibling_corner	RIGHT
    }

	BackButton
    {
        ControlName				RuiButton
        classname               "MenuButton"
        wide					280
        tall					120
        ypos                    -150
        xpos                    -20
        zpos                    10
        rui                     "ui/gamemode_select_v2_lobby_button.rpak"
        labelText               ""
        visible					0
        tabPosition             1
        cursorVelocityModifier  0.7
        sound_accept            "UI_Menu_GameMode_Select"

        ruiArgs
        {
            lockIconEnabled 0
            modeNameText "Back"
            modeDescText ""
            modeImage "rui/menu/store/feature_background_square"
        }

        pin_to_sibling			DarkenBackground
        pin_corner_to_sibling	BOTTOM_RIGHT
        pin_to_sibling_corner	BOTTOM_RIGHT
    }
}

