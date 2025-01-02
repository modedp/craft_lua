local l__ReplicatedStorage__1 = game:GetService("ReplicatedStorage");
local v2 = require(l__ReplicatedStorage__1.Libs.Class);
local v3 = require(l__ReplicatedStorage__1.Libs.Memo);
local u1 = nil;
spawn(function()
	u1 = require(l__ReplicatedStorage__1.Block);
end);
return v3(function(p1)
	local v4 = v2(p1);
	function v4.constructor(p2, p3, p4, p5, p6)
		p2.moveSpeed = 0.7;
		p2.stepHeight = 0.5;
		p2.moveStrafing = 0;
		p2.moveForward = 0;
		p2.isJumping = false;
		p2.renderWalkTime = 0;
		p2.renderWalkDepth = 0;
		p2.renderLastWalkDepth = 0;
		p2.swingProgress = 0;
		p2.prevSwingProgress = 0;
	end;
	function v4.getEyeHeight(p7)
		return p7:getHeight() * 0.85;
	end;
	function v4.moveEntityWithHeading(p8, p9, p10)
		if p8:handleWaterMovement() then
			p8:moveFlying(p9, p10, 0.02);
			p8:moveEntity(p8.xVel, p8.yVel, p8.zVel);
			p8.xVel = p8.xVel * 0.8;
			p8.yVel = p8.yVel * 0.8 - 0.02;
			p8.zVel = p8.zVel * 0.8;
			return;
		end;
		if p8:handleLavaMovement() then
			p8:moveFlying(p9, p10, 0.02);
			p8:moveEntity(p8.xVel, p8.yVel, p8.zVel);
			p8.xVel = p8.xVel * 0.5;
			p8.yVel = p8.yVel * 0.5 - 0.02;
			p8.zVel = p8.zVel * 0.5;
			return;
		end;
		local v5 = 0.91;
		if p8.onGround then
			v5 = 0.546;
			local v6 = p8.world:getBlock(math.floor(p8.x), math.floor(p8.y - p8.yOffset) - 1, math.floor(p8.z));
			if v6 ~= u1.air.blockID then
				v5 = u1.blocks[v6].friction * 0.91;
			end;
		end;
		p8:moveFlying(p9, p10, p8.onGround and 0.1 * (0.1627714 / v5 ^ 3) or 0.02);
		local v7 = 0.91;
		if p8.onGround then
			v7 = 0.546;
			local v8 = p8.world:getBlock(math.floor(p8.x), math.floor(p8.y - p8.yOffset) - 1, math.floor(p8.z));
			if v8 ~= u1.air.blockID then
				v7 = u1.blocks[v8].friction * 0.91;
			end;
		end;
		p8:moveEntity(p8.xVel, p8.yVel, p8.zVel);
		p8.yVel = (p8.yVel - 0.08) * 0.98;
		p8.xVel = p8.xVel * v7;
		p8.zVel = p8.zVel * v7;
		p8.renderLastWalkDepth = p8.renderWalkDepth;
		local v9 = math.sqrt((p8.x - p8.prevX) ^ 2 + (p8.z - p8.prevZ) ^ 2) * 4;
		if v9 > 1 then
			v9 = 1;
		end;
		p8.renderWalkDepth = (v9 - p8.renderWalkDepth) * 0.4 + p8.renderWalkDepth;
		p8.renderWalkTime = p8.renderWalkTime + p8.renderWalkDepth;
	end;
	function v4.update(p11)
		p1.update(p11);
		p11:onLivingUpdate();
		local v10 = p11.x - p11.prevX;
		local v11 = p11.z - p11.prevZ;
		local v12 = p11.renderYawOffset;
		if math.sqrt(v10 ^ 2 + v11 ^ 2) > 0.05 then
			v12 = math.deg(math.atan2(v11, v10)) - 90;
		end;
		if p11.swingProgress > 0 then
			v12 = p11.yaw;
		end;
		local v13 = v12 - p11.renderYawOffset;
		while v13 < -180 do
			v13 = v13 + 360;		
		end;
		while v13 >= 180 do
			v13 = v13 - 360;		
		end;
		p11.renderYawOffset = p11.renderYawOffset + v13 * 0.3;
		local v14 = p11.yaw - p11.renderYawOffset;
		while v14 < -180 do
			v14 = v14 + 360;		
		end;
		while v13 >= 180 do
			v14 = v14 - 360;		
		end;
		local v15 = math.clamp(v14, -75, 75);
		p11.renderYawOffset = p11.yaw - v15;
		if v15 ^ 2 > 2500 then
			p11.renderYawOffset = p11.renderYawOffset + v15 * 0.2;
		end;
		while p11.yaw - p11.prevYaw < -180 do
			p11.prevYaw = p11.prevYaw - 360;		
		end;
		while p11.yaw - p11.prevYaw >= 180 do
			p11.prevYaw = p11.prevYaw + 360;		
		end;
		while p11.renderYawOffset - p11.prevRenderYawOffset < -180 do
			p11.prevRenderYawOffset = p11.prevRenderYawOffset - 360;		
		end;
		while p11.renderYawOffset - p11.prevRenderYawOffset >= 180 do
			p11.prevRenderYawOffset = p11.prevRenderYawOffset + 360;		
		end;
		while p11.pitch - p11.prevPitch < -180 do
			p11.prevPitch = p11.prevPitch - 360;		
		end;
		while p11.pitch - p11.prevPitch >= 180 do
			p11.prevPitch = p11.prevPitch + 360;		
		end;
	end;
	function v4.onEntityUpdate(p12)
		p12.prevSwingProgress = p12.swingProgress;
		p1.onEntityUpdate(p12);
		p12.prevRenderYawOffset = p12.renderYawOffset;
		p12.prevYaw = p12.yaw;
		p12.prevPitch = p12.pitch;
	end;
	function v4.onLivingUpdate(p13)
		p13:updatePlayerActionState();
		local v16 = p13:handleWaterMovement();
		local v17 = p13:handleLavaMovement();
		if p13.isJumping then
			if v16 then
				p13.yVel = p13.yVel + 0.04;
			elseif v17 then
				p13.yVel = p13.yVel + 0.04;
			elseif p13.onGround then
				p13:jump();
			end;
		end;
		p13.moveStrafing = p13.moveStrafing * 0.98;
		p13.moveForward = p13.moveForward * 0.98;
		p13:moveEntityWithHeading(p13.moveStrafing, p13.moveForward);
		local v18 = math.sqrt(p13.xVel ^ 2 + p13.zVel ^ 2);
		local v19 = math.atan(-p13.yVel * 0.2) * 15;
		if v18 > 0.1 then
			v18 = 0.1;
		end;
		if not p13.onGround then
			v18 = 0;
		end;
		if p13.onGround then
			v19 = 0;
		end;
		p13.prevRenderMoveBobbing = p13.renderMoveBobbing;
		p13.prevRenderFallBobbing = p13.renderFallBobbing;
		p13.renderMoveBobbing = p13.renderMoveBobbing + (v18 - p13.renderMoveBobbing) * 0.4;
		p13.renderFallBobbing = p13.renderFallBobbing + (v19 - p13.renderFallBobbing) * 0.8;
	end;
	function v4.jump(p14)
		p14.yVel = 0.42;
	end;
	function v4.updatePlayerActionState(p15)

	end;
	function v4.getRemoteUpdatePayload(p16)
		local v20 = p1.getRemoteUpdatePayload(p16);
		v20.renderWalkTime = p16.renderWalkTime;
		v20.renderWalkDepth = p16.renderWalkDepth;
		v20.swingProgress = p16.swingProgress;
		return v20;
	end;
	function v4.processRemoteUpdatePayload(p17, p18)
		p1.processRemoteUpdatePayload(p17, p18);
		p17.renderWalkTime = p18.renderWalkTime;
		p17.renderLastWalkDepth = p17.renderWalkDepth;
		p17.renderWalkDepth = p18.renderWalkDepth;
		p17.prevSwingProgress = p17.swingProgress;
		p17.swingProgress = p18.swingProgress;
	end;
	return v4;
end);
