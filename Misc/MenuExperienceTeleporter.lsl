//Menu Based Experience Teleporter
//Version 22.11.9
//Nomads Galaxy
//In World; Game.Wylder
//This code is licensed CC BY-NC-SA 4.0
//https://creativecommons.org/licenses/by-nc-sa/4.0/

////SCRIPT DESCRIPTION////
/*
    This script will let you teleport to whatever landmark you put in it by selecting it from a menu.

    I barely commented this thing, I really should have, but I was lazy. 
    If you have any questions, feel free to contact me in world.

    Author's Note; This is optimized for viewing in Visual Studio Code with
    the "LSL Firestorm" extension. It may not look as pretty in other editors.
*/

//This script is extremely easy, just plop it into an object, set the script to use "Furzona Experience" - and drop a landmark into the object's inventory.

integer giDebug = FALSE; 

string greeting = "Hello Inhabitant, Please Select a Simulation to Interface With.";

vector gvLookat = <0., 1., 0.>;  //Which direction is the camera looking at - currently is bugged and does not work. Thanks Linden Labs.

vector gvSIM_Global_Coordinates = ZERO_VECTOR;  
vector gvLocal_Coordinates = ZERO_VECTOR; 
vector gvTargetSimCorner = ZERO_VECTOR; 
vector gvRelative_Coordinates = ZERO_VECTOR; 
vector gvCurrentSimGlobal = ZERO_VECTOR; 
key gkLocalCoordinateQuery = NULL_KEY; 
string gsLandMarkName = ""; 
string gsErrorMessage = ""; 
list glDither = [0.5, 0.5, -0.5, -0.5, 0.0, 0.0]; 
list glShuffledList = []; 
integer giInitialized = FALSE; 

list landmarknames = []; //[string,string,string]
list landmarkcoordinates = []; //[vector,vector,vector]
integer lmcount;

integer channel;
key user;
integer pagenum = 1;
list currentpage;
integer selection;
list navigation = ["<-","---","->"];

integer dialogChannel;
integer dialogHandle;

open_menu(key inputKey, string inputString, list inputList)
{
    dialogChannel = (integer)llFrand(DEBUG_CHANNEL)*-1;
    dialogHandle = llListen(dialogChannel, "", inputKey, "");
    llDialog(inputKey, inputString, inputList, dialogChannel);
    llSetTimerEvent(30.0);
}

close_menu()
{
    llSetTimerEvent(0.0);// you can use 0 as well to save memory
    llListenRemove(dialogHandle);
}

