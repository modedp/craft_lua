local v1 = nil;
local l__LocalPlayer__2 = game:GetService("Players").LocalPlayer;
v1 = l__LocalPlayer__2:WaitForChild("PlayerGui");
local l__PlayerScripts__3 = l__LocalPlayer__2:WaitForChild("PlayerScripts");
local l__StarterGui__4 = game:GetService("StarterGui");
local v5 = game:GetService("TeleportService"):GetArrivingTeleportGui();
if v5 then
	v5.Name = "StartupGui";
	v5.Enabled = true;
	v5.Parent = v1;
	spawn(function()
		while true do
			wait();
			if pcall(function()
				l__StarterGui__4:SetCore("TopbarEnabled", false);
			end) then
				break;
			end;		
		end;
	end);
	local v6 = Instance.new("BoolValue");
	v6.Name = "StartupAnimatorReady";
	v6.Value = true;
	v6.Parent = l__PlayerScripts__3;
	l__LocalPlayer__2:WaitForChild("PlayerScripts"):WaitForChild("ClientReady");
	while true do
		wait();
		if l__LocalPlayer__2.PlayerScripts.ClientReady.Value then
			break;
		end;	
	end;
	wait(1);
	v5:Destroy();
else
	local l__StartupGui__7 = script:WaitForChild("StartupGui");
	l__StartupGui__7.Parent = v1;
	l__StartupGui__7:WaitForChild("StartupAnimator").Disabled = false;
end;
game:GetService("ReplicatedFirst"):RemoveDefaultLoadingScreen();
