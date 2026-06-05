player_manager.AddValidModel( "The Boys - Black Noir", "models/arty/codmw2022/mp/noncanon/theboys/blacknoir/blacknoir_pm.mdl" )
player_manager.AddValidModel( "The Boys - Black Noir - ARC9", "models/arty/codmw2022/mp/noncanon/theboys/blacknoir/blacknoir - arc9_pm.mdl" )

player_manager.AddValidHands( "The Boys - Black Noir", "models/arty/codmw2022/mp/noncanon/theboys/blacknoir_vm.mdl", 0, "00" )
player_manager.AddValidHands( "The Boys - Black Noir - ARC9", "models/arty/codmw2022/mp/noncanon/theboys/blacknoir_vm.mdl", 0, "00" )

local Category = "The Boys" 

local NPC = {   Name = "Black Noir (Hostile)", 
                Class = "npc_combine_s",
                Model = "models/arty/codmw2022/mp/noncanon/theboys/blacknoir/blacknoir_hostile.mdl", 
                Health = "500", 
                Weapons = {"weapon_shotgun","weapon_smg1","weapon_ar2"}, 
                Category = Category }
                               
list.Set( "NPC", "blacknoir_hostile", NPC )

local NPC = {   Name = "Black Noir (Friendly)", 
                Class = "npc_citizen",
                Model = "models/arty/codmw2022/mp/noncanon/theboys/blacknoir/blacknoir_friendly.mdl", 
                Health = "500", 
                KeyValues = { citizentype = 4 }, 
                Weapons = {"weapon_shotgun","weapon_smg1","weapon_ar2"}, 
                Category = Category }
                               
list.Set( "NPC", "blacknoir_friendly", NPC )
