local l__ReplicatedStorage__1 = game:GetService("ReplicatedStorage");
if game:GetService("RunService"):IsServer() then
	local u1 = nil;
	local l__ServerScriptService__2 = game:GetService("ServerScriptService");
	spawn(function()
		u1 = require(l__ServerScriptService__2.ServerWorld.TreeGenerator);
	end);
end;
local u3 = require(l__ReplicatedStorage__1.Libs.Class);
local u4 = require(l__ReplicatedStorage__1.Libs.AABB);
local u5 = nil;
return require(l__ReplicatedStorage__1.Libs.Memo)(function(p1)
	local v2 = require(l__ReplicatedStorage__1.Block.BlockPlant)(p1);
	local v3 = u3(v2);
	function v3.constructor(p2)
		p2.boundingBox = u4.fromPool(0.1, 0, 0.1, 0.9, 0.8, 0.9);
	end;
	function v3.onBlockTick(p3, p4, p5, p6, p7)
		v2.onBlockTick(p3, p4, p5, p6, p7);
		if p4:getBlock(p5, p6, p7) == p1.air.blockID then
			return;
		end;
		local v4 = p4.rand:NextInteger(4, 6);
		local v5 = u5.new(p4);
		if v5:isSpaceForTree(p5, p6, p7, v4) then
			v5:growTree(p5, p6, p7, v4);
		end;
	end;
	return v3;
end);
