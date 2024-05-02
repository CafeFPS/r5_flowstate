global function ChatEffects
global function FindChatEffect
global function DEV_PrintAllChatEffects

//CHAT EFFECTS
global struct Chat {

	table<string,string> effects = {
	
		["THUMBSUP"] = "󰉥",
		["SKULL"] = "󰆿",
		["PISTOL"] = "󰉅",
		["ROOK"] = "󰈭",
		["YELLOW_SKULL"] = "󰈫",
		["NO_WEP"] = "󰈝",
		["HEALTHKIT"] = "󰈘",
		["PHOENIX"] = "󰈖",
		["LOCKED"] = "󰈎",
		["EYE"] = "󰇊",
		["FRIEND"] = "󰆾",
		["LAG"] = "󰆼",
		["CONNECTING"] = "󰆺",
		["CELL"] = "󰈚",
		["BATTERY"] = "󰈙",
		["APEX"] = "󰅡",
		["FIVE"] = "󰆗",
		["CIRCLE"] = "󰆉",
		["BLUEPEX"] = "󰅠",
		["WRAITH_BANNER"] = "󰄒",
		["BIG_WHITE_CROWN"] = "󰄈",
		["WHITE_CROWN"] = "󰄇",
		["BLUE_CROWN"] = "󰄄",
		["TREE"] = "󰃻",
		["SUS"] = "󰃴",
		["RED_SQUARE"] = "󰃭"
	}

}

global Chat chat

table <string,string> function ChatEffects()
{
	return chat.effects
}

string function FindChatEffect( string key )
{
	if( key in chat.effects )
	{
		return chat.effects[key]
	}
	
	string query = key.tolower()
	
	foreach( effectKey, chatValue in chat.effects )
	{
		if ( effectKey.tolower() == query )
		{
			return chatValue
		}
	}
	
	return "Not found.";
}

void function DEV_PrintAllChatEffects()
{
	string print_effects = format( "\n\n --- Chat Effects --- \n\n" )
	
	foreach( key, value in chat.effects )
	{
		print_effects += format( "%s \n", key ) 
	}
	
	sqprint( print_effects )
}