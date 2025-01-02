local l__ReplicatedStorage__1 = game:GetService("ReplicatedStorage");
local u1 = require(l__ReplicatedStorage__1.Libs.Class);
local u2 = require(l__ReplicatedStorage__1.Entity);
return require(l__ReplicatedStorage__1.Libs.Memo)(function(p1)
	local v2 = u1((require(l__ReplicatedStorage__1.Block.BlockFluid)(p1)));
	function v2.onDisplayTick(p2, p3, p4, p5, p6)
		if math.random() < 0.02 then
			p3:spawnLocalEntity(u2.particleWaterSuspend, p4 + math.random(), p5 + math.random(), p6 + math.random(), math.random() * 0.25 - 0.125, math.random() * 0.25 - 0.0625, math.random() * 0.25 - 0.125);
		end;
	end;
	return v2;
end);
