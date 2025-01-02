local l__ReplicatedStorage__1 = game:GetService("ReplicatedStorage");
local v2 = require(l__ReplicatedStorage__1.Libs.Class);
local v3 = require(l__ReplicatedStorage__1.Libs.AABB);
local v4 = require(l__ReplicatedStorage__1.Libs.UUID);
local u1 = nil;
spawn(function()
	u1 = require(l__ReplicatedStorage__1.Block);
end);
local v5 = v2();
v5.entities = {};
function v5.registerEntity(p1, p2)
	local v6 = require(p2)(v5);
	v6.entityID = p1;
	v5.entities[p1] = v6;
	return v6;
end;
function v5.constructor(p3, p4, p5, p6, p7)
	p3.world = p4;
	p3.addedToWorld = false;
	p3.isRemote = false;
	p3.isReplicating = false;
	p3.lastReplicateTime = 0;
	p3.uuid = v4();
	p3.x = p5;
	p3.y = p6;
	p3.z = p7;
	p3.yaw = 0;
	p3.renderYawOffset = 0;
	p3.pitch = 0;
	p3.prevX = p5;
	p3.prevY = p6;
	p3.prevZ = p7;
	p3.prevYaw = 0;
	p3.prevRenderYawOffset = 0;
	p3.prevPitch = 0;
	p3.xVel = 0;
	p3.yVel = 0;
	p3.zVel = 0;
	p3.onGround = false;
	p3.isCollidedHorz = false;
	p3.isCollidedVert = false;
	p3.isCollided = false;
	p3.inWater = false;
	p3.fallDistance = 0;
	p3.noClip = false;
	p3.isSneaking = false;
	p3.doSliding = true;
	p3.stepHeight = 0;
	p3.yOffset = 0;
	p3.ySize = 0;
	p3.prevYSize = 0;
	p3.dead = false;
	p3.entityWalks = true;
	p3.preventEntitySpawning = true;
	p3.renderDistanceWalked = 0;
	p3.nextStepDistance = 1;
	p3.renderMoveBobbing = 0;
	p3.renderFallBobbing = 0;
	p3.prevRenderDistanceWalked = 0;
	p3.prevRenderMoveBobbing = 0;
	p3.prevRenderFallBobbing = 0;
	p3.ticksExisted = 0;
	p3:onInit();
end;
function v5.getSize(p8)
	return 1;
end;
function v5.getHeight(p9)
	return 1;
end;
function v5.getCollisionBox(p10)
	local v7 = p10:getSize() / 2;
	p10.collisionBox = v3.new(p10.x - v7, p10.y - p10.yOffset, p10.z - v7, p10.x + v7, p10.y - p10.yOffset + p10:getHeight(), p10.z + v7);
	return p10.collisionBox;
end;
function v5.markDead(p11)
	p11.dead = true;
end;
function v5.kill(p12)
	p12:markDead();
end;
function v5.onInit(p13)

end;
function v5.onSpawn(p14)

end;
function v5.onDespawn(p15)

end;
function v5.update(p16)
	p16:onEntityUpdate();
end;
function v5.onEntityUpdate(p17)
	p17.ticksExisted = p17.ticksExisted + 1;
	p17.prevRenderDistanceWalked = p17.renderDistanceWalked;
	p17.prevX = p17.x;
	p17.prevY = p17.y;
	p17.prevYSize = p17.ySize;
	p17.prevZ = p17.z;
	p17.prevYaw = p17.yaw;
	p17.prevPitch = p17.pitch;
	if p17:handleWaterMovement() then
		if not p17.inWater then
			local v8 = math.sqrt(p17.xVel ^ 2 * 0.2 + p17.yVel ^ 2 + p17.zVel ^ 2 * 0.2) * 0.2;
			if v8 > 1 then
				v8 = 1;
			end;
			p17.world:playSoundAtEntity(p17, "random.splash", v8, 1 + (math.random() - math.random()) * 0.4);
			for v9 = 1, 1 + p17:getSize() * 20 do
				p17.world:spawnLocalEntity(v5.particleBubble, p17.x + (math.random() * 2 - 1) * p17:getSize(), math.floor(p17.y) + 1, p17.z + (math.random() * 2 - 1) * p17:getSize(), p17.xVel, p17.yVel - math.random() * 0.2, p17.zVel);
			end;
			for v10 = 1, 1 + p17:getSize() * 20 do
				p17.world:spawnLocalEntity(v5.particleSplash, p17.x + (math.random() * 2 - 1) * p17:getSize(), math.floor(p17.y) + 1, p17.z + (math.random() * 2 - 1) * p17:getSize(), p17.xVel, p17.yVel - math.random() * 0.2, p17.zVel);
			end;
			p17.fallDistance = 0;
			p17.inWater = true;
		end;
	else
		p17.inWater = false;
	end;
	if p17.y < -64 then
		p17:kill();
	end;
