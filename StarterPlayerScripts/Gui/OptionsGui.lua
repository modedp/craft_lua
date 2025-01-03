local l__ReplicatedStorage__1 = game:GetService("ReplicatedStorage");
local l__LocalPlayer__2 = game:GetService("Players").LocalPlayer;
local l__PlayerGui__3 = l__LocalPlayer__2.PlayerGui;
local l__PlayerScripts__4 = l__LocalPlayer__2.PlayerScripts;
local v5 = require(l__PlayerScripts__4.Flags);
local u1 = require(l__PlayerScripts__4.Options);
local u2 = {
	[2] = "Tiny", 
	[4] = "Short", 
	[6] = "Normal", 
	[15] = "Far"
};
local u3 = { 2, 4, 6, 15 };
return function(p1)
	p1:registerView("Options", {
		showMouse = true
	});
	local l__gui__6 = p1.views.Options.gui;
	local v7 = nil
	if u1:getOption("musicEnabled") then
		v7 = "ON";
	else
		v7 = "OFF";
	end;
	l__gui__6.Music.TextLabel.Text = ("Music: %s"):format(v7);
	l__gui__6.Music.Activated:Connect(function()
		u1:setOption("musicEnabled", not u1:getOption("musicEnabled"));
		local v8 = nil
		if u1:getOption("musicEnabled") then
			 v8 = "ON";
		else
			v8 = "OFF";
		end;
		l__gui__6.Music.TextLabel.Text = ("Music: %s"):format(v8);
	end);
	local v9 = nil
	if u1:getOption("soundEnabled") then
		v9 = "ON";
	else
		v9 = "OFF";
	end;
	l__gui__6.Sound.TextLabel.Text = ("Sound: %s"):format(v9);
	l__gui__6.Sound.Activated:Connect(function()
		local v10 = nil
		u1:setOption("soundEnabled", not u1:getOption("soundEnabled"));
		if u1:getOption("soundEnabled") then
			v10 = "ON";
		else
			v10 = "OFF";
		end;
		l__gui__6.Sound.TextLabel.Text = ("Sound: %s"):format(v10);
	end);
	local v11 = nil
	if u1:getOption("fancyGraphics") then
		v11 = "Fancy";
	else
		v11 = "Fast";
	end;
	l__gui__6.Graphics.TextLabel.Text = ("Graphics: %s"):format(v11);
	l__gui__6.Graphics.Activated:Connect(function()
		u1:setOption("fancyGraphics", not u1:getOption("fancyGraphics"));
		local v12 = nil
		if u1:getOption("fancyGraphics") then
			v12 = "Fancy";
		else
			v12 = "Fast";
		end;
		l__gui__6.Graphics.TextLabel.Text = ("Graphics: %s"):format(v12);
	end);
	l__gui__6.RenderDistance.TextLabel.Text = ("Render Distance: %s"):format(u2[u1:getOption("renderDistance")]);
	l__gui__6.RenderDistance.Activated:Connect(function()
		local v13 = u1:getOption("renderDistance");
		local v14 = #u3;
		for v15, v16 in pairs(u3) do
			if v13 == v16 then
				v14 = v15;
			end;
		end;
		u1:setOption("renderDistance", u3[v14 % #u3 + 1]);
		l__gui__6.RenderDistance.TextLabel.Text = ("Render Distance: %s"):format(u2[u1:getOption("renderDistance")]);
	end);
	local v17 = nil
	if u1:getOption("viewBobbing") then
		v17 = "ON";
	else
		v17 = "OFF";
	end;
	l__gui__6.ViewBobbing.TextLabel.Text = ("View Bobbing: %s"):format(v17);
	l__gui__6.ViewBobbing.Activated:Connect(function()
		local v18 = nil
		u1:setOption("viewBobbing", not u1:getOption("viewBobbing"));
		if u1:getOption("viewBobbing") then
			v18 = "ON";
		else
			v18 = "OFF";
		end;
		l__gui__6.ViewBobbing.TextLabel.Text = ("View Bobbing: %s"):format(v18);
	end);
	l__gui__6.Done.Activated:Connect(function()
		p1:navigateBack();
	end);
	return {};
end;