default
{
    state_entry()
    {
        llSitTarget(<0.0, 0.0, 0.25>, ZERO_ROTATION);
        llVolumeDetect(FALSE);
        
        gvCurrentSimGlobal = llGetRegionCorner();
                
        lmcount = llGetInventoryNumber(INVENTORY_LANDMARK);

        if(lmcount == 0)
        {
            llOwnerSay("No Landmarks Detected.");
        }
        else
        {
            integer i;
            for(i = 0; i < lmcount; i++)
            {
                landmarknames += [llGetInventoryName(INVENTORY_LANDMARK,i)];
                landmarkcoordinates += [llRequestInventoryData(llGetInventoryName(INVENTORY_LANDMARK,i))];
            }
        }
    }
    
    on_rez(integer start_param) 
    { 
        llResetScript();  
    }
    
    changed( integer change )
    {
        if(change & (CHANGED_OWNER | CHANGED_REGION | CHANGED_INVENTORY))
        {
            llResetScript(); 
        }
        
         if (change & CHANGED_LINK)
         {
             llUnSit ( llAvatarOnSitTarget() );
         }
    }
    
    dataserver(key query_id, string data)
    {
        if (query_id == gkLocalCoordinateQuery)
        {
            gvRelative_Coordinates = (vector)data;
            gvSIM_Global_Coordinates = gvRelative_Coordinates + gvCurrentSimGlobal;
            
            gvTargetSimCorner = 
            <
            256.0 * (float) ( (integer) (gvSIM_Global_Coordinates.x / 256.0)), 
            256.0 * (float) ( (integer) (gvSIM_Global_Coordinates.y / 256.0)), 
            0.0 
            >;
            
            gvLocal_Coordinates = gvSIM_Global_Coordinates - gvTargetSimCorner; 
            if (giDebug)
            {  
                llOwnerSay("gvCurrentSimGlobal:" + (string)gvCurrentSimGlobal);
                llOwnerSay("gvSIM_Global_Coordinates:" + (string)gvSIM_Global_Coordinates);
                llOwnerSay("gvTargetSimCorner:" + (string)gvTargetSimCorner);
                llOwnerSay("gvLocal_Coordinates:" + (string)gvLocal_Coordinates);
            }
            
            llVolumeDetect(TRUE);
            giInitialized = TRUE; 
            llOwnerSay("\nInitialization Successful\n");
        }
        else
        {
            giInitialized = FALSE;
        }
    }
    
    touch_start(integer total_number)
    {
        user = llDetectedKey(0);
        if(lmcount == 0)
        {
            llOwnerSay("No Landmarks Detected.");
        }
        else
        {
            currentpage = navigation + llList2ListStrided(landmarknames, 0, 8, 1);
            open_menu(user,greeting,currentpage);
        }
    }

    listen(integer c, string n, key id, string m)
    {
        if(c != dialogChannel) return;
        close_menu();
        if(m == "<-")
        {
            pagenum--;
            if(pagenum < 1) pagenum = 1;
            currentpage = navigation + llList2ListStrided(landmarknames, (pagenum-1)*8, ((pagenum-1)*8)+8, 1);
            open_menu(user,greeting,currentpage);
        }
        else if(m == "->")
        {
            pagenum++;
            if(pagenum > (integer)llCeil((float)lmcount/8.0)) pagenum = (integer)llCeil((float)lmcount/8.0);
            currentpage = navigation + llList2ListStrided(landmarknames, (pagenum-1)*8, ((pagenum-1)*8)+8, 1);
            open_menu(user,greeting,currentpage);
        }
        else if(m == "---")
        {
            llInstantMessage(user,"Connection Refused. Inhabitant, Please Try Again.");
        }
        else
        {
            selection = llListFindList(landmarknames,[m]);
            gkLocalCoordinateQuery = llRequestInventoryData(llList2String(landmarknames,selection));
            if (giInitialized)
            {
                llRequestExperiencePermissions(user, "");            
                glShuffledList = llListRandomize ( glDither, 1) ; 
            }
        }
    }
    
    /*
    collision_start(integer detected)
    {
        
        if (giInitialized) 
        {
            llRequestExperiencePermissions(llDetectedKey(0), "");
            
            glShuffledList = llListRandomize ( glDither, 1) ; 
        }
         
    }
    */
    
    experience_permissions( key agent_id )
    {
        llTeleportAgentGlobalCoords( agent_id, gvTargetSimCorner,
                                      (<gvLocal_Coordinates.x + llList2Float( glShuffledList, 0 ), 
                                        gvLocal_Coordinates.y + llList2Float( glShuffledList, 1 ), 
                                        gvLocal_Coordinates.z> ),
                                        gvLookat);
    }
    
    experience_permissions_denied( key agent_id, integer reason )
    {
        gsErrorMessage = "Teleport Denied: " + llGetExperienceErrorMessage(reason) + ". ";
        if (reason == 1) gsErrorMessage += "The call failed due to too many recent calls."; 
        else if (reason == 2) gsErrorMessage += "The region currently has experiences disabled."; 
        else if (reason == 3) gsErrorMessage += "One of the string arguments was too big to fit in the key-value store."; 
        else if (reason == 4) gsErrorMessage += "Experience permissions were denied by the user."; 
        else if (reason == 5) gsErrorMessage += "This script is not associated with an experience."; 
        else if (reason == 6) gsErrorMessage += "The sim was unable to verify the validity of the experience. Retrying after a short wait is advised."; 
        else if (reason == 7) gsErrorMessage += "The script is associated with an experience that no longer exists."; 
        else if (reason == 8) gsErrorMessage += "The experience owner has temporarily disabled the experience."; 
        else if (reason == 9) gsErrorMessage += "The experience has been suspended by Linden Lab customer support."; 
        else if (reason == 10) gsErrorMessage += "An unknown error not covered by any of the other predetermined error states."; 
        else if (reason == 11) gsErrorMessage += "An attempt to write data to the key-value store failed due to the data quota being met."; 
        else if (reason == 12) gsErrorMessage += "The key-value store is currently disabled on this region."; 
        else if (reason == 13) gsErrorMessage += "Unable to communicate with the key-value store."; 
        else if (reason == 14) gsErrorMessage += "The requested key does not exist."; 
        else if (reason == 15) gsErrorMessage += "A checked update failed due to an out of date request."; 
        else if (reason == 16) gsErrorMessage += "The content rating of the experience exceeds that of the region."; 
        else if (reason == 17) gsErrorMessage += "The experience is blocked or not enabled for this land."; 
        else if (reason == 18) gsErrorMessage += "The request for experience permissions was ignored."; 

        llSay(PUBLIC_CHANNEL, gsErrorMessage);
        llRegionSayTo( agent_id, PUBLIC_CHANNEL, gsErrorMessage );  
    }

    timer()
    {
        close_menu();
    }
}
