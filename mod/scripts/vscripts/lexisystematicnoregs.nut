global function Lexinoreginit


table<string,int> noregs
array<string> canchangewithclientcommandvar
bool hasloaded = false

array<int> DISALLOWED_COLOURS = [
    0,
    52,
    16,
    18,
    17,
    20,
    23,
    25,
    24,
    59,
    60,
    62,
    61,
    58,
    65,
    95,
    61,
    54,
    92,
    102,
    101,
    232,
    233,
    234,
    235,
    236,
    237,
    238,
    239,
    240,
    57,
    56,
    19,
    91,
    89,
    90,
    88,
    96,
    53
]

void function Lexinoreginit(){
    printt("NOREGGER INITTED")
    if (!NSDoesFileExist("systematicnoregs.json")) {
        table defaultnoregpeople
        defaultnoregpeople["1012640166434"] <- 10 // lexi
        array<string> defaultcanchangewithclientcommand = ["1012640166434","1012982551974","1007839429466"] // lexi, ryu, soda

        NSSaveFile("systematicnoregs.json", printablebetterweee({noreggers = defaultnoregpeople, canchangewithclientcommand = defaultcanchangewithclientcommand})) //LEXI UID SHE SO FAMOUS
        // this would set lexi to have 10% noregs
    }
// "{"+quote+"noreggers"+quote+"{"+quote+"1012640166434"+quote+":10}"+"}"


    void functionref( string ) onFileLoad = void function ( string result ) 
    {
        table data


        if (result == "") {
            data = {}
            // printt("iwqmfoqmfowqmf")
        table defaultnoregpeople
        defaultnoregpeople["1012640166434"] <- 10 // lexi
        array<string> defaultcanchangewithclientcommand = ["1012640166434","1012982551974","1007839429466"] // lexi, ryu, soda

        NSSaveFile("systematicnoregs.json", printablebetterweee({noreggers = defaultnoregpeople, canchangewithclientcommand = defaultcanchangewithclientcommand})) //LEXI UID SHE SO FAMOUS
        // this would set lexi to have 10% noregs
        } else {
            data = DecodeJSON(result)
        }

        if ("noreggers" in data){
        foreach (uid,noregpercent in  expect table(data["noreggers"])) {
            // printt("WIDQNDIWQ"+uid)
            noregs[(expect string(uid))] <- (expect int(noregpercent))
           
        }}
        if ("canchangewithclientcommand" in data){
        foreach (uid in expect array(data["canchangewithclientcommand"])){
            canchangewithclientcommandvar.append(expect string(uid))
        }}

       
    }


         NSLoadFile("systematicnoregs.json", onFileLoad)
        thread sonnytoldmetorenamethisfunction()
        if (!hasloaded){
		AddDamageCallback( "player", noreg )
        AddClientCommandCallback( "changenoregpercent", changenoregpercent )
        AddClientCommandCallback( "reloadconfig", reloadconfig )
        hasloaded = true
        }
         
	
    
}


bool function reloadconfig( entity player, array<string> args )
{
    noregs.clear()
    canchangewithclientcommandvar.clear()
    Lexinoreginit()
    return true
}

void function sonnytoldmetorenamethisfunction(){
    HttpRequest request
    request.method = HttpRequestMethod.GET
    request.url = GetConVarString("systematicnoregsenabled")
    void functionref( HttpRequestResponse ) onSuccess = void function ( HttpRequestResponse response )
		{
           if (!NSIsSuccessHttpCode(response.statusCode)) {
                print("error resolving noregs from remote")
                return
           }
           table data = DecodeJSON(response.body)
              if ("noreggers" in data){
                   foreach (uid,noregpercent in  expect table(data["noreggers"])) {

            noregs[(expect string(uid))] <- (expect int(noregpercent))
           
        }}
                if ("canchangewithclientcommand" in data){
        foreach (uid in expect array(data["canchangewithclientcommand"])){
            canchangewithclientcommandvar.append(expect string(uid))
        }}
        print("Resolved and parsed noregs from remote")

        }
void functionref( HttpRequestFailure ) onFailure = void function ( HttpRequestFailure failure )
		{
			printt("could not resolve noregs from remote")
        }
    NSHttpRequest( request, onSuccess, onFailure )
}

bool function changenoregpercent( entity player, array<string> args )
{
	if(!( canchangewithclientcommandvar.contains(player.GetUID() ))){
        Chat_ServerPrivateMessage(player,"[38;5;219mno perms to change accuracy",false,false)
        return true
    }
    if (args.len() != 2){
        Chat_ServerPrivateMessage(player,"[38;5;219muse the format changenoregpercent UID PERCENT",false,false)
        return true
    }
    Chat_ServerPrivateMessage(player,"[38;5;219mtrying to change noregpercent for [38;5;189m"+ args[0]+ " [38;5;219mto[38;5;189m " + args[1] +"[38;5;219m%",false,false)
	noregs[args[0]] = args[1].tointeger()
    NSSaveFile("systematicnoregs.json", printablebetterweee({noreggers = noregs, canchangewithclientcommand = canchangewithclientcommandvar})) 
    return true
}

void function noreg ( entity titan, var damageInfo )

{

	entity player = DamageInfo_GetAttacker( damageInfo )
    // discordlogsendmessage("" + player.IsPlayer() + titan.IsPlayer() + IsValid( titan ) + IsValid( player ) + (player.GetUID() in noregs) + (RandomInt( 100 ) < noregs[player.GetUID()])  + GetConVarInt("systematicnoregsenabled"))
    if (   player.IsPlayer() && titan.IsPlayer() && IsValid( titan ) && IsValid( player ) && (player.GetUID() in noregs) && (RandomInt( 100 ) < noregs[player.GetUID()])  && GetConVarInt("systematicnoregsenabled"))

	{
		vector velocity = titan.GetVelocity()
		float squared = velocity.x * velocity.x + velocity.y * velocity.y + velocity.z * velocity.z
		// if ( squared > 50000  == 0 )
		// {
        	string reallycounter = ""
			for (int i = 0; i < RandomInt(15)+1; i++){
                int colour = 0
                while (!colour || DISALLOWED_COLOURS.contains(colour)){
					colour = RandomIntRange ( 1, 254 )

                }
				reallycounter += "[38;5;"+colour+"m!"
			}
            if (DamageInfo_GetDamage(damageInfo) > 0 && GetConVarInt("shouldnotifyofnoregs")){
        Chat_ServerPrivateMessage(player,"[110myou noregged"+reallycounter+ "[38;5;249m and missed on [38;5;189m"+ DamageInfo_GetDamage(damageInfo).tointeger() + "[38;5;249m damage!",false,false)
            }
			DamageInfo_SetDamage( damageInfo, 0 )
		// }
		// else if ( squared > 150000 )
		// {

		// 	DamageInfo_SetDamage( damageInfo, 0 )
		// }
	}
    // else{
    //     discordlogsendmessage("you did not noreg")
    // }
}