local l__TweenService__1 = game:GetService("TweenService");
local l__LocalPlayer__2 = game:GetService("Players").LocalPlayer;
local l__PlayerGui__3 = l__LocalPlayer__2.PlayerGui;
local l__PlayerScripts__4 = l__LocalPlayer__2.PlayerScripts;
local v5 = require(game:GetService("ReplicatedStorage").Libs.SyncEvent);
return function(p1)
	p1:registerView("Null", {
		showMouse = true
	});
	return {};
end;
