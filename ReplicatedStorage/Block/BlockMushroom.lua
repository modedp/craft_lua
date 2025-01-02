local l__ReplicatedStorage__1 = game:GetService("ReplicatedStorage");
local u1 = require(l__ReplicatedStorage__1.Libs.Class);
local u2 = require(l__ReplicatedStorage__1.Libs.AABB);
return require(l__ReplicatedStorage__1.Libs.Memo)(function(p1)
	local v2 = u1((require(l__ReplicatedStorage__1.Block.BlockPlant)(p1)));
	function v2.constructor(p2)
		p2.boundingBox = u2.fromPool(0.3, 0, 0.3, 0.7, 0.4, 0.7);
	end;
	function v2.canBlockSupportPlant(p3, p4)
		return p1.blocks[p4]:isOpaqueCube();
	end;
	return v2;
end);
