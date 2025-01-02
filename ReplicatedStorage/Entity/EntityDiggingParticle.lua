local l__ReplicatedStorage__1 = game:GetService("ReplicatedStorage");
local v2 = require(l__ReplicatedStorage__1.Libs.Class);
local v3 = require(l__ReplicatedStorage__1.Libs.Memo);
local va =  require(l__ReplicatedStorage__1.Assets).blocks
local u1 = nil;
spawn(function()
	u1 = require(l__ReplicatedStorage__1.Block);
end);
local function u2(p1)
	return "rbxassetid://" .. va[p1];
end;
return v3(function(p2)
	local v4 = v2((require(script.Parent.EntityParticle)(p2)));
	function v4.constructor(p3, p4, p5, p6, p7, p8, p9, p10, p11)
		p3.blockType = p11;
		p3.particleGravity = p11.blockParticleGravity;
		p3.particleColor = Color3.new(0.6, 0.6, 0.6);
		p3.particleScale = p3.particleScale / 2;
		p3.particleTextureJitterX = math.random();
		p3.particleTextureJitterY = math.random();
	end;
	function v4.createBlockBreakParticles(p12, p13, p14, p15)
		local v5 = p12:getBlock(p13, p14, p15);
		if v5 == u1.air.blockID then
			return;
		end;
		local v6 = u1.blocks[v5];
		for v7 = 1, 3 do
			for v8 = 1, 3 do
				for v9 = 1, 3 do
					local v10 = p13 + (v7 - 0.5) / 3;
					local v11 = p14 + (v8 - 0.5) / 3;
					local v12 = p15 + (v9 - 0.5) / 3;
					p12:spawnLocalEntity(p2.particleDig, v10, v11, v12, v10 - p13 - 0.5, v11 - p14 - 0.5, v12 - p15 - 0.5, v6);
				end;
			end;
		end;
	end;
	function v4.createParticleModel(p16, p17)
		local v13 = Instance.new("ImageLabel");
		v13.Size = UDim2.new(0.1 * p16.particleScale, 0, 0.1 * p16.particleScale, 0);
		v13.Position = UDim2.new(0.5, 0, 0.5, 0);
		v13.AnchorPoint = Vector2.new(0.5, 0.5);
		v13.BackgroundTransparency = 1;
		local v14 = p16:getEntityBrightness();
		v13.ImageColor3 = Color3.new(p16.particleColour.r * v14, p16.particleColour.g * v14, p16.particleColour.b * v14);
		v13.Image = u2(p16.blockType.blockTexture);
		v13.ImageRectSize = Vector2.new(256, 256);
		v13.ImageRectOffset = Vector2.new(p16.particleTextureJitterX * 768, p16.particleTextureJitterY * 768);
		v13.Parent = p17;
	end;
	function v4.updateParticleModel(p18, p19)

	end;
	return v4;
end);
