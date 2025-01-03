--[[Parent of this script is Gui]]
local l__LocalPlayer__1 = game:GetService("Players").LocalPlayer;
local l__PlayerGui__2 = l__LocalPlayer__1.PlayerGui;
local l__PlayerScripts__3 = l__LocalPlayer__1.PlayerScripts;
local l__ReplicatedStorage__1 = game:GetService("ReplicatedStorage");
local u2 = require(l__PlayerScripts__3.WorldRenderer.ItemRenderer);
local u3 = require(l__PlayerScripts__3.WorldLoader);
local l__RunService__4 = game:GetService("RunService");
local u5 = require(l__PlayerScripts__3.Flags);
return function(p1)
	local v4 = {
		rewardTiers = l__ReplicatedStorage__1.Remote.Shop.GetDonationRewardTiers:InvokeServer()
	};
	p1:registerView("Donate", {
		showMouse = true
	});
	p1:registerView("DonatorShop", {
		showMouse = true
	});
	local l__gui__5 = p1.views.DonatorShop.gui;
	local l__gui__6 = p1.views.Donate.gui;
	function v4:initTiers(p2)
		for v6, v7 in pairs(v4.rewardTiers) do
			local v8 = 1 - (v6 - 1) / (#v4.rewardTiers - 1);
			local v9 = script.RewardTier:Clone();
			v9.Title.Text = v7.title;
			v9.Message.Text = v7.desc;
			v9.Position = UDim2.new(0, 0, v8, -100 * v8);
			local l__Icon__10 = v9.Rewards.Icon;
			l__Icon__10.Parent = nil;
			for v11, v12 in pairs(v7.rewards) do
				local v13 = l__Icon__10:Clone();
				v13.LayoutOrder = v11;
				v13.ZIndex = -v11;
				local v14 = u2:renderItem(v12);
				if v14 then
					v14.Parent = v13;
				end;
				v7.gui = v9;
				v13.Parent = v9.Rewards;
			end;
			l__Icon__10:Destroy();
			v9.Parent = l__gui__6.RewardTiers.Content.Tiers;
		end;
	end;
	v4:initTiers();
	function v4:updateTiers(p3)
		local v15 = l__ReplicatedStorage__1.Remote.Shop.GetDonationAmount:InvokeServer();
		l__gui__6.RewardTiers.Content.Meter.Bar.Size = UDim2.new(1, 0, 1, 0);
		for v16, v17 in pairs(v4.rewardTiers) do
			if v17.points <= v15 then
				v17.gui.Points.TextColor3 = Color3.new(1, 1, 1);
				v17.gui.Points.Text = "Unlocked!";
			elseif v16 == 1 or v4.rewardTiers[v16 - 1].points <= v15 then
				local v18 = nil;
				v17.gui.Points.TextColor3 = Color3.new(0.5, 1, 0.25);
				v17.gui.Points.Text = ("Need %d more Points to unlock!"):format(v17.points - v15);
				local v19 = v16 ~= 1 and v4.rewardTiers[v16 - 1].points or 0;
				v18 = (v15 - v19) / (v17.points - v19);
				if v16 == 1 then
					l__gui__6.RewardTiers.Content.Meter.Bar.Size = UDim2.new(1, 0, 0, math.clamp(84 * v18, 0, 84));
				else
					local v20 = math.clamp((v16 - 2 + v18) / (#v4.rewardTiers - 1), 0, 1);
					l__gui__6.RewardTiers.Content.Meter.Bar.Size = UDim2.new(1, 0, v20, 84 * (1 - v20));
				end;
			else
				v17.gui.Points.TextColor3 = Color3.new(0.5, 0.5, 0.5);
				v17.gui.Points.Text = "Locked...";
			end;
		end;
		local v21 = l__gui__6.RewardTiers.Content.Meter.Bar.Position.Y - l__gui__6.RewardTiers.Content.Meter.Bar.Size.Y;
		l__gui__6.RewardTiers.Content.CanvasPosition = Vector2.new(0, v21.Offset + v21.Scale * l__gui__6.RewardTiers.Content.Meter.AbsoluteSize.Y + l__gui__6.RewardTiers.Content.Meter.Position.Y.Offset - l__gui__6.RewardTiers.Content.AbsoluteSize.Y / 2);
	end;
	v4:updateTiers();
	l__ReplicatedStorage__1.Remote.Shop.OnPointsUpdated.OnClientEvent:Connect(function()
		v4:updateTiers();
	end);
	p1.views.Donate.onShown:connect(function()
		local v22 = nil
		if u3:isInGame() then
			v22 = 1;
		else
			v22 = 0;
		end;
		l__gui__6.RewardTiers.Content.Back.ImageTransparency = v22;
	end);
	l__gui__6.Back.Activated:Connect(function()
		p1:navigateBack();
	end);
	l__gui__6.DonatorShop.Activated:Connect(function()
		p1:navigateTo("DonatorShop");
	end);
	local v23 = Instance.new("Camera");
	v23.FieldOfView = 1;
	v23.Focus = CFrame.new();
	v23.CFrame = CFrame.new(Vector3.new(1, 0.8165, 1) * 220, v23.Focus.p);
	v23.Parent = script;
	for v24, v25 in pairs({ l__gui__5.Minimum, l__gui__5.Medium, l__gui__5.Maximum }) do
		v25.Icon.CurrentCamera = v23;
		local u7 = 0;
		l__RunService__4.RenderStepped:Connect(function(p4)
			v25.Icon.Block.CFrame = CFrame.Angles(0, u7, 0);
			u7 = u7 + p4;
		end);
	end;
	l__gui__5.Back.Activated:Connect(function()
		p1:navigateBack();
	end);
	l__gui__5.Minimum.Buy.Activated:Connect(function()
		if u5.passThroughPurchases then
			p1.GenericMessageGui:show("Donations are disabled - passthrough purchases have been enabled on this server.\nThis is usually enabled on development versions for testing.", "Okay");
			return;
		end;
		l__ReplicatedStorage__1.Remote.Shop.PromptBuy:FireServer("donateMinimum");
	end);
	l__gui__5.Medium.Buy.Activated:Connect(function()
		if u5.passThroughPurchases then
			p1.GenericMessageGui:show("Donations are disabled - passthrough purchases have been enabled on this server.\nThis is usually enabled on development versions for testing.", "Okay");
			return;
		end;
		l__ReplicatedStorage__1.Remote.Shop.PromptBuy:FireServer("donateMedium");
	end);
	l__gui__5.Maximum.Buy.Activated:Connect(function()
		if u5.passThroughPurchases then
			p1.GenericMessageGui:show("Donations are disabled - passthrough purchases have been enabled on this server.\nThis is usually enabled on development versions for testing.", "Okay");
			return;
		end;
		l__ReplicatedStorage__1.Remote.Shop.PromptBuy:FireServer("donateMaximum");
	end);
	return v4;
end;
