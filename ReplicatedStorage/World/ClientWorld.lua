local l__ReplicatedStorage__1 = game:GetService("ReplicatedStorage");
local l__RunService__2 = game:GetService("RunService");
local l__LocalPlayer__3 = game:GetService("Players").LocalPlayer;
local l__PlayerGui__4 = l__LocalPlayer__3.PlayerGui;
local l__PlayerScripts__5 = l__LocalPlayer__3.PlayerScripts;
local v6 = require(l__ReplicatedStorage__1.Libs.Class);
local v7 = require(l__ReplicatedStorage__1.Libs.Compress);
local v8 = require(l__ReplicatedStorage__1.Libs.Arrays);
local v9 = require(l__ReplicatedStorage__1.Libs.TWait);
local v10 = require(l__ReplicatedStorage__1.Libs.Listener);
local v11 = require(l__ReplicatedStorage__1.World);
local v12 = require(l__PlayerScripts__5.WorldRenderer);
local v13 = require(l__ReplicatedStorage__1.Block);
local v14 = require(l__ReplicatedStorage__1.Entity);
local u1 = nil;
local u2 = nil;
spawn(function()
	u1 = require(l__PlayerScripts__5.Camera);
	u2 = require(l__PlayerScripts__5.AudioEngine);
end);
local v15 = v6(v11);
function v15.constructor(p1, p2, p3)
	p1.blockRenderQueue = {};
	p1.blocksNeedRendering = false;
	p1.renderer = v12.new(p1, v10.new());
	p1.localPlayerEntity = p1:spawnPlayerEntity(p1.size / 2 + 0.5, p1.height, p1.size / 2 + 0.5);
	spawn(function()
		while l__RunService__2.RenderStepped:Wait() do
			if p1.blocksNeedRendering then
				p1.blocksNeedRendering = false;
				p1:doRender();
			end;		
		end;
	end);
	l__RunService__2.RenderStepped:Connect(function(p4)
		p1.renderer:renderTick(p4);
	end);
end;
function v11.spawnLocalEntity(p5, p6, p7, p8, p9, ...)
	local v16 = p6.new(p5, p7, p8, p9, ...);
	v16.isRemote = false;
	p5.entities[#p5.entities + 1] = v16;
	v16.addedToWorld = true;
	v16:onSpawn();
	p5.renderer:startRenderingEntity(v16);
	return v16;
end;
function v11.spawnPlayerEntity(p10, p11, p12, p13)
	local v17 = v14.player.new(p10, p11, p12, p13, l__LocalPlayer__3);
	v17.isRemote = false;
	v17.isReplicating = true;
	p10.entities[#p10.entities + 1] = v17;
	v17.addedToWorld = true;
	v17:onSpawn();
	p10.renderer:startRenderingEntity(v17);
	return v17;
end;
function v15.spawnReplicatedEntity(p14, p15, p16, p17, p18, p19, ...)
	local v18 = p15.new(p14, p17, p18, p19, ...);
	v18.uuid = p16;
	v18.isRemote = true;
	p14.entities[#p14.entities + 1] = v18;
	v18.addedToWorld = true;
	p14.renderer:startRenderingEntity(v18);
	return v18;
end;
function v15.setBlock(p20, p21, p22, p23, p24, p25)
	if p21 >= 1 and p22 >= 1 and p23 >= 1 and p21 <= p20.size and p22 <= p20.height and p23 <= p20.size then
		if p20.blocks[p21][p23][p22] == p24 then
			return;
		else
			p20.blocks[p21][p23][p22] = p24;
			if p25 ~= false then
				p20:renderBlock(p21, p22, p23);
				p20:renderBlock(p21 - 1, p22, p23);
				p20:renderBlock(p21 + 1, p22, p23);
				p20:renderBlock(p21, p22 - 1, p23);
				p20:renderBlock(p21, p22 + 1, p23);
				p20:renderBlock(p21, p22, p23 - 1);
				p20:renderBlock(p21, p22, p23 + 1);
			end;
			return;
		end;
	end;
end;
function v15.renderBlock(p26, p27, p28, p29)
	if p27 >= 1 and p28 >= 1 and p29 >= 1 and p27 <= p26.size and p28 <= p26.height and p29 <= p26.size then
		p26.blockRenderQueue[("%d_%d_%d"):format(p27, p28, p29)] = Vector3.new(p27, p28, p29);
		p26.blocksNeedRendering = true;
		return;
	end;
end;
function v15.doRandomDisplayTicks(p30, p31, p32, p33)
	p31 = math.floor(p31);
	p32 = math.floor(p32);
	p33 = math.floor(p33);
	for v19 = 1, 1000 do
		local v20 = p31 + math.random(-16, 16);
		local v21 = p32 + math.random(-16, 16);
		local v22 = p33 + math.random(-16, 16);
		v13.blocks[p30:getBlock(v20, v21, v22)]:onDisplayTick(p30, v20, v21, v22);
	end;
end;
function v15.update(p34, p35)
	if p34.updating then
		return false;
	end;
	p34.updating = true;
	p34:doRandomDisplayTicks(u1.x, u1.y, u1.z);
	local v23 = {};
	for v28, v29 in pairs(p34.entities) do
		if not v29.isRemote and v29.addedToWorld then
			v29:update();
		end;
		if v29.dead then
			p34.renderer:stopRenderingEntity(v29);
			if not v29.isRemote then
				v29:onDespawn();
			end;
			v23[v29] = true;
		elseif v29.addedToWorld and v29 == p34.localPlayerEntity then
			l__ReplicatedStorage__1.Remote.World.PlayerUpdated:FireServer(v29:getRemoteUpdatePayload());
		end;
	end;
	for v33, v34 in pairs(v23) do
		local v35 = nil;
		for v36, v37 in pairs(p34.entities) do
			if v33 == v37 then
				v35 = v36;
				break;
			end;
		end;
		if v35 then
			table.remove(p34.entities, v35);
		end;	
	end;
	p34.numTicks = p34.numTicks + 1;
	p34.lastTickTime = tick();
	p34.updating = false;
	return true;
end;
function v15.doRender(p36)
	if p36.rendering or p36.renderer.currentlyRendering then
		return;
	end;
	p36.rendering = true;
	p36.blockRenderQueue = {};
	local v38 = 0;
	for v39, v40 in pairs(p36.blockRenderQueue) do
		p36.renderer:doBlockRender(v40.x, v40.y, v40.z);
		v38 = v38 + 1;
	end;
	p36.rendering = false;
end;
function v15.playSoundAtPosition(p37, p38, p39, p40, p41, p42, p43)
	u2:playPositionalSound(u2:getSoundDataForName(p41), "Sound", p38, p39, p40, p42, p43);
end;
return v15;
