local l__ReplicatedStorage__1 = game:GetService("ReplicatedStorage");
local v2 = require(l__ReplicatedStorage__1.Libs.Class);
local v3 = require(l__ReplicatedStorage__1.Libs.Memo);
local u1 = nil;
local u2 = nil;
spawn(function()
	u1 = require(l__ReplicatedStorage__1.Block);
	u2 = require(l__ReplicatedStorage__1.Block.BlockFluid)(u1);
end);
return v3(function(p1)
	local v4 = v2((require(script.Parent.EntityParticle)(p1)));
	function v4.constructor(p2, p3, p4, p5, p6, p7, p8, p9)
		p2.particleTexture = "rbxgameasset://Images/particle-bubble";
		p2.particleScale = p2.particleScale * (math.random() * 0.6 + 0.2);
		p2.xVel = p7 * 0.2 + (math.random() * 2 - 1) * 0.02;
		p2.yVel = p8 * 0.2 + (math.random() * 2 - 1) * 0.02;
		p2.zVel = p9 * 0.2 + (math.random() * 2 - 1) * 0.02;
		p2.particleMaxAge = 8 / (math.random() * 0.8 + 0.2);
	end;
	function v4.getSize(p10)
		return 0.02;
	end;
	function v4.update(p11)
		p11.prevX = p11.x;
		p11.prevY = p11.y;
		p11.prevZ = p11.z;
		p11.yVel = p11.yVel + 0.002;
		p11:moveEntity(p11.xVel, p11.yVel, p11.zVel);
		p11.xVel = p11.xVel * 0.85;
		p11.yVel = p11.yVel * 0.85;
		p11.zVel = p11.zVel * 0.85;
		if not u1.blocks[p11.world:getBlock(math.floor(p11.x), math.floor(p11.y), math.floor(p11.z))]:isA(u2) then
			p11:markDead();
		end;
		p11.particleAge = p11.particleAge + 1;
		if p11.particleMaxAge <= p11.particleAge then
			p11:markDead();
		end;
	end;
	return v4;
end);
