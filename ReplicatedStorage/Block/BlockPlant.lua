local l__ReplicatedStorage__1 = game:GetService("ReplicatedStorage");
local u1 = require(l__ReplicatedStorage__1.Libs.Class);
local u2 = require(l__ReplicatedStorage__1.Libs.AABB);
return require(l__ReplicatedStorage__1.Libs.Memo)(function(p1)
	local v2 = u1(p1);
	function v2.constructor(p2, p3, p4)
		p2:setTicksRandomly(true);
		p2.needsSunlight = p4;
		p2.boundingBox = u2.fromPool(0.3, 0, 0.3, 0.7, 0.6, 0.7);
	end;
	function v2.canBlockSupportPlant(p5, p6)
		local v3 = true;
		if p6 ~= p1.grass.blockID then
			v3 = p6 == p1.dirt.blockID;
		end;
		return v3;
	end;
	function v2.isOpaqueCube(p7)
		return false;
	end;
	function v2.isCollidable(p8)
		return false;
	end;
	function v2.getRenderType(p9)
		return "plant";
	end;
	function v2.getItemRenderType(p10)
		return "flat";
	end;
	function v2.isReplaceable(p11)
		return true;
	end;
	function v2.isFluidReplaceable(p12)
		return true;
	end;
	function v2.isTransparent(p13)
		return true;
	end;
	function v2.getTickInterval(p14)
		return 0.25;
	end;
	function v2.onBlockTick(p15, p16, p17, p18, p19)
		local v4 = p16:canBlockSeeSky(p17, p18, p19);
		if not (not p15.needsSunlight) and not v4 or not p15.needsSunlight and v4 then
			p16:setBlock(p17, p18, p19, p1.air.blockID);
		end;
	end;
	function v2.onBlockCreate(p20, p21, p22, p23, p24)
		p21:updateBlock(p22, p23, p24);
	end;
	function v2.isSunlightBlocking(p25)
		return false;
	end;
	function v2.onBlockUpdate(p26, p27, p28, p29, p30)
		if not p26:canBlockSupportPlant((p27:getBlock(p28, p29 - 1, p30))) then
			p27:setBlock(p28, p29, p30, p1.air.blockID);
		end;
	end;
	return v2;
end);
