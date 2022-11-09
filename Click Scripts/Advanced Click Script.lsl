/*
=# Welcome! #=
______________
So, scripting can be difficult, and
it also can become very confusing at
times. However, scripting a click
script is probably one of the easiest
scripts to modify/edit. This script
is the more advanced version of my
'Make Your Own Click Scripts'
So I figure you know the basics of
how to write LSL script or at least
modify it. So there won't be alot of
detailed notes, but I will still show
you what is what and what does what.
I reccomend you refer to the LSL Wiki
for more detailed info about scripting.

But anyways, Have Fun!


If you do not know how to modify click
scripts, Please refer to the Simple script.

*/


//When a user clicks the script, this is the first Prompt they are given.
list list_one = ["Menu 1","Menu 2"];
//When a user clicks 'Menu 1', they are given the options below. '<< BACK' returns the user to the Menu Selection.
list list_two = ["Opt 1","Opt 2","<< BACK","Opt 3","Opt 4","Opt 5"];
//When a user clicks 'Menu 2', they are given the options below. '<< BACK' returns the user to the Menu Selection.
list list_three = ["Opt 6","Opt 7","<< BACK","Opt 8","Opt 9","Opt 10"];
//Each list can have a max of 12 options, 11 if you keep the '<< BACK'
key dk;
string owner;
integer lock = FALSE;
//This controls whether or not the script is locked to users.
//This is also toggled by the owner clicking on the script.
integer listn;
integer rand;
integer chan;
integer listen_id;
integer dialogChannel;
integer dialogHandle;

//Global Functions
    //open_menu like this is a secure way to use Dialog menus, as it will close the menu after 30 seconds of no response.
    //Additionally, this is more secure as the listen channel changes every time the menu is opened.
    open_menu(key inputKey, string inputString, list inputList)
    {
        dialogChannel = (integer)llFrand(DEBUG_CHANNEL)*-1;
        dialogHandle = llListen(dialogChannel, "", inputKey, "");
        llDialog(inputKey, inputString, inputList, dialogChannel);
        llSetTimerEvent(30.0);
    }

    close_menu()//This is used to close the menu after 30 seconds
    {
        llSetTimerEvent(0.0);// you can use 0 as well to save memory
        llListenRemove(dialogHandle);
    }
//End Global Functions

default
{
    attach(key n)
    {
        llResetScript();
    }
    
    on_rez(integer n)
    {
        llResetScript();
    }
    state_entry()
    {
        owner = llKey2Name(llGetOwner());
    }

    touch_start(integer total_number)
    {
        dk = llDetectedKey(0);
        if(dk == llGetOwner())
        {//Below controls what happens if the script is locked or not, and if the owner clicks it.
            open_menu(llGetOwner(),"Change lock state,",["lock","unlock"]);//This dialog appears if the owner clicks, to toggle lock.
        }
        else if(lock == FALSE)
        {
            open_menu(dk,"What are your intentions with "+owner+"'s _____?",list_one);
        } else {
            llInstantMessage(dk,"This ______ is locked ");//This appears if the script Is locked.
        }
    }
    
    listen(integer c, string n, key i, string m)
    {
        // script commands
        if(m == "lock")
        {
            lock = TRUE;
            llOwnerSay("Locked");
        }
        if(m == "unlock")
        {
            lock = FALSE;
            llOwnerSay("Unlocked");
        }
        
        //events
        if(m == "Menu 1")
        {
            open_menu(dk,"This Is Menu 1",list_two);//displayes the 2nd list of options
        }
        if(m == "Menu 2")
        {
            open_menu(dk,"This Is Menu 2",list_three);//displayes the 2nd list of options
        }
        if(m == "<< BACK")//Returns user to Menu selection
        {
            open_menu(dk,"This Is The Menu Selection",list_one);//Displays Menu Selection
        }
        if(m == "Opt 1")
        {
            llSay(0, "Text 1");
        }
        if(m == "Opt 2")
        {
            llSay(0,"Text 2");
        }
        if(m == "Opt 3")
        {
            llSay(0,"Text 3");
        }
        if(m == "Opt 4")
        {
            llSay(0,"Text 4");
        }
        if(m == "Opt 5")
        {
            llSay(0," Text 5");
        }
        if(m == "Opt 6")
        {
            llSay(0,"Text 6");
        }
        if(m == "Opt 7")
        {
            llSay(0,"Text 7");
        }
        if(m == "Opt 8")
        {
            llSay(0,"Text 8");
        }
        if(m == "Opt 9")
        {
            llSay(0,"Text 9");
        }
        if(m == "Opt 10")
        {
            llSay(0,"Text 10");
        }
    }

    timer() 
    {
        llInstantMessage(dk, "Sorry, you snooze you lose, try the menu again.");
        close_menu();
    }

}