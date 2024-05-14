"resource/ui/menus/panels/store.res"
{
	PanelFrame
	{
		ControlName				Label
		xpos					0
		ypos					0
		wide					%100
		tall					%100
		labelText				""
	    bgcolor_override		"70 30 30 255"
		visible					0
		paintbackground			1
		proportionalToParent    1
	}

    TabsCommon
    {
        ControlName				CNestedPanel
        classname				"TabsCommonClass"
        zpos					1
        wide					f0
        tall					60
        visible					1
        controlSettingsFile		"resource/ui/menus/panels/tabs_store.res"

        pin_to_sibling			PanelFrame
        pin_corner_to_sibling	TOP
        pin_to_sibling_corner	TOP
    }

    BusyPanel
    {
        ControlName				RuiPanel
        rui                     "ui/store_busy.rpak"
        ypos					-64
        wide					1728
        tall					864
        visible					0
        zpos                    10

        pin_to_sibling			PanelFrame
        pin_corner_to_sibling	TOP
        pin_to_sibling_corner	TOP
    }

    CollectionEventPanel
    {
        ControlName				CNestedPanel
        ypos					-64
        wide					%100
        tall					864
        visible					0
        tabPosition             1
        controlSettingsFile		"resource/ui/menus/panels/store_collection_event.res"
		proportionalToParent    1

        pin_to_sibling			PanelFrame
        pin_corner_to_sibling	TOP
        pin_to_sibling_corner	TOP
    }

    //SpecialCurrencyShopPanel
    //{
    //    ControlName				CNestedPanel
    //    ypos					-64
    //    wide					%100
    //    tall					864
    //    visible					0
    //    tabPosition             1
    //    controlSettingsFile		"resource/ui/menus/panels/store_special_currency_shop.res"
    //	proportionalToParent    1
    //
    //    pin_to_sibling			PanelFrame
    //    pin_corner_to_sibling	TOP
    //    pin_to_sibling_corner	TOP
    //}

	ThemedShopPanel
    {
        ControlName				CNestedPanel
        ypos					-64
        wide					%100
        tall					904
        visible					0
        tabPosition             1
        controlSettingsFile		"resource/ui/menus/panels/store_themed_shop_event.res"
		proportionalToParent    1

        pin_to_sibling			PanelFrame
        pin_corner_to_sibling	TOP
        pin_to_sibling_corner	TOP
    }

    ECPanel
    {
        ControlName				CNestedPanel
        ypos					-64
        wide					1728
        tall					864
        visible					0
        tabPosition             1
        controlSettingsFile		"resource/ui/menus/panels/store_ec.res"
		proportionalToParent    1

        pin_to_sibling			PanelFrame
        pin_corner_to_sibling	TOP
        pin_to_sibling_corner	TOP
    }

    LootPanel
    {
        ControlName				CNestedPanel
        ypos					-64
        wide					1728
        tall					%100
        visible					0
        tabPosition             1
        proportionalToParent    1
        controlSettingsFile		"resource/ui/menus/panels/store_loot.res"
		proportionalToParent    1

        pin_to_sibling			PanelFrame
        pin_corner_to_sibling	TOP
        pin_to_sibling_corner	TOP
    }

    CharacterPanel
    {
        ControlName				CNestedPanel
        ypos					-64
        wide					1728
        tall					%100
        visible					0
        tabPosition             1
        controlSettingsFile		"resource/ui/menus/panels/store_characters.res"
		proportionalToParent    1

        pin_to_sibling			PanelFrame
        pin_corner_to_sibling	TOP
        pin_to_sibling_corner	TOP
    }

    VCPanel
    {
        ControlName				CNestedPanel
        ypos					-64
        wide					1728
        tall					%100
        visible					0
        tabPosition             1
        controlSettingsFile		"resource/ui/menus/panels/store_vc.res"
		proportionalToParent    1

        pin_to_sibling			PanelFrame
        pin_corner_to_sibling	TOP
        pin_to_sibling_corner	TOP
    }
}