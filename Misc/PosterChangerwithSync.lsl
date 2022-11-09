//Synced Poster Changer Script
//Version 22.11.9
//Nomads Galaxy
//In World; Game.Wylder
//This code is licensed CC BY-NC-SA 4.0
//https://creativecommons.org/licenses/by-nc-sa/4.0/

////SCRIPT DESCRIPTION////
/*
    This script is designed to be used alongside a Poster or Billboard.
    It's function is simple, it will sync with the sim's clock and cycle
    through textures within the 'link' list, and when clicked, will provide
    a corresponding URL that is assigned alongside the texture.

    Author's Note; This is optimized for viewing in Visual Studio Code with
    the "LSL Firestorm" extension. It may not look as pretty in other editors.
*/

//List Link
list link = [
"653760a7-c19f-b79d-58b8-7384422530f2","http://discord.furzona.club",
"ff46c3fe-79ad-bf7e-deb3-a013e8debf93","http://www.furzona.club"
];
/*
    The list above is the primary control of the script, determining the
    Texture UUID to apply, and the Text (or URL) to be given. I have loaded
    some Furzona Textures in here as an example.

    To add more textures, simply expand the list from;
    "653760a7-c19f-b79d-58b8-7384422530f2","http://discord.furzona.club",
    "ff46c3fe-79ad-bf7e-deb3-a013e8debf93","http://www.furzona.club"

    To;
    "TEXTURE-UUID","TEXT/LINK",
    "TEXTURE-UUID","TEXT/LINK",
    "TEXTURE-UUID","TEXT/LINK" <- Make sure the final Texture & Text/Link does not have a comma ',' at the end
*/

//User Configurable Gloabl Variables
    //loveyoface - Stay Beautiful, This Integer controls the Face ID that the script will be targeting.
    integer loveyoface = 1;
    //seconds - This integer is how often the texture will change and go to the next one in the cycle
    integer seconds = 60;
    //enabletouch - This boolean controls whether or not the script will respond to touch events.
    integer enabletouch = TRUE;
    //enablecursor - This boolean controls whether or not the cursor will turn into a 'click hand' when the prim is hovered over.
    integer enablecursor = TRUE;
    //touchpretext - This string is the pre-text that will be displayed when the script is touched.
    string touchpretext = "More Info Here: ";
//End User Configurable Global Variables

//Non Configurable Global Variables
    //The script will likely break if you change these.
    //Declare index for use in Timer & Touch events.
    integer index = 0;
    //nsync is used to sync the script with Sim Time, and is better than Backstreet Boys.
    integer nsync; 
    //You may hate me but it aint no lie.
//End Non Configurable Global Variables

//Gloabl Functions
    //GetSec() - Returns the current second of the sim time.
    integer GetSec()
    {
        integer now = (integer)llGetWallclock(); //Get's the time in seconds since Midnight PST
        integer sec = now % 60; //Modulo 60 to get the seconds
        return sec; //Returns the result to the caller
    }
//End Global Functions

default
{
    state_entry() //This is the first thing that happens when the script is loaded.
    {
        llSetTimerEvent(1); //Timer is set to 1 second, this is to sync the script with the sim time.
        if(enabletouch && enablecursor))
        {//This will enable the cursor to change to a 'click hand' when the prim is hovered over.
            llSetClickAction(CLICK_ACTION_TOUCH); 
        }
        else if(enabletouch && !enablecursor)
        {//This will disable the cursor to change to a 'click hand' when the prim is hovered over, but will still respond to clicks.
            llSetClickAction(CLICK_ACTION_NONE); 
        }
        else
        {//This will disable the touch action, and will not respond to clicks. 'touch_start' will not be called.
            llSetClickAction(CLICK_ACTION_DISABLED); 
        }
    }//End state_entry()
    
    touch_start(integer total_number) //This will occur when the object the script is in, is clicked on.
    {//This will "Instant Message" the user that clicked the object, with the corresponding Text/Link from the list.
        llInstantMessage(llDetectedKey(0),touchpretext+llList2String(link,(index+1)));
    }//End touch_start()

    timer() //The timer event is called by llSetTimerEvent() and will occur every interval of seconds set in the 'seconds' variable.
    {
        integer count = llGetListLength(link); //Would likely be better in state_entry, but this is fine. Gets the length of the list.
        if(GetSec() == 0) //If the current second is 0, then we will sync the script with the sim time.
        {
            if(nsync < seconds) //If the nsync variable is less than the seconds variable, then we will set the timer event to the seconds variable.
            {
                nsync = seconds; //Set nsync to seconds
                llSetTimerEvent(nsync); //Set the timer event to the nsync variable.
                llOwnerSay("Synced"); //Informs the Object Owner that the script is synced.
            }
        }
        llSetTexture(llList2Key(link,index),loveyoface); //Sets the texture to the corresponding UUID in the list.
        index = index + 2; //Increments the index by 2, as the list is in the format of "UUID","TEXT/LINK"
        if(index > (count - 1)) //If the index is greater than the length of the list, then we will reset the index to 0.
        {
            index = 0;  //Reset the index to 0.
        }
    }//End timer()
}
