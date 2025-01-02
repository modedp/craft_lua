local l__ReplicatedStorage__1 = game:GetService("ReplicatedStorage");
local v2 = require(l__ReplicatedStorage__1.Libs.Class)();
local v3 = require(script.BlockPlant)(v2);
local v4 = require(script.BlockMushroom)(v2);
local v5 = require(script.BlockSlab)(v2);
local v6 = require(script.BlockWater)(v2);
local v7 = require(script.BlockLava)(v2);
local v8 = require(script.BlockFalling)(v2);
v2.blocks = {};
local u1 = require(l__ReplicatedStorage__1.Libs.AABB);
function v2.constructor(p1, p2)
	p1.blockID = p2;
	p1.blockTexture = "";
	p1.ticksRandomly = false;
	p1.boundingBox = u1.fromPool(0, 0, 0, 1, 1, 1);
	p1.collisionBox = u1.fromPool(0, 0, 0, 1, 1, 1);
	p1.blockParticleGravity = 1;
	p1.friction = 0.6;
	p1.stepSound = {
		sound = "step.stone", 
		volume = 1, 
		pitch = 1
	};
	p1.breakSound = {
		sound = "step.stone", 
		volume = 1, 
		pitch = 1
	};
	v2.blocks[p2] = p1;
end;
function v2.setBlockTexture(p3, p4)
	p3.blockTexture = p4;
	return p3;
end;
function v2.setTicksRandomly(p5, p6)
	p5.ticksRandomly = p6;
	return p5;
end;
function v2.setStepSound(p7, p8)
	p7.stepSound.sound = "step." .. p8;
	p7.breakSound.sound = "step." .. p8;
	return p7;
end;
function v2.getRenderType(p9)
	return "cube";
end;
function v2.getItemRenderType(p10)
	return "block";
end;
function v2.isOpaqueCube(p11)
	return true;
end;
function v2.isGlowing(p12)
	return false;
end;
function v2.isTransparent(p13)
	return false;
end;
function v2.getCullFace(p14, p15, p16)
	local v9 = true;
	if p14.blockID ~= p16 then
		v9 = v2.blocks[p16]:isOpaqueCube();
	end;
	return v9;
end;
function v2.getTextureForFace(p17, p18)
	return p17.blockTexture;
end;
function v2.onDisplayTick(p19, p20, p21, p22, p23)

end;
function v2.getPickBlockID(p24)
	return p24.blockID;
end;
function v2.isSunlightBlocking(p25)
	return true;
end;
function v2.isCollidable(p26)
	return true;
end;
function v2.getBoundingBox(p27)
	return p27.boundingBox;
end;
function v2.getCollisionBoxes(p28)
	return { p28.collisionBox };
end;
function v2.isTargetable(p29)
	return true;
end;
function v2.isBreakable(p30)
	return true;
end;
function v2.isReplaceable(p31)
	return false;
end;
function v2.isFluidReplaceable(p32)
	return false;
end;
function v2.getTickInterval(p33)
	return 0;
end;
function v2.onBlockCreate(p34, p35, p36, p37, p38)

end;
function v2.onBlockUpdate(p39, p40, p41, p42, p43)

end;
function v2.onBlockTick(p44, p45, p46, p47, p48)

end;
function v2.onBlockDestroy(p49, p50, p51, p52, p53)

end;
v2.void = require(script.BlockVoid)(v2).new(-1);
v2.air = require(script.BlockAir)(v2).new(0);
v2.stone = v2.new(1):setBlockTexture("stone");
v2.grass = require(script.BlockGrass)(v2).new(2):setStepSound("gravel");
v2.dirt = v2.new(3):setBlockTexture("dirt"):setStepSound("gravel");
v2.cobblestone = v2.new(4):setBlockTexture("cobblestone");
v2.planks = v2.new(5):setBlockTexture("planks"):setStepSound("wood");
v2.sapling = require(script.BlockSapling)(v2).new(6, true):setBlockTexture("sapling");
v2.bedrock = require(script.BlockBedrock)(v2).new(7):setBlockTexture("bedrock");
v2.waterMoving = v6.new(8, true):setBlockTexture("water");
v2.water = v6.new(9, false):setBlockTexture("water");
v2.lavaMoving = v7.new(10, true):setBlockTexture("lava");
v2.lava = v7.new(11, false):setBlockTexture("lava");
v2.sand = v8.new(12):setBlockTexture("sand"):setStepSound("gravel");
v2.gravel = v8.new(13):setBlockTexture("gravel"):setStepSound("gravel");
v2.goldOre = v2.new(14):setBlockTexture("gold-ore");
v2.ironOre = v2.new(15):setBlockTexture("iron-ore");
v2.coalOre = v2.new(16):setBlockTexture("coal-ore");
v2.log = require(script.BlockLog)(v2).new(17):setStepSound("wood");
v2.leaves = require(script.BlockLeaves)(v2).new(18):setBlockTexture("leaves");
v2.sponge = require(script.BlockSponge)(v2).new(19):setBlockTexture("sponge"):setStepSound("gravel");
v2.glass = require(script.BlockGlass)(v2).new(20):setBlockTexture("glass");
v2.redWool = v2.new(21):setBlockTexture("wool-red");
v2.orangeWool = v2.new(22):setBlockTexture("wool-orange");
v2.yellowWool = v2.new(23):setBlockTexture("wool-yellow");
v2.limeWool = v2.new(24):setBlockTexture("wool-lime");
v2.greenWool = v2.new(25):setBlockTexture("wool-green");
v2.aquaWool = v2.new(26):setBlockTexture("wool-aqua");
v2.cyanWool = v2.new(27):setBlockTexture("wool-cyan");
v2.blueWool = v2.new(28):setBlockTexture("wool-blue");
v2.purpleWool = v2.new(29):setBlockTexture("wool-purple");
v2.indigoWool = v2.new(30):setBlockTexture("wool-indigo");
v2.violetWool = v2.new(31):setBlockTexture("wool-violet");
v2.magentaWool = v2.new(32):setBlockTexture("wool-magenta");
v2.pinkWool = v2.new(33):setBlockTexture("wool-pink");
v2.blackWool = v2.new(34):setBlockTexture("wool-black");
v2.greyWool = v2.new(35):setBlockTexture("wool-grey");
v2.whiteWool = v2.new(36):setBlockTexture("wool-white");
v2.dandelion = v3.new(37, true):setBlockTexture("dandelion");
v2.rose = v3.new(38, true):setBlockTexture("rose");
v2.brownMushroom = v4.new(39, false):setBlockTexture("red-mushroom");
v2.redMushroom = v4.new(40, false):setBlockTexture("brown-mushroom");
v2.goldBlock = require(script.BlockGold)(v2).new(41);
v2.ironBlock = require(script.BlockIron)(v2).new(42);
v2.doubleSlab = v5.new(43, true);
v2.slab = v5.new(44, false);
v2.bricks = v2.new(45):setBlockTexture("bricks");
v2.tnt = require(script.BlockTNT)(v2).new(46);
v2.bookshelf = require(script.BlockBookshelf)(v2).new(47):setStepSound("wood");
v2.mossStone = v2.new(48):setBlockTexture("moss-stone");
v2.obsidian = v2.new(49):setBlockTexture("obsidian");
v2.diamondOre = v2.new(56):setBlockTexture("diamond-ore");
v2.diamondBlock = require(script.BlockDiamond)(v2).new(57);
v2.glowingObsidian = require(script.BlockGlowingObsidian)(v2).new(95):setBlockTexture("obsidian-glowing");
return v2;
