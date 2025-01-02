local l__ReplicatedStorage__1 = game:GetService("ReplicatedStorage");
local u1 = require(l__ReplicatedStorage__1.Libs.Class);
return require(l__ReplicatedStorage__1.Libs.Memo)(function(p1)
	local v2 = u1(p1);
	function v2.constructor(p2, p3, p4, p5, p6, p7, p8, p9)
		if not p7 then
			p7 = 0;
			p8 = 0;
			p9 = 0;
		end;
		p2.particleGravity = 0;
		p2.yOffset = p2:getHeight() / 2;
		p2.particleColour = Color3.new(1, 1, 1);
		p2.xVel = p7 + (math.random() * 2 - 1) * 0.4;
		p2.yVel = p8 + (math.random() * 2 - 1) * 0.4;
		p2.zVel = p9 + (math.random() * 2 - 1) * 0.4;
		local v3 = (math.random() * 2 + 1) * 0.15;
		local v4 = math.sqrt(p2.xVel ^ 2 + p2.yVel ^ 2 + p2.zVel ^ 2);
		p2.xVel = p2.xVel / v4 * v3 * 0.4;
		p2.yVel = p2.yVel / v4 * v3 * 0.4;
		p2.zVel = p2.zVel / v4 * v3 * 0.4;
		p2.particleScale = (math.random() / 2 + 0.5) * 4;
		p2.particleMaxAge = 4 / (math.random() * 0.9 + 0.1);
		p2.particleAge = 0;
		p2.particleTexture = "";
		p2.entityWalks = false;
		p2.preventEntitySpawning = false;
	end;
	function v2.getSize(p10)
		return 0.2;
	end;
	function v2.getHeight(p11)
		return p11:getSize();
	end;
	function v2.update(p12)
		p12.prevX = p12.x;
		p12.prevY = p12.y;
		p12.prevZ = p12.z;
		p12.particleAge = p12.particleAge + 1;
		if p12.particleMaxAge <= p12.particleAge then
			p12:markDead();
		end;
		p12.yVel = p12.yVel - 0.04 * p12.particleGravity;
		p12:moveEntity(p12.xVel, p12.yVel, p12.zVel);
		p12.xVel = p12.xVel * 0.98;
		p12.yVel = p12.yVel * 0.98;
		p12.zVel = p12.zVel * 0.98;
		if p12.onGround then
			p12.xVel = p12.xVel * 0.7;
			p12.zVel = p12.zVel * 0.7;
		end;
	end;
	function v2.createParticleModel(p13, p14)
		local v5 = Instance.new("ImageLabel");
		v5.Size = UDim2.new(0.1 * p13.particleScale, 0, 0.1 * p13.particleScale, 0);
		v5.Position = UDim2.new(0.5, 0, 0.5, 0);
		v5.AnchorPoint = Vector2.new(0.5, 0.5);
		v5.BackgroundTransparency = 1;
		local v6 = p13:getEntityBrightness();
		v5.ImageColor3 = Color3.new(p13.particleColour.r * v6, p13.particleColour.g * v6, p13.particleColour.b * v6);
		v5.Image = p13.particleTexture;
		v5.Parent = p14;
	end;
	function v2.updateParticleModel(p15, p16)

	end;
	return v2;
end);
