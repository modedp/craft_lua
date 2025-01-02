local l__ReplicatedStorage__1 = game:GetService("ReplicatedStorage");
local u1 = require(l__ReplicatedStorage__1.Libs.Class);
return require(l__ReplicatedStorage__1.Libs.Memo)(function(p1)
	local v2 = u1(p1);
	function v2.constructor(p2)
		p2:setTicksRandomly(true);
		p2:setBlockTexture("grass");
	end;
	function v2.getPickBlockID(p3)
		return p1.dirt.blockID;
	end;
	function v2.getTextureForFace(p4, p5)
		if p5 == Enum.NormalId.Top then
			return "grass-top";
		end;
		if p5 ~= Enum.NormalId.Bottom then
			return p4.blockTexture;
		end;
		return p1.dirt.blockTexture;
	end;
	function v2.getTickInterval(p6)
		return 1;
	end;
	local u2 = require(l__ReplicatedStorage__1.Block.BlockFluid)(p1);
	function v2.onBlockTick(p7, p8, p9, p10, p11)
		if p10 < 64 then
			local v3 = p1.blocks[p8:getBlock(p9, p10 + 1, p11)];
			if v3:isOpaqueCube() or v3:isA(u2) then
				p8:setBlock(p9, p10, p11, p1.dirt.blockID);
				return;
			end;
		end;
		for v4 = 1, 5 do
			local v5 = p8.rand:NextInteger(-2, 2);
			local v6 = p8.rand:NextInteger(-2, 2);
			local v7 = p8.rand:NextInteger(-1, 1);
			if p8:getBlock(p9 + v5, p10 + v7, p11 + v6) == p1.dirt.blockID and p8:canBlockSeeSky(p9 + v5, p10 + v7, p11 + v6) then
				p8:setBlock(p9 + v5, p10 + v7, p11 + v6, p1.grass.blockID);
				return;
			end;
		end;
	end;
	return v2;
end);
