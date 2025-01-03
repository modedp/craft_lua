local l__ReplicatedStorage__1 = game:GetService("ReplicatedStorage");
local l__TeleportService__2 = game:GetService("TeleportService");
local l__LocalPlayer__3 = game:GetService("Players").LocalPlayer;
local l__PlayerGui__4 = l__LocalPlayer__3.PlayerGui;
local l__PlayerScripts__5 = l__LocalPlayer__3.PlayerScripts;
local v6 = require(l__ReplicatedStorage__1.Libs.SyncEvent);
local v7 = {};
local u1 = nil;
local u2 = {
	musicEnabled = true, 
	soundEnabled = true, 
	fancyGraphics = false, 
	viewBobbing = true, 
	renderDistance = 6
};
(function(p1)
	u1 = u2;
	for v8, v9 in pairs(p1) do
		u1[v8] = v9;
	end;
end)(l__TeleportService__2:GetTeleportSetting("GameOptions") or (l__ReplicatedStorage__1.Remote.Options.GetGameOptions:InvokeServer() or {}));
v7.optionChanged = v6.new();
function v7.setOption(p2, p3, p4)
	u1[p3] = p4;
	l__TeleportService__2:SetTeleportSetting("GameOptions", u1);
	l__ReplicatedStorage__1.Remote.Options.UpdateGameOptions:FireServer(u1);
	p2.optionChanged:fire(p3);
end;
function v7.getOption(p5, p6)
	return u1[p6];
end;
return v7;
