local l__ReplicatedStorage__1 = game:GetService("ReplicatedStorage");
local u1 = require(l__ReplicatedStorage__1.Libs.Class);
local u2 = require(l__ReplicatedStorage__1.Libs.AABB);
return require(l__ReplicatedStorage__1.Libs.Memo)(function(p1)
	local v2 = u1(p1);
	function v2.constructor(p2, p3, p4)
		p2.isDoubleSlab = p4;
		if not p4 then
			p2.boundingBox = u2.fromPool(0, 0, 0, 1, 0.5, 1);
			p2.collisionBox = u2.fromPool(0, 0, 0, 1, 0.5, 1);
		end;
		p2:setBlockTexture("slab");
	end;
	function v2.getPickBlockID(p5)
		return p1.slab.blockID;
	end;
	function v2.getRenderType(p6)
		return "slab";
	end;
	function v2.isOpaqueCube(p7)
		return p7.isDoubleSlab;
	end;
	function v2.getCullFace(p8, p9, p10)
		if not p8.isDoubleSlab and p9 == Enum.NormalId.Top then
			return false;
		end;
		if p9 == Enum.NormalId.Bottom then
			return p1.blocks[p10]:isOpaqueCube();
		end;
		local v3 = true;
		if p8.blockID ~= p10 then
			v3 = p1.blocks[p10]:isOpaqueCube();
		end;
		return v3;
	end;
	function v2.getTextureForFace(p11, p12)
		if p12 ~= Enum.NormalId.Top and p12 ~= Enum.NormalId.Bottom then
			return p11.blockTexture;
		end;
		return "slab-top";
	end;
	return v2;
end);
