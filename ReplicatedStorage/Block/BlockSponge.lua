local l__ReplicatedStorage__1 = game:GetService("ReplicatedStorage");
local u1 = require(l__ReplicatedStorage__1.Libs.Class);
return require(l__ReplicatedStorage__1.Libs.Memo)(function(p1)
	local v2 = u1(p1);
	local u2 = require(l__ReplicatedStorage__1.Block.BlockWater)(p1);
	function v2.onBlockCreate(p2, p3, p4, p5, p6)
		spawn(function()
			for v3 = -2, 2 do
				for v4 = -2, 2 do
					for v5 = -2, 2 do
						if (v3 ~= 0 or v4 ~= 0 or v5 ~= 0) and p1.blocks[p3:getBlock(p4 + v3, p5 + v4, p6 + v5)]:isA(u2) then
							p3:setBlock(p4 + v3, p5 + v4, p6 + v5, p1.air.blockID);
						end;
					end;
				end;
			end;
		end);
	end;
	function v2.onBlockUpdate(p7, p8, p9, p10, p11)
		p7:onBlockCreate(p8, p9, p10, p11);
	end;
	return v2;
end);
