//Sim Discord Restert Notifier
//Version 22.11.9
//Nomads Galaxy
//In World; Game.Wylder
//This code is licensed CC BY-NC-SA 4.0
//https://creativecommons.org/licenses/by-nc-sa/4.0/

////SCRIPT DESCRIPTION////
/*
    This script is designed to be used in conjunction with a Discord Server,
    and a Discord Webhook. It will send a message to the designated Discord
    Webhook when the sim restarts, and will also send a message to the owner
    of the prim.

    Author's Note; This is optimized for viewing in Visual Studio Code with
    the "LSL Firestorm" extension. It may not look as pretty in other editors.
*/

////Additoinal Credit////
/*
    Thank you to Anthony Fairport for their original script that this is based on.
*/

//User Configurable Global Variables
    //In-World Related
        //clicktextRestarted - This is the message that will be sent to the user if the sim has restarted.
        string clicktextLastRestart = "The Sim Last Restarted At:";
        //clicktextNoRestart - This is the message that will be sent to the user if the sim has not restarted yet.
        string clicktextNoRestart = "The Sim Has Not Restarted Yet";
    //Discord Related
        //WEBHOOK_URL - This is the webhook URL for the Discord channel you want to post to.
        string WEBHOOK_URL = "enter a valid webhook URL";
        //AVATAR_URL - This is the URL of the avatar you want to use for the webhook.
        string AVATAR_URL = "https://cdn.discordapp.com/embed/avatars/0.png";
        //DISCORD_MSG - This is the message that will be sent to the Discord channel.
        string DISCORD_MSG = "The Sim Is Back Online";
//End User Configurable Global Variables

//Non Configurable Global Variables
    //WEBHOOK_WAIT - This is a boolean value that determines if the script should wait for the webhook to return a response.
    integer WEBHOOK_WAIT = TRUE;
    //REQUEST_KEY - This is the key that is returned from the HTTP request.
    key REQUEST_KEY;
    //LastSimRestart - This is Declaring a String to be used for trackign the last time the sim restarted.
    string LastSimRestart = "";
//End Non Configurable Global Variables

//Gloabl Functions
    //FormatTime will take a UTC timestamp and format it into a more readable format.
    string FormatTime(string sTime)
    {
        list l = llParseString2List(sTime,["T","."],[]); //Splits the input string 'sTime' into a list, using 'T' and '.' as delimiters.
        return llList2String(l,0)+" "+llList2String(l,1)+" UTC"; //Returns the first and second elements of the list, separated by a space.
    }

    //PostToDiscord will send a message to the Discord channel specified in the WEBHOOK_URL variable.
    key PostToDiscord()
    {//Below is the Json data that is sent in the webhook, if you are familiar with Discord webhooks, you can edit this to your liking.
        list json1 = [
            "content", DISCORD_MSG,
            "tts", "false",
            "avatar_url", AVATAR_URL
        ];
        
        //Controls if the script should wait for the webhook to return a response based off the WEBHOOK_WAIT variable.
        string query_string = "";
        if (WEBHOOK_WAIT)
            query_string += "?wait=true";

        //The actual HTTP Webhook request.
        return llHTTPRequest(WEBHOOK_URL + query_string, 
        [ 
            HTTP_METHOD, "POST", 
            HTTP_MIMETYPE, "application/json",
            HTTP_VERIFY_CERT,TRUE,
            HTTP_VERBOSE_THROTTLE, TRUE,
            HTTP_PRAGMA_NO_CACHE, TRUE ], llList2Json(JSON_OBJECT, json1));
            
    }
//End Global Functions

default
{
    //Note: This script does not use State_Entry or State_Exit, as it is not needed for this script.
    touch_start( integer num_detected ) //If the object is touched
    {
        //It will check to see if the sim has restarted yet.
        if ( LastSimRestart == "" )
        {
            //If it hasn't restarted yet, it will let the user know.
            llInstantMessage(llDetectedKey(0),clicktextNoRestart);
        }
        else
        {
            //Otherwise it will IM the user with the last time the sim restarted.
            llInstantMessage(llDetectedKey(0),clicktextLastRestart+" "+LastSimRestart);
        }
    }
    
    changed( integer change ) //This state occurs when a change is detected, such as a Sim Restart.
    {
        if ( change & CHANGED_REGION_START ) //If a change is detected, and the change is caused by a Sim Restart.
        {
            //It will send a message to the owner informing them that the Sim Region has restarted.
            llInstantMessage(llGetOwner(),llGetRegionName()+" has restarted.");
            //It will also update the LastSimRestart variable with the current time.
            LastSimRestart = FormatTime(llGetTimestamp());
            //Finally, it will send a message to the Discord channel specified in the WEBHOOK_URL variable.
            REQUEST_KEY = PostToDiscord();
        }
    }
}