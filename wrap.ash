import <dizzyj_mayam.ash>;
import "clanlib.ash"
###
# Try to ascertain current state.
#
# 1. New day - Garbo1 hasn't run yet, we have not ascended
#    a. ascensionsToday = 0
#    b. _garboCompleted = ''
#    c. kingLiberated = true
# 2. Garbo1 has started, but hasn't finished. we have not ascended
#    a. ascensionsToday = 0
#    b. _garboCompleted = ''
#    c. kingLiberated = true
# 3. Garbo has completed, we have not ascended
#    a. ascensionsToday = 0
#    b. _garboCompleted = 'garbo'
#    c. kingLiberated = true
# 4. We have ascended, but we have not completed ascension. (not in aftercore)
#    a. ascensionsToday = 1
#    b. _garboCompleted = ''
#    c. kingLiberated = false
# 5. We have ascended and have completed it, but we have not started 2nd garbo
#    a. ascensionsToday = 1
#    b. _garboCompleted = ''
#    c. kingLiberated = true
# 6. We have ascended. 2nd garbo has started, but hasn't finished
#    a. ascensionsToday = 1
#    b. _garboCompleted = ''
#    c. kingLiberated = true
# 7. Asenscion complete, 2nd garbo complete
#    a. ascensionsToday = 1
#    b. _garboCompleted = 'garbo'
#    c. kingLiberated = true


###
# Overall process:
#
# 1. Breakfast
# 2. Mayam
#    a. Yamtility Belt - Yam, Meat, Eyepatch, Yam
#    b. Stuffed Yam Stinkbomb - Vessel, Yam, Cheese Explosion
#    c. Nothing - Chair, Bottle, Yam, Clock
#     mayam resonance Yamtility Belt;
#     mayam resonance Stuffed Yam Stinkbomb;
#     mayam rings chair bottle yam clock;
# 3. Garbo
# 4. Pre-ascension Prep
#    a. acquire Legend food
#    b. acquire Borrowed time
#    c. acquire ice house
#    d. familiar stooper
#    e. Drink stillsuit distillate
#    f. ice house skeleton
#        i. if Novelty Tropical, kill and fight again
#        ii. if not Novelty Tropical, ice house
#    g. use rest of advs in Barf Mountain
#    h. harvest garden
# 5. Ascend
#    - Astral Six-Pack
#    - Astral Mask (Or sweater if available)
#    a. Normal
#    b. Sauceror
#    c. Community Service
#    d. Opossum
# 6. Run instantsccs
# 7. Mayam
#    a. Yamtility Belt - Yam, Meat, Eyepatch, Yam
#    b. Stuffed Yam Stinkbomb - Vessel, Yam, Cheese Explosion
#    c. Nothing - Chair, Bottle, Yam, Clock
# 8. Garbo

###
# Prefs to check
#
# ascensionsToday - have we ascended? (0 or 1)
# _garboCompleted - garbo if so, blank if not I think
# kingLiberated   - true / false?

######
# Flags?
######
boolean clan_meat_stack = true;
int clan_meat_stack_amount = 5000;

#####
# Custom Flags
#####
boolean do_the_pvp = true;
boolean pvp_done = false;
string last_pvp = "";

#####
# Custom vars
int dizzyj_meteoriteAdesToUse = 0;
string[int] dizzyj_mayam_ringOne = { "chair", "eye", "yam1", "sword", "vessel", "fur" };
string[int] dizzyj_mayam_ringTwo = { "yam2", "lightning", "bottle", "wood", "meat" };
string[int] dizzyj_mayam_ringThree = { "yam3", "eyepatch", "cheese", "wall" };

#####
######
# Useful Functions
######


