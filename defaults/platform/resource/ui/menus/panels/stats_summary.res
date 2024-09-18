"resource/ui/menus/panels/stats_summary.res"
{
	PanelFrame
	{
		ControlName				Label
		xpos					0
		ypos					0
		wide					%100
		tall					%100
		labelText				""
		bgcolor_override		"70 70 70 255"
		visible					0
		paintbackground			1
		proportionalToParent    1
	}

	ToolTip
    {
        ControlName				RuiPanel
        InheritProperties       ToolTip
        zpos                    999
    }

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


    LifetimeAndSeasonalStats
    {
        ControlName         RuiPanel

        xpos                0
        ypos                0

        wide                1700
        tall                850
        rui                 "ui/career_stats_card_v2.rpak"

        pin_to_sibling			PanelFrame
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	TOP_LEFT

        visible 1
    }

    StatsCardToolTipField_Summary_Header
    {
        ControlName				CNestedPanel

        xpos                    -320
        ypos                    -285
        zpos                    10

        wide                    550
        tall                    100

        visible					1
        controlSettingsFile		"resource/ui/menus/panels/stats_tooltip_field.res"

        pin_to_sibling          LifetimeAndSeasonalStats
        pin_corner_to_sibling   CENTER
        pin_to_sibling_corner   CENTER
    }

    StatsCardToolTipField_Summary_LeftCircle
    {
        ControlName				CNestedPanel

        xpos                    -455
        ypos                    50
        zpos                    10

        wide                    275
        tall                    275

        visible					1
        controlSettingsFile		"resource/ui/menus/panels/stats_tooltip_field.res"

        pin_to_sibling          LifetimeAndSeasonalStats
        pin_corner_to_sibling   CENTER
        pin_to_sibling_corner   CENTER
    }

    StatsCardToolTipField_Summary_RightCircle
    {
        ControlName				CNestedPanel

        xpos                    -180
        ypos                    50
        zpos                    10

        wide                    275
        tall                    275

        visible					1
        controlSettingsFile		"resource/ui/menus/panels/stats_tooltip_field.res"

        pin_to_sibling          LifetimeAndSeasonalStats
        pin_corner_to_sibling   CENTER
        pin_to_sibling_corner   CENTER
    }

    StatsCardToolTipField_Summary_ColumnA
    {
        ControlName				CNestedPanel

        xpos                    -455
        ypos                    275
        zpos                    10

        wide                    275
        tall                    125

        visible					1
        controlSettingsFile		"resource/ui/menus/panels/stats_tooltip_field.res"

        pin_to_sibling          LifetimeAndSeasonalStats
        pin_corner_to_sibling   CENTER
        pin_to_sibling_corner   CENTER
    }

    StatsCardToolTipField_Summary_ColumnB
    {
        ControlName				CNestedPanel

        xpos                    -180
        ypos                    275
        zpos                    10

        wide                    275
        tall                    125

        visible					1
        controlSettingsFile		"resource/ui/menus/panels/stats_tooltip_field.res"

        pin_to_sibling          LifetimeAndSeasonalStats
        pin_corner_to_sibling   CENTER
        pin_to_sibling_corner   CENTER
    }


    StatsCardToolTipField_Season_Header
    {
        ControlName				CNestedPanel

        xpos                    320
        ypos                    -285
        zpos                    10

        wide                    550
        tall                    100

        visible					1
        controlSettingsFile		"resource/ui/menus/panels/stats_tooltip_field.res"

        pin_to_sibling          LifetimeAndSeasonalStats
        pin_corner_to_sibling   CENTER
        pin_to_sibling_corner   CENTER
    }

    StatsCardToolTipField_Season_LeftCircle
    {
        ControlName				CNestedPanel

        xpos                    180
        ypos                    50
        zpos                    10

        wide                    275
        tall                    275

        visible					1
        controlSettingsFile		"resource/ui/menus/panels/stats_tooltip_field.res"

        pin_to_sibling          LifetimeAndSeasonalStats
        pin_corner_to_sibling   CENTER
        pin_to_sibling_corner   CENTER
    }

    StatsCardToolTipField_Season_RightCircle
    {
        ControlName				CNestedPanel

        xpos                    455
        ypos                    50
        zpos                    10

        wide                    275
        tall                    275

        visible					1
        controlSettingsFile		"resource/ui/menus/panels/stats_tooltip_field.res"

        pin_to_sibling          LifetimeAndSeasonalStats
        pin_corner_to_sibling   CENTER
        pin_to_sibling_corner   CENTER
    }

    StatsCardToolTipField_Season_ColumnA
    {
        ControlName				CNestedPanel

        xpos                    180
        ypos                    275
        zpos                    10

        wide                    275
        tall                    125

        visible					1
        controlSettingsFile		"resource/ui/menus/panels/stats_tooltip_field.res"

        pin_to_sibling          LifetimeAndSeasonalStats
        pin_corner_to_sibling   CENTER
        pin_to_sibling_corner   CENTER
    }

    StatsCardToolTipField_Season_ColumnB
    {
        ControlName				CNestedPanel

        xpos                    455
        ypos                    275
        zpos                    10

        wide                    275
        tall                    125

        visible					1
        controlSettingsFile		"resource/ui/menus/panels/stats_tooltip_field.res"

        pin_to_sibling          LifetimeAndSeasonalStats
        pin_corner_to_sibling   CENTER
        pin_to_sibling_corner   CENTER
    }
}