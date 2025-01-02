local l__ReplicatedStorage__1 = game:GetService("ReplicatedStorage");
local l__RunService__2 = game:GetService("RunService");
local v3 = nil;
if l__RunService__2:IsClient() then
	v3 = require(game:GetService("Players").LocalPlayer.PlayerScripts.Options);
end;
local u1 = require(l__ReplicatedStorage__1.Libs.Class);
return require(l__ReplicatedStorage__1.Libs.Memo)(function(p1)
	local v4 = u1(p1);
	function v4.constructor(p2)
		p2:setTicksRandomly(true);
		p2.blockParticleGravity = 0.25;
	end;
	function v4.isOpaqueCube(p3)
		if not l__RunService__2:IsClient() then
			return false;
		end;
		return not v3:getOption("fancyGraphics");
	end;
	function v4.isTransparent(p4)
		return v3:getOption("fancyGraphics");
	end;
	function v4.isSunlightBlocking(p5)
		return false;
	end;
	function v4.getTickInterval(p6)
		return 1;
	end;
	function v4.onBlockTick(p7, p8, p9, p10, p11)
		for v5 = -2, 2 do
			for v6 = -2, 2 do
				for v7 = -1, 1 do
					if (v5 ~= 0 or v7 ~= 0 or v6 ~= 0) and p8:getBlock(p9 + v5, p10 + v7, p11 + v6) == p1.log.blockID then
						return;
					end;
				end;
			end;
		end;
		p8:setBlock(p9, p10, p11, 0);
	end;
	function v4.getCullFace(p12, p13, p14)
		if not v3:getOption("fancyGraphics") then
			return p1.getCullFace(p12, p13, p14);
		end;
		return p1.blocks[p14]:isOpaqueCube();
	end;
	function v4.getTextureForFace(p15, p16)
		local v8
		if v3:getOption("fancyGraphics") then
			v8 = "";
		else
			v8 = "-fast";
		end;
		return p15.blockTexture .. v8;
	end;
	return v4;
end);
