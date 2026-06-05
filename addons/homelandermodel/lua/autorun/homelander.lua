player_manager.AddValidModel("The Boys - Homelander", "models/bread/cod/characters/the_boys/homelander.mdl")
player_manager.AddValidHands("The Boys - Homelander", "models/breadarms/weapons/homelander_viewmodel.mdl", 0, "0")

list.Set("NPC", "homelander_f", {
	Name = "Homelander (Friendly)",
	Class = "npc_citizen",
	Model = "models/bread/cod/characters/the_boys/npc/homelander_f.mdl",
	KeyValues = {citizentype = 4},
	Category = "The Boys"
})

list.Set("NPC", "homelander_h", {
	Name = "Homelander (Hostile)",
	Class = "npc_combine_s",
	Model = "models/bread/cod/characters/the_boys/npc/homelander_h.mdl",
	Weapons = {"weapon_smg1", "weapon_ar2"},
	Numgrenades = "4",
	Category = "The Boys"
})