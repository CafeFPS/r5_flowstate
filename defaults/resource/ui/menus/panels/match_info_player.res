"resource/ui/menus/panels/match_info_player.res"
{
	Name
	{
		ControlName				Label
		wide					190
		tall					30
		visible					1
		textAlignment				"east"
		textinsetx				11
		font 					Default_27
	}

	Score
	{
		ControlName				Label
		pin_to_sibling				Name
		pin_corner_to_sibling			TOP_LEFT
		pin_to_sibling_corner			TOP_RIGHT
		wide					60
		tall					30
		visible					1
		font 					Default_27
	}

	KillsIcon
	{
		ControlName				ImagePanel
		pin_to_sibling				Score
		pin_corner_to_sibling			TOP_LEFT
		pin_to_sibling_corner			TOP_RIGHT
		wide					30
		tall					30
		visible					1
		scaleImage				1
		image					"ui\menu\lobby\network_icon_kills"
	}

	Kills
	{
		ControlName				Label
		pin_to_sibling				KillsIcon
		pin_corner_to_sibling			TOP_LEFT
		pin_to_sibling_corner			TOP_RIGHT
		wide					40
		tall					30
		visible					1
		font 					Default_27
	}

	DeathsIcon
	{
		ControlName				ImagePanel
		pin_to_sibling				Kills
		pin_corner_to_sibling			TOP_LEFT
		pin_to_sibling_corner			TOP_RIGHT
		wide					30
		tall					30
		visible					1
		scaleImage				1
		image					"ui\menu\lobby\network_icon_deaths"
	}

	Deaths
	{
		ControlName				Label
		pin_to_sibling				DeathsIcon
		pin_corner_to_sibling			TOP_LEFT
		pin_to_sibling_corner			TOP_RIGHT
		wide					40
		tall					30
		visible					1
		font 					Default_27
	}

}
