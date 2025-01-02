local l__ReplicatedStorage__1 = game:GetService("ReplicatedStorage");
local u1 = require(l__ReplicatedStorage__1.Libs.Class);
local u2 = require(l__ReplicatedStorage__1.Entity);
return require(l__ReplicatedStorage__1.Libs.Memo)(function(p1)
	local v2 = u1(p1);
	function v2.constructor(p2)

	end;
	function v2.isGlowing(p3)
		return true;
	end;
	function v2.onDisplayTick(p4, p5, p6, p7, p8)
		if p5:getBlock(p6, p7 + 1, p8) == p1.water.blockID then
			for v3 = 1, 4 do
				p5:spawnLocalEntity(u2.particleBubble, p6 + math.random(), p7 + 1, p8 + math.random(), math.random() * 0.25 - 0.125, math.random() * 0.25, math.random() * 0.25 - 0.125);
			end;
		end;
	end;
	return v2;
end);
