//Mr. Clean
//Version 22.11.9
//Nomads Galaxy
//In World; Game.Wylder
//This code is licensed CC BY-NC-SA 4.0
//https://creativecommons.org/licenses/by-nc-sa/4.0/

////SCRIPT DESCRIPTION////
/*
    This script will clean any state of a prim and all its linked prims.

    I forget how I aquired this script, but the scripts' creator in SL
    is 4t Resident (4t.mildor). I am uncertain if this is the original
    creator.

    Author's Note; This is optimized for viewing in Visual Studio Code with
    the "LSL Firestorm" extension. It may not look as pretty in other editors.
*/

integer items_contained;
integer l_count;
string  drone;



inject(key linkedprim, string scriptfile)
    {llGiveInventory(linkedprim, scriptfile );}
    
clean()
       {list OBJECTs;
        integer ii;
        integer inventlength=llGetInventoryNumber(INVENTORY_ALL);
        
        for(ii=0;ii < inventlength;ii++)
          {OBJECTs += llGetInventoryName(INVENTORY_ALL, ii);}
          
        for(ii=0;ii < inventlength;ii++) 
           {if (llList2String(OBJECTs,ii)!=llGetScriptName()) 
               {llRemoveInventory(llList2String(OBJECTs,ii));} 
            }
            
        llSetCameraAtOffset( ZERO_VECTOR );
        llSetCameraEyeOffset( ZERO_VECTOR );
        llSetClickAction(CLICK_ACTION_TOUCH);
        llSetTextureAnim( FALSE , ALL_SIDES, 1, 1, 0, 0, 0.0 );
        llSetText("",ZERO_VECTOR,0.0);
        llParticleSystem([]);
        llSetPayPrice(PAY_DEFAULT,[PAY_DEFAULT,PAY_DEFAULT,PAY_DEFAULT,PAY_DEFAULT]);
        llSitTarget(ZERO_VECTOR,ZERO_ROTATION);
        llTargetOmega(ZERO_VECTOR,0.0,0.0);
        llStopSound();
        llStopMoveToTarget();
        llStopLookAt();
        llVolumeDetect(FALSE);
        llCollisionFilter("", NULL_KEY, TRUE);
        llForceMouselook(FALSE);
        llPassCollisions(TRUE);
        llPassTouches(TRUE);
        llRemoveVehicleFlags(-1);
        llSetVehicleType(VEHICLE_TYPE_NONE);
        llSetRemoteScriptAccessPin(0);
        llSetSitText("");
        llSetTouchText("");
        llSetBuoyancy(0.0);
        llSetForceAndTorque(ZERO_VECTOR,ZERO_VECTOR,FALSE) ;
        llSetPrimitiveParams([PRIM_POINT_LIGHT,FALSE,< 1.0,1.0,1.0 >,0.0,10.0,0.75]);
        
        }


default 
{
   state_entry()
    {if(llGetLinkNumber()>1)
        {clean();
        llSay(0,"["+(string)llGetLinkNumber()+".] Linked-Prim is Clean...");
        llRemoveInventory( llGetScriptName() );}
    else
       {drone = llGetScriptName();
        l_count = llGetObjectPrimCount(llGetKey());
        if(l_count==1)
          {clean();
           llSay(0,"The Prim is Clean...");
           llRemoveInventory( llGetScriptName() );}
        else
         {integer i = 0;
          for(i=2;i<=l_count;i++)
              {inject(llGetLinkKey(i),drone);
               llSay(0,"[+] Injecting "+drone+" into ["+(string)i+".] Linked-Prim "+(string)i+" of "+(string)l_count);}
       
          clean();
          llSay(0,"The Root-Prim is Clean... now:\n1.Now take it back in your inventory and rerez it then.");
          llSetObjectName(llGetObjectName()+"rerez-me");
          }
        }
            
    }
            
   on_rez(integer start)
    {if (llGetSubString(llGetObjectName(),-8,-1)=="rerez-me")
       { llSay(0,"\n2. Set all scripts to running in selection to clean all childprims too.\n(rightclick the prim-> select 'edit'. Then in the top of your viewer select 'tools'->select 'set scripts to running in selection.')");
        llSetObjectName(llDeleteSubString(llGetObjectName(),-8,-1));
        llRemoveInventory( llGetScriptName() );}
        llResetScript();
    } 
            
}