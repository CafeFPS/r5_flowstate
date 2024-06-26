// Current Support:
// Rows x 10
// Columns x 4 (for the users sake, menus should really never have more than 3

resource/ui/menus/combo_buttons.res
{
    ButtonRow0x0
    {
        ControlName				BaseModHybridButton
        InheritProperties		ComboButtonLarge
        labelText				"ButtonRow0x0"

        tabPosition             1

        pin_to_sibling			ButtonRowAnchor
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	TOP_LEFT

        cursorVelocityModifier  0.5
    }
    ButtonRow0x1
    {
        ControlName				BaseModHybridButton
        InheritProperties		ComboButtonLarge
        labelText				"ButtonRow0x1"

        pin_to_sibling			ButtonRow0x0
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	TOP_RIGHT
    }
    ButtonRow0x2
    {
        ControlName				BaseModHybridButton
        InheritProperties		ComboButtonLarge
        labelText				"ButtonRow0x2"

        pin_to_sibling			ButtonRow0x1
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	TOP_RIGHT
    }
    ButtonRow0x3
    {
        ControlName				BaseModHybridButton
        InheritProperties		ComboButtonLarge
        labelText				"ButtonRow0x3"

        pin_to_sibling			ButtonRow0x2
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	TOP_RIGHT
    }
    TitleRow0
    {
        ControlName				RuiPanel
        rui                     "ui/combo_header_large.rpak"
        InheritProperties       ComboButtonTitleLarge
        labelText				"TitleRow0"

        pin_to_sibling			ButtonRow0x0
    }

    ButtonRow1x0
    {
        ControlName				BaseModHybridButton
        InheritProperties		ComboButtonLarge
        labelText				"ButtonRow1x0"

        pin_to_sibling			ButtonRowAnchor
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	TOP_LEFT
    }
    ButtonRow1x1
    {
        ControlName				BaseModHybridButton
        InheritProperties		ComboButtonLarge
        labelText				"ButtonRow1x1"

        pin_to_sibling			ButtonRow1x0
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	TOP_RIGHT
    }
    ButtonRow1x2
    {
        ControlName				BaseModHybridButton
        InheritProperties		ComboButtonLarge
        labelText				"ButtonRow1x2"

        pin_to_sibling			ButtonRow1x1
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	TOP_RIGHT
    }
    ButtonRow1x3
    {
        ControlName				BaseModHybridButton
        InheritProperties		ComboButtonLarge
        labelText				"ButtonRow1x3"

        pin_to_sibling			ButtonRow1x2
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	TOP_RIGHT
    }
    TitleRow1
    {
        ControlName				RuiPanel
        rui                     "ui/combo_header_large.rpak"
        InheritProperties       ComboButtonTitleLarge
        labelText				"TitleRow1"

        pin_to_sibling			ButtonRow1x0
    }


    ButtonRow2x0
    {
        ControlName				BaseModHybridButton
        InheritProperties		ComboButtonLarge
        labelText				"ButtonRow2x0"

        pin_to_sibling			ButtonRowAnchor
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	TOP_LEFT
    }
    ButtonRow2x1
    {
        ControlName				BaseModHybridButton
        InheritProperties		ComboButtonLarge
        labelText				"ButtonRow2x1"

        pin_to_sibling			ButtonRow2x0
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	TOP_RIGHT
    }
    ButtonRow2x2
    {
        ControlName				BaseModHybridButton
        InheritProperties		ComboButtonLarge
        labelText				"ButtonRow2x2"

        pin_to_sibling			ButtonRow2x1
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	TOP_RIGHT
    }
    ButtonRow2x3
    {
        ControlName				BaseModHybridButton
        InheritProperties		ComboButtonLarge
        labelText				"ButtonRow2x3"

        pin_to_sibling			ButtonRow2x2
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	TOP_RIGHT
    }
    TitleRow2
    {
        ControlName				RuiPanel
        rui                     "ui/combo_header_large.rpak"
        InheritProperties       ComboButtonTitleLarge
        labelText				"TitleRow2"

        pin_to_sibling			ButtonRow2x0
    }


    ButtonRow3x0
    {
        ControlName				BaseModHybridButton
        InheritProperties		ComboButtonLarge
        labelText				"ButtonRow3x0"

        pin_to_sibling			ButtonRowAnchor
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	TOP_LEFT
    }
    ButtonRow3x1
    {
        ControlName				BaseModHybridButton
        InheritProperties		ComboButtonLarge
        labelText				"ButtonRow3x1"

        pin_to_sibling			ButtonRow3x0
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	TOP_RIGHT
    }
    ButtonRow3x2
    {
        ControlName				BaseModHybridButton
        InheritProperties		ComboButtonLarge
        labelText				"ButtonRow3x2"

        pin_to_sibling			ButtonRow3x1
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	TOP_RIGHT
    }
    ButtonRow3x3
    {
        ControlName				BaseModHybridButton
        InheritProperties		ComboButtonLarge
        labelText				"ButtonRow3x3"

        pin_to_sibling			ButtonRow3x2
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	TOP_RIGHT
    }
    TitleRow3
    {
        ControlName				RuiPanel
        rui                     "ui/combo_header_large.rpak"
        InheritProperties       ComboButtonTitleLarge
        labelText				"TitleRow3"

        pin_to_sibling			ButtonRow3x0
    }


    ButtonRow4x0
    {
        ControlName				BaseModHybridButton
        InheritProperties		ComboButtonLarge
        labelText				"ButtonRow4x0"

        pin_to_sibling			ButtonRowAnchor
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	TOP_LEFT
    }
    ButtonRow4x1
    {
        ControlName				BaseModHybridButton
        InheritProperties		ComboButtonLarge
        labelText				"ButtonRow4x1"

        pin_to_sibling			ButtonRow4x0
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	TOP_RIGHT
    }
    ButtonRow4x2
    {
        ControlName				BaseModHybridButton
        InheritProperties		ComboButtonLarge
        labelText				"ButtonRow4x2"

        pin_to_sibling			ButtonRow4x1
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	TOP_RIGHT
    }
    ButtonRow4x3
    {
        ControlName				BaseModHybridButton
        InheritProperties		ComboButtonLarge
        labelText				"ButtonRow4x3"

        pin_to_sibling			ButtonRow4x2
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	TOP_RIGHT
    }
    TitleRow4
    {
        ControlName				RuiPanel
        rui                     "ui/combo_header_large.rpak"
        InheritProperties       ComboButtonTitleLarge
        labelText				"TitleRow4"

        pin_to_sibling			ButtonRow4x0
    }


    ButtonRow5x0
    {
        ControlName				BaseModHybridButton
        InheritProperties		ComboButtonLarge
        labelText				"ButtonRow5x0"

        pin_to_sibling			ButtonRowAnchor
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	TOP_LEFT
    }
    ButtonRow5x1
    {
        ControlName				BaseModHybridButton
        InheritProperties		ComboButtonLarge
        labelText				"ButtonRow5x1"

        pin_to_sibling			ButtonRow5x0
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	TOP_RIGHT
    }
    ButtonRow5x2
    {
        ControlName				BaseModHybridButton
        InheritProperties		ComboButtonLarge
        labelText				"ButtonRow5x2"

        pin_to_sibling			ButtonRow5x1
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	TOP_RIGHT
    }
    ButtonRow5x3
    {
        ControlName				BaseModHybridButton
        InheritProperties		ComboButtonLarge
        labelText				"ButtonRow5x3"

        pin_to_sibling			ButtonRow5x2
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	TOP_RIGHT
    }
    TitleRow5
    {
        ControlName				RuiPanel
        rui                     "ui/combo_header_large.rpak"
        InheritProperties       ComboButtonTitleLarge
        labelText				"TitleRow5"

        pin_to_sibling			ButtonRow5x0
    }


    ButtonRow6x0
    {
        ControlName				BaseModHybridButton
        InheritProperties		ComboButtonLarge
        labelText				"ButtonRow6x0"

        pin_to_sibling			ButtonRowAnchor
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	TOP_LEFT
    }
    ButtonRow6x1
    {
        ControlName				BaseModHybridButton
        InheritProperties		ComboButtonLarge
        labelText				"ButtonRow6x1"

        pin_to_sibling			ButtonRow6x0
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	TOP_RIGHT
    }
    ButtonRow6x2
    {
        ControlName				BaseModHybridButton
        InheritProperties		ComboButtonLarge
        labelText				"ButtonRow6x2"

        pin_to_sibling			ButtonRow6x1
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	TOP_RIGHT
    }
    ButtonRow6x3
    {
        ControlName				BaseModHybridButton
        InheritProperties		ComboButtonLarge
        labelText				"ButtonRow6x3"

        pin_to_sibling			ButtonRow6x2
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	TOP_RIGHT
    }
    TitleRow6
    {
        ControlName				RuiPanel
        rui                     "ui/combo_header_large.rpak"
        InheritProperties       ComboButtonTitleLarge
        labelText				"TitleRow6"

        pin_to_sibling			ButtonRow6x0
    }


    ButtonRow7x0
    {
        ControlName				BaseModHybridButton
        InheritProperties		ComboButtonLarge
        labelText				"ButtonRow7x0"

        pin_to_sibling			ButtonRowAnchor
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	TOP_LEFT
    }
    ButtonRow7x1
    {
        ControlName				BaseModHybridButton
        InheritProperties		ComboButtonLarge
        labelText				"ButtonRow7x1"

        pin_to_sibling			ButtonRow7x0
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	TOP_RIGHT
    }
    ButtonRow7x2
    {
        ControlName				BaseModHybridButton
        InheritProperties		ComboButtonLarge
        labelText				"ButtonRow7x2"

        pin_to_sibling			ButtonRow7x1
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	TOP_RIGHT
    }
    ButtonRow7x3
    {
        ControlName				BaseModHybridButton
        InheritProperties		ComboButtonLarge
        labelText				"ButtonRow7x3"

        pin_to_sibling			ButtonRow7x2
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	TOP_RIGHT
    }
    TitleRow7
    {
        ControlName				RuiPanel
        rui                     "ui/combo_header_large.rpak"
        InheritProperties       ComboButtonTitleLarge
        labelText				"TitleRow7"

        pin_to_sibling			ButtonRow7x0
    }


    ButtonRow8x0
    {
        ControlName				BaseModHybridButton
        InheritProperties		ComboButtonLarge
        labelText				"ButtonRow8x0"

        pin_to_sibling			ButtonRowAnchor
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	TOP_LEFT
    }
    ButtonRow8x1
    {
        ControlName				BaseModHybridButton
        InheritProperties		ComboButtonLarge
        labelText				"ButtonRow8x1"

        pin_to_sibling			ButtonRow8x0
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	TOP_RIGHT
    }
    ButtonRow8x2
    {
        ControlName				BaseModHybridButton
        InheritProperties		ComboButtonLarge
        labelText				"ButtonRow8x2"

        pin_to_sibling			ButtonRow8x1
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	TOP_RIGHT
    }
    ButtonRow8x3
    {
        ControlName				BaseModHybridButton
        InheritProperties		ComboButtonLarge
        labelText				"ButtonRow8x3"

        pin_to_sibling			ButtonRow8x2
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	TOP_RIGHT
    }
    TitleRow8
    {
        ControlName				RuiPanel
        rui                     "ui/combo_header_large.rpak"
        InheritProperties       ComboButtonTitleLarge
        labelText				"TitleRow8"

        pin_to_sibling			ButtonRow8x0
    }


    ButtonRow9x0
    {
        ControlName				BaseModHybridButton
        InheritProperties		ComboButtonLarge
        labelText				"ButtonRow9x0"

        pin_to_sibling			ButtonRowAnchor
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	TOP_LEFT
    }
    ButtonRow9x1
    {
        ControlName				BaseModHybridButton
        InheritProperties		ComboButtonLarge
        labelText				"ButtonRow9x1"

        pin_to_sibling			ButtonRow9x0
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	TOP_RIGHT
    }
    ButtonRow9x2
    {
        ControlName				BaseModHybridButton
        InheritProperties		ComboButtonLarge
        labelText				"ButtonRow9x2"

        pin_to_sibling			ButtonRow9x1
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	TOP_RIGHT
    }
    ButtonRow9x3
    {
        ControlName				BaseModHybridButton
        InheritProperties		ComboButtonLarge
        labelText				"ButtonRow9x3"

        pin_to_sibling			ButtonRow9x2
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	TOP_RIGHT
    }
    TitleRow9
    {
        ControlName				RuiPanel
        rui                     "ui/combo_header_large.rpak"
        InheritProperties       ComboButtonTitleLarge
        labelText				"TitleRow9"

        pin_to_sibling			ButtonRow9x0
    }
}
