local l__ReplicatedStorage__1 = game:GetService("ReplicatedStorage");
local l__LocalPlayer__2 = game:GetService("Players").LocalPlayer;
local l__PlayerGui__3 = l__LocalPlayer__2.PlayerGui;
local u1 = require(l__LocalPlayer__2.PlayerScripts.Flags);
return function(p1)
	p1:registerView("PauseMenu", {
		showMouse = true
	});
	local l__gui__2 = p1.views.PauseMenu.gui;
	p1.views.PauseMenu.onShown:connect(function()
		if u1.isUserWorld and u1.userWorldOwner == l__LocalPlayer__2.UserId then
			l__gui__2.Menu.InviteToWorld.ImageRectOffset = Vector2.new(0, 0);
			l__gui__2.Menu.InviteToWorld.TextLabel.TextColor3 = Color3.new(1, 1, 1);
			return;
		end;
		l__gui__2.Menu.InviteToWorld.ImageRectOffset = Vector2.new(20, 0);
		l__gui__2.Menu.InviteToWorld.TextLabel.TextColor3 = Color3.new(0.5, 0.5, 0.5);
	end);
	l__gui__2.Menu.BackToGame.Activated:Connect(function()
		p1:navigateBack();
	end);
	l__gui__2.Menu.Quit.Activated:Connect(function()
		p1:navigateTo("MainMenu");
	end);
	l__gui__2.Menu.Options.Activated:Connect(function()
		p1:navigateTo("Options");
	end);
	l__gui__2.Menu.InviteToWorld.Activated:Connect(function()
		if u1.isUserWorld and u1.userWorldOwner == l__LocalPlayer__2.UserId then
			p1:navigateTo("InviteToWorld");
		end;
	end);
	return {};
end;
