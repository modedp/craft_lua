math.randomseed(tick());
local l__ReplicatedStorage__1 = game:GetService("ReplicatedStorage");
local v2 = require(l__ReplicatedStorage__1.Libs.Listener);
local v3 = require(l__ReplicatedStorage__1.Entity);
local l__RunService__4 = game:GetService("RunService");
local l__StarterPlayerScripts__5 = game:GetService("StarterPlayer").StarterPlayerScripts;
local l__LocalPlayer__6 = game:GetService("Players").LocalPlayer;
local l__PlayerGui__7 = l__LocalPlayer__6.PlayerGui;
local l__StarterGui__1 = game:GetService("StarterGui");
pcall(function()
	l__StarterGui__1:SetCore("ResetButtonCallback", false);
end);
local l__PlayerScripts__2 = l__LocalPlayer__6.PlayerScripts;
local u3 = function()
	return #l__PlayerScripts__2:GetDescendants() == #l__StarterPlayerScripts__5:GetDescendants();
end;
local u4 = Instance.new("BindableEvent");
local S = nil;
S = l__PlayerScripts__2.DescendantAdded:Connect(function()
	if u3() then
		u4:Fire();
		S:Disconnect();
	end;
end);
if not u3() then
	u4.Event:Wait();
end;
u4:Destroy();
local vf = require(l__PlayerScripts__2.Flags);
vf.initRemoteFlags(vf);
local vc = require(l__PlayerScripts__2.Camera);
local v8 = require(l__PlayerScripts__2.Controller);
local v9 = require(l__PlayerScripts__2.Gui);
local v10 = require(l__PlayerScripts__2.SkyRenderer);
local v11 = require(l__PlayerScripts__2.ClientWorld);
local v12 = require(l__PlayerScripts__2.AudioEngine);
local v13 = require(l__PlayerScripts__2.WorldLoader);
local v14 = Instance.new("BoolValue");
v14.Name = "ClientReady";
v14.Value = true;
v14.Parent = l__PlayerScripts__2;
local u5 = function()
	return not l__ReplicatedStorage__1.Remote.Loading.IsLoading.Value;
end;
local u6 = Instance.new("BindableEvent");
if not u5() then
	u6.Event:Wait();
end;
l__ReplicatedStorage__1.Remote.Loading.IsLoading.Changed:Connect(function()
	if u5() then
		u6:Fire();
	end;
end):Disconnect();
u6:Destroy();
local voc = v2.new();
voc.listen(voc, "step", function(p1)
	v9.GuiLoading:setStep(p1);
	print(p1);
end);
voc.listen(voc, "progress", function(p2)
	v9.GuiLoading:setProgress(p2);
end);
v9.GuiLoading.setProgress(v9.GuiLoading.setProgress, -1);
l__ReplicatedStorage__1.Remote.World.EntitySpawned.OnClientEvent:Connect(function(p3, p4, p5, p6, p7, ...)
	while true do
		wait();
		if v13.currentWorld then
			break;
		end;	
	end;
	if v13.currentWorld:getEntityByUUID(p4) then
		return;
	end;
	v13.currentWorld:spawnReplicatedEntity(v3.entities[p3], p4, p5, p6, p7, ...);
end);
l__ReplicatedStorage__1.Remote.World.EntityDespawned.OnClientEvent:Connect(function(p8)
	while true do
		wait();
		if v13.currentWorld then
			break;
		end;	
	end;
	local v15 = v13.currentWorld:getEntityByUUID(p8);
	if not v15 then
		return;
	end;
	v15.dead = true;
end);
l__ReplicatedStorage__1.Remote.World.EntityUpdated.OnClientEvent:Connect(function(p9, p10)
	while true do
		wait();
		if v13.currentWorld then
			break;
		end;	
	end;
	local v16 = v13.currentWorld:getEntityByUUID(p9);
	if not v16 then
		return;
	end;
	v16:processRemoteUpdatePayload(p10);
end);
v13.loadServerWorld(v13, voc);
v10.init(v10);
v12.init(v12);
vc.init(vc);
v8.init(v8);
spawn(function()
	l__RunService__4.Heartbeat:Connect(function()
		if not v13:isInGame() then
			return;
		end;
		v13.currentWorld.renderer:recalcVisibleChunks();
	end);
	local u7 = 0;
	local u8 = 0;
	l__RunService__4.Heartbeat:Connect(function(p11)
		if v13.currentWorld then
			u7 = u7 + p11;
			while u7 >= 0.05 do
				u7 = u7 - 0.05;
				v13.currentWorld:update();
				u8 = u8 + 1;			
			end;
		end;
	end);
end);
v9.GuiLoading.isLoading = false;
if v9.currentView == "Loading" then
	v9.setView(v9, "InGame");
	v9.showServerRules(v9);
end;
v8.setControllersEnabled(v8, true);
vc.lockToEntity = v13.currentWorld.localPlayerEntity;
pcall(function()
	local v17 = Instance.new("BindableEvent");
	v17.Event:Connect(function()
		v13.currentWorld.localPlayerEntity:setPosition(v13.currentWorld.size / 2 + 0.5, v13.currentWorld.height, v13.currentWorld.size / 2 + 0.5);
	end);
	l__StarterGui__1:SetCore("ResetButtonCallback", v17);
end);
