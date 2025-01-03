local l__ReplicatedStorage__1 = game:GetService("ReplicatedStorage");
local l__UserInputService__2 = game:GetService("UserInputService");
local l__RunService__3 = game:GetService("RunService");
local l__Players__4 = game:GetService("Players");
local l__LocalPlayer__5 = l__Players__4.LocalPlayer;
local l__PlayerGui__6 = l__LocalPlayer__5.PlayerGui;
local l__PlayerScripts__7 = l__LocalPlayer__5.PlayerScripts;
local v8 = require(l__PlayerScripts__7.FontRenderer);
local v9 = require(l__ReplicatedStorage__1.Block);
local v10 = require(l__ReplicatedStorage__1.Libs.MapLen);
local v11 = require(l__PlayerScripts__7.WorldRenderer.ItemRenderer);
local v12 = require(l__PlayerScripts__7.WorldLoader);
local v13 = require(l__PlayerScripts__7.Flags);
local v04 = require(l__ReplicatedStorage__1.Assets).other
local u1 = nil;
spawn(function()
	u1 = require(l__PlayerScripts__7.Camera);
end);
return function(p1)
	local v14 = {};
	p1:registerView("InGame", {
		showMouse = false
	});
	v14.hotbar = {};
	v14.selectedHotbarSlot = 1;
	local l__gui__2 = p1.views.InGame.gui;
	local u3 = { 1, 4, 45, 3, 5, 17, 18, 20, 44, 48, 6, 37, 38, 39, 40, 12, 13, 19, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 16, 15, 14, 42, 41, 47, 46, 49, 95, 56, 57 };
	local u4 = {};
	function v14.initHotbar(p2)
		local l__Hotbar__15 = l__gui__2.Hotbar;
		l__Hotbar__15.SelectBlock.Activated:Connect(function()
			p2:showSelectBlock();
		end);
		local l__Blocks__16 = l__Hotbar__15.Blocks;
		local l__Icon__17 = l__Blocks__16.Icon;
		l__Icon__17.Parent = nil;
		for v18 = 1,9,1 do
			local v19 = u3[v18];
			v14.hotbar[v18] = v19;
			local v20 = l__Icon__17:Clone();
			v20.LayoutOrder = v18;
			local v21 = v11:renderItem(v19);
			if v21 then
				v21.Parent = v20;
			end;
			local u5 = v18;
			v20.Activated:Connect(function()
				p2:setSelectedHotbarSlot(u5);
			end);
			u4[u5] = v20;
			v20.Parent = l__Blocks__16;
		end;
	end;
	function v14.setHotbarBlockID(p3, p4, p5)
		v14.hotbar[p4] = p5;
		v12.currentWorld.localPlayerEntity.currentEquippedBlock = v14.hotbar[v14.selectedHotbarSlot];
		u1:switchFirstPersonItem(v12.currentWorld.localPlayerEntity.currentEquippedBlock);
		local v22 = u4[p4];
		v22:ClearAllChildren();
		local v23 = v11:renderItem(p5);
		if v23 then
			v23.Parent = v22;
		end;
	end;
	function v14.setSelectedHotbarSlot(p6, p7)
		v14.selectedHotbarSlot = p7;
		v12.currentWorld.localPlayerEntity.currentEquippedBlock = v14.hotbar[v14.selectedHotbarSlot];
		u1:switchFirstPersonItem(v12.currentWorld.localPlayerEntity.currentEquippedBlock);
		l__gui__2.Hotbar.SelectedSlot.Position = UDim2.new(0, -2 + (p7 - 1) * 40, 0, -2);
	end;
	local u6 = {};
	function v14.selectLookingAtBlock(p8)
		local v24 = nil;
		local v25 = nil;
		local v26 = nil;
		local v27 = nil;
		local v28 = nil;
		local v29 = nil;
		local v30 = nil;
		local v31 = nil;
		local v32 = nil;
		local v33 = nil;
		local v34 = nil;
		local v35 = nil;
		local v36, v37 = u1:getLookingAtInfo();
		if v37 then
			local v38 = v9.blocks[v37]:getPickBlockID();
			if not u6[v38] then
				p8:sendMessage("\194\167cYou can't pick that block, you haven't unlocked it yet.");
				return;
			end;
			for v24, v42 in pairs(p8.hotbar) do
				if v42 == v38 then
					v25 = v24;
					v32 = v25;
					v27 = "setSelectedHotbarSlot";
					v26 = p8;
					v31 = v26;
					v28 = p8;
					v29 = v27;
					v30 = v28[v29];
					v33 = v30;
					v34 = v31;
					v35 = v32;
					v33(v34, v35);
					return;
				end;			
			end;
			p8:setHotbarBlockID(p8.selectedHotbarSlot, v38);
			return;
		else
			v25 = v24;
			v32 = v25;
			v27 = "setSelectedHotbarSlot";
			v26 = p8;
			v31 = v26;
			v28 = p8;
			v29 = v27;
			v30 = v28[v29];
			v33 = v30;
			v34 = v31;
			v35 = v32;
			v33(v34, v35);
			return;
		end;
	end;
	v14.selectBlockShown = false;
	local l__DonateGui__7 = p1.DonateGui;
	function v14.initSelectBlock(p9)
		local l__SelectBlock__43 = l__gui__2.SelectBlock;
		local l__Blocks__44 = l__SelectBlock__43.Blocks;
		local l__Block__45 = l__Blocks__44.Block;
		l__Block__45.Parent = nil;
		l__SelectBlock__43.DonateOverlay.Donate.Activated:Connect(function()
			v14:hideSelectBlock();
			p1:navigateTo("Donate");
		end);
		for v49, v50 in ipairs(u3) do
			local v51 = nil;
			for v55, v56 in pairs(l__DonateGui__7.rewardTiers) do
				for v57, v58 in pairs(v56.rewards) do
					if v58 == v50 then
						v51 = v56;
						break;
					end;
				end;
				if v51 then
					break;
				end;			
			end;
			local v59 = l__Block__45:Clone();
			v59.Name = "Slot" .. v49;
			v59.LayoutOrder = v49;
			local v60 = v11:renderItem(v50);
			if v60 then
				v60.Parent = v59.Icon;
			end;
			local u8 = 0;
			v59.MouseEnter:Connect(function()
				local v61 = true;
				if v51 ~= nil then
					v61 = v51.points <= u8;
				end;
				if not v61 then
					return;
				end;
				v59.UIScale.Scale = 1.625;
				v59.BackgroundTransparency = 0.25;
			end);
			v59.MouseLeave:Connect(function()
				local v62 = true;
				if v51 ~= nil then
					v62 = v51.points <= u8;
				end;
				if not v62 then
					return;
				end;
				v59.UIScale.Scale = 1;
				v59.BackgroundTransparency = 1;
			end);
			v59.Activated:Connect(function()
				local v63 = true;
				if v51 ~= nil then
					v63 = v51.points <= u8;
				end;
				if not v63 then
					return;
				end;
				v59.UIScale.Scale = 1;
				v59.BackgroundTransparency = 1;
				p9:setHotbarBlockID(v14.selectedHotbarSlot, v50);
				p9:hideSelectBlock();
			end);
			v59.Parent = l__Blocks__44;		
		end;
		local u9 = 0;
		local function v64()
			spawn(function()
				u9 = l__ReplicatedStorage__1.Remote.Shop.GetDonationAmount:InvokeServer();
				local v65 = true;
				for v70, v71 in ipairs(u3) do
					local v69 = nil;
					local v72 = nil;
					for v76, v77 in pairs(l__DonateGui__7.rewardTiers) do
						for v78, v79 in pairs(v77.rewards) do
							if v79 == v71 then
								v72 = v77;
								break;
							end;
						end;
						if v72 then
							break;
						end;					
					end;
					local v80 = true;
					if v72 ~= nil then
						v80 = v72.points <= u9;
					end;
					v69 = l__Blocks__44["Slot" .. v70];
					u6[v71] = v80;
					if v80 then
						local v81 = v69.Icon:GetChildren()[1];
						v81.ImageTransparency = 0;
						v81.ImageColor3 = Color3.new(1, 1, 1);
					else
						v65 = false;
						local v82 = v69.Icon:GetChildren()[1];
						v82.ImageTransparency = 0.75;
						v82.ImageColor3 = Color3.new(0.5, 0.5, 0.5);
					end;				
				end;
				l__SelectBlock__43.DonateOverlay.Visible = not v65;
				local v83 = nil
				if v65 then
					v83 = 0;
				else
					v83 = 36;
				end;
				l__SelectBlock__43.Size = UDim2.new(0, 480, 0, 300 + v83);
			end);
		end;
		v64();
		l__ReplicatedStorage__1.Remote.Shop.OnPointsUpdated.OnClientEvent:Connect(v64);
	end;
	function v14.showSelectBlock(p10)
		p10.selectBlockShown = true;
		l__gui__2.SelectBlock.Visible = true;
		l__UserInputService__2.MouseIconEnabled = true;
	end;
	function v14.hideSelectBlock(p11)
		p11.selectBlockShown = false;
		l__gui__2.SelectBlock.Visible = false;
		l__UserInputService__2.MouseIconEnabled = false;
	end;
	v14:initHotbar();
	v14:initSelectBlock();
	function v14.initPlayerList(p12)
		local l__PlayerList__84 = l__gui__2.PlayerList;
		local l__Entry__85 = l__PlayerList__84.Entry;
		l__Entry__85.Parent = script;
		local u10 = {};
		local function v86(p13)
			local v87 = l__Entry__85:Clone();
			v87.Name = p13.Name;
			v87.TextLabel.Text = p13.Name;
			v87.Parent = l__PlayerList__84;
			u10[p13] = v87;
		end;
		local function v88()
			local v89 = 0;
			for v90, v91 in pairs(u10) do
				v89 = math.max(v89, (v8:measureText(v91.TextLabel.Text) * v91.TextLabel.TextSize / 8).x);
			end;
			l__PlayerList__84.Size = UDim2.new(0, v89 + 32, 1, -8);
		end;
		for v92, v93 in pairs(l__Players__4:GetPlayers()) do
			v86(v93);
		end;
		v88();
		l__Players__4.PlayerAdded:Connect(function(p14)
			v86(p14);
			v88();
		end);
		l__Players__4.PlayerRemoving:Connect(function(p15)
			u10[p15]:Destroy();
			u10[p15] = nil;
			v88();
		end);
	end;
	v14:initPlayerList();
	function v14.initChat(p16)
		local l__Chat__94 = l__gui__2.Chat;
		local l__ChatText__95 = l__Chat__94.ChatLog.ChatText;
		l__ChatText__95.Parent = script;
		local function u11()
			return l__Chat__94.AbsoluteSize.X - 8;
		end;
		function v14.sendMessage(p17, p18)
			local v96 = l__ChatText__95:Clone();
			v96.Size = UDim2.new(1, 0, 0, (v8:measureText(p18, Vector2.new(u11(), math.huge) / (v96.Message.TextSize / 8)) * v96.Message.TextSize / 8).y + 6);
			v96.Message.Text = p18;
			v96.Parent = l__Chat__94.ChatLog;
			local l__Y__97 = l__Chat__94.ChatLog.UIListLayout.AbsoluteContentSize.Y;
			l__Chat__94.ChatLog.CanvasSize = UDim2.new(0, 0, 0, l__Y__97);
			if l__Chat__94.ChatLog.CanvasSize.Y.Offset - 10 <= l__Chat__94.ChatLog.CanvasPosition.Y + l__Chat__94.ChatLog.AbsoluteWindowSize.Y then
				l__Chat__94.ChatLog.CanvasPosition = l__Chat__94.ChatLog.CanvasPosition + Vector2.new(0, l__Y__97 - l__Chat__94.ChatLog.CanvasSize.Y.Offset);
			end;
			delay(15, function()
				local v98 = tick();
				while tick() - v98 < 1 do
					local v99 = tick() - v98;
					v96.Message.FontOptions.TextTransparency.Value = v99;
					v96.BackgroundTransparency = v99 / 2 + 0.5;
					wait();				
				end;
				v96:Destroy();
				local l__Y__100 = l__Chat__94.ChatLog.UIListLayout.AbsoluteContentSize.Y;
				l__Chat__94.ChatLog.CanvasSize = UDim2.new(0, 0, 0, l__Y__100);
				l__Chat__94.ChatLog.CanvasPosition = l__Chat__94.ChatLog.CanvasPosition + Vector2.new(0, l__Y__100 - l__Chat__94.ChatLog.CanvasSize.Y.Offset);
			end);
		end;
		function v14.focusChatBox(p19)
			l__Chat__94.InputBox.Visible = true;
			l__Chat__94.InputBox.TextBox:CaptureFocus();
		end;
		l__Chat__94.InputBox.TextBox:GetPropertyChangedSignal("Text"):Connect(function()
			if v13.maxChatMessageLength < #l__Chat__94.InputBox.TextBox.Text then
				l__Chat__94.InputBox.TextBox.Text = l__Chat__94.InputBox.TextBox.Text:sub(1, v13.maxChatMessageLength);
			end;
			l__Chat__94.InputBox.Size = UDim2.new(1, 0, 0, (v8:measureText(l__Chat__94.InputBox.TextBox.Text, Vector2.new(u11(), 99999) / l__Chat__94.InputBox.TextBox.TextSize * 8) * l__Chat__94.InputBox.TextBox.TextSize / 8).y + 6);
		end);
		l__Chat__94.InputBox.TextBox.FocusLost:Connect(function(p20)
			if v14.currentlyOptimisedInput == Enum.UserInputType.Touch then
				l__Chat__94.InputBox.Visible = false;
			end;
			if p20 then
				l__ReplicatedStorage__1.Remote.Chat.SendMessage:FireServer(l__Chat__94.InputBox.TextBox.Text);
				l__Chat__94.InputBox.TextBox.Text = "";
			end;
		end);
		l__ReplicatedStorage__1.Remote.Chat.OnChatMessage.OnClientEvent:Connect(function(p21)
			v14:sendMessage(p21);
		end);
	end;
	v14:initChat();
	l__gui__2.OpenMenu.Activated:Connect(function()
		p1:navigateTo("PauseMenu");
	end);
	l__gui__2.OpenChat.Activated:Connect(function()
		spawn(function()
			v14:focusChatBox();
		end);
	end);
	v14.currentlyOptimisedInput = nil;
	function v14.optimiseForInput(p22, p23)
		if p23 == p22.currentlyOptimisedInput then
			return;
		end;
		p22.currentlyOptimisedInput = p23;
		l__gui__2.Hotbar.SelectBlock.Visible = p23 == Enum.UserInputType.Touch;
		local v101 = nil
		if l__gui__2.Hotbar.SelectBlock.Visible then
			v101 = -21;
		else
			v101 = 0;
		end;
		l__gui__2.Hotbar.Position = UDim2.new(0.5, v101, 1, 0);
		l__gui__2.OpenMenu.Visible = p23 == Enum.UserInputType.Touch;
		l__gui__2.OpenChat.Visible = p23 == Enum.UserInputType.Touch;
		l__gui__2.Chat.InputBox.Visible = p23 ~= Enum.UserInputType.Touch;
	end;
	v14:optimiseForInput(l__UserInputService__2:GetLastInputType());
	local function u12()
		l__gui__2.Version.Text = v13.versionString;
		if v14.currentlyOptimisedInput ~= Enum.UserInputType.Touch then
			l__gui__2.Version.Text = l__gui__2.Version.Text .. "\nPress Enter to open menu";
		end;
	end;
	local u13 = {
		[Enum.KeyCode.One] = 1, 
		[Enum.KeyCode.Two] = 2, 
		[Enum.KeyCode.Three] = 3, 
		[Enum.KeyCode.Four] = 4, 
		[Enum.KeyCode.Five] = 5, 
		[Enum.KeyCode.Six] = 6, 
		[Enum.KeyCode.Seven] = 7, 
		[Enum.KeyCode.Eight] = 8, 
		[Enum.KeyCode.Nine] = 9
	};
	l__UserInputService__2.InputBegan:Connect(function(p24, p25)
		if p25 or p1.currentView ~= "InGame" then
			return;
		end;
		v14:optimiseForInput(l__UserInputService__2:GetLastInputType());
		u12();
		if p24.UserInputType == Enum.UserInputType.Keyboard then
			if p24.KeyCode ~= Enum.KeyCode.E then
				if p24.KeyCode == Enum.KeyCode.T or p24.KeyCode == Enum.KeyCode.Slash then
					spawn(function()
						v14:focusChatBox();
					end);
					return;
				elseif p24.KeyCode == Enum.KeyCode.Return then
					p1:navigateTo("PauseMenu");
					return;
				elseif u13[p24.KeyCode] ~= nil then
					v14:setSelectedHotbarSlot(u13[p24.KeyCode]);
					return;
				else
					return;
				end;
			end;
		else
			if p24.UserInputType == Enum.UserInputType.MouseButton3 then
				v14:selectLookingAtBlock();
			end;
			return;
		end;
		if v14.selectBlockShown then
			v14:hideSelectBlock();
			return;
		end;
		v14:showSelectBlock();
	end);
	l__UserInputService__2.InputChanged:Connect(function(p26, p27)
		if p27 or p1.currentView ~= "InGame" then
			return;
		end;
		if p26.UserInputType == Enum.UserInputType.MouseWheel then
			v14:setSelectedHotbarSlot((v14.selectedHotbarSlot - p26.Position.Z - 1) % 9 + 1);
		end;
	end);
	u12();
	l__gui__2.Autosave.Visible = l__ReplicatedStorage__1.Remote.UserWorlds.IsSaving.Value or not l__ReplicatedStorage__1.Remote.UserWorlds.SavedSuccessfully.Value;
	local v102 = nil
	if l__ReplicatedStorage__1.Remote.UserWorlds.IsSaving.Value then
		local v102 = "rbxassetid://" .. v04.autosave
	else
		v102 = "rbxassetid://" .. v04["autosave-fail"];
	end;
	l__gui__2.Autosave.Image = v102;
	l__ReplicatedStorage__1.Remote.UserWorlds.IsSaving.Changed:Connect(function()
		l__gui__2.Autosave.Visible = l__ReplicatedStorage__1.Remote.UserWorlds.IsSaving.Value or not l__ReplicatedStorage__1.Remote.UserWorlds.SavedSuccessfully.Value;
		local v103 = nil
		if l__ReplicatedStorage__1.Remote.UserWorlds.IsSaving.Value then
			v103 = "rbxassetid://" .. v04.autosave;
		else
			v103 = "rbxassetid://" .. v04["autosave-fail"];
		end;
		l__gui__2.Autosave.Image = v103;
	end);
	l__ReplicatedStorage__1.Remote.UserWorlds.SavedSuccessfully.Changed:Connect(function()
		l__gui__2.Autosave.Visible = l__ReplicatedStorage__1.Remote.UserWorlds.IsSaving.Value or not l__ReplicatedStorage__1.Remote.UserWorlds.SavedSuccessfully.Value;
	end);
	p1.views.InGame.onShown:connect(function()
		v12.inGame = true;
	end);
	return v14;
end;
