--[[Parent of this script is StarterPlayerScripts]]
local l__ReplicatedStorage__1 = game:GetService("ReplicatedStorage");
local l__LocalPlayer__2 = game:GetService("Players").LocalPlayer;
local l__PlayerGui__3 = l__LocalPlayer__2.PlayerGui;
local l__PlayerScripts__4 = l__LocalPlayer__2.PlayerScripts;
local v5 = require(l__ReplicatedStorage__1.Libs.Arrays);
local v6 = {};
local u1 = tick();
local function u2(p1, p2)
	local v7 = nil;
	local v8 = nil;
	p1 = p1 / 16;
	p2 = p2 / 16;
	v7 = 0;
	v8 = 0;
	local v9 = 1;
	for v10 = 1, 4 do
		local v11 = (1 / v9 - 1) * 0.5 + 1;
		v7 = v7 + math.noise(p1 * v9, p2 * v9, (v10 + u1) % 500) * v11;
		v8 = v8 + v11;
		v9 = v9 * 2;
	end;
	return v8 / v7 - 0.075; --[[Unsure Cloud Mechanic]]
end;
local u3 = v5.new(256, 256);
local u4 = require(l__ReplicatedStorage__1.Libs.TWait);
local u5 = v5.new(256, 256);
local l__RunService__6 = game:GetService("RunService");
local u7 = require(l__PlayerScripts__4.Options);
function v6.initClouds(p3)
	local l__Clouds__14 = script.Clouds;
	l__Clouds__14.Parent = nil;
	l__Clouds__14.Size = Vector3.new(40, 0.05, 40);
	local l__Cloud__15 = l__Clouds__14.Cloud;
	l__Cloud__15.Size = Vector3.new(20, 0, 20);
	l__Cloud__15.Parent = nil;
	for v16 = 1, 256 do
		for v17 = 1, 256 do
			local v18 = u2(v16, v17);
			local v19 = u2(v16 - 256, v17);
			local v20 = u2(v16, v17 - 256);
			local v21 = u2(v16 - 256, v17 - 256);
			local v22 = v16 / 256;
			local v23 = (v19 - v18) * v22 + v18;
			u3[v16][v17] = ((v21 - v20) * v22 + v20 - v23) * (v17 / 256) + v23;
			if v17 % 50 == 1 then
				u4();
			end;
		end;
	end;
	for v24 = 1, 100 do
		for v25 = 1, 100 do
			local v26 = l__Cloud__15:Clone();
			v26.SizeRelativeOffset = Vector3.new(v24 - 1, 0, v25 - 1);
			v26.Adornee = l__Clouds__14;
			v26.Parent = l__Clouds__14;
			u5[v24][v25] = v26;
			if v25 % 50 == 1 then
				u4();
			end;
		end;
	end;
	local u8 = 0;
	local u9 = 0;
	local u10 = 0;
	local u11 = 0;
	l__RunService__6.Heartbeat:Connect(function(p4)
		u8 = u8 + p4 * 2 / 20;
		if not (u7:getOption("renderDistance") > 4) then
			l__Clouds__14.Parent = script;
			return;
		end;
		local l__Position__27 = workspace.CurrentCamera.CFrame.Position;
		local v28 = math.floor(l__Position__27.X / 20);
		local v29 = math.floor(l__Position__27.Z / 20);
		if v28 ~= u9 or v29 ~= u10 or math.floor(u11) ~= math.floor(u8) then
			for v30 = 1, 100 do
				for v31 = 1, 100 do
					local v32 = nil;
					v32 = u5[v30][v31];
					if u3[(v30 + v28 - math.floor(u8) - 1) % 256 + 1][(v31 + v29 - 1) % 256 + 1] > 0 then
						v32.Visible = true;
					else
						v32.Visible = false;
					end;
				end;
			end;
			u9 = v28;
			u10 = v29;
			u11 = u8;
		end;
		l__Clouds__14.CFrame = CFrame.new((u8 % 1 + v28 - 50 - 0.5) * 20, 272, (v29 - 50 - 0.5) * 20);
		l__Clouds__14.Parent = workspace.CurrentCamera;
	end);
end;
v6.topFadeColor = Color3.fromRGB(141, 179, 255);
local l__Lighting__12 = game:GetService("Lighting");
local u13 = require(l__PlayerScripts__4.WorldLoader);
local u14 = require(l__PlayerScripts__4.Camera);
local u15 = require(l__ReplicatedStorage__1.Block);
function v6.initBackground(p5)
	local l__Skysphere__16 = script.Skysphere;
	local l__TopFade__17 = script.TopFade;
	l__RunService__6.RenderStepped:Connect(function(p6)
		local v33 = u7:getOption("renderDistance");
		l__Lighting__12.GlobalShadows = u7:getOption("fancyGraphics") == true;
		local v34 = false;
		local v35 = false;
		if u13.currentWorld then
			local v36 = u13.currentWorld:getBlock(u14.blockX, u14.blockY, u14.blockZ);
			if v36 == u15.water.blockID or v36 == u15.waterMoving.blockID then
				v34 = true;
			elseif v36 == u15.lava.blockID or v36 == u15.lavaMoving.blockID then
				v35 = true;
			end;
		end;
		if v34 then
			l__Lighting__12.FogColor = Color3.fromRGB(7, 14, 66);
			l__Lighting__12.FogStart = 0;
			l__Lighting__12.FogEnd = 100;
		elseif v35 then
			l__Lighting__12.FogColor = Color3.fromRGB(63, 7, 7);
			l__Lighting__12.FogStart = 0;
			l__Lighting__12.FogEnd = 15;
		else
			l__Lighting__12.FogColor = Color3.fromRGB(182, 208, 255);
			l__Lighting__12.FogStart = v33 * 16 * 2;
			l__Lighting__12.FogEnd = v33 * 16 * 4;
		end;
		local l__Position__37 = workspace.CurrentCamera.CFrame.Position;
		l__Skysphere__16.CFrame = CFrame.new(l__Position__37);
		l__Skysphere__16.Parent = workspace.CurrentCamera;
		if not (v33 > 4) then
			l__TopFade__17.Parent = nil;
			return;
		end;
		local v38 = l__Position__37 + Vector3.new(0, 144, 0);
		if v38.Y < 274 then
			v38 = v38 * Vector3.new(1, 0, 1) + Vector3.new(0, 274, 0);
		end;
		l__TopFade__17.CFrame = CFrame.new(v38);
		l__TopFade__17.Plane.Color3 = p5.topFadeColor;
		l__TopFade__17.Parent = workspace.CurrentCamera;
	end);
end;
function v6.init(p7)
	v6:initClouds();
	v6:initBackground();
end;
return v6;
