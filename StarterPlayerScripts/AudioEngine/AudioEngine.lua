--[[Parent above this script is StarterPlayerScripts]]
local l__LocalPlayer__1 = game:GetService("Players").LocalPlayer;
local l__PlayerGui__2 = l__LocalPlayer__1.PlayerGui;
local l__PlayerScripts__3 = l__LocalPlayer__1.PlayerScripts;
local v4 = {
	currentMusic = nil
};
local v5 = Instance.new("Folder");
v5.Name = "SoundObjects";
v5.Parent = workspace;
local u1 = require(script.Sounds);
function v4.getSoundDataForName(p1, p2)
	local v6 = u1;
	for v7, v8 in ipairs((string.split(p2, "."))) do
		v6 = v6[v8];
		if not v6 then
			return;
		end;
	end;
	if v6 ~= u1 and (not (not v6.assetid) or not (not v6.assetids)) then
		return v6;
	end;
	return nil;
end;
local l__SoundService__2 = game:GetService("SoundService");
function v4.playGlobalSound(p3, p4, p5)
	local v9 = Instance.new("Sound");
	v9.SoundId = "rbxassetid://" .. (p4.assetid or p4.assetids[math.random(#p4.assetids)]);
	v9.SoundGroup = l__SoundService__2["Group" .. p5];
	v9.Ended:Connect(function()
		wait(1);
		v9:Destroy();
	end);
	if p4.startAt then
		v9.TimePosition = p4.startAt;
	end;
	v9.Volume = 1;
	v9.Parent = v5;
	v9:Play();
	return v9;
end;
function v4.playPositionalSound(p6, p7, p8, p9, p10, p11, p12, p13)
	local v10 = Instance.new("Part");
	v10.Anchored = true;
	v10.CanCollide = false;
	v10.Locked = true;
	v10.Position = Vector3.new(p9 - 0.5, p10 - 0.5, p11 - 0.5) * 4;
	v10.Size = Vector3.new(0.05, 0.05, 0.05);
	v10.Transparency = 1;
	v10.Parent = v5;
	local v11 = p7;
	if p7.assetids then
		v11 = p7.assetids[math.random(#p7.assetids)];
	end;
	local v12 = Instance.new("Sound");
	v12.SoundId = "rbxassetid://" .. v11.assetid;
	v12.SoundGroup = l__SoundService__2["Group" .. p8];
	v12.Ended:Connect(function()
		wait(1);
		v12:Destroy();
	end);
	if v11.startAt then
		v12.TimePosition = v11.startAt;
	end;
	v12.Volume = p12;
	v12.PlaybackSpeed = p13;
	v12.Parent = v10;
	v12:Play();
	return v12;
end;
local u3 = require(l__PlayerScripts__3.Options);
local u4 = require(l__PlayerScripts__3.WorldLoader);
function v4.playMusic(p14, p15)
	if not (not v4.currentMusic) or not u3:getOption("musicEnabled") or not u4:isInGame() then
		return;
	end;
	local v13 = p14:playGlobalSound(p15, "Music");
	v13.Ended:Connect(function()
		v4.currentMusic = nil;
	end);
	v4.currentMusic = v13;
end;
function v4.stopMusic(p16)
	if not v4.currentMusic then
		return;
	end;
	v4.currentMusic:Stop();
	v4.currentMusic:Destroy();
	v4.currentMusic = nil;
end;
function v4.isMusicPlaying(p17)
	return v4.currentMusic ~= nil;
end;
function v4.init(p18)
	u3.optionChanged:connect(function(p19)
		if p19 == "musicEnabled" then
			local v14 = u3:getOption("musicEnabled");
			local v15 = nil
			if v14 then
				v15 = 1;
			else
				v15 = 0;
			end;
			l__SoundService__2.GroupMusic.Volume = v15;
			if not v14 and p18:isMusicPlaying() then
				p18:stopMusic();
				return;
			end;
		elseif p19 == "soundEnabled" then
			local v16 = nil
			if u3:getOption("soundEnabled") then
				v16 = 1;
			else
				v16 = 0;
			end;
			l__SoundService__2.GroupSound.Volume = v16;
		end;
	end);
	local v17 = nil
	if u3:getOption("musicEnabled") then
		v17 = 1;
	else
		v17 = 0;
	end;
	l__SoundService__2.GroupMusic.Volume = v17;
	local v18 = nil
	if u3:getOption("soundEnabled") then
		v18 = 1;
	else
		v18 = 0;
	end;
	l__SoundService__2.GroupSound.Volume = v18;
	spawn(function()
		local v19 = nil;
		while true do
			wait(2);
			if not (not u4:isInGame()) and not v4:isMusicPlaying() then
				local v20 = {};
				for v21, v22 in pairs(u1.music.calm) do
					if v22 ~= v19 then
						v20[#v20 + 1] = v22;
					end;
				end;
				local v23 = v20[math.random(#v20)];
				v19 = v23;
				v4:playMusic(v23);
				wait(math.random(300, 420));
			end;		
		end;
	end);
end;
return v4;
