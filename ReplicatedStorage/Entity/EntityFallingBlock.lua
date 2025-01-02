local l__ReplicatedStorage__1 = game:GetService("ReplicatedStorage");
local u1 = require(l__ReplicatedStorage__1.Libs.Class);
return require(l__ReplicatedStorage__1.Libs.Memo)(function(p1)
	local v2 = u1(p1);
	function v2.constructor(p2, p3, p4, p5, p6, p7)
		p2.fallTime = 0;
		p2.blockID = p7;
		p2.yOffset = p2:getHeight() / 2;
		p2.entityWalks = false;
	end;
	function v2.getSize(p8)
		return 0.98;
	end;
	function v2.getHeight(p9)
		return 0.98;
	end;
	function v2.update(p10)
		if p10.blockID < 1 then
			p10:markDead();
			return;
		end;
		p10.prevX = p10.x;
		p10.prevY = p10.y;
		p10.prevZ = p10.z;
		local v3 = math.floor(p10.x);
		local v4 = math.floor(p10.y);
		local v5 = math.floor(p10.z);
		if p10.world:getBlock(v3, v4, v5) == p10.blockID then
			p10.world:setBlock(v3, v4, v5, 0);
		end;
		if p10.fallTime > 100 then
			p10:markDead();
		elseif p10.onGround then
			p10.xVel = p10.xVel * 0.7;
			p10.zVel = p10.zVel * 0.7;
			p10.yVel = p10.yVel * -0.5;
			p10:markDead();
			if p10.world:canPlaceBlockAt(v3, v4, v5, p10.blockID) then
				p10.world:setBlock(v3, v4, v5, p10.blockID);
			end;
		end;
		p10.fallTime = p10.fallTime + 1;
		p10.yVel = p10.yVel - 0.04;
		p10:moveEntity(p10.xVel, p10.yVel, p10.zVel);
		p10.xVel = p10.xVel * 0.98;
		p10.yVel = p10.yVel * 0.98;
		p10.zVel = p10.zVel * 0.98;
	end;
	return v2;
end);
