local recipes = {
	-- WOOD SECTION WOOD SECTION WOOD SECTION 
	OakPlanks = {
		"OakLog",nil,nil,
		nil,nil,nil,
		nil,nil,nil,
		4
	},
	CraftingTable = {
		"OakPlanks","OakPlanks",nil,
		"OakPlanks","OakPlanks",nil,
		nil,nil,nil
	},
	Stick = {
		"OakPlanks",nil,nil,
		"OakPlanks",nil,nil,
		nil,nil,nil,
		4
	},
	Torch = {
		"Coal",nil,nil,
		"Stick",nil,nil,
		nil,nil,nil,
		4
	},
	-- STONE SECTION STONE SECTION STONE SECTION 
	Furnace = {
		"Cobblestone","Cobblestone","Cobblestone",
		"Cobblestone",		nil,	"Cobblestone",
		"Cobblestone","Cobblestone","Cobblestone"
	},
	-- ORE SECTION ORE SECTION ORE SECTION 
	CoalBlock = {
		"Coal","Coal","Coal",
		"Coal","Coal","Coal",
		"Coal","Coal","Coal"
	},
	Coal = {
		"CoalBlock",nil,nil,
		nil,nil,nil,
		nil,nil,nil,
		9
	},
	IronBlock = {
		"IronIngot","IronIngot","IronIngot",
		"IronIngot","IronIngot","IronIngot",
		"IronIngot","IronIngot","IronIngot"
	},
	IronIngot = {
		"IronBlock",nil,nil,
		nil,nil,nil,
		nil,nil,nil,
		9
	},
	GoldBlock = {
		"GoldIngot","GoldIngot","GoldIngot",
		"GoldIngot","GoldIngot","GoldIngot",
		"GoldIngot","GoldIngot","GoldIngot"
	},
	GoldIngot = {
		"GoldBlock",nil,nil,
		nil,nil,nil,
		nil,nil,nil,
		9
	},
	DiamondBlock = {
		"Diamond","Diamond","Diamond",
		"Diamond","Diamond","Diamond",
		"Diamond","Diamond","Diamond"
	},
	Diamond = {
		"DiamondBlock",nil,nil,
		nil,nil,nil,
		nil,nil,nil,
		9
	},
	-- TOOL SECTION TOOL SECTION TOOL SECTION 
	Shears = {
		nil,		"IronIngot",nil,
		"IronIngot",nil,		nil,
		nil,		nil,		nil
	},
	WoodenPickaxe = {
		"OakPlanks","OakPlanks","OakPlanks",
		nil,"Stick",nil,
		nil,"Stick",nil
	},
	GoldPickaxe = {
		"GoldIngot","GoldIngot","GoldIngot",
		nil,"Stick",nil,
		nil,"Stick",nil
	},	
	StonePickaxe = {
		"Cobblestone","Cobblestone","Cobblestone",
		nil,"Stick",nil,
		nil,"Stick",nil
	},
	IronPickaxe = {
		"IronIngot","IronIngot","IronIngot",
		nil,"Stick",nil,
		nil,"Stick",nil
	},
	DiamondPickaxe = {
		"Diamond","Diamond","Diamond",
		nil,"Stick",nil,
		nil,"Stick",nil
	},
	WoodenAxe = {
		"OakPlanks","OakPlanks",nil,
		"OakPlanks","Stick",nil,
		nil,"Stick",nil
	},
	GoldAxe = {
		"GoldIngot","GoldIngot",nil,
		"GoldIngot","Stick",nil,
		nil,"Stick",nil
	},
	StoneAxe = {
		"Cobblestone","Cobblestone",nil,
		"Cobblestone","Stick",nil,
		nil,"Stick",nil
	},
	IronAxe = {
		"IronIngot","IronIngot",nil,
		"IronIngot","Stick",nil,
		nil,"Stick",nil
	},
	DiamondAxe = {
		"Diamond","Diamond",nil,
		"Diamond","Stick",nil,
		nil,"Stick",nil
	},
	WoodenSword = {
		"OakPlanks",nil,nil,
		"OakPlanks",nil,nil,
		"Stick",nil,nil
	},
	GoldSword = {
		"GoldIngot",nil,nil,
		"GoldIngot",nil,nil,
		"Stick",nil,nil
	},
	StoneSword = {
		"Cobblestone",nil,nil,
		"Cobblestone",nil,nil,
		"Stick",nil,nil
	},
	IronSword = {
		"IronIngot",nil,nil,
		"IronIngot",nil,nil,
		"Stick",nil,nil
	},
	DiamondSword = {
		"Diamond",nil,nil,
		"Diamond",nil,nil,
		"Stick",nil,nil
	},
	WoodenShovel = {
		"OakPlanks",nil,nil,
		"Stick",nil,nil,
		"Stick",nil,nil
	},
	GoldShovel = {
		"GoldIngot",nil,nil,
		"Stick",nil,nil,
		"Stick",nil,nil
	},	
	StoneShovel = {
		"Cobblestone",nil,nil,
		"Stick",nil,nil,
		"Stick",nil,nil
	},
	IronShovel = {
		"IronIngot",nil,nil,
		"Stick",nil,nil,
		"Stick",nil,nil
	},
	DiamondShovel = {
		"Diamond",nil,nil,
		"Stick",nil,nil,
		"Stick",nil,nil
	},
}
local unorderedRecipes = {
	
}

return {recipes,unorderedRecipes}
