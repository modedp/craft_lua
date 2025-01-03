--[[Parent of this script is Gui]]
local l__TweenService__1 = game:GetService("TweenService");
local l__Players__2 = game:GetService("Players");
local l__LocalPlayer__3 = l__Players__2.LocalPlayer;
local l__PlayerGui__4 = l__LocalPlayer__3.PlayerGui;
local u1 = require(l__LocalPlayer__3.PlayerScripts.WorldLoader);
local l__ReplicatedStorage__2 = game:GetService("ReplicatedStorage");
return function(p1)
	p1:registerView("WorldInvites", {
		showMouse = true
	});
	local l__gui__3 = p1.views.WorldInvites.gui;
	p1.views.WorldInvites.onShown:connect(function()
		local v5 = nil
		if u1:isInGame() then
			v5 = 1;
		else
			v5 = 0;
		end;
		l__gui__3.WorldList.Content.Back.ImageTransparency = v5;
	end);
	local u4 = nil;
	local u5 = {};
	local function v6(p2)
		if u4 then
			u5[u4].BackgroundTransparency = 1;
		end;
		u4 = p2;
		if not p2 then
			l__gui__3.PlayWorld.ImageRectOffset = Vector2.new(20, 0);
			l__gui__3.PlayWorld.TextLabel.TextColor3 = Color3.new(0.5, 0.5, 0.5);
			l__gui__3.IgnoreInvite.ImageRectOffset = Vector2.new(20, 0);
			l__gui__3.IgnoreInvite.TextLabel.TextColor3 = Color3.new(0.5, 0.5, 0.5);
			l__gui__3.AddToWorldList.ImageRectOffset = Vector2.new(20, 0);
			l__gui__3.AddToWorldList.TextLabel.TextColor3 = Color3.new(0.5, 0.5, 0.5);
			return;
		end;
		u5[p2].BackgroundTransparency = 0;
		l__gui__3.PlayWorld.ImageRectOffset = Vector2.new(0, 0);
		l__gui__3.PlayWorld.TextLabel.TextColor3 = Color3.new(1, 1, 1);
		l__gui__3.IgnoreInvite.ImageRectOffset = Vector2.new(0, 0);
		l__gui__3.IgnoreInvite.TextLabel.TextColor3 = Color3.new(1, 1, 1);
		l__gui__3.AddToWorldList.ImageRectOffset = Vector2.new(0, 0);
		l__gui__3.AddToWorldList.TextLabel.TextColor3 = Color3.new(1, 1, 1);
	end;
	v6(nil);
	local u6 = nil;
	local function u7(p3)
		if u5[p3.id] then
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
		u5[p3.id] = v7;
		v7.Parent = l__gui__3.WorldList.Content.Worlds;
		l__gui__3.WorldList.EmptyMessage.Visible = false;
	end;
	local function u8(p4)
		v6(nil);
		for v12, v13 in pairs(u5) do
			v13:Destroy();
		end;
		u5 = {};
		l__gui__3.WorldList.EmptyMessage.Visible = false;
		l__gui__3.WorldList.LoadingMessage.Visible = true;
		spawn(function()
			if p4 ~= false then
				u6 = l__ReplicatedStorage__2.Remote.UserWorlds.GetWorldInvites:InvokeServer();
			end;
			l__gui__3.WorldList.LoadingMessage.Visible = false;
			if not u6 or #u6 == 0 then
				l__gui__3.WorldList.EmptyMessage.Visible = true;
			end;
			for v14, v15 in pairs(u6) do
				u7(v15);
			end;
		end);
	end;
	p1.views.WorldInvites.onShown:connect(function()
		u8(true);
	end);
	l__gui__3.IgnoreInvite.Activated:Connect(function()
		if not u6 then
			return;
		end;
		if not u4 then
			return;
		end;
		local v16 = u6[u4];
		if not p1.YesNoGui:show(("Are you sure you want to ignore your invite to '%s'?\n\nThis will remove the world from your invites list.\nTo rejoin, you'll need to get a new invite from the world owner."):format(v16.name)) then
			return;
		end;
		p1:navigateTo("Null");
		local v17, v18 = l__ReplicatedStorage__2.Remote.UserWorlds.IgnoreInvite:InvokeServer(v16.id);
		p1:navigateBack();
		if not v17 then
			p1.GenericMessageGui:show("Error while ignoring world invite;\n" .. v18, "Back");
		end;
	end);
	l__gui__3.PlayWorld.Activated:Connect(function()
		if not u6 then
			return;
		end;
		if not u4 then
			return;
		end;
		p1:navigateTo("Null");
		local v19, v20 = l__ReplicatedStorage__2.Remote.UserWorlds.JoinWorld:InvokeServer(u4);
		if not v19 then
			p1:navigateBack();
			if v20 ~= "You're already in this world" then
				p1.GenericMessageGui:show("Error while joining world;\n" .. v20, "Back");
				return;
			end;
		else
			return;
		end;
		p1:navigateTo("InGame");
	end);
	l__gui__3.AddToWorldList.Activated:Connect(function()
		if not u6 then
			return;
		end;
		if not u4 then
			return;
		end;
		local v21, v22 = l__ReplicatedStorage__2.Remote.UserWorlds.AddInviteToWorldList:InvokeServer(u6[u4].id);
		if not v21 then
			p1.GenericMessageGui:show("Error while adding world invite to list;\n" .. v22, "Back");
		end;
		u8(true);
	end);
	l__gui__3.Back.Activated:Connect(function()
		p1:navigateBack();
	end);
	return {};
end;
