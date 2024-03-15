# qb-gym
GYM with skillsystem for QB-Core fw.

## MY EDITS

I changed the Menu to qb-menu
I also added a own table for the skills, so i dont use list/json in my players table (its defeats the purpose of it *~ man1c*)

## ADD TO SHARED.LUA
```
['gym_membership'] 					 = {['name'] = 'gym_membership', 			 	  	  	['label'] = 'Gym membership', 						['weight'] = 0, 		['type'] = 'item', 		['image'] = 'gym_membership.png', 				['unique'] = true, 		['useable'] = true, 	['shouldClose'] = false,   ['combinable'] = nil,   ['description'] = ''},
```
## Screenshots
![Check Status](https://i.imgur.com/tWs8Sow.png)

## Config
```
--------------------------------------------------------
-- Gym                                                --
--------------------------------------------------------

ConfigGym = {}

ConfigGym.UpdateFrequency = 3600 
ConfigGym.DeleteStats = true 

ConfigGym.MmbershipCardPrice = 365

ConfigGym.Skills = {
    ["stamina"] = { 
        ["Current"] = 20, ["RemoveAmount"] = -0.3, ["Stat"] = "MP0_STAMINA" 
    },

    ["strength"] = {
        ["Current"] = 10, ["RemoveAmount"] = -0.3, ["Stat"] = "MP0_STRENGTH"
    },

    ["diving"] = {
        ["Current"] = 0, ["RemoveAmount"] = -0.3, ["Stat"] = "MP0_LUNG_CAPACITY"
    },

    ["shooting"] = {
        ["Current"] = 0, ["RemoveAmount"] = -0.1,["Stat"] = "MP0_SHOOTING_ABILITY"
    },

    ["driving"] = {
        ["Current"] = 0, ["RemoveAmount"] = -0.5, ["Stat"] = "MP0_DRIVING_ABILITY"
    },

    ["wheelie_ability"] = {
        ["Current"] = 0, ["RemoveAmount"] = -0.2, ["Stat"] = "MP0_WHEELIE_ABILITY"
    }
}

ConfigGym.Locations = {
    [1] = {--pull-ups
        coords = vector3(-1200.02, -1571.18, 4.61), heading = 215.53,
        animation = "prop_human_muscle_chin_ups", skill = "resistance", SkillAddQuantity = 1,
        Text3D = "~g~[E]~w~ - Mache Klimmzüge", viewDistance = 2.5,
    },
    [2] = {--arms
        coords = vector3(-1202.9837, -1565.1718, 4.63115), heading = 212.78,
        animation = "world_human_muscle_free_weights", skill = "strength", SkillAddQuantity = 1,
        Text3D = "~g~[E]~w~ - Hebe Hanteln", viewDistance = 2.5,
    },
    [3] = {--pushup
        coords = vector3(-1203.3242, -1570.6184, 4.631155), heading = 212.78,
        animation = "world_human_push_ups", skill = "strength", SkillAddQuantity = 1,
        Text3D = "~g~[E]~w~ - Mache Liegestütze", viewDistance = 2.5,
    },
    [4] = {--yoga
        coords = vector3(-1204.7958, -1560.1906, 4.63115), heading = 212.78,
        animation = "world_human_yoga", skill = "resistance", SkillAddQuantity = 1,
        Text3D = "~g~[E]~w~ - Mache Yoga", viewDistance = 2.5,
    },
    [5] = {--yoga
        coords = vector3(-1221.04, -1545.01, 4.69), heading = 212.78,
        animation = "world_human_yoga", skill = "resistance", SkillAddQuantity = 1,
        Text3D = "~g~[E]~w~ - Mache Yoga", viewDistance = 3.5,
    },
    [6] = {--yoga
        coords = vector3(-1217.09, -1543.43, 4.72), heading = 212.78,
        animation = "world_human_yoga", skill = "resistance", SkillAddQuantity = 1,
        Text3D = "~g~[E]~w~ - Mache Yoga", viewDistance = 3.5,
    },
}
```