end;
function v5.handleWaterMovement(p18)
	local v11 = p18.world:isWaterInAABB(p18:getCollisionBox());
	if not v11 then
		p18.inWater = false;
	end;
	return v11;
end;
function v5.handleLavaMovement(p19)
	return p19.world:isLavaInAABB(p19:getCollisionBox());
end;
function v5.moveFlying(p20, p21, p22, p23)
	local v12 = math.sqrt(p21 ^ 2 + p22 ^ 2);
	if v12 < 0.01 then
		return;
	end;
	if v12 < 1 then
		v12 = 1;
	end;
	local v13 = p23 / v12;
	p21 = p21 * v13;
	p22 = p22 * v13;
	local v14 = math.sin(math.rad(p20.yaw));
	local v15 = math.cos(math.rad(p20.yaw));
	p20.xVel = p20.xVel + p21 * v15 - p22 * v14;
	p20.zVel = p20.zVel + p22 * v15 + p21 * v14;
end;
function v5.moveEntity(p24, p25, p26, p27)
	if p24.noClip then
		p24.x = p24.x + p25;
		p24.y = p24.y + p26;
		p24.z = p24.z + p27;
		return;
	end;
	local l__y__16 = p24.y;
	local v17 = p25;
	local v18 = p27;
	local v19 = p24:getCollisionBox();
	local v20 = v19:Clone();
	local v21 = p24.onGround and p24.isSneaking;
	if v21 then
		while p25 ~= 0 and #p24.world:getCollidingAABBs(p24, v19:Translate(p25, -1, 0)) == 0 do
			p24.xVel = 0;
			if p25 < 0.05 and p25 >= -0.05 then
				p25 = 0;
			elseif p25 > 0 then
				p25 = p25 - 0.05;
			else
				p25 = p25 + 0.05;
			end;
			v17 = p25;		
		end;
		while p27 ~= 0 and #p24.world:getCollidingAABBs(p24, v19:Translate(0, -1, p27)) == 0 do
			p24.zVel = 0;
			if p27 < 0.05 and p27 >= -0.05 then
				p27 = 0;
			elseif p27 > 0 then
				p27 = p27 - 0.05;
			else
				p27 = p27 + 0.05;
			end;
			v18 = p27;		
		end;
	end;
	local v22 = p24.world:getCollidingAABBs(p24, v19:DirectionalExpand(Vector3.new(p25, p26, p27)));
	for v23, v24 in ipairs(v22) do
		p26 = v24:CalculateYOffset(v19, p26);
	end;
	v19:Offset(0, p26, 0);
	if not p24.doSliding and p26 ~= p26 then
		p25 = 0;
		p26 = 0;
		p27 = 0;
	end;
	local v25 = false;
	if p26 ~= p26 then
		v25 = p26 < 0;
	end;
	for v26, v27 in ipairs(v22) do
		p25 = v27:CalculateXOffset(v19, p25);
	end;
	v19:Offset(p25, 0, 0);
	if not p24.doSliding and v17 ~= p25 then
		p25 = 0;
		p26 = 0;
		p27 = 0;
	end;
	for v28, v29 in ipairs(v22) do
		p27 = v29:CalculateZOffset(v19, p27);
	end;
	v19:Offset(0, 0, p27);
	if not p24.doSliding and v18 ~= p27 then
		p25 = 0;
		p26 = 0;
		p27 = 0;
	end;
	if p24.stepHeight > 0 and v25 and p24.ySize < 0.05 and (v17 ~= p25 or v18 ~= p27) then
		p25 = v17;
		p26 = p24.stepHeight;
		p27 = v18;
		local v30 = v19:Clone();
		local v31 = p24.world:getCollidingAABBs(p24, v20:DirectionalExpand(Vector3.new(p25, p26, p27)));
		for v32, v33 in ipairs(v31) do
			p26 = v33:CalculateYOffset(v20, p26);
		end;
		v20:Offset(0, p26, 0);
		if not p24.doSliding and p26 ~= p26 then
			p25 = 0;
			p26 = 0;
			p27 = 0;
		end;
		for v34, v35 in ipairs(v31) do
			p25 = v35:CalculateXOffset(v20, p25);
		end;
		v20:Offset(p25, 0, 0);
		if not p24.doSliding and v17 ~= p25 then
			p25 = 0;
			p26 = 0;
			p27 = 0;
		end;
		for v36, v37 in ipairs(v31) do
			p27 = v37:CalculateZOffset(v19, p27);
		end;
		v19:Offset(0, 0, p27);
		if not p24.doSliding and v18 ~= p27 then
			p25 = 0;
			p26 = 0;
			p27 = 0;
		end;
		if p25 ^ 2 + p27 ^ 2 <= p25 ^ 2 + p27 ^ 2 then
			p25 = p25;
			p26 = p26;
			p27 = p27;
			v19 = v30;
		else
			p24.ySize = p24.ySize + 0.5;
		end;
	end;
	p24.x = (v19.minX + v19.maxX) / 2;
	p24.y = v19.minY + p24.yOffset;
	p24.z = (v19.minZ + v19.maxZ) / 2;
	local v38 = true;
	if v17 == p25 then
		v38 = v18 ~= p27;
	end;
	p24.isCollidedHorz = v38;
	p24.isCollidedVert = p26 ~= p26;
	local v39 = false;
	if p26 ~= p26 then
		v39 = p26 < 0;
	end;
	p24.onGround = v39;
	p24.isCollided = p24.isCollidedHorz or p24.isCollidedVert;
	p24:updateFallState(p26, p24.onGround);
	if v17 ~= p25 then
		p24.xVel = 0;
	end;
	if p26 ~= p26 then
		p24.yVel = 0;
	end;
	if v18 ~= p27 then
		p24.zVel = 0;
	end;
	if p24.entityWalks and not v21 and p24.onGround then
		p24.renderDistanceWalked = p24.renderDistanceWalked + math.sqrt((p24.x - p24.x) ^ 2 + (p24.z - p24.z) ^ 2) * 0.6;
		local v40 = u1.blocks[p24.world:getBlock(math.floor(p24.x), math.floor(p24.y - 0.2 - p24.yOffset), (math.floor(p24.z)))];
		if math.floor(p24.renderDistanceWalked - 0.5) ~= math.floor(p24.prevRenderDistanceWalked - 0.5) and v40:isCollidable() then
			p24.nextStepDistance = p24.nextStepDistance + 1;
			local l__stepSound__41 = v40.stepSound;
		end;
	end;
	p24.ySize = p24.ySize * 0.4;
