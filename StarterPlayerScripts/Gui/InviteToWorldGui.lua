local l__ReplicatedStorage__1 = game:GetService("ReplicatedStorage");
local l__LocalPlayer__2 = game:GetService("Players").LocalPlayer;
local l__PlayerGui__3 = l__LocalPlayer__2.PlayerGui;
local v4 = require(l__LocalPlayer__2.PlayerScripts.Flags);
local u1 = require(l__ReplicatedStorage__1.Libs.Trim);
return function(p1)
	p1:registerView("InviteToWorld", {
		showMouse = true
	});
	local l__gui__2 = p1.views.InviteToWorld.gui;
	p1.views.InviteToWorld.onShown:connect(function()
		l__gui__2.Message.Text = "";
		l__gui__2.Username.Input.TextBox.Text = "";
	end);
	l__gui__2.Done.Activated:Connect(function()
		p1:navigateBack();
	end);
	l__gui__2.Invite.Activated:Connect(function()
		l__gui__2.Message.Text = "\194\1677Sending invite...";
		local v5 = u1(l__gui__2.Username.Input.TextBox.Text);
		if #v5 == 0 then
			l__gui__2.Message.Text = "\194\167cYou must provide a username.";
			return;
		end;
		local v6, v7 = l__ReplicatedStorage__1.Remote.UserWorlds.SendInviteToPlayer:InvokeServer(v5);
		if v6 then
			l__gui__2.Message.Text = ("\194\167aSent an invite to %s!"):format(v5);
			return;
		end;
		l__gui__2.Message.Text = ("\194\167c%s"):format(v7);
	end);
	l__gui__2.Revoke.Activated:Connect(function()
		l__gui__2.Message.Text = "\194\1677Revoking invite...";
		local v8 = u1(l__gui__2.Username.Input.TextBox.Text);
		if #v8 == 0 then
			l__gui__2.Message.Text = "\194\167cYou must provide a username.";
			return;
		end;
		local v9, v10 = l__ReplicatedStorage__1.Remote.UserWorlds.RevokeInviteFromPlayer:InvokeServer(v8);
		if v9 then
			l__gui__2.Message.Text = ("\194\167a%s is no longer invited."):format(v8);
			return;
		end;
		l__gui__2.Message.Text = ("\194\167c%s"):format(v10);
	end);
	return {};
end;
