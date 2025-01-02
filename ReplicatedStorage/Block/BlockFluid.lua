local l__ReplicatedStorage__1 = game:GetService("ReplicatedStorage");
local u1 = require(l__ReplicatedStorage__1.Libs.Class);
local u2 = require(l__ReplicatedStorage__1.Libs.AABB);
return require(l__ReplicatedStorage__1.Libs.Memo)(function(p1)
	local v2 = u1(p1);
	function v2.constructor(p2, p3, p4)
		p2.isFlowing = p4;
		p2.stillBlockID = p4 and p3 + 1 or p3;
		p2.flowingBlockID = p4 and p3 or p3 - 1;
		p2.collisionBox = u2.fromPool(0, 0, 0, 1, 0.875, 1);
	end;
	function v2.getRenderType(p5)
		return "fluid";
	end;
	function v2.getItemRenderType(p6)
		return "flat";
	end;
	function v2.onBlockCreate(p7, p8, p9, p10, p11)
		p8:updateBlock(p9, p10, p11);
	end;
	function v2.getTickInterval(p12)
		if p12.isFlowing then
			return 5;
		end;
		return 0;
	end;
	function v2.onBlockUpdate(p13, p14, p15, p16, p17)
		if p13.isFlowing then
			return;
		end;
		if not (not p1.blocks[p14:getBlock(p15, p16 - 1, p17)]:isFluidReplaceable()) or not (not p1.blocks[p14:getBlock(p15 + 1, p16, p17)]:isFluidReplaceable()) or not (not p1.blocks[p14:getBlock(p15 - 1, p16, p17)]:isFluidReplaceable()) or not (not p1.blocks[p14:getBlock(p15, p16, p17 + 1)]:isFluidReplaceable()) or p1.blocks[p14:getBlock(p15, p16, p17 - 1)]:isFluidReplaceable() then
			p14:setBlock(p15, p16, p17, p13.flowingBlockID);
		end;
	end;
	function v2.onBlockTick(p18, p19, p20, p21, p22)
		if not p18.isFlowing then
			return;
		end;
		local u3 = false;
		local function v3(p23, p24, p25)
			if not p1.blocks[p19:getBlock(p23, p24, p25)]:isFluidReplaceable() then
				return false;
			end;
			u3 = true;
			if p18 == p1.water or p18 == p1.waterMoving then
				for v4 = -2, 2 do
					for v5 = -2, 2 do
						for v6 = -2, 2 do
							if (v4 ~= 0 or v5 ~= 0 or v6 ~= 0) and p19:getBlock(p23 + v4, p24 + v5, p25 + v6) == p1.sponge.blockID then
								return false;
							end;
						end;
					end;
				end;
			end;
			p19:setBlock(p23, p24, p25, p18.flowingBlockID);
			return true;
		end;
		if not v3(p20, p21 - 1, p22) then
			v3(p20 + 1, p21, p22);
			v3(p20 - 1, p21, p22);
			v3(p20, p21, p22 + 1);
			v3(p20, p21, p22 - 1);
		end;
		if not u3 then
			p19:setBlock(p20, p21, p22, p18.stillBlockID);
		end;
	end;
	function v2.isOpaqueCube(p26)
		return false;
	end;
	function v2.isTransparent(p27)
		return true;
	end;
	function v2.isCollidable(p28)
		return false;
	end;
	function v2.isReplaceable(p29)
		return true;
	end;
	function v2.isTargetable(p30)
		return false;
	end;
	function v2.getCullFace(p31, p32, p33)
		if p32 == Enum.NormalId.Top then
			local v7 = true;
			if p31.stillBlockID ~= p33 then
				v7 = p31.flowingBlockID == p33;
			end;
			return v7;
		end;
		local v8 = true;
		if p31.stillBlockID ~= p33 then
			v8 = true;
			if p31.flowingBlockID ~= p33 then
				v8 = p1.blocks[p33]:isOpaqueCube();
			end;
		end;
		return v8;
	end;
	function v2.getLiquidCullBackface(p34, p35, p36)
		local v9 = p1.blocks[p36];
		return v9:isOpaqueCube() or v9:isA(v2);
	end;
	return v2;
end);