void manageDisplayCase() {

    foreach thing in $items[
                            AutumnFest ale,
                            autumn leaf,
                            autumn-spice donut,
                            autumn years wisdom,
                            bag of gross foreign snacks,
                            bag of park garbage,
                            bottle of gin,
                            bottle of rum,
                            bottle of tequila,
                            bottle of vodka,
                            bottle of whiskey,
                            snifter of thoroughly aged brandy,
                            bowl of cottage cheese,
                            commemorative war stein,
                            expensive camera,
                            fat stacks of cash,
                            Gathered Meat-Clip,
                            grue egg,
                            hot buttered roll,
                            stuffed astral badger,
                            stuffed baby gravy fairy,
                            stuffed Baron von Ratsworth,
                            stuffed Cheshire bitten,
                            stuffed cocoabo,
                            stuffed flaming gravy fairy,
                            stuffed frozen gravy fairy,
                            stuffed hand turkey,
                            stuffed key,
                            stuffed MagiMechTech MicroMechaMech,
                            stuffed Meat,
                            stuffed mind flayer,
                            stuffed monocle,
                            stuffed scary death orb,
                            stuffed sleazy gravy fairy,
                            stuffed snowy owl,
                            stuffed spooky gravy fairy,
                            stuffed stinky gravy fairy,
                            stuffed teddy butler,
                            stuffed tin of caviar,
                            stuffed treasure chest,
                            stuffed undead elbow macaroni,
                            stuffed mink,
                            meat stack,
                            asbestos ore,
                            bubblewrap ore,
                            cardboard ore,
                            linoleum ore,
                            styrofoam ore,
                            teflon ore,
                            velcro ore,
                            vinyl ore,
                            heart necklace,
                            spade necklace,
                            club necklace,
                            diamond necklace,
                            rubber WWBD? bracelet,
                            rubber WWJD? bracelet,
                            rubber WWSPD? bracelet,
                            rubber WWtNSD? bracelet,
                            d10,
                            stuffed yam stinkbomb,
                            toast
                            ] {
      string strthing = to_string(thing);
      int amountof = item_amount(thing);
      if (amountof < 1) {
        print("We don't have any "+strthing+" to put in the DC!", "green");
      } else {
        print("We have "+to_string(item_amount(thing))+" "+thing+". Placing in DC","blue");
        put_display(item_amount(thing), thing);
      }
    }
}

void pvpEnable()
{
        if(!hippy_stone_broken())
        {
                visit_url("peevpee.php?action=smashstone&pwd&confirm=on&shatter=Smash+that+Hippy+Crap%21");     //break hippy stone
                visit_url("peevpee.php?action=pledge&place=fight&pwd");                                                                   //pledge allegiance
        }
}

void sendPeril(){
    cl_clannie[int] clannies = get_clannies();
    string title;
    string name;
    string rank;

    cl_clannie[int] potentially_perilable_clannies;
    int cur = 0;
    foreach id, clannie in clannies{
        if(clannie.is_active){
            potentially_perilable_clannies[cur] = clannie;
            cur += 1;
        }
    }

    int num_potentially_perilable_clannies = count(potentially_perilable_clannies);

    # Don't care if they're perilable.. just keep periling until we get to 3 perilsForeseen
    while (get_property("_perilsForeseen").to_int() < 3){
        cl_clannie pclannie = potentially_perilable_clannies[random(num_potentially_perilable_clannies)];
        visit_url("inventory.php?action=foresee");
        visit_url("choice.php?whichchoice=1558&option=1&who="+to_string(pclannie.id));
        print("Tried to peril "+to_string(pclannie));
    }

    print("Perils done: "+to_string(get_property("_perilsForeseen"))+". Exiting Peridot.", "blue");

}

void checkPvPStatus(){

    ## Check if Mayam explosion has been used.
    ##   Should always be used every day. If we haven't used it that's 5 more fites - we should try to use it.
    ##   Since PVP is usually end-of-day, we likely don't care about other mayam rings, but maybe put some logic in for preferences
    if (! get_property("_mayamSymbolsUsed").contains_text("explosion")) {
        string ring1 = randomMayam(1);
        string ring2 = randomMayam(2);
        string ring3 = randomMayam(3);
        cli_execute("mayam rings "+ring1+" "+ring2+" "+ring3+" "+"explosion");
        pvp_done = false;
    }

    ## Check if meteorite-ades have been used: _meteoriteAdesUsed
    ##   If value < 3 then we need to use (3-value)
    int dizzyj_meteoriteAdesToUse = (3 - to_int(get_property("_meteoriteAdesUsed")));

    ## Check if we have any any fites remaining.
    ##   If so, we need to set pvp_done=false
    if ( dizzyj_meteoriteAdesToUse > 0 ) {
        pvp_done = false;
    }

    last_pvp = to_string(get_property("last_pvp"));

    if (last_pvp != (now_to_string("yyyyMMdd")) ) {
        ### Means either its not set, or probably just set to the day Before...
        print("Last PVP: "+to_string(last_pvp));
        pvp_done=false;
    }

    set_property("pvp_done",pvp_done);


}

