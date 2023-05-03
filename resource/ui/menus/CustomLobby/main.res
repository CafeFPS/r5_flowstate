"resource/ui/menus/main.menu"
{
	"menu"
	{
		"ControlName"						"Frame"
		"xpos"								"0"
		"ypos"								"0"
		"zpos"								"3"
		"wide"								"f0"
		"tall"								"f0"
		"autoResize"						"0"
		"pinCorner"							"0"
		"visible"							"1"
		"enabled"							"1"
		"tabPosition"						"0"
		"disableDpad"						"1"
		"PaintBackgroundType"				"0"	// 0 for normal(opaque), 1 for single texture from Texture1, and 2 for rounded box w/ four corner textures
		"infocus_bgcolor_override"			"0 0 0 0"
		"outoffocus_bgcolor_override"		"0 0 0 0"
		"Screen"
		{
			"ControlName"		"Label"
			"wide"				"%100"
			"tall"				"%100"
			"labelText"			""
			"visible"			"0"
		}
		"FullBlackScreen"
		{
			"ControlName"		"ImagePanel"
			"tall"				"%100"
			"wide"				"%100"
			"fillColor"			"0 0 0 255"
			"drawColor"			"0 0 0 255"
			"visible"			"0"
			"zpos"				"30"
		}
		"SafeArea"
		{
			"ControlName"				"Label"
			"wide"						"%90"
			"tall"						"%90"
			"labelText"					""
			"visible"					"0"
			"pin_to_sibling"			"Screen"
			"pin_corner_to_sibling"		"CENTER"
			"pin_to_sibling_corner"		"CENTER"
		}
		"TitleArt"
		{
			"ControlName"				"RuiPanel"
			"wide"						"1920"
			"tall"						"%100"
			"rui"						"ui/basic_image.rpak"
			"pin_to_sibling"			"Screen"
			"pin_corner_to_sibling"		"CENTER"
			"pin_to_sibling_corner"		"CENTER"
		}
		"Subtitle"
		{
			"ControlName"				"RuiPanel"
			"wide"						"1920"
			"tall"						"%100"
			"visible"					"1"
			"rui"						"ui/titlemenu_subtitle.rpak"
			"pin_to_sibling"			"TitleArt"
			"pin_corner_to_sibling"		"CENTER"
			"pin_to_sibling_corner"		"CENTER"
		}
		"VersionDisplay"
		{
			"ControlName"				"Label"
			"xpos"						"-16"
			"ypos"						"8"
			"auto_wide_tocontents"		"1"
			"auto_tall_tocontents"		"1"
			"labelText"					""
			"font"						"DefaultRegularFont"
			"fontHeight"				"24"
			"visible"					"0"
			"fgcolor_override"			"255 255 255 83"
			"pin_to_sibling"			"CompanyInfo"
			"pin_corner_to_sibling"		"BOTTOM_RIGHT"
			"pin_to_sibling_corner"		"TOP_RIGHT"
		}
		"CompanyInfo"
		{
			"ControlName"				"RuiPanel"
			"wide"						"284"
			"tall"						"62"
			"visible"					"1"
			"rui"						"ui/titlemenu_company_info.rpak"
			"pin_to_sibling"			"SafeArea"
			"pin_corner_to_sibling"		"BOTTOM_RIGHT"
			"pin_to_sibling_corner"		"BOTTOM_RIGHT"
			"ruiArgs"
			{
				"copyrightText"		"#COPYRIGHT_TEXT"
			}
		}
		"ToolTip"
		{
			"ControlName"			"RuiPanel"
			"InheritProperties"		"ToolTip"
		}
		// //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		"R5RMainMenuPanel"
		{
			"ControlName"				"CNestedPanel"
			"classname"					"MainMenuPanelClass"
			// wide					1920
			// tall					1080
			"wide"						"%100"
			"tall"						"%100"
			"visible"					"0"
			"tabPosition"				"1"
			"controlSettingsFile"		"scripts/resource/ui/menus/CustomLobby/panels/mainmenu.res"
		}
		// //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		"FooterButtons"
		{
			"ControlName"			"CNestedPanel"
			"InheritProperties"		"FooterButtons"
		}
	}
}
