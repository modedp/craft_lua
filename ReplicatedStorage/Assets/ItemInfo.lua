local M_BI = require(script.Parent:WaitForChild("BlockInfo"))

local items = {
	-- WOOD SECTION WOOD SECTION WOOD SECTION WOOD SECTION WOOD SECTION 
	Stick = {
		maxstack = 64,
		texture = "stick"
	},
	Torch = {
		maxstack = 64,
		texture = "torch",
		placeable = 1,
	},
	-- ORE SECTION ORE SECTION ORE SECTION ORE SECTION ORE SECTION
	Coal = {
		maxstack = 64,
		texture = "coal"
	},
	GoldIngot = {
		maxstack = 64,
		texture = "goldingot"
	},
	IronIngot = {
		maxstack = 64,
		texture = "ironingot"
	},	
	Diamond = {
		maxstack = 64,
		texture = "diamond"
	},
	-- MISC SECTION MISC SECTION MISC SECTION MISC SECTION MISC SECTION
	Barrier = {
		maxstack = 64,
		texture = "barrier"
	},
	-- TOOLS SECTION TOOLS SECTION TOOLS SECTION TOOLS SECTION TOOLS SECTION
	Shears = {
		maxstack = 1,
		texture = "shears",
		level = "shears",
		tooltype = "shears",
		name = "Shears"
	},
	-- PICKAXES PICKAXES PICKAXES PICKAXES
	WoodenPickaxe = {
		maxstack = 1,
		texture = "woodenpickaxe",
		level = "wooden",
		tooltype = "pickaxe",
		name = "Wooden Pickaxe"
	},
	GoldPickaxe = {
		maxstack = 1,
		texture = "goldpickaxe",
		level = "gold",
		tooltype = "pickaxe",
		name = "Gold Pickaxe"
	},
	StonePickaxe = {
		maxstack = 1,
		texture = "stonepickaxe",
		level = "stone",
		tooltype = "pickaxe",
		name = "Stone Pickaxe"
	},
	IronPickaxe = {
		maxstack = 1,
		texture = "ironpickaxe",
		level = "iron",
		tooltype = "pickaxe",
		name = "Iron Pickaxe"
	},
	DiamondPickaxe = {
		maxstack = 1,
		texture = "diamondpickaxe",
		level = "diamond",
		tooltype = "pickaxe",
		name = "Diamond Pickaxe"
	},
	-- AXES AXES AXES AXES
	WoodenAxe = {
		maxstack = 1,
		texture = "woodenaxe",
		level = "wooden",
		tooltype = "axe",
		name = "Wooden Axe"
	},
	GoldAxe = {
		maxstack = 1,
		texture = "goldaxe",
		level = "gold",
		tooltype = "axe",
		name = "Gold Axe"
	},
	StoneAxe = {
		maxstack = 1,
		texture = "stoneaxe",
		level = "stone",
		tooltype = "axe",
		name = "Stone Axe"
	},
	IronAxe = {
		maxstack = 1,
		texture = "ironaxe",
		level = "iron",
		tooltype = "axe",
		name = "Iron Axe"
	},
	DiamondAxe = {
		maxstack = 1,
		texture = "diamondaxe",
		level = "diamond",
		tooltype = "axe",
		name = "Diamond Axe"
	},
	-- SWORDS SWORDS SWORDS SWORDS
	WoodenSword = {
		maxstack = 1,
		texture = "woodensword",
		level = "wooden",
		tooltype = "sword",
		name = "Wooden Sword"
	},
	GoldSword = {
		maxstack = 1,
		texture = "goldsword",
		level = "gold",
		tooltype = "sword",
		name = "Gold Sword"
	},
	StoneSword = {
		maxstack = 1,
		texture = "stonesword",
		level = "stone",
		tooltype = "sword",
		name = "Stone Sword"
	},
	IronSword = {
		maxstack = 1,
		texture = "ironsword",
		level = "iron",
		tooltype = "sword",
		name = "Iron Sword"
	},
	DiamondSword = {
		maxstack = 1,
		texture = "diamondsword",
		level = "diamond",
		tooltype = "sword",
		name = "Diamond Sword"
	},
	-- SHOVEL SECTION SHOVEL SECTION SHOVEL SECTION
	WoodenShovel = {
		maxstack = 1,
		texture = "woodenshovel",
		level = "wooden",
		tooltype = "shovel",
		name = "Wooden Shovel"
	},
	GoldShovel = {
		maxstack = 1,
		texture = "goldshovel",
		level = "gold",
		tooltype = "shovel",
		name = "Gold Shovel"
	},
	StoneShovel = {
		maxstack = 1,
		texture = "stoneshovel",
		level = "stone",
		tooltype = "shovel",
		name = "Stone Shovel"
	},
	IronShovel = {
		maxstack = 1,
		texture = "ironshovel",
		level = "iron",
		tooltype = "shovel",
		name = "Iron Shovel"
	},
	DiamondShovel = {
		maxstack = 1,
		texture = "diamondshovel",
		level = "diamond",
		tooltype = "shovel",
		name = "Diamond Shovel"
	},
	Item = {
		maxstack = 64
	},
}

for i,v in pairs(M_BI) do
	if v.hasItsOwnItem and not items[i] then
		local item = {
			maxstack = 64,
			defaultname = (type(v.hasItsOwnItem) == "string") and v.hasItsOwnItem or i,
			block = i
		}
		items[i] = item
	end
end

return items
