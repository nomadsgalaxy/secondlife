/*
_______________________________________________________________________________________________________
Please Stretch your script window to fit the bar above, this is to keep formatting from being messed up

=# Welcome! #=
________________________
So, scripting can be difficult, and
it also can become very confusing at
times. However, scripting a click
script is probably one of the easiest
scripts to modify/edit. This script
contains detailed notes to help you
write your own custom click script!
It's alot of reading, but it really
helps explain the basics that you 
need to know before going head into
scripts. So, have fun!
________________________

=# Table of Contents #=
________________________
Insert# - Name - Line #
________________________

1 - Adding click options       - Line 35

2 - Setting lock State         - Line 56

3 - Locking & If Statements    - Line 118

4 - Setting your Click Text    - Line 183

5 - Adding/Removing click Text - Line 215
_________________________________________
=# Adding click options to the list #=
______________________________________
These are the options the clicker is given. To add moer Options,
Simply but a comma at the end of the last option so it looks like - "," 
then after the new quotations add the option name, then close it
off with an end quote. It should look somthing like this;

...","Option 6","Option 7"];

You can have up to 12 options with this script, there are 
ways to add more with several pages of text, which I will
save for my 'Advanced Click Script'.
______________________________________
*/

//User Configurable Variables
    //list_one - As Described Above, this is the list of options the clicker is given.
    list list_one = ["Example/Option 1","Option 2","Option 3","Option 4","Option 5","Option 6"];
    //locked - This is the lock state of the script, see below for more info.
    integer locked = FALSE;
    /*
    =# Setting script Lock state #=
    _______________________________
    If you wish to lock the click script, set this to TRUE, 
    FALSE means everyone (including you) can click the script.
    This integer is refered to below at the start of the script.

    The feature for the owner to lock the script by clicking
    the object has been disabled, so new scripters can test
    the script by themselves, this feature will be re-integrated
    in my 'Advanced Click Script'
    _______________________________
    */
//End User Configurable Variables

//Non User Configurable Global Variables
    //This is used to auto generate a name based off your Legacy Name (Username)
    string ownerlegacyname;
    integer dialogChannel;
    integer dialogHandle;
//End Non User Configurable Global Variables



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

