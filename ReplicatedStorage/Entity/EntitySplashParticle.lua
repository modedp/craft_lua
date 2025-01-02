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
		p2.xVel = p2.xVel * 0.3;
		p2.yVel = math.random() * 0.2 + 0.1;
		p2.zVel = p2.zVel * 0.3;
		p2.particleGravity = 0.04;
		p2.particleMaxAge = 8 / (math.random() * 0.8 + 0.2);
		p2.particleTexture = "rbxgameasset://Images/particle-splash-" .. math.random(1, 4);
		if p8 == 0 and (p7 ~= 0 or p9 ~= 0) then
			p2.xVel = p7;
			p2.yVel = p8 + 0.1;
			p2.zVel = p9;
		end;
	end;
	function v4.getSize(p10)
		return 0.01;
	end;
	function v4.update(p11)
		p11.prevX = p11.x;
		p11.prevY = p11.y;
		p11.prevZ = p11.z;
		p11.yVel = p11.yVel - p11.particleGravity;
		p11:moveEntity(p11.xVel, p11.yVel, p11.zVel);
		p11.xVel = p11.xVel * 0.98;
		p11.yVel = p11.yVel * 0.98;
		p11.zVel = p11.zVel * 0.98;
		p11.particleAge = p11.particleAge + 1;
		if p11.particleMaxAge <= p11.particleAge then
			p11:markDead();
		end;
		if p11.onGround then
			if math.random() < 0.5 then
				p11:markDead();
			end;
			p11.xVel = p11.xVel * 0.7;
			p11.zVel = p11.zVel * 0.7;
		end;
		if u1.blocks[p11.world:getBlock(math.floor(p11.x), math.floor(p11.y), math.floor(p11.z))]:isA(u2) then
			p11:markDead();
		end;
	end;
	return v4;
end);
