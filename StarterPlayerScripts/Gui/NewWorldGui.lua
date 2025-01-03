local l__ReplicatedStorage__1 = game:GetService("ReplicatedStorage");
local l__TweenService__2 = game:GetService("TweenService");
local l__LocalPlayer__3 = game:GetService("Players").LocalPlayer;
local l__PlayerGui__4 = l__LocalPlayer__3.PlayerGui;
local l__PlayerScripts__5 = l__LocalPlayer__3.PlayerScripts;
local u1 = require(l__ReplicatedStorage__1.Libs.Trim);
return function(p1)
	p1:registerView("NewWorld", {
		showMouse = true
	});
	local l__gui__6 = p1.views.NewWorld.gui;
	local v7 = { "Small", "Medium", "Large" };
	local v8 = { "Plains", "Forest", "Desert", "Ocean", "Island", "Flat" };
	l__gui__6.Options.WorldSize.TextLabel.Text = ("World size: %s"):format(v7[3]);
	local u2 = 3;
	l__gui__6.Options.WorldSize.Activated:Connect(function()
		u2 = u2 % #v7 + 1;
		l__gui__6.Options.WorldSize.TextLabel.Text = ("World size: %s"):format(v7[u2]);
	end);
	l__gui__6.Options.WorldType.TextLabel.Text = ("World type: %s"):format(v8[1]);
	local u3 = 1;
	l__gui__6.Options.WorldType.Activated:Connect(function()
		u3 = u3 % #v8 + 1;
		l__gui__6.Options.WorldType.TextLabel.Text = ("World type: %s"):format(v8[u3]);
	end);
	l__gui__6.Create.Activated:Connect(function()
		p1:navigateTo("Null");
		local v9 = l__gui__6.Options.WorldName.Input.TextBox.Text;
		if #u1(v9) < 1 then
			v9 = "My World";
		end;
		local v10, v11 = l__ReplicatedStorage__1.Remote.UserWorlds.CreateNewWorld:InvokeServer(v9, l__gui__6.Options.Seed.Input.TextBox.Text, v7[u2], v8[u3]);
		if not v10 then
			p1:navigateBack();
			p1.GenericMessageGui:show(("Error while creating new world: %s"):format(v11));
		end;
	end);
	l__gui__6.Back.Activated:Connect(function()
		p1:navigateBack();
	end);
	return {};
end;
