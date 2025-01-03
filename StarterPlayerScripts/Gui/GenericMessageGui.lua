local l__TweenService__1 = game:GetService("TweenService");
local l__LocalPlayer__2 = game:GetService("Players").LocalPlayer;
local l__PlayerGui__3 = l__LocalPlayer__2.PlayerGui;
local l__PlayerScripts__4 = l__LocalPlayer__2.PlayerScripts;
local v5 = require(game:GetService("ReplicatedStorage").Libs.SyncEvent);
return function(p1)
	local v6 = {};
	p1:registerView("GenericMessage", {
		showMouse = true
	});
	local l__gui__1 = p1.views.GenericMessage.gui;
	function v6.show(p2, p3, p4)
		if p4 == nil then
			p4 = "Back";
		end;
		l__gui__1.Message.Text = p3;
		l__gui__1.Back.TextLabel.Text = p4;
		p1:navigateTo("GenericMessage");
	end;
	l__gui__1.Back.Activated:Connect(function()
		p1:navigateBack();
	end);
	return v6;
end;
