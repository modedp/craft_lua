--[[Parent of this script is Gui]]
local l__LocalPlayer__1 = game:GetService("Players").LocalPlayer;
local l__PlayerGui__2 = l__LocalPlayer__1.PlayerGui;
local l__PlayerScripts__3 = l__LocalPlayer__1.PlayerScripts;
local u1 = require(l__PlayerScripts__3.AudioEngine.Sounds);
local u2 = require(l__PlayerScripts__3.WorldLoader);
local l__RunService__3 = game:GetService("RunService");
local l__ReplicatedStorage__4 = game:GetService("ReplicatedStorage");
return function(p1)
	local v4 = {};
	p1:registerView("Credits", {
		showMouse = true
	});
	p1:registerView("CreditsAudioLicenses", {
		showMouse = true
	});
	p1:registerView("CreditsEarlyPlayers", {
		showMouse = true
	});
	local l__gui__5 = p1.views.Credits.gui;
	l__gui__5.Back.Activated:Connect(function()
		p1:navigateBack();
	end);
	l__gui__5.AudioLicenses.Activated:Connect(function()
		p1:navigateTo("CreditsAudioLicenses");
	end);
	l__gui__5.EarlyPlayers.Activated:Connect(function()
		p1:navigateTo("CreditsEarlyPlayers");
	end);
	local l__gui__5 = p1.views.CreditsAudioLicenses.gui;
	function v4.initAudioLicenses(p2)
		local l__LicenseList__6 = l__gui__5.Scroll.Content.LicenseList;
		local l__License__7 = l__LicenseList__6.License;
		l__License__7.Parent = nil;
		local function u6(p3, p4)
			local v8 = l__License__7:Clone();
			v8.Name = p4;
			v8.SoundName.Text = p4;
			v8.License.Text = p3.license.desc;
			v8.Source.Text = p3.license.source;
			v8.Parent = l__LicenseList__6;
		end;
		local function u7(p5, p6)
			if p5.assetid or p5.assetids then
				u6(p5, p6);
				return;
			end;
			for v9, v10 in pairs(p5) do
				u7(v10, p6 == nil and v9 or p6 .. "." .. v9);
			end;
		end;
		u7(u1);
		l__License__7:Destroy();
		l__LicenseList__6.Parent.CanvasSize = UDim2.new(0, 0, 0, l__LicenseList__6.UIListLayout.AbsoluteContentSize.Y + 64);
	end;
	v4:initAudioLicenses();
	p1.views.CreditsAudioLicenses.onShown:connect(function()
		local v11 = nil
		if u2:isInGame() then
			v11 = 1;
		else
			v11 = 0;
		end;
		l__gui__5.Scroll.Content.Back.ImageTransparency = v11;
	end);
	l__gui__5.Back.Activated:Connect(function()
		p1:navigateBack();
	end);
	local l__gui__8 = p1.views.CreditsEarlyPlayers.gui;
	local u9 = {};
	p1.views.CreditsEarlyPlayers.onShown:connect(function()
		local v12 = nil;
		if u2:isInGame() then
			v12 = 1;
		else
			v12 = 0;
		end;
		l__gui__8.Scroll.Content.Back.ImageTransparency = v12;
		l__gui__8.Scroll.EmptyMessage.Visible = true;
		spawn(function()
			local u10 = nil;
			local u11 = nil;
			local u12 = nil;
			local u13 = nil;
			u10 = l__RunService__3.RenderStepped:Connect(function()
				if not p1.views.CreditsEarlyPlayers.visible then
					u10:Disconnect();
					return;
				end;
				local v13 = l__gui__8.Scroll.Content.CanvasPosition.Y - 400;
				local v14 = l__gui__8.Scroll.Content.AbsoluteWindowSize.Y + 800;
				if u11 ~= v13 or u12 ~= v14 or #u9 ~= u13 then
					u11 = v13;
					u12 = v14;
					u13 = #u9;
					for v15 = 1, #u9 do
						local v16 = u9[v15];
						local v17 = false;
						local v18 = (v15 - 1) * 32 + 16;
						if v13 <= v18 + 32 and v18 <= v13 + v14 then
							v17 = true;
						end;
						if v17 and v16.actual == nil then
							v16.actual = v16.template:Clone();
							v16.actual.Parent = l__gui__8.Scroll.Content.PlayerList;
						elseif not v17 and v16.actual ~= nil then
							v16.actual:Destroy();
							v16.actual = nil;
						end;
					end;
				end;
			end);
		end);
		spawn(function()
			local v19 = l__ReplicatedStorage__4.Remote.Credits.GetEarlyPlayers:InvokeServer():split("\n");
			l__gui__8.Scroll.Content.CanvasSize = UDim2.new(0, 0, 0, #v19 * 32 + 16);
			for v20, v21 in ipairs(v19) do
				if not p1.views.CreditsEarlyPlayers.visible then
					break;
				end;
				l__gui__8.Scroll.EmptyMessage.Visible = false;
				local v22 = script.PlayerEntry:Clone();
				v22.Text = v21;
				v22.Position = UDim2.new(0, 0, 0, (v20 - 1) * 32);
				u9[v20] = {
					template = v22
				};
				if v20 % 25 == 0 then
					wait();
				end;
			end;
		end);
	end);
	p1.views.CreditsEarlyPlayers.onHidden:connect(function()
		for v23, v24 in ipairs(u9) do
			if v24.actual then
				v24.actual:Destroy();
			end;
			v24.template:Destroy();
		end;
		u9 = {};
		l__gui__8.Scroll.EmptyMessage.Visible = true;
	end);
	l__gui__8.Back.Activated:Connect(function()
		p1:navigateBack();
	end);
	return v4;
end;