end;
function v5.updateFallState(p28, p29, p30)
	if p30 then
		if not (p28.fallDistance > 0) then
			return;
		end;
	else
		if p29 < 0 then
			p28.fallDistance = p28.fallDistance - p29;
		end;
		return;
	end;
	p28:onFall(p28.fallDistance);
	p28.fallDistance = 0;
end;
function v5.onFall(p31, p32)

end;
function v5.getEntityBrightness(p33)
	return 1;
end;
function v5.getLookVector(p34)
	local v42 = math.rad(p34.yaw);
	local v43 = math.rad(p34.pitch);
	local v44 = math.cos(v43);
	return Vector3.new(-math.sin(v42) * v44, -math.sin(v43), math.cos(v42) * v44);
end;
function v5.setPosition(p35, p36, p37, p38)
	p35.x = p36;
	p35.y = p37;
	p35.z = p38;
	p35.prevX = p36;
	p35.prevY = p37;
	p35.prevZ = p38;
end;
function v5.getSqDistanceTo(p39, p40, p41, p42)
	return (p39.x - p40) ^ 2 + (p39.y - p41) ^ 2 + (p39.z - p42) ^ 2;
end;
function v5.getDistanceTo(p43, p44, p45, p46)
	return math.sqrt(p43:getSqDistanceTo(p44, p45, p46));
end;
function v5.getRemoteUpdatePayload(p47)
	return {
		x = p47.x, 
		y = p47.y, 
		ySize = p47.ySize, 
		z = p47.z, 
		yaw = p47.yaw, 
		renderYawOffset = p47.renderYawOffset, 
		pitch = p47.pitch, 
		ticksExisted = p47.ticksExisted, 
		isSneaking = p47.isSneaking
	};
end;
function v5.processRemoteUpdatePayload(p48, p49)
	p48.lastReplicateTime = tick();
	p48.prevX = p48.x;
	p48.prevY = p48.y;
	p48.prevYSize = p48.ySize;
	p48.prevZ = p48.z;
	p48.prevYaw = p48.yaw;
	p48.prevPitch = p48.pitch;
	p48.prevRenderYawOffset = p48.renderYawOffset;
	p48.x = p49.x;
	p48.y = p49.y;
	p48.ySize = p49.ySize;
	p48.z = p49.z;
	p48.yaw = p49.yaw;
	p48.renderYawOffset = p49.renderYawOffset;
	p48.pitch = p49.pitch;
	p48.isSneaking = p49.isSneaking;
	p48.ticksExisted = p49.ticksExisted;
end;
v5.particleDig = v5.registerEntity(-1, script.EntityDiggingParticle);
v5.particleSplash = v5.registerEntity(-2, script.EntitySplashParticle);
v5.particleBubble = v5.registerEntity(-3, script.EntityBubbleParticle);
v5.particleWaterSuspend = v5.registerEntity(-4, script.EntityWaterSuspendParticle);
v5.fallingBlock = v5.registerEntity(2, script.EntityFallingBlock);
v5.player = v5.registerEntity(3, script.EntityPlayer);
return v5;
