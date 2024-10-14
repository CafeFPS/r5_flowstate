//commands_util.nut																//mkos

global function Commands_AllCommandAliasesContains
global function Commands_GetCommandAliases
global function Commands_GetCommandHandler										
global function Commands_Register

global typedef CommandHandle void functionref( string )

struct CommandData
{
	CommandHandle handle
	array<string> aliases
}

struct 
{
	table<string, CommandData > commandHandlers
	table<string,bool> allCommandAliases
	
} file

void function nullreturn( string tag ) 
{
	#if DEVELOPER
		printw( "No handler for command:", tag )
	#endif
}

CommandHandle function Commands_GetCommandHandler( string tag ) 
{
	if ( tag in file.commandHandlers )
		return file.commandHandlers[ tag ].handle
		
	return nullreturn
}

bool function __CommandExists( string tag ) 
{
	return ( tag in file.commandHandlers )
}

void function Commands_Register( string tag, CommandHandle handlerFunction, array<string> aliases ) 
{
	if ( !__CommandExists( tag ) ) 
	{
		CommandData data 
		
		data.handle = handlerFunction
		data.aliases = aliases
		
		file.commandHandlers[ tag ] <- data	
		file.allCommandAliases[ tag ] <- true
		
		foreach( string alias in aliases )
			file.allCommandAliases[ alias ] <- true
			
		#if DEVELOPER
			printw( "Registered command:", tag, " handler: " + string( handlerFunction ) + "()" )
		#endif
    } 
	else
	{
		#if DEVELOPER
			printw( "Command", "\"" + tag + "\"", "already exists" )
		#endif
	}
}

bool function Commands_AllCommandAliasesContains( string alias )
{
	return ( alias in file.allCommandAliases )
}

array<string> function Commands_GetCommandAliases( string cmd )
{
	if( __CommandExists( cmd ) )
		return file.commandHandlers[ cmd ].aliases
		
	array<string> emptyArray
	return emptyArray
}