void pvpstuff() {
    checkPvPStatus();
    if ( do_the_pvp ) {
        print("Doing the pvp");
        pvpEnable();
        # If breakfastCompleted
        cli_execute("breakfast");

        pvp_done = to_boolean(get_property("pvp_done"));
        if ( ! pvp_done ) {

            foreach thing in $items[meteorite-ade] {
                retrieve_item(3, thing);
            }
            use($item[meteorite-ade], 3);
            cli_execute("scripts/_custom/move_valuables_to_closet.ash");
            cli_execute("scripts/UberPvPOptimizer.ash");

            cli_execute("swagger");

            set_property("pvp_done","true");
            set_property("last_pvp",now_to_string("yyyyMMdd"));
        }

    }
}


string iceHouseMonster() {
    visit_url("museum.php?action=icehouse");
    if (!get_property("banishedMonsters").contains_text("ice house")) {
        return $monster[none];
    } else {
        string [int] banishMap = split_string(get_property("banishedMonsters"), ":");
        for (int i = 0; i < count(banishMap); i++) {
            if (banishMap[i] == "ice house") {
                return to_monster(banishMap[i-1]);
            }
        }
    }
    return $monster[none];
}

void breakfast() {
    print("\nStarting Breakfast!","blue");
    cli_execute("breakfast");
    if (!(to_boolean(get_property("_pirateBellowUsed")))){
        use_skill(1, $skill[Pirate bellow]);
    }
    visit_url("shop.php?whichshop=september");
    sendPeril();

}

void dinner() {
    ## Clan meat stack donation
    if ( clan_meat_stack ) {
        retrieve_item(clan_meat_stack_amount, $item[meat stack]);
        put_stash(clan_meat_stack_amount, $item[meat stack]);
    }
}

void useMayamCalendar() {
    print("\nUsing Mayam Calendar!","blue");
    int mayamCount = get_property("_mayamSymbolsUsed").split_string(",").count();

    if (mayamCount < 4) {
        cli_execute("mayam resonance Yamtility Belt");
        cli_execute("mayam resonance Stuffed Yam Stinkbomb");
        cli_execute("mayam rings chair bottle yam clock");
    }
}

void callGarbo() {
    print("\nGARBO TIME!","blue");
    cli_execute("garbo");
}

void prepInstancSCCS() {
    set_property("_instant_skipCalzoneOfLegend", "true");
    set_property("_instant_skipPizzaOfLegend", "true");
    set_property("_instant_skipDeepDishOfLegend", "true");
    set_property("instant_explicitlyExcludedBuffs","2806,2899,2742,2738,2736,2735,2729,2741");
}

void prepAscend() {
    ## Obtain things I need
    print("\nAscension Prep!","blue");
    print("\n    Acquiring Essentials","green");
    foreach thing in $items[Calzone of Legend, Deep Dish of Legend, Pizza of Legend, borrowed time, ice house] {
      retrieve_item(1, thing);
    }

    foreach thing in $items[baked veggie ricotta casserole,
                            plain calzone,
                            roasted vegetable focaccia,
                            Pete's rich ricotta,
                            roasted vegetable of Jarlsberg,
                            Boris's bread
                            ] {
      retrieve_item(3, thing);
    }



    if (get_property("_dizzy_last_stooper") != (now_to_string("yyyyMMdd")) ) {
        ### Means either its not set, or probably just set to the day Before...
        print("Last stooper: "+to_string(get_property("_dizzy_last_stooper")));
        set_property("_dizzy_stooper_drink","false");
        set_property("_dizzy_stooper_adv","false");
    }

    print("\nChecking stooper","green");

    ### If we haven't drunk stooper yet
    if ( ! to_boolean( get_property("_dizzy_stooper_drink") ) ) {
        print("\nStooper hasn't been drunk today.. Drinking");

        ## Switch to stooper
        use_familiar($familiar[stooper]);

        ## Drink distillate for advs
        cli_execute("drink stillsuit distillate");
        set_property("_dizzy_stooper_drink","true");

    }

    ## Set choice for Skeleton Store NC, and adventure in Skeleton store
    set_property("choiceAdventure1060","1");

    ##
    string mon1 = to_lower_case("factory-irregular skeleton");
    string mon2 = to_lower_case("remaindered skeleton");
    string mon3 = to_lower_case("swarm of skulls");

    print("\n    Ice House Monster: "+iceHouseMonster(),"green");

    ### If we haven't adventured with stooper yet AND we have adventures
    if ( ! to_boolean( get_property("_dizzy_stooper_adv") ) && my_adventures() > 0) {
        print("\nStooper advs not used today, and we have more than 0 adventures.");
        while ( iceHouseMonster() != mon1 && iceHouseMonster() != mon2 && iceHouseMonster() != mon3) {
            print("\n    Adventuring to get correct Ice House Monster","green");
            adv1(to_location(439), 1, "if monsterid 1746 attack; repeat; endif; use ice house;");
        }
        ## By now we should have an ice housed skeleton
        print("\n    Ice House Monster: "+iceHouseMonster(),"green");

        print("\n    Using remaining advs in Barf Mountain","green");
        while ( my_adventures() > 0 ){
            adv1(to_location(442), 1, "attack; repeat");
        }

        set_property("_dizzy_stooper_adv", "true");
        set_property("_dizzy_last_stooper", now_to_string("yyyyMMdd"));
    }

    print("\n    Picking Garden","green");
    cli_execute("garden pick");

    print("\n    Spending Sept-Embers", "green");
    buy($coinmaster[Sept-Ember Censer], 3, $item[Mmm-brr! brand mouthwash]);
    buy($coinmaster[Sept-Ember Censer], 1, $item[wheel of camembert]);


}

