local l__ReplicatedStorage__1 = game:GetService("ReplicatedStorage");
local l__LocalPlayer__2 = game:GetService("Players").LocalPlayer;
local l__PlayerGui__3 = l__LocalPlayer__2.PlayerGui;
local l__PlayerScripts__4 = l__LocalPlayer__2.PlayerScripts;
local v5 = {
	currentWorld = nil, 
	inGame = false
};
local u1 = require(l__PlayerScripts__4.ClientWorld);
local u2 = require(l__ReplicatedStorage__1.Entity);
local u3 = require(l__ReplicatedStorage__1.Libs.TWait);
function v5.loadServerWorld(p1, p2)
	if p1.currentWorld then
		return;
	end;
	local u4 = {};
	local v6 = l__ReplicatedStorage__1.Remote.World.OnBlockSet.OnClientEvent:Connect(function(...)
		u4[#u4 + 1] = { ... };
	end);
	p2:fire("step", "Connecting to world server...");
	local v7 = l__ReplicatedStorage__1.Remote.World.GetWorldInfo:InvokeServer();
	local v8 = u1.new(v7.seed, v7.size);
	p2:fire("step", "Downloading terrain...");
	spawn(function()
		l__ReplicatedStorage__1.Remote.World.DownloadWorld:FireServer();
	end);
	local v9, v10 = l__ReplicatedStorage__1.Remote.World.OnWorldDownload.OnClientEvent:Wait();
	v8.blocks = v9;
	for v11, v12 in pairs(v10) do
		v8:spawnReplicatedEntity(u2.entities[table.remove(v12, 1)], unpack(v12));
	end;
	l__PlayerScripts__4:WaitForChild("StartupAnimatorReady");
	while true do
		wait();
		if l__PlayerScripts__4.StartupAnimatorReady.Value then
			break;
		end;	
	end;
	p2:fire("step", "Building terrain...");
	v8.renderer.listener = p2;
	v8.renderer:doFullRender();
	v8.renderer:updateBoundsSize();
	l__ReplicatedStorage__1.Remote.World.OnBlockSet.OnClientEvent:Connect(function(...)
		v8:setBlock(...);
	end);
	p2:fire("step", "Simulating the world for a little bit");
	p2:fire("progress", -1);
	v6:Disconnect();
	for v13, v14 in pairs(u4) do
		v8:setBlock(unpack(v14));
		u3();
	end;
	p1.currentWorld = v8;
	l__ReplicatedStorage__1.Remote.World.PlayerSpawned:FireServer(v8.localPlayerEntity.uuid, v8.localPlayerEntity.x, v8.localPlayerEntity.y, v8.localPlayerEntity.z);
	return v8;
end;
function v5.isInGame(p3)
	local v15 = false;
	if p3.currentWorld ~= nil then
		v15 = v5.inGame;
	end;
	return v15;
end;
return v5;