integer chan;
default
{
    on_rez(integer n)
    {
        llResetScript();
    }
    
    attach(key a)
    {
        llResetScript();
    }
    
    state_entry()
    {
        ownerlegacyname = llKey2Name(llGetOwner());
    }

    touch_start(integer total_number)
    {/*
    
    =# Locking the Script & IF statements #=
    ________________________________________
    Below is an IF statement, it works like this;
    
    We have the Integer 'lock' which is defined above.
    if 'lock' is set to false, it will perform the action defined.
    
    if(lock == FALSE){ - This check if the integer is set to FALSE
    
    however, if 'lock' isn't false, we use the statement 'else'
    
    } else {
    
    How this part works is simpele, if 'lock' doesnt equal 'FALSE'
    then it will perform the defined action below it.
    
    A more advanced version of this is integrated in 
    'Advanced Click Script' where you
    can change the state of 'lock' by clicking the object.
    
    (This is removed in this script so beginers can easily test their script)
    ________________________________________
    
    */
        if(!locked)
        {//Replace _______ with object name, such as "Tail" or "Wings"
            if(llDetectedKey(0) == llGetOwner())
            {
                list ownermenu = ["Lock"];
                ownermenu = ownermenu + list_one;
                open_menu(llDetectedKey(0),"What would you like to do with your _______ ",ownermenu);
            }
            else
            {
                open_menu(llDetectedKey(0),"What would you like to do with "+ownerlegacyname+"'s _______ ",list_one);
            }
        }
        else
        {
            if(llDetectedKey(0) == llGetOwner())
            {
                list ownermenu = ["Unlock"];
                ownermenu = ownermenu + list_one;
                open_menu(llDetectedKey(0),"What would you like to do with your _______ ",ownermenu);
            }
            else
            {
                llInstantMessage(llDetectedKey(0),"This _______ is locked >.>");
            }
        }
    }
    
    listen(integer c, string n, key i, string m)
    {
        if(m == "Lock")
        {
            locked = TRUE;
            llOwnerSay("Locked");
        }
        if(m == "Unlock")
        {
            locked = FALSE;
            llOwnerSay("Unlocked");
        }/*
        
        =# Setting your Click Text #=
        ________________________________
        If 'Option 1' from the list above is selected, 
        then 'Text 1' is said in local chat. It's important
        that you type this exactly as it's typed in the list
        above, meaning if you put 'Option 1' in the list,
        and 'option 1' in the IF statement, it will not
        work. Because the script is looking for 'Option 1'
        with a capital 'O'.
        
        if(m == "Example/Option 1")
        
        For when typing in the text that will be said in
        local chat, note that "+owner+" will add in the
        name of the owner into the text. Because this is
        your own personal click script, I reccomend you
        don't use this. Just type in your name instead! :D
        
        Now, if you want to put in the name of the clicker
        who selected the option, put in "+n + ", this will
        turn text that looks like;
        
        ""+n + " grabs Jacob's tail." Into
        
        "John Smith grabs Jacob's tail."
        
        llSay(0, "This script belongs to "+ownerlegacyname+", and has been clicked by "+n + ".");
            
        If Jacob Resident owned and clicked this script, it would return;
        "Test Object: This scribt belongs to Jacob Resident, and has been clicked by Jacob Resident."
        ___________________________________
        
        =# Adding/Removing click options #=
        ___________________________________
        
        To add a new click statement, place your cursor here;
        
                {
                    llSay(0, "Text 6");
                } <--
            }
        }
        
        Hit Enter/Return to insert a new line
        
                }
                if(m == "Option 6")
                {
                    llSay(0, "Text 6");
                }
                <--
            }
        }
        
        Now start typing the if statement, that looks like
        'if(m == "Option 7")' Replace Option 7 with what you want.
        
                }
                if(m == "Option 6")
                {
                    llSay(0, "Text 6");
                }
                if(m == "Option 7")<--
            }
        }
        
        Now hit enter/return and insert left bracket ' { '
        
                }
                if(m == "Option 6")
                {
                    llSay(0, "Text 6");
                }
                if(m == "Option 7")
                { <--
            }
        }
        
        Hit enter/return and your cursor should move here
        
                }
                if(m == "Option 6")
                {
                    llSay(0, "Text 6");
                }
                if(m == "Option 7")
                {
                    |<--
            }
        }
        
        Once your cursor is in the new indented line, 
        start typing 'llSay(0, "Text 7");', replace
        Text 7 with what you want.
        
                }
                if(m == "Option 6")
                {
                    llSay(0, "Text 6");
                }
                if(m == "Option 7")
                {
                    llSay(0, "Text7");<--
            }
        }
        
        Hit enter/return to go down to the next line.
        
                }
                if(m == "Option 6")
                {
                    llSay(0, "Text 6");
                }
                if(m == "Option 7")
                {
                    llSay(0, "Text7");
                    <--
            }
        }
        
        Now insert the right bracket ' } ' and your
        cursor will automatically move back an indent.
        
                }
                if(m == "Option 6")
                {
                    llSay(0, "Text 6");
                }
                if(m == "Option 7")
                {
                    llSay(0, "Text7");
                }<--
            }
        }
        
        There you go! You just added a new click option.
        ________________________________________________
        
        */
        if(m == "Example/Option 1")
        {
            llSay(0, "This script belongs to "+ownerlegacyname+", and has been clicked by "+n + ".");
        }
        if(m == "Option 2")
        {
            llSay(0, "Text 2");
        }
        if(m == "Option 3")
        {
            llSay(0, "Text 3");
        }
        if(m == "Option 4")
        {
            llSay(0,"Text 4");
        }
        if(m == "Option 5")
        {
            llSay(0,"Text 5");
        }
        if(m == "Option 6")
        {
            llSay(0,"Text 6");
        }
    }

    timer()
    {//This is the timer that closes the menu after 10 seconds
        close_menu();
    }
}