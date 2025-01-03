--[[Parent of this script is WorldRenderer]]
local l__ServerScriptService__1 = game:GetService("ServerScriptService");
local l__ReplicatedStorage__2 = game:GetService("ReplicatedStorage");
local v3 = require(l__ReplicatedStorage__2.Block);
local v4 = require(l__ReplicatedStorage__2.Entity);
local v5 = require(game:GetService("Players").LocalPlayer.PlayerScripts.Flags);
local v6 = {};
local v7 = Instance.new("Folder");
v7.Name = "RenderedEntities";
v7.Parent = workspace;
v6.entityRendererMap = {};
function v6.register(p1, p2)
	local v8 = require(p2);
	v6.entityRendererMap[p1] = v8;
	return v8;
end;
function v6.createEntityModel(p3, p4)
	local v9 = Instance.new("Model");
	v9.Name = "RenderedEntity";
	p3.entityRendererMap[p4.entityID]:createEntityModel(p4, v9);
	v9.Parent = v7;
	return v9;
end;
local function u1(p5, p6, p7, p8, p9, p10, p11)
	return (p8 - p5) * p11 + p5, (p9 - p6) * p11 + p6, (p10 - p7) * p11 + p7;
end;
local function u2(p12, p13, p14)
	return (p13 - p12) * p14 + p12;
end;
function v6.updateEntityModel(p15, p16, p17)
	local v10 = nil
	if p16.isRemote then
		v10 = p16.lastReplicateTime;
	else
		v10 = p16.world.lastTickTime;
	end;
	local v11 = math.clamp((tick() - v10) / 0.05, 0, 1);
	local v12, v13, v14 = u1(p16.prevX, p16.prevY - p16.prevYSize, p16.prevZ, p16.x, p16.y - p16.ySize, p16.z, v11);
	local v15 = u2(p16.prevPitch, p16.pitch, v11);
	local v16 = u2(p16.prevYaw, p16.yaw, v11);
	p15.entityRendererMap[p16.entityID]:updateEntityModel(p16, CFrame.new(v12 * 4 - 2, v13 * 4 - 2, v14 * 4 - 2) * CFrame.Angles(0, math.pi - math.rad((u2(p16.prevRenderYawOffset, p16.renderYawOffset, v11))), 0), p17, v11);
	if p16 == p16.world.localPlayerEntity then
		p17.Parent = nil;
	end;
end;
function v6.destroyEntityModel(p18, p19, p20)
	p18.entityRendererMap[p19.entityID]:destroyEntityModel(p19, p20);
	p20:Destroy();
end;
v6.register(v4.particleDig.entityID, script.RenderParticle);
v6.register(v4.particleSplash.entityID, script.RenderParticle);
v6.register(v4.particleBubble.entityID, script.RenderParticle);
v6.register(v4.particleWaterSuspend.entityID, script.RenderParticle);
v6.register(v4.fallingBlock.entityID, script.RenderFallingBlock);
v6.register(v4.player.entityID, script.RenderPlayer);
return v6;
