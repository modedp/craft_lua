--[[Parent of this script is Gui]]
local l__TweenService__1 = game:GetService("TweenService");
local l__Players__2 = game:GetService("Players");
local l__LocalPlayer__3 = l__Players__2.LocalPlayer;
local l__PlayerGui__4 = l__LocalPlayer__3.PlayerGui;
local u1 = require(l__LocalPlayer__3.PlayerScripts.WorldLoader);
local l__ReplicatedStorage__2 = game:GetService("ReplicatedStorage");
return function(p1)
	p1:registerView("MyWorlds", {
		showMouse = true
	});
	local l__gui__3 = p1.views.MyWorlds.gui;
	p1.views.MyWorlds.onShown:connect(function()
		local v5 = nil
		if u1:isInGame() then
			v5 = 1;
		else
			v5 = 0;
		end;
		l__gui__3.WorldList.Content.Back.ImageTransparency = v5;
	end);
	local u4 = nil;
	local u5 = nil;
	local u6 = {};
	local function v6(p2)
		if u5 then
			u6[u5].BackgroundTransparency = 1;
		end;
		u5 = p2;
		if not p2 then
			l__gui__3.PlayWorld.ImageRectOffset = Vector2.new(20, 0);
			l__gui__3.PlayWorld.TextLabel.TextColor3 = Color3.new(0.5, 0.5, 0.5);
			l__gui__3.DeleteWorld.ImageRectOffset = Vector2.new(20, 0);
			l__gui__3.DeleteWorld.TextLabel.TextColor3 = Color3.new(0.5, 0.5, 0.5);
			return;
		end;
		u6[p2].BackgroundTransparency = 0;
		l__gui__3.PlayWorld.ImageRectOffset = Vector2.new(0, 0);
		l__gui__3.PlayWorld.TextLabel.TextColor3 = Color3.new(1, 1, 1);
		l__gui__3.DeleteWorld.ImageRectOffset = Vector2.new(0, 0);
		l__gui__3.DeleteWorld.TextLabel.TextColor3 = Color3.new(1, 1, 1);
	end;
	v6(nil);
	local u7 = nil;
	local function u8(p3)
		if u6[p3.id] then
			return;
		end;
		local v7 = script.WorldEntry:Clone();
		v7.LayoutOrder = -(p3.lastPlayTime and 0);
		v7.WorldName.Text = p3.name;
		v7.WorldPlayers.Text = "Retrieving info...";
		spawn(function()
			local v8 = nil
			if p3.owner == l__Players__2.LocalPlayer.UserId then
				v8 = "you";
			else
				v8 = l__Players__2:GetNameFromUserIdAsync(p3.owner);
			end;
			if #p3.invited == 0 then
				v7.WorldPlayers.Text = ("Owned by %s"):format(v8);
			else
				v7.WorldPlayers.Text = ("Owned by %s\nRetrieving invites..."):format(v8);
			end;
			local v9 = "";
			for v10, v11 in ipairs(p3.invited) do
				if v10 > 1 then
					v9 = v9 .. ", ";
				end;
				v9 = v9 .. l__Players__2:GetNameFromUserIdAsync(v11);
				v7.WorldPlayers.Text = ("Owned by %s\nInvited players: %s"):format(v8, v9);
			end;
		end);
		v7.Activated:Connect(function()
			v6(p3.id);
		end);
		u6[p3.id] = v7;
		v7.Parent = l__gui__3.WorldList.Content.Worlds;
		l__gui__3.WorldList.EmptyMessage.Visible = false;
	end;
	local function u9(p4)
		v6(nil);
		for v12, v13 in pairs(u6) do
			v13:Destroy();
		end;
		u6 = {};
		l__gui__3.NewWorld.ImageRectOffset = Vector2.new(20, 0);
		l__gui__3.NewWorld.TextLabel.TextColor3 = Color3.new(0.5, 0.5, 0.5);
		l__gui__3.WorldList.EmptyMessage.Visible = false;
		l__gui__3.WorldList.LoadingMessage.Visible = true;
		spawn(function()
			if p4 ~= false then
				u4 = l__ReplicatedStorage__2.Remote.UserWorlds.GetWorldList:InvokeServer();
				u7 = l__ReplicatedStorage__2.Remote.UserWorlds.GetOwnedWorldLimit:InvokeServer();
			end;
			l__gui__3.WorldList.LoadingMessage.Visible = false;
			l__gui__3.NewWorld.ImageRectOffset = Vector2.new(0, 0);
			l__gui__3.NewWorld.TextLabel.TextColor3 = Color3.new(1, 1, 1);
			if not u4 or #u4 == 0 then
				l__gui__3.WorldList.EmptyMessage.Visible = true;
			end;
			for v14, v15 in pairs(u4) do
				u8(v15);
			end;
		end);
	end;
	p1.views.MyWorlds.onShown:connect(function()
		u9(true);
	end);
	local function u10()
		if not u4 then
			return 0;
		end;
		local v16 = 0;
		for v17, v18 in pairs(u4) do
			if v18.owner == l__Players__2.LocalPlayer.UserId then
				v16 = v16 + 1;
			end;
		end;
		return v16;
	end;
	l__gui__3.NewWorld.Activated:Connect(function()
		if not u4 then
			return;
		end;
		if u7 <= u10() then
			if not p1.YesNoGui:show(("You've reached your world limit of %d world(s).\n\nWould you like to buy space for another world?\nThis will raise your world limit permanently."):format(u7)) then
				return;
			end;
			p1:navigateTo("Null");
			local v19 = l__ReplicatedStorage__2.Remote.Shop.PromptBuyWithResult:InvokeServer("extraWorld");
			p1:navigateBack();
			if not v19 then
				return;
			end;
		else
			p1:navigateTo("NewWorld");
			return;
		end;
		p1:navigateTo("NewWorld");
	end);
	l__gui__3.DeleteWorld.Activated:Connect(function()
		if not u4 then
			return;
		end;
		if not u5 then
			return;
		end;
		local v20 = u4[u5];
		if v20.owner == l__Players__2.LocalPlayer.UserId then
			if not p1.YesNoGui:show(("Are you sure you want to delete '%s'?\n\nSince you own the world, this will delete all world data forever (a long time!)\nThis will also delete the world for any invited players."):format(v20.name)) then
				return;
			end;
		elseif not p1.YesNoGui:show(("Are you sure you want to delete '%s'?\n\nThis will remove the world from your world list.\nTo rejoin, you'll need to get a new invite from the world owner."):format(v20.name)) then
			return;
		end;
		p1:navigateTo("Null");
		local v21, v22 = l__ReplicatedStorage__2.Remote.UserWorlds.DeleteWorld:InvokeServer(v20.id);
		p1:navigateBack();
		if not v21 then
			p1.GenericMessageGui:show("Error while deleting world;\n" .. v22, "Back");
		end;
	end);
	l__gui__3.PlayWorld.Activated:Connect(function()
		if not u4 then
			return;
		end;
		if not u5 then
			return;
		end;
		p1:navigateTo("Null");
		local v23, v24 = l__ReplicatedStorage__2.Remote.UserWorlds.JoinWorld:InvokeServer(u5);
		if not v23 then
			p1:navigateBack();
			if v24 ~= "You're already in this world" then
				p1.GenericMessageGui:show("Error while joining world;\n" .. v24, "Back");
				return;
			end;
		else
			return;
		end;
		p1:navigateTo("InGame");
	end);
	l__gui__3.WorldInvites.Activated:Connect(function()
		p1:navigateTo("WorldInvites");
	end);
	l__gui__3.Back.Activated:Connect(function()
		p1:navigateBack();
	end);
	return {};
end;
