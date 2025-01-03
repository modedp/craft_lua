local l__TweenService__1 = game:GetService("TweenService");
local l__LocalPlayer__2 = game:GetService("Players").LocalPlayer;
local l__PlayerGui__3 = l__LocalPlayer__2.PlayerGui;
local l__PlayerScripts__4 = l__LocalPlayer__2.PlayerScripts;
local u1 = require(game:GetService("ReplicatedStorage").Libs.SyncEvent);
return function(p1)
	local v5 = {};
	p1:registerView("YesNo", {
		showMouse = true
	});
	local l__gui__6 = p1.views.YesNo.gui;
	v5.onChoiceMade = u1.new();
	l__gui__6.No.Activated:Connect(function()
		v5.onChoiceMade:fire(false);
	end);
	l__gui__6.Yes.Activated:Connect(function()
		v5.onChoiceMade:fire(true);
	end);
	function v5.show(p2, p3, p4, p5)
		if p4 == nil then
			p4 = "Yes";
		end;
		if p5 == nil then
			p5 = "No";
		end;
		l__gui__6.Message.Text = p3;
		l__gui__6.Yes.TextLabel.Text = p4;
		l__gui__6.No.TextLabel.Text = p5;
		p1:navigateTo("YesNo");
		local u2 = nil;
		local u3 = nil;
		u3 = p2.onChoiceMade:connect(function(p6)
			u2 = p6;
			u3:disconnect();
		end);
		while true do
			wait();
			if u2 ~= nil then
				break;
			end;		
		end;
		p1:navigateBack();
		return nil;
	end;
	return v5;
end;