boolean ascended = false;
if(to_int(get_property('ascensionsToday')) > 0) {
    ascended = true;
}
boolean garboed = false;
if(get_property('_garboCompleted') == 'garbo') {
    garboed = true;
}
boolean aftercore = to_boolean(get_property('kingLiberated'));

#foreach item in $items[Calzone of Legend, Deep Dish of Legend, Pizza of Legend] {
#  retrieve_item(1, legend);
#}


if ( ascended ) {
    print("We've ascended");
} else {
    print("We still need to ascend today");
}
if ( garboed ) {
    print("We've garboed");
} else {
    print("We have not garboed yet today for this ascension");
}
if ( aftercore ) {
    print("We've completed this run");
} else {
    print("We have not completed this run yet");
}

print("\n========\n");
print("Ice House Monster: "+iceHouseMonster());
print("\n========\n");
boolean case1 = false;
boolean case2 = false;
boolean case3 = false;
boolean case4 = false;
boolean case5 = false;
boolean case7 = false;
string casenum = '1';

#cli_execute("git update");
# Case 1
if ( (!ascended) && (!garboed) && (aftercore) ) {
    case1 = true;
    casenum = '1';
}

# Case 2
if ( (!ascended) && (!garboed) && (!aftercore) ) {
    case2 = true;
    casenum = '2';
}
# Case 3
if ( (!ascended) && (garboed) && (aftercore) ) {
    case3 = true;
    casenum = '3';
}

# Case 4
if ( (ascended) && (!garboed) && (!aftercore) ) {
    case4 = true;
    casenum = '4';
}

# Case 5
if ( (ascended) && (!garboed) && (aftercore) ) {
    case5 = true;
    casenum = '5';
}

# Case 7
if ( (ascended) && (garboed) && (aftercore) ) {
    case7 = true;
    casenum = '7';
}


switch ( casenum ) {
    case "1":
        print("We need to run garbo, prep-ascend, ascend, run instantsccs, and run garbo");
        pvpEnable();


        breakfast();
        useMayamCalendar();
        callGarbo();
        pvpstuff();
        prepAscend();

        break;
    case "2":
        # Looks to be same actions as case 4 but this doesn't see an ascension done yesterday
        # We got here initially by doing first leg yesterday, ascending, but never kicking off 2nd leg
        # and waiting until after RO to finish

        print("We haven't garboed or ascended, but we aren't in aftercore. I think we need to finish the current run...");
        wait(10);

        cli_execute("instantsccs");
        breakfast();
        useMayamCalendar();
        callGarbo();
        pvpstuff();
        manageDisplayCase();
        dinner();
        cli_execute("scripts/_custom/garbo_nightcap_improved.ash");

        break;
    case "3":
        print("We need to prep-ascend, ascend, run instantsccs and run garbo");
        pvpstuff();
        prepAscend();

        break;
    case "4":
        print("We need to complete our run of instantsccs and run garbo");


        prepInstancSCCS();
        cli_execute("instantsccs");
        pvpEnable();
        breakfast();
        useMayamCalendar();
        callGarbo();
        pvpstuff();
        manageDisplayCase();
        dinner();
        cli_execute("scripts/_custom/garbo_nightcap_improved.ash");

        break;
    case "5":
        print("We need to run garbo");
        pvpEnable();
        breakfast();
        useMayamCalendar();
        callGarbo();
        pvpstuff();
        manageDisplayCase();
        dinner();
        cli_execute("scripts/_custom/garbo_nightcap_improved.ash");

        break;
    case "7":
        pvpstuff();
        manageDisplayCase();
        dinner();
        print("We are done for the day");

        cli_execute("scripts/_custom/garbo_nightcap_improved.ash");

        break;
}
