global function InitActionBlocksMenu

struct
{
	array<table> actionBlockData
	int currentPage = -1
	array<var> buttons
	var blackBackground
	var descriptionHeader
	var description
	var owner
	var ownerHeader
} file

void function InitActionBlocksMenu()
{
	var menu = GetMenu( "ActionBlocksMenu" )
}
