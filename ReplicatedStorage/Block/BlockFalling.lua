local l__ReplicatedStorage__1 = game:GetService("ReplicatedStorage");
local u1 = require(l__ReplicatedStorage__1.Libs.Class);
local u2 = require(l__ReplicatedStorage__1.Entity);
return require(l__ReplicatedStorage__1.Libs.Memo)(function(p1)
	local v2 = u1(p1);
	function v2.onBlockCreate(p2, p3, p4, p5, p6)
		p3:updateBlock(p4, p5, p6);
	end;
	function v2.onBlockUpdate(p7, p8, p9, p10, p11)
		if not p1.blocks[p8:getBlock(p9, p10 - 1, p11)]:isCollidable() then
			p8:spawnServerEntity(u2.fallingBlock, p9 + 0.5, p10 + 0.5, p11 + 0.5, p7.blockID);
		end;
	end;
	return v2;
end);
