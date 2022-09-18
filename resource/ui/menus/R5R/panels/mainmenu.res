"resource/ui/menus/panels/mainmenu.res"
{
    "PanelFrame"
    {
		"ControlName"			"Label"
		"wide"					"%100"
		"tall"					"%100"
		"labelText"				""
		"visible"				"1"
    }

    "LaunchButton"
    {
        "ControlName"			"RuiButton"
        "wide"					"%100"
        "tall"					"%100"
        "zpos"                  "3"
        "rui"                   "ui/invisible.rpak"
        "labelText"             ""
        "visible"				"1"
		"sound_focus"           ""
		"sound_accept"          "UI_Menu_Accept"
        "cursorPriority"        "-1"

        "pin_to_sibling"		"PanelFrame"
        "pin_corner_to_sibling"	"TOP_LEFT"
        "pin_to_sibling_corner"	"TOP_LEFT"
    }

    "Status"
	{
		"ControlName"			"RuiPanel"
		"ypos"                  "190"
		"wide"                  "600"
		"tall"					"92"
		"visible"			    "1"
		"rui"                   "ui/titlemenu_status.rpak"

        "pin_to_sibling"		"PanelFrame"
        "pin_corner_to_sibling"	"CENTER"
        "pin_to_sibling_corner"	"CENTER"
	}

    "StatusDetails"
    {
        "ControlName"			"RuiPanel"
        "ypos"					"-126"
        "wide"					"940"
        "tall"					"90"
        "rui"                   "ui/titlemenu_status_details.rpak"
        "visible"				"1"

        "pin_to_sibling"		"PanelFrame"
        "pin_corner_to_sibling"	"BOTTOM"
        "pin_to_sibling_corner"	"BOTTOM"
    }
}